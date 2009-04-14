Return-Path: <linux-kernel-owner+w=401wt.eu-S1753424AbZDNF64@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753424AbZDNF64 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Apr 2009 01:58:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751300AbZDNF6q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Apr 2009 01:58:46 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:62996 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750990AbZDNF6p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Apr 2009 01:58:45 -0400
Message-ID: <49E42646.4060608@cn.fujitsu.com>
Date: Tue, 14 Apr 2009 13:59:34 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, Jens Axboe <jens.axboe@oracle.com>
CC: Arnaldo Carvalho de Melo <acme@redhat.com>,
       "Theodore Ts'o" <tytso@mit.edu>, Shawn Du <duyuyang@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>, linux-btrace@vger.kernel.org
Subject: [PATCH 2/3] blktrace: support per-partition tracing for ftrace plugin
References: <49E42620.4050701@cn.fujitsu.com>
In-Reply-To: <49E42620.4050701@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The previous patch adds support to trace a single partition for
relay+ioctl blktrace, and this patch is for ftrace plugin blktrace:

  # echo 1 > /sys/block/sda/sda7/enable
  # cat start_lba
  102398373
  # cat end_lba
  102703545

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
---
 kernel/trace/blktrace.c |   39 +++++++++++++++++++++++++--------------
 1 files changed, 25 insertions(+), 14 deletions(-)

diff --git a/kernel/trace/blktrace.c b/kernel/trace/blktrace.c
index e932654..d109898 100644
--- a/kernel/trace/blktrace.c
+++ b/kernel/trace/blktrace.c
@@ -403,6 +403,23 @@ static struct rchan_callbacks blk_relay_callbacks = {
 	.remove_buf_file	= blk_remove_buf_file_callback,
 };
 
+static void blk_trace_setup_lba(struct blk_trace *bt,
+				struct block_device *bdev)
+{
+	struct hd_struct *part = NULL;
+
+	if (bdev)
+		part = bdev->bd_part;
+
+	if (part) {
+		bt->start_lba = part->start_sect;
+		bt->end_lba = part->start_sect + part->nr_sects;
+	} else {
+		bt->start_lba = 0;
+		bt->end_lba = -1ULL;
+	}
+}
+
 /*
  * Setup everything required to start tracing
  */
@@ -413,7 +430,6 @@ int do_blk_trace_setup(struct request_queue *q, char *name, dev_t dev,
 	struct blk_trace *old_bt, *bt = NULL;
 	struct dentry *dir = NULL;
 	int ret, i;
-	struct hd_struct *part = NULL;
 
 	if (!buts->buf_size || !buts->buf_nr)
 		return -EINVAL;
@@ -482,14 +498,7 @@ int do_blk_trace_setup(struct request_queue *q, char *name, dev_t dev,
 	if (!bt->act_mask)
 		bt->act_mask = (u16) -1;
 
-	if (bdev)
-		part = bdev->bd_part;
-
-	if (part) {
-		bt->start_lba = part->start_sect;
-		bt->end_lba = part->start_sect + part->nr_sects;
-	} else
-		bt->end_lba = -1ULL;
+	blk_trace_setup_lba(bt, bdev);
 
 	/* overwrite with user settings */
 	if (buts->start_lba)
@@ -1370,7 +1379,8 @@ static int blk_trace_remove_queue(struct request_queue *q)
 /*
  * Setup everything required to start tracing
  */
-static int blk_trace_setup_queue(struct request_queue *q, dev_t dev)
+static int blk_trace_setup_queue(struct request_queue *q,
+				 struct block_device *bdev)
 {
 	struct blk_trace *old_bt, *bt = NULL;
 	int ret = -ENOMEM;
@@ -1383,9 +1393,10 @@ static int blk_trace_setup_queue(struct request_queue *q, dev_t dev)
 	if (!bt->msg_data)
 		goto free_bt;
 
-	bt->dev = dev;
+	bt->dev = bdev->bd_dev;
 	bt->act_mask = (u16)-1;
-	bt->end_lba = -1ULL;
+
+	blk_trace_setup_lba(bt, bdev);
 
 	old_bt = xchg(&q->blk_trace, bt);
 	if (old_bt != NULL) {
@@ -1602,7 +1613,7 @@ static ssize_t sysfs_blk_trace_attr_store(struct device *dev,
 
 	if (attr == &dev_attr_enable) {
 		if (value)
-			ret = blk_trace_setup_queue(q, bdev->bd_dev);
+			ret = blk_trace_setup_queue(q, bdev);
 		else
 			ret = blk_trace_remove_queue(q);
 		goto out_unlock_bdev;
@@ -1610,7 +1621,7 @@ static ssize_t sysfs_blk_trace_attr_store(struct device *dev,
 
 	ret = 0;
 	if (q->blk_trace == NULL)
-		ret = blk_trace_setup_queue(q, bdev->bd_dev);
+		ret = blk_trace_setup_queue(q, bdev);
 
 	if (ret == 0) {
 		if (attr == &dev_attr_act_mask)
-- 
1.5.4.rc3

