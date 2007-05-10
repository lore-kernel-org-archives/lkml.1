Return-Path: <linux-kernel-owner+w=401wt.eu-S1761662AbXEJLng@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761662AbXEJLng (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2007 07:43:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760695AbXEJLlR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 May 2007 07:41:17 -0400
Received: from brick.kernel.dk ([80.160.20.94]:4896 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758519AbXEJLlJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2007 07:41:09 -0400
From: Jens Axboe <jens.axboe@oracle.com>
To: linux-kernel@vger.kernel.org
Cc: Jens Axboe <jens.axboe@oracle.com>
Subject: [PATCH 12/12] ll_rw_blk: temporarily enable max_segments tweaking
Date: Thu, 10 May 2007 13:40:37 +0200
Message-Id: <11787972371728-git-send-email-jens.axboe@oracle.com>
X-Mailer: git-send-email 1.5.2.rc1
In-Reply-To: <11787972373654-git-send-email-jens.axboe@oracle.com>
References: <11787972373654-git-send-email-jens.axboe@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Expose this setting for now, so that users can play with enabling
large commands without defaulting it to on globally. This is a debug
patch, it will be dropped for the final versions.

Signed-off-by: Jens Axboe <jens.axboe@oracle.com>
---
 block/ll_rw_blk.c |   23 +++++++++++++++++++++++
 1 files changed, 23 insertions(+), 0 deletions(-)

diff --git a/block/ll_rw_blk.c b/block/ll_rw_blk.c
index b01a5f2..18f1db0 100644
--- a/block/ll_rw_blk.c
+++ b/block/ll_rw_blk.c
@@ -3930,7 +3930,23 @@ static ssize_t queue_max_hw_sectors_show(struct request_queue *q, char *page)
 	return queue_var_show(max_hw_sectors_kb, (page));
 }
 
+static ssize_t queue_max_segments_show(struct request_queue *q, char *page)
+{
+	return queue_var_show(q->max_phys_segments, page);
+}
+
+static ssize_t queue_max_segments_store(struct request_queue *q,
+					const char *page, size_t count)
+{
+	unsigned long segments;
+	ssize_t ret = queue_var_store(&segments, page, count);
 
+	spin_lock_irq(q->queue_lock);
+	q->max_phys_segments = segments;
+	spin_unlock_irq(q->queue_lock);
+
+	return ret;
+}
 static struct queue_sysfs_entry queue_requests_entry = {
 	.attr = {.name = "nr_requests", .mode = S_IRUGO | S_IWUSR },
 	.show = queue_requests_show,
@@ -3954,6 +3970,12 @@ static struct queue_sysfs_entry queue_max_hw_sectors_entry = {
 	.show = queue_max_hw_sectors_show,
 };
 
+static struct queue_sysfs_entry queue_max_segments_entry = {
+	.attr = {.name = "max_segments", .mode = S_IRUGO | S_IWUSR },
+	.show = queue_max_segments_show,
+	.store = queue_max_segments_store,
+};
+
 static struct queue_sysfs_entry queue_iosched_entry = {
 	.attr = {.name = "scheduler", .mode = S_IRUGO | S_IWUSR },
 	.show = elv_iosched_show,
@@ -3965,6 +3987,7 @@ static struct attribute *default_attrs[] = {
 	&queue_ra_entry.attr,
 	&queue_max_hw_sectors_entry.attr,
 	&queue_max_sectors_entry.attr,
+	&queue_max_segments_entry.attr,
 	&queue_iosched_entry.attr,
 	NULL,
 };
-- 
1.5.2.rc1

