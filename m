Return-Path: <linux-kernel-owner+w=401wt.eu-S1761310AbZEGNjn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761310AbZEGNjn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 May 2009 09:39:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756532AbZEGNiS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 May 2009 09:38:18 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:42565 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754889AbZEGNiJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 May 2009 09:38:09 -0400
Message-Id: <20090507133746.521337240@szeredi.hu>
References: <20090507133734.450612199@szeredi.hu>
User-Agent: quilt/0.45-1
Date: Thu, 07 May 2009 15:37:35 +0200
From: Miklos Szeredi <miklos@szeredi.hu>
To: jens.axboe@oracle.com
Cc: Max Kellermann <max@duempel.org>, torvalds@linux-foundation.org,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [patch 1/3] splice: implement pipe to pipe splicing
Content-Disposition: inline; filename=splice_pipe_to_pipe.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Allow splice(2) to work when both the input and the output is a pipe.

Based on the impementation of the tee(2) syscall, but instead of
duplicating the buffer references move the buffers from the input pipe
to the output pipe.

Moving the whole buffer only succeeds if the full length of the buffer
is spliced.  Otherwise duplicate the buffer, just like tee(2), set the
length of the output buffer and advance the offset on the input
buffer.

Since splice is operating on two pipes, special care needs to be taken
with locking to prevent AN ABBA deadlock.  Again this is done
similarly to the tee(2) syscall, first preparing the input and output
pipes so there's data to consume and space for that data, and then
doing the move operation while holding both locks.

If other processes are doing I/O on the same pipes parallel to the
splice, then by the time both inodes are locked there might be no
buffers left to move, or no space to move them to.  In this case retry
the whole operation, including the preparation phase.  This could lead
to starvation, but I'm not sure if that's serious enough to worry
about.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
---
 fs/splice.c |  162 +++++++++++++++++++++++++++++++++++++++++++++++++++++++-----
 1 file changed, 151 insertions(+), 11 deletions(-)

Index: linux-2.6/fs/splice.c
===================================================================
--- linux-2.6.orig/fs/splice.c	2009-05-07 14:40:01.000000000 +0200
+++ linux-2.6/fs/splice.c	2009-05-07 14:40:06.000000000 +0200
@@ -1112,6 +1112,9 @@ long do_splice_direct(struct file *in, l
 	return ret;
 }
 
