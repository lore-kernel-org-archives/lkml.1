Return-Path: <linux-kernel-owner+w=401wt.eu-S1765008AbXJFSbw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765008AbXJFSbw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Oct 2007 14:31:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764971AbXJFSbA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 6 Oct 2007 14:31:00 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:58809 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764956AbXJFSa5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Oct 2007 14:30:57 -0400
Message-Id: <20071006182342.881981486@arndb.de>
References: <20071006181902.141862534@arndb.de>
User-Agent: quilt/0.46-1
Date: Sat, 06 Oct 2007 20:19:05 +0200
From: Arnd Bergmann <arnd@arndb.de>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: linux-kernel@vger.kernel.org, davem@davemloft.net, hch@lst.de,
       Al Viro <viro@ftp.linux.org.uk>
Subject: [patch 3/9] compat_ioctl: handle blk_trace ioctls
Content-Disposition: inline; filename=compat-blktrace.diff
X-Provags-ID: V01U2FsdGVkX18pw40q3n2J5WluL8/dWLax3G4vRGe6NIq/MVN
 tzKuae2QD+jgNxw0qjDcllBwLavTAhY8+5f9lWIaugllI4fdo6
 BFYGJ82X5Qbn5s5qciJPg==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

blk_trace_setup is broken on x86_64 compat systems,
this makes the code work correctly on all 64 bit architectures
in compat mode.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Index: linux-2.6/block/blktrace.c
===================================================================
--- linux-2.6.orig/block/blktrace.c
+++ linux-2.6/block/blktrace.c
@@ -312,33 +312,26 @@ static struct rchan_callbacks blk_relay_
 /*
  * Setup everything required to start tracing
  */
