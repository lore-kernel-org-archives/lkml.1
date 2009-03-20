Return-Path: <linux-kernel-owner+w=401wt.eu-S1761091AbZCTBt3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761091AbZCTBt3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Mar 2009 21:49:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758924AbZCTBtO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Mar 2009 21:49:14 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:53545 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1760244AbZCTBtK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Mar 2009 21:49:10 -0400
Message-ID: <49C2F628.9090300@cn.fujitsu.com>
Date: Fri, 20 Mar 2009 09:49:28 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Jens Axboe <jens.axboe@oracle.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 6/7] blktrace: remove sysfs_blk_trace_enable_show/store()
References: <49C2F599.3060306@cn.fujitsu.com>
In-Reply-To: <49C2F599.3060306@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

sysfs_blk_trace_enable_show()/store() share most of code with
sysfs_blk_trace_attr_show()/store().

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
---
 kernel/trace/blktrace.c |   89 +++++++++++------------------------------------
 1 files changed, 21 insertions(+), 68 deletions(-)

diff --git a/kernel/trace/blktrace.c b/kernel/trace/blktrace.c
index 14986af..46e0cfe 100644
--- a/kernel/trace/blktrace.c
+++ b/kernel/trace/blktrace.c
@@ -1284,72 +1284,6 @@ static int blk_trace_setup_queue(struct request_queue *q, dev_t dev)
  * sysfs interface to enable and configure tracing
  */
 
-static ssize_t sysfs_blk_trace_enable_show(struct device *dev,
-					   struct device_attribute *attr,
-					   char *buf)
-{
-	struct hd_struct *p = dev_to_part(dev);
-	struct block_device *bdev;
-	ssize_t ret = -ENXIO;
-
-	lock_kernel();
-	bdev = bdget(part_devt(p));
-	if (bdev != NULL) {
-		struct request_queue *q = bdev_get_queue(bdev);
-
-		if (q != NULL) {
-			mutex_lock(&bdev->bd_mutex);
-			ret = sprintf(buf, "%u\n", !!q->blk_trace);
-			mutex_unlock(&bdev->bd_mutex);
-		}
-
-		bdput(bdev);
-	}
-
-	unlock_kernel();
-	return ret;
-}
-
-static ssize_t sysfs_blk_trace_enable_store(struct device *dev,
-					    struct device_attribute *attr,
-					    const char *buf, size_t count)
-{
-	struct block_device *bdev;
-	struct request_queue *q;
-	struct hd_struct *p;
-	int value;
-	ssize_t ret = -ENXIO;
-
-	if (count == 0 || sscanf(buf, "%d", &value) != 1)
-		goto out;
-
-	lock_kernel();
-	p = dev_to_part(dev);
-	bdev = bdget(part_devt(p));
-	if (bdev == NULL)
-		goto out_unlock_kernel;
-
-	q = bdev_get_queue(bdev);
-	if (q == NULL)
-		goto out_bdput;
-
-	mutex_lock(&bdev->bd_mutex);
-	if (value)
-		ret = blk_trace_setup_queue(q, bdev->bd_dev);
-	else
-		ret = blk_trace_remove_queue(q);
-	mutex_unlock(&bdev->bd_mutex);
-
-	if (ret == 0)
-		ret = count;
-out_bdput:
-	bdput(bdev);
-out_unlock_kernel:
-	unlock_kernel();
-out:
-	return ret;
-}
-
 static ssize_t sysfs_blk_trace_attr_show(struct device *dev,
 					 struct device_attribute *attr,
 					 char *buf);
@@ -1361,8 +1295,7 @@ static ssize_t sysfs_blk_trace_attr_store(struct device *dev,
 		    sysfs_blk_trace_attr_show, \
 		    sysfs_blk_trace_attr_store)
 
-static DEVICE_ATTR(enable, S_IRUGO | S_IWUSR,
-		   sysfs_blk_trace_enable_show, sysfs_blk_trace_enable_store);
+static BLK_TRACE_DEVICE_ATTR(enable);
 static BLK_TRACE_DEVICE_ATTR(act_mask);
 static BLK_TRACE_DEVICE_ATTR(pid);
 static BLK_TRACE_DEVICE_ATTR(start_lba);
@@ -1447,6 +1380,12 @@ static ssize_t sysfs_blk_trace_attr_show(struct device *dev,
 	if (q == NULL)
 		goto out_bdput;
 	mutex_lock(&bdev->bd_mutex);
+
+	if (attr == &dev_attr_enable) {
+		ret = sprintf(buf, "%u\n", !!q->blk_trace);
+		goto out_unlock_bdev;
+	}
+
 	if (q->blk_trace == NULL)
 		ret = sprintf(buf, "disabled\n");
 	else if (attr == &dev_attr_act_mask)
@@ -1457,6 +1396,8 @@ static ssize_t sysfs_blk_trace_attr_show(struct device *dev,
 		ret = sprintf(buf, "%llu\n", q->blk_trace->start_lba);
 	else if (attr == &dev_attr_end_lba)
 		ret = sprintf(buf, "%llu\n", q->blk_trace->end_lba);
+
+out_unlock_bdev:
 	mutex_unlock(&bdev->bd_mutex);
 out_bdput:
 	bdput(bdev);
@@ -1499,6 +1440,15 @@ static ssize_t sysfs_blk_trace_attr_store(struct device *dev,
 		goto out_bdput;
 
 	mutex_lock(&bdev->bd_mutex);
+
+	if (attr == &dev_attr_enable) {
+		if (value)
+			ret = blk_trace_setup_queue(q, bdev->bd_dev);
+		else
+			ret = blk_trace_remove_queue(q);
+		goto out_unlock_bdev;
+	}
+
 	ret = 0;
 	if (q->blk_trace == NULL)
 		ret = blk_trace_setup_queue(q, bdev->bd_dev);
@@ -1514,6 +1464,8 @@ static ssize_t sysfs_blk_trace_attr_store(struct device *dev,
 			q->blk_trace->end_lba = value;
 		ret = count;
 	}
+
+out_unlock_bdev:
 	mutex_unlock(&bdev->bd_mutex);
 out_bdput:
 	bdput(bdev);
@@ -1522,3 +1474,4 @@ out_unlock_kernel:
 out:
 	return ret;
 }
+
-- 
1.5.4.rc3

