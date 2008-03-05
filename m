Return-Path: <linux-kernel-owner+w=401wt.eu-S1756494AbYCEXGy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756494AbYCEXGy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2008 18:06:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765287AbYCEXBN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Mar 2008 18:01:13 -0500
Received: from mga05.intel.com ([192.55.52.89]:26616 "EHLO
	fmsmga101.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1765568AbYCEXBI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2008 18:01:08 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.25,453,1199692800"; 
   d="scan'208";a="529388288"
Date: Wed, 5 Mar 2008 15:01:57 -0800
From: mark gross <mgross@linux.intel.com>
To: Grant Grundler <grundler@parisc-linux.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, greg@kroah.com,
       lkml <linux-kernel@vger.kernel.org>, linux-pci@atrey.karlin.mff.cuni.cz
Subject: [PATCH] Use an array instead of a list for deffered intel-iommu
	iotlb flushing  Re: [PATCH]iommu-iotlb-flushing
Message-ID: <20080305230157.GA24220@linux.intel.com>
Reply-To: mgross@linux.intel.com
References: <20080221000623.GA5510@linux.intel.com> <20080223000517.232704f3.akpm@linux-foundation.org> <20080229231841.GA6639@linux.intel.com> <20080301071043.GB9373@colo.lackof.org> <20080303183411.GA13582@linux.intel.com> <20080305182315.GA15765@colo.lackof.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080305182315.GA15765@colo.lackof.org>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 05, 2008 at 11:23:15AM -0700, Grant Grundler wrote:
> On Mon, Mar 03, 2008 at 10:34:11AM -0800, mark gross wrote:
> > The intel DMAR engines with the TLB's do have a measurable overhead
> > flushing TLB entries on every unmapsingle.  This hardware forces a bit
> > poll on TLB flush completion that adds up on high rates of unmap
> > operations.  (about 15% on my netperf small packet 32 byte UDP stream
> > over a 1GigE adapter)
> 
> So if we flushed the IOTLB every 16 unmap calls, it should be < 1% penalty?
> 
> Using that logic is how I decided the current calue of DELAYED_RESOURCE_CNT
> on parisc.
> 
> > FWIW: I think IOMMU use for avoiding bounce buffers is a thing of the
> > past.
> 
> Agreed. PA-RISC is a legacy platform at this point.
> 
> > (at least I have a "show me where it helps" point of view for
> > modern hardware.  what new hardware needs bounce buffers anymore?)
> 
> Otherwise, Anything running in a legacy IDE mode is using 32-bit DMA.
> So linux  still has plenty of SATA drivers using 32-bit DMA.
> 
> All the NICs, FC, Infiniband, et al are PCI-e and thus by definition
> 64-bit DMA capable.
> 
> > Also, to be fair to the Intel hardware the performance overhead is
> > really only noticeable on small packed and 10Gig benchmarking.  Most
> > users will not be able to notice the overhead.
> 
> *nod* - I know. That why I use pktgen to measure the dma map/unmap overhead.
> Note that with solid state storage (should be more visible in the next year
> or so), the transaction rate is going to look alot more like a NIC than
> the traditional HBA storage controller. So map/unmap performance will
> matter for those configurations too.

Sweet! now I have an excuse to get one of those spiffy SD-Disks!  

> 
> 
> > > One can do a few things to limit how much the protections
> > > are weakened:
> > > 1) Invalidate the IO TLB entry and IO Pdir entries (just don't force
> > >   syncronization). At least this was possible on the IOMMU's
> > >   I'm familiar with.
> > 
> > The default is the TLB invalidation. It has a nasty polling loop that
> > hurts on the small packet netperf benchmark.
> > 
> > > 
> > > 2) release the IO Pdir entry for re-use once syncronization has been forced.
> > >    Syncronization/flushing of the IO TLB shoot-down is the most expensive
> > >    ops AFAICT on the IOMMU's I've worked with.
> > 
> > this is what the patch does.
> 
> Ok - I wasn't sure which step was the "syncronize step".
> 
> BTW, I hope you (and others from Intel - go willy! ;) can give feedback
> to the Intel/AMD chipset designers to ditch this design ASAP.
> It clearly sucks.
> 

The HW implementation IS evolving.  Especially as the MCH and more of
the chipsets are moved into the CPU package.  It will get better over
time, but the protection will never be "free".

