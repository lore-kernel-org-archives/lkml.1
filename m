Return-Path: <linux-kernel-owner+w=401wt.eu-S1754384AbYBGTNK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754384AbYBGTNK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2008 14:13:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760669AbYBGTMu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Feb 2008 14:12:50 -0500
Received: from general-networks3.cust.sloane.cz ([88.146.176.14]:39205 "EHLO
	server.generalnetworks.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761632AbYBGTMs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2008 14:12:48 -0500
From: Jiri Slaby <jirislaby@gmail.com>
To: "Oyvind Aabling" <Oyvind.Aabling@uni-c.dk>
Cc: <linux-kernel@vger.kernel.org>, Jiri Slaby <jirislaby@gmail.com>
Subject: [RFT 3/9] Char: moxa, serialise timer
Date: Thu,  7 Feb 2008 20:11:19 +0100
Message-Id: <1202411485-16022-3-git-send-email-jirislaby@gmail.com>
X-Mailer: git-send-email 1.5.3.8
In-Reply-To: <1202411485-16022-1-git-send-email-jirislaby@gmail.com>
References: <1202411485-16022-1-git-send-email-jirislaby@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

- del timer after we are sure it won't be fired again
- make timer scheduling atomic
- don't reschedule timer when all cards have gone

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
---
 drivers/char/moxa.c |   26 +++++++++++++++-----------
 1 files changed, 15 insertions(+), 11 deletions(-)

diff --git a/drivers/char/moxa.c b/drivers/char/moxa.c
index f45405f..eabb2e0 100644
--- a/drivers/char/moxa.c
+++ b/drivers/char/moxa.c
@@ -846,10 +846,11 @@ static int moxa_init_board(struct moxa_board_conf *brd, struct device *dev)
 	if (ret)
 		goto err_free;
 
+	spin_lock_bh(&moxa_lock);
 	brd->ready = 1;
-
 	if (!timer_pending(&moxaTimer))
 		mod_timer(&moxaTimer, jiffies + HZ / 50);
+	spin_unlock_bh(&moxa_lock);
 
 	return 0;
 err_free:
@@ -1040,13 +1041,6 @@ static void __exit moxa_exit(void)
 {
 	int i;
 
-	del_timer_sync(&moxaTimer);
-
-	if (tty_unregister_driver(moxaDriver))
-		printk(KERN_ERR "Couldn't unregister MOXA Intellio family "
-				"serial driver\n");
-	put_tty_driver(moxaDriver);
-
 #ifdef CONFIG_PCI
 	pci_unregister_driver(&moxa_pci_driver);
 #endif
@@ -1054,6 +1048,13 @@ static void __exit moxa_exit(void)
 	for (i = 0; i < MAX_BOARDS; i++) /* ISA boards */
 		if (moxa_boards[i].ready)
 			moxa_board_deinit(&moxa_boards[i]);
+
+	del_timer_sync(&moxaTimer);
+
+	if (tty_unregister_driver(moxaDriver))
+		printk(KERN_ERR "Couldn't unregister MOXA Intellio family "
+				"serial driver\n");
+	put_tty_driver(moxaDriver);
 }
 
 module_init(moxa_init);
@@ -1432,7 +1433,7 @@ static void moxa_poll(unsigned long ignored)
 {
 	struct moxa_board_conf *brd;
 	u16 __iomem *ip;
-	unsigned int card, port;
+	unsigned int card, port, served = 0;
 
 	spin_lock(&moxa_lock);
 	for (card = 0; card < MAX_BOARDS; card++) {
@@ -1440,6 +1441,8 @@ static void moxa_poll(unsigned long ignored)
 		if (!brd->ready)
 			continue;
 
+		served++;
+
 		ip = NULL;
 		if (readb(brd->intPend) == 0xff)
 			ip = brd->intTable + readb(brd->intNdx);
@@ -1460,9 +1463,10 @@ static void moxa_poll(unsigned long ignored)
 		}
 	}
 	moxaLowWaterChk = 0;
-	spin_unlock(&moxa_lock);
 
-	mod_timer(&moxaTimer, jiffies + HZ / 50);
+	if (served)
+		mod_timer(&moxaTimer, jiffies + HZ / 50);
+	spin_unlock(&moxa_lock);
 }
 
 /******************************************************************************/
-- 
1.5.3.8

