Return-Path: <linux-kernel-owner+w=401wt.eu-S1755688AbXF3D11@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755688AbXF3D11 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jun 2007 23:27:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754009AbXF3DZe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jun 2007 23:25:34 -0400
Received: from e3.ny.us.ibm.com ([32.97.182.143]:34413 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755488AbXF3DZc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jun 2007 23:25:32 -0400
Subject: [RFC PATCH 3/3] blktrace conversion to GTSC
From: Tom Zanussi <zanussi@us.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: adobriyan@gmail.com, dwilder@us.ibm.com, hunt@redhat.com
Content-Type: text/plain
Date: Fri, 29 Jun 2007 22:24:38 -0500
Message-Id: <1183173878.24291.145.camel@ubuntu>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch converts blktrace to use the Generic Trace Setup and
Control (GTSC) interface.  Also attached is a small patch to the
blktrace user code, needed for the ioctl change.

Signed-off-by: Tom Zanussi <zanussi@us.ibm.com>
Signed-off-by: David Wilder <dwilder@us.ibm.com>
---
 block/Kconfig                |    2 
 block/blktrace.c             |  188 +++++--------------------------------------
 include/linux/blktrace_api.h |   30 +++---
 3 files changed, 40 insertions(+), 180 deletions(-)

diff --git a/block/Kconfig b/block/Kconfig
index a50f481..9ae9a8c 100644
--- a/block/Kconfig
+++ b/block/Kconfig
@@ -30,7 +30,7 @@ config LBD
 config BLK_DEV_IO_TRACE
 	bool "Support for tracing block io actions"
 	depends on SYSFS
-	select RELAY
+	select GTSC
 	select DEBUG_FS
 	help
 	  Say Y here, if you want to be able to trace the block layer actions
diff --git a/block/blktrace.c b/block/blktrace.c
index 3f0e7c3..c5d5821 100644
--- a/block/blktrace.c
+++ b/block/blktrace.c
@@ -36,7 +36,7 @@ static void trace_note(struct blk_trace *bt, pid_t pid, int action,
 {
 	struct blk_io_trace *t;
 
-	t = relay_reserve(bt->rchan, sizeof(*t) + len);
+	t = relay_reserve(bt->trace->rchan, sizeof(*t) + len);
 	if (t) {
 		const int cpu = smp_processor_id();
 
@@ -126,7 +126,7 @@ void __blk_add_trace(struct blk_trace *bt, sector_t sector, int bytes,
 	pid_t pid;
 	int cpu;
 
-	if (unlikely(bt->trace_state != Blktrace_running))
+	if (unlikely(!trace_running(bt->trace)))
 		return;
 
 	what |= ddir_act[rw & WRITE];
@@ -152,7 +152,7 @@ void __blk_add_trace(struct blk_trace *bt, sector_t sector, int bytes,
 	if (unlikely(tsk->btrace_seq != blktrace_seq))
 		trace_note_tsk(bt, tsk);
 
-	t = relay_reserve(bt->rchan, sizeof(*t) + pdu_len);
+	t = relay_reserve(bt->trace->rchan, sizeof(*t) + pdu_len);
 	if (t) {
 		cpu = smp_processor_id();
 		sequence = per_cpu_ptr(bt->sequence, cpu);
@@ -178,55 +178,8 @@ void __blk_add_trace(struct blk_trace *bt, sector_t sector, int bytes,
 
 EXPORT_SYMBOL_GPL(__blk_add_trace);
 
-static struct dentry *blk_tree_root;
-static struct mutex blk_tree_mutex;
-static unsigned int root_users;
-
-static inline void blk_remove_root(void)
-{
-	if (blk_tree_root) {
-		debugfs_remove(blk_tree_root);
-		blk_tree_root = NULL;
-	}
-}
-
-static void blk_remove_tree(struct dentry *dir)
-{
-	mutex_lock(&blk_tree_mutex);
-	debugfs_remove(dir);
-	if (--root_users == 0)
-		blk_remove_root();
-	mutex_unlock(&blk_tree_mutex);
-}
-
-static struct dentry *blk_create_tree(const char *blk_name)
-{
-	struct dentry *dir = NULL;
-
-	mutex_lock(&blk_tree_mutex);
-
-	if (!blk_tree_root) {
-		blk_tree_root = debugfs_create_dir("block", NULL);
-		if (!blk_tree_root)
-			goto err;
-	}
-
-	dir = debugfs_create_dir(blk_name, blk_tree_root);
-	if (dir)
-		root_users++;
-	else
-		blk_remove_root();
-
-err:
-	mutex_unlock(&blk_tree_mutex);
-	return dir;
-}
-
 static void blk_trace_cleanup(struct blk_trace *bt)
 {
-	relay_close(bt->rchan);
-	debugfs_remove(bt->dropped_file);
-	blk_remove_tree(bt->dir);
 	free_percpu(bt->sequence);
 	kfree(bt);
 }
@@ -239,76 +192,14 @@ static int blk_trace_remove(request_queue_t *q)
 	if (!bt)
 		return -EINVAL;
 
-	if (bt->trace_state == Blktrace_setup ||
-	    bt->trace_state == Blktrace_stopped)
+	if (!trace_running(bt->trace)) {
+		trace_cleanup(bt->trace);
 		blk_trace_cleanup(bt);
+	}
 
 	return 0;
 }
 
-static int blk_dropped_open(struct inode *inode, struct file *filp)
-{
-	filp->private_data = inode->i_private;
-
-	return 0;
-}
-
-static ssize_t blk_dropped_read(struct file *filp, char __user *buffer,
-				size_t count, loff_t *ppos)
-{
-	struct blk_trace *bt = filp->private_data;
-	char buf[16];
-
-	snprintf(buf, sizeof(buf), "%u\n", atomic_read(&bt->dropped));
-
-	return simple_read_from_buffer(buffer, count, ppos, buf, strlen(buf));
-}
-
-static const struct file_operations blk_dropped_fops = {
-	.owner =	THIS_MODULE,
-	.open =		blk_dropped_open,
-	.read =		blk_dropped_read,
-};
-
-/*
- * Keep track of how many times we encountered a full subbuffer, to aid
- * the user space app in telling how many lost events there were.
- */
-static int blk_subbuf_start_callback(struct rchan_buf *buf, void *subbuf,
-				     void *prev_subbuf, size_t prev_padding)
-{
-	struct blk_trace *bt;
-
-	if (!relay_buf_full(buf))
-		return 1;
-
-	bt = buf->chan->private_data;
-	atomic_inc(&bt->dropped);
-	return 0;
-}
-
-static int blk_remove_buf_file_callback(struct dentry *dentry)
-{
-	debugfs_remove(dentry);
-	return 0;
-}
-
-static struct dentry *blk_create_buf_file_callback(const char *filename,
-						   struct dentry *parent,
-						   int mode,
-						   struct rchan_buf *buf,
-						   int *is_global)
-{
-	return debugfs_create_file(filename, mode, parent, buf,
-					&relay_file_operations);
-}
-
-static struct rchan_callbacks blk_relay_callbacks = {
-	.subbuf_start		= blk_subbuf_start_callback,
-	.create_buf_file	= blk_create_buf_file_callback,
-	.remove_buf_file	= blk_remove_buf_file_callback,
-};
-
 /*
  * Setup everything required to start tracing
  */
@@ -317,25 +208,23 @@ static int blk_trace_setup(request_queue_t *q, struct block_device *bdev,
 {
 	struct blk_user_trace_setup buts;
 	struct blk_trace *old_bt, *bt = NULL;
-	struct dentry *dir = NULL;
 	char b[BDEVNAME_SIZE];
 	int ret, i;
+	struct gtsc_trace_setup *gts = &buts.gts;
 
 	if (copy_from_user(&buts, arg, sizeof(buts)))
 		return -EFAULT;
 
-	if (!buts.buf_size || !buts.buf_nr)
-		return -EINVAL;
-
-	strcpy(buts.name, bdevname(bdev, b));
+	strcpy(gts->root, "block");
+	strcpy(gts->name, bdevname(bdev, b));
 
 	/*
 	 * some device names have larger paths - convert the slashes
 	 * to underscores for this to work as expected
 	 */
-	for (i = 0; i < strlen(buts.name); i++)
-		if (buts.name[i] == '/')
-			buts.name[i] = '_';
+	for (i = 0; i < strlen(gts->name); i++)
+		if (gts->name[i] == '/')
+			gts->name[i] = '_';
 
 	if (copy_to_user(arg, &buts, sizeof(buts)))
 		return -EFAULT;
@@ -349,23 +238,12 @@ static int blk_trace_setup(request_queue_t *q, struct block_device *bdev,
 	if (!bt->sequence)
 		goto err;
 
-	ret = -ENOENT;
-	dir = blk_create_tree(buts.name);
-	if (!dir)
+	bt->trace = trace_setup(gts->root, gts->name, gts->buf_size,
+				gts->buf_nr, 0);
+	if (!bt->trace)
 		goto err;
 
-	bt->dir = dir;
 	bt->dev = bdev->bd_dev;
-	atomic_set(&bt->dropped, 0);
-
-	ret = -EIO;
-	bt->dropped_file = debugfs_create_file("dropped", 0444, dir, bt, &blk_dropped_fops);
-	if (!bt->dropped_file)
-		goto err;
-
-	bt->rchan = relay_open("trace", dir, buts.buf_size, buts.buf_nr, &blk_relay_callbacks, bt);
-	if (!bt->rchan)
-		goto err;
 
 	bt->act_mask = buts.act_mask;
 	if (!bt->act_mask)
@@ -377,7 +255,6 @@ static int blk_trace_setup(request_queue_t *q, struct block_device *bdev,
 		bt->end_lba = -1ULL;
 
 	bt->pid = buts.pid;
-	bt->trace_state = Blktrace_setup;
 
 	ret = -EBUSY;
 	old_bt = xchg(&q->blk_trace, bt);
@@ -388,14 +265,10 @@ static int blk_trace_setup(request_queue_t *q, struct block_device *bdev,
 
 	return 0;
 err:
-	if (dir)
-		blk_remove_tree(dir);
 	if (bt) {
-		if (bt->dropped_file)
-			debugfs_remove(bt->dropped_file);
 		free_percpu(bt->sequence);
-		if (bt->rchan)
-			relay_close(bt->rchan);
+		if (bt->trace)
+			trace_cleanup(bt->trace);
 		kfree(bt);
 	}
 	return ret;
@@ -404,33 +277,21 @@ err:
 static int blk_trace_startstop(request_queue_t *q, int start)
 {
 	struct blk_trace *bt;
-	int ret;
+	int ret = 0;
 
 	if ((bt = q->blk_trace) == NULL)
 		return -EINVAL;
 
-	/*
-	 * For starting a trace, we can transition from a setup or stopped
-	 * trace. For stopping a trace, the state must be running
-	 */
-	ret = -EINVAL;
 	if (start) {
-		if (bt->trace_state == Blktrace_setup ||
-		    bt->trace_state == Blktrace_stopped) {
+		if (!trace_running(bt->trace)) {
 			blktrace_seq++;
 			smp_mb();
-			bt->trace_state = Blktrace_running;
-
-			trace_note_time(bt);
-			ret = 0;
-		}
-	} else {
-		if (bt->trace_state == Blktrace_running) {
-			bt->trace_state = Blktrace_stopped;
-			relay_flush(bt->rchan);
-			ret = 0;
+			ret = trace_start(bt->trace);
+			if (!ret)
+				trace_note_time(bt);
 		}
-	}
+	} else
+		ret = trace_stop(bt->trace);
 
 	return ret;
 }
@@ -551,7 +412,6 @@ static void blk_trace_set_ht_offsets(void)
 
 static __init int blk_trace_init(void)
 {
-	mutex_init(&blk_tree_mutex);
 	on_each_cpu(blk_trace_check_cpu_time, NULL, 1, 1);
 	blk_trace_set_ht_offsets();
 
diff --git a/include/linux/blktrace_api.h b/include/linux/blktrace_api.h
index 3680ff9..875323e 100644
--- a/include/linux/blktrace_api.h
+++ b/include/linux/blktrace_api.h
@@ -2,7 +2,7 @@
 #define BLKTRACE_H
 
 #include <linux/blkdev.h>
-#include <linux/relay.h>
+#include <linux/gtsc.h>
 
 /*
  * Trace categories
@@ -109,34 +109,34 @@ struct blk_io_trace_remap {
 	__be64 sector;
 };
 
-enum {
-	Blktrace_setup = 1,
-	Blktrace_running,
-	Blktrace_stopped,
-};
-
 struct blk_trace {
-	int trace_state;
-	struct rchan *rchan;
+	struct trace_info *trace;
 	unsigned long *sequence;
 	u16 act_mask;
 	u64 start_lba;
 	u64 end_lba;
 	u32 pid;
 	u32 dev;
-	struct dentry *dir;
-	struct dentry *dropped_file;
-	atomic_t dropped;
+};
+
+/*
+ * User setup structure
+ */
+struct gtsc_trace_setup 
+{
+	char root[TRACE_ROOT_NAME_SIZE];
+	char name[TRACE_NAME_SIZE];
+	u32 buf_size;
+	u32 buf_nr;
+	u32 flags;
 };
 
 /*
  * User setup structure passed with BLKTRACESTART
  */
 struct blk_user_trace_setup {
-	char name[BDEVNAME_SIZE];	/* output */
+	struct gtsc_trace_setup gts;	/* input */
 	u16 act_mask;			/* input */
-	u32 buf_size;			/* input */
-	u32 buf_nr;			/* input */
 	u64 start_lba;
 	u64 end_lba;
 	u32 pid;



