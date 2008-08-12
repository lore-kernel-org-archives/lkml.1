Return-Path: <linux-kernel-owner+w=401wt.eu-S1753487AbYHLQ7c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753487AbYHLQ7c (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2008 12:59:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752062AbYHLQ7V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Aug 2008 12:59:21 -0400
Received: from saeurebad.de ([85.214.36.134]:36330 "EHLO saeurebad.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752029AbYHLQ7U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2008 12:59:20 -0400
From: Johannes Weiner <hannes@saeurebad.de>
To: Andreas Herrmann <andreas.herrmann3@amd.com>
Cc: Ingo Molnar <mingo@elte.hu>, Nick Piggin <npiggin@suse.de>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] alloc_bootmem_core: fix misaligned allocation of 1G page
References: <20080812095336.GE5952@alberich.amd.com>
Date: Tue, 12 Aug 2008 18:58:55 +0200
In-Reply-To: <20080812095336.GE5952@alberich.amd.com> (Andreas Herrmann's
	message of "Tue, 12 Aug 2008 11:53:36 +0200")
Message-ID: <877iam41bk.fsf@skyscraper.fehenstaub.lan>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andreas,

Andreas Herrmann <andreas.herrmann3@amd.com> writes:

> If memory hole remapping is enabled on an x86-NUMA system, allocation
> of 1G pages on node 1 will most probably trigger an BUG_ON in
> alloc_bootmem_huge_page because alloc_bootmem_core fails to properly
> align the huge page on a 1G boundary.

Yeah, the problem of rewriting working code is that you're likely to
re-introduce old bugs :(

> I've observed this Oops with kernel 2.6.27-rc2-00166-gaeee90d
> with a 2 socket system and activated memory hole remapping.
> (Of course disabling memory hole remapping works around the problem
> but this wastes a significant amount of memory.)
>
> Here some dmesg snippet with that kernel (using "bootmem_debug"  plus some
> additional printk's):
>
>   ...
>   Bootmem setup node 0 0000000000000000-0000000130000000
>   ...
>   Bootmem setup node 1 0000000130000000-0000000230000000
>   ...
>   Kernel command line: root=/dev/sda4 console=ttyS0,115200
>     hugepagesz=2M hugepages=0 hugepagesz=1G hugepages=3 bootmem_debug
>     debug earlyprintk=ttyS0,115200
>    ...
>
>   bootmem::alloc_bootmem_core nid=1 size=40000000 [262144 pages]
>     align=40000000 goal=0 limit=0
>   min: 1245184, max: 2293760, step: 262144, start: 1310720
>   sidx: 65536, midx: 1048576
>   sidx: 65536
>   sidx: 262144, eidx: 524288
>   start_off: 1073741824, end_off: 2147483648, merge: 0, min_pfn: 1245184
>   bootmem::__reserve nid=1 start=170000 end=1b0000 flags=1
>   addr:ffff880170000000, paddr:0000000170000000, size: 1073741824
>   PANIC: early exception 06 rip 10:ffffffff807ce3b0 error 0 cr2 0
>   Pid: 0, comm: swapper Not tainted 2.6.27-rc2-00166-gaeee90d-dirty #6
>
>   Call Trace:
>    [<ffffffff807cccbe>] ___alloc_bootmem_nopanic+0x60/0x98
>    [<ffffffff807bc195>] early_idt_handler+0x55/0x69
>    [<ffffffff807ce3b0>] alloc_bootmem_huge_page+0xa6/0xd9
>    [<ffffffff807ce39f>] alloc_bootmem_huge_page+0x95/0xd9
>    [<ffffffff807ce3fe>] hugetlb_hstate_alloc_pages+0x1b/0x3a
>    [<ffffffff807ce489>] hugetlb_nrpages_setup+0x6c/0x7a
>    [<ffffffff807bc69e>] unknown_bootoption+0xdc/0x1e2
>    [<ffffffff802446d6>] parse_args+0x137/0x1f5
>    [<ffffffff807bc5c2>] unknown_bootoption+0x0/0x1e2
>    [<ffffffff807bcb6e>] start_kernel+0x195/0x2b7
>    [<ffffffff807bc369>] x86_64_start_kernel+0xe3/0xe7
>
>   RIP 0x10
>
> The problem in alloc_bootmem_core is that it just guarantees
> proper alignment for the offset (sidx) from bdata->node_min_pfn.
>
> A simple (ugly) fix is to add bdata->node_min_pfn to sidx and
> friends. Patch is attached.

[...]

> The current code in alloc_bootmem_core is based on changes introduced
> with commit 5f2809e69c7128f86316048221cf45146f69a4a0 (bootmem: clean
> up alloc_bootmem_core). But I didn't check whether this commit
> introduced the problem.

It did, there were workarounds for the same problem in the earlier code,
I missed it.

The misalignment stems from the fact that the alignment requirement is
wider than the offset-pfn and the starting pfn of the node is not
aligned itself, correct?

I think, the cleaner fix would be to work with an aligned base pfn to
begin with, like the following, untested.  What do you think?

	Hannes

diff --git a/mm/bootmem.c b/mm/bootmem.c
index 4af15d0..bee4dfe 100644
--- a/mm/bootmem.c
+++ b/mm/bootmem.c
@@ -410,7 +410,7 @@ static void * __init alloc_bootmem_core(struct bootmem_data *bdata,
 				unsigned long goal, unsigned long limit)
 {
 	unsigned long fallback = 0;
-	unsigned long min, max, start, sidx, midx, step;
+	unsigned long min_pfn, min, max, start, sidx, midx, step;
 
 	BUG_ON(!size);
 	BUG_ON(align & (align - 1));
@@ -423,7 +423,10 @@ static void * __init alloc_bootmem_core(struct bootmem_data *bdata,
 		bdata - bootmem_node_data, size, PAGE_ALIGN(size) >> PAGE_SHIFT,
 		align, goal, limit);
 
-	min = bdata->node_min_pfn;
+	step = max(align >> PAGE_SHIFT, 1UL);
+	min_pfn = ALIGN(bdata->node_min_pfn, step);
+
+	min = min_pfn;
 	max = bdata->node_low_pfn;
 
 	goal >>= PAGE_SHIFT;
@@ -434,15 +437,13 @@ static void * __init alloc_bootmem_core(struct bootmem_data *bdata,
 	if (max <= min)
 		return NULL;
 
-	step = max(align >> PAGE_SHIFT, 1UL);
-
 	if (goal && min < goal && goal < max)
 		start = ALIGN(goal, step);
 	else
 		start = ALIGN(min, step);
 
-	sidx = start - bdata->node_min_pfn;;
-	midx = max - bdata->node_min_pfn;
+	sidx = start - min_pfn;
+	midx = max - min_pfn;
 
 	if (bdata->hint_idx > sidx) {
 		/*
@@ -492,8 +493,7 @@ find_block:
 				PFN_UP(end_off), BOOTMEM_EXCLUSIVE))
 			BUG();
 
-		region = phys_to_virt(PFN_PHYS(bdata->node_min_pfn) +
-				start_off);
+		region = phys_to_virt(PFN_PHYS(min_pfn) + start_off);
 		memset(region, 0, size);
 		return region;
 	}
