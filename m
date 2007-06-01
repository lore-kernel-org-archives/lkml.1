Return-Path: <linux-kernel-owner+w=401wt.eu-S1753357AbXFACpd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753357AbXFACpd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2007 22:45:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751676AbXFACpZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 May 2007 22:45:25 -0400
Received: from ns1.suse.de ([195.135.220.2]:46850 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751107AbXFACpY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2007 22:45:24 -0400
From: Neil Brown <neilb@suse.de>
To: Jens Axboe <jens.axboe@oracle.com>
Date: Fri, 1 Jun 2007 12:44:30 +1000
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18015.34830.401191.916084@notabene.brown>
Cc: Christoph Hellwig <hch@infradead.org>, linux-kernel@vger.kernel.org,
       cotte@de.ibm.com, hugh@veritas.com, zanussi@us.ibm.com,
       Linus Torvalds <torvalds@osdl.org>
Subject: Re: [PATCH] sendfile removal (nfsd update)
In-Reply-To: message from Jens Axboe on Thursday May 31
References: <20070531103316.GO32105@kernel.dk>
	<20070531105543.GA25676@infradead.org>
	<20070531110550.GR32105@kernel.dk>
	<18014.48878.442628.260297@notabene.brown>
	<20070531122723.GT32105@kernel.dk>
X-Mailer: VM 7.19 under Emacs 21.4.1
X-face: [Gw_3E*Gng}4rRrKRYotwlE?.2|**#s9D<ml'fY1Vw+@XfR[fRCsUoP?K6bt3YD\ui5Fh?f
	LONpR';(ql)VM_TQ/<l_^D3~B:z$\YC7gUCuC=sYm/80G=$tt"98mr8(l))QzVKCk$6~gldn~*FK9x
	8`;pM{3S8679sP+MbP,72<3_PIH-$I&iaiIb|hV1d%cYg))BmI)AZ
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Ok, here is a patch that makes nfsd use splice instead of sendfile.
It appears to both compile and work.

Some observations:
  - __splice_from_pipe wants a "struct file*" and I wanted to pass a
    "struct svcrqst *".  Maybe it should take a void * ?
  - It also wants a *ppos which I had no use for.. It that really
    need?  Cannot &file->f_pos be used?
  - I copied do_splice_to from splice.c as it wasn't exported, and
    then found I couldn't compile because rw_verify_area wasn't
    exported. As nfsd doesn't need that (we never export
    mandatory-locking files) I just remove it and some other cruft
    that I didn't need.... Not sure if that was the best approach.
  - I needed to export alloc_pipe_info.  Maybe there should be a 
    get_current_pipe instead which does the alloc if needed.
  - I would much rather have something like free_pipe_info exported
    than open code it in do_splice_read (which is based heavily on
    do_splice_direct).
  
NeilBrown

-------------------------------
Replace ->sendfile with ->splice_read

Apparently ->sendfile is going away, so change nfsd to use ->splice_read
to get pages for a file.

Signed-off-by: Neil Brown <neilb@suse.de>

### Diffstat output
 ./fs/nfsd/vfs.c |  125 ++++++++++++++++++++++++++++++++++++++++++++++++--------
 ./fs/pipe.c     |    1 
 2 files changed, 109 insertions(+), 17 deletions(-)

diff .prev/fs/nfsd/vfs.c ./fs/nfsd/vfs.c
--- .prev/fs/nfsd/vfs.c	2007-06-01 10:41:27.000000000 +1000
+++ ./fs/nfsd/vfs.c	2007-06-01 12:32:51.000000000 +1000
@@ -23,7 +23,7 @@
 #include <linux/file.h>
 #include <linux/mount.h>
 #include <linux/major.h>
-#include <linux/ext2_fs.h>
+#include <linux/pipe_fs_i.h>
 #include <linux/proc_fs.h>
 #include <linux/stat.h>
 #include <linux/fcntl.h>
@@ -801,26 +801,32 @@ found:
 }
 
 /*
- * Grab and keep cached pages assosiated with a file in the svc_rqst
- * so that they can be passed to the netowork sendmsg/sendpage routines
- * directrly. They will be released after the sending has completed.
+ * Grab and keep cached pages associated with a file in the svc_rqst
+ * so that they can be passed to the network sendmsg/sendpage routines
+ * directly. They will be released after the sending has completed.
  */
 static int
-nfsd_read_actor(read_descriptor_t *desc, struct page *page, unsigned long offset , unsigned long size)
+nfsd_splice_actor(struct pipe_inode_info *pipe, struct pipe_buffer *buf,
+		  struct splice_desc *sd)
 {
-	unsigned long count = desc->count;
-	struct svc_rqst *rqstp = desc->arg.data;
+	struct svc_rqst *rqstp = (struct svc_rqst *)sd->file;
 	struct page **pp = rqstp->rq_respages + rqstp->rq_resused;
+	struct page *page = buf->page;
+	size_t size;
+	int ret;
+
+	ret = buf->ops->pin(pipe, buf);
+	if (unlikely(ret))
+		return ret;
 
-	if (size > count)
-		size = count;
+	size = sd->len;
 
 	if (rqstp->rq_res.page_len == 0) {
 		get_page(page);
 		put_page(*pp);
 		*pp = page;
 		rqstp->rq_resused++;
-		rqstp->rq_res.page_base = offset;
+		rqstp->rq_res.page_base = buf->offset;
 		rqstp->rq_res.page_len = size;
 	} else if (page != pp[-1]) {
 		get_page(page);
@@ -832,11 +838,98 @@ nfsd_read_actor(read_descriptor_t *desc,
 	} else
 		rqstp->rq_res.page_len += size;
 
-	desc->count = count - size;
-	desc->written += size;
 	return size;
 }
 
+static long do_splice_to(struct file *in, loff_t *ppos,
+			 struct pipe_inode_info *pipe, size_t len,
+			 unsigned int flags)
+{
+	loff_t isize, left;
+
+	isize = i_size_read(in->f_mapping->host);
+	if (unlikely(*ppos >= isize))
+		return 0;
+
+	left = isize - *ppos;
+	if (unlikely(left < len))
+		len = left;
+
+	return in->f_op->splice_read(in, ppos, pipe, len, flags);
+}
+
+static int do_splice_read(struct file *in, loff_t *ppos, size_t count,
+			  struct svc_rqst *rqstp)
+{
+	struct pipe_inode_info *pipe;
+	long ret, bytes;
+	int i;
+
+	rqstp->rq_resused = 1;
+
+	pipe = current->splice_pipe;
+	if (unlikely(!pipe)) {
+		pipe = alloc_pipe_info(NULL);
+		if (!pipe)
+			return -ENOMEM;
+
+		pipe->readers = 1;
+		current->splice_pipe = pipe;
+	}
+
+	ret = 0;
+	bytes = 0;
+
+	while (count) {
+		loff_t unused = 0;
+		size_t read_len, max_read_len;
+
+		max_read_len = min(count, (size_t)(PIPE_BUFFERS*PAGE_SIZE));
+
+		ret = do_splice_to(in, ppos, pipe, max_read_len, 0);
+		if (unlikely(ret < 0))
+			goto out_release;
+
+		read_len = ret;
+
+		ret = __splice_from_pipe(pipe, (struct file *)rqstp,
+					 &unused, read_len, 0,
+					 nfsd_splice_actor);
+		if (unlikely(ret < 0))
+			goto out_release;
+
+		bytes += ret;
+		count -= ret;
+	}
+
+	pipe->nrbufs = pipe->curbuf = 0;
+
+	return bytes;
+
+ out_release:
+	/*
+	 * If we did an incomplete transfer we must release
+	 * the pipe buffers in question:
+	 */
+	for (i = 0; i < PIPE_BUFFERS; i++) {
+		struct pipe_buffer *buf = pipe->bufs + i;
+
+		if (buf->ops) {
+			buf->ops->release(pipe, buf);
+			buf->ops = NULL;
+		}
+	}
+	pipe->nrbufs = pipe->curbuf = 0;
+
+	/*
+	 * If we transferred some data, return the number of bytes:
+	 */
+	if (bytes > 0)
+		return bytes;
+
+	return ret;
+}
+
 static __be32
 nfsd_vfs_read(struct svc_rqst *rqstp, struct svc_fh *fhp, struct file *file,
               loff_t offset, struct kvec *vec, int vlen, unsigned long *count)
@@ -861,11 +954,9 @@ nfsd_vfs_read(struct svc_rqst *rqstp, st
 	if (ra && ra->p_set)
 		file->f_ra = ra->p_ra;
 
-	if (file->f_op->sendfile && rqstp->rq_sendfile_ok) {
-		rqstp->rq_resused = 1;
-		host_err = file->f_op->sendfile(file, &offset, *count,
-						 nfsd_read_actor, rqstp);
-	} else {
+	if (file->f_op->splice_read && rqstp->rq_sendfile_ok)
+		host_err = do_splice_read(file, &offset, *count, rqstp);
+	else {
 		oldfs = get_fs();
 		set_fs(KERNEL_DS);
 		host_err = vfs_readv(file, (struct iovec __user *)vec, vlen, &offset);

diff .prev/fs/pipe.c ./fs/pipe.c
--- .prev/fs/pipe.c	2007-06-01 12:30:43.000000000 +1000
+++ ./fs/pipe.c	2007-06-01 12:31:58.000000000 +1000
@@ -865,6 +865,7 @@ struct pipe_inode_info * alloc_pipe_info
 
 	return pipe;
 }
+EXPORT_SYMBOL(alloc_pipe_info);
 
 void __free_pipe_info(struct pipe_inode_info *pipe)
 {
