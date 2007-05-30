Return-Path: <linux-kernel-owner+w=401wt.eu-S1757886AbXE3R7E@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757886AbXE3R7E (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2007 13:59:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751296AbXE3R6y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 May 2007 13:58:54 -0400
Received: from brick.kernel.dk ([80.160.20.94]:27247 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751670AbXE3R6x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2007 13:58:53 -0400
Date: Wed, 30 May 2007 19:57:59 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Jeff Garzik <jeff@garzik.org>, Zach Brown <zach.brown@oracle.com>,
       linux-kernel@vger.kernel.org, Arjan van de Ven <arjan@infradead.org>,
       Christoph Hellwig <hch@infradead.org>, Andrew Morton <akpm@zip.com.au>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Ulrich Drepper <drepper@redhat.com>,
       Evgeniy Polyakov <johnpol@2ka.mipt.ru>,
       "David S. Miller" <davem@davemloft.net>,
       Suparna Bhattacharya <suparna@in.ibm.com>,
       Davide Libenzi <davidel@xmailserver.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: Syslets, Threadlets, generic AIO support, v6
Message-ID: <20070530175759.GP15559@kernel.dk>
References: <20070529212718.GH7875@mami.zabbo.net> <465CA654.5000505@garzik.org> <20070530072055.GA3077@elte.hu> <465D43A0.8040307@garzik.org> <alpine.LFD.0.98.0705300820350.26602@woody.linux-foundation.org> <20070530160913.GA14261@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070530160913.GA14261@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 30 2007, Ingo Molnar wrote:
>  - splice. (a bit too early to tell but it's looking good so far. Would
>    be nice if someone did a brute-force memcpy() based vmsplice to user
>    memory, just to make usage fully symmetric.)

Heh, I actually agree, at least then the interface is complete! We can
always replace it with something more clever, should someone feel so
inclined. Here's a rough patch to do that, it's totally untested (but it
compiles). sparse will warn about the __user removal, though. I'm sure
viro would shoot me dead on the spot, should he see this...

diff --git a/fs/splice.c b/fs/splice.c
index 12f2828..5023c01 100644
--- a/fs/splice.c
+++ b/fs/splice.c
@@ -657,9 +657,9 @@ out_ret:
  * key here is the 'actor' worker passed in that actually moves the data
  * to the wanted destination. See pipe_to_file/pipe_to_sendpage above.
  */
-ssize_t __splice_from_pipe(struct pipe_inode_info *pipe,
-			   struct file *out, loff_t *ppos, size_t len,
-			   unsigned int flags, splice_actor *actor)
+ssize_t __splice_from_pipe(struct pipe_inode_info *pipe, void *actor_priv,
+			   loff_t *ppos, size_t len, unsigned int flags,
+			   splice_actor *actor)
 {
 	int ret, do_wakeup, err;
 	struct splice_desc sd;
@@ -669,7 +669,7 @@ ssize_t __splice_from_pipe(struct pipe_inode_info *pipe,
 
 	sd.total_len = len;
 	sd.flags = flags;
-	sd.file = out;
+	sd.file = actor_priv;
 	sd.pos = *ppos;
 
 	for (;;) {
@@ -1240,28 +1240,104 @@ static int get_iovec_page_array(const struct iovec __user *iov,
 	return error;
 }
 
+static int pipe_to_user(struct pipe_inode_info *pipe, struct pipe_buffer *buf,
+			struct splice_desc *sd)
+{
+	int ret;
+
+	ret = buf->ops->pin(pipe, buf);
+	if (!ret) {
+		void __user *dst = sd->userptr;
+		/*
+		 * use non-atomic map, can be optimized to map atomically if we
+		 * prefault the user memory.
+		 */
+		char *src = buf->ops->map(pipe, buf, 0);
+
+		if (copy_to_user(dst, src, sd->len))
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
+	ssize_t size;
+	int error;
+	long ret;
+
+	pipe = pipe_info(file->f_path.dentry->d_inode);
+	if (!pipe)
+		return -EBADF;
+	if (!nr_segs)
+		return 0;
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
+		size = __splice_from_pipe(pipe, (void *) base, NULL, len,
+						flags, pipe_to_user);
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
@@ -1289,6 +1365,22 @@ static long do_vmsplice(struct file *file, const struct iovec __user *iov,
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
@@ -1300,7 +1392,9 @@ asmlinkage long sys_vmsplice(int fd, const struct iovec __user *iov,
 	file = fget_light(fd, &fput);
 	if (file) {
 		if (file->f_mode & FMODE_WRITE)
-			error = do_vmsplice(file, iov, nr_segs, flags);
+			error = vmsplice_to_pipe(file, iov, nr_segs, flags);
+		else if (file->f_mode & FMODE_READ)
+			error = vmsplice_to_user(file, iov, nr_segs, flags);
 
 		fput_light(file, fput);
 	}

-- 
Jens Axboe

