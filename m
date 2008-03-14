Return-Path: <linux-kernel-owner+w=401wt.eu-S1755631AbYCNHQQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755631AbYCNHQQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2008 03:16:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751491AbYCNHQD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Mar 2008 03:16:03 -0400
Received: from mga10.intel.com ([192.55.52.92]:58150 "EHLO
	fmsmga102.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750935AbYCNHQC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2008 03:16:02 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.25,499,1199692800"; 
   d="scan'208";a="306168981"
Subject: Re: hackbench regression since 2.6.25-rc
From: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
To: Christoph Lameter <clameter@sgi.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Kay Sievers <kay.sievers@vrfy.org>, Greg Kroah-Hartman <gregkh@suse.de>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>
In-Reply-To: <Pine.LNX.4.64.0803132328330.24204@schroedinger.engr.sgi.com>
References: <1205394417.3215.85.camel@ymzhang>
	 <20080313014808.f8d25c2a.akpm@linux-foundation.org>
	 <1205400538.3215.148.camel@ymzhang>
	 <Pine.LNX.4.64.0803131714130.22519@schroedinger.engr.sgi.com>
	 <1205463842.3215.188.camel@ymzhang>
	 <Pine.LNX.4.64.0803132328330.24204@schroedinger.engr.sgi.com>
Content-Type: text/plain; charset=utf-8
Date: Fri, 14 Mar 2008 15:14:21 +0800
Message-Id: <1205478861.3215.279.camel@ymzhang>
Mime-Version: 1.0
X-Mailer: Evolution 2.9.2 (2.9.2-2.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-03-13 at 23:32 -0700, Christoph Lameter wrote:
> On Fri, 14 Mar 2008, Zhang, Yanmin wrote:
> 
> > After testing:
> > Name                   Objects    Alloc     Free   %Fast
> > :0000192                  3428 80093958 80090708  92   8
> > :0000512                   374 80016030 80015715  68   7
> 
> Ahhh... Okay those slabs did not change for 2.6.25-rc. Is there
> really a difference to 2.6.24?
As oprofile shows slub functions spend more than 80% cpu time, I would like
to focus on optimizing SLUB before going back to 2.6.24.

> 
> > So block 192 and 512's and very active and their fast free percentage is low.
> 
> Yes but that is to be expected given that hackbench does allocate objects 
> and then passes them to other processors for freeing.
> 
> Could you get me more details on the two critical slabs?
Yes, definitely.

> 
> Do slabinfo -a and then pick one alias for each of those sizes.
They are skbuff_head_cache and kmalloc-512.

> 
> Then do
> 
> slabinfo skbuff_head (whatever alias you want to use to refer to the slab)
Slabcache: skbuff_head_cache     Aliases:  7 Order :  0 Objects: 2848

Sizes (bytes)     Slabs              Debug                Memory
------------------------------------------------------------------------
Object :     192  Total  :     142   Sanity Checks : Off  Total:  581632
SlabObj:     192  Full   :     126   Redzoning     : Off  Used :  546816
SlabSiz:    4096  Partial:       0   Poisoning     : Off  Loss :   34816
Loss   :       0  CpuSlab:      16   Tracking      : Off  Lalig:       0
Align  :       8  Objects:      21   Tracing       : Off  Lpadd:    9088

skbuff_head_cache has no kmem_cache operations

skbuff_head_cache: Kernel object allocation
-----------------------------------------------------------------------
No Data

skbuff_head_cache: Kernel object freeing
------------------------------------------------------------------------
No Data

skbuff_head_cache: No NUMA information available.

Slab Perf Counter       Alloc     Free %Al %Fr
--------------------------------------------------
Fastpath             74048234  6259131  92   7
Slowpath              6031994 73818377   7  92
Page Alloc              19746    19603   0   0
Add partial                 0  4658709   0   5
Remove partial        4639106    19603   5   0
RemoteObj/SlabFrozen        0  3887872   0   4
Total                80080228 80077508

Refill  6031979
Deactivate Full=4658836(100%) Empty=0(0%) ToHead=0(0%) ToTail=0(0%)




Slabcache: kmalloc-512           Aliases:  1 Order :  0 Objects: 365

Sizes (bytes)     Slabs              Debug                Memory
------------------------------------------------------------------------
Object :     512  Total  :      61   Sanity Checks : Off  Total:  249856
SlabObj:     512  Full   :      36   Redzoning     : Off  Used :  186880
SlabSiz:    4096  Partial:       9   Poisoning     : Off  Loss :   62976
Loss   :       0  CpuSlab:      16   Tracking      : Off  Lalig:       0
Align  :       8  Objects:       8   Tracing       : Off  Lpadd:       0

kmalloc-512 has no kmem_cache operations

kmalloc-512: Kernel object allocation
-----------------------------------------------------------------------
No Data

kmalloc-512: Kernel object freeing
------------------------------------------------------------------------
No Data

kmalloc-512: No NUMA information available.

Slab Perf Counter       Alloc     Free %Al %Fr
--------------------------------------------------
Fastpath             55039159  5006829  68   6
Slowpath             24975754 75007769  31  93
Page Alloc              73840    73779   0   0
Add partial                 0 24341085   0  30
Remove partial       24267297    73779  30   0
RemoteObj/SlabFrozen        0   953614   0   1
Total                80014913 80014598

Refill 24975738
Deactivate Full=24341121(100%) Empty=0(0%) ToHead=0(0%) ToTail=0(0%)


> 
> for each of them. Should give some more insight as to how slub behaves
> with these two slab caches.
> 

