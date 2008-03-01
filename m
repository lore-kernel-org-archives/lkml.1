Return-Path: <linux-kernel-owner+w=401wt.eu-S1756759AbYCAHMT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756759AbYCAHMT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Mar 2008 02:12:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751143AbYCAHMI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Mar 2008 02:12:08 -0500
Received: from colo.lackof.org ([198.49.126.79]:43504 "EHLO colo.lackof.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751874AbYCAHMG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Mar 2008 02:12:06 -0500
Date: Sat, 1 Mar 2008 00:10:43 -0700
From: Grant Grundler <grundler@parisc-linux.org>
To: mark gross <mgross@linux.intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, greg@kroah.com,
       lkml <linux-kernel@vger.kernel.org>, linux-pci@atrey.karlin.mff.cuni.cz
Subject: Re: [PATCH]iommu-iotlb-flushing
Message-ID: <20080301071043.GB9373@colo.lackof.org>
References: <20080221000623.GA5510@linux.intel.com> <20080223000517.232704f3.akpm@linux-foundation.org> <20080229231841.GA6639@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080229231841.GA6639@linux.intel.com>
X-Home-Page: http://www.parisc-linux.org/
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 29, 2008 at 03:18:41PM -0800, mark gross wrote:
> On Sat, Feb 23, 2008 at 12:05:17AM -0800, Andrew Morton wrote:
> > On Wed, 20 Feb 2008 16:06:23 -0800 mark gross <mgross@linux.intel.com> wrote:
> > 
> > > The following patch is for batching up the flushing of the IOTLB for
> > > the DMAR implementation found in the Intel VT-d hardware.  It works by
> > > building a list of to be flushed IOTLB entries and a bitmap list of
> > > which DMAR engine they are from.

I didn't see the original patch - thanks for cc'ing linux-pci.

PA-RISC and IA64 have been doing this for several years now.
See DELAYED_RESOURCE_CNT usage in drivers/parisc/sba_iommu.c
and in arch/ia64/hp/common/sba_iommu.c.

I prototyped the same concept for x86_64 GART support but it didn't
seem to matter on benchmarks since most of the devices I use are
64-bit and don't need to use the IOMMU. IDE/SATA controllers 
are 32-bit but there is LOTS of overhead in so many other places,
this change made less than 0.3 difference for them.
(And the decision to use uncached memory for the IO Pdir made this moot).
I'd be happy to post the patch if someone wants to see it though.

> > > This approach recovers 15 to 20% of the performance lost when using the
> > > IOMMU for my netperf udp stream benchmark with small packets.  It can be
> > > disabled with a kernel boot parameter
> > > "intel_iommu=strict".
> > > 
> > > Its use does weaken the IOMMU protections a bit.

One can do a few things to limit how much the protections
are weakened:
1) Invalidate the IO TLB entry and IO Pdir entries (just don't force
  syncronization). At least this was possible on the IOMMU's
  I'm familiar with.

2) release the IO Pdir entry for re-use once syncronization has been forced.
   Syncronization/flushing of the IO TLB shoot-down is the most expensive
   ops AFAICT on the IOMMU's I've worked with.

I don't ever recall finding a bug where the device was DMA'ing to a
buffer again shortly after unmap call. Most DMA errors are device driver
not programming the DMA engines correctly.

