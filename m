Return-Path: <linux-kernel-owner+w=401wt.eu-S1761633AbXEJKSo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761633AbXEJKSo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2007 06:18:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760224AbXEJKOU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 May 2007 06:14:20 -0400
Received: from mx1.redhat.com ([66.187.233.31]:56166 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760861AbXEJKOK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2007 06:14:10 -0400
Message-Id: <20070510101129.732392567@chello.nl>
References: <20070510100839.621199408@chello.nl>
User-Agent: quilt/0.46-1
Date: Thu, 10 May 2007 12:08:52 +0200
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: linux-mm@kvack.org, linux-kernel@vger.kernel.org
Cc: miklos@szeredi.hu, akpm@linux-foundation.org, neilb@suse.de, dgc@sgi.com,
       tomoki.sekiyama.qu@hitachi.com, a.p.zijlstra@chello.nl,
       nikita@clusterfs.com, trond.myklebust@fys.uio.no,
       yingchao.zhou@gmail.com
Subject: [PATCH 13/15] debug: sysfs files for the current ratio/size/total
Content-Disposition: inline; filename=bdi_stat_debug.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Expose the per bdi dirty limits in sysfs

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 block/ll_rw_blk.c   |   50 ++++++++++++++++++++++++++++++++++++++++++++++++++
 mm/page-writeback.c |    4 ++--
 2 files changed, 52 insertions(+), 2 deletions(-)

Index: linux-2.6/block/ll_rw_blk.c
===================================================================
--- linux-2.6.orig/block/ll_rw_blk.c	2007-05-04 09:57:52.000000000 +0200
+++ linux-2.6/block/ll_rw_blk.c	2007-05-04 10:00:23.000000000 +0200
@@ -3998,6 +3998,38 @@ static ssize_t queue_nr_writeback_show(s
 			nr_writeback >> (PAGE_CACHE_SHIFT - 10));
 }
 
+extern void bdi_writeout_fraction(struct backing_dev_info *bdi,
+	       	long *numerator, long *denominator);
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
@@ -4037,6 +4069,21 @@ static struct queue_sysfs_entry queue_wr
 	.show = queue_nr_writeback_show,
 };
 
+static struct queue_sysfs_entry queue_cache_ratio_entry = {
+	.attr = {.name = "cache_ratio", .mode = S_IRUGO },
+	.show = queue_nr_cache_ratio_show,
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
@@ -4051,6 +4098,9 @@ static struct attribute *default_attrs[]
 	&queue_max_sectors_entry.attr,
 	&queue_reclaimable_entry.attr,
 	&queue_writeback_entry.attr,
+	&queue_cache_ratio_entry.attr,
+	&queue_cache_size_entry.attr,
+	&queue_cache_total_entry.attr,
 	&queue_iosched_entry.attr,
 	NULL,
 };
Index: linux-2.6/mm/page-writeback.c
===================================================================
--- linux-2.6.orig/mm/page-writeback.c	2007-05-04 09:58:04.000000000 +0200
+++ linux-2.6/mm/page-writeback.c	2007-05-04 10:00:37.000000000 +0200
@@ -402,7 +402,7 @@ static void __bdi_writeout_inc(struct ba
  *
  *   p_{j} = x_{j} / (period/2 + t % period/2)
  */
-static void bdi_writeout_fraction(struct backing_dev_info *bdi,
+void bdi_writeout_fraction(struct backing_dev_info *bdi,
 	       	long *numerator, long *denominator)
 {
 	struct vm_completions_data *vcd = get_vcd();
@@ -477,7 +477,7 @@ static unsigned long determine_dirtyable
 	return x + 1;	/* Ensure that we never return 0 */
 }
 
-static void
+void
 get_dirty_limits(long *pbackground, long *pdirty, long *pbdi_dirty,
 		 struct backing_dev_info *bdi)
 {

-- 

