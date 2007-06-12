Return-Path: <linux-kernel-owner+w=401wt.eu-S1758783AbXFLHBf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758783AbXFLHBf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2007 03:01:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753580AbXFLHAd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jun 2007 03:00:33 -0400
Received: from brick.kernel.dk ([80.160.20.94]:13562 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752457AbXFLHAa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2007 03:00:30 -0400
From: Jens Axboe <jens.axboe@oracle.com>
To: linux-kernel@vger.kernel.org
Cc: Jens Axboe <jens.axboe@oracle.com>
Subject: [PATCH 2/18] vmsplice: add vmsplice-to-user support
Date: Tue, 12 Jun 2007 08:57:58 +0200
Message-Id: <11816314941954-git-send-email-jens.axboe@oracle.com>
X-Mailer: git-send-email 1.5.2.1.174.gcd03
In-Reply-To: <11816314942627-git-send-email-jens.axboe@oracle.com>
References: <11816314942627-git-send-email-jens.axboe@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

A bit of a cheat, it actually just copies the data to userspace. But
this makes the interface nice and symmetric and enables people to build
on splice, with room for future improvement in performance.

Signed-off-by: Jens Axboe <jens.axboe@oracle.com>
---
 fs/splice.c               |  142 ++++++++++++++++++++++++++++++++++++++-------
 include/linux/pipe_fs_i.h |    8 ++-
 2 files changed, 127 insertions(+), 23 deletions(-)

diff --git a/fs/splice.c b/fs/splice.c
index 6871de6..837be82 100644
--- a/fs/splice.c
+++ b/fs/splice.c
@@ -1282,28 +1282,107 @@ static int get_iovec_page_array(const struct iovec __user *iov,
 	return error;
 }
 
+static int pipe_to_user(struct pipe_inode_info *pipe, struct pipe_buffer *buf,
+			struct splice_desc *sd)
+{
+	int ret;
+
+	ret = buf->ops->pin(pipe, buf);
+	if (!ret) {
+		/*
+		 * use non-atomic map, can be optimized to map atomically if we
+		 * prefault the user memory.
+		 */
+		char *src = buf->ops->map(pipe, buf, 0);
+
+		if (copy_to_user(sd->userptr, src, sd->len))
+			ret = -EFAULT;
+
+		buf->ops->unmap(pipe, buf, src);
+
+		if (!ret)
+			return sd->len;
+	}
+
+	return ret;
+}
+
+/*
+ * For lack of a better implementation, implement vmsplice() to userspace
+ * as a simple copy of the pipes pages to the user iov.
+ */
+static long vmsplice_to_user(struct file *file, const struct iovec __user *iov,
+			     unsigned long nr_segs, unsigned int flags)
+{
+	struct pipe_inode_info *pipe;
+	struct splice_desc sd;
+	ssize_t size;
+	int error;
+	long ret;
+
+	pipe = pipe_info(file->f_path.dentry->d_inode);
+	if (!pipe)
+		return -EBADF;
+
+	if (pipe->inode)
+		mutex_lock(&pipe->inode->i_mutex);
+
+	ret = 0;
+	while (nr_segs) {
+		void __user *base;
+		size_t len;
+
+		/*
+		 * Get user address base and length for this iovec.
+		 */
+		error = get_user(base, &iov->iov_base);
+		if (unlikely(error))
+			break;
+		error = get_user(len, &iov->iov_len);
+		if (unlikely(error))
+			break;
+
+		/*
+		 * Sanity check this iovec. 0 read succeeds.
+		 */
+		if (unlikely(!len))
+			break;
+		error = -EFAULT;
+		if (unlikely(!base))
+			break;
+
+		sd.len = 0;
+		sd.total_len = len;
+		sd.flags = flags;
+		sd.userptr = base;
+		sd.pos = 0;
+
+		size = __splice_from_pipe(pipe, &sd, pipe_to_user);
+		if (size < 0) {
+			if (!ret)
+				ret = size;
+
+			break;
+		}
+
+		nr_segs--;
+		iov++;
+		ret += size;
+	}
+
+	if (pipe->inode)
+		mutex_unlock(&pipe->inode->i_mutex);
+
+	return ret;
+}
+
 /*
  * vmsplice splices a user address range into a pipe. It can be thought of
  * as splice-from-memory, where the regular splice is splice-from-file (or
  * to file). In both cases the output is a pipe, naturally.
- *
- * Note that vmsplice only supports splicing _from_ user memory to a pipe,
- * not the other way around. Splicing from user memory is a simple operation
- * that can be supported without any funky alignment restrictions or nasty
- * vm tricks. We simply map in the user memory and fill them into a pipe.
- * The reverse isn't quite as easy, though. There are two possible solutions
- * for that:
- *
- *	- memcpy() the data internally, at which point we might as well just
- *	  do a regular read() on the buffer anyway.
- *	- Lots of nasty vm tricks, that are neither fast nor flexible (it
- *	  has restriction limitations on both ends of the pipe).
- *
- * Alas, it isn't here.
- *
  */
-static long do_vmsplice(struct file *file, const struct iovec __user *iov,
-			unsigned long nr_segs, unsigned int flags)
+static long vmsplice_to_pipe(struct file *file, const struct iovec __user *iov,
+			     unsigned long nr_segs, unsigned int flags)
 {
 	struct pipe_inode_info *pipe;
 	struct page *pages[PIPE_BUFFERS];
@@ -1318,10 +1397,6 @@ static long do_vmsplice(struct file *file, const struct iovec __user *iov,
 	pipe = pipe_info(file->f_path.dentry->d_inode);
 	if (!pipe)
 		return -EBADF;
-	if (unlikely(nr_segs > UIO_MAXIOV))
-		return -EINVAL;
-	else if (unlikely(!nr_segs))
-		return 0;
 
 	spd.nr_pages = get_iovec_page_array(iov, nr_segs, pages, partial,
 					    flags & SPLICE_F_GIFT);
@@ -1331,6 +1406,22 @@ static long do_vmsplice(struct file *file, const struct iovec __user *iov,
 	return splice_to_pipe(pipe, &spd);
 }
 
+/*
+ * Note that vmsplice only really supports true splicing _from_ user memory
+ * to a pipe, not the other way around. Splicing from user memory is a simple
+ * operation that can be supported without any funky alignment restrictions
+ * or nasty vm tricks. We simply map in the user memory and fill them into
+ * a pipe. The reverse isn't quite as easy, though. There are two possible
+ * solutions for that:
+ *
+ *	- memcpy() the data internally, at which point we might as well just
+ *	  do a regular read() on the buffer anyway.
+ *	- Lots of nasty vm tricks, that are neither fast nor flexible (it
+ *	  has restriction limitations on both ends of the pipe).
+ *
+ * Currently we punt and implement it as a normal copy, see pipe_to_user().
+ *
+ */
 asmlinkage long sys_vmsplice(int fd, const struct iovec __user *iov,
 			     unsigned long nr_segs, unsigned int flags)
 {
@@ -1338,11 +1429,18 @@ asmlinkage long sys_vmsplice(int fd, const struct iovec __user *iov,
 	long error;
 	int fput;
 
+	if (unlikely(nr_segs > UIO_MAXIOV))
+		return -EINVAL;
+	else if (unlikely(!nr_segs))
+		return 0;
+
 	error = -EBADF;
 	file = fget_light(fd, &fput);
 	if (file) {
 		if (file->f_mode & FMODE_WRITE)
-			error = do_vmsplice(file, iov, nr_segs, flags);
+			error = vmsplice_to_pipe(file, iov, nr_segs, flags);
+		else if (file->f_mode & FMODE_READ)
+			error = vmsplice_to_user(file, iov, nr_segs, flags);
 
 		fput_light(file, fput);
 	}
diff --git a/include/linux/pipe_fs_i.h b/include/linux/pipe_fs_i.h
index 883ba9b..c2bda03 100644
--- a/include/linux/pipe_fs_i.h
+++ b/include/linux/pipe_fs_i.h
@@ -88,7 +88,13 @@ int generic_pipe_buf_steal(struct pipe_inode_info *, struct pipe_buffer *);
 struct splice_desc {
 	unsigned int len, total_len;	/* current and remaining length */
 	unsigned int flags;		/* splice flags */
-	struct file *file;		/* file to read/write */
+	/*
+	 * actor() private data
+	 */
+	union {
+		void __user *userptr;	/* memory to write to */
+		struct file *file;	/* file to read/write */
+	};
 	loff_t pos;			/* file position */
 };
 
-- 
1.5.2.1.174.gcd03

