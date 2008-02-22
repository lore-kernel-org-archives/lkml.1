Return-Path: <linux-kernel-owner+w=401wt.eu-S1758805AbYBVOvd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758805AbYBVOvd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2008 09:51:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755260AbYBVOrl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Feb 2008 09:47:41 -0500
Received: from general-networks3.cust.sloane.cz ([88.146.176.14]:42305 "EHLO
	server.generalnetworks.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754975AbYBVOrf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2008 09:47:35 -0500
From: Jiri Slaby <jirislaby@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: <linux-kernel@vger.kernel.org>, <alan@lxorguk.ukuu.org.uk>,
       Oyvind Aabling <Oyvind.Aabling@uni-c.dk>,
       Jiri Slaby <jirislaby@gmail.com>
Subject: [PATCH 10/19] Char: moxa, timer cleanup
Date: Fri, 22 Feb 2008 15:46:37 +0100
Message-Id: <1203691606-9310-10-git-send-email-jirislaby@gmail.com>
X-Mailer: git-send-email 1.5.4.1
In-Reply-To: <1203691606-9310-1-git-send-email-jirislaby@gmail.com>
References: <1203691606-9310-1-git-send-email-jirislaby@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

- schedule timer even after some card is installed, not after insmod
- cleanup timer functions

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Tested-by: Oyvind Aabling <Oyvind.Aabling@uni-c.dk>
---
 drivers/char/moxa.c |   62 +++++++++++++++++---------------------------------
 1 files changed, 21 insertions(+), 41 deletions(-)

diff --git a/drivers/char/moxa.c b/drivers/char/moxa.c
index e2e8580..8c2b72e 100644
--- a/drivers/char/moxa.c
+++ b/drivers/char/moxa.c
@@ -215,7 +215,6 @@ static void moxa_receive_data(struct moxa_port *);
  */
 static int MoxaDriverIoctl(struct tty_struct *, unsigned int, unsigned long);
 static int MoxaDriverPoll(void);
-static int MoxaPortsOfCard(int);
 static void MoxaPortEnable(struct moxa_port *);
 static void MoxaPortDisable(struct moxa_port *);
 static int MoxaPortSetTermio(struct moxa_port *, struct ktermios *, speed_t);
@@ -715,6 +714,9 @@ static int moxa_init_board(struct moxa_board_conf *brd, struct device *dev)
 
 	brd->ready = 1;
 
+	if (!timer_pending(&moxaTimer))
+		mod_timer(&moxaTimer, jiffies + HZ / 50);
+
 	return 0;
 err_free:
 	kfree(brd->ports);
@@ -856,8 +858,6 @@ static int __init moxa_init(void)
 		return -1;
 	}
 
-	mod_timer(&moxaTimer, jiffies + HZ / 50);
-
 	/* Find the boards defined from module args. */
 #ifdef MODULE
 	{
@@ -1284,10 +1284,10 @@ static void moxa_hangup(struct tty_struct *tty)
 
 static void moxa_poll(unsigned long ignored)
 {
-	register int card;
 	struct moxa_port *ch;
-	struct tty_struct *tp;
-	int i, ports;
+	struct tty_struct *tty;
+	unsigned int card;
+	int i;
 
 	del_timer(&moxaTimer);
 
@@ -1295,36 +1295,38 @@ static void moxa_poll(unsigned long ignored)
 		mod_timer(&moxaTimer, jiffies + HZ / 50);
 		return;
 	}
+
 	for (card = 0; card < MAX_BOARDS; card++) {
-		if ((ports = MoxaPortsOfCard(card)) <= 0)
+		if (!moxa_boards[card].ready)
 			continue;
 		ch = moxa_boards[card].ports;
-		for (i = 0; i < ports; i++, ch++) {
+		for (i = 0; i < moxa_boards[card].numPorts; i++, ch++) {
 			if ((ch->asyncflags & ASYNC_INITIALIZED) == 0)
 				continue;
 			if (!(ch->statusflags & THROTTLE) &&
 			    (MoxaPortRxQueue(ch) > 0))
 				moxa_receive_data(ch);
-			if ((tp = ch->tty) == 0)
+			tty = ch->tty;
+			if (tty == NULL)
 				continue;
 			if (ch->statusflags & LOWWAIT) {
 				if (MoxaPortTxQueue(ch) <= WAKEUP_CHARS) {
-					if (!tp->stopped) {
+					if (!tty->stopped) {
 						ch->statusflags &= ~LOWWAIT;
-						tty_wakeup(tp);
+						tty_wakeup(tty);
 					}
 				}
 			}
-			if (!I_IGNBRK(tp) && (MoxaPortResetBrkCnt(ch) > 0)) {
-				tty_insert_flip_char(tp, 0, TTY_BREAK);
-				tty_schedule_flip(tp);
+			if (!I_IGNBRK(tty) && (MoxaPortResetBrkCnt(ch) > 0)) {
+				tty_insert_flip_char(tty, 0, TTY_BREAK);
+				tty_schedule_flip(tty);
 			}
 			if (MoxaPortDCDChange(ch)) {
 				if (ch->asyncflags & ASYNC_CHECK_CD) {
 					if (MoxaPortDCDON(ch))
 						wake_up_interruptible(&ch->open_wait);
 					else {
-						tty_hangup(tp);
+						tty_hangup(tty);
 						wake_up_interruptible(&ch->open_wait);
 						ch->asyncflags &= ~ASYNC_NORMAL_ACTIVE;
 					}
@@ -1670,15 +1672,14 @@ copy:
 	return -ENOIOCTLCMD;
 }
 
-int MoxaDriverPoll(void)
+static int MoxaDriverPoll(void)
 {
 	struct moxa_board_conf *brd;
 	struct moxa_port *p;
-	register ushort temp;
-	register int card;
 	void __iomem *ofsAddr;
 	void __iomem *ip;
-	int port, ports;
+	unsigned int port, ports, card;
+	ushort temp;
 
 	for (card = 0; card < MAX_BOARDS; card++) {
 		brd = &moxa_boards[card];
@@ -1728,19 +1729,8 @@ int MoxaDriverPoll(void)
 		}
 	}
 	moxaLowWaterChk = 0;
-	return (0);
-}
 
-/*****************************************************************************
- *	Card level function:						     *
- *	1. MoxaPortsOfCard(int cardno); 				     *
- *****************************************************************************/
-int MoxaPortsOfCard(int cardno)
-{
-
-	if (moxa_boards[cardno].boardType == 0)
-		return (0);
-	return (moxa_boards[cardno].numPorts);
+	return 0;
 }
 
 /*****************************************************************************
@@ -1811,16 +1801,6 @@ int MoxaPortsOfCard(int cardno)
  *                      -1      : no any Moxa card.             
  *
  *
- *      Function 4:     Get the ports of this card.
- *      Syntax:
- *      int  MoxaPortsOfCard(int cardno);
- *
- *           int cardno         : card number (0 - 3)
- *
- *           return:    0       : this card is invalid
- *                      8/16/24/32
- *
- *
  *      Function 6:     Enable this port to start Tx/Rx data.
  *      Syntax:
  *      void MoxaPortEnable(int port);
-- 
1.5.4.1

