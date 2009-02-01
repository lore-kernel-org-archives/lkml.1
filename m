Return-Path: <linux-kernel-owner+w=401wt.eu-S1756572AbZBARwG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756572AbZBARwG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Feb 2009 12:52:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755843AbZBARtX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Feb 2009 12:49:23 -0500
Received: from fg-out-1718.google.com ([72.14.220.159]:43113 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755808AbZBARtU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Feb 2009 12:49:20 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=tXr6afw6E3VnuUOn60W9mDnSSguXYUzIa0cKXLB4UMtwXy5Jq7mCnxS3H5VwyXUiZy
         89BXlDJAGBJ88aOk8YL2xP1QcmRBin6vXVEn5RR3S3ma+86Gpiq8VDDdpZ1JAEGBXK1G
         s/M6EBomUcurcZ3/BebWw+LmIbDleI8C8vNqc=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Sun, 01 Feb 2009 18:50:12 +0100
Message-Id: <20090201175012.19144.87417.sendpatchset@localhost.localdomain>
In-Reply-To: <20090201174909.19144.67767.sendpatchset@localhost.localdomain>
References: <20090201174909.19144.67767.sendpatchset@localhost.localdomain>
Subject: [PATCH 09/15] ide: add "flagged" taskfile flags to struct ide_taskfile
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] ide: add "flagged" taskfile flags to struct ide_taskfile

* Add ->ftf_flags field to struct ide_taskfile
  and convert flags for TASKFILE ioctl to use it.

* Rename "flagged" taskfile flags:
  - IDE_TFLAG_FLAGGED -> IDE_FTFLAG_FLAGGED
  - IDE_TFLAG_FLAGGED_SET_IN_FLAGS -> IDE_FTFLAG_SET_IN_FLAGS
  - IDE_TFLAG_{OUT,IN}_DATA -> IDE_FTFLAG_{OUT,IN}_DATA

There should be no functional changes caused by this patch.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/ide-h8300.c    |    4 +-
 drivers/ide/ide-io-std.c   |    6 ++--
 drivers/ide/ide-taskfile.c |   12 ++++----
 drivers/ide/ns87415.c      |    2 -
 drivers/ide/scc_pata.c     |    4 +-
 drivers/ide/tx4938ide.c    |    4 +-
 drivers/ide/tx4939ide.c    |    4 +-
 include/linux/ide.h        |   66 +++++++++++++++++++++++----------------------
 8 files changed, 53 insertions(+), 49 deletions(-)

