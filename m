Return-Path: <linux-kernel-owner+w=401wt.eu-S970790AbXFHUnW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S970790AbXFHUnW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2007 16:43:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758326AbXFHUnO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jun 2007 16:43:14 -0400
Received: from mx2.suse.de ([195.135.220.15]:47561 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753793AbXFHUnN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2007 16:43:13 -0400
Message-ID: <6901450.1181335390183.SLOX.WebMail.wwwrun@imap-dhs.suse.de>
Date: Fri, 8 Jun 2007 22:43:10 +0200 (CEST)
From: Andreas Kleen <ak@suse.de>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [Intel-IOMMU 02/10] Library routine for pre-allocat pool handling
Cc: "Keshavamurthy, Anil S" <anil.s.keshavamurthy@intel.com>,
       linux-kernel@vger.kernel.org, gregkh@suse.de, muli@il.ibm.com,
       asit.k.mallick@intel.com, suresh.b.siddha@intel.com,
       arjan@linux.intel.com, ashok.raj@intel.com, shaohua.li@intel.com,
       davem@davemloft.net
In-Reply-To: <20070608120107.245eba96.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-Priority: 3 (normal)
X-Mailer: SuSE Linux Openexchange Server 4 - WebMail (Build 2.4160)
X-Operating-System: Linux 2.4.21-314-smp i386 (JVM 1.3.1_19)
Organization: SuSE Linux AG
References: <20070606185658.138237000@askeshav-devel.jf.intel.com> <20070606190042.510643000@askeshav-devel.jf.intel.com> <20070607162726.2236a296.akpm@linux-foundation.org> <20070608182156.GA24865@linux-os.sc.intel.com> <20070608120107.245eba96.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Am Fr 08.06.2007 21:01 schrieb Andrew Morton
<akpm@linux-foundation.org>:

> On Fri, 8 Jun 2007 11:21:57 -0700
> "Keshavamurthy, Anil S" <anil.s.keshavamurthy@intel.com> wrote:
>
> > On Thu, Jun 07, 2007 at 04:27:26PM -0700, Andrew Morton wrote:
> > > On Wed, 06 Jun 2007 11:57:00 -0700
> > > anil.s.keshavamurthy@intel.com wrote:
> > >
> > > > Signed-off-by: Anil S Keshavamurthy
> > > > <anil.s.keshavamurthy@intel.com>
> > >
> > > That was a terse changelog.
> > >
> > > Obvious question: how does this differ from mempools, and would it
> > > be
> > > better to fill in any gaps in mempool functionality instead of
> > > implementing something similar-looking?
> >
> > Very good question. Mempool pre-allocates the elements
> > to the required minimum count size during its initilization time.
> > However when mempool_alloc() is called it tries to obtain the
> > element from OS and if that fails then it looks for the element in
> > its pool. If there are no elements in its pool and if the gpf_t
> > flags says it can wait then it waits untill someone puts the element
> > back to pool, else if gpf_t flag say it can;t wait then it returns
> > NULL.
> > In other words, mempool acts as *emergency* pool, i.e only if the OS
> > fails
> > to allocate the required memory, then the pool object is used.
> >
> >
> > In the IOMMU case, we need exactly opposite of what mempool
> > provides,
> > i.e we always want to look for the element in the pool and if the
> > pool
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
> emergency pool, then what _are_ they designed for? (Boy this is a hard
> way
> to write a changelog!)

mempools are designed to manage a limited resource pool by sleeping
if necessary until someone else frees a resource. It's basically similar
how to main VM works with a sleeping allocation, just in a "private user
group"

In the IOMMU case sleeping is not allowed because pci_map_* typically
happens inside spinlocks.  But the IOMMU code might need to allocate
new page tables and other datastructures in there.

This means mempools don't work for those (the previous version had non
sensical
constructs like GFP_ATOMIC mempool calls)

 I haven't looked at Anil's code, but I suspect the only really robust
way to handle this case is to always preallocate everything. But I'm not
sure
why that would need new library functions; it should be just some simple
lists that could be open coded.

If it needs to fall back to the OS for any non pre allocation then it
will
likely be flakey under high load. Now that might be ok in some cases
-- apparently block layer is much better at handling this than it used
to be and networking has to handle it anyways, but it might be still
a unpleasant surprise for many drivers. One generic problem is that
there are no upcalls when such resources become avaialable again
so the upper layers would need to poll to know when to resubmit
a request.

It's a pretty messy problem unfortunately.

One relatively easy way out would be to just preallocate
a static aperture fully and always map into it. Not sure
how much memory that would need -- when it's too large
it might take a lot of memory for page tables always and when it's
too small it might overflow under high load.

> That's what kmem_cache_alloc() is for?!?!

Tradtionally that was not allowed in block layer path. Not sure
it is fully obsolete with the recent dirty tracking work, probably not.

Besides it would need to be GFP_ATOMIC and the default
atomic pools are not that big.

-Andi


