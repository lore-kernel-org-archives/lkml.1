Return-Path: <linux-kernel-owner+w=401wt.eu-S1755704AbZEURXt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755704AbZEURXt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 May 2009 13:23:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753924AbZEURXm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 May 2009 13:23:42 -0400
Received: from sh.osrg.net ([192.16.179.4]:58149 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753545AbZEURXl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 May 2009 13:23:41 -0400
Date: Fri, 22 May 2009 02:21:51 +0900
To: ijc@hellion.org.uk
Cc: fujita.tomonori@lab.ntt.co.jp, jeremy@goop.org,
       xen-devel@lists.xensource.com, beckyb@kernel.crashing.org, okir@suse.de,
       x86@kernel.org, linux-kernel@vger.kernel.org, mingo@elte.hu,
       gregkh@suse.de
Subject: Re: [Xen-devel] Re: Where do we stand with the Xen patches?
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <1242906335.22654.188.camel@zakaz.uk.xensource.com>
References: <1242903785.22654.157.camel@zakaz.uk.xensource.com>
	<20090521201951I.fujita.tomonori@lab.ntt.co.jp>
	<1242906335.22654.188.camel@zakaz.uk.xensource.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20090522022145E.fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Fri, 22 May 2009 02:21:54 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 21 May 2009 12:45:35 +0100
Ian Campbell <ijc@hellion.org.uk> wrote:

> > A necessary interface? Sorry, I don't buy it. It's necessary for
> > only Xen. And it's not fit well for swiotlb and the architecture
> > abstraction.
> 
> I said "necessary interface to enable a particular use-case". Xen is a
> valid use case -- I appreciate that you personally may have no interest
> in it but plenty of people do and plenty of people would like to see it
> working in the mainline kernels.
> 
> In terms of clean abstraction this is a architecture hook to allow
> mappings to be forced through the swiotlb. It is essentially a more
> flexible extension to the existing swiotlb_force flag, in fact
> swiotlb_force_mapping() might even be a better name for it.
> 
> IMHO, the benefits here (working Xen domain 0 plus PCI passthrough to
> guest domains) are well worth the costs.

All I care about is a clean design; an wrong design will hurt us.


> > > If there was a cleaner way to achieve the same result we would of course
> > > go with that. I don't think duplicating swiotlb.c, as has been suggested
> > > as the alternative, just for that one hook point makes sense.
> > 
> > One hook? You need to reread swiotlb.c. There are more. All should go.
> 
> I meant that swiotlb_range_needs_mapping is the single contentious hook
> as far as I can tell. It is the only one which you appear to be
> disputing the very existence of (irrespective of whether it uses __weak
> or is moved into asm/dma-mapping.h). The other existing __weak hooks are
> useful to other users too and all can, AFAICT, be moved into
> asm/dma-mapping.h.
> 
> You have already dealt with moving swiotlb_address_needs_mapping and I
> am currently looking into the the phys_to_bus and bus_to_phys ones. That
> just leaves the alloc functions, which are next on my list after
> phys_to_bus and bus_to_phys. Will finishing up those patches resolve
> most of your objections are do you have others?

The latest your patch is more hacky than the current code. You just
move the ugly hacks for dom0 from lib/swiotlb.c to somewhere else.

I guess that the only way to keep the Xen-specific stuff in Xen's land
is something like this. Then xen/pci-swiotlb.c implements its own
map/unmap functions without messing up the generic code.

I guess that do_map_single's io_tlb_daddr argument is pointless for
Xen since swiotlb doesn't work if iotlb buffer is not physically
continuous (you will see data corruption with some device drivers).


diff --git a/include/linux/swiotlb.h b/include/linux/swiotlb.h
index cb1a663..e1c40ae 100644
--- a/include/linux/swiotlb.h
+++ b/include/linux/swiotlb.h
@@ -21,8 +21,17 @@ struct scatterlist;
  */
 #define IO_TLB_SHIFT 11
 
-extern void
-swiotlb_init(void);
+extern void swiotlb_init(void);
+extern void swiotlb_register_io_tlb(void *);
+
+extern void *do_map_single(struct device *hwdev, dma_addr_t io_tlb_daddr,
+			   phys_addr_t phys, size_t size,
+			   enum dma_data_direction dir);
+extern void do_unmap_single(struct device *hwdev, char *dma_addr, size_t size,
+			    enum dma_data_direction dir);
+
+extern void sync_single(struct device *hwdev, char *dma_addr, size_t size,
+			int dir, int target);
 
 extern void *swiotlb_alloc_boot(size_t bytes, unsigned long nslabs);
 extern void *swiotlb_alloc(unsigned order, unsigned long nslabs);
diff --git a/lib/swiotlb.c b/lib/swiotlb.c
index cec5f62..6efa8cc 100644
--- a/lib/swiotlb.c
+++ b/lib/swiotlb.c
@@ -176,24 +176,16 @@ static void swiotlb_print_info(unsigned long bytes)
  * Statically reserve bounce buffer space and initialize bounce buffer data
  * structures for the software IO TLB used to implement the DMA API.
  */
-void __init
-swiotlb_init_with_default_size(size_t default_size)
+void __init swiotlb_register_iotlb(void *iotlb)
 {
 	unsigned long i, bytes;
 
-	if (!io_tlb_nslabs) {
-		io_tlb_nslabs = (default_size >> IO_TLB_SHIFT);
-		io_tlb_nslabs = ALIGN(io_tlb_nslabs, IO_TLB_SEGSIZE);
-	}
-
 	bytes = io_tlb_nslabs << IO_TLB_SHIFT;
 
 	/*
 	 * Get IO TLB memory from the low pages
 	 */
-	io_tlb_start = swiotlb_alloc_boot(bytes, io_tlb_nslabs);
-	if (!io_tlb_start)
-		panic("Cannot allocate SWIOTLB buffer");
+	io_tlb_start = iotlb;
 	io_tlb_end = io_tlb_start + bytes;
 
 	/*
@@ -207,21 +199,30 @@ swiotlb_init_with_default_size(size_t default_size)
 	io_tlb_index = 0;
 	io_tlb_orig_addr = alloc_bootmem(io_tlb_nslabs * sizeof(phys_addr_t));
 
-	/*
-	 * Get the overflow emergency buffer
-	 */
-	io_tlb_overflow_buffer = swiotlb_alloc_boot(io_tlb_overflow,
-						    io_tlb_overflow >> IO_TLB_SHIFT);
-	if (!io_tlb_overflow_buffer)
-		panic("Cannot allocate SWIOTLB overflow buffer!\n");
-
 	swiotlb_print_info(bytes);
 }
 
 void __init
 swiotlb_init(void)
 {
-	swiotlb_init_with_default_size(64 * (1<<20));	/* default to 64MB */
+	size_t default_size = 64 * (1 << 20);	/* default to 64MB */
+	void *iotlb;
+
+	if (!io_tlb_nslabs) {
+		io_tlb_nslabs = (default_size >> IO_TLB_SHIFT);
+		io_tlb_nslabs = ALIGN(io_tlb_nslabs, IO_TLB_SEGSIZE);
+	}
+
+	iotlb = swiotlb_alloc_boot(io_tlb_nslabs << IO_TLB_SHIFT,
+				   io_tlb_nslabs);
+	BUG_ON(!iotlb);
+
+	io_tlb_overflow_buffer = swiotlb_alloc_boot(io_tlb_overflow,
+						    io_tlb_overflow >> IO_TLB_SHIFT);
+	if (!io_tlb_overflow_buffer)
+		panic("Cannot allocate SWIOTLB overflow buffer!\n");
+
+	swiotlb_register_iotlb(iotlb);
 }
 
 /*
@@ -378,8 +379,9 @@ static void swiotlb_bounce(phys_addr_t phys, char *dma_addr, size_t size,
 /*
  * Allocates bounce buffer and returns its kernel virtual address.
  */
-static void *
-map_single(struct device *hwdev, phys_addr_t phys, size_t size, int dir)
+void *do_map_single(struct device *hwdev, dma_addr_t io_tlb_daddr,
+		    phys_addr_t phys, size_t size,
+		    enum dma_data_direction dir)
 {
 	unsigned long flags;
 	char *dma_addr;
@@ -391,7 +393,7 @@ map_single(struct device *hwdev, phys_addr_t phys, size_t size, int dir)
 	unsigned long max_slots;
 
 	mask = dma_get_seg_boundary(hwdev);
-	start_dma_addr = swiotlb_virt_to_bus(hwdev, io_tlb_start) & mask;
+	start_dma_addr = io_tlb_daddr & mask;
 
 	offset_slots = ALIGN(start_dma_addr, 1 << IO_TLB_SHIFT) >> IO_TLB_SHIFT;
 
@@ -481,11 +483,18 @@ found:
 	return dma_addr;
 }
 
+static void *map_single(struct device *dev, phys_addr_t phys, size_t size,
+			enum dma_data_direction dir)
+{
+	return do_map_single(dev, swiotlb_virt_to_bus(dev, io_tlb_start),
+			     phys, size, dir);
+}
+
 /*
  * dma_addr is the kernel virtual address of the bounce buffer to unmap.
  */
-static void
-do_unmap_single(struct device *hwdev, char *dma_addr, size_t size, int dir)
+void do_unmap_single(struct device *hwdev, char *dma_addr, size_t size,
+		     enum dma_data_direction dir)
 {
 	unsigned long flags;
 	int i, count, nslots = ALIGN(size, 1 << IO_TLB_SHIFT) >> IO_TLB_SHIFT;
@@ -524,7 +533,7 @@ do_unmap_single(struct device *hwdev, char *dma_addr, size_t size, int dir)
 	spin_unlock_irqrestore(&io_tlb_lock, flags);
 }
 
-static void
+void
 sync_single(struct device *hwdev, char *dma_addr, size_t size,
 	    int dir, int target)
 {
