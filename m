Return-Path: <linux-kernel-owner+w=401wt.eu-S1757640AbZDNRuy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757640AbZDNRuy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Apr 2009 13:50:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757205AbZDNRt3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Apr 2009 13:49:29 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:56532 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757050AbZDNRtW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Apr 2009 13:49:22 -0400
Message-Id: <20090414174853.750588717@szeredi.hu>
References: <20090414174835.487031939@szeredi.hu>
User-Agent: quilt/0.45-1
Date: Tue, 14 Apr 2009 19:48:36 +0200
From: Miklos Szeredi <miklos@szeredi.hu>
To: jens.axboe@oracle.com, mfasheh@suse.com
Cc: akpm@linux-foundation.org, viro@ZenIV.linux.org.uk,
       torvalds@linux-foundation.org, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: [patch 1/6] splice: split up __splice_from_pipe()
Content-Disposition: inline; filename=splice_from_pipe_cleanup.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Split up __splice_from_pipe() into four helper functions:

  splice_from_pipe_begin()
  splice_from_pipe_next()
  splice_from_pipe_feed()
  splice_from_pipe_end()

splice_from_pipe_next() will wait (if necessary) for more buffers to
be added to the pipe.  splice_from_pipe_feed() will feed the buffers
to the supplied actor and return when there's no more data available
(or if all of the requested data has been copied).

This is necessary so that implementations can do locking around the
non-waiting splice_from_pipe_feed().

This patch should not cause any change in behavior.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
---
 fs/splice.c            |  225 ++++++++++++++++++++++++++++++++-----------------
 include/linux/splice.h |   10 ++
 2 files changed, 157 insertions(+), 78 deletions(-)

Index: linux-2.6/fs/splice.c
===================================================================
--- linux-2.6.orig/fs/splice.c	2009-04-14 16:36:07.000000000 +0200
+++ linux-2.6/fs/splice.c	2009-04-14 18:08:03.000000000 +0200
@@ -601,107 +601,176 @@ out:
 	return ret;
 }
 
+static void wakeup_pipe_writers(struct pipe_inode_info *pipe)
+{
+	smp_mb();
+	if (waitqueue_active(&pipe->wait))
+		wake_up_interruptible(&pipe->wait);
+	kill_fasync(&pipe->fasync_writers, SIGIO, POLL_OUT);
+}
+
 /**
- * __splice_from_pipe - splice data from a pipe to given actor
+ * splice_from_pipe_feed - feed available data from a pipe to a file
  * @pipe:	pipe to splice from
  * @sd:		information to @actor
  * @actor:	handler that splices the data
  *
  * Description:
- *    This function does little more than loop over the pipe and call
- *    @actor to do the actual moving of a single struct pipe_buffer to
- *    the desired destination. See pipe_to_file, pipe_to_sendpage, or
- *    pipe_to_user.
+
+ *    This function loops over the pipe and calls @actor to do the
+ *    actual moving of a single struct pipe_buffer to the desired
+ *    destination.  It returns when there's no more buffers left in
+ *    the pipe or if the requested number of bytes (@sd->total_len)
+ *    have been copied.  It returns a positive number (one) if the
+ *    pipe needs to be filled with more data, zero if the required
+ *    number of bytes have been copied and -errno on error.
  *
+ *    This, together with splice_from_pipe_{begin,end,next}, may be
+ *    used to implement the functionality of __splice_from_pipe() when
+ *    locking is required around copying the pipe buffers to the
+ *    destination.
  */
