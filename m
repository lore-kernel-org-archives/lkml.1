Return-Path: <linux-kernel-owner+w=401wt.eu-S1759493AbYG3WYT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759493AbYG3WYT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2008 18:24:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754617AbYG3WXO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jul 2008 18:23:14 -0400
Received: from fk-out-0910.google.com ([209.85.128.188]:25437 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752853AbYG3WXH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2008 18:23:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:mime-version:content-type
         :content-transfer-encoding:content-disposition:message-id;
        b=xfQd3Ps1A4BTpeGUZnO0CxzNGPJfOmG9mhiNuo3e91xzfngAxvryu+rw1CkPReJNDB
         nmK2VnpdF1PbEEQKexrkSOmPJKBf5qpCG6zwSiFdiOE3bqg7yiUwBeVJD4YtbVMB/JkE
         hSnONHmthKGazQDzcbFZBz9BRfXEpXSTygJ9M=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Subject: [PATCH 3/3] ide: ide_id_has_flush_cache_ext() -> ata_id_flush_ext_enabled()
Date: Wed, 30 Jul 2008 23:26:56 +0200
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, Jeff Garzik <jgarzik@pobox.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807302326.56498.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Add ata_id_flush_ext_enabled() inline helper to <linux/ata.h>.

* ide_id_has_flush_cache_ext() -> ata_id_flush_ext_enabled()

  The latter one also checks if the command is marked as
  supported in word 83 and validity of words 83 & 86.

Cc: Jeff Garzik <jgarzik@pobox.com>
Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/ide-disk.c |    6 +++---
 drivers/ide/ide-io.c   |    2 +-
 include/linux/ata.h    |   13 +++++++++++++
 include/linux/ide.h    |    4 ----
 4 files changed, 17 insertions(+), 8 deletions(-)

Index: b/drivers/ide/ide-disk.c
===================================================================
--- a/drivers/ide/ide-disk.c
+++ b/drivers/ide/ide-disk.c
@@ -582,7 +582,7 @@ static void idedisk_prepare_flush(struct
 	BUG_ON(task == NULL);
 
 	memset(task, 0, sizeof(*task));
-	if (ide_id_has_flush_cache_ext(drive->id) &&
+	if (ata_id_flush_ext_enabled(drive->id) &&
 	    (drive->capacity64 >= (1UL << 28)))
 		task->tf.command = ATA_CMD_FLUSH_EXT;
 	else
@@ -659,7 +659,7 @@ static void update_ordered(ide_drive_t *
 		capacity = idedisk_capacity(drive);
 		barrier = ata_id_flush_enabled(id) && !drive->noflush &&
 			(drive->addressing == 0 || capacity <= (1ULL << 28) ||
-			 ide_id_has_flush_cache_ext(id));
+			 ata_id_flush_ext_enabled(id));
 
 		printk(KERN_INFO "%s: cache flushes %ssupported\n",
 		       drive->name, barrier ? "" : "not ");
@@ -705,7 +705,7 @@ static int do_idedisk_flushcache(ide_dri
 	ide_task_t args;
 
 	memset(&args, 0, sizeof(ide_task_t));
-	if (ide_id_has_flush_cache_ext(drive->id))
+	if (ata_id_flush_ext_enabled(drive->id))
 		args.tf.command = ATA_CMD_FLUSH_EXT;
 	else
 		args.tf.command = ATA_CMD_FLUSH;
Index: b/drivers/ide/ide-io.c
===================================================================
--- a/drivers/ide/ide-io.c
+++ b/drivers/ide/ide-io.c
@@ -188,7 +188,7 @@ static ide_startstop_t ide_start_power_s
 			ide_complete_power_step(drive, rq, 0, 0);
 			return ide_stopped;
 		}
-		if (ide_id_has_flush_cache_ext(drive->id))
+		if (ata_id_flush_ext_enabled(drive->id))
 			args->tf.command = ATA_CMD_FLUSH_EXT;
 		else
 			args->tf.command = ATA_CMD_FLUSH;
Index: b/include/linux/ata.h
===================================================================
--- a/include/linux/ata.h
+++ b/include/linux/ata.h
@@ -573,6 +573,19 @@ static inline int ata_id_has_flush_ext(c
 	return id[ATA_ID_COMMAND_SET_2] & (1 << 13);
 }
 
+static inline int ata_id_flush_ext_enabled(const u16 *id)
+{
+	if (ata_id_has_flush_ext(id) == 0)
+		return 0;
+	if ((id[ATA_ID_CSF_DEFAULT] & 0xC000) != 0x4000)
+		return 0;
+	/*
+	 * some Maxtor disks have bit 13 defined incorrectly
+	 * so check bit 10 too
+	 */
+	return (id[ATA_ID_CFS_ENABLE_2] & 0x2400) == 0x2400;
+}
+
 static inline int ata_id_has_lba48(const u16 *id)
 {
 	if ((id[ATA_ID_COMMAND_SET_2] & 0xC000) != 0x4000)
Index: b/include/linux/ide.h
===================================================================
--- a/include/linux/ide.h
+++ b/include/linux/ide.h
@@ -1451,10 +1451,6 @@ extern struct mutex ide_cfg_mtx;
 extern struct bus_type ide_bus_type;
 extern struct class *ide_port_class;
 
-/* some Maxtor disks have bit 13 defined incorrectly so check bit 10 too */
-#define ide_id_has_flush_cache_ext(id)	\
-	(((id)[ATA_ID_CFS_ENABLE_2] & 0x2400) == 0x2400)
-
 static inline void ide_dump_identify(u8 *id)
 {
 	print_hex_dump(KERN_INFO, "", DUMP_PREFIX_NONE, 16, 2, id, 512, 0);
