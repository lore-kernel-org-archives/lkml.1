Return-Path: <linux-kernel-owner+w=401wt.eu-S1752544AbZAEGsw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752544AbZAEGsw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2009 01:48:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751297AbZAEGsn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Jan 2009 01:48:43 -0500
Received: from ns1.suse.de ([195.135.220.2]:56803 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751269AbZAEGsm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2009 01:48:42 -0500
Date: Mon, 5 Jan 2009 07:48:38 +0100
From: Nick Piggin <npiggin@suse.de>
To: Christoph Hellwig <hch@infradead.org>
Cc: Peter Klotz <peter.klotz@aon.at>, Roman Kononov <kernel@kononov.ftml.net>,
       linux-kernel@vger.kernel.org, xfs@oss.sgi.com
Subject: Re: BUG: soft lockup - is this XFS problem?
Message-ID: <20090105064838.GA5209@wotan.suse.de>
References: <gifgp1$8ic$1@ger.gmane.org> <20081223171259.GA11945@infradead.org> <20081230042333.GC27679@wotan.suse.de> <20090103214443.GA6612@infradead.org> <20090105014821.GA367@wotan.suse.de> <20090105041959.GC367@wotan.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090105041959.GC367@wotan.suse.de>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 05, 2009 at 05:19:59AM +0100, Nick Piggin wrote:
> On Mon, Jan 05, 2009 at 02:48:21AM +0100, Nick Piggin wrote:
> > 
> > OK.. Hmm, well here is a modification to your patch which might help further.
> > I'll see if I can reproduce it here meanwhile.
> 
> I have reproduced it. It seems like it might be a livelock condition
> because the system ended up recovering after I terminated the dd (and
> did so before I collected any real info, oops, hopefully I can
> reproduce it again).
> 
> This would fit with the problem going away when the debugging patch
> was applied. Timing changes...

No, I was wrong. The problem goes away with the patch applied because
a function call == a compiler barrier. The problem randomly recovered
for me because of something more subtle.

I believe this patch should solve it. Please test and confirm before
I send it upstream.

---

An XFS workload showed up a bug in the lockless pagecache patch. Basically it
would go into an "infinite" loop, although it would sometimes be able to break
out of the loop! The reason is a missing compiler barrier in the "increment
reference count unless it was zero" case of the lockless pagecache protocol in
the gang lookup functions.

This would cause the compiler to use a cached value of struct page pointer to
retry the operation with, rather than reload it. So the page might have been
removed from pagecache and freed (refcount==0) but the lookup would not correctly
notice the page is no longer in pagecache, and keep attempting to increment the
refcount and failing, until the page gets reallocated for something else. This
isn't a data corruption because the condition will be detected if the page has
been reallocated. However it can result in a lockup. 

Add a the required compiler barrier and comment to fix this.

Assembly snippet from find_get_pages, before:
.L220:
        movq    (%rbx), %rax    #* ivtmp.1162, tmp82
        movq    (%rax), %rdi    #, prephitmp.1149
.L218:
        testb   $1, %dil        #, prephitmp.1149
        jne     .L217   #,
        testq   %rdi, %rdi      # prephitmp.1149
        je      .L203   #,
        cmpq    $-1, %rdi       #, prephitmp.1149
        je      .L217   #,
        movl    8(%rdi), %esi   # <variable>._count.counter, c
        testl   %esi, %esi      # c
        je      .L218   #,

after:
.L212:
        movq    (%rbx), %rax    #* ivtmp.1109, tmp81
        movq    (%rax), %rdi    #, ret
        testb   $1, %dil        #, ret
        jne     .L211   #,
        testq   %rdi, %rdi      # ret
        je      .L197   #,
        cmpq    $-1, %rdi       #, ret
        je      .L211   #,
        movl    8(%rdi), %esi   # <variable>._count.counter, c
        testl   %esi, %esi      # c
        je      .L212   #,

(notice the obvious infinite loop in the first example, if page->count remains 0)


---
Index: linux-2.6/mm/filemap.c
===================================================================
--- linux-2.6.orig/mm/filemap.c	2009-01-05 17:22:57.000000000 +1100
+++ linux-2.6/mm/filemap.c	2009-01-05 17:28:40.000000000 +1100
@@ -794,8 +794,19 @@ repeat:
 		if (unlikely(page == RADIX_TREE_RETRY))
 			goto restart;
 
-		if (!page_cache_get_speculative(page))
+		if (!page_cache_get_speculative(page)) {
+			/*
+			 * A failed page_cache_get_speculative operation does
+			 * not imply any barriers (Documentation/atomic_ops.txt),
+			 * and as such, we must force the compiler to deref the
+			 * radix-tree slot again rather than using the cached
+			 * value (because we need to give up if the page has been
+			 * removed from the radix-tree, rather than looping until
+			 * it gets reused for something else).
+			 */
+			barrier();
 			goto repeat;
+		}
 
 		/* Has the page moved? */
 		if (unlikely(page != *((void **)pages[i]))) {
@@ -850,8 +861,11 @@ repeat:
 		if (page->mapping == NULL || page->index != index)
 			break;
 
-		if (!page_cache_get_speculative(page))
+		if (!page_cache_get_speculative(page)) {
+			/* barrier: see find_get_pages() */
+			barrier();
 			goto repeat;
+		}
 
 		/* Has the page moved? */
 		if (unlikely(page != *((void **)pages[i]))) {
@@ -904,8 +918,11 @@ repeat:
 		if (unlikely(page == RADIX_TREE_RETRY))
 			goto restart;
 
-		if (!page_cache_get_speculative(page))
+		if (!page_cache_get_speculative(page)) {
+			/* barrier: see find_get_pages() */
+			barrier();
 			goto repeat;
+		}
 
 		/* Has the page moved? */
 		if (unlikely(page != *((void **)pages[i]))) {
