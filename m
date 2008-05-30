Return-Path: <linux-kernel-owner+w=401wt.eu-S1756209AbYE3Kfq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756209AbYE3Kfq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2008 06:35:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752967AbYE3Kfh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 May 2008 06:35:37 -0400
Received: from brick.kernel.dk ([87.55.233.238]:25818 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752882AbYE3Kff (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2008 06:35:35 -0400
Date: Fri, 30 May 2008 12:35:32 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Fausto Richetti Blanco <fausto.blanco@gmail.com>
Cc: linux-kernel@vger.kernel.org, miquels@cistron.nl, riel@redhat.com,
       jengelh@medozas.de
Subject: Re: Pipe buffers' limit of 16 * 4K
Message-ID: <20080530103531.GT25504@kernel.dk>
References: <d8d698ae0805231255i4d0da724p68cb2b9376134797@mail.gmail.com> <d8d698ae0805231719g4202edf2k947bba4128385ab6@mail.gmail.com> <20080523205630.444fe2b9@bree.surriel.com> <d8d698ae0805261043u125b653ve73d067cd92caa16@mail.gmail.com> <d8d698ae0805290600s782e16b4pe70d725f55826cf0@mail.gmail.com> <1212067164.8621.3.camel@localhost.localdomain> <alpine.LNX.1.10.0805291633000.19264@fbirervta.pbzchgretzou.qr> <d8d698ae0805290846w7cd2b14j99db2e1e2a9ec7ed@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d8d698ae0805290846w7cd2b14j99db2e1e2a9ec7ed@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 29 2008, Fausto Richetti Blanco wrote:
> On Thu, May 29, 2008 at 11:36 AM, Jan Engelhardt <jengelh@medozas.de> wrote:
> >
> > On Thursday 2008-05-29 15:19, Miquel van Smoorenburg wrote:
> >>On Thu, 2008-05-29 at 10:00 -0300, Fausto Richetti Blanco wrote:
> >>
> >>Why not use a socketpair() instead of a pipe(). You can adjust the size
> >>with setsockopt SO_SNDBUF/SO_RCVBUF (see man socket(7))
> >
> > Nah, if there's lots of POST requests, and a large buffer for
> > each of it, you may end up running into allocation failures.
> 
> Well, I think it's an alternative.. A good one, indeed :)
> 
> However, I implemented it and run into the limit of /proc/sys/net/core/wmem_max
> 
> Do you guys think it's a big impact to change this to a higher value ?
> It's meant to only affect the MAX window size, right ? Does it have
> any other way of changing this limit (by process or by user, for
> exemple) ?
> 
> The strange thing here is that setsockopt doesn't fail if I change the
> size of the buffer to anything higher than
> /proc/sys/net/core/wmem_max. It doesn't work either :)
> 
> The implementation with socketpair, adjusting
> /proc/sys/net/core/wmem_max, seems good to me. However, I still think
> dynamic buffers for pipes a good idea.

I have an old patch that does that, I just looked it up and it was last
updated for 2.6.23. It uses fcntl() with F_SETPIPE_SZ for getting and
setting the pipe size.

Patch updated, the below is the current Linus kernel.

diff --git a/fs/fcntl.c b/fs/fcntl.c
index bfd7765..aea3f5b 100644
--- a/fs/fcntl.c
+++ b/fs/fcntl.c
@@ -15,6 +15,7 @@
 #include <linux/smp_lock.h>
 #include <linux/slab.h>
 #include <linux/module.h>
+#include <linux/pipe_fs_i.h>
 #include <linux/security.h>
 #include <linux/ptrace.h>
 #include <linux/signal.h>
@@ -370,6 +371,10 @@ static long do_fcntl(int fd, unsigned int cmd, unsigned long arg,
 	case F_NOTIFY:
 		err = fcntl_dirnotify(fd, filp, arg);
 		break;
+	case F_SETPIPE_SZ:
+	case F_GETPIPE_SZ:
+		err = pipe_fcntl(filp, cmd, arg);
+		break;
 	default:
 		break;
 	}
diff --git a/fs/pipe.c b/fs/pipe.c
index ec228bc..d6b5c7e 100644
--- a/fs/pipe.c
+++ b/fs/pipe.c
@@ -11,6 +11,7 @@
 #include <linux/module.h>
 #include <linux/init.h>
 #include <linux/fs.h>
+#include <linux/log2.h>
 #include <linux/mount.h>
 #include <linux/pipe_fs_i.h>
 #include <linux/uio.h>
@@ -342,7 +343,7 @@ redo:
 			if (!buf->len) {
 				buf->ops = NULL;
 				ops->release(pipe, buf);
-				curbuf = (curbuf + 1) & (PIPE_BUFFERS-1);
+				curbuf = (curbuf + 1) & (pipe->buffers - 1);
 				pipe->curbuf = curbuf;
 				pipe->nrbufs = --bufs;
 				do_wakeup = 1;
@@ -424,7 +425,7 @@ pipe_write(struct kiocb *iocb, const struct iovec *_iov,
 	chars = total_len & (PAGE_SIZE-1); /* size of the last buffer */
 	if (pipe->nrbufs && chars != 0) {
 		int lastbuf = (pipe->curbuf + pipe->nrbufs - 1) &
-							(PIPE_BUFFERS-1);
+							(pipe->buffers - 1);
 		struct pipe_buffer *buf = pipe->bufs + lastbuf;
 		const struct pipe_buf_operations *ops = buf->ops;
 		int offset = buf->offset + buf->len;
@@ -470,8 +471,8 @@ redo1:
 			break;
 		}
 		bufs = pipe->nrbufs;
-		if (bufs < PIPE_BUFFERS) {
-			int newbuf = (pipe->curbuf + bufs) & (PIPE_BUFFERS-1);
+		if (bufs < pipe->buffers) {
+			int newbuf = (pipe->curbuf + bufs) & (pipe->buffers-1);
 			struct pipe_buffer *buf = pipe->bufs + newbuf;
 			struct page *page = pipe->tmp_page;
 			char *src;
@@ -532,7 +533,7 @@ redo2:
 			if (!total_len)
 				break;
 		}
-		if (bufs < PIPE_BUFFERS)
+		if (bufs < pipe->buffers)
 			continue;
 		if (filp->f_flags & O_NONBLOCK) {
 			if (!ret)
@@ -592,7 +593,7 @@ static long pipe_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
 			nrbufs = pipe->nrbufs;
 			while (--nrbufs >= 0) {
 				count += pipe->bufs[buf].len;
-				buf = (buf+1) & (PIPE_BUFFERS-1);
+				buf = (buf+1) & (pipe->buffers - 1);
 			}
 			mutex_unlock(&inode->i_mutex);
 
@@ -623,7 +624,7 @@ pipe_poll(struct file *filp, poll_table *wait)
 	}
 
 	if (filp->f_mode & FMODE_WRITE) {
-		mask |= (nrbufs < PIPE_BUFFERS) ? POLLOUT | POLLWRNORM : 0;
+		mask |= (nrbufs < pipe->buffers) ? POLLOUT | POLLWRNORM : 0;
 		/*
 		 * Most Unices do not set POLLERR for FIFOs but on Linux they
 		 * behave exactly like pipes for poll().
@@ -858,25 +859,32 @@ struct pipe_inode_info * alloc_pipe_info(struct inode *inode)
 
 	pipe = kzalloc(sizeof(struct pipe_inode_info), GFP_KERNEL);
 	if (pipe) {
-		init_waitqueue_head(&pipe->wait);
-		pipe->r_counter = pipe->w_counter = 1;
-		pipe->inode = inode;
+		pipe->bufs = kzalloc(sizeof(struct pipe_buffer) * PIPE_DEF_BUFFERS, GFP_KERNEL);
+		if (pipe->bufs) {
+			init_waitqueue_head(&pipe->wait);
+			pipe->r_counter = pipe->w_counter = 1;
+			pipe->inode = inode;
+			pipe->buffers = PIPE_DEF_BUFFERS;
+			return pipe;
+		}
+		kfree(pipe);
 	}
 
-	return pipe;
+	return NULL;
 }
 
 void __free_pipe_info(struct pipe_inode_info *pipe)
 {
 	int i;
 
-	for (i = 0; i < PIPE_BUFFERS; i++) {
+	for (i = 0; i < pipe->buffers; i++) {
 		struct pipe_buffer *buf = pipe->bufs + i;
 		if (buf->ops)
 			buf->ops->release(pipe, buf);
 	}
 	if (pipe->tmp_page)
 		__free_page(pipe->tmp_page);
+	kfree(pipe->bufs);
 	kfree(pipe);
 }
 
@@ -1097,6 +1105,81 @@ asmlinkage long __weak sys_pipe(int __user *fildes)
 }
 
 /*
+ * Allocate a new array of pipe buffers and copy the info over. Returns the
+ * pipe size if successful, or return -ERROR on error.
+ */
+static long pipe_set_size(struct pipe_inode_info *pipe, unsigned long arg)
+{
+	struct pipe_buffer *bufs;
+
+	/*
+	 * Must be a power-of-2 currently
+	 */
+	if (!is_power_of_2(arg))
+		return -EINVAL;
+
+	/*
+	 * We can shrink the pipe, if arg >= pipe->nrbufs. Since we don't
+	 * expect a lot of shrink+grow operations, just free and allocate
+	 * again like we would do for growing. If the pipe currently
+	 * contains more buffers than arg, then return busy.
+	 */
+	if (arg < pipe->nrbufs)
+		return -EBUSY;
+
+	bufs = kcalloc(arg, sizeof(struct pipe_buffer), GFP_KERNEL);
+	if (unlikely(!bufs))
+		return -ENOMEM;
+
+	/*
+	 * The pipe array wraps around, so just start the new one at zero
+	 * and adjust the indexes.
+	 */
+	if (pipe->nrbufs) {
+		const unsigned int tail = pipe->nrbufs & (pipe->buffers - 1);
+		const unsigned int head = pipe->nrbufs - tail;
+
+		if (head)
+			memcpy(bufs, pipe->bufs + pipe->curbuf, head * sizeof(struct pipe_buffer));
+		if (tail)
+			memcpy(bufs + head, pipe->bufs + pipe->curbuf, tail * sizeof(struct pipe_buffer));
+	}
+
+	pipe->curbuf = 0;
+	kfree(pipe->bufs);
+	pipe->bufs = bufs;
+	pipe->buffers = arg;
+	return arg;
+}
+
+long pipe_fcntl(struct file *file, unsigned int cmd, unsigned long arg)
+{
+	struct pipe_inode_info *pipe;
+	long ret;
+
+	pipe = file->f_path.dentry->d_inode->i_pipe;
+	if (!pipe)
+		return -EBADF;
+
+	mutex_lock(&pipe->inode->i_mutex);
+
+	switch (cmd) {
+	case F_SETPIPE_SZ:
+		ret = pipe_set_size(pipe, arg);
+		break;
+	case F_GETPIPE_SZ:
+		ret = pipe->buffers;
+		break;
+	default:
+		ret = -EINVAL;
+		break;
+	}
+
+	mutex_unlock(&pipe->inode->i_mutex);
+	return ret;
+}
+
+/*
  * pipefs should _never_ be mounted by userland - too much of security hassle,
  * no real gain from having the whole whorehouse mounted. So we don't need
  * any operations on the root directory. However, we need a non-trivial
diff --git a/fs/splice.c b/fs/splice.c
index aa5f6f6..8e11996 100644
--- a/fs/splice.c
+++ b/fs/splice.c
@@ -191,8 +191,8 @@ ssize_t splice_to_pipe(struct pipe_inode_info *pipe,
 			break;
 		}
 
-		if (pipe->nrbufs < PIPE_BUFFERS) {
-			int newbuf = (pipe->curbuf + pipe->nrbufs) & (PIPE_BUFFERS - 1);
+		if (pipe->nrbufs < pipe->buffers) {
+			int newbuf = (pipe->curbuf + pipe->nrbufs) & (pipe->buffers - 1);
 			struct pipe_buffer *buf = pipe->bufs + newbuf;
 
 			buf->page = spd->pages[page_nr];
@@ -212,7 +212,7 @@ ssize_t splice_to_pipe(struct pipe_inode_info *pipe,
 
 			if (!--spd->nr_pages)
 				break;
-			if (pipe->nrbufs < PIPE_BUFFERS)
+			if (pipe->nrbufs < pipe->buffers)
 				continue;
 
 			break;
@@ -265,6 +265,36 @@ static void spd_release_page(struct splice_pipe_desc *spd, unsigned int i)
 	page_cache_release(spd->pages[i]);
 }
 
+/*
+ * Check if we need to grow the arrays holding pages and partial page
+ * descriptions.
+ */
+int splice_grow_spd(struct pipe_inode_info *pipe, struct splice_pipe_desc *spd)
+{
+	if (pipe->buffers <= PIPE_DEF_BUFFERS)
+		return 0;
+
+	spd->pages = kmalloc(pipe->buffers * sizeof(struct page *), GFP_KERNEL);
+	spd->partial = kmalloc(pipe->buffers * sizeof(struct partial_page), GFP_KERNEL);
+
+	if (spd->pages && spd->partial)
+		return 0;
+
+	kfree(spd->pages);
+	kfree(spd->partial);
+	return -ENOMEM;
+}
+
+void splice_shrink_spd(struct pipe_inode_info *pipe,
+		       struct splice_pipe_desc *spd)
+{
+	if (pipe->buffers <= PIPE_DEF_BUFFERS)
+		return;
+
+	kfree(spd->pages);
+	kfree(spd->partial);
+}
+
 static int
 __generic_file_splice_read(struct file *in, loff_t *ppos,
 			   struct pipe_inode_info *pipe, size_t len,
@@ -272,8 +302,8 @@ __generic_file_splice_read(struct file *in, loff_t *ppos,
 {
 	struct address_space *mapping = in->f_mapping;
 	unsigned int loff, nr_pages, req_pages;
-	struct page *pages[PIPE_BUFFERS];
-	struct partial_page partial[PIPE_BUFFERS];
+	struct page *pages[PIPE_DEF_BUFFERS];
+	struct partial_page partial[PIPE_DEF_BUFFERS];
 	struct page *page;
 	pgoff_t index, end_index;
 	loff_t isize;
@@ -286,15 +316,18 @@ __generic_file_splice_read(struct file *in, loff_t *ppos,
 		.spd_release = spd_release_page,
 	};
 
+	if (splice_grow_spd(pipe, &spd))
+		return -ENOMEM;
+
 	index = *ppos >> PAGE_CACHE_SHIFT;
 	loff = *ppos & ~PAGE_CACHE_MASK;
 	req_pages = (len + loff + PAGE_CACHE_SIZE - 1) >> PAGE_CACHE_SHIFT;
-	nr_pages = min(req_pages, (unsigned)PIPE_BUFFERS);
+	nr_pages = min(req_pages, pipe->buffers);
 
 	/*
 	 * Lookup the (hopefully) full range of pages we need.
 	 */
-	spd.nr_pages = find_get_pages_contig(mapping, index, nr_pages, pages);
+	spd.nr_pages = find_get_pages_contig(mapping, index, nr_pages, spd.pages);
 	index += spd.nr_pages;
 
 	/*
@@ -335,7 +368,7 @@ __generic_file_splice_read(struct file *in, loff_t *ppos,
 			unlock_page(page);
 		}
 
-		pages[spd.nr_pages++] = page;
+		spd.pages[spd.nr_pages++] = page;
 		index++;
 	}
 
@@ -356,7 +389,7 @@ __generic_file_splice_read(struct file *in, loff_t *ppos,
 		 * this_len is the max we'll use from this page
 		 */
 		this_len = min_t(unsigned long, len, PAGE_CACHE_SIZE - loff);
-		page = pages[page_nr];
+		page = spd.pages[page_nr];
 
 		if (PageReadahead(page))
 			page_cache_async_readahead(mapping, &in->f_ra, in,
@@ -442,8 +475,8 @@ fill_it:
 			len = this_len;
 		}
 
-		partial[page_nr].offset = loff;
-		partial[page_nr].len = this_len;
+		spd.partial[page_nr].offset = loff;
+		spd.partial[page_nr].len = this_len;
 		len -= this_len;
 		loff = 0;
 		spd.nr_pages++;
@@ -455,12 +488,13 @@ fill_it:
 	 * we got, 'nr_pages' is how many pages are in the map.
 	 */
 	while (page_nr < nr_pages)
-		page_cache_release(pages[page_nr++]);
+		page_cache_release(spd.pages[page_nr++]);
 	in->f_ra.prev_pos = (loff_t)index << PAGE_CACHE_SHIFT;
 
 	if (spd.nr_pages)
-		return splice_to_pipe(pipe, &spd);
+		error = splice_to_pipe(pipe, &spd);
 
+	splice_shrink_spd(pipe, &spd);
 	return error;
 }
 
@@ -641,7 +675,7 @@ ssize_t __splice_from_pipe(struct pipe_inode_info *pipe, struct splice_desc *sd,
 			if (!buf->len) {
 				buf->ops = NULL;
 				ops->release(pipe, buf);
-				pipe->curbuf = (pipe->curbuf + 1) & (PIPE_BUFFERS - 1);
+				pipe->curbuf = (pipe->curbuf + 1) & (pipe->buffers - 1);
 				pipe->nrbufs--;
 				if (pipe->inode)
 					do_wakeup = 1;
@@ -1024,7 +1058,7 @@ out_release:
 	 * If we did an incomplete transfer we must release
 	 * the pipe buffers in question:
 	 */
-	for (i = 0; i < PIPE_BUFFERS; i++) {
+	for (i = 0; i < pipe->buffers; i++) {
 		struct pipe_buffer *buf = pipe->bufs + i;
 
 		if (buf->ops) {
@@ -1190,7 +1224,8 @@ static int copy_from_user_mmap_sem(void *dst, const void __user *src, size_t n)
  */
 static int get_iovec_page_array(const struct iovec __user *iov,
 				unsigned int nr_vecs, struct page **pages,
-				struct partial_page *partial, int aligned)
+				struct partial_page *partial, int aligned,
+				unsigned int pipe_buffers)
 {
 	int buffers = 0, error = 0;
 
@@ -1235,8 +1270,8 @@ static int get_iovec_page_array(const struct iovec __user *iov,
 			break;
 
 		npages = (off + len + PAGE_SIZE - 1) >> PAGE_SHIFT;
-		if (npages > PIPE_BUFFERS - buffers)
-			npages = PIPE_BUFFERS - buffers;
+		if (npages > pipe_buffers - buffers)
+			npages = pipe_buffers - buffers;
 
 		error = get_user_pages(current, current->mm,
 				       (unsigned long) base, npages, 0, 0,
@@ -1272,7 +1307,7 @@ static int get_iovec_page_array(const struct iovec __user *iov,
 		 * or if we mapped the max number of pages that we have
 		 * room for.
 		 */
-		if (error < npages || buffers == PIPE_BUFFERS)
+		if (error < npages || buffers == pipe_buffers)
 			break;
 
 		nr_vecs--;
@@ -1419,8 +1454,8 @@ static long vmsplice_to_pipe(struct file *file, const struct iovec __user *iov,
 			     unsigned long nr_segs, unsigned int flags)
 {
 	struct pipe_inode_info *pipe;
-	struct page *pages[PIPE_BUFFERS];
-	struct partial_page partial[PIPE_BUFFERS];
+	struct page *pages[PIPE_DEF_BUFFERS];
+	struct partial_page partial[PIPE_DEF_BUFFERS];
 	struct splice_pipe_desc spd = {
 		.pages = pages,
 		.partial = partial,
@@ -1428,17 +1463,25 @@ static long vmsplice_to_pipe(struct file *file, const struct iovec __user *iov,
 		.ops = &user_page_pipe_buf_ops,
 		.spd_release = spd_release_page,
 	};
+	long ret;
 
 	pipe = pipe_info(file->f_path.dentry->d_inode);
 	if (!pipe)
 		return -EBADF;
 
-	spd.nr_pages = get_iovec_page_array(iov, nr_segs, pages, partial,
-					    flags & SPLICE_F_GIFT);
+	if (splice_grow_spd(pipe, &spd))
+		return -ENOMEM;
+
+	spd.nr_pages = get_iovec_page_array(iov, nr_segs, spd.pages,
+					    spd.partial, flags & SPLICE_F_GIFT,
+					    pipe->buffers);
 	if (spd.nr_pages <= 0)
-		return spd.nr_pages;
+		ret = spd.nr_pages;
+	else
+		ret = splice_to_pipe(pipe, &spd);
 
-	return splice_to_pipe(pipe, &spd);
+	splice_shrink_spd(pipe, &spd);
+	return ret;
 }
 
 /*
@@ -1564,13 +1607,13 @@ static int link_opipe_prep(struct pipe_inode_info *pipe, unsigned int flags)
 	 * Check ->nrbufs without the inode lock first. This function
 	 * is speculative anyways, so missing one is ok.
 	 */
-	if (pipe->nrbufs < PIPE_BUFFERS)
+	if (pipe->nrbufs < pipe->buffers)
 		return 0;
 
 	ret = 0;
 	mutex_lock(&pipe->inode->i_mutex);
 
-	while (pipe->nrbufs >= PIPE_BUFFERS) {
+	while (pipe->nrbufs >= pipe->buffers) {
 		if (!pipe->readers) {
 			send_sig(SIGPIPE, current, 0);
 			ret = -EPIPE;
@@ -1622,11 +1665,11 @@ static int link_pipe(struct pipe_inode_info *ipipe,
 		 * If we have iterated all input buffers or ran out of
 		 * output room, break.
 		 */
-		if (i >= ipipe->nrbufs || opipe->nrbufs >= PIPE_BUFFERS)
+		if (i >= ipipe->nrbufs || opipe->nrbufs >= opipe->buffers)
 			break;
 
-		ibuf = ipipe->bufs + ((ipipe->curbuf + i) & (PIPE_BUFFERS - 1));
-		nbuf = (opipe->curbuf + opipe->nrbufs) & (PIPE_BUFFERS - 1);
+		ibuf = ipipe->bufs + ((ipipe->curbuf + i) & (ipipe->buffers-1));
+		nbuf = (opipe->curbuf + opipe->nrbufs) & (opipe->buffers - 1);
 
 		/*
 		 * Get a reference to this pipe buffer,
diff --git a/include/asm-generic/fcntl.h b/include/asm-generic/fcntl.h
index b847741..1d50973 100644
--- a/include/asm-generic/fcntl.h
+++ b/include/asm-generic/fcntl.h
@@ -73,6 +73,13 @@
 #define F_SETSIG	10	/* for sockets. */
 #define F_GETSIG	11	/* for sockets. */
 #endif
+#ifndef F_SETPIPE_SZ		/* for growing pipe sizes */
+#define F_SETPIPE_SZ	12
+#endif
+#ifndef F_GETPIPE_SZ
+#define F_GETPIPE_SZ	13
+#endif
+
 
 /* for F_[GET|SET]FL */
 #define FD_CLOEXEC	1	/* actually anything with low bit set goes */
diff --git a/include/linux/pipe_fs_i.h b/include/linux/pipe_fs_i.h
index 8e41202..4765076 100644
--- a/include/linux/pipe_fs_i.h
+++ b/include/linux/pipe_fs_i.h
@@ -3,7 +3,7 @@
 
 #define PIPEFS_MAGIC 0x50495045
 
-#define PIPE_BUFFERS (16)
+#define PIPE_DEF_BUFFERS	16
 
 #define PIPE_BUF_FLAG_LRU	0x01	/* page is on the LRU */
 #define PIPE_BUF_FLAG_ATOMIC	0x02	/* was atomically mapped */
@@ -44,17 +44,17 @@ struct pipe_buffer {
  **/
 struct pipe_inode_info {
 	wait_queue_head_t wait;
-	unsigned int nrbufs, curbuf;
-	struct page *tmp_page;
+	unsigned int nrbufs, curbuf, buffers;
 	unsigned int readers;
 	unsigned int writers;
 	unsigned int waiting_writers;
 	unsigned int r_counter;
 	unsigned int w_counter;
+	struct page *tmp_page;
 	struct fasync_struct *fasync_readers;
 	struct fasync_struct *fasync_writers;
 	struct inode *inode;
-	struct pipe_buffer bufs[PIPE_BUFFERS];
+	struct pipe_buffer *bufs;
 };
 
 /*
@@ -148,4 +148,7 @@ void generic_pipe_buf_get(struct pipe_inode_info *, struct pipe_buffer *);
 int generic_pipe_buf_confirm(struct pipe_inode_info *, struct pipe_buffer *);
 int generic_pipe_buf_steal(struct pipe_inode_info *, struct pipe_buffer *);
 
+/* for F_SETPIPE_SZ and F_GETPIPE_SZ */
+long pipe_fcntl(struct file *, unsigned int, unsigned long arg);
+
 #endif
diff --git a/include/linux/splice.h b/include/linux/splice.h
index 528dcb9..dcdb0b0 100644
--- a/include/linux/splice.h
+++ b/include/linux/splice.h
@@ -71,4 +71,11 @@ extern ssize_t splice_to_pipe(struct pipe_inode_info *,
 extern ssize_t splice_direct_to_actor(struct file *, struct splice_desc *,
 				      splice_direct_actor *);
 
+/*
+ * for dynamic pipe sizing
+ */
+extern int splice_grow_spd(struct pipe_inode_info *, struct splice_pipe_desc *);
+extern void splice_shrink_spd(struct pipe_inode_info *,
+				struct splice_pipe_desc *);
+
 #endif
diff --git a/kernel/relay.c b/kernel/relay.c
index 7de644c..5e71a9d 100644
--- a/kernel/relay.c
+++ b/kernel/relay.c
@@ -1108,8 +1108,8 @@ static int subbuf_splice_actor(struct file *in,
 	size_t read_subbuf = read_start / subbuf_size;
 	size_t padding = rbuf->padding[read_subbuf];
 	size_t nonpad_end = read_subbuf * subbuf_size + subbuf_size - padding;
-	struct page *pages[PIPE_BUFFERS];
-	struct partial_page partial[PIPE_BUFFERS];
+	struct page *pages[PIPE_DEF_BUFFERS];
+	struct partial_page partial[PIPE_DEF_BUFFERS];
 	struct splice_pipe_desc spd = {
 		.pages = pages,
 		.nr_pages = 0,
@@ -1121,6 +1121,8 @@ static int subbuf_splice_actor(struct file *in,
 
 	if (rbuf->subbufs_produced == rbuf->subbufs_consumed)
 		return 0;
+	if (splice_grow_spd(pipe, &spd))
+		return -ENOMEM;
 
 	/*
 	 * Adjust read len, if longer than what is available
@@ -1165,16 +1167,19 @@ static int subbuf_splice_actor(struct file *in,
 		}
 	}
 
+	ret = 0;
 	if (!spd.nr_pages)
-		return 0;
+		goto out;
 
 	ret = *nonpad_ret = splice_to_pipe(pipe, &spd);
 	if (ret < 0 || ret < total_len)
-		return ret;
+		goto out;
 
         if (read_start + ret == nonpad_end)
                 ret += padding;
 
+out:
+	splice_shrink_spd(pipe, &spd);
         return ret;
 }
 

-- 
Jens Axboe

