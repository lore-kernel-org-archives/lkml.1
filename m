Return-Path: <linux-kernel-owner+w=401wt.eu-S1757181AbYGHXIs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757181AbYGHXIs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2008 19:08:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754341AbYGHXIj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jul 2008 19:08:39 -0400
Received: from mga02.intel.com ([134.134.136.20]:64581 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754290AbYGHXIj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2008 19:08:39 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.30,326,1212390000"; 
   d="scan'208";a="406843894"
Date: Tue, 8 Jul 2008 16:08:37 -0700
From: Suresh Siddha <suresh.b.siddha@intel.com>
To: mingo@elte.hu, hpa@zytor.com, tglx@linutronix.de
Cc: linux-kernel@vger.kernel.org, yhlu.kernel@gmail.com
Subject: [patch] tip/x86_64: fix e820 merge issue which broke max_pfn_mapped
Message-ID: <20080708230837.GD1678@linux-os.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With out this 64bit tip/master doesn't boot using ACPI on my system.
---
 
max_pfn_mapped should include all e820 entries.
The direct mapping extends to max_pfn_mapped, so that we can directly access
apertures, ACPI and other tables without having to play with fixmaps.

With this, my system with 1GB memory boots fine with ACPI enabled.

Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
---

Index: tree-x86/arch/x86/kernel/e820.c
===================================================================
--- tree-x86.orig/arch/x86/kernel/e820.c	2008-07-08 15:31:24.000000000 -0700
+++ tree-x86/arch/x86/kernel/e820.c	2008-07-08 15:55:09.000000000 -0700
@@ -1040,6 +1040,10 @@
 
 	if (last_pfn > max_arch_pfn)
 		last_pfn = max_arch_pfn;
+#ifdef CONFIG_X86_64
+	if (last_pfn > max_pfn_mapped)
+		max_pfn_mapped = last_pfn;
+#endif
 	if (last_pfn > end_user_pfn)
 		last_pfn = end_user_pfn;
 
@@ -1067,6 +1071,12 @@
 	if (*ei_startpfn >= *ei_endpfn)
 		return 0;
 
+#ifdef CONFIG_X86_64
+	/* Check if max_pfn_mapped should be updated */
+	if (ei->type != E820_RAM && *ei_endpfn > max_pfn_mapped)
+		max_pfn_mapped = *ei_endpfn;
+#endif
+
 	/* Skip if map is outside the node */
 	if (ei->type != E820_RAM || *ei_endpfn <= start_pfn ||
 				    *ei_startpfn >= last_pfn)
Index: tree-x86/arch/x86/kernel/setup.c
===================================================================
--- tree-x86.orig/arch/x86/kernel/setup.c	2008-07-08 15:33:42.000000000 -0700
+++ tree-x86/arch/x86/kernel/setup.c	2008-07-08 15:33:49.000000000 -0700
@@ -722,8 +722,12 @@
 	high_memory = (void *)__va(max_pfn * PAGE_SIZE - 1) + 1;
 #endif
 
+#ifdef CONFIG_X86_32
 	/* max_pfn_mapped is updated here */
 	max_pfn_mapped = init_memory_mapping(0, (max_low_pfn << PAGE_SHIFT));
+#else
+	max_pfn_mapped = init_memory_mapping(0, (max_pfn_mapped << PAGE_SHIFT));
+#endif
 
 	/*
 	 * NOTE: On x86-32, only from this point on, fixmaps are ready for use.
