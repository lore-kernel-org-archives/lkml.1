Return-Path: <linux-kernel-owner+w=401wt.eu-S1753986AbYCIPZc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753986AbYCIPZc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Mar 2008 11:25:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752575AbYCIPYl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Mar 2008 11:24:41 -0400
Received: from fg-out-1718.google.com ([72.14.220.156]:14145 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752068AbYCIPYe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Mar 2008 11:24:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=cCLiA8ns8Eh33ACaYFuz289pNYrCmcDJgs9Lx+i2mCbJNmUpEzKlRFgkkSKSVoaoGLmb6+sfRnaGugC6Z/IWwnfuuh6v5Kse+mR5rHXjk6gFQykGeW1E8KAZ81zcZoQDuaf+HEbdE1RSJiXGqzytkxycTVL0l4D52Nvte3S+0vA=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Subject: [PATCH 2/7] ide: do complete DMA setup in ->init_dma method
Date: Sun, 9 Mar 2008 16:29:18 +0100
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803091629.18569.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Make ide_hwif_setup_dma() return an error value.

* Pass 'const struct ide_port_info *d' instead of 'unsigned long dmabase'
  to ->init_dma method and make it return an error value.

* Rename ide_get_or_set_dma_base() to ide_pci_dma_base(),
  change ordering of its arguments and then export it.

* Export ide_pci_set_master().

* Do complete DMA setup inside ->init_dma method and update ->init_dma
  users accordingly.

* Sanitize code for DMA setup in ide_init_port().

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/ide-probe.c    |   21 +++++++++++++++------
 drivers/ide/pci/alim15x3.c |   27 +++++++++++++++++++++------
 drivers/ide/pci/hpt366.c   |   27 +++++++++++++++++++++------
 drivers/ide/setup-pci.c    |   31 ++++++++++++++-----------------
 include/linux/ide.h        |   11 +++++++----
 5 files changed, 78 insertions(+), 39 deletions(-)

Index: b/drivers/ide/ide-probe.c
===================================================================
--- a/drivers/ide/ide-probe.c
+++ b/drivers/ide/ide-probe.c
@@ -1353,9 +1353,6 @@ static void ide_init_port(ide_hwif_t *hw
 	if (d->init_iops)
 		d->init_iops(hwif);
 
-	if ((d->host_flags & IDE_HFLAG_NO_DMA) == 0)
-		ide_hwif_setup_dma(hwif, d);
-
 	if ((!hwif->irq && (d->host_flags & IDE_HFLAG_LEGACY_IRQS)) ||
 	    (d->host_flags & IDE_HFLAG_FORCE_LEGACY_IRQS))
 		hwif->irq = port ? 15 : 14;
@@ -1374,9 +1371,21 @@ static void ide_init_port(ide_hwif_t *hw
 	hwif->mwdma_mask = d->mwdma_mask;
 	hwif->ultra_mask = d->udma_mask;
 
-	/* reset DMA masks only for SFF-style DMA controllers */
-	if ((d->host_flags & IDE_HFLAG_NO_DMA) == 0 && hwif->dma_base == 0)
-		hwif->swdma_mask = hwif->mwdma_mask = hwif->ultra_mask = 0;
+	if ((d->host_flags & IDE_HFLAG_NO_DMA) == 0) {
+		int rc;
+
+		if (d->init_dma)
+			rc = d->init_dma(hwif, d);
+		else
+			rc = ide_hwif_setup_dma(hwif, d);
+
+		if (rc < 0) {
+			printk(KERN_INFO "%s: DMA disabled\n", hwif->name);
+			hwif->swdma_mask = 0;
+			hwif->mwdma_mask = 0;
+			hwif->ultra_mask = 0;
+		}
+	}
 
 	if (d->host_flags & IDE_HFLAG_RQSIZE_256)
 		hwif->rqsize = 256;
Index: b/drivers/ide/pci/alim15x3.c
===================================================================
--- a/drivers/ide/pci/alim15x3.c
+++ b/drivers/ide/pci/alim15x3.c
@@ -723,17 +723,32 @@ static void __devinit init_hwif_ali15x3 
 /**
  *	init_dma_ali15x3	-	set up DMA on ALi15x3
  *	@hwif: IDE interface
- *	@dmabase: DMA interface base PCI address
+ *	@d: IDE port info
  *
- *	Set up the DMA functionality on the ALi 15x3. For the ALi
- *	controllers this is generic so we can let the generic code do
- *	the actual work.
+ *	Set up the DMA functionality on the ALi 15x3.
  */
 
-static void __devinit init_dma_ali15x3 (ide_hwif_t *hwif, unsigned long dmabase)
+static int __devinit init_dma_ali15x3(ide_hwif_t *hwif,
+				      const struct ide_port_info *d)
 {
+	struct pci_dev *dev = to_pci_dev(hwif->dev);
+	unsigned long base = ide_pci_dma_base(hwif, d);
+
+	if (base == 0 || ide_pci_set_master(dev, d->name) < 0)
+		return -1;
+
 	if (!hwif->channel)
-		outb(inb(dmabase + 2) & 0x60, dmabase + 2);
+		outb(inb(base + 2) & 0x60, base + 2);
+
+	printk(KERN_INFO "    %s: BM-DMA at 0x%04lx-0x%04lx\n",
+			 hwif->name, base, base + 7);
+
+	if (ide_allocate_dma_engine(hwif))
+		return -1;
+
+	ide_setup_dma(hwif, base);
+
+	return 0;
 }
 
 static const struct ide_port_ops ali_port_ops = {
Index: b/drivers/ide/pci/hpt366.c
===================================================================
--- a/drivers/ide/pci/hpt366.c
+++ b/drivers/ide/pci/hpt366.c
@@ -1327,14 +1327,17 @@ static void __devinit init_hwif_hpt366(i
 		hwif->dma_lost_irq	= &hpt366_dma_lost_irq;
 }
 
-static void __devinit init_dma_hpt366(ide_hwif_t *hwif, unsigned long dmabase)
+static int __devinit init_dma_hpt366(ide_hwif_t *hwif,
+				     const struct ide_port_info *d)
 {
 	struct pci_dev *dev = to_pci_dev(hwif->dev);
-	u8 masterdma	= 0, slavedma	= 0;
-	u8 dma_new	= 0, dma_old	= 0;
-	unsigned long flags;
+	unsigned long flags, base = ide_pci_dma_base(hwif, d);
+	u8 dma_old, dma_new, masterdma = 0, slavedma = 0;
 
-	dma_old = inb(dmabase + 2);
+	if (base == 0 || ide_pci_set_master(dev, d->name) < 0)
+		return -1;
+
+	dma_old = inb(base + 2);
 
 	local_irq_save(flags);
 
@@ -1345,9 +1348,21 @@ static void __devinit init_dma_hpt366(id
 	if (masterdma & 0x30)	dma_new |= 0x20;
 	if ( slavedma & 0x30)	dma_new |= 0x40;
 	if (dma_new != dma_old)
-		outb(dma_new, dmabase + 2);
+		outb(dma_new, base + 2);
 
 	local_irq_restore(flags);
+
+	printk(KERN_INFO "    %s: BM-DMA at 0x%04lx-0x%04lx\n",
+			 hwif->name, base, base + 7);
+
+	hwif->extra_base = base + (hwif->channel ? 8 : 16);
+
+	if (ide_allocate_dma_engine(hwif))
+		return -1;
+
+	ide_setup_dma(hwif, base);
+
+	return 0;
 }
 
 static void __devinit hpt374_init(struct pci_dev *dev, struct pci_dev *dev2)
Index: b/drivers/ide/setup-pci.c
===================================================================
--- a/drivers/ide/setup-pci.c
+++ b/drivers/ide/setup-pci.c
@@ -72,16 +72,16 @@ static void ide_pci_clear_simplex(unsign
 }
 
 /**
- *	ide_get_or_set_dma_base		-	setup BMIBA
- *	@d: IDE port info
+ *	ide_pci_dma_base	-	setup BMIBA
  *	@hwif: IDE interface
+ *	@d: IDE port info
  *
  *	Fetch the DMA Bus-Master-I/O-Base-Address (BMIBA) from PCI space.
  *	Where a device has a partner that is already in DMA mode we check
  *	and enforce IDE simplex rules.
  */
 
-static unsigned long ide_get_or_set_dma_base(const struct ide_port_info *d, ide_hwif_t *hwif)
+unsigned long ide_pci_dma_base(ide_hwif_t *hwif, const struct ide_port_info *d)
 {
 	struct pci_dev *dev = to_pci_dev(hwif->dev);
 	unsigned long dma_base = 0;
@@ -132,11 +132,12 @@ static unsigned long ide_get_or_set_dma_
 out:
 	return dma_base;
 }
+EXPORT_SYMBOL_GPL(ide_pci_dma_base);
 
 /*
  * Set up BM-DMA capability (PnP BIOS should have done this)
  */
-static int ide_pci_set_master(struct pci_dev *dev, const char *name)
+int ide_pci_set_master(struct pci_dev *dev, const char *name)
 {
 	u16 pcicmd;
 
@@ -155,6 +156,7 @@ static int ide_pci_set_master(struct pci
 
 	return 0;
 }
+EXPORT_SYMBOL_GPL(ide_pci_set_master);
 #endif /* CONFIG_BLK_DEV_IDEDMA_PCI */
 
 void ide_setup_pci_noise(struct pci_dev *dev, const struct ide_port_info *d)
@@ -359,20 +361,17 @@ static ide_hwif_t *ide_hwif_configure(st
  *	state
  */
 
-void ide_hwif_setup_dma(ide_hwif_t *hwif, const struct ide_port_info *d)
+int ide_hwif_setup_dma(ide_hwif_t *hwif, const struct ide_port_info *d)
 {
 	struct pci_dev *dev = to_pci_dev(hwif->dev);
 
 	if ((d->host_flags & IDE_HFLAG_NO_AUTODMA) == 0 ||
 	    ((dev->class >> 8) == PCI_CLASS_STORAGE_IDE &&
 	     (dev->class & 0x80))) {
-		unsigned long base = ide_get_or_set_dma_base(d, hwif);
+		unsigned long base = ide_pci_dma_base(hwif, d);
 
 		if (base == 0 || ide_pci_set_master(dev, d->name) < 0)
-			goto out_disabled;
-
-		if (d->init_dma)
-			d->init_dma(hwif, base);
+			return -1;
 
 		if (hwif->mmio)
 			printk(KERN_INFO "    %s: MMIO-DMA\n", hwif->name);
@@ -382,15 +381,13 @@ void ide_hwif_setup_dma(ide_hwif_t *hwif
 
 		hwif->extra_base = base + (hwif->channel ? 8 : 16);
 
-		if (ide_allocate_dma_engine(hwif) == 0)
-			ide_setup_dma(hwif, base);
-	}
+		if (ide_allocate_dma_engine(hwif))
+			return -1;
 
-	return;
+		ide_setup_dma(hwif, base);
+	}
 
-out_disabled:
-	printk(KERN_INFO "%s: Bus-Master DMA disabled (BIOS) on %s\n",
-			 d->name, pci_name(dev));
+	return 0;
 }
 #endif /* CONFIG_BLK_DEV_IDEDMA_PCI */
 
Index: b/include/linux/ide.h
===================================================================
--- a/include/linux/ide.h
+++ b/include/linux/ide.h
@@ -1009,10 +1009,12 @@ void ide_pci_setup_ports(struct pci_dev 
 void ide_setup_pci_noise(struct pci_dev *, const struct ide_port_info *);
 
 #ifdef CONFIG_BLK_DEV_IDEDMA_PCI
-void ide_hwif_setup_dma(ide_hwif_t *, const struct ide_port_info *);
+int ide_pci_set_master(struct pci_dev *, const char *);
+unsigned long ide_pci_dma_base(ide_hwif_t *, const struct ide_port_info *);
+int ide_hwif_setup_dma(ide_hwif_t *, const struct ide_port_info *);
 #else
-static inline void ide_hwif_setup_dma(ide_hwif_t *hwif,
-				      const struct ide_port_info *d) { }
+static inline int ide_hwif_setup_dma(ide_hwif_t *hwif,
+				     const struct ide_port_info *d) { }
 #endif
 
 extern void default_hwif_iops(ide_hwif_t *);
@@ -1105,7 +1107,8 @@ struct ide_port_info {
 	unsigned int		(*init_chipset)(struct pci_dev *, const char *);
 	void			(*init_iops)(ide_hwif_t *);
 	void                    (*init_hwif)(ide_hwif_t *);
-	void			(*init_dma)(ide_hwif_t *, unsigned long);
+	int			(*init_dma)(ide_hwif_t *,
+					    const struct ide_port_info *);
 
 	const struct ide_port_ops	*port_ops;
 
