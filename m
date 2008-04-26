Return-Path: <linux-kernel-owner+w=401wt.eu-S1762302AbYDZUZZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762302AbYDZUZZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Apr 2008 16:25:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760188AbYDZUZM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Apr 2008 16:25:12 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:44527 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759833AbYDZUZJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Apr 2008 16:25:09 -0400
Date: Sat, 26 Apr 2008 22:24:49 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Yinghai Lu <yinghai.lu@sun.com>, Yinghai Lu <yhlu.kernel@gmail.com>,
       jbarnes@virtuousgeek.org
Subject: [RFC git pull] "big box" x86 changes, GART
Message-ID: <20080426202449.GA17256@elte.hu>
References: <20080426185516.GA32364@elte.hu> <alpine.LFD.1.10.0804261205490.2813@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.10.0804261205490.2813@woody.linux-foundation.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Linus, please pull the x86 "big box & GART" subtopic tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/x86/linux-2.6-x86-bigbox-gart.git for-linus

it also touches drivers/char/agp/amd64-agp.c.

Thanks,

	Ingo

------------------>
Pavel Machek (1):
      x86: iommu: use symbolic constants, not hardcoded numbers

Yinghai Lu (5):
      x86: agp_gart size checking for buggy device
      x86: checking aperture size order
      x86_64: allocate gart aperture from 512M
      x86: clean up aperture_64.c
      x86: reserve dma32 early for gart fix

 arch/x86/kernel/aperture_64.c |  283 +++++++++++++++++++++++++++-------------
 arch/x86/kernel/pci-dma.c     |   11 +-
 arch/x86/kernel/pci-gart_64.c |   10 +-
 drivers/char/agp/amd64-agp.c  |   46 +++----
 include/asm-x86/gart.h        |   21 +++
 5 files changed, 242 insertions(+), 129 deletions(-)

diff --git a/arch/x86/kernel/aperture_64.c b/arch/x86/kernel/aperture_64.c
index 479926d..02f4dba 100644
--- a/arch/x86/kernel/aperture_64.c
+++ b/arch/x86/kernel/aperture_64.c
@@ -35,6 +35,18 @@ int fallback_aper_force __initdata;
 
 int fix_aperture __initdata = 1;
 
