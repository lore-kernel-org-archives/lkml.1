Return-Path: <linux-kernel-owner+w=401wt.eu-S1759154AbXFLHD1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759154AbXFLHD1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2007 03:03:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756391AbXFLHAi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jun 2007 03:00:38 -0400
Received: from brick.kernel.dk ([80.160.20.94]:13573 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752715AbXFLHAc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2007 03:00:32 -0400
From: Jens Axboe <jens.axboe@oracle.com>
To: linux-kernel@vger.kernel.org
Cc: Tom Zanussi <zanussi@us.ibm.com>, Jens Axboe <jens.axboe@oracle.com>
Subject: [PATCH 10/18] splice: relay support
Date: Tue, 12 Jun 2007 08:58:06 +0200
Message-Id: <11816314953887-git-send-email-jens.axboe@oracle.com>
X-Mailer: git-send-email 1.5.2.1.174.gcd03
In-Reply-To: <11816314942627-git-send-email-jens.axboe@oracle.com>
References: <11816314942627-git-send-email-jens.axboe@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tom Zanussi <zanussi@us.ibm.com>

Signed-off-by: Jens Axboe <jens.axboe@oracle.com>
---
 kernel/relay.c |  241 ++++++++++++++++++++++++++++++++++++++++++++------------
 1 files changed, 191 insertions(+), 50 deletions(-)

diff --git a/kernel/relay.c b/kernel/relay.c
index 4311101..3950c1b 100644
--- a/kernel/relay.c
+++ b/kernel/relay.c
@@ -21,6 +21,7 @@
 #include <linux/vmalloc.h>
 #include <linux/mm.h>
 #include <linux/cpu.h>
+#include <linux/pipe_fs_i.h>
 
 /* list of open channels, for cpu hotplug */
 static DEFINE_MUTEX(relay_channels_mutex);
@@ -121,6 +122,7 @@ static void *relay_alloc_buf(struct rchan_buf *buf, size_t *size)
 		buf->page_array[i] = alloc_page(GFP_KERNEL);
 		if (unlikely(!buf->page_array[i]))
 			goto depopulate;
+		set_page_private(buf->page_array[i], (unsigned long)buf);
 	}
 	mem = vmap(buf->page_array, n_pages, VM_MAP, PAGE_KERNEL);
 	if (!mem)
@@ -963,43 +965,6 @@ static int subbuf_read_actor(size_t read_start,
 	return ret;
 }
 
-/*
- *	subbuf_send_actor - send up to one subbuf's worth of data
- */
-static int subbuf_send_actor(size_t read_start,
-			     struct rchan_buf *buf,
-			     size_t avail,
-			     read_descriptor_t *desc,
-			     read_actor_t actor)
-{
-	unsigned long pidx, poff;
-	unsigned int subbuf_pages;
-	int ret = 0;
-
-	subbuf_pages = buf->chan->alloc_size >> PAGE_SHIFT;
-	pidx = (read_start / PAGE_SIZE) % subbuf_pages;
-	poff = read_start & ~PAGE_MASK;
-	while (avail) {
-		struct page *p = buf->page_array[pidx];
-		unsigned int len;
-
-		len = PAGE_SIZE - poff;
-		if (len > avail)
-			len = avail;
-
-		len = actor(desc, p, poff, len);
-		if (desc->error)
-			break;
-
-		avail -= len;
-		ret += len;
-		poff = 0;
-		pidx = (pidx + 1) % subbuf_pages;
-	}
-
-	return ret;
-}
-
 typedef int (*subbuf_actor_t) (size_t read_start,
 			       struct rchan_buf *buf,
 			       size_t avail,
@@ -1060,19 +1025,195 @@ static ssize_t relay_file_read(struct file *filp,
 				       NULL, &desc);
 }
 
