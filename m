Return-Path: <linux-kernel-owner+w=401wt.eu-S1761823AbYDLMSv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761823AbYDLMSv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Apr 2008 08:18:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761525AbYDLMSL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Apr 2008 08:18:11 -0400
Received: from fk-out-0910.google.com ([209.85.128.189]:35944 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761509AbYDLMSJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Apr 2008 08:18:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=huzm75oY9a7AaZAhJGfuhgxFoa8RrVAqM25exutmvtaJdWZA1suOJarWKcJiCupmw6FthIea2GFtNYc0dGMpJnZTglLrysj8xamoiUyC2/amDiw/LkKYpwoKuaUnjpyW3ZChMqswcJ6/N9EgHd4zOVOrMVmfN7hnQg/Di/9QyiE=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Sat, 12 Apr 2008 14:34:15 +0200
Message-Id: <20080412123415.18751.51136.sendpatchset@localhost.localdomain>
In-Reply-To: <20080412123401.18751.17246.sendpatchset@localhost.localdomain>
References: <20080412123401.18751.17246.sendpatchset@localhost.localdomain>
Subject: [PATCH 3/9] ide: add ->tf_load and ->tf_read methods
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Add ->tf_load and ->tf_read methods to ide_hwif_t and set the default
  methods in default_hwif_transport().

* Use ->tf_{load,read} instead o calling ide_tf_{load,read}() directly.

* Make ide_tf_{load,read}() static.

There should be no functional changes caused by this patch.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/ide-io.c       |    4 ++--
 drivers/ide/ide-iops.c     |    7 +++++--
 drivers/ide/ide-lib.c      |    2 +-
 drivers/ide/ide-taskfile.c |    2 +-
 include/linux/ide.h        |    8 +++++---
 5 files changed, 14 insertions(+), 9 deletions(-)

Index: b/drivers/ide/ide-io.c
===================================================================
--- a/drivers/ide/ide-io.c
+++ b/drivers/ide/ide-io.c
@@ -330,7 +330,7 @@ void ide_end_drive_cmd (ide_drive_t *dri
 			tf->error = err;
 			tf->status = stat;
 
-			ide_tf_read(drive, task);
+			drive->hwif->tf_read(drive, task);
 
 			if (task->tf_flags & IDE_TFLAG_DYN)
 				kfree(task);
@@ -1638,7 +1638,7 @@ void ide_pktcmd_tf_load(ide_drive_t *dri
 	task.tf.lbah    = (bcount >> 8) & 0xff;
 
 	ide_tf_dump(drive->name, &task.tf);
-	ide_tf_load(drive, &task);
+	drive->hwif->tf_load(drive, &task);
 }
 
 EXPORT_SYMBOL_GPL(ide_pktcmd_tf_load);
Index: b/drivers/ide/ide-iops.c
===================================================================
--- a/drivers/ide/ide-iops.c
+++ b/drivers/ide/ide-iops.c
@@ -127,7 +127,7 @@ void SELECT_MASK (ide_drive_t *drive, in
 		port_ops->maskproc(drive, mask);
 }
 
-void ide_tf_load(ide_drive_t *drive, ide_task_t *task)
+static void ide_tf_load(ide_drive_t *drive, ide_task_t *task)
 {
 	ide_hwif_t *hwif = drive->hwif;
 	struct ide_io_ports *io_ports = &hwif->io_ports;
@@ -172,7 +172,7 @@ void ide_tf_load(ide_drive_t *drive, ide
 			   io_ports->device_addr);
 }
 
-void ide_tf_read(ide_drive_t *drive, ide_task_t *task)
+static void ide_tf_read(ide_drive_t *drive, ide_task_t *task)
 {
 	ide_hwif_t *hwif = drive->hwif;
 	struct ide_io_ports *io_ports = &hwif->io_ports;
@@ -323,6 +323,9 @@ static void ata_output_data(ide_drive_t 
 
 void default_hwif_transport(ide_hwif_t *hwif)
 {
+	hwif->tf_load	  = ide_tf_load;
+	hwif->tf_read	  = ide_tf_read;
+
 	hwif->input_data  = ata_input_data;
 	hwif->output_data = ata_output_data;
 }
Index: b/drivers/ide/ide-lib.c
===================================================================
--- a/drivers/ide/ide-lib.c
+++ b/drivers/ide/ide-lib.c
@@ -487,7 +487,7 @@ static void ide_dump_sector(ide_drive_t 
 	else
 		task.tf_flags = IDE_TFLAG_IN_LBA | IDE_TFLAG_IN_DEVICE;
 
-	ide_tf_read(drive, &task);
+	drive->hwif->tf_read(drive, &task);
 
 	if (lba48 || (tf->device & ATA_LBA))
 		printk(", LBAsect=%llu",
Index: b/drivers/ide/ide-taskfile.c
===================================================================
--- a/drivers/ide/ide-taskfile.c
+++ b/drivers/ide/ide-taskfile.c
@@ -109,7 +109,7 @@ ide_startstop_t do_rw_taskfile (ide_driv
 
 	if ((task->tf_flags & IDE_TFLAG_DMA_PIO_FALLBACK) == 0) {
 		ide_tf_dump(drive->name, tf);
-		ide_tf_load(drive, task);
+		hwif->tf_load(drive, task);
 	}
 
 	switch (task->data_phase) {
Index: b/include/linux/ide.h
===================================================================
--- a/include/linux/ide.h
+++ b/include/linux/ide.h
@@ -429,6 +429,8 @@ struct ide_dma_ops {
 	void	(*dma_timeout)(struct ide_drive_s *);
 };
 
+struct ide_task_s;
+
 typedef struct hwif_s {
 	struct hwif_s *next;		/* for linked-list in ide_hwgroup_t */
 	struct hwif_s *mate;		/* other hwif from same PCI chip */
@@ -469,6 +471,9 @@ typedef struct hwif_s {
 	const struct ide_port_ops	*port_ops;
 	const struct ide_dma_ops	*dma_ops;
 
+	void (*tf_load)(ide_drive_t *, struct ide_task_s *);
+	void (*tf_read)(ide_drive_t *, struct ide_task_s *);
+
 	void (*input_data)(ide_drive_t *, struct request *, void *, unsigned);
 	void (*output_data)(ide_drive_t *, struct request *, void *, unsigned);
 
@@ -951,9 +956,6 @@ typedef struct ide_task_s {
 
 void ide_tf_dump(const char *, struct ide_taskfile *);
 
-void ide_tf_load(ide_drive_t *, ide_task_t *);
-void ide_tf_read(ide_drive_t *, ide_task_t *);
-
 extern void SELECT_DRIVE(ide_drive_t *);
 extern void SELECT_MASK(ide_drive_t *, int);
 
