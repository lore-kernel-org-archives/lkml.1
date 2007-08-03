Return-Path: <linux-kernel-owner+w=401wt.eu-S932079AbXHCNDQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932079AbXHCNDQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Aug 2007 09:03:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761686AbXHCM5a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Aug 2007 08:57:30 -0400
Received: from mx1.redhat.com ([66.187.233.31]:51281 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762267AbXHCM5Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Aug 2007 08:57:25 -0400
Message-Id: <20070803125237.851592000@chello.nl>
References: <20070803123712.987126000@chello.nl>
User-Agent: quilt/0.45-1
Date: Fri, 03 Aug 2007 14:37:36 +0200
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: linux-mm@kvack.org, linux-kernel@vger.kernel.org
Cc: miklos@szeredi.hu, akpm@linux-foundation.org, neilb@suse.de, dgc@sgi.com,
       tomoki.sekiyama.qu@hitachi.com, a.p.zijlstra@chello.nl,
       nikita@clusterfs.com, trond.myklebust@fys.uio.no,
       yingchao.zhou@gmail.com, richard@rsk.demon.co.uk,
       torvalds@linux-foundation.org
Subject: [PATCH 23/23] debug: sysfs files for the current ratio/size/total
Content-Disposition: inline; filename=bdi_stat_debug.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Expose the per bdi dirty limits in sysfs

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 block/ll_rw_blk.c   |   80 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 mm/page-writeback.c |    4 +-
 2 files changed, 82 insertions(+), 2 deletions(-)

Index: linux-2.6/block/ll_rw_blk.c
===================================================================
--- linux-2.6.orig/block/ll_rw_blk.c
+++ linux-2.6/block/ll_rw_blk.c
@@ -3995,6 +3995,56 @@ static ssize_t queue_nr_writeback_show(s
 			nr_writeback >> (PAGE_CACHE_SHIFT - 10));
 }
 
+extern void bdi_writeout_fraction(struct backing_dev_info *bdi,
+		long *numerator, long *denominator);
+
+static ssize_t queue_nr_cache_ratio_show(struct request_queue *q, char *page)
+{
+	long scale, div;
+
+	bdi_writeout_fraction(&q->backing_dev_info, &scale, &div);
+	scale *= 1024;
+	scale /= div;
+
+	return sprintf(page, "%ld\n", scale);
+}
+
+static ssize_t queue_nr_cache_num_show(struct request_queue *q, char *page)
+{
+	long scale, div;
+
+	bdi_writeout_fraction(&q->backing_dev_info, &scale, &div);
+
+	return sprintf(page, "%ld\n", scale);
+}
+
+static ssize_t queue_nr_cache_denom_show(struct request_queue *q, char *page)
+{
+	long scale, div;
+
+	bdi_writeout_fraction(&q->backing_dev_info, &scale, &div);
+
+	return sprintf(page, "%ld\n", div);
+}
+
+extern void
+get_dirty_limits(long *pbackground, long *pdirty, long *pbdi_dirty,
+		struct backing_dev_info *bdi);
+
+static ssize_t queue_nr_cache_size_show(struct request_queue *q, char *page)
+{
+	long background, dirty, bdi_dirty;
+	get_dirty_limits(&background, &dirty, &bdi_dirty, &q->backing_dev_info);
+	return sprintf(page, "%ld\n", bdi_dirty);
+}
+
+static ssize_t queue_nr_cache_total_show(struct request_queue *q, char *page)
+{
+	long background, dirty, bdi_dirty;
+	get_dirty_limits(&background, &dirty, &bdi_dirty, &q->backing_dev_info);
+	return sprintf(page, "%ld\n", dirty);
+}
+
 static struct queue_sysfs_entry queue_requests_entry = {
 	.attr = {.name = "nr_requests", .mode = S_IRUGO | S_IWUSR },
 	.show = queue_requests_show,
@@ -4028,6 +4078,31 @@ static struct queue_sysfs_entry queue_wr
 	.show = queue_nr_writeback_show,
 };
 
+static struct queue_sysfs_entry queue_cache_ratio_entry = {
+	.attr = {.name = "cache_ratio", .mode = S_IRUGO },
+	.show = queue_nr_cache_ratio_show,
+};
+
+static struct queue_sysfs_entry queue_cache_num_entry = {
+	.attr = {.name = "cache_num", .mode = S_IRUGO },
+	.show = queue_nr_cache_num_show,
+};
+
+static struct queue_sysfs_entry queue_cache_denom_entry = {
+	.attr = {.name = "cache_denom", .mode = S_IRUGO },
+	.show = queue_nr_cache_denom_show,
+};
+
+static struct queue_sysfs_entry queue_cache_size_entry = {
+	.attr = {.name = "cache_size", .mode = S_IRUGO },
+	.show = queue_nr_cache_size_show,
+};
+
+static struct queue_sysfs_entry queue_cache_total_entry = {
+	.attr = {.name = "cache_total", .mode = S_IRUGO },
+	.show = queue_nr_cache_total_show,
+};
+
 static struct queue_sysfs_entry queue_iosched_entry = {
 	.attr = {.name = "scheduler", .mode = S_IRUGO | S_IWUSR },
 	.show = elv_iosched_show,
@@ -4041,6 +4116,11 @@ static struct attribute *default_attrs[]
 	&queue_max_sectors_entry.attr,
 	&queue_reclaimable_entry.attr,
 	&queue_writeback_entry.attr,
+	&queue_cache_ratio_entry.attr,
+	&queue_cache_num_entry.attr,
+	&queue_cache_denom_entry.attr,
+	&queue_cache_size_entry.attr,
+	&queue_cache_total_entry.attr,
 	&queue_iosched_entry.attr,
 	NULL,
 };
Index: linux-2.6/mm/page-writeback.c
===================================================================
--- linux-2.6.orig/mm/page-writeback.c
+++ linux-2.6/mm/page-writeback.c
@@ -176,7 +176,7 @@ static void task_dirty_inc(struct task_s
 /*
  * Obtain an accurate fraction of the BDI's portion.
  */
-static void bdi_writeout_fraction(struct backing_dev_info *bdi,
+void bdi_writeout_fraction(struct backing_dev_info *bdi,
 		long *numerator, long *denominator)
 {
 	if (bdi_cap_writeback_dirty(bdi)) {
@@ -300,7 +300,7 @@ static unsigned long determine_dirtyable
 	return x + 1;	/* Ensure that we never return 0 */
 }
 
-static void
+void
 get_dirty_limits(long *pbackground, long *pdirty, long *pbdi_dirty,
 		 struct backing_dev_info *bdi)
 {

--

