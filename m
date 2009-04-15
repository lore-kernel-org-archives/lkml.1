Return-Path: <linux-kernel-owner+w=401wt.eu-S1759325AbZDOKNz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759325AbZDOKNz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Apr 2009 06:13:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759000AbZDOKNo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Apr 2009 06:13:44 -0400
Received: from hera.kernel.org ([140.211.167.34]:55449 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752813AbZDOKNn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Apr 2009 06:13:43 -0400
Date: Wed, 15 Apr 2009 10:13:03 GMT
From: tip-bot for Li Zefan <lizf@cn.fujitsu.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, hpa@zytor.com,
       mingo@redhat.com, lizf@cn.fujitsu.com, tytso@mit.edu,
       jens.axboe@oracle.com, duyuyang@gmail.com, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, acme@redhat.com,
       linux-kernel@vger.kernel.org, lizf@cn.fujitsu.com, tytso@mit.edu,
       jens.axboe@oracle.com, duyuyang@gmail.com, tglx@linutronix.de,
       mingo@elte.hu
In-Reply-To: <49E42646.4060608@cn.fujitsu.com>
References: <49E42646.4060608@cn.fujitsu.com>
Subject: [tip:tracing/core] blktrace: support per-partition tracing for ftrace plugin
Message-ID: <tip-1411074bef90ccb3b709b98965ac79508b51c452@git.kernel.org>
Git-Commit-ID: 1411074bef90ccb3b709b98965ac79508b51c452
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 15 Apr 2009 10:13:05 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  1411074bef90ccb3b709b98965ac79508b51c452
Gitweb:     http://git.kernel.org/tip/1411074bef90ccb3b709b98965ac79508b51c452
Author:     Li Zefan <lizf@cn.fujitsu.com>
AuthorDate: Tue, 14 Apr 2009 13:59:34 +0800
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 15 Apr 2009 09:38:44 +0200

blktrace: support per-partition tracing for ftrace plugin

The previous patch adds support to trace a single partition for
relay+ioctl blktrace, and this patch is for ftrace plugin blktrace:

  # echo 1 > /sys/block/sda/sda7/enable
  # cat start_lba
  102398373
  # cat end_lba
  102703545

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
Acked-by: "Theodore Ts'o" <tytso@mit.edu>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Shawn Du <duyuyang@gmail.com>
Cc: Jens Axboe <jens.axboe@oracle.com>
LKML-Reference: <49E42646.4060608@cn.fujitsu.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


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
