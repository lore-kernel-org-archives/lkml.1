Return-Path: <linux-kernel-owner+w=401wt.eu-S1760132AbXI1IGe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760132AbXI1IGe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2007 04:06:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758069AbXI1ICA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Sep 2007 04:02:00 -0400
Received: from mx1.redhat.com ([66.187.233.31]:51116 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756323AbXI1IBy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2007 04:01:54 -0400
Message-Id: <20070928080042.527431000@chello.nl>
References: <20070928074200.436463000@chello.nl>
User-Agent: quilt/0.45-1
Date: Fri, 28 Sep 2007 09:42:10 +0200
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: lkml <linux-kernel@vger.kernel.org>, linux-arch@vger.kernel.org
Cc: Zach Brown <zach.brown@oracle.com>, Ingo Molnar <mingo@elte.hu>,
       akpm@linux-foundation.org, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 10/12] lockdep: lock_page: handle IO-completions
Content-Disposition: inline; filename=lockdep-page-async.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

IO-completions unlock the page in interrupt context, which is not the same
context as that locked the page.

Avoid this problem by doing the unlock tracking when submitting the page for
IO.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 fs/buffer.c             |    4 +++-
 fs/mpage.c              |   19 +++++++++++++++----
 fs/nfs/read.c           |    4 +++-
 include/linux/pagemap.h |    5 +++++
 mm/page_io.c            |    3 ++-
 5 files changed, 28 insertions(+), 7 deletions(-)

Index: linux-2.6/fs/buffer.c
===================================================================
--- linux-2.6.orig/fs/buffer.c
+++ linux-2.6/fs/buffer.c
@@ -413,7 +413,7 @@ static void end_buffer_async_read(struct
 	 */
 	if (page_uptodate && !PageError(page))
 		SetPageUptodate(page);
-	unlock_page(page);
+	unlock_page_nocheck(page);
 	return;
 
 still_busy:
@@ -1988,6 +1988,8 @@ int block_read_full_page(struct page *pa
 		mark_buffer_async_read(bh);
 	}
 
+	unlock_page_check(page);
+
 	/*
 	 * Stage 3: start the IO.  Check for uptodateness
 	 * inside the buffer lock in case another process reading
Index: linux-2.6/fs/mpage.c
===================================================================
--- linux-2.6.orig/fs/mpage.c
+++ linux-2.6/fs/mpage.c
@@ -59,7 +59,7 @@ static int mpage_end_io_read(struct bio 
 			ClearPageUptodate(page);
 			SetPageError(page);
 		}
-		unlock_page(page);
+		unlock_page_nocheck(page);
 	} while (bvec >= bio->bi_io_vec);
 	bio_put(bio);
 	return 0;
@@ -92,9 +92,20 @@ static int mpage_end_io_write(struct bio
 
 static struct bio *mpage_bio_submit(int rw, struct bio *bio)
 {
-	bio->bi_end_io = mpage_end_io_read;
-	if (rw == WRITE)
-		bio->bi_end_io = mpage_end_io_write;
+	bio->bi_end_io = mpage_end_io_write;
+	if (rw == READ) {
+		struct bio_vec *bvec = bio->bi_io_vec;
+		int i;
+
+		bio->bi_end_io = mpage_end_io_read;
+
+		for (i = 0; i < bio->bi_vcnt; i++) {
+			struct page *page = bvec[i].bv_page;
+
+			if (page)
+				unlock_page_check(page);
+		}
+	}
 	submit_bio(rw, bio);
 	return NULL;
 }
Index: linux-2.6/fs/nfs/read.c
===================================================================
--- linux-2.6.orig/fs/nfs/read.c
+++ linux-2.6/fs/nfs/read.c
@@ -137,12 +137,13 @@ static int nfs_readpage_async(struct nfs
 		nfs_pagein_multi(inode, &one_request, 1, len, 0);
 	else
 		nfs_pagein_one(inode, &one_request, 1, len, 0);
+	unlock_page_check(page);
 	return 0;
 }
 
 static void nfs_readpage_release(struct nfs_page *req)
 {
-	unlock_page(req->wb_page);
+	unlock_page_nocheck(req->wb_page);
 
 	dprintk("NFS: read done (%s/%Ld %d@%Ld)\n",
 			req->wb_context->path.dentry->d_inode->i_sb->s_id,
@@ -540,6 +541,7 @@ readpage_async_filler(void *data, struct
 	if (len < PAGE_CACHE_SIZE)
 		zero_user_page(page, len, PAGE_CACHE_SIZE - len, KM_USER0);
 	nfs_pageio_add_request(desc->pgio, new);
+	unlock_page_check(page);
 	return 0;
 out_error:
 	error = PTR_ERR(new);
Index: linux-2.6/mm/page_io.c
===================================================================
--- linux-2.6.orig/mm/page_io.c
+++ linux-2.6/mm/page_io.c
@@ -92,7 +92,7 @@ int end_swap_bio_read(struct bio *bio, u
 	} else {
 		SetPageUptodate(page);
 	}
-	unlock_page(page);
+	unlock_page_nocheck(page);
 	bio_put(bio);
 	return 0;
 }
@@ -144,6 +144,7 @@ int swap_readpage(struct file *file, str
 	}
 	count_vm_event(PSWPIN);
 	submit_bio(READ, bio);
+	unlock_page_check(page);
 out:
 	return ret;
 }
Index: linux-2.6/include/linux/pagemap.h
===================================================================
--- linux-2.6.orig/include/linux/pagemap.h
+++ linux-2.6/include/linux/pagemap.h
@@ -189,6 +189,11 @@ static inline void unlock_page(struct pa
 	unlock_page_nocheck(page);
 }
 
+static inline void unlock_page_check(struct page *page)
+{
+	__unlock_page_check(page, _RET_IP_);
+}
+
 /*
  * lock_page_nosync should only be used if we can't pin the page's inode.
  * Doesn't play quite so well with block device plugging.

--

