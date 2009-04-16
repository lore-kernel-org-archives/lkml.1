Return-Path: <linux-kernel-owner+w=401wt.eu-S1754676AbZDPUP3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754676AbZDPUP3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Apr 2009 16:15:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752210AbZDPUPM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Apr 2009 16:15:12 -0400
Received: from hera.kernel.org ([140.211.167.34]:59303 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751830AbZDPUPK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Apr 2009 16:15:10 -0400
Message-ID: <49E7916C.7050701@kernel.org>
Date: Thu, 16 Apr 2009 13:13:32 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       "H. Peter Anvin" <hpa@zytor.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       linux-pci@vger.kernel.org, yannick.roehlly@free.fr
Subject: [PATCH] x86/pci: make pci_mem_start to be aligned only -v4
References: <49E00E9F.8030605@kernel.org> <49E4F6D6.6030709@kernel.org> <49E4F71F.10107@kernel.org> <alpine.LFD.2.00.0904141359020.18124@localhost.localdomain> <49E52A7A.4070607@kernel.org> <49E52D3F.1090206@kernel.org> <20090416093152.6605612d@hobbes> <alpine.LFD.2.00.0904160938090.4042@localhost.localdomain> <20090416165640.GA13927@elte.hu> <49E76864.9060309@kernel.org> <20090416172803.GB16618@elte.hu>
In-Reply-To: <20090416172803.GB16618@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

please check.

[PATCH] x86/pci: make pci_mem_start to be aligned only -v4

Impact: make more big space below 4g for assigning to unassigned pci devices

don't need to reserved one round after the gapstart.

v2: Linus said: "
	We've definitely seen ACPI code or integrated graphics stuff 
	that steals a lot of memory at the end, which means that end-of-RAM might 
	be not at 2GB, but at 2GB-16MB-1MB, for example (1MB of "ACPI data", and 
	16MB of "stolen video ram").

	At a minimum, if we do this, I'd like to make sure we round up to a big 
	boundary (eg 32MB or something - exactly because a missing 16MB can easily 
	be some integrated stolen video memory).

	Sure, we do that whole

		while ((gapsize >> 4) > round)
			round += round;

	thing, so that if the gap is large, then we'll certainly get to 32MB too, 
	but I think your patch matters the most exactly when the gap is small. 
	Maybe we could just raise the initial minimum rounding from 1MB to 32MB?
	...
	Alternatively, maybe we can make sure that we round up to at least X bytes
	from the end of RAM, and to at least Y bytes from the end of some RESERVED 
	thing."
v3: take pci_mem_start - low_top_ram bigger than half around, aka 16M at least
v4: try to check e820 early to see if we need reserve stolen RAM.
	and only do one simple round up in e820_setup_gap

Reported-and-tested-by: Yannick <yannick.roehlly@free.fr>
Signed-off-by: Yinghai Lu <yinghai@kernel.org>

---
 arch/x86/include/asm/e820.h |    1 
 arch/x86/kernel/e820.c      |   54 ++++++++++++++++++++++++++++++++++++++------
 arch/x86/kernel/setup.c     |    6 ++++
 3 files changed, 54 insertions(+), 7 deletions(-)

Index: linux-2.6/arch/x86/kernel/e820.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/e820.c
+++ linux-2.6/arch/x86/kernel/e820.c
@@ -636,13 +636,11 @@ __init void e820_setup_gap(void)
 
 	/*
 	 * See how much we want to round up: start off with
-	 * rounding to the next 1MB area.
+	 * rounding to the next 32MB area.
 	 */
-	round = 0x100000;
-	while ((gapsize >> 4) > round)
-		round += round;
-	/* Fun with two's complement */
-	pci_mem_start = (gapstart + round) & -round;
+	round = 0x2000000;
+
+	pci_mem_start = roundup(gapstart, round);
 
 	printk(KERN_INFO
 	       "Allocating PCI resources starting at %lx (gap: %lx:%lx)\n",
@@ -1143,7 +1141,9 @@ static unsigned long __init e820_end_pfn
 	if (last_pfn > max_arch_pfn)
 		last_pfn = max_arch_pfn;
 
-	printk(KERN_INFO "last_pfn = %#lx max_arch_pfn = %#lx\n",
+	printk(KERN_INFO "limit_pfn = %#lx ", limit_pfn);
+	e820_print_type(type);
+	printk(KERN_CONT " last_pfn = %#lx max_arch_pfn = %#lx\n",
 			 last_pfn, max_arch_pfn);
 	return last_pfn;
 }
@@ -1314,6 +1314,46 @@ void __init finish_e820_parsing(void)
 	}
 }
 
+static unsigned long __init real_end(unsigned long low_top_ram,
+				       unsigned long round,
+				       unsigned long real_end_ram, int type)
+{
+	unsigned long low_top_x;
+	unsigned long end_x;
+
+	low_top_x = e820_end_pfn((low_top_ram + round)>>PAGE_SHIFT, type)
+			 << PAGE_SHIFT;
+	end_x = roundup(low_top_x, round);
+	if (end_x > real_end_ram)
+		real_end_ram = end_x;
+
+	return real_end_ram;
+}
+
+void __init e820_reserve_stolen_range(void)
+{
+	unsigned long round;
+	unsigned long low_top_ram;
+	unsigned long real_end_ram;
+
+	/* 32M is enough ?*/
+	round = 0x2000000;
+	low_top_ram = e820_end_of_low_ram_pfn() << PAGE_SHIFT;
+	real_end_ram = roundup(low_top_ram, round);
+	if (low_top_ram == real_end_ram)
+		return;
+
+	real_end_ram = real_end(low_top_ram, round, real_end_ram,
+				 E820_RESERVED);
+	real_end_ram = real_end(low_top_ram, round, real_end_ram, E820_ACPI);
+	real_end_ram = real_end(low_top_ram, round, real_end_ram, E820_NVS);
+
+	e820_add_region(low_top_ram, real_end_ram - low_top_ram, E820_RESERVED);
+	sanitize_e820_map(e820.map, ARRAY_SIZE(e820.map), &e820.nr_map);
+	printk(KERN_INFO "fixed physical RAM map:\n");
+	e820_print_map("reserve_stolen_range");
+}
+
 static inline const char *e820_type_to_string(int e820_type)
 {
 	switch (e820_type) {
Index: linux-2.6/arch/x86/include/asm/e820.h
===================================================================
--- linux-2.6.orig/arch/x86/include/asm/e820.h
+++ linux-2.6/arch/x86/include/asm/e820.h
@@ -78,6 +78,7 @@ extern u64 e820_update_range(u64 start,
 extern u64 e820_remove_range(u64 start, u64 size, unsigned old_type,
 			     int checktype);
 extern void update_e820(void);
+extern void e820_reserve_stolen_range(void);
 extern void e820_setup_gap(void);
 extern int e820_search_gap(unsigned long *gapstart, unsigned long *gapsize,
 			unsigned long start_addr, unsigned long long end_addr);
Index: linux-2.6/arch/x86/kernel/setup.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/setup.c
+++ linux-2.6/arch/x86/kernel/setup.c
@@ -812,6 +812,12 @@ void __init setup_arch(char **cmdline_p)
 	insert_resource(&iomem_resource, &data_resource);
 	insert_resource(&iomem_resource, &bss_resource);
 
+	/*
+	 * some systems use end of ram to for acpi or video ram
+	 * but doesn't state that in reserved in e820
+	 * try to round of ram etc and reserve them
+	 */
+	e820_reserve_stolen_range();
 
 #ifdef CONFIG_X86_32
 	if (ppro_with_ram_bug()) {
