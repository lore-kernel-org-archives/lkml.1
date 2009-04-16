Return-Path: <linux-kernel-owner+w=401wt.eu-S1757498AbZDPQQV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757498AbZDPQQV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Apr 2009 12:16:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755711AbZDPQQK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Apr 2009 12:16:10 -0400
Received: from hera.kernel.org ([140.211.167.34]:54430 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752943AbZDPQQI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Apr 2009 12:16:08 -0400
Date: Thu, 16 Apr 2009 16:15:19 GMT
From: tip-bot for Shawn Du <duyuyang@gmail.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, hpa@zytor.com,
       mingo@redhat.com, lizf@cn.fujitsu.com, tytso@mit.edu,
       jens.axboe@oracle.com, duyuyang@gmail.com, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, acme@redhat.com,
       linux-kernel@vger.kernel.org, lizf@cn.fujitsu.com, tytso@mit.edu,
       jens.axboe@oracle.com, duyuyang@gmail.com, tglx@linutronix.de,
       mingo@elte.hu
In-Reply-To: <49E42620.4050701@cn.fujitsu.com>
References: <49E42620.4050701@cn.fujitsu.com>
Subject: [tip:tracing/core] blktrace: support per-partition tracing
Message-ID: <tip-d0deef5b14af7d5bbd0003a0a2a1a32326e20a6d@git.kernel.org>
Git-Commit-ID: d0deef5b14af7d5bbd0003a0a2a1a32326e20a6d
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Thu, 16 Apr 2009 16:15:21 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  d0deef5b14af7d5bbd0003a0a2a1a32326e20a6d
Gitweb:     http://git.kernel.org/tip/d0deef5b14af7d5bbd0003a0a2a1a32326e20a6d
Author:     Shawn Du <duyuyang@gmail.com>
AuthorDate: Tue, 14 Apr 2009 13:58:56 +0800
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 16 Apr 2009 10:10:57 +0200

blktrace: support per-partition tracing

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
Acked-by: "Theodore Ts'o" <tytso@mit.edu>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Jens Axboe <jens.axboe@oracle.com>
LKML-Reference: <49E42620.4050701@cn.fujitsu.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 block/compat_ioctl.c         |    2 +-
 drivers/scsi/sg.c            |    1 +
 include/linux/blktrace_api.h |   24 +++++++++++++-----------
 kernel/trace/blktrace.c      |   29 +++++++++++++++++++++--------
 4 files changed, 36 insertions(+), 20 deletions(-)

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
index d960889..267edc4 100644
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
@@ -200,15 +202,15 @@ extern int blk_trace_remove(struct request_queue *q);
 extern struct attribute_group blk_trace_attr_group;
 
 #else /* !CONFIG_BLK_DEV_IO_TRACE */
-#define blk_trace_ioctl(bdev, cmd, arg)		(-ENOTTY)
-#define blk_trace_shutdown(q)			do { } while (0)
-#define do_blk_trace_setup(q, name, dev, buts)	(-ENOTTY)
-#define blk_add_driver_data(q, rq, data, len)	do {} while (0)
-#define blk_trace_setup(q, name, dev, arg)	(-ENOTTY)
-#define blk_trace_startstop(q, start)		(-ENOTTY)
-#define blk_trace_remove(q)			(-ENOTTY)
-#define blk_add_trace_msg(q, fmt, ...)		do { } while (0)
-
+# define blk_trace_ioctl(bdev, cmd, arg)		(-ENOTTY)
+# define blk_trace_shutdown(q)				do { } while (0)
+# define do_blk_trace_setup(q, name, dev, bdev, buts)	(-ENOTTY)
+# define blk_add_driver_data(q, rq, data, len)		do {} while (0)
+# define blk_trace_setup(q, name, dev, bdev, arg)	(-ENOTTY)
+# define blk_trace_startstop(q, start)			(-ENOTTY)
+# define blk_trace_remove(q)				(-ENOTTY)
+# define blk_add_trace_msg(q, fmt, ...)			do { } while (0)
 #endif /* CONFIG_BLK_DEV_IO_TRACE */
+
 #endif /* __KERNEL__ */
 #endif
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
