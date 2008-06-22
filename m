Return-Path: <linux-kernel-owner+w=401wt.eu-S1757372AbYFVX2j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757372AbYFVX2j (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jun 2008 19:28:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755785AbYFVX2b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Jun 2008 19:28:31 -0400
Received: from nebensachen.de ([195.34.83.29]:51929 "EHLO mail.nebensachen.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755131AbYFVX2a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jun 2008 19:28:30 -0400
X-Hashcash: 1:20:080622:bzolnier@gmail.com::Uysn1OozgLEG6CB1:00000000000000000000000000000000000000000000FDR
X-Hashcash: 1:20:080622:linux-ide@vger.kernel.org::J69V+Iwl7fuCCFJz:0000000000000000000000000000000000001Uop
X-Hashcash: 1:20:080622:linux-kernel@vger.kernel.org::+6JsQx0FBG0mKfYw:0000000000000000000000000000000001/87
X-Hashcash: 1:20:080622:randy.dunlap@oracle.com::7wN+P0KAzuNhzS1b:000000000000000000000000000000000000005DpM
From: Elias Oltmanns <eo@nebensachen.de>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
       Randy Dunlap <randy.dunlap@oracle.com>
Subject: [PATCH] IDE: Fix HDIO_DRIVE_RESET handling
References: <87k5gmz596.fsf@denkblock.local>
	<200806192247.25063.bzolnier@gmail.com>
	<87wskhuk98.fsf@denkblock.local>
Date: Mon, 23 Jun 2008 01:28:21 +0200
In-Reply-To: <87wskhuk98.fsf@denkblock.local> (Elias Oltmanns's message of
	"Mon, 23 Jun 2008 01:23:31 +0200")
Message-ID: <87r6apuk16.fsf@denkblock.local>
User-Agent: Gnus/5.110007 (No Gnus v0.7)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently, the code path executing an HDIO_DRIVE_RESET ioctl is broken
in various ways.  Most importantly, it is treated as an out of band
request in an illegal way which may very likely lead to system lock ups.
Use the drive's request queue to avoid this problem (and fix a locking
issue for free along the way).

Signed-off-by: Elias Oltmanns <eo@nebensachen.de>
---

 drivers/ide/ide-io.c   |   23 ++++++++++++++++++++++-
 drivers/ide/ide-iops.c |   14 +++++++++++++-
 drivers/ide/ide.c      |   33 ++++++++++++++-------------------
 include/linux/ide.h    |    6 ++++++
 4 files changed, 55 insertions(+), 21 deletions(-)

diff --git a/drivers/ide/ide-io.c b/drivers/ide/ide-io.c
index 2805774..d80f1b9 100644
--- a/drivers/ide/ide-io.c
+++ b/drivers/ide/ide-io.c
@@ -766,6 +766,18 @@ static ide_startstop_t execute_drive_cmd (ide_drive_t *drive,
  	return ide_stopped;
 }
 
+static ide_startstop_t ide_special_rq(ide_drive_t *drive, struct request *rq)
+{
+	switch (rq->cmd[0]) {
+	case REQ_DRIVE_RESET:
+		return ide_do_reset(drive);
+	default:
+		blk_dump_rq_flags(rq, "ide_special_rq - bad request");
+		ide_end_request(drive, 0, 0);
+		return ide_stopped;
+	}
+}
+
 static void ide_check_pm_state(ide_drive_t *drive, struct request *rq)
 {
 	struct request_pm_state *pm = rq->data;
@@ -869,7 +881,16 @@ static ide_startstop_t start_request (ide_drive_t *drive, struct request *rq)
 			    pm->pm_step == ide_pm_state_completed)
 				ide_complete_pm_request(drive, rq);
 			return startstop;
-		}
+		} else if (!rq->rq_disk && blk_special_request(rq))
+			/*
+			 * TODO: Once all ULDs have been modified to
+			 * check for specific op codes rather than
+			 * blindly accepting any special request, the
+			 * echeck for ->rq_disk above may be replaced
+			 * by a more suitable mechanism or even
+			 * dropped entirely.
+			 */
+			return ide_special_rq(drive, rq);
 
 		drv = *(ide_driver_t **)rq->rq_disk->private_data;
 		return drv->do_request(drive, rq, block);
diff --git a/drivers/ide/ide-iops.c b/drivers/ide/ide-iops.c
index 66e39e5..d68fc2a 100644
--- a/drivers/ide/ide-iops.c
+++ b/drivers/ide/ide-iops.c
@@ -905,6 +905,14 @@ void ide_execute_pkt_cmd(ide_drive_t *drive)
 }
 EXPORT_SYMBOL_GPL(ide_execute_pkt_cmd);
 
