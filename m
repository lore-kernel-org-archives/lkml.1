Return-Path: <linux-kernel-owner+w=401wt.eu-S1761895AbYFGBMa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761895AbYFGBMa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2008 21:12:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760697AbYFGBI4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jun 2008 21:08:56 -0400
Received: from sous-sol.org ([216.99.217.87]:42320 "EHLO sous-sol.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760663AbYFGBIy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2008 21:08:54 -0400
Message-Id: <20080607010545.198839305@sous-sol.org>
References: <20080607010215.358296706@sous-sol.org>
User-Agent: quilt/0.46-1
Date: Fri, 06 Jun 2008 18:02:16 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: linux-kernel@vger.kernel.org, stable@kernel.org, jejb@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Kay Sievers <kay.sievers@vrfy.org>, Neil Brown <neilb@suse.de>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [patch 01/50] block: do_mounts - accept root=<non-existant partition>
Content-Disposition: inline; filename=block-do_mounts-accept-root-non-existant-partition.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.
---------------------

From: Kay Sievers <kay.sievers@vrfy.org>

commit 30f2f0eb4bd2c43d10a8b0d872c6e5ad8f31c9a0 upstream

Some devices, like md, may create partitions only at first access,
so allow root= to be set to a valid non-existant partition of an
existing disk. This applies only to non-initramfs root mounting.

This fixes a regression from 2.6.24 which did allow this to happen and
broke some users machines :(

Acked-by: Neil Brown <neilb@suse.de>
Tested-by: Joao Luis Meloni Assirati <assirati@nonada.if.usp.br>
Signed-off-by: Kay Sievers <kay.sievers@vrfy.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>

---
 block/genhd.c         |    9 ++++++---
 include/linux/genhd.h |    4 ++--
 init/do_mounts.c      |   27 ++++++++++++++++++++++++++-
 3 files changed, 34 insertions(+), 6 deletions(-)

--- a/block/genhd.c
+++ b/block/genhd.c
@@ -645,7 +645,7 @@ void genhd_media_change_notify(struct ge
 EXPORT_SYMBOL_GPL(genhd_media_change_notify);
 #endif  /*  0  */
 
-dev_t blk_lookup_devt(const char *name)
+dev_t blk_lookup_devt(const char *name, int part)
 {
 	struct device *dev;
 	dev_t devt = MKDEV(0, 0);
@@ -653,7 +653,11 @@ dev_t blk_lookup_devt(const char *name)
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
@@ -661,7 +665,6 @@ dev_t blk_lookup_devt(const char *name)
 
 	return devt;
 }
-
 EXPORT_SYMBOL(blk_lookup_devt);
 
 struct gendisk *alloc_disk(int minors)
--- a/include/linux/genhd.h
+++ b/include/linux/genhd.h
@@ -524,7 +524,7 @@ struct unixware_disklabel {
 #define ADDPART_FLAG_RAID	1
 #define ADDPART_FLAG_WHOLEDISK	2
 
-extern dev_t blk_lookup_devt(const char *name);
+extern dev_t blk_lookup_devt(const char *name, int part);
 extern char *disk_name (struct gendisk *hd, int part, char *buf);
 
 extern int rescan_partitions(struct gendisk *disk, struct block_device *bdev);
@@ -552,7 +552,7 @@ static inline struct block_device *bdget
 
 static inline void printk_all_partitions(void) { }
 
-static inline dev_t blk_lookup_devt(const char *name)
+static inline dev_t blk_lookup_devt(const char *name, int part)
 {
 	dev_t devt = MKDEV(0, 0);
 	return devt;
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