> > > I just looked at the implementation of flush_unmaps().
> > > I strongly reccomend comparing this implementation with the
> > > DELAYED_RESOURCE_CNT since this looks like it will need 2X or more
> > > of the CPU cycles to execute for each entry. Use of "list_del()"
> > > is substantially more expensive than a simple linear arrary.
> > > (Fewer entries per cacheline by 4X maybe?)
> > >
> > 
> > /me looks, an array of pointers to iova's to clean up makes good sense.
> > I don't know why I didn't think of this approach first.  Working with
> > lists is messy and if I can avoid it I usually try.
> 
> *shrug* I didn't think too much about it on the original implementation
> and it happened to work out nicely. Think cacheline "life cycle" when
> picking array sizes (or when comparing to linked lists) and you'll
> usually end up with the best performing design.
> 
> >  
> > > Another problem is every now and then some IO is going to burn a bunch
> > > of CPU cycles and introduce inconsistent performance for particular
> > > unmap operations. One has to tradeoff amortizing the cost of the
> > > IOMMU flushing with the number of "unusable" IO Pdir entries and more
> > > consistent CPU utilization for each unmap() call.  My gut feeling
> > > is 250 is rather high for high_watermark unless flushing the IO TLB
> > > is extremely expensive.
> > > 
> > 
> > the 250 high water mark came from 1gig small packet netperf udp
> > streaming testing.  The 1000 I initially used didn't perform quite as
> > well.  Nothing scientific went into this number just some tests cases.
> 
> Well, it can be more scientific. Determine the overhead (with vs without).
> Then divide by how many times one can afford to ignore the sync op.
> That will be (roughly) be the new overhead.
> 
> > > ...
> > > > > boot-time options suck.  Is it not possible to tweak this at runtime?
> > > > 
> > > > Yes, I could easily create a sysfs or debugfs mechanism for turning it
> > > > on / off at run time.  I would like input on the preferred way to do this.
> > > > sysfs or debugfs?
> > > 
> > > I prefer a compile time constant since we are talking about fixed costs
> > > for this implementation.  The compiler can do a better job with a constant.
> > > I know this sounds nit picky but if I can't sufficiently emphasized how
> > > perf critical DMA map/unmap code is.
> > 
> > Compile time options lock out OSV's from using the feature.
> 
> Huh? I think you misunderstood. Decide how _many_ you want to defer
> at compile time and leave the general feature enabled as a runtime option.
> (e.g. use_vtd=1 boot param or when booting with Xen or KVM enabled).
> 
> > These IOMMU's are in desktop systems now.  My job is to make it not
> > suck so OSV's will leave DMAR enabled in production kernels.
> > (well at least try to anyway.)
> 
> Ok - my suggestion still applies. "compile time constant" only refers
> to the number of unmaps the code will defer. e.g. "borrow" DELAY_RESOURCE_CNT.
> I understand the DMAR needs to be enabled at runtime for production.
> (I've spent ~5 years dealing with RH/SuSE/Debian IA64-linux kernels...)
> 
> If you can reduce the overhead to < 1% for pktgen, TPC-C won't
> notice it and I doubt specweb will either.

Sadly the overhead only a fraction of the overhead is due to the IOTLB
flushes.  I can't wave away the IOVA management overhead with batched
flushes of the IOTLB.

> 
> > > 
> > > If it has to be a variable, I prefer sysfs but don't have a good reason
> > > for that.
> > > 
> > > > Signed-off-by: <mgross@linux.intel.com>
> > > 
> > > Ah! Maybe you can get together with Matthew Wilcox (also) and consider
> > > how the IOMMU code might be included in the scsi_ram driver he wrote.
> > > Or maybe just directly use the ram disk (rd.c) instead.
> > 
> > Yup, Willi has just started to look over my shoulder on some of this.
> > He pointed me at some OLS papers and whatnot to look at.  I botched my
> > chance to work face to face with him last week on his last visit to
> > Oregon but we'll keep talking.
> 
> Excellent. I'm also happy to answer questions on linux-pci about this.
> And willy will be back in oregon I'm sure. :)
> You can also visit him in Ottawa if you register for OLS this year.
> 

I'm not going to OLS this year :(  travel budget is severely restricted
because of over spending last year.

> > > At LSF, I suggested using the IOAT DMA engine (if available) do real DMA.
> > > Running the IO requests through the IOMMU would expose the added CPU cost
> > > of the IOMMU in it's worst case. This doesn't need to go to kernel.org
> > > but might help you isolate perf bottlenecks in this iommu code.
> > 
> > Oh the worst cases are easy.  Just run a 10gig NIC and see what you get.
> 
> Well, you still need a consistent benchmark/workload (e.g. pktgen) and
> a precise tool to measure the overhead (e.g. oprofile or perfmon2).
> 

I've been using oprofile, and some TSC counters I have in an out-of tree
patch for instrumenting the code and dumping the cycles per
code-path-of-interest.  Its been pretty effective, but it affects the
throughput of the run.

> Using the IOAT would allow people without 10G NICs to mess around with this.
> 

I'll have to check this out.

> > With a 1Gig NIC you need to drop the packet size down to 32 bytes or
> > something tiny like that to really notice it.  16K packets
> > have only a smallish overhead that are iffy as benchmarks because the
> > CPU utilization is too low (<25%) to be a good measure.
> 
> *nod*
> 
> > FWIW : throughput isn't effected so much as the CPU overhead.
> > iommu=strict: 16K UDP UNIDIRECTIONAL SEND TEST 826Mbps at 25% cpu 
> > with this patch: 16K UDP UNIDIRECTIONAL SEND TEST 826Mbps at 18% cpu 
> > IOMMU=OFF: 16K UDP UNIDIRECTIONAL SEND TEST 826Mbps at 11% cpu 
> 
> Understood. That's why netperf (see netperf.org) measures "service demand".
> Taking CPU away from user space generally results in lower benchmark/app perf.
>

The following patch is an update to use an array instead of a list of
IOVA's in the implementation of defered iotlb flushes.  It takes
inspiration from sba_iommu.c

I like this implementation better as it encapsulates the batch process
within intel-iommu.c, and no longer touches iova.h (which is shared)

Performance data:  Netperf 32byte UDP streaming
2.6.25-rc3-mm1:
IOMMU-strict : 58Mps @ 62% cpu
NO-IOMMU : 71Mbs @ 41% cpu
List-based IOMMU-default-batched-IOTLB flush: 66Mbps @ 57% cpu

with this patch:
IOMMU-strict : 73Mps @ 75% cpu
NO-IOMMU : 74Mbs @ 42% cpu
Array-based IOMMU-default-batched-IOTLB flush: 72Mbps @ 62% cpu

--mgross


Signed-off-by: <mgross@linux.intel.com>


Index: linux-2.6.25-rc3-mm1/drivers/pci/intel-iommu.c
===================================================================
--- linux-2.6.25-rc3-mm1.orig/drivers/pci/intel-iommu.c	2008-03-05 11:34:41.000000000 -0800
+++ linux-2.6.25-rc3-mm1/drivers/pci/intel-iommu.c	2008-03-05 12:50:21.000000000 -0800
@@ -59,8 +59,17 @@
 DEFINE_TIMER(unmap_timer,  flush_unmaps_timeout, 0, 0);
 
 static struct intel_iommu *g_iommus;
+
+#define HIGH_WATER_MARK 250
+struct deferred_flush_tables {
+	int next;
+	struct iova *iova[HIGH_WATER_MARK];
+	struct dmar_domain *domain[HIGH_WATER_MARK];
+};
+
+static struct deferred_flush_tables *deferred_flush;
+
 /* bitmap for indexing intel_iommus */
-static unsigned long 	*g_iommus_to_flush;
 static int g_num_of_iommus;
 
 static DEFINE_SPINLOCK(async_umap_flush_lock);
@@ -68,10 +77,6 @@
 
 static int timer_on;
 static long list_size;
-static int high_watermark;
-
-static struct dentry *intel_iommu_debug, *debug;
-
 
 static void domain_remove_dev_info(struct dmar_domain *domain);
 
@@ -1692,7 +1697,7 @@
 	struct dmar_rmrr_unit *rmrr;
 	struct pci_dev *pdev;
 	struct intel_iommu *iommu;
-	int nlongs, i, ret, unit = 0;
+	int i, ret, unit = 0;
 
 	/*
 	 * for each drhd
@@ -1711,17 +1716,16 @@
 		 */
 	}
 