+static inline void ide_complete_drive_reset(ide_drive_t *drive)
+{
+	struct request *rq = HWGROUP(drive)->rq;
+
+	if (rq && blk_special_request(rq) && rq->cmd[0] == REQ_DRIVE_RESET)
+		ide_end_request(drive, 1, 0);
+}
+
 /* needed below */
 static ide_startstop_t do_reset1 (ide_drive_t *, int);
 
@@ -941,6 +949,7 @@ static ide_startstop_t atapi_reset_pollfunc (ide_drive_t *drive)
 	/* done polling */
 	hwgroup->polling = 0;
 	hwgroup->resetting = 0;
+	ide_complete_drive_reset(drive);
 	return ide_stopped;
 }
 
@@ -961,7 +970,7 @@ static ide_startstop_t reset_pollfunc (ide_drive_t *drive)
 		if (port_ops->reset_poll(drive)) {
 			printk(KERN_ERR "%s: host reset_poll failure for %s.\n",
 				hwif->name, drive->name);
-			return ide_stopped;
+			goto out;
 		}
 	}
 
@@ -1005,6 +1014,8 @@ static ide_startstop_t reset_pollfunc (ide_drive_t *drive)
 	}
 	hwgroup->polling = 0;	/* done polling */
 	hwgroup->resetting = 0; /* done reset attempt */
+out:
+	ide_complete_drive_reset(drive);
 	return ide_stopped;
 }
 
@@ -1112,6 +1123,7 @@ static ide_startstop_t do_reset1 (ide_drive_t *drive, int do_not_try_atapi)
 
 	if (io_ports->ctl_addr == 0) {
 		spin_unlock_irqrestore(&ide_lock, flags);
+		ide_complete_drive_reset(drive);
 		return ide_stopped;
 	}
 
diff --git a/drivers/ide/ide.c b/drivers/ide/ide.c
index b0739c9..bf17529 100644
--- a/drivers/ide/ide.c
+++ b/drivers/ide/ide.c
@@ -529,6 +529,19 @@ static int generic_ide_resume(struct device *dev)
 	return err;
 }
 
+static void generic_drive_reset(ide_drive_t *drive)
+{
+	struct request *rq;
+
+	rq = blk_get_request(drive->queue, READ, __GFP_WAIT);
+	rq->cmd_type = REQ_TYPE_SPECIAL;
+	rq->cmd_len = 1;
+	rq->cmd[0] = REQ_DRIVE_RESET;
+	rq->cmd_flags |= REQ_SOFTBARRIER;
+	blk_execute_rq(drive->queue, NULL, rq, 1);
+	blk_put_request(rq);
+}
+
 int generic_ide_ioctl(ide_drive_t *drive, struct file *file, struct block_device *bdev,
 			unsigned int cmd, unsigned long arg)
 {
@@ -603,31 +616,13 @@ int generic_ide_ioctl(ide_drive_t *drive, struct file *file, struct block_device
 			if (!capable(CAP_SYS_ADMIN))
 				return -EACCES;
 
-			/*
-			 *	Abort the current command on the
-			 *	group if there is one, taking
-			 *	care not to allow anything else
-			 *	to be queued and to die on the
-			 *	spot if we miss one somehow
-			 */
-
 			spin_lock_irqsave(&ide_lock, flags);
-
 			if (HWGROUP(drive)->resetting) {
 				spin_unlock_irqrestore(&ide_lock, flags);
 				return -EBUSY;
 			}
-
-			ide_abort(drive, "drive reset");
-
-			BUG_ON(HWGROUP(drive)->handler);
-
-			/* Ensure nothing gets queued after we
-			   drop the lock. Reset will clear the busy */
-
-			HWGROUP(drive)->busy = 1;
 			spin_unlock_irqrestore(&ide_lock, flags);
-			(void) ide_do_reset(drive);
+			generic_drive_reset(drive);
 
 			return 0;
 		case HDIO_GET_BUSSTATE:
diff --git a/include/linux/ide.h b/include/linux/ide.h
index 5ddae9b..8fbe838 100644
--- a/include/linux/ide.h
+++ b/include/linux/ide.h
@@ -139,6 +139,12 @@ struct ide_io_ports {
 #define WAIT_MIN_SLEEP	(2*HZ/100)	/* 20msec - minimum sleep time */
 
 /*
+ * Op codes for special requests to be handled by ide_special_rq().
+ * Values should be in the range of 0x20 to 0x3f.
+ */
+#define REQ_DRIVE_RESET		0x20
+
+/*
  * Check for an interrupt and acknowledge the interrupt status
  */
 struct hwif_s;
