Return-Path: <linux-kernel-owner+w=401wt.eu-S1761729AbYDLMTo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761729AbYDLMTo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Apr 2008 08:19:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761619AbYDLMSa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Apr 2008 08:18:30 -0400
Received: from fg-out-1718.google.com ([72.14.220.152]:19942 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761603AbYDLMS3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Apr 2008 08:18:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=HBEsAYD68lyKv0rTFiIwYuAreJFtTUeKcAqmMZMk97PCYboJIphEwabkeFtBLWmyfGjgvLz1tBz7nMRFJwBIh2HaZ4bX4LyjZ1Oqk16yY3RgAvBg/k3EMUv6mUz8B/X3FxHLyTr8qm7cqFLU9FYhzyVWgCyZ5TDxwdmHugHNOfY=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Sat, 12 Apr 2008 14:34:37 +0200
Message-Id: <20080412123437.18751.2532.sendpatchset@localhost.localdomain>
In-Reply-To: <20080412123401.18751.17246.sendpatchset@localhost.localdomain>
References: <20080412123401.18751.17246.sendpatchset@localhost.localdomain>
Subject: [PATCH 6/9] scc_pata: add ->tf_{load,read} methods
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add ->tf_{load,read} methods so scc_ide_{outb,outw,inb,inw}()
can be used directly.

There should be no functional changes caused by this patch.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/pci/scc_pata.c |   87 +++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 87 insertions(+)

Index: b/drivers/ide/pci/scc_pata.c
===================================================================
--- a/drivers/ide/pci/scc_pata.c
+++ b/drivers/ide/pci/scc_pata.c
@@ -574,6 +574,90 @@ static int __devinit init_setup_scc(stru
 	return ide_setup_pci_device(dev, d);
 }
 
+static void scc_tf_load(ide_drive_t *drive, ide_task_t *task)
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
+		scc_ide_outw((tf->hob_data << 8) | tf->data,
+			     io_ports->data_addr);
+
+	if (task->tf_flags & IDE_TFLAG_OUT_HOB_FEATURE)
+		scc_ide_outb(tf->hob_feature, io_ports->feature_addr);
+	if (task->tf_flags & IDE_TFLAG_OUT_HOB_NSECT)
+		scc_ide_outb(tf->hob_nsect, io_ports->nsect_addr);
+	if (task->tf_flags & IDE_TFLAG_OUT_HOB_LBAL)
+		scc_ide_outb(tf->hob_lbal, io_ports->lbal_addr);
+	if (task->tf_flags & IDE_TFLAG_OUT_HOB_LBAM)
+		scc_ide_outb(tf->hob_lbam, io_ports->lbam_addr);
+	if (task->tf_flags & IDE_TFLAG_OUT_HOB_LBAH)
+		scc_ide_outb(tf->hob_lbah, io_ports->lbah_addr);
+
+	if (task->tf_flags & IDE_TFLAG_OUT_FEATURE)
+		scc_ide_outb(tf->feature, io_ports->feature_addr);
+	if (task->tf_flags & IDE_TFLAG_OUT_NSECT)
+		scc_ide_outb(tf->nsect, io_ports->nsect_addr);
+	if (task->tf_flags & IDE_TFLAG_OUT_LBAL)
+		scc_ide_outb(tf->lbal, io_ports->lbal_addr);
+	if (task->tf_flags & IDE_TFLAG_OUT_LBAM)
+		scc_ide_outb(tf->lbam, io_ports->lbam_addr);
+	if (task->tf_flags & IDE_TFLAG_OUT_LBAH)
+		scc_ide_outb(tf->lbah, io_ports->lbah_addr);
+
+	if (task->tf_flags & IDE_TFLAG_OUT_DEVICE)
+		scc_ide_outb((tf->device & HIHI) | drive->select.all,
+			     io_ports->device_addr);
+}
+
+static void scc_tf_read(ide_drive_t *drive, ide_task_t *task)
+{
+	struct ide_io_ports *io_ports = &drive->hwif->io_ports;
+	struct ide_taskfile *tf = &task->tf;
+
+	if (task->tf_flags & IDE_TFLAG_IN_DATA) {
+		u16 data = scc_ide_inw(io_ports->data_addr);
+
+		tf->data = data & 0xff;
+		tf->hob_data = (data >> 8) & 0xff;
+	}
+
+	/* be sure we're looking at the low order bits */
+	scc_ide_outb(drive->ctl & ~0x80, io_ports->ctl_addr);
+
+	if (task->tf_flags & IDE_TFLAG_IN_NSECT)
+		tf->nsect  = scc_ide_inb(io_ports->nsect_addr);
+	if (task->tf_flags & IDE_TFLAG_IN_LBAL)
+		tf->lbal   = scc_ide_inb(io_ports->lbal_addr);
+	if (task->tf_flags & IDE_TFLAG_IN_LBAM)
+		tf->lbam   = scc_ide_inb(io_ports->lbam_addr);
+	if (task->tf_flags & IDE_TFLAG_IN_LBAH)
+		tf->lbah   = scc_ide_inb(io_ports->lbah_addr);
+	if (task->tf_flags & IDE_TFLAG_IN_DEVICE)
+		tf->device = scc_ide_inb(io_ports->device_addr);
+
+	if (task->tf_flags & IDE_TFLAG_LBA48) {
+		scc_ide_outb(drive->ctl | 0x80, io_ports->ctl_addr);
+
+		if (task->tf_flags & IDE_TFLAG_IN_HOB_FEATURE)
+			tf->hob_feature = scc_ide_inb(io_ports->feature_addr);
+		if (task->tf_flags & IDE_TFLAG_IN_HOB_NSECT)
+			tf->hob_nsect   = scc_ide_inb(io_ports->nsect_addr);
+		if (task->tf_flags & IDE_TFLAG_IN_HOB_LBAL)
+			tf->hob_lbal    = scc_ide_inb(io_ports->lbal_addr);
+		if (task->tf_flags & IDE_TFLAG_IN_HOB_LBAM)
+			tf->hob_lbam    = scc_ide_inb(io_ports->lbam_addr);
+		if (task->tf_flags & IDE_TFLAG_IN_HOB_LBAH)
+			tf->hob_lbah    = scc_ide_inb(io_ports->lbah_addr);
+	}
+}
+
 static void scc_input_data(ide_drive_t *drive, void *buf, unsigned int len)
 {
 	unsigned long data_addr = drive->hwif->io_ports.data_addr;
@@ -619,6 +703,9 @@ static void __devinit init_mmio_iops_scc
 
 	ide_set_hwifdata(hwif, ports);
 
+	hwif->tf_load = scc_tf_load;
+	hwif->tf_read = scc_tf_read;
+
 	hwif->input_data  = scc_input_data;
 	hwif->output_data = scc_output_data;
 
