Return-Path: <linux-kernel-owner+w=401wt.eu-S1762908AbZCTKaj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762908AbZCTKaj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Mar 2009 06:30:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762660AbZCTK2F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Mar 2009 06:28:05 -0400
Received: from hera.kernel.org ([140.211.167.34]:35342 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762670AbZCTK2C (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Mar 2009 06:28:02 -0400
Date: Fri, 20 Mar 2009 10:26:35 GMT
From: Li Zefan <lizf@cn.fujitsu.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, hpa@zytor.com,
       mingo@redhat.com, lizf@cn.fujitsu.com, jens.axboe@oracle.com,
       fweisbec@gmail.com, rostedt@goodmis.org, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, acme@redhat.com,
       linux-kernel@vger.kernel.org, lizf@cn.fujitsu.com,
       jens.axboe@oracle.com, fweisbec@gmail.com, rostedt@goodmis.org,
       tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <49C30EA3.1060004@cn.fujitsu.com>
References: <49C30EA3.1060004@cn.fujitsu.com>
Subject: [tip:tracing/blktrace] blktrace: remove sysfs_blk_trace_enable_show/store()
Message-ID: <tip-9626d7ee4addbf97245c129e24ba9a9b765bd5ef@git.kernel.org>
Git-Commit-ID: 9626d7ee4addbf97245c129e24ba9a9b765bd5ef
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Fri, 20 Mar 2009 10:26:37 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  9626d7ee4addbf97245c129e24ba9a9b765bd5ef
Gitweb:     http://git.kernel.org/tip/9626d7ee4addbf97245c129e24ba9a9b765bd5ef
Author:     Li Zefan <lizf@cn.fujitsu.com>
AuthorDate: Fri, 20 Mar 2009 11:33:55 +0800
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 20 Mar 2009 11:20:06 +0100

blktrace: remove sysfs_blk_trace_enable_show/store()

sysfs_blk_trace_enable_show()/store() share most of code with
sysfs_blk_trace_attr_show()/store().

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
Cc: Jens Axboe <jens.axboe@oracle.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Acked-by: Frederic Weisbecker <fweisbec@gmail.com>
LKML-Reference: <49C30EA3.1060004@cn.fujitsu.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 kernel/trace/blktrace.c |   92 +++++++++++-----------------------------------
 1 files changed, 22 insertions(+), 70 deletions(-)

diff --git a/kernel/trace/blktrace.c b/kernel/trace/blktrace.c
index 14986af..dfee6f9 100644
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
@@ -1512,13 +1462,15 @@ static ssize_t sysfs_blk_trace_attr_store(struct device *dev,
 			q->blk_trace->start_lba = value;
 		else if (attr == &dev_attr_end_lba)
 			q->blk_trace->end_lba = value;
-		ret = count;
 	}
+
+out_unlock_bdev:
 	mutex_unlock(&bdev->bd_mutex);
 out_bdput:
 	bdput(bdev);
 out_unlock_kernel:
 	unlock_kernel();
 out:
-	return ret;
+	return ret ? ret : count;
 }
+
