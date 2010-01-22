Return-Path: <linux-kernel-owner+w=401wt.eu-S1755833Ab0AVDas@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755833Ab0AVDas (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jan 2010 22:30:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932161Ab0AVDaj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jan 2010 22:30:39 -0500
Received: from mga03.intel.com ([143.182.124.21]:51569 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755781Ab0AVDag (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jan 2010 22:30:36 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.47,316,1257148800"; 
   d="scan'208";a="235568028"
Message-Id: <20100122033004.335813103@intel.com>
User-Agent: quilt/0.48-1
Date: Fri, 22 Jan 2010 11:21:04 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
cc: Andrew Morton <akpm@linux-foundation.org>, Yinghai Lu <yinghai@kernel.org>
To: Thomas Gleixner <tglx@linutronix.de>
To: Ingo Molnar <mingo@redhat.com>
To: "H. Peter Anvin" <hpa@zytor.com>
cc: x86@kernel.org
Cc: Wu Fengguang <fengguang.wu@intel.com>, LKML <linux-kernel@vger.kernel.org>
cc: Andi Kleen <andi@firstfloor.org>, shaohui.zheng@intel.com,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: [PATCH 2/3] x86: remove bios data range from e820
References: <20100122032102.137106635@intel.com>
Content-Disposition: inline; filename=remove_bios_begin_end.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Yinghai Lu <yinghai@kernel.org>

To prepare move page_is_ram() as generic one.

Tested-by: Wu Fengguang <fengguang.wu@intel.com>
Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 arch/x86/kernel/e820.c  |    8 ++++++++
 arch/x86/kernel/setup.c |   19 ++++++++++++++++++-
 arch/x86/mm/ioremap.c   |   16 ----------------
 3 files changed, 26 insertions(+), 17 deletions(-)

--- linux-mm.orig/arch/x86/kernel/setup.c	2010-01-22 11:20:33.000000000 +0800
+++ linux-mm/arch/x86/kernel/setup.c	2010-01-22 11:20:37.000000000 +0800
@@ -659,6 +659,23 @@ static struct dmi_system_id __initdata b
 	{}
 };
 
+static void __init trim_bios_range(void)
+{
+	/*
+	 * A special case is the first 4Kb of memory;
+	 * This is a BIOS owned area, not kernel ram, but generally
+	 * not listed as such in the E820 table.
+	 */
+	e820_update_range(0, PAGE_SIZE, E820_RAM, E820_RESERVED);
+	/*
+	 * special case: Some BIOSen report the PC BIOS
+	 * area (640->1Mb) as ram even though it is not.
+	 * take them out.
+	 */
+	e820_remove_range(BIOS_BEGIN, BIOS_END - BIOS_BEGIN, E820_RAM, 1);
+	sanitize_e820_map(e820.map, ARRAY_SIZE(e820.map), &e820.nr_map);
+}
+
 /*
  * Determine if we were loaded by an EFI loader.  If so, then we have also been
  * passed the efi memmap, systab, etc., so we should use these data structures
@@ -822,7 +839,7 @@ void __init setup_arch(char **cmdline_p)
 	insert_resource(&iomem_resource, &data_resource);
 	insert_resource(&iomem_resource, &bss_resource);
 
-
+	trim_bios_range();
 #ifdef CONFIG_X86_32
 	if (ppro_with_ram_bug()) {
 		e820_update_range(0x70000000ULL, 0x40000ULL, E820_RAM,
--- linux-mm.orig/arch/x86/kernel/e820.c	2010-01-22 11:20:33.000000000 +0800
+++ linux-mm/arch/x86/kernel/e820.c	2010-01-22 11:20:37.000000000 +0800
@@ -517,11 +517,19 @@ u64 __init e820_remove_range(u64 start, 
 			     int checktype)
 {
 	int i;
+	u64 end;
 	u64 real_removed_size = 0;
 
 	if (size > (ULLONG_MAX - start))
 		size = ULLONG_MAX - start;
 
+	end = start + size;
+	printk(KERN_DEBUG "e820 remove range: %016Lx - %016Lx ",
+		       (unsigned long long) start,
+		       (unsigned long long) end);
+	e820_print_type(old_type);
+	printk(KERN_CONT "\n");
+
 	for (i = 0; i < e820.nr_map; i++) {
 		struct e820entry *ei = &e820.map[i];
 		u64 final_start, final_end;
--- linux-mm.orig/arch/x86/mm/ioremap.c	2010-01-22 11:20:33.000000000 +0800
+++ linux-mm/arch/x86/mm/ioremap.c	2010-01-22 11:20:37.000000000 +0800
@@ -29,22 +29,6 @@ int page_is_ram(unsigned long pagenr)
 	resource_size_t addr, end;
 	int i;
 
-	/*
-	 * A special case is the first 4Kb of memory;
-	 * This is a BIOS owned area, not kernel ram, but generally
-	 * not listed as such in the E820 table.
-	 */
-	if (pagenr == 0)
-		return 0;
-
-	/*
-	 * Second special case: Some BIOSen report the PC BIOS
-	 * area (640->1Mb) as ram even though it is not.
-	 */
-	if (pagenr >= (BIOS_BEGIN >> PAGE_SHIFT) &&
-		    pagenr < (BIOS_END >> PAGE_SHIFT))
-		return 0;
-
 	for (i = 0; i < e820.nr_map; i++) {
 		/*
 		 * Not usable memory:


