Return-Path: <linux-kernel-owner+w=401wt.eu-S965680AbXHMDgE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965680AbXHMDgE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Aug 2007 23:36:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964784AbXHMDfv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Aug 2007 23:35:51 -0400
Received: from smtp3.hushmail.com ([65.39.178.135]:56926 "EHLO
	smtp3.hushmail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935290AbXHMDfu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Aug 2007 23:35:50 -0400
Date: Sun, 12 Aug 2007 23:35:48 -0400
To: <linux-kernel@vger.kernel.org>, <kernel-janitors@vger.kernel.org>,
       <linux-atm-general@lists.sourceforge.net>
Subject: [PATCH ] /drivers/atm ioremap balancing/ returncode check
Reply-to: postfail@hushmail.com
From: "Scott Thompson" <postfail@hushmail.com>
Content-type: text/plain; charset="UTF-8"
Message-Id: <20070813033549.16C28DA820@mailserver8.hushmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

patchset against 2.6.23-rc2.  
corrects missing ioremap return checks and balancing on iounmap 
calls in /drivers/atm...

Signed-off-by: Scott Thompson <postfail <at> hushmail.com>
----------------------------------------------------------
diff --git a/drivers/atm/fore200e.c b/drivers/atm/fore200e.c
index 405ee5e..99e4ae4 100644
--- a/drivers/atm/fore200e.c
+++ b/drivers/atm/fore200e.c
@@ -795,8 +795,9 @@ fore200e_sba_map(struct fore200e* fore200e)
     fore200e->regs.sba.isr = sbus_ioremap(&sbus_dev->resource[2], 
0, SBA200E_ISR_LENGTH, "SBA ISR");
     fore200e->virt_base    = sbus_ioremap(&sbus_dev->resource[3], 
0, SBA200E_RAM_LENGTH, "SBA RAM");
 
-    if (fore200e->virt_base == NULL) {
+    if (!fore200e->regs.sba.hcr || !fore200e->regs.sba.bsr || 
!fore200e->regs.sba.isr || !fore200e->virt_base) {
 	printk(FORE200E "unable to map RAM of device %s\n", fore200e-
>name);
+	fore200e_sba_unmap(fore200e);
 	return -EFAULT;
     }
 
diff --git a/drivers/atm/he.c b/drivers/atm/he.c
index d33aba6..92d0d51 100644
--- a/drivers/atm/he.c
+++ b/drivers/atm/he.c
@@ -1107,6 +1107,7 @@ he_start(struct atm_dev *dev)
 	status = he_readl(he_dev, RESET_CNTL);
 	if ((status & BOARD_RST_STATUS) == 0) {
 		hprintk("reset failed\n");
+		iounmap(he_dev->membase);
 		return -EINVAL;
 	}
 
@@ -1170,8 +1171,10 @@ he_start(struct atm_dev *dev)
 	he_writel(he_dev, lb_swap, LB_SWAP);
 
 	/* 4.10 initialize the interrupt queues */
-	if ((err = he_init_irq(he_dev)) != 0)
+	if ((err = he_init_irq(he_dev)) != 0) {
+		iounmap(he_dev->membase);
 		return err;
+	}
 
 #ifdef USE_TASKLET
 	tasklet_init(&he_dev->tasklet, he_tasklet, (unsigned long) 
he_dev);
@@ -1226,6 +1229,7 @@ he_start(struct atm_dev *dev)
 
 	if (nvpibits != -1 && nvcibits != -1 && nvpibits+nvcibits != 
HE_MAXCIDBITS) {
 		hprintk("nvpibits + nvcibits != %d\n", HE_MAXCIDBITS);
+		iounmap(he_dev->membase);
 		return -ENODEV;
 	}
 
@@ -1474,9 +1478,10 @@ he_start(struct atm_dev *dev)
 
 	/* 5.1.8 cs block connection memory initialization */
 	
-	if (he_init_cs_block_rcm(he_dev) < 0)
+	if (he_init_cs_block_rcm(he_dev) < 0) {
+		iounmap(he_dev->membase);
 		return -ENOMEM;
-
+	}
 	/* 5.1.10 initialize host structures */
 
 	he_init_tpdrq(he_dev);
@@ -1486,6 +1491,7 @@ he_start(struct atm_dev *dev)
 		sizeof(struct he_tpd), TPD_ALIGNMENT, 0);
 	if (he_dev->tpd_pool == NULL) {
 		hprintk("unable to create tpd pci_pool\n");
+		iounmap(he_dev->membase);
 		return -ENOMEM;         
 	}
 
@@ -1493,8 +1499,10 @@ he_start(struct atm_dev *dev)
 #else
 	he_dev->tpd_base = (void *) pci_alloc_consistent(he_dev->pci_dev,
 			CONFIG_NUMTPDS * sizeof(struct he_tpd), &he_dev->tpd_base_phys);
-	if (!he_dev->tpd_base)
+	if (!he_dev->tpd_base) {
+		iounmap(he_dev->membase);
 		return -ENOMEM;
+	}
 
 	for (i = 0; i < CONFIG_NUMTPDS; ++i) {
 		he_dev->tpd_base[i].status = (i << TPD_ADDR_SHIFT);
@@ -1505,8 +1513,10 @@ he_start(struct atm_dev *dev)
 	he_dev->tpd_end = &he_dev->tpd_base[CONFIG_NUMTPDS - 1];
 #endif
 
-	if (he_init_group(he_dev, 0) != 0)
+	if (he_init_group(he_dev, 0) != 0) {
+		iounmap(he_dev->membase);
 		return -ENOMEM;
+	}
 
 	for (group = 1; group < HE_NUM_GROUPS; ++group) {
 		he_writel(he_dev, 0x0, G0_RBPS_S + (group * 32));
@@ -1540,6 +1550,7 @@ he_start(struct atm_dev *dev)
 				sizeof(struct he_hsp), &he_dev->hsp_phys);
 	if (he_dev->hsp == NULL) {
 		hprintk("failed to allocate host status page\n");
+		iounmap(he_dev->membase);
 		return -ENOMEM;
 	}
 	memset(he_dev->hsp, 0, sizeof(struct he_hsp));


