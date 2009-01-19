Return-Path: <linux-kernel-owner+w=401wt.eu-S1757902AbZASOSO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757902AbZASOSO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2009 09:18:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752517AbZASOOg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Jan 2009 09:14:36 -0500
Received: from mail-bw0-f21.google.com ([209.85.218.21]:49200 "EHLO
	mail-bw0-f21.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754620AbZASOOd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2009 09:14:33 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=usbDGmaDlLSz7kMgvIvmr1bkin4inbNE7v5zwD85OMpabTeExjueB8ViogLgxBBtzh
         YAZSrJ8Vw/f2c5N2DMNigLertadSlr4RT6TQbPi75b+tPbpozcrdrcVpxCdp1S8Vs5kS
         Kg+v8Fv/pZC7J6rXYGF5VmW57Yg/XXRnVuX3g=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Mon, 19 Jan 2009 15:14:57 +0100
Message-Id: <20090119141457.27613.26363.sendpatchset@localhost.localdomain>
In-Reply-To: <20090119141330.27613.34546.sendpatchset@localhost.localdomain>
References: <20090119141330.27613.34546.sendpatchset@localhost.localdomain>
Subject: [PATCH 10/12] ide: remove no longer needed IRQ fallback code from hwif_init()
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] ide: remove no longer needed IRQ fallback code from hwif_init()

Then remove no longer used __ide_default_irq().

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/ide-probe.c |   30 ++++--------------------------
 include/linux/ide.h     |   15 ---------------
 2 files changed, 4 insertions(+), 41 deletions(-)

Index: b/drivers/ide/ide-probe.c
===================================================================
--- a/drivers/ide/ide-probe.c
+++ b/drivers/ide/ide-probe.c
@@ -1056,14 +1056,9 @@ static void drive_release_dev (struct de
 
 static int hwif_init(ide_hwif_t *hwif)
 {
-	int old_irq;
-
 	if (!hwif->irq) {
-		hwif->irq = __ide_default_irq(hwif->io_ports.data_addr);
-		if (!hwif->irq) {
-			printk(KERN_ERR "%s: disabled, no IRQ\n", hwif->name);
-			return 0;
-		}
+		printk(KERN_ERR "%s: disabled, no IRQ\n", hwif->name);
+		return 0;
 	}
 
 	if (register_blkdev(hwif->major, hwif->name))
@@ -1081,29 +1076,12 @@ static int hwif_init(ide_hwif_t *hwif)
 
 	sg_init_table(hwif->sg_table, hwif->sg_max_nents);
 	
-	if (init_irq(hwif) == 0)
-		goto done;
-
-	old_irq = hwif->irq;
-	/*
-	 *	It failed to initialise. Find the default IRQ for 
-	 *	this port and try that.
-	 */
-	hwif->irq = __ide_default_irq(hwif->io_ports.data_addr);
-	if (!hwif->irq) {
-		printk(KERN_ERR "%s: disabled, unable to get IRQ %d\n",
-			hwif->name, old_irq);
-		goto out;
-	}
 	if (init_irq(hwif)) {
-		printk(KERN_ERR "%s: probed IRQ %d and default IRQ %d failed\n",
-			hwif->name, old_irq, hwif->irq);
+		printk(KERN_ERR "%s: disabled, unable to get IRQ %d\n",
+			hwif->name, hwif->irq);
 		goto out;
 	}
-	printk(KERN_WARNING "%s: probed IRQ %d failed, using default\n",
-		hwif->name, hwif->irq);
 
-done:
 	blk_register_region(MKDEV(hwif->major, 0), MAX_DRIVES << PARTN_BITS,
 			    THIS_MODULE, ata_probe, ata_lock, hwif);
 	return 1;
Index: b/include/linux/ide.h
===================================================================
--- a/include/linux/ide.h
+++ b/include/linux/ide.h
@@ -193,21 +193,6 @@ static inline void ide_std_init_ports(hw
 	hw->io_ports.ctl_addr = ctl_addr;
 }
 
-/* for IDE PCI controllers in legacy mode, temporary */
-static inline int __ide_default_irq(unsigned long base)
-{
-	switch (base) {
-#ifdef CONFIG_IA64
-	case 0x1f0: return isa_irq_to_vector(14);
-	case 0x170: return isa_irq_to_vector(15);
-#else
-	case 0x1f0: return 14;
-	case 0x170: return 15;
-#endif
-	}
-	return 0;
-}
-
 #if defined(CONFIG_ARM) || defined(CONFIG_FRV) || defined(CONFIG_M68K) || \
     defined(CONFIG_MIPS) || defined(CONFIG_MN10300) || defined(CONFIG_PARISC) \
     || defined(CONFIG_PPC) || defined(CONFIG_SPARC) || defined(CONFIG_SPARC64)