-	nlongs = BITS_TO_LONGS(g_num_of_iommus);
-	g_iommus_to_flush = kzalloc(nlongs * sizeof(unsigned long), GFP_KERNEL);
-	if (!g_iommus_to_flush) {
-		printk(KERN_ERR "Intel-IOMMU: "
-			"Allocating bitmap array failed\n");
-		return -ENOMEM;
-	}
-
 	g_iommus = kzalloc(g_num_of_iommus * sizeof(*iommu), GFP_KERNEL);
 	if (!g_iommus) {
-		kfree(g_iommus_to_flush);
+		ret = -ENOMEM;
+		goto error;
+	}
+
+	deferred_flush = kzalloc(g_num_of_iommus *
+		sizeof(struct deferred_flush_tables), GFP_KERNEL);
+	if (!deferred_flush) {
+		kfree(g_iommus);
 		ret = -ENOMEM;
 		goto error;
 	}
@@ -1970,42 +1974,48 @@
 
 static void flush_unmaps(void)
 {
-	struct iova *node, *n;
-	unsigned long flags;
-	int i;
+	int i, j;
 
-	spin_lock_irqsave(&async_umap_flush_lock, flags);
 	timer_on = 0;
 
 	/* just flush them all */
 	for (i = 0; i < g_num_of_iommus; i++) {
-		if (test_and_clear_bit(i, g_iommus_to_flush))
+		if (deferred_flush[i].next) {
 			iommu_flush_iotlb_global(&g_iommus[i], 0);
+			for (j = 0; j < deferred_flush[i].next; j++) {
+				__free_iova(&deferred_flush[i].domain[j]->iovad,
+						deferred_flush[i].iova[j]);
+			}
+			deferred_flush[i].next = 0;
+		}
 	}
 
-	list_for_each_entry_safe(node, n, &unmaps_to_do, list) {
-		/* free iova */
-		list_del(&node->list);
-		__free_iova(&((struct dmar_domain *)node->dmar)->iovad, node);
-
-	}
 	list_size = 0;
-	spin_unlock_irqrestore(&async_umap_flush_lock, flags);
 }
 
 static void flush_unmaps_timeout(unsigned long data)
 {
+	unsigned long flags;
+
+	spin_lock_irqsave(&async_umap_flush_lock, flags);
 	flush_unmaps();
+	spin_unlock_irqrestore(&async_umap_flush_lock, flags);
 }
 
 static void add_unmap(struct dmar_domain *dom, struct iova *iova)
 {
 	unsigned long flags;
+	int next, iommu_id;
 
 	spin_lock_irqsave(&async_umap_flush_lock, flags);
-	iova->dmar = dom;
-	list_add(&iova->list, &unmaps_to_do);
-	set_bit((dom->iommu - g_iommus), g_iommus_to_flush);
+	if (list_size == HIGH_WATER_MARK)
+		flush_unmaps();
+
+	iommu_id = dom->iommu - g_iommus;
+	next = deferred_flush[iommu_id].next;
+	deferred_flush[iommu_id].domain[next] = dom;
+	deferred_flush[iommu_id].iova[next] = iova;
+	deferred_flush[iommu_id].next++;
 
 	if (!timer_on) {
 		mod_timer(&unmap_timer, jiffies + msecs_to_jiffies(10));
@@ -2054,8 +2064,6 @@
 		 * queue up the release of the unmap to save the 1/6th of the
 		 * cpu used up by the iotlb flush operation...
 		 */
-		if (list_size > high_watermark)
-			flush_unmaps();
 	}
 }
 
@@ -2380,10 +2388,6 @@
 	if (dmar_table_init())
 		return 	-ENODEV;
 
-	high_watermark = 250;
-	intel_iommu_debug = debugfs_create_dir("intel_iommu", NULL);
-	debug = debugfs_create_u32("high_watermark", S_IWUGO | S_IRUGO,
-					intel_iommu_debug, &high_watermark);
 	iommu_init_mempool();
 	dmar_init_reserved_ranges();
 
Index: linux-2.6.25-rc3-mm1/drivers/pci/iova.h
===================================================================
--- linux-2.6.25-rc3-mm1.orig/drivers/pci/iova.h	2008-03-05 12:49:12.000000000 -0800
+++ linux-2.6.25-rc3-mm1/drivers/pci/iova.h	2008-03-05 12:49:25.000000000 -0800
@@ -24,8 +24,6 @@
 	struct rb_node	node;
 	unsigned long	pfn_hi; /* IOMMU dish out addr hi */
 	unsigned long	pfn_lo; /* IOMMU dish out addr lo */
-	struct list_head list;
-	void *dmar;
 };
 
 /* holds all the iova translations for a domain */
