Return-Path: <linux-kernel-owner+w=401wt.eu-S1761990AbYDLMT3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761990AbYDLMT3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Apr 2008 08:19:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760329AbYDLMSY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Apr 2008 08:18:24 -0400
Received: from fg-out-1718.google.com ([72.14.220.159]:21782 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761578AbYDLMSW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Apr 2008 08:18:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=VZaWwVaNJ8kPmIbiI3Y1c0B9RYoxHH3Hye28u9DMMFxL6d/FT6tPgzfhNva/oDHDOvwkCng40OEhclXvsrZC9h9BkGP1vM2AiPzITgPFCQxQdGQsZCAwBd74EkVR5PoiO/kJZJzTBZGT37Q1H3rHa/d0hbeLkOsNki+JC1Pu9/k=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Sat, 12 Apr 2008 14:34:30 +0200
Message-Id: <20080412123430.18751.96502.sendpatchset@localhost.localdomain>
In-Reply-To: <20080412123401.18751.17246.sendpatchset@localhost.localdomain>
References: <20080412123401.18751.17246.sendpatchset@localhost.localdomain>
Subject: [PATCH 5/9] ide-h8300: add ->tf_{load,read} methods
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add ->tf_{load,read} methods so outb()/inb() and mm_outw()/mm_inw()
can be used directly.

There should be no functional changes caused by this patch.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/h8300/ide-h8300.c |   88 ++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 88 insertions(+)

Index: b/drivers/ide/h8300/ide-h8300.c
===================================================================
--- a/drivers/ide/h8300/ide-h8300.c
+++ b/drivers/ide/h8300/ide-h8300.c
@@ -42,6 +42,91 @@ static u16 mm_inw(unsigned long a)
 	return r;
 }
 
+static void h8300_tf_load(ide_drive_t *drive, ide_task_t *task)
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
+	if (task->tf_flags & IDE_TFLAG_OUT_DATA)
+		mm_outw((tf->hob_data << 8) | tf->data, io_ports->data_addr);
+
+	if (task->tf_flags & IDE_TFLAG_OUT_HOB_FEATURE)
+		outb(tf->hob_feature, io_ports->feature_addr);
+	if (task->tf_flags & IDE_TFLAG_OUT_HOB_NSECT)
+		outb(tf->hob_nsect, io_ports->nsect_addr);
+	if (task->tf_flags & IDE_TFLAG_OUT_HOB_LBAL)
+		outb(tf->hob_lbal, io_ports->lbal_addr);
+	if (task->tf_flags & IDE_TFLAG_OUT_HOB_LBAM)
+		outb(tf->hob_lbam, io_ports->lbam_addr);
+	if (task->tf_flags & IDE_TFLAG_OUT_HOB_LBAH)
+		outb(tf->hob_lbah, io_ports->lbah_addr);
+
+	if (task->tf_flags & IDE_TFLAG_OUT_FEATURE)
+		outb(tf->feature, io_ports->feature_addr);
+	if (task->tf_flags & IDE_TFLAG_OUT_NSECT)
+		outb(tf->nsect, io_ports->nsect_addr);
+	if (task->tf_flags & IDE_TFLAG_OUT_LBAL)
+		outb(tf->lbal, io_ports->lbal_addr);
+	if (task->tf_flags & IDE_TFLAG_OUT_LBAM)
+		outb(tf->lbam, io_ports->lbam_addr);
+	if (task->tf_flags & IDE_TFLAG_OUT_LBAH)
+		outb(tf->lbah, io_ports->lbah_addr);
+
+	if (task->tf_flags & IDE_TFLAG_OUT_DEVICE)
+		outb((tf->device & HIHI) | drive->select.all,
+		     io_ports->device_addr);
+}
+
+static void h8300_tf_read(ide_drive_t *drive, ide_task_t *task)
+{
+	ide_hwif_t *hwif = drive->hwif;
+	struct ide_io_ports *io_ports = &hwif->io_ports;
+	struct ide_taskfile *tf = &task->tf;
+
+	if (task->tf_flags & IDE_TFLAG_IN_DATA) {
+		u16 data = mm_inw(io_ports->data_addr);
+
+		tf->data = data & 0xff;
+		tf->hob_data = (data >> 8) & 0xff;
+	}
+
+	/* be sure we're looking at the low order bits */
+	outb(drive->ctl & ~0x80, io_ports->ctl_addr);
+
+	if (task->tf_flags & IDE_TFLAG_IN_NSECT)
+		tf->nsect  = inb(io_ports->nsect_addr);
+	if (task->tf_flags & IDE_TFLAG_IN_LBAL)
+		tf->lbal   = inb(io_ports->lbal_addr);
+	if (task->tf_flags & IDE_TFLAG_IN_LBAM)
+		tf->lbam   = inb(io_ports->lbam_addr);
+	if (task->tf_flags & IDE_TFLAG_IN_LBAH)
+		tf->lbah   = inb(io_ports->lbah_addr);
+	if (task->tf_flags & IDE_TFLAG_IN_DEVICE)
+		tf->device = inb(io_ports->device_addr);
+
+	if (task->tf_flags & IDE_TFLAG_LBA48) {
+		outb(drive->ctl | 0x80, io_ports->ctl_addr);
+
+		if (task->tf_flags & IDE_TFLAG_IN_HOB_FEATURE)
+			tf->hob_feature = inb(io_ports->feature_addr);
+		if (task->tf_flags & IDE_TFLAG_IN_HOB_NSECT)
+			tf->hob_nsect   = inb(io_ports->nsect_addr);
+		if (task->tf_flags & IDE_TFLAG_IN_HOB_LBAL)
+			tf->hob_lbal    = inb(io_ports->lbal_addr);
+		if (task->tf_flags & IDE_TFLAG_IN_HOB_LBAM)
+			tf->hob_lbam    = inb(io_ports->lbam_addr);
+		if (task->tf_flags & IDE_TFLAG_IN_HOB_LBAH)
+			tf->hob_lbah    = inb(io_ports->lbah_addr);
+	}
+}
+
 static void mm_outsw(unsigned long addr, void *buf, u32 len)
 {
 	unsigned short *bp = (unsigned short *)buf;
@@ -84,6 +169,9 @@ static inline void hwif_setup(ide_hwif_t
 {
 	default_hwif_iops(hwif);
 
+	hwif->tf_load = h8300_tf_load;
+	hwif->tf_read = h8300_tf_read;
+
 	hwif->input_data  = h8300_input_data;
 	hwif->output_data = h8300_output_data;
 
