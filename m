Return-Path: <linux-kernel-owner+w=401wt.eu-S1752878AbYCIPtq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752878AbYCIPtq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Mar 2008 11:49:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753925AbYCIPtQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Mar 2008 11:49:16 -0400
Received: from fg-out-1718.google.com ([72.14.220.154]:11705 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752584AbYCIPsq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Mar 2008 11:48:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=UknuqtdOsOxZbyKlruGvA/FUFZbpneWMh4nkGd5fqaytAwErG+67/TtBvHSwMe5+7v9lvtm687hekiflQvaLlNNmng72lvdA43Ue5s7ZEWqEWhZuWOgSjeWQHNcJQf7QrYZseJwY2ct2cJPCFF0CjXZulZ2PyrD39XrnY1sYlNk=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Subject: [PATCH 4/4] ide: constify struct ide_dma_ops
Date: Sun, 9 Mar 2008 17:02:18 +0100
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803091702.18521.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Export ide_dma_exec_cmd() and __ide_dma_test_irq().

* Constify struct ide_dma_ops.

* Always set hwif->dma_ops to &sff_dma_ops in ide_setup_dma()
  (it is later overriden by ide_init_port() if needed) and drop
  'const struct ide_port_info *d' argument.

While at it:

* Rename __ide_dma_test_irq() to __ide_dma_test_irq().

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/arm/icside.c       |    2 +-
 drivers/ide/arm/palm_bk3710.c  |    2 +-
 drivers/ide/cris/ide-cris.c    |    4 ++--
 drivers/ide/ide-dma.c          |   33 ++++++++-------------------------
 drivers/ide/ide-taskfile.c     |    2 +-
 drivers/ide/mips/au1xxx-ide.c  |    2 +-
 drivers/ide/pci/alim15x3.c     |   11 +++++++++--
 drivers/ide/pci/cmd64x.c       |   25 ++++++++++++++++++++++---
 drivers/ide/pci/cs5520.c       |    9 ++++++++-
 drivers/ide/pci/hpt366.c       |   26 ++++++++++++++++++++++----
 drivers/ide/pci/ns87415.c      |    8 +++++++-
 drivers/ide/pci/pdc202xx_old.c |   12 ++++++++++--
 drivers/ide/pci/sc1200.c       |    9 ++++++++-
 drivers/ide/pci/scc_pata.c     |    7 ++++++-
 drivers/ide/pci/sgiioc4.c      |    2 +-
 drivers/ide/pci/sl82c105.c     |    6 +++++-
 drivers/ide/pci/tc86c001.c     |    9 ++++++++-
 drivers/ide/pci/trm290.c       |    2 ++
 drivers/ide/ppc/pmac.c         |    4 ++--
 drivers/ide/setup-pci.c        |    2 +-
 include/linux/ide.h            |    8 +++++---
 21 files changed, 130 insertions(+), 55 deletions(-)

Index: b/drivers/ide/arm/icside.c
===================================================================
--- a/drivers/ide/arm/icside.c
+++ b/drivers/ide/arm/icside.c
@@ -392,7 +392,7 @@ static int icside_dma_init(ide_hwif_t *h
 	return 0;
 }
 
-static struct ide_dma_ops icside_v6_dma_ops = {
+static const struct ide_dma_ops icside_v6_dma_ops = {
 	.dma_host_set		= icside_dma_host_set,
 	.dma_setup		= icside_dma_setup,
 	.dma_exec_cmd		= icside_dma_exec_cmd,
Index: b/drivers/ide/arm/palm_bk3710.c
===================================================================
--- a/drivers/ide/arm/palm_bk3710.c
+++ b/drivers/ide/arm/palm_bk3710.c
@@ -328,7 +328,7 @@ static int __devinit palm_bk3710_init_dm
 	if (ide_allocate_dma_engine(hwif))
 		return -1;
 
-	ide_setup_dma(hwif, base, d);
+	ide_setup_dma(hwif, base);
 
 	return 0;
 }
Index: b/drivers/ide/cris/ide-cris.c
===================================================================
--- a/drivers/ide/cris/ide-cris.c
+++ b/drivers/ide/cris/ide-cris.c
@@ -782,7 +782,7 @@ static const struct ide_port_ops cris_po
 	.set_dma_mode		= cris_set_dma_mode,
 };
 
-static struct ide_dma_ops cris_dma_ops;
+static const struct ide_dma_ops cris_dma_ops;
 
 static const struct ide_port_info cris_port_info __initdata = {
 	.chipset		= ide_etrax100,
@@ -1072,7 +1072,7 @@ static void cris_dma_start(ide_drive_t *
 	}
 }
 
-static struct ide_dma_ops cris_dma_ops = {
+static const struct ide_dma_ops cris_dma_ops = {
 	.dma_host_set		= cris_dma_host_set,
 	.dma_setup		= cris_dma_setup,
 	.dma_exec_cmd		= cris_dma_exec_cmd,
Index: b/drivers/ide/ide-dma.c
===================================================================
--- a/drivers/ide/ide-dma.c
+++ b/drivers/ide/ide-dma.c
@@ -482,11 +482,12 @@ int ide_dma_setup(ide_drive_t *drive)
 
 EXPORT_SYMBOL_GPL(ide_dma_setup);
 
-static void ide_dma_exec_cmd(ide_drive_t *drive, u8 command)
+void ide_dma_exec_cmd(ide_drive_t *drive, u8 command)
 {
 	/* issue cmd to drive */
 	ide_execute_command(drive, command, &ide_dma_intr, 2*WAIT_CMD, dma_timer_expiry);
 }
+EXPORT_SYMBOL_GPL(ide_dma_exec_cmd);
 
 void ide_dma_start(ide_drive_t *drive)
 {
@@ -532,7 +533,7 @@ int __ide_dma_end (ide_drive_t *drive)
 EXPORT_SYMBOL(__ide_dma_end);
 
 /* returns 1 if dma irq issued, 0 otherwise */
-static int __ide_dma_test_irq(ide_drive_t *drive)
+int ide_dma_test_irq(ide_drive_t *drive)
 {
 	ide_hwif_t *hwif	= HWIF(drive);
 	u8 dma_stat		= hwif->INB(hwif->dma_status);
@@ -545,6 +546,7 @@ static int __ide_dma_test_irq(ide_drive_
 			drive->name, __func__);
 	return 0;
 }
+EXPORT_SYMBOL_GPL(ide_dma_test_irq);
 #else
 static inline int config_drive_for_dma(ide_drive_t *drive) { return 0; }
 #endif /* CONFIG_BLK_DEV_IDEDMA_SFF */
@@ -839,21 +841,19 @@ int ide_allocate_dma_engine(ide_hwif_t *
 }
 EXPORT_SYMBOL_GPL(ide_allocate_dma_engine);
 
-static struct ide_dma_ops sff_dma_ops = {
+static const struct ide_dma_ops sff_dma_ops = {
 	.dma_host_set		= ide_dma_host_set,
 	.dma_setup		= ide_dma_setup,
 	.dma_exec_cmd		= ide_dma_exec_cmd,
 	.dma_start		= ide_dma_start,
 	.dma_end		= __ide_dma_end,
-	.dma_test_irq		= __ide_dma_test_irq,
+	.dma_test_irq		= ide_dma_test_irq,
 	.dma_timeout		= ide_dma_timeout,
 	.dma_lost_irq		= ide_dma_lost_irq,
 };
 
-void ide_setup_dma(ide_hwif_t *hwif, unsigned long base,
-		   const struct ide_port_info *d)
+void ide_setup_dma(ide_hwif_t *hwif, unsigned long base)
 {
-	struct ide_dma_ops *dma_ops = d->dma_ops ? d->dma_ops : &sff_dma_ops;
 	hwif->dma_base = base;
 
 	if (!hwif->dma_command)
@@ -867,24 +867,7 @@ void ide_setup_dma(ide_hwif_t *hwif, uns
 	if (!hwif->dma_prdtable)
 		hwif->dma_prdtable	= hwif->dma_base + 4;
 
-	hwif->dma_ops = dma_ops;
-
-	if (dma_ops->dma_host_set == NULL)
-		dma_ops->dma_host_set	= ide_dma_host_set;
-	if (dma_ops->dma_setup == NULL)
-		dma_ops->dma_setup	= ide_dma_setup;
-	if (dma_ops->dma_exec_cmd == NULL)
-		dma_ops->dma_exec_cmd	= ide_dma_exec_cmd;
-	if (dma_ops->dma_start == NULL)
-		dma_ops->dma_start	= ide_dma_start;
-	if (dma_ops->dma_end == NULL)
-		dma_ops->dma_end	= __ide_dma_end;
-	if (dma_ops->dma_test_irq == NULL)
-		dma_ops->dma_test_irq	= __ide_dma_test_irq;
-	if (dma_ops->dma_timeout == NULL)
-		dma_ops->dma_timeout	= ide_dma_timeout;
-	if (dma_ops->dma_lost_irq == NULL)
-		dma_ops->dma_lost_irq	= ide_dma_lost_irq;
+	hwif->dma_ops = &sff_dma_ops;
 }
 
 EXPORT_SYMBOL_GPL(ide_setup_dma);
Index: b/drivers/ide/ide-taskfile.c
===================================================================
--- a/drivers/ide/ide-taskfile.c
+++ b/drivers/ide/ide-taskfile.c
@@ -135,7 +135,7 @@ ide_startstop_t do_rw_taskfile (ide_driv
 	ide_hwif_t *hwif	= HWIF(drive);
 	struct ide_taskfile *tf = &task->tf;
 	ide_handler_t *handler = NULL;
-	struct ide_dma_ops *dma_ops = hwif->dma_ops;
+	const struct ide_dma_ops *dma_ops = hwif->dma_ops;
 
 	if (task->data_phase == TASKFILE_MULTI_IN ||
 	    task->data_phase == TASKFILE_MULTI_OUT) {
Index: b/drivers/ide/mips/au1xxx-ide.c
===================================================================
--- a/drivers/ide/mips/au1xxx-ide.c
+++ b/drivers/ide/mips/au1xxx-ide.c
@@ -385,7 +385,7 @@ static void auide_dma_timeout(ide_drive_
 	auide_dma_end(drive);
 }
 
-static struct ide_dma_ops auide_dma_ops = {
+static const struct ide_dma_ops auide_dma_ops = {
 	.dma_host_set		= auide_dma_host_set,
 	.dma_setup		= auide_dma_setup,
 	.dma_exec_cmd		= auide_dma_exec_cmd,
Index: b/drivers/ide/pci/alim15x3.c
===================================================================
--- a/drivers/ide/pci/alim15x3.c
+++ b/drivers/ide/pci/alim15x3.c
@@ -731,7 +731,7 @@ static int __devinit init_dma_ali15x3(id
 	if (ide_allocate_dma_engine(hwif))
 		return -1;
 
-	ide_setup_dma(hwif, base, d);
+	ide_setup_dma(hwif, base);
 
 	return 0;
 }
@@ -743,8 +743,15 @@ static const struct ide_port_ops ali_por
 	.cable_detect		= ali_cable_detect,
 };
 
-static struct ide_dma_ops ali_dma_ops = {
+static const struct ide_dma_ops ali_dma_ops = {
+	.dma_host_set		= ide_dma_host_set,
 	.dma_setup		= ali15x3_dma_setup,
+	.dma_exec_cmd		= ide_dma_exec_cmd,
+	.dma_start		= ide_dma_start,
+	.dma_end		= __ide_dma_end,
+	.dma_test_irq		= ide_dma_test_irq,
+	.dma_lost_irq		= ide_dma_lost_irq,
+	.dma_timeout		= ide_dma_timeout,
 };
 
 static const struct ide_port_info ali15x3_chipset __devinitdata = {
Index: b/drivers/ide/pci/cmd64x.c
===================================================================
--- a/drivers/ide/pci/cmd64x.c
+++ b/drivers/ide/pci/cmd64x.c
@@ -391,18 +391,37 @@ static const struct ide_port_ops cmd64x_
 	.cable_detect		= cmd64x_cable_detect,
 };
 
-static struct ide_dma_ops cmd643_dma_ops = {
+static const struct ide_dma_ops cmd643_dma_ops = {
+	.dma_host_set		= ide_dma_host_set,
+	.dma_setup		= ide_dma_setup,
+	.dma_exec_cmd		= ide_dma_exec_cmd,
+	.dma_start		= ide_dma_start,
 	.dma_end		= cmd64x_ide_dma_end,
 	.dma_test_irq		= cmd64x_ide_dma_test_irq,
+	.dma_lost_irq		= ide_dma_lost_irq,
+	.dma_timeout		= ide_dma_timeout,
 };
 
-static struct ide_dma_ops cmd646_rev1_dma_ops = {
+static const struct ide_dma_ops cmd646_rev1_dma_ops = {
+	.dma_host_set		= ide_dma_host_set,
+	.dma_setup		= ide_dma_setup,
+	.dma_exec_cmd		= ide_dma_exec_cmd,
+	.dma_start		= ide_dma_start,
 	.dma_end		= cmd646_1_ide_dma_end,
+	.dma_test_irq		= ide_dma_test_irq,
+	.dma_lost_irq		= ide_dma_lost_irq,
+	.dma_timeout		= ide_dma_timeout,
 };
 
-static struct ide_dma_ops cmd64x_dma_ops = {
+static const struct ide_dma_ops cmd64x_dma_ops = {
+	.dma_host_set		= ide_dma_host_set,
+	.dma_setup		= ide_dma_setup,
+	.dma_exec_cmd		= ide_dma_exec_cmd,
+	.dma_start		= ide_dma_start,
 	.dma_end		= cmd648_ide_dma_end,
 	.dma_test_irq		= cmd648_ide_dma_test_irq,
+	.dma_lost_irq		= ide_dma_lost_irq,
+	.dma_timeout		= ide_dma_timeout,
 };
 
 static const struct ide_port_info cmd64x_chipsets[] __devinitdata = {
Index: b/drivers/ide/pci/cs5520.c
===================================================================
--- a/drivers/ide/pci/cs5520.c
+++ b/drivers/ide/pci/cs5520.c
@@ -108,8 +108,15 @@ static const struct ide_port_ops cs5520_
 	.set_dma_mode		= cs5520_set_dma_mode,
 };
 
-static struct ide_dma_ops cs5520_dma_ops = {
+static const struct ide_dma_ops cs5520_dma_ops = {
 	.dma_host_set		= cs5520_dma_host_set,
+	.dma_setup		= ide_dma_setup,
+	.dma_exec_cmd		= ide_dma_exec_cmd,
+	.dma_start		= ide_dma_start,
+	.dma_end		= __ide_dma_end,
+	.dma_test_irq		= ide_dma_test_irq,
+	.dma_lost_irq		= ide_dma_lost_irq,
+	.dma_timeout		= ide_dma_timeout,
 };
 
 #define DECLARE_CS_DEV(name_str)				\
Index: b/drivers/ide/pci/hpt366.c
===================================================================
--- a/drivers/ide/pci/hpt366.c
+++ b/drivers/ide/pci/hpt366.c
@@ -1347,7 +1347,7 @@ static int __devinit init_dma_hpt366(ide
 	if (ide_allocate_dma_engine(hwif))
 		return -1;
 
-	ide_setup_dma(hwif, base, d);
+	ide_setup_dma(hwif, base);
 
 	return 0;
 }
@@ -1415,19 +1415,37 @@ static const struct ide_port_ops hpt3xx_
 	.cable_detect		= hpt3xx_cable_detect,
 };
 
-static struct ide_dma_ops hpt3xxx_dma_ops = {
+static const struct ide_dma_ops hpt3xxx_dma_ops = {
+	.dma_host_set		= ide_dma_host_set,
+	.dma_setup		= ide_dma_setup,
+	.dma_exec_cmd		= ide_dma_exec_cmd,
+	.dma_start		= ide_dma_start,
 	.dma_end		= hpt374_ide_dma_end,
 	.dma_test_irq		= hpt374_ide_dma_test_irq,
+	.dma_lost_irq		= ide_dma_lost_irq,
+	.dma_timeout		= ide_dma_timeout,
 };
 
-static struct ide_dma_ops hpt370x_dma_ops = {
+static const struct ide_dma_ops hpt370x_dma_ops = {
+	.dma_host_set		= ide_dma_host_set,
+	.dma_setup		= ide_dma_setup,
+	.dma_exec_cmd		= ide_dma_exec_cmd,
 	.dma_start		= hpt370_ide_dma_start,
 	.dma_end		= hpt370_ide_dma_end,
+	.dma_test_irq		= ide_dma_test_irq,
+	.dma_lost_irq		= ide_dma_lost_irq,
 	.dma_timeout		= hpt370_dma_timeout,
 };
 
-static struct ide_dma_ops hpt36x_dma_ops = {
+static const struct ide_dma_ops hpt36x_dma_ops = {
+	.dma_host_set		= ide_dma_host_set,
+	.dma_setup		= ide_dma_setup,
+	.dma_exec_cmd		= ide_dma_exec_cmd,
+	.dma_start		= ide_dma_start,
+	.dma_end		= __ide_dma_end,
+	.dma_test_irq		= ide_dma_test_irq,
 	.dma_lost_irq		= hpt366_dma_lost_irq,
+	.dma_timeout		= ide_dma_timeout,
 };
 
 static const struct ide_port_info hpt366_chipsets[] __devinitdata = {
Index: b/drivers/ide/pci/ns87415.c
===================================================================
--- a/drivers/ide/pci/ns87415.c
+++ b/drivers/ide/pci/ns87415.c
@@ -258,9 +258,15 @@ static const struct ide_port_ops ns87415
 	.selectproc		= ns87415_selectproc,
 };
 
-static struct ide_dma_ops ns87415_dma_ops = {
+static const struct ide_dma_ops ns87415_dma_ops = {
+	.dma_host_set		= ide_dma_host_set,
 	.dma_setup		= ns87415_ide_dma_setup,
+	.dma_exec_cmd		= ide_dma_exec_cmd,
+	.dma_start		= ide_dma_start,
 	.dma_end		= ns87415_ide_dma_end,
+	.dma_test_irq		= ide_dma_test_irq,
+	.dma_lost_irq		= ide_dma_lost_irq,
+	.dma_timeout		= ide_dma_timeout,
 };
 
 static const struct ide_port_info ns87415_chipset __devinitdata = {
Index: b/drivers/ide/pci/pdc202xx_old.c
===================================================================
--- a/drivers/ide/pci/pdc202xx_old.c
+++ b/drivers/ide/pci/pdc202xx_old.c
@@ -329,13 +329,21 @@ static const struct ide_port_ops pdc2026
 	.cable_detect		= pdc2026x_cable_detect,
 };
 
-static struct ide_dma_ops pdc20246_dma_ops = {
+static const struct ide_dma_ops pdc20246_dma_ops = {
+	.dma_host_set		= ide_dma_host_set,
+	.dma_setup		= ide_dma_setup,
+	.dma_exec_cmd		= ide_dma_exec_cmd,
+	.dma_start		= ide_dma_start,
+	.dma_end		= __ide_dma_end,
 	.dma_test_irq		= pdc202xx_old_ide_dma_test_irq,
 	.dma_lost_irq		= pdc202xx_dma_lost_irq,
 	.dma_timeout		= pdc202xx_dma_timeout,
 };
 
-static struct ide_dma_ops pdc2026x_dma_ops = {
+static const struct ide_dma_ops pdc2026x_dma_ops = {
+	.dma_host_set		= ide_dma_host_set,
+	.dma_setup		= ide_dma_setup,
+	.dma_exec_cmd		= ide_dma_exec_cmd,
 	.dma_start		= pdc202xx_old_ide_dma_start,
 	.dma_end		= pdc202xx_old_ide_dma_end,
 	.dma_test_irq		= pdc202xx_old_ide_dma_test_irq,
Index: b/drivers/ide/pci/sc1200.c
===================================================================
--- a/drivers/ide/pci/sc1200.c
+++ b/drivers/ide/pci/sc1200.c
@@ -292,8 +292,15 @@ static const struct ide_port_ops sc1200_
 	.udma_filter		= sc1200_udma_filter,
 };
 
-static struct ide_dma_ops sc1200_dma_ops = {
+static const struct ide_dma_ops sc1200_dma_ops = {
+	.dma_host_set		= ide_dma_host_set,
+	.dma_setup		= ide_dma_setup,
+	.dma_exec_cmd		= ide_dma_exec_cmd,
+	.dma_start		= ide_dma_start,
 	.dma_end		= sc1200_ide_dma_end,
+	.dma_test_irq		= ide_dma_test_irq,
+	.dma_lost_irq		= ide_dma_lost_irq,
+	.dma_timeout		= ide_dma_timeout,
 };
 
 static const struct ide_port_info sc1200_chipset __devinitdata = {
Index: b/drivers/ide/pci/scc_pata.c
===================================================================
--- a/drivers/ide/pci/scc_pata.c
+++ b/drivers/ide/pci/scc_pata.c
@@ -672,10 +672,15 @@ static const struct ide_port_ops scc_por
 	.cable_detect		= scc_cable_detect,
 };
 
-static struct ide_dma_ops scc_dma_ops = {
+static const struct ide_dma_ops scc_dma_ops = {
+	.dma_host_set		= ide_dma_host_set,
 	.dma_setup		= scc_dma_setup,
+	.dma_exec_cmd		= ide_dma_exec_cmd,
+	.dma_start		= ide_dma_start,
 	.dma_end		= scc_ide_dma_end,
 	.dma_test_irq		= scc_dma_test_irq,
+	.dma_lost_irq		= ide_dma_lost_irq,
+	.dma_timeout		= ide_dma_timeout,
 };
 
 #define DECLARE_SCC_DEV(name_str)			\
Index: b/drivers/ide/pci/sgiioc4.c
===================================================================
--- a/drivers/ide/pci/sgiioc4.c
+++ b/drivers/ide/pci/sgiioc4.c
@@ -560,7 +560,7 @@ static const struct ide_port_ops sgiioc4
 	.maskproc		= sgiioc4_maskproc,
 };
 
-static struct ide_dma_ops sgiioc4_dma_ops = {
+static const struct ide_dma_ops sgiioc4_dma_ops = {
 	.dma_host_set		= sgiioc4_dma_host_set,
 	.dma_setup		= sgiioc4_ide_dma_setup,
 	.dma_start		= sgiioc4_ide_dma_start,
Index: b/drivers/ide/pci/sl82c105.c
===================================================================
--- a/drivers/ide/pci/sl82c105.c
+++ b/drivers/ide/pci/sl82c105.c
@@ -288,9 +288,13 @@ static const struct ide_port_ops sl82c10
 	.resetproc		= sl82c105_resetproc,
 };
 
-static struct ide_dma_ops sl82c105_dma_ops = {
+static const struct ide_dma_ops sl82c105_dma_ops = {
+	.dma_host_set		= ide_dma_host_set,
+	.dma_setup		= ide_dma_setup,
+	.dma_exec_cmd		= ide_dma_exec_cmd,
 	.dma_start		= sl82c105_dma_start,
 	.dma_end		= sl82c105_dma_end,
+	.dma_test_irq		= ide_dma_test_irq,
 	.dma_lost_irq		= sl82c105_dma_lost_irq,
 	.dma_timeout		= sl82c105_dma_timeout,
 };
Index: b/drivers/ide/pci/tc86c001.c
===================================================================
--- a/drivers/ide/pci/tc86c001.c
+++ b/drivers/ide/pci/tc86c001.c
@@ -186,8 +186,15 @@ static const struct ide_port_ops tc86c00
 	.cable_detect		= tc86c001_cable_detect,
 };
 
-static struct ide_dma_ops tc86c001_dma_ops = {
+static const struct ide_dma_ops tc86c001_dma_ops = {
+	.dma_host_set		= ide_dma_host_set,
+	.dma_setup		= ide_dma_setup,
+	.dma_exec_cmd		= ide_dma_exec_cmd,
 	.dma_start		= tc86c001_dma_start,
+	.dma_end		= __ide_dma_end,
+	.dma_test_irq		= ide_dma_test_irq,
+	.dma_lost_irq		= ide_dma_lost_irq,
+	.dma_timeout		= ide_dma_timeout,
 };
 
 static const struct ide_port_info tc86c001_chipset __devinitdata = {
Index: b/drivers/ide/pci/trm290.c
===================================================================
--- a/drivers/ide/pci/trm290.c
+++ b/drivers/ide/pci/trm290.c
@@ -320,6 +320,8 @@ static struct ide_dma_ops trm290_dma_ops
 	.dma_start 		= trm290_dma_start,
 	.dma_end		= trm290_ide_dma_end,
 	.dma_test_irq		= trm290_ide_dma_test_irq,
+	.dma_lost_irq		= ide_dma_lost_irq,
+	.dma_timeout		= ide_dma_timeout,
 };
 
 static const struct ide_port_info trm290_chipset __devinitdata = {
Index: b/drivers/ide/ppc/pmac.c
===================================================================
--- a/drivers/ide/ppc/pmac.c
+++ b/drivers/ide/ppc/pmac.c
@@ -930,7 +930,7 @@ static const struct ide_port_ops pmac_id
 	.selectproc		= pmac_ide_selectproc,
 };
 
-static struct ide_dma_ops pmac_dma_ops;
+static const struct ide_dma_ops pmac_dma_ops;
 
 static const struct ide_port_info pmac_port_info = {
 	.init_dma		= pmac_ide_init_dma,
@@ -1675,7 +1675,7 @@ pmac_ide_dma_lost_irq (ide_drive_t *driv
 	printk(KERN_ERR "ide-pmac lost interrupt, dma status: %lx\n", status);
 }
 
-static struct ide_dma_ops pmac_dma_ops = {
+static const struct ide_dma_ops pmac_dma_ops = {
 	.dma_host_set		= pmac_ide_dma_host_set,
 	.dma_setup		= pmac_ide_dma_setup,
 	.dma_exec_cmd		= pmac_ide_dma_exec_cmd,
Index: b/drivers/ide/setup-pci.c
===================================================================
--- a/drivers/ide/setup-pci.c
+++ b/drivers/ide/setup-pci.c
@@ -384,7 +384,7 @@ int ide_hwif_setup_dma(ide_hwif_t *hwif,
 		if (ide_allocate_dma_engine(hwif))
 			return -1;
 
-		ide_setup_dma(hwif, base, d);
+		ide_setup_dma(hwif, base);
 	}
 
 	return 0;
Index: b/include/linux/ide.h
===================================================================
--- a/include/linux/ide.h
+++ b/include/linux/ide.h
@@ -463,7 +463,7 @@ typedef struct hwif_s {
 	void (*rw_disk)(ide_drive_t *, struct request *);
 
 	const struct ide_port_ops	*port_ops;
-	struct ide_dma_ops		*dma_ops;
+	const struct ide_dma_ops	*dma_ops;
 
 	void (*ata_input_data)(ide_drive_t *, void *, u32);
 	void (*ata_output_data)(ide_drive_t *, void *, u32);
@@ -1117,7 +1117,7 @@ struct ide_port_info {
 					    const struct ide_port_info *);
 
 	const struct ide_port_ops	*port_ops;
-	struct ide_dma_ops		*dma_ops;
+	const struct ide_dma_ops	*dma_ops;
 
 	ide_pci_enablebit_t	enablebits[2];
 	hwif_chipset_t		chipset;
@@ -1169,12 +1169,14 @@ void ide_destroy_dmatable(ide_drive_t *)
 extern int ide_build_dmatable(ide_drive_t *, struct request *);
 int ide_allocate_dma_engine(ide_hwif_t *);
 void ide_release_dma_engine(ide_hwif_t *);
-void ide_setup_dma(ide_hwif_t *, unsigned long, const struct ide_port_info *);
+void ide_setup_dma(ide_hwif_t *, unsigned long);
 
 void ide_dma_host_set(ide_drive_t *, int);
 extern int ide_dma_setup(ide_drive_t *);
+void ide_dma_exec_cmd(ide_drive_t *, u8);
 extern void ide_dma_start(ide_drive_t *);
 extern int __ide_dma_end(ide_drive_t *);
+int ide_dma_test_irq(ide_drive_t *);
 extern void ide_dma_lost_irq(ide_drive_t *);
 extern void ide_dma_timeout(ide_drive_t *);
 #endif /* CONFIG_BLK_DEV_IDEDMA_SFF */
