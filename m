Return-Path: <linux-kernel-owner+w=401wt.eu-S1030583AbXDJUgS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030583AbXDJUgS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2007 16:36:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030555AbXDJUgR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Apr 2007 16:36:17 -0400
Received: from ug-out-1314.google.com ([66.249.92.168]:1788 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753844AbXDJUgQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2007 16:36:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=qM0QUJVOpifslnoLdHbLbSV+hZE/Jz4pWugqBXHu+FXnbuGxzq2pFVpnSVJ3MvDNbkMEqiQUcHksRC1FSud12TZhSne4U/ymLfO9NYR9ZITwDXSHsyQmldiog4JcNtcJJ4pjdnqEh+cHXYdHFYWlUOLpNXUz5H4GJsSyFWpID2k=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [git patches] IDE fixes
Date: Tue, 10 Apr 2007 22:45:37 +0200
User-Agent: KMail/1.9.6
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200704102245.37696.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Please pull from:

master.kernel.org:/pub/scm/linux/kernel/git/bart/ide-2.6.git/

to receive the following updates:

 drivers/ide/ide-cd.c   |    9 +++++++++
 drivers/ide/ide-io.c   |    6 +++++-
 drivers/ide/ide-iops.c |    2 ++
 drivers/ide/ide.c      |    2 ++
 include/linux/ide.h    |    2 ++
 5 files changed, 20 insertions(+), 1 deletions(-)


Danny Kukawka (1):
      ide: add "optical" to sysfs "media" attribute

Stuart Hayes (1):
      ide: ugly messages trying to open CD drive with no media present

Suleiman Souhlal (1):
      ide: correctly prevent IDE timer expiry function to run if request was already handled


diff --git a/drivers/ide/ide-cd.c b/drivers/ide/ide-cd.c
index 45a928c..638becd 100644
--- a/drivers/ide/ide-cd.c
+++ b/drivers/ide/ide-cd.c
@@ -735,6 +735,15 @@ static int cdrom_decode_status(ide_drive_t *drive, int good_stat, int *stat_ret)
 			cdrom_saw_media_change (drive);
 			/*printk("%s: media changed\n",drive->name);*/
 			return 0;
+ 		} else if ((sense_key == ILLEGAL_REQUEST) &&
+ 			   (rq->cmd[0] == GPCMD_START_STOP_UNIT)) {
+ 			/*
+ 			 * Don't print error message for this condition--
+ 			 * SFF8090i indicates that 5/24/00 is the correct
+ 			 * response to a request to close the tray if the
+ 			 * drive doesn't have that capability.
+ 			 * cdrom_log_sense() knows this!
+ 			 */
 		} else if (!(rq->cmd_flags & REQ_QUIET)) {
 			/* Otherwise, print an error. */
 			ide_dump_status(drive, "packet command error", stat);
diff --git a/drivers/ide/ide-io.c b/drivers/ide/ide-io.c
index 0e02800..8670112 100644
--- a/drivers/ide/ide-io.c
+++ b/drivers/ide/ide-io.c
@@ -1226,6 +1226,7 @@ static void ide_do_request (ide_hwgroup_t *hwgroup, int masked_irq)
 #endif
 				/* so that ide_timer_expiry knows what to do */
 				hwgroup->sleeping = 1;
+				hwgroup->req_gen_timer = hwgroup->req_gen;
 				mod_timer(&hwgroup->timer, sleep);
 				/* we purposely leave hwgroup->busy==1
 				 * while sleeping */
@@ -1411,7 +1412,8 @@ void ide_timer_expiry (unsigned long data)
 
 	spin_lock_irqsave(&ide_lock, flags);
 
-	if ((handler = hwgroup->handler) == NULL) {
+	if (((handler = hwgroup->handler) == NULL) ||
+	    (hwgroup->req_gen != hwgroup->req_gen_timer)) {
 		/*
 		 * Either a marginal timeout occurred
 		 * (got the interrupt just as timer expired),
@@ -1439,6 +1441,7 @@ void ide_timer_expiry (unsigned long data)
 				if ((wait = expiry(drive)) > 0) {
 					/* reset timer */
 					hwgroup->timer.expires  = jiffies + wait;
+					hwgroup->req_gen_timer = hwgroup->req_gen;
 					add_timer(&hwgroup->timer);
 					spin_unlock_irqrestore(&ide_lock, flags);
 					return;
@@ -1653,6 +1656,7 @@ irqreturn_t ide_intr (int irq, void *dev_id)
 		printk(KERN_ERR "%s: ide_intr: hwgroup->busy was 0 ??\n", drive->name);
 	}
 	hwgroup->handler = NULL;
+	hwgroup->req_gen++;
 	del_timer(&hwgroup->timer);
 	spin_unlock(&ide_lock);
 
diff --git a/drivers/ide/ide-iops.c b/drivers/ide/ide-iops.c
index 1ee53a5..3caa176 100644
--- a/drivers/ide/ide-iops.c
+++ b/drivers/ide/ide-iops.c
@@ -889,6 +889,7 @@ static void __ide_set_handler (ide_drive_t *drive, ide_handler_t *handler,
 	hwgroup->handler	= handler;
 	hwgroup->expiry		= expiry;
 	hwgroup->timer.expires	= jiffies + timeout;
+	hwgroup->req_gen_timer = hwgroup->req_gen;
 	add_timer(&hwgroup->timer);
 }
 
@@ -929,6 +930,7 @@ void ide_execute_command(ide_drive_t *drive, task_ioreg_t cmd, ide_handler_t *ha
 	hwgroup->handler	= handler;
 	hwgroup->expiry		= expiry;
 	hwgroup->timer.expires	= jiffies + timeout;
+	hwgroup->req_gen_timer = hwgroup->req_gen;
 	add_timer(&hwgroup->timer);
 	hwif->OUTBSYNC(drive, cmd, IDE_COMMAND_REG);
 	/* Drive takes 400nS to respond, we must avoid the IRQ being
diff --git a/drivers/ide/ide.c b/drivers/ide/ide.c
index a6f098f..ae5bf2b 100644
--- a/drivers/ide/ide.c
+++ b/drivers/ide/ide.c
@@ -1962,6 +1962,8 @@ static char *media_string(ide_drive_t *drive)
 		return "tape";
 	case ide_floppy:
 		return "floppy";
+	case ide_optical:
+		return "optical";
 	default:
 		return "UNKNOWN";
 	}
diff --git a/include/linux/ide.h b/include/linux/ide.h
index 58564a1..d3bbc71 100644
--- a/include/linux/ide.h
+++ b/include/linux/ide.h
@@ -861,6 +861,8 @@ typedef struct hwgroup_s {
 	int (*expiry)(ide_drive_t *);
 		/* ide_system_bus_speed */
 	int pio_clock;
+	int req_gen;
+	int req_gen_timer;
 
 	unsigned char cmd_buf[4];
 } ide_hwgroup_t;
