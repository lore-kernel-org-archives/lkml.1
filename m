Return-Path: <linux-kernel-owner+w=401wt.eu-S937044AbXHNEem@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937044AbXHNEem (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2007 00:34:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758192AbXHNEe2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Aug 2007 00:34:28 -0400
Received: from n23b.bullet.mail.sp1.yahoo.com ([69.147.64.243]:34839 "HELO
	n23b.bullet.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756013AbXHNEe1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2007 00:34:27 -0400
X-Greylist: delayed 392 seconds by postgrey-1.27 at vger.kernel.org; Tue, 14 Aug 2007 00:34:27 EDT
X-Yahoo-Newman-Property: ymail-5
X-Yahoo-Newman-Id: 708862.93782.bm@rrr4.mail.re1.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=Received:Date:From:Reply-To:Subject:To:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID;
  b=N9TCKU8Ks7qMy8d2H5lI2t1xyTjXOt/9bNws4+ZUBWEsgulGwln3MPHhmI2y5yibsAYAwHI1dJgaJIiBpcqBShJ5PxowMXv6oK0UKHdlf+BszIC4ZrZ6of4nr+Ki+YzRthsbUIVwIWr5Z9Bi3lb2fo0/nlk75tNjQqAep6EiBnc=;
Date: Mon, 13 Aug 2007 21:27:51 -0700 (PDT)
From: Scott Thompson <postfailathushmaildotcom@yahoo.com>
Reply-To: postfail@hushmail.com
Subject: Re: [PATCH ] /drivers/atm ioremap balancing/ returncode check (re-resend)
To: postfail@hushmail.com, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org,
       linux-atm-general@lists.sourceforge.net
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <710028.51582.qm@web44903.mail.sp1.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

 patchset against 2.6.23-rc3.  
 corrects missing ioremap return checks and balancing on iounmap calls..

I attempted to actually reapply the patch that was sent but the following two lines that aren't
changed with this patch exceed the yahoo wordwrap maximum (argh).  I also fixed an if condition in
the first patch that would exceed 80 columns as well.

     fore200e->regs.sba.isr = sbus_ioremap(&sbus_dev->resource[2], 0, SBA200E_ISR_LENGTH, "SBA
ISR");
     fore200e->virt_base    = sbus_ioremap(&sbus_dev->resource[3], 0, SBA200E_RAM_LENGTH, "SBA
RAM");
 
 Warning -- cleanup handler here may miss additional required cleanup as has occurred on other
 portions of ioremap audit. This patch had been submitted previously but hushmail client caused
 wordwrap issues, resending with different mail client.
 
 Signed-off-by: Scott Thompson <postfail <at> hushmail.com>
 ----------------------------------------------------------
diff --git a/drivers/atm/fore200e.c b/drivers/atm/fore200e.c
index 405ee5e..1d47ebe 100644
--- a/drivers/atm/fore200e.c
+++ b/drivers/atm/fore200e.c
@@ -795,8 +795,10 @@ fore200e_sba_map(struct fore200e* fore200e)
     fore200e->regs.sba.isr = sbus_ioremap(&sbus_dev->resource[2], 0, SBA200E_ISR_LENGTH, "SBA
ISR");
     fore200e->virt_base    = sbus_ioremap(&sbus_dev->resource[3], 0, SBA200E_RAM_LENGTH, "SBA
RAM");
 
-    if (fore200e->virt_base == NULL) {
+    if (!fore200e->regs.sba.hcr || !fore200e->regs.sba.bsr
+	|| !fore200e->regs.sba.isr || !fore200e->virt_base) {
 	printk(FORE200E "unable to map RAM of device %s\n", fore200e->name);
+	fore200e_sba_unmap(fore200e);
 	return -EFAULT;
     }
 
diff --git a/drivers/atm/he.c b/drivers/atm/he.c
index d33aba6..5ac9260 100644
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
 	tasklet_init(&he_dev->tasklet, he_tasklet, (unsigned long) he_dev);
@@ -1226,6 +1229,7 @@ he_start(struct atm_dev *dev)
 
 	if (nvpibits != -1 && nvcibits != -1 && nvpibits+nvcibits != HE_MAXCIDBITS) {
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



       
____________________________________________________________________________________
Need a vacation? Get great deals
to amazing places on Yahoo! Travel.
http://travel.yahoo.com/


       
____________________________________________________________________________________
Sick sense of humor? Visit Yahoo! TV's 
Comedy with an Edge to see what's on, when. 
http://tv.yahoo.com/collections/222