-static int blk_trace_setup(struct request_queue *q, struct block_device *bdev,
-			   char __user *arg)
+int do_blk_trace_setup(struct request_queue *q, struct block_device *bdev,
+			struct blk_user_trace_setup *buts)
 {
-	struct blk_user_trace_setup buts;
 	struct blk_trace *old_bt, *bt = NULL;
 	struct dentry *dir = NULL;
 	char b[BDEVNAME_SIZE];
 	int ret, i;
 
-	if (copy_from_user(&buts, arg, sizeof(buts)))
-		return -EFAULT;
-
-	if (!buts.buf_size || !buts.buf_nr)
+	if (!buts->buf_size || !buts->buf_nr)
 		return -EINVAL;
 
-	strcpy(buts.name, bdevname(bdev, b));
+	strcpy(buts->name, bdevname(bdev, b));
 
 	/*
 	 * some device names have larger paths - convert the slashes
 	 * to underscores for this to work as expected
 	 */
-	for (i = 0; i < strlen(buts.name); i++)
-		if (buts.name[i] == '/')
-			buts.name[i] = '_';
-
-	if (copy_to_user(arg, &buts, sizeof(buts)))
-		return -EFAULT;
+	for (i = 0; i < strlen(buts->name); i++)
+		if (buts->name[i] == '/')
+			buts->name[i] = '_';
 
 	ret = -ENOMEM;
 	bt = kzalloc(sizeof(*bt), GFP_KERNEL);
@@ -350,7 +343,7 @@ static int blk_trace_setup(struct reques
 		goto err;
 
 	ret = -ENOENT;
-	dir = blk_create_tree(buts.name);
+	dir = blk_create_tree(buts->name);
 	if (!dir)
 		goto err;
 
@@ -363,20 +356,21 @@ static int blk_trace_setup(struct reques
 	if (!bt->dropped_file)
 		goto err;
 
-	bt->rchan = relay_open("trace", dir, buts.buf_size, buts.buf_nr, &blk_relay_callbacks, bt);
+	bt->rchan = relay_open("trace", dir, buts->buf_size,
+				buts->buf_nr, &blk_relay_callbacks, bt);
 	if (!bt->rchan)
 		goto err;
 
-	bt->act_mask = buts.act_mask;
+	bt->act_mask = buts->act_mask;
 	if (!bt->act_mask)
 		bt->act_mask = (u16) -1;
 
-	bt->start_lba = buts.start_lba;
-	bt->end_lba = buts.end_lba;
+	bt->start_lba = buts->start_lba;
+	bt->end_lba = buts->end_lba;
 	if (!bt->end_lba)
 		bt->end_lba = -1ULL;
 
-	bt->pid = buts.pid;
+	bt->pid = buts->pid;
 	bt->trace_state = Blktrace_setup;
 
 	ret = -EBUSY;
@@ -401,6 +395,26 @@ err:
 	return ret;
 }
 
+static int blk_trace_setup(struct request_queue *q, struct block_device *bdev,
+			   char __user *arg)
+{
+	struct blk_user_trace_setup buts;
+	int ret;
+
+	ret = copy_from_user(&buts, arg, sizeof(buts));
+	if (ret)
+		return -EFAULT;
+
+	ret = do_blk_trace_setup(q, bdev, &buts);
+	if (ret)
+		return ret;
+
+	if (copy_to_user(arg, &buts, sizeof(buts)))
+		return -EFAULT;
+
+	return 0;
+}
+
 static int blk_trace_startstop(struct request_queue *q, int start)
 {
 	struct blk_trace *bt;
Index: linux-2.6/block/compat_ioctl.c
===================================================================
--- linux-2.6.orig/block/compat_ioctl.c
+++ linux-2.6/block/compat_ioctl.c
@@ -40,6 +40,53 @@ static int compat_put_u64(unsigned long 
 #define BLKBSZSET_32		_IOW(0x12, 113, int)
 #define BLKGETSIZE64_32		_IOR(0x12, 114, int)
 
+struct compat_blk_user_trace_setup {
+	char name[32];
+	u16 act_mask;
+	u32 buf_size;
+	u32 buf_nr;
+	compat_u64 start_lba;
+	compat_u64 end_lba;
+	u32 pid;
+};
+#define BLKTRACESETUP32 _IOWR(0x12, 115, struct compat_blk_user_trace_setup)
+
+static int compat_blk_trace_setup(struct block_device *bdev, char __user *arg)
+{
+	struct blk_user_trace_setup buts;
+	struct compat_blk_user_trace_setup cbuts;
+	struct request_queue *q;
+	int ret;
+
+	q = bdev_get_queue(bdev);
+	if (!q)
+		return -ENXIO;
+
+	if (copy_from_user(&cbuts, arg, sizeof(cbuts)))
+		return -EFAULT;
+
+	buts = (struct blk_user_trace_setup) {
+		.act_mask = cbuts.act_mask,
+		.buf_size = cbuts.buf_size,
+		.buf_nr = cbuts.buf_nr,
+		.start_lba = cbuts.start_lba,
+		.end_lba = cbuts.end_lba,
+		.pid = cbuts.pid,
+	};
+	memcpy(&buts.name, &cbuts.name, 32);
+
+	mutex_lock(&bdev->bd_mutex);
+	ret = do_blk_trace_setup(q, bdev, &buts);
+	mutex_unlock(&bdev->bd_mutex);
+	if (ret)
+		return ret;
+
+	if (copy_to_user(arg, &buts.name, 32))
+		return -EFAULT;
+
+	return 0;
+}
+
 static int compat_blkdev_driver_ioctl(struct inode *inode, struct file *file,
 			struct gendisk *disk, unsigned cmd, unsigned long arg)
 {
@@ -199,6 +246,13 @@ static int compat_blkdev_locked_ioctl(st
 
 	case BLKGETSIZE64_32:
 		return compat_put_u64(arg, bdev->bd_inode->i_size);
+
+	case BLKTRACESETUP32:
+		return compat_blk_trace_setup(bdev, compat_ptr(arg));
+	case BLKTRACESTART: /* compatible */
+	case BLKTRACESTOP:  /* compatible */
+	case BLKTRACETEARDOWN: /* compatible */
+		return blk_trace_ioctl(bdev, cmd, compat_ptr(arg));
 	}
 	return -ENOIOCTLCMD;
 }
Index: linux-2.6/fs/compat_ioctl.c
===================================================================
--- linux-2.6.orig/fs/compat_ioctl.c
+++ linux-2.6/fs/compat_ioctl.c
@@ -62,7 +62,6 @@
 #include <linux/i2c-dev.h>
 #include <linux/wireless.h>
 #include <linux/atalk.h>
-#include <linux/blktrace_api.h>
 #include <linux/loop.h>
 
 #include <net/bluetooth/bluetooth.h>
@@ -2477,13 +2476,6 @@ COMPATIBLE_IOCTL(FIONREAD)  /* This is a
 /* 0x00 */
 COMPATIBLE_IOCTL(FIBMAP)
 COMPATIBLE_IOCTL(FIGETBSZ)
-/* 0x12 */
-#ifdef CONFIG_BLOCK
-COMPATIBLE_IOCTL(BLKTRACESTART)
-COMPATIBLE_IOCTL(BLKTRACESTOP)
-COMPATIBLE_IOCTL(BLKTRACESETUP)
-COMPATIBLE_IOCTL(BLKTRACETEARDOWN)
-#endif
 /* RAID */
 COMPATIBLE_IOCTL(RAID_VERSION)
 COMPATIBLE_IOCTL(GET_ARRAY_INFO)
Index: linux-2.6/include/linux/blktrace_api.h
===================================================================
--- linux-2.6.orig/include/linux/blktrace_api.h
+++ linux-2.6/include/linux/blktrace_api.h
@@ -142,10 +142,14 @@ struct blk_user_trace_setup {
 	u32 pid;
 };
 
+#ifdef __KERNEL__
 #if defined(CONFIG_BLK_DEV_IO_TRACE)
 extern int blk_trace_ioctl(struct block_device *, unsigned, char __user *);
 extern void blk_trace_shutdown(struct request_queue *);
 extern void __blk_add_trace(struct blk_trace *, sector_t, int, int, u32, int, int, void *);
+extern int do_blk_trace_setup(struct request_queue *q,
+	struct block_device *bdev, struct blk_user_trace_setup *buts);
+
 
 /**
  * blk_add_trace_rq - Add a trace for a request oriented action
@@ -286,6 +290,7 @@ static inline void blk_add_trace_remap(s
 #define blk_add_trace_generic(q, rq, rw, what)	do { } while (0)
 #define blk_add_trace_pdu_int(q, what, bio, pdu)	do { } while (0)
 #define blk_add_trace_remap(q, bio, dev, f, t)	do {} while (0)
+#define do_blk_trace_setup(q, bdev, buts)	do {} while (0)
 #endif /* CONFIG_BLK_DEV_IO_TRACE */
-
+#endif /* __KERNEL__ */
 #endif

-- 

