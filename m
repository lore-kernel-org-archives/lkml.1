Return-Path: <linux-kernel-owner+w=401wt.eu-S1161258AbXD2U7L@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161258AbXD2U7L (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Apr 2007 16:59:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161151AbXD2U7L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Apr 2007 16:59:11 -0400
Received: from cacti.profiwh.com ([85.93.165.66]:48215 "EHLO smtp.wsc.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1161258AbXD2U7I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Apr 2007 16:59:08 -0400
Message-id: <1845932223189792756@wsc.cz>
In-reply-to: <1726067771982725064@wsc.cz>
Subject: [PATCH 9/21] Char: cyclades, simplify variables initialization
From: Jiri Slaby <jirislaby@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: <linux-kernel@vger.kernel.org>
Date: Sun, 29 Apr 2007 22:59:05 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

cyclades, simplify variables initialization

- do not init static variables to 0
- simplify cy_init_card -- use memset(0) and do not zero each element
  separately, also reorder init, so that same entries are inited at one
  place

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>

---
commit 5bd7a7ad3eaafc9d8d03bd1488650b210c03f613
tree 46cb0c86eba349d6079d294359f8e36ff8526c71
parent 289b6204e150db7f487f53c227318b950b29d863
author Jiri Slaby <jirislaby@gmail.com> Wed, 25 Apr 2007 22:02:36 +0200
committer Jiri Slaby <jirislaby@gmail.com> Sat, 28 Apr 2007 23:47:12 +0200

 drivers/char/cyclades.c |  156 +++++++++++++----------------------------------
 1 files changed, 44 insertions(+), 112 deletions(-)

diff --git a/drivers/char/cyclades.c b/drivers/char/cyclades.c
index 738903d..9088c93 100644
--- a/drivers/char/cyclades.c
+++ b/drivers/char/cyclades.c
@@ -718,8 +718,8 @@ static unsigned int cy_isa_addresses[] = {
 #define NR_ISA_ADDRS ARRAY_SIZE(cy_isa_addresses)
 
 #ifdef MODULE
-static long maddr[NR_CARDS] = { 0, };
-static int irq[NR_CARDS] = { 0, };
+static long maddr[NR_CARDS];
+static int irq[NR_CARDS];
 
 module_param_array(maddr, long, NULL, 0);
 module_param_array(irq, int, NULL, 0);
@@ -4505,6 +4505,8 @@ static void __devinit cy_init_card(struct cyclades_card *cinfo,
 	unsigned short chip_number;
 	int index, port;
 
+	spin_lock_init(&cinfo->card_lock);
+
 	if (IS_CYC_Z(*cinfo)) {	/* Cyclades-Z */
 		mailbox = readl(&((struct RUNTIME_9060 __iomem *)
 				     cinfo->ctl_addr)->mail_box_0);
@@ -4512,104 +4514,47 @@ static void __devinit cy_init_card(struct cyclades_card *cinfo,
 		cinfo->intr_enabled = 0;
 		cinfo->nports = 0;	/* Will be correctly set later, after
 					   Z FW is loaded */
-		spin_lock_init(&cinfo->card_lock);
-		for (port = cinfo->first_line;
-		     port < cinfo->first_line + nports; port++) {
-			info = &cy_port[port];
-			info->magic = CYCLADES_MAGIC;
+	} else {
+		index = cinfo->bus_index;
+		nports = cinfo->nports = CyPORTS_PER_CHIP * cinfo->num_chips;
+	}
+
+	for (port = cinfo->first_line; port < cinfo->first_line + nports;
+			port++) {
+		info = &cy_port[port];
+		memset(info, 0, sizeof(*info));
+		info->magic = CYCLADES_MAGIC;
+		info->card = board;
+		info->line = port;
+		info->flags = STD_COM_FLAGS;
+		info->closing_wait = CLOSING_WAIT_DELAY;
+		info->close_delay = 5 * HZ / 10;
+
+		INIT_WORK(&info->tqueue, do_softint);
+		init_waitqueue_head(&info->open_wait);
+		init_waitqueue_head(&info->close_wait);
+		init_waitqueue_head(&info->shutdown_wait);
+		init_waitqueue_head(&info->delta_msr_wait);
+
+		if (IS_CYC_Z(*cinfo)) {
 			info->type = PORT_STARTECH;
-			info->card = board;
-			info->line = port;
-			info->chip_rev = 0;
-			info->flags = STD_COM_FLAGS;
-			info->tty = NULL;
 			if (mailbox == ZO_V1)
 				info->xmit_fifo_size = CYZ_FIFO_SIZE;
 			else
-				info->xmit_fifo_size =
-				    4 * CYZ_FIFO_SIZE;
-			info->cor1 = 0;
-			info->cor2 = 0;
-			info->cor3 = 0;
-			info->cor4 = 0;
-			info->cor5 = 0;
-			info->tbpr = 0;
-			info->tco = 0;
-			info->rbpr = 0;
-			info->rco = 0;
-			info->custom_divisor = 0;
-			info->close_delay = 5 * HZ / 10;
-			info->closing_wait = CLOSING_WAIT_DELAY;
-			info->icount.cts = info->icount.dsr =
-			    info->icount.rng = info->icount.dcd = 0;
-			info->icount.rx = info->icount.tx = 0;
-			info->icount.frame = info->icount.parity = 0;
-			info->icount.overrun = info->icount.brk = 0;
-			info->x_char = 0;
-			info->event = 0;
-			info->count = 0;
-			info->blocked_open = 0;
-			info->default_threshold = 0;
-			info->default_timeout = 0;
-			INIT_WORK(&info->tqueue, do_softint);
-			init_waitqueue_head(&info->open_wait);
-			init_waitqueue_head(&info->close_wait);
-			init_waitqueue_head(&info->shutdown_wait);
-			init_waitqueue_head(&info->delta_msr_wait);
-			/* info->session */
-			/* info->pgrp */
-			info->read_status_mask = 0;
-			/* info->timeout */
-			/* Bentson's vars */
-			info->jiffies[0] = 0;
-			info->jiffies[1] = 0;
-			info->jiffies[2] = 0;
-			info->rflush_count = 0;
+				info->xmit_fifo_size = 4 * CYZ_FIFO_SIZE;
 #ifdef CONFIG_CYZ_INTR
 			init_timer(&cyz_rx_full_timer[port]);
 			cyz_rx_full_timer[port].function = NULL;
 #endif
-		}
-#ifndef CONFIG_CYZ_INTR
-		if (!timer_pending(&cyz_timerlist)) {
-			mod_timer(&cyz_timerlist, jiffies + 1);
-#ifdef CY_PCI_DEBUG
-			printk(KERN_DEBUG "Cyclades-Z polling initialized\n");
-#endif
-		}
-#endif				/* CONFIG_CYZ_INTR */
-
-	} else {	/* Cyclom-Y of some kind */
-		index = cinfo->bus_index;
-		spin_lock_init(&cinfo->card_lock);
-		cinfo->nports = CyPORTS_PER_CHIP * cinfo->num_chips;
-		for (port = cinfo->first_line;
-		     port < cinfo->first_line + cinfo->nports; port++) {
-			info = &cy_port[port];
-			info->magic = CYCLADES_MAGIC;
+		} else {
 			info->type = PORT_CIRRUS;
-			info->card = board;
-			info->line = port;
-			info->flags = STD_COM_FLAGS;
-			info->tty = NULL;
 			info->xmit_fifo_size = CyMAX_CHAR_FIFO;
-			info->cor1 =
-			    CyPARITY_NONE | Cy_1_STOP | Cy_8_BITS;
+			info->cor1 = CyPARITY_NONE | Cy_1_STOP | Cy_8_BITS;
 			info->cor2 = CyETC;
 			info->cor3 = 0x08;	/* _very_ small rcv threshold */
-			info->cor4 = 0;
-			info->cor5 = 0;
-			info->custom_divisor = 0;
-			info->close_delay = 5 * HZ / 10;
-			info->closing_wait = CLOSING_WAIT_DELAY;
-			info->icount.cts = info->icount.dsr =
-			    info->icount.rng = info->icount.dcd = 0;
-			info->icount.rx = info->icount.tx = 0;
-			info->icount.frame = info->icount.parity = 0;
-			info->icount.overrun = info->icount.brk = 0;
+
 			chip_number = (port - cinfo->first_line) / 4;
-			if ((info->chip_rev =
-			     readb(cinfo->base_addr +
+			if ((info->chip_rev = readb(cinfo->base_addr +
 				      (cy_chip_offset[chip_number] <<
 				       index) + (CyGFRCR << index))) >=
 			    CD1400_REV_J) {
@@ -4618,35 +4563,28 @@ static void __devinit cy_init_card(struct cyclades_card *cinfo,
 				info->tco = baud_co_60[13];	/* Tx CO */
 				info->rbpr = baud_bpr_60[13];	/* Rx BPR */
 				info->rco = baud_co_60[13];	/* Rx CO */
-				info->rflow = 0;
 				info->rtsdtr_inv = 1;
 			} else {
 				info->tbpr = baud_bpr_25[13];	/* Tx BPR */
 				info->tco = baud_co_25[13];	/* Tx CO */
 				info->rbpr = baud_bpr_25[13];	/* Rx BPR */
 				info->rco = baud_co_25[13];	/* Rx CO */
-				info->rflow = 0;
 				info->rtsdtr_inv = 0;
 			}
-			info->x_char = 0;
-			info->event = 0;
-			info->count = 0;
-			info->blocked_open = 0;
-			info->default_threshold = 0;
-			info->default_timeout = 0;
-			INIT_WORK(&info->tqueue, do_softint);
-			init_waitqueue_head(&info->open_wait);
-			init_waitqueue_head(&info->close_wait);
-			init_waitqueue_head(&info->shutdown_wait);
-			init_waitqueue_head(&info->delta_msr_wait);
-			/* info->session */
-			/* info->pgrp */
-			info->read_status_mask =
-			    CyTIMEOUT | CySPECHAR | CyBREAK
-			    | CyPARITY | CyFRAME | CyOVERRUN;
-			/* info->timeout */
+			info->read_status_mask = CyTIMEOUT | CySPECHAR |
+				CyBREAK | CyPARITY | CyFRAME | CyOVERRUN;
 		}
+
 	}
+
+#ifndef CONFIG_CYZ_INTR
+	if (IS_CYC_Z(*cinfo) && !timer_pending(&cyz_timerlist)) {
+		mod_timer(&cyz_timerlist, jiffies + 1);
+#ifdef CY_PCI_DEBUG
+		printk(KERN_DEBUG "Cyclades-Z polling initialized\n");
+#endif
+	}
+#endif
 }
 
 /* initialize chips on Cyclom-Y card -- return number of valid
@@ -5369,12 +5307,6 @@ static int __init cy_init(void)
 		goto err_frtty;
 	}
 
-	for (i = 0; i < NR_CARDS; i++) {
-		/* base_addr=0 indicates board not found */
-		cy_card[i].base_addr = NULL;
-	}
-
-	/* invalidate remaining cy_port structures */
 	for (i = 0; i < NR_PORTS; i++) {
 		cy_port[i].line = -1;
 		cy_port[i].magic = -1;
