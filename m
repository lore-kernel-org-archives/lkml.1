Return-Path: <linux-kernel-owner+w=401wt.eu-S1755974AbZKWBUO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755974AbZKWBUO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Nov 2009 20:20:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755630AbZKWBUN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Nov 2009 20:20:13 -0500
Received: from hera.kernel.org ([140.211.167.34]:39071 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754065AbZKWBUM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Nov 2009 20:20:12 -0500
Message-ID: <4B09E2F9.7040403@kernel.org>
Date: Sun, 22 Nov 2009 17:18:49 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH] x86: crash kernel reserve with reserve_early -v2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


use find_e820_area/reserve_early instead.

-v2: address Eric's request, to restore original semantics.
     will fail, if the provided address can not be used.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 arch/x86/kernel/setup.c |   57 ++++++++++++------------------------------------
 1 file changed, 15 insertions(+), 42 deletions(-)

Index: linux-2.6/arch/x86/kernel/setup.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/setup.c
+++ linux-2.6/arch/x86/kernel/setup.c
@@ -488,42 +488,11 @@ static void __init reserve_early_setup_d
 
 #ifdef CONFIG_KEXEC
 
-/**
- * Reserve @size bytes of crashkernel memory at any suitable offset.
- *
- * @size: Size of the crashkernel memory to reserve.
- * Returns the base address on success, and -1ULL on failure.
- */
-static
-unsigned long long __init find_and_reserve_crashkernel(unsigned long long size)
-{
-	const unsigned long long alignment = 16<<20; 	/* 16M */
-	unsigned long long start = 0LL;
-
-	while (1) {
-		int ret;
-
-		start = find_e820_area(start, ULONG_MAX, size, alignment);
-		if (start == -1ULL)
-			return start;
-
-		/* try to reserve it */
-		ret = reserve_bootmem_generic(start, size, BOOTMEM_EXCLUSIVE);
-		if (ret >= 0)
-			return start;
-
-		start += alignment;
-	}
-}
-
 static inline unsigned long long get_total_mem(void)
 {
 	unsigned long long total;
 
-	total = max_low_pfn - min_low_pfn;
-#ifdef CONFIG_HIGHMEM
-	total += highend_pfn - highstart_pfn;
-#endif
+	total = max_pfn - min_low_pfn;
 
 	return total << PAGE_SHIFT;
 }
@@ -543,21 +512,25 @@ static void __init reserve_crashkernel(v
 
 	/* 0 means: find the address automatically */
 	if (crash_base <= 0) {
-		crash_base = find_and_reserve_crashkernel(crash_size);
+		const unsigned long long alignment = 16<<20;	/* 16M */
+
+		crash_base = find_e820_area(alignment, ULONG_MAX, crash_size,
+				 alignment);
 		if (crash_base == -1ULL) {
-			pr_info("crashkernel reservation failed. "
-				"No suitable area found.\n");
+			pr_info("crashkernel reservation failed - No suitable area found.\n");
 			return;
 		}
 	} else {
-		ret = reserve_bootmem_generic(crash_base, crash_size,
-					BOOTMEM_EXCLUSIVE);
-		if (ret < 0) {
-			pr_info("crashkernel reservation failed - "
-				"memory is in use\n");
+		unsigned long long start;
+
+		start = find_e820_area(crash_base, ULONG_MAX, crash_size,
+				 1<<20);
+		if (start != crash_base) {
+			pr_info("crashkernel reservation failed - memory is in use.\n");
 			return;
 		}
 	}
+	reserve_early(crash_base, crash_base + crash_size, "CRASH KERNEL");
 
 	printk(KERN_INFO "Reserving %ldMB of memory at %ldMB "
 			"for crashkernel (System RAM: %ldMB)\n",
@@ -935,6 +908,8 @@ void __init setup_arch(char **cmdline_p)
 
 	reserve_initrd();
 
+	reserve_crashkernel();
+
 	vsmp_init();
 
 	io_delay_init();
@@ -965,8 +940,6 @@ void __init setup_arch(char **cmdline_p)
 
 	initmem_init(0, max_pfn, acpi, k8);
 
-	reserve_crashkernel();
-
 #ifdef CONFIG_X86_64
 	/*
 	 * dma32_reserve_bootmem() allocates bootmem which may conflict
