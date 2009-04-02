Return-Path: <linux-kernel-owner+w=401wt.eu-S1764298AbZDBHNU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764298AbZDBHNU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Apr 2009 03:13:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760829AbZDBHND
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Apr 2009 03:13:03 -0400
Received: from gw.goop.org ([64.81.55.164]:45260 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759915AbZDBHMs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Apr 2009 03:12:48 -0400
Message-ID: <49D4656C.20009@goop.org>
Date: Thu, 02 Apr 2009 00:12:44 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
CC: x86@kernel.org, mingo@elte.hu, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] swiotlb updates for Xen dom0
References: <1238539935-4295-1-git-send-email-jeremy@goop.org> <20090402152918I.fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <20090402152918I.fujita.tomonori@lab.ntt.co.jp>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

FUJITA Tomonori wrote:
> On Tue, 31 Mar 2009 15:52:06 -0700
> Jeremy Fitzhardinge <jeremy@goop.org> wrote:
>
>   
>> This series adds Xen support to x86 swiotlb.  This is mostly a matter of
>> adding some Xen code into the existing hooks in pci-swiotlb_64.c:
>>   - swiotlb_alloc_boot
>>   - swiotlb_arch_range_needs_mapping
>>   - swiotlb_phys_to_bus/bus_to_phys
>>
>> These hooks are conditional on xen_pv_domain(), which compiles to a
>> constant 0 when CONFIG_XEN is not enabled (and is a simple variable
>> read when it is).
>>
>> All the Xen-specific code is in xen-iommu.c.
>>
>> This series is just the patches which touch lib/swiotlb.c or
>> pci-swiotlb_64.c.  You can see them with more context in:
>>    git://git.kernel.org/pub/scm/linux/kernel/git/jeremy/xen.git for-linus/xen/dom0/swiotlb
>>
>> Thanks,
>> 	J
>>
>>  arch/x86/kernel/pci-swiotlb_64.c |   31 ++++++++++++++++-
>>  arch/x86/xen/Kconfig             |    1 
>>  drivers/pci/xen-iommu.c          |   68 ++++++++++++++++++++++++++++++++++++---
>>  include/xen/swiotlb.h            |   38 +++++++++++++++++++++
>>  lib/swiotlb.c                    |    3 +
>>  5 files changed, 133 insertions(+), 8 deletions(-)
>>     
>
> This patchset looks ugly.
>
> You add 'if we are Xen, we do A. We do B if not' code into 6 functions
> though pic-swiotlb_64.c has only 8 functions. In addition, 5 of 8
> functions were added for Xen.
>
> Why can't you have something like arch/x86/xen/pci-swiotlb.c, which
> works as arch/x86/kernel/pci-swiotlb_64.c? That should be much
> cleaner.
>   

Sure.  Something like this? (Applied on top of the rest of the series, 
after kernel/pci-swiotlb_64.c => pci_swiotlb.c)   It leaves one if(xen) 
in the init function, but its consistent with the other clauses setting 
swiotlb=1.

My only concern with this scheme is that if there's ever a non-Xen x86 
user who wants to override these functions, we'll need to move them back 
out into a common file because its not possible to have two overriding 
definitions for a weak function (one hopes that the linker will warn if 
that arises).

    J

Subject: [PATCH] xen/swiotlb: move all Xen-specific swiotlb operations to separate file

Most of these functions are no-ops on non-Xen systems, so we can fall
back to the default functions if CONFIG_XEN is not defined.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>

diff --git a/arch/x86/kernel/pci-swiotlb.c b/arch/x86/kernel/pci-swiotlb.c
index ead556f..2d8dd35 100644
--- a/arch/x86/kernel/pci-swiotlb.c
+++ b/arch/x86/kernel/pci-swiotlb.c
@@ -12,54 +12,9 @@
 #include <asm/dma.h>
 
 #include <xen/swiotlb.h>
-#include <asm/xen/hypervisor.h>
 
 int swiotlb __read_mostly;
 
