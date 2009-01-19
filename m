Return-Path: <linux-kernel-owner+w=401wt.eu-S1760949AbZASNDu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760949AbZASNDu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2009 08:03:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760779AbZASNDG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Jan 2009 08:03:06 -0500
Received: from fg-out-1718.google.com ([72.14.220.152]:46333 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760694AbZASNDA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2009 08:03:00 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=pH6s9ei2bY0MHrU5LcqTYUTCyN8znSXgUwAMXOeWNNL23AehHXgeZ4ppDKb2D21y7p
         IhKp3QdS5cqvd8h2C9ad+At3cwPZOTM+icEWlsVXFS107/gz8PfjduspXrwRFQCh1xTm
         GqwRC4XWjTCOiqqTiItRBoE+xNOi+XE89iEHw=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Mon, 19 Jan 2009 14:03:22 +0100
Message-Id: <20090119130322.24745.76137.sendpatchset@localhost.localdomain>
In-Reply-To: <20090119130309.24745.40877.sendpatchset@localhost.localdomain>
References: <20090119130309.24745.40877.sendpatchset@localhost.localdomain>
Subject: [PATCH 2/6] ide: move SFF I/O code to ide-io-sff.c
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] ide: move SFF I/O code to ide-io-sff.c

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/Makefile     |    3 
 drivers/ide/ide-io-sff.c |  314 +++++++++++++++++++++++++++++++++++++++++++++++
 drivers/ide/ide-iops.c   |  311 ----------------------------------------------
 3 files changed, 316 insertions(+), 312 deletions(-)

Index: b/drivers/ide/Makefile
===================================================================
--- a/drivers/ide/Makefile
+++ b/drivers/ide/Makefile
@@ -5,7 +5,8 @@
 EXTRA_CFLAGS				+= -Idrivers/ide
 
 ide-core-y += ide.o ide-ioctls.o ide-io.o ide-iops.o ide-lib.o ide-probe.o \
-	      ide-taskfile.o ide-pm.o ide-park.o ide-sysfs.o ide-devsets.o
+	      ide-taskfile.o ide-pm.o ide-park.o ide-sysfs.o ide-devsets.o \
+	      ide-io-sff.o
 
 # core IDE code
 ide-core-$(CONFIG_IDE_XFER_MODE)	+= ide-pio-blacklist.o ide-xfer-mode.o
