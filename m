Return-Path: <linux-kernel-owner+w=401wt.eu-S1756056AbZBIXTK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756056AbZBIXTK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Feb 2009 18:19:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755229AbZBIXSo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Feb 2009 18:18:44 -0500
Received: from fg-out-1718.google.com ([72.14.220.157]:23002 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754502AbZBIXSj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Feb 2009 18:18:39 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=M/L+4bv8ZQ72lSsQ3mp6FOyCtCwhKVwGrIC6BYJ25pxNt7Bu/z7Q8fG6iRr8ZmJ6MC
         GWoUxEIhecDKrPhsvJIzh/T+IlD1Xw6jwsjs7mw1ynkYTizJoDTgsUqTv0HX9TgsZ2P9
         N+KRoS9j1qq4xJXv93FeNGXs0XVpmTX+yiQxc=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Borislav Petkov <petkovbb@gmail.com>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Tue, 10 Feb 2009 00:19:52 +0100
Message-Id: <20090209231952.32406.58013.sendpatchset@localhost.localdomain>
In-Reply-To: <20090209231945.32406.14874.sendpatchset@localhost.localdomain>
References: <20090209231945.32406.14874.sendpatchset@localhost.localdomain>
Subject: [PATCH 1/6] ide: pass command to ide_map_sg()
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] ide: pass command to ide_map_sg()

* Set IDE_TFLAG_WRITE flag and ->rq also for ATA_CMD_PACKET
  commands.

* Pass command to ->dma_setup method and update all its
  implementations accordingly.

* Pass command instead of request to ide_build_sglist(),
  *_build_dmatable() and ide_map_sg().

While at it:

* Fix scc_dma_setup() documentation + use ATA_DMA_WR define.

* Rename sgiioc4_build_dma_table() to sgiioc4_build_dmatable(),
  change return value type to 'int' and drop unused 'ddir'
  argument.

* Do some minor cleanups in [tx4939]ide_dma_setup().

There should be no functional changes caused by this patch.

Cc: Borislav Petkov <petkovbb@gmail.com>
Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/alim15x3.c     |    7 ++++---
 drivers/ide/au1xxx-ide.c   |   15 ++++++---------
 drivers/ide/icside.c       |    7 +++----
 drivers/ide/ide-atapi.c    |   16 ++++++++++++----
 drivers/ide/ide-disk.c     |   10 +++++-----
 drivers/ide/ide-dma-sff.c  |   18 +++++++++---------
 drivers/ide/ide-dma.c      |   15 +++++++--------
 drivers/ide/ide-floppy.c   |    6 +++++-
 drivers/ide/ide-io.c       |    6 +++---
 drivers/ide/ide-taskfile.c |    4 ++--
 drivers/ide/ns87415.c      |    4 ++--
 drivers/ide/pmac.c         |   19 ++++++++-----------
 drivers/ide/scc_pata.c     |   19 +++++++------------
 drivers/ide/sgiioc4.c      |   21 +++++++--------------
 drivers/ide/trm290.c       |   10 +++++-----
 drivers/ide/tx4939ide.c    |   26 ++++++++++----------------
 include/linux/ide.h        |   12 ++++++------
 17 files changed, 101 insertions(+), 114 deletions(-)

