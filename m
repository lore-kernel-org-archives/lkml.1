Return-Path: <linux-kernel-owner+w=401wt.eu-S1761942AbYFTVd0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761942AbYFTVd0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2008 17:33:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761398AbYFTVcF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jun 2008 17:32:05 -0400
Received: from fk-out-0910.google.com ([209.85.128.190]:5898 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761380AbYFTVcB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2008 17:32:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=fNLHNnacwq8h839Lx/Z+LMeRlfA6TDA2fjC7BAPOPiOxyTDouiflCLuKUmW1wLSUIh
         Ytw51B23qGlKXx92d2vF2SxnVlbbO5THyFPAYVD4fJ7qri6P+feYoes/nBtz5+IixZyW
         Hic5iIWBUTWd9vS/t07toqedrx6JzvrsdDcBI=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Fri, 20 Jun 2008 23:33:56 +0200
Message-Id: <20080620213356.13202.61560.sendpatchset@localhost.localdomain>
In-Reply-To: <20080620213323.13202.71450.sendpatchset@localhost.localdomain>
References: <20080620213323.13202.71450.sendpatchset@localhost.localdomain>
Subject: [PATCH 05/18] ide: factor out simplex handling from ide_pci_dma_base()
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Factor out simplex handling from ide_pci_dma_base() to
  ide_pci_check_simplex().

* Set hwif->dma_base early in ->init_dma method / ide_hwif_setup_dma()
  and reset it in ide_init_port() if DMA initialization fails.

* Use ->read_sff_dma_status instead of ->INB in ide_pci_dma_base().

There should be no functional changes caused by this patch.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/ide-probe.c    |    1 +
 drivers/ide/pci/alim15x3.c |   12 +++++++++---
 drivers/ide/pci/hpt366.c   |   12 +++++++++---
 drivers/ide/setup-pci.c    |   35 +++++++++++++++++++++++------------
 include/linux/ide.h        |    1 +
 5 files changed, 43 insertions(+), 18 deletions(-)

Index: b/drivers/ide/ide-probe.c
===================================================================
--- a/drivers/ide/ide-probe.c
+++ b/drivers/ide/ide-probe.c
@@ -1369,6 +1369,7 @@ static void ide_init_port(ide_hwif_t *hw
 
 		if (rc < 0) {
 			printk(KERN_INFO "%s: DMA disabled\n", hwif->name);
+			hwif->dma_base = 0;
 			hwif->swdma_mask = 0;
 			hwif->mwdma_mask = 0;
 			hwif->ultra_mask = 0;
Index: b/drivers/ide/pci/alim15x3.c
===================================================================
--- a/drivers/ide/pci/alim15x3.c
+++ b/drivers/ide/pci/alim15x3.c
@@ -471,7 +471,15 @@ static int __devinit init_dma_ali15x3(id
 	struct pci_dev *dev = to_pci_dev(hwif->dev);
 	unsigned long base = ide_pci_dma_base(hwif, d);
 
-	if (base == 0 || ide_pci_set_master(dev, d->name) < 0)
+	if (base == 0)
+		return -1;
+
+	hwif->dma_base = base;
+
+	if (ide_pci_check_simplex(hwif, d) < 0)
+		return -1;
+
+	if (ide_pci_set_master(dev, d->name) < 0)
 		return -1;
 
 	if (!hwif->channel)
@@ -483,8 +491,6 @@ static int __devinit init_dma_ali15x3(id
 	if (ide_allocate_dma_engine(hwif))
 		return -1;
 
-	hwif->dma_base = base;
-
 	hwif->dma_ops = &sff_dma_ops;
 
 	return 0;
Index: b/drivers/ide/pci/hpt366.c
===================================================================
--- a/drivers/ide/pci/hpt366.c
+++ b/drivers/ide/pci/hpt366.c
@@ -1320,7 +1320,15 @@ static int __devinit init_dma_hpt366(ide
 	unsigned long flags, base = ide_pci_dma_base(hwif, d);
 	u8 dma_old, dma_new, masterdma = 0, slavedma = 0;
 
-	if (base == 0 || ide_pci_set_master(dev, d->name) < 0)
+	if (base == 0)
+		return -1;
+
+	hwif->dma_base = base;
+
+	if (ide_pci_check_simplex(hwif, d) < 0)
+		return -1;
+
+	if (ide_pci_set_master(dev, d->name) < 0)
 		return -1;
 
 	dma_old = inb(base + 2);
@@ -1346,8 +1354,6 @@ static int __devinit init_dma_hpt366(ide
 	if (ide_allocate_dma_engine(hwif))
 		return -1;
 
-	hwif->dma_base = base;
-
 	hwif->dma_ops = &sff_dma_ops;
 
 	return 0;
Index: b/drivers/ide/setup-pci.c
===================================================================
--- a/drivers/ide/setup-pci.c
+++ b/drivers/ide/setup-pci.c
@@ -72,15 +72,12 @@ static void ide_pci_clear_simplex(unsign
  *	@d: IDE port info
  *
  *	Fetch the DMA Bus-Master-I/O-Base-Address (BMIBA) from PCI space.
- *	Where a device has a partner that is already in DMA mode we check
- *	and enforce IDE simplex rules.
  */
 
 unsigned long ide_pci_dma_base(ide_hwif_t *hwif, const struct ide_port_info *d)
 {
 	struct pci_dev *dev = to_pci_dev(hwif->dev);
 	unsigned long dma_base = 0;
-	u8 dma_stat = 0;
 
 	if (hwif->host_flags & IDE_HFLAG_MMIO)
 		return hwif->dma_base;
@@ -101,11 +98,19 @@ unsigned long ide_pci_dma_base(ide_hwif_
 	if (hwif->channel)
 		dma_base += 8;
 
-	if (d->host_flags & IDE_HFLAG_CS5520)
+	return dma_base;
+}
+EXPORT_SYMBOL_GPL(ide_pci_dma_base);
+
+int ide_pci_check_simplex(ide_hwif_t *hwif, const struct ide_port_info *d)
+{
+	u8 dma_stat;
+
+	if (d->host_flags & (IDE_HFLAG_MMIO | IDE_HFLAG_CS5520))
 		goto out;
 
 	if (d->host_flags & IDE_HFLAG_CLEAR_SIMPLEX) {
-		ide_pci_clear_simplex(dma_base, d->name);
+		ide_pci_clear_simplex(hwif->dma_base, d->name);
 		goto out;
 	}
 
@@ -119,15 +124,15 @@ unsigned long ide_pci_dma_base(ide_hwif_
 	 * we tune the drive then try to grab DMA ownership if we want to be
 	 * the DMA end.  This has to be become dynamic to handle hot-plug.
 	 */
-	dma_stat = hwif->INB(dma_base + 2);
+	dma_stat = hwif->read_sff_dma_status(hwif);
 	if ((dma_stat & 0x80) && hwif->mate && hwif->mate->dma_base) {
 		printk(KERN_INFO "%s: simplex device: DMA disabled\n", d->name);
-		dma_base = 0;
+		return -1;
 	}
 out:
-	return dma_base;
+	return 0;
 }
-EXPORT_SYMBOL_GPL(ide_pci_dma_base);
+EXPORT_SYMBOL_GPL(ide_pci_check_simplex);
 
 /*
  * Set up BM-DMA capability (PnP BIOS should have done this)
@@ -362,7 +367,15 @@ int ide_hwif_setup_dma(ide_hwif_t *hwif,
 	     (dev->class & 0x80))) {
 		unsigned long base = ide_pci_dma_base(hwif, d);
 
-		if (base == 0 || ide_pci_set_master(dev, d->name) < 0)
+		if (base == 0)
+			return -1;
+
+		hwif->dma_base = base;
+
+		if (ide_pci_check_simplex(hwif, d) < 0)
+			return -1;
+
+		if (ide_pci_set_master(dev, d->name) < 0)
 			return -1;
 
 		if (hwif->host_flags & IDE_HFLAG_MMIO)
@@ -376,8 +389,6 @@ int ide_hwif_setup_dma(ide_hwif_t *hwif,
 		if (ide_allocate_dma_engine(hwif))
 			return -1;
 
-		hwif->dma_base = base;
-
 		hwif->dma_ops = &sff_dma_ops;
 	}
 
Index: b/include/linux/ide.h
===================================================================
--- a/include/linux/ide.h
+++ b/include/linux/ide.h
@@ -994,6 +994,7 @@ void ide_setup_pci_noise(struct pci_dev 
 int ide_pci_set_master(struct pci_dev *, const char *);
 unsigned long ide_pci_dma_base(ide_hwif_t *, const struct ide_port_info *);
 extern const struct ide_dma_ops sff_dma_ops;
+int ide_pci_check_simplex(ide_hwif_t *, const struct ide_port_info *);
 int ide_hwif_setup_dma(ide_hwif_t *, const struct ide_port_info *);
 #else
 static inline int ide_hwif_setup_dma(ide_hwif_t *hwif,
