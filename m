Return-Path: <linux-kernel-owner+w=401wt.eu-S1754159AbYKRUWu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754159AbYKRUWu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2008 15:22:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752734AbYKRUWZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Nov 2008 15:22:25 -0500
Received: from gv-out-0910.google.com ([216.239.58.186]:14607 "EHLO
	gv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752472AbYKRUWX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2008 15:22:23 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:mime-version:content-type
         :content-transfer-encoding:content-disposition:message-id;
        b=lWIdq3+HbW8Fp6d9AhWxhga9FlT7JvXMDK0HSp73yi1TKKljdB6lvKztR+KjFtd6I5
         9nKLmnGzNQHPl+qjS2C3SiXEyg6XacKEJzma8ADRokTrOT8XH8geHzzAh0q8q888ANXu
         RSF1B6xaJDttW5RLqGxVhAmV+wIH5rNIbRRgY=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Subject: [PATCH 2/3] ide: add ide_[un]lock_hwgroup() helpers
Date: Tue, 18 Nov 2008 21:16:00 +0100
User-Agent: KMail/1.9.10
Cc: linux-kernel@vger.kernel.org,
       Michael Schmitz <schmitz@biophys.uni-duesseldorf.de>,
       Geert Uytterhoeven <geert@linux-m68k.org>,
       Elias Oltmanns <eo@nebensachen.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200811182116.00351.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add ide_[un]lock_hwgroup() inline helpers for obtaining exclusive
access to the given hwgroup and update the core code accordingly.

[ This change besides making code saner results in more efficient
  use of ide_{get,release}_lock(). ]

Cc: Michael Schmitz <schmitz@biophys.uni-duesseldorf.de>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Elias Oltmanns <eo@nebensachen.de>
Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/ide-io.c   |   32 +++++++++++---------------------
 drivers/ide/ide-park.c |    2 +-
 include/linux/ide.h    |   20 ++++++++++++++++++++
 3 files changed, 32 insertions(+), 22 deletions(-)

Index: b/drivers/ide/ide-io.c
===================================================================
--- a/drivers/ide/ide-io.c
+++ b/drivers/ide/ide-io.c
@@ -790,10 +790,7 @@ void do_ide_request(struct request_queue
 	/* caller must own hwgroup->lock */
 	BUG_ON(!irqs_disabled());
 
-	while (!hwgroup->busy) {
-		hwgroup->busy = 1;
-		/* for atari only */
-		ide_get_lock(ide_intr, hwgroup);
+	while (!ide_lock_hwgroup(hwgroup)) {
 		drive = choose_drive(hwgroup);
 		if (drive == NULL) {
 			int sleeping = 0;
@@ -825,17 +822,10 @@ void do_ide_request(struct request_queue
 				hwgroup->sleeping = 1;
 				hwgroup->req_gen_timer = hwgroup->req_gen;
 				mod_timer(&hwgroup->timer, sleep);
-				/* we purposely leave hwgroup->busy==1
+				/* we purposely leave hwgroup locked
 				 * while sleeping */
-			} else {
-				/* Ugly, but how can we sleep for the lock
-				 * otherwise? perhaps from tq_disk?
-				 */
-
-				/* for atari only */
-				ide_release_lock();
-				hwgroup->busy = 0;
-			}
+			} else
+				ide_unlock_hwgroup(hwgroup);
 
 			/* no more work for this hwgroup (for now) */
 			goto plug_device;
@@ -865,7 +855,7 @@ void do_ide_request(struct request_queue
 		 */
 		rq = elv_next_request(drive->queue);
 		if (!rq) {
-			hwgroup->busy = 0;
+			ide_unlock_hwgroup(hwgroup);
 			break;
 		}
 
@@ -885,8 +875,8 @@ void do_ide_request(struct request_queue
 		if ((drive->dev_flags & IDE_DFLAG_BLOCKED) &&
 		    blk_pm_request(rq) == 0 &&
 		    (rq->cmd_flags & REQ_PREEMPT) == 0) {
-			/* We clear busy, there should be no pending ATA command at this point. */
-			hwgroup->busy = 0;
+			/* there should be no pending command at this point */
+			ide_unlock_hwgroup(hwgroup);
 			goto plug_device;
 		}
 
@@ -897,7 +887,7 @@ void do_ide_request(struct request_queue
 		spin_lock_irq(&hwgroup->lock);
 
 		if (startstop == ide_stopped) {
-			hwgroup->busy = 0;
+			ide_unlock_hwgroup(hwgroup);
 			if (!elv_queue_empty(orig_drive->queue))
 				blk_plug_device(orig_drive->queue);
 		}
@@ -1001,7 +991,7 @@ void ide_timer_expiry (unsigned long dat
 		 */
 		if (hwgroup->sleeping) {
 			hwgroup->sleeping = 0;
-			hwgroup->busy = 0;
+			ide_unlock_hwgroup(hwgroup);
 		}
 	} else {
 		ide_drive_t *drive = hwgroup->drive;
@@ -1056,7 +1046,7 @@ void ide_timer_expiry (unsigned long dat
 			spin_lock_irq(&hwgroup->lock);
 			enable_irq(hwif->irq);
 			if (startstop == ide_stopped) {
-				hwgroup->busy = 0;
+				ide_unlock_hwgroup(hwgroup);
 				if (!elv_queue_empty(drive->queue))
 					blk_plug_device(drive->queue);
 			}
@@ -1249,7 +1239,7 @@ irqreturn_t ide_intr (int irq, void *dev
 	drive->service_time = jiffies - drive->service_start;
 	if (startstop == ide_stopped) {
 		if (hwgroup->handler == NULL) {	/* paranoia */
-			hwgroup->busy = 0;
+			ide_unlock_hwgroup(hwgroup);
 			if (!elv_queue_empty(drive->queue))
 				blk_plug_device(drive->queue);
 		} else
Index: b/drivers/ide/ide-park.c
===================================================================
--- a/drivers/ide/ide-park.c
+++ b/drivers/ide/ide-park.c
@@ -22,7 +22,7 @@ static void issue_park_cmd(ide_drive_t *
 		if (reset_timer && hwgroup->sleeping &&
 		    del_timer(&hwgroup->timer)) {
 			hwgroup->sleeping = 0;
-			hwgroup->busy = 0;
+			ide_unlock_hwgroup(hwgroup);
 			blk_start_queueing(q);
 		}
 		spin_unlock_irq(&hwgroup->lock);
Index: b/include/linux/ide.h
===================================================================
--- a/include/linux/ide.h
+++ b/include/linux/ide.h
@@ -1280,6 +1280,26 @@ extern void ide_stall_queue(ide_drive_t 
 
 extern void ide_timer_expiry(unsigned long);
 extern irqreturn_t ide_intr(int irq, void *dev_id);
+
+static inline int ide_lock_hwgroup(ide_hwgroup_t *hwgroup)
+{
+	if (hwgroup->busy)
+		return 1;
+
+	hwgroup->busy = 1;
+	/* for atari only */
+	ide_get_lock(ide_intr, hwgroup);
+
+	return 0;
+}
+
+static inline void ide_unlock_hwgroup(ide_hwgroup_t *hwgroup)
+{
+	/* for atari only */
+	ide_release_lock();
+	hwgroup->busy = 0;
+}
+
 extern void do_ide_request(struct request_queue *);
 
 void ide_init_disk(struct gendisk *, ide_drive_t *);
