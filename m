Return-Path: <linux-kernel-owner+w=401wt.eu-S1422750AbXCGSDM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422750AbXCGSDM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2007 13:03:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422956AbXCGSCt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Mar 2007 13:02:49 -0500
Received: from 64.221.212.177.ptr.us.xo.net ([64.221.212.177]:21078 "EHLO
	ext.agami.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1422757AbXCGSCo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2007 13:02:44 -0500
X-Greylist: delayed 3479 seconds by postgrey-1.27 at vger.kernel.org; Wed, 07 Mar 2007 13:02:43 EST
Message-ID: <45EEF0B5.40905@agami.com>
Date: Wed, 07 Mar 2007 09:04:53 -0800
From: Michael Nishimoto <miken@agami.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.7.2) Gecko/20040804 Netscape/7.2 (ax)
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: Christoph Hellwig <hch@lst.de>
CC: xfs@oss.sgi.com, ecashin@coraid.com, akpm@osdl.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] xfs: stop using kmalloc in xfs_buf_get_noaddr
References: <20070307101324.GC30587@lst.de>
In-Reply-To: <20070307101324.GC30587@lst.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 07 Mar 2007 17:04:47.0821 (UTC) FILETIME=[B622A7D0:01C760DA]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Incore log buffers are not always a power of two of the page size.
In particular, when xfs is running over software raid devices, the
log buffers are allocated to match the size of a stripe.

However, they are always a multiple of PAGE_SIZE, so we are still safe.

   Michael

Christoph Hellwig wrote:

>Currently xfs_buf_get_noaddr allocates memory using kmem_alloc which
>can end up either in kmalloc or vmalloc and assigns it to the buffer.
>This patch changes it to allocate individual pages and if there is
>more then one maps it into kernel virtual space using vmap.
>
>This means the minimum buffer allocation is PAGE_SIZE now.  For two
>of the three caller (log buffers, log recovery) that is perfectly
>fine, because they always allocate buffers that are a power of two
>of the page size anyway.  For xfs_zero_remaining_bytes the minimum
>allocation goes up from blocksize to pagesize and thus there is
>a potential waste of memory for blocksize < pagesize allocations,
>which is unfortunate but not directly solveable when block
>drivers expect reference countable pages.  To fix this waste
>xfs_zero_remaining_bytes could be rewritten to zero more than
>a single block at a time, which sounds like a good idea in general.
>
>
>Signed-off-by: Christoph Hellwig <hch@lst.de>
>
>Index: linux-2.6/fs/xfs/linux-2.6/xfs_buf.c
>===================================================================
>--- linux-2.6.orig/fs/xfs/linux-2.6/xfs_buf.c	2007-03-05 15:54:40.000000000 +0100
>+++ linux-2.6/fs/xfs/linux-2.6/xfs_buf.c	2007-03-05 15:54:47.000000000 +0100
>@@ -314,7 +314,7 @@
> 
> 	ASSERT(list_empty(&bp->b_hash_list));
> 
>-	if (bp->b_flags & _XBF_PAGE_CACHE) {
>+	if (bp->b_flags & (_XBF_PAGE_CACHE|_XBF_PAGES)) {
> 		uint		i;
> 
> 		if ((bp->b_flags & XBF_MAPPED) && (bp->b_page_count > 1))
>@@ -323,18 +323,11 @@
> 		for (i = 0; i < bp->b_page_count; i++) {
> 			struct page	*page = bp->b_pages[i];
> 
>-			ASSERT(!PagePrivate(page));
>+			if (bp->b_flags & _XBF_PAGE_CACHE)
>+				ASSERT(!PagePrivate(page));
> 			page_cache_release(page);
> 		}
> 		_xfs_buf_free_pages(bp);
>-	} else if (bp->b_flags & _XBF_KMEM_ALLOC) {
>-		 /*
>-		  * XXX(hch): bp->b_count_desired might be incorrect (see
>-		  * xfs_buf_associate_memory for details), but fortunately
>-		  * the Linux version of kmem_free ignores the len argument..
>-		  */
>-		kmem_free(bp->b_addr, bp->b_count_desired);
>-		_xfs_buf_free_pages(bp);
> 	}
> 
> 	xfs_buf_deallocate(bp);
>@@ -764,41 +757,41 @@
> 	size_t			len,
> 	xfs_buftarg_t		*target)
> {
>-	size_t			malloc_len = len;
>+	unsigned long		page_count = PAGE_ALIGN(len) >> PAGE_SHIFT;
>+	int			error, i;
> 	xfs_buf_t		*bp;
>-	void			*data;
>-	int			error;
> 
> 	bp = xfs_buf_allocate(0);
> 	if (unlikely(bp == NULL))
> 		goto fail;
> 	_xfs_buf_initialize(bp, target, 0, len, 0);
> 
>- try_again:
>-	data = kmem_alloc(malloc_len, KM_SLEEP | KM_MAYFAIL | KM_LARGE);
>-	if (unlikely(data == NULL))
>+	error = _xfs_buf_get_pages(bp, page_count, 0);
>+	if (error)
> 		goto fail_free_buf;
> 
>-	/* check whether alignment matches.. */
>-	if ((__psunsigned_t)data !=
>-	    ((__psunsigned_t)data & ~target->bt_smask)) {
>-		/* .. else double the size and try again */
>-		kmem_free(data, malloc_len);
>-		malloc_len <<= 1;
>-		goto try_again;
>-	}
>-
>-	error = xfs_buf_associate_memory(bp, data, len);
>-	if (error)
>+	for (i = 0; i < page_count; i++) {
>+		bp->b_pages[i] = alloc_page(GFP_KERNEL);
>+		if (!bp->b_pages[i])
>+			goto fail_free_mem;
>+	}
>+	bp->b_flags |= _XBF_PAGES;
>+
>+	error = _xfs_buf_map_pages(bp, XBF_MAPPED);
>+	if (unlikely(error)) {
>+		printk(KERN_WARNING "%s: failed to map pages\n",
>+				__FUNCTION__);
> 		goto fail_free_mem;
>-	bp->b_flags |= _XBF_KMEM_ALLOC;
>+	}
> 
> 	xfs_buf_unlock(bp);
> 
> 	XB_TRACE(bp, "no_daddr", data);
> 	return bp;
>+
>  fail_free_mem:
>-	kmem_free(data, malloc_len);
>+ 	for ( ; i >= 0; i++)
>+		__free_page(bp->b_pages[i]);
>  fail_free_buf:
> 	xfs_buf_free(bp);
>  fail:
>Index: linux-2.6/fs/xfs/linux-2.6/xfs_buf.h
>===================================================================
>--- linux-2.6.orig/fs/xfs/linux-2.6/xfs_buf.h	2007-03-05 15:54:40.000000000 +0100
>+++ linux-2.6/fs/xfs/linux-2.6/xfs_buf.h	2007-03-05 15:55:06.000000000 +0100
>@@ -63,7 +63,7 @@
> 
> 	/* flags used only internally */
> 	_XBF_PAGE_CACHE = (1 << 17),/* backed by pagecache		   */
>-	_XBF_KMEM_ALLOC = (1 << 18),/* backed by kmem_alloc()		   */
>+	_XBF_PAGES = (1 << 18),	    /* backed by refcounted pages	   */
> 	_XBF_RUN_QUEUES = (1 << 19),/* run block device task queue	   */
> 	_XBF_DELWRI_Q = (1 << 21),   /* buffer on delwri queue		   */
> } xfs_buf_flags_t;
>
>
>  
>

