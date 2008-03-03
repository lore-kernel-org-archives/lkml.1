Return-Path: <linux-kernel-owner+w=401wt.eu-S1759221AbYCCS3Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759221AbYCCS3Q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2008 13:29:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751648AbYCCS26
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Mar 2008 13:28:58 -0500
Received: from mga10.intel.com ([192.55.52.92]:64774 "EHLO
	fmsmga102.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751214AbYCCS24 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2008 13:28:56 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.25,439,1199692800"; 
   d="scan'208";a="303370185"
Date: Mon, 3 Mar 2008 10:34:11 -0800
From: mark gross <mgross@linux.intel.com>
To: Grant Grundler <grundler@parisc-linux.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, greg@kroah.com,
       lkml <linux-kernel@vger.kernel.org>, linux-pci@atrey.karlin.mff.cuni.cz
Subject: Re: [PATCH]iommu-iotlb-flushing
Message-ID: <20080303183411.GA13582@linux.intel.com>
Reply-To: mgross@linux.intel.com
References: <20080221000623.GA5510@linux.intel.com> <20080223000517.232704f3.akpm@linux-foundation.org> <20080229231841.GA6639@linux.intel.com> <20080301071043.GB9373@colo.lackof.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080301071043.GB9373@colo.lackof.org>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 01, 2008 at 12:10:43AM -0700, Grant Grundler wrote:
> On Fri, Feb 29, 2008 at 03:18:41PM -0800, mark gross wrote:
> > On Sat, Feb 23, 2008 at 12:05:17AM -0800, Andrew Morton wrote:
> > > On Wed, 20 Feb 2008 16:06:23 -0800 mark gross <mgross@linux.intel.com> wrote:
> > > 
> > > > The following patch is for batching up the flushing of the IOTLB for
> > > > the DMAR implementation found in the Intel VT-d hardware.  It works by
> > > > building a list of to be flushed IOTLB entries and a bitmap list of
> > > > which DMAR engine they are from.
> 
> I didn't see the original patch - thanks for cc'ing linux-pci.
> 
> PA-RISC and IA64 have been doing this for several years now.
> See DELAYED_RESOURCE_CNT usage in drivers/parisc/sba_iommu.c
> and in arch/ia64/hp/common/sba_iommu.c.
> 
> I prototyped the same concept for x86_64 GART support but it didn't
> seem to matter on benchmarks since most of the devices I use are
> 64-bit and don't need to use the IOMMU. IDE/SATA controllers 
> are 32-bit but there is LOTS of overhead in so many other places,
> this change made less than 0.3 difference for them.

The intel DMAR engines with the TLB's do have a measurable overhead
flushing TLB entries on every unmapsingle.  This hardware forces a bit
poll on TLB flush completion that adds up on high rates of unmap
operations.  (about 15% on my netperf small packet 32 byte UDP stream
over a 1GigE adapter)

FWIW: I think IOMMU use for avoiding bounce buffers is a thing of the
past.  (at least I have a "show me where it helps" point of view for
modern hardware.  what new hardware needs bounce buffers anymore?)

Also, to be fair to the Intel hardware the performance overhead is
really only noticeable on small packed and 10Gig benchmarking.  Most
users will not be able to notice the overhead.

> (And the decision to use uncached memory for the IO Pdir made this moot).
> I'd be happy to post the patch if someone wants to see it though.
> 
> > > > This approach recovers 15 to 20% of the performance lost when using the
> > > > IOMMU for my netperf udp stream benchmark with small packets.  It can be
> > > > disabled with a kernel boot parameter
> > > > "intel_iommu=strict".
> > > > 
> > > > Its use does weaken the IOMMU protections a bit.
> 
> One can do a few things to limit how much the protections
> are weakened:
> 1) Invalidate the IO TLB entry and IO Pdir entries (just don't force
>   syncronization). At least this was possible on the IOMMU's
>   I'm familiar with.

The default is the TLB invalidation. It has a nasty polling loop that
hurts on the small packet netperf benchmark.

> 
> 2) release the IO Pdir entry for re-use once syncronization has been forced.
>    Syncronization/flushing of the IO TLB shoot-down is the most expensive
>    ops AFAICT on the IOMMU's I've worked with.

this is what the patch does.

> 
> I don't ever recall finding a bug where the device was DMA'ing to a
> buffer again shortly after unmap call. Most DMA errors are device driver
> not programming the DMA engines correctly.
> 

This makes me feel a bit better.


