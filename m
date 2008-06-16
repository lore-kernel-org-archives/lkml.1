Return-Path: <linux-kernel-owner+w=401wt.eu-S1756221AbYFPOsq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756221AbYFPOsq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2008 10:48:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754001AbYFPOsg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jun 2008 10:48:36 -0400
Received: from g4t0017.houston.hp.com ([15.201.24.20]:11974 "EHLO
	g4t0017.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753658AbYFPOsf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2008 10:48:35 -0400
Subject: Re: [PATCH] fix double unlock_page() in 2.6.26-rc5-mm3 kernel BUG
	at mm/filemap.c:575!
From: Lee Schermerhorn <Lee.Schermerhorn@hp.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
       linux-kernel@vger.kernel.org, kernel-testers@vger.kernel.org,
       linux-mm@kvack.org, Nick Piggin <npiggin@suse.de>,
       Andy Whitcroft <apw@shadowen.org>, "riel@redhat.com" <riel@redhat.com>
In-Reply-To: <1213371046.9670.12.camel@lts-notebook>
References: <20080611225945.4da7bb7f.akpm@linux-foundation.org>
	 <4850E1E5.90806@linux.vnet.ibm.com>
	 <20080612015746.172c4b56.akpm@linux-foundation.org>
	 <20080612202003.db871cac.kamezawa.hiroyu@jp.fujitsu.com>
	 <20080613104444.63bd242f.kamezawa.hiroyu@jp.fujitsu.com>
	 <20080612191311.1331f337.akpm@linux-foundation.org>
	 <1213371046.9670.12.camel@lts-notebook>
Content-Type: text/plain
Organization: HP/OSLO
Date: Mon, 16 Jun 2008 10:49:02 -0400
Message-Id: <1213627742.6538.7.camel@lts-notebook>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-06-13 at 11:30 -0400, Lee Schermerhorn wrote:
> On Thu, 2008-06-12 at 19:13 -0700, Andrew Morton wrote:
> > On Fri, 13 Jun 2008 10:44:44 +0900 KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:
> > 
> > > This is reproducer of panic. "quick fix" is attached.
> > 
> > Thanks - I put that in
> > ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.26-rc5/2.6.26-rc5-mm3/hot-fixes/
> > 
> > > But I think putback_lru_page() should be re-designed.
> > 
> > Yes, it sounds that way.
> 
> Here's a proposed replacement patch that reworks putback_lru_page()
> slightly and cleans up the call sites.  I still want to balance the
> get_page() in isolate_lru_page() with a put_page() in putback_lru_page()
> for the primary users--vmscan and page migration.  So, I need to drop
> the lock before the put_page() when handed a page with null mapping and
> a single reference count as the page will be freed on put_page() and a
> locked page would bug out in free_pages_check()/bad_page().  
> 

Below is a fix to the "proposed replacement patch" posted on Friday.
Incorrect test for page->mapping().

Lee

Against:  2.6.26-rc5-mm3 

Incremental fix to my proposed patch to "fix double unlock_page() in
2.6.26-rc5-mm3 kernel BUG at mm/filemap.c:575".

"page_mapping(page)" should be "page->mapping" in VM_BUG_ON()s
introduced to m[un]lock_vma_page().

Signed-off-by: Lee Schermerhorn <lee.schermerhorn@hp.com>

 mm/mlock.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

Index: linux-2.6.26-rc5-mm3/mm/mlock.c
===================================================================
--- linux-2.6.26-rc5-mm3.orig/mm/mlock.c	2008-06-16 09:47:28.000000000 -0400
+++ linux-2.6.26-rc5-mm3/mm/mlock.c	2008-06-16 09:48:27.000000000 -0400
@@ -80,12 +80,12 @@ void __clear_page_mlock(struct page *pag
  * Mark page as mlocked if not already.
  * If page on LRU, isolate and putback to move to unevictable list.
  *
- * Called with page locked and page_mapping() != NULL.
+ * Called with page locked and page->mapping != NULL.
  */
 void mlock_vma_page(struct page *page)
 {
 	BUG_ON(!PageLocked(page));
-	VM_BUG_ON(!page_mapping(page));
+	VM_BUG_ON(!page->mapping);
 
 	if (!TestSetPageMlocked(page)) {
 		inc_zone_page_state(page, NR_MLOCK);
@@ -98,7 +98,7 @@ void mlock_vma_page(struct page *page)
 /*
  * called from munlock()/munmap() path with page supposedly on the LRU.
  *
- * Called with page locked and page_mapping() != NULL.
+ * Called with page locked and page->mapping != NULL.
  *
  * Note:  unlike mlock_vma_page(), we can't just clear the PageMlocked
  * [in try_to_munlock()] and then attempt to isolate the page.  We must
@@ -118,7 +118,7 @@ void mlock_vma_page(struct page *page)
 static void munlock_vma_page(struct page *page)
 {
 	BUG_ON(!PageLocked(page));
-	VM_BUG_ON(!page_mapping(page));
+	VM_BUG_ON(!page->mapping);
 
 	if (TestClearPageMlocked(page)) {
 		dec_zone_page_state(page, NR_MLOCK);


