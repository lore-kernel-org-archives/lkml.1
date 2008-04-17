Return-Path: <linux-kernel-owner+w=401wt.eu-S1756438AbYDQAoo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756438AbYDQAoo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2008 20:44:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753511AbYDQAof
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Apr 2008 20:44:35 -0400
Received: from wx-out-0506.google.com ([66.249.82.232]:65381 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751699AbYDQAoe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2008 20:44:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=reply-to:to:subject:date:user-agent:cc:mime-version:content-type:content-transfer-encoding:content-disposition:message-id:from;
        b=WSCcGMwwO287oYs8Wa0OwQcaAzUJIS7u4/J9KJqY3wkcnWmeFvFCOoBrN8Tay5h4tCkkQUPfEsJBlTvB1Qy1gigDN3sIiGzQow6ZD9iq6kJX1douzbgv3KDKeGRoOkWu1c6+CNoZYkQXbDiQ5Cy+/niTpM1MySnAIs3YtwASxRw=
Reply-To: yhlu.kernel@gmail.com
To: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH] x86_64: clean up aperture_64.c
Date: Wed, 16 Apr 2008 17:44:13 -0700
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200804161744.13340.yhlu.kernel@gmail.com>
From: Yinghai Lu <yhlu.kernel.send@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


1. use symbolic register names where appropriate.
2. num to bus or slot changing
3. handle for new opteron for bus other than 0

Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>

Index: linux-2.6/arch/x86/kernel/aperture_64.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/aperture_64.c
+++ linux-2.6/arch/x86/kernel/aperture_64.c
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
@@ -120,33 +132,33 @@ static int __init aperture_valid(u64 ape
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
@@ -155,8 +167,8 @@ static __u32 __init read_agp(int num, in
 	u64 aper;
 	u32 old_order;
 
-	printk(KERN_INFO "AGP bridge at %02x:%02x:%02x\n", num, slot, func);
-	apsizereg = read_pci_config_16(num, slot, func, cap + 0x14);
+	printk(KERN_INFO "AGP bridge at %02x:%02x:%02x\n", bus, slot, func);
+	apsizereg = read_pci_config_16(bus, slot, func, cap + 0x14);
 	if (apsizereg == 0xffffffff) {
 		printk(KERN_ERR "APSIZE in AGP bridge unreadable\n");
 		return 0;
@@ -174,8 +186,8 @@ static __u32 __init read_agp(int num, in
 	if ((int)*order < 0) /* < 32MB */
 		*order = 0;
 
-	aper_low = read_pci_config(num, slot, func, 0x10);
-	aper_hi = read_pci_config(num, slot, func, 0x14);
+	aper_low = read_pci_config(bus, slot, func, 0x10);
+	aper_hi = read_pci_config(bus, slot, func, 0x14);
 	aper = (aper_low & ~((1<<22)-1)) | ((u64)aper_hi << 32);
 
 	/*
@@ -213,15 +225,15 @@ static __u32 __init read_agp(int num, in
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
@@ -230,17 +242,17 @@ static __u32 __init search_agp_bridge(u3
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
@@ -280,38 +292,49 @@ void __init early_gart_iommu_check(void)
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
 
@@ -330,13 +353,22 @@ void __init early_gart_iommu_check(void)
 	}
 
 	/* different nodes have different setting, disable them all at first*/
-	for (num = 24; num < 32; num++) {
-		if (!early_is_k8_nb(read_pci_config(0, num, 3, 0x00)))
-			continue;
-
-		ctl = read_pci_config(0, num, 3, 0x90);
-		ctl &= ~1;
-		write_pci_config(0, num, 3, 0x90, ctl);
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
+			ctl &= ~AMD64_GARTEN;
+			write_pci_config(bus, slot, 3, AMD64_GARTAPERTURECTL, ctl);
+		}
 	}
 
 }
@@ -348,8 +380,8 @@ void __init gart_iommu_hole_init(void)
 	u32 agp_aper_base = 0, agp_aper_order = 0;
 	u32 aper_size, aper_alloc = 0, aper_order = 0, last_aper_order = 0;
 	u64 aper_base, last_aper_base = 0;
-	int fix, num, valid_agp = 0;
-	int node;
+	int fix, slot, valid_agp = 0;
+	int i, node;
 
 	if (gart_iommu_aperture_disabled || !fix_aperture ||
 	    !early_pci_allowed())
@@ -362,48 +394,58 @@ void __init gart_iommu_hole_init(void)
 
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
-		if (!aperture_valid(aper_base, aper_size, 64<<20)) {
-			if (valid_agp && agp_aper_base &&
-			    agp_aper_base == aper_base &&
-			    agp_aper_order == aper_order) {
-				/* the same between two setting from NB and agp */
-				if (!no_iommu && end_pfn > MAX_DMA32_PFN && !printed_gart_size_msg) {
-					printk(KERN_ERR "you are using iommu with agp, but GART size is less than 64M\n");
-					printk(KERN_ERR "please increase GART size in your BIOS setup\n");
-					printk(KERN_ERR "if BIOS doesn't have that option, contact your HW vendor!\n");
-					printed_gart_size_msg = 1;
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
 				}
-			} else {
-				fix = 1;
-				break;
 			}
-		}
 
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
@@ -452,16 +494,22 @@ void __init gart_iommu_hole_init(void)
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