+static int splice_pipe_to_pipe(struct pipe_inode_info *ipipe,
+			       struct pipe_inode_info *opipe,
+			       size_t len, unsigned int flags);
 /*
  * After the inode slimming patch, i_pipe/i_bdev/i_cdev share the same
  * location, so checking ->i_pipe is not enough to verify that this is a
@@ -1132,12 +1135,32 @@ static long do_splice(struct file *in, l
 		      struct file *out, loff_t __user *off_out,
 		      size_t len, unsigned int flags)
 {
-	struct pipe_inode_info *pipe;
+	struct pipe_inode_info *ipipe;
+	struct pipe_inode_info *opipe;
 	loff_t offset, *off;
 	long ret;
 
-	pipe = pipe_info(in->f_path.dentry->d_inode);
-	if (pipe) {
+	ipipe = pipe_info(in->f_path.dentry->d_inode);
+	opipe = pipe_info(out->f_path.dentry->d_inode);
+
+	if (ipipe && opipe) {
+		if (off_in || off_out)
+			return -ESPIPE;
+
+		if (!(in->f_mode & FMODE_READ))
+			return -EBADF;
+
+		if (!(out->f_mode & FMODE_WRITE))
+			return -EBADF;
+
+		/* Splicing to self would be fun, but... */
+		if (ipipe == opipe)
+			return -EINVAL;
+
+		return splice_pipe_to_pipe(ipipe, opipe, len, flags);
+	}
+
+	if (ipipe) {
 		if (off_in)
 			return -ESPIPE;
 		if (off_out) {
@@ -1149,7 +1172,7 @@ static long do_splice(struct file *in, l
 		} else
 			off = &out->f_pos;
 
-		ret = do_splice_from(pipe, out, off, len, flags);
+		ret = do_splice_from(ipipe, out, off, len, flags);
 
 		if (off_out && copy_to_user(off_out, off, sizeof(loff_t)))
 			ret = -EFAULT;
@@ -1157,8 +1180,7 @@ static long do_splice(struct file *in, l
 		return ret;
 	}
 
-	pipe = pipe_info(out->f_path.dentry->d_inode);
-	if (pipe) {
+	if (opipe) {
 		if (off_out)
 			return -ESPIPE;
 		if (off_in) {
@@ -1170,7 +1192,7 @@ static long do_splice(struct file *in, l
 		} else
 			off = &in->f_pos;
 
-		ret = do_splice_to(in, off, pipe, len, flags);
+		ret = do_splice_to(in, off, opipe, len, flags);
 
 		if (off_in && copy_to_user(off_in, off, sizeof(loff_t)))
 			ret = -EFAULT;
@@ -1511,7 +1533,7 @@ SYSCALL_DEFINE6(splice, int, fd_in, loff
  * Make sure there's data to read. Wait for input if we can, otherwise
  * return an appropriate error.
  */
-static int link_ipipe_prep(struct pipe_inode_info *pipe, unsigned int flags)
+static int ipipe_prep(struct pipe_inode_info *pipe, unsigned int flags)
 {
 	int ret;
 
@@ -1549,7 +1571,7 @@ static int link_ipipe_prep(struct pipe_i
  * Make sure there's writeable room. Wait for room if we can, otherwise
  * return an appropriate error.
  */
-static int link_opipe_prep(struct pipe_inode_info *pipe, unsigned int flags)
+static int opipe_prep(struct pipe_inode_info *pipe, unsigned int flags)
 {
 	int ret;
 
@@ -1587,6 +1609,124 @@ static int link_opipe_prep(struct pipe_i
 }
 
 /*
+ * Splice contents of ipipe to opipe.
+ */
+static int splice_pipe_to_pipe(struct pipe_inode_info *ipipe,
+			       struct pipe_inode_info *opipe,
+			       size_t len, unsigned int flags)
+{
+	struct pipe_buffer *ibuf, *obuf;
+	int ret = 0, nbuf;
+	bool input_wakeup = false;
+
+
+retry:
+	ret = ipipe_prep(ipipe, flags);
+	if (ret)
+		return ret;
+
+	ret = opipe_prep(opipe, flags);
+	if (ret)
+		return ret;
+
+	/*
+	 * Potential ABBA deadlock, work around it by ordering lock
+	 * grabbing by pipe info address. Otherwise two different processes
+	 * could deadlock (one doing tee from A -> B, the other from B -> A).
+	 */
+	pipe_double_lock(ipipe, opipe);
+
+	do {
+		if (!opipe->readers) {
+			send_sig(SIGPIPE, current, 0);
+			if (!ret)
+				ret = -EPIPE;
+			break;
+		}
+
+		if (!ipipe->nrbufs && !ipipe->writers)
+			break;
+
+		/*
+		 * Cannot make any progress, because either the input
+		 * pipe is empty or the output pipe is full.
+		 */
+		if (!ipipe->nrbufs || opipe->nrbufs >= PIPE_BUFFERS) {
+			/* Already processed some buffers, break */
+			if (ret)
+				break;
+
+			if (flags & SPLICE_F_NONBLOCK) {
+				ret = -EAGAIN;
+				break;
+			}
+
+			/*
+			 * We raced with another reader/writer and haven't
+			 * managed to process any buffers.  A zero return
+			 * value means EOF, so retry instead.
+			 */
+			pipe_unlock(ipipe);
+			pipe_unlock(opipe);
+			goto retry;
+		}
+
+		ibuf = ipipe->bufs + ipipe->curbuf;
+		nbuf = (opipe->curbuf + opipe->nrbufs) % PIPE_BUFFERS;
+		obuf = opipe->bufs + nbuf;
+
+		if (len >= ibuf->len) {
+			/*
+			 * Simply move the whole buffer from ipipe to opipe
+			 */
+			*obuf = *ibuf;
+			ibuf->ops = NULL;
+			opipe->nrbufs++;
+			ipipe->curbuf = (ipipe->curbuf + 1) % PIPE_BUFFERS;
+			ipipe->nrbufs--;
+			input_wakeup = true;
+		} else {
+			/*
+			 * Get a reference to this pipe buffer,
+			 * so we can copy the contents over.
+			 */
+			ibuf->ops->get(ipipe, ibuf);
+			*obuf = *ibuf;
+
+			/*
+			 * Don't inherit the gift flag, we need to
+			 * prevent multiple steals of this page.
+			 */
+			obuf->flags &= ~PIPE_BUF_FLAG_GIFT;
+
+			obuf->len = len;
+			opipe->nrbufs++;
+			ibuf->offset += obuf->len;
+			ibuf->len -= obuf->len;
+		}
+		ret += obuf->len;
+		len -= obuf->len;
+	} while (len);
+
+	pipe_unlock(ipipe);
+	pipe_unlock(opipe);
+
+	/*
+	 * If we put data in the output pipe, wakeup any potential readers.
+	 */
+	if (ret > 0) {
+		smp_mb();
+		if (waitqueue_active(&opipe->wait))
+			wake_up_interruptible(&opipe->wait);
+		kill_fasync(&opipe->fasync_readers, SIGIO, POLL_IN);
+	}
+	if (input_wakeup)
+		wakeup_pipe_writers(ipipe);
+
+	return ret;
+}
+
+/*
  * Link contents of ipipe to opipe.
  */
 static int link_pipe(struct pipe_inode_info *ipipe,
@@ -1690,9 +1830,9 @@ static long do_tee(struct file *in, stru
 		 * Keep going, unless we encounter an error. The ipipe/opipe
 		 * ordering doesn't really matter.
 		 */
-		ret = link_ipipe_prep(ipipe, flags);
+		ret = ipipe_prep(ipipe, flags);
 		if (!ret) {
-			ret = link_opipe_prep(opipe, flags);
+			ret = opipe_prep(opipe, flags);
 			if (!ret)
 				ret = link_pipe(ipipe, opipe, len, flags);
 		}

--
