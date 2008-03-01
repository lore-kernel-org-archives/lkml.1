Return-Path: <linux-kernel-owner+w=401wt.eu-S1762754AbYCAUr3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762754AbYCAUr3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Mar 2008 15:47:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760705AbYCAUnx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Mar 2008 15:43:53 -0500
Received: from ug-out-1314.google.com ([66.249.92.171]:28247 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760295AbYCAUnm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Mar 2008 15:43:42 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=eWR/6inRemnSUs1zjPtjCo8+Xf15uDKiHY87LJSsACHkI5AA6IHSXaZEweUJwQQBDx05ImKh+ZyAZUQsiiFJoTnb+LhOdu4XnxJChWDL67hHTeL0Qz3s/oNjCBn/BCuWnMGA7e3QeIy/q5flCgBybU/ziLlSz4vB1eDIxRPEhKo=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Subject: [PATCH 7/9] ide: manage resources for PCI devices in ide_pci_enable()
Date: Sat, 1 Mar 2008 21:51:32 +0100
User-Agent: KMail/1.9.6 (enterprise 0.20071204.744707)
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803012151.33070.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Reserve PCI BARs 0-3 (0-1 for single port controllers) in
  ide_pci_enable() and remove ide_hwif_request_regions() call
  from ide_device_add_all() (also cleanup resource management
  in scc_pata host driver).

* Fix handling of PCI BAR 4 in ide_pci_enable(), then cleanup
  ide_iomio_dma() (+ init_hwif_trm290() in trm290 host driver)
  and remove ide_release[_iomio]_dma().

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/ide-dma.c      |   43 +++----------------------------------------
 drivers/ide/ide-probe.c    |    6 ------
 drivers/ide/ide.c          |    2 +-
 drivers/ide/pci/scc_pata.c |   27 ++++-----------------------
 drivers/ide/pci/trm290.c   |    5 -----
 drivers/ide/setup-pci.c    |   22 +++++++++++++++-------
 include/linux/ide.h        |    4 ++--
 7 files changed, 25 insertions(+), 84 deletions(-)

Index: b/drivers/ide/ide-dma.c
===================================================================
--- a/drivers/ide/ide-dma.c
+++ b/drivers/ide/ide-dma.c
@@ -810,7 +810,7 @@ void ide_dma_timeout (ide_drive_t *drive
 
 EXPORT_SYMBOL(ide_dma_timeout);
 
-static void ide_release_dma_engine(ide_hwif_t *hwif)
+void ide_release_dma_engine(ide_hwif_t *hwif)
 {
 	if (hwif->dmatable_cpu) {
 		struct pci_dev *pdev = to_pci_dev(hwif->dev);
@@ -821,27 +821,6 @@ static void ide_release_dma_engine(ide_h
 	}
 }
 
-static int ide_release_iomio_dma(ide_hwif_t *hwif)
-{
-	release_region(hwif->dma_base, 8);
-	if (hwif->extra_ports)
-		release_region(hwif->extra_base, hwif->extra_ports);
-	return 1;
-}
-
-/*
- * Needed for allowing full modular support of ide-driver
- */
-int ide_release_dma(ide_hwif_t *hwif)
-{
-	ide_release_dma_engine(hwif);
-
-	if (hwif->mmio)
-		return 1;
-	else
-		return ide_release_iomio_dma(hwif);
-}
-
 static int ide_allocate_dma_engine(ide_hwif_t *hwif)
 {
 	struct pci_dev *pdev = to_pci_dev(hwif->dev);
@@ -871,25 +850,9 @@ static int ide_iomio_dma(ide_hwif_t *hwi
 	printk(KERN_INFO "    %s: BM-DMA at 0x%04lx-0x%04lx",
 	       hwif->name, base, base + 7);
 
-	if (!request_region(base, 8, hwif->name)) {
-		printk(" -- Error, ports in use.\n");
-		return 1;
-	}
-
-	if (hwif->cds->extra) {
+	if (hwif->cds->extra)
 		hwif->extra_base = base + (hwif->channel ? 8 : 16);
 
-		if (!hwif->mate || !hwif->mate->extra_ports) {
-			if (!request_region(hwif->extra_base,
-					    hwif->cds->extra, hwif->cds->name)) {
-				printk(" -- Error, extra ports in use.\n");
-				release_region(base, 8);
-				return 1;
-			}
-			hwif->extra_ports = hwif->cds->extra;
-		}
-	}
-
 	return 0;
 }
 
@@ -909,7 +872,7 @@ void ide_setup_dma(ide_hwif_t *hwif, uns
 		return;
 
 	if (ide_allocate_dma_engine(hwif)) {
-		ide_release_dma(hwif);
+		ide_release_dma_engine(hwif);
 		return;
 	}
 
Index: b/drivers/ide/ide-probe.c
===================================================================
--- a/drivers/ide/ide-probe.c
+++ b/drivers/ide/ide-probe.c
@@ -1526,12 +1526,6 @@ int ide_device_add_all(u8 *idx, const st
 
 		hwif = &ide_hwifs[idx[i]];
 
-		if (ide_hwif_request_regions(hwif)) {
-			printk(KERN_ERR "%s: ports already in use, "
-					"skipping probe\n", hwif->name);
-			continue;
-		}
-
 		if (ide_probe_port(hwif) == 0)
 			hwif->present = 1;
 
Index: b/drivers/ide/ide.c
===================================================================
--- a/drivers/ide/ide.c
+++ b/drivers/ide/ide.c
@@ -415,7 +415,7 @@ void ide_unregister(unsigned int index)
 	spin_lock_irq(&ide_lock);
 
 	if (hwif->dma_base)
-		(void)ide_release_dma(hwif);
+		ide_release_dma_engine(hwif);
 
 	/* restore hwif data to pristine status */
 	ide_init_port_data(hwif, index);
Index: b/drivers/ide/pci/scc_pata.c
===================================================================
--- a/drivers/ide/pci/scc_pata.c
+++ b/drivers/ide/pci/scc_pata.c
@@ -492,21 +492,11 @@ static int setup_mmio_scc (struct pci_de
 	if (i >= MAX_HWIFS)
 		return -ENOMEM;
 
-	if (!request_mem_region(ctl_base, ctl_size, name)) {
-		printk(KERN_WARNING "%s: IDE controller MMIO ports not available.\n", SCC_PATA_NAME);
-		goto fail_0;
-	}
-
-	if (!request_mem_region(dma_base, dma_size, name)) {
-		printk(KERN_WARNING "%s: IDE controller MMIO ports not available.\n", SCC_PATA_NAME);
-		goto fail_1;
-	}
-
 	if ((ctl_addr = ioremap(ctl_base, ctl_size)) == NULL)
-		goto fail_2;
+		goto fail_0;
 
 	if ((dma_addr = ioremap(dma_base, dma_size)) == NULL)
-		goto fail_3;
+		goto fail_1;
 
 	pci_set_master(dev);
 	scc_ports[i].ctl = (unsigned long)ctl_addr;
@@ -515,12 +505,8 @@ static int setup_mmio_scc (struct pci_de
 
 	return 1;
 
- fail_3:
-	iounmap(ctl_addr);
- fail_2:
-	release_mem_region(dma_base, dma_size);
  fail_1:
-	release_mem_region(ctl_base, ctl_size);
+	iounmap(ctl_addr);
  fail_0:
 	return -ENOMEM;
 }
@@ -729,10 +715,6 @@ static void __devexit scc_remove(struct 
 {
 	struct scc_ports *ports = pci_get_drvdata(dev);
 	ide_hwif_t *hwif = ports->hwif;
-	unsigned long ctl_base = pci_resource_start(dev, 0);
-	unsigned long dma_base = pci_resource_start(dev, 1);
-	unsigned long ctl_size = pci_resource_len(dev, 0);
-	unsigned long dma_size = pci_resource_len(dev, 1);
 
 	if (hwif->dmatable_cpu) {
 		pci_free_consistent(dev, PRD_ENTRIES * PRD_BYTES,
@@ -745,8 +727,7 @@ static void __devexit scc_remove(struct 
 	hwif->chipset = ide_unknown;
 	iounmap((void*)ports->dma);
 	iounmap((void*)ports->ctl);
-	release_mem_region(dma_base, dma_size);
-	release_mem_region(ctl_base, ctl_size);
+	pci_release_selected_regions(dev, (1 << 2) - 1);
 	memset(ports, 0, sizeof(*ports));
 }
 
Index: b/drivers/ide/pci/trm290.c
===================================================================
--- a/drivers/ide/pci/trm290.c
+++ b/drivers/ide/pci/trm290.c
@@ -257,11 +257,6 @@ static void __devinit init_hwif_trm290(i
 	printk(KERN_INFO "    %s: BM-DMA at 0x%04lx-0x%04lx",
 	       hwif->name, hwif->dma_base, hwif->dma_base + 3);
 
-	if (!request_region(hwif->dma_base, 4, hwif->name)) {
-		printk(KERN_CONT " -- Error, ports in use.\n");
-		return;
-	}
-
 	hwif->dmatable_cpu = pci_alloc_consistent(dev, PRD_ENTRIES * PRD_BYTES,
 						  &hwif->dmatable_dma);
 	if (!hwif->dmatable_cpu) {
Index: b/drivers/ide/setup-pci.c
===================================================================
--- a/drivers/ide/setup-pci.c
+++ b/drivers/ide/setup-pci.c
@@ -158,7 +158,7 @@ EXPORT_SYMBOL_GPL(ide_setup_pci_noise);
 
 static int ide_pci_enable(struct pci_dev *dev, const struct ide_port_info *d)
 {
-	int ret;
+	int ret, bars;
 
 	if (pci_enable_device(dev)) {
 		ret = pci_enable_device_io(dev);
@@ -181,13 +181,21 @@ static int ide_pci_enable(struct pci_dev
 		goto out;
 	}
 
-	/* FIXME: Temporary - until we put in the hotplug interface logic
-	   Check that the bits we want are not in use by someone else. */
-	ret = pci_request_region(dev, 4, "ide_tmp");
-	if (ret < 0)
-		goto out;
+	if (d->host_flags & IDE_HFLAG_SINGLE)
+		bars = (1 << 2) - 1;
+	else
+		bars = (1 << 4) - 1;
+
+	if ((d->host_flags & IDE_HFLAG_NO_DMA) == 0) {
+		if (d->host_flags & IDE_HFLAG_CS5520)
+			bars |= (1 << 2);
+		else
+			bars |= (1 << 4);
+	}
 
-	pci_release_region(dev, 4);
+	ret = pci_request_selected_regions(dev, bars, d->name);
+	if (ret < 0)
+		printk(KERN_ERR "%s: can't reserve resources\n", d->name);
 out:
 	return ret;
 }
Index: b/include/linux/ide.h
===================================================================
--- a/include/linux/ide.h
+++ b/include/linux/ide.h
@@ -1160,7 +1160,7 @@ void ide_destroy_dmatable(ide_drive_t *)
 
 #ifdef CONFIG_BLK_DEV_IDEDMA_SFF
 extern int ide_build_dmatable(ide_drive_t *, struct request *);
-extern int ide_release_dma(ide_hwif_t *);
+extern void ide_release_dma_engine(ide_hwif_t *);
 extern void ide_setup_dma(ide_hwif_t *, unsigned long);
 
 void ide_dma_host_set(ide_drive_t *, int);
@@ -1184,7 +1184,7 @@ static inline void ide_check_dma_crc(ide
 #endif /* CONFIG_BLK_DEV_IDEDMA */
 
 #ifndef CONFIG_BLK_DEV_IDEDMA_SFF
-static inline void ide_release_dma(ide_hwif_t *drive) {;}
+static inline void ide_release_dma_engine(ide_hwif_t *hwif) { ; }
 #endif
 
 #ifdef CONFIG_BLK_DEV_IDEACPI
