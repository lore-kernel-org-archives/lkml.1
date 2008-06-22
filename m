Return-Path: <linux-kernel-owner+w=401wt.eu-S1757982AbYFVXjF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757982AbYFVXjF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jun 2008 19:39:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756158AbYFVXix
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Jun 2008 19:38:53 -0400
Received: from nebensachen.de ([195.34.83.29]:57954 "EHLO mail.nebensachen.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754989AbYFVXiw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jun 2008 19:38:52 -0400
X-Hashcash: 1:20:080622:bzolnier@gmail.com::TzDb5F2mrkctoPi8:00000000000000000000000000000000000000000006rKk
X-Hashcash: 1:20:080622:linux-ide@vger.kernel.org::03A4V/1Kv6rYDZ++:0000000000000000000000000000000000002qK9
X-Hashcash: 1:20:080622:linux-kernel@vger.kernel.org::pQYTWAAk8ABxIP9/:0000000000000000000000000000000003jaV
X-Hashcash: 1:20:080622:randy.dunlap@oracle.com::aZaFG0HEnk6N0ZCi:000000000000000000000000000000000000000FMX
From: Elias Oltmanns <eo@nebensachen.de>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
       Randy Dunlap <randy.dunlap@oracle.com>
Subject: [PATCH 4/4] IDE: Report errors during drive reset back to user space
References: <87k5gmz596.fsf@denkblock.local>
	<200806192247.25063.bzolnier@gmail.com>
	<87wskhuk98.fsf@denkblock.local>
Date: Mon, 23 Jun 2008 01:38:45 +0200
Message-ID: <873an5ujju.fsf@denkblock.local>
User-Agent: Gnus/5.110007 (No Gnus v0.7)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make sure that each error condition during the execution of an
HDIO_DRIVE_RESET ioctl is actually reported to the calling process.

Signed-off-by: Elias Oltmanns <eo@nebensachen.de>
---

 Documentation/ioctl/hdio.txt |    2 ++
 drivers/ide/ide-iops.c       |   18 +++++++++++-------
 drivers/ide/ide.c            |   10 ++++++----
 drivers/ide/pci/siimage.c    |    3 +--
 4 files changed, 20 insertions(+), 13 deletions(-)

diff --git a/Documentation/ioctl/hdio.txt b/Documentation/ioctl/hdio.txt
index a859734..28f5fdc 100644
--- a/Documentation/ioctl/hdio.txt
+++ b/Documentation/ioctl/hdio.txt
@@ -509,6 +509,8 @@ HDIO_DRIVE_RESET		execute a device reset
 	error returns:
 	  EACCES	Access denied:  requires CAP_SYS_ADMIN
 	  EBUSY		Device busy:	reset operation in progress already
+	  ENXIO		No such device:	phy dead or ctl_addr == 0
+	  EIO		I/O error:	reset timed out or hardware error
 
 	notes:
 
diff --git a/drivers/ide/ide-iops.c b/drivers/ide/ide-iops.c
index d68fc2a..286fc15 100644
--- a/drivers/ide/ide-iops.c
+++ b/drivers/ide/ide-iops.c
@@ -905,12 +905,12 @@ void ide_execute_pkt_cmd(ide_drive_t *drive)
 }
 EXPORT_SYMBOL_GPL(ide_execute_pkt_cmd);
 
-static inline void ide_complete_drive_reset(ide_drive_t *drive)
+static inline void ide_complete_drive_reset(ide_drive_t *drive, int err)
 {
 	struct request *rq = HWGROUP(drive)->rq;
 
 	if (rq && blk_special_request(rq) && rq->cmd[0] == REQ_DRIVE_RESET)
-		ide_end_request(drive, 1, 0);
+		ide_end_request(drive, err ? err : 1, 0);
 }
 
 /* needed below */
@@ -949,7 +949,7 @@ static ide_startstop_t atapi_reset_pollfunc (ide_drive_t *drive)
 	/* done polling */
 	hwgroup->polling = 0;
 	hwgroup->resetting = 0;
-	ide_complete_drive_reset(drive);
+	ide_complete_drive_reset(drive, 0);
 	return ide_stopped;
 }
 
