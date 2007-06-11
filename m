Return-Path: <linux-kernel-owner+w=401wt.eu-S1756656AbXFKXTK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756656AbXFKXTK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2007 19:19:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751367AbXFKXS6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jun 2007 19:18:58 -0400
Received: from mga01.intel.com ([192.55.52.88]:6498 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750930AbXFKXS5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2007 19:18:57 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.16,409,1175497200"; 
   d="scan'208";a="255722534"
Date: Mon, 11 Jun 2007 16:15:02 -0700
From: "Keshavamurthy, Anil S" <anil.s.keshavamurthy@intel.com>
To: Andi Kleen <ak@suse.de>
Cc: "Keshavamurthy, Anil S" <anil.s.keshavamurthy@intel.com>,
       Christoph Lameter <clameter@sgi.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       gregkh@suse.de, muli@il.ibm.com, asit.k.mallick@intel.com,
       suresh.b.siddha@intel.com, arjan@linux.intel.com, ashok.raj@intel.com,
       shaohua.li@intel.com, davem@davemloft.net
Subject: Re: [Intel-IOMMU 02/10] Library routine for pre-allocat pool handling
Message-ID: <20070611231502.GA25022@linux-os.sc.intel.com>
Reply-To: "Keshavamurthy, Anil S" <anil.s.keshavamurthy@intel.com>
References: <20070606185658.138237000@askeshav-devel.jf.intel.com> <200706091147.24705.ak@suse.de> <20070611204442.GA4074@linux-os.sc.intel.com> <200706120025.58137.ak@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200706120025.58137.ak@suse.de>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 12, 2007 at 12:25:57AM +0200, Andi Kleen wrote:
> 
> > Please advice.
> 
> I think the short term only safe option would be to fully preallocate an aperture.
> If it is too small you can try GFP_ATOMIC but it would be just
> a unreliable fallback. For safety you could perhaps have some kernel thread
> that tries to enlarge it in the background depending on current
> use. That would be not 100% guaranteed to keep up with load,
> but would at least keep up if the system is not too busy.
> 
> That is basically what your resource pools do, but they seem
> to be unnecessarily convoluted for the task :- after all you
> could just preallocate the page tables and rewrite/flush them without
> having some kind of allocator inbetween, can't you?
Nope, it is not convoluted for the task. If you see carefully how
the IO virtual address is obtained, I am basically reusing the
the previous translated virutal address once it is freed instead
of going for continious IO virtural address. Because of this
reuse of IO virtual address, these address tend to map to the
same PAGE tables and hence the memory for page tables itself
does not grow unless there is that much IO going on in the System
where all entries in the page tables are full(which means that
much IO is in flight).

The only defect I see in the current resource pool is that
I am queuing the work on Keventd to grow the pool which could
be a problem as many other subsystem in the kernel depends
on keventd and as Anderew pointed out we could dead lock.
If we have a separate worker thread to grow the pool then
the deadlock issues is taken care.

I would still love to get my current resource pool (just fix the
keventd to separate thread to grow the pool) implementations 
to get into linus kernrl compared to kmem_cache_alloc implementation 
as I don;t see any benifit in moving to kmem_cache_alloc. But if 
people want I can provide kmem_cache_alloc implementation 
too just for comparisions. But this does not solve the fundamental 
problem that we have today.

So ideally for IOMMU's we should have some preallocated buffers
and if the buffers reach certain min_threshould the pool should
grow in the background and all of these features is in resource pool
implementation. Since we did not see any problems, can we
atleat try this resource pool implementation in the linux
MM kernels? If it is too bad, then I will change to 
kmem_cache_alloc() version. If this testing is OKAY, then
I will refresh my patch for the coding styles etc and 
resubmit with resource pool implementation. Andrew??


> 
> If you make the start value large enough (256+MB?) that might reasonably
> work. How much memory in page tables would that take? Or perhaps scale
> it with available memory or available devices. 

What you are suggesting is to prealloacate and setup the page tables at the
begining. But this would waste lot of memory because we don't know ahead of
time how large the page table setup should be and in future our hardware
can support 64K domains where each domain can dish out independent address
from its start to end address range. And pre-setup of tables for all of the
64K domains is not feasible.

> 
> In theory it could also be precomputed from the block/network device queue 
> lengths etc.; the trouble is just such checks would need to be added to all kinds of 
> other odd subsystems that manage devices too.  That would be much more work.
> 
> Some investigation how to do sleeping block/network submit would be
> also interesting (e.g. replace the spinlocks there with mutexes and see how
> much it affects performance). For networking you would need to keep 
> at least a non sleeping path though because packets can be legally
> submitted from interrupt context. If it works out then sleeping
> interfaces to the IOMMU code could be added.

Yup, these investigations needs to happen and sooner the better for all and 
for general linux community.

> 
> -Andi
