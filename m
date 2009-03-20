Return-Path: <linux-kernel-owner+w=401wt.eu-S1762978AbZCTKbU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762978AbZCTKbU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Mar 2009 06:31:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762681AbZCTK21
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Mar 2009 06:28:27 -0400
Received: from hera.kernel.org ([140.211.167.34]:35364 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761784AbZCTK2Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Mar 2009 06:28:25 -0400
Date: Fri, 20 Mar 2009 10:26:44 GMT
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
In-Reply-To: <49C30098.6080107@cn.fujitsu.com>
References: <49C30098.6080107@cn.fujitsu.com>
Subject: [tip:tracing/blktrace] blktrace: avoid accessing NULL bdev->bd_disk
Message-ID: <tip-afaebb6720cc62df1b03e36c2f699b00cfee784e@git.kernel.org>
Git-Commit-ID: afaebb6720cc62df1b03e36c2f699b00cfee784e
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Fri, 20 Mar 2009 10:26:46 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  afaebb6720cc62df1b03e36c2f699b00cfee784e
Gitweb:     http://git.kernel.org/tip/afaebb6720cc62df1b03e36c2f699b00cfee784e
Author:     Li Zefan <lizf@cn.fujitsu.com>
AuthorDate: Fri, 20 Mar 2009 10:34:00 +0800
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 20 Mar 2009 11:20:07 +0100

blktrace: avoid accessing NULL bdev->bd_disk

bdev->bd_disk can be NULL, if the block device is not opened.

Try this against an unmounted partition, and you'll see NULL dereference:

  # echo 1 > /sys/block/sda/sda5/enable

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
Cc: Jens Axboe <jens.axboe@oracle.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Acked-by: Frederic Weisbecker <fweisbec@gmail.com>
LKML-Reference: <49C30098.6080107@cn.fujitsu.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 kernel/trace/blktrace.c |   13 +++++++++++--
 1 files changed, 11 insertions(+), 2 deletions(-)

diff --git a/kernel/trace/blktrace.c b/kernel/trace/blktrace.c
index dfee6f9..108f4f7 100644
--- a/kernel/trace/blktrace.c
+++ b/kernel/trace/blktrace.c
@@ -1362,6 +1362,14 @@ static int blk_str2act_mask(const char *str)
 	return mask;
 }
 
+static struct request_queue *blk_trace_get_queue(struct block_device *bdev)
+{
+	if (bdev->bd_disk == NULL)
+		return NULL;
+
+	return bdev_get_queue(bdev);
+}
+
 static ssize_t sysfs_blk_trace_attr_show(struct device *dev,
 					 struct device_attribute *attr,
 					 char *buf)
@@ -1376,9 +1384,10 @@ static ssize_t sysfs_blk_trace_attr_show(struct device *dev,
 	if (bdev == NULL)
 		goto out_unlock_kernel;
 
-	q = bdev_get_queue(bdev);
+	q = blk_trace_get_queue(bdev);
 	if (q == NULL)
 		goto out_bdput;
+
 	mutex_lock(&bdev->bd_mutex);
 
 	if (attr == &dev_attr_enable) {
@@ -1435,7 +1444,7 @@ static ssize_t sysfs_blk_trace_attr_store(struct device *dev,
 	if (bdev == NULL)
 		goto out_unlock_kernel;
 
-	q = bdev_get_queue(bdev);
+	q = blk_trace_get_queue(bdev);
 	if (q == NULL)
 		goto out_bdput;
 
