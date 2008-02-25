Return-Path: <linux-kernel-owner+w=401wt.eu-S1756524AbYBYQk1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756524AbYBYQk1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2008 11:40:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754136AbYBYQkP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Feb 2008 11:40:15 -0500
Received: from mga07.intel.com ([143.182.124.22]:27259 "EHLO
	azsmga101.ch.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754102AbYBYQkN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2008 11:40:13 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.25,402,1199692800"; 
   d="scan'208";a="383259428"
Date: Mon, 25 Feb 2008 08:28:51 -0800
From: mark gross <mgross@linux.intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH]iommu-iotlb-flushing
Message-ID: <20080225162851.GC22018@linux.intel.com>
Reply-To: mgross@linux.intel.com
References: <20080221000623.GA5510@linux.intel.com> <20080223000517.232704f3.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080223000517.232704f3.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 23, 2008 at 12:05:17AM -0800, Andrew Morton wrote:
> On Wed, 20 Feb 2008 16:06:23 -0800 mark gross <mgross@linux.intel.com> wrote:
> 
> > The following patch is for batching up the flushing of the IOTLB for
> > the DMAR implementation found in the Intel VT-d hardware.  It works by
> > building a list of to be flushed IOTLB entries and a bitmap list of
> > which DMAR engine they are from.
> > 
> > After either a high water mark (250 accessible via debugfs) or 10ms the
> > list of iova's will be reclaimed and the DMAR engines associated are
> > IOTLB-flushed.
> > 
> > This approach recovers 15 to 20% of the performance lost when using the
> > IOMMU for my netperf udp stream benchmark with small packets.  It can be
> > disabled with a kernel boot parameter
> > "intel_iommu=strict".
> > 
> > Its use does weaken the IOMMU protections a bit.
> > 
> > I would like to see this go into MM for a while and then onto mainline.
> > 
> > ...
> >
> > +static struct timer_list unmap_timer =
> > +	TIMER_INITIALIZER(flush_unmaps_timeout, 0, 0);
> 
> Could use DEFINE_TIMER here.

ok
> 
> > +struct unmap_list {
> > +	struct list_head list;
> > +	struct dmar_domain *domain;
> > +	struct iova *iova;
> > +};
> 
> unmap_list doens't seem to be used anywhere?

oops, left over from earlier version.

