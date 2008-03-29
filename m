Return-Path: <linux-kernel-owner+w=401wt.eu-S1757534AbYC2SsA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757534AbYC2SsA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Mar 2008 14:48:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757323AbYC2Srv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Mar 2008 14:47:51 -0400
Received: from fg-out-1718.google.com ([72.14.220.155]:51973 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757227AbYC2Sru (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Mar 2008 14:47:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=from:to:subject:date:user-agent:cc:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=Vrr3GSLyO7NMSi1wOQ+XJeLQ2I+rzCru/phZgs49yDO9DPcJLWQitGLXXeVToTiafkyoW0yBkCM+zriDexJUy9WPWIK2qqRXbOuQHr8h4gLJc8Z81ujR85EOh4PncpQvgmkiHcEV2MtO54LJsVkNNsGRLiw9o4f+xK0PH8F/2KA=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [git patches] IDE fixes
Date: Sat, 29 Mar 2008 20:01:17 +0100
User-Agent: KMail/1.9.9
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Stephen Rothwell <sfr@canb.auug.org.au>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803292001.17584.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Linus, please pull from:

master.kernel.org:/pub/scm/linux/kernel/git/bart/ide-2.6.git/

to receive the following updates:

 drivers/ide/ide-iops.c  |    1 +
 drivers/ide/ide-probe.c |    5 +++--
 include/linux/ide.h     |    2 +-
 3 files changed, 5 insertions(+), 3 deletions(-)


Bartlomiej Zolnierkiewicz (2):
      Revert "ide: change master/slave IDENTIFY order"
      ide: fix defining SUPPORT_VLB_SYNC


diff --git a/drivers/ide/ide-iops.c b/drivers/ide/ide-iops.c
index c419266..01b9220 100644
--- a/drivers/ide/ide-iops.c
+++ b/drivers/ide/ide-iops.c
@@ -595,6 +595,7 @@ u8 eighty_ninty_three (ide_drive_t *drive)
 
 	/*
 	 * FIXME:
+	 * - change master/slave IDENTIFY order
 	 * - force bit13 (80c cable present) check also for !ivb devices
 	 *   (unless the slave device is pre-ATA3)
 	 */
diff --git a/drivers/ide/ide-probe.c b/drivers/ide/ide-probe.c
index 194ecb0..47a1149 100644
--- a/drivers/ide/ide-probe.c
+++ b/drivers/ide/ide-probe.c
@@ -774,9 +774,10 @@ static int ide_probe_port(ide_hwif_t *hwif)
 		printk(KERN_DEBUG "%s: Wait for ready failed before probe !\n", hwif->name);
 
 	/*
-	 * Need to probe slave device first to make it release PDIAG-.
+	 * Second drive should only exist if first drive was found,
+	 * but a lot of cdrom drives are configured as single slaves.
 	 */
-	for (unit = MAX_DRIVES - 1; unit >= 0; unit--) {
+	for (unit = 0; unit < MAX_DRIVES; ++unit) {
 		ide_drive_t *drive = &hwif->drives[unit];
 		drive->dn = (hwif->channel ? 2 : 0) + unit;
 		(void) probe_for_drive(drive);
diff --git a/include/linux/ide.h b/include/linux/ide.h
index a3b69c1..bc26b2f 100644
--- a/include/linux/ide.h
+++ b/include/linux/ide.h
@@ -26,7 +26,7 @@
 #include <asm/semaphore.h>
 #include <asm/mutex.h>
 
-#if defined(CRIS) || defined(FRV)
+#if defined(CONFIG_CRIS) || defined(CONFIG_FRV)
 # define SUPPORT_VLB_SYNC 0
 #else
 # define SUPPORT_VLB_SYNC 1