> > > +	if (intel_iommu_strict) {

I suggest adding an "unlikely()" around this test so the compiler
can generate better code for this and it's clear what your intent is.


I just looked at the implementation of flush_unmaps().
I strongly reccomend comparing this implementation with the
DELAYED_RESOURCE_CNT since this looks like it will need 2X or more
of the CPU cycles to execute for each entry. Use of "list_del()"
is substantially more expensive than a simple linear arrary.
(Fewer entries per cacheline by 4X maybe?)

Another problem is every now and then some IO is going to burn a bunch
of CPU cycles and introduce inconsistent performance for particular
unmap operations. One has to tradeoff amortizing the cost of the
IOMMU flushing with the number of "unusable" IO Pdir entries and more
consistent CPU utilization for each unmap() call.  My gut feeling
is 250 is rather high for high_watermark unless flushing the IO TLB
is extremely expensive.


...
> > boot-time options suck.  Is it not possible to tweak this at runtime?
> 
> Yes, I could easily create a sysfs or debugfs mechanism for turning it
> on / off at run time.  I would like input on the preferred way to do this.
> sysfs or debugfs?

I prefer a compile time constant since we are talking about fixed costs
for this implementation.  The compiler can do a better job with a constant.
I know this sounds nit picky but if I can't sufficiently emphasized how
perf critical DMA map/unmap code is.

If it has to be a variable, I prefer sysfs but don't have a good reason
for that.

> Signed-off-by: <mgross@linux.intel.com>

Ah! Maybe you can get together with Matthew Wilcox (also) and consider
how the IOMMU code might be included in the scsi_ram driver he wrote.
Or maybe just directly use the ram disk (rd.c) instead.

At LSF, I suggested using the IOAT DMA engine (if available) do real DMA.
Running the IO requests through the IOMMU would expose the added CPU cost
of the IOMMU in it's worst case. This doesn't need to go to kernel.org
but might help you isolate perf bottlenecks in this iommu code.


> Index: linux-2.6.25-rc2-mm1/drivers/pci/intel-iommu.c
> ===================================================================
> --- linux-2.6.25-rc2-mm1.orig/drivers/pci/intel-iommu.c	2008-02-26 11:15:46.000000000 -0800
> +++ linux-2.6.25-rc2-mm1/drivers/pci/intel-iommu.c	2008-02-29 14:36:55.000000000 -0800
...
> +static void flush_unmaps_timeout(unsigned long data);
> +
> +DEFINE_TIMER(unmap_timer,  flush_unmaps_timeout, 0, 0);

Why bother with the timer?

This just adds more overhead and won't help much to improve
protection.  If someone needs tighter protection, the "strict"
unmapping/flushing parameter should be sufficient to track
down the issues they might be seeing.  And it's perfectly OK
to be sitting on a few "unusable" IOMMU entries.

...
> +static void flush_unmaps(void)
> +{
> +	struct iova *node, *n;
> +	unsigned long flags;
> +	int i;
> +
> +	spin_lock_irqsave(&async_umap_flush_lock, flags);
> +	timer_on = 0;
> +
> +	/* just flush them all */
> +	for (i = 0; i < g_num_of_iommus; i++) {
> +		if (test_and_clear_bit(i, g_iommus_to_flush))
> +			iommu_flush_iotlb_global(&g_iommus[i], 0);
> +	}

When we hit a highwater mark, would be make sense to only
flush the iommu associated with the device in question?

I'm trying to limit the amount of time spent in any single
call to flush_unmaps(). If iommu_flush_iotlb_global() is really
fast (ie not 1000s of cycles), then this might be still ok.
But it would certainly make more sense to only flush the
iommu associated with the IO device calling unmap.

> +	list_for_each_entry_safe(node, n, &unmaps_to_do, list) {
> +		/* free iova */
> +		list_del(&node->list);

Using a linear array would be alot more efficient than list_del().
One could increment a local index (we are holding the spinlock) and
not touch the data again. See code snippet from sba_iommu.c below.

> +		__free_iova(&((struct dmar_domain *)node->dmar)->iovad, node);
> +
> +	}
> +	list_size = 0;
> +	spin_unlock_irqrestore(&async_umap_flush_lock, flags);
> +}
...
> +static void add_unmap(struct dmar_domain *dom, struct iova *iova)
> +{
> +	unsigned long flags;
> +
> +	spin_lock_irqsave(&async_umap_flush_lock, flags);
> +	iova->dmar = dom;
> +	list_add(&iova->list, &unmaps_to_do);
> +	set_bit((dom->iommu - g_iommus), g_iommus_to_flush);
> +
> +	if (!timer_on) {
> +		mod_timer(&unmap_timer, jiffies + msecs_to_jiffies(10));
> +		timer_on = 1;
> +	}
> +	list_size++;
> +	spin_unlock_irqrestore(&async_umap_flush_lock, flags);
> +}

I'd like to compare the above with code from parisc sba_iommu.c
which does the same thing:
...
        d = &(ioc->saved[ioc->saved_cnt]);
        d->iova = iova;
        d->size = size;
        if (++(ioc->saved_cnt) >= DELAYED_RESOURCE_CNT) {
...

(plus spinlock acquire/release)

map/unmap_single is called _alot_. It's probably called more often
than the low level CPU interrupt handler on a busy NIC.

Removing stats gathering from the SBA code yielded an easily
measurable difference in perf. I don't recall exactly what it was.
Apologies for not quantifying the diference when I made the change:
http://lists.parisc-linux.org/pipermail/parisc-linux-cvs/2004-January/033739.html


> @@ -23,6 +23,8 @@
>  	struct rb_node	node;
>  	unsigned long	pfn_hi; /* IOMMU dish out addr hi */
>  	unsigned long	pfn_lo; /* IOMMU dish out addr lo */
> +	struct list_head list;

Can we have a more descriptive name than "list"?

> +	void *dmar;

Why isn't this declared "struct dmar_domain *"?

I'm looking at this usage in the patch:
+               __free_iova(&((struct dmar_domain *)node->dmar)->iovad, node);

Given this is all for intel IOMMUs, I expect a struct could be visible.
But I might be overlooking some higher design here.

thanks and I hope the above helps,
grant