Index: b/drivers/ide/ide-io-sff.c
===================================================================
--- /dev/null
+++ b/drivers/ide/ide-io-sff.c
@@ -0,0 +1,314 @@
+
+#include <linux/kernel.h>
+#include <linux/ide.h>
+
+/*
+ *	Conventional PIO operations for ATA devices
+ */
+
+static u8 ide_inb(unsigned long port)
+{
+	return (u8) inb(port);
+}
+
+static void ide_outb(u8 val, unsigned long port)
+{
+	outb(val, port);
+}
+
+/*
+ *	MMIO operations, typically used for SATA controllers
+ */
+
+static u8 ide_mm_inb(unsigned long port)
+{
+	return (u8) readb((void __iomem *) port);
+}
+
+static void ide_mm_outb(u8 value, unsigned long port)
+{
+	writeb(value, (void __iomem *) port);
+}
+
+void ide_exec_command(ide_hwif_t *hwif, u8 cmd)
+{
+	if (hwif->host_flags & IDE_HFLAG_MMIO)
+		writeb(cmd, (void __iomem *)hwif->io_ports.command_addr);
+	else
+		outb(cmd, hwif->io_ports.command_addr);
+}
+EXPORT_SYMBOL_GPL(ide_exec_command);
+
+u8 ide_read_status(ide_hwif_t *hwif)
+{
+	if (hwif->host_flags & IDE_HFLAG_MMIO)
+		return readb((void __iomem *)hwif->io_ports.status_addr);
+	else
+		return inb(hwif->io_ports.status_addr);
+}
+EXPORT_SYMBOL_GPL(ide_read_status);
+
+u8 ide_read_altstatus(ide_hwif_t *hwif)
+{
+	if (hwif->host_flags & IDE_HFLAG_MMIO)
+		return readb((void __iomem *)hwif->io_ports.ctl_addr);
+	else
+		return inb(hwif->io_ports.ctl_addr);
+}
+EXPORT_SYMBOL_GPL(ide_read_altstatus);
+
+void ide_set_irq(ide_hwif_t *hwif, int on)
+{
+	u8 ctl = ATA_DEVCTL_OBS;
+
+	if (on == 4) { /* hack for SRST */
+		ctl |= 4;
+		on &= ~4;
+	}
+
+	ctl |= on ? 0 : 2;
+
+	if (hwif->host_flags & IDE_HFLAG_MMIO)
+		writeb(ctl, (void __iomem *)hwif->io_ports.ctl_addr);
+	else
+		outb(ctl, hwif->io_ports.ctl_addr);
+}
+EXPORT_SYMBOL_GPL(ide_set_irq);
+
+void ide_tf_load(ide_drive_t *drive, ide_task_t *task)
+{
+	ide_hwif_t *hwif = drive->hwif;
+	struct ide_io_ports *io_ports = &hwif->io_ports;
+	struct ide_taskfile *tf = &task->tf;
+	void (*tf_outb)(u8 addr, unsigned long port);
+	u8 mmio = (hwif->host_flags & IDE_HFLAG_MMIO) ? 1 : 0;
+	u8 HIHI = (task->tf_flags & IDE_TFLAG_LBA48) ? 0xE0 : 0xEF;
+
+	if (mmio)
+		tf_outb = ide_mm_outb;
+	else
+		tf_outb = ide_outb;
+
+	if (task->tf_flags & IDE_TFLAG_FLAGGED)
+		HIHI = 0xFF;
+
+	if (task->tf_flags & IDE_TFLAG_OUT_DATA) {
+		u16 data = (tf->hob_data << 8) | tf->data;
+
+		if (mmio)
+			writew(data, (void __iomem *)io_ports->data_addr);
+		else
+			outw(data, io_ports->data_addr);
+	}
+
+	if (task->tf_flags & IDE_TFLAG_OUT_HOB_FEATURE)
+		tf_outb(tf->hob_feature, io_ports->feature_addr);
+	if (task->tf_flags & IDE_TFLAG_OUT_HOB_NSECT)
+		tf_outb(tf->hob_nsect, io_ports->nsect_addr);
+	if (task->tf_flags & IDE_TFLAG_OUT_HOB_LBAL)
+		tf_outb(tf->hob_lbal, io_ports->lbal_addr);
+	if (task->tf_flags & IDE_TFLAG_OUT_HOB_LBAM)
+		tf_outb(tf->hob_lbam, io_ports->lbam_addr);
+	if (task->tf_flags & IDE_TFLAG_OUT_HOB_LBAH)
+		tf_outb(tf->hob_lbah, io_ports->lbah_addr);
+
+	if (task->tf_flags & IDE_TFLAG_OUT_FEATURE)
+		tf_outb(tf->feature, io_ports->feature_addr);
+	if (task->tf_flags & IDE_TFLAG_OUT_NSECT)
+		tf_outb(tf->nsect, io_ports->nsect_addr);
+	if (task->tf_flags & IDE_TFLAG_OUT_LBAL)
+		tf_outb(tf->lbal, io_ports->lbal_addr);
+	if (task->tf_flags & IDE_TFLAG_OUT_LBAM)
+		tf_outb(tf->lbam, io_ports->lbam_addr);
+	if (task->tf_flags & IDE_TFLAG_OUT_LBAH)
+		tf_outb(tf->lbah, io_ports->lbah_addr);
+
+	if (task->tf_flags & IDE_TFLAG_OUT_DEVICE)
+		tf_outb((tf->device & HIHI) | drive->select,
+			 io_ports->device_addr);
+}
+EXPORT_SYMBOL_GPL(ide_tf_load);
+
+void ide_tf_read(ide_drive_t *drive, ide_task_t *task)
+{
+	ide_hwif_t *hwif = drive->hwif;
+	struct ide_io_ports *io_ports = &hwif->io_ports;
+	struct ide_taskfile *tf = &task->tf;
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
+
+	if (task->tf_flags & IDE_TFLAG_IN_DATA) {
+		u16 data;
+
+		if (mmio)
+			data = readw((void __iomem *)io_ports->data_addr);
+		else
+			data = inw(io_ports->data_addr);
+
+		tf->data = data & 0xff;
+		tf->hob_data = (data >> 8) & 0xff;
+	}
+
+	/* be sure we're looking at the low order bits */
+	tf_outb(ATA_DEVCTL_OBS & ~0x80, io_ports->ctl_addr);
+
+	if (task->tf_flags & IDE_TFLAG_IN_FEATURE)
+		tf->feature = tf_inb(io_ports->feature_addr);
+	if (task->tf_flags & IDE_TFLAG_IN_NSECT)
+		tf->nsect  = tf_inb(io_ports->nsect_addr);
+	if (task->tf_flags & IDE_TFLAG_IN_LBAL)
+		tf->lbal   = tf_inb(io_ports->lbal_addr);
+	if (task->tf_flags & IDE_TFLAG_IN_LBAM)
+		tf->lbam   = tf_inb(io_ports->lbam_addr);
+	if (task->tf_flags & IDE_TFLAG_IN_LBAH)
+		tf->lbah   = tf_inb(io_ports->lbah_addr);
+	if (task->tf_flags & IDE_TFLAG_IN_DEVICE)
+		tf->device = tf_inb(io_ports->device_addr);
+
+	if (task->tf_flags & IDE_TFLAG_LBA48) {
+		tf_outb(ATA_DEVCTL_OBS | 0x80, io_ports->ctl_addr);
+
+		if (task->tf_flags & IDE_TFLAG_IN_HOB_FEATURE)
+			tf->hob_feature = tf_inb(io_ports->feature_addr);
+		if (task->tf_flags & IDE_TFLAG_IN_HOB_NSECT)
+			tf->hob_nsect   = tf_inb(io_ports->nsect_addr);
+		if (task->tf_flags & IDE_TFLAG_IN_HOB_LBAL)
+			tf->hob_lbal    = tf_inb(io_ports->lbal_addr);
+		if (task->tf_flags & IDE_TFLAG_IN_HOB_LBAM)
+			tf->hob_lbam    = tf_inb(io_ports->lbam_addr);
+		if (task->tf_flags & IDE_TFLAG_IN_HOB_LBAH)
+			tf->hob_lbah    = tf_inb(io_ports->lbah_addr);
+	}
+}
+EXPORT_SYMBOL_GPL(ide_tf_read);
+
+/*
+ * Some localbus EIDE interfaces require a special access sequence
+ * when using 32-bit I/O instructions to transfer data.  We call this
+ * the "vlb_sync" sequence, which consists of three successive reads
+ * of the sector count register location, with interrupts disabled
+ * to ensure that the reads all happen together.
+ */
+static void ata_vlb_sync(unsigned long port)
+{
+	(void)inb(port);
+	(void)inb(port);
+	(void)inb(port);
+}
+
+/*
+ * This is used for most PIO data transfers *from* the IDE interface
+ *
+ * These routines will round up any request for an odd number of bytes,
+ * so if an odd len is specified, be sure that there's at least one
+ * extra byte allocated for the buffer.
+ */
+void ide_input_data(ide_drive_t *drive, struct request *rq, void *buf,
+		    unsigned int len)
+{
+	ide_hwif_t *hwif = drive->hwif;
+	struct ide_io_ports *io_ports = &hwif->io_ports;
+	unsigned long data_addr = io_ports->data_addr;
+	u8 io_32bit = drive->io_32bit;
+	u8 mmio = (hwif->host_flags & IDE_HFLAG_MMIO) ? 1 : 0;
+
+	len++;
+
+	if (io_32bit) {
+		unsigned long uninitialized_var(flags);
+
+		if ((io_32bit & 2) && !mmio) {
+			local_irq_save(flags);
+			ata_vlb_sync(io_ports->nsect_addr);
+		}
+
+		if (mmio)
+			__ide_mm_insl((void __iomem *)data_addr, buf, len / 4);
+		else
+			insl(data_addr, buf, len / 4);
+
+		if ((io_32bit & 2) && !mmio)
+			local_irq_restore(flags);
+
+		if ((len & 3) >= 2) {
+			if (mmio)
+				__ide_mm_insw((void __iomem *)data_addr,
+						(u8 *)buf + (len & ~3), 1);
+			else
+				insw(data_addr, (u8 *)buf + (len & ~3), 1);
+		}
+	} else {
+		if (mmio)
+			__ide_mm_insw((void __iomem *)data_addr, buf, len / 2);
+		else
+			insw(data_addr, buf, len / 2);
+	}
+}
+EXPORT_SYMBOL_GPL(ide_input_data);
+
+/*
+ * This is used for most PIO data transfers *to* the IDE interface
+ */
+void ide_output_data(ide_drive_t *drive, struct request *rq, void *buf,
+		     unsigned int len)
+{
+	ide_hwif_t *hwif = drive->hwif;
+	struct ide_io_ports *io_ports = &hwif->io_ports;
+	unsigned long data_addr = io_ports->data_addr;
+	u8 io_32bit = drive->io_32bit;
+	u8 mmio = (hwif->host_flags & IDE_HFLAG_MMIO) ? 1 : 0;
+
+	if (io_32bit) {
+		unsigned long uninitialized_var(flags);
+
+		if ((io_32bit & 2) && !mmio) {
+			local_irq_save(flags);
+			ata_vlb_sync(io_ports->nsect_addr);
+		}
+
+		if (mmio)
+			__ide_mm_outsl((void __iomem *)data_addr, buf, len / 4);
+		else
+			outsl(data_addr, buf, len / 4);
+
+		if ((io_32bit & 2) && !mmio)
+			local_irq_restore(flags);
+
+		if ((len & 3) >= 2) {
+			if (mmio)
+				__ide_mm_outsw((void __iomem *)data_addr,
+						 (u8 *)buf + (len & ~3), 1);
+			else
+				outsw(data_addr, (u8 *)buf + (len & ~3), 1);
+		}
+	} else {
+		if (mmio)
+			__ide_mm_outsw((void __iomem *)data_addr, buf, len / 2);
+		else
+			outsw(data_addr, buf, len / 2);
+	}
+}
+EXPORT_SYMBOL_GPL(ide_output_data);
+
+const struct ide_tp_ops default_tp_ops = {
+	.exec_command		= ide_exec_command,
+	.read_status		= ide_read_status,
+	.read_altstatus		= ide_read_altstatus,
+
+	.set_irq		= ide_set_irq,
+
+	.tf_load		= ide_tf_load,
+	.tf_read		= ide_tf_read,
+
+	.input_data		= ide_input_data,
+	.output_data		= ide_output_data,
+};
Index: b/drivers/ide/ide-iops.c
===================================================================
--- a/drivers/ide/ide-iops.c
+++ b/drivers/ide/ide-iops.c
@@ -27,34 +27,6 @@
 #include <asm/uaccess.h>
 #include <asm/io.h>
 
