//
// 手の画像素材：http://www.irasutoya.com/2013/07/blog-post_5608.html
//

// 画面のレンダリングライブラリ
import processing.opengl.*;

// ゲームの状態を示す番号と状態名のdefine
public static final int TITLE = -1; //タイトル画面の状態
public static final int MATCH = 0;  // 手を決める状態
public static final int TIE   = 1;  // あいこの状態
public static final int LOSE  = 2;  // 敗北の状態
public static final int WIN   = 3;  // 勝利の状態
public static final int JOUGH = 4;  // ジャッジ状態
 
// 大域変数の宣言
int status = TITLE;
int player   = 0;
int computer = 0;
PImage[] hand;
PImage title;
PFont font;
int flag = 0;

int win_score = 0;
int lose_score = 0;
int tie_score = 0;

//--------------------------------------
// 初期設定(実行時に1回実行される)
//
void setup() {
  // 画面の設定
  size(700, 700);
  strokeWeight(10);
  smooth();

  // 画像ファイルの設定
  title = loadImage("image/title.png");
  hand = new PImage[3];
  hand[0] = loadImage("image/gu.png");
  hand[1] = loadImage("image/choki.png");
  hand[2] = loadImage("image/pa.png");

  // フォントの設定
  // println(PFont.list());
  font = createFont("メイリオ", 32);   // フォントを設定する
  textAlign(CENTER, CENTER);
}

//--------------------------------------
// 実行停止するまで何度も繰り返し実行される
//
void draw() {
  background(255, 255, 200);
  switch (status) {
  case TITLE:
    image(title,0,0);
    title();
    break;
  case MATCH: 
    match();
    showHand();
    break;
  case JOUGH:
    status = judge();
    break;
  case TIE:   
    tie();
    break;
  case LOSE:
    lose();
    break;
  case WIN:
    win();
    break;
  }
  
  if(status != -1){
    noFill();
    rect(75,520,550,80);
    textSize(72);
    text(+win_score+ "勝"+lose_score+"負"+tie_score+"分" , width/2, 550);
  }

}

//--------------------------------------
// 画面に両者の手を表示する
//
void showHand() {
  scale(1,-1);
  image(hand[computer-1], 350-75, -50-150);
  scale(1, -1);
  
  if(mouseX>100 && mouseX<250 && mouseY>300 && mouseY<450){
    fill(255,255,0); rect(100,300,150,150);
  } 
  image(hand[0] , 100,300);
  
  if(mouseX>275 && mouseX<425 && mouseY>300 && mouseY<450){
    fill(255,255,0); rect(275,300,150,150);
  }
  image(hand[1] , 275,300);
  
  if(mouseX>450 && mouseX<600 && mouseY>300 && mouseY<450){
    fill(255,255,0); rect(450,300,150,150);
  }
  image(hand[2] , 450,300);
  
  textFont(font);
  font = createFont("メイリオ", 32); 
  fill(0);
  text("computer", width/2, 15);
  text("player",width/2,475);
  textSize(72);
  text("じゃんけん...",width/2,250);
  textSize(32);
  text("マウスで手を選択してください",width/2 ,650);
}

//--------------------------------------
// 両者の手を決める状態
//
void match() {
  //computer
  computer = (int)random(1,4);
  
  //player
  if(mousePressed){
      if(mouseX>100 && mouseX<250 && mouseY>300 && mouseY<450){
        player = 1; status = JOUGH;
      }
      if(mouseX>275 && mouseX<425 && mouseY>300 && mouseY<450){
        player = 2; status = JOUGH;
      }
      if(mouseX>450 && mouseX<600 && mouseY>300 && mouseY<450){
        player = 3; status = JOUGH;
      }
  } 
}

//--------------------------------------
// 勝敗判定しstatusの値を変更する
//
int judge() {
  if(player == computer){
      tie_score += 1;
      return TIE; 
  }
  else if(player == 3 && computer == 1){
      win_score += 1;
      return WIN; 
  }
  else if(player == 1 && computer == 3){
      lose_score += 1;
      return LOSE;
  }
  else if(player < computer){
      win_score += 1;
      return WIN; 
  }
  else if(computer < player){
      lose_score += 1;
      return LOSE; 
  }
  return 0;
}

//--------------------------------------
// あいこの結果表示
//
void tie() {
  background(255,255,200);
  image(hand[player-1] , 350-75,300);
  scale(1,-1);
  image(hand[computer-1], 350-75, -50-150);
  scale(1, -1);
  textFont(font);
  font = createFont("メイリオ", 72); 
  fill(0);
  text("あいこだよ", width/2, 250);
  textSize(32);
  text("スペースキーを押してリトライ", width/2, 650);
  text("computer", width/2, 15);
  text("player",width/2,475);
  if(keyPressed && key == ' '){
      status = 0;
  }
}

//--------------------------------------
// 敗北の結果表現
//
void lose() {
  background(0,0,255);
  strokeWeight(0);
  color c1 = color(3, 169, 250);
  color c2 = color(88, 3, 250);
  for(float w = 0; w < width; w += 5){
      color c = lerpColor(c1, c2, w / width);
      fill(c);
      rect(0, w, width, 5);
  }
  strokeWeight(10);
  image(hand[player-1] , 350-75,300);
  scale(1,-1);
  image(hand[computer-1], 350-75, -50-150);
  scale(1, -1);
  textFont(font);
  font = createFont("メイリオ", 72);
  fill(0);
  text("あなたの負け...", width/2, 250);
  textSize(32);
  text("スペースキーを押してリトライ", width/2, 650);
  text("computer", width/2, 15);
  text("player",width/2,475);
  if(keyPressed && key == ' '){
      status = 0;
  }
}

//--------------------------------------
// 勝利の結果表現
//
int backPosX = -200;
void win() {
  background(255,0,0);
  strokeWeight(0);
  for(int i = backPosX;i <= 700; i += 200){
     fill(255,0,0);
     rect(i,0,100,700);
     fill(255);
     rect(i+100,0,100,700);
  }
  backPosX += 10;
  if(backPosX >= 0) backPosX = -200;
  strokeWeight(10);
  
  image(hand[player-1] , 350-75,300);
  scale(1,-1);
  image(hand[computer-1], 350-75, -50-150);
  scale(1, -1);
  textFont(font);
  font = createFont("メイリオ", 72);
  fill(0);
  text("勝ちだよ やったー！", width/2, 250);
  textSize(32);
  text("スペースキーを押してリトライ", width/2, 650);
  text("computer", width/2, 15);
  text("player",width/2,475);
  if(keyPressed && key == ' '){
      status = 0;
  }
}


//---------------------------------------
//TITLEの実装
void title(){
  fill(255,255,200);
  rect(200,400,300,100);
  textFont(font);
  font = createFont("メイリオ", 32);
  fill(0);
  text("スタート",350,450);
  if(mouseX >= 200 && mouseX <= 500 && mouseY >= 400 && mouseY <= 500){
    fill(255,255,0);
    rect(200,400,300,100);
    fill(0);
    text("スタート",350,450);
    if(mousePressed) status = 0;
    delay(150);
  }
}