Index: b/drivers/ide/ide-h8300.c
===================================================================
--- a/drivers/ide/ide-h8300.c
+++ b/drivers/ide/ide-h8300.c
@@ -54,7 +54,7 @@ static void h8300_tf_load(ide_drive_t *d
 	if (task->tf_flags & IDE_TFLAG_FLAGGED)
 		HIHI = 0xFF;
 
-	if (task->tf_flags & IDE_TFLAG_OUT_DATA)
+	if (task->ftf_flags & IDE_FTFLAG_OUT_DATA)
 		mm_outw((tf->hob_data << 8) | tf->data, io_ports->data_addr);
 
 	if (task->tf_flags & IDE_TFLAG_OUT_HOB_FEATURE)
@@ -90,7 +90,7 @@ static void h8300_tf_read(ide_drive_t *d
 	struct ide_io_ports *io_ports = &hwif->io_ports;
 	struct ide_taskfile *tf = &task->tf;
 
-	if (task->tf_flags & IDE_TFLAG_IN_DATA) {
+	if (task->ftf_flags & IDE_FTFLAG_IN_DATA) {
 		u16 data = mm_inw(io_ports->data_addr);
 
 		tf->data = data & 0xff;
Index: b/drivers/ide/ide-io-std.c
===================================================================
--- a/drivers/ide/ide-io-std.c
+++ b/drivers/ide/ide-io-std.c
@@ -96,10 +96,10 @@ void ide_tf_load(ide_drive_t *drive, ide
 	else
 		tf_outb = ide_outb;
 
-	if (task->tf_flags & IDE_TFLAG_FLAGGED)
+	if (task->ftf_flags & IDE_FTFLAG_FLAGGED)
 		HIHI = 0xFF;
 
-	if (task->tf_flags & IDE_TFLAG_OUT_DATA) {
+	if (task->ftf_flags & IDE_FTFLAG_OUT_DATA) {
 		u16 data = (tf->hob_data << 8) | tf->data;
 
 		if (mmio)
@@ -153,7 +153,7 @@ void ide_tf_read(ide_drive_t *drive, ide
 		tf_inb  = ide_inb;
 	}
 
-	if (task->tf_flags & IDE_TFLAG_IN_DATA) {
+	if (task->ftf_flags & IDE_FTFLAG_IN_DATA) {
 		u16 data;
 
 		if (mmio)
Index: b/drivers/ide/ide-taskfile.c
===================================================================
--- a/drivers/ide/ide-taskfile.c
+++ b/drivers/ide/ide-taskfile.c
@@ -73,8 +73,8 @@ ide_startstop_t do_rw_taskfile (ide_driv
 		}
 	}
 
-	if (task->tf_flags & IDE_TFLAG_FLAGGED)
-		task->tf_flags |= IDE_TFLAG_FLAGGED_SET_IN_FLAGS;
+	if (task->ftf_flags & IDE_FTFLAG_FLAGGED)
+		task->ftf_flags |= IDE_FTFLAG_SET_IN_FLAGS;
 
 	memcpy(&hwif->task, task, sizeof(*task));
 
@@ -551,10 +551,10 @@ int ide_taskfile_ioctl (ide_drive_t *dri
 		args.tf_flags |= (IDE_TFLAG_LBA48 | IDE_TFLAG_IN_HOB);
 
 	if (req_task->out_flags.all) {
-		args.tf_flags |= IDE_TFLAG_FLAGGED;
+		args.ftf_flags |= IDE_FTFLAG_FLAGGED;
 
 		if (req_task->out_flags.b.data)
-			args.tf_flags |= IDE_TFLAG_OUT_DATA;
+			args.ftf_flags |= IDE_FTFLAG_OUT_DATA;
 
 		if (req_task->out_flags.b.nsector_hob)
 			args.tf_flags |= IDE_TFLAG_OUT_HOB_NSECT;
@@ -582,7 +582,7 @@ int ide_taskfile_ioctl (ide_drive_t *dri
 	}
 
 	if (req_task->in_flags.b.data)
-		args.tf_flags |= IDE_TFLAG_IN_DATA;
+		args.ftf_flags |= IDE_FTFLAG_IN_DATA;
 
 	switch(req_task->data_phase) {
 		case TASKFILE_MULTI_OUT:
@@ -647,7 +647,7 @@ int ide_taskfile_ioctl (ide_drive_t *dri
 	memcpy(req_task->hob_ports, &args.tf_array[0], HDIO_DRIVE_HOB_HDR_SIZE - 2);
 	memcpy(req_task->io_ports, &args.tf_array[6], HDIO_DRIVE_TASK_HDR_SIZE);
 
-	if ((args.tf_flags & IDE_TFLAG_FLAGGED_SET_IN_FLAGS) &&
+	if ((args.ftf_flags & IDE_FTFLAG_SET_IN_FLAGS) &&
 	    req_task->in_flags.all == 0) {
 		req_task->in_flags.all = IDE_TASKFILE_STD_IN_FLAGS;
 		if (drive->dev_flags & IDE_DFLAG_LBA48)
Index: b/drivers/ide/ns87415.c
===================================================================
--- a/drivers/ide/ns87415.c
+++ b/drivers/ide/ns87415.c
@@ -66,7 +66,7 @@ static void superio_tf_read(ide_drive_t 
 	struct ide_io_ports *io_ports = &drive->hwif->io_ports;
 	struct ide_taskfile *tf = &task->tf;
 
-	if (task->tf_flags & IDE_TFLAG_IN_DATA) {
+	if (task->ftf_flags & IDE_FTFLAG_IN_DATA) {
 		u16 data = inw(io_ports->data_addr);
 
 		tf->data = data & 0xff;
Index: b/drivers/ide/scc_pata.c
===================================================================
--- a/drivers/ide/scc_pata.c
+++ b/drivers/ide/scc_pata.c
@@ -675,7 +675,7 @@ static void scc_tf_load(ide_drive_t *dri
 	if (task->tf_flags & IDE_TFLAG_FLAGGED)
 		HIHI = 0xFF;
 
-	if (task->tf_flags & IDE_TFLAG_OUT_DATA)
+	if (task->ftf_flags & IDE_FTFLAG_OUT_DATA)
 		out_be32((void *)io_ports->data_addr,
 			 (tf->hob_data << 8) | tf->data);
 
@@ -711,7 +711,7 @@ static void scc_tf_read(ide_drive_t *dri
 	struct ide_io_ports *io_ports = &drive->hwif->io_ports;
 	struct ide_taskfile *tf = &task->tf;
 
-	if (task->tf_flags & IDE_TFLAG_IN_DATA) {
+	if (task->ftf_flags & IDE_FTFLAG_IN_DATA) {
 		u16 data = (u16)in_be32((void *)io_ports->data_addr);
 
 		tf->data = data & 0xff;
Index: b/drivers/ide/tx4938ide.c
===================================================================
--- a/drivers/ide/tx4938ide.c
+++ b/drivers/ide/tx4938ide.c
@@ -92,7 +92,7 @@ static void tx4938ide_tf_load(ide_drive_
 	if (task->tf_flags & IDE_TFLAG_FLAGGED)
 		HIHI = 0xFF;
 
-	if (task->tf_flags & IDE_TFLAG_OUT_DATA) {
+	if (task->ftf_flags & IDE_FTFLAG_OUT_DATA) {
 		u16 data = (tf->hob_data << 8) | tf->data;
 
 		/* no endian swap */
@@ -132,7 +132,7 @@ static void tx4938ide_tf_read(ide_drive_
 	struct ide_io_ports *io_ports = &hwif->io_ports;
 	struct ide_taskfile *tf = &task->tf;
 
-	if (task->tf_flags & IDE_TFLAG_IN_DATA) {
+	if (task->ftf_flags & IDE_FTFLAG_IN_DATA) {
 		u16 data;
 
 		/* no endian swap */
Index: b/drivers/ide/tx4939ide.c
===================================================================
--- a/drivers/ide/tx4939ide.c
+++ b/drivers/ide/tx4939ide.c
@@ -477,7 +477,7 @@ static void tx4939ide_tf_load(ide_drive_
 	if (task->tf_flags & IDE_TFLAG_FLAGGED)
 		HIHI = 0xFF;
 
-	if (task->tf_flags & IDE_TFLAG_OUT_DATA) {
+	if (task->ftf_flags & IDE_FTFLAG_OUT_DATA) {
 		u16 data = (tf->hob_data << 8) | tf->data;
 
 		/* no endian swap */
@@ -519,7 +519,7 @@ static void tx4939ide_tf_read(ide_drive_
 	struct ide_io_ports *io_ports = &hwif->io_ports;
 	struct ide_taskfile *tf = &task->tf;
 
-	if (task->tf_flags & IDE_TFLAG_IN_DATA) {
+	if (task->ftf_flags & IDE_FTFLAG_IN_DATA) {
 		u16 data;
 
 		/* no endian swap */
Index: b/include/linux/ide.h
===================================================================
--- a/include/linux/ide.h
+++ b/include/linux/ide.h
@@ -234,56 +234,52 @@ typedef enum {
 
 enum {
 	IDE_TFLAG_LBA48			= (1 << 0),
-	IDE_TFLAG_FLAGGED		= (1 << 2),
-	IDE_TFLAG_OUT_DATA		= (1 << 3),
-	IDE_TFLAG_OUT_HOB_FEATURE	= (1 << 4),
-	IDE_TFLAG_OUT_HOB_NSECT		= (1 << 5),
-	IDE_TFLAG_OUT_HOB_LBAL		= (1 << 6),
-	IDE_TFLAG_OUT_HOB_LBAM		= (1 << 7),
-	IDE_TFLAG_OUT_HOB_LBAH		= (1 << 8),
+	IDE_TFLAG_OUT_HOB_FEATURE	= (1 << 1),
+	IDE_TFLAG_OUT_HOB_NSECT		= (1 << 2),
+	IDE_TFLAG_OUT_HOB_LBAL		= (1 << 3),
+	IDE_TFLAG_OUT_HOB_LBAM		= (1 << 4),
+	IDE_TFLAG_OUT_HOB_LBAH		= (1 << 5),
 	IDE_TFLAG_OUT_HOB		= IDE_TFLAG_OUT_HOB_FEATURE |
 					  IDE_TFLAG_OUT_HOB_NSECT |
 					  IDE_TFLAG_OUT_HOB_LBAL |
 					  IDE_TFLAG_OUT_HOB_LBAM |
 					  IDE_TFLAG_OUT_HOB_LBAH,
-	IDE_TFLAG_OUT_FEATURE		= (1 << 9),
-	IDE_TFLAG_OUT_NSECT		= (1 << 10),
-	IDE_TFLAG_OUT_LBAL		= (1 << 11),
-	IDE_TFLAG_OUT_LBAM		= (1 << 12),
-	IDE_TFLAG_OUT_LBAH		= (1 << 13),
+	IDE_TFLAG_OUT_FEATURE		= (1 << 6),
+	IDE_TFLAG_OUT_NSECT		= (1 << 7),
+	IDE_TFLAG_OUT_LBAL		= (1 << 8),
+	IDE_TFLAG_OUT_LBAM		= (1 << 9),
+	IDE_TFLAG_OUT_LBAH		= (1 << 10),
 	IDE_TFLAG_OUT_TF		= IDE_TFLAG_OUT_FEATURE |
 					  IDE_TFLAG_OUT_NSECT |
 					  IDE_TFLAG_OUT_LBAL |
 					  IDE_TFLAG_OUT_LBAM |
 					  IDE_TFLAG_OUT_LBAH,
-	IDE_TFLAG_OUT_DEVICE		= (1 << 14),
-	IDE_TFLAG_WRITE			= (1 << 15),
-	IDE_TFLAG_FLAGGED_SET_IN_FLAGS	= (1 << 16),
-	IDE_TFLAG_IN_DATA		= (1 << 17),
-	IDE_TFLAG_CUSTOM_HANDLER	= (1 << 18),
-	IDE_TFLAG_DMA_PIO_FALLBACK	= (1 << 19),
-	IDE_TFLAG_IN_HOB_FEATURE	= (1 << 20),
-	IDE_TFLAG_IN_HOB_NSECT		= (1 << 21),
-	IDE_TFLAG_IN_HOB_LBAL		= (1 << 22),
-	IDE_TFLAG_IN_HOB_LBAM		= (1 << 23),
-	IDE_TFLAG_IN_HOB_LBAH		= (1 << 24),
+	IDE_TFLAG_OUT_DEVICE		= (1 << 11),
+	IDE_TFLAG_WRITE			= (1 << 12),
+	IDE_TFLAG_CUSTOM_HANDLER	= (1 << 13),
+	IDE_TFLAG_DMA_PIO_FALLBACK	= (1 << 14),
+	IDE_TFLAG_IN_HOB_FEATURE	= (1 << 15),
+	IDE_TFLAG_IN_HOB_NSECT		= (1 << 16),
+	IDE_TFLAG_IN_HOB_LBAL		= (1 << 17),
+	IDE_TFLAG_IN_HOB_LBAM		= (1 << 18),
+	IDE_TFLAG_IN_HOB_LBAH		= (1 << 19),
 	IDE_TFLAG_IN_HOB_LBA		= IDE_TFLAG_IN_HOB_LBAL |
 					  IDE_TFLAG_IN_HOB_LBAM |
 					  IDE_TFLAG_IN_HOB_LBAH,
 	IDE_TFLAG_IN_HOB		= IDE_TFLAG_IN_HOB_FEATURE |
 					  IDE_TFLAG_IN_HOB_NSECT |
 					  IDE_TFLAG_IN_HOB_LBA,
-	IDE_TFLAG_IN_FEATURE		= (1 << 1),
-	IDE_TFLAG_IN_NSECT		= (1 << 25),
-	IDE_TFLAG_IN_LBAL		= (1 << 26),
-	IDE_TFLAG_IN_LBAM		= (1 << 27),
-	IDE_TFLAG_IN_LBAH		= (1 << 28),
+	IDE_TFLAG_IN_FEATURE		= (1 << 20),
+	IDE_TFLAG_IN_NSECT		= (1 << 21),
+	IDE_TFLAG_IN_LBAL		= (1 << 22),
+	IDE_TFLAG_IN_LBAM		= (1 << 23),
+	IDE_TFLAG_IN_LBAH		= (1 << 24),
 	IDE_TFLAG_IN_LBA		= IDE_TFLAG_IN_LBAL |
 					  IDE_TFLAG_IN_LBAM |
 					  IDE_TFLAG_IN_LBAH,
 	IDE_TFLAG_IN_TF			= IDE_TFLAG_IN_NSECT |
 					  IDE_TFLAG_IN_LBA,
-	IDE_TFLAG_IN_DEVICE		= (1 << 29),
+	IDE_TFLAG_IN_DEVICE		= (1 << 25),
 	IDE_TFLAG_HOB			= IDE_TFLAG_OUT_HOB |
 					  IDE_TFLAG_IN_HOB,
 	IDE_TFLAG_TF			= IDE_TFLAG_OUT_TF |
@@ -291,9 +287,16 @@ enum {
 	IDE_TFLAG_DEVICE		= IDE_TFLAG_OUT_DEVICE |
 					  IDE_TFLAG_IN_DEVICE,
 	/* force 16-bit I/O operations */
-	IDE_TFLAG_IO_16BIT		= (1 << 30),
+	IDE_TFLAG_IO_16BIT		= (1 << 26),
 	/* ide_task_t was allocated using kmalloc() */
-	IDE_TFLAG_DYN			= (1 << 31),
+	IDE_TFLAG_DYN			= (1 << 27),
+};
+
+enum {
+	IDE_FTFLAG_FLAGGED		= (1 << 0),
+	IDE_FTFLAG_SET_IN_FLAGS		= (1 << 1),
+	IDE_FTFLAG_OUT_DATA		= (1 << 2),
+	IDE_FTFLAG_IN_DATA		= (1 << 3),
 };
 
 struct ide_taskfile {
@@ -330,6 +333,7 @@ typedef struct ide_task_s {
 		struct ide_taskfile	tf;
 		u8			tf_array[14];
 	};
+	u8			ftf_flags;	/* for TASKFILE ioctl */
 	u32			tf_flags;
 	int			data_phase;
 	struct request		*rq;		/* copy of request */
