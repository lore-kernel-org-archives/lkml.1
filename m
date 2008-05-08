Return-Path: <linux-kernel-owner+w=401wt.eu-S1764677AbYEHTXS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764677AbYEHTXS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2008 15:23:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760428AbYEHTWC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 May 2008 15:22:02 -0400
Received: from ug-out-1314.google.com ([66.249.92.173]:31309 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752059AbYEHTV4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2008 15:21:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=Ps2suBmcgZWU2ccyquPvbknds1Lpg9RT4UIRUxEJL9AcIeYIeNH/OxoqdVF7OwyZQqvnCydeoGXPTrFdhkqSL8yDw8gWREembM1uVBkQYul05pP3TkR3sOWf2VLfDyx53zp48CQMcC5K6bf0WZ0EV8GrVwz8YoWRF9EAtwtiFdI=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Subject: [PATCH 1/4] ide: pass 'hwif *' instead of 'drive *' to ->OUTBSYNC method
Date: Thu, 8 May 2008 21:35:27 +0200
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200805082135.27591.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There should be no functional changes caused by this patch.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/ide-io.c       |    2 +-
 drivers/ide/ide-iops.c     |   18 +++++++++---------
 drivers/ide/ide-probe.c    |    6 +++---
 drivers/ide/ide-taskfile.c |    2 +-
 drivers/ide/pci/scc_pata.c |    5 +----
 drivers/ide/ppc/pmac.c     |    6 +++---
 drivers/scsi/ide-scsi.c    |    2 +-
 include/linux/ide.h        |    2 +-
 8 files changed, 20 insertions(+), 23 deletions(-)

Index: b/drivers/ide/ide-io.c
===================================================================
--- a/drivers/ide/ide-io.c
+++ b/drivers/ide/ide-io.c
@@ -437,7 +437,7 @@ static ide_startstop_t ide_atapi_error(i
 
 	if (ide_read_status(drive) & (BUSY_STAT | DRQ_STAT))
 		/* force an abort */
-		hwif->OUTBSYNC(drive, WIN_IDLEIMMEDIATE,
+		hwif->OUTBSYNC(hwif, WIN_IDLEIMMEDIATE,
 			       hwif->io_ports.command_addr);
 
 	if (rq->errors >= ERROR_MAX) {
Index: b/drivers/ide/ide-iops.c
===================================================================
--- a/drivers/ide/ide-iops.c
+++ b/drivers/ide/ide-iops.c
@@ -42,7 +42,7 @@ static void ide_outb (u8 val, unsigned l
 	outb(val, port);
 }
 
-static void ide_outbsync (ide_drive_t *drive, u8 addr, unsigned long port)
+static void ide_outbsync(ide_hwif_t *hwif, u8 addr, unsigned long port)
 {
 	outb(addr, port);
 }
@@ -68,7 +68,7 @@ static void ide_mm_outb (u8 value, unsig
 	writeb(value, (void __iomem *) port);
 }
 
-static void ide_mm_outbsync (ide_drive_t *drive, u8 value, unsigned long port)
+static void ide_mm_outbsync(ide_hwif_t *hwif, u8 value, unsigned long port)
 {
 	writeb(value, (void __iomem *) port);
 }
@@ -686,7 +686,7 @@ int ide_driveid_update(ide_drive_t *driv
 	SELECT_MASK(drive, 1);
 	ide_set_irq(drive, 1);
 	msleep(50);
-	hwif->OUTBSYNC(drive, WIN_IDENTIFY, hwif->io_ports.command_addr);
+	hwif->OUTBSYNC(hwif, WIN_IDENTIFY, hwif->io_ports.command_addr);
 	timeout = jiffies + WAIT_WORSTCASE;
 	do {
 		if (time_after(jiffies, timeout)) {
@@ -773,7 +773,7 @@ int ide_config_drive_speed(ide_drive_t *
 	ide_set_irq(drive, 0);
 	hwif->OUTB(speed, io_ports->nsect_addr);
 	hwif->OUTB(SETFEATURES_XFER, io_ports->feature_addr);
-	hwif->OUTBSYNC(drive, WIN_SETFEATURES, io_ports->command_addr);
+	hwif->OUTBSYNC(hwif, WIN_SETFEATURES, io_ports->command_addr);
 	if (drive->quirk_list == 2)
 		ide_set_irq(drive, 1);
 
@@ -881,7 +881,7 @@ void ide_execute_command(ide_drive_t *dr
 
 	spin_lock_irqsave(&ide_lock, flags);
 	__ide_set_handler(drive, handler, timeout, expiry);
-	hwif->OUTBSYNC(drive, cmd, hwif->io_ports.command_addr);
+	hwif->OUTBSYNC(hwif, cmd, hwif->io_ports.command_addr);
 	/*
 	 * Drive takes 400nS to respond, we must avoid the IRQ being
 	 * serviced before that.
@@ -899,7 +899,7 @@ void ide_execute_pkt_cmd(ide_drive_t *dr
 	unsigned long flags;
 
 	spin_lock_irqsave(&ide_lock, flags);
-	hwif->OUTBSYNC(drive, WIN_PACKETCMD, hwif->io_ports.command_addr);
+	hwif->OUTBSYNC(hwif, WIN_PACKETCMD, hwif->io_ports.command_addr);
 	ndelay(400);
 	spin_unlock_irqrestore(&ide_lock, flags);
 }
@@ -1094,7 +1094,7 @@ static ide_startstop_t do_reset1 (ide_dr
 		pre_reset(drive);
 		SELECT_DRIVE(drive);
 		udelay (20);
-		hwif->OUTBSYNC(drive, WIN_SRST, io_ports->command_addr);
+		hwif->OUTBSYNC(hwif, WIN_SRST, io_ports->command_addr);
 		ndelay(400);
 		hwgroup->poll_timeout = jiffies + WAIT_WORSTCASE;
 		hwgroup->polling = 1;
@@ -1125,14 +1125,14 @@ static ide_startstop_t do_reset1 (ide_dr
 	 * recover from reset very quickly, saving us the first 50ms wait time.
 	 */
 	/* set SRST and nIEN */
-	hwif->OUTBSYNC(drive, drive->ctl|6, io_ports->ctl_addr);
+	hwif->OUTBSYNC(hwif, drive->ctl | 6, io_ports->ctl_addr);
 	/* more than enough time */
 	udelay(10);
 	if (drive->quirk_list == 2)
 		ctl = drive->ctl;	/* clear SRST and nIEN */
 	else
 		ctl = drive->ctl | 2;	/* clear SRST, leave nIEN */
-	hwif->OUTBSYNC(drive, ctl, io_ports->ctl_addr);
+	hwif->OUTBSYNC(hwif, ctl, io_ports->ctl_addr);
 	/* more than enough time */
 	udelay(10);
 	hwgroup->poll_timeout = jiffies + WAIT_WORSTCASE;
Index: b/drivers/ide/ide-probe.c
===================================================================
--- a/drivers/ide/ide-probe.c
+++ b/drivers/ide/ide-probe.c
@@ -293,7 +293,7 @@ static int actual_try_to_identify (ide_d
 		hwif->OUTB(0, io_ports->feature_addr);
 
 	/* ask drive for ID */
-	hwif->OUTBSYNC(drive, cmd, io_ports->command_addr);
+	hwif->OUTBSYNC(hwif, cmd, hwif->io_ports.command_addr);
 
 	timeout = ((cmd == WIN_IDENTIFY) ? WAIT_WORSTCASE : WAIT_PIDENTIFY) / 2;
 	timeout += jiffies;
@@ -480,7 +480,7 @@ static int do_probe (ide_drive_t *drive,
 			msleep(50);
 			SELECT_DRIVE(drive);
 			msleep(50);
-			hwif->OUTBSYNC(drive, WIN_SRST, io_ports->command_addr);
+			hwif->OUTBSYNC(hwif, WIN_SRST, io_ports->command_addr);
 			(void)ide_busy_sleep(hwif);
 			rc = try_to_identify(drive, cmd);
 		}
@@ -516,7 +516,7 @@ static void enable_nest (ide_drive_t *dr
 	printk("%s: enabling %s -- ", hwif->name, drive->id->model);
 	SELECT_DRIVE(drive);
 	msleep(50);
-	hwif->OUTBSYNC(drive, EXABYTE_ENABLE_NEST, hwif->io_ports.command_addr);
+	hwif->OUTBSYNC(hwif, EXABYTE_ENABLE_NEST, hwif->io_ports.command_addr);
 
 	if (ide_busy_sleep(hwif)) {
 		printk(KERN_CONT "failed (timeout)\n");
Index: b/drivers/ide/ide-taskfile.c
===================================================================
--- a/drivers/ide/ide-taskfile.c
+++ b/drivers/ide/ide-taskfile.c
@@ -117,7 +117,7 @@ ide_startstop_t do_rw_taskfile (ide_driv
 	switch (task->data_phase) {
 	case TASKFILE_MULTI_OUT:
 	case TASKFILE_OUT:
-		hwif->OUTBSYNC(drive, tf->command, hwif->io_ports.command_addr);
+		hwif->OUTBSYNC(hwif, tf->command, hwif->io_ports.command_addr);
 		ndelay(400);	/* FIXME */
 		return pre_task_out_intr(drive, task->rq);
 	case TASKFILE_MULTI_IN:
Index: b/drivers/ide/pci/scc_pata.c
===================================================================
--- a/drivers/ide/pci/scc_pata.c
+++ b/drivers/ide/pci/scc_pata.c
@@ -148,11 +148,8 @@ static void scc_ide_outb(u8 addr, unsign
 	out_be32((void*)port, addr);
 }
 
-static void
-scc_ide_outbsync(ide_drive_t * drive, u8 addr, unsigned long port)
+static void scc_ide_outbsync(ide_hwif_t *hwif, u8 addr, unsigned long port)
 {
-	ide_hwif_t *hwif = HWIF(drive);
-
 	out_be32((void*)port, addr);
 	eieio();
 	in_be32((void*)(hwif->dma_base + 0x01c));
Index: b/drivers/ide/ppc/pmac.c
===================================================================
--- a/drivers/ide/ppc/pmac.c
+++ b/drivers/ide/ppc/pmac.c
@@ -481,13 +481,13 @@ pmac_ide_do_update_timings(ide_drive_t *
 		pmac_ide_selectproc(drive);
 }
 
-static void
-pmac_outbsync(ide_drive_t *drive, u8 value, unsigned long port)
+static void pmac_outbsync(ide_hwif_t *hwif, u8 value, unsigned long port)
 {
 	u32 tmp;
 	
 	writeb(value, (void __iomem *) port);
-	tmp = readl(PMAC_IDE_REG(IDE_TIMING_CONFIG));
+	tmp = readl((void __iomem *)(hwif->io_ports.data_addr
+				     + IDE_TIMING_CONFIG));
 }
 
 /*
Index: b/drivers/scsi/ide-scsi.c
===================================================================
--- a/drivers/scsi/ide-scsi.c
+++ b/drivers/scsi/ide-scsi.c
@@ -257,7 +257,7 @@ idescsi_atapi_error(ide_drive_t *drive, 
 
 	if (ide_read_status(drive) & (BUSY_STAT | DRQ_STAT))
 		/* force an abort */
-		hwif->OUTBSYNC(drive, WIN_IDLEIMMEDIATE,
+		hwif->OUTBSYNC(hwif, WIN_IDLEIMMEDIATE,
 			       hwif->io_ports.command_addr);
 
 	rq->errors++;
Index: b/include/linux/ide.h
===================================================================
--- a/include/linux/ide.h
+++ b/include/linux/ide.h
@@ -478,7 +478,7 @@ typedef struct hwif_s {
 	void (*ide_dma_clear_irq)(ide_drive_t *drive);
 
 	void (*OUTB)(u8 addr, unsigned long port);
-	void (*OUTBSYNC)(ide_drive_t *drive, u8 addr, unsigned long port);
+	void (*OUTBSYNC)(struct hwif_s *hwif, u8 addr, unsigned long port);
 
 	u8  (*INB)(unsigned long port);
 
