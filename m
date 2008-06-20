Return-Path: <linux-kernel-owner+w=401wt.eu-S1757016AbYFTVds@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757016AbYFTVds (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2008 17:33:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761420AbYFTVcN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jun 2008 17:32:13 -0400
Received: from fk-out-0910.google.com ([209.85.128.190]:5898 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761380AbYFTVcI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2008 17:32:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=jIHqKavxRiBt1+g17QKPsjrTNYYZCXMtobvWAoQzZfLerGlct7KfdTTE/VY0gl8MAM
         uCTggu2oGdnffXIE/h1aa/GD/R91Xs0LzxJx3Qp69NbGStZNfy3Rc7AWi7dwWj58B4jg
         73DneHIIE1IU/Qj0NRNhqk+PQab5R6u0rd6RI=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Fri, 20 Jun 2008 23:34:03 +0200
Message-Id: <20080620213403.13202.26763.sendpatchset@localhost.localdomain>
In-Reply-To: <20080620213323.13202.71450.sendpatchset@localhost.localdomain>
References: <20080620213323.13202.71450.sendpatchset@localhost.localdomain>
Subject: [PATCH 06/18] ide: add ->exec_command method
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add ->exec_command method for writing ATA Command register
and use it instead of ->OUTBSYNC.

There should be no functional changes caused by this patch.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/ide-io.c       |    3 +--
 drivers/ide/ide-iops.c     |   19 ++++++++++++++-----
 drivers/ide/ide-probe.c    |    6 +++---
 drivers/ide/ide-taskfile.c |    2 +-
 drivers/ide/pci/scc_pata.c |    9 +++++++++
 drivers/ide/ppc/pmac.c     |    9 +++++++++
 drivers/scsi/ide-scsi.c    |    3 +--
 include/linux/ide.h        |    3 ++-
 8 files changed, 40 insertions(+), 14 deletions(-)

Index: b/drivers/ide/ide-io.c
===================================================================
--- a/drivers/ide/ide-io.c
+++ b/drivers/ide/ide-io.c
@@ -437,8 +437,7 @@ static ide_startstop_t ide_atapi_error(i
 
 	if (ide_read_status(drive) & (BUSY_STAT | DRQ_STAT))
 		/* force an abort */
-		hwif->OUTBSYNC(hwif, WIN_IDLEIMMEDIATE,
-			       hwif->io_ports.command_addr);
+		hwif->exec_command(hwif, WIN_IDLEIMMEDIATE);
 
 	if (rq->errors >= ERROR_MAX) {
 		ide_kill_rq(drive, rq);
Index: b/drivers/ide/ide-iops.c
===================================================================
--- a/drivers/ide/ide-iops.c
+++ b/drivers/ide/ide-iops.c
@@ -103,6 +103,14 @@ void SELECT_MASK(ide_drive_t *drive, int
 		port_ops->maskproc(drive, mask);
 }
 
+static void ide_exec_command(ide_hwif_t *hwif, u8 cmd)
+{
+	if (hwif->host_flags & IDE_HFLAG_MMIO)
+		writeb(cmd, (void __iomem *)hwif->io_ports.command_addr);
+	else
+		outb(cmd, hwif->io_ports.command_addr);
+}
+
 static u8 ide_read_sff_dma_status(ide_hwif_t *hwif)
 {
 	if (hwif->host_flags & IDE_HFLAG_MMIO)
@@ -331,6 +339,7 @@ static void ata_output_data(ide_drive_t 
 
 void default_hwif_transport(ide_hwif_t *hwif)
 {
+	hwif->exec_command	  = ide_exec_command;
 	hwif->read_sff_dma_status = ide_read_sff_dma_status;
 
 	hwif->tf_load	  = ide_tf_load;
@@ -696,7 +705,7 @@ int ide_driveid_update(ide_drive_t *driv
 	SELECT_MASK(drive, 1);
 	ide_set_irq(drive, 1);
 	msleep(50);
-	hwif->OUTBSYNC(hwif, WIN_IDENTIFY, hwif->io_ports.command_addr);
+	hwif->exec_command(hwif, WIN_IDENTIFY);
 	timeout = jiffies + WAIT_WORSTCASE;
 	do {
 		if (time_after(jiffies, timeout)) {
@@ -783,7 +792,7 @@ int ide_config_drive_speed(ide_drive_t *
 	ide_set_irq(drive, 0);
 	hwif->OUTB(speed, io_ports->nsect_addr);
 	hwif->OUTB(SETFEATURES_XFER, io_ports->feature_addr);
-	hwif->OUTBSYNC(hwif, WIN_SETFEATURES, io_ports->command_addr);
+	hwif->exec_command(hwif, WIN_SETFEATURES);
 	if (drive->quirk_list == 2)
 		ide_set_irq(drive, 1);
 
@@ -891,7 +900,7 @@ void ide_execute_command(ide_drive_t *dr
 
 	spin_lock_irqsave(&ide_lock, flags);
 	__ide_set_handler(drive, handler, timeout, expiry);
-	hwif->OUTBSYNC(hwif, cmd, hwif->io_ports.command_addr);
+	hwif->exec_command(hwif, cmd);
 	/*
 	 * Drive takes 400nS to respond, we must avoid the IRQ being
 	 * serviced before that.
@@ -909,7 +918,7 @@ void ide_execute_pkt_cmd(ide_drive_t *dr
 	unsigned long flags;
 
 	spin_lock_irqsave(&ide_lock, flags);
-	hwif->OUTBSYNC(hwif, WIN_PACKETCMD, hwif->io_ports.command_addr);
+	hwif->exec_command(hwif, WIN_PACKETCMD);
 	ndelay(400);
 	spin_unlock_irqrestore(&ide_lock, flags);
 }
@@ -1104,7 +1113,7 @@ static ide_startstop_t do_reset1 (ide_dr
 		pre_reset(drive);
 		SELECT_DRIVE(drive);
 		udelay (20);
-		hwif->OUTBSYNC(hwif, WIN_SRST, io_ports->command_addr);
+		hwif->exec_command(hwif, WIN_SRST);
 		ndelay(400);
 		hwgroup->poll_timeout = jiffies + WAIT_WORSTCASE;
 		hwgroup->polling = 1;
Index: b/drivers/ide/ide-probe.c
===================================================================
--- a/drivers/ide/ide-probe.c
+++ b/drivers/ide/ide-probe.c
@@ -295,7 +295,7 @@ static int actual_try_to_identify (ide_d
 		hwif->OUTB(0, io_ports->feature_addr);
 
 	/* ask drive for ID */
-	hwif->OUTBSYNC(hwif, cmd, hwif->io_ports.command_addr);
+	hwif->exec_command(hwif, cmd);
 
 	timeout = ((cmd == WIN_IDENTIFY) ? WAIT_WORSTCASE : WAIT_PIDENTIFY) / 2;
 	timeout += jiffies;
@@ -482,7 +482,7 @@ static int do_probe (ide_drive_t *drive,
 			msleep(50);
 			SELECT_DRIVE(drive);
 			msleep(50);
-			hwif->OUTBSYNC(hwif, WIN_SRST, io_ports->command_addr);
+			hwif->exec_command(hwif, WIN_SRST);
 			(void)ide_busy_sleep(hwif);
 			rc = try_to_identify(drive, cmd);
 		}
@@ -518,7 +518,7 @@ static void enable_nest (ide_drive_t *dr
 	printk("%s: enabling %s -- ", hwif->name, drive->id->model);
 	SELECT_DRIVE(drive);
 	msleep(50);
-	hwif->OUTBSYNC(hwif, EXABYTE_ENABLE_NEST, hwif->io_ports.command_addr);
+	hwif->exec_command(hwif, EXABYTE_ENABLE_NEST);
 
 	if (ide_busy_sleep(hwif)) {
 		printk(KERN_CONT "failed (timeout)\n");
Index: b/drivers/ide/ide-taskfile.c
===================================================================
--- a/drivers/ide/ide-taskfile.c
+++ b/drivers/ide/ide-taskfile.c
@@ -87,7 +87,7 @@ ide_startstop_t do_rw_taskfile (ide_driv
 	switch (task->data_phase) {
 	case TASKFILE_MULTI_OUT:
 	case TASKFILE_OUT:
-		hwif->OUTBSYNC(hwif, tf->command, hwif->io_ports.command_addr);
+		hwif->exec_command(hwif, tf->command);
 		ndelay(400);	/* FIXME */
 		return pre_task_out_intr(drive, task->rq);
 	case TASKFILE_MULTI_IN:
Index: b/drivers/ide/pci/scc_pata.c
===================================================================
--- a/drivers/ide/pci/scc_pata.c
+++ b/drivers/ide/pci/scc_pata.c
@@ -126,6 +126,14 @@ static u8 scc_ide_inb(unsigned long port
 	return (u8)data;
 }
 
+static void scc_exec_command(ide_hwif_t *hwif, u8 cmd)
+{
+	out_be32((void *)hwif->io_ports.command_addr, cmd);
+	eieio();
+	in_be32((void *)(hwif->dma_base + 0x01c));
+	eieio();
+}
+
 static u8 scc_read_sff_dma_status(ide_hwif_t *hwif)
 {
 	return (u8)in_be32((void *)(hwif->dma_base + 4));
@@ -780,6 +788,7 @@ static void __devinit init_mmio_iops_scc
 
 	ide_set_hwifdata(hwif, ports);
 
+	hwif->exec_command	  = scc_exec_command;
 	hwif->read_sff_dma_status = scc_read_sff_dma_status;
 
 	hwif->tf_load = scc_tf_load;
Index: b/drivers/ide/ppc/pmac.c
===================================================================
--- a/drivers/ide/ppc/pmac.c
+++ b/drivers/ide/ppc/pmac.c
@@ -495,6 +495,13 @@ static void pmac_outbsync(ide_hwif_t *hw
 				     + IDE_TIMING_CONFIG));
 }
 
+static void pmac_exec_command(ide_hwif_t *hwif, u8 cmd)
+{
+	writeb(cmd, (void __iomem *)hwif->io_ports.command_addr);
+	(void)readl((void __iomem *)(hwif->io_ports.data_addr
+				     + IDE_TIMING_CONFIG));
+}
+
 /*
  * Old tuning functions (called on hdparm -p), sets up drive PIO timings
  */
@@ -1086,6 +1093,8 @@ static int __devinit pmac_ide_setup_devi
 	if (hwif == NULL)
 		return -ENOENT;
 
+	hwif->exec_command = pmac_exec_command;
+
 	/* Setup MMIO ops */
 	default_hwif_mmiops(hwif);
        	hwif->OUTBSYNC = pmac_outbsync;
Index: b/drivers/scsi/ide-scsi.c
===================================================================
--- a/drivers/scsi/ide-scsi.c
+++ b/drivers/scsi/ide-scsi.c
@@ -248,8 +248,7 @@ idescsi_atapi_error(ide_drive_t *drive, 
 
 	if (ide_read_status(drive) & (BUSY_STAT | DRQ_STAT))
 		/* force an abort */
-		hwif->OUTBSYNC(hwif, WIN_IDLEIMMEDIATE,
-			       hwif->io_ports.command_addr);
+		hwif->exec_command(hwif, WIN_IDLEIMMEDIATE);
 
 	rq->errors++;
 
Index: b/include/linux/ide.h
===================================================================
--- a/include/linux/ide.h
+++ b/include/linux/ide.h
@@ -468,7 +468,8 @@ typedef struct hwif_s {
 	const struct ide_port_ops	*port_ops;
 	const struct ide_dma_ops	*dma_ops;
 
-	u8 (*read_sff_dma_status)(struct hwif_s *);
+	void	(*exec_command)(struct hwif_s *, u8);
+	u8	(*read_sff_dma_status)(struct hwif_s *);
 
 	void (*tf_load)(ide_drive_t *, struct ide_task_s *);
 	void (*tf_read)(ide_drive_t *, struct ide_task_s *);
