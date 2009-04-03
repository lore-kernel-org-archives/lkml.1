Return-Path: <linux-kernel-owner+w=401wt.eu-S1762726AbZDCJnV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762726AbZDCJnV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Apr 2009 05:43:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761788AbZDCJmK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Apr 2009 05:42:10 -0400
Received: from mx2.redhat.com ([66.187.237.31]:43357 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761683AbZDCJmF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Apr 2009 05:42:05 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 4/4] FS-Cache: Revert the addition of
	PG_owner_priv2/PG_fscache_write
To: nickpiggin@yahoo.com.au, hch@infradead.org
Cc: dhowells@redhat.com, nfsv4@linux-nfs.org, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Date: Fri, 03 Apr 2009 10:41:53 +0100
Message-ID: <20090403094153.9510.78074.stgit@warthog.procyon.org.uk>
In-Reply-To: <20090403094138.9510.80681.stgit@warthog.procyon.org.uk>
References: <20090403094138.9510.80681.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Revert the addition of PG_owner_priv2/PG_fscache_write as it's no longer used
by FS-Cache.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 include/linux/page-flags.h |    3 ---
 include/linux/pagemap.h    |   16 ----------------
 mm/filemap.c               |   17 -----------------
 3 files changed, 0 insertions(+), 36 deletions(-)


diff --git a/include/linux/page-flags.h b/include/linux/page-flags.h
index 0633e06..62214c7 100644
--- a/include/linux/page-flags.h
+++ b/include/linux/page-flags.h
@@ -79,7 +79,6 @@ enum pageflags {
 	PG_active,
 	PG_slab,
 	PG_owner_priv_1,	/* Owner use. If pagecache, fs may use*/
-	PG_owner_priv_2,	/* Owner use. fs may use in pagecache */
 	PG_arch_1,
 	PG_reserved,
 	PG_private,		/* If pagecache, has fs-private data */
@@ -115,7 +114,6 @@ enum pageflags {
 	 * when those inodes are being locally cached.
 	 */
 	PG_fscache = PG_private_2,	/* page backed by cache */
-	PG_fscache_write = PG_owner_priv_2, /* page being written to cache */
 
 	/* XEN */
 	PG_pinned = PG_owner_priv_1,
@@ -220,7 +218,6 @@ PAGEFLAG(Private, private) __SETPAGEFLAG(Private, private)
 	__CLEARPAGEFLAG(Private, private)
 PAGEFLAG(Private2, private_2) TESTSCFLAG(Private2, private_2)
 PAGEFLAG(OwnerPriv1, owner_priv_1) TESTCLEARFLAG(OwnerPriv1, owner_priv_1)
-PAGEFLAG(OwnerPriv2, owner_priv_2) TESTSCFLAG(OwnerPriv2, owner_priv_2)
 
 /*
  * Only test-and-set exist for PG_writeback.  The unconditional operators are
diff --git a/include/linux/pagemap.h b/include/linux/pagemap.h
index 7140f74..34da523 100644
--- a/include/linux/pagemap.h
+++ b/include/linux/pagemap.h
@@ -383,22 +383,6 @@ static inline void wait_on_page_writeback(struct page *page)
 
 extern void end_page_writeback(struct page *page);
 
-/**
- * wait_on_page_owner_priv_2 - Wait for PG_owner_priv_2 to become clear
- * @page: The page to monitor
- *
- * Wait for a PG_owner_priv_2 to become clear on the specified page.  This is
- * also used to monitor PG_fscache_write (which is an alternate name for the
- * same bit).
- */
-static inline void wait_on_page_owner_priv_2(struct page *page)
-{
-	if (PageOwnerPriv2(page))
-		wait_on_page_bit(page, PG_owner_priv_2);
-}
-
-extern void end_page_owner_priv_2(struct page *page);
-
 /*
  * Add an arbitrary waiter to a page's wait queue
  */
diff --git a/mm/filemap.c b/mm/filemap.c
index a07d714..fc11974 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -621,23 +621,6 @@ void end_page_writeback(struct page *page)
 EXPORT_SYMBOL(end_page_writeback);
 
 /**
- * end_page_owner_priv_2 - Clear PG_owner_priv_2 and wake up any waiters
- * @page: the page
- *
- * Clear PG_owner_priv_2 and wake up any processes waiting for that event.
- * This is used to indicate - using PG_fscache_write (an alternate name for the
- * same bit) - that a page has finished being written to the local disk cache.
- */
-void end_page_owner_priv_2(struct page *page)
-{
-	if (!TestClearPageOwnerPriv2(page))
-		BUG();
-	smp_mb__after_clear_bit();
-	wake_up_page(page, PG_owner_priv_2);
-}
-EXPORT_SYMBOL(end_page_owner_priv_2);
-
-/**
  * __lock_page - get a lock on the page, assuming we need to sleep to get it
  * @page: the page to lock
  *

