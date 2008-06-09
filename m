Return-Path: <linux-kernel-owner+w=401wt.eu-S1757102AbYFIVD4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757102AbYFIVD4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2008 17:03:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752945AbYFIVDr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jun 2008 17:03:47 -0400
Received: from relay1.sgi.com ([192.48.171.29]:40155 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752324AbYFIVDq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2008 17:03:46 -0400
Date: Mon, 9 Jun 2008 16:03:44 -0500
From: Russ Anderson <rja@sgi.com>
To: Christoph Lameter <clameter@sgi.com>
Cc: linux-kernel@vger.kernel.org, linux-ia64@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Tony Luck <tony.luck@intel.com>
Subject: Re: [PATCH 2/3] mm: Avoid putting a bad page back on the LRU v6
Message-ID: <20080609210344.GA9039@sgi.com>
Reply-To: Russ Anderson <rja@sgi.com>
References: <20080609161933.GC14939@sgi.com> <Pine.LNX.4.64.0806091123400.30605@schroedinger.engr.sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0806091123400.30605@schroedinger.engr.sgi.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 09, 2008 at 11:28:00AM -0700, Christoph Lameter wrote:
> On Mon, 9 Jun 2008, Russ Anderson wrote:
> 
> > -#define PAGE_FLAGS	(1 << PG_lru   | 1 << PG_private   | 1 << PG_locked | \
> > +#define PAGE_FLAGS_BASE	(1 << PG_lru   | 1 << PG_private   | 1 << PG_locked | \
> >  			 1 << PG_buddy | 1 << PG_writeback | \
> >  			 1 << PG_slab  | 1 << PG_swapcache | 1 << PG_active)
> > +
> > +#ifdef CONFIG_PAGEFLAGS_EXTENDED
> > +PAGEFLAG(MemError, memerror)
> > +#define	PAGE_FLAGS	(PAGE_FLAGS_BASE | 1UL << PG_memerror)
> > +#else
> > +PAGEFLAG_FALSE(MemError)
> > +#define	PAGE_FLAGS	(PAGE_FLAGS_BASE)
> > +#endif
> 
> Hmmmm... That doesnt look nice. It would be good if we had some definition 
> that  allows the simple oring with a flag mask. That mask should be 
> zero if the flag is always false.
> 
> #ifdef CONFIG_PAGEFLAGS_EXTENDED
> PAGEFLAG(MemError, memerror)
> #define MemError_mask (1 << PG_memerror)
> #else
> PAGEFLAG_FALSE(MemError)
> #define MemError_mask 0
> #endif
> 
> #define	PAGE_FLAGS	(PAGE_FLAGS_BASE | MemError_mask)
> 
> Maybe we could have the PAGEFLAG and the PAGEFLAG_FALSE macros generate 
> these definitions?

Does this look better?


Index: linus/include/linux/page-flags.h
===================================================================
--- linus.orig/include/linux/page-flags.h	2008-06-09 13:48:10.072171477 -0500
+++ linus/include/linux/page-flags.h	2008-06-09 15:58:27.957729371 -0500
@@ -84,6 +84,7 @@ enum pageflags {
 	PG_private,		/* If pagecache, has fs-private data */
 	PG_writeback,		/* Page is under writeback */
 #ifdef CONFIG_PAGEFLAGS_EXTENDED
+	PG_memerror,		/* Page has a physical memory error */
 	PG_head,		/* A head page */
 	PG_tail,		/* A tail page */
 #else
@@ -132,15 +133,21 @@ static inline int TestSetPage##uname(str
 static inline int TestClearPage##uname(struct page *page)		\
 		{ return test_and_clear_bit(PG_##lname, &page->flags); }
 
+#define PAGEFLAGMASK(uname, lname)					\
+static inline int PAGEMASK_##uname(void)				\
+		{ return (1 << PG_##lname); }
 
 #define PAGEFLAG(uname, lname) TESTPAGEFLAG(uname, lname)		\
-	SETPAGEFLAG(uname, lname) CLEARPAGEFLAG(uname, lname)
+	SETPAGEFLAG(uname, lname) CLEARPAGEFLAG(uname, lname)		\
+	PAGEFLAGMASK(uname, lname)
 
 #define __PAGEFLAG(uname, lname) TESTPAGEFLAG(uname, lname)		\
 	__SETPAGEFLAG(uname, lname)  __CLEARPAGEFLAG(uname, lname)
 
 #define PAGEFLAG_FALSE(uname) 						\
 static inline int Page##uname(struct page *page) 			\
+			{ return 0; }					\
+static inline int PAGEMASK_##uname(void)				\
 			{ return 0; }
 
 #define TESTSCFLAG(uname, lname)					\
@@ -307,9 +314,16 @@ static inline void __ClearPageTail(struc
 
 #endif /* !PAGEFLAGS_EXTENDED */
 
+#ifdef CONFIG_PAGEFLAGS_EXTENDED
+PAGEFLAG(MemError, memerror)
+#else
+PAGEFLAG_FALSE(MemError)
+#endif
+
 #define PAGE_FLAGS	(1 << PG_lru   | 1 << PG_private   | 1 << PG_locked | \
 			 1 << PG_buddy | 1 << PG_writeback | \
-			 1 << PG_slab  | 1 << PG_swapcache | 1 << PG_active)
+			 1 << PG_slab  | 1 << PG_swapcache | 1 << PG_active) |\
+			 PAGEMASK_MemError()
 
 /*
  * Flags checked in bad_page().  Pages on the free list should not have

-- 
Russ Anderson, OS RAS/Partitioning Project Lead  
SGI - Silicon Graphics Inc          rja@sgi.com
