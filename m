Return-Path: <linux-kernel-owner+w=401wt.eu-S1754641AbYFDAZv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754641AbYFDAZv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2008 20:25:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751061AbYFDAZm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jun 2008 20:25:42 -0400
Received: from sh.osrg.net ([192.16.179.4]:38540 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751714AbYFDAZl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2008 20:25:41 -0400
Date: Wed, 4 Jun 2008 09:23:25 +0900
To: alexisb@us.ibm.com, akpm@linux-foundation.org
Cc: muli@il.ibm.com, fujita.tomonori@lab.ntt.co.jp,
       linux-kernel@vger.kernel.org, mingo@elte.hu
Subject: Re: [PATCH -mm] x86 calgary: fix handling of devces that aren't
	behind the Calgary
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <1212512137.8567.43.camel@alexis>
References: <20080531133114P.tomof@acm.org>
	<20080603052146.GI7011@il.ibm.com>
	<1212512137.8567.43.camel@alexis>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20080604092705E.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 03 Jun 2008 09:55:37 -0700
Alexis Bruemmer <alexisb@us.ibm.com> wrote:

> On Tue, 2008-06-03 at 08:21 +0300, Muli Ben-Yehuda wrote:
> > On Sat, May 31, 2008 at 01:31:33PM +0900, FUJITA Tomonori wrote:
> > 
> > > The calgary code can give drivers addresses above 4GB which is very
> > > bad for hardware that is only 32bit DMA addressable:
> > > 
> > > http://lkml.org/lkml/2008/5/8/423
> > > 
> > > This patch tries to fix the problem by using per-device
> > > dma_mapping_ops support. This fixes the calgary code to use swiotlb
> > > or nommu properly for devices which are not behind the
> > > Calgary/CalIOC2.
> > > 
> > > With this patch, the calgary code sets the global dma_ops to swiotlb
> > > or nommu, and the dma_ops of devices behind the Calgary/CalIOC2 to
> > > calgary_dma_ops. So the calgary code can handle devices safely that
> > > aren't behind the Calgary/CalIOC2.
> > 
> > This seems a little backward to me. I thought we were going to get rid
> > of the global dma_ops? If not, assuming going through the global one
> > would be more efficient, Calgary should be the global one and
> > nommu/swiotlb should be used on devices that do not have translation
> > enabled. The reason why is that the majority of devices on a Calgary
> > system, assuming Calgary is in use, will have translation enabled.
> > 
> > In general the patch looks good, barring the point above. We'll give
> > it a spin on some Calgary/CalIOC2 machines.
> Initial testing on a CalIO2 box this patch causes the machine not to
> boot (and this time I tested the base 2.6.26-rc4 + FUJITA 2 per deive
> dma_ops patches first and it boots just fine).  Here is a bit of the
> dump from the failed boot:
> 
> Loading megaraid_sas
> [17180656.651128] megasas: 00.00.03.20-rc1 Mon. March 10 11:02:31 PDT 2008
> [17180656.657866] megasas: 0x1000:0x0060:0x1014:0x0363: bus 4:slot 0:func 0
> [17180656.663899] ACPI: PCI Interrupt 0000:04:00.0[A] -> GSI 46 (level, low) -> IRQ 46
> [17180656.673677] megasas: FW now in Ready state
> [17180657.774102] Calgary: DMA error on CalIOC2 PHB 0x3
> [17180657.779171] Calgary: 0x02000000@CSR 0x00000000@PLSSR 0xb0008000@CSMR 0x00000000@MCK
> [17180657.787212] Calgary: 0x00000000@0x810 0xf6200000@0x820 0xf6200040@0x830 0x00000000@0x840 0x06000000@0x850 0x00000000@0x860 0x00000000@0x870 
> [17180657.801629] Calgary: 0x00000000@0xcb0
> 
> Adding some quick debug code it seems that the megaraid controller is
> not getting its dev->dev.archdata.dma_ops set to calgary_dma_ops.  I am
> not sure why, but will keep digging.  Any ideas?

Ah, sorry. pci_alloc_consistent fails?

=
fix per-device dma_mapping_ops support

On x86, pci_dma_supported, pci_alloc_consistent, and
pci_free_consistent don't call DMA APIs directly (the majority of
platforms do). per-device dma_mapping_ops support patch needs to
modify pci-dma.c.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>

