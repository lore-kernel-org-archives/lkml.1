Return-Path: <linux-kernel-owner+w=401wt.eu-S1756170AbYHMQlt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756170AbYHMQlt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2008 12:41:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752464AbYHMQll
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Aug 2008 12:41:41 -0400
Received: from outbound-va3.frontbridge.com ([216.32.180.16]:59521 "EHLO
	VA3EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752457AbYHMQlk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2008 12:41:40 -0400
X-BigFish: VPS-40(zz1dbaM1432R98dR1805M936fQ3117Kzz10d3izzz32i6bh61h)
X-Spam-TCS-SCL: 0:0
X-WSS-ID: 0K5JT0Y-01-GRI-01
Date: Wed, 13 Aug 2008 18:41:21 +0200
From: Andreas Herrmann <andreas.herrmann3@amd.com>
To: Johannes Weiner <hannes@saeurebad.de>
CC: Ingo Molnar <mingo@elte.hu>, Nick Piggin <npiggin@suse.de>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] alloc_bootmem_core: fix misaligned allocation of 1G
	page
Message-ID: <20080813164121.GA5985@alberich.amd.com>
References: <20080812095336.GE5952@alberich.amd.com> <877iam41bk.fsf@skyscraper.fehenstaub.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <877iam41bk.fsf@skyscraper.fehenstaub.lan>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-OriginalArrivalTime: 13 Aug 2008 16:41:26.0318 (UTC) FILETIME=[6DA504E0:01C8FD63]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 12, 2008 at 06:58:55PM +0200, Johannes Weiner wrote:
> Andreas Herrmann <andreas.herrmann3@amd.com> writes:
> > The current code in alloc_bootmem_core is based on changes introduced
> > with commit 5f2809e69c7128f86316048221cf45146f69a4a0 (bootmem: clean
> > up alloc_bootmem_core). But I didn't check whether this commit
> > introduced the problem.
> 
> It did, there were workarounds for the same problem in the earlier code,
> I missed it.
> 
> The misalignment stems from the fact that the alignment requirement is
> wider than the offset-pfn and the starting pfn of the node is not
> aligned itself, correct?

Yes.

> I think, the cleaner fix would be to work with an aligned base pfn to
> begin with, like the following, untested.  What do you think?

This won't (completely) work.

Every time you compute the new alignment for sidx the starting point
(node_min_pfn) must be factored in.

Otherwise the function can't allocate the first possible page. For
example, assuming that

  node_min_pfn = 130000
  align = 0x40000000  (1GByte)

allocating a 1G page on this node will result in

  sidx=0x40000
  min_pfn=0x140000

Both are properly aligned. But the resulting super-page will be at
address 0x180000000 whereas the first possible 1G page would be at
address 0x140000000.

> diff --git a/mm/bootmem.c b/mm/bootmem.c
> index 4af15d0..bee4dfe 100644
> --- a/mm/bootmem.c
> +++ b/mm/bootmem.c

  ...

> @@ -492,8 +493,7 @@ find_block:
>  				PFN_UP(end_off), BOOTMEM_EXCLUSIVE))
>  			BUG();
>  
> -		region = phys_to_virt(PFN_PHYS(bdata->node_min_pfn) +
> -				start_off);
> +		region = phys_to_virt(PFN_PHYS(min_pfn) + start_off);
>  		memset(region, 0, size);
>  		return region;

Oops ...
the returned region doesn't match the reserved one as it still gets
reserved with

          if (__reserve(bdata, PFN_DOWN(start_off) + merge,
                        PFN_UP(end_off), BOOTMEM_EXCLUSIVE))
   
where __reserve() will use bdata->node_min_pfn and not the properly
aligned min_pfn value. Either you have to pass the new min_pfn
value to __reserve() or you have to adapt start_off with another
offset = min_pfn - bdata->node_min_pfn ...



I thought about other solutions like introducing a "base_offset" --
the value needed to align node_min_pfn. But this value must be used
in many places to correctly compute/align sidx etc. and it doesn't
make the code better readable.

Hence I still prefer the patch posted yesterday. I just want to clean
it up somewhat. See attached patch.


Regards,

Andreas
--

alloc_bootmem_core: minor cleanup, use min instead of bdata->node_min_pfn

Signed-off-by: Andreas Herrmann <andreas.herrmann3@amd.com>
---
 mm/bootmem.c |   20 ++++++++------------
 1 files changed, 8 insertions(+), 12 deletions(-)

diff --git a/mm/bootmem.c b/mm/bootmem.c
index 9d54244..11ece4b 100644
--- a/mm/bootmem.c
+++ b/mm/bootmem.c
@@ -459,9 +459,8 @@ static void * __init alloc_bootmem_core(struct bootmem_data *bdata,
 		unsigned long eidx, i, start_off, end_off;
 find_block:
 		sidx = find_next_zero_bit(bdata->node_bootmem_map,
-					  midx - bdata->node_min_pfn,
-					  sidx - bdata->node_min_pfn);
-		sidx += bdata->node_min_pfn;
+					  midx - min, sidx - min);
+		sidx += min;
 		sidx = ALIGN(sidx, step);
 		eidx = sidx + PFN_UP(size);
 
@@ -469,8 +468,7 @@ find_block:
 			break;
 
 		for (i = sidx; i < eidx; i++)
-			if (test_bit(i - bdata->node_min_pfn,
-				     bdata->node_bootmem_map)) {
+			if (test_bit(i - min, bdata->node_bootmem_map)) {
 				sidx = ALIGN(i, step);
 				if (sidx == i)
 					sidx += step;
@@ -478,17 +476,16 @@ find_block:
 			}
 
 		if (bdata->last_end_off &&
-		    (PFN_DOWN(bdata->last_end_off) + 1) ==
-		    (sidx - bdata->node_min_pfn))
+		    (PFN_DOWN(bdata->last_end_off) + 1) == (sidx - min))
 			start_off = ALIGN(bdata->last_end_off, align);
 		else
-			start_off = PFN_PHYS(sidx - bdata->node_min_pfn);
+			start_off = PFN_PHYS(sidx - min);
 
-		merge = PFN_DOWN(start_off) < (sidx - bdata->node_min_pfn);
+		merge = PFN_DOWN(start_off) < (sidx - min);
 		end_off = start_off + size;
 
 		bdata->last_end_off = end_off;
-		bdata->hint_idx = PFN_UP(end_off + bdata->node_min_pfn);
+		bdata->hint_idx = PFN_UP(end_off + min);
 
 		/*
 		 * Reserve the area now:
@@ -497,8 +494,7 @@ find_block:
 				PFN_UP(end_off), BOOTMEM_EXCLUSIVE))
 			BUG();
 
-		region = phys_to_virt(PFN_PHYS(bdata->node_min_pfn) +
-				start_off);
+		region = phys_to_virt(PFN_PHYS(min) + start_off);
 		memset(region, 0, size);
 		return region;
 	}
-- 
1.5.6.4




