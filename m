Return-Path: <linux-kernel-owner+w=401wt.eu-S935597AbXG2UBc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935597AbXG2UBc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jul 2007 16:01:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935146AbXG2UAs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Jul 2007 16:00:48 -0400
Received: from cacti.profiwh.com ([85.93.165.66]:39107 "EHLO smtp.wsc.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S935269AbXG2UAp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jul 2007 16:00:45 -0400
Message-id: <1243417395921129513@wsc.cz>
In-reply-to: <2460336901848917845@wsc.cz>
Subject: [PATCH 3/4] Char: cyclades, move spin_lock to one place
From: Jiri Slaby <jirislaby@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: <linux-kernel@vger.kernel.org>
Date: Sun, 29 Jul 2007 22:01:20 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

cyclades, move spin_lock to one place

lock whole processing in isr, avoid error-prone locking/unlocking in rx/tx
esp. on fail paths (there was a bug in the past yet).

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>

---
commit 93fc0dd73bb407b773506ec8d756317de9098d53
tree 6a1c1cfde015d095c6c94f21ea9b04e038787207
parent 681fc4c7f1aa79a001d5ebe5f09bc7b63fa9dd16
author Jiri Slaby <jirislaby@gmail.com> Sat, 28 Jul 2007 11:28:53 +0200
committer Jiri Slaby <jirislaby@gmail.com> Sat, 28 Jul 2007 11:28:53 +0200

 drivers/char/cyclades.c |    9 ++-------
 1 files changed, 2 insertions(+), 7 deletions(-)

diff --git a/drivers/char/cyclades.c b/drivers/char/cyclades.c
index 698e90c..a83524a 100644
--- a/drivers/char/cyclades.c
+++ b/drivers/char/cyclades.c
@@ -994,7 +994,6 @@ static void cyy_chip_rx(struct cyclades_card *cinfo, int chip,
 	printk(KERN_DEBUG "cyy_interrupt: rcvd intr, chip %d\n", chip);
 #endif
 	/* determine the channel & change to that context */
-	spin_lock(&cinfo->card_lock);
 	save_xir = (u_char) readb(base_addr + (CyRIR << index));
 	channel = (u_short) (save_xir & CyIRChannel);
 	info = &cinfo->ports[channel + chip * 4];
@@ -1031,7 +1030,6 @@ static void cyy_chip_rx(struct cyclades_card *cinfo, int chip,
 
 		if (data & info->ignore_status_mask) {
 			info->icount.rx++;
-			spin_unlock(&cinfo->card_lock);
 			return;
 		}
 		if (tty_buffer_request_room(tty, 1)) {
@@ -1116,7 +1114,6 @@ end:
 	/* end of service */
 	cy_writeb(base_addr + (CyRIR << index), save_xir & 0x3f);
 	cy_writeb(base_addr + (CyCAR << index), save_car);
-	spin_unlock(&cinfo->card_lock);
 }
 
 static void cyy_chip_tx(struct cyclades_card *cinfo, int chip,
@@ -1135,7 +1132,6 @@ static void cyy_chip_tx(struct cyclades_card *cinfo, int chip,
 #endif
 
 	/* determine the channel & change to that context */
-	spin_lock(&cinfo->card_lock);
 	save_xir = (u_char) readb(base_addr + (CyTIR << index));
 	channel = (u_short) (save_xir & CyIRChannel);
 	save_car = readb(base_addr + (CyCAR << index));
@@ -1240,7 +1236,6 @@ end:
 	/* end of service */
 	cy_writeb(base_addr + (CyTIR << index), save_xir & 0x3f);
 	cy_writeb(base_addr + (CyCAR << index), save_car);
-	spin_unlock(&cinfo->card_lock);
 }
 
 static void cyy_chip_modem(struct cyclades_card *cinfo, int chip,
@@ -1251,7 +1246,6 @@ static void cyy_chip_modem(struct cyclades_card *cinfo, int chip,
 	int save_xir, channel, save_car, index = cinfo->bus_index;
 
 	/* determine the channel & change to that context */
-	spin_lock(&cinfo->card_lock);
 	save_xir = (u_char) readb(base_addr + (CyMIR << index));
 	channel = (u_short) (save_xir & CyIRChannel);
 	info = &cinfo->ports[channel + chip * 4];
@@ -1315,7 +1309,6 @@ end:
 	/* end of service */
 	cy_writeb(base_addr + (CyMIR << index), save_xir & 0x3f);
 	cy_writeb(base_addr + (CyCAR << index), save_car);
-	spin_unlock(&cinfo->card_lock);
 }
 
 /* The real interrupt service routine is called
@@ -1367,12 +1360,14 @@ static irqreturn_t cyy_interrupt(int irq, void *dev_id)
 			 */
 				if (1000 < too_many++)
 					break;
+				spin_lock(&cinfo->card_lock);
 				if (status & CySRReceive) /* rx intr */
 					cyy_chip_rx(cinfo, chip, base_addr);
 				if (status & CySRTransmit) /* tx intr */
 					cyy_chip_tx(cinfo, chip, base_addr);
 				if (status & CySRModem) /* modem intr */
 					cyy_chip_modem(cinfo, chip, base_addr);
+				spin_unlock(&cinfo->card_lock);
 			}
 		}
 	} while (had_work);