> > > > +	if (intel_iommu_strict) {
> 
> I suggest adding an "unlikely()" around this test so the compiler
> can generate better code for this and it's clear what your intent is.
> 

Ack

> 
> I just looked at the implementation of flush_unmaps().
> I strongly reccomend comparing this implementation with the
> DELAYED_RESOURCE_CNT since this looks like it will need 2X or more
> of the CPU cycles to execute for each entry. Use of "list_del()"
> is substantially more expensive than a simple linear arrary.
> (Fewer entries per cacheline by 4X maybe?)
>

/me looks, an array of pointers to iova's to clean up makes good sense.
I don't know why I didn't think of this approach first.  Working with
lists is messy and if I can avoid it I usually try.
 
> Another problem is every now and then some IO is going to burn a bunch
> of CPU cycles and introduce inconsistent performance for particular
> unmap operations. One has to tradeoff amortizing the cost of the
> IOMMU flushing with the number of "unusable" IO Pdir entries and more
> consistent CPU utilization for each unmap() call.  My gut feeling
> is 250 is rather high for high_watermark unless flushing the IO TLB
> is extremely expensive.
> 

the 250 high water mark came from 1gig small packet netperf udp
streaming testing.  The 1000 I initially used didn't perform quite as
well.  Nothing scientific went into this number just some tests cases.

> 
> ...
> > > boot-time options suck.  Is it not possible to tweak this at runtime?
> > 
> > Yes, I could easily create a sysfs or debugfs mechanism for turning it
> > on / off at run time.  I would like input on the preferred way to do this.
> > sysfs or debugfs?
> 
> I prefer a compile time constant since we are talking about fixed costs
> for this implementation.  The compiler can do a better job with a constant.
> I know this sounds nit picky but if I can't sufficiently emphasized how
> perf critical DMA map/unmap code is.

Compile time options lock out OSV's from using the feature.  These
IOMMU's are in desktop systems now.  My job is to make it not suck so
OSV's will leave DMAR enabled in production kernels.  (well at least
try to anyway.)

> 
> If it has to be a variable, I prefer sysfs but don't have a good reason
> for that.
> 
> > Signed-off-by: <mgross@linux.intel.com>
> 
> Ah! Maybe you can get together with Matthew Wilcox (also) and consider
> how the IOMMU code might be included in the scsi_ram driver he wrote.
> Or maybe just directly use the ram disk (rd.c) instead.

Yup, Willi has just started to look over my shoulder on some of this.
He pointed me at some OLS papers and whatnot to look at.  I botched my
chance to work face to face with him last week on his last visit to
Oregon but we'll keep talking.

> 
> At LSF, I suggested using the IOAT DMA engine (if available) do real DMA.
> Running the IO requests through the IOMMU would expose the added CPU cost
> of the IOMMU in it's worst case. This doesn't need to go to kernel.org
> but might help you isolate perf bottlenecks in this iommu code.

Oh the worst cases are easy.  Just run a 10gig NIC and see what you get.
With a 1Gig NIC you need to drop the packet size down to 32 bytes or
something tiny like that to really notice it.  16K packets
have only a smallish overhead that are iffy as benchmarks because the
CPU utilization is too low (<25%) to be a good measure.

FWIW : throughput isn't effected so much as the CPU overhead.
iommu=strict: 16K UDP UNIDIRECTIONAL SEND TEST 826Mbps at 25% cpu 
with this patch: 16K UDP UNIDIRECTIONAL SEND TEST 826Mbps at 18% cpu 
IOMMU=OFF: 16K UDP UNIDIRECTIONAL SEND TEST 826Mbps at 11% cpu 


> 
> 
> > Index: linux-2.6.25-rc2-mm1/drivers/pci/intel-iommu.c
> > ===================================================================
> > --- linux-2.6.25-rc2-mm1.orig/drivers/pci/intel-iommu.c	2008-02-26 11:15:46.000000000 -0800
> > +++ linux-2.6.25-rc2-mm1/drivers/pci/intel-iommu.c	2008-02-29 14:36:55.000000000 -0800
> ...
> > +static void flush_unmaps_timeout(unsigned long data);
> > +
> > +DEFINE_TIMER(unmap_timer,  flush_unmaps_timeout, 0, 0);
> 
> Why bother with the timer?
> 
> This just adds more overhead and won't help much to improve
> protection.  If someone needs tighter protection, the "strict"
> unmapping/flushing parameter should be sufficient to track
> down the issues they might be seeing.  And it's perfectly OK
> to be sitting on a few "unusable" IOMMU entries.
> 

