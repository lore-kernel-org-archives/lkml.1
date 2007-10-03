Return-Path: <linux-kernel-owner+w=401wt.eu-S1758569AbXJCPzt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758569AbXJCPzt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2007 11:55:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754811AbXJCPzk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Oct 2007 11:55:40 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:63639 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754593AbXJCPzi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2007 11:55:38 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [PATCH] Fix blktrace setup 32-bit ioctl on 64-bit kernels
Date: Wed, 3 Oct 2007 17:55:20 +0200
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: linux-kernel@vger.kernel.org, abhishekrai@google.com,
       Linus Torvalds <torvalds@linux-foundation.org>, davem@davemloft.net
References: <20071002073943.GC5236@kernel.dk> <20071002083758.GD5236@kernel.dk> <20071002092856.GG5236@kernel.dk>
In-Reply-To: <20071002092856.GG5236@kernel.dk>
X-Face: >j"dOR3XO=^3iw?0`(E1w<L^(+[DJB_w&ik~>Z/&le9!.ok[JrI=S~VlsF~}"P\+jx.GT@=?utf-8?q?=0A=09-oaEG?=,9Ba>v;3>:kcw#yO5?B:l{(Ln.2)=?utf-8?q?=27=7Dfw07+4-=26=5E=7CScOpE=3F=5D=5EXdv=5B/zWkA7=60=25M!DxZ=0A=09?=
 =?utf-8?q?8MJ=2EU5?="hi+2yT(k`PF~Zt;tfT,i,JXf=x@eLP{7B:"GyA\=UnN)
 =?utf-8?q?=26=26qdaA=3A=7D-Y*=7D=3A3YvzV9=0A=09=7E=273a=7E7I=7CWQ=5D?=<50*%U-6Ewmxfzd<JV4tqSh>n/CK_E/ouMU(r?FAQG/ev^JyuX.%(By`"
 =?utf-8?q?L=5F=0A=09H=3Dbj?=)"y7*XOqz|SS"mrZ$`Q_syCd
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710031755.21068.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1+EdDvlX+iT/Al2bqEIVqIImEUJBE9orvetXZe
 ZOxr7PgeJnh8cmknNHffjf0kr1hPFNik0COue3jtzX2MjoIV5/
 B+d0KrScCvBJ38+LSLJxQ==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Here's my counterproposal for the blktrace compat code. It doesn't have
any of the problems I found in your patch obviously, but I haven't tested
it either, so I'm sure you can spot a bug or two in here. Comments?

Jens, I think the best overall solution would be to have a
block/compat_ioctl.c file with all the compat handling for block
devices moved over from fs/compat_ioctl.c, and done in a nicer way.
If you agree, with this approach, I'd volunteer to come up with a
patch.

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
+static int do_blk_trace_setup(struct request_queue *q, struct block_device *bdev,
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
@@ -474,6 +488,53 @@ int blk_trace_ioctl(struct block_device 
 	return ret;
 }
 
+#if defined(CONFIG_COMPAT)
+static inline int compat_blk_trace_setup(struct request_queue *q,
+			struct block_device *bdev, char __user *arg)
+{
+	struct blk_user_trace_setup buts;
+	struct compat_blk_user_trace_setup cbuts;
+	int ret;
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
+int compat_blk_trace_ioctl(struct block_device *bdev, unsigned cmd, char __user *arg)
+{
+
+	if (cmd == BLKTRACESETUP32) {
+		struct request_queue *q = bdev_get_queue(bdev);
+		if (!q)
+			return -ENXIO;
+		return compat_blk_trace_setup(q, bdev, arg);
+	}
+
+	return blk_trace_ioctl(bdev, cmd, arg);
+}
+#endif
+
 /**
  * blk_trace_shutdown: - stop and cleanup trace structures
  * @q:    the request queue associated with the device
Index: linux-2.6/block/ioctl.c
===================================================================
--- linux-2.6.orig/block/ioctl.c
+++ linux-2.6/block/ioctl.c
@@ -290,14 +290,25 @@ int blkdev_ioctl(struct inode *inode, st
    ENOIOCTLCMD for unknown ioctls. */
 long compat_blkdev_ioctl(struct file *file, unsigned cmd, unsigned long arg)
 {
+	int ret = -ENOIOCTLCMD;
+#ifdef CONFIG_COMPAT
 	struct block_device *bdev = file->f_path.dentry->d_inode->i_bdev;
 	struct gendisk *disk = bdev->bd_disk;
-	int ret = -ENOIOCTLCMD;
+
+	switch (cmd) {
+	case BLKTRACESTART:
+	case BLKTRACESTOP:
+	case BLKTRACESETUP32:
+	case BLKTRACETEARDOWN:
+		return blk_trace_ioctl(bdev, cmd, (char __user *) arg);
+	}
+
 	if (disk->fops->compat_ioctl) {
 		lock_kernel();
 		ret = disk->fops->compat_ioctl(file, cmd, arg);
 		unlock_kernel();
 	}
+#endif
 	return ret;
 }
 
Index: linux-2.6/include/linux/blktrace_api.h
===================================================================
--- linux-2.6.orig/include/linux/blktrace_api.h
+++ linux-2.6/include/linux/blktrace_api.h
@@ -142,6 +142,23 @@ struct blk_user_trace_setup {
 	u32 pid;
 };
 
+#ifdef __KERNEL__
+#include <linux/compat.h>
+
+#ifdef CONFIG_COMPAT
+struct compat_blk_user_trace_setup {
+	char name[32];
+	u16 act_mask;
+	u32 buf_size;
+	u32 buf_nr;
+	compat_u64 start_lba;
+	compat_u64 end_lba;
+	u32 pid;
+};
+#define BLKTRACESETUP32 _IOWR(0x12,115,struct compat_blk_user_trace_setup)
+
+#endif /* CONFIG_COMPAT */
+
 #if defined(CONFIG_BLK_DEV_IO_TRACE)
 extern int blk_trace_ioctl(struct block_device *, unsigned, char __user *);
 extern void blk_trace_shutdown(struct request_queue *);
@@ -287,5 +304,6 @@ static inline void blk_add_trace_remap(s
 #define blk_add_trace_pdu_int(q, what, bio, pdu)	do { } while (0)
 #define blk_add_trace_remap(q, bio, dev, f, t)	do {} while (0)
 #endif /* CONFIG_BLK_DEV_IO_TRACE */
+#endif /* __KERNEL__ */
 
 #endif
Index: linux-2.6/fs/compat_ioctl.c
===================================================================
--- linux-2.6.orig/fs/compat_ioctl.c
+++ linux-2.6/fs/compat_ioctl.c
@@ -2553,10 +2553,6 @@ COMPATIBLE_IOCTL(BLKRRPART)
 COMPATIBLE_IOCTL(BLKFLSBUF)
 COMPATIBLE_IOCTL(BLKSECTSET)
 COMPATIBLE_IOCTL(BLKSSZGET)
-COMPATIBLE_IOCTL(BLKTRACESTART)
-COMPATIBLE_IOCTL(BLKTRACESTOP)
-COMPATIBLE_IOCTL(BLKTRACESETUP)
-COMPATIBLE_IOCTL(BLKTRACETEARDOWN)
 ULONG_IOCTL(BLKRASET)
 ULONG_IOCTL(BLKFRASET)
 #endif
