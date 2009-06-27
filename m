Return-Path: <linux-kernel-owner+w=401wt.eu-S1756044AbZF0AFe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756044AbZF0AFe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jun 2009 20:05:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752780AbZF0AFZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jun 2009 20:05:25 -0400
Received: from sous-sol.org ([216.99.217.87]:58700 "EHLO sequoia.sous-sol.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751646AbZF0AFY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jun 2009 20:05:24 -0400
Date: Fri, 26 Jun 2009 17:03:47 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: David Woodhouse <dwmw2@infradead.org>
Cc: Chris Wright <chrisw@redhat.com>, tony.luck@intel.com,
       linux-ia64@vger.kernel.org, linux-kernel@vger.kernel.org,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       iommu@lists.linux-foundation.org, akpm@linux-foundation.org,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH v2] IA64 Compilation Error Fix for Intel IOMMU Identity
	Mapping Support
Message-ID: <20090627000347.GH6729@sequoia.sous-sol.org>
References: <20090625041605.GA9330@linux-os.sc.intel.com> <20090625134827W.fujita.tomonori@lab.ntt.co.jp> <1245913886.17089.91.camel@macbook.infradead.org> <1245966743.30355.42.camel@macbook.infradead.org> <20090625234342.GD28176@x200.localdomain> <alpine.LFD.2.01.0906251835060.3605@localhost.localdomain> <20090626015205.GE28176@x200.localdomain> <alpine.LFD.2.01.0906251858540.3605@localhost.localdomain> <20090626020854.GG28176@x200.localdomain> <alpine.LFD.2.00.0906261213400.6967@twosheds.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0906261213400.6967@twosheds.infradead.org>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* David Woodhouse (dwmw2@infradead.org) wrote:
> On Thu, 25 Jun 2009, Chris Wright wrote:
> 
> > * Linus Torvalds (torvalds@linux-foundation.org) wrote:
> >> Ok. Sounds like what I want is to get this patch through the ia64 people,
> >> after it has gotten some testing there. Since ia64 is where the current
> >> kernel fails anyway, that sounds like the motivation will be there too.
> >
> > Yup, I agree.
> 
> Tony, please could you test what's in git://git.infradead.org/iommu-2.6.git
> 
> It builds, but we'd like to check that it works correctly with iommu=pt on 
> IA64.

In the meantime, I booted this on an IA-64 box (w/out VT-d), forced it
to call intel_iommu_init() as if it had an IOMMU, and added a small bit
of debugging.  Looks like it's doing the right thing.

efi based
e000000001000000-e000000078000000
e00000007c000000-e00000007e990000
e00000007f300000-e00000007fda0000
e000000100000000-e00000047b7f0000
e00000047f800000-e00000047fdc0000
e00000047fe80000-e00000047ffb0000
zone based
1000000-100000000
100000000-47ffb0000
online node based
1000000-78000000
7c000000-7e990000
7f300000-7fda0000
100000000-47b7f0000
47f800000-47fdc0000
47fe80000-47ffb0000

The efi based mem walker is returning virtual addresses, Fenghua did
you test that one?  I'm surprised it worked.

This is quite similar to the type of output I see on x86_64 (except the
e820 map gives phys addrs, of course).

e820 based
10000-9d800
100000-bf341000
bf67e000-bf800000
100000000-340000000
zone based
10000-1000000
1000000-100000000
100000000-1c0000000
1c0000000-340000000
online node based
10000-9d000
100000-bf341000
bf67e000-bf800000
100000000-1c0000000
1c0000000-340000000

thanks,
-chris
---
debug patch for the really bored...

Index: linus-2.6/drivers/pci/intel-iommu.c
===================================================================
--- linus-2.6.orig/drivers/pci/intel-iommu.c
+++ linus-2.6/drivers/pci/intel-iommu.c
@@ -3110,10 +3110,66 @@ static int __init init_iommu_sysfs(void)
 }
 #endif	/* CONFIG_PM */
 
+#ifdef CONFIG_X86
+#include <asm/e820.h>
+static void __init print_memmap(void)
+{
+	int i;
+	printk("e820 based\n");
+	for (i = 0; i < e820.nr_map; i++) {
+		struct e820entry *ei = &e820.map[i];
+
+		if (ei->type == E820_RAM)
+			printk("%llx-%llx\n", ei->addr, ei->addr + ei->size);
+	}
+}
+#elif CONFIG_IA64
+#include <linux/efi.h>
+static int __init efi_print_map(u64 start, u64 end, void *unused)
+{
+	printk("%llx-%llx\n", start, end);
+	return 0;
+}
+
+static void __init print_memmap(void)
+{
+	printk("efi based\n");
+	efi_memmap_walk(efi_print_map, NULL);
+}
+#endif
+
+static int __init print_region(unsigned long start_pfn, unsigned long end_pfn,
+			       void *unused)
+{
+	printk("%lx-%lx\n", start_pfn << PAGE_SHIFT, end_pfn << PAGE_SHIFT);
+	return 0;
+}
+
+static void __init show_mem_regions(void)
+{
+	int  nid;
+	struct zone *zone;
+
+	print_memmap();
+	printk("zone based\n");
+	for_each_populated_zone(zone) {
+		unsigned long zone_end_pfn = zone->zone_start_pfn +
+					     zone->spanned_pages;
+		printk("%lx-%lx\n", zone->zone_start_pfn << PAGE_SHIFT,
+				    zone_end_pfn << PAGE_SHIFT);
+	}
+
+	printk("online node based\n");
+	for_each_online_node(nid)
+		work_with_active_regions(nid, print_region, NULL);
+}
+
 int __init intel_iommu_init(void)
 {
 	int ret = 0;
 
+	show_mem_regions();
+
 	if (dmar_table_init())
 		return 	-ENODEV;
 
Index: linus-2.6/arch/ia64/kernel/pci-dma.c
===================================================================
--- linus-2.6.orig/arch/ia64/kernel/pci-dma.c
+++ linus-2.6/arch/ia64/kernel/pci-dma.c
@@ -47,7 +47,7 @@ extern struct dma_map_ops intel_dma_ops;
 
 static int __init pci_iommu_init(void)
 {
-	if (iommu_detected)
+//	if (iommu_detected)
 		intel_iommu_init();
 
 	return 0;
