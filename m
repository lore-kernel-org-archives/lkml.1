Return-Path: <linux-kernel-owner+w=401wt.eu-S1755397AbYFFMYM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755397AbYFFMYM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2008 08:24:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753299AbYFFMX4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jun 2008 08:23:56 -0400
Received: from g1t0026.austin.hp.com ([15.216.28.33]:26550 "EHLO
	g1t0026.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752986AbYFFMXz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2008 08:23:55 -0400
Message-ID: <48492C56.3010801@hp.com>
Date: Fri, 06 Jun 2008 08:23:50 -0400
From: "Alan D. Brunelle" <Alan.Brunelle@hp.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080505)
MIME-Version: 1.0
To: Jens Axboe <jens.axboe@oracle.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH] Added in user-injected messages into blk traces
References: <4847DA2D.3030603@hp.com> <20080606092423.GN5757@kernel.dk>
In-Reply-To: <20080606092423.GN5757@kernel.dk>
Content-Type: multipart/mixed;
 boundary="------------070705090203070107080106"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------070705090203070107080106
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit



--------------070705090203070107080106
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
 block/blktrace.c             |   45 ++++++++++++++++++++++++++++++++++++++++++
 include/linux/blktrace_api.h |    1 +
 2 files changed, 46 insertions(+), 0 deletions(-)

diff --git a/block/blktrace.c b/block/blktrace.c
index 7ae87cc..63ed9cf 100644
--- a/block/blktrace.c
+++ b/block/blktrace.c
@@ -246,6 +246,7 @@ err:
 static void blk_trace_cleanup(struct blk_trace *bt)
 {
 	relay_close(bt->rchan);
+	debugfs_remove(bt->msg_file);
 	debugfs_remove(bt->dropped_file);
 	blk_remove_tree(bt->dir);
 	free_percpu(bt->sequence);
@@ -293,6 +294,44 @@ static const struct file_operations blk_dropped_fops = {
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
+	char *msg;
+	struct blk_trace *bt;
+
+	if (count > BLK_TN_MAX_MSG)
+		return -EINVAL;
+
+	msg = kmalloc(count, GFP_KERNEL);
+	if (msg == NULL)
+		return -ENOMEM;
+
+	if (copy_from_user(msg, buffer, count)) {
+		kfree(msg);
+		return -EFAULT;
+	}
+
+	bt = filp->private_data;
+	__trace_note_message(bt, "%s", msg);
+	kfree(msg);
+
+	return count;
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
@@ -382,6 +421,10 @@ int do_blk_trace_setup(struct request_queue *q, char *name, dev_t dev,
 	if (!bt->dropped_file)
 		goto err;
 
+	bt->msg_file = debugfs_create_file("msg", 0222, dir, bt, &blk_msg_fops);
+	if (!bt->msg_file)
+		goto err;
+
 	bt->rchan = relay_open("trace", dir, buts->buf_size,
 				buts->buf_nr, &blk_relay_callbacks, bt);
 	if (!bt->rchan)
@@ -411,6 +454,8 @@ err:
 	if (dir)
 		blk_remove_tree(dir);
 	if (bt) {
+		if (bt->msg_file)
+			debugfs_remove(bt->msg_file);
 		if (bt->dropped_file)
 			debugfs_remove(bt->dropped_file);
 		free_percpu(bt->sequence);
diff --git a/include/linux/blktrace_api.h b/include/linux/blktrace_api.h
index e3ef903..d084b8d 100644
--- a/include/linux/blktrace_api.h
+++ b/include/linux/blktrace_api.h
@@ -129,6 +129,7 @@ struct blk_trace {
 	u32 dev;
 	struct dentry *dir;
 	struct dentry *dropped_file;
+	struct dentry *msg_file;
 	atomic_t dropped;
 };
 
-- 
1.5.4.3


--------------070705090203070107080106--
