Return-Path: <linux-kernel-owner+w=401wt.eu-S1753045AbXFLHEA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753045AbXFLHEA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2007 03:04:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756847AbXFLHAk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jun 2007 03:00:40 -0400
Received: from brick.kernel.dk ([80.160.20.94]:13576 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752751AbXFLHAc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2007 03:00:32 -0400
From: Jens Axboe <jens.axboe@oracle.com>
To: linux-kernel@vger.kernel.org
Cc: Jens Axboe <jens.axboe@oracle.com>
Subject: [PATCH 13/18] relay: use splice_to_pipe() instead of open-coding the pipe loop
Date: Tue, 12 Jun 2007 08:58:09 +0200
Message-Id: <1181631495919-git-send-email-jens.axboe@oracle.com>
X-Mailer: git-send-email 1.5.2.1.174.gcd03
In-Reply-To: <11816314942627-git-send-email-jens.axboe@oracle.com>
References: <11816314942627-git-send-email-jens.axboe@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

It cleans up the relay splice implementation a lot, and gets rid of
a lot of internal pipe knowledge that should not be in there.

Plus fixes for padding and partial first page (and lots more) from
Tom Zanussi.

Signed-off-by: Jens Axboe <jens.axboe@oracle.com>
---
 kernel/relay.c |  146 +++++++++++++++++++++-----------------------------------
 1 files changed, 55 insertions(+), 91 deletions(-)

diff --git a/kernel/relay.c b/kernel/relay.c
index ae13040..0c2971e 100644
--- a/kernel/relay.c
+++ b/kernel/relay.c
@@ -1025,19 +1025,23 @@ static ssize_t relay_file_read(struct file *filp,
 				       NULL, &desc);
 }
 
