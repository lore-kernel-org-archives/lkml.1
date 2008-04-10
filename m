Return-Path: <linux-kernel-owner+w=401wt.eu-S1759471AbYDJUNN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759471AbYDJUNN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2008 16:13:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758914AbYDJUMV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Apr 2008 16:12:21 -0400
Received: from nf-out-0910.google.com ([64.233.182.190]:27884 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757581AbYDJUMT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2008 16:12:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:mime-version:content-disposition:message-id:content-type:content-transfer-encoding;
        b=obcAUceM9251Ga/9IWZSB9jOEcDRVylRAyXR5s5Yt0iCQDdqciKoEpCfT4drMRSWheDDBVGMS/l22yRGGyOnmNNyGa2tFaO1rPQkIOMjhg9+aUrXcnuiUEOOVXoc5tXwLZ9d5UL5W5WxmXC7344GIzRyusNaMIcKFqKRV9rJc0M=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Subject: [PATCH 3/3] ide: add ide_execute_pkt_cmd() helper
Date: Thu, 10 Apr 2008 22:26:52 +0200
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200804102226.52658.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add ide_execute_pkt_cmd() helper for executing PACKET command,
then convert ATAPI device drivers to use it.

As a nice side-effect this fixes ide-{floppy,tape,scsi} w.r.t.
ide_lock taking (ide-cd was OK).

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/ide-cd.c     |    9 +--------
 drivers/ide/ide-floppy.c |    4 +---
 drivers/ide/ide-iops.c   |   12 +++++++++++-
 drivers/ide/ide-tape.c   |    4 +---
 drivers/scsi/ide-scsi.c  |    4 +---
 include/linux/ide.h      |    2 ++
 6 files changed, 17 insertions(+), 18 deletions(-)

Index: b/drivers/ide/ide-cd.c
===================================================================
--- a/drivers/ide/ide-cd.c
+++ b/drivers/ide/ide-cd.c
@@ -555,14 +555,7 @@ static ide_startstop_t cdrom_start_packe
 				    ATAPI_WAIT_PC, cdrom_timer_expiry);
 		return ide_started;
 	} else {
-		unsigned long flags;
-
-		/* packet command */
-		spin_lock_irqsave(&ide_lock, flags);
-		hwif->OUTBSYNC(drive, WIN_PACKETCMD,
-			       hwif->io_ports.command_addr);
-		ndelay(400);
-		spin_unlock_irqrestore(&ide_lock, flags);
+		ide_execute_pkt_cmd(drive);
 
 		return (*handler) (drive);
 	}
Index: b/drivers/ide/ide-floppy.c
===================================================================
--- a/drivers/ide/ide-floppy.c
+++ b/drivers/ide/ide-floppy.c
@@ -696,9 +696,7 @@ static ide_startstop_t idefloppy_issue_p
 		return ide_started;
 	} else {
 		/* Issue the packet command */
-		hwif->OUTBSYNC(drive, WIN_PACKETCMD,
-			       hwif->io_ports.command_addr);
-		ndelay(400);
+		ide_execute_pkt_cmd(drive);
 		return (*pkt_xfer_routine) (drive);
 	}
 }
Index: b/drivers/ide/ide-iops.c
===================================================================
--- a/drivers/ide/ide-iops.c
+++ b/drivers/ide/ide-iops.c
@@ -801,9 +801,19 @@ void ide_execute_command(ide_drive_t *dr
 	ndelay(400);
 	spin_unlock_irqrestore(&ide_lock, flags);
 }
-
 EXPORT_SYMBOL(ide_execute_command);
 
+void ide_execute_pkt_cmd(ide_drive_t *drive)
+{
+	ide_hwif_t *hwif = drive->hwif;
+	unsigned long flags;
+
+	spin_lock_irqsave(&ide_lock, flags);
+	hwif->OUTBSYNC(drive, WIN_PACKETCMD, hwif->io_ports.command_addr);
+	ndelay(400);
+	spin_unlock_irqrestore(&ide_lock, flags);
+}
+EXPORT_SYMBOL_GPL(ide_execute_pkt_cmd);
 
 /* needed below */
 static ide_startstop_t do_reset1 (ide_drive_t *, int);
Index: b/drivers/ide/ide-tape.c
===================================================================
--- a/drivers/ide/ide-tape.c
+++ b/drivers/ide/ide-tape.c
@@ -1056,9 +1056,7 @@ static ide_startstop_t idetape_issue_pc(
 				    IDETAPE_WAIT_CMD, NULL);
 		return ide_started;
 	} else {
-		hwif->OUTBSYNC(drive, WIN_PACKETCMD,
-			       hwif->io_ports.command_addr);
-		ndelay(400);
+		ide_execute_pkt_cmd(drive);
 		return idetape_transfer_pc(drive);
 	}
 }
Index: b/drivers/scsi/ide-scsi.c
===================================================================
--- a/drivers/scsi/ide-scsi.c
+++ b/drivers/scsi/ide-scsi.c
@@ -574,9 +574,7 @@ static ide_startstop_t idescsi_issue_pc(
 		return ide_started;
 	} else {
 		/* Issue the packet command */
-		hwif->OUTBSYNC(drive, WIN_PACKETCMD,
-			       hwif->io_ports.command_addr);
-		ndelay(400);
+		ide_execute_pkt_cmd(drive);
 		return idescsi_transfer_pc(drive);
 	}
 }
Index: b/include/linux/ide.h
===================================================================
--- a/include/linux/ide.h
+++ b/include/linux/ide.h
@@ -811,6 +811,8 @@ extern void ide_set_handler (ide_drive_t
 void ide_execute_command(ide_drive_t *, u8, ide_handler_t *, unsigned int,
 			 ide_expiry_t *);
 
+void ide_execute_pkt_cmd(ide_drive_t *);
+
 ide_startstop_t __ide_error(ide_drive_t *, struct request *, u8, u8);
 
 ide_startstop_t ide_error (ide_drive_t *drive, const char *msg, byte stat);