/me thinks about this.  You have a point.  I put in the timer to build
the time window of any rogue DMA actions.  I still worry about
potentially unbounded times where a stale IOTLB entry could be used.
What do others think?

> ...
> > +static void flush_unmaps(void)
> > +{
> > +	struct iova *node, *n;
> > +	unsigned long flags;
> > +	int i;
> > +
> > +	spin_lock_irqsave(&async_umap_flush_lock, flags);
> > +	timer_on = 0;
> > +
> > +	/* just flush them all */
> > +	for (i = 0; i < g_num_of_iommus; i++) {
> > +		if (test_and_clear_bit(i, g_iommus_to_flush))
> > +			iommu_flush_iotlb_global(&g_iommus[i], 0);
> > +	}
> 
> When we hit a highwater mark, would be make sense to only
> flush the iommu associated with the device in question?
> 

This is what I do.  The bitmap is a mapping to which DMAR engines (IOMMU)
need do be flushed.

> I'm trying to limit the amount of time spent in any single
> call to flush_unmaps(). If iommu_flush_iotlb_global() is really
> fast (ie not 1000s of cycles), then this might be still ok.

Its fast, and global in this case is global to the passed in
DMAR-engine, not the system.

> But it would certainly make more sense to only flush the
> iommu associated with the IO device calling unmap.
> 
> > +	list_for_each_entry_safe(node, n, &unmaps_to_do, list) {
> > +		/* free iova */
> > +		list_del(&node->list);
> 
> Using a linear array would be alot more efficient than list_del().
> One could increment a local index (we are holding the spinlock) and
> not touch the data again. See code snippet from sba_iommu.c below.
> 

You have a point.  The only downside is that the high water mark would
no longer be a runtime tunable as it would be tied to the size of this
array.

> > +		__free_iova(&((struct dmar_domain *)node->dmar)->iovad, node);
> > +
> > +	}
> > +	list_size = 0;
> > +	spin_unlock_irqrestore(&async_umap_flush_lock, flags);
> > +}
> ...
> > +static void add_unmap(struct dmar_domain *dom, struct iova *iova)
> > +{
> > +	unsigned long flags;
> > +
> > +	spin_lock_irqsave(&async_umap_flush_lock, flags);
> > +	iova->dmar = dom;
> > +	list_add(&iova->list, &unmaps_to_do);
> > +	set_bit((dom->iommu - g_iommus), g_iommus_to_flush);
> > +
> > +	if (!timer_on) {
> > +		mod_timer(&unmap_timer, jiffies + msecs_to_jiffies(10));
> > +		timer_on = 1;
> > +	}
> > +	list_size++;
> > +	spin_unlock_irqrestore(&async_umap_flush_lock, flags);
> > +}
> 
> I'd like to compare the above with code from parisc sba_iommu.c
> which does the same thing:
> ...
>         d = &(ioc->saved[ioc->saved_cnt]);
>         d->iova = iova;
>         d->size = size;
>         if (++(ioc->saved_cnt) >= DELAYED_RESOURCE_CNT) {
> ...
> 
> (plus spinlock acquire/release)
> 
> map/unmap_single is called _alot_. It's probably called more often
> than the low level CPU interrupt handler on a busy NIC.
>

yes it is.
 
> Removing stats gathering from the SBA code yielded an easily
> measurable difference in perf. I don't recall exactly what it was.
> Apologies for not quantifying the diference when I made the change:
> http://lists.parisc-linux.org/pipermail/parisc-linux-cvs/2004-January/033739.html
> 
> 
> > @@ -23,6 +23,8 @@
> >  	struct rb_node	node;
> >  	unsigned long	pfn_hi; /* IOMMU dish out addr hi */
> >  	unsigned long	pfn_lo; /* IOMMU dish out addr lo */
> > +	struct list_head list;
> 
> Can we have a more descriptive name than "list"?
>

something like "deferred_flush_list" perhaps?
  
> > +	void *dmar;
> 
> Why isn't this declared "struct dmar_domain *"?
> 
> I'm looking at this usage in the patch:
> +               __free_iova(&((struct dmar_domain *)node->dmar)->iovad, node);
> 
> Given this is all for intel IOMMUs, I expect a struct could be visible.
> But I might be overlooking some higher design here.

The RB trees need to know which DMAR engine the iovad is part of.the
dmar_domain pointer provides this.  I think the disconnect is that the
intel vt-d systems have multiple IOMMU's to juggle where I think you are
assuming there is only one.

> 
> thanks and I hope the above helps,

It helps a lot! thanks.  I'm going to take a hard look at moving from a
list to an array for batching up the iova's to defer-flush.
> grant
