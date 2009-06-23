Return-Path: <linux-kernel-owner+w=401wt.eu-S1758760AbZFWVdo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758760AbZFWVdo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 17:33:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758169AbZFWVci
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 17:32:38 -0400
Received: from mail-fx0-f213.google.com ([209.85.220.213]:48931 "EHLO
	mail-fx0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757936AbZFWVcc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 17:32:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:mime-version:content-type
         :content-transfer-encoding:content-disposition:message-id;
        b=SzBwTvKdeX3DGsKxbvLUSJPJOZOL5Qy8b8WqducGgGxSO9liRM6ku/bQnltyeg9BIR
         6ISwdfXk3G9tD5JAA/6qop0rzRwCAuQWXUe5EauqCaE+Ydt9DgHAy6EYVDqw8nAwrb4G
         Yo/VIzvz+9eKbsuJxzvT208kTefFpGwB6QC4M=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: David Miller <davem@davemloft.net>
Subject: [patch 4/6] ide: allow ide_dev_read_id() to be called from the IRQ context
Date: Tue, 23 Jun 2009 23:29:11 +0200
User-Agent: KMail/1.11.3 (Linux/2.6.30-next-20090623-11043-g1684859-dirty; KDE/4.2.3; i686; ; )
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200906232329.11648.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] ide: allow ide_dev_read_id() to be called from the IRQ context

* Un-static __ide_wait_stat().

* Allow ide_dev_read_id() helper to be called from the IRQ context by
  adding irq_ctx flag and using mdelay()/__ide_wait_stat() when needed.

* Switch ide_driveid_update() to set irq_ctx flag.

This change is needed for the consecutive patch which fixes races in
handling of user-space SET XFER commands but for improved bisectability
and clarity it is better to do it in a separate patch.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
I'm not completely happy with this version of patch since I originally
intended to unify ide_busy_sleep() with __ide_wait_stat() first..

 drivers/ide/ide-iops.c  |    6 +++---
 drivers/ide/ide-probe.c |   31 +++++++++++++++++++++----------
 include/linux/ide.h     |    3 ++-
 3 files changed, 26 insertions(+), 14 deletions(-)

Index: b/drivers/ide/ide-iops.c
===================================================================
--- a/drivers/ide/ide-iops.c
+++ b/drivers/ide/ide-iops.c
@@ -102,8 +102,8 @@ EXPORT_SYMBOL(ide_fixstring);
  * setting a timer to wake up at half second intervals thereafter,
  * until timeout is achieved, before timing out.
  */
