Return-Path: <linux-kernel-owner+w=401wt.eu-S1031966AbXFHUPy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031966AbXFHUPy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2007 16:15:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750943AbXFHUPs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jun 2007 16:15:48 -0400
Received: from mga02.intel.com ([134.134.136.20]:11880 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750828AbXFHUPr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2007 16:15:47 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.16,400,1175497200"; 
   d="scan'208";a="252414262"
Date: Fri, 8 Jun 2007 13:12:00 -0700
From: "Keshavamurthy, Anil S" <anil.s.keshavamurthy@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Keshavamurthy, Anil S" <anil.s.keshavamurthy@intel.com>,
       linux-kernel@vger.kernel.org, ak@suse.de, gregkh@suse.de,
       muli@il.ibm.com, asit.k.mallick@intel.com, suresh.b.siddha@intel.com,
       arjan@linux.intel.com, ashok.raj@intel.com, shaohua.li@intel.com,
       davem@davemloft.net
Subject: Re: [Intel-IOMMU 02/10] Library routine for pre-allocat pool handling
Message-ID: <20070608201200.GA641@linux-os.sc.intel.com>
Reply-To: "Keshavamurthy, Anil S" <anil.s.keshavamurthy@intel.com>
References: <20070606185658.138237000@askeshav-devel.jf.intel.com> <20070606190042.510643000@askeshav-devel.jf.intel.com> <20070607162726.2236a296.akpm@linux-foundation.org> <20070608182156.GA24865@linux-os.sc.intel.com> <20070608120107.245eba96.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070608120107.245eba96.akpm@linux-foundation.org>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 08, 2007 at 12:01:07PM -0700, Andrew Morton wrote:
> On Fri, 8 Jun 2007 11:21:57 -0700
> "Keshavamurthy, Anil S" <anil.s.keshavamurthy@intel.com> wrote:
> 
> > On Thu, Jun 07, 2007 at 04:27:26PM -0700, Andrew Morton wrote:
> > > On Wed, 06 Jun 2007 11:57:00 -0700
> > > anil.s.keshavamurthy@intel.com wrote:
> > > 
> > > > Signed-off-by: Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>
> > > 
> > > That was a terse changelog.
> > > 
> > > Obvious question: how does this differ from mempools, and would it be
> > > better to fill in any gaps in mempool functionality instead of
> > > implementing something similar-looking?
> > 
> > Very good question. Mempool pre-allocates the elements
> > to the required minimum count size during its initilization time.
> > However when mempool_alloc() is called it tries to obtain the
> > element from OS and if that fails then it looks for the element in 
> > its pool. If there are no elements in its pool and if the gpf_t 
> > flags says it can wait then it waits untill someone puts the element 
> > back to pool, else if gpf_t flag say it can;t wait then it returns NULL. 
> > In other words, mempool acts as *emergency* pool, i.e only if the OS fails 
> > to allocate the required memory, then the pool object is used.
> > 
> > 
> > In the IOMMU case, we need exactly opposite of what mempool provides,
> > i.e we always want to look for the element in the pool and if the pool
> > has no element then go to OS as a worst case. This resource pool
> > library routines do the same. Again, this resource pools 
> > grows and shrinks automatically to maintain the minimum pool 
> > elements in the background. I am not sure whether this totally
> > opposite functionality of mempools and resource pools can be 
> > merged.
> 
> Confused.
> 
> If resource pools are not designed to provide extra robustness via an
> emergency pool, then what _are_ they designed for?  (Boy this is a hard way
> to write a changelog!)

The resource pool indeed provide extra robustness, the initial pool size will
be equal to min_count + grow_count. If the pool object count goes below
min_count, then pool grows in the background while serving as emergency
pool with min_count of objects in it. If we run out of emergency pool objects
before the pool grow in the background, then we go to OS for allocation.

Similary, if the pool objects grows above the max threshold,
the objects are freed to OS in the background thread maintaining
the pool objects close to min_count + grow_count size.


> 
> > In fact the very first version of this IOMMU patch used mempools
> > and the performance was worse because mempool did not help as
> > IOMMU did a very frequent alloc and free of pool objects and
> > every call to alloc/free used to go to os. Andi Kleen, 
> > noticied and told us that mempool usage for IOMMU is wrong and
> > hence we came up with resource pool concept.
> 
> You _seem_ to be saying that the resource pools are there purely for
> alloc/free performance reasons.  If so, I'd be skeptical: slab is pretty
> darned fast.
We need several objects of size say( 4 * sizeof(u64)) and reuse
them in dma map/unmap api calls for managing io virtual allocation address that
this driver has dished out. Hence having pool of objects where we put 
the element in the linked list and and get it from the linked list is pretty
fast compared to slab.
> 
> > > 
> > > The changelog very much should describe all this, as well as explaining
> > > what the dynamic behaviour of this new thing is, and what applications are
> > > envisaged, what problems it solves, etc, etc.
> > 
> > I can gladly update the changelog if the resource pool concept is 
> > approved. I will fix all the below minor comments.
> > 
> > I envision that this might be useful for all vendor's (IBM, AMD, Intel, etc) IOMMU driver
> > and for any kernel component which does lots of dynamic alloc/free an object of same size.
> > 
> 
> That's what kmem_cache_alloc() is for?!?!
We had this kmem_cache_alloc() with mempool concept earlier and Andi suggest to 
come up with something pre-allocated pool.  
Andi, Can you chime in please.

-Anil
