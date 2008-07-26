Return-Path: <linux-kernel-owner+w=401wt.eu-S1756161AbYGZNn2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756161AbYGZNn2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jul 2008 09:43:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755239AbYGZNma
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Jul 2008 09:42:30 -0400
Received: from mu-out-0910.google.com ([209.85.134.186]:59438 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755020AbYGZNm3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jul 2008 09:42:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=ooZXlZScMQ+YVXMXCQAKSmutmaV3xfCwsbxywI60WOtOIsQafr8gkS1RopqP6c8aUX
         FFauuBvScU2NB3KxqTOSzzcj3uN7dqVMzzJcTqM08g9VVr0OK7hWGwISS1ssGcbKQZA7
         WDDZkawLu/tNHSmKuPz60iM05gKCVVLG1Rerw=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Sat, 26 Jul 2008 15:40:23 +0200
Message-Id: <20080726134023.10589.32428.sendpatchset@localhost.localdomain>
In-Reply-To: <20080726134010.10589.51679.sendpatchset@localhost.localdomain>
References: <20080726134010.10589.51679.sendpatchset@localhost.localdomain>
Subject: [PATCH 03/10] ide: enhance ide_busy_sleep()
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Make ide_busy_sleep() take timeout value as a parameter
  and also allow use of AltStatus Register if requested with
  altstatus parameter.  Update existing users accordingly.

* Convert ide_driveid_update() and actual_try_to_identify()
  to use ide_busy_sleep().

There should be no functional changes caused by this patch.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/ide-iops.c  |   15 +++++----------
 drivers/ide/ide-probe.c |   30 ++++++++++++------------------
 include/linux/ide.h     |    2 ++
 3 files changed, 19 insertions(+), 28 deletions(-)

Index: b/drivers/ide/ide-iops.c
===================================================================
--- a/drivers/ide/ide-iops.c
+++ b/drivers/ide/ide-iops.c
@@ -666,7 +666,7 @@ int ide_driveid_update(ide_drive_t *driv
 	ide_hwif_t *hwif = drive->hwif;
 	const struct ide_tp_ops *tp_ops = hwif->tp_ops;
 	u16 *id;
-	unsigned long timeout, flags;
+	unsigned long flags;
 	u8 stat;
 
 	/*
@@ -678,16 +678,11 @@ int ide_driveid_update(ide_drive_t *driv
 	tp_ops->set_irq(hwif, 0);
 	msleep(50);
 	tp_ops->exec_command(hwif, ATA_CMD_ID_ATA);
-	timeout = jiffies + WAIT_WORSTCASE;
-	do {
-		if (time_after(jiffies, timeout)) {
-			SELECT_MASK(drive, 0);
-			return 0;	/* drive timed-out */
-		}
 
-		msleep(50);	/* give drive a breather */
-		stat = tp_ops->read_altstatus(hwif);
-	} while (stat & ATA_BUSY);
+	if (ide_busy_sleep(hwif, WAIT_WORSTCASE, 1)) {
+		SELECT_MASK(drive, 0);
+		return 0;
+	}
 
 	msleep(50);	/* wait for IRQ and ATA_DRQ */
 	stat = tp_ops->read_status(hwif);
Index: b/drivers/ide/ide-probe.c
===================================================================
--- a/drivers/ide/ide-probe.c
+++ b/drivers/ide/ide-probe.c
@@ -291,17 +291,9 @@ static int actual_try_to_identify (ide_d
 	tp_ops->exec_command(hwif, cmd);
 
 	timeout = ((cmd == ATA_CMD_ID_ATA) ? WAIT_WORSTCASE : WAIT_PIDENTIFY) / 2;
-	timeout += jiffies;
-	do {
-		if (time_after(jiffies, timeout)) {
-			/* drive timed-out */
-			return 1;
-		}
-		/* give drive a breather */
-		msleep(50);
-		s = use_altstatus ? tp_ops->read_altstatus(hwif)
-				  : tp_ops->read_status(hwif);
-	} while (s & ATA_BUSY);
+
+	if (ide_busy_sleep(hwif, timeout, use_altstatus))
+		return 1;
 
 	/* wait for IRQ and ATA_DRQ */
 	msleep(50);
@@ -383,19 +375,21 @@ static int try_to_identify (ide_drive_t 
 	return retval;
 }
 
-static int ide_busy_sleep(ide_hwif_t *hwif)
+int ide_busy_sleep(ide_hwif_t *hwif, unsigned long timeout, int altstatus)
 {
-	unsigned long timeout = jiffies + WAIT_WORSTCASE;
 	u8 stat;
 
+	timeout += jiffies;
+
 	do {
-		msleep(50);
-		stat = hwif->tp_ops->read_status(hwif);
+		msleep(50);	/* give drive a breather */
+		stat = altstatus ? hwif->tp_ops->read_altstatus(hwif)
+				 : hwif->tp_ops->read_status(hwif);
 		if ((stat & ATA_BUSY) == 0)
 			return 0;
 	} while (time_before(jiffies, timeout));
 
-	return 1;
+	return 1;	/* drive timed-out */
 }
 
 static u8 ide_read_device(ide_drive_t *drive)
@@ -489,7 +483,7 @@ static int do_probe (ide_drive_t *drive,
 			SELECT_DRIVE(drive);
 			msleep(50);
 			tp_ops->exec_command(hwif, ATA_CMD_DEV_RESET);
-			(void)ide_busy_sleep(hwif);
+			(void)ide_busy_sleep(hwif, WAIT_WORSTCASE, 0);
 			rc = try_to_identify(drive, cmd);
 		}
 
@@ -529,7 +523,7 @@ static void enable_nest (ide_drive_t *dr
 	msleep(50);
 	tp_ops->exec_command(hwif, ATA_EXABYTE_ENABLE_NEST);
 
-	if (ide_busy_sleep(hwif)) {
+	if (ide_busy_sleep(hwif, WAIT_WORSTCASE, 0)) {
 		printk(KERN_CONT "failed (timeout)\n");
 		return;
 	}
Index: b/include/linux/ide.h
===================================================================
--- a/include/linux/ide.h
+++ b/include/linux/ide.h
@@ -932,6 +932,8 @@ void ide_fix_driveid(u16 *);
 
 extern void ide_fixstring(u8 *, const int, const int);
 
+int ide_busy_sleep(ide_hwif_t *, unsigned long, int);
+
 int ide_wait_stat(ide_startstop_t *, ide_drive_t *, u8, u8, unsigned long);
 
 extern ide_startstop_t ide_do_reset (ide_drive_t *);
