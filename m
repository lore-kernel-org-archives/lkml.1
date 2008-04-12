Return-Path: <linux-kernel-owner+w=401wt.eu-S1761924AbYDLMTO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761924AbYDLMTO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Apr 2008 08:19:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761577AbYDLMSR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Apr 2008 08:18:17 -0400
Received: from fk-out-0910.google.com ([209.85.128.189]:35944 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761558AbYDLMSP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Apr 2008 08:18:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=raBDpEX7k4NFZtOjO8LRYTeod4HoS+gp8pJyZp7PVal/3eGKq14BAhHWq3Cpc+r4UnZGzSqCoEAJdOT8l7GKGGUPXPZWoHIWcbyy+wBzR8fgoLb3KN0FnHm96/pIAt/twyZzFolvagFsw8GmkJ9aNfNLAuTIYhNDVjfVcEE1JvQ=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Sat, 12 Apr 2008 14:34:22 +0200
Message-Id: <20080412123422.18751.64166.sendpatchset@localhost.localdomain>
In-Reply-To: <20080412123401.18751.17246.sendpatchset@localhost.localdomain>
References: <20080412123401.18751.17246.sendpatchset@localhost.localdomain>
Subject: [PATCH 4/9] ide-cris: add ->tf_{load,read} methods
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add ->tf_{load,read} methods so cris_ide_{outb,outw,inb,inw}()
can be used directly.

There should be no functional changes caused by this patch.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/cris/ide-cris.c |   87 ++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 87 insertions(+)

Index: b/drivers/ide/cris/ide-cris.c
===================================================================
--- a/drivers/ide/cris/ide-cris.c
+++ b/drivers/ide/cris/ide-cris.c
@@ -775,6 +775,90 @@ static void __init cris_setup_ports(hw_r
 	hw->ack_intr = cris_ide_ack_intr;
 }
 
+static void cris_tf_load(ide_drive_t *drive, ide_task_t *task)
+{
+	struct ide_io_ports *io_ports = &drive->hwif->io_ports;
+	struct ide_taskfile *tf = &task->tf;
+	u8 HIHI = (task->tf_flags & IDE_TFLAG_LBA48) ? 0xE0 : 0xEF;
+
+	if (task->tf_flags & IDE_TFLAG_FLAGGED)
+		HIHI = 0xFF;
+
+	ide_set_irq(drive, 1);
+
+	if (task->tf_flags & IDE_TFLAG_OUT_DATA)
+		cris_ide_outw((tf->hob_data << 8) | tf->data,
+			      io_ports->data_addr);
+
+	if (task->tf_flags & IDE_TFLAG_OUT_HOB_FEATURE)
+		cris_ide_outb(tf->hob_feature, io_ports->feature_addr);
+	if (task->tf_flags & IDE_TFLAG_OUT_HOB_NSECT)
+		cris_ide_outb(tf->hob_nsect, io_ports->nsect_addr);
+	if (task->tf_flags & IDE_TFLAG_OUT_HOB_LBAL)
+		cris_ide_outb(tf->hob_lbal, io_ports->lbal_addr);
+	if (task->tf_flags & IDE_TFLAG_OUT_HOB_LBAM)
+		cris_ide_outb(tf->hob_lbam, io_ports->lbam_addr);
+	if (task->tf_flags & IDE_TFLAG_OUT_HOB_LBAH)
+		cris_ide_outb(tf->hob_lbah, io_ports->lbah_addr);
+
+	if (task->tf_flags & IDE_TFLAG_OUT_FEATURE)
+		cris_ide_outb(tf->feature, io_ports->feature_addr);
+	if (task->tf_flags & IDE_TFLAG_OUT_NSECT)
+		cris_ide_outb(tf->nsect, io_ports->nsect_addr);
+	if (task->tf_flags & IDE_TFLAG_OUT_LBAL)
+		cris_ide_outb(tf->lbal, io_ports->lbal_addr);
+	if (task->tf_flags & IDE_TFLAG_OUT_LBAM)
+		cris_ide_outb(tf->lbam, io_ports->lbam_addr);
+	if (task->tf_flags & IDE_TFLAG_OUT_LBAH)
+		cris_ide_outb(tf->lbah, io_ports->lbah_addr);
+
+	if (task->tf_flags & IDE_TFLAG_OUT_DEVICE)
+		cris_ide_outb((tf->device & HIHI) | drive->select.all,
+			      io_ports->device_addr);
+}
+
+static void cris_tf_read(ide_drive_t *drive, ide_task_t *task)
+{
+	struct ide_io_ports *io_ports = &drive->hwif->io_ports;
+	struct ide_taskfile *tf = &task->tf;
+
+	if (task->tf_flags & IDE_TFLAG_IN_DATA) {
+		u16 data = cris_ide_inw(io_ports->data_addr);
+
+		tf->data = data & 0xff;
+		tf->hob_data = (data >> 8) & 0xff;
+	}
+
+	/* be sure we're looking at the low order bits */
+	cris_ide_outb(drive->ctl & ~0x80, io_ports->ctl_addr);
+
+	if (task->tf_flags & IDE_TFLAG_IN_NSECT)
+		tf->nsect  = cris_ide_inb(io_ports->nsect_addr);
+	if (task->tf_flags & IDE_TFLAG_IN_LBAL)
+		tf->lbal   = cris_ide_inb(io_ports->lbal_addr);
+	if (task->tf_flags & IDE_TFLAG_IN_LBAM)
+		tf->lbam   = cris_ide_inb(io_ports->lbam_addr);
+	if (task->tf_flags & IDE_TFLAG_IN_LBAH)
+		tf->lbah   = cris_ide_inb(io_ports->lbah_addr);
+	if (task->tf_flags & IDE_TFLAG_IN_DEVICE)
+		tf->device = cris_ide_inb(io_ports->device_addr);
+
+	if (task->tf_flags & IDE_TFLAG_LBA48) {
+		cris_ide_outb(drive->ctl | 0x80, io_ports->ctl_addr);
+
+		if (task->tf_flags & IDE_TFLAG_IN_HOB_FEATURE)
+			tf->hob_feature = cris_ide_inb(io_ports->feature_addr);
+		if (task->tf_flags & IDE_TFLAG_IN_HOB_NSECT)
+			tf->hob_nsect   = cris_ide_inb(io_ports->nsect_addr);
+		if (task->tf_flags & IDE_TFLAG_IN_HOB_LBAL)
+			tf->hob_lbal    = cris_ide_inb(io_ports->lbal_addr);
+		if (task->tf_flags & IDE_TFLAG_IN_HOB_LBAM)
+			tf->hob_lbam    = cris_ide_inb(io_ports->lbam_addr);
+		if (task->tf_flags & IDE_TFLAG_IN_HOB_LBAH)
+			tf->hob_lbah    = cris_ide_inb(io_ports->lbah_addr);
+	}
+}
+
 static const struct ide_port_ops cris_port_ops = {
 	.set_pio_mode		= cris_set_pio_mode,
 	.set_dma_mode		= cris_set_dma_mode,
@@ -812,6 +896,9 @@ static int __init init_e100_ide(void)
 
 		ide_init_port_hw(hwif, &hw);
 
+		hwif->tf_load = cris_tf_load;
+		hwif->tf_read = cris_tf_read;
+
 		hwif->input_data  = cris_input_data;
 		hwif->output_data = cris_output_data;
 
