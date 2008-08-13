Return-Path: <linux-kernel-owner+w=401wt.eu-S1757160AbYHMSSj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757160AbYHMSSj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2008 14:18:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751373AbYHMSSb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Aug 2008 14:18:31 -0400
Received: from saeurebad.de ([85.214.36.134]:36702 "EHLO saeurebad.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751152AbYHMSSa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2008 14:18:30 -0400
From: Johannes Weiner <hannes@saeurebad.de>
To: Andreas Herrmann <andreas.herrmann3@amd.com>
Cc: Ingo Molnar <mingo@elte.hu>, Nick Piggin <npiggin@suse.de>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] alloc_bootmem_core: fix misaligned allocation of 1G page
References: <20080812095336.GE5952@alberich.amd.com>
	<877iam41bk.fsf@skyscraper.fehenstaub.lan>
	<20080813164121.GA5985@alberich.amd.com>
Date: Wed, 13 Aug 2008 20:18:04 +0200
In-Reply-To: <20080813164121.GA5985@alberich.amd.com> (Andreas Herrmann's
	message of "Wed, 13 Aug 2008 18:41:21 +0200")
Message-ID: <87tzdo93tv.fsf@skyscraper.fehenstaub.lan>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Andreas Herrmann <andreas.herrmann3@amd.com> writes:

> On Tue, Aug 12, 2008 at 06:58:55PM +0200, Johannes Weiner wrote:
>> Andreas Herrmann <andreas.herrmann3@amd.com> writes:
>> > The current code in alloc_bootmem_core is based on changes introduced
>> > with commit 5f2809e69c7128f86316048221cf45146f69a4a0 (bootmem: clean
>> > up alloc_bootmem_core). But I didn't check whether this commit
>> > introduced the problem.
>> 
>> It did, there were workarounds for the same problem in the earlier code,
>> I missed it.
>> 
>> The misalignment stems from the fact that the alignment requirement is
>> wider than the offset-pfn and the starting pfn of the node is not
>> aligned itself, correct?
>
> Yes.

Okay, and the real and effective problem is that the code right now
aligns the relative offsets to the globally requested alignment, which
is of course total crap to do.  Because, whether or not the result will
be correct (only if the node start is aligned), the global alignment is
just not applicable to relative offsets, even if it works by accident.

>> I think, the cleaner fix would be to work with an aligned base pfn to
>> begin with, like the following, untested.  What do you think?
>
> This won't (completely) work.

You are right, this was not the problem at all.

> Every time you compute the new alignment for sidx the starting point
> (node_min_pfn) must be factored in.

Yep.

> Otherwise the function can't allocate the first possible page. For
> example, assuming that
>
>   node_min_pfn = 130000
>   align = 0x40000000  (1GByte)
>
> allocating a 1G page on this node will result in
>
>   sidx=0x40000
>   min_pfn=0x140000
>
> Both are properly aligned. But the resulting super-page will be at
> address 0x180000000 whereas the first possible 1G page would be at
> address 0x140000000.

I can not follow this example.  Is there a typo somewhere?  In this
example, the resulting address is aligned but it shouldn't even be so.

The sidx will be aligned and when you add 0x130000 to it, the result is
not (in this case).

>> diff --git a/mm/bootmem.c b/mm/bootmem.c
>> index 4af15d0..bee4dfe 100644
>> --- a/mm/bootmem.c
>> +++ b/mm/bootmem.c
>
>   ...
>
>> @@ -492,8 +493,7 @@ find_block:
>>  				PFN_UP(end_off), BOOTMEM_EXCLUSIVE))
>>  			BUG();
>>  
>> -		region = phys_to_virt(PFN_PHYS(bdata->node_min_pfn) +
>> -				start_off);
>> +		region = phys_to_virt(PFN_PHYS(min_pfn) + start_off);
>>  		memset(region, 0, size);
>>  		return region;
>
> Oops ...
> the returned region doesn't match the reserved one as it still gets
> reserved with
>
>           if (__reserve(bdata, PFN_DOWN(start_off) + merge,
>                         PFN_UP(end_off), BOOTMEM_EXCLUSIVE))
>    
> where __reserve() will use bdata->node_min_pfn and not the properly
> aligned min_pfn value. Either you have to pass the new min_pfn
> value to __reserve() or you have to adapt start_off with another
> offset = min_pfn - bdata->node_min_pfn ...

All in favor for the latter.  Keep the relative value at a local
alignment so that it yields a correct global alignment when combined
with node_min_pfn, no matter how node_min_pfn is aligned itself.

