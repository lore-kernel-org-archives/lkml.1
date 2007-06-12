Return-Path: <linux-kernel-owner+w=401wt.eu-S1753063AbXFLHBu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753063AbXFLHBu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2007 03:01:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754129AbXFLHAe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jun 2007 03:00:34 -0400
Received: from brick.kernel.dk ([80.160.20.94]:13558 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752183AbXFLHAb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2007 03:00:31 -0400
From: Jens Axboe <jens.axboe@oracle.com>
To: linux-kernel@vger.kernel.org
Cc: Jens Axboe <jens.axboe@oracle.com>
Subject: [PATCH 1/18] splice: abstract out actor data
Date: Tue, 12 Jun 2007 08:57:57 +0200
Message-Id: <11816314942637-git-send-email-jens.axboe@oracle.com>
X-Mailer: git-send-email 1.5.2.1.174.gcd03
In-Reply-To: <11816314942627-git-send-email-jens.axboe@oracle.com>
References: <11816314942627-git-send-email-jens.axboe@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

For direct splicing (or private splicing), the output may not be a file.
So abstract out the handling into a specified actor function and put
the data in the splice_desc structure earlier, so we can build on top
of that.

This is the first step in better splice handling for drivers, and also
for implementing vmsplice _to_ user memory.

Signed-off-by: Jens Axboe <jens.axboe@oracle.com>
---
 fs/ocfs2/file.c           |   11 ++++-
 fs/splice.c               |  100 ++++++++++++++++++++++++++++++++-------------
 include/linux/pipe_fs_i.h |   10 +++--
 3 files changed, 85 insertions(+), 36 deletions(-)

diff --git a/fs/ocfs2/file.c b/fs/ocfs2/file.c
index ac6c964..eb97b20 100644
--- a/fs/ocfs2/file.c
+++ b/fs/ocfs2/file.c
@@ -1636,9 +1636,14 @@ static ssize_t __ocfs2_file_splice_write(struct pipe_inode_info *pipe,
 	int ret, err;
 	struct address_space *mapping = out->f_mapping;
 	struct inode *inode = mapping->host;
-
-	ret = __splice_from_pipe(pipe, out, ppos, len, flags,
-				 ocfs2_splice_write_actor);
+	struct splice_desc sd = {
+		.total_len = len,
+		.flags = flags,
+		.pos = *ppos,
+	};
+
+	sd.file = out;
+	ret = __splice_from_pipe(pipe, &sd, ocfs2_splice_write_actor);
 	if (ret > 0) {
 		*ppos += ret;
 
diff --git a/fs/splice.c b/fs/splice.c
index cb21136..6871de6 100644
--- a/fs/splice.c
+++ b/fs/splice.c
@@ -666,31 +666,24 @@ out_ret:
  * key here is the 'actor' worker passed in that actually moves the data
  * to the wanted destination. See pipe_to_file/pipe_to_sendpage above.
  */
-ssize_t __splice_from_pipe(struct pipe_inode_info *pipe,
-			   struct file *out, loff_t *ppos, size_t len,
-			   unsigned int flags, splice_actor *actor)
+ssize_t __splice_from_pipe(struct pipe_inode_info *pipe, struct splice_desc *sd,
+			   splice_actor *actor)
 {
 	int ret, do_wakeup, err;
-	struct splice_desc sd;
 
 	ret = 0;
 	do_wakeup = 0;
 
-	sd.total_len = len;
-	sd.flags = flags;
-	sd.file = out;
-	sd.pos = *ppos;
-
 	for (;;) {
 		if (pipe->nrbufs) {
 			struct pipe_buffer *buf = pipe->bufs + pipe->curbuf;
 			const struct pipe_buf_operations *ops = buf->ops;
 
-			sd.len = buf->len;
-			if (sd.len > sd.total_len)
-				sd.len = sd.total_len;
+			sd->len = buf->len;
+			if (sd->len > sd->total_len)
+				sd->len = sd->total_len;
 
-			err = actor(pipe, buf, &sd);
+			err = actor(pipe, buf, sd);
 			if (err <= 0) {
 				if (!ret && err != -ENODATA)
 					ret = err;
@@ -702,10 +695,10 @@ ssize_t __splice_from_pipe(struct pipe_inode_info *pipe,
 			buf->offset += err;
 			buf->len -= err;
 
-			sd.len -= err;
-			sd.pos += err;
-			sd.total_len -= err;
-			if (sd.len)
+			sd->len -= err;
+			sd->pos += err;
+			sd->total_len -= err;
+			if (sd->len)
 				continue;
 
 			if (!buf->len) {
@@ -717,7 +710,7 @@ ssize_t __splice_from_pipe(struct pipe_inode_info *pipe,
 					do_wakeup = 1;
 			}
 
-			if (!sd.total_len)
+			if (!sd->total_len)
 				break;
 		}
 
@@ -730,7 +723,7 @@ ssize_t __splice_from_pipe(struct pipe_inode_info *pipe,
 				break;
 		}
 
-		if (flags & SPLICE_F_NONBLOCK) {
+		if (sd->flags & SPLICE_F_NONBLOCK) {
 			if (!ret)
 				ret = -EAGAIN;
 			break;
@@ -770,6 +763,13 @@ ssize_t splice_from_pipe(struct pipe_inode_info *pipe, struct file *out,
 {
 	ssize_t ret;
 	struct inode *inode = out->f_mapping->host;
+	struct splice_desc sd = {
+		.total_len = len,
+		.flags = flags,
+		.pos = *ppos,
+	};
+
+	sd.file = out;
 
 	/*
 	 * The actor worker might be calling ->prepare_write and
@@ -778,7 +778,7 @@ ssize_t splice_from_pipe(struct pipe_inode_info *pipe, struct file *out,
 	 * pipe->inode, we have to order lock acquiry here.
 	 */
 	inode_double_lock(inode, pipe->inode);
-	ret = __splice_from_pipe(pipe, out, ppos, len, flags, actor);
+	ret = __splice_from_pipe(pipe, &sd, actor);
 	inode_double_unlock(inode, pipe->inode);
 
 	return ret;
@@ -802,6 +802,11 @@ generic_file_splice_write_nolock(struct pipe_inode_info *pipe, struct file *out,
 {
 	struct address_space *mapping = out->f_mapping;
 	struct inode *inode = mapping->host;
+	struct splice_desc sd = {
+		.total_len = len,
+		.flags = flags,
+		.pos = *ppos,
+	};
 	ssize_t ret;
 	int err;
 
@@ -809,7 +814,8 @@ generic_file_splice_write_nolock(struct pipe_inode_info *pipe, struct file *out,
 	if (unlikely(err))
 		return err;
 
-	ret = __splice_from_pipe(pipe, out, ppos, len, flags, pipe_to_file);
+	sd.file = out;
+	ret = __splice_from_pipe(pipe, &sd, pipe_to_file);
 	if (ret > 0) {
 		*ppos += ret;
 
@@ -948,14 +954,17 @@ static long do_splice_to(struct file *in, loff_t *ppos,
 	return in->f_op->splice_read(in, ppos, pipe, len, flags);
 }
 
-long do_splice_direct(struct file *in, loff_t *ppos, struct file *out,
-		      size_t len, unsigned int flags)
+/*
+ * Splices from an input file to an actor, using a 'direct' pipe.
+ */
+ssize_t splice_direct_to_actor(struct file *in, struct splice_desc *sd,
+			       splice_direct_actor *actor)
 {
 	struct pipe_inode_info *pipe;
 	long ret, bytes;
-	loff_t out_off;
 	umode_t i_mode;
-	int i;
+	size_t len;
+	int i, flags;
 
 	/*
 	 * We require the input being a regular file, as we don't want to
@@ -991,7 +1000,13 @@ long do_splice_direct(struct file *in, loff_t *ppos, struct file *out,
 	 */
 	ret = 0;
 	bytes = 0;
-	out_off = 0;
+	len = sd->total_len;
+	flags = sd->flags;
+
+	/*
+	 * Don't block on output, we have to drain the direct pipe.
+	 */
+	sd->flags &= ~SPLICE_F_NONBLOCK;
 
 	while (len) {
 		size_t read_len, max_read_len;
@@ -1001,19 +1016,19 @@ long do_splice_direct(struct file *in, loff_t *ppos, struct file *out,
 		 */
 		max_read_len = min(len, (size_t)(PIPE_BUFFERS*PAGE_SIZE));
 
-		ret = do_splice_to(in, ppos, pipe, max_read_len, flags);
+		ret = do_splice_to(in, &sd->pos, pipe, max_read_len, flags);
 		if (unlikely(ret < 0))
 			goto out_release;
 
 		read_len = ret;
+		sd->total_len = read_len;
 
 		/*
 		 * NOTE: nonblocking mode only applies to the input. We
 		 * must not do the output in nonblocking mode as then we
 		 * could get stuck data in the internal pipe:
 		 */
-		ret = do_splice_from(pipe, out, &out_off, read_len,
-				     flags & ~SPLICE_F_NONBLOCK);
+		ret = actor(pipe, sd);
 		if (unlikely(ret < 0))
 			goto out_release;
 
@@ -1058,6 +1073,33 @@ out_release:
 		return bytes;
 
 	return ret;
+
+}
+EXPORT_SYMBOL(splice_direct_to_actor);
+
+static int direct_splice_actor(struct pipe_inode_info *pipe,
+			       struct splice_desc *sd)
+{
+	struct file *file = sd->file;
+
+	return do_splice_from(pipe, file, &sd->pos, sd->total_len, sd->flags);
+}
+
+long do_splice_direct(struct file *in, loff_t *ppos, struct file *out,
+		      size_t len, unsigned int flags)
+{
+	struct splice_desc sd = {
+		.len		= len,
+		.total_len	= len,
+		.flags		= flags,
+		.pos		= *ppos,
+	};
+	size_t ret;
+
+	sd.file = out;
+	ret = splice_direct_to_actor(in, &sd, direct_splice_actor);
+	*ppos = sd.pos;
+	return ret;
 }
 
 /*
diff --git a/include/linux/pipe_fs_i.h b/include/linux/pipe_fs_i.h
index c8884f9..883ba9b 100644
--- a/include/linux/pipe_fs_i.h
+++ b/include/linux/pipe_fs_i.h
@@ -94,13 +94,15 @@ struct splice_desc {
 
 typedef int (splice_actor)(struct pipe_inode_info *, struct pipe_buffer *,
 			   struct splice_desc *);
+typedef int (splice_direct_actor)(struct pipe_inode_info *,
+				  struct splice_desc *);
 
 extern ssize_t splice_from_pipe(struct pipe_inode_info *, struct file *,
 				loff_t *, size_t, unsigned int,
 				splice_actor *);
-
-extern ssize_t __splice_from_pipe(struct pipe_inode_info *, struct file *,
-				  loff_t *, size_t, unsigned int,
-				  splice_actor *);
+extern ssize_t __splice_from_pipe(struct pipe_inode_info *,
+				  struct splice_desc *, splice_actor *);
+extern ssize_t splice_direct_to_actor(struct file *, struct splice_desc *,
+				      splice_direct_actor *);
 
 #endif
-- 
1.5.2.1.174.gcd03

