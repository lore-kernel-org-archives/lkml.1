Return-Path: <linux-kernel-owner+w=401wt.eu-S1759385AbYDJUMy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759385AbYDJUMy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2008 16:12:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758899AbYDJUMU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Apr 2008 16:12:20 -0400
Received: from fk-out-0910.google.com ([209.85.128.188]:16851 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757745AbYDJUMP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2008 16:12:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=xkUqtZ7cMgF2PDHAZalxjQ2/0PCh7Z7Av3Z87EnWE2ozIC7Ow816pX504pfke9vb7eETBkJh029dmekknVaaUEdGUhpydlQBOYbHST7tgH16gN1zxiNYY0ipp2P9QFrxcucIfcRlykgFS+SSpeE87JNtge0hkxB9pUJl7XawhQE=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Subject: [PATCH 1/3] ide: always use ->OUTBSYNC method for executing commands
Date: Thu, 10 Apr 2008 22:26:44 +0200
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200804102226.44209.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Always use ->OUTBSYNC method for executing commands so the posting is done
if needed (this affects only pmac and scc_pata host drivers at the moment).

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/ide-floppy.c |    3 ++-
 drivers/ide/ide-io.c     |    3 ++-
 drivers/ide/ide-iops.c   |    2 +-
 drivers/ide/ide-probe.c  |    6 +++---
 drivers/ide/ide-tape.c   |    3 ++-
 drivers/scsi/ide-scsi.c  |    6 ++++--
 6 files changed, 14 insertions(+), 9 deletions(-)

Index: b/drivers/ide/ide-floppy.c
===================================================================
--- a/drivers/ide/ide-floppy.c
+++ b/drivers/ide/ide-floppy.c
@@ -696,7 +696,8 @@ static ide_startstop_t idefloppy_issue_p
 		return ide_started;
 	} else {
 		/* Issue the packet command */
-		hwif->OUTB(WIN_PACKETCMD, hwif->io_ports.command_addr);
+		hwif->OUTBSYNC(drive, WIN_PACKETCMD,
+			       hwif->io_ports.command_addr);
 		return (*pkt_xfer_routine) (drive);
 	}
 }
Index: b/drivers/ide/ide-io.c
===================================================================
--- a/drivers/ide/ide-io.c
+++ b/drivers/ide/ide-io.c
@@ -502,7 +502,8 @@ static ide_startstop_t ide_atapi_error(i
 
 	if (ide_read_status(drive) & (BUSY_STAT | DRQ_STAT))
 		/* force an abort */
-		hwif->OUTB(WIN_IDLEIMMEDIATE, hwif->io_ports.command_addr);
+		hwif->OUTBSYNC(drive, WIN_IDLEIMMEDIATE,
+			       hwif->io_ports.command_addr);
 
 	if (rq->errors >= ERROR_MAX) {
 		ide_kill_rq(drive, rq);
Index: b/drivers/ide/ide-iops.c
===================================================================
--- a/drivers/ide/ide-iops.c
+++ b/drivers/ide/ide-iops.c
@@ -593,7 +593,7 @@ int ide_driveid_update(ide_drive_t *driv
 	SELECT_MASK(drive, 1);
 	ide_set_irq(drive, 1);
 	msleep(50);
-	hwif->OUTB(WIN_IDENTIFY, hwif->io_ports.command_addr);
+	hwif->OUTBSYNC(drive, WIN_IDENTIFY, hwif->io_ports.command_addr);
 	timeout = jiffies + WAIT_WORSTCASE;
 	do {
 		if (time_after(jiffies, timeout)) {
Index: b/drivers/ide/ide-probe.c
===================================================================
--- a/drivers/ide/ide-probe.c
+++ b/drivers/ide/ide-probe.c
@@ -295,7 +295,7 @@ static int actual_try_to_identify (ide_d
 		hwif->OUTB(0, io_ports->feature_addr);
 
 	/* ask drive for ID */
-	hwif->OUTB(cmd, io_ports->command_addr);
+	hwif->OUTBSYNC(drive, cmd, io_ports->command_addr);
 
 	timeout = ((cmd == WIN_IDENTIFY) ? WAIT_WORSTCASE : WAIT_PIDENTIFY) / 2;
 	timeout += jiffies;
@@ -482,7 +482,7 @@ static int do_probe (ide_drive_t *drive,
 			msleep(50);
 			hwif->OUTB(drive->select.all, io_ports->device_addr);
 			msleep(50);
-			hwif->OUTB(WIN_SRST, io_ports->command_addr);
+			hwif->OUTBSYNC(drive, WIN_SRST, io_ports->command_addr);
 			(void)ide_busy_sleep(hwif);
 			rc = try_to_identify(drive, cmd);
 		}
@@ -518,7 +518,7 @@ static void enable_nest (ide_drive_t *dr
 	printk("%s: enabling %s -- ", hwif->name, drive->id->model);
 	SELECT_DRIVE(drive);
 	msleep(50);
-	hwif->OUTB(EXABYTE_ENABLE_NEST, hwif->io_ports.command_addr);
+	hwif->OUTBSYNC(drive, EXABYTE_ENABLE_NEST, hwif->io_ports.command_addr);
 
 	if (ide_busy_sleep(hwif)) {
 		printk(KERN_CONT "failed (timeout)\n");
Index: b/drivers/ide/ide-tape.c
===================================================================
--- a/drivers/ide/ide-tape.c
+++ b/drivers/ide/ide-tape.c
@@ -1056,7 +1056,8 @@ static ide_startstop_t idetape_issue_pc(
 				    IDETAPE_WAIT_CMD, NULL);
 		return ide_started;
 	} else {
-		hwif->OUTB(WIN_PACKETCMD, hwif->io_ports.command_addr);
+		hwif->OUTBSYNC(drive, WIN_PACKETCMD,
+			       hwif->io_ports.command_addr);
 		return idetape_transfer_pc(drive);
 	}
 }
Index: b/drivers/scsi/ide-scsi.c
===================================================================
--- a/drivers/scsi/ide-scsi.c
+++ b/drivers/scsi/ide-scsi.c
@@ -256,7 +256,8 @@ idescsi_atapi_error(ide_drive_t *drive, 
 
 	if (ide_read_status(drive) & (BUSY_STAT | DRQ_STAT))
 		/* force an abort */
-		hwif->OUTB(WIN_IDLEIMMEDIATE, hwif->io_ports.command_addr);
+		hwif->OUTBSYNC(drive, WIN_IDLEIMMEDIATE,
+			       hwif->io_ports.command_addr);
 
 	rq->errors++;
 
@@ -573,7 +574,8 @@ static ide_startstop_t idescsi_issue_pc(
 		return ide_started;
 	} else {
 		/* Issue the packet command */
-		hwif->OUTB(WIN_PACKETCMD, hwif->io_ports.command_addr);
+		hwif->OUTBSYNC(drive, WIN_PACKETCMD,
+			       hwif->io_ports.command_addr);
 		return idescsi_transfer_pc(drive);
 	}
 }
