Return-Path: <linux-kernel-owner+w=401wt.eu-S1759406AbYDDM7s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759406AbYDDM7s (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2008 08:59:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759889AbYDDMzc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Apr 2008 08:55:32 -0400
Received: from saeurebad.de ([85.214.36.134]:44728 "EHLO saeurebad.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759083AbYDDMza (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2008 08:55:30 -0400
X-Mailbox-Line: From hannes@skyscraper.fehenstaub.lan Fri Apr  4 13:52:30 2008
Message-Id: <20080404115230.866692968@skyscraper.fehenstaub.lan>
References: <20080404115137.397502419@skyscraper.fehenstaub.lan>
User-Agent: quilt/0.46-1
Date: Fri, 04 Apr 2008 13:51:39 +0200
From: hannes@saeurebad.de
To: LKML <linux-kernel@vger.kernel.org>
Subject: [patch 02/22 -v2] Generic show_mem() implementation
Content-Disposition: inline; filename=generic-show_mem.patch
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This implements a platform-independent version of show_mem().

Signed-off-by: Johannes Weiner <hannes@saeurebad.de>
---

Note: I added the quicklist_total_size() as `pagetable cache' because
it was the only use case I have found for quicklists, anyway. 

Index: tree-linus/mm/Kconfig
===================================================================
--- tree-linus.orig/mm/Kconfig
+++ tree-linus/mm/Kconfig
@@ -193,3 +193,6 @@ config NR_QUICK
 config VIRT_TO_BUS
 	def_bool y
 	depends on !ARCH_NO_VIRT_TO_BUS
+
+config HAVE_ARCH_SHOW_MEM
+	def_bool n
Index: tree-linus/mm/page_alloc.c
===================================================================
--- tree-linus.orig/mm/page_alloc.c
+++ tree-linus/mm/page_alloc.c
@@ -45,6 +45,7 @@
 #include <linux/fault-inject.h>
 #include <linux/page-isolation.h>
 #include <linux/memcontrol.h>
+#include <linux/nmi.h>
 
 #include <asm/tlbflush.h>
 #include <asm/div64.h>
@@ -1889,6 +1890,60 @@ void show_free_areas(void)
 	show_swap_cache_info();
 }
 
+#ifndef CONFIG_HAVE_ARCH_SHOW_MEM
+void show_mem(void)
+{
+	pg_data_t *pgdat;
+	int total = 0, reserved = 0, shared = 0, nonshared = 0, highmem = 0;
+
+	printk(KERN_INFO "Mem-Info:\n");
+	show_free_areas();
+
+	for_each_online_pgdat(pgdat) {
+		unsigned long i, flags;
+
+		pgdat_resize_lock(pgdat, &flags);
+		for (i = 0; i < pgdat->node_spanned_pages; i++) {
+			struct page *page;
+			unsigned long pfn = pgdat->node_start_pfn + i;
+
+			if (unlikely((i % MAX_ORDER_NR_PAGES) == 0))
+				touch_nmi_watchdog();
+
+			if (!pfn_valid(pfn))
+				continue;
+
+			page = pfn_to_page(pfn);
+
+			if (PageHighMem(page))
+				highmem++;
+
+			if (PageReserved(page))
+				reserved++;
+			else if (page_count(page) == 1)
+				nonshared++;
+			else if (page_count(page) > 1)
+				shared += page_count(page) - 1;
+
+			total++;
+		}
+		pgdat_resize_unlock(pgdat, &flags);
+	}
+
+	printk(KERN_INFO "%d pages RAM\n", total);
+#ifdef CONFIG_HIGHMEM
+	printk(KERN_INFO "%d pages HighMem\n", highmem);
+#endif
+	printk(KERN_INFO "%d pages reserved\n", reserved);
+	printk(KERN_INFO "%d pages shared\n", shared);
+	printk(KERN_INFO "%d pages non-shared\n", nonshared);
+#ifdef CONFIG_QUICKLIST
+	printk(KERN_INFO "%d pages in pagetable cache\n",
+		quicklist_total_size());
+#endif
+}
+#endif /* !CONFIG_HAVE_ARCH_SHOW_MEM */
+
 /*
  * Builds allocation fallback zone lists.
  *
Index: tree-linus/arch/alpha/Kconfig
===================================================================
--- tree-linus.orig/arch/alpha/Kconfig
+++ tree-linus/arch/alpha/Kconfig
@@ -7,6 +7,7 @@ config ALPHA
 	default y
 	select HAVE_IDE
 	select HAVE_OPROFILE
+	select HAVE_ARCH_SHOW_MEM
 	help
 	  The Alpha is a 64-bit general-purpose processor designed and
 	  marketed by the Digital Equipment Corporation of blessed memory,
Index: tree-linus/arch/arm/Kconfig
===================================================================
--- tree-linus.orig/arch/arm/Kconfig
+++ tree-linus/arch/arm/Kconfig
@@ -13,6 +13,7 @@ config ARM
 	select HAVE_OPROFILE
 	select HAVE_KPROBES if (!XIP_KERNEL)
 	select HAVE_KRETPROBES if (HAVE_KPROBES)
+	select HAVE_ARCH_SHOW_MEM
 	help
 	  The ARM series is a line of low-power-consumption RISC chip designs
 	  licensed by ARM Ltd and targeted at embedded applications and
Index: tree-linus/arch/avr32/Kconfig
===================================================================
--- tree-linus.orig/arch/avr32/Kconfig
+++ tree-linus/arch/avr32/Kconfig
@@ -13,6 +13,7 @@ config AVR32
 	select HAVE_IDE
 	select HAVE_OPROFILE
 	select HAVE_KPROBES
+	select HAVE_ARCH_SHOW_MEM
 	help
 	  AVR32 is a high-performance 32-bit RISC microprocessor core,
 	  designed for cost-sensitive embedded applications, with particular
Index: tree-linus/arch/blackfin/Kconfig
===================================================================
--- tree-linus.orig/arch/blackfin/Kconfig
+++ tree-linus/arch/blackfin/Kconfig
@@ -26,6 +26,7 @@ config BLACKFIN
 	default y
 	select HAVE_IDE
 	select HAVE_OPROFILE
+	select HAVE_ARCH_SHOW_MEM
 
 config ZONE_DMA
 	bool
Index: tree-linus/arch/cris/Kconfig
===================================================================
--- tree-linus.orig/arch/cris/Kconfig
+++ tree-linus/arch/cris/Kconfig
@@ -55,6 +55,7 @@ config CRIS
 	bool
 	default y
 	select HAVE_IDE
+	select HAVE_ARCH_SHOW_MEM
 
 config HZ
 	int
Index: tree-linus/arch/frv/Kconfig
===================================================================
--- tree-linus.orig/arch/frv/Kconfig
+++ tree-linus/arch/frv/Kconfig
@@ -6,6 +6,7 @@ config FRV
 	bool
 	default y
 	select HAVE_IDE
+	select HAVE_ARCH_SHOW_MEM
 
 config ZONE_DMA
 	bool
Index: tree-linus/arch/h8300/Kconfig
===================================================================
--- tree-linus.orig/arch/h8300/Kconfig
+++ tree-linus/arch/h8300/Kconfig
@@ -9,6 +9,7 @@ config H8300
 	bool
 	default y
 	select HAVE_IDE
+	select HAVE_ARCH_SHOW_MEM
 
 config MMU
 	bool
Index: tree-linus/arch/ia64/Kconfig
===================================================================
--- tree-linus.orig/arch/ia64/Kconfig
+++ tree-linus/arch/ia64/Kconfig
@@ -19,6 +19,7 @@ config IA64
 	select HAVE_OPROFILE
 	select HAVE_KPROBES
 	select HAVE_KRETPROBES
+	select HAVE_ARCH_SHOW_MEM
 	default y
 	help
 	  The Itanium Processor Family is Intel's 64-bit successor to
Index: tree-linus/arch/m32r/Kconfig
===================================================================
--- tree-linus.orig/arch/m32r/Kconfig
+++ tree-linus/arch/m32r/Kconfig
@@ -10,6 +10,7 @@ config M32R
 	default y
 	select HAVE_IDE
 	select HAVE_OPROFILE
+	select HAVE_ARCH_SHOW_MEM
 
 config SBUS
 	bool
Index: tree-linus/arch/m68k/Kconfig
===================================================================
--- tree-linus.orig/arch/m68k/Kconfig
+++ tree-linus/arch/m68k/Kconfig
@@ -6,6 +6,7 @@ config M68K
 	bool
 	default y
 	select HAVE_IDE
+	select HAVE_ARCH_SHOW_MEM
 
 config MMU
 	bool
Index: tree-linus/arch/m68knommu/Kconfig
===================================================================
--- tree-linus.orig/arch/m68knommu/Kconfig
+++ tree-linus/arch/m68knommu/Kconfig
@@ -9,6 +9,7 @@ config M68K
 	bool
 	default y
 	select HAVE_IDE
+	select HAVE_ARCH_SHOW_MEM
 
 config MMU
 	bool
Index: tree-linus/arch/mips/Kconfig
===================================================================
--- tree-linus.orig/arch/mips/Kconfig
+++ tree-linus/arch/mips/Kconfig
@@ -6,6 +6,7 @@ config MIPS
 	# Horrible source of confusion.  Die, die, die ...
 	select EMBEDDED
 	select RTC_LIB
+	select HAVE_ARCH_SHOW_MEM
 
 mainmenu "Linux/MIPS Kernel Configuration"
 
Index: tree-linus/arch/mn10300/Kconfig
===================================================================
--- tree-linus.orig/arch/mn10300/Kconfig
+++ tree-linus/arch/mn10300/Kconfig
@@ -7,6 +7,7 @@ mainmenu "Linux Kernel Configuration"
 
 config MN10300
 	def_bool y
+	select HAVE_ARCH_SHOW_MEM
 
 config AM33
 	def_bool y
Index: tree-linus/arch/parisc/Kconfig
===================================================================
--- tree-linus.orig/arch/parisc/Kconfig
+++ tree-linus/arch/parisc/Kconfig
@@ -9,6 +9,7 @@ config PARISC
 	def_bool y
 	select HAVE_IDE
 	select HAVE_OPROFILE
+	select HAVE_ARCH_SHOW_MEM
 	help
 	  The PA-RISC microprocessor is designed by Hewlett-Packard and used
 	  in many of their workstations & servers (HP9000 700 and 800 series,
Index: tree-linus/arch/powerpc/Kconfig
===================================================================
--- tree-linus.orig/arch/powerpc/Kconfig
+++ tree-linus/arch/powerpc/Kconfig
@@ -91,6 +91,7 @@ config PPC
 	select HAVE_OPROFILE
 	select HAVE_KPROBES
 	select HAVE_KRETPROBES
+	select HAVE_ARCH_SHOW_MEM
 
 config EARLY_PRINTK
 	bool
Index: tree-linus/arch/ppc/Kconfig
===================================================================
--- tree-linus.orig/arch/ppc/Kconfig
+++ tree-linus/arch/ppc/Kconfig
@@ -45,6 +45,7 @@ config PPC
 	select HAVE_IDE
 	select HAVE_OPROFILE
 	select HAVE_KPROBES
+	select HAVE_ARCH_SHOW_MEM
 
 config PPC32
 	bool
Index: tree-linus/arch/s390/Kconfig
===================================================================
--- tree-linus.orig/arch/s390/Kconfig
+++ tree-linus/arch/s390/Kconfig
@@ -62,6 +62,7 @@ config S390
 	select HAVE_OPROFILE
 	select HAVE_KPROBES
 	select HAVE_KRETPROBES
+	select HAVE_ARCH_SHOW_MEM
 
 source "init/Kconfig"
 
Index: tree-linus/arch/sh/Kconfig
===================================================================
--- tree-linus.orig/arch/sh/Kconfig
+++ tree-linus/arch/sh/Kconfig
@@ -10,6 +10,7 @@ config SUPERH
 	select EMBEDDED
 	select HAVE_IDE
 	select HAVE_OPROFILE
+	select HAVE_ARCH_SHOW_MEM
 	help
 	  The SuperH is a RISC processor targeted for use in embedded systems
 	  and consumer electronics; it was also used in the Sega Dreamcast
Index: tree-linus/arch/sparc/Kconfig
===================================================================
--- tree-linus.orig/arch/sparc/Kconfig
+++ tree-linus/arch/sparc/Kconfig
@@ -71,6 +71,7 @@ config SPARC
 	default y
 	select HAVE_IDE
 	select HAVE_OPROFILE
+	select HAVE_ARCH_SHOW_MEM
 
 # Identify this as a Sparc32 build
 config SPARC32
Index: tree-linus/arch/sparc64/Kconfig
===================================================================
--- tree-linus.orig/arch/sparc64/Kconfig
+++ tree-linus/arch/sparc64/Kconfig
@@ -11,6 +11,7 @@ config SPARC
 	select HAVE_OPROFILE
 	select HAVE_KPROBES
 	select HAVE_KRETPROBES
+	select HAVE_ARCH_SHOW_MEM
 
 config SPARC64
 	bool
Index: tree-linus/arch/um/Kconfig
===================================================================
--- tree-linus.orig/arch/um/Kconfig
+++ tree-linus/arch/um/Kconfig
@@ -11,6 +11,7 @@ config GENERIC_HARDIRQS
 config UML
 	bool
 	default y
+	select HAVE_ARCH_SHOW_MEM
 
 config MMU
 	bool
Index: tree-linus/arch/v850/Kconfig
===================================================================
--- tree-linus.orig/arch/v850/Kconfig
+++ tree-linus/arch/v850/Kconfig
@@ -79,6 +79,7 @@ config V850
 	bool
 	default y
 	select HAVE_IDE
+	select HAVE_ARCH_SHOW_MEM
 
 menu "Processor type and features"
 
Index: tree-linus/arch/x86/Kconfig
===================================================================
--- tree-linus.orig/arch/x86/Kconfig
+++ tree-linus/arch/x86/Kconfig
@@ -23,7 +23,7 @@ config X86
 	select HAVE_KPROBES
 	select HAVE_KRETPROBES
 	select HAVE_KVM if ((X86_32 && !X86_VOYAGER && !X86_VISWS && !X86_NUMAQ) || X86_64)
-
+	select HAVE_ARCH_SHOW_MEM
 
 config GENERIC_LOCKBREAK
 	def_bool n
Index: tree-linus/arch/xtensa/Kconfig
===================================================================
--- tree-linus.orig/arch/xtensa/Kconfig
+++ tree-linus/arch/xtensa/Kconfig
@@ -15,6 +15,7 @@ config XTENSA
 	bool
 	default y
 	select HAVE_IDE
+	select HAVE_ARCH_SHOW_MEM
 	help
 	  Xtensa processors are 32-bit RISC machines designed by Tensilica
 	  primarily for embedded systems.  These processors are both

-- 

