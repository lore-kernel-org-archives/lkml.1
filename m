Return-Path: <linux-kernel-owner+w=401wt.eu-S932173AbYDLMUk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932173AbYDLMUk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Apr 2008 08:20:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760409AbYDLMSp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Apr 2008 08:18:45 -0400
Received: from fg-out-1718.google.com ([72.14.220.152]:19942 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760562AbYDLMSn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Apr 2008 08:18:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=LHNvX5TX5sR9c7XVS+AJUwx6xKgsdmHzJ7+ffcNn4iFs+lF9Wo2gsRjUvYPTY02PKH1Y5QhYL/JiKAenVgQTYlxInq/NMReWQnHzIDQucFqp5jSQOF+qKruLvK5TMk+3sEUwLuwEhZCcNWAScOwmCOCmzyRPnqlGbeRzoUL/STs=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Sat, 12 Apr 2008 14:34:51 +0200
Message-Id: <20080412123451.18751.59868.sendpatchset@localhost.localdomain>
In-Reply-To: <20080412123401.18751.17246.sendpatchset@localhost.localdomain>
References: <20080412123401.18751.17246.sendpatchset@localhost.localdomain>
Subject: [PATCH 8/9] ide: use IDE I/O helpers directly in ide_tf_{load,read}()
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There should be no functional changes caused by this patch.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/ide-iops.c |   83 +++++++++++++++++++++++++++++++++----------------
 1 file changed, 56 insertions(+), 27 deletions(-)

Index: b/drivers/ide/ide-iops.c
===================================================================
--- a/drivers/ide/ide-iops.c
+++ b/drivers/ide/ide-iops.c
@@ -132,8 +132,15 @@ static void ide_tf_load(ide_drive_t *dri
 	ide_hwif_t *hwif = drive->hwif;
 	struct ide_io_ports *io_ports = &hwif->io_ports;
 	struct ide_taskfile *tf = &task->tf;
+	void (*tf_outb)(u8 addr, unsigned long port);
+	u8 mmio = (hwif->host_flags & IDE_HFLAG_MMIO) ? 1 : 0;
 	u8 HIHI = (task->tf_flags & IDE_TFLAG_LBA48) ? 0xE0 : 0xEF;
 
+	if (mmio)
+		tf_outb = ide_mm_outb;
+	else
+		tf_outb = ide_outb;
+
 	if (task->tf_flags & IDE_TFLAG_FLAGGED)
 		HIHI = 0xFF;
 
@@ -142,34 +149,40 @@ static void ide_tf_load(ide_drive_t *dri
 	if ((task->tf_flags & IDE_TFLAG_NO_SELECT_MASK) == 0)
 		SELECT_MASK(drive, 0);
 
-	if (task->tf_flags & IDE_TFLAG_OUT_DATA)
-		hwif->OUTW((tf->hob_data << 8) | tf->data, io_ports->data_addr);
+	if (task->tf_flags & IDE_TFLAG_OUT_DATA) {
+		u16 data = (tf->hob_data << 8) | tf->data;
+
+		if (mmio)
+			writew(data, (void __iomem *)io_ports->data_addr);
+		else
+			outw(data, io_ports->data_addr);
+	}
 
 	if (task->tf_flags & IDE_TFLAG_OUT_HOB_FEATURE)
-		hwif->OUTB(tf->hob_feature, io_ports->feature_addr);
+		tf_outb(tf->hob_feature, io_ports->feature_addr);
 	if (task->tf_flags & IDE_TFLAG_OUT_HOB_NSECT)
-		hwif->OUTB(tf->hob_nsect, io_ports->nsect_addr);
+		tf_outb(tf->hob_nsect, io_ports->nsect_addr);
 	if (task->tf_flags & IDE_TFLAG_OUT_HOB_LBAL)
-		hwif->OUTB(tf->hob_lbal, io_ports->lbal_addr);
+		tf_outb(tf->hob_lbal, io_ports->lbal_addr);
 	if (task->tf_flags & IDE_TFLAG_OUT_HOB_LBAM)
-		hwif->OUTB(tf->hob_lbam, io_ports->lbam_addr);
+		tf_outb(tf->hob_lbam, io_ports->lbam_addr);
 	if (task->tf_flags & IDE_TFLAG_OUT_HOB_LBAH)
-		hwif->OUTB(tf->hob_lbah, io_ports->lbah_addr);
+		tf_outb(tf->hob_lbah, io_ports->lbah_addr);
 
 	if (task->tf_flags & IDE_TFLAG_OUT_FEATURE)
-		hwif->OUTB(tf->feature, io_ports->feature_addr);
+		tf_outb(tf->feature, io_ports->feature_addr);
 	if (task->tf_flags & IDE_TFLAG_OUT_NSECT)
-		hwif->OUTB(tf->nsect, io_ports->nsect_addr);
+		tf_outb(tf->nsect, io_ports->nsect_addr);
 	if (task->tf_flags & IDE_TFLAG_OUT_LBAL)
-		hwif->OUTB(tf->lbal, io_ports->lbal_addr);
+		tf_outb(tf->lbal, io_ports->lbal_addr);
 	if (task->tf_flags & IDE_TFLAG_OUT_LBAM)
-		hwif->OUTB(tf->lbam, io_ports->lbam_addr);
+		tf_outb(tf->lbam, io_ports->lbam_addr);
 	if (task->tf_flags & IDE_TFLAG_OUT_LBAH)
-		hwif->OUTB(tf->lbah, io_ports->lbah_addr);
+		tf_outb(tf->lbah, io_ports->lbah_addr);
 
 	if (task->tf_flags & IDE_TFLAG_OUT_DEVICE)
-		hwif->OUTB((tf->device & HIHI) | drive->select.all,
-			   io_ports->device_addr);
+		tf_outb((tf->device & HIHI) | drive->select.all,
+			 io_ports->device_addr);
 }
 
 static void ide_tf_read(ide_drive_t *drive, ide_task_t *task)
@@ -177,41 +190,57 @@ static void ide_tf_read(ide_drive_t *dri
 	ide_hwif_t *hwif = drive->hwif;
 	struct ide_io_ports *io_ports = &hwif->io_ports;
 	struct ide_taskfile *tf = &task->tf;
+	void (*tf_outb)(u8 addr, unsigned long port);
+	u8 (*tf_inb)(unsigned long port);
+	u8 mmio = (hwif->host_flags & IDE_HFLAG_MMIO) ? 1 : 0;
+
+	if (mmio) {
+		tf_outb = ide_mm_outb;
+		tf_inb  = ide_mm_inb;
+	} else {
+		tf_outb = ide_outb;
+		tf_inb  = ide_inb;
+	}
 
 	if (task->tf_flags & IDE_TFLAG_IN_DATA) {
-		u16 data = hwif->INW(io_ports->data_addr);
+		u16 data;
+
+		if (mmio)
+			data = readw((void __iomem *)io_ports->data_addr);
+		else
+			data = inw(io_ports->data_addr);
 
 		tf->data = data & 0xff;
 		tf->hob_data = (data >> 8) & 0xff;
 	}
 
 	/* be sure we're looking at the low order bits */
-	hwif->OUTB(drive->ctl & ~0x80, io_ports->ctl_addr);
+	tf_outb(drive->ctl & ~0x80, io_ports->ctl_addr);
 
 	if (task->tf_flags & IDE_TFLAG_IN_NSECT)
-		tf->nsect  = hwif->INB(io_ports->nsect_addr);
+		tf->nsect  = tf_inb(io_ports->nsect_addr);
 	if (task->tf_flags & IDE_TFLAG_IN_LBAL)
-		tf->lbal   = hwif->INB(io_ports->lbal_addr);
+		tf->lbal   = tf_inb(io_ports->lbal_addr);
 	if (task->tf_flags & IDE_TFLAG_IN_LBAM)
-		tf->lbam   = hwif->INB(io_ports->lbam_addr);
+		tf->lbam   = tf_inb(io_ports->lbam_addr);
 	if (task->tf_flags & IDE_TFLAG_IN_LBAH)
-		tf->lbah   = hwif->INB(io_ports->lbah_addr);
+		tf->lbah   = tf_inb(io_ports->lbah_addr);
 	if (task->tf_flags & IDE_TFLAG_IN_DEVICE)
-		tf->device = hwif->INB(io_ports->device_addr);
+		tf->device = tf_inb(io_ports->device_addr);
 
 	if (task->tf_flags & IDE_TFLAG_LBA48) {
-		hwif->OUTB(drive->ctl | 0x80, io_ports->ctl_addr);
+		tf_outb(drive->ctl | 0x80, io_ports->ctl_addr);
 
 		if (task->tf_flags & IDE_TFLAG_IN_HOB_FEATURE)
-			tf->hob_feature = hwif->INB(io_ports->feature_addr);
+			tf->hob_feature = tf_inb(io_ports->feature_addr);
 		if (task->tf_flags & IDE_TFLAG_IN_HOB_NSECT)
-			tf->hob_nsect   = hwif->INB(io_ports->nsect_addr);
+			tf->hob_nsect   = tf_inb(io_ports->nsect_addr);
 		if (task->tf_flags & IDE_TFLAG_IN_HOB_LBAL)
-			tf->hob_lbal    = hwif->INB(io_ports->lbal_addr);
+			tf->hob_lbal    = tf_inb(io_ports->lbal_addr);
 		if (task->tf_flags & IDE_TFLAG_IN_HOB_LBAM)
-			tf->hob_lbam    = hwif->INB(io_ports->lbam_addr);
+			tf->hob_lbam    = tf_inb(io_ports->lbam_addr);
 		if (task->tf_flags & IDE_TFLAG_IN_HOB_LBAH)
-			tf->hob_lbah    = hwif->INB(io_ports->lbah_addr);
+			tf->hob_lbah    = tf_inb(io_ports->lbah_addr);
 	}
 }
 
