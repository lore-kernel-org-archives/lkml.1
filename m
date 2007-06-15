Return-Path: <linux-kernel-owner+w=401wt.eu-S1754919AbXFOGMz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754919AbXFOGMz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2007 02:12:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752315AbXFOGMs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jun 2007 02:12:48 -0400
Received: from brick.kernel.dk ([80.160.20.94]:1157 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752162AbXFOGMr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2007 02:12:47 -0400
Date: Fri, 15 Jun 2007 08:12:58 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Carsten Otte <cotte@de.ibm.com>
Cc: Hugh Dickins <hugh@veritas.com>, linux-kernel@vger.kernel.org,
       jaredeh@gmail.com, Christian Borntraeger <cborntra@de.ibm.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: Re: [patch] xip sendfile removal
Message-ID: <20070615061258.GL6149@kernel.dk>
References: <1181835707.7222.13.camel@cotte.boeblingen.de.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1181835707.7222.13.camel@cotte.boeblingen.de.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 14 2007, Carsten Otte wrote:
> This patch removes xip_file_sendfile, the sendfile implementation for
> xip without replacement. Those customers that use xip on s390 are not
> using sendfile() as far as we know, and so far s390 is the only platform
> this could potentially be used on so far.
> Having sendfile is not a popular feature for execute in place file
> systems, however we have a working implementation of splice_read() based
> on fs/splice.c if anyone asks for it.
> At this point in time, it does not seem preferable to merge
> splice_read() for xip because it causes extra maintenence effort due to
> code duplication and it requires struct page behind the xip memory
> segment. We'd like to get rid of that in favor of supporting flash based
> embedded platforms (Monta Vista work) soon.

Thanks Carsten, as discussed in private I will fold this in with the
splice series that removes sendfile. I'll post the splice ext2 xip patch
here for reference, so that it'll at least always be in the archives :-)

>From 7bb62072ffde311a9efd730fb9e004f016e776e5 Mon Sep 17 00:00:00 2001
From: Carsten Otte <cotte@de.ibm.com>
Date: Tue, 12 Jun 2007 08:48:48 +0200
Subject: [PATCH] ext2 xip: replace sendfile with splice

This patch removes xip_file_sendfile, and replaces it with
xip_file_splice_read. It passes the ltp testcase on a ext2 filesystem
that is mounted -o xip,rw.
I am not exactly happy with this patch, because it introduces waaaay too
much code duplication from fs/splice.c. I want to dig into making
generic_file_splice_read able to deal with xip files aswell. That would
allow to do the same for splice write.
If I cannot find a nicer solution, I'd vote for removing sendfile from
filemap_xip without replacement: a xip filesystem is intended to be used
for executables and libraries. This content is very rarely subject to
splice.

Signed-off-by: Carsten Otte <cotte@de.ibm.com>
Signed-off-by: Jens Axboe <jens.axboe@oracle.com>
---
 fs/ext2/file.c     |    2 +-
 include/linux/fs.h |    4 +-
 mm/filemap_xip.c   |  206 ++++++++++++++++++++++++++++++++++++++++++++++++----
 3 files changed, 192 insertions(+), 20 deletions(-)

diff --git a/fs/ext2/file.c b/fs/ext2/file.c
index 072a190..5f4a17c 100644
--- a/fs/ext2/file.c
+++ b/fs/ext2/file.c
@@ -70,7 +70,7 @@ const struct file_operations ext2_xip_file_operations = {
 	.open		= generic_file_open,
 	.release	= ext2_release_file,
 	.fsync		= ext2_sync_file,
-	.sendfile	= xip_file_sendfile,
+	.splice_read	= xip_file_splice_read,
 };
 #endif
 
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 61ebf32..a5bf63e 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1764,13 +1764,11 @@ extern int nonseekable_open(struct inode * inode, struct file * filp);
 #ifdef CONFIG_FS_XIP
 extern ssize_t xip_file_read(struct file *filp, char __user *buf, size_t len,
 			     loff_t *ppos);
-extern ssize_t xip_file_sendfile(struct file *in_file, loff_t *ppos,
-				 size_t count, read_actor_t actor,
-				 void *target);
 extern int xip_file_mmap(struct file * file, struct vm_area_struct * vma);
 extern ssize_t xip_file_write(struct file *filp, const char __user *buf,
 			      size_t len, loff_t *ppos);
 extern int xip_truncate_page(struct address_space *mapping, loff_t from);
+extern ssize_t xip_file_splice_read(struct file *, loff_t *, struct pipe_inode_info *, size_t, unsigned int);
 #else
 static inline int xip_truncate_page(struct address_space *mapping, loff_t from)
 {
diff --git a/mm/filemap_xip.c b/mm/filemap_xip.c
index fa360e5..f1f3134 100644
--- a/mm/filemap_xip.c
+++ b/mm/filemap_xip.c
@@ -14,6 +14,7 @@
 #include <linux/uio.h>
 #include <linux/rmap.h>
 #include <linux/sched.h>
+#include <linux/splice.h>
 #include <asm/tlbflush.h>
 #include "filemap.h"
 
@@ -92,7 +93,11 @@ do_xip_mapping_read(struct address_space *mapping,
 		if (unlikely(IS_ERR(page))) {
 			if (PTR_ERR(page) == -ENODATA) {
 				/* sparse */
-				page = ZERO_PAGE(0);
+				page = xip_sparse_page();
+				if (!page) {
+					desc->error = -ENOMEM;
+					goto out;
+				}
 			} else {
 				desc->error = PTR_ERR(page);
 				goto out;
@@ -159,27 +164,196 @@ xip_file_read(struct file *filp, char __user *buf, size_t len, loff_t *ppos)
 }
 EXPORT_SYMBOL_GPL(xip_file_read);
 
-ssize_t
-xip_file_sendfile(struct file *in_file, loff_t *ppos,
-	     size_t count, read_actor_t actor, void *target)
+static int xip_pipe_buf_steal(struct pipe_inode_info *pipe,
+				   struct pipe_buffer *buf)
 {
-	read_descriptor_t desc;
+	return 1;
+}
 
-	if (!count)
+static void xip_pipe_buf_release(struct pipe_inode_info *pipe,
+					struct pipe_buffer *buf)
+{
+	page_cache_release(buf->page);
+}
+
+static const struct pipe_buf_operations xip_pipe_buf_ops = {
+	.can_merge = 0,
+	.pin = generic_pipe_buf_pin,
+	.get = generic_pipe_buf_get,
+	.map = generic_pipe_buf_map,
+	.unmap = generic_pipe_buf_unmap,
+	.release = xip_pipe_buf_release,
+	.steal = xip_pipe_buf_steal,
+};
+
+static int
+__xip_file_splice_read(struct file *in, loff_t *ppos,
+			   struct pipe_inode_info *pipe, size_t len,
+			   unsigned int flags)
+{
+	struct address_space *mapping = in->f_mapping;
+	unsigned int loff, nr_pages;
+	struct page *pages[PIPE_BUFFERS];
+	struct partial_page partial[PIPE_BUFFERS];
+	struct page *page;
+	pgoff_t index, end_index;
+	loff_t isize;
+	size_t total_len;
+	int error, page_nr;
+	struct splice_pipe_desc spd = {
+		.pages = pages,
+		.partial = partial,
+		.flags = flags,
+		.ops = &xip_pipe_buf_ops,
+	};
+
+	index = *ppos >> PAGE_CACHE_SHIFT;
+	loff = *ppos & ~PAGE_CACHE_MASK;
+	nr_pages = (len + loff + PAGE_CACHE_SIZE - 1) >> PAGE_CACHE_SHIFT;
+
+	if (nr_pages > PIPE_BUFFERS)
+		nr_pages = PIPE_BUFFERS;
+
+	error = 0;
+	total_len = 0;
+
+	spd.nr_pages = 0;
+	while (spd.nr_pages < nr_pages) {
+		page = mapping->a_ops->get_xip_page(mapping,
+			index*(PAGE_SIZE/512), 0);
+		if (!page) {
+			error = -EIO;
+			break;
+		}
+		if (unlikely(IS_ERR(page))) {
+			if (PTR_ERR(page) == -ENODATA) {
+				/* sparse */
+				page = xip_sparse_page();
+				if (!page) {
+					error = -ENOMEM;
+					break;
+				}
+			} else {
+				error = PTR_ERR(page);
+				break;
+			}
+		}
+		page_cache_get(page);
+		pages[spd.nr_pages++] = page;
+		index++;
+	}
+
+	/*
+	 * Now loop over the map and fill in the partial map
+	 */
+	index = *ppos >> PAGE_CACHE_SHIFT;
+	nr_pages = spd.nr_pages;
+	spd.nr_pages = 0;
+	for (page_nr = 0; page_nr < nr_pages; page_nr++) {
+		unsigned int this_len;
+
+		if (!len)
+			break;
+
+		/*
+		 * this_len is the max we'll use from this page
+		 */
+		this_len = min_t(unsigned long, len, PAGE_CACHE_SIZE - loff);
+		page = pages[page_nr];
+		isize = i_size_read(mapping->host);
+		end_index = (isize - 1) >> PAGE_CACHE_SHIFT;
+		if (unlikely(!isize || index > end_index))
+			break;
+
+		/*
+		 * if this is the last page, see if we need to shrink
+		 * the length and stop
+		 */
+		if (end_index == index) {
+			unsigned int plen;
+
+			/*
+			 * max good bytes in this page
+			 */
+			plen = ((isize - 1) & ~PAGE_CACHE_MASK) + 1;
+			if (plen <= loff)
+				break;
+
+			/*
+			 * force quit after adding this page
+			 */
+			this_len = min(this_len, plen - loff);
+			len = this_len;
+		}
+
+		partial[page_nr].offset = loff;
+		partial[page_nr].len = this_len;
+		len -= this_len;
+		loff = 0;
+		spd.nr_pages++;
+		index++;
+	}
+
+	if (spd.nr_pages)
+		return splice_to_pipe(pipe, &spd);
+
+	return error;
+}
+
+/**
+ * xip_file_splice_read - splice data from file to a pipe
+ * @in:		file to splice from
+ * @pipe:	pipe to splice to
+ * @len:	number of bytes to splice
+ * @flags:	splice modifier flags
+ *
+ * derived from generic_file_splice_read in fs/splice_read.c
+ */
+ssize_t xip_file_splice_read(struct file *in, loff_t *ppos,
+				 struct pipe_inode_info *pipe, size_t len,
+				 unsigned int flags)
+{
+	ssize_t spliced;
+	int ret;
+	loff_t isize, left;
+
+	BUG_ON(!in->f_mapping->a_ops->get_xip_page);
+
+	isize = i_size_read(in->f_mapping->host);
+	if (unlikely(*ppos >= isize))
 		return 0;
 
-	desc.written = 0;
-	desc.count = count;
-	desc.arg.data = target;
-	desc.error = 0;
+	left = isize - *ppos;
+	if (unlikely(left < len))
+		len = left;
 
-	do_xip_mapping_read(in_file->f_mapping, &in_file->f_ra, in_file,
-			    ppos, &desc, actor);
-	if (desc.written)
-		return desc.written;
-	return desc.error;
+	ret = 0;
+	spliced = 0;
+	while (len) {
+		ret = __xip_file_splice_read(in, ppos, pipe, len, flags);
+
+		if (ret < 0)
+			break;
+		else if (!ret) {
+			if (spliced)
+				break;
+			if (flags & SPLICE_F_NONBLOCK) {
+				ret = -EAGAIN;
+				break;
+			}
+		}
+
+		*ppos += ret;
+		len -= ret;
+		spliced += ret;
+	}
+
+	if (spliced)
+		return spliced;
+
+	return ret;
 }
-EXPORT_SYMBOL_GPL(xip_file_sendfile);
+EXPORT_SYMBOL(xip_file_splice_read);
 
 /*
  * __xip_unmap is invoked from xip_unmap and
-- 
1.5.2.1.174.gcd03


-- 
Jens Axboe

