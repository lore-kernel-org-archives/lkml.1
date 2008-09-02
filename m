Return-Path: <linux-kernel-owner+w=401wt.eu-S1752495AbYIBTuu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752495AbYIBTuu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2008 15:50:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754244AbYIBTtn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Sep 2008 15:49:43 -0400
Received: from ug-out-1314.google.com ([66.249.92.171]:11982 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754151AbYIBTtk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2008 15:49:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=tXWgqBBhWwkUptfWLsotBlzEgngRTYNz3+nPqZniWNwRLYwFx15WnLwjkDGqT6CCZd
         gGP9SQM7oUO+/DSu2zgDVzpp1fvDDsT4G8ddShBpe1rJLFoj9Eh9G4y0rGTeVIgCN5UO
         wKVxCw6gydx9CSrNdABKyE0uCRDQBVO+sJek4=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Tue, 02 Sep 2008 21:47:33 +0200
Message-Id: <20080902194733.14564.4975.sendpatchset@localhost.localdomain>
In-Reply-To: <20080902194711.14564.63625.sendpatchset@localhost.localdomain>
References: <20080902194711.14564.63625.sendpatchset@localhost.localdomain>
Subject: [PATCH 4/8] ide: switch to DMA-mapping API part 2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Follow-up to commit 5c05ff68b9a9b40a9be949497e0aa980185565cf
("ide: switch to DMA-mapping API"):

* pci_{alloc,free}_consistent() -> dma_{alloc,free}_coherent()
  in ide_{allocate,release}_dma_engine().

* Add ->prd_max_nents and ->prd_ent_size fields to ide_hwif_t
  (+ set default values in ide_allocate_dma_engine()).

* Make ide_{allocate,release}_dma_engine() available also
  for CONFIG_BLK_DEV_IDEDMA_SFF=n.  Then convert au1xxx-ide.c,
  scc_pata.c and sgiioc4.c to use them.

* Add missing ->init_dma method to scc_pata.

This patch also fixes:
- ->dmatable_cpu leak for au1xxx-ide
- too early realease of ->dmatable_cpu for scc_pata
- wrong amount of ->dmatable_cpu memory being freed for sgiioc4

While at it:
- remove superfluous ->dma_base check from ide_unregister()
- return -ENOMEM on error in ide_release_dma_engine()
- beautify error message in ide_release_dma_engine()

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/ide-dma.c         |   35 +++++++++++++++++++++--------------
 drivers/ide/ide.c             |    3 +--
 drivers/ide/mips/au1xxx-ide.c |    7 +++----
 drivers/ide/pci/scc_pata.c    |   14 +++++++-------
 drivers/ide/pci/sgiioc4.c     |   15 +++++++--------
 include/linux/ide.h           |   17 ++++++++++-------
 6 files changed, 49 insertions(+), 42 deletions(-)

Index: b/drivers/ide/ide-dma.c
===================================================================
--- a/drivers/ide/ide-dma.c
+++ b/drivers/ide/ide-dma.c
@@ -844,36 +844,43 @@ void ide_dma_timeout(ide_drive_t *drive)
 }
 EXPORT_SYMBOL_GPL(ide_dma_timeout);
 
-#ifdef CONFIG_BLK_DEV_IDEDMA_SFF
 void ide_release_dma_engine(ide_hwif_t *hwif)
 {
 	if (hwif->dmatable_cpu) {
-		struct pci_dev *pdev = to_pci_dev(hwif->dev);
+		int prd_size = hwif->prd_max_nents * hwif->prd_ent_size;
 
-		pci_free_consistent(pdev, PRD_ENTRIES * PRD_BYTES,
-				    hwif->dmatable_cpu, hwif->dmatable_dma);
+		dma_free_coherent(hwif->dev, prd_size,
+				  hwif->dmatable_cpu, hwif->dmatable_dma);
 		hwif->dmatable_cpu = NULL;
 	}
 }
