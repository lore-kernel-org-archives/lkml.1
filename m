Return-Path: <linux-kernel-owner+w=401wt.eu-S1759024AbYGCNGx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759024AbYGCNGx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2008 09:06:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759485AbYGCNGJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jul 2008 09:06:09 -0400
Received: from hera.kernel.org ([140.211.167.34]:33992 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756507AbYGCNGG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2008 09:06:06 -0400
From: Tejun Heo <tj@kernel.org>
To: jeff@garzik.org, linux-ide@vger.kernel.org,
       James.Bottomley@HansenPartnership.com, bharrosh@panasas.com,
       greg.freemyer@gmail.com, linux-scsi@vger.kernel.org,
       brking@linux.vnet.ibm.com, liml@rtr.ca, jens.axboe@oracle.com,
       viro@ftp.linux.org.uk, linux-kernel@vger.kernel.org, device@lanana.org
Cc: Tejun Heo <tj@kernel.org>
Subject: [PATCH 5/6] sd/ide-disk: apply extended minors to sd and ide
Date: Thu,  3 Jul 2008 17:33:05 +0900
Message-Id: <1215073986-4709-6-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.5.4.5
In-Reply-To: <1215073986-4709-1-git-send-email-tj@kernel.org>
References: <1215073986-4709-1-git-send-email-tj@kernel.org>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0rc1 (hera.kernel.org [127.0.0.1]); Thu, 03 Jul 2008 08:33:41 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Update sd and ide-disk such that they can take advantage of extended
minors.

ide-disk already has 64 minors per device and currently doesn't use
extended minors although after this patch it can be turned on by
simply tweaking constants.

sd only had 16 minors per device causing problems on certain peculiar
configurations.  This patch lifts the restriction and enables it to
use upto 64 minors.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 drivers/ide/ide-disk.c |   11 ++++++++---
 drivers/scsi/sd.c      |    9 +++++++--
 2 files changed, 15 insertions(+), 5 deletions(-)

diff --git a/drivers/ide/ide-disk.c b/drivers/ide/ide-disk.c
index 8e08d08..f8b091a 100644
--- a/drivers/ide/ide-disk.c
+++ b/drivers/ide/ide-disk.c
@@ -41,6 +41,10 @@
 #include <asm/io.h>
 #include <asm/div64.h>
 
+#define IDE_DISK_PARTS		(1 << PARTN_BITS)
+#define IDE_DISK_MINORS		IDE_DISK_PARTS
+#define IDE_DISK_EXT_MINORS	(IDE_DISK_PARTS - IDE_DISK_MINORS)
+
 struct ide_disk_obj {
 	ide_drive_t	*drive;
 	ide_driver_t	*driver;
@@ -1158,8 +1162,8 @@ static int ide_disk_probe(ide_drive_t *drive)
 	if (!idkp)
 		goto failed;
 
-	g = alloc_disk_node(1 << PARTN_BITS,
-			hwif_to_node(drive->hwif));
+	g = alloc_disk_ext_node(IDE_DISK_MINORS, IDE_DISK_EXT_MINORS,
+				hwif_to_node(drive->hwif));
 	if (!g)
 		goto out_free_idkp;
 
@@ -1185,7 +1189,8 @@ static int ide_disk_probe(ide_drive_t *drive)
 	} else
 		drive->attach = 1;
 
-	g->minors = 1 << PARTN_BITS;
+	g->minors = IDE_DISK_MINORS;
+	g->ext_minors = IDE_DISK_EXT_MINORS;
 	g->driverfs_dev = &drive->gendev;
 	g->flags = drive->removable ? GENHD_FL_REMOVABLE : 0;
 	set_capacity(g, idedisk_capacity(drive));
diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 01cefbb..8879c98 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -86,6 +86,10 @@ MODULE_ALIAS_SCSI_DEVICE(TYPE_DISK);
 MODULE_ALIAS_SCSI_DEVICE(TYPE_MOD);
 MODULE_ALIAS_SCSI_DEVICE(TYPE_RBC);
 
+#define SD_PARTS	64
+#define SD_MINORS	16
+#define SD_EXT_MINORS	(SD_PARTS - SD_MINORS)
+
 static int  sd_revalidate_disk(struct gendisk *);
 static int  sd_probe(struct device *);
 static int  sd_remove(struct device *);
@@ -1642,7 +1646,7 @@ static int sd_probe(struct device *dev)
 	if (!sdkp)
 		goto out;
 
-	gd = alloc_disk(16);
+	gd = alloc_disk_ext(SD_MINORS, SD_EXT_MINORS);
 	if (!gd)
 		goto out_free;
 
@@ -1684,7 +1688,8 @@ static int sd_probe(struct device *dev)
 
 	gd->major = sd_major((index & 0xf0) >> 4);
 	gd->first_minor = ((index & 0xf) << 4) | (index & 0xfff00);
-	gd->minors = 16;
+	gd->minors = SD_MINORS;
+	gd->ext_minors = SD_EXT_MINORS;
 	gd->fops = &sd_fops;
 
 	if (index < 26) {
-- 
1.5.4.5

