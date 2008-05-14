Return-Path: <linux-kernel-owner+w=401wt.eu-S1763086AbYENRuw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763086AbYENRuw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2008 13:50:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762850AbYENRuZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 May 2008 13:50:25 -0400
Received: from ns.suse.de ([195.135.220.2]:55868 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758453AbYENRuX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2008 13:50:23 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Kay Sievers <kay.sievers@vrfy.org>, stable <stable@kernel.org>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 1/2] block: do_mounts - accept root=<non-existant partition>
Date: Wed, 14 May 2008 10:49:54 -0700
Message-Id: <1210787395-25887-1-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.5.1
In-Reply-To: <20080514174920.GA25856@suse.de>
References: <20080514174920.GA25856@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kay Sievers <kay.sievers@vrfy.org>

Some devices, like md, may create partitions only at first access,
so allow root= to be set to a valid non-existant partition of an
existing disk. This applies only to non-initramfs root mounting.

This fixes a regression from 2.6.24 which did allow this to happen and
broke some users machines :(

Acked-by: Neil Brown <neilb@suse.de>
Tested-by: Joao Luis Meloni Assirati <assirati@nonada.if.usp.br>
Cc: stable <stable@kernel.org>
Signed-off-by: Kay Sievers <kay.sievers@vrfy.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 block/genhd.c         |    9 ++++++---
 include/linux/genhd.h |    4 ++--
 init/do_mounts.c      |   27 ++++++++++++++++++++++++++-
 3 files changed, 34 insertions(+), 6 deletions(-)

diff --git a/block/genhd.c b/block/genhd.c
index fda9c7a..129ad93 100644
--- a/block/genhd.c
+++ b/block/genhd.c
@@ -653,7 +653,7 @@ void genhd_media_change_notify(struct gendisk *disk)
 EXPORT_SYMBOL_GPL(genhd_media_change_notify);
 #endif  /*  0  */
 
-dev_t blk_lookup_devt(const char *name)
+dev_t blk_lookup_devt(const char *name, int part)
 {
 	struct device *dev;
 	dev_t devt = MKDEV(0, 0);
@@ -661,7 +661,11 @@ dev_t blk_lookup_devt(const char *name)
 	mutex_lock(&block_class_lock);
 	list_for_each_entry(dev, &block_class.devices, node) {
 		if (strcmp(dev->bus_id, name) == 0) {
-			devt = dev->devt;
+			struct gendisk *disk = dev_to_disk(dev);
+
+			if (part < disk->minors)
+				devt = MKDEV(MAJOR(dev->devt),
+					     MINOR(dev->devt) + part);
 			break;
 		}
 	}
@@ -669,7 +673,6 @@ dev_t blk_lookup_devt(const char *name)
 
 	return devt;
 }
-
 EXPORT_SYMBOL(blk_lookup_devt);
 
 struct gendisk *alloc_disk(int minors)
diff --git a/include/linux/genhd.h b/include/linux/genhd.h
index e9874e7..ae7aec3 100644
--- a/include/linux/genhd.h
+++ b/include/linux/genhd.h
@@ -525,7 +525,7 @@ struct unixware_disklabel {
 #define ADDPART_FLAG_RAID	1
 #define ADDPART_FLAG_WHOLEDISK	2
 
-extern dev_t blk_lookup_devt(const char *name);
+extern dev_t blk_lookup_devt(const char *name, int part);
 extern char *disk_name (struct gendisk *hd, int part, char *buf);
 
 extern int rescan_partitions(struct gendisk *disk, struct block_device *bdev);
@@ -553,7 +553,7 @@ static inline struct block_device *bdget_disk(struct gendisk *disk, int index)
 
 static inline void printk_all_partitions(void) { }
 
-static inline dev_t blk_lookup_devt(const char *name)
+static inline dev_t blk_lookup_devt(const char *name, int part)
 {
 	dev_t devt = MKDEV(0, 0);
 	return devt;
diff --git a/init/do_mounts.c b/init/do_mounts.c
index 3885e70..660c1e5 100644
--- a/init/do_mounts.c
+++ b/init/do_mounts.c
@@ -76,6 +76,7 @@ dev_t name_to_dev_t(char *name)
 	char s[32];
 	char *p;
 	dev_t res = 0;
+	int part;
 
 	if (strncmp(name, "/dev/", 5) != 0) {
 		unsigned maj, min;
@@ -106,7 +107,31 @@ dev_t name_to_dev_t(char *name)
 	for (p = s; *p; p++)
 		if (*p == '/')
 			*p = '!';
-	res = blk_lookup_devt(s);
+	res = blk_lookup_devt(s, 0);
+	if (res)
+		goto done;
+
+	/*
+	 * try non-existant, but valid partition, which may only exist
+	 * after revalidating the disk, like partitioned md devices
+	 */
+	while (p > s && isdigit(p[-1]))
+		p--;
+	if (p == s || !*p || *p == '0')
+		goto fail;
+
+	/* try disk name without <part number> */
+	part = simple_strtoul(p, NULL, 10);
+	*p = '\0';
+	res = blk_lookup_devt(s, part);
+	if (res)
+		goto done;
+
+	/* try disk name without p<part number> */
+	if (p < s + 2 || !isdigit(p[-2]) || p[-1] != 'p')
+		goto fail;
+	p[-1] = '\0';
+	res = blk_lookup_devt(s, part);
 	if (res)
 		goto done;
 
-- 
1.5.5.1

