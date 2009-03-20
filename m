Return-Path: <linux-kernel-owner+w=401wt.eu-S1761022AbZCTBtq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761022AbZCTBtq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Mar 2009 21:49:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761107AbZCTBtb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Mar 2009 21:49:31 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:55917 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1761141AbZCTBta (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Mar 2009 21:49:30 -0400
Message-ID: <49C2F63C.2090107@cn.fujitsu.com>
Date: Fri, 20 Mar 2009 09:49:48 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Jens Axboe <jens.axboe@oracle.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 7/7] blktrace: avoid accessing NULL bdev->bd_disk
References: <49C2F599.3060306@cn.fujitsu.com>
In-Reply-To: <49C2F599.3060306@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

bdev->bd_disk can be NULL, if the block device is not opened.

Try this against an unmounted partition, and you'll see NULL dereference:
  # echo 1 > /sys/block/sda/sda5/enable

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
---
 kernel/trace/blktrace.c |   13 +++++++++++--
 1 files changed, 11 insertions(+), 2 deletions(-)

diff --git a/kernel/trace/blktrace.c b/kernel/trace/blktrace.c
index 46e0cfe..37095d9 100644
--- a/kernel/trace/blktrace.c
+++ b/kernel/trace/blktrace.c
@@ -1362,6 +1362,14 @@ static int blk_str2act_mask(const char *str)
 	return mask;
 }
 
+static request_queue *blk_trace_get_queue(struct block_device *bdev)
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
 
-- 
1.5.4.rc3

