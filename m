Return-Path: <linux-kernel-owner+w=401wt.eu-S1756226AbYFYL1s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756226AbYFYL1s (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2008 07:27:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752036AbYFYL1j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jun 2008 07:27:39 -0400
Received: from nebensachen.de ([195.34.83.29]:45144 "EHLO mail.nebensachen.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752774AbYFYL1i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2008 07:27:38 -0400
X-Hashcash: 1:20:080625:bzolnier@gmail.com::gWg6QCjOi43QXes8:00000000000000000000000000000000000000000001yQT
X-Hashcash: 1:20:080625:alan@lxorguk.ukuu.org.uk::Eo1kIBdVDGXo4sW+:00000000000000000000000000000000000003zkg
X-Hashcash: 1:20:080625:linux-ide@vger.kernel.org::Df0VM2Nso01jYO/I:00000000000000000000000000000000000083yt
X-Hashcash: 1:20:080625:linux-kernel@vger.kernel.org::1yec9CB/WCCkqfdO:0000000000000000000000000000000009Kdc
X-Hashcash: 1:20:080625:randy.dunlap@oracle.com::gbtOu+o1jxr7gOsH:000000000000000000000000000000000000004MiH
From: Elias Oltmanns <eo@nebensachen.de>
To: "Bartlomiej Zolnierkiewicz" <bzolnier@gmail.com>
Cc: "Alan Cox" <alan@lxorguk.ukuu.org.uk>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org, "Randy Dunlap" <randy.dunlap@oracle.com>
Subject: [PATCH 1/4 v2] IDE: Fix HDIO_DRIVE_RESET handling
References: <87k5gmz596.fsf@denkblock.local>
	<200806240041.42796.bzolnier@gmail.com>
	<87skv3s3d9.fsf@denkblock.local>
	<200806241306.42054.bzolnier@gmail.com>
	<20080624133218.6bccab75@lxorguk.ukuu.org.uk>
	<58cb370e0806240621g61370f56j660e31790dad89c3@mail.gmail.com>
	<20080624143548.24dcf511@lxorguk.ukuu.org.uk>
	<58cb370e0806240719o4a70537p4a6fb64e9086e2d8@mail.gmail.com>
	<87k5gdn4fq.fsf@denkblock.local>
Date: Wed, 25 Jun 2008 13:27:32 +0200
In-Reply-To: <87k5gdn4fq.fsf@denkblock.local> (Elias Oltmanns's message of
	"Wed, 25 Jun 2008 13:23:53 +0200")
Message-ID: <87ej6ln49n.fsf_-_@denkblock.local>
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
 drivers/ide/ide-iops.c |   18 +++++++++++++-----
 drivers/ide/ide.c      |   41 +++++++++++++++--------------------------
 include/linux/ide.h    |    6 ++++++
 4 files changed, 56 insertions(+), 32 deletions(-)

diff --git a/drivers/ide/ide-io.c b/drivers/ide/ide-io.c
index 2805774..2b33c12 100644
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
+			 * check for ->rq_disk above may be replaced
+			 * by a more suitable mechanism or even
+			 * dropped entirely.
+			 */
+			return ide_special_rq(drive, rq);
 
 		drv = *(ide_driver_t **)rq->rq_disk->private_data;
 		return drv->do_request(drive, rq, block);
diff --git a/drivers/ide/ide-iops.c b/drivers/ide/ide-iops.c
index 66e39e5..80e782b 100644
--- a/drivers/ide/ide-iops.c
+++ b/drivers/ide/ide-iops.c
@@ -905,6 +905,14 @@ void ide_execute_pkt_cmd(ide_drive_t *drive)
 }
 EXPORT_SYMBOL_GPL(ide_execute_pkt_cmd);
 
+static inline void ide_complete_drive_reset(ide_drive_t *drive)
+{
+	struct request *rq = drive->hwif->hwgroup->rq;
+
+	if (rq && blk_special_request(rq) && rq->cmd[0] == REQ_DRIVE_RESET)
+		ide_end_request(drive, 1, 0);
+}
+
 /* needed below */
 static ide_startstop_t do_reset1 (ide_drive_t *, int);
 
@@ -940,7 +948,7 @@ static ide_startstop_t atapi_reset_pollfunc (ide_drive_t *drive)
 	}
 	/* done polling */
 	hwgroup->polling = 0;
-	hwgroup->resetting = 0;
+	ide_complete_drive_reset(drive);
 	return ide_stopped;
 }
 
@@ -961,7 +969,7 @@ static ide_startstop_t reset_pollfunc (ide_drive_t *drive)
 		if (port_ops->reset_poll(drive)) {
 			printk(KERN_ERR "%s: host reset_poll failure for %s.\n",
 				hwif->name, drive->name);
-			return ide_stopped;
+			goto out;
 		}
 	}
 
@@ -1004,7 +1012,8 @@ static ide_startstop_t reset_pollfunc (ide_drive_t *drive)
 		}
 	}
 	hwgroup->polling = 0;	/* done polling */
-	hwgroup->resetting = 0; /* done reset attempt */
+out:
+	ide_complete_drive_reset(drive);
 	return ide_stopped;
 }
 
@@ -1090,7 +1099,6 @@ static ide_startstop_t do_reset1 (ide_drive_t *drive, int do_not_try_atapi)
 
 	/* For an ATAPI device, first try an ATAPI SRST. */
 	if (drive->media != ide_disk && !do_not_try_atapi) {
-		hwgroup->resetting = 1;
 		pre_reset(drive);
 		SELECT_DRIVE(drive);
 		udelay (20);
@@ -1112,10 +1120,10 @@ static ide_startstop_t do_reset1 (ide_drive_t *drive, int do_not_try_atapi)
 
 	if (io_ports->ctl_addr == 0) {
 		spin_unlock_irqrestore(&ide_lock, flags);
+		ide_complete_drive_reset(drive);
 		return ide_stopped;
 	}
 
-	hwgroup->resetting = 1;
 	/*
 	 * Note that we also set nIEN while resetting the device,
 	 * to mask unwanted interrupts from the interface during the reset.
diff --git a/drivers/ide/ide.c b/drivers/ide/ide.c
index b0739c9..dbedb02 100644
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
@@ -603,33 +616,9 @@ int generic_ide_ioctl(ide_drive_t *drive, struct file *file, struct block_device
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
-			spin_lock_irqsave(&ide_lock, flags);
-
-			if (HWGROUP(drive)->resetting) {
-				spin_unlock_irqrestore(&ide_lock, flags);
-				return -EBUSY;
-			}
-
-			ide_abort(drive, "drive reset");
-
-			BUG_ON(HWGROUP(drive)->handler);
-
-			/* Ensure nothing gets queued after we
-			   drop the lock. Reset will clear the busy */
-
-			HWGROUP(drive)->busy = 1;
-			spin_unlock_irqrestore(&ide_lock, flags);
-			(void) ide_do_reset(drive);
-
+			generic_drive_reset(drive);
 			return 0;
+
 		case HDIO_GET_BUSSTATE:
 			if (!capable(CAP_SYS_ADMIN))
 				return -EACCES;
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
