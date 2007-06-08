Return-Path: <linux-kernel-owner+w=401wt.eu-S969857AbXFHVYs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S969857AbXFHVYs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2007 17:24:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751072AbXFHVYl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jun 2007 17:24:41 -0400
Received: from mga09.intel.com ([134.134.136.24]:10568 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750926AbXFHVYl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2007 17:24:41 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.16,401,1175497200"; 
   d="scan'208";a="94923863"
Date: Fri, 8 Jun 2007 14:20:54 -0700
From: "Keshavamurthy, Anil S" <anil.s.keshavamurthy@intel.com>
To: Andreas Kleen <ak@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       "Keshavamurthy, Anil S" <anil.s.keshavamurthy@intel.com>,
       linux-kernel@vger.kernel.org, gregkh@suse.de, muli@il.ibm.com,
       asit.k.mallick@intel.com, suresh.b.siddha@intel.com,
       arjan@linux.intel.com, ashok.raj@intel.com, shaohua.li@intel.com,
       davem@davemloft.net
Subject: Re: [Intel-IOMMU 02/10] Library routine for pre-allocat pool handling
Message-ID: <20070608212054.GB641@linux-os.sc.intel.com>
Reply-To: "Keshavamurthy, Anil S" <anil.s.keshavamurthy@intel.com>
References: <20070606185658.138237000@askeshav-devel.jf.intel.com> <20070606190042.510643000@askeshav-devel.jf.intel.com> <20070607162726.2236a296.akpm@linux-foundation.org> <20070608182156.GA24865@linux-os.sc.intel.com> <20070608120107.245eba96.akpm@linux-foundation.org> <6901450.1181335390183.SLOX.WebMail.wwwrun@imap-dhs.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <6901450.1181335390183.SLOX.WebMail.wwwrun@imap-dhs.suse.de>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 08, 2007 at 10:43:10PM +0200, Andreas Kleen wrote:
> Am Fr 08.06.2007 21:01 schrieb Andrew Morton
> <akpm@linux-foundation.org>:
> 
> > On Fri, 8 Jun 2007 11:21:57 -0700
> > "Keshavamurthy, Anil S" <anil.s.keshavamurthy@intel.com> wrote:
> >
> > > On Thu, Jun 07, 2007 at 04:27:26PM -0700, Andrew Morton wrote:
> > > > On Wed, 06 Jun 2007 11:57:00 -0700
> > > > anil.s.keshavamurthy@intel.com wrote:
> > > >
> > > > > Signed-off-by: Anil S Keshavamurthy
> > > > > <anil.s.keshavamurthy@intel.com>
> > > >
> > > > That was a terse changelog.
> > > >
> > > > Obvious question: how does this differ from mempools, and would it
> > > > be
> > > > better to fill in any gaps in mempool functionality instead of
> > > > implementing something similar-looking?
> > >
> > > Very good question. Mempool pre-allocates the elements
> > > to the required minimum count size during its initilization time.
> > > However when mempool_alloc() is called it tries to obtain the
> > > element from OS and if that fails then it looks for the element in
> > > its pool. If there are no elements in its pool and if the gpf_t
> > > flags says it can wait then it waits untill someone puts the element
> > > back to pool, else if gpf_t flag say it can;t wait then it returns
> > > NULL.
> > > In other words, mempool acts as *emergency* pool, i.e only if the OS
> > > fails
> > > to allocate the required memory, then the pool object is used.
> > >
> > >
> > > In the IOMMU case, we need exactly opposite of what mempool
> > > provides,
> > > i.e we always want to look for the element in the pool and if the
> > > pool
> > > has no element then go to OS as a worst case. This resource pool
> > > library routines do the same. Again, this resource pools
> > > grows and shrinks automatically to maintain the minimum pool
> > > elements in the background. I am not sure whether this totally
> > > opposite functionality of mempools and resource pools can be
> > > merged.
> >
> > Confused.
> >
> > If resource pools are not designed to provide extra robustness via an
> > emergency pool, then what _are_ they designed for? (Boy this is a hard
> > way
> > to write a changelog!)
> 
> mempools are designed to manage a limited resource pool by sleeping
> if necessary until someone else frees a resource. It's basically similar
> how to main VM works with a sleeping allocation, just in a "private user
> group"
> 
> In the IOMMU case sleeping is not allowed because pci_map_* typically
> happens inside spinlocks.  But the IOMMU code might need to allocate
> new page tables and other datastructures in there.
> 
> This means mempools don't work for those (the previous version had non
> sensical
> constructs like GFP_ATOMIC mempool calls)
> 
>  I haven't looked at Anil's code, but I suspect the only really robust
> way to handle this case is to always preallocate everything. But I'm not
> sure
> why that would need new library functions; it should be just some simple
> lists that could be open coded.

Since it is practically impossible to predicit how much to preallocate,
we have a min_count+grow_count of object allocated and we always use from this
pool. If the object count goes below certain low threshold(which acts as 
emergency pool from this point), the pool grows by allocating and 
adding the newly allocated object into the pool in the
worker (keventd) thread. 
Again, once the IO pressure is over, the PCI driver
does the unmap calls and we put back the objects back to preallocate pools.
The smartness is builtin to the pool as the elements are put back to the 
pool it detects that the pool count is greater then the threshold and 
it automagically queues the work to free the objects and bring back the 
pre-allocated object count back to minimum threshold.
Thus this preallocated pool grow and shrinks based on the demand, while
acting as both pre-allocated pools and as emergency pool.

Currently I have made this as a libray functions, if that is not correct,
we can pull this and make it part of the Intel IOMMU driver itself.
Please do let me know your suggestions.

> 
> If it needs to fall back to the OS for any non pre allocation then it
> will
> likely be flakey under high load. Now that might be ok in some cases
> -- apparently block layer is much better at handling this than it used
> to be and networking has to handle it anyways, but it might be still
> a unpleasant surprise for many drivers. One generic problem is that
> there are no upcalls when such resources become avaialable again
> so the upper layers would need to poll to know when to resubmit
> a request.
> 
> It's a pretty messy problem unfortunately.
I agree, worst case if the element is not available in the 
pool we need to fall back to the OS and if OS fails then it
is tough luck.

> 
> One relatively easy way out would be to just preallocate
> a static aperture fully and always map into it. Not sure
> how much memory that would need -- when it's too large
> it might take a lot of memory for page tables always and when it's
> too small it might overflow under high load.
Yup, and since we need to use the same driver from 
desktop to servers, preallocation count for servers 
many not be suitable for desktops.

> 
> > That's what kmem_cache_alloc() is for?!?!
> 
> Tradtionally that was not allowed in block layer path. Not sure
> it is fully obsolete with the recent dirty tracking work, probably not.
> 
> Besides it would need to be GFP_ATOMIC and the default
> atomic pools are not that big.
> 
> -Andi
