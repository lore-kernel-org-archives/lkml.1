Return-Path: <linux-kernel-owner+w=401wt.eu-S1161333AbXD2VFd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161333AbXD2VFd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Apr 2007 17:05:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161366AbXD2VFc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Apr 2007 17:05:32 -0400
Received: from cacti.profiwh.com ([85.93.165.66]:48211 "EHLO smtp.wsc.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1161333AbXD2VEr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Apr 2007 17:04:47 -0400
Message-id: <49901838060939918@wsc.cz>
In-reply-to: <1726067771982725064@wsc.cz>
Subject: [PATCH 17/21] Char: cyclades, conditions cleanup
From: Jiri Slaby <jirislaby@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: <linux-kernel@vger.kernel.org>
Date: Sun, 29 Apr 2007 23:04:45 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

cyclades, conditions cleanup

- 0 is not NULL
- use unlikely to hit the icache in isr more likely
- remove or comment empty if/else paths

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>

---
commit fb2b658e64e69e56c52b1242b9957e9d96f28ade
tree b7f1629c12b53a56bd5b3149ceba3830dbfc028f
parent c2e132ebb19f9f8b3d4aee5cd4f755cd7588d49f
author Jiri Slaby <jirislaby@gmail.com> Fri, 27 Apr 2007 18:03:37 +0200
committer Jiri Slaby <jirislaby@gmail.com> Sat, 28 Apr 2007 23:48:36 +0200

 drivers/char/cyclades.c |   60 ++++++++++++++++-------------------------------
 1 files changed, 21 insertions(+), 39 deletions(-)

diff --git a/drivers/char/cyclades.c b/drivers/char/cyclades.c
index 6e5fca9..620e17c 100644
--- a/drivers/char/cyclades.c
+++ b/drivers/char/cyclades.c
@@ -1043,7 +1043,7 @@ static void cyy_intr_chip(struct cyclades_card *cinfo, int chip,
 		cy_writeb(base_addr + (CyCAR << index), save_xir);
 
 		/* if there is nowhere to put the data, discard it */
-		if (info->tty == 0) {
+		if (info->tty == NULL) {
 			j = (readb(base_addr + (CyRIVR << index)) &
 				CyIVRMask);
 			if (j == CyIVRRxEx) {	/* exception */
@@ -1214,7 +1214,7 @@ static void cyy_intr_chip(struct cyclades_card *cinfo, int chip,
 			goto txend;
 		}
 		info = &cy_port[i];
-		if (info->tty == 0) {
+		if (info->tty == NULL) {
 			cy_writeb(base_addr + (CySRER << index),
 				  readb(base_addr + (CySRER << index)) &
 				  ~CyTxRdy);
@@ -1263,7 +1263,7 @@ static void cyy_intr_chip(struct cyclades_card *cinfo, int chip,
 				}
 				goto txdone;
 			}
-			if (info->xmit_buf == 0) {
+			if (info->xmit_buf == NULL) {
 				cy_writeb(base_addr + (CySRER << index),
 					readb(base_addr + (CySRER << index)) &
 					~CyTxRdy);
@@ -1304,7 +1304,6 @@ static void cyy_intr_chip(struct cyclades_card *cinfo, int chip,
 						0);
 					info->icount.tx++;
 					char_count--;
-				} else {
 				}
 			}
 		}
@@ -1333,9 +1332,7 @@ txend:
 		mdm_change = readb(base_addr + (CyMISR << index));
 		mdm_status = readb(base_addr + (CyMSVR1 << index));
 
-		if (info->tty == 0) {	/* no place for data, ignore it */
-			;
-		} else {
+		if (info->tty) {
 			if (mdm_change & CyANY_DELTA) {
 				/* For statistics only */
 				if (mdm_change & CyDCD)
@@ -1389,10 +1386,10 @@ txend:
 					}
 				}
 			}
-			if (mdm_change & CyDSR) {
+/*			if (mdm_change & CyDSR) {
 			}
 			if (mdm_change & CyRI) {
-			}
+			}*/
 		}
 		/* end of service */
 		cy_writeb(base_addr + (CyMIR << index), (save_xir & 0x3f));
@@ -1408,14 +1405,14 @@ txend:
 static irqreturn_t cyy_interrupt(int irq, void *dev_id)
 {
 	int status;
-	struct cyclades_card *cinfo;
+	struct cyclades_card *cinfo = dev_id;
 	void __iomem *base_addr, *card_base_addr;
 	int chip;
 	int index;
 	int too_many;
 	int had_work;
 
-	if ((cinfo = (struct cyclades_card *)dev_id) == 0) {
+	if (unlikely(cinfo == NULL)) {
 #ifdef CY_DEBUG_INTERRUPTS
 		printk(KERN_DEBUG "cyy_interrupt: spurious interrupt %d\n",irq);
 #endif
@@ -1564,7 +1561,7 @@ cyz_handle_rx(struct cyclades_port *info, struct CH_CTRL __iomem *ch_ctrl,
 			info->mon.char_max = char_count;
 		info->mon.char_last = char_count;
 #endif
-		if (tty == 0) {
+		if (tty == NULL) {
 			/* flush received characters */
 			new_rx_get = (new_rx_get + char_count) &
 					(rx_bufsize - 1);
@@ -1650,9 +1647,8 @@ cyz_handle_tx(struct cyclades_port *info, struct CH_CTRL __iomem *ch_ctrl,
 
 	if (char_count) {
 
-		if (tty == 0) {
+		if (tty == NULL)
 			goto ztxdone;
-		}
 
 		if (info->x_char) {	/* send special char */
 			data = info->x_char;
@@ -1731,9 +1727,9 @@ static void cyz_handle_cmd(struct cyclades_card *cinfo)
 		special_count = 0;
 		delta_count = 0;
 		info = &cy_port[channel + cinfo->first_line];
-		if ((tty = info->tty) == 0) {
+		if ((tty = info->tty) == NULL)
 			continue;
-		}
+
 		ch_ctrl = &(zfw_ctrl->ch_ctrl[channel]);
 		buf_ctrl = &(zfw_ctrl->buf_ctrl[channel]);
 
@@ -1822,16 +1818,16 @@ static void cyz_handle_cmd(struct cyclades_card *cinfo)
 #ifdef CONFIG_CYZ_INTR
 static irqreturn_t cyz_interrupt(int irq, void *dev_id)
 {
-	struct cyclades_card *cinfo;
+	struct cyclades_card *cinfo = dev_id;
 
-	if ((cinfo = (struct cyclades_card *)dev_id) == 0) {
+	if (unlikely(cinfo == NULL))
 #ifdef CY_DEBUG_INTERRUPTS
 		printk(KERN_DEBUG "cyz_interrupt: spurious interrupt %d\n",irq);
 #endif
 		return IRQ_NONE;	/* spurious interrupt */
 	}
 
-	if (!ISZLOADED(*cinfo)) {
+	if (unlikely(!ISZLOADED(*cinfo))) {
 #ifdef CY_DEBUG_INTERRUPTS
 		printk(KERN_DEBUG "cyz_interrupt: board not yet loaded "
 				"(IRQ%d).\n", irq);
@@ -2661,8 +2657,6 @@ static void cy_wait_until_sent(struct tty_struct *tty, int timeout)
 					timeout))
 				break;
 		}
-	} else {
-		/* Nothing to do! */
 	}
 	/* Run one more char cycle */
 	msleep_interruptible(jiffies_to_msecs(char_time * 5));
@@ -3857,8 +3851,6 @@ static int set_threshold(struct cyclades_port *info, unsigned long value)
 		cy_writeb(base_addr + (CyCOR3 << index), info->cor3);
 		cyy_issue_cmd(base_addr, CyCOR_CHANGE | CyCOR3ch, index);
 		spin_unlock_irqrestore(&card->card_lock, flags);
-	} else {
-		/* Nothing to do! */
 	}
 	return 0;
 }				/* set_threshold */
@@ -3881,10 +3873,8 @@ get_threshold(struct cyclades_port *info, unsigned long __user * value)
 
 		tmp = readb(base_addr + (CyCOR3 << index)) & CyREC_FIFO;
 		return put_user(tmp, value);
-	} else {
-		/* Nothing to do! */
-		return 0;
 	}
+	return 0;
 }				/* get_threshold */
 
 static int
@@ -3918,8 +3908,6 @@ static int set_timeout(struct cyclades_port *info, unsigned long value)
 		spin_lock_irqsave(&card->card_lock, flags);
 		cy_writeb(base_addr + (CyRTPR << index), value & 0xff);
 		spin_unlock_irqrestore(&card->card_lock, flags);
-	} else {
-		/* Nothing to do! */
 	}
 	return 0;
 }				/* set_timeout */
@@ -3941,10 +3929,8 @@ static int get_timeout(struct cyclades_port *info, unsigned long __user * value)
 
 		tmp = readb(base_addr + (CyRTPR << index));
 		return put_user(tmp, value);
-	} else {
-		/* Nothing to do! */
-		return 0;
 	}
+	return 0;
 }				/* get_timeout */
 
 static int set_default_timeout(struct cyclades_port *info, unsigned long value)
@@ -4348,8 +4334,6 @@ static void cy_stop(struct tty_struct *tty)
 		cy_writeb(base_addr + (CySRER << index),
 			  readb(base_addr + (CySRER << index)) & ~CyTxRdy);
 		spin_unlock_irqrestore(&cinfo->card_lock, flags);
-	} else {
-		/* Nothing to do! */
 	}
 }				/* cy_stop */
 
@@ -4381,8 +4365,6 @@ static void cy_start(struct tty_struct *tty)
 		cy_writeb(base_addr + (CySRER << index),
 			  readb(base_addr + (CySRER << index)) | CyTxRdy);
 		spin_unlock_irqrestore(&cinfo->card_lock, flags);
-	} else {
-		/* Nothing to do! */
 	}
 }				/* cy_start */
 
@@ -4694,7 +4676,7 @@ static int __init cy_detect_isa(void)
 		}
 		/* fill the next cy_card structure available */
 		for (j = 0; j < NR_CARDS; j++) {
-			if (cy_card[j].base_addr == 0)
+			if (cy_card[j].base_addr == NULL)
 				break;
 		}
 		if (j == NR_CARDS) {	/* no more cy_cards available */
@@ -4779,7 +4761,7 @@ static int __devinit cy_init_Ze(struct RUNTIME_9060 __iomem *cy_pci_addr0,
 
 	/* fill the next cy_card structure available */
 	for (j = 0; j < NR_CARDS; j++) {
-		if (cy_card[j].base_addr == 0)
+		if (cy_card[j].base_addr == NULL)
 			break;
 	}
 	if (j == NR_CARDS) {	/* no more cy_cards available */
@@ -4889,7 +4871,7 @@ static int __devinit cy_pci_probe(struct pci_dev *pdev,
 		}
 		/* fill the next cy_card structure available */
 		for (j = 0; j < NR_CARDS; j++) {
-			if (cy_card[j].base_addr == 0)
+			if (cy_card[j].base_addr == NULL)
 				break;
 		}
 		if (j == NR_CARDS) {	/* no more cy_cards available */
@@ -5039,7 +5021,7 @@ static int __devinit cy_pci_probe(struct pci_dev *pdev,
 
 		/* fill the next cy_card structure available */
 		for (j = 0; j < NR_CARDS; j++) {
-			if (cy_card[j].base_addr == 0)
+			if (cy_card[j].base_addr == NULL)
 				break;
 		}
 		if (j == NR_CARDS) {	/* no more cy_cards available */
