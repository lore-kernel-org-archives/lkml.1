Return-Path: <linux-kernel-owner+w=401wt.eu-S1755650AbYCHVWr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755650AbYCHVWr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Mar 2008 16:22:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753177AbYCHVVn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Mar 2008 16:21:43 -0500
Received: from gv-out-0910.google.com ([216.239.58.186]:48864 "EHLO
	gv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752628AbYCHVVj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Mar 2008 16:21:39 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=Xmuj6Ed1soDw6e8BBINo7jwJczINDszvWNqNgU3EmgTwFnB9PjR0+KDU/Q8ATbB0abgzryGgwRrZc1i/SbuBibO0ThHDgNdFetE1kWfT2ZaPRYs2xvKCggyNRB2agZdp6ZUlu59OdKf14Yr/H26sTSYLcAbr9zY8LBamvq5N6xE=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Subject: [PATCH 5/7] ide: export ide_allocate_dma_engine()
Date: Sat, 8 Mar 2008 22:32:35 +0100
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803082232.35296.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Export ide_allocate_dma_engine() and use it in trm290 host driver.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/ide-dma.c    |    3 ++-
 drivers/ide/pci/trm290.c |    9 ++-------
 include/linux/ide.h      |    3 ++-
 3 files changed, 6 insertions(+), 9 deletions(-)

Index: b/drivers/ide/ide-dma.c
===================================================================
--- a/drivers/ide/ide-dma.c
+++ b/drivers/ide/ide-dma.c
@@ -821,7 +821,7 @@ void ide_release_dma_engine(ide_hwif_t *
 	}
 }
 
-static int ide_allocate_dma_engine(ide_hwif_t *hwif)
+int ide_allocate_dma_engine(ide_hwif_t *hwif)
 {
 	struct pci_dev *pdev = to_pci_dev(hwif->dev);
 
@@ -837,6 +837,7 @@ static int ide_allocate_dma_engine(ide_h
 
 	return 1;
 }
+EXPORT_SYMBOL_GPL(ide_allocate_dma_engine);
 
 void ide_setup_dma(ide_hwif_t *hwif, unsigned long base)
 {
Index: b/drivers/ide/pci/trm290.c
===================================================================
--- a/drivers/ide/pci/trm290.c
+++ b/drivers/ide/pci/trm290.c
@@ -254,16 +254,11 @@ static void __devinit init_hwif_trm290(i
 	hwif->config_data = cfg_base;
 	hwif->dma_base = (cfg_base + 4) ^ (hwif->channel ? 0x80 : 0);
 
-	printk(KERN_INFO "    %s: BM-DMA at 0x%04lx-0x%04lx",
+	printk(KERN_INFO "    %s: BM-DMA at 0x%04lx-0x%04lx\n",
 	       hwif->name, hwif->dma_base, hwif->dma_base + 3);
 
-	hwif->dmatable_cpu = pci_alloc_consistent(dev, PRD_ENTRIES * PRD_BYTES,
-						  &hwif->dmatable_dma);
-	if (!hwif->dmatable_cpu) {
-		printk(KERN_CONT " -- Error, unable to allocate DMA table.\n");
+	if (ide_allocate_dma_engine(hwif))
 		return;
-	}
-	printk(KERN_CONT "\n");
 
 	local_irq_save(flags);
 	/* put config reg into first byte of hwif->select_data */
Index: b/include/linux/ide.h
===================================================================
--- a/include/linux/ide.h
+++ b/include/linux/ide.h
@@ -1157,7 +1157,8 @@ void ide_destroy_dmatable(ide_drive_t *)
 
 #ifdef CONFIG_BLK_DEV_IDEDMA_SFF
 extern int ide_build_dmatable(ide_drive_t *, struct request *);
-extern void ide_release_dma_engine(ide_hwif_t *);
+int ide_allocate_dma_engine(ide_hwif_t *);
+void ide_release_dma_engine(ide_hwif_t *);
 extern void ide_setup_dma(ide_hwif_t *, unsigned long);
 
 void ide_dma_host_set(ide_drive_t *, int);