-/*
- *	Conventional PIO operations for ATA devices
- */
-
-static u8 ide_inb (unsigned long port)
-{
-	return (u8) inb(port);
-}
-
-static void ide_outb (u8 val, unsigned long port)
-{
-	outb(val, port);
-}
-
-/*
- *	MMIO operations, typically used for SATA controllers
- */
-
-static u8 ide_mm_inb (unsigned long port)
-{
-	return (u8) readb((void __iomem *) port);
-}
-
-static void ide_mm_outb (u8 value, unsigned long port)
-{
-	writeb(value, (void __iomem *) port);
-}
-
 void SELECT_DRIVE (ide_drive_t *drive)
 {
 	ide_hwif_t *hwif = drive->hwif;
@@ -78,275 +50,6 @@ void SELECT_MASK(ide_drive_t *drive, int
 		port_ops->maskproc(drive, mask);
 }
 
-void ide_exec_command(ide_hwif_t *hwif, u8 cmd)
-{
-	if (hwif->host_flags & IDE_HFLAG_MMIO)
-		writeb(cmd, (void __iomem *)hwif->io_ports.command_addr);
-	else
-		outb(cmd, hwif->io_ports.command_addr);
-}
-EXPORT_SYMBOL_GPL(ide_exec_command);
-
-u8 ide_read_status(ide_hwif_t *hwif)
-{
-	if (hwif->host_flags & IDE_HFLAG_MMIO)
-		return readb((void __iomem *)hwif->io_ports.status_addr);
-	else
-		return inb(hwif->io_ports.status_addr);
-}
-EXPORT_SYMBOL_GPL(ide_read_status);
-
-u8 ide_read_altstatus(ide_hwif_t *hwif)
-{
-	if (hwif->host_flags & IDE_HFLAG_MMIO)
-		return readb((void __iomem *)hwif->io_ports.ctl_addr);
-	else
-		return inb(hwif->io_ports.ctl_addr);
-}
-EXPORT_SYMBOL_GPL(ide_read_altstatus);
-
-void ide_set_irq(ide_hwif_t *hwif, int on)
-{
-	u8 ctl = ATA_DEVCTL_OBS;
-
-	if (on == 4) { /* hack for SRST */
-		ctl |= 4;
-		on &= ~4;
-	}
-
-	ctl |= on ? 0 : 2;
-
-	if (hwif->host_flags & IDE_HFLAG_MMIO)
-		writeb(ctl, (void __iomem *)hwif->io_ports.ctl_addr);
-	else
-		outb(ctl, hwif->io_ports.ctl_addr);
-}
-EXPORT_SYMBOL_GPL(ide_set_irq);
-
-void ide_tf_load(ide_drive_t *drive, ide_task_t *task)
-{
-	ide_hwif_t *hwif = drive->hwif;
-	struct ide_io_ports *io_ports = &hwif->io_ports;
-	struct ide_taskfile *tf = &task->tf;
-	void (*tf_outb)(u8 addr, unsigned long port);
-	u8 mmio = (hwif->host_flags & IDE_HFLAG_MMIO) ? 1 : 0;
-	u8 HIHI = (task->tf_flags & IDE_TFLAG_LBA48) ? 0xE0 : 0xEF;
-
-	if (mmio)
-		tf_outb = ide_mm_outb;
-	else
-		tf_outb = ide_outb;
-
-	if (task->tf_flags & IDE_TFLAG_FLAGGED)
-		HIHI = 0xFF;
-
-	if (task->tf_flags & IDE_TFLAG_OUT_DATA) {
-		u16 data = (tf->hob_data << 8) | tf->data;
-
-		if (mmio)
-			writew(data, (void __iomem *)io_ports->data_addr);
-		else
-			outw(data, io_ports->data_addr);
-	}
-
-	if (task->tf_flags & IDE_TFLAG_OUT_HOB_FEATURE)
-		tf_outb(tf->hob_feature, io_ports->feature_addr);
-	if (task->tf_flags & IDE_TFLAG_OUT_HOB_NSECT)
-		tf_outb(tf->hob_nsect, io_ports->nsect_addr);
-	if (task->tf_flags & IDE_TFLAG_OUT_HOB_LBAL)
-		tf_outb(tf->hob_lbal, io_ports->lbal_addr);
-	if (task->tf_flags & IDE_TFLAG_OUT_HOB_LBAM)
-		tf_outb(tf->hob_lbam, io_ports->lbam_addr);
-	if (task->tf_flags & IDE_TFLAG_OUT_HOB_LBAH)
-		tf_outb(tf->hob_lbah, io_ports->lbah_addr);
-
-	if (task->tf_flags & IDE_TFLAG_OUT_FEATURE)
-		tf_outb(tf->feature, io_ports->feature_addr);
-	if (task->tf_flags & IDE_TFLAG_OUT_NSECT)
-		tf_outb(tf->nsect, io_ports->nsect_addr);
-	if (task->tf_flags & IDE_TFLAG_OUT_LBAL)
-		tf_outb(tf->lbal, io_ports->lbal_addr);
-	if (task->tf_flags & IDE_TFLAG_OUT_LBAM)
-		tf_outb(tf->lbam, io_ports->lbam_addr);
-	if (task->tf_flags & IDE_TFLAG_OUT_LBAH)
-		tf_outb(tf->lbah, io_ports->lbah_addr);
-
-	if (task->tf_flags & IDE_TFLAG_OUT_DEVICE)
-		tf_outb((tf->device & HIHI) | drive->select,
-			 io_ports->device_addr);
-}
-EXPORT_SYMBOL_GPL(ide_tf_load);
-
-void ide_tf_read(ide_drive_t *drive, ide_task_t *task)
-{
-	ide_hwif_t *hwif = drive->hwif;
-	struct ide_io_ports *io_ports = &hwif->io_ports;
-	struct ide_taskfile *tf = &task->tf;
-	void (*tf_outb)(u8 addr, unsigned long port);
-	u8 (*tf_inb)(unsigned long port);
-	u8 mmio = (hwif->host_flags & IDE_HFLAG_MMIO) ? 1 : 0;
-
-	if (mmio) {
-		tf_outb = ide_mm_outb;
-		tf_inb  = ide_mm_inb;
-	} else {
-		tf_outb = ide_outb;
-		tf_inb  = ide_inb;
-	}
-
-	if (task->tf_flags & IDE_TFLAG_IN_DATA) {
-		u16 data;
-
-		if (mmio)
-			data = readw((void __iomem *)io_ports->data_addr);
-		else
-			data = inw(io_ports->data_addr);
-
-		tf->data = data & 0xff;
-		tf->hob_data = (data >> 8) & 0xff;
-	}
-
-	/* be sure we're looking at the low order bits */
-	tf_outb(ATA_DEVCTL_OBS & ~0x80, io_ports->ctl_addr);
-
-	if (task->tf_flags & IDE_TFLAG_IN_FEATURE)
-		tf->feature = tf_inb(io_ports->feature_addr);
-	if (task->tf_flags & IDE_TFLAG_IN_NSECT)
-		tf->nsect  = tf_inb(io_ports->nsect_addr);
-	if (task->tf_flags & IDE_TFLAG_IN_LBAL)
-		tf->lbal   = tf_inb(io_ports->lbal_addr);
-	if (task->tf_flags & IDE_TFLAG_IN_LBAM)
-		tf->lbam   = tf_inb(io_ports->lbam_addr);
-	if (task->tf_flags & IDE_TFLAG_IN_LBAH)
-		tf->lbah   = tf_inb(io_ports->lbah_addr);
-	if (task->tf_flags & IDE_TFLAG_IN_DEVICE)
-		tf->device = tf_inb(io_ports->device_addr);
-
-	if (task->tf_flags & IDE_TFLAG_LBA48) {
-		tf_outb(ATA_DEVCTL_OBS | 0x80, io_ports->ctl_addr);
-
-		if (task->tf_flags & IDE_TFLAG_IN_HOB_FEATURE)
-			tf->hob_feature = tf_inb(io_ports->feature_addr);
-		if (task->tf_flags & IDE_TFLAG_IN_HOB_NSECT)
-			tf->hob_nsect   = tf_inb(io_ports->nsect_addr);
-		if (task->tf_flags & IDE_TFLAG_IN_HOB_LBAL)
-			tf->hob_lbal    = tf_inb(io_ports->lbal_addr);
-		if (task->tf_flags & IDE_TFLAG_IN_HOB_LBAM)
-			tf->hob_lbam    = tf_inb(io_ports->lbam_addr);
-		if (task->tf_flags & IDE_TFLAG_IN_HOB_LBAH)
-			tf->hob_lbah    = tf_inb(io_ports->lbah_addr);
-	}
-}
-EXPORT_SYMBOL_GPL(ide_tf_read);
-
-/*
- * Some localbus EIDE interfaces require a special access sequence
- * when using 32-bit I/O instructions to transfer data.  We call this
- * the "vlb_sync" sequence, which consists of three successive reads
- * of the sector count register location, with interrupts disabled
- * to ensure that the reads all happen together.
- */
-static void ata_vlb_sync(unsigned long port)
-{
-	(void)inb(port);
-	(void)inb(port);
-	(void)inb(port);
-}
-
-/*
- * This is used for most PIO data transfers *from* the IDE interface
- *
- * These routines will round up any request for an odd number of bytes,
- * so if an odd len is specified, be sure that there's at least one
- * extra byte allocated for the buffer.
- */
-void ide_input_data(ide_drive_t *drive, struct request *rq, void *buf,
-		    unsigned int len)
-{
-	ide_hwif_t *hwif = drive->hwif;
-	struct ide_io_ports *io_ports = &hwif->io_ports;
-	unsigned long data_addr = io_ports->data_addr;
-	u8 io_32bit = drive->io_32bit;
-	u8 mmio = (hwif->host_flags & IDE_HFLAG_MMIO) ? 1 : 0;
-
-	len++;
-
-	if (io_32bit) {
-		unsigned long uninitialized_var(flags);
-
-		if ((io_32bit & 2) && !mmio) {
-			local_irq_save(flags);
-			ata_vlb_sync(io_ports->nsect_addr);
-		}
-
-		if (mmio)
-			__ide_mm_insl((void __iomem *)data_addr, buf, len / 4);
-		else
-			insl(data_addr, buf, len / 4);
-
-		if ((io_32bit & 2) && !mmio)
-			local_irq_restore(flags);
-
-		if ((len & 3) >= 2) {
-			if (mmio)
-				__ide_mm_insw((void __iomem *)data_addr,
-						(u8 *)buf + (len & ~3), 1);
-			else
-				insw(data_addr, (u8 *)buf + (len & ~3), 1);
-		}
-	} else {
-		if (mmio)
-			__ide_mm_insw((void __iomem *)data_addr, buf, len / 2);
-		else
-			insw(data_addr, buf, len / 2);
-	}
-}
-EXPORT_SYMBOL_GPL(ide_input_data);
-
-/*
- * This is used for most PIO data transfers *to* the IDE interface
- */
-void ide_output_data(ide_drive_t *drive, struct request *rq, void *buf,
-		     unsigned int len)
-{
-	ide_hwif_t *hwif = drive->hwif;
-	struct ide_io_ports *io_ports = &hwif->io_ports;
-	unsigned long data_addr = io_ports->data_addr;
-	u8 io_32bit = drive->io_32bit;
-	u8 mmio = (hwif->host_flags & IDE_HFLAG_MMIO) ? 1 : 0;
-
-	if (io_32bit) {
-		unsigned long uninitialized_var(flags);
-
-		if ((io_32bit & 2) && !mmio) {
-			local_irq_save(flags);
-			ata_vlb_sync(io_ports->nsect_addr);
-		}
-
-		if (mmio)
-			__ide_mm_outsl((void __iomem *)data_addr, buf, len / 4);
-		else
-			outsl(data_addr, buf, len / 4);
-
-		if ((io_32bit & 2) && !mmio)
-			local_irq_restore(flags);
-
-		if ((len & 3) >= 2) {
-			if (mmio)
-				__ide_mm_outsw((void __iomem *)data_addr,
-						 (u8 *)buf + (len & ~3), 1);
-			else
-				outsw(data_addr, (u8 *)buf + (len & ~3), 1);
-		}
-	} else {
-		if (mmio)
-			__ide_mm_outsw((void __iomem *)data_addr, buf, len / 2);
-		else
-			outsw(data_addr, buf, len / 2);
-	}
-}
-EXPORT_SYMBOL_GPL(ide_output_data);
-
 u8 ide_read_error(ide_drive_t *drive)
 {
 	ide_task_t task;
@@ -360,20 +63,6 @@ u8 ide_read_error(ide_drive_t *drive)
 }
 EXPORT_SYMBOL_GPL(ide_read_error);
 
-const struct ide_tp_ops default_tp_ops = {
-	.exec_command		= ide_exec_command,
-	.read_status		= ide_read_status,
-	.read_altstatus		= ide_read_altstatus,
-
-	.set_irq		= ide_set_irq,
-
-	.tf_load		= ide_tf_load,
-	.tf_read		= ide_tf_read,
-
-	.input_data		= ide_input_data,
-	.output_data		= ide_output_data,
-};
-
 void ide_fix_driveid(u16 *id)
 {
 #ifndef __LITTLE_ENDIAN