-static ssize_t relay_file_sendfile(struct file *filp,
-				   loff_t *ppos,
-				   size_t count,
-				   read_actor_t actor,
-				   void *target)
+static void relay_pipe_buf_release(struct pipe_inode_info *pipe,
+				   struct pipe_buffer *buf)
 {
-	read_descriptor_t desc;
-	desc.written = 0;
-	desc.count = count;
-	desc.arg.data = target;
-	desc.error = 0;
-	return relay_file_read_subbufs(filp, ppos, subbuf_send_actor,
-				       actor, &desc);
+	struct rchan_buf *rbuf;
+
+	rbuf = (struct rchan_buf *)page_private(buf->page);
+
+	rbuf->bytes_consumed += PAGE_SIZE;
+
+	if (rbuf->bytes_consumed == rbuf->chan->subbuf_size) {
+		relay_subbufs_consumed(rbuf->chan, rbuf->cpu, 1);
+		rbuf->bytes_consumed = 0;
+	}
+}
+
+static struct pipe_buf_operations relay_pipe_buf_ops = {
+	.can_merge = 0,
+	.map = generic_pipe_buf_map,
+	.unmap = generic_pipe_buf_unmap,
+	.pin = generic_pipe_buf_pin,
+	.release = relay_pipe_buf_release,
+	.steal = generic_pipe_buf_steal,
+	.get = generic_pipe_buf_get,
+};
+
+/**
+ *	subbuf_splice_actor - splice up to one subbuf's worth of data
+ */
+static int subbuf_splice_actor(struct file *in,
+			       loff_t *ppos,
+			       struct pipe_inode_info *pipe,
+			       size_t len,
+			       unsigned int flags,
+			       int *nonpad_ret)
+{
+	unsigned int pidx, poff;
+	unsigned int subbuf_pages;
+	int ret = 0;
+	int do_wakeup = 0;
+	struct rchan_buf *rbuf = in->private_data;
+	unsigned int subbuf_size = rbuf->chan->subbuf_size;
+	size_t read_start = ((size_t)*ppos) % rbuf->chan->alloc_size;
+	size_t avail = subbuf_size - read_start % subbuf_size;
+	size_t read_subbuf = read_start / subbuf_size;
+	size_t padding = rbuf->padding[read_subbuf];
+	size_t nonpad_end = read_subbuf * subbuf_size + subbuf_size - padding;
+
+	if (rbuf->subbufs_produced == rbuf->subbufs_consumed)
+		return 0;
+
+	if (len > avail)
+		len = avail;
+
+	if (pipe->inode)
+		mutex_lock(&pipe->inode->i_mutex);
+
+	subbuf_pages = rbuf->chan->alloc_size >> PAGE_SHIFT;
+	pidx = (read_start / PAGE_SIZE) % subbuf_pages;
+	poff = read_start & ~PAGE_MASK;
+
+	for (;;) {
+		unsigned int this_len;
+		unsigned int this_end;
+		int newbuf = (pipe->curbuf + pipe->nrbufs) & (PIPE_BUFFERS - 1);
+		struct pipe_buffer *buf = pipe->bufs + newbuf;
+
+		if (!pipe->readers) {
+			send_sig(SIGPIPE, current, 0);
+			if (!ret)
+				ret = -EPIPE;
+			break;
+		}
+
+		if (pipe->nrbufs < PIPE_BUFFERS) {
+			this_len = PAGE_SIZE - poff;
+			if (this_len > avail)
+				this_len = avail;
+
+			buf->page = rbuf->page_array[pidx];
+			buf->offset = poff;
+			this_end = read_start + ret + this_len;
+			if (this_end > nonpad_end) {
+				if (read_start + ret >= nonpad_end)
+					buf->len = 0;
+				else
+					buf->len = nonpad_end - (read_start + ret);
+			} else
+				buf->len = this_len;
+
+			*nonpad_ret += buf->len;
+
+			buf->ops = &relay_pipe_buf_ops;
+			pipe->nrbufs++;
+
+			avail -= this_len;
+			ret += this_len;
+			poff = 0;
+			pidx = (pidx + 1) % subbuf_pages;
+
+			if (pipe->inode)
+				do_wakeup = 1;
+
+			if (!avail)
+				break;
+
+			if (pipe->nrbufs < PIPE_BUFFERS)
+				continue;
+
+			break;
+		}
+
+		if (flags & SPLICE_F_NONBLOCK) {
+			if (!ret)
+				ret = -EAGAIN;
+			break;
+		}
+
+		if (signal_pending(current)) {
+			if (!ret)
+				ret = -ERESTARTSYS;
+			break;
+		}
+
+		if (do_wakeup) {
+			smp_mb();
+			if (waitqueue_active(&pipe->wait))
+				wake_up_interruptible_sync(&pipe->wait);
+			kill_fasync(&pipe->fasync_readers, SIGIO, POLL_IN);
+			do_wakeup = 0;
+		}
+
+		pipe->waiting_writers++;
+		pipe_wait(pipe);
+		pipe->waiting_writers--;
+	}
+
+	if (pipe->inode)
+		mutex_unlock(&pipe->inode->i_mutex);
+
+	if (do_wakeup) {
+		smp_mb();
+		if (waitqueue_active(&pipe->wait))
+			wake_up_interruptible(&pipe->wait);
+		kill_fasync(&pipe->fasync_readers, SIGIO, POLL_IN);
+	}
+
+	return ret;
+}
+
+static ssize_t relay_file_splice_read(struct file *in,
+				      loff_t *ppos,
+				      struct pipe_inode_info *pipe,
+				      size_t len,
+				      unsigned int flags)
+{
+	ssize_t spliced;
+	int ret;
+	int nonpad_ret = 0;
+
+	ret = 0;
+	spliced = 0;
+
+	while (len) {
+		ret = subbuf_splice_actor(in, ppos, pipe, len, flags, &nonpad_ret);
+		if (ret < 0)
+			break;
+		else if (!ret) {
+			break;
+			if (spliced)
+				break;
+			if (flags & SPLICE_F_NONBLOCK) {
+				ret = -EAGAIN;
+				break;
+			}
+		}
+
+		*ppos += ret;
+		if (ret > len)
+			len = 0;
+		else
+			len -= ret;
+		spliced += nonpad_ret;
+		nonpad_ret = 0;
+	}
+
+	if (spliced)
+		return spliced;
+
+	return ret;
 }
 
 const struct file_operations relay_file_operations = {
@@ -1082,7 +1223,7 @@ const struct file_operations relay_file_operations = {
 	.read		= relay_file_read,
 	.llseek		= no_llseek,
 	.release	= relay_file_release,
-	.sendfile       = relay_file_sendfile,
+	.splice_read	= relay_file_splice_read,
 };
 EXPORT_SYMBOL_GPL(relay_file_operations);
 
-- 
1.5.2.1.174.gcd03