+static void relay_consume_bytes(struct rchan_buf *rbuf, int bytes_consumed)
+{
+	rbuf->bytes_consumed += bytes_consumed;
+
+	if (rbuf->bytes_consumed >= rbuf->chan->subbuf_size) {
+		relay_subbufs_consumed(rbuf->chan, rbuf->cpu, 1);
+		rbuf->bytes_consumed %= rbuf->chan->subbuf_size;
+	}
+}
+
 static void relay_pipe_buf_release(struct pipe_inode_info *pipe,
 				   struct pipe_buffer *buf)
 {
 	struct rchan_buf *rbuf;
 
 	rbuf = (struct rchan_buf *)page_private(buf->page);
-
-	rbuf->bytes_consumed += PAGE_SIZE;
-
-	if (rbuf->bytes_consumed == rbuf->chan->subbuf_size) {
-		relay_subbufs_consumed(rbuf->chan, rbuf->cpu, 1);
-		rbuf->bytes_consumed = 0;
-	}
+	relay_consume_bytes(rbuf, buf->private);
 }
 
 static struct pipe_buf_operations relay_pipe_buf_ops = {
@@ -1060,118 +1064,79 @@ static int subbuf_splice_actor(struct file *in,
 			       unsigned int flags,
 			       int *nonpad_ret)
 {
-	unsigned int pidx, poff;
-	unsigned int subbuf_pages;
-	int ret = 0;
-	int do_wakeup = 0;
+	unsigned int pidx, poff, total_len, subbuf_pages, ret;
 	struct rchan_buf *rbuf = in->private_data;
 	unsigned int subbuf_size = rbuf->chan->subbuf_size;
 	size_t read_start = ((size_t)*ppos) % rbuf->chan->alloc_size;
-	size_t avail = subbuf_size - read_start % subbuf_size;
 	size_t read_subbuf = read_start / subbuf_size;
 	size_t padding = rbuf->padding[read_subbuf];
 	size_t nonpad_end = read_subbuf * subbuf_size + subbuf_size - padding;
+	struct page *pages[PIPE_BUFFERS];
+	struct partial_page partial[PIPE_BUFFERS];
+	struct splice_pipe_desc spd = {
+		.pages = pages,
+		.nr_pages = 0,
+		.partial = partial,
+		.flags = flags,
+		.ops = &relay_pipe_buf_ops,
+	};
 
 	if (rbuf->subbufs_produced == rbuf->subbufs_consumed)
 		return 0;
 
-	if (len > avail)
-		len = avail;
-
-	if (pipe->inode)
-		mutex_lock(&pipe->inode->i_mutex);
+	/*
+	 * Adjust read len, if longer than what is available
+	 */
+	if (len > (subbuf_size - read_start % subbuf_size))
+		len = subbuf_size - read_start % subbuf_size;
 
 	subbuf_pages = rbuf->chan->alloc_size >> PAGE_SHIFT;
 	pidx = (read_start / PAGE_SIZE) % subbuf_pages;
 	poff = read_start & ~PAGE_MASK;
 
-	for (;;) {
-		unsigned int this_len;
-		unsigned int this_end;
-		int newbuf = (pipe->curbuf + pipe->nrbufs) & (PIPE_BUFFERS - 1);
-		struct pipe_buffer *buf = pipe->bufs + newbuf;
+	for (total_len = 0; spd.nr_pages < subbuf_pages; spd.nr_pages++) {
+		unsigned int this_len, this_end, private;
+		unsigned int cur_pos = read_start + total_len;
 
-		if (!pipe->readers) {
-			send_sig(SIGPIPE, current, 0);
-			if (!ret)
-				ret = -EPIPE;
+		if (!len)
 			break;
-		}
-
-		if (pipe->nrbufs < PIPE_BUFFERS) {
-			this_len = PAGE_SIZE - poff;
-			if (this_len > avail)
-				this_len = avail;
-
-			buf->page = rbuf->page_array[pidx];
-			buf->offset = poff;
-			this_end = read_start + ret + this_len;
-			if (this_end > nonpad_end) {
-				if (read_start + ret >= nonpad_end)
-					buf->len = 0;
-				else
-					buf->len = nonpad_end - (read_start + ret);
-			} else
-				buf->len = this_len;
-
-			*nonpad_ret += buf->len;
-
-			buf->ops = &relay_pipe_buf_ops;
-			pipe->nrbufs++;
 
-			avail -= this_len;
-			ret += this_len;
-			poff = 0;
-			pidx = (pidx + 1) % subbuf_pages;
+		this_len = min_t(unsigned long, len, PAGE_SIZE - poff);
+		private = this_len;
 
-			if (pipe->inode)
-				do_wakeup = 1;
+		spd.pages[spd.nr_pages] = rbuf->page_array[pidx];
+		spd.partial[spd.nr_pages].offset = poff;
 
-			if (!avail)
-				break;
-
-			if (pipe->nrbufs < PIPE_BUFFERS)
-				continue;
-
-			break;
+		this_end = cur_pos + this_len;
+		if (this_end >= nonpad_end) {
+			this_len = nonpad_end - cur_pos;
+			private = this_len + padding;
 		}
+		spd.partial[spd.nr_pages].len = this_len;
+		spd.partial[spd.nr_pages].private = private;
 
-		if (flags & SPLICE_F_NONBLOCK) {
-			if (!ret)
-				ret = -EAGAIN;
-			break;
-		}
+		len -= this_len;
+		total_len += this_len;
+		poff = 0;
+		pidx = (pidx + 1) % subbuf_pages;
 
-		if (signal_pending(current)) {
-			if (!ret)
-				ret = -ERESTARTSYS;
+		if (this_end >= nonpad_end) {
+			spd.nr_pages++;
 			break;
 		}
-
-		if (do_wakeup) {
-			smp_mb();
-			if (waitqueue_active(&pipe->wait))
-				wake_up_interruptible_sync(&pipe->wait);
-			kill_fasync(&pipe->fasync_readers, SIGIO, POLL_IN);
-			do_wakeup = 0;
-		}
-
-		pipe->waiting_writers++;
-		pipe_wait(pipe);
-		pipe->waiting_writers--;
 	}
 
-	if (pipe->inode)
-		mutex_unlock(&pipe->inode->i_mutex);
+	if (!spd.nr_pages)
+		return 0;
 
-	if (do_wakeup) {
-		smp_mb();
-		if (waitqueue_active(&pipe->wait))
-			wake_up_interruptible(&pipe->wait);
-		kill_fasync(&pipe->fasync_readers, SIGIO, POLL_IN);
-	}
+	ret = *nonpad_ret = splice_to_pipe(pipe, &spd);
+	if (ret < 0 || ret < total_len)
+		return ret;
 
-	return ret;
+        if (read_start + ret == nonpad_end)
+                ret += padding;
+
+        return ret;
 }
 
 static ssize_t relay_file_splice_read(struct file *in,
@@ -1192,7 +1157,6 @@ static ssize_t relay_file_splice_read(struct file *in,
 		if (ret < 0)
 			break;
 		else if (!ret) {
-			break;
 			if (spliced)
 				break;
 			if (flags & SPLICE_F_NONBLOCK) {
-- 
1.5.2.1.174.gcd03