diff --git a/arch/x86/kernel/pci-dma.c b/arch/x86/kernel/pci-dma.c
index 4471984..bc2251d 100644
--- a/arch/x86/kernel/pci-dma.c
+++ b/arch/x86/kernel/pci-dma.c
@@ -318,6 +318,8 @@ static int dma_release_coherent(struct device *dev, int order, void *vaddr)
 
 int dma_supported(struct device *dev, u64 mask)
 {
+	struct dma_mapping_ops *ops = get_dma_ops(dev);
+
 #ifdef CONFIG_PCI
 	if (mask > 0xffffffff && forbid_dac > 0) {
 		dev_info(dev, "PCI: Disallowing DAC for device\n");
@@ -325,8 +327,8 @@ int dma_supported(struct device *dev, u64 mask)
 	}
 #endif
 
-	if (dma_ops->dma_supported)
-		return dma_ops->dma_supported(dev, mask);
+	if (ops->dma_supported)
+		return ops->dma_supported(dev, mask);
 
 	/* Copied from i386. Doesn't make much sense, because it will
 	   only work for pci_alloc_coherent.
@@ -373,6 +375,7 @@ void *
 dma_alloc_coherent(struct device *dev, size_t size, dma_addr_t *dma_handle,
 		   gfp_t gfp)
 {
+	struct dma_mapping_ops *ops = get_dma_ops(dev);
 	void *memory = NULL;
 	struct page *page;
 	unsigned long dma_mask = 0;
@@ -435,8 +438,8 @@ dma_alloc_coherent(struct device *dev, size_t size, dma_addr_t *dma_handle,
 			/* Let low level make its own zone decisions */
 			gfp &= ~(GFP_DMA32|GFP_DMA);
 
-			if (dma_ops->alloc_coherent)
-				return dma_ops->alloc_coherent(dev, size,
+			if (ops->alloc_coherent)
+				return ops->alloc_coherent(dev, size,
 							   dma_handle, gfp);
 			return NULL;
 		}
@@ -448,14 +451,14 @@ dma_alloc_coherent(struct device *dev, size_t size, dma_addr_t *dma_handle,
 		}
 	}
 
-	if (dma_ops->alloc_coherent) {
+	if (ops->alloc_coherent) {
 		free_pages((unsigned long)memory, get_order(size));
 		gfp &= ~(GFP_DMA|GFP_DMA32);
-		return dma_ops->alloc_coherent(dev, size, dma_handle, gfp);
+		return ops->alloc_coherent(dev, size, dma_handle, gfp);
 	}
 
-	if (dma_ops->map_simple) {
-		*dma_handle = dma_ops->map_simple(dev, virt_to_phys(memory),
+	if (ops->map_simple) {
+		*dma_handle = ops->map_simple(dev, virt_to_phys(memory),
 					      size,
 					      PCI_DMA_BIDIRECTIONAL);
 		if (*dma_handle != bad_dma_address)
@@ -477,12 +480,14 @@ EXPORT_SYMBOL(dma_alloc_coherent);
 void dma_free_coherent(struct device *dev, size_t size,
 			 void *vaddr, dma_addr_t bus)
 {
+	struct dma_mapping_ops *ops = get_dma_ops(dev);
+
 	int order = get_order(size);
 	WARN_ON(irqs_disabled());	/* for portability */
 	if (dma_release_coherent(dev, order, vaddr))
 		return;
-	if (dma_ops->unmap_single)
-		dma_ops->unmap_single(dev, bus, size, 0);
+	if (ops->unmap_single)
+		ops->unmap_single(dev, bus, size, 0);
 	free_pages((unsigned long)vaddr, order);
 }
 EXPORT_SYMBOL(dma_free_coherent);