-void * __init swiotlb_alloc_boot(size_t size, unsigned long nslabs)
-{
-	void *ret = alloc_bootmem_low_pages(size);
-
-	if (ret && xen_pv_domain())
-		xen_swiotlb_fixup(ret, size, nslabs);
-
-	return ret;
-}
-
-void *swiotlb_alloc(unsigned order, unsigned long nslabs)
-{
-	void *ret = (void *)__get_free_pages(GFP_DMA | __GFP_NOWARN, order);
-
-	if (ret && xen_pv_domain())
-		xen_swiotlb_fixup(ret, 1u << order, nslabs);
-
-	return ret;
-}
-
-dma_addr_t swiotlb_phys_to_bus(struct device *hwdev, phys_addr_t paddr)
-{
-	if (xen_pv_domain())
-		return xen_phys_to_bus(paddr);
-
-	return paddr;
-}
-
-phys_addr_t swiotlb_bus_to_phys(dma_addr_t baddr)
-{
-	if (xen_pv_domain())
-		return xen_bus_to_phys(baddr);
-
-	return baddr;
-}
-
-int swiotlb_arch_range_needs_mapping(phys_addr_t paddr, size_t size)
-{
-	if (xen_pv_domain())
-		return xen_range_needs_mapping(paddr, size);
-
-	return 0;
-}
-
 static void *x86_swiotlb_alloc_coherent(struct device *hwdev, size_t size,
 					dma_addr_t *dma_handle, gfp_t flags)
 {
diff --git a/arch/x86/xen/Makefile b/arch/x86/xen/Makefile
index 639965a..b021e72 100644
--- a/arch/x86/xen/Makefile
+++ b/arch/x86/xen/Makefile
@@ -12,4 +12,4 @@ obj-y		:= enlighten.o setup.o multicalls.o mmu.o irq.o \
 obj-$(CONFIG_SMP)		+= smp.o spinlock.o
 obj-$(CONFIG_XEN_DEBUG_FS)	+= debugfs.o
 obj-$(CONFIG_XEN_DOM0)		+= vga.o apic.o
-obj-$(CONFIG_XEN_DOM0_PCI)	+= pci.o
\ No newline at end of file
+obj-$(CONFIG_XEN_DOM0_PCI)	+= pci.o pci-swiotlb.o
\ No newline at end of file
diff --git a/arch/x86/xen/pci-swiotlb.c b/arch/x86/xen/pci-swiotlb.c
new file mode 100644
index 0000000..82b2291
--- /dev/null
+++ b/arch/x86/xen/pci-swiotlb.c
@@ -0,0 +1,51 @@
+#include <linux/bootmem.h>
+#include <linux/gfp.h>
+
+#include <xen/swiotlb.h>
+#include <asm/xen/hypervisor.h>
+
+/* 
+ * This file defines overrides for weak functions with default
+ * implementations in lib/swiotlb.c.
+ */
+
+void * __init swiotlb_alloc_boot(size_t size, unsigned long nslabs)
+{
+	void *ret = alloc_bootmem_low_pages(size);
+
+	if (ret && xen_pv_domain())
+		xen_swiotlb_fixup(ret, size, nslabs);
+
+	return ret;
+}
+
+void *swiotlb_alloc(unsigned order, unsigned long nslabs)
+{
+	/* Never called on x86.  Warn, just in case. */
+	WARN_ON(1);
+	return NULL;
+}
+
+dma_addr_t swiotlb_phys_to_bus(struct device *hwdev, phys_addr_t paddr)
+{
+	if (xen_pv_domain())
+		return xen_phys_to_bus(paddr);
+
+	return paddr;
+}
+
+phys_addr_t swiotlb_bus_to_phys(dma_addr_t baddr)
+{
+	if (xen_pv_domain())
+		return xen_bus_to_phys(baddr);
+
+	return baddr;
+}
+
+int swiotlb_arch_range_needs_mapping(phys_addr_t paddr, size_t size)
+{
+	if (xen_pv_domain())
+		return xen_range_needs_mapping(paddr, size);
+
+	return 0;
+}


