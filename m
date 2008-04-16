Return-Path: <linux-kernel-owner+w=401wt.eu-S1765129AbYDPOFa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765129AbYDPOFa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2008 10:05:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754824AbYDPOFS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Apr 2008 10:05:18 -0400
Received: from gir.skynet.ie ([193.1.99.77]:45284 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754368AbYDPOFQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2008 10:05:16 -0400
Date: Wed, 16 Apr 2008 15:05:13 +0100
From: Mel Gorman <mel@csn.ul.ie>
To: Ingo Molnar <mingo@elte.hu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Christoph Lameter <clameter@sgi.com>, linux-kernel@vger.kernel.org,
       Nick Piggin <npiggin@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Yinghai.Lu@sun.com, apw@shadowen.org,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [patch] mm: sparsemem memory_present() memory corruption fix
Message-ID: <20080416140512.GA1438@csn.ul.ie>
References: <20080415161532.GA15088@elte.hu> <alpine.LFD.1.00.0804151010500.2879@woody.linux-foundation.org> <Pine.LNX.4.64.0804151232080.1785@schroedinger.engr.sgi.com> <20080415195430.GA23015@elte.hu> <Pine.LNX.4.64.0804151255390.1785@schroedinger.engr.sgi.com> <20080415201734.GA25628@elte.hu> <4805115D.5030703@cs.helsinki.fi> <20080415204025.GA29784@elte.hu> <alpine.LFD.1.00.0804151353380.2879@woody.linux-foundation.org> <20080416000356.GA24737@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20080416000356.GA24737@elte.hu>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On (16/04/08 02:03), Ingo Molnar didst pronounce:
> 
> finally found it ... the patch below solves the sparsemem crash and the 
> testsystem boots up fine now:
> 
>   mars:~> uname -a
>   Linux mars 2.6.25-rc9-sched-devel.git-x86-latest.git #985 SMP Wed Apr 16 
>   01:37:37 CEST 2008 i686 i686 i386 GNU/Linux
> 
> yay! :-)
> 

Very cool :) This fixed the silent lock-up that I was getting when using
your config as well.

At a bit of a loss yesterday to explain what was going wrong, I had started
putting together patches to sanity check memory initialisation at various
different stages trying to catch where things were going pear-shaped. You
found the bug before it was done but I finished the basics anyway and posted
it as "[RFC] Verification and debugging of memory initialisation". Something
like it may help avoid similar headaches for people who tend to run into
(or cause) boot problems.

> ps. anyone who can correctly guess the method with which i found the 
>     exact place that corrupted memory will get a free beer next time we 
>     meet :-)
> 
> ------------------------->
> Subject: mm: sparsemem memory_present() memory corruption fix
> From: Ingo Molnar <mingo@elte.hu>
> Date: Wed Apr 16 01:40:00 CEST 2008
> 
> fix memory corruption and crash on 32-bit x86 systems.
> 
> if a !PAE x86 kernel is booted on a 32-bit system with more than
> 4GB of RAM, then we call memory_present() with a start/end that
> goes outside the scope of MAX_PHYSMEM_BITS.
> 
> that causes this loop to happily walk over the limit of the
> sparse memory section map:
> 
>     for (pfn = start; pfn < end; pfn += PAGES_PER_SECTION) {
>                 unsigned long section = pfn_to_section_nr(pfn);
>                 struct mem_section *ms;
> 
>                 sparse_index_init(section, nid);
>                 set_section_nid(section, nid);
> 
>                 ms = __nr_to_section(section);
>                 if (!ms->section_mem_map)
>                         ms->section_mem_map = sparse_encode_early_nid(nid) |
> 
> 'ms' will be out of bounds and we'll corrupt a small amount of memory by
> encoding the node ID. Depending on what that memory is, we might crash, 
> misbehave or just not notice the bug.
> 
> the fix is to sanity check anything the architecture passes to sparsemem.
> 
> this bug seems to be rather old (as old as sparsemem support itself),
> but the exact incarnation depended on random details like configs,
> which made this bug more prominent in v2.6.25-to-be.
> 
> an additional enhancement might be to print a warning about ignored
> or trimmed memory ranges.
> 
> Signed-off-by: Ingo Molnar <mingo@elte.hu>
> ---
>  mm/sparse.c |   10 ++++++++++
>  1 file changed, 10 insertions(+)
> 
> Index: linux/mm/sparse.c
> ===================================================================
> --- linux.orig/mm/sparse.c
> +++ linux/mm/sparse.c
> @@ -149,8 +149,18 @@ static inline int sparse_early_nid(struc
>  /* Record a memory area against a node. */
>  void __init memory_present(int nid, unsigned long start, unsigned long end)
>  {
> +	unsigned long max_arch_pfn = 1ULL << (MAX_PHYSMEM_BITS-PAGE_SHIFT);
>  	unsigned long pfn;
>  
> +	/*
> +	 * Sanity checks - do not allow an architecture to pass
> +	 * in larger pfns than the maximum scope of sparsemem:
> +	 */
> +	if (start >= max_arch_pfn)
> +		return;
> +	if (end >= max_arch_pfn)
> +		end = max_arch_pfn;
> +
>  	start &= PAGE_SECTION_MASK;
>  	for (pfn = start; pfn < end; pfn += PAGES_PER_SECTION) {
>  		unsigned long section = pfn_to_section_nr(pfn);
> 

-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab
