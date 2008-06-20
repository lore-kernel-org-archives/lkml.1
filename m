Return-Path: <linux-kernel-owner+w=401wt.eu-S1762307AbYFTVea@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762307AbYFTVea (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2008 17:34:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761495AbYFTVc2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jun 2008 17:32:28 -0400
Received: from fk-out-0910.google.com ([209.85.128.189]:6668 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759288AbYFTVcV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2008 17:32:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=gbL469WLMyvIywUy6XWD3Yy4Q3/AzH/Nmv6jP8/STabE4Cn6jlVxpi2Bw7o5MKSFx5
         wNeTJj2Ab+/bbfWMe/b/bIgP+EKV84gDJ0II4SaMSm8IoHqsW/CPYcGkLugsmhuMY96p
         K9WCFG/vo/BUlv4zrRaclbPqaiMl40fpd+hFw=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Fri, 20 Jun 2008 23:34:17 +0200
Message-Id: <20080620213417.13202.59036.sendpatchset@localhost.localdomain>
In-Reply-To: <20080620213323.13202.71450.sendpatchset@localhost.localdomain>
References: <20080620213323.13202.71450.sendpatchset@localhost.localdomain>
Subject: [PATCH 08/18] ide: add ->read_altstatus method
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Remove ide_read_altstatus() inline helper.

* Add ->read_altstatus method for reading ATA Alternate Status
  register and use it instead of ->INB.

There should be no functional changes caused by this patch.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/ide-iops.c     |   13 +++++++++++--
 drivers/ide/ide-probe.c    |    4 ++--
 drivers/ide/pci/scc_pata.c |    6 ++++++
 include/linux/ide.h        |    8 +-------
 4 files changed, 20 insertions(+), 11 deletions(-)

Index: b/drivers/ide/ide-iops.c
===================================================================
--- a/drivers/ide/ide-iops.c
+++ b/drivers/ide/ide-iops.c
@@ -119,6 +119,14 @@ static u8 ide_read_status(ide_hwif_t *hw
 		return inb(hwif->io_ports.status_addr);
 }
 
+static u8 ide_read_altstatus(ide_hwif_t *hwif)
+{
+	if (hwif->host_flags & IDE_HFLAG_MMIO)
+		return readb((void __iomem *)hwif->io_ports.ctl_addr);
+	else
+		return inb(hwif->io_ports.ctl_addr);
+}
+
 static u8 ide_read_sff_dma_status(ide_hwif_t *hwif)
 {
 	if (hwif->host_flags & IDE_HFLAG_MMIO)
@@ -349,6 +357,7 @@ void default_hwif_transport(ide_hwif_t *
 {
 	hwif->exec_command	  = ide_exec_command;
 	hwif->read_status	  = ide_read_status;
+	hwif->read_altstatus	  = ide_read_altstatus;
 	hwif->read_sff_dma_status = ide_read_sff_dma_status;
 
 	hwif->tf_load	  = ide_tf_load;
@@ -511,7 +520,7 @@ int drive_is_ready (ide_drive_t *drive)
 	 * about possible isa-pnp and pci-pnp issues yet.
 	 */
 	if (hwif->io_ports.ctl_addr)
-		stat = ide_read_altstatus(drive);
+		stat = hwif->read_altstatus(hwif);
 	else
 		/* Note: this may clear a pending IRQ!! */
 		stat = hwif->read_status(hwif);
@@ -724,7 +733,7 @@ int ide_driveid_update(ide_drive_t *driv
 		}
 
 		msleep(50);	/* give drive a breather */
-		stat = ide_read_altstatus(drive);
+		stat = hwif->read_altstatus(hwif);
 	} while (stat & BUSY_STAT);
 
 	msleep(50);	/* wait for IRQ and DRQ_STAT */
Index: b/drivers/ide/ide-probe.c
===================================================================
--- a/drivers/ide/ide-probe.c
+++ b/drivers/ide/ide-probe.c
@@ -275,7 +275,7 @@ static int actual_try_to_identify (ide_d
 	msleep(50);
 
 	if (io_ports->ctl_addr) {
-		a = ide_read_altstatus(drive);
+		a = hwif->read_altstatus(hwif);
 		s = hwif->read_status(hwif);
 		if ((a ^ s) & ~INDEX_STAT)
 			/* ancient Seagate drives, broken interfaces */
@@ -306,7 +306,7 @@ static int actual_try_to_identify (ide_d
 		}
 		/* give drive a breather */
 		msleep(50);
-		s = use_altstatus ? ide_read_altstatus(drive)
+		s = use_altstatus ? hwif->read_altstatus(hwif)
 				  : hwif->read_status(hwif);
 	} while (s & BUSY_STAT);
 
Index: b/drivers/ide/pci/scc_pata.c
===================================================================
--- a/drivers/ide/pci/scc_pata.c
+++ b/drivers/ide/pci/scc_pata.c
@@ -139,6 +139,11 @@ static u8 scc_read_status(ide_hwif_t *hw
 	return (u8)in_be32((void *)hwif->io_ports.status_addr);
 }
 
+static u8 scc_read_altstatus(ide_hwif_t *hwif)
+{
+	return (u8)in_be32((void *)hwif->io_ports.ctl_addr);
+}
+
 static u8 scc_read_sff_dma_status(ide_hwif_t *hwif)
 {
 	return (u8)in_be32((void *)(hwif->dma_base + 4));
@@ -795,6 +800,7 @@ static void __devinit init_mmio_iops_scc
 
 	hwif->exec_command	  = scc_exec_command;
 	hwif->read_status	  = scc_read_status;
+	hwif->read_altstatus	  = scc_read_altstatus;
 	hwif->read_sff_dma_status = scc_read_sff_dma_status;
 
 	hwif->tf_load = scc_tf_load;
Index: b/include/linux/ide.h
===================================================================
--- a/include/linux/ide.h
+++ b/include/linux/ide.h
@@ -470,6 +470,7 @@ typedef struct hwif_s {
 
 	void	(*exec_command)(struct hwif_s *, u8);
 	u8	(*read_status)(struct hwif_s *);
+	u8	(*read_altstatus)(struct hwif_s *);
 	u8	(*read_sff_dma_status)(struct hwif_s *);
 
 	void (*tf_load)(ide_drive_t *, struct ide_task_s *);
@@ -1349,13 +1350,6 @@ static inline void ide_set_irq(ide_drive
 		       hwif->io_ports.ctl_addr);
 }
 
-static inline u8 ide_read_altstatus(ide_drive_t *drive)
-{
-	ide_hwif_t *hwif = drive->hwif;
-
-	return hwif->INB(hwif->io_ports.ctl_addr);
-}
-
 static inline u8 ide_read_error(ide_drive_t *drive)
 {
 	ide_hwif_t *hwif = drive->hwif;
