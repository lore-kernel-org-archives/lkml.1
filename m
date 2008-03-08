Return-Path: <linux-kernel-owner+w=401wt.eu-S1756847AbYCHVX5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756847AbYCHVX5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Mar 2008 16:23:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753926AbYCHVVt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Mar 2008 16:21:49 -0500
Received: from nf-out-0910.google.com ([64.233.182.191]:12768 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752419AbYCHVVn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Mar 2008 16:21:43 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=rndDcTIKpr3ov80/STrog5tzniv0fv/HX+pdfq8xqjaarstXqLA/dmH7c+tQ1BTsX0bwGWh37E/nXpFGVBHd/wnaA1lVE3hu6J5tYbz9L8UHk8LHuYik21kwpkL3ZB4noLhCT12FgjxqaOU7cj+cbxw9ch9ALh6gZ3us5ubjmd8=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Subject: [PATCH 7/7] ide: cleanup ide_setup_dma()
Date: Sat, 8 Mar 2008 22:34:01 +0100
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803082234.01367.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* There is no need to call ide_release_dma_engine().

* Move the code up to (and including) ide_allocate_dma_engine()
  call to the callers of ide_setup_dma().

There should be no functional changes caused by this patch.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/arm/palm_bk3710.c |    5 ++++-
 drivers/ide/ide-dma.c         |   13 -------------
 drivers/ide/setup-pci.c       |   17 +++++++++++++----
 3 files changed, 17 insertions(+), 18 deletions(-)

Index: b/drivers/ide/arm/palm_bk3710.c
===================================================================
--- a/drivers/ide/arm/palm_bk3710.c
+++ b/drivers/ide/arm/palm_bk3710.c
@@ -392,7 +392,10 @@ static int __devinit palm_bk3710_probe(s
 	hwif->mmio = 1;
 	default_hwif_mmiops(hwif);
 
-	ide_setup_dma(hwif, mem->start);
+	printk(KERN_INFO "    %s: MMIO-DMA\n", hwif->name);
+
+	if (ide_allocate_dma_engine(hwif) == 0)
+		ide_setup_dma(hwif, mem->start);
 
 	idx[0] = i;
 
Index: b/drivers/ide/ide-dma.c
===================================================================
--- a/drivers/ide/ide-dma.c
+++ b/drivers/ide/ide-dma.c
@@ -841,19 +841,6 @@ EXPORT_SYMBOL_GPL(ide_allocate_dma_engin
 
 void ide_setup_dma(ide_hwif_t *hwif, unsigned long base)
 {
-	if (hwif->mmio)
-		printk(KERN_INFO "    %s: MMIO-DMA\n", hwif->name);
-	else
-		printk(KERN_INFO "    %s: BM-DMA at 0x%04lx-0x%04lx\n",
-				 hwif->name, base, base + 7);
-
-	hwif->extra_base = base + (hwif->channel ? 8 : 16);
-
-	if (ide_allocate_dma_engine(hwif)) {
-		ide_release_dma_engine(hwif);
-		return;
-	}
-
 	hwif->dma_base = base;
 
 	if (!hwif->dma_command)
Index: b/drivers/ide/setup-pci.c
===================================================================
--- a/drivers/ide/setup-pci.c
+++ b/drivers/ide/setup-pci.c
@@ -366,15 +366,24 @@ void ide_hwif_setup_dma(ide_hwif_t *hwif
 	if ((d->host_flags & IDE_HFLAG_NO_AUTODMA) == 0 ||
 	    ((dev->class >> 8) == PCI_CLASS_STORAGE_IDE &&
 	     (dev->class & 0x80))) {
-		unsigned long dma_base = ide_get_or_set_dma_base(d, hwif);
+		unsigned long base = ide_get_or_set_dma_base(d, hwif);
 
-		if (dma_base == 0 || ide_pci_set_master(dev, d->name) < 0)
+		if (base == 0 || ide_pci_set_master(dev, d->name) < 0)
 			goto out_disabled;
 
 		if (d->init_dma)
-			d->init_dma(hwif, dma_base);
+			d->init_dma(hwif, base);
 
-		ide_setup_dma(hwif, dma_base);
+		if (hwif->mmio)
+			printk(KERN_INFO "    %s: MMIO-DMA\n", hwif->name);
+		else
+			printk(KERN_INFO "    %s: BM-DMA at 0x%04lx-0x%04lx\n",
+					 hwif->name, base, base + 7);
+
+		hwif->extra_base = base + (hwif->channel ? 8 : 16);
+
+		if (ide_allocate_dma_engine(hwif) == 0)
+			ide_setup_dma(hwif, base);
 	}
 
 	return;
