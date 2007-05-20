Return-Path: <linux-kernel-owner+w=401wt.eu-S1760274AbXETVZ0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760274AbXETVZ0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 May 2007 17:25:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756831AbXETVZR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 May 2007 17:25:17 -0400
Received: from cacti.profiwh.com ([85.93.165.66]:43450 "EHLO smtp.wsc.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756812AbXETVZQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 May 2007 17:25:16 -0400
Message-id: <20461285551864014911@wsc.cz>
Subject: [PATCH 1/3] Char: isicom, cleanup locking
From: Jiri Slaby <jirislaby@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: <linux-kernel@vger.kernel.org>
Date: Sun, 20 May 2007 23:25:11 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

isicom, cleanup locking

don't spin processor when not needed (use sleep instead of delay). Don't
release the lock when needed in next iteration -- this actually fixes a
bug -- missing braces

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>

---
commit af05316f4ba7503ae531f3afdb5264c10e3b8e2c
tree 2fac39ab09e16f20329fc785beeb7607b6ed8bc9
parent a9dbc0b98956d548b1aee3f55b3799a12946ace4
author Jiri Slaby <jirislaby@gmail.com> Sun, 20 May 2007 21:32:42 +0200
committer Jiri Slaby <jirislaby@gmail.com> Sun, 20 May 2007 21:32:42 +0200

 drivers/char/isicom.c |   65 ++++++++++++++++++++-----------------------------
 1 files changed, 27 insertions(+), 38 deletions(-)

diff --git a/drivers/char/isicom.c b/drivers/char/isicom.c
index 761f777..b133b92 100644
--- a/drivers/char/isicom.c
+++ b/drivers/char/isicom.c
@@ -243,17 +243,18 @@ static inline int WaitTillCardIsFree(u16 base)
 
 static int lock_card(struct isi_board *card)
 {
-	char		retries;
 	unsigned long base = card->base;
+	unsigned int retries, a;
 
-	for (retries = 0; retries < 100; retries++) {
+	for (retries = 0; retries < 10; retries++) {
 		spin_lock_irqsave(&card->card_lock, card->flags);
-		if (inw(base + 0xe) & 0x1) {
-			return 1;
-		} else {
-			spin_unlock_irqrestore(&card->card_lock, card->flags);
-			udelay(1000);   /* 1ms */
+		for (a = 0; a < 10; a++) {
+			if (inw(base + 0xe) & 0x1)
+				return 1;
+			udelay(10);
 		}
+		spin_unlock_irqrestore(&card->card_lock, card->flags);
+		msleep(10);
 	}
 	printk(KERN_WARNING "ISICOM: Failed to lock Card (0x%lx)\n",
 		card->base);
@@ -261,23 +262,6 @@ static int lock_card(struct isi_board *card)
 	return 0;	/* Failed to acquire the card! */
 }
 
-static int lock_card_at_interrupt(struct isi_board *card)
-{
-	unsigned char		retries;
-	unsigned long base = card->base;
-
-	for (retries = 0; retries < 200; retries++) {
-		spin_lock_irqsave(&card->card_lock, card->flags);
-
-		if (inw(base + 0xe) & 0x1)
-			return 1;
-		else
-			spin_unlock_irqrestore(&card->card_lock, card->flags);
-	}
-	/* Failing in interrupt is an acceptable event */
-	return 0;	/* Failed to acquire the card! */
-}
-
 static void unlock_card(struct isi_board *card)
 {
 	spin_unlock_irqrestore(&card->card_lock, card->flags);
@@ -415,6 +399,8 @@ static inline int __isicom_paranoia_check(struct isi_port const *port,
 
 static void isicom_tx(unsigned long _data)
 {
+	unsigned long flags;
+	unsigned int retries;
 	short count = (BOARD_COUNT-1), card, base;
 	short txcount, wrd, residue, word_count, cnt;
 	struct isi_port *port;
@@ -435,32 +421,34 @@ static void isicom_tx(unsigned long _data)
 	count = isi_card[card].port_count;
 	port = isi_card[card].ports;
 	base = isi_card[card].base;
+
+	spin_lock_irqsave(&isi_card[card].card_lock, flags);
+	for (retries = 0; retries < 100; retries++) {
+		if (inw(base + 0xe) & 0x1)
+			break;
+		udelay(2);
+	}
+	if (retries >= 100)
+		goto unlock;
+
 	for (;count > 0;count--, port++) {
-		if (!lock_card_at_interrupt(&isi_card[card]))
-			continue;
 		/* port not active or tx disabled to force flow control */
 		if (!(port->flags & ASYNC_INITIALIZED) ||
 				!(port->status & ISI_TXOK))
-			unlock_card(&isi_card[card]);
 			continue;
 
 		tty = port->tty;
 
-
-		if (tty == NULL) {
-			unlock_card(&isi_card[card]);
+		if (tty == NULL)
 			continue;
-		}
 
 		txcount = min_t(short, TX_SIZE, port->xmit_cnt);
-		if (txcount <= 0 || tty->stopped || tty->hw_stopped) {
-			unlock_card(&isi_card[card]);
+		if (txcount <= 0 || tty->stopped || tty->hw_stopped)
 			continue;
-		}
-		if (!(inw(base + 0x02) & (1 << port->channel))) {
-			unlock_card(&isi_card[card]);
+
+		if (!(inw(base + 0x02) & (1 << port->channel)))
 			continue;
-		}
+
 		pr_dbg("txing %d bytes, port%d.\n", txcount,
 			port->channel + 1);
 		outw((port->channel << isi_card[card].shift_count) | txcount,
@@ -508,9 +496,10 @@ static void isicom_tx(unsigned long _data)
 			port->status &= ~ISI_TXOK;
 		if (port->xmit_cnt <= WAKEUP_CHARS)
 			tty_wakeup(tty);
-		unlock_card(&isi_card[card]);
 	}
 
+unlock:
+	spin_unlock_irqrestore(&isi_card[card].card_lock, flags);
 	/*	schedule another tx for hopefully in about 10ms	*/
 sched_again:
 	if (!re_schedule) {
