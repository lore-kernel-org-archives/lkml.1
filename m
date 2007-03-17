Return-Path: <linux-kernel-owner+w=401wt.eu-S966003AbXCQAg0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966003AbXCQAg0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2007 20:36:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966005AbXCQAg0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Mar 2007 20:36:26 -0400
Received: from verein.lst.de ([213.95.11.210]:55818 "EHLO mail.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966003AbXCQAgY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2007 20:36:24 -0400
Date: Sat, 17 Mar 2007 01:36:17 +0100
From: Christoph Hellwig <hch@lst.de>
To: Timothy Shimmin <tes@sgi.com>
Cc: Christoph Hellwig <hch@lst.de>, xfs@oss.sgi.com, ecashin@coraid.com,
       akpm@osdl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] xfs: stop using kmalloc in xfs_buf_get_noaddr
Message-ID: <20070317003617.GB17362@lst.de>
References: <20070307101324.GC30587@lst.de> <20070309115511.GA20426@lst.de> <73E41C01F3C8F79AD31CEDAF@timothy-shimmins-power-mac-g5.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <73E41C01F3C8F79AD31CEDAF@timothy-shimmins-power-mac-g5.local>
User-Agent: Mutt/1.3.28i
X-Spam-Score: -0.001 () BAYES_44
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> It looks like you might need: for (i--; i >= 0; i--)
> (or: for (j = 0; j < i; j++) etc.)
> 
> Because if the initial alloc_page loop goes to completion then:
>  i == pagecount
> and if alloc_page loop terminates early then
>  bp->b_pages[i] == NULL
> So we have gone 1 too far in both cases and need to
> start free'ing back one.
> Unless I missed something.

No, I was missing something :)

Here's the updated version:


Index: linux-2.6/fs/xfs/linux-2.6/xfs_buf.c
===================================================================
--- linux-2.6.orig/fs/xfs/linux-2.6/xfs_buf.c	2007-03-16 15:32:20.000000000 +0100
+++ linux-2.6/fs/xfs/linux-2.6/xfs_buf.c	2007-03-16 15:35:10.000000000 +0100
@@ -314,7 +314,7 @@ xfs_buf_free(
 
 	ASSERT(list_empty(&bp->b_hash_list));
 
-	if (bp->b_flags & _XBF_PAGE_CACHE) {
+	if (bp->b_flags & (_XBF_PAGE_CACHE|_XBF_PAGES)) {
 		uint		i;
 
 		if ((bp->b_flags & XBF_MAPPED) && (bp->b_page_count > 1))
@@ -323,18 +323,11 @@ xfs_buf_free(
 		for (i = 0; i < bp->b_page_count; i++) {
 			struct page	*page = bp->b_pages[i];
 
-			ASSERT(!PagePrivate(page));
+			if (bp->b_flags & _XBF_PAGE_CACHE)
+				ASSERT(!PagePrivate(page));
 			page_cache_release(page);
 		}
 		_xfs_buf_free_pages(bp);
-	} else if (bp->b_flags & _XBF_KMEM_ALLOC) {
-		 /*
-		  * XXX(hch): bp->b_count_desired might be incorrect (see
-		  * xfs_buf_associate_memory for details), but fortunately
-		  * the Linux version of kmem_free ignores the len argument..
-		  */
-		kmem_free(bp->b_addr, bp->b_count_desired);
-		_xfs_buf_free_pages(bp);
 	}
 
 	xfs_buf_deallocate(bp);
@@ -764,41 +757,41 @@ xfs_buf_get_noaddr(
 	size_t			len,
 	xfs_buftarg_t		*target)
 {
-	size_t			malloc_len = len;
+	unsigned long		page_count = PAGE_ALIGN(len) >> PAGE_SHIFT;
+	int			error, i;
 	xfs_buf_t		*bp;
-	void			*data;
-	int			error;
 
 	bp = xfs_buf_allocate(0);
 	if (unlikely(bp == NULL))
 		goto fail;
 	_xfs_buf_initialize(bp, target, 0, len, 0);
 
- try_again:
-	data = kmem_alloc(malloc_len, KM_SLEEP | KM_MAYFAIL | KM_LARGE);
-	if (unlikely(data == NULL))
+	error = _xfs_buf_get_pages(bp, page_count, 0);
+	if (error)
 		goto fail_free_buf;
 
-	/* check whether alignment matches.. */
-	if ((__psunsigned_t)data !=
-	    ((__psunsigned_t)data & ~target->bt_smask)) {
-		/* .. else double the size and try again */
-		kmem_free(data, malloc_len);
-		malloc_len <<= 1;
-		goto try_again;
-	}
-
-	error = xfs_buf_associate_memory(bp, data, len);
-	if (error)
+	for (i = 0; i < page_count; i++) {
+		bp->b_pages[i] = alloc_page(GFP_KERNEL);
+		if (!bp->b_pages[i])
+			goto fail_free_mem;
+	}
+	bp->b_flags |= _XBF_PAGES;
+
+	error = _xfs_buf_map_pages(bp, XBF_MAPPED);
+	if (unlikely(error)) {
+		printk(KERN_WARNING "%s: failed to map pages\n",
+				__FUNCTION__);
 		goto fail_free_mem;
-	bp->b_flags |= _XBF_KMEM_ALLOC;
+	}
 
 	xfs_buf_unlock(bp);
 
 	XB_TRACE(bp, "no_daddr", data);
 	return bp;
+
  fail_free_mem:
-	kmem_free(data, malloc_len);
+ 	while (--i >= 0)
+		__free_page(bp->b_pages[i]);
  fail_free_buf:
 	xfs_buf_free(bp);
  fail:
Index: linux-2.6/fs/xfs/linux-2.6/xfs_buf.h
===================================================================
--- linux-2.6.orig/fs/xfs/linux-2.6/xfs_buf.h	2007-03-13 18:18:05.000000000 +0100
+++ linux-2.6/fs/xfs/linux-2.6/xfs_buf.h	2007-03-16 15:34:20.000000000 +0100
@@ -63,7 +63,7 @@ typedef enum {
 
 	/* flags used only internally */
 	_XBF_PAGE_CACHE = (1 << 17),/* backed by pagecache		   */
-	_XBF_KMEM_ALLOC = (1 << 18),/* backed by kmem_alloc()		   */
+	_XBF_PAGES = (1 << 18),	    /* backed by refcounted pages	   */
 	_XBF_RUN_QUEUES = (1 << 19),/* run block device task queue	   */
 	_XBF_DELWRI_Q = (1 << 21),   /* buffer on delwri queue		   */
 } xfs_buf_flags_t;