> I thought about other solutions like introducing a "base_offset" --
> the value needed to align node_min_pfn. But this value must be used
> in many places to correctly compute/align sidx etc. and it doesn't
> make the code better readable.
>
> Hence I still prefer the patch posted yesterday. I just want to clean
> it up somewhat. See attached patch.

Attached is a version that should be easier to read.  Please
double-check.

It keeps the indexes/offsets aligned relative to the node so that
combined with the node start always yields a value that is aligned as
requested.

	Hannes

commit ec5b91737d0be242a6a9b255fa1749962f978188
Author: Johannes Weiner <hannes@saeurebad.de>
Date:   Wed Aug 13 19:59:43 2008 +0200

    bootmem: fix aligning of node-relative indexes and offsets

diff --git a/mm/bootmem.c b/mm/bootmem.c
index 4af15d0..8620832 100644
--- a/mm/bootmem.c
+++ b/mm/bootmem.c
@@ -405,6 +405,30 @@ int __init reserve_bootmem(unsigned long addr, unsigned long size,
 }
 #endif /* !CONFIG_HAVE_ARCH_BOOTMEM_NODE */
 
+static unsigned long align_idx(struct bootmem_data *bdata, unsigned long idx,
+			unsigned long step)
+{
+	unsigned long base = bdata->node_min_pfn;
+
+	/*
+	 * Align the index with respect to the node start so that the
+	 * resulting absolute PFN (node-start + index) is properly
+	 * aligned.
+	 */
+
+	return ALIGN(base + idx, step) - base;
+}
+
+static unsigned long align_off(struct bootmem_data *bdata, unsigned long off,
+			unsigned long align)
+{
+	unsigned long base = PFN_PHYS(bdata->node_min_pfn);
+
+	/* Same as align_idx for byte offsets */
+
+	return ALIGN(base + off, align) - base;
+}
+
 static void * __init alloc_bootmem_core(struct bootmem_data *bdata,
 				unsigned long size, unsigned long align,
 				unsigned long goal, unsigned long limit)
@@ -441,16 +465,23 @@ static void * __init alloc_bootmem_core(struct bootmem_data *bdata,
 	else
 		start = ALIGN(min, step);
 
-	sidx = start - bdata->node_min_pfn;;
+	sidx = start - bdata->node_min_pfn;
 	midx = max - bdata->node_min_pfn;
 
+	/*
+	 * Because the indexes are relative to the node, all alignment
+	 * below has to be done with respect to the node's start in
+	 * order to have the resulting PFNs and addresses properly
+	 * aligned.
+	 */
+
 	if (bdata->hint_idx > sidx) {
 		/*
 		 * Handle the valid case of sidx being zero and still
 		 * catch the fallback below.
 		 */
 		fallback = sidx + 1;
-		sidx = ALIGN(bdata->hint_idx, step);
+		sidx = align_idx(bdata, bdata->hint_idx, step);
 	}
 
 	while (1) {
@@ -459,7 +490,7 @@ static void * __init alloc_bootmem_core(struct bootmem_data *bdata,
 		unsigned long eidx, i, start_off, end_off;
 find_block:
 		sidx = find_next_zero_bit(bdata->node_bootmem_map, midx, sidx);
-		sidx = ALIGN(sidx, step);
+		sidx = align_idx(bdata, sidx, step);
 		eidx = sidx + PFN_UP(size);
 
 		if (sidx >= midx || eidx > midx)
@@ -467,7 +498,7 @@ find_block:
 
 		for (i = sidx; i < eidx; i++)
 			if (test_bit(i, bdata->node_bootmem_map)) {
-				sidx = ALIGN(i, step);
+				sidx = align_idx(bdata, i, step);
 				if (sidx == i)
 					sidx += step;
 				goto find_block;
@@ -475,7 +506,7 @@ find_block:
 
 		if (bdata->last_end_off &&
 				PFN_DOWN(bdata->last_end_off) + 1 == sidx)
-			start_off = ALIGN(bdata->last_end_off, align);
+			start_off = align_off(bdata, bdata->last_end_off, align);
 		else
 			start_off = PFN_PHYS(sidx);
 
@@ -499,7 +530,7 @@ find_block:
 	}
 
 	if (fallback) {
-		sidx = ALIGN(fallback - 1, step);
+		sidx = align_idx(bdata, fallback - 1, step);
 		fallback = 0;
 		goto find_block;
 	}
