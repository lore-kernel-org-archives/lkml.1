Return-Path: <linux-kernel-owner+w=401wt.eu-S1761622AbYDLMSb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761622AbYDLMSb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Apr 2008 08:18:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761502AbYDLMSD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Apr 2008 08:18:03 -0400
Received: from fg-out-1718.google.com ([72.14.220.159]:21782 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761473AbYDLMSB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Apr 2008 08:18:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=Qck8djh+K7jdIghqk9NIo1rfDdeilq+G4MgzfFKHC6Zhtng9Ojq6XJczHz/bKGx7MAX47Vkt/IoWGNSHk+AyTTNBLhJ9uL5Gdt+3WCfKn+NE5jJSKDigq4Y1sUed+vH8ONN8Peg1GlvqVJaKayx/z7HH9PX7Kk5ertVvjlOHhtw=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Sat, 12 Apr 2008 14:34:08 +0200
Message-Id: <20080412123408.18751.58937.sendpatchset@localhost.localdomain>
In-Reply-To: <20080412123401.18751.17246.sendpatchset@localhost.localdomain>
References: <20080412123401.18751.17246.sendpatchset@localhost.localdomain>
Subject: [PATCH 2/9] ide: move ide_tf_{load,read} to ide-iops.c
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/ide-io.c       |   43 ---------------------
 drivers/ide/ide-iops.c     |   88 +++++++++++++++++++++++++++++++++++++++++++++
 drivers/ide/ide-taskfile.c |   45 -----------------------
 3 files changed, 88 insertions(+), 88 deletions(-)

Index: b/drivers/ide/ide-io.c
===================================================================
--- a/drivers/ide/ide-io.c
+++ b/drivers/ide/ide-io.c
@@ -295,49 +295,6 @@ static void ide_complete_pm_request (ide
 	spin_unlock_irqrestore(&ide_lock, flags);
 }
 
-void ide_tf_read(ide_drive_t *drive, ide_task_t *task)
-{
-	ide_hwif_t *hwif = drive->hwif;
-	struct ide_io_ports *io_ports = &hwif->io_ports;
-	struct ide_taskfile *tf = &task->tf;
-
-	if (task->tf_flags & IDE_TFLAG_IN_DATA) {
-		u16 data = hwif->INW(io_ports->data_addr);
-
-		tf->data = data & 0xff;
-		tf->hob_data = (data >> 8) & 0xff;
-	}
-
-	/* be sure we're looking at the low order bits */
-	hwif->OUTB(drive->ctl & ~0x80, io_ports->ctl_addr);
-
-	if (task->tf_flags & IDE_TFLAG_IN_NSECT)
-		tf->nsect  = hwif->INB(io_ports->nsect_addr);
-	if (task->tf_flags & IDE_TFLAG_IN_LBAL)
-		tf->lbal   = hwif->INB(io_ports->lbal_addr);
-	if (task->tf_flags & IDE_TFLAG_IN_LBAM)
-		tf->lbam   = hwif->INB(io_ports->lbam_addr);
-	if (task->tf_flags & IDE_TFLAG_IN_LBAH)
-		tf->lbah   = hwif->INB(io_ports->lbah_addr);
-	if (task->tf_flags & IDE_TFLAG_IN_DEVICE)
-		tf->device = hwif->INB(io_ports->device_addr);
-
-	if (task->tf_flags & IDE_TFLAG_LBA48) {
-		hwif->OUTB(drive->ctl | 0x80, io_ports->ctl_addr);
-
-		if (task->tf_flags & IDE_TFLAG_IN_HOB_FEATURE)
-			tf->hob_feature = hwif->INB(io_ports->feature_addr);
-		if (task->tf_flags & IDE_TFLAG_IN_HOB_NSECT)
-			tf->hob_nsect   = hwif->INB(io_ports->nsect_addr);
-		if (task->tf_flags & IDE_TFLAG_IN_HOB_LBAL)
-			tf->hob_lbal    = hwif->INB(io_ports->lbal_addr);
-		if (task->tf_flags & IDE_TFLAG_IN_HOB_LBAM)
-			tf->hob_lbam    = hwif->INB(io_ports->lbam_addr);
-		if (task->tf_flags & IDE_TFLAG_IN_HOB_LBAH)
-			tf->hob_lbah    = hwif->INB(io_ports->lbah_addr);
-	}
-}
-
 /**
  *	ide_end_drive_cmd	-	end an explicit drive command
  *	@drive: command 
Index: b/drivers/ide/ide-iops.c
===================================================================
--- a/drivers/ide/ide-iops.c
+++ b/drivers/ide/ide-iops.c
@@ -127,6 +127,94 @@ void SELECT_MASK (ide_drive_t *drive, in
 		port_ops->maskproc(drive, mask);
 }
 
+void ide_tf_load(ide_drive_t *drive, ide_task_t *task)
+{
+	ide_hwif_t *hwif = drive->hwif;
+	struct ide_io_ports *io_ports = &hwif->io_ports;
+	struct ide_taskfile *tf = &task->tf;
+	u8 HIHI = (task->tf_flags & IDE_TFLAG_LBA48) ? 0xE0 : 0xEF;
+
+	if (task->tf_flags & IDE_TFLAG_FLAGGED)
+		HIHI = 0xFF;
+
+	ide_set_irq(drive, 1);
+
+	if ((task->tf_flags & IDE_TFLAG_NO_SELECT_MASK) == 0)
+		SELECT_MASK(drive, 0);
+
+	if (task->tf_flags & IDE_TFLAG_OUT_DATA)
+		hwif->OUTW((tf->hob_data << 8) | tf->data, io_ports->data_addr);
+
+	if (task->tf_flags & IDE_TFLAG_OUT_HOB_FEATURE)
+		hwif->OUTB(tf->hob_feature, io_ports->feature_addr);
+	if (task->tf_flags & IDE_TFLAG_OUT_HOB_NSECT)
+		hwif->OUTB(tf->hob_nsect, io_ports->nsect_addr);
+	if (task->tf_flags & IDE_TFLAG_OUT_HOB_LBAL)
+		hwif->OUTB(tf->hob_lbal, io_ports->lbal_addr);
+	if (task->tf_flags & IDE_TFLAG_OUT_HOB_LBAM)
+		hwif->OUTB(tf->hob_lbam, io_ports->lbam_addr);
+	if (task->tf_flags & IDE_TFLAG_OUT_HOB_LBAH)
+		hwif->OUTB(tf->hob_lbah, io_ports->lbah_addr);
+
+	if (task->tf_flags & IDE_TFLAG_OUT_FEATURE)
+		hwif->OUTB(tf->feature, io_ports->feature_addr);
+	if (task->tf_flags & IDE_TFLAG_OUT_NSECT)
+		hwif->OUTB(tf->nsect, io_ports->nsect_addr);
+	if (task->tf_flags & IDE_TFLAG_OUT_LBAL)
+		hwif->OUTB(tf->lbal, io_ports->lbal_addr);
+	if (task->tf_flags & IDE_TFLAG_OUT_LBAM)
+		hwif->OUTB(tf->lbam, io_ports->lbam_addr);
+	if (task->tf_flags & IDE_TFLAG_OUT_LBAH)
+		hwif->OUTB(tf->lbah, io_ports->lbah_addr);
+
+	if (task->tf_flags & IDE_TFLAG_OUT_DEVICE)
+		hwif->OUTB((tf->device & HIHI) | drive->select.all,
+			   io_ports->device_addr);
+}
+
+void ide_tf_read(ide_drive_t *drive, ide_task_t *task)
+{
+	ide_hwif_t *hwif = drive->hwif;
+	struct ide_io_ports *io_ports = &hwif->io_ports;
+	struct ide_taskfile *tf = &task->tf;
+
+	if (task->tf_flags & IDE_TFLAG_IN_DATA) {
+		u16 data = hwif->INW(io_ports->data_addr);
+
+		tf->data = data & 0xff;
+		tf->hob_data = (data >> 8) & 0xff;
+	}
+
+	/* be sure we're looking at the low order bits */
+	hwif->OUTB(drive->ctl & ~0x80, io_ports->ctl_addr);
+
+	if (task->tf_flags & IDE_TFLAG_IN_NSECT)
+		tf->nsect  = hwif->INB(io_ports->nsect_addr);
+	if (task->tf_flags & IDE_TFLAG_IN_LBAL)
+		tf->lbal   = hwif->INB(io_ports->lbal_addr);
+	if (task->tf_flags & IDE_TFLAG_IN_LBAM)
+		tf->lbam   = hwif->INB(io_ports->lbam_addr);
+	if (task->tf_flags & IDE_TFLAG_IN_LBAH)
+		tf->lbah   = hwif->INB(io_ports->lbah_addr);
+	if (task->tf_flags & IDE_TFLAG_IN_DEVICE)
+		tf->device = hwif->INB(io_ports->device_addr);
+
+	if (task->tf_flags & IDE_TFLAG_LBA48) {
+		hwif->OUTB(drive->ctl | 0x80, io_ports->ctl_addr);
+
+		if (task->tf_flags & IDE_TFLAG_IN_HOB_FEATURE)
+			tf->hob_feature = hwif->INB(io_ports->feature_addr);
+		if (task->tf_flags & IDE_TFLAG_IN_HOB_NSECT)
+			tf->hob_nsect   = hwif->INB(io_ports->nsect_addr);
+		if (task->tf_flags & IDE_TFLAG_IN_HOB_LBAL)
+			tf->hob_lbal    = hwif->INB(io_ports->lbal_addr);
+		if (task->tf_flags & IDE_TFLAG_IN_HOB_LBAM)
+			tf->hob_lbam    = hwif->INB(io_ports->lbam_addr);
+		if (task->tf_flags & IDE_TFLAG_IN_HOB_LBAH)
+			tf->hob_lbah    = hwif->INB(io_ports->lbah_addr);
+	}
+}
+
 /*
  * Some localbus EIDE interfaces require a special access sequence
  * when using 32-bit I/O instructions to transfer data.  We call this
Index: b/drivers/ide/ide-taskfile.c
===================================================================
--- a/drivers/ide/ide-taskfile.c
+++ b/drivers/ide/ide-taskfile.c
@@ -47,51 +47,6 @@ void ide_tf_dump(const char *s, struct i
 #endif
 }
 
-void ide_tf_load(ide_drive_t *drive, ide_task_t *task)
-{
-	ide_hwif_t *hwif = drive->hwif;
-	struct ide_io_ports *io_ports = &hwif->io_ports;
-	struct ide_taskfile *tf = &task->tf;
-	u8 HIHI = (task->tf_flags & IDE_TFLAG_LBA48) ? 0xE0 : 0xEF;
-
-	if (task->tf_flags & IDE_TFLAG_FLAGGED)
-		HIHI = 0xFF;
-
-	ide_set_irq(drive, 1);
-
-	if ((task->tf_flags & IDE_TFLAG_NO_SELECT_MASK) == 0)
-		SELECT_MASK(drive, 0);
-
-	if (task->tf_flags & IDE_TFLAG_OUT_DATA)
-		hwif->OUTW((tf->hob_data << 8) | tf->data, io_ports->data_addr);
-
-	if (task->tf_flags & IDE_TFLAG_OUT_HOB_FEATURE)
-		hwif->OUTB(tf->hob_feature, io_ports->feature_addr);
-	if (task->tf_flags & IDE_TFLAG_OUT_HOB_NSECT)
-		hwif->OUTB(tf->hob_nsect, io_ports->nsect_addr);
-	if (task->tf_flags & IDE_TFLAG_OUT_HOB_LBAL)
-		hwif->OUTB(tf->hob_lbal, io_ports->lbal_addr);
-	if (task->tf_flags & IDE_TFLAG_OUT_HOB_LBAM)
-		hwif->OUTB(tf->hob_lbam, io_ports->lbam_addr);
-	if (task->tf_flags & IDE_TFLAG_OUT_HOB_LBAH)
-		hwif->OUTB(tf->hob_lbah, io_ports->lbah_addr);
-
-	if (task->tf_flags & IDE_TFLAG_OUT_FEATURE)
-		hwif->OUTB(tf->feature, io_ports->feature_addr);
-	if (task->tf_flags & IDE_TFLAG_OUT_NSECT)
-		hwif->OUTB(tf->nsect, io_ports->nsect_addr);
-	if (task->tf_flags & IDE_TFLAG_OUT_LBAL)
-		hwif->OUTB(tf->lbal, io_ports->lbal_addr);
-	if (task->tf_flags & IDE_TFLAG_OUT_LBAM)
-		hwif->OUTB(tf->lbam, io_ports->lbam_addr);
-	if (task->tf_flags & IDE_TFLAG_OUT_LBAH)
-		hwif->OUTB(tf->lbah, io_ports->lbah_addr);
-
-	if (task->tf_flags & IDE_TFLAG_OUT_DEVICE)
-		hwif->OUTB((tf->device & HIHI) | drive->select.all,
-			   io_ports->device_addr);
-}
-
 int taskfile_lib_get_identify (ide_drive_t *drive, u8 *buf)
 {
 	ide_task_t args;
