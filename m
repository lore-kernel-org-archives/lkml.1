Return-Path: <linux-kernel-owner+w=401wt.eu-S1422782AbXDRKF2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422782AbXDRKF2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2007 06:05:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422780AbXDRKF2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Apr 2007 06:05:28 -0400
Received: from av7.karneval.cz ([81.27.192.15]:53227 "EHLO av6.karneval.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1422777AbXDRKFX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2007 06:05:23 -0400
Message-id: <3210010229950231391@karneval.cz>
In-reply-to: <2428225437641930190@karneval.cz>
Subject: [PATCH 5/11] Char: cyclades, move card entries init into function
From: Jiri Slaby <jirislaby@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: <linux-kernel@vger.kernel.org>
Date: Wed, 18 Apr 2007 12:05:17 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

cyclades, move card entries init into function

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>

---
commit de8850dd6c04762688b19609b13cb16a1e6399a9
tree 288721fb454613ce1d3bdd6ec10ca6e01c3059c7
parent 07df3f0fcb1cad6a274d5b7b32d65df54c3f4fb4
author Jiri Slaby <jirislaby@gmail.com> Mon, 02 Apr 2007 12:07:20 +0200
committer Jiri Slaby <jirislaby@gmail.com> Tue, 10 Apr 2007 10:48:02 +0200

 drivers/char/cyclades.c |  311 ++++++++++++++++++++++++-----------------------
 1 files changed, 156 insertions(+), 155 deletions(-)

diff --git a/drivers/char/cyclades.c b/drivers/char/cyclades.c
index adf993a..fe967be 100644
--- a/drivers/char/cyclades.c
+++ b/drivers/char/cyclades.c
@@ -4503,6 +4503,159 @@ static void cy_hangup(struct tty_struct *tty)
  * ---------------------------------------------------------------------
  */
 
+static void __devinit cy_init_card(struct cyclades_card *cinfo,
+		const unsigned int board)
+{
+	struct cyclades_port *info;
+	u32 mailbox;
+	unsigned int nports;
+	unsigned short chip_number;
+	int index, port;
+
+	if (cinfo->num_chips == -1) {	/* Cyclades-Z */
+		mailbox = readl(&((struct RUNTIME_9060 __iomem *)
+				     cinfo->ctl_addr)->mail_box_0);
+		nports = (mailbox == ZE_V1) ? ZE_V1_NPORTS : 8;
+		cinfo->intr_enabled = 0;
+		cinfo->nports = 0;	/* Will be correctly set later, after 
+					   Z FW is loaded */
+		spin_lock_init(&cinfo->card_lock);
+		for (port = cinfo->first_line;
+		     port < cinfo->first_line + nports; port++) {
+			info = &cy_port[port];
+			info->magic = CYCLADES_MAGIC;
+			info->type = PORT_STARTECH;
+			info->card = board;
+			info->line = port;
+			info->chip_rev = 0;
+			info->flags = STD_COM_FLAGS;
+			info->tty = NULL;
+			if (mailbox == ZO_V1)
+				info->xmit_fifo_size = CYZ_FIFO_SIZE;
+			else
+				info->xmit_fifo_size =
+				    4 * CYZ_FIFO_SIZE;
+			info->cor1 = 0;
+			info->cor2 = 0;
+			info->cor3 = 0;
+			info->cor4 = 0;
+			info->cor5 = 0;
+			info->tbpr = 0;
+			info->tco = 0;
+			info->rbpr = 0;
+			info->rco = 0;
+			info->custom_divisor = 0;
+			info->close_delay = 5 * HZ / 10;
+			info->closing_wait = CLOSING_WAIT_DELAY;
+			info->icount.cts = info->icount.dsr =
+			    info->icount.rng = info->icount.dcd = 0;
+			info->icount.rx = info->icount.tx = 0;
+			info->icount.frame = info->icount.parity = 0;
+			info->icount.overrun = info->icount.brk = 0;
+			info->x_char = 0;
+			info->event = 0;
+			info->count = 0;
+			info->blocked_open = 0;
+			info->default_threshold = 0;
+			info->default_timeout = 0;
+			INIT_WORK(&info->tqueue, do_softint);
+			init_waitqueue_head(&info->open_wait);
+			init_waitqueue_head(&info->close_wait);
+			init_waitqueue_head(&info->shutdown_wait);
+			init_waitqueue_head(&info->delta_msr_wait);
+			/* info->session */
+			/* info->pgrp */
+			info->read_status_mask = 0;
+			/* info->timeout */
+			/* Bentson's vars */
+			info->jiffies[0] = 0;
+			info->jiffies[1] = 0;
+			info->jiffies[2] = 0;
+			info->rflush_count = 0;
+#ifdef CONFIG_CYZ_INTR
+			init_timer(&cyz_rx_full_timer[port]);
+			cyz_rx_full_timer[port].function = NULL;
+#endif
+		}
+#ifndef CONFIG_CYZ_INTR
+		if (!timer_pending(&cyz_timerlist)) {
+			mod_timer(&cyz_timerlist, jiffies + 1);
+#ifdef CY_PCI_DEBUG
+			printk("Cyclades-Z polling initialized\n");
+#endif
+		}
+#endif				/* CONFIG_CYZ_INTR */
+
+	} else {	/* Cyclom-Y of some kind */
+		index = cinfo->bus_index;
+		spin_lock_init(&cinfo->card_lock);
+		cinfo->nports = CyPORTS_PER_CHIP * cinfo->num_chips;
+		for (port = cinfo->first_line;
+		     port < cinfo->first_line + cinfo->nports; port++) {
+			info = &cy_port[port];
+			info->magic = CYCLADES_MAGIC;
+			info->type = PORT_CIRRUS;
+			info->card = board;
+			info->line = port;
+			info->flags = STD_COM_FLAGS;
+			info->tty = NULL;
+			info->xmit_fifo_size = CyMAX_CHAR_FIFO;
+			info->cor1 =
+			    CyPARITY_NONE | Cy_1_STOP | Cy_8_BITS;
+			info->cor2 = CyETC;
+			info->cor3 = 0x08;	/* _very_ small rcv threshold */
+			info->cor4 = 0;
+			info->cor5 = 0;
+			info->custom_divisor = 0;
+			info->close_delay = 5 * HZ / 10;
+			info->closing_wait = CLOSING_WAIT_DELAY;
+			info->icount.cts = info->icount.dsr =
+			    info->icount.rng = info->icount.dcd = 0;
+			info->icount.rx = info->icount.tx = 0;
+			info->icount.frame = info->icount.parity = 0;
+			info->icount.overrun = info->icount.brk = 0;
+			chip_number = (port - cinfo->first_line) / 4;
+			if ((info->chip_rev =
+			     readb(cinfo->base_addr +
+				      (cy_chip_offset[chip_number] <<
+				       index) + (CyGFRCR << index))) >=
+			    CD1400_REV_J) {
+				/* It is a CD1400 rev. J or later */
+				info->tbpr = baud_bpr_60[13];	/* Tx BPR */
+				info->tco = baud_co_60[13];	/* Tx CO */
+				info->rbpr = baud_bpr_60[13];	/* Rx BPR */
+				info->rco = baud_co_60[13];	/* Rx CO */
+				info->rflow = 0;
+				info->rtsdtr_inv = 1;
+			} else {
+				info->tbpr = baud_bpr_25[13];	/* Tx BPR */
+				info->tco = baud_co_25[13];	/* Tx CO */
+				info->rbpr = baud_bpr_25[13];	/* Rx BPR */
+				info->rco = baud_co_25[13];	/* Rx CO */
+				info->rflow = 0;
+				info->rtsdtr_inv = 0;
+			}
+			info->x_char = 0;
+			info->event = 0;
+			info->count = 0;
+			info->blocked_open = 0;
+			info->default_threshold = 0;
+			info->default_timeout = 0;
+			INIT_WORK(&info->tqueue, do_softint);
+			init_waitqueue_head(&info->open_wait);
+			init_waitqueue_head(&info->close_wait);
+			init_waitqueue_head(&info->shutdown_wait);
+			init_waitqueue_head(&info->delta_msr_wait);
+			/* info->session */
+			/* info->pgrp */
+			info->read_status_mask =
+			    CyTIMEOUT | CySPECHAR | CyBREAK
+			    | CyPARITY | CyFRAME | CyOVERRUN;
+			/* info->timeout */
+		}
+	}
+}
+
 /* initialize chips on Cyclom-Y card -- return number of valid
    chips (which is number of ports/4) */
 static unsigned short __init
@@ -5300,13 +5453,7 @@ static const struct tty_operations cy_ops = {
 
 static int __init cy_init(void)
 {
-	struct cyclades_port *info;
-	struct cyclades_card *cinfo;
-	int number_z_boards = 0;
-	int board, port, i, index;
-	unsigned long mailbox;
-	unsigned short chip_number;
-	int nports;
+	unsigned int i;
 
 	cy_serial_driver = alloc_tty_driver(NR_PORTS);
 	if (!cy_serial_driver)
@@ -5369,154 +5516,8 @@ static int __init cy_init(void)
 	}
 
 	/* initialize per-port data structures for each valid board found */
-	for (board = 0; board < cy_nboard; board++) {
-		cinfo = &cy_card[board];
-		if (cinfo->num_chips == -1) {	/* Cyclades-Z */
-			number_z_boards++;
-			mailbox = readl(&((struct RUNTIME_9060 __iomem *)
-					     cy_card[board].ctl_addr)->
-					   mail_box_0);
-			nports = (mailbox == ZE_V1) ? ZE_V1_NPORTS : 8;
-			cinfo->intr_enabled = 0;
-			cinfo->nports = 0;	/* Will be correctly set later, after 
-						   Z FW is loaded */
-			spin_lock_init(&cinfo->card_lock);
-			for (port = cinfo->first_line;
-			     port < cinfo->first_line + nports; port++) {
-				info = &cy_port[port];
-				info->magic = CYCLADES_MAGIC;
-				info->type = PORT_STARTECH;
-				info->card = board;
-				info->line = port;
-				info->chip_rev = 0;
-				info->flags = STD_COM_FLAGS;
-				info->tty = NULL;
-				if (mailbox == ZO_V1)
-					info->xmit_fifo_size = CYZ_FIFO_SIZE;
-				else
-					info->xmit_fifo_size =
-					    4 * CYZ_FIFO_SIZE;
-				info->cor1 = 0;
-				info->cor2 = 0;
-				info->cor3 = 0;
-				info->cor4 = 0;
-				info->cor5 = 0;
-				info->tbpr = 0;
-				info->tco = 0;
-				info->rbpr = 0;
-				info->rco = 0;
-				info->custom_divisor = 0;
-				info->close_delay = 5 * HZ / 10;
-				info->closing_wait = CLOSING_WAIT_DELAY;
-				info->icount.cts = info->icount.dsr =
-				    info->icount.rng = info->icount.dcd = 0;
-				info->icount.rx = info->icount.tx = 0;
-				info->icount.frame = info->icount.parity = 0;
-				info->icount.overrun = info->icount.brk = 0;
-				info->x_char = 0;
-				info->event = 0;
-				info->count = 0;
-				info->blocked_open = 0;
-				info->default_threshold = 0;
-				info->default_timeout = 0;
-				INIT_WORK(&info->tqueue, do_softint);
-				init_waitqueue_head(&info->open_wait);
-				init_waitqueue_head(&info->close_wait);
-				init_waitqueue_head(&info->shutdown_wait);
-				init_waitqueue_head(&info->delta_msr_wait);
-				/* info->session */
-				/* info->pgrp */
-				info->read_status_mask = 0;
-				/* info->timeout */
-				/* Bentson's vars */
-				info->jiffies[0] = 0;
-				info->jiffies[1] = 0;
-				info->jiffies[2] = 0;
-				info->rflush_count = 0;
-#ifdef CONFIG_CYZ_INTR
-				init_timer(&cyz_rx_full_timer[port]);
-				cyz_rx_full_timer[port].function = NULL;
-#endif
-			}
-			continue;
-		} else {	/* Cyclom-Y of some kind */
-			index = cinfo->bus_index;
-			spin_lock_init(&cinfo->card_lock);
-			cinfo->nports = CyPORTS_PER_CHIP * cinfo->num_chips;
-			for (port = cinfo->first_line;
-			     port < cinfo->first_line + cinfo->nports; port++) {
-				info = &cy_port[port];
-				info->magic = CYCLADES_MAGIC;
-				info->type = PORT_CIRRUS;
-				info->card = board;
-				info->line = port;
-				info->flags = STD_COM_FLAGS;
-				info->tty = NULL;
-				info->xmit_fifo_size = CyMAX_CHAR_FIFO;
-				info->cor1 =
-				    CyPARITY_NONE | Cy_1_STOP | Cy_8_BITS;
-				info->cor2 = CyETC;
-				info->cor3 = 0x08;	/* _very_ small rcv threshold */
-				info->cor4 = 0;
-				info->cor5 = 0;
-				info->custom_divisor = 0;
-				info->close_delay = 5 * HZ / 10;
-				info->closing_wait = CLOSING_WAIT_DELAY;
-				info->icount.cts = info->icount.dsr =
-				    info->icount.rng = info->icount.dcd = 0;
-				info->icount.rx = info->icount.tx = 0;
-				info->icount.frame = info->icount.parity = 0;
-				info->icount.overrun = info->icount.brk = 0;
-				chip_number = (port - cinfo->first_line) / 4;
-				if ((info->chip_rev =
-				     readb(cinfo->base_addr +
-					      (cy_chip_offset[chip_number] <<
-					       index) + (CyGFRCR << index))) >=
-				    CD1400_REV_J) {
-					/* It is a CD1400 rev. J or later */
-					info->tbpr = baud_bpr_60[13];	/* Tx BPR */
-					info->tco = baud_co_60[13];	/* Tx CO */
-					info->rbpr = baud_bpr_60[13];	/* Rx BPR */
-					info->rco = baud_co_60[13];	/* Rx CO */
-					info->rflow = 0;
-					info->rtsdtr_inv = 1;
-				} else {
-					info->tbpr = baud_bpr_25[13];	/* Tx BPR */
-					info->tco = baud_co_25[13];	/* Tx CO */
-					info->rbpr = baud_bpr_25[13];	/* Rx BPR */
-					info->rco = baud_co_25[13];	/* Rx CO */
-					info->rflow = 0;
-					info->rtsdtr_inv = 0;
-				}
-				info->x_char = 0;
-				info->event = 0;
-				info->count = 0;
-				info->blocked_open = 0;
-				info->default_threshold = 0;
-				info->default_timeout = 0;
-				INIT_WORK(&info->tqueue, do_softint);
-				init_waitqueue_head(&info->open_wait);
-				init_waitqueue_head(&info->close_wait);
-				init_waitqueue_head(&info->shutdown_wait);
-				init_waitqueue_head(&info->delta_msr_wait);
-				/* info->session */
-				/* info->pgrp */
-				info->read_status_mask =
-				    CyTIMEOUT | CySPECHAR | CyBREAK
-				    | CyPARITY | CyFRAME | CyOVERRUN;
-				/* info->timeout */
-			}
-		}
-	}
-
-#ifndef CONFIG_CYZ_INTR
-	if (number_z_boards) {
-		mod_timer(&cyz_timerlist, jiffies + 1);
-#ifdef CY_PCI_DEBUG
-		printk("Cyclades-Z polling initialized\n");
-#endif
-	}
-#endif				/* CONFIG_CYZ_INTR */
+	for (i = 0; i < cy_nboard; i++)
+		cy_init_card(&cy_card[i], i);
 
 	return 0;
 