+struct bus_dev_range {
+	int bus;
+	int dev_base;
+	int dev_limit;
+};
+
+static struct bus_dev_range bus_dev_ranges[] __initdata = {
+	{ 0x00, 0x18, 0x20},
+	{ 0xff, 0x00, 0x20},
+	{ 0xfe, 0x00, 0x20}
+};
+
 static struct resource gart_resource = {
 	.name	= "GART",
 	.flags	= IORESOURCE_MEM,
@@ -55,8 +67,9 @@ static u32 __init allocate_aperture(void)
 	u32 aper_size;
 	void *p;
 
-	if (fallback_aper_order > 7)
-		fallback_aper_order = 7;
+	/* aper_size should <= 1G */
+	if (fallback_aper_order > 5)
+		fallback_aper_order = 5;
 	aper_size = (32 * 1024 * 1024) << fallback_aper_order;
 
 	/*
@@ -65,7 +78,20 @@ static u32 __init allocate_aperture(void)
 	 * memory. Unfortunately we cannot move it up because that would
 	 * make the IOMMU useless.
 	 */
-	p = __alloc_bootmem_nopanic(aper_size, aper_size, 0);
+	/*
+	 * using 512M as goal, in case kexec will load kernel_big
+	 * that will do the on position decompress, and  could overlap with
+	 * that positon with gart that is used.
+	 * sequende:
+	 * kernel_small
+	 * ==> kexec (with kdump trigger path or previous doesn't shutdown gart)
+	 * ==> kernel_small(gart area become e820_reserved)
+	 * ==> kexec (with kdump trigger path or previous doesn't shutdown gart)
+	 * ==> kerne_big (uncompressed size will be big than 64M or 128M)
+	 * so don't use 512M below as gart iommu, leave the space for kernel
+	 * code for safe
+	 */
+	p = __alloc_bootmem_nopanic(aper_size, aper_size, 512ULL<<20);
 	if (!p || __pa(p)+aper_size > 0xffffffff) {
 		printk(KERN_ERR
 			"Cannot allocate aperture memory hole (%p,%uK)\n",
@@ -83,7 +109,7 @@ static u32 __init allocate_aperture(void)
 	return (u32)__pa(p);
 }
 
-static int __init aperture_valid(u64 aper_base, u32 aper_size)
+static int __init aperture_valid(u64 aper_base, u32 aper_size, u32 min_size)
 {
 	if (!aper_base)
 		return 0;
@@ -96,8 +122,9 @@ static int __init aperture_valid(u64 aper_base, u32 aper_size)
 		printk(KERN_ERR "Aperture pointing to e820 RAM. Ignoring.\n");
 		return 0;
 	}
-	if (aper_size < 64*1024*1024) {
-		printk(KERN_ERR "Aperture too small (%d MB)\n", aper_size>>20);
+	if (aper_size < min_size) {
+		printk(KERN_ERR "Aperture too small (%d MB) than (%d MB)\n",
+				 aper_size>>20, min_size>>20);
 		return 0;
 	}
 
@@ -105,47 +132,51 @@ static int __init aperture_valid(u64 aper_base, u32 aper_size)
 }
 
 /* Find a PCI capability */
-static __u32 __init find_cap(int num, int slot, int func, int cap)
+static __u32 __init find_cap(int bus, int slot, int func, int cap)
 {
 	int bytes;
 	u8 pos;
 
-	if (!(read_pci_config_16(num, slot, func, PCI_STATUS) &
+	if (!(read_pci_config_16(bus, slot, func, PCI_STATUS) &
 						PCI_STATUS_CAP_LIST))
 		return 0;
 
-	pos = read_pci_config_byte(num, slot, func, PCI_CAPABILITY_LIST);
+	pos = read_pci_config_byte(bus, slot, func, PCI_CAPABILITY_LIST);
 	for (bytes = 0; bytes < 48 && pos >= 0x40; bytes++) {
 		u8 id;
 
 		pos &= ~3;
-		id = read_pci_config_byte(num, slot, func, pos+PCI_CAP_LIST_ID);
+		id = read_pci_config_byte(bus, slot, func, pos+PCI_CAP_LIST_ID);
 		if (id == 0xff)
 			break;
 		if (id == cap)
 			return pos;
-		pos = read_pci_config_byte(num, slot, func,
+		pos = read_pci_config_byte(bus, slot, func,
 						pos+PCI_CAP_LIST_NEXT);
 	}
 	return 0;
 }
 
 /* Read a standard AGPv3 bridge header */
-static __u32 __init read_agp(int num, int slot, int func, int cap, u32 *order)
+static __u32 __init read_agp(int bus, int slot, int func, int cap, u32 *order)
 {
 	u32 apsize;
 	u32 apsizereg;
 	int nbits;
 	u32 aper_low, aper_hi;
 	u64 aper;
+	u32 old_order;
 
-	printk(KERN_INFO "AGP bridge at %02x:%02x:%02x\n", num, slot, func);
-	apsizereg = read_pci_config_16(num, slot, func, cap + 0x14);
+	printk(KERN_INFO "AGP bridge at %02x:%02x:%02x\n", bus, slot, func);
+	apsizereg = read_pci_config_16(bus, slot, func, cap + 0x14);
 	if (apsizereg == 0xffffffff) {
 		printk(KERN_ERR "APSIZE in AGP bridge unreadable\n");
 		return 0;
 	}
 
+	/* old_order could be the value from NB gart setting */
+	old_order = *order;
+
 	apsize = apsizereg & 0xfff;
 	/* Some BIOS use weird encodings not in the AGPv3 table. */
 	if (apsize & 0xff)
@@ -155,14 +186,26 @@ static __u32 __init read_agp(int num, int slot, int func, int cap, u32 *order)
 	if ((int)*order < 0) /* < 32MB */
 		*order = 0;
 
-	aper_low = read_pci_config(num, slot, func, 0x10);
-	aper_hi = read_pci_config(num, slot, func, 0x14);
+	aper_low = read_pci_config(bus, slot, func, 0x10);
+	aper_hi = read_pci_config(bus, slot, func, 0x14);
 	aper = (aper_low & ~((1<<22)-1)) | ((u64)aper_hi << 32);
 
+	/*
+	 * On some sick chips, APSIZE is 0. It means it wants 4G
+	 * so let double check that order, and lets trust AMD NB settings:
+	 */
+	printk(KERN_INFO "Aperture from AGP @ %Lx old size %u MB\n",
+			aper, 32 << old_order);
+	if (aper + (32ULL<<(20 + *order)) > 0x100000000ULL) {
+		printk(KERN_INFO "Aperture size %u MB (APSIZE %x) is not right, using settings from NB\n",
+				32 << *order, apsizereg);
+		*order = old_order;
+	}
+
 	printk(KERN_INFO "Aperture from AGP @ %Lx size %u MB (APSIZE %x)\n",
 			aper, 32 << *order, apsizereg);
 
-	if (!aperture_valid(aper, (32*1024*1024) << *order))
+	if (!aperture_valid(aper, (32*1024*1024) << *order, 32<<20))
 		return 0;
 	return (u32)aper;
 }
@@ -182,15 +225,15 @@ static __u32 __init read_agp(int num, int slot, int func, int cap, u32 *order)
  */
 static __u32 __init search_agp_bridge(u32 *order, int *valid_agp)
 {
-	int num, slot, func;
+	int bus, slot, func;
 
 	/* Poor man's PCI discovery */
-	for (num = 0; num < 256; num++) {
+	for (bus = 0; bus < 256; bus++) {
 		for (slot = 0; slot < 32; slot++) {
 			for (func = 0; func < 8; func++) {
 				u32 class, cap;
 				u8 type;
-				class = read_pci_config(num, slot, func,
+				class = read_pci_config(bus, slot, func,
 							PCI_CLASS_REVISION);
 				if (class == 0xffffffff)
 					break;
@@ -199,17 +242,17 @@ static __u32 __init search_agp_bridge(u32 *order, int *valid_agp)
 				case PCI_CLASS_BRIDGE_HOST:
 				case PCI_CLASS_BRIDGE_OTHER: /* needed? */
 					/* AGP bridge? */
-					cap = find_cap(num, slot, func,
+					cap = find_cap(bus, slot, func,
 							PCI_CAP_ID_AGP);
 					if (!cap)
 						break;
 					*valid_agp = 1;
-					return read_agp(num, slot, func, cap,
+					return read_agp(bus, slot, func, cap,
 							order);
 				}
 
 				/* No multi-function device? */
-				type = read_pci_config_byte(num, slot, func,
+				type = read_pci_config_byte(bus, slot, func,
 							       PCI_HEADER_TYPE);
 				if (!(type & 0x80))
 					break;
@@ -249,38 +292,49 @@ void __init early_gart_iommu_check(void)
 	 * or BIOS forget to put that in reserved.
 	 * try to update e820 to make that region as reserved.
 	 */
-	int fix, num;
+	int fix, slot;
 	u32 ctl;
 	u32 aper_size = 0, aper_order = 0, last_aper_order = 0;
 	u64 aper_base = 0, last_aper_base = 0;
 	int aper_enabled = 0, last_aper_enabled = 0;
+	int i;
 
 	if (!early_pci_allowed())
 		return;
 
 	fix = 0;
-	for (num = 24; num < 32; num++) {
-		if (!early_is_k8_nb(read_pci_config(0, num, 3, 0x00)))
-			continue;
-
-		ctl = read_pci_config(0, num, 3, 0x90);
-		aper_enabled = ctl & 1;
-		aper_order = (ctl >> 1) & 7;
-		aper_size = (32 * 1024 * 1024) << aper_order;
-		aper_base = read_pci_config(0, num, 3, 0x94) & 0x7fff;
-		aper_base <<= 25;
-
-		if ((last_aper_order && aper_order != last_aper_order) ||
-		    (last_aper_base && aper_base != last_aper_base) ||
-		    (last_aper_enabled && aper_enabled != last_aper_enabled)) {
-			fix = 1;
-			break;
+	for (i = 0; i < ARRAY_SIZE(bus_dev_ranges); i++) {
+		int bus;
+		int dev_base, dev_limit;
+
+		bus = bus_dev_ranges[i].bus;
+		dev_base = bus_dev_ranges[i].dev_base;
+		dev_limit = bus_dev_ranges[i].dev_limit;
+
+		for (slot = dev_base; slot < dev_limit; slot++) {
+			if (!early_is_k8_nb(read_pci_config(bus, slot, 3, 0x00)))
+				continue;
+
+			ctl = read_pci_config(bus, slot, 3, AMD64_GARTAPERTURECTL);
+			aper_enabled = ctl & AMD64_GARTEN;
+			aper_order = (ctl >> 1) & 7;
+			aper_size = (32 * 1024 * 1024) << aper_order;
+			aper_base = read_pci_config(bus, slot, 3, AMD64_GARTAPERTUREBASE) & 0x7fff;
+			aper_base <<= 25;
+
+			if ((last_aper_order && aper_order != last_aper_order) ||
+			    (last_aper_base && aper_base != last_aper_base) ||
+			    (last_aper_enabled && aper_enabled != last_aper_enabled)) {
+				fix = 1;
+				goto out;
+			}
+			last_aper_order = aper_order;
+			last_aper_base = aper_base;
+			last_aper_enabled = aper_enabled;
 		}
-		last_aper_order = aper_order;
-		last_aper_base = aper_base;
-		last_aper_enabled = aper_enabled;
 	}
 
+out:
 	if (!fix && !aper_enabled)
 		return;
 
@@ -288,8 +342,8 @@ void __init early_gart_iommu_check(void)
 		fix = 1;
 
 	if (gart_fix_e820 && !fix && aper_enabled) {
-		if (e820_any_mapped(aper_base, aper_base + aper_size,
-				    E820_RAM)) {
+		if (!e820_all_mapped(aper_base, aper_base + aper_size,
+				    E820_RESERVED)) {
 			/* reserved it, so we can resuse it in second kernel */
 			printk(KERN_INFO "update e820 for GART\n");
 			add_memory_region(aper_base, aper_size, E820_RESERVED);
@@ -299,23 +353,35 @@ void __init early_gart_iommu_check(void)
 	}
 
 	/* different nodes have different setting, disable them all at first*/
-	for (num = 24; num < 32; num++) {
-		if (!early_is_k8_nb(read_pci_config(0, num, 3, 0x00)))
-			continue;
+	for (i = 0; i < ARRAY_SIZE(bus_dev_ranges); i++) {
+		int bus;
+		int dev_base, dev_limit;
+
+		bus = bus_dev_ranges[i].bus;
+		dev_base = bus_dev_ranges[i].dev_base;
+		dev_limit = bus_dev_ranges[i].dev_limit;
 
-		ctl = read_pci_config(0, num, 3, 0x90);
-		ctl &= ~1;
-		write_pci_config(0, num, 3, 0x90, ctl);
+		for (slot = dev_base; slot < dev_limit; slot++) {
+			if (!early_is_k8_nb(read_pci_config(bus, slot, 3, 0x00)))
+				continue;
+
+			ctl = read_pci_config(bus, slot, 3, AMD64_GARTAPERTURECTL);
+			ctl &= ~AMD64_GARTEN;
+			write_pci_config(bus, slot, 3, AMD64_GARTAPERTURECTL, ctl);
+		}
 	}
 
 }
 
+static int __initdata printed_gart_size_msg;
+
 void __init gart_iommu_hole_init(void)
 {
+	u32 agp_aper_base = 0, agp_aper_order = 0;
 	u32 aper_size, aper_alloc = 0, aper_order = 0, last_aper_order = 0;
 	u64 aper_base, last_aper_base = 0;
-	int fix, num, valid_agp = 0;
-	int node;
+	int fix, slot, valid_agp = 0;
+	int i, node;
 
 	if (gart_iommu_aperture_disabled || !fix_aperture ||
 	    !early_pci_allowed())
@@ -323,38 +389,63 @@ void __init gart_iommu_hole_init(void)
 
 	printk(KERN_INFO  "Checking aperture...\n");
 
+	if (!fallback_aper_force)
+		agp_aper_base = search_agp_bridge(&agp_aper_order, &valid_agp);
+
 	fix = 0;
 	node = 0;
-	for (num = 24; num < 32; num++) {
-		if (!early_is_k8_nb(read_pci_config(0, num, 3, 0x00)))
-			continue;
-
-		iommu_detected = 1;
-		gart_iommu_aperture = 1;
-
-		aper_order = (read_pci_config(0, num, 3, 0x90) >> 1) & 7;
-		aper_size = (32 * 1024 * 1024) << aper_order;
-		aper_base = read_pci_config(0, num, 3, 0x94) & 0x7fff;
-		aper_base <<= 25;
-
-		printk(KERN_INFO "Node %d: aperture @ %Lx size %u MB\n",
-				node, aper_base, aper_size >> 20);
-		node++;
-
-		if (!aperture_valid(aper_base, aper_size)) {
-			fix = 1;
-			break;
-		}
+	for (i = 0; i < ARRAY_SIZE(bus_dev_ranges); i++) {
+		int bus;
+		int dev_base, dev_limit;
+
+		bus = bus_dev_ranges[i].bus;
+		dev_base = bus_dev_ranges[i].dev_base;
+		dev_limit = bus_dev_ranges[i].dev_limit;
+
+		for (slot = dev_base; slot < dev_limit; slot++) {
+			if (!early_is_k8_nb(read_pci_config(bus, slot, 3, 0x00)))
+				continue;
+
+			iommu_detected = 1;
+			gart_iommu_aperture = 1;
+
+			aper_order = (read_pci_config(bus, slot, 3, AMD64_GARTAPERTURECTL) >> 1) & 7;
+			aper_size = (32 * 1024 * 1024) << aper_order;
+			aper_base = read_pci_config(bus, slot, 3, AMD64_GARTAPERTUREBASE) & 0x7fff;
+			aper_base <<= 25;
+
+			printk(KERN_INFO "Node %d: aperture @ %Lx size %u MB\n",
+					node, aper_base, aper_size >> 20);
+			node++;
+
+			if (!aperture_valid(aper_base, aper_size, 64<<20)) {
+				if (valid_agp && agp_aper_base &&
+				    agp_aper_base == aper_base &&
+				    agp_aper_order == aper_order) {
+					/* the same between two setting from NB and agp */
+					if (!no_iommu && end_pfn > MAX_DMA32_PFN && !printed_gart_size_msg) {
+						printk(KERN_ERR "you are using iommu with agp, but GART size is less than 64M\n");
+						printk(KERN_ERR "please increase GART size in your BIOS setup\n");
+						printk(KERN_ERR "if BIOS doesn't have that option, contact your HW vendor!\n");
+						printed_gart_size_msg = 1;
+					}
+				} else {
+					fix = 1;
+					goto out;
+				}
+			}
 
-		if ((last_aper_order && aper_order != last_aper_order) ||
-		    (last_aper_base && aper_base != last_aper_base)) {
-			fix = 1;
-			break;
+			if ((last_aper_order && aper_order != last_aper_order) ||
+			    (last_aper_base && aper_base != last_aper_base)) {
+				fix = 1;
+				goto out;
+			}
+			last_aper_order = aper_order;
+			last_aper_base = aper_base;
 		}
-		last_aper_order = aper_order;
-		last_aper_base = aper_base;
 	}
 
+out:
 	if (!fix && !fallback_aper_force) {
 		if (last_aper_base) {
 			unsigned long n = (32 * 1024 * 1024) << last_aper_order;
@@ -364,8 +455,10 @@ void __init gart_iommu_hole_init(void)
 		return;
 	}
 
-	if (!fallback_aper_force)
-		aper_alloc = search_agp_bridge(&aper_order, &valid_agp);
+	if (!fallback_aper_force) {
+		aper_alloc = agp_aper_base;
+		aper_order = agp_aper_order;
+	}
 
 	if (aper_alloc) {
 		/* Got the aperture from the AGP bridge */
@@ -401,16 +494,22 @@ void __init gart_iommu_hole_init(void)
 	}
 
 	/* Fix up the north bridges */
-	for (num = 24; num < 32; num++) {
-		if (!early_is_k8_nb(read_pci_config(0, num, 3, 0x00)))
-			continue;
-
-		/*
-		 * Don't enable translation yet. That is done later.
-		 * Assume this BIOS didn't initialise the GART so
-		 * just overwrite all previous bits
-		 */
-		write_pci_config(0, num, 3, 0x90, aper_order<<1);
-		write_pci_config(0, num, 3, 0x94, aper_alloc>>25);
+	for (i = 0; i < ARRAY_SIZE(bus_dev_ranges); i++) {
+		int bus;
+		int dev_base, dev_limit;
+
+		bus = bus_dev_ranges[i].bus;
+		dev_base = bus_dev_ranges[i].dev_base;
+		dev_limit = bus_dev_ranges[i].dev_limit;
+		for (slot = dev_base; slot < dev_limit; slot++) {
+			if (!early_is_k8_nb(read_pci_config(bus, slot, 3, 0x00)))
+				continue;
+
+			/* Don't enable translation yet. That is done later.
+			   Assume this BIOS didn't initialise the GART so
+			   just overwrite all previous bits */
+			write_pci_config(bus, slot, 3, AMD64_GARTAPERTURECTL, aper_order << 1);
+			write_pci_config(bus, slot, 3, AMD64_GARTAPERTUREBASE, aper_alloc >> 25);
+		}
 	}
 }
diff --git a/arch/x86/kernel/pci-dma.c b/arch/x86/kernel/pci-dma.c
index 388b113..50a18e4 100644
--- a/arch/x86/kernel/pci-dma.c
+++ b/arch/x86/kernel/pci-dma.c
@@ -77,10 +77,14 @@ void __init dma32_reserve_bootmem(void)
 	if (end_pfn <= MAX_DMA32_PFN)
 		return;
 
+	/*
+	 * check aperture_64.c allocate_aperture() for reason about
+	 * using 512M as goal
+	 */
 	align = 64ULL<<20;
 	size = round_up(dma32_bootmem_size, align);
 	dma32_bootmem_ptr = __alloc_bootmem_nopanic(size, align,
-				 __pa(MAX_DMA_ADDRESS));
+				 512ULL<<20);
 	if (dma32_bootmem_ptr)
 		dma32_bootmem_size = size;
 	else
@@ -88,7 +92,6 @@ void __init dma32_reserve_bootmem(void)
 }
 static void __init dma32_free_bootmem(void)
 {
-	int node;
 
 	if (end_pfn <= MAX_DMA32_PFN)
 		return;
@@ -96,9 +99,7 @@ static void __init dma32_free_bootmem(void)
 	if (!dma32_bootmem_ptr)
 		return;
 
-	for_each_online_node(node)
-		free_bootmem_node(NODE_DATA(node), __pa(dma32_bootmem_ptr),
-				  dma32_bootmem_size);
+	free_bootmem(__pa(dma32_bootmem_ptr), dma32_bootmem_size);
 
 	dma32_bootmem_ptr = NULL;
 	dma32_bootmem_size = 0;
diff --git a/arch/x86/kernel/pci-gart_64.c b/arch/x86/kernel/pci-gart_64.c
index c07455d..bffcf45 100644
--- a/arch/x86/kernel/pci-gart_64.c
+++ b/arch/x86/kernel/pci-gart_64.c
@@ -598,13 +598,13 @@ static __init int init_k8_gatt(struct agp_kern_info *info)
 		dev = k8_northbridges[i];
 		gatt_reg = __pa(gatt) >> 12;
 		gatt_reg <<= 4;
-		pci_write_config_dword(dev, 0x98, gatt_reg);
-		pci_read_config_dword(dev, 0x90, &ctl);
+		pci_write_config_dword(dev, AMD64_GARTTABLEBASE, gatt_reg);
+		pci_read_config_dword(dev, AMD64_GARTAPERTURECTL, &ctl);
 
-		ctl |= 1;
-		ctl &= ~((1<<4) | (1<<5));
+		ctl |= GARTEN;
+		ctl &= ~(DISGARTCPU | DISGARTIO);
 
-		pci_write_config_dword(dev, 0x90, ctl);
+		pci_write_config_dword(dev, AMD64_GARTAPERTURECTL, ctl);
 	}
 	flush_gart();
 
diff --git a/drivers/char/agp/amd64-agp.c b/drivers/char/agp/amd64-agp.c
index d8200ac..9c24470 100644
--- a/drivers/char/agp/amd64-agp.c
+++ b/drivers/char/agp/amd64-agp.c
@@ -16,28 +16,9 @@
 #include <asm/page.h>		/* PAGE_SIZE */
 #include <asm/e820.h>
 #include <asm/k8.h>
+#include <asm/gart.h>
 #include "agp.h"
 
-/* PTE bits. */
-#define GPTE_VALID	1
-#define GPTE_COHERENT	2
-
-/* Aperture control register bits. */
-#define GARTEN		(1<<0)
-#define DISGARTCPU	(1<<4)
-#define DISGARTIO	(1<<5)
-
-/* GART cache control register bits. */
-#define INVGART		(1<<0)
-#define GARTPTEERR	(1<<1)
-
-/* K8 On-cpu GART registers */
-#define AMD64_GARTAPERTURECTL	0x90
-#define AMD64_GARTAPERTUREBASE	0x94
-#define AMD64_GARTTABLEBASE	0x98
-#define AMD64_GARTCACHECTL	0x9c
-#define AMD64_GARTEN		(1<<0)
-
 /* NVIDIA K8 registers */
 #define NVIDIA_X86_64_0_APBASE		0x10
 #define NVIDIA_X86_64_1_APBASE1		0x50
@@ -165,7 +146,7 @@ static int amd64_fetch_size(void)
  * In a multiprocessor x86-64 system, this function gets
  * called once for each CPU.
  */
-static u64 amd64_configure (struct pci_dev *hammer, u64 gatt_table)
+static u64 amd64_configure(struct pci_dev *hammer, u64 gatt_table)
 {
 	u64 aperturebase;
 	u32 tmp;
@@ -181,7 +162,7 @@ static u64 amd64_configure (struct pci_dev *hammer, u64 gatt_table)
 	addr >>= 12;
 	tmp = (u32) addr<<4;
 	tmp &= ~0xf;
-	pci_write_config_dword (hammer, AMD64_GARTTABLEBASE, tmp);
+	pci_write_config_dword(hammer, AMD64_GARTTABLEBASE, tmp);
 
 	/* Enable GART translation for this hammer. */
 	pci_read_config_dword(hammer, AMD64_GARTAPERTURECTL, &tmp);
@@ -264,11 +245,7 @@ static int __devinit aperture_valid(u64 aper, u32 size)
 		printk(KERN_ERR PFX "No aperture\n");
 		return 0;
 	}
-	if (size < 32*1024*1024) {
-		printk(KERN_ERR PFX "Aperture too small (%d MB)\n", size>>20);
-		return 0;
-	}
-       if ((u64)aper + size > 0x100000000ULL) {
+	if ((u64)aper + size > 0x100000000ULL) {
 		printk(KERN_ERR PFX "Aperture out of bounds\n");
 		return 0;
 	}
@@ -276,6 +253,10 @@ static int __devinit aperture_valid(u64 aper, u32 size)
 		printk(KERN_ERR PFX "Aperture pointing to RAM\n");
 		return 0;
 	}
+	if (size < 32*1024*1024) {
+		printk(KERN_ERR PFX "Aperture too small (%d MB)\n", size>>20);
+		return 0;
+	}
 
 	/* Request the Aperture. This catches cases when someone else
 	   already put a mapping in there - happens with some very broken BIOS
@@ -331,6 +312,17 @@ static __devinit int fix_northbridge(struct pci_dev *nb, struct pci_dev *agp,
 	pci_read_config_dword(agp, 0x10, &aper_low);
 	pci_read_config_dword(agp, 0x14, &aper_hi);
 	aper = (aper_low & ~((1<<22)-1)) | ((u64)aper_hi << 32);
+
+	/*
+	 * On some sick chips APSIZE is 0. This means it wants 4G
+	 * so let double check that order, and lets trust the AMD NB settings
+	 */
+	if (order >=0 && aper + (32ULL<<(20 + order)) > 0x100000000ULL) {
+		printk(KERN_INFO "Aperture size %u MB is not right, using settings from NB\n",
+				  32 << order);
+		order = nb_order;
+	}
+
 	printk(KERN_INFO PFX "Aperture from AGP @ %Lx size %u MB\n", aper, 32 << order);
 	if (order < 0 || !aperture_valid(aper, (32*1024*1024)<<order))
 		return -1;
diff --git a/include/asm-x86/gart.h b/include/asm-x86/gart.h
index 90958ed..248e577 100644
--- a/include/asm-x86/gart.h
+++ b/include/asm-x86/gart.h
@@ -5,6 +5,7 @@ extern void pci_iommu_shutdown(void);
 extern void no_iommu_init(void);
 extern int force_iommu, no_iommu;
 extern int iommu_detected;
+extern int agp_amd64_init(void);
 #ifdef CONFIG_GART_IOMMU
 extern void gart_iommu_init(void);
 extern void gart_iommu_shutdown(void);
@@ -31,4 +32,24 @@ static inline void gart_iommu_shutdown(void)
 
 #endif
 
+/* PTE bits. */
+#define GPTE_VALID	1
+#define GPTE_COHERENT	2
+
+/* Aperture control register bits. */
+#define GARTEN		(1<<0)
+#define DISGARTCPU	(1<<4)
+#define DISGARTIO	(1<<5)
+
+/* GART cache control register bits. */
+#define INVGART		(1<<0)
+#define GARTPTEERR	(1<<1)
+
+/* K8 On-cpu GART registers */
+#define AMD64_GARTAPERTURECTL	0x90
+#define AMD64_GARTAPERTUREBASE	0x94
+#define AMD64_GARTTABLEBASE	0x98
+#define AMD64_GARTCACHECTL	0x9c
+#define AMD64_GARTEN		(1<<0)
+
 #endif

