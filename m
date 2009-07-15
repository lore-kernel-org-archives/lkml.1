Return-Path: <linux-kernel-owner+w=401wt.eu-S1754614AbZGOWFu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754614AbZGOWFu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jul 2009 18:05:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754163AbZGOWFu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Jul 2009 18:05:50 -0400
Received: from cmpxchg.org ([85.214.51.133]:60352 "EHLO cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752952AbZGOWFt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jul 2009 18:05:49 -0400
Date: Thu, 16 Jul 2009 00:04:45 +0200
From: Johannes Weiner <hannes@cmpxchg.org>
To: Christoph Lameter <cl@linux-foundation.org>
Cc: Mel Gorman <mel@csn.ul.ie>, Andrew Morton <akpm@linux-foundation.org>,
       kosaki.motohiro@jp.fujitsu.com,
       Maxim Levitsky <maximlevitsky@gmail.com>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>, Jiri Slaby <jirislaby@gmail.com>
Subject: Re: [PATCH] mm: Warn once when a page is freed with PG_mlocked set V2
Message-ID: <20090715220445.GA1823@cmpxchg.org>
References: <20090715125822.GB29749@csn.ul.ie> <alpine.DEB.1.10.0907151027410.23643@gentwo.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.10.0907151027410.23643@gentwo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Christoph,

On Wed, Jul 15, 2009 at 10:31:54AM -0400, Christoph Lameter wrote:
> On Wed, 15 Jul 2009, Mel Gorman wrote:
> 
> > -static inline int free_pages_check(struct page *page)
> > +static inline int free_pages_check(struct page *page, int wasMlocked)
> >  {
> > +	WARN_ONCE(wasMlocked, KERN_WARNING
> > +		"Page flag mlocked set for process %s at pfn:%05lx\n"
> > +		"page:%p flags:0x%lX\n",
> > +		current->comm, page_to_pfn(page),
> > +		page, page->flags|__PG_MLOCKED);
> > +
> >  	if (unlikely(page_mapcount(page) |
> 
> There is already a free_page_mlocked() that is only called if the mlock
> bit is set. Move it into there to avoid having to run two checks in the
> hot codee path?
> 
> Also __free_pages_ok() now has a TestClearMlocked in the hot code path.
> Would it be possible to get rid of the unconditional use of an atomic
> operation? Just check the bit and clear it later in free_page_mlocked()?

That was initially done, but free_pages_check() checks for that flag
and did bad_page() on those mlocked ones.  Now, one idea was to not
check the mlocked flag at all in free_pages_check() as we handle it
differently anyway.  But I think we might still want to check for it
in tail-pages of higher order blocks.

And if you move that warning after free_pages_check(), the interesting
bits for the warning have been wiped already.

But we can get rid of the locked test-and-clear despite all the other
issues, patch below.

	Hannes

>From eee677ddea61b1331a3bd8e402a0d02437fe872a Mon Sep 17 00:00:00 2001
From: Johannes Weiner <hannes@cmpxchg.org>
Date: Wed, 15 Jul 2009 23:40:28 +0200
Subject: [patch] mm: non-atomic test-clear of PG_mlocked on free

By the time PG_mlocked is cleared in the page freeing path, nobody
else is looking at our page->flags anymore.

It is thus safe to make the test-and-clear non-atomic and thereby
removing an unnecessary and expensive operation from a hotpath.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
---
 include/linux/page-flags.h |   12 +++++++++---
 mm/page_alloc.c            |    4 ++--
 2 files changed, 11 insertions(+), 5 deletions(-)

diff --git a/include/linux/page-flags.h b/include/linux/page-flags.h
index e2e5ce5..10e6011 100644
--- a/include/linux/page-flags.h
+++ b/include/linux/page-flags.h
@@ -158,6 +158,9 @@ static inline int TestSetPage##uname(struct page *page)			\
 static inline int TestClearPage##uname(struct page *page)		\
 		{ return test_and_clear_bit(PG_##lname, &page->flags); }
 
+#define __TESTCLEARFLAG(uname, lname)					\
+static inline int __TestClearPage##uname(struct page *page)		\
+		{ return __test_and_clear_bit(PG_##lname, &page->flags); }
 
 #define PAGEFLAG(uname, lname) TESTPAGEFLAG(uname, lname)		\
 	SETPAGEFLAG(uname, lname) CLEARPAGEFLAG(uname, lname)
@@ -184,6 +187,9 @@ static inline void __ClearPage##uname(struct page *page) {  }
 #define TESTCLEARFLAG_FALSE(uname)					\
 static inline int TestClearPage##uname(struct page *page) { return 0; }
 
+#define __TESTCLEARFLAG_FALSE(uname)					\
+static inline int __TestClearPage##uname(struct page *page) { return 0; }
+
 struct page;	/* forward declaration */
 
 TESTPAGEFLAG(Locked, locked) TESTSETFLAG(Locked, locked)
@@ -250,11 +256,11 @@ PAGEFLAG(Unevictable, unevictable) __CLEARPAGEFLAG(Unevictable, unevictable)
 #ifdef CONFIG_HAVE_MLOCKED_PAGE_BIT
 #define MLOCK_PAGES 1
 PAGEFLAG(Mlocked, mlocked) __CLEARPAGEFLAG(Mlocked, mlocked)
-	TESTSCFLAG(Mlocked, mlocked)
+	TESTSCFLAG(Mlocked, mlocked) __TESTCLEARFLAG(Mlocked, mlocked)
 #else
 #define MLOCK_PAGES 0
-PAGEFLAG_FALSE(Mlocked)
-	SETPAGEFLAG_NOOP(Mlocked) TESTCLEARFLAG_FALSE(Mlocked)
+PAGEFLAG_FALSE(Mlocked) SETPAGEFLAG_NOOP(Mlocked)
+	TESTCLEARFLAG_FALSE(Mlocked) __TESTCLEARFLAG_FALSE(Mlocked)
 #endif
 
 #ifdef CONFIG_IA64_UNCACHED_ALLOCATOR
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index caa9268..b0c8758 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -557,7 +557,7 @@ static void __free_pages_ok(struct page *page, unsigned int order)
 	unsigned long flags;
 	int i;
 	int bad = 0;
-	int wasMlocked = TestClearPageMlocked(page);
+	int wasMlocked = __TestClearPageMlocked(page);
 
 	kmemcheck_free_shadow(page, order);
 
@@ -1021,7 +1021,7 @@ static void free_hot_cold_page(struct page *page, int cold)
 	struct zone *zone = page_zone(page);
 	struct per_cpu_pages *pcp;
 	unsigned long flags;
-	int wasMlocked = TestClearPageMlocked(page);
+	int wasMlocked = __TestClearPageMlocked(page);
 
 	kmemcheck_free_shadow(page, 0);
 
-- 
1.6.3

