Return-Path: <linux-kernel-owner+w=401wt.eu-S1756826AbZBIXUy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756826AbZBIXUy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Feb 2009 18:20:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756085AbZBIXTP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Feb 2009 18:19:15 -0500
Received: from mail-bw0-f161.google.com ([209.85.218.161]:56753 "EHLO
	mail-bw0-f161.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755405AbZBIXTN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Feb 2009 18:19:13 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=GATucOFvLFIZS52VIBF0IV3MRnIRU2Rx6xUO//ze2DyDgXbdc/SNPxMiR3QuRzk1yw
         V25iMNuoQsmXGONVKw+Xf9D4s6r2elXyPQUJRCivuZv1Enwm3UZKQm4Pl2qYi9vIbqLo
         VBPF+bFUt5E8/UWROddO5PGaAY061voFsc514=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Borislav Petkov <petkovbb@gmail.com>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Tue, 10 Feb 2009 00:20:26 +0100
Message-Id: <20090209232026.32406.50385.sendpatchset@localhost.localdomain>
In-Reply-To: <20090209231945.32406.14874.sendpatchset@localhost.localdomain>
References: <20090209231945.32406.14874.sendpatchset@localhost.localdomain>
Subject: [PATCH 6/6] ide: keep track of number of bytes instead of sectors in struct ide_cmd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] ide: keep track of number of bytes instead of sectors in struct ide_cmd

* Pass number of bytes instead of sectors to ide_init_sg_cmd().

* Pass number of bytes to process to ide_pio_sector() and rename
  it to ide_pio_bytes().

* Rename ->nsect field to ->nbytes in struct ide_cmd and use
  ->nbytes, ->nleft and ->cursg_ofs to keep track of number of
  bytes instead of sectors.

There should be no functional changes caused by this patch.

Cc: Borislav Petkov <petkovbb@gmail.com>
Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/ide-disk.c     |    4 ++--
 drivers/ide/ide-floppy.c   |    2 +-
 drivers/ide/ide-io.c       |    6 +++---
 drivers/ide/ide-taskfile.c |   32 ++++++++++++++++----------------
 include/linux/ide.h        |    4 ++--
 5 files changed, 24 insertions(+), 24 deletions(-)