-static int __ide_wait_stat(ide_drive_t *drive, u8 good, u8 bad,
-			   unsigned long timeout, u8 *rstat)
+int __ide_wait_stat(ide_drive_t *drive, u8 good, u8 bad,
+		    unsigned long timeout, u8 *rstat)
 {
 	ide_hwif_t *hwif = drive->hwif;
 	const struct ide_tp_ops *tp_ops = hwif->tp_ops;
@@ -316,7 +316,7 @@ int ide_driveid_update(ide_drive_t *driv
 		return 0;
 
 	SELECT_MASK(drive, 1);
-	rc = ide_dev_read_id(drive, ATA_CMD_ID_ATA, id);
+	rc = ide_dev_read_id(drive, ATA_CMD_ID_ATA, id, 1);
 	SELECT_MASK(drive, 0);
 
 	if (rc)
Index: b/drivers/ide/ide-probe.c
===================================================================
--- a/drivers/ide/ide-probe.c
+++ b/drivers/ide/ide-probe.c
@@ -238,6 +238,7 @@ static void do_identify(ide_drive_t *dri
  *	@drive: drive to identify
  *	@cmd: command to use
  *	@id: buffer for IDENTIFY data
+ *	@irq_ctx: flag set when called from the IRQ context
  *
  *	Sends an ATA(PI) IDENTIFY request to a drive and waits for a response.
  *
@@ -246,7 +247,7 @@ static void do_identify(ide_drive_t *dri
  *			2  device aborted the command (refused to identify itself)
  */
 
-int ide_dev_read_id(ide_drive_t *drive, u8 cmd, u16 *id)
+int ide_dev_read_id(ide_drive_t *drive, u8 cmd, u16 *id, int irq_ctx)
 {
 	ide_hwif_t *hwif = drive->hwif;
 	struct ide_io_ports *io_ports = &hwif->io_ports;
@@ -263,7 +264,10 @@ int ide_dev_read_id(ide_drive_t *drive, 
 		tp_ops->write_devctl(hwif, ATA_NIEN | ATA_DEVCTL_OBS);
 
 	/* take a deep breath */
-	msleep(50);
+	if (irq_ctx)
+		mdelay(50);
+	else
+		msleep(50);
 
 	if (io_ports->ctl_addr &&
 	    (hwif->host_flags & IDE_HFLAG_BROKEN_ALTSTATUS) == 0) {
@@ -295,12 +299,19 @@ int ide_dev_read_id(ide_drive_t *drive, 
 
 	timeout = ((cmd == ATA_CMD_ID_ATA) ? WAIT_WORSTCASE : WAIT_PIDENTIFY) / 2;
 
-	if (ide_busy_sleep(drive, timeout, use_altstatus))
-		return 1;
-
 	/* wait for IRQ and ATA_DRQ */
-	msleep(50);
-	s = tp_ops->read_status(hwif);
+	if (irq_ctx) {
+		rc = __ide_wait_stat(drive, ATA_DRQ, BAD_R_STAT, timeout, &s);
+		if (rc)
+			return 1;
+	} else {
+		rc = ide_busy_sleep(drive, timeout, use_altstatus);
+		if (rc)
+			return 1;
+
+		msleep(50);
+		s = tp_ops->read_status(hwif);
+	}
 
 	if (OK_STAT(s, ATA_DRQ, BAD_R_STAT)) {
 		/* drive returned ID */
@@ -406,10 +417,10 @@ static int do_probe (ide_drive_t *drive,
 
 	if (OK_STAT(stat, ATA_DRDY, ATA_BUSY) ||
 	    present || cmd == ATA_CMD_ID_ATAPI) {
-		rc = ide_dev_read_id(drive, cmd, id);
+		rc = ide_dev_read_id(drive, cmd, id, 0);
 		if (rc)
 			/* failed: try again */
-			rc = ide_dev_read_id(drive, cmd, id);
+			rc = ide_dev_read_id(drive, cmd, id, 0);
 
 		stat = tp_ops->read_status(hwif);
 
@@ -424,7 +435,7 @@ static int do_probe (ide_drive_t *drive,
 			msleep(50);
 			tp_ops->exec_command(hwif, ATA_CMD_DEV_RESET);
 			(void)ide_busy_sleep(drive, WAIT_WORSTCASE, 0);
-			rc = ide_dev_read_id(drive, cmd, id);
+			rc = ide_dev_read_id(drive, cmd, id, 0);
 		}
 
 		/* ensure drive IRQ is clear */
Index: b/include/linux/ide.h
===================================================================
--- a/include/linux/ide.h
+++ b/include/linux/ide.h
@@ -1081,6 +1081,7 @@ extern void ide_fixstring(u8 *, const in
 
 int ide_busy_sleep(ide_drive_t *, unsigned long, int);
 
+int __ide_wait_stat(ide_drive_t *, u8, u8, unsigned long, u8 *);
 int ide_wait_stat(ide_startstop_t *, ide_drive_t *, u8, u8, unsigned long);
 
 ide_startstop_t ide_do_park_unpark(ide_drive_t *, struct request *);
@@ -1169,7 +1170,7 @@ int ide_no_data_taskfile(ide_drive_t *, 
 
 int ide_taskfile_ioctl(ide_drive_t *, unsigned long);
 
-int ide_dev_read_id(ide_drive_t *, u8, u16 *);
+int ide_dev_read_id(ide_drive_t *, u8, u16 *, int);
 
 extern int ide_driveid_update(ide_drive_t *);
 extern int ide_config_drive_speed(ide_drive_t *, u8);
