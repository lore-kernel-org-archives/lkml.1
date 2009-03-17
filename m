Return-Path: <linux-kernel-owner+w=401wt.eu-S1761298AbZCQCYE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761298AbZCQCYE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Mar 2009 22:24:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754087AbZCQCXw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Mar 2009 22:23:52 -0400
Received: from hera.kernel.org ([140.211.167.34]:34130 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752087AbZCQCXw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Mar 2009 22:23:52 -0400
Message-ID: <49BF0978.40605@kernel.org>
Date: Mon, 16 Mar 2009 19:22:48 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>, Jeremy Fitzhardinge <jeremy@goop.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: {PATCH] x86: print out initial max_pfn_mapped
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Impact: more debug info

check range that is mapped before init_memory_mapping().
also make 64bit have max_pfn_mapped assigned before that calling

Signed-off-by: Yinghai Lu <yinghai@kernel.org>

---
 arch/x86/kernel/setup.c |    3 +++
 arch/x86/mm/init.c      |    7 +++----
 2 files changed, 6 insertions(+), 4 deletions(-)

Index: linux-2.6/arch/x86/kernel/setup.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/setup.c
+++ linux-2.6/arch/x86/kernel/setup.c
@@ -836,12 +836,15 @@ void __init setup_arch(char **cmdline_p)
 		max_low_pfn = max_pfn;
 
 	high_memory = (void *)__va(max_pfn * PAGE_SIZE - 1) + 1;
+	max_pfn_mapped = KERNEL_IMAGE_SIZE >> PAGE_SHIFT;
 #endif
 
 #ifdef CONFIG_X86_CHECK_BIOS_CORRUPTION
 	setup_bios_corruption_check();
 #endif
 
+	printk(KERN_DEBUG "initial memory mapped %lx\n", max_pfn_mapped<<PAGE_SHIFT);
+
 	/* max_pfn_mapped is updated here */
 	max_low_pfn_mapped = init_memory_mapping(0, max_low_pfn<<PAGE_SHIFT);
 	max_pfn_mapped = max_low_pfn_mapped;
Index: linux-2.6/arch/x86/mm/init.c
===================================================================
--- linux-2.6.orig/arch/x86/mm/init.c
+++ linux-2.6/arch/x86/mm/init.c
@@ -65,12 +65,11 @@ static void __init find_early_table_spac
 	 */
 #ifdef CONFIG_X86_32
 	start = 0x7000;
-	e820_table_start = find_e820_area(start, max_pfn_mapped<<PAGE_SHIFT,
-					tables, PAGE_SIZE);
-#else /* CONFIG_X86_64 */
+#else
 	start = 0x8000;
-	e820_table_start = find_e820_area(start, end, tables, PAGE_SIZE);
 #endif
+	e820_table_start = find_e820_area(start, max_pfn_mapped<<PAGE_SHIFT,
+					tables, PAGE_SIZE);
 	if (e820_table_start == -1UL)
 		panic("Cannot find space for the kernel page tables");
 
