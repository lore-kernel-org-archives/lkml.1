Return-Path: <linux-kernel-owner+w=401wt.eu-S1760093AbYG1Un0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760093AbYG1Un0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2008 16:43:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753312AbYG1UnG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jul 2008 16:43:06 -0400
Received: from fk-out-0910.google.com ([209.85.128.185]:15694 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751270AbYG1UnD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2008 16:43:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:subject;
        b=DsTYjeKJ60LqmZiXo/LcQKt17bCUsVs6P9ZGO5N0+ibHzNKF/AtV0fK23iZr91y17H
         BY84Yw8fWR4F2IqRtgjs3yRcrJs1zwUoK4Vi13R+wSRmMxoyAxxo+m0eXFGJ6q9XOBy7
         193J6otd4jnUoOKm9WD0iKhy5hkQrAqJ5oHLQ=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Mon, 28 Jul 2008 22:41:02 +0200
Message-Id: <20080728204102.4283.74632.sendpatchset@localhost.localdomain>
Subject: [PATCH 1/5] ide: remove SECTOR_WORDS define
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Just use SECTOR_SIZE instead.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
another batch of small cleanups...

 drivers/ide/ide-disk.c     |    5 +++--
 drivers/ide/ide-iops.c     |    2 +-
 drivers/ide/ide-probe.c    |    2 +-
 drivers/ide/ide-proc.c     |    5 +++--
 drivers/ide/ide-taskfile.c |    2 +-
 include/linux/ide.h        |    2 +-
 6 files changed, 10 insertions(+), 8 deletions(-)

Index: b/drivers/ide/ide-disk.c
===================================================================
--- a/drivers/ide/ide-disk.c
+++ b/drivers/ide/ide-disk.c
@@ -546,13 +546,14 @@ static int proc_idedisk_read_smart(char 
 
 	if (get_smart_data(drive, page, sub_cmd) == 0) {
 		unsigned short *val = (unsigned short *) page;
-		char *out = ((char *)val) + (SECTOR_WORDS * 4);
+		char *out = (char *)val + SECTOR_SIZE;
+
 		page = out;
 		do {
 			out += sprintf(out, "%04x%c", le16_to_cpu(*val),
 				       (++i & 7) ? ' ' : '\n');
 			val += 1;
-		} while (i < (SECTOR_WORDS * 2));
+		} while (i < SECTOR_SIZE / 2);
 		len = out - page;
 	}
 
Index: b/drivers/ide/ide-iops.c
===================================================================
--- a/drivers/ide/ide-iops.c
+++ b/drivers/ide/ide-iops.c
@@ -693,7 +693,7 @@ int ide_driveid_update(ide_drive_t *driv
 	}
 	local_irq_save(flags);
 	SELECT_MASK(drive, 0);
-	id = kmalloc(SECTOR_WORDS*4, GFP_ATOMIC);
+	id = kmalloc(SECTOR_SIZE, GFP_ATOMIC);
 	if (!id) {
 		local_irq_restore(flags);
 		return 0;
Index: b/drivers/ide/ide-probe.c
===================================================================
--- a/drivers/ide/ide-probe.c
+++ b/drivers/ide/ide-probe.c
@@ -561,7 +561,7 @@ static inline u8 probe_for_drive (ide_dr
 	 *	Also note that 0 everywhere means "can't do X"
 	 */
  
-	drive->id = kzalloc(SECTOR_WORDS *4, GFP_KERNEL);
+	drive->id = kzalloc(SECTOR_SIZE, GFP_KERNEL);
 	drive->id_read = 0;
 	if(drive->id == NULL)
 	{
Index: b/drivers/ide/ide-proc.c
===================================================================
--- a/drivers/ide/ide-proc.c
+++ b/drivers/ide/ide-proc.c
@@ -100,13 +100,14 @@ static int proc_ide_read_identify
 
 		err = taskfile_lib_get_identify(drive, page);
 		if (!err) {
-			char *out = ((char *)page) + (SECTOR_WORDS * 4);
+			char *out = (char *)page + SECTOR_SIZE;
+
 			page = out;
 			do {
 				out += sprintf(out, "%04x%c",
 					le16_to_cpup(val), (++i & 7) ? ' ' : '\n');
 				val += 1;
-			} while (i < (SECTOR_WORDS * 2));
+			} while (i < SECTOR_SIZE / 2);
 			len = out - page;
 		}
 	}
Index: b/drivers/ide/ide-taskfile.c
===================================================================
--- a/drivers/ide/ide-taskfile.c
+++ b/drivers/ide/ide-taskfile.c
@@ -768,7 +768,7 @@ int ide_cmd_ioctl (ide_drive_t *drive, u
 
 	if (args[3]) {
 		tfargs.tf_flags |= IDE_TFLAG_IO_16BIT;
-		bufsize = SECTOR_WORDS * 4 * args[3];
+		bufsize = SECTOR_SIZE * args[3];
 		buf = kzalloc(bufsize, GFP_KERNEL);
 		if (buf == NULL)
 			return -ENOMEM;
Index: b/include/linux/ide.h
===================================================================
--- a/include/linux/ide.h
+++ b/include/linux/ide.h
@@ -126,7 +126,7 @@ struct ide_io_ports {
 #define PARTN_BITS	6	/* number of minor dev bits for partitions */
 #define MAX_DRIVES	2	/* per interface; 2 assumed by lots of code */
 #define SECTOR_SIZE	512
-#define SECTOR_WORDS	(SECTOR_SIZE / 4)	/* number of 32bit words per sector */
+
 #define IDE_LARGE_SEEK(b1,b2,t)	(((b1) > (b2) + (t)) || ((b2) > (b1) + (t)))
 
 /*
