Return-Path: <linux-kernel-owner+w=401wt.eu-S1757525AbYFYLbV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757525AbYFYLbV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2008 07:31:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755137AbYFYLbG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jun 2008 07:31:06 -0400
Received: from nebensachen.de ([195.34.83.29]:35130 "EHLO mail.nebensachen.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755521AbYFYLbE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2008 07:31:04 -0400
X-Hashcash: 1:20:080625:bzolnier@gmail.com::Ot/Zsv6iC4ooQAp9:00000000000000000000000000000000000000000002Nqk
X-Hashcash: 1:20:080625:alan@lxorguk.ukuu.org.uk::m6tHkvOs44AqwhJO:00000000000000000000000000000000000009fk7
X-Hashcash: 1:20:080625:linux-ide@vger.kernel.org::zU3kwyCZTOTU6cBA:0000000000000000000000000000000000004oWo
X-Hashcash: 1:20:080625:linux-kernel@vger.kernel.org::WAAhPyaecEt8U8YO:0000000000000000000000000000000000QBL
X-Hashcash: 1:20:080625:randy.dunlap@oracle.com::eiW56GlTHQ+Mrmxj:000000000000000000000000000000000000002k1R
From: Elias Oltmanns <eo@nebensachen.de>
To: "Bartlomiej Zolnierkiewicz" <bzolnier@gmail.com>
Cc: "Alan Cox" <alan@lxorguk.ukuu.org.uk>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org, "Randy Dunlap" <randy.dunlap@oracle.com>
Subject: [PATCH 4/4 v2] IDE: Report errors during drive reset back to user space
References: <87k5gmz596.fsf@denkblock.local>
	<200806240041.42796.bzolnier@gmail.com>
	<87skv3s3d9.fsf@denkblock.local>
	<200806241306.42054.bzolnier@gmail.com>
	<20080624133218.6bccab75@lxorguk.ukuu.org.uk>
	<58cb370e0806240621g61370f56j660e31790dad89c3@mail.gmail.com>
	<20080624143548.24dcf511@lxorguk.ukuu.org.uk>
	<58cb370e0806240719o4a70537p4a6fb64e9086e2d8@mail.gmail.com>
	<87k5gdn4fq.fsf@denkblock.local>
Date: Wed, 25 Jun 2008 13:30:53 +0200
In-Reply-To: <87k5gdn4fq.fsf@denkblock.local> (Elias Oltmanns's message of
	"Wed, 25 Jun 2008 13:23:53 +0200")
Message-ID: <871w2ln442.fsf_-_@denkblock.local>
User-Agent: Gnus/5.110007 (No Gnus v0.7)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make sure that each error condition during the execution of an
HDIO_DRIVE_RESET ioctl is actually reported to the calling process.
Also, unify the exit path of reset_pollfunc() when returning ide_stopped
since the need of ->port_ops->reset_poll() to be treated specially has
vanished (way back, it seems).

Signed-off-by: Elias Oltmanns <eo@nebensachen.de>
---

 Documentation/ioctl/hdio.txt |    2 ++
 drivers/ide/ide-iops.c       |   18 +++++++++++-------
 drivers/ide/ide.c            |   10 ++++++----
 drivers/ide/pci/siimage.c    |    3 +--
 4 files changed, 20 insertions(+), 13 deletions(-)

diff --git a/Documentation/ioctl/hdio.txt b/Documentation/ioctl/hdio.txt
index 44d283d..91a6ecb 100644
--- a/Documentation/ioctl/hdio.txt
+++ b/Documentation/ioctl/hdio.txt
@@ -508,6 +508,8 @@ HDIO_DRIVE_RESET		execute a device reset
 
 	error returns:
 	  EACCES	Access denied:  requires CAP_SYS_ADMIN
+	  ENXIO		No such device:	phy dead or ctl_addr == 0
+	  EIO		I/O error:	reset timed out or hardware error
 
 	notes:
 
diff --git a/drivers/ide/ide-iops.c b/drivers/ide/ide-iops.c
index 80e782b..6a8b955 100644
--- a/drivers/ide/ide-iops.c
+++ b/drivers/ide/ide-iops.c
@@ -905,12 +905,12 @@ void ide_execute_pkt_cmd(ide_drive_t *drive)
 }
 EXPORT_SYMBOL_GPL(ide_execute_pkt_cmd);
 
-static inline void ide_complete_drive_reset(ide_drive_t *drive)
+static inline void ide_complete_drive_reset(ide_drive_t *drive, int err)
 {
 	struct request *rq = drive->hwif->hwgroup->rq;
 
 	if (rq && blk_special_request(rq) && rq->cmd[0] == REQ_DRIVE_RESET)
-		ide_end_request(drive, 1, 0);
+		ide_end_request(drive, err ? err : 1, 0);
 }
 
 /* needed below */
@@ -948,7 +948,7 @@ static ide_startstop_t atapi_reset_pollfunc (ide_drive_t *drive)
 	}
 	/* done polling */
 	hwgroup->polling = 0;
-	ide_complete_drive_reset(drive);
+	ide_complete_drive_reset(drive, 0);
 	return ide_stopped;
 }
 
@@ -964,9 +964,11 @@ static ide_startstop_t reset_pollfunc (ide_drive_t *drive)
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
@@ -983,6 +985,7 @@ static ide_startstop_t reset_pollfunc (ide_drive_t *drive)
 		}
 		printk("%s: reset timed-out, status=0x%02x\n", hwif->name, tmp);
 		drive->failures++;
+		err = -EIO;
 	} else  {
 		printk("%s: reset: ", hwif->name);
 		tmp = ide_read_error(drive);
@@ -1009,11 +1012,12 @@ static ide_startstop_t reset_pollfunc (ide_drive_t *drive)
 			if (tmp & 0x80)
 				printk("; slave: failed");
 			printk("\n");
+			err = -EIO;
 		}
 	}
-	hwgroup->polling = 0;	/* done polling */
 out:
-	ide_complete_drive_reset(drive);
+	hwgroup->polling = 0;	/* done polling */
+	ide_complete_drive_reset(drive, err);
 	return ide_stopped;
 }
 
@@ -1120,7 +1124,7 @@ static ide_startstop_t do_reset1 (ide_drive_t *drive, int do_not_try_atapi)
 
 	if (io_ports->ctl_addr == 0) {
 		spin_unlock_irqrestore(&ide_lock, flags);
-		ide_complete_drive_reset(drive);
+		ide_complete_drive_reset(drive, -ENXIO);
 		return ide_stopped;
 	}
 
diff --git a/drivers/ide/ide.c b/drivers/ide/ide.c
index dbedb02..dfdc48a 100644
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
@@ -616,8 +619,7 @@ int generic_ide_ioctl(ide_drive_t *drive, struct file *file, struct block_device
 			if (!capable(CAP_SYS_ADMIN))
 				return -EACCES;
 
-			generic_drive_reset(drive);
-			return 0;
+			return generic_drive_reset(drive);
 
 		case HDIO_GET_BUSSTATE:
 			if (!capable(CAP_SYS_ADMIN))
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
 
