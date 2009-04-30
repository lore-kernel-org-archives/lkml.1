Return-Path: <linux-kernel-owner+w=401wt.eu-S1762727AbZD3MMV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762727AbZD3MMV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Apr 2009 08:12:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761501AbZD3MLZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Apr 2009 08:11:25 -0400
Received: from bender.cm4all.net ([87.106.27.49]:55450 "EHLO bender.cm4all.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759659AbZD3MLV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Apr 2009 08:11:21 -0400
From: Max Kellermann <mk@cm4all.com>
Subject: [splice PATCH 3/3] splice: added support for pipe-to-pipe splice()
To: linux-kernel@vger.kernel.org
Cc: jens.axboe@oracle.com, w@1wt.eu
Date: Thu, 30 Apr 2009 14:03:54 +0200
Message-ID: <20090430120354.5689.75240.stgit@rabbit.intern.cm-ag>
In-Reply-To: <20090430120342.5689.74090.stgit@rabbit.intern.cm-ag>
References: <20090430120342.5689.74090.stgit@rabbit.intern.cm-ag>
User-Agent: StGIT/0.14.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch enables the splice() system call to copy buffers from one
pipe to another.  This obvious and trivial use case for splice() was
not supported until now.

It reuses the functions link_ipipe_prep() and link_opipe_prep() from
the tee() system call implementation.

Signed-off-by: Max Kellermann <mk@cm4all.com>
---

 fs/splice.c |  166 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 166 insertions(+), 0 deletions(-)

diff --git a/fs/splice.c b/fs/splice.c
index 96135eb..f69a88f 100644
--- a/fs/splice.c
+++ b/fs/splice.c
@@ -902,6 +902,156 @@ ssize_t generic_splice_sendpage(struct pipe_inode_info *pipe, struct file *out,
 
 EXPORT_SYMBOL(generic_splice_sendpage);
 
+static int link_ipipe_prep(struct pipe_inode_info *pipe, unsigned int flags);
+static int link_opipe_prep(struct pipe_inode_info *pipe, unsigned int flags);
+
+/**
+ * Returns the nth pipe buffer after the current one.
+ *
+ * @i the buffer index, relative to the current one
+ */
+static inline struct pipe_buffer *
+pipe_buffer_at(struct pipe_inode_info *pipe, unsigned i)
+{
+	BUG_ON(i >= PIPE_BUFFERS);
+
+	return pipe->bufs + ((pipe->curbuf + i) & (PIPE_BUFFERS - 1));
+}
+
+/**
+ * Splice pages from one pipe to another.
+ *
+ * @ipipe the input pipe
+ * @opipe the output pipe
+ * @len the maximum number of bytes to move
+ * @flags splice modifier flags
+ */
+static long do_splice_pipes(struct pipe_inode_info *ipipe,
+			    struct pipe_inode_info *opipe,
+			    size_t len, unsigned int flags)
+{
+	struct pipe_buffer *ibuf, *obuf;
+	long ret;
+	int do_wakeup = 0;
+
+	if (ipipe == opipe)
+		/* cannot splice a pipe to itself */
+		return -EINVAL;
+
+	while (1) {
+		/* wait for ipipe to become ready to read */
+		ret = link_ipipe_prep(ipipe, flags);
+		if (ret)
+			return ret;
+
+		/* wait for opipe to become ready to write */
+		ret = link_opipe_prep(opipe, flags);
+		if (ret)
+			return ret;
+
+		/* lock both pipes */
+		pipe_double_lock(ipipe, opipe);
+
+		/* see if the splice() is still possible */
+		if ((ipipe->nrbufs > 0 || ipipe->writers == 0) &&
+		    opipe->nrbufs < PIPE_BUFFERS)
+			/* yes, it is - keep the locks and end this
+			   loop */
+			break;
+
+		/* no - someone has drained ipipe or has filled opipe
+		   between link_[io]pipe_pre()'s lock and our lock.
+		   Drop both locks and wait again. */
+		pipe_unlock(ipipe);
+		pipe_unlock(opipe);
+	}
+
+	do {
+		if (opipe->readers == 0) {
+			/* nobody's reading from the output pipe: send
+			   SIGPIPE */
+			send_sig(SIGPIPE, current, 0);
+			if (!ret)
+				ret = -EPIPE;
+			break;
+		}
+
+		/*
+		 * If we have iterated all input buffers or ran out of
+		 * output room, break.
+		 */
+		if (ipipe->nrbufs == 0 || opipe->nrbufs >= PIPE_BUFFERS)
+			break;
+
+		/* now do the real thing: move a buffer (or a part of
+		   it) from ipipe to opipe */
+
+		ibuf = pipe_buffer_at(ipipe, 0);
+		obuf = pipe_buffer_at(opipe, opipe->nrbufs);
+		*obuf = *ibuf;
+
+		/*
+		 * Don't inherit the gift flag, we need to
+		 * prevent multiple steals of this page.
+		 */
+		obuf->flags &= ~PIPE_BUF_FLAG_GIFT;
+
+		/* increase the reference counter */
+		obuf->ops->get(opipe, obuf);
+
+		if (obuf->len > len) {
+			/* partial move */
+
+			obuf->len = len;
+
+			/* remove the portion from ibuf */
+			ibuf->offset += len;
+			ibuf->len -= len;
+		} else {
+			/* full move: remove buffer from the input
+			   pipe */
+
+			ibuf->ops->release(ipipe, ibuf);
+			ibuf->ops = NULL;
+
+			ipipe->curbuf = (ipipe->curbuf + 1) &
+				(PIPE_BUFFERS - 1);
+			ipipe->nrbufs--;
+
+			do_wakeup = 1;
+		}
+
+		opipe->nrbufs++;
+		ret += obuf->len;
+		len -= obuf->len;
+	} while (len > 0);
+
+	pipe_unlock(ipipe);
+	pipe_unlock(opipe);
+
+	if (do_wakeup) {
+		/* at least one buffer was removed from the
+		   input pipe: wake up potential writers */
+		smp_mb();
+		if (waitqueue_active(&ipipe->wait))
+			wake_up_interruptible(&ipipe->wait);
+		kill_fasync(&ipipe->fasync_writers, SIGIO, POLL_OUT);
+	}
+
+	/*
+	 * If we put data in the output pipe, wakeup any potential
+	 * readers.
+	 */
+	if (ret > 0) {
+		smp_mb();
+		if (waitqueue_active(&opipe->wait))
+			wake_up_interruptible(&opipe->wait);
+		kill_fasync(&opipe->fasync_readers, SIGIO, POLL_IN);
+	}
+
+	return ret;
+}
+
 /*
  * Attempt to initiate a splice from pipe to file.
  */
@@ -1138,8 +1288,24 @@ static long do_splice(struct file *in, loff_t __user *off_in,
 
 	pipe = pipe_info(in->f_path.dentry->d_inode);
 	if (pipe) {
+		struct pipe_inode_info *out_pipe;
+
 		if (off_in)
 			return -ESPIPE;
+
+		out_pipe = pipe_info(out->f_path.dentry->d_inode);
+		if (out_pipe) {
+			/* special case: a splice between two pipes */
+
+			if (unlikely(!(out->f_mode & FMODE_WRITE)))
+				return -EBADF;
+
+			if (off_out)
+				return -ESPIPE;
+
+			return do_splice_pipes(pipe, out_pipe, len, flags);
+		}
+
 		if (off_out) {
 			if (out->f_op->llseek == no_llseek)
 				return -EINVAL;

