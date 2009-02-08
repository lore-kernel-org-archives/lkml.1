Return-Path: <linux-kernel-owner+w=401wt.eu-S1753847AbZBHUsD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753847AbZBHUsD (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Feb 2009 15:48:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753190AbZBHUrx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Feb 2009 15:47:53 -0500
Received: from cmpxchg.org ([85.214.51.133]:60448 "EHLO cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752038AbZBHUrw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Feb 2009 15:47:52 -0500
Date: Sun, 8 Feb 2009 21:47:25 +0100
From: Johannes Weiner <hannes@cmpxchg.org>
To: linux-kernel@vger.kernel.org
Cc: mm-commits@vger.kernel.org, chandru@in.ibm.com, benh@kernel.crashing.org,
       chandru@linux.vnet.ibm.com, paulus@samba.org, akpm@linux-foundation.org
Subject: Re: + powerpc-fix-code-for-reserved-memory-spanning-across-nodes.patch added to -mm tree
Message-ID: <20090208204725.GA5514@cmpxchg.org>
References: <200812250806.mBP86LPQ018399@imap1.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200812250806.mBP86LPQ018399@imap1.linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 25, 2008 at 12:06:21AM -0800, akpm@linux-foundation.org wrote:
> 
> The patch titled
>      powerpc: fix code for reserved memory spanning across nodes
> has been added to the -mm tree.  Its filename is
>      powerpc-fix-code-for-reserved-memory-spanning-across-nodes.patch
> 
> Before you just go and hit "reply", please:
>    a) Consider who else should be cc'ed
>    b) Prefer to cc a suitable mailing list as well
>    c) Ideally: find the original patch on the mailing list and do a
>       reply-to-all to that, adding suitable additional cc's
> 
> *** Remember to use Documentation/SubmitChecklist when testing your code ***
> 
> See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
> out what to do about this
> 
> The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/
> 
> ------------------------------------------------------
> Subject: powerpc: fix code for reserved memory spanning across nodes
> From: Chandru <chandru@in.ibm.com>
> 
> When booted with crashkernel=224M@32M or any memory size less than this,
> the system boots properly.  The following was the observation..  The
> system comes up with two nodes (0-256M and 256M-4GB).  The crashkernel
> memory reservation spans across these two nodes.  The
> mark_reserved_regions_for_nid() in arch/powerpc/mm/numa.c resizes the
> reserved part of the memory within it as:
> 
> 	if (end_pfn > node_ar.end_pfn)
> 		reserve_size = (node_ar.end_pfn << PAGE_SHIFT)
> 				- (start_pfn << PAGE_SHIFT);
> 
> 
> but the reserve_bootmem_node() in mm/bootmem.c raises the pfn value of end 
> 
> 	end = PFN_UP(physaddr + size);
>
> This causes end to get a value past the last page in the 0-256M node. 
> Again when reserve_bootmem_node() returns, mark_reserved_regions_for_nid()
> loops around to set the rest of the crashkernel memory in the next node as
> reserved.  It references NODE_DATA(node_ar.nid) and this causes another
> 'Oops: kernel access of bad area' problem.  The following changes made the
> system to boot with any amount of crashkernel memory size.
> 
> Signed-off-by: Chandru S <chandru@linux.vnet.ibm.com>
> Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
> Cc: Paul Mackerras <paulus@samba.org>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
> 
>  arch/powerpc/mm/numa.c |    7 ++++---
>  mm/bootmem.c           |    4 ++++
>  2 files changed, 8 insertions(+), 3 deletions(-)
> 
> diff -puN arch/powerpc/mm/numa.c~powerpc-fix-code-for-reserved-memory-spanning-across-nodes arch/powerpc/mm/numa.c
> --- a/arch/powerpc/mm/numa.c~powerpc-fix-code-for-reserved-memory-spanning-across-nodes
> +++ a/arch/powerpc/mm/numa.c
> @@ -995,10 +995,11 @@ void __init do_init_bootmem(void)
>  				  start_pfn, end_pfn);
>  
>  		free_bootmem_with_active_regions(nid, end_pfn);
> +	}
> +
> +	for_each_online_node(nid) {
>  		/*
> -		 * Be very careful about moving this around.  Future
> -		 * calls to careful_allocation() depend on this getting
> -		 * done correctly.
> +		 * Be very careful about moving this around.
>  		 */
>  		mark_reserved_regions_for_nid(nid);
>  		sparse_memory_present_with_active_regions(nid);
> diff -puN mm/bootmem.c~powerpc-fix-code-for-reserved-memory-spanning-across-nodes mm/bootmem.c
> --- a/mm/bootmem.c~powerpc-fix-code-for-reserved-memory-spanning-across-nodes
> +++ a/mm/bootmem.c
> @@ -375,10 +375,14 @@ int __init reserve_bootmem_node(pg_data_
>  				 unsigned long size, int flags)
>  {
>  	unsigned long start, end;
> +	bootmem_data_t *bdata = pgdat->bdata;
>  
>  	start = PFN_DOWN(physaddr);
>  	end = PFN_UP(physaddr + size);
>  
> +	if (end > bdata->node_low_pfn)
> +		end = bdata->node_low_pfn;

Chandru,

from your patch descriptions I read two reasons why your bootup fails:

1. Rounding a contained range so that it exceeds the node

This is impossible.  Either your range includes that page already or
it doesn't.  bootmem doesn't reserve more pages than requested, it
just rounds up to full pages if your range includes partials.  Your
size must already overflow the node boundary if the end pfn is too
high.

2. Node-spanning range

If you have ranges that span nodes you are using the wrong interface.
By passing a node descriptor to reserve_bootmem_node(), you expect the
specified range to be on that node.  If it is not, please use the
node-agnostic reserve_bootmem() interface.

The above patch brings a kludge back to bootmem that silently cuts
bogus ranges.  I don't agree, these bugs should be fixed, not worked
around.

What I can spot in the callsite is the following:

                unsigned long physbase = lmb.reserved.region[i].base;
                unsigned long size = lmb.reserved.region[i].size;
                unsigned long start_pfn = physbase >> PAGE_SHIFT;
                unsigned long end_pfn = ((physbase + size) >> PAGE_SHIFT);

When physbase + size is not a multiple of PAGE_SIZE, the overlap is
cut off and end_pfn is too low.

                        if (end_pfn > node_ar.end_pfn)
                                reserve_size = (node_ar.end_pfn << PAGE_SHIFT)
                                        - (start_pfn << PAGE_SHIFT);

The test could then fail even if the size should have been trimmed.
Since the overlap must be less than PAGE_SIZE for this to happen, this
would explain what you noticed: the bootmem range exceeds the node
boundary by exactly one PFN because of the rounding (if I got you
right).

Patch attached, can not test, sorry, eat carefully.

	Hannes

PS: Andrew, I wasn't CC'd but this patch was listed in this `patches
that might be from hannes@etcppp'-list from another mm-commit message.
It's magical!

---
From: Johannes Weiner <hannes@cmpxchg.org>
Subject: powerpc: fix rounding error in teaching bootmem about LMB

If the reserved LMB does not exactly span complete pages, treating
(start + size) >> PAGE_SHIFT as the ending PFN is an off by one error.

The subsequent check for whether the region needs to be trimmed to fit
the underlying node can now fail if the range exceeds the node by 1 to
PAGE_SIZE - 1 bytes.  The excessive range is then passed to bootmem
which BUG()s out on it correctly.

Fix up the rounding to include all pages the LMB spans, even partial
ones.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
---

diff --git a/arch/powerpc/mm/numa.c b/arch/powerpc/mm/numa.c
index 7393bd7..38016a2 100644
--- a/arch/powerpc/mm/numa.c
+++ b/arch/powerpc/mm/numa.c
@@ -12,6 +12,7 @@
 #include <linux/bootmem.h>
 #include <linux/init.h>
 #include <linux/mm.h>
+#include <linux/pfn.h>
 #include <linux/mmzone.h>
 #include <linux/module.h>
 #include <linux/nodemask.h>
@@ -881,8 +882,8 @@ static void mark_reserved_regions_for_nid(int nid)
 	for (i = 0; i < lmb.reserved.cnt; i++) {
 		unsigned long physbase = lmb.reserved.region[i].base;
 		unsigned long size = lmb.reserved.region[i].size;
-		unsigned long start_pfn = physbase >> PAGE_SHIFT;
-		unsigned long end_pfn = ((physbase + size) >> PAGE_SHIFT);
+		unsigned long start_pfn = PFN_DOWN(physbase);
+		unsigned long end_pfn = PFN_UP(physbase + size);
 		struct node_active_region node_ar;
 		unsigned long node_end_pfn = node->node_start_pfn +
 					     node->node_spanned_pages;
