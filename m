Return-Path: <linux-kernel-owner+w=401wt.eu-S1030301AbXDCOrs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030301AbXDCOrs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2007 10:47:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030307AbXDCOrm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Apr 2007 10:47:42 -0400
Received: from mx1.redhat.com ([66.187.233.31]:47605 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030301AbXDCOr0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2007 10:47:26 -0400
Message-Id: <20070403144224.610538071@taijtu.programming.kicks-ass.net>
References: <20070403144047.073283598@taijtu.programming.kicks-ass.net>
User-Agent: quilt/0.46-1
Date: Tue, 03 Apr 2007 16:40:52 +0200
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: linux-mm@kvack.org, linux-kernel@vger.kernel.org
Cc: miklos@szeredi.hu, akpm@linux-foundation.org, neilb@suse.de, dgc@sgi.com,
       tomoki.sekiyama.qu@hitachi.com, a.p.zijlstra@chello.nl
Subject: [PATCH 5/6] mm: expose BDI statistics in sysfs.
Content-Disposition: inline; filename=bdi_stat_sysfs.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Expose the per BDI stats in /sys/block/<dev>/queue/*

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 block/ll_rw_blk.c   |   81 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 mm/page-writeback.c |    2 -
 2 files changed, 82 insertions(+), 1 deletion(-)

Index: linux-2.6/block/ll_rw_blk.c
===================================================================
--- linux-2.6.orig/block/ll_rw_blk.c
+++ linux-2.6/block/ll_rw_blk.c
@@ -3975,6 +3975,20 @@ static ssize_t queue_max_hw_sectors_show
 	return queue_var_show(max_hw_sectors_kb, (page));
 }
 
+static ssize_t queue_nr_dirty_show(struct request_queue *q, char *page)
+{
+	return sprintf(page, "%lu\n", bdi_stat(&q->backing_dev_info, BDI_DIRTY));
+}
+
+static ssize_t queue_nr_writeback_show(struct request_queue *q, char *page)
+{
+	return sprintf(page, "%lu\n", bdi_stat(&q->backing_dev_info, BDI_WRITEBACK));
+}
+
+static ssize_t queue_nr_unstable_show(struct request_queue *q, char *page)
+{
+	return sprintf(page, "%lu\n", bdi_stat(&q->backing_dev_info, BDI_UNSTABLE));
+}
 
 static struct queue_sysfs_entry queue_requests_entry = {
 	.attr = {.name = "nr_requests", .mode = S_IRUGO | S_IWUSR },
@@ -4005,6 +4019,21 @@ static struct queue_sysfs_entry queue_ma
 	.show = queue_max_hw_sectors_show,
 };
 
+static struct queue_sysfs_entry queue_dirty_entry = {
+	.attr = {.name = "dirty_pages", .mode = S_IRUGO },
+	.show = queue_nr_dirty_show,
+};
+
+static struct queue_sysfs_entry queue_writeback_entry = {
+	.attr = {.name = "writeback_pages", .mode = S_IRUGO },
+	.show = queue_nr_writeback_show,
+};
+
+static struct queue_sysfs_entry queue_unstable_entry = {
+	.attr = {.name = "unstable_pages", .mode = S_IRUGO },
+	.show = queue_nr_unstable_show,
+};
+
 static struct queue_sysfs_entry queue_iosched_entry = {
 	.attr = {.name = "scheduler", .mode = S_IRUGO | S_IWUSR },
 	.show = elv_iosched_show,
@@ -4017,6 +4046,9 @@ static struct attribute *default_attrs[]
 	&queue_initial_ra_entry.attr,
 	&queue_max_hw_sectors_entry.attr,
 	&queue_max_sectors_entry.attr,
+	&queue_dirty_entry.attr,
+	&queue_writeback_entry.attr,
+	&queue_unstable_entry.attr,
 	&queue_iosched_entry.attr,
 	NULL,
 };

-- 