@@ -965,9 +965,11 @@ static ide_startstop_t reset_pollfunc (ide_drive_t *drive)
 	ide_hwif_t *hwif	= HWIF(drive);
 	const struct ide_port_ops *port_ops = hwif->port_ops;
 	u8 tmp;
+	int err = 0;
 
 	if (port_ops && port_ops->reset_poll) {
-		if (port_ops->reset_poll(drive)) {
+		err = port_ops->reset_poll(drive);
+		if (err) {
 			printk(KERN_ERR "%s: host reset_poll failure for %s.\n",
 				hwif->name, drive->name);
 			goto out;
@@ -984,6 +986,7 @@ static ide_startstop_t reset_pollfunc (ide_drive_t *drive)
 		}
 		printk("%s: reset timed-out, status=0x%02x\n", hwif->name, tmp);
 		drive->failures++;
+		err = -EIO;
 	} else  {
 		printk("%s: reset: ", hwif->name);
 		tmp = ide_read_error(drive);
@@ -1010,12 +1013,13 @@ static ide_startstop_t reset_pollfunc (ide_drive_t *drive)
 			if (tmp & 0x80)
 				printk("; slave: failed");
 			printk("\n");
+			err = -EIO;
 		}
 	}
+out:
 	hwgroup->polling = 0;	/* done polling */
 	hwgroup->resetting = 0; /* done reset attempt */
-out:
-	ide_complete_drive_reset(drive);
+	ide_complete_drive_reset(drive, err);
 	return ide_stopped;
 }
 
@@ -1123,7 +1127,7 @@ static ide_startstop_t do_reset1 (ide_drive_t *drive, int do_not_try_atapi)
 
 	if (io_ports->ctl_addr == 0) {
 		spin_unlock_irqrestore(&ide_lock, flags);
-		ide_complete_drive_reset(drive);
+		ide_complete_drive_reset(drive, -ENXIO);
 		return ide_stopped;
 	}
 
diff --git a/drivers/ide/ide.c b/drivers/ide/ide.c
index bf17529..af46549 100644
--- a/drivers/ide/ide.c
+++ b/drivers/ide/ide.c
@@ -529,17 +529,20 @@ static int generic_ide_resume(struct device *dev)
 	return err;
 }
 
-static void generic_drive_reset(ide_drive_t *drive)
+static int generic_drive_reset(ide_drive_t *drive)
 {
 	struct request *rq;
+	int ret = 0;
 
 	rq = blk_get_request(drive->queue, READ, __GFP_WAIT);
 	rq->cmd_type = REQ_TYPE_SPECIAL;
 	rq->cmd_len = 1;
 	rq->cmd[0] = REQ_DRIVE_RESET;
 	rq->cmd_flags |= REQ_SOFTBARRIER;
-	blk_execute_rq(drive->queue, NULL, rq, 1);
+	if (blk_execute_rq(drive->queue, NULL, rq, 1))
+		ret = rq->errors;
 	blk_put_request(rq);
+	return ret;
 }
 
 int generic_ide_ioctl(ide_drive_t *drive, struct file *file, struct block_device *bdev,
@@ -622,9 +625,8 @@ int generic_ide_ioctl(ide_drive_t *drive, struct file *file, struct block_device
 				return -EBUSY;
 			}
 			spin_unlock_irqrestore(&ide_lock, flags);
-			generic_drive_reset(drive);
 
-			return 0;
+			return generic_drive_reset(drive);
 		case HDIO_GET_BUSSTATE:
 			if (!capable(CAP_SYS_ADMIN))
 				return -EACCES;
diff --git a/drivers/ide/pci/siimage.c b/drivers/ide/pci/siimage.c
index b75e9bb..6e9d765 100644
--- a/drivers/ide/pci/siimage.c
+++ b/drivers/ide/pci/siimage.c
@@ -421,8 +421,7 @@ static int sil_sata_reset_poll(ide_drive_t *drive)
 		if ((sata_stat & 0x03) != 0x03) {
 			printk(KERN_WARNING "%s: reset phy dead, status=0x%08x\n",
 					    hwif->name, sata_stat);
-			HWGROUP(drive)->polling = 0;
-			return ide_started;
+			return -ENXIO;
 		}
 	}
 
