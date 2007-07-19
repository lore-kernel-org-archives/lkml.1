Return-Path: <linux-kernel-owner+w=401wt.eu-S937977AbXGSNvz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937977AbXGSNvz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 09:51:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935104AbXGSNsj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 09:48:39 -0400
Received: from cantor.suse.de ([195.135.220.2]:54516 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932592AbXGSNsg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 09:48:36 -0400
From: Andi Kleen <ak@suse.de>
References: <20070719348.540885000@suse.de>
In-Reply-To: <20070719348.540885000@suse.de>
To: wli@holomorphy.com, lkml@rtr.ca, ak@suse.de, linux-kernel@vger.kernel.org
Subject: [PATCH for review] [7/48] i386: divorce CONFIG_X86_PAE from CONFIG_HIGHMEM64G
Message-Id: <20070719134836.0C54214E6E@wotan.suse.de>
Date: Thu, 19 Jul 2007 15:48:36 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


From: William Lee Irwin III <wli@holomorphy.com>

PAE is useful for more than supporting more than 4GB RAM.  It supports
expanded swapspace and NX executable protections.  Some users may want NX
or expanded swapspace support without the overhead or instability of
highmem.  For these reasons, the following patch divorces CONFIG_X86_PAE
from CONFIG_HIGHMEM64G.

Cc: Mark Lord <lkml@rtr.ca>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: William Irwin <wli@holomorphy.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Andi Kleen <ak@suse.de>

---

 arch/i386/Kconfig        |   16 +++++++++++-----
 arch/i386/kernel/setup.c |    8 ++++----
 2 files changed, 15 insertions(+), 9 deletions(-)

Index: linux/arch/i386/Kconfig
===================================================================
--- linux.orig/arch/i386/Kconfig
+++ linux/arch/i386/Kconfig
@@ -544,6 +544,7 @@ config HIGHMEM4G
 config HIGHMEM64G
 	bool "64GB"
 	depends on !M386 && !M486
+	select X86_PAE
 	help
 	  Select this if you have a 32-bit processor and more than 4
 	  gigabytes of physical RAM.
@@ -573,12 +574,12 @@ choice
 	config VMSPLIT_3G
 		bool "3G/1G user/kernel split"
 	config VMSPLIT_3G_OPT
-		depends on !HIGHMEM
+		depends on !X86_PAE
 		bool "3G/1G user/kernel split (for full 1G low memory)"
 	config VMSPLIT_2G
 		bool "2G/2G user/kernel split"
 	config VMSPLIT_2G_OPT
-		depends on !HIGHMEM
+		depends on !X86_PAE
 		bool "2G/2G user/kernel split (for full 2G low memory)"
 	config VMSPLIT_1G
 		bool "1G/3G user/kernel split"
@@ -598,10 +599,15 @@ config HIGHMEM
 	default y
 
 config X86_PAE
-	bool
-	depends on HIGHMEM64G
-	default y
+	bool "PAE (Physical Address Extension) Support"
+	default n
+	depends on !HIGHMEM4G
 	select RESOURCES_64BIT
+	help
+	  PAE is required for NX support, and furthermore enables
+	  larger swapspace support for non-overcommit purposes. It
+	  has the cost of more pagetable lookup overhead, and also
+	  consumes more pagetable space per process.
 
 # Common NUMA Features
 config NUMA
Index: linux/arch/i386/kernel/setup.c
===================================================================
--- linux.orig/arch/i386/kernel/setup.c
+++ linux/arch/i386/kernel/setup.c
@@ -273,18 +273,18 @@ unsigned long __init find_max_low_pfn(vo
 		printk(KERN_WARNING "Warning only %ldMB will be used.\n",
 					MAXMEM>>20);
 		if (max_pfn > MAX_NONPAE_PFN)
-			printk(KERN_WARNING "Use a PAE enabled kernel.\n");
+			printk(KERN_WARNING "Use a HIGHMEM64G enabled kernel.\n");
 		else
 			printk(KERN_WARNING "Use a HIGHMEM enabled kernel.\n");
 		max_pfn = MAXMEM_PFN;
 #else /* !CONFIG_HIGHMEM */
-#ifndef CONFIG_X86_PAE
+#ifndef CONFIG_HIGHMEM64G
 		if (max_pfn > MAX_NONPAE_PFN) {
 			max_pfn = MAX_NONPAE_PFN;
 			printk(KERN_WARNING "Warning only 4GB will be used.\n");
-			printk(KERN_WARNING "Use a PAE enabled kernel.\n");
+			printk(KERN_WARNING "Use a HIGHMEM64G enabled kernel.\n");
 		}
-#endif /* !CONFIG_X86_PAE */
+#endif /* !CONFIG_HIGHMEM64G */
 #endif /* !CONFIG_HIGHMEM */
 	} else {
 		if (highmem_pages == -1)
