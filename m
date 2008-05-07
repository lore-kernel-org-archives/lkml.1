Return-Path: <linux-kernel-owner+w=401wt.eu-S1764541AbYEGRbv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764541AbYEGRbv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2008 13:31:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760127AbYEGR30
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 May 2008 13:29:26 -0400
Received: from ik-out-1112.google.com ([66.249.90.177]:36429 "EHLO
	ik-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751547AbYEGR3J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2008 13:29:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=k7bE7xLJ9MCOKBOlseFcrUjD7w4qm2EVfqC+mm05DFAdAPyxi/dJPaYxQoP2ZaAQhhWYLPJJ5AzBS/6kUMyTpyZmpuA4415Lp6tMa0WUyfIif+NrO9vGRnWMEuGvq5rIgj/VU4v26YyHmZKSidujPJCNp6XSiC8HdbZZy9D17sQ=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Subject: [PATCH 5/6] ide: move IRQ unmasking out from ->tf_load method
Date: Wed, 7 May 2008 19:44:32 +0200
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200805071944.32249.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move IRQ unmasking out from ->tf_load method to its users.

There should be no functional changes caused by this patch
(SELECT_MASK() is NOP except for hpt366, icside and sgiioc4).

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/h8300/ide-h8300.c |    2 --
 drivers/ide/ide-io.c          |    2 ++
 drivers/ide/ide-iops.c        |    5 +----
 drivers/ide/ide-taskfile.c    |    2 ++
 drivers/ide/pci/scc_pata.c    |    2 --
 include/linux/ide.h           |    1 +
 6 files changed, 6 insertions(+), 8 deletions(-)

Index: b/drivers/ide/h8300/ide-h8300.c
===================================================================
--- a/drivers/ide/h8300/ide-h8300.c
+++ b/drivers/ide/h8300/ide-h8300.c
@@ -52,8 +52,6 @@ static void h8300_tf_load(ide_drive_t *d
 	if (task->tf_flags & IDE_TFLAG_FLAGGED)
 		HIHI = 0xFF;
 
-	ide_set_irq(drive, 1);
-
 	if (task->tf_flags & IDE_TFLAG_OUT_DATA)
 		mm_outw((tf->hob_data << 8) | tf->data, io_ports->data_addr);
 
Index: b/drivers/ide/ide-io.c
===================================================================
--- a/drivers/ide/ide-io.c
+++ b/drivers/ide/ide-io.c
@@ -1576,6 +1576,8 @@ void ide_pktcmd_tf_load(ide_drive_t *dri
 	task.tf.lbah    = (bcount >> 8) & 0xff;
 
 	ide_tf_dump(drive->name, &task.tf);
+	ide_set_irq(drive, 1);
+	SELECT_MASK(drive, 0);
 	drive->hwif->tf_load(drive, &task);
 }
 
Index: b/drivers/ide/ide-iops.c
===================================================================
--- a/drivers/ide/ide-iops.c
+++ b/drivers/ide/ide-iops.c
@@ -95,7 +95,7 @@ void SELECT_DRIVE (ide_drive_t *drive)
 	hwif->OUTB(drive->select.all, hwif->io_ports.device_addr);
 }
 
-static void SELECT_MASK(ide_drive_t *drive, int mask)
+void SELECT_MASK(ide_drive_t *drive, int mask)
 {
 	const struct ide_port_ops *port_ops = drive->hwif->port_ops;
 
@@ -120,9 +120,6 @@ static void ide_tf_load(ide_drive_t *dri
 	if (task->tf_flags & IDE_TFLAG_FLAGGED)
 		HIHI = 0xFF;
 
-	ide_set_irq(drive, 1);
-	SELECT_MASK(drive, 0);
-
 	if (task->tf_flags & IDE_TFLAG_OUT_DATA) {
 		u16 data = (tf->hob_data << 8) | tf->data;
 
Index: b/drivers/ide/ide-taskfile.c
===================================================================
--- a/drivers/ide/ide-taskfile.c
+++ b/drivers/ide/ide-taskfile.c
@@ -109,6 +109,8 @@ ide_startstop_t do_rw_taskfile (ide_driv
 
 	if ((task->tf_flags & IDE_TFLAG_DMA_PIO_FALLBACK) == 0) {
 		ide_tf_dump(drive->name, tf);
+		ide_set_irq(drive, 1);
+		SELECT_MASK(drive, 0);
 		hwif->tf_load(drive, task);
 	}
 
Index: b/drivers/ide/pci/scc_pata.c
===================================================================
--- a/drivers/ide/pci/scc_pata.c
+++ b/drivers/ide/pci/scc_pata.c
@@ -662,8 +662,6 @@ static void scc_tf_load(ide_drive_t *dri
 	if (task->tf_flags & IDE_TFLAG_FLAGGED)
 		HIHI = 0xFF;
 
-	ide_set_irq(drive, 1);
-
 	if (task->tf_flags & IDE_TFLAG_OUT_DATA)
 		out_be32((void *)io_ports->data_addr,
 			 (tf->hob_data << 8) | tf->data);
Index: b/include/linux/ide.h
===================================================================
--- a/include/linux/ide.h
+++ b/include/linux/ide.h
@@ -958,6 +958,7 @@ typedef struct ide_task_s {
 void ide_tf_dump(const char *, struct ide_taskfile *);
 
 extern void SELECT_DRIVE(ide_drive_t *);
+void SELECT_MASK(ide_drive_t *, int);
 
 extern int drive_is_ready(ide_drive_t *);
 
