Return-Path: <linux-kernel-owner+w=401wt.eu-S933430AbYBOMIf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933430AbYBOMIf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2008 07:08:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753769AbYBOMI1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Feb 2008 07:08:27 -0500
Received: from smtp-out01.alice-dsl.net ([88.44.60.11]:49306 "EHLO
	smtp-out01.alice-dsl.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752862AbYBOMI0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2008 07:08:26 -0500
Date: Fri, 15 Feb 2008 13:08:21 +0100
From: Andi Kleen <andi@firstfloor.org>
To: dm-devel@redhat.com, agk@redhat.com, linux-kernel@vger.kernel.org
Subject: [PATCH] Implement barrier support for single device DM devices
Message-ID: <20080215120821.GA8267@basil.nowhere.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
X-OriginalArrivalTime: 15 Feb 2008 12:01:59.0525 (UTC) FILETIME=[91807150:01C86FCA]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Implement barrier support for single device DM devices

This patch implements barrier support in DM for the common case of dm linear
just remapping a single underlying device. In this case we can safely
pass the barrier through because there can be no reordering between
devices.

Signed-off-by: Andi Kleen <ak@suse.de>

---
 drivers/md/dm-linear.c |    1 +
 drivers/md/dm-table.c  |   27 ++++++++++++++++++++++++++-
 drivers/md/dm.c        |   14 ++++----------
 drivers/md/dm.h        |    2 ++
 4 files changed, 33 insertions(+), 11 deletions(-)

Index: linux/drivers/md/dm-table.c
===================================================================
--- linux.orig/drivers/md/dm-table.c
+++ linux/drivers/md/dm-table.c
@@ -38,6 +38,9 @@ struct dm_table {
 	sector_t *highs;
 	struct dm_target *targets;
 
+	unsigned single_device : 1;
+	unsigned barrier_supported : 1;
+
 	/*
 	 * Indicates the rw permissions for the new logical
 	 * device.  This should be a combination of FMODE_READ
@@ -584,12 +587,21 @@ EXPORT_SYMBOL_GPL(dm_set_device_limits);
 int dm_get_device(struct dm_target *ti, const char *path, sector_t start,
 		  sector_t len, int mode, struct dm_dev **result)
 {
-	int r = __table_get_device(ti->table, ti, path,
+	struct dm_table *t = ti->table;
+	int r = __table_get_device(t, ti, path,
 				   start, len, mode, result);
 
 	if (!r)
 		dm_set_device_limits(ti, (*result)->bdev);
 
+	if (!r) {
+		/* Only got single device? */
+		if (t->devices.next->next == &t->devices)
+			t->single_device = 1;
+		else
+			t->single_device = 0;
+	}
+
 	return r;
 }
 
@@ -1023,6 +1035,16 @@ struct mapped_device *dm_table_get_md(st
 	return t->md;
 }
 
+int dm_table_barrier_ok(struct dm_table *t)
+{
+	return t->single_device && t->barrier_supported;
+}
+
+void dm_table_support_barrier(struct dm_table *t)
+{
+	t->barrier_supported = 1;
+}
+
 EXPORT_SYMBOL(dm_vcalloc);
 EXPORT_SYMBOL(dm_get_device);
 EXPORT_SYMBOL(dm_put_device);
@@ -1033,3 +1055,5 @@ EXPORT_SYMBOL(dm_table_get_md);
 EXPORT_SYMBOL(dm_table_put);
 EXPORT_SYMBOL(dm_table_get);
 EXPORT_SYMBOL(dm_table_unplug_all);
+EXPORT_SYMBOL(dm_table_barrier_ok);
+EXPORT_SYMBOL(dm_table_support_barrier);
Index: linux/drivers/md/dm.c
===================================================================
--- linux.orig/drivers/md/dm.c
+++ linux/drivers/md/dm.c
@@ -801,7 +801,10 @@ static int __split_bio(struct mapped_dev
 	ci.map = dm_get_table(md);
 	if (unlikely(!ci.map))
 		return -EIO;
-
+	if (unlikely(bio_barrier(bio) && !dm_table_barrier_ok(ci.map))) {
+		bio_endio(bio, -EOPNOTSUPP);
+		return 0;
+	}
 	ci.md = md;
 	ci.bio = bio;
 	ci.io = alloc_io(md);
@@ -837,15 +840,6 @@ static int dm_request(struct request_que
 	int rw = bio_data_dir(bio);
 	struct mapped_device *md = q->queuedata;
 
-	/*
-	 * There is no use in forwarding any barrier request since we can't
-	 * guarantee it is (or can be) handled by the targets correctly.
-	 */
-	if (unlikely(bio_barrier(bio))) {
-		bio_endio(bio, -EOPNOTSUPP);
-		return 0;
-	}
-
 	down_read(&md->io_lock);
 
 	disk_stat_inc(dm_disk(md), ios[rw]);
Index: linux/drivers/md/dm.h
===================================================================
--- linux.orig/drivers/md/dm.h
+++ linux/drivers/md/dm.h
@@ -116,6 +116,8 @@ void dm_table_unplug_all(struct dm_table
  * To check the return value from dm_table_find_target().
  */
 #define dm_target_is_valid(t) ((t)->table)
+int dm_table_barrier_ok(struct dm_table *t);
+void dm_table_support_barrier(struct dm_table *t);
 
 /*-----------------------------------------------------------------
  * A registry of target types.
Index: linux/drivers/md/dm-linear.c
===================================================================
--- linux.orig/drivers/md/dm-linear.c
+++ linux/drivers/md/dm-linear.c
@@ -52,6 +52,7 @@ static int linear_ctr(struct dm_target *
 		ti->error = "dm-linear: Device lookup failed";
 		goto bad;
 	}
+	dm_table_support_barrier(ti->table);
 
 	ti->private = lc;
 	return 0;
