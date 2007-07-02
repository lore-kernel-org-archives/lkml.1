Return-Path: <linux-kernel-owner+w=401wt.eu-S1755398AbXGBSO6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755398AbXGBSO6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jul 2007 14:14:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752566AbXGBSOw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jul 2007 14:14:52 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:50993 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752062AbXGBSOv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jul 2007 14:14:51 -0400
Subject: Re: [patch 00/14] Page cache cleanup in anticipation of Large
	Blocksize support
From: Badari Pulavarty <pbadari@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: clameter@sgi.com, lkml <linux-kernel@vger.kernel.org>,
       Christoph Hellwig <hch@infradead.org>
In-Reply-To: <20070614130645.cabdff1b.akpm@linux-foundation.org>
References: <20070614193839.878721298@sgi.com>
	 <20070614130645.cabdff1b.akpm@linux-foundation.org>
Content-Type: text/plain
Date: Mon, 02 Jul 2007 11:16:20 -0700
Message-Id: <1183400180.31959.14.camel@dyn9047017100.beaverton.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.0.4 (2.0.4-4) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-06-14 at 13:06 -0700, Andrew Morton wrote:
> On Thu, 14 Jun 2007 12:38:39 -0700
> clameter@sgi.com wrote:
> 
> > This patchset cleans up the page cache handling by replacing
> > open coded shifts and adds through inline function calls.
> 

Some of us (crazy) people are trying to support read for hugetlbfs
in order to get oprofile work on large-page-backed-executables by
libhugetlbfs.

Currently, I can't use any generic support. I have this ugly patch
to get oprofile work. Christoph's clean ups would allow me to set
per-mapping pagesize and get this to work, without any hacks.

Thanks,
Badari

 fs/hugetlbfs/inode.c |  117 +++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 117 insertions(+)

Index: linux/fs/hugetlbfs/inode.c
===================================================================
--- linux.orig/fs/hugetlbfs/inode.c	2007-05-18 04:16:27.000000000 -0700
+++ linux/fs/hugetlbfs/inode.c	2007-06-22 10:46:09.000000000 -0700
@@ -160,6 +160,122 @@ full_search:
 #endif
 
 /*
+ * Support for read()
+ */
+static int
+hugetlbfs_read_actor(struct page *page, unsigned long offset,
+			char __user *buf, unsigned long count,
+			unsigned long size)
+{
+	char *kaddr;
+	unsigned long to_copy;
+	int i, chunksize;
+
+	if (size > count)
+		size = count;
+
+	/* Find which 4k chunk and offset with in that chunk */
+	i = offset >> PAGE_CACHE_SHIFT;
+	offset = offset & ~PAGE_CACHE_MASK;
+	to_copy = size;
+
+	while (to_copy) {
+		chunksize = PAGE_CACHE_SIZE;
+		if (offset)
+			chunksize -= offset;
+		if (chunksize > to_copy)
+			chunksize = to_copy;
+
+#if 0
+printk("Coping i=%d page: %p offset %d chunk %d\n", i, &page[i], offset, chunksize);
+#endif
+		kaddr = kmap(&page[i]);
+		memcpy(buf, kaddr + offset, chunksize);
+		kunmap(&page[i]);
+		offset = 0;
+		to_copy -= chunksize;
+		buf += chunksize;
+		i++;
+	}
+	return size;
+}
+
+
+ssize_t
+hugetlbfs_read(struct file *filp, char __user *buf, size_t len, loff_t *ppos)
+{
+	struct address_space *mapping = filp->f_mapping;
+	struct inode *inode = mapping->host;
+	unsigned long index = *ppos >> HPAGE_SHIFT;
+	unsigned long end_index;
+	loff_t isize;
+	unsigned long offset;
+	ssize_t retval = 0;
+
+	/* validate user buffer and len */
+	if (len == 0)
+		goto out;
+
+	isize = i_size_read(inode);
+	if (!isize)
+		goto out;
+
+	offset = *ppos & ~HPAGE_MASK;
+	end_index = (isize - 1) >> HPAGE_SHIFT;
+	for (;;) {
+		struct page *page;
+		unsigned long nr, ret;
+
+		/* nr is the maximum number of bytes to copy from this page */
+		nr = HPAGE_SIZE;
+		if (index >= end_index) {
+			if (index > end_index)
+				goto out;
+			nr = ((isize - 1) & ~HPAGE_MASK) + 1;
+			if (nr <= offset) {
+				goto out;
+			}
+		}
+		nr = nr - offset;
+
+		/* Find the page */
+		page = find_get_page(mapping, index);
+		if (unlikely(page == NULL)) {
+			/*
+			 * We can't find the page in the cache - bail out
+			 * TODO - should we zero out the user buffer ?
+			 */
+			goto out;
+		}
+#if 0
+printk("Found page %p at index %d offset %d nr %d\n", page, index, offset, nr);
+#endif
+
+		/*
+		 * Ok, we have the page, so now we can copy it to user space...
+		 */
+		ret = hugetlbfs_read_actor(page, offset, buf, len, nr);
+		if (ret < 0) {
+			retval = retval ? : ret;
+			goto out;
+		}
+
+		offset += ret;
+		retval += ret;
+		len -= ret;
+		index += offset >> HPAGE_SHIFT;
+		offset &= ~HPAGE_MASK;
+
+		page_cache_release(page);
+		if (ret == nr && len)
+			continue;
+		goto out;
+	}
+out:
+	return retval;
+}
+
+/*
  * Read a page. Again trivial. If it didn't already exist
  * in the page cache, it is zero-filled.
  */
@@ -565,6 +681,7 @@ static void init_once(void *foo, kmem_ca
 }
 
 struct file_operations hugetlbfs_file_operations = {
+ 	.read			= hugetlbfs_read,
 	.mmap			= hugetlbfs_file_mmap,
 	.fsync			= simple_sync_file,
 	.get_unmapped_area	= hugetlb_get_unmapped_area,