> 
> > +static struct intel_iommu *g_iommus;
> > +/* bitmap for indexing intel_iommus */
> > +static unsigned long 	*g_iommus_to_flush;
> > +static int g_num_of_iommus;
> > +
> > +static DEFINE_SPINLOCK(async_umap_flush_lock);
> > +static LIST_HEAD(unmaps_to_do);
> > +
> > +static int timer_on;
> > +static long list_size;
> > +static int high_watermark;
> > +
> > +static struct dentry *intel_iommu_debug, *debug;
> > +
> > +
> >  static void domain_remove_dev_info(struct dmar_domain *domain);
> >  
> >  static int dmar_disabled;
> >  static int __initdata dmar_map_gfx = 1;
> >  static int dmar_forcedac;
> > +static int intel_iommu_strict;
> >  
> >  #define DUMMY_DEVICE_DOMAIN_INFO ((struct device_domain_info *)(-1))
> >  static DEFINE_SPINLOCK(device_domain_lock);
> > @@ -73,9 +103,13 @@
> >  			printk(KERN_INFO
> >  				"Intel-IOMMU: disable GFX device mapping\n");
> >  		} else if (!strncmp(str, "forcedac", 8)) {
> > -			printk (KERN_INFO
> > +			printk(KERN_INFO
> >  				"Intel-IOMMU: Forcing DAC for PCI devices\n");
> >  			dmar_forcedac = 1;
> > +		} else if (!strncmp(str, "strict", 8)) {
> 
> s/8/6/

ack.

> 
> > +			printk(KERN_INFO
> > +				"Intel-IOMMU: disable batched IOTLB flush\n");
> > +			intel_iommu_strict = 1;
> >  		}
> >  
> >  		str += strcspn(str, ",");
> > @@ -965,17 +999,13 @@
> >  		set_bit(0, iommu->domain_ids);
> >  	return 0;
> >  }
> > -
> > -static struct intel_iommu *alloc_iommu(struct dmar_drhd_unit *drhd)
> > +static struct intel_iommu *alloc_iommu(struct intel_iommu *iommu,
> > +					struct dmar_drhd_unit *drhd)
> >  {
> > -	struct intel_iommu *iommu;
> >  	int ret;
> >  	int map_size;
> >  	u32 ver;
> >  
> > -	iommu = kzalloc(sizeof(*iommu), GFP_KERNEL);
> > -	if (!iommu)
> > -		return NULL;
> >  	iommu->reg = ioremap(drhd->reg_base_addr, PAGE_SIZE_4K);
> >  	if (!iommu->reg) {
> >  		printk(KERN_ERR "IOMMU: can't map the region\n");
> > @@ -1396,7 +1426,7 @@
> >  	int index;
> >  
> >  	while (dev) {
> > -		for (index = 0; index < cnt; index ++)
> > +		for (index = 0; index < cnt; index++)
> >  			if (dev == devices[index])
> >  				return 1;
> >  
> > @@ -1661,7 +1691,7 @@
> >  	struct dmar_rmrr_unit *rmrr;
> >  	struct pci_dev *pdev;
> >  	struct intel_iommu *iommu;
> > -	int ret, unit = 0;
> > +	int nlongs, i, ret, unit = 0;
> >  
> >  	/*
> >  	 * for each drhd
> > @@ -1672,7 +1702,30 @@
> >  	for_each_drhd_unit(drhd) {
> >  		if (drhd->ignored)
> >  			continue;
> > -		iommu = alloc_iommu(drhd);
> > +		g_num_of_iommus++;
> 
> No locking needed for g_num_of_iommus?
> 

I'll double check if its needed, but it wouldn't hurt.  This code is on
the kernel startup / init path. 

> > +	}
> > +
> > +	nlongs = BITS_TO_LONGS(g_num_of_iommus);
> 
> Would this code be neater if it used the <linux/bitmap.h> stuff?

I'll look into it.

> 
> > +	g_iommus_to_flush = kzalloc(nlongs * sizeof(unsigned long), GFP_KERNEL);
> > +	if (!g_iommus_to_flush) {
> > +		printk(KERN_ERR "Intel-IOMMU: "
> > +			"Allocating bitmap array failed\n");
> > +		return -ENOMEM;
> 
> Are you sure we aren't leaking anything here?  Like the alloc_iommu() above?

Once you set up the IOMMU's you never take them down or re-set them up.
This code runs one and one time at boot up.  

> 
> > +	}
> > +
> > +	g_iommus = kzalloc(g_num_of_iommus * sizeof(*iommu), GFP_KERNEL);
> > +	if (!g_iommus) {
> > +		kfree(g_iommus_to_flush);
> > +		ret = -ENOMEM;
> > +		goto error;
> > +	}
> > +
> > +	i = 0;
> > +	for_each_drhd_unit(drhd) {
> > +		if (drhd->ignored)
> > +			continue;
> > +		iommu = alloc_iommu(&g_iommus[i], drhd);
> > +		i++;
> >  		if (!iommu) {
> >  			ret = -ENOMEM;
> >  			goto error;
> > @@ -1705,7 +1758,6 @@
> >  	 * endfor
> >  	 */
> >  	for_each_rmrr_units(rmrr) {
> > -		int i;
> >  		for (i = 0; i < rmrr->devices_cnt; i++) {
> >  			pdev = rmrr->devices[i];
> >  			/* some BIOS lists non-exist devices in DMAR table */
> > @@ -1909,6 +1961,54 @@
> >  	return 0;
> >  }
> >  
> > +static void flush_unmaps(void)
> > +{
> > +	struct iova *node, *n;
> > +	unsigned long flags;
> > +	int i;
> > +
> > +	spin_lock_irqsave(&async_umap_flush_lock, flags);
> > +	timer_on = 0;
> > +
> > +	/*just flush them all*/
> 
> I'm surprised that checkpatch didn't grump about the odd commenting style.

It didn't.  What's odd about the comment style here?

> 
> > +	for (i = 0; i < g_num_of_iommus; i++) {
> > +		if (test_and_clear_bit(i, g_iommus_to_flush))
> > +			iommu_flush_iotlb_global(&g_iommus[i], 0);
> > +	}
> > +
> > +	list_for_each_entry_safe(node, n, &unmaps_to_do, list) {
> > +		/* free iova */
> > +		list_del(&node->list);
> > +		__free_iova(&((struct dmar_domain *)node->dmar)->iovad, node);
> > +
> > +	}
> > +	list_size = 0;
> > +	spin_unlock_irqrestore(&async_umap_flush_lock, flags);
> > +}
> > +
> > +static void flush_unmaps_timeout(unsigned long data)
> > +{
> > +	flush_unmaps();
> > +}
> > +
> > +static void add_unmap(struct dmar_domain *dom, struct iova *iova)
> > +{
> > +	unsigned long flags;
> > +
> > +	spin_lock_irqsave(&async_umap_flush_lock, flags);
> 
> How scalable is this?

Not very.  But, its better than blocking on the hardware poll IOTLB
flush operation on every unmap.  Is there a lock less way to insert
into this list?  I suppose I could have one lock per DMAR-engine but,
that would still have the scalability issue.  (perhaps a list per IOVA?
/me needs to think on this a bit)

The best way is to get the network stack to reuse dma buffers when using
an iommu and avoid the unmap operation altogether.  But thats a longer
term goal.

> 
> > +	iova->dmar = dom;
> > +	list_add(&iova->list, &unmaps_to_do);
> > +	set_bit((dom->iommu - g_iommus), g_iommus_to_flush);
> > +
> > +	if (!timer_on) {
> > +		unmap_timer.expires = jiffies + msecs_to_jiffies(10);
> > +		mod_timer(&unmap_timer, unmap_timer.expires);
> 
> No, this modifies unmap_timer.expires twice.  Might be racy too.  You want
> 
> 	mod_timer(&unmap_timer, jiffies + msecs_to_jiffies(10));

ack

> 
> > +		timer_on = 1;
> > +	}
> > +	list_size++;
> > +	spin_unlock_irqrestore(&async_umap_flush_lock, flags);
> > +}
> > +
> >  static void intel_unmap_single(struct device *dev, dma_addr_t dev_addr,
> >  	size_t size, int dir)
> >  {
> > @@ -1936,13 +2036,21 @@
> >  	dma_pte_clear_range(domain, start_addr, start_addr + size);
> >  	/* free page tables */
> >  	dma_pte_free_pagetable(domain, start_addr, start_addr + size);
> > -
> > -	if (iommu_flush_iotlb_psi(domain->iommu, domain->id, start_addr,
> > -			size >> PAGE_SHIFT_4K, 0))
> > -		iommu_flush_write_buffer(domain->iommu);
> > -
> > -	/* free iova */
> > -	__free_iova(&domain->iovad, iova);
> > +	if (intel_iommu_strict) {
> > +		if (iommu_flush_iotlb_psi(domain->iommu,
> > +			domain->id, start_addr, size >> PAGE_SHIFT_4K, 0))
> > +			iommu_flush_write_buffer(domain->iommu);
> > +		/* free iova */
> > +		__free_iova(&domain->iovad, iova);
> > +	} else {
> > +		add_unmap(domain, iova);
> > +		/*
> > +		 * queue up the release of the unmap to save the 1/6th of the
> > +		 * cpu used up by the iotlb flush operation...
> > +		 */
> > +		if (list_size > high_watermark)
> > +			flush_unmaps();
> > +	}
> >  }
> >  
> >  static void * intel_alloc_coherent(struct device *hwdev, size_t size,
> > @@ -2266,6 +2374,10 @@
> >  	if (dmar_table_init())
> >  		return 	-ENODEV;
> >  
> > +	high_watermark = 250;
> > +	intel_iommu_debug = debugfs_create_dir("intel_iommu", NULL);
> > +	debug = debugfs_create_u32("high_watermark", S_IWUGO | S_IRUGO,
> > +					intel_iommu_debug, &high_watermark);
> >  	iommu_init_mempool();
> >  	dmar_init_reserved_ranges();
> >  
> > @@ -2281,6 +2393,7 @@
> >  	printk(KERN_INFO
> >  	"PCI-DMA: Intel(R) Virtualization Technology for Directed I/O\n");
> >  
> > +	init_timer(&unmap_timer);
> 
> I see timers being added, but I see no del_timer_sync()s added on cleanup
> paths.  Are you sure that we don't have races on various teardown paths?
> 

This code doesn't really tear down well.  However; at this point in
intel_iommu_init there is no further error paths to put tear down code.


> >  	force_iommu = 1;
> >  	dma_ops = &intel_dma_ops;
> >  	return 0;
> > Index: linux-2.6.24-mm1/drivers/pci/iova.h
> > ===================================================================
> > --- linux-2.6.24-mm1.orig/drivers/pci/iova.h	2008-02-12 07:12:06.000000000 -0800
> > +++ linux-2.6.24-mm1/drivers/pci/iova.h	2008-02-12 07:39:53.000000000 -0800
> > @@ -23,6 +23,8 @@
> >  	struct rb_node	node;
> >  	unsigned long	pfn_hi; /* IOMMU dish out addr hi */
> >  	unsigned long	pfn_lo; /* IOMMU dish out addr lo */
> > +	struct list_head list;
> > +	void *dmar;
> >  };
> >  
> >  /* holds all the iova translations for a domain */
> > Index: linux-2.6.24-mm1/Documentation/kernel-parameters.txt
> > ===================================================================
> > --- linux-2.6.24-mm1.orig/Documentation/kernel-parameters.txt	2008-02-12 07:12:06.000000000 -0800
> > +++ linux-2.6.24-mm1/Documentation/kernel-parameters.txt	2008-02-13 11:17:22.000000000 -0800
> > @@ -822,6 +822,10 @@
> >  			than 32 bit addressing. The default is to look
> >  			for translation below 32 bit and if not available
> >  			then look in the higher range.
> > +		strict [Default Off]
> > +			With this option on every unmap_single operation will
> > +			result in a hardware IOTLB flush operation as opposed
> > +			to batching them for performance.
> 
> boot-time options suck.  Is it not possible to tweak this at runtime?

Yes they do.  There may be a way to enable / disable this behavior at
runtime.  Let me think on it a bit.

Thank you for looking at this!

--mgross

