Return-Path: <linux-kernel-owner+w=401wt.eu-S1751823AbZDNF6W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751823AbZDNF6W (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Apr 2009 01:58:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751300AbZDNF6L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Apr 2009 01:58:11 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:50603 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750990AbZDNF6J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Apr 2009 01:58:09 -0400
Message-ID: <49E42620.4050701@cn.fujitsu.com>
Date: Tue, 14 Apr 2009 13:58:56 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, Jens Axboe <jens.axboe@oracle.com>
CC: Arnaldo Carvalho de Melo <acme@redhat.com>,
       "Theodore Ts'o" <tytso@mit.edu>, Shawn Du <duyuyang@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>, linux-btrace@vger.kernel.org
Subject: PATCH 1/3] blktrace: support per-partition tracing
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Shawn Du <duyuyang@gmail.com>

Though one can specify '-d /dev/sda1' when using blktrace, it still
traces the whole sda.

To support per-partition tracing, when we start tracing, we initialize
bt->start_lba and bt->end_lba to the start and end sector of that
partition.

Note some actions are per device, thus we don't filter 0-sector events.

The original patch and discussion can be found here:
	http://marc.info/?l=linux-btrace&m=122949374214540&w=2

Signed-off-by: Shawn Du <duyuyang@gmail.com>
Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
---
 block/compat_ioctl.c         |    2 +-
 drivers/scsi/sg.c            |    1 +
 include/linux/blktrace_api.h |    6 ++++--
 kernel/trace/blktrace.c      |   29 +++++++++++++++++++++--------
 4 files changed, 27 insertions(+), 11 deletions(-)

diff --git a/block/compat_ioctl.c b/block/compat_ioctl.c
index f87615d..f8c218c 100644
--- a/block/compat_ioctl.c
+++ b/block/compat_ioctl.c
@@ -568,7 +568,7 @@ static int compat_blk_trace_setup(struct block_device *bdev, char __user *arg)
 	memcpy(&buts.name, &cbuts.name, 32);
 
 	mutex_lock(&bdev->bd_mutex);
-	ret = do_blk_trace_setup(q, b, bdev->bd_dev, &buts);
+	ret = do_blk_trace_setup(q, b, bdev->bd_dev, bdev, &buts);
 	mutex_unlock(&bdev->bd_mutex);
 	if (ret)
 		return ret;
diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
index 82312df..49c9873 100644
--- a/drivers/scsi/sg.c
+++ b/drivers/scsi/sg.c
@@ -1065,6 +1065,7 @@ sg_ioctl(struct inode *inode, struct file *filp,
 		return blk_trace_setup(sdp->device->request_queue,
 				       sdp->disk->disk_name,
 				       MKDEV(SCSI_GENERIC_MAJOR, sdp->index),
+				       NULL,
 				       (char *)arg);
 	case BLKTRACESTART:
 		return blk_trace_startstop(sdp->device->request_queue, 1);
diff --git a/include/linux/blktrace_api.h b/include/linux/blktrace_api.h
index d960889..6b2c87e 100644
--- a/include/linux/blktrace_api.h
+++ b/include/linux/blktrace_api.h
@@ -165,8 +165,9 @@ struct blk_trace {
 
 extern int blk_trace_ioctl(struct block_device *, unsigned, char __user *);
 extern void blk_trace_shutdown(struct request_queue *);
-extern int do_blk_trace_setup(struct request_queue *q,
-	char *name, dev_t dev, struct blk_user_trace_setup *buts);
+extern int do_blk_trace_setup(struct request_queue *q, char *name,
+			      dev_t dev, struct block_device *bdev,
+			      struct blk_user_trace_setup *buts);
 extern void __trace_note_message(struct blk_trace *, const char *fmt, ...);
 
 /**
@@ -193,6 +194,7 @@ extern void __trace_note_message(struct blk_trace *, const char *fmt, ...);
 extern void blk_add_driver_data(struct request_queue *q, struct request *rq,
 				void *data, size_t len);
 extern int blk_trace_setup(struct request_queue *q, char *name, dev_t dev,
+			   struct block_device *bdev,
 			   char __user *arg);
 extern int blk_trace_startstop(struct request_queue *q, int start);
 extern int blk_trace_remove(struct request_queue *q);
diff --git a/kernel/trace/blktrace.c b/kernel/trace/blktrace.c
index 2b98195..e932654 100644
--- a/kernel/trace/blktrace.c
+++ b/kernel/trace/blktrace.c
@@ -147,7 +147,7 @@ static int act_log_check(struct blk_trace *bt, u32 what, sector_t sector,
 {
 	if (((bt->act_mask << BLK_TC_SHIFT) & what) == 0)
 		return 1;
-	if (sector < bt->start_lba || sector > bt->end_lba)
+	if (sector && (sector < bt->start_lba || sector > bt->end_lba))
 		return 1;
 	if (bt->pid && pid != bt->pid)
 		return 1;
@@ -192,7 +192,7 @@ static void __blk_add_trace(struct blk_trace *bt, sector_t sector, int bytes,
 	what |= MASK_TC_BIT(rw, DISCARD);
 
 	pid = tsk->pid;
-	if (unlikely(act_log_check(bt, what, sector, pid)))
+	if (act_log_check(bt, what, sector, pid))
 		return;
 	cpu = raw_smp_processor_id();
 
@@ -407,11 +407,13 @@ static struct rchan_callbacks blk_relay_callbacks = {
  * Setup everything required to start tracing
  */
 int do_blk_trace_setup(struct request_queue *q, char *name, dev_t dev,
-			struct blk_user_trace_setup *buts)
+		       struct block_device *bdev,
+		       struct blk_user_trace_setup *buts)
 {
 	struct blk_trace *old_bt, *bt = NULL;
 	struct dentry *dir = NULL;
 	int ret, i;
+	struct hd_struct *part = NULL;
 
 	if (!buts->buf_size || !buts->buf_nr)
 		return -EINVAL;
@@ -480,11 +482,21 @@ int do_blk_trace_setup(struct request_queue *q, char *name, dev_t dev,
 	if (!bt->act_mask)
 		bt->act_mask = (u16) -1;
 
-	bt->start_lba = buts->start_lba;
-	bt->end_lba = buts->end_lba;
-	if (!bt->end_lba)
+	if (bdev)
+		part = bdev->bd_part;
+
+	if (part) {
+		bt->start_lba = part->start_sect;
+		bt->end_lba = part->start_sect + part->nr_sects;
+	} else
 		bt->end_lba = -1ULL;
 
+	/* overwrite with user settings */
+	if (buts->start_lba)
+		bt->start_lba = buts->start_lba;
+	if (buts->end_lba)
+		bt->end_lba = buts->end_lba;
+
 	bt->pid = buts->pid;
 	bt->trace_state = Blktrace_setup;
 
@@ -505,6 +517,7 @@ err:
 }
 
 int blk_trace_setup(struct request_queue *q, char *name, dev_t dev,
+		    struct block_device *bdev,
 		    char __user *arg)
 {
 	struct blk_user_trace_setup buts;
@@ -514,7 +527,7 @@ int blk_trace_setup(struct request_queue *q, char *name, dev_t dev,
 	if (ret)
 		return -EFAULT;
 
-	ret = do_blk_trace_setup(q, name, dev, &buts);
+	ret = do_blk_trace_setup(q, name, dev, bdev, &buts);
 	if (ret)
 		return ret;
 
@@ -582,7 +595,7 @@ int blk_trace_ioctl(struct block_device *bdev, unsigned cmd, char __user *arg)
 	switch (cmd) {
 	case BLKTRACESETUP:
 		bdevname(bdev, b);
-		ret = blk_trace_setup(q, b, bdev->bd_dev, arg);
+		ret = blk_trace_setup(q, b, bdev->bd_dev, bdev, arg);
 		break;
 	case BLKTRACESTART:
 		start = 1;
-- 
1.5.4.rc3
