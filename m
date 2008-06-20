Return-Path: <linux-kernel-owner+w=401wt.eu-S1762533AbYFTVeu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762533AbYFTVeu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2008 17:34:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756736AbYFTVcd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jun 2008 17:32:33 -0400
Received: from fg-out-1718.google.com ([72.14.220.153]:22386 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761497AbYFTVca (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2008 17:32:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=rW352Gl7QwByIjM4pi4QxoDzKvzOOCBz/OC6KhTt34YuweZg7MlOcisbQTfArFJq/Z
         N16qRoKwOGEncrCxUoAT7elkwdSfLrbnNo1JLeOtI1DoY8ZhHXMmHndDVaGEw+mYj6L6
         YRXLt9UFGwzlzmmbF/4mnf2bAVDQKihkDZeSo=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Fri, 20 Jun 2008 23:34:24 +0200
Message-Id: <20080620213424.13202.16889.sendpatchset@localhost.localdomain>
In-Reply-To: <20080620213323.13202.71450.sendpatchset@localhost.localdomain>
References: <20080620213323.13202.71450.sendpatchset@localhost.localdomain>
Subject: [PATCH 09/18] ide: add ->set_irq method
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add ->set_irq method for setting nIEN bit of ATA Device Control
register and use it instead of ide_set_irq().

While at it:

* Use ->set_irq in init_irq() and do_reset1().

* Don't use HWIF() macro in ide_check_pm_state().

There should be no functional changes caused by this patch.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/ide-io.c       |   14 ++++++++------
 drivers/ide/ide-iops.c     |   37 +++++++++++++++++++++++++++----------
 drivers/ide/ide-probe.c    |    9 ++++-----
 drivers/ide/ide-taskfile.c |    2 +-
 drivers/ide/pci/scc_pata.c |   19 +++++++++++++++++++
 drivers/ide/ppc/pmac.c     |   17 +++++++++++++++++
 include/linux/ide.h        |   10 ++--------
 7 files changed, 78 insertions(+), 30 deletions(-)

Index: b/drivers/ide/ide-io.c
===================================================================
--- a/drivers/ide/ide-io.c
+++ b/drivers/ide/ide-io.c
@@ -783,16 +783,17 @@ static void ide_check_pm_state(ide_drive
 		 * the bus may be broken enough to walk on our toes at this
 		 * point.
 		 */
+		ide_hwif_t *hwif = drive->hwif;
 		int rc;
 #ifdef DEBUG_PM
 		printk("%s: Wakeup request inited, waiting for !BSY...\n", drive->name);
 #endif
-		rc = ide_wait_not_busy(HWIF(drive), 35000);
+		rc = ide_wait_not_busy(hwif, 35000);
 		if (rc)
 			printk(KERN_WARNING "%s: bus not ready on wakeup\n", drive->name);
 		SELECT_DRIVE(drive);
-		ide_set_irq(drive, 1);
-		rc = ide_wait_not_busy(HWIF(drive), 100000);
+		hwif->set_irq(hwif, 1);
+		rc = ide_wait_not_busy(hwif, 100000);
 		if (rc)
 			printk(KERN_WARNING "%s: drive not ready on wakeup\n", drive->name);
 	}
@@ -1069,7 +1070,7 @@ static void ide_do_request (ide_hwgroup_
 			 * quirk_list may not like intr setups/cleanups
 			 */
 			if (drive->quirk_list != 1)
-				ide_set_irq(drive, 0);
+				hwif->set_irq(hwif, 0);
 		}
 		hwgroup->hwif = hwif;
 		hwgroup->drive = drive;
@@ -1547,6 +1548,7 @@ EXPORT_SYMBOL(ide_do_drive_cmd);
 
 void ide_pktcmd_tf_load(ide_drive_t *drive, u32 tf_flags, u16 bcount, u8 dma)
 {
+	ide_hwif_t *hwif = drive->hwif;
 	ide_task_t task;
 
 	memset(&task, 0, sizeof(task));
@@ -1557,9 +1559,9 @@ void ide_pktcmd_tf_load(ide_drive_t *dri
 	task.tf.lbah    = (bcount >> 8) & 0xff;
 
 	ide_tf_dump(drive->name, &task.tf);
-	ide_set_irq(drive, 1);
+	hwif->set_irq(hwif, 1);
 	SELECT_MASK(drive, 0);
-	drive->hwif->tf_load(drive, &task);
+	hwif->tf_load(drive, &task);
 }
 
 EXPORT_SYMBOL_GPL(ide_pktcmd_tf_load);
Index: b/drivers/ide/ide-iops.c
===================================================================
--- a/drivers/ide/ide-iops.c
+++ b/drivers/ide/ide-iops.c
@@ -135,6 +135,23 @@ static u8 ide_read_sff_dma_status(ide_hw
 		return inb(hwif->dma_base + ATA_DMA_STATUS);
 }
 
+static void ide_set_irq(ide_hwif_t *hwif, int on)
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
+
 static void ide_tf_load(ide_drive_t *drive, ide_task_t *task)
 {
 	ide_hwif_t *hwif = drive->hwif;
@@ -360,6 +377,8 @@ void default_hwif_transport(ide_hwif_t *
 	hwif->read_altstatus	  = ide_read_altstatus;
 	hwif->read_sff_dma_status = ide_read_sff_dma_status;
 
+	hwif->set_irq	  = ide_set_irq;
+
 	hwif->tf_load	  = ide_tf_load;
 	hwif->tf_read	  = ide_tf_read;
 
@@ -722,7 +741,7 @@ int ide_driveid_update(ide_drive_t *driv
 	 */
 
 	SELECT_MASK(drive, 1);
-	ide_set_irq(drive, 1);
+	hwif->set_irq(hwif, 1);
 	msleep(50);
 	hwif->exec_command(hwif, WIN_IDENTIFY);
 	timeout = jiffies + WAIT_WORSTCASE;
@@ -808,12 +827,12 @@ int ide_config_drive_speed(ide_drive_t *
 	SELECT_DRIVE(drive);
 	SELECT_MASK(drive, 0);
 	udelay(1);
-	ide_set_irq(drive, 0);
+	hwif->set_irq(hwif, 0);
 	hwif->OUTB(speed, io_ports->nsect_addr);
 	hwif->OUTB(SETFEATURES_XFER, io_ports->feature_addr);
 	hwif->exec_command(hwif, WIN_SETFEATURES);
 	if (drive->quirk_list == 2)
-		ide_set_irq(drive, 1);
+		hwif->set_irq(hwif, 1);
 
 	error = __ide_wait_stat(drive, drive->ready_stat,
 				BUSY_STAT|DRQ_STAT|ERR_STAT,
@@ -1116,7 +1135,6 @@ static ide_startstop_t do_reset1 (ide_dr
 	ide_hwgroup_t *hwgroup;
 	struct ide_io_ports *io_ports;
 	const struct ide_port_ops *port_ops;
-	u8 ctl;
 
 	spin_lock_irqsave(&ide_lock, flags);
 	hwif = HWIF(drive);
@@ -1162,16 +1180,15 @@ static ide_startstop_t do_reset1 (ide_dr
 	 * immediate interrupt due to the edge transition it produces.
 	 * This single interrupt gives us a "fast poll" for drives that
 	 * recover from reset very quickly, saving us the first 50ms wait time.
+	 *
+	 * TODO: add ->softreset method and stop abusing ->set_irq
 	 */
 	/* set SRST and nIEN */
-	hwif->OUTBSYNC(hwif, ATA_DEVCTL_OBS | 6, io_ports->ctl_addr);
+	hwif->set_irq(hwif, 4);
 	/* more than enough time */
 	udelay(10);
-	if (drive->quirk_list == 2)
-		ctl = ATA_DEVCTL_OBS;		/* clear SRST and nIEN */
-	else
-		ctl = ATA_DEVCTL_OBS | 2;	/* clear SRST, leave nIEN */
-	hwif->OUTBSYNC(hwif, ctl, io_ports->ctl_addr);
+	/* clear SRST, leave nIEN (unless device is on the quirk list) */
+	hwif->set_irq(hwif, drive->quirk_list == 2);
 	/* more than enough time */
 	udelay(10);
 	hwgroup->poll_timeout = jiffies + WAIT_WORSTCASE;
Index: b/drivers/ide/ide-probe.c
===================================================================
--- a/drivers/ide/ide-probe.c
+++ b/drivers/ide/ide-probe.c
@@ -361,7 +361,7 @@ static int try_to_identify (ide_drive_t 
 			autoprobe = 1;
 			cookie = probe_irq_on();
 		}
-		ide_set_irq(drive, autoprobe);
+		hwif->set_irq(hwif, autoprobe);
 	}
 
 	retval = actual_try_to_identify(drive, cmd);
@@ -369,7 +369,7 @@ static int try_to_identify (ide_drive_t 
 	if (autoprobe) {
 		int irq;
 
-		ide_set_irq(drive, 0);
+		hwif->set_irq(hwif, 0);
 		/* clear drive IRQ */
 		(void)hwif->read_status(hwif);
 		udelay(5);
@@ -711,7 +711,7 @@ static int ide_port_wait_ready(ide_hwif_
 		/* Ignore disks that we will not probe for later. */
 		if (!drive->noprobe || drive->present) {
 			SELECT_DRIVE(drive);
-			ide_set_irq(drive, 1);
+			hwif->set_irq(hwif, 1);
 			mdelay(2);
 			rc = ide_wait_not_busy(hwif, 35000);
 			if (rc)
@@ -1068,8 +1068,7 @@ static int init_irq (ide_hwif_t *hwif)
 			sa = IRQF_SHARED;
 
 		if (io_ports->ctl_addr)
-			/* clear nIEN */
-			hwif->OUTBSYNC(hwif, ATA_DEVCTL_OBS, io_ports->ctl_addr);
+			hwif->set_irq(hwif, 1);
 
 		if (request_irq(hwif->irq,&ide_intr,sa,hwif->name,hwgroup))
 	       		goto out_unlink;
Index: b/drivers/ide/ide-taskfile.c
===================================================================
--- a/drivers/ide/ide-taskfile.c
+++ b/drivers/ide/ide-taskfile.c
@@ -79,7 +79,7 @@ ide_startstop_t do_rw_taskfile (ide_driv
 
 	if ((task->tf_flags & IDE_TFLAG_DMA_PIO_FALLBACK) == 0) {
 		ide_tf_dump(drive->name, tf);
-		ide_set_irq(drive, 1);
+		hwif->set_irq(hwif, 1);
 		SELECT_MASK(drive, 0);
 		hwif->tf_load(drive, task);
 	}
Index: b/drivers/ide/pci/scc_pata.c
===================================================================
--- a/drivers/ide/pci/scc_pata.c
+++ b/drivers/ide/pci/scc_pata.c
@@ -149,6 +149,23 @@ static u8 scc_read_sff_dma_status(ide_hw
 	return (u8)in_be32((void *)(hwif->dma_base + 4));
 }
 
+static void scc_set_irq(ide_hwif_t *hwif, int on)
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
+	out_be32((void *)hwif->io_ports.ctl_addr, ctl);
+	eieio();
+	in_be32((void *)(hwif->dma_base + 0x01c));
+	eieio();
+}
+
 static void scc_ide_insw(unsigned long port, void *addr, u32 count)
 {
 	u16 *ptr = (u16 *)addr;
@@ -803,6 +820,8 @@ static void __devinit init_mmio_iops_scc
 	hwif->read_altstatus	  = scc_read_altstatus;
 	hwif->read_sff_dma_status = scc_read_sff_dma_status;
 
+	hwif->set_irq = scc_set_irq;
+
 	hwif->tf_load = scc_tf_load;
 	hwif->tf_read = scc_tf_read;
 
Index: b/drivers/ide/ppc/pmac.c
===================================================================
--- a/drivers/ide/ppc/pmac.c
+++ b/drivers/ide/ppc/pmac.c
@@ -502,6 +502,22 @@ static void pmac_exec_command(ide_hwif_t
 				     + IDE_TIMING_CONFIG));
 }
 
+static void pmac_set_irq(ide_hwif_t *hwif, int on)
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
+	writeb(ctl, (void __iomem *)hwif->io_ports.ctl_addr);
+	(void)readl((void __iomem *)(hwif->io_ports.data_addr
+				     + IDE_TIMING_CONFIG));
+}
+
 /*
  * Old tuning functions (called on hdparm -p), sets up drive PIO timings
  */
@@ -1094,6 +1110,7 @@ static int __devinit pmac_ide_setup_devi
 		return -ENOENT;
 
 	hwif->exec_command = pmac_exec_command;
+	hwif->set_irq	   = pmac_set_irq;
 
 	/* Setup MMIO ops */
 	default_hwif_mmiops(hwif);
Index: b/include/linux/ide.h
===================================================================
--- a/include/linux/ide.h
+++ b/include/linux/ide.h
@@ -473,6 +473,8 @@ typedef struct hwif_s {
 	u8	(*read_altstatus)(struct hwif_s *);
 	u8	(*read_sff_dma_status)(struct hwif_s *);
 
+	void	(*set_irq)(struct hwif_s *, int);
+
 	void (*tf_load)(ide_drive_t *, struct ide_task_s *);
 	void (*tf_read)(ide_drive_t *, struct ide_task_s *);
 
@@ -1342,14 +1344,6 @@ static inline ide_drive_t *ide_get_paire
 	return &hwif->drives[(drive->dn ^ 1) & 1];
 }
 
-static inline void ide_set_irq(ide_drive_t *drive, int on)
-{
-	ide_hwif_t *hwif = drive->hwif;
-
-	hwif->OUTBSYNC(hwif, ATA_DEVCTL_OBS | (on ? 0 : 2),
-		       hwif->io_ports.ctl_addr);
-}
-
 static inline u8 ide_read_error(ide_drive_t *drive)
 {
 	ide_hwif_t *hwif = drive->hwif;
