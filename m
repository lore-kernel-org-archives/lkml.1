Return-Path: <linux-kernel-owner+w=401wt.eu-S1756247AbYKIQZs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756247AbYKIQZs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Nov 2008 11:25:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756055AbYKIQY1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Nov 2008 11:24:27 -0500
Received: from ey-out-2122.google.com ([74.125.78.27]:60863 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755905AbYKIQYZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Nov 2008 11:24:25 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=Ke12HNzlFU5WzMS3FPCQNAKE0b4PiGOiIxMAmza73WsFbWyIgUjzq6lsP512Aa+ODt
         ktVZ3VA0aCEEW+WVbY2OcQ43JMap+VDdSXpyb7cVAmUI9wOhe2Bx2fBXtkxKXyNVYj9m
         C/epZYyNG4Grr6rfaeVsbsUtVpB6arU+ylQG0=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Sun, 09 Nov 2008 17:22:26 +0100
Message-Id: <20081109162226.18999.89256.sendpatchset@localhost.localdomain>
In-Reply-To: <20081109162219.18999.74912.sendpatchset@localhost.localdomain>
References: <20081109162219.18999.74912.sendpatchset@localhost.localdomain>
Subject: [PATCH 02/11] ide: fix build for DEBUG_PM
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] ide: fix build for DEBUG_PM

Also while at it:

* Drop unused arguments from ide_complete_power_step().

* Move DEBUG_PM printk() from ide_end_drive_cmd() to
  ide_complete_power_step().

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/ide-io.c |   19 ++++++++++---------
 1 file changed, 10 insertions(+), 9 deletions(-)

Index: b/drivers/ide/ide-io.c
===================================================================
--- a/drivers/ide/ide-io.c
+++ b/drivers/ide/ide-io.c
@@ -120,10 +120,14 @@ int ide_end_request (ide_drive_t *drive,
 }
 EXPORT_SYMBOL(ide_end_request);
 
-static void ide_complete_power_step(ide_drive_t *drive, struct request *rq, u8 stat, u8 error)
+static void ide_complete_power_step(ide_drive_t *drive, struct request *rq)
 {
 	struct request_pm_state *pm = rq->data;
 
+#ifdef DEBUG_PM
+	printk(KERN_INFO "%s: complete_power_step(step: %d)\n",
+		drive->name, pm->pm_step);
+#endif
 	if (drive->media != ide_disk)
 		return;
 
@@ -160,7 +164,7 @@ static ide_startstop_t ide_start_power_s
 		/* Not supported? Switch to next step now. */
 		if (ata_id_flush_enabled(drive->id) == 0 ||
 		    (drive->dev_flags & IDE_DFLAG_WCACHE) == 0) {
-			ide_complete_power_step(drive, rq, 0, 0);
+			ide_complete_power_step(drive, rq);
 			return ide_stopped;
 		}
 		if (ata_id_flush_ext_enabled(drive->id))
@@ -179,7 +183,7 @@ static ide_startstop_t ide_start_power_s
 		if (drive->media != ide_disk)
 			pm->pm_step = IDE_PM_RESTORE_DMA;
 		else
-			ide_complete_power_step(drive, rq, 0, 0);
+			ide_complete_power_step(drive, rq);
 		return ide_stopped;
 	case IDE_PM_IDLE:		/* Resume step 2 (idle) */
 		args->tf.command = ATA_CMD_IDLEIMMEDIATE;
@@ -301,11 +305,8 @@ void ide_end_drive_cmd (ide_drive_t *dri
 		}
 	} else if (blk_pm_request(rq)) {
 		struct request_pm_state *pm = rq->data;
-#ifdef DEBUG_PM
-		printk("%s: complete_power_step(step: %d, stat: %x, err: %x)\n",
-			drive->name, rq->pm->pm_step, stat, err);
-#endif
-		ide_complete_power_step(drive, rq, stat, err);
+
+		ide_complete_power_step(drive, rq);
 		if (pm->pm_step == IDE_PM_COMPLETED)
 			ide_complete_pm_request(drive, rq);
 		return;
@@ -782,7 +783,7 @@ static ide_startstop_t start_request (id
 			struct request_pm_state *pm = rq->data;
 #ifdef DEBUG_PM
 			printk("%s: start_power_step(step: %d)\n",
-				drive->name, rq->pm->pm_step);
+				drive->name, pm->pm_step);
 #endif
 			startstop = ide_start_power_step(drive, rq);
 			if (startstop == ide_stopped &&
