Return-Path: <linux-kernel-owner+w=401wt.eu-S1756168AbZETPc0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756168AbZETPc0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 May 2009 11:32:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754764AbZETPcM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 May 2009 11:32:12 -0400
Received: from mail-ew0-f176.google.com ([209.85.219.176]:56712 "EHLO
	mail-ew0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753825AbZETPcL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 May 2009 11:32:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:mime-version:content-disposition
         :message-id:content-type:content-transfer-encoding;
        b=veqlOWjNs9RDho+z5bXLMOq8bMsoGCOGYR1NbwqLb6YsMXWeXAbWo9ZxHKh8kTb6o+
         8baq3x8u1FwT29P2GFuZlGs6MdvRGVbewLQCsed2tuxHyuBpV4wLH2H1YCvHq8zhcuve
         2zj8n8rlzQuq8OgYnhTsV4uhBSZEppCmBFIcE=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Subject: [PATCH] ide: report timeouts in ide_busy_sleep()
Date: Wed, 20 May 2009 17:32:58 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.30-rc6-next-20090518-05332-g0707b5a; KDE/4.2.2; i686; ; )
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200905201732.58772.bzolnier@gmail.com>
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* change 'hwif' argument to 'drive'
* report an error on timeout

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
against Linus' tree

 drivers/ide/ide-probe.c |    9 ++++++---
 include/linux/ide.h     |    2 +-
 2 files changed, 7 insertions(+), 4 deletions(-)

Index: b/drivers/ide/ide-probe.c
===================================================================
--- a/drivers/ide/ide-probe.c
+++ b/drivers/ide/ide-probe.c
@@ -295,7 +295,7 @@ int ide_dev_read_id(ide_drive_t *drive, 
 
 	timeout = ((cmd == ATA_CMD_ID_ATA) ? WAIT_WORSTCASE : WAIT_PIDENTIFY) / 2;
 
-	if (ide_busy_sleep(hwif, timeout, use_altstatus))
+	if (ide_busy_sleep(drive, timeout, use_altstatus))
 		return 1;
 
 	/* wait for IRQ and ATA_DRQ */
@@ -316,8 +316,9 @@ int ide_dev_read_id(ide_drive_t *drive, 
 	return rc;
 }
 
-int ide_busy_sleep(ide_hwif_t *hwif, unsigned long timeout, int altstatus)
+int ide_busy_sleep(ide_drive_t *drive, unsigned long timeout, int altstatus)
 {
+	ide_hwif_t *hwif = drive->hwif;
 	u8 stat;
 
 	timeout += jiffies;
@@ -330,6 +331,8 @@ int ide_busy_sleep(ide_hwif_t *hwif, uns
 			return 0;
 	} while (time_before(jiffies, timeout));
 
+	printk(KERN_ERR "%s: timeout in %s\n", drive->name, __func__);
+
 	return 1;	/* drive timed-out */
 }
 
@@ -420,7 +423,7 @@ static int do_probe (ide_drive_t *drive,
 			tp_ops->dev_select(drive);
 			msleep(50);
 			tp_ops->exec_command(hwif, ATA_CMD_DEV_RESET);
-			(void)ide_busy_sleep(hwif, WAIT_WORSTCASE, 0);
+			(void)ide_busy_sleep(drive, WAIT_WORSTCASE, 0);
 			rc = ide_dev_read_id(drive, cmd, id);
 		}
 
Index: b/include/linux/ide.h
===================================================================
--- a/include/linux/ide.h
+++ b/include/linux/ide.h
@@ -1109,7 +1109,7 @@ void ide_fix_driveid(u16 *);
 
 extern void ide_fixstring(u8 *, const int, const int);
 
-int ide_busy_sleep(ide_hwif_t *, unsigned long, int);
+int ide_busy_sleep(ide_drive_t *, unsigned long, int);
 
 int ide_wait_stat(ide_startstop_t *, ide_drive_t *, u8, u8, unsigned long);
 
