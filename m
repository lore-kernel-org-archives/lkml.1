Return-Path: <linux-kernel-owner+w=401wt.eu-S1757351AbXFAIRE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757351AbXFAIRE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2007 04:17:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752311AbXFAIQt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Jun 2007 04:16:49 -0400
Received: from brick.kernel.dk ([80.160.20.94]:28346 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751615AbXFAIQs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2007 04:16:48 -0400
Date: Fri, 1 Jun 2007 10:15:36 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Christoph Hellwig <hch@infradead.org>, linux-kernel@vger.kernel.org,
       cotte@de.ibm.com, hugh@veritas.com, neilb@suse.de, zanussi@us.ibm.com,
       Linus Torvalds <torvalds@osdl.org>
Subject: Re: [PATCH] sendfile removal
Message-ID: <20070601081536.GO32105@kernel.dk>
References: <20070531103316.GO32105@kernel.dk> <20070531105543.GA25676@infradead.org> <20070531110550.GR32105@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070531110550.GR32105@kernel.dk>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 31 2007, Jens Axboe wrote:
> > This change is wrong.  loop or any existing user of ->sendfile absolutely
> > needs to go through a file operations vector so that file-system specific
> > actions such as locking are performed.  This is required at least for the
> > clustered filesystems and XFS.   The right way to implement this is
> > via do_splice_direct or something similar.
> > 
> > do_generic_file_read is only a library function for filesystem use
> > and should never be called directly.
> 
> I'll convert it to do_splice_direct(), thanks.

So how does this look? Totally untested, will do that now. It only
covers the read side, the write conversion to splice will happen later.

diff --git a/drivers/block/loop.c b/drivers/block/loop.c
index 92bac14..3714e60 100644
--- a/drivers/block/loop.c
+++ b/drivers/block/loop.c
@@ -74,6 +74,7 @@
 #include <linux/highmem.h>
 #include <linux/gfp.h>
 #include <linux/kthread.h>
+#include <linux/pipe_fs_i.h>
 
 #include <asm/uaccess.h>
 
@@ -401,58 +402,70 @@ struct lo_read_data {
 };
 
 static int
-lo_read_actor(read_descriptor_t *desc, struct page *page,
-	      unsigned long offset, unsigned long size)
+lo_splice_actor(struct pipe_inode_info *pipe, struct pipe_buffer *buf,
+		struct splice_desc *sd)
 {
-	unsigned long count = desc->count;
-	struct lo_read_data *p = desc->arg.data;
+	struct lo_read_data *p = sd->data;
 	struct loop_device *lo = p->lo;
+	struct page *page = buf->page;
 	sector_t IV;
+	size_t size;
+	int ret;
 
-	IV = ((sector_t) page->index << (PAGE_CACHE_SHIFT - 9))+(offset >> 9);
+	ret = buf->ops->pin(pipe, buf);
+	if (unlikely(ret))
+		return ret;
 
-	if (size > count)
-		size = count;
+	IV = ((sector_t) page->index << (PAGE_CACHE_SHIFT - 9))+(buf->offset >> 9);
+	size = sd->len;
 
-	if (lo_do_transfer(lo, READ, page, offset, p->page, p->offset, size, IV)) {
+	if (lo_do_transfer(lo, READ, page, buf->offset, p->page, p->offset, size, IV)) {
 		size = 0;
 		printk(KERN_ERR "loop: transfer error block %ld\n",
 		       page->index);
-		desc->error = -EINVAL;
+		size = -EINVAL;
 	}
 
 	flush_dcache_page(p->page);
 
-	desc->count = count - size;
-	desc->written += size;
-	p->offset += size;
+	if (size > 0)
+		p->offset += size;
 	return size;
 }
 
 static int
+lo_direct_splice_actor(struct pipe_inode_info *pipe, struct splice_desc *sd)
+{
+	return __splice_from_pipe(pipe, sd, lo_splice_actor);
+}
+
+static int
 do_lo_receive(struct loop_device *lo,
 	      struct bio_vec *bvec, int bsize, loff_t pos)
 {
 	struct lo_read_data cookie;
+	struct splice_desc sd;
 	struct file *file;
-	read_descriptor_t desc;
-
-	desc.written = 0;
-	desc.count = bvec->bv_len;
-	desc.arg.data = &cookie;
-	desc.error = 0;
+	int retval;
 
 	cookie.lo = lo;
 	cookie.page = bvec->bv_page;
 	cookie.offset = bvec->bv_offset;
 	cookie.bsize = bsize;
+
+	sd.len = 0;
+	sd.total_len = bsize;
+	sd.flags = 0;
+	sd.pos = pos;
+	sd.data = &cookie;
+
 	file = lo->lo_backing_file;
+	retval = splice_direct_to_actor(file, &sd, lo_direct_splice_actor);
 
-	do_generic_file_read(file, &pos, &desc, lo_read_actor);
-	if (desc.written)
-		return 0;
+	if (retval < 0)
+		return retval;
 
-	return desc.error;
+	return 0;
 }
 
 static int
@@ -687,8 +700,8 @@ static int loop_change_fd(struct loop_device *lo, struct file *lo_file,
 	if (!S_ISREG(inode->i_mode) && !S_ISBLK(inode->i_mode))
 		goto out_putf;
 
-	/* new backing store needs to support loop (eg readpage) */
-	if (!file->f_mapping->a_ops->readpage)
+	/* new backing store needs to support loop (eg splice_read) */
+	if (!inode->i_fop->splice_read)
 		goto out_putf;
 
 	/* size of the new backing store needs to be the same */
@@ -768,7 +781,7 @@ static int loop_set_fd(struct loop_device *lo, struct file *lo_file,
 		 * If we can't read - sorry. If we only can't write - well,
 		 * it's going to be read-only.
 		 */
-		if (!aops->readpage)
+		if (!file->f_op->splice_read)
 			goto out_putf;
 		if (aops->prepare_write && aops->commit_write)
 			lo_flags |= LO_FLAGS_USE_AOPS;

-- 
Jens Axboe

