Return-Path: <linux-kernel-owner+w=401wt.eu-S932869AbYEHTYR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932869AbYEHTYR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2008 15:24:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760863AbYEHTWH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 May 2008 15:22:07 -0400
Received: from nf-out-0910.google.com ([64.233.182.191]:2324 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754418AbYEHTV6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2008 15:21:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=gatPzT8nn89nafcE0hi2tN3w3tVW9sqCqFu2MBHfG2qQ/iAOxs4k3YsQ3wWGTqTjOcNUZNXzEdsrPuwnDxOQ3dXDtFD0FPzdVZqs/5MBJmA+5QCE9DZcttuhYEz0Od7egjYLwl0pD+VjppBY/DCgqvWUuU481lg/JhxgZHhNBeA=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Subject: [PATCH 4/4] ide: remove drive->ctl
Date: Thu, 8 May 2008 21:37:33 +0200
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200805082137.33747.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove drive->ctl (it is always equal to 0x08 after init time).

While at it:

* Use ATA_DEVCTL_OBS define.

There should be no functional changes caused by this patch.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/h8300/ide-h8300.c |    4 ++--
 drivers/ide/ide-iops.c        |   10 +++++-----
 drivers/ide/ide-probe.c       |    2 +-
 drivers/ide/ide.c             |    1 -
 drivers/ide/pci/hpt366.c      |    3 +--
 drivers/ide/pci/ns87415.c     |    4 ++--
 drivers/ide/pci/scc_pata.c    |    4 ++--
 drivers/ide/pci/sgiioc4.c     |    2 +-
 include/linux/ide.h           |    3 +--
 9 files changed, 15 insertions(+), 18 deletions(-)

Index: b/drivers/ide/h8300/ide-h8300.c
===================================================================
--- a/drivers/ide/h8300/ide-h8300.c
+++ b/drivers/ide/h8300/ide-h8300.c
@@ -96,7 +96,7 @@ static void h8300_tf_read(ide_drive_t *d
 	}
 
 	/* be sure we're looking at the low order bits */
-	outb(drive->ctl & ~0x80, io_ports->ctl_addr);
+	outb(ATA_DEVCTL_OBS & ~0x80, io_ports->ctl_addr);
 
 	if (task->tf_flags & IDE_TFLAG_IN_NSECT)
 		tf->nsect  = inb(io_ports->nsect_addr);
@@ -110,7 +110,7 @@ static void h8300_tf_read(ide_drive_t *d
 		tf->device = inb(io_ports->device_addr);
 
 	if (task->tf_flags & IDE_TFLAG_LBA48) {
-		outb(drive->ctl | 0x80, io_ports->ctl_addr);
+		outb(ATA_DEVCTL_OBS | 0x80, io_ports->ctl_addr);
 
 		if (task->tf_flags & IDE_TFLAG_IN_HOB_FEATURE)
 			tf->hob_feature = inb(io_ports->feature_addr);
Index: b/drivers/ide/ide-iops.c
===================================================================
--- a/drivers/ide/ide-iops.c
+++ b/drivers/ide/ide-iops.c
@@ -186,7 +186,7 @@ static void ide_tf_read(ide_drive_t *dri
 	}
 
 	/* be sure we're looking at the low order bits */
-	tf_outb(drive->ctl & ~0x80, io_ports->ctl_addr);
+	tf_outb(ATA_DEVCTL_OBS & ~0x80, io_ports->ctl_addr);
 
 	if (task->tf_flags & IDE_TFLAG_IN_NSECT)
 		tf->nsect  = tf_inb(io_ports->nsect_addr);
@@ -200,7 +200,7 @@ static void ide_tf_read(ide_drive_t *dri
 		tf->device = tf_inb(io_ports->device_addr);
 
 	if (task->tf_flags & IDE_TFLAG_LBA48) {
-		tf_outb(drive->ctl | 0x80, io_ports->ctl_addr);
+		tf_outb(ATA_DEVCTL_OBS | 0x80, io_ports->ctl_addr);
 
 		if (task->tf_flags & IDE_TFLAG_IN_HOB_FEATURE)
 			tf->hob_feature = tf_inb(io_ports->feature_addr);
@@ -1125,13 +1125,13 @@ static ide_startstop_t do_reset1 (ide_dr
 	 * recover from reset very quickly, saving us the first 50ms wait time.
 	 */
 	/* set SRST and nIEN */
-	hwif->OUTBSYNC(hwif, drive->ctl | 6, io_ports->ctl_addr);
+	hwif->OUTBSYNC(hwif, ATA_DEVCTL_OBS | 6, io_ports->ctl_addr);
 	/* more than enough time */
 	udelay(10);
 	if (drive->quirk_list == 2)
-		ctl = drive->ctl;	/* clear SRST and nIEN */
+		ctl = ATA_DEVCTL_OBS;		/* clear SRST and nIEN */
 	else
-		ctl = drive->ctl | 2;	/* clear SRST, leave nIEN */
+		ctl = ATA_DEVCTL_OBS | 2;	/* clear SRST, leave nIEN */
 	hwif->OUTBSYNC(hwif, ctl, io_ports->ctl_addr);
 	/* more than enough time */
 	udelay(10);
Index: b/drivers/ide/ide-probe.c
===================================================================
--- a/drivers/ide/ide-probe.c
+++ b/drivers/ide/ide-probe.c
@@ -1068,7 +1068,7 @@ static int init_irq (ide_hwif_t *hwif)
 
 		if (io_ports->ctl_addr)
 			/* clear nIEN */
-			hwif->OUTBSYNC(hwif, 0x08, io_ports->ctl_addr);
+			hwif->OUTBSYNC(hwif, ATA_DEVCTL_OBS, io_ports->ctl_addr);
 
 		if (request_irq(hwif->irq,&ide_intr,sa,hwif->name,hwgroup))
 	       		goto out_unlink;
Index: b/drivers/ide/ide.c
===================================================================
--- a/drivers/ide/ide.c
+++ b/drivers/ide/ide.c
@@ -136,7 +136,6 @@ static void ide_port_init_devices_data(i
 		drive->media			= ide_disk;
 		drive->select.all		= (unit<<4)|0xa0;
 		drive->hwif			= hwif;
-		drive->ctl			= 0x08;
 		drive->ready_stat		= READY_STAT;
 		drive->bad_wstat		= BAD_W_STAT;
 		drive->special.b.recalibrate	= 1;
Index: b/drivers/ide/pci/hpt366.c
===================================================================
--- a/drivers/ide/pci/hpt366.c
+++ b/drivers/ide/pci/hpt366.c
@@ -759,8 +759,7 @@ static void hpt3xx_maskproc(ide_drive_t 
 				enable_irq (hwif->irq);
 		}
 	} else
-		outb(mask ? (drive->ctl | 2) : (drive->ctl & ~2),
-		     hwif->io_ports.ctl_addr);
+		outb(ATA_DEVCTL_OBS | (mask ? 2 : 0), hwif->io_ports.ctl_addr);
 }
 
 /*
Index: b/drivers/ide/pci/ns87415.c
===================================================================
--- a/drivers/ide/pci/ns87415.c
+++ b/drivers/ide/pci/ns87415.c
@@ -76,7 +76,7 @@ static void superio_tf_read(ide_drive_t 
 	}
 
 	/* be sure we're looking at the low order bits */
-	outb(drive->ctl & ~0x80, io_ports->ctl_addr);
+	outb(ATA_DEVCTL_OBS & ~0x80, io_ports->ctl_addr);
 
 	if (task->tf_flags & IDE_TFLAG_IN_NSECT)
 		tf->nsect  = inb(io_ports->nsect_addr);
@@ -90,7 +90,7 @@ static void superio_tf_read(ide_drive_t 
 		tf->device = superio_ide_inb(io_ports->device_addr);
 
 	if (task->tf_flags & IDE_TFLAG_LBA48) {
-		outb(drive->ctl | 0x80, io_ports->ctl_addr);
+		outb(ATA_DEVCTL_OBS | 0x80, io_ports->ctl_addr);
 
 		if (task->tf_flags & IDE_TFLAG_IN_HOB_FEATURE)
 			tf->hob_feature = inb(io_ports->feature_addr);
Index: b/drivers/ide/pci/scc_pata.c
===================================================================
--- a/drivers/ide/pci/scc_pata.c
+++ b/drivers/ide/pci/scc_pata.c
@@ -703,7 +703,7 @@ static void scc_tf_read(ide_drive_t *dri
 	}
 
 	/* be sure we're looking at the low order bits */
-	scc_ide_outb(drive->ctl & ~0x80, io_ports->ctl_addr);
+	scc_ide_outb(ATA_DEVCTL_OBS & ~0x80, io_ports->ctl_addr);
 
 	if (task->tf_flags & IDE_TFLAG_IN_NSECT)
 		tf->nsect  = scc_ide_inb(io_ports->nsect_addr);
@@ -717,7 +717,7 @@ static void scc_tf_read(ide_drive_t *dri
 		tf->device = scc_ide_inb(io_ports->device_addr);
 
 	if (task->tf_flags & IDE_TFLAG_LBA48) {
-		scc_ide_outb(drive->ctl | 0x80, io_ports->ctl_addr);
+		scc_ide_outb(ATA_DEVCTL_OBS | 0x80, io_ports->ctl_addr);
 
 		if (task->tf_flags & IDE_TFLAG_IN_HOB_FEATURE)
 			tf->hob_feature = scc_ide_inb(io_ports->feature_addr);
Index: b/drivers/ide/pci/sgiioc4.c
===================================================================
--- a/drivers/ide/pci/sgiioc4.c
+++ b/drivers/ide/pci/sgiioc4.c
@@ -111,7 +111,7 @@ sgiioc4_init_hwif_ports(hw_regs_t * hw, 
 static void
 sgiioc4_maskproc(ide_drive_t * drive, int mask)
 {
-	writeb(mask ? (drive->ctl | 2) : (drive->ctl & ~2),
+	writeb(ATA_DEVCTL_OBS | (mask ? 2 : 0),
 	       (void __iomem *)drive->hwif->io_ports.ctl_addr);
 }
 
Index: b/include/linux/ide.h
===================================================================
--- a/include/linux/ide.h
+++ b/include/linux/ide.h
@@ -349,7 +349,6 @@ typedef struct ide_drive_s {
         u8	wcache;		/* status of write cache */
 	u8	acoustic;	/* acoustic management */
 	u8	media;		/* disk, cdrom, tape, floppy, ... */
-	u8	ctl;		/* "normal" value for Control register */
 	u8	ready_stat;	/* min status value for drive ready */
 	u8	mult_count;	/* current multiple sector setting */
 	u8	mult_req;	/* requested multiple sector setting */
@@ -1325,7 +1324,7 @@ static inline void ide_set_irq(ide_drive
 {
 	ide_hwif_t *hwif = drive->hwif;
 
-	hwif->OUTBSYNC(hwif, drive->ctl | (on ? 0 : 2),
+	hwif->OUTBSYNC(hwif, ATA_DEVCTL_OBS | (on ? 0 : 2),
 		       hwif->io_ports.ctl_addr);
 }
 