+EXPORT_SYMBOL_GPL(ide_release_dma_engine);
 
 int ide_allocate_dma_engine(ide_hwif_t *hwif)
 {
-	struct pci_dev *pdev = to_pci_dev(hwif->dev);
-
-	hwif->dmatable_cpu = pci_alloc_consistent(pdev,
-						  PRD_ENTRIES * PRD_BYTES,
-						  &hwif->dmatable_dma);
-
-	if (hwif->dmatable_cpu)
-		return 0;
+	int prd_size;
 
-	printk(KERN_ERR "%s: -- Error, unable to allocate DMA table.\n",
+	if (hwif->prd_max_nents == 0)
+		hwif->prd_max_nents = PRD_ENTRIES;
+	if (hwif->prd_ent_size == 0)
+		hwif->prd_ent_size = PRD_BYTES;
+
+	prd_size = hwif->prd_max_nents * hwif->prd_ent_size;
+
+	hwif->dmatable_cpu = dma_alloc_coherent(hwif->dev, prd_size,
+						&hwif->dmatable_dma,
+						GFP_ATOMIC);
+	if (hwif->dmatable_cpu == NULL) {
+		printk(KERN_ERR "%s: unable to allocate PRD table\n",
 			hwif->name);
+		return -ENOMEM;
+	}
 
-	return 1;
+	return 0;
 }
 EXPORT_SYMBOL_GPL(ide_allocate_dma_engine);
 
+#ifdef CONFIG_BLK_DEV_IDEDMA_SFF
 const struct ide_dma_ops sff_dma_ops = {
 	.dma_host_set		= ide_dma_host_set,
 	.dma_setup		= ide_dma_setup,
Index: b/drivers/ide/ide.c
===================================================================
--- a/drivers/ide/ide.c
+++ b/drivers/ide/ide.c
@@ -227,8 +227,7 @@ void ide_unregister(ide_hwif_t *hwif)
 	kfree(hwif->sg_table);
 	unregister_blkdev(hwif->major, hwif->name);
 
-	if (hwif->dma_base)
-		ide_release_dma_engine(hwif);
+	ide_release_dma_engine(hwif);
 
 	mutex_unlock(&ide_cfg_mtx);
 }
Index: b/drivers/ide/mips/au1xxx-ide.c
===================================================================
--- a/drivers/ide/mips/au1xxx-ide.c
+++ b/drivers/ide/mips/au1xxx-ide.c
@@ -427,10 +427,9 @@ static int auide_ddma_init(ide_hwif_t *h
 							     NUM_DESCRIPTORS);
 	auide->rx_desc_head = (void*)au1xxx_dbdma_ring_alloc(auide->rx_chan,
 							     NUM_DESCRIPTORS);
- 
-	hwif->dmatable_cpu = dma_alloc_coherent(hwif->dev,
-						PRD_ENTRIES * PRD_BYTES,        /* 1 Page */
-						&hwif->dmatable_dma, GFP_KERNEL);
+
+	/* FIXME: check return value */
+	(void)ide_allocate_dma_engine(hwif);
 	
 	au1xxx_dbdma_start( auide->tx_chan );
 	au1xxx_dbdma_start( auide->rx_chan );
Index: b/drivers/ide/pci/scc_pata.c
===================================================================
--- a/drivers/ide/pci/scc_pata.c
+++ b/drivers/ide/pci/scc_pata.c
@@ -821,6 +821,12 @@ static void __devinit init_iops_scc(ide_
 	init_mmio_iops_scc(hwif);
 }
 
+static int __devinit scc_init_dma(ide_hwif_t *hwif,
+				  const struct ide_port_info *d)
+{
+	return ide_allocate_dma_engine(hwif);
+}
+
 static u8 scc_cable_detect(ide_hwif_t *hwif)
 {
 	return ATA_CBL_PATA80;
@@ -885,6 +891,7 @@ static const struct ide_dma_ops scc_dma_
   {							\
       .name		= name_str,			\
       .init_iops	= init_iops_scc,		\
+      .init_dma		= scc_init_dma,			\
       .init_hwif	= init_hwif_scc,		\
       .tp_ops		= &scc_tp_ops,		\
       .port_ops		= &scc_port_ops,		\
@@ -922,13 +929,6 @@ static void __devexit scc_remove(struct 
 {
 	struct scc_ports *ports = pci_get_drvdata(dev);
 	struct ide_host *host = ports->host;
-	ide_hwif_t *hwif = host->ports[0];
-
-	if (hwif->dmatable_cpu) {
-		pci_free_consistent(dev, PRD_ENTRIES * PRD_BYTES,
-				    hwif->dmatable_cpu, hwif->dmatable_dma);
-		hwif->dmatable_cpu = NULL;
-	}
 
 	ide_host_remove(host);
 
Index: b/drivers/ide/pci/sgiioc4.c
===================================================================
--- a/drivers/ide/pci/sgiioc4.c
+++ b/drivers/ide/pci/sgiioc4.c
@@ -359,14 +359,13 @@ ide_dma_sgiioc4(ide_hwif_t *hwif, const 
 	}
 	hwif->dma_base = (unsigned long) virt_dma_base;
 
-	hwif->dmatable_cpu = pci_alloc_consistent(dev,
-					  IOC4_PRD_ENTRIES * IOC4_PRD_BYTES,
-					  &hwif->dmatable_dma);
+	hwif->sg_max_nents = IOC4_PRD_ENTRIES;
 
-	if (!hwif->dmatable_cpu)
-		goto dma_pci_alloc_failure;
+	hwif->prd_max_nents = IOC4_PRD_ENTRIES;
+	hwif->prd_ent_size = IOC4_PRD_BYTES;
 
-	hwif->sg_max_nents = IOC4_PRD_ENTRIES;
+	if (ide_allocate_dma_engine(hwif))
+		goto dma_pci_alloc_failure;
 
 	pad = pci_alloc_consistent(dev, IOC4_IDE_CACHELINE_SIZE,
 				   (dma_addr_t *)&hwif->extra_base);
@@ -375,8 +374,8 @@ ide_dma_sgiioc4(ide_hwif_t *hwif, const 
 		return 0;
 	}
 
-	pci_free_consistent(dev, IOC4_PRD_ENTRIES * IOC4_PRD_BYTES,
-			    hwif->dmatable_cpu, hwif->dmatable_dma);
+	ide_release_dma_engine(hwif);
+
 	printk(KERN_INFO
 	       "%s() -- Error! Unable to allocate DMA Maps for drive %s\n",
 	       __func__, hwif->name);
Index: b/include/linux/ide.h
===================================================================
--- a/include/linux/ide.h
+++ b/include/linux/ide.h
@@ -786,6 +786,12 @@ typedef struct hwif_s {
 	unsigned int	*dmatable_cpu;
 	/* dma physical region descriptor table (dma view) */
 	dma_addr_t	dmatable_dma;
+
+	/* maximum number of PRD table entries */
+	int prd_max_nents;
+	/* PRD entry size in bytes */
+	int prd_ent_size;
+
 	/* Scatter-gather list used to build the above */
 	struct scatterlist *sg_table;
 	int sg_max_nents;		/* Maximum number of entries in it */
@@ -1418,14 +1424,14 @@ int ide_set_dma(ide_drive_t *);
 void ide_check_dma_crc(ide_drive_t *);
 ide_startstop_t ide_dma_intr(ide_drive_t *);
 
+int ide_allocate_dma_engine(ide_hwif_t *);
+void ide_release_dma_engine(ide_hwif_t *);
+
 int ide_build_sglist(ide_drive_t *, struct request *);
 void ide_destroy_dmatable(ide_drive_t *);
 
 #ifdef CONFIG_BLK_DEV_IDEDMA_SFF
 extern int ide_build_dmatable(ide_drive_t *, struct request *);
-int ide_allocate_dma_engine(ide_hwif_t *);
-void ide_release_dma_engine(ide_hwif_t *);
-
 void ide_dma_host_set(ide_drive_t *, int);
 extern int ide_dma_setup(ide_drive_t *);
 void ide_dma_exec_cmd(ide_drive_t *, u8);
@@ -1448,11 +1454,8 @@ static inline void ide_dma_on(ide_drive_
 static inline void ide_dma_verbose(ide_drive_t *drive) { ; }
 static inline int ide_set_dma(ide_drive_t *drive) { return 1; }
 static inline void ide_check_dma_crc(ide_drive_t *drive) { ; }
-#endif /* CONFIG_BLK_DEV_IDEDMA */
-
-#ifndef CONFIG_BLK_DEV_IDEDMA_SFF
 static inline void ide_release_dma_engine(ide_hwif_t *hwif) { ; }
-#endif
+#endif /* CONFIG_BLK_DEV_IDEDMA */
 
 #ifdef CONFIG_BLK_DEV_IDEACPI
 extern int ide_acpi_exec_tfs(ide_drive_t *drive);