-ssize_t __splice_from_pipe(struct pipe_inode_info *pipe, struct splice_desc *sd,
-			   splice_actor *actor)
+int splice_from_pipe_feed(struct pipe_inode_info *pipe, struct splice_desc *sd,
+			  splice_actor *actor)
 {
-	int ret, do_wakeup, err;
-
-	ret = 0;
-	do_wakeup = 0;
+	int ret;
 
-	for (;;) {
-		if (pipe->nrbufs) {
-			struct pipe_buffer *buf = pipe->bufs + pipe->curbuf;
-			const struct pipe_buf_operations *ops = buf->ops;
-
-			sd->len = buf->len;
-			if (sd->len > sd->total_len)
-				sd->len = sd->total_len;
-
-			err = actor(pipe, buf, sd);
-			if (err <= 0) {
-				if (!ret && err != -ENODATA)
-					ret = err;
-
-				break;
-			}
-
-			ret += err;
-			buf->offset += err;
-			buf->len -= err;
-
-			sd->len -= err;
-			sd->pos += err;
-			sd->total_len -= err;
-			if (sd->len)
-				continue;
-
-			if (!buf->len) {
-				buf->ops = NULL;
-				ops->release(pipe, buf);
-				pipe->curbuf = (pipe->curbuf + 1) & (PIPE_BUFFERS - 1);
-				pipe->nrbufs--;
-				if (pipe->inode)
-					do_wakeup = 1;
-			}
+	while (pipe->nrbufs) {
+		struct pipe_buffer *buf = pipe->bufs + pipe->curbuf;
+		const struct pipe_buf_operations *ops = buf->ops;
+
+		sd->len = buf->len;
+		if (sd->len > sd->total_len)
+			sd->len = sd->total_len;
+
+		ret = actor(pipe, buf, sd);
+		if (ret <= 0) {
+			if (ret == -ENODATA)
+				ret = 0;
+			return ret;
+		}
+		buf->offset += ret;
+		buf->len -= ret;
 
-			if (!sd->total_len)
-				break;
+		sd->num_spliced += ret;
+		sd->len -= ret;
+		sd->pos += ret;
+		sd->total_len -= ret;
+
+		if (!buf->len) {
+			buf->ops = NULL;
+			ops->release(pipe, buf);
+			pipe->curbuf = (pipe->curbuf + 1) & (PIPE_BUFFERS - 1);
+			pipe->nrbufs--;
+			if (pipe->inode)
+				sd->need_wakeup = true;
 		}
 
-		if (pipe->nrbufs)
-			continue;
+		if (!sd->total_len)
+			return 0;
+	}
+
+	return 1;
+}
+EXPORT_SYMBOL(splice_from_pipe_feed);
+
+/**
+ * splice_from_pipe_next - wait for some data to splice from
+ * @pipe:	pipe to splice from
+ * @sd:		information about the splice operation
+ *
+ * Description:
+ *    This function will wait for some data and return a positive
+ *    value (one) if pipe buffers are available.  It will return zero
+ *    or -errno if no more data needs to be spliced.
+ */
+int splice_from_pipe_next(struct pipe_inode_info *pipe, struct splice_desc *sd)
+{
+	while (!pipe->nrbufs) {
 		if (!pipe->writers)
-			break;
-		if (!pipe->waiting_writers) {
-			if (ret)
-				break;
-		}
+			return 0;
 
-		if (sd->flags & SPLICE_F_NONBLOCK) {
-			if (!ret)
-				ret = -EAGAIN;
-			break;
-		}
+		if (!pipe->waiting_writers && sd->num_spliced)
+			return 0;
 
-		if (signal_pending(current)) {
-			if (!ret)
-				ret = -ERESTARTSYS;
-			break;
-		}
+		if (sd->flags & SPLICE_F_NONBLOCK)
+			return -EAGAIN;
 
-		if (do_wakeup) {
-			smp_mb();
-			if (waitqueue_active(&pipe->wait))
-				wake_up_interruptible_sync(&pipe->wait);
-			kill_fasync(&pipe->fasync_writers, SIGIO, POLL_OUT);
-			do_wakeup = 0;
+		if (signal_pending(current))
+			return -ERESTARTSYS;
+
+		if (sd->need_wakeup) {
+			wakeup_pipe_writers(pipe);
+			sd->need_wakeup = false;
 		}
 
 		pipe_wait(pipe);
 	}
 
-	if (do_wakeup) {
-		smp_mb();
-		if (waitqueue_active(&pipe->wait))
-			wake_up_interruptible(&pipe->wait);
-		kill_fasync(&pipe->fasync_writers, SIGIO, POLL_OUT);
-	}
+	return 1;
+}
+EXPORT_SYMBOL(splice_from_pipe_next);
 
-	return ret;
+/**
+ * splice_from_pipe_begin - start splicing from pipe
+ * @pipe:	pipe to splice from
+ *
+ * Description:
+ *    This function should be called before a loop containing
+ *    splice_from_pipe_next() and splice_from_pipe_feed() to
+ *    initialize the necessary fields of @sd.
+ */
+void splice_from_pipe_begin(struct splice_desc *sd)
+{
+	sd->num_spliced = 0;
+	sd->need_wakeup = false;
+}
+EXPORT_SYMBOL(splice_from_pipe_begin);
+
+/**
+ * splice_from_pipe_end - finish splicing from pipe
+ * @pipe:	pipe to splice from
+ * @sd:		information about the splice operation
+ *
+ * Description:
+ *    This function will wake up pipe writers if necessary.  It should
+ *    be called after a loop containing splice_from_pipe_next() and
+ *    splice_from_pipe_feed().
+ */
+void splice_from_pipe_end(struct pipe_inode_info *pipe, struct splice_desc *sd)
+{
+	if (sd->need_wakeup)
+		wakeup_pipe_writers(pipe);
+}
+EXPORT_SYMBOL(splice_from_pipe_end);
+
+/**
+ * __splice_from_pipe - splice data from a pipe to given actor
+ * @pipe:	pipe to splice from
+ * @sd:		information to @actor
+ * @actor:	handler that splices the data
+ *
+ * Description:
+ *    This function does little more than loop over the pipe and call
+ *    @actor to do the actual moving of a single struct pipe_buffer to
+ *    the desired destination. See pipe_to_file, pipe_to_sendpage, or
+ *    pipe_to_user.
+ *
+ */
+ssize_t __splice_from_pipe(struct pipe_inode_info *pipe, struct splice_desc *sd,
+			   splice_actor *actor)
+{
+	int ret;
+
+	splice_from_pipe_begin(sd);
+	do {
+		ret = splice_from_pipe_next(pipe, sd);
+		if (ret > 0)
+			ret = splice_from_pipe_feed(pipe, sd, actor);
+	} while (ret > 0);
+	splice_from_pipe_end(pipe, sd);
+
+	return sd->num_spliced ? sd->num_spliced : ret;
 }
 EXPORT_SYMBOL(__splice_from_pipe);
 
Index: linux-2.6/include/linux/splice.h
===================================================================
--- linux-2.6.orig/include/linux/splice.h	2009-04-14 16:36:07.000000000 +0200
+++ linux-2.6/include/linux/splice.h	2009-04-14 17:37:47.000000000 +0200
@@ -36,6 +36,8 @@ struct splice_desc {
 		void *data;		/* cookie */
 	} u;
 	loff_t pos;			/* file position */
+	size_t num_spliced;		/* number of bytes already spliced */
+	bool need_wakeup;		/* need to wake up writer */
 };
 
 struct partial_page {
@@ -66,6 +68,14 @@ extern ssize_t splice_from_pipe(struct p
 				splice_actor *);
 extern ssize_t __splice_from_pipe(struct pipe_inode_info *,
 				  struct splice_desc *, splice_actor *);
+extern int splice_from_pipe_feed(struct pipe_inode_info *, struct splice_desc *,
+				 splice_actor *);
+extern int splice_from_pipe_next(struct pipe_inode_info *,
+				 struct splice_desc *);
+extern void splice_from_pipe_begin(struct splice_desc *);
+extern void splice_from_pipe_end(struct pipe_inode_info *,
+				 struct splice_desc *);
+
 extern ssize_t splice_to_pipe(struct pipe_inode_info *,
 			      struct splice_pipe_desc *);
 extern ssize_t splice_direct_to_actor(struct file *, struct splice_desc *,

--
