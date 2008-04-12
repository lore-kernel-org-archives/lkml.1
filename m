Return-Path: <linux-kernel-owner+w=401wt.eu-S932124AbYDLMT7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932124AbYDLMT7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Apr 2008 08:19:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761680AbYDLMSi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Apr 2008 08:18:38 -0400
Received: from fk-out-0910.google.com ([209.85.128.189]:35944 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761652AbYDLMSg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Apr 2008 08:18:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=Lw1BGoPDRDNrkH5NAtBxfZgwpZUVzt+ze+RULwh6zsvyN1R0jxcDhwykxleTGNXXEP0U5IiVOFyyZ3igjiG1fqc2um/n+J/kpr3pPt7xv4xLK+yagxF1tbzrBOsSuDGNOLMP5mY4G3C/mUzdG7Fz2tpsOduz0LnoFDytj5V3hfw=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Sat, 12 Apr 2008 14:34:44 +0200
Message-Id: <20080412123444.18751.4483.sendpatchset@localhost.localdomain>
In-Reply-To: <20080412123401.18751.17246.sendpatchset@localhost.localdomain>
References: <20080412123401.18751.17246.sendpatchset@localhost.localdomain>
Subject: [PATCH 7/9] ns87415: add ->tf_read method
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add ->tf_read method so out{b,w}(), in{b,w}() and superio_ide_inb()
can be used directly.

There should be no functional changes caused by this patch.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/pci/ns87415.c |   44 ++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 44 insertions(+)

Index: b/drivers/ide/pci/ns87415.c
===================================================================
--- a/drivers/ide/pci/ns87415.c
+++ b/drivers/ide/pci/ns87415.c
@@ -63,6 +63,48 @@ static u8 superio_ide_inb (unsigned long
 	return inb(port);
 }
 
+static void superio_tf_read(ide_drive_t *drive, ide_task_t *task)
+{
+	struct ide_io_ports *io_ports = &drive->hwif->io_ports;
+	struct ide_taskfile *tf = &task->tf;
+
+	if (task->tf_flags & IDE_TFLAG_IN_DATA) {
+		u16 data = inw(io_ports->data_addr);
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
+		tf->device = superio_ide_inb(io_ports->device_addr);
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
 static void __devinit superio_ide_init_iops (struct hwif_s *hwif)
 {
 	struct pci_dev *pdev = to_pci_dev(hwif->dev);
@@ -80,6 +122,8 @@ static void __devinit superio_ide_init_i
 	tmp = superio_ide_inb(superio_ide_dma_status[port]);
 	outb(tmp | 0x66, superio_ide_dma_status[port]);
 
+	hwif->tf_read = superio_tf_read;
+
 	/* We need to override inb to workaround a SuperIO errata */
 	hwif->INB = superio_ide_inb;
 }
