Return-Path: <linux-kernel-owner+w=401wt.eu-S1765488AbXLMTrl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765488AbXLMTrl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2007 14:47:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761342AbXLMTrd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Dec 2007 14:47:33 -0500
Received: from relay1.sgi.com ([192.48.171.29]:34097 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1761307AbXLMTrc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2007 14:47:32 -0500
Date: Thu, 13 Dec 2007 11:47:29 -0800 (PST)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Jeremy Fitzhardinge <jeremy@goop.org>
cc: Suresh Siddha <suresh.b.siddha@intel.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Andi Kleen <ak@suse.de>,
       Tony Luck <tony.luck@intel.com>,
       Asit Mallick <asit.k.mallick@intel.com>,
       Andrew Morton <akpm@linux-foundation.org>, benh@kernel.crashing.org
Subject: Re: What was the problem with quicklists and x86-64?
In-Reply-To: <47603321.4030700@goop.org>
Message-ID: <Pine.LNX.4.64.0712131131540.13396@schroedinger.engr.sgi.com>
References: <47603321.4030700@goop.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 12 Dec 2007, Jeremy Fitzhardinge wrote:

> I'm looking at unifying the various pgalloc+pgd_lists mechanisms between
> 32-bit (PAE and non-PAE) and 64-bit, so I'm trying to understand why
> these differences exist in the first place.
> 
> Change da8f153e51290e7438ba7da66234a864e5d3e1c1 reverted the use of
> quicklists for allocating pagetables, because of concerns about ordering
> with respect to tlb flushes.

These issues only exist with NUMA because of the freeing of off node pages 
before the TLB flush was done. There was a discussion about this issue and 
my fix of simply not freeing the offnode pages early was ignored. Instead 
the x86_64 implementation (which has no problems that I know of) was 
pulled leaving the issue open in the core. Benjamin Herrrenschmidt 
wanted to take a look at these issues (CCing him).

Here is the fix again. Could we please reapply the x86_64 quicklist 
patch after applying this one? (I have another patch in testing that 
maintains separate lists for off and on node pages and frees all off node 
pages on flush but that one adds new capabilities).

http://marc.info/?t=119039827700001&r=1&w=2



[NUMA] quicklists: Do not release off node pages early

quicklists must keep even off node pages on the quicklists until the TLB flush
has been completed.

Signed-off-by: Christoph Lameter <clameter@sgi.com>

Index: linux-2.6/include/linux/quicklist.h
===================================================================
--- linux-2.6.orig/include/linux/quicklist.h	2007-12-13 11:42:21.000000000 -0800
+++ linux-2.6/include/linux/quicklist.h	2007-12-13 11:42:37.000000000 -0800
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