Index: b/drivers/ide/ide-disk.c
===================================================================
--- a/drivers/ide/ide-disk.c
+++ b/drivers/ide/ide-disk.c
@@ -152,7 +152,7 @@ static ide_startstop_t __ide_do_rw_disk(
 	cmd.rq = rq;
 
 	if (dma == 0) {
-		ide_init_sg_cmd(&cmd, nsectors);
+		ide_init_sg_cmd(&cmd, nsectors << 9);
 		ide_map_sg(drive, &cmd);
 	}
 
@@ -162,7 +162,7 @@ static ide_startstop_t __ide_do_rw_disk(
 		/* fallback to PIO */
 		cmd.tf_flags |= IDE_TFLAG_DMA_PIO_FALLBACK;
 		ide_tf_set_cmd(drive, &cmd, 0);
-		ide_init_sg_cmd(&cmd, nsectors);
+		ide_init_sg_cmd(&cmd, nsectors << 9);
 		rc = do_rw_taskfile(drive, &cmd);
 	}
 
Index: b/drivers/ide/ide-floppy.c
===================================================================
--- a/drivers/ide/ide-floppy.c
+++ b/drivers/ide/ide-floppy.c
@@ -293,7 +293,7 @@ static ide_startstop_t ide_floppy_do_req
 
 	cmd.rq = rq;
 
-	ide_init_sg_cmd(&cmd, rq->nr_sectors);
+	ide_init_sg_cmd(&cmd, rq->nr_sectors << 9);
 	ide_map_sg(drive, &cmd);
 
 	pc->sg = hwif->sg_table;
Index: b/drivers/ide/ide-io.c
===================================================================
--- a/drivers/ide/ide-io.c
+++ b/drivers/ide/ide-io.c
@@ -241,9 +241,9 @@ void ide_map_sg(ide_drive_t *drive, stru
 }
 EXPORT_SYMBOL_GPL(ide_map_sg);
 
-void ide_init_sg_cmd(struct ide_cmd *cmd, int nsect)
+void ide_init_sg_cmd(struct ide_cmd *cmd, unsigned int nr_bytes)
 {
-	cmd->nsect = cmd->nleft = nsect;
+	cmd->nbytes = cmd->nleft = nr_bytes;
 	cmd->cursg_ofs = 0;
 	cmd->cursg = NULL;
 }
@@ -268,7 +268,7 @@ static ide_startstop_t execute_drive_cmd
 
 	if (cmd) {
 		if (cmd->protocol == ATA_PROT_PIO) {
-			ide_init_sg_cmd(cmd, rq->nr_sectors);
+			ide_init_sg_cmd(cmd, rq->nr_sectors << 9);
 			ide_map_sg(drive, cmd);
 		}
 
Index: b/drivers/ide/ide-taskfile.c
===================================================================
--- a/drivers/ide/ide-taskfile.c
+++ b/drivers/ide/ide-taskfile.c
@@ -188,8 +188,8 @@ static u8 wait_drive_not_busy(ide_drive_
 	return stat;
 }
 
-static void ide_pio_sector(ide_drive_t *drive, struct ide_cmd *cmd,
-			   unsigned int write)
+static void ide_pio_bytes(ide_drive_t *drive, struct ide_cmd *cmd,
+			  unsigned int write, unsigned int nr_bytes)
 {
 	ide_hwif_t *hwif = drive->hwif;
 	struct scatterlist *sg = hwif->sg_table;
@@ -208,7 +208,7 @@ static void ide_pio_sector(ide_drive_t *
 	}
 
 	page = sg_page(cursg);
-	offset = cursg->offset + cmd->cursg_ofs * SECTOR_SIZE;
+	offset = cursg->offset + cmd->cursg_ofs;
 
 	/* get the current page and offset */
 	page = nth_page(page, (offset >> PAGE_SHIFT));
@@ -219,19 +219,19 @@ static void ide_pio_sector(ide_drive_t *
 #endif
 	buf = kmap_atomic(page, KM_BIO_SRC_IRQ) + offset;
 
-	cmd->nleft--;
-	cmd->cursg_ofs++;
+	cmd->nleft -= nr_bytes;
+	cmd->cursg_ofs += nr_bytes;
 
-	if ((cmd->cursg_ofs * SECTOR_SIZE) == cursg->length) {
+	if (cmd->cursg_ofs == cursg->length) {
 		cmd->cursg = sg_next(cmd->cursg);
 		cmd->cursg_ofs = 0;
 	}
 
 	/* do the actual data transfer */
 	if (write)
-		hwif->tp_ops->output_data(drive, cmd, buf, SECTOR_SIZE);
+		hwif->tp_ops->output_data(drive, cmd, buf, nr_bytes);
 	else
-		hwif->tp_ops->input_data(drive, cmd, buf, SECTOR_SIZE);
+		hwif->tp_ops->input_data(drive, cmd, buf, nr_bytes);
 
 	kunmap_atomic(buf, KM_BIO_SRC_IRQ);
 #ifdef CONFIG_HIGHMEM
@@ -244,9 +244,9 @@ static void ide_pio_multi(ide_drive_t *d
 {
 	unsigned int nsect;
 
-	nsect = min_t(unsigned int, cmd->nleft, drive->mult_count);
+	nsect = min_t(unsigned int, cmd->nleft >> 9, drive->mult_count);
 	while (nsect--)
-		ide_pio_sector(drive, cmd, write);
+		ide_pio_bytes(drive, cmd, write, SECTOR_SIZE);
 }
 
 static void ide_pio_datablock(ide_drive_t *drive, struct ide_cmd *cmd,
@@ -265,7 +265,7 @@ static void ide_pio_datablock(ide_drive_
 	if (cmd->tf_flags & IDE_TFLAG_MULTI_PIO)
 		ide_pio_multi(drive, cmd, write);
 	else
-		ide_pio_sector(drive, cmd, write);
+		ide_pio_bytes(drive, cmd, write, SECTOR_SIZE);
 
 	drive->io_32bit = saved_io_32bit;
 }
@@ -273,18 +273,18 @@ static void ide_pio_datablock(ide_drive_
 static void ide_error_cmd(ide_drive_t *drive, struct ide_cmd *cmd)
 {
 	if (cmd->tf_flags & IDE_TFLAG_FS) {
-		int sectors = cmd->nsect - cmd->nleft;
+		int nr_bytes = cmd->nbytes - cmd->nleft;
 
 		if (cmd->protocol == ATA_PROT_PIO &&
 		    ((cmd->tf_flags & IDE_TFLAG_WRITE) || cmd->nleft == 0)) {
 			if (cmd->tf_flags & IDE_TFLAG_MULTI_PIO)
-				sectors -= drive->mult_count;
+				nr_bytes -= drive->mult_count << 9;
 			else
-				sectors--;
+				nr_bytes -= SECTOR_SIZE;
 		}
 
-		if (sectors > 0)
-			ide_complete_rq(drive, 0, sectors << 9);
+		if (nr_bytes > 0)
+			ide_complete_rq(drive, 0, nr_bytes);
 	}
 }
 
Index: b/include/linux/ide.h
===================================================================
--- a/include/linux/ide.h
+++ b/include/linux/ide.h
@@ -349,7 +349,7 @@ struct ide_cmd {
 	int			sg_nents;	  /* number of sg entries */
 	int			sg_dma_direction; /* DMA transfer direction */
 
-	unsigned int		nsect;
+	unsigned int		nbytes;
 	unsigned int		nleft;
 	struct scatterlist	*cursg;
 	unsigned int		cursg_ofs;
@@ -1406,7 +1406,7 @@ int ide_pci_resume(struct pci_dev *);
 #endif
 
 void ide_map_sg(ide_drive_t *, struct ide_cmd *);
-void ide_init_sg_cmd(struct ide_cmd *, int);
+void ide_init_sg_cmd(struct ide_cmd *, unsigned int);
 
 #define BAD_DMA_DRIVE		0
 #define GOOD_DMA_DRIVE		1
