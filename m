Return-Path: <linux-kernel-owner+w=401wt.eu-S1757571AbYFEMVR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757571AbYFEMVR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2008 08:21:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756137AbYFEMVH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jun 2008 08:21:07 -0400
Received: from g4t0015.houston.hp.com ([15.201.24.18]:11762 "EHLO
	g4t0015.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754760AbYFEMVG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2008 08:21:06 -0400
Message-ID: <4847DA2D.3030603@hp.com>
Date: Thu, 05 Jun 2008 08:21:01 -0400
From: "Alan D. Brunelle" <Alan.Brunelle@hp.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080505)
MIME-Version: 1.0
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: Jens Axboe <jens.axboe@oracle.com>
Subject: [PATCH] Added in user-injected messages into blk traces
Content-Type: multipart/mixed;
 boundary="------------060602030209050203020209"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------060602030209050203020209
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit


--------------060602030209050203020209
Content-Type: text/x-diff;
 name="0001-Added-in-user-injected-messages-into-blk-traces.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename*0="0001-Added-in-user-injected-messages-into-blk-traces.patch"

This allows a user to annotate the blk trace stream: writing a suitable
message to {/sys/kernel/debug}/block/<dsf>/msg will have it propagated
into the trace stream.

Signed-off-by: Alan D. Brunelle <alan.brunelle@hp.com>
---
 block/blktrace.c             |   42 ++++++++++++++++++++++++++++++++++++++++++
 include/linux/blktrace_api.h |    1 +
 2 files changed, 43 insertions(+), 0 deletions(-)

diff --git a/block/blktrace.c b/block/blktrace.c
index 38e6b83..b9c4df2 100644
--- a/block/blktrace.c
+++ b/block/blktrace.c
@@ -253,6 +253,7 @@ err:
 static void blk_trace_cleanup(struct blk_trace *bt)
 {
 	relay_close(bt->rchan);
+	debugfs_remove(bt->msg_file);
 	debugfs_remove(bt->dropped_file);
 	blk_remove_tree(bt->dir);
 	free_percpu(bt->sequence);
@@ -299,6 +300,41 @@ static const struct file_operations blk_dropped_fops = {
 	.read =		blk_dropped_read,
 };
 
+static int blk_msg_open(struct inode *inode, struct file *filp)
+{
+	filp->private_data = inode->i_private;
+
+	return 0;
+}
+
+static ssize_t blk_msg_write(struct file *filp, const char __user *buffer,
+				size_t count, loff_t *ppos)
+{
+	ssize_t ret = count;
+
+	if (count > BLK_TN_MAX_MSG)
+		ret = -EINVAL;
+	else {
+		char *msg = kmalloc(BLK_TN_MAX_MSG, GFP_KERNEL);
+
+		if (copy_from_user(msg, buffer, count))
+			ret = -EFAULT;
+		else {
+			struct blk_trace *bt = filp->private_data;
+			__trace_note_message(bt, "%s", msg);
+		}
+		kfree(msg);
+	}
+
+	return ret;
+}
+
+static const struct file_operations blk_msg_fops = {
+	.owner =	THIS_MODULE,
+	.open =		blk_msg_open,
+	.write =	blk_msg_write,
+};
+
 /*
  * Keep track of how many times we encountered a full subbuffer, to aid
  * the user space app in telling how many lost events there were.
@@ -384,6 +420,10 @@ int do_blk_trace_setup(struct request_queue *q, char *name, dev_t dev,
 	if (!bt->dropped_file)
 		goto err;
 
+	bt->msg_file = debugfs_create_file("msg", 0222, dir, bt, &blk_msg_fops);
+	if (!bt->msg_file)
+		goto err;
+
 	bt->rchan = relay_open("trace", dir, buts->buf_size,
 				buts->buf_nr, &blk_relay_callbacks, bt);
 	if (!bt->rchan)
@@ -413,6 +453,8 @@ err:
 	if (dir)
 		blk_remove_tree(dir);
 	if (bt) {
+		if (bt->msg_file)
+			debugfs_remove(bt->msg_file);
 		if (bt->dropped_file)
 			debugfs_remove(bt->dropped_file);
 		free_percpu(bt->sequence);
diff --git a/include/linux/blktrace_api.h b/include/linux/blktrace_api.h
index 3228caa..41208f1 100644
--- a/include/linux/blktrace_api.h
+++ b/include/linux/blktrace_api.h
@@ -128,6 +128,7 @@ struct blk_trace {
 	u32 dev;
 	struct dentry *dir;
 	struct dentry *dropped_file;
+	struct dentry *msg_file;
 	atomic_t dropped;
 };
 
-- 
1.5.4.3


--------------060602030209050203020209--
