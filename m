Return-Path: <linux-kernel-owner+w=401wt.eu-S1761947AbXGQPlj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761947AbXGQPlj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2007 11:41:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762696AbXGQPky
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jul 2007 11:40:54 -0400
Received: from mx1.redhat.com ([66.187.233.31]:45373 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934558AbXGQPkw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2007 11:40:52 -0400
Message-Id: <20070717173758.018232000@chello.nl>
References: <20070717173428.355522000@chello.nl>
User-Agent: quilt/0.45-1
Date: Tue, 17 Jul 2007 19:34:34 +0200
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, Zach Brown <zach.brown@oracle.com>,
       Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [RFC/T PATCH 06/12] lockdep: lock_page: handle IO-completions
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
 include/linux/pagemap.h |   13 ++++++++++++-
 mm/filemap.c            |    5 ++---
 4 files changed, 32 insertions(+), 9 deletions(-)

Index: linux-2.6/include/linux/pagemap.h
===================================================================
--- linux-2.6.orig/include/linux/pagemap.h
+++ linux-2.6/include/linux/pagemap.h
@@ -353,7 +353,7 @@ static inline pgoff_t linear_page_index(
 
 extern void FASTCALL(__lock_page(struct page *page));
 extern void FASTCALL(__lock_page_nosync(struct page *page));
-extern void FASTCALL(unlock_page(struct page *page));
+extern void FASTCALL(unlock_page_nocheck(struct page *page));
 
 extern struct lockdep_map page_lockdep_map;
 
@@ -376,6 +376,17 @@ static inline int trylock_page(struct pa
 	return ret;
 }
 
+static inline void __unlock_page_check(struct page *page)
+{
+	spin_release(&page_lockdep_map, 1, _RET_IP_);
+}
+
+static inline void unlock_page(struct page *page)
+{
+	__unlock_page_check(page);
+	unlock_page_nocheck(page);
+}
+
 /*
  * lock_page_nosync should only be used if we can't pin the page's inode.
  * Doesn't play quite so well with block device plugging.
Index: linux-2.6/mm/filemap.c
===================================================================
--- linux-2.6.orig/mm/filemap.c
+++ linux-2.6/mm/filemap.c
@@ -530,16 +530,15 @@ struct lockdep_map page_lockdep_map =
 
 EXPORT_SYMBOL(page_lockdep_map);
 
-void fastcall unlock_page(struct page *page)
+void fastcall unlock_page_nocheck(struct page *page)
 {
-	spin_release(&page_lockdep_map, 1, _RET_IP_);
 	smp_mb__before_clear_bit();
 	if (!TestClearPageLocked(page))
 		BUG();
 	smp_mb__after_clear_bit(); 
 	wake_up_page(page, PG_locked);
 }
-EXPORT_SYMBOL(unlock_page);
+EXPORT_SYMBOL(unlock_page_nocheck);
 
 /**
  * end_page_writeback - end writeback against a page
Index: linux-2.6/fs/buffer.c
===================================================================
--- linux-2.6.orig/fs/buffer.c
+++ linux-2.6/fs/buffer.c
@@ -410,7 +410,7 @@ static void end_buffer_async_read(struct
 	 */
 	if (page_uptodate && !PageError(page))
 		SetPageUptodate(page);
-	unlock_page(page);
+	unlock_page_nocheck(page);
 	return;
 
 still_busy:
@@ -1970,6 +1970,8 @@ int block_read_full_page(struct page *pa
 		mark_buffer_async_read(bh);
 	}
 
+	__unlock_page_check(page);
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
+				__unlock_page_check(page);
+		}
+	}
 	submit_bio(rw, bio);
 	return NULL;
 }

--

