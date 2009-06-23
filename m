Return-Path: <linux-kernel-owner+w=401wt.eu-S1757575AbZFWVd5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757575AbZFWVd5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 17:33:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758526AbZFWVck
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 17:32:40 -0400
Received: from mail-bw0-f213.google.com ([209.85.218.213]:41020 "EHLO
	mail-bw0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758019AbZFWVcf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 17:32:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:mime-version:content-disposition
         :message-id:content-type:content-transfer-encoding;
        b=iCwH0C6O/ojckMs/nIymJ2qQT/SC3rNoS0KiCoQ0oR2JolowxOBoTVYUyjbg+FfHzM
         hb5y4ztccDSJTwBaTouYXyYkb3OvlPElcoZYV0izoijCskF5eo7UaKGohKJVdMibEpTM
         7AeJvqcx6dBcq2CPmfozJPLkrlFOV+7JXHekw=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: David Miller <davem@davemloft.net>
Subject: [patch 5/6] ide: fix races in handling of user-space SET XFER commands
Date: Tue, 23 Jun 2009 23:35:51 +0200
User-Agent: KMail/1.11.3 (Linux/2.6.30-next-20090623-11043-g1684859-dirty; KDE/4.2.3; i686; ; )
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200906232335.51621.bzolnier@gmail.com>
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] ide: fix races in handling of user-space SET XFER commands

* Make cmd->tf_flags field 'u16' and add IDE_TFLAG_SET_XFER taskfile flag.

* Update ide_finish_cmd() to set xfer / re-read id if the new flag is set.

* Convert set_xfer_rate() (write handler for /proc/ide/hd?/current_speed)
  and ide_cmd_ioctl() (HDIO_DRIVE_CMD ioctl handler) to use the new flag.

* Remove no longer needed disable_irq_nosync() + enable_irq() from
  ide_config_drive_speed().

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
These races are easily triggable (i.e. 'hdparm -Xmode' results in the "bad
status" error during ide_driveid_update() phase) and I was no longer able to
reproduce them with this patch applied.

 drivers/ide/ide-ioctls.c   |    8 ++------
 drivers/ide/ide-iops.c     |   10 ----------
 drivers/ide/ide-proc.c     |   10 ++--------
 drivers/ide/ide-taskfile.c |    9 ++++++++-
 include/linux/ide.h        |    3 ++-
 5 files changed, 14 insertions(+), 26 deletions(-)

Index: b/drivers/ide/ide-ioctls.c
===================================================================
--- a/drivers/ide/ide-ioctls.c
+++ b/drivers/ide/ide-ioctls.c
@@ -166,6 +166,8 @@ static int ide_cmd_ioctl(ide_drive_t *dr
 			err = -EINVAL;
 			goto abort;
 		}
+
+		cmd.tf_flags |= IDE_TFLAG_SET_XFER;
 	}
 
 	err = ide_raw_taskfile(drive, &cmd, buf, args[3]);
@@ -173,12 +175,6 @@ static int ide_cmd_ioctl(ide_drive_t *dr
 	args[0] = tf->status;
 	args[1] = tf->error;
 	args[2] = tf->nsect;
-
-	if (!err && xfer_rate) {
-		/* active-retuning-calls future */
-		ide_set_xfer_rate(drive, xfer_rate);
-		ide_driveid_update(drive);
-	}
 abort:
 	if (copy_to_user((void __user *)arg, &args, 4))
 		err = -EFAULT;
Index: b/drivers/ide/ide-iops.c
===================================================================
--- a/drivers/ide/ide-iops.c
+++ b/drivers/ide/ide-iops.c
@@ -363,14 +363,6 @@ int ide_config_drive_speed(ide_drive_t *
 	 * this point (lost interrupt).
 	 */
 
-	/*
-	 *	FIXME: we race against the running IRQ here if
-	 *	this is called from non IRQ context. If we use
-	 *	disable_irq() we hang on the error path. Work
-	 *	is needed.
-	 */
-	disable_irq_nosync(hwif->irq);
-
 	udelay(1);
 	tp_ops->dev_select(drive);
 	SELECT_MASK(drive, 1);
@@ -394,8 +386,6 @@ int ide_config_drive_speed(ide_drive_t *
 
 	SELECT_MASK(drive, 0);
 
-	enable_irq(hwif->irq);
-
 	if (error) {
 		(void) ide_dump_status(drive, "set_drive_speed_status", stat);
 		return error;
Index: b/drivers/ide/ide-proc.c
===================================================================
--- a/drivers/ide/ide-proc.c
+++ b/drivers/ide/ide-proc.c
@@ -195,7 +195,6 @@ ide_devset_get(xfer_rate, current_speed)
 static int set_xfer_rate (ide_drive_t *drive, int arg)
 {
 	struct ide_cmd cmd;
-	int err;
 
 	if (arg < XFER_PIO_0 || arg > XFER_UDMA_6)
 		return -EINVAL;
@@ -206,14 +205,9 @@ static int set_xfer_rate (ide_drive_t *d
 	cmd.tf.nsect   = (u8)arg;
 	cmd.valid.out.tf = IDE_VALID_FEATURE | IDE_VALID_NSECT;
 	cmd.valid.in.tf  = IDE_VALID_NSECT;
+	cmd.tf_flags   = IDE_TFLAG_SET_XFER;
 
-	err = ide_no_data_taskfile(drive, &cmd);
-
-	if (!err) {
-		ide_set_xfer_rate(drive, (u8) arg);
-		ide_driveid_update(drive);
-	}
-	return err;
+	return ide_no_data_taskfile(drive, &cmd);
 }
 
 ide_devset_rw(current_speed, xfer_rate);
Index: b/drivers/ide/ide-taskfile.c
===================================================================
--- a/drivers/ide/ide-taskfile.c
+++ b/drivers/ide/ide-taskfile.c
@@ -322,10 +322,17 @@ static void ide_error_cmd(ide_drive_t *d
 void ide_finish_cmd(ide_drive_t *drive, struct ide_cmd *cmd, u8 stat)
 {
 	struct request *rq = drive->hwif->rq;
-	u8 err = ide_read_error(drive);
+	u8 err = ide_read_error(drive), nsect = cmd->tf.nsect;
+	u8 set_xfer = !!(cmd->tf_flags & IDE_TFLAG_SET_XFER);
 
 	ide_complete_cmd(drive, cmd, stat, err);
 	rq->errors = err;
+
+	if (err == 0 && set_xfer) {
+		ide_set_xfer_rate(drive, nsect);
+		ide_driveid_update(drive);
+	}
+
 	ide_complete_rq(drive, err ? -EIO : 0, blk_rq_bytes(rq));
 }
 
Index: b/include/linux/ide.h
===================================================================
--- a/include/linux/ide.h
+++ b/include/linux/ide.h
@@ -258,6 +258,7 @@ enum {
 	IDE_TFLAG_DYN			= (1 << 5),
 	IDE_TFLAG_FS			= (1 << 6),
 	IDE_TFLAG_MULTI_PIO		= (1 << 7),
+	IDE_TFLAG_SET_XFER		= (1 << 8),
 };
 
 enum {
@@ -294,7 +295,7 @@ struct ide_cmd {
 		} out, in;
 	} valid;
 
-	u8			tf_flags;
+	u16			tf_flags;
 	u8			ftf_flags;	/* for TASKFILE ioctl */
 	int			protocol;
 
