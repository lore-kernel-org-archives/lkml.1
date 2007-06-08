Return-Path: <linux-kernel-owner+w=401wt.eu-S967316AbXFHCeq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967316AbXFHCeq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2007 22:34:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964987AbXFHCei
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jun 2007 22:34:38 -0400
Received: from holomorphy.com ([66.93.40.71]:39205 "EHLO holomorphy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751427AbXFHCei (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2007 22:34:38 -0400
Date: Thu, 7 Jun 2007 19:35:51 -0700
From: William Lee Irwin III <wli@holomorphy.com>
To: linux-kernel@vger.kernel.org
Cc: Mark Lord <lkml@rtr.ca>, Andi Kleen <ak@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: divorce CONFIG_X86_PAE from CONFIG_HIGHMEM64G
Message-ID: <20070608023551.GJ15426@holomorphy.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Organization: The Domain of Holomorphy
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

PAE is useful for more than supporting more than 4GB RAM. It supports
expanded swapspace and NX executable protections. Some users may want
NX or expanded swapspace support without the overhead or instability
of highmem. For these reasons, the following patch divorces
CONFIG_X86_PAE from CONFIG_HIGHMEM64G.

vs. 2.6.22-rc4-mm2

Cc: Mark Lord <lkml@rtr.ca>
Cc: Andi Kleen <ak@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: William Irwin <wli@holomorphy.com>


Index: mm-2.6.22-rc4-2/arch/i386/Kconfig
===================================================================
--- mm-2.6.22-rc4-2.orig/arch/i386/Kconfig	2007-06-07 00:05:53.609599701 -0700
+++ mm-2.6.22-rc4-2/arch/i386/Kconfig	2007-06-07 17:02:24.333262965 -0700
@@ -544,6 +544,7 @@
 config HIGHMEM64G
 	bool "64GB"
 	depends on X86_CMPXCHG64
+	select X86_PAE
 	help
 	  Select this if you have a 32-bit processor and more than 4
 	  gigabytes of physical RAM.
@@ -573,12 +574,12 @@
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
@@ -598,10 +599,15 @@
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
Index: mm-2.6.22-rc4-2/arch/i386/kernel/setup.c
===================================================================
--- mm-2.6.22-rc4-2.orig/arch/i386/kernel/setup.c	2007-06-06 23:52:18.839168580 -0700
+++ mm-2.6.22-rc4-2/arch/i386/kernel/setup.c	2007-06-07 17:02:24.349263876 -0700
@@ -273,18 +273,18 @@
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