Index: b/drivers/ide/alim15x3.c
===================================================================
--- a/drivers/ide/alim15x3.c
+++ b/drivers/ide/alim15x3.c
@@ -191,17 +191,18 @@ static void ali_set_dma_mode(ide_drive_t
 /**
  *	ali15x3_dma_setup	-	begin a DMA phase
  *	@drive:	target device
+ *	@cmd: command
  *
  *	Returns 1 if the DMA cannot be performed, zero on success.
  */
 
-static int ali15x3_dma_setup(ide_drive_t *drive)
+static int ali15x3_dma_setup(ide_drive_t *drive, struct ide_cmd *cmd)
 {
 	if (m5229_revision < 0xC2 && drive->media != ide_disk) {
-		if (rq_data_dir(drive->hwif->rq))
+		if (cmd->tf_flags & IDE_TFLAG_WRITE)
 			return 1;	/* try PIO instead of DMA */
 	}
-	return ide_dma_setup(drive);
+	return ide_dma_setup(drive, cmd);
 }
 
 /**
Index: b/drivers/ide/au1xxx-ide.c
===================================================================
--- a/drivers/ide/au1xxx-ide.c
+++ b/drivers/ide/au1xxx-ide.c
@@ -209,15 +209,14 @@ static void auide_set_dma_mode(ide_drive
  */
 
 #ifdef CONFIG_BLK_DEV_IDE_AU1XXX_MDMA2_DBDMA
-static int auide_build_dmatable(ide_drive_t *drive)
+static int auide_build_dmatable(ide_drive_t *drive, struct ide_cmd *cmd)
 {
 	ide_hwif_t *hwif = drive->hwif;
-	struct request *rq = hwif->rq;
 	_auide_hwif *ahwif = &auide_hwif;
 	struct scatterlist *sg;
-	int i = hwif->cmd.sg_nents, iswrite, count = 0;
+	int i = cmd->sg_nents, count = 0;
+	int iswrite = !!(cmd->tf_flags & IDE_TFLAG_WRITE);
 
-	iswrite = (rq_data_dir(rq) == WRITE);
 	/* Save for interrupt context */
 	ahwif->drive = drive;
 
@@ -298,12 +297,10 @@ static void auide_dma_exec_cmd(ide_drive
 			    (2*WAIT_CMD), NULL);
 }
 
-static int auide_dma_setup(ide_drive_t *drive)
+static int auide_dma_setup(ide_drive_t *drive, struct ide_cmd *cmd)
 {
-	struct request *rq = drive->hwif->rq;
-
-	if (!auide_build_dmatable(drive)) {
-		ide_map_sg(drive, rq);
+	if (auide_build_dmatable(drive, cmd) == 0) {
+		ide_map_sg(drive, cmd);
 		return 1;
 	}
 
Index: b/drivers/ide/icside.c
===================================================================
--- a/drivers/ide/icside.c
+++ b/drivers/ide/icside.c
@@ -307,15 +307,14 @@ static void icside_dma_start(ide_drive_t
 	enable_dma(ec->dma);
 }
 
-static int icside_dma_setup(ide_drive_t *drive)
+static int icside_dma_setup(ide_drive_t *drive, struct ide_cmd *cmd)
 {
 	ide_hwif_t *hwif = drive->hwif;
 	struct expansion_card *ec = ECARD_DEV(hwif->dev);
 	struct icside_state *state = ecard_get_drvdata(ec);
-	struct request *rq = hwif->rq;
 	unsigned int dma_mode;
 
-	if (rq_data_dir(rq))
+	if (cmd->tf_flags & IDE_TFLAG_WRITE)
 		dma_mode = DMA_MODE_WRITE;
 	else
 		dma_mode = DMA_MODE_READ;
@@ -344,7 +343,7 @@ static int icside_dma_setup(ide_drive_t 
 	 * Tell the DMA engine about the SG table and
 	 * data direction.
 	 */
-	set_dma_sg(ec->dma, hwif->sg_table, hwif->cmd.sg_nents);
+	set_dma_sg(ec->dma, hwif->sg_table, cmd->sg_nents);
 	set_dma_mode(ec->dma, dma_mode);
 
 	drive->waiting_for_dma = 1;
Index: b/drivers/ide/ide-atapi.c
===================================================================
--- a/drivers/ide/ide-atapi.c
+++ b/drivers/ide/ide-atapi.c
@@ -626,12 +626,20 @@ ide_startstop_t ide_issue_pc(ide_drive_t
 {
 	struct ide_atapi_pc *pc;
 	ide_hwif_t *hwif = drive->hwif;
+	const struct ide_dma_ops *dma_ops = hwif->dma_ops;
+	struct ide_cmd *cmd = &hwif->cmd;
 	ide_expiry_t *expiry = NULL;
 	struct request *rq = hwif->rq;
 	unsigned int timeout;
 	u32 tf_flags;
 	u16 bcount;
 
+	if (drive->media != ide_floppy) {
+		if (rq_data_dir(rq))
+			cmd->tf_flags |= IDE_TFLAG_WRITE;
+		cmd->rq = rq;
+	}
+
 	if (dev_is_idecd(drive)) {
 		tf_flags = IDE_TFLAG_OUT_NSECT | IDE_TFLAG_OUT_LBAL;
 		bcount = ide_cd_get_xferlen(rq);
@@ -639,8 +647,8 @@ ide_startstop_t ide_issue_pc(ide_drive_t
 		timeout = ATAPI_WAIT_PC;
 
 		if (drive->dma) {
-			if (ide_build_sglist(drive, rq))
-				drive->dma = !hwif->dma_ops->dma_setup(drive);
+			if (ide_build_sglist(drive, cmd))
+				drive->dma = !dma_ops->dma_setup(drive, cmd);
 			else
 				drive->dma = 0;
 		}
@@ -663,8 +671,8 @@ ide_startstop_t ide_issue_pc(ide_drive_t
 
 		if ((pc->flags & PC_FLAG_DMA_OK) &&
 		     (drive->dev_flags & IDE_DFLAG_USING_DMA)) {
-			if (ide_build_sglist(drive, rq))
-				drive->dma = !hwif->dma_ops->dma_setup(drive);
+			if (ide_build_sglist(drive, cmd))
+				drive->dma = !dma_ops->dma_setup(drive, cmd);
 			else
 				drive->dma = 0;
 		}
Index: b/drivers/ide/ide-disk.c
===================================================================
--- a/drivers/ide/ide-disk.c
+++ b/drivers/ide/ide-disk.c
@@ -99,11 +99,6 @@ static ide_startstop_t __ide_do_rw_disk(
 	memset(&cmd, 0, sizeof(cmd));
 	cmd.tf_flags = IDE_TFLAG_TF | IDE_TFLAG_DEVICE;
 
-	if (dma == 0) {
-		ide_init_sg_cmd(&cmd, nsectors);
-		ide_map_sg(drive, rq);
-	}
-
 	if (drive->dev_flags & IDE_DFLAG_LBA) {
 		if (lba48) {
 			pr_debug("%s: LBA=0x%012llx\n", drive->name,
@@ -156,6 +151,11 @@ static ide_startstop_t __ide_do_rw_disk(
 	ide_tf_set_cmd(drive, &cmd, dma);
 	cmd.rq = rq;
 
+	if (dma == 0) {
+		ide_init_sg_cmd(&cmd, nsectors);
+		ide_map_sg(drive, &cmd);
+	}
+
 	rc = do_rw_taskfile(drive, &cmd);
 
 	if (rc == ide_stopped && dma) {
Index: b/drivers/ide/ide-dma-sff.c
===================================================================
--- a/drivers/ide/ide-dma-sff.c
+++ b/drivers/ide/ide-dma-sff.c
@@ -111,7 +111,7 @@ EXPORT_SYMBOL_GPL(ide_dma_host_set);
  *	May also be invoked from trm290.c
  */
 
-int ide_build_dmatable(ide_drive_t *drive, struct request *rq)
+int ide_build_dmatable(ide_drive_t *drive, struct ide_cmd *cmd)
 {
 	ide_hwif_t *hwif = drive->hwif;
 	__le32 *table = (__le32 *)hwif->dmatable_cpu;
@@ -120,7 +120,7 @@ int ide_build_dmatable(ide_drive_t *driv
 	struct scatterlist *sg;
 	u8 is_trm290 = !!(hwif->host_flags & IDE_HFLAG_TRM290);
 
-	for_each_sg(hwif->sg_table, sg, hwif->cmd.sg_nents, i) {
+	for_each_sg(hwif->sg_table, sg, cmd->sg_nents, i) {
 		u32 cur_addr, cur_len, xcount, bcount;
 
 		cur_addr = sg_dma_address(sg);
@@ -175,6 +175,7 @@ EXPORT_SYMBOL_GPL(ide_build_dmatable);
 /**
  *	ide_dma_setup	-	begin a DMA phase
  *	@drive: target device
+ *	@cmd: command
  *
  *	Build an IDE DMA PRD (IDE speak for scatter gather table)
  *	and then set up the DMA transfer registers for a device
@@ -185,17 +186,16 @@ EXPORT_SYMBOL_GPL(ide_build_dmatable);
  *	is returned.
  */
 
-int ide_dma_setup(ide_drive_t *drive)
+int ide_dma_setup(ide_drive_t *drive, struct ide_cmd *cmd)
 {
 	ide_hwif_t *hwif = drive->hwif;
-	struct request *rq = hwif->rq;
-	unsigned int reading = rq_data_dir(rq) ? 0 : ATA_DMA_WR;
 	u8 mmio = (hwif->host_flags & IDE_HFLAG_MMIO) ? 1 : 0;
+	u8 rw = (cmd->tf_flags & IDE_TFLAG_WRITE) ? 0 : ATA_DMA_WR;
 	u8 dma_stat;
 
 	/* fall back to pio! */
-	if (!ide_build_dmatable(drive, rq)) {
-		ide_map_sg(drive, rq);
+	if (ide_build_dmatable(drive, cmd) == 0) {
+		ide_map_sg(drive, cmd);
 		return 1;
 	}
 
@@ -208,9 +208,9 @@ int ide_dma_setup(ide_drive_t *drive)
 
 	/* specify r/w */
 	if (mmio)
-		writeb(reading, (void __iomem *)(hwif->dma_base + ATA_DMA_CMD));
+		writeb(rw, (void __iomem *)(hwif->dma_base + ATA_DMA_CMD));
 	else
-		outb(reading, hwif->dma_base + ATA_DMA_CMD);
+		outb(rw, hwif->dma_base + ATA_DMA_CMD);
 
 	/* read DMA status for INTR & ERROR flags */
 	dma_stat = hwif->dma_ops->dma_sff_read_status(hwif);
Index: b/drivers/ide/ide-dma.c
===================================================================
--- a/drivers/ide/ide-dma.c
+++ b/drivers/ide/ide-dma.c
@@ -120,7 +120,7 @@ int ide_dma_good_drive(ide_drive_t *driv
 /**
  *	ide_build_sglist	-	map IDE scatter gather for DMA I/O
  *	@drive: the drive to build the DMA table for
- *	@rq: the request holding the sg list
+ *	@cmd: command
  *
  *	Perform the DMA mapping magic necessary to access the source or
  *	target buffers of a request via DMA.  The lower layers of the
@@ -128,23 +128,22 @@ int ide_dma_good_drive(ide_drive_t *driv
  *	operate in a portable fashion.
  */
 
-int ide_build_sglist(ide_drive_t *drive, struct request *rq)
+int ide_build_sglist(ide_drive_t *drive, struct ide_cmd *cmd)
 {
 	ide_hwif_t *hwif = drive->hwif;
 	struct scatterlist *sg = hwif->sg_table;
-	struct ide_cmd *cmd = &hwif->cmd;
 	int i;
 
-	ide_map_sg(drive, rq);
+	ide_map_sg(drive, cmd);
 
-	if (rq_data_dir(rq) == READ)
-		cmd->sg_dma_direction = DMA_FROM_DEVICE;
-	else
+	if (cmd->tf_flags & IDE_TFLAG_WRITE)
 		cmd->sg_dma_direction = DMA_TO_DEVICE;
+	else
+		cmd->sg_dma_direction = DMA_FROM_DEVICE;
 
 	i = dma_map_sg(hwif->dev, sg, cmd->sg_nents, cmd->sg_dma_direction);
 	if (i == 0)
-		ide_map_sg(drive, rq);
+		ide_map_sg(drive, cmd);
 
 	return i;
 }
Index: b/drivers/ide/ide-floppy.c
===================================================================
--- a/drivers/ide/ide-floppy.c
+++ b/drivers/ide/ide-floppy.c
@@ -285,8 +285,12 @@ static ide_startstop_t ide_floppy_do_req
 		goto out_end;
 	}
 
+	if (rq_data_dir(rq))
+		cmd->tf_flags |= IDE_TFLAG_WRITE;
+	cmd->rq = rq;
+
 	ide_init_sg_cmd(cmd, rq->nr_sectors);
-	ide_map_sg(drive, rq);
+	ide_map_sg(drive, cmd);
 
 	pc->sg = hwif->sg_table;
 	pc->sg_cnt = cmd->sg_nents;
Index: b/drivers/ide/ide-io.c
===================================================================
--- a/drivers/ide/ide-io.c
+++ b/drivers/ide/ide-io.c
@@ -224,11 +224,11 @@ static ide_startstop_t do_special (ide_d
 	return ide_stopped;
 }
 
-void ide_map_sg(ide_drive_t *drive, struct request *rq)
+void ide_map_sg(ide_drive_t *drive, struct ide_cmd *cmd)
 {
 	ide_hwif_t *hwif = drive->hwif;
-	struct ide_cmd *cmd = &hwif->cmd;
 	struct scatterlist *sg = hwif->sg_table;
+	struct request *rq = cmd->rq;
 
 	if (rq->cmd_type == REQ_TYPE_ATA_TASKFILE) {
 		sg_init_one(sg, rq->buffer, rq->nr_sectors * SECTOR_SIZE);
@@ -269,7 +269,7 @@ static ide_startstop_t execute_drive_cmd
 	if (cmd) {
 		if (cmd->protocol == ATA_PROT_PIO) {
 			ide_init_sg_cmd(cmd, rq->nr_sectors);
-			ide_map_sg(drive, rq);
+			ide_map_sg(drive, cmd);
 		}
 
 		return do_rw_taskfile(drive, cmd);
Index: b/drivers/ide/ide-taskfile.c
===================================================================
--- a/drivers/ide/ide-taskfile.c
+++ b/drivers/ide/ide-taskfile.c
@@ -102,8 +102,8 @@ ide_startstop_t do_rw_taskfile(ide_drive
 		return ide_started;
 	default:
 		if ((drive->dev_flags & IDE_DFLAG_USING_DMA) == 0 ||
-		    ide_build_sglist(drive, hwif->rq) == 0 ||
-		    dma_ops->dma_setup(drive))
+		    ide_build_sglist(drive, cmd) == 0 ||
+		    dma_ops->dma_setup(drive, cmd))
 			return ide_stopped;
 		dma_ops->dma_exec_cmd(drive, tf->command);
 		dma_ops->dma_start(drive);
Index: b/drivers/ide/ns87415.c
===================================================================
--- a/drivers/ide/ns87415.c
+++ b/drivers/ide/ns87415.c
@@ -216,11 +216,11 @@ static int ns87415_dma_end(ide_drive_t *
 	return (dma_stat & 7) != 4;
 }
 
-static int ns87415_dma_setup(ide_drive_t *drive)
+static int ns87415_dma_setup(ide_drive_t *drive, struct ide_cmd *cmd)
 {
 	/* select DMA xfer */
 	ns87415_prepare_drive(drive, 1);
-	if (!ide_dma_setup(drive))
+	if (ide_dma_setup(drive, cmd) == 0)
 		return 0;
 	/* DMA failed: select PIO xfer */
 	ns87415_prepare_drive(drive, 0);
Index: b/drivers/ide/pmac.c
===================================================================
--- a/drivers/ide/pmac.c
+++ b/drivers/ide/pmac.c
@@ -404,7 +404,6 @@ kauai_lookup_timing(struct kauai_timing*
 #define IDE_WAKEUP_DELAY	(1*HZ)
 
 static int pmac_ide_init_dma(ide_hwif_t *, const struct ide_port_info *);
-static int pmac_ide_build_dmatable(ide_drive_t *drive, struct request *rq);
 static void pmac_ide_selectproc(ide_drive_t *drive);
 static void pmac_ide_kauai_selectproc(ide_drive_t *drive);
 
@@ -1422,8 +1421,7 @@ out:
  * pmac_ide_build_dmatable builds the DBDMA command list
  * for a transfer and sets the DBDMA channel to point to it.
  */
-static int
-pmac_ide_build_dmatable(ide_drive_t *drive, struct request *rq)
+static int pmac_ide_build_dmatable(ide_drive_t *drive, struct ide_cmd *cmd)
 {
 	ide_hwif_t *hwif = drive->hwif;
 	pmac_ide_hwif_t *pmif =
@@ -1431,8 +1429,8 @@ pmac_ide_build_dmatable(ide_drive_t *dri
 	struct dbdma_cmd *table;
 	volatile struct dbdma_regs __iomem *dma = pmif->dma_regs;
 	struct scatterlist *sg;
-	int wr = (rq_data_dir(rq) == WRITE);
-	int i = hwif->cmd.sg_nents, count = 0;
+	int wr = !!(cmd->tf_flags & IDE_TFLAG_WRITE);
+	int i = cmd->sg_nents, count = 0;
 
 	/* DMA table is already aligned */
 	table = (struct dbdma_cmd *) pmif->dma_table_cpu;
@@ -1504,23 +1502,22 @@ use_pio_instead:
  * Prepare a DMA transfer. We build the DMA table, adjust the timings for
  * a read on KeyLargo ATA/66 and mark us as waiting for DMA completion
  */
-static int
-pmac_ide_dma_setup(ide_drive_t *drive)
+static int pmac_ide_dma_setup(ide_drive_t *drive, struct ide_cmd *cmd)
 {
 	ide_hwif_t *hwif = drive->hwif;
 	pmac_ide_hwif_t *pmif =
 		(pmac_ide_hwif_t *)dev_get_drvdata(hwif->gendev.parent);
-	struct request *rq = hwif->rq;
 	u8 unit = drive->dn & 1, ata4 = (pmif->kind == controller_kl_ata4);
+	u8 write = !!(cmd->tf_flags & IDE_TFLAG_WRITE);
 
-	if (!pmac_ide_build_dmatable(drive, rq)) {
-		ide_map_sg(drive, rq);
+	if (pmac_ide_build_dmatable(drive, cmd) == 0) {
+		ide_map_sg(drive, cmd);
 		return 1;
 	}
 
 	/* Apple adds 60ns to wrDataSetup on reads */
 	if (ata4 && (pmif->timings[unit] & TR_66_UDMA_EN)) {
-		writel(pmif->timings[unit] + (!rq_data_dir(rq) ? 0x00800000UL : 0),
+		writel(pmif->timings[unit] + (write ? 0 : 0x00800000UL),
 			PMAC_IDE_REG(IDE_TIMING_CONFIG));
 		(void)readl(PMAC_IDE_REG(IDE_TIMING_CONFIG));
 	}
Index: b/drivers/ide/scc_pata.c
===================================================================
--- a/drivers/ide/scc_pata.c
+++ b/drivers/ide/scc_pata.c
@@ -303,8 +303,9 @@ static void scc_dma_host_set(ide_drive_t
 }
 
 /**
- *	scc_ide_dma_setup	-	begin a DMA phase
+ *	scc_dma_setup	-	begin a DMA phase
  *	@drive: target device
+ *	@cmd: command
  *
  *	Build an IDE DMA PRD (IDE speak for scatter gather table)
  *	and then set up the DMA transfer registers.
@@ -313,21 +314,15 @@ static void scc_dma_host_set(ide_drive_t
  *	is returned.
  */
 
-static int scc_dma_setup(ide_drive_t *drive)
+static int scc_dma_setup(ide_drive_t *drive, struct ide_cmd *cmd)
 {
 	ide_hwif_t *hwif = drive->hwif;
-	struct request *rq = hwif->rq;
-	unsigned int reading;
+	u32 rw = (cmd->tf_flags & IDE_TFLAG_WRITE) ? 0 : ATA_DMA_WR;
 	u8 dma_stat;
 
-	if (rq_data_dir(rq))
-		reading = 0;
-	else
-		reading = 1 << 3;
-
 	/* fall back to pio! */
-	if (!ide_build_dmatable(drive, rq)) {
-		ide_map_sg(drive, rq);
+	if (ide_build_dmatable(drive, cmd) == 0) {
+		ide_map_sg(drive, cmd);
 		return 1;
 	}
 
@@ -335,7 +330,7 @@ static int scc_dma_setup(ide_drive_t *dr
 	out_be32((void __iomem *)(hwif->dma_base + 8), hwif->dmatable_dma);
 
 	/* specify r/w */
-	out_be32((void __iomem *)hwif->dma_base, reading);
+	out_be32((void __iomem *)hwif->dma_base, rw);
 
 	/* read DMA status for INTR & ERROR flags */
 	dma_stat = scc_dma_sff_read_status(hwif);
Index: b/drivers/ide/sgiioc4.c
===================================================================
--- a/drivers/ide/sgiioc4.c
+++ b/drivers/ide/sgiioc4.c
@@ -424,12 +424,11 @@ sgiioc4_configure_for_dma(int dma_direct
 /* | Upper 32 bits - Zero	    |EOL| 15 unused     | 16 Bit Length| */
 /* --------------------------------------------------------------------- */
 /* Creates the scatter gather list, DMA Table */
-static unsigned int
-sgiioc4_build_dma_table(ide_drive_t * drive, struct request *rq, int ddir)
+static int sgiioc4_build_dmatable(ide_drive_t *drive, struct ide_cmd *cmd)
 {
 	ide_hwif_t *hwif = drive->hwif;
 	unsigned int *table = hwif->dmatable_cpu;
-	unsigned int count = 0, i = hwif->cmd.sg_nents;
+	unsigned int count = 0, i = cmd->sg_nents;
 	struct scatterlist *sg = hwif->sg_table;
 
 	while (i && sg_dma_len(sg)) {
@@ -484,24 +483,18 @@ use_pio_instead:
 	return 0;		/* revert to PIO for this request */
 }
 
-static int sgiioc4_dma_setup(ide_drive_t *drive)
+static int sgiioc4_dma_setup(ide_drive_t *drive, struct ide_cmd *cmd)
 {
-	struct request *rq = drive->hwif->rq;
-	unsigned int count = 0;
 	int ddir;
+	u8 write = !!(cmd->tf_flags & IDE_TFLAG_WRITE);
 
-	if (rq_data_dir(rq))
-		ddir = PCI_DMA_TODEVICE;
-	else
-		ddir = PCI_DMA_FROMDEVICE;
-
-	if (!(count = sgiioc4_build_dma_table(drive, rq, ddir))) {
+	if (sgiioc4_build_dmatable(drive, cmd) == 0) {
 		/* try PIO instead of DMA */
-		ide_map_sg(drive, rq);
+		ide_map_sg(drive, cmd);
 		return 1;
 	}
 
-	if (rq_data_dir(rq))
+	if (write)
 		/* Writes TO the IOC4 FROM Main Memory */
 		ddir = IOC4_DMA_READ;
 	else
Index: b/drivers/ide/trm290.c
===================================================================
--- a/drivers/ide/trm290.c
+++ b/drivers/ide/trm290.c
@@ -181,13 +181,12 @@ static void trm290_dma_exec_cmd(ide_driv
 	ide_execute_command(drive, command, &ide_dma_intr, WAIT_CMD, NULL);
 }
 
-static int trm290_dma_setup(ide_drive_t *drive)
+static int trm290_dma_setup(ide_drive_t *drive, struct ide_cmd *cmd)
 {
 	ide_hwif_t *hwif = drive->hwif;
-	struct request *rq = hwif->rq;
 	unsigned int count, rw;
 
-	if (rq_data_dir(rq)) {
+	if (cmd->tf_flags & IDE_TFLAG_WRITE) {
 #ifdef TRM290_NO_DMA_WRITES
 		/* always use PIO for writes */
 		trm290_prepare_drive(drive, 0);	/* select PIO xfer */
@@ -197,8 +196,9 @@ static int trm290_dma_setup(ide_drive_t 
 	} else
 		rw = 2;
 
-	if (!(count = ide_build_dmatable(drive, rq))) {
-		ide_map_sg(drive, rq);
+	count = ide_build_dmatable(drive, cmd);
+	if (count == 0) {
+		ide_map_sg(drive, cmd);
 		/* try PIO instead of DMA */
 		trm290_prepare_drive(drive, 0); /* select PIO xfer */
 		return 1;
Index: b/drivers/ide/tx4939ide.c
===================================================================
--- a/drivers/ide/tx4939ide.c
+++ b/drivers/ide/tx4939ide.c
@@ -232,7 +232,7 @@ static u8 tx4939ide_clear_dma_status(voi
 
 #ifdef __BIG_ENDIAN
 /* custom ide_build_dmatable to handle swapped layout */
-static int tx4939ide_build_dmatable(ide_drive_t *drive, struct request *rq)
+static int tx4939ide_build_dmatable(ide_drive_t *drive, struct ide_cmd *cmd)
 {
 	ide_hwif_t *hwif = drive->hwif;
 	u32 *table = (u32 *)hwif->dmatable_cpu;
@@ -240,7 +240,7 @@ static int tx4939ide_build_dmatable(ide_
 	int i;
 	struct scatterlist *sg;
 
-	for_each_sg(hwif->sg_table, sg, hwif->cmd.sg_nents, i) {
+	for_each_sg(hwif->sg_table, sg, cmd->sg_nents, i) {
 		u32 cur_addr, cur_len, bcount;
 
 		cur_addr = sg_dma_address(sg);
@@ -287,23 +287,15 @@ use_pio_instead:
 #define tx4939ide_build_dmatable	ide_build_dmatable
 #endif
 
-static int tx4939ide_dma_setup(ide_drive_t *drive)
+static int tx4939ide_dma_setup(ide_drive_t *drive, struct ide_cmd *cmd)
 {
 	ide_hwif_t *hwif = drive->hwif;
 	void __iomem *base = TX4939IDE_BASE(hwif);
-	struct request *rq = hwif->rq;
-	u8 reading;
-	int nent;
-
-	if (rq_data_dir(rq))
-		reading = 0;
-	else
-		reading = ATA_DMA_WR;
+	u8 rw = (cmd->tf_flags & IDE_TFLAG_WRITE) ? 0 : ATA_DMA_WR;
 
 	/* fall back to PIO! */
-	nent = tx4939ide_build_dmatable(drive, rq);
-	if (!nent) {
-		ide_map_sg(drive, rq);
+	if (tx4939ide_build_dmatable(drive, cmd) == 0) {
+		ide_map_sg(drive, cmd);
 		return 1;
 	}
 
@@ -311,7 +303,7 @@ static int tx4939ide_dma_setup(ide_drive
 	tx4939ide_writel(hwif->dmatable_dma, base, TX4939IDE_PRD_Ptr);
 
 	/* specify r/w */
-	tx4939ide_writeb(reading, base, TX4939IDE_DMA_Cmd);
+	tx4939ide_writeb(rw, base, TX4939IDE_DMA_Cmd);
 
 	/* clear INTR & ERROR flags */
 	tx4939ide_clear_dma_status(base);
@@ -320,7 +312,9 @@ static int tx4939ide_dma_setup(ide_drive
 
 	tx4939ide_writew(SECTOR_SIZE / 2, base, drive->dn ?
 			 TX4939IDE_Xfer_Cnt_2 : TX4939IDE_Xfer_Cnt_1);
-	tx4939ide_writew(rq->nr_sectors, base, TX4939IDE_Sec_Cnt);
+
+	tx4939ide_writew(cmd->rq->nr_sectors, base, TX4939IDE_Sec_Cnt);
+
 	return 0;
 }
 
Index: b/include/linux/ide.h
===================================================================
--- a/include/linux/ide.h
+++ b/include/linux/ide.h
@@ -713,7 +713,7 @@ struct ide_port_ops {
 
 struct ide_dma_ops {
 	void	(*dma_host_set)(struct ide_drive_s *, int);
-	int	(*dma_setup)(struct ide_drive_s *);
+	int	(*dma_setup)(struct ide_drive_s *, struct ide_cmd *);
 	void	(*dma_exec_cmd)(struct ide_drive_s *, u8);
 	void	(*dma_start)(struct ide_drive_s *);
 	int	(*dma_end)(struct ide_drive_s *);
@@ -1409,7 +1409,7 @@ int ide_pci_resume(struct pci_dev *);
 #define ide_pci_resume NULL
 #endif
 
-void ide_map_sg(ide_drive_t *, struct request *);
+void ide_map_sg(ide_drive_t *, struct ide_cmd *);
 void ide_init_sg_cmd(struct ide_cmd *, int);
 
 #define BAD_DMA_DRIVE		0
@@ -1444,14 +1444,14 @@ ide_startstop_t ide_dma_intr(ide_drive_t
 int ide_allocate_dma_engine(ide_hwif_t *);
 void ide_release_dma_engine(ide_hwif_t *);
 
-int ide_build_sglist(ide_drive_t *, struct request *);
+int ide_build_sglist(ide_drive_t *, struct ide_cmd *);
 void ide_destroy_dmatable(ide_drive_t *);
 
 #ifdef CONFIG_BLK_DEV_IDEDMA_SFF
 int config_drive_for_dma(ide_drive_t *);
-extern int ide_build_dmatable(ide_drive_t *, struct request *);
+int ide_build_dmatable(ide_drive_t *, struct ide_cmd *);
 void ide_dma_host_set(ide_drive_t *, int);
-extern int ide_dma_setup(ide_drive_t *);
+int ide_dma_setup(ide_drive_t *, struct ide_cmd *);
 void ide_dma_exec_cmd(ide_drive_t *, u8);
 extern void ide_dma_start(ide_drive_t *);
 int ide_dma_end(ide_drive_t *);
@@ -1479,7 +1479,7 @@ static inline void ide_check_dma_crc(ide
 static inline ide_startstop_t ide_dma_timeout_retry(ide_drive_t *drive, int error) { return ide_stopped; }
 static inline void ide_release_dma_engine(ide_hwif_t *hwif) { ; }
 static inline int ide_build_sglist(ide_drive_t *drive,
-				   struct request *rq) { return 0; }
+				   struct ide_cmd *cmd) { return 0; }
 #endif /* CONFIG_BLK_DEV_IDEDMA */
 
 #ifdef CONFIG_BLK_DEV_IDEACPI
