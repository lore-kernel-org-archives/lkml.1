Return-Path: <linux-kernel-owner+w=401wt.eu-S1762515AbXIUTH4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762515AbXIUTH4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2007 15:07:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762164AbXIUTHZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Sep 2007 15:07:25 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:38122 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1762115AbXIUTHW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2007 15:07:22 -0400
Date: Fri, 21 Sep 2007 12:07:22 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: "Siddha, Suresh B" <suresh.b.siddha@intel.com>, akpm@linux-foundation.org,
       ak@suse.de, linux-kernel@vger.kernel.org, tony.luck@intel.com,
       asit.k.mallick@intel.com
Subject: Re: x86_64: potential critical issue with quicklists and page table
 pages
In-Reply-To: <alpine.LFD.0.999.0709211204050.16478@woody.linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0709211205570.17160@schroedinger.engr.sgi.com>
References: <20070921180742.GH20863@linux-os.sc.intel.com>
 <alpine.LFD.0.999.0709211139550.16478@woody.linux-foundation.org>
 <Pine.LNX.4.64.0709211149040.17160@schroedinger.engr.sgi.com>
 <alpine.LFD.0.999.0709211153060.16478@woody.linux-foundation.org>
 <alpine.LFD.0.999.0709211204050.16478@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 21 Sep 2007, Linus Torvalds wrote:

> On Fri, 21 Sep 2007, Linus Torvalds wrote:
> > 
> > On Fri, 21 Sep 2007, Christoph Lameter wrote:
> > > 
> > > The quicklists collect pages while we gather pages for TLB flushing. 
> > > These pages must be kept until the actual TLB flush has occurred. The 
> > > optimization of releasing off node pages early is therefore not valid.
> > 
> > That should be the "mmu_gather" structure, not the quicklists.
> 
> Oh, and I see what's wrong: you not only switched "free_page()" to 
> "quicklist_free()", you *also* switched "tlb_remove_page()" to 
> "quicklist_free()".
> 
> Ok, that commit is totally and utterly broken. Will revert.

On x86_64 the quicklists partially replace the role of the mmu_gather
list because we would otherwise create more overhead by having to move
pages between the mmu gather and the quicklists lists.
lists.

The final flush does only check if there are too many pages on the
quicklists. Otherwise the quicklist is not dumped/freed (unlike the
mmu_gather list) but kept for the following page table page allocations
since we have cache hot cpu objects there.

The only problem is that we cannot release any pages before the TLB flush 
has happened. The optimization of releasing off node pages in order to 
keep only node local pages is therefore not valid.



---
 include/linux/quicklist.h |    8 --------
 1 file changed, 8 deletions(-)

Index: linux-2.6/include/linux/quicklist.h
===================================================================
--- linux-2.6.orig/include/linux/quicklist.h	2007-09-21 11:46:44.000000000 -0700
+++ linux-2.6/include/linux/quicklist.h	2007-09-21 11:55:01.000000000 -0700
@@ -56,14 +56,6 @@ static inline void __quicklist_free(int 
 	struct page *page)
 {
 	struct quicklist *q;
-	int nid = page_to_nid(page);
-
-	if (unlikely(nid != numa_node_id())) {
-		if (dtor)
-			dtor(p);
-		__free_page(page);
-		return;
-	}
 
 	q = &get_cpu_var(quicklist)[nr];
 	*(void **)p = q->page;
