Return-Path: <linux-kernel-owner+w=401wt.eu-S1755712AbYDDMeb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755712AbYDDMeb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2008 08:34:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757799AbYDDMeM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Apr 2008 08:34:12 -0400
Received: from saeurebad.de ([85.214.36.134]:44232 "EHLO saeurebad.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755637AbYDDMeG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2008 08:34:06 -0400
X-Mailbox-Line: From hannes@skyscraper.fehenstaub.lan Fri Apr  4 13:26:16 2008
Message-Id: <20080404112404.413840814@skyscraper.fehenstaub.lan>
User-Agent: quilt/0.46-1
Date: Fri, 04 Apr 2008 13:24:04 +0200
From: hannes@saeurebad.de
To: LKML <linux-kernel@vger.kernel.org>
Subject: [patch 00/22] Generic show_mem()
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Every arch implements its own show_mem() function.  Most of them share
quite some code, some of them are completely identical.

This series implements a generic version of this function and migrates
almost all architectures to it.

---
version 2:
	- Fix kbuild bits as suggested by Heiko Carstens
	- Include quicklist info as suggested by Paul Mundt
	- Extend changelogs by info on removal of redundant output

Note: This patchset is based on the `Remove redundant display of free
swap space from show_mem()' series. 

 arch/alpha/mm/init.c      |   29 -----------------------
 arch/alpha/mm/numa.c      |   34 ---------------------------
 arch/arm/Kconfig          |    1 +
 arch/avr32/mm/init.c      |   39 -------------------------------
 arch/blackfin/mm/init.c   |   27 ----------------------
 arch/cris/mm/init.c       |   30 ------------------------
 arch/frv/mm/init.c        |   31 -------------------------
 arch/h8300/mm/init.c      |   28 -----------------------
 arch/ia64/Kconfig         |    1 +
 arch/m32r/mm/init.c       |   35 ----------------------------
 arch/m68k/mm/init.c       |   30 ------------------------
 arch/m68knommu/mm/init.c  |   28 -----------------------
 arch/mips/mm/Makefile     |    3 +-
 arch/mips/mm/pgtable.c    |   36 -----------------------------
 arch/mn10300/mm/pgtable.c |   27 ----------------------
 arch/parisc/Kconfig       |    1 +
 arch/powerpc/mm/mem.c     |   39 -------------------------------
 arch/ppc/mm/init.c        |   30 ------------------------
 arch/s390/mm/init.c       |   35 ----------------------------
 arch/sh/mm/init.c         |   40 --------------------------------
 arch/sparc/Kconfig        |    1 +
 arch/sparc64/mm/init.c    |   43 -----------------------------------
 arch/um/kernel/mem.c      |   29 -----------------------
 arch/v850/kernel/setup.c  |   30 ------------------------
 arch/x86/mm/init_64.c     |   37 ------------------------------
 arch/x86/mm/pgtable_32.c  |   47 --------------------------------------
 arch/xtensa/mm/init.c     |   26 ---------------------
 mm/Kconfig                |    3 ++
 mm/page_alloc.c           |   55 +++++++++++++++++++++++++++++++++++++++++++++
 mm/swap_state.c           |    3 +-
 30 files changed, 65 insertions(+), 733 deletions(-)

-- 

>From hannes@skyscraper.fehenstaub.lan Fri Apr  4 13:26:17 2008
Message-Id: <20080404112616.987371299@skyscraper.fehenstaub.lan>
References: <20080404112404.413840814@skyscraper.fehenstaub.lan>
User-Agent: quilt/0.46-1
Date: Fri, 04 Apr 2008 13:24:05 +0200
From: hannes@saeurebad.de
To: LKML <linux-kernel@vger.kernel.org>
Subject: [patch 01/22] Print current swapcache page count in show_swap_cache_info()
Content-Disposition: inline; filename=print-total_swapcache_pages-in-show_swap_cache_info.patch

Most show_mem() implementations calculate the amount of pages within
the swapcache every time.  Move the output to a more appropriate place
and use the anyway available total_swapcache_pages variable.

Signed-off-by: Johannes Weiner <hannes@saeurebad.de>
---

diff --git a/mm/swap_state.c b/mm/swap_state.c
index 50757ee..71cc0e1 100644
--- a/mm/swap_state.c
+++ b/mm/swap_state.c
@@ -56,7 +56,8 @@ static struct {
 
 void show_swap_cache_info(void)
 {
-	printk("Swap cache: add %lu, delete %lu, find %lu/%lu\n",
+	printk("%lu pages in swap cache\n", total_swapcache_pages);
+	printk("Swap cache stats: add %lu, delete %lu, find %lu/%lu\n",
 		swap_cache_info.add_total, swap_cache_info.del_total,
 		swap_cache_info.find_success, swap_cache_info.find_total);
 	printk("Free swap  = %lukB\n", nr_swap_pages << (PAGE_SHIFT - 10));

-- 

>From hannes@skyscraper.fehenstaub.lan Fri Apr  4 13:26:17 2008
Message-Id: <20080404112617.136116485@skyscraper.fehenstaub.lan>
References: <20080404112404.413840814@skyscraper.fehenstaub.lan>
User-Agent: quilt/0.46-1
Date: Fri, 04 Apr 2008 13:24:06 +0200
From: hannes@saeurebad.de
To: LKML <linux-kernel@vger.kernel.org>
Subject: [patch 02/22] Generic show_mem() implementation
Content-Disposition: inline; filename=generic-show_mem.patch

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

>From hannes@skyscraper.fehenstaub.lan Fri Apr  4 13:26:17 2008
Message-Id: <20080404112617.283432238@skyscraper.fehenstaub.lan>
References: <20080404112404.413840814@skyscraper.fehenstaub.lan>
User-Agent: quilt/0.46-1
Date: Fri, 04 Apr 2008 13:24:07 +0200
From: hannes@saeurebad.de
To: LKML <linux-kernel@vger.kernel.org>
Cc: Richard Henderson <rth@twiddle.net>
Subject: [patch 03/22] alpha: Use generic show_mem()
Content-Disposition: inline; filename=alpha-use-generic-show_mem.patch

Remove arch-specific show_mem() in favor of the generic version.

This also removes the following redundant information display:

	- free pages, printed by show_free_areas()
	- pages in swapcache, printed by show_swap_cache_info()

where show_mem() calls show_free_areas(), which calls
show_swap_cache_info().

Signed-off-by: Johannes Weiner <hannes@saeurebad.de>
CC: Richard Henderson <rth@twiddle.net>
---

Index: tree-linus/arch/alpha/Kconfig
===================================================================
--- tree-linus.orig/arch/alpha/Kconfig
+++ tree-linus/arch/alpha/Kconfig
@@ -7,7 +7,6 @@ config ALPHA
 	default y
 	select HAVE_IDE
 	select HAVE_OPROFILE
-	select HAVE_ARCH_SHOW_MEM
 	help
 	  The Alpha is a 64-bit general-purpose processor designed and
 	  marketed by the Digital Equipment Corporation of blessed memory,
Index: tree-linus/arch/alpha/mm/init.c
===================================================================
--- tree-linus.orig/arch/alpha/mm/init.c
+++ tree-linus/arch/alpha/mm/init.c
@@ -94,35 +94,6 @@ __bad_page(void)
 	return pte_mkdirty(mk_pte(virt_to_page(EMPTY_PGE), PAGE_SHARED));
 }
 
-#ifndef CONFIG_DISCONTIGMEM
-void
-show_mem(void)
-{
-	long i,free = 0,total = 0,reserved = 0;
-	long shared = 0, cached = 0;
-
-	printk("\nMem-info:\n");
-	show_free_areas();
-	i = max_mapnr;
-	while (i-- > 0) {
-		total++;
-		if (PageReserved(mem_map+i))
-			reserved++;
-		else if (PageSwapCache(mem_map+i))
-			cached++;
-		else if (!page_count(mem_map+i))
-			free++;
-		else
-			shared += page_count(mem_map + i) - 1;
-	}
-	printk("%ld pages of RAM\n",total);
-	printk("%ld free pages\n",free);
-	printk("%ld reserved pages\n",reserved);
-	printk("%ld pages shared\n",shared);
-	printk("%ld pages swap cached\n",cached);
-}
-#endif
-
 static inline unsigned long
 load_PCB(struct pcb_struct *pcb)
 {
Index: tree-linus/arch/alpha/mm/numa.c
===================================================================
--- tree-linus.orig/arch/alpha/mm/numa.c
+++ tree-linus/arch/alpha/mm/numa.c
@@ -359,37 +359,3 @@ void __init mem_init(void)
 	mem_stress();
 #endif
 }
-
-void
-show_mem(void)
-{
-	long i,free = 0,total = 0,reserved = 0;
-	long shared = 0, cached = 0;
-	int nid;
-
-	printk("\nMem-info:\n");
-	show_free_areas();
-	for_each_online_node(nid) {
-		unsigned long flags;
-		pgdat_resize_lock(NODE_DATA(nid), &flags);
-		i = node_spanned_pages(nid);
-		while (i-- > 0) {
-			struct page *page = nid_page_nr(nid, i);
-			total++;
-			if (PageReserved(page))
-				reserved++;
-			else if (PageSwapCache(page))
-				cached++;
-			else if (!page_count(page))
-				free++;
-			else
-				shared += page_count(page) - 1;
-		}
-		pgdat_resize_unlock(NODE_DATA(nid), &flags);
-	}
-	printk("%ld pages of RAM\n",total);
-	printk("%ld free pages\n",free);
-	printk("%ld reserved pages\n",reserved);
-	printk("%ld pages shared\n",shared);
-	printk("%ld pages swap cached\n",cached);
-}

-- 

>From hannes@skyscraper.fehenstaub.lan Fri Apr  4 13:26:17 2008
Message-Id: <20080404112617.429190114@skyscraper.fehenstaub.lan>
References: <20080404112404.413840814@skyscraper.fehenstaub.lan>
User-Agent: quilt/0.46-1
Date: Fri, 04 Apr 2008 13:24:08 +0200
From: hannes@saeurebad.de
To: LKML <linux-kernel@vger.kernel.org>
Cc: Haavard Skinnemoen <hskinnemoen@atmel.com>
Subject: [patch 04/22] avr32: Use generic show_mem()
Content-Disposition: inline; filename=avr32-use-generic-show_mem.patch

Remove arch-specific show_mem() in favor of the generic version.

This also removes the following redundant information display:

	- free pages, printed by show_free_areas()
	- pages in slabs, printed by show_free_areas()
	- pages in swapcache, printed by show_swap_cache_info()

where show_mem() calls show_free_areas(), which calls
show_swap_cache_info().

Signed-off-by: Johannes Weiner <hannes@saeurebad.de>
CC: Haavard Skinnemoen <hskinnemoen@atmel.com>
---

Index: tree-linus/arch/avr32/Kconfig
===================================================================
--- tree-linus.orig/arch/avr32/Kconfig
+++ tree-linus/arch/avr32/Kconfig
@@ -13,7 +13,6 @@ config AVR32
 	select HAVE_IDE
 	select HAVE_OPROFILE
 	select HAVE_KPROBES
-	select HAVE_ARCH_SHOW_MEM
 	help
 	  AVR32 is a high-performance 32-bit RISC microprocessor core,
 	  designed for cost-sensitive embedded applications, with particular
Index: tree-linus/arch/avr32/mm/init.c
===================================================================
--- tree-linus.orig/arch/avr32/mm/init.c
+++ tree-linus/arch/avr32/mm/init.c
@@ -37,45 +37,6 @@ unsigned long mmu_context_cache = NO_CON
 #define START_PFN	(NODE_DATA(0)->bdata->node_boot_start >> PAGE_SHIFT)
 #define MAX_LOW_PFN	(NODE_DATA(0)->bdata->node_low_pfn)
 
-void show_mem(void)
-{
-	int total = 0, reserved = 0, cached = 0;
-	int slab = 0, free = 0, shared = 0;
-	pg_data_t *pgdat;
-
-	printk("Mem-info:\n");
-	show_free_areas();
-
-	for_each_online_pgdat(pgdat) {
-		struct page *page, *end;
-
-		page = pgdat->node_mem_map;
-		end = page + pgdat->node_spanned_pages;
-
-		do {
-			total++;
-			if (PageReserved(page))
-				reserved++;
-			else if (PageSwapCache(page))
-				cached++;
-			else if (PageSlab(page))
-				slab++;
-			else if (!page_count(page))
-				free++;
-			else
-				shared += page_count(page) - 1;
-			page++;
-		} while (page < end);
-	}
-
-	printk ("%d pages of RAM\n", total);
-	printk ("%d free pages\n", free);
-	printk ("%d reserved pages\n", reserved);
-	printk ("%d slab pages\n", slab);
-	printk ("%d pages shared\n", shared);
-	printk ("%d pages swap cached\n", cached);
-}
-
 /*
  * paging_init() sets up the page tables
  *

-- 

>From hannes@skyscraper.fehenstaub.lan Fri Apr  4 13:26:17 2008
Message-Id: <20080404112617.575314036@skyscraper.fehenstaub.lan>
References: <20080404112404.413840814@skyscraper.fehenstaub.lan>
User-Agent: quilt/0.46-1
Date: Fri, 04 Apr 2008 13:24:09 +0200
From: hannes@saeurebad.de
To: LKML <linux-kernel@vger.kernel.org>
Cc: Bryan Wu <cooloney@kernel.org>
Subject: [patch 05/22] blackfin: Use generic show_mem()
Content-Disposition: inline; filename=blackfin-use-generic-show_mem.patch

Remove arch-specific show_mem() in favor of the generic version.

This also removes the following redundant information display:

	- free pages, printed by show_free_areas()
	- pages in swapcache, printed by show_swap_cache_info()

where show_mem() calls show_free_areas(), which calls
show_swap_cache_info().

Signed-off-by: Johannes Weiner <hannes@saeurebad.de>
CC: Bryan Wu <cooloney@kernel.org>
---

Index: tree-linus/arch/blackfin/Kconfig
===================================================================
--- tree-linus.orig/arch/blackfin/Kconfig
+++ tree-linus/arch/blackfin/Kconfig
@@ -26,7 +26,6 @@ config BLACKFIN
 	default y
 	select HAVE_IDE
 	select HAVE_OPROFILE
-	select HAVE_ARCH_SHOW_MEM
 
 config ZONE_DMA
 	bool
Index: tree-linus/arch/blackfin/mm/init.c
===================================================================
--- tree-linus.orig/arch/blackfin/mm/init.c
+++ tree-linus/arch/blackfin/mm/init.c
@@ -53,33 +53,6 @@ static unsigned long empty_bad_page;
 
 unsigned long empty_zero_page;
 
-void show_mem(void)
-{
-	unsigned long i;
-	int free = 0, total = 0, reserved = 0, shared = 0;
-
-	int cached = 0;
-	printk(KERN_INFO "Mem-info:\n");
-	show_free_areas();
-	i = max_mapnr;
-	while (i-- > 0) {
-		total++;
-		if (PageReserved(mem_map + i))
-			reserved++;
-		else if (PageSwapCache(mem_map + i))
-			cached++;
-		else if (!page_count(mem_map + i))
-			free++;
-		else
-			shared += page_count(mem_map + i) - 1;
-	}
-	printk(KERN_INFO "%d pages of RAM\n", total);
-	printk(KERN_INFO "%d free pages\n", free);
-	printk(KERN_INFO "%d reserved pages\n", reserved);
-	printk(KERN_INFO "%d pages shared\n", shared);
-	printk(KERN_INFO "%d pages swap cached\n", cached);
-}
-
 /*
  * paging_init() continues the virtual memory environment setup which
  * was begun by the code in arch/head.S.

-- 

>From hannes@skyscraper.fehenstaub.lan Fri Apr  4 13:26:17 2008
Message-Id: <20080404112617.721647722@skyscraper.fehenstaub.lan>
References: <20080404112404.413840814@skyscraper.fehenstaub.lan>
User-Agent: quilt/0.46-1
Date: Fri, 04 Apr 2008 13:24:10 +0200
From: hannes@saeurebad.de
To: LKML <linux-kernel@vger.kernel.org>
Cc: Mikael Starvik <starvik@axis.com>
Subject: [patch 06/22] cris: Use generic show_mem()
Content-Disposition: inline; filename=cris-use-generic-show_mem.patch

Remove arch-specific show_mem() in favor of the generic version.

This also removes the following redundant information display:

	- free pages, printed by show_free_areas()
	- pages in swapcache, printed by show_swap_cache_info()

where show_mem() calls show_free_areas(), which calls
show_swap_cache_info().

Signed-off-by: Johannes Weiner <hannes@saeurebad.de>
CC: Mikael Starvik <starvik@axis.com>
---

Index: tree-linus/arch/cris/Kconfig
===================================================================
--- tree-linus.orig/arch/cris/Kconfig
+++ tree-linus/arch/cris/Kconfig
@@ -55,7 +55,6 @@ config CRIS
 	bool
 	default y
 	select HAVE_IDE
-	select HAVE_ARCH_SHOW_MEM
 
 config HZ
 	int
Index: tree-linus/arch/cris/mm/init.c
===================================================================
--- tree-linus.orig/arch/cris/mm/init.c
+++ tree-linus/arch/cris/mm/init.c
@@ -19,36 +19,6 @@ unsigned long empty_zero_page;
 extern char _stext, _edata, _etext; /* From linkerscript */
 extern char __init_begin, __init_end;
 
-void 
-show_mem(void)
-{
-	int i,free = 0,total = 0,cached = 0, reserved = 0, nonshared = 0;
-	int shared = 0;
-
-	printk("\nMem-info:\n");
-	show_free_areas();
-	i = max_mapnr;
-	while (i-- > 0) {
-		total++;
-		if (PageReserved(mem_map+i))
-			reserved++;
-		else if (PageSwapCache(mem_map+i))
-			cached++;
-		else if (!page_count(mem_map+i))
-			free++;
-		else if (page_count(mem_map+i) == 1)
-			nonshared++;
-		else
-			shared += page_count(mem_map+i) - 1;
-	}
-	printk("%d pages of RAM\n",total);
-	printk("%d free pages\n",free);
-	printk("%d reserved pages\n",reserved);
-	printk("%d pages nonshared\n",nonshared);
-	printk("%d pages shared\n",shared);
-	printk("%d pages swap cached\n",cached);
-}
-
 void __init
 mem_init(void)
 {

-- 

>From hannes@skyscraper.fehenstaub.lan Fri Apr  4 13:26:17 2008
Message-Id: <20080404112617.868158417@skyscraper.fehenstaub.lan>
References: <20080404112404.413840814@skyscraper.fehenstaub.lan>
User-Agent: quilt/0.46-1
Date: Fri, 04 Apr 2008 13:24:11 +0200
From: hannes@saeurebad.de
To: LKML <linux-kernel@vger.kernel.org>
Cc: David Howells <dhowells@redhat.com>
Subject: [patch 07/22] frv: Use generic show_mem()
Content-Disposition: inline; filename=frv-use-generic-show_mem.patch

Remove arch-specific show_mem() in favor of the generic version.

This also removes the following redundant information display:

	- free pages, printed by show_free_areas()

where show_mem() calls show_free_areas().

Signed-off-by: Johannes Weiner <hannes@saeurebad.de>
CC: David Howells <dhowells@redhat.com>
---

Index: tree-linus/arch/frv/Kconfig
===================================================================
--- tree-linus.orig/arch/frv/Kconfig
+++ tree-linus/arch/frv/Kconfig
@@ -6,7 +6,6 @@ config FRV
 	bool
 	default y
 	select HAVE_IDE
-	select HAVE_ARCH_SHOW_MEM
 
 config ZONE_DMA
 	bool
Index: tree-linus/arch/frv/mm/init.c
===================================================================
--- tree-linus.orig/arch/frv/mm/init.c
+++ tree-linus/arch/frv/mm/init.c
@@ -60,37 +60,6 @@ unsigned long empty_zero_page;
 
 /*****************************************************************************/
 /*
- *
- */
-void show_mem(void)
-{
-	unsigned long i;
-	int free = 0, total = 0, reserved = 0, shared = 0;
-
-	printk("\nMem-info:\n");
-	show_free_areas();
-	i = max_mapnr;
-	while (i-- > 0) {
-		struct page *page = &mem_map[i];
-
-		total++;
-		if (PageReserved(page))
-			reserved++;
-		else if (!page_count(page))
-			free++;
-		else
-			shared += page_count(page) - 1;
-	}
-
-	printk("%d pages of RAM\n",total);
-	printk("%d free pages\n",free);
-	printk("%d reserved pages\n",reserved);
-	printk("%d pages shared\n",shared);
-
-} /* end show_mem() */
-
-/*****************************************************************************/
-/*
  * paging_init() continues the virtual memory environment setup which
  * was begun by the code in arch/head.S.
  * The parameters are pointers to where to stick the starting and ending

-- 

>From hannes@skyscraper.fehenstaub.lan Fri Apr  4 13:26:18 2008
Message-Id: <20080404112618.014367432@skyscraper.fehenstaub.lan>
References: <20080404112404.413840814@skyscraper.fehenstaub.lan>
User-Agent: quilt/0.46-1
Date: Fri, 04 Apr 2008 13:24:12 +0200
From: hannes@saeurebad.de
To: LKML <linux-kernel@vger.kernel.org>
Subject: [patch 08/22] h8300: Use generic show_mem()
Content-Disposition: inline; filename=h8300-use-generic-show_mem.patch

Remove arch-specific show_mem() in favor of the generic version.

This also removes the following redundant information display:

	- free pages, printed by show_free_areas()
	- pages in swapcache, printed by show_swap_cache_info()

where show_mem() calls show_free_areas(), which calls
show_swap_cache_info().

Signed-off-by: Johannes Weiner <hannes@saeurebad.de>
---

Index: tree-linus/arch/h8300/Kconfig
===================================================================
--- tree-linus.orig/arch/h8300/Kconfig
+++ tree-linus/arch/h8300/Kconfig
@@ -9,7 +9,6 @@ config H8300
 	bool
 	default y
 	select HAVE_IDE
-	select HAVE_ARCH_SHOW_MEM
 
 config MMU
 	bool
Index: tree-linus/arch/h8300/mm/init.c
===================================================================
--- tree-linus.orig/arch/h8300/mm/init.c
+++ tree-linus/arch/h8300/mm/init.c
@@ -64,33 +64,6 @@ unsigned long empty_zero_page;
 
 extern unsigned long rom_length;
 
-void show_mem(void)
-{
-    unsigned long i;
-    int free = 0, total = 0, reserved = 0, shared = 0;
-    int cached = 0;
-
-    printk("\nMem-info:\n");
-    show_free_areas();
-    i = max_mapnr;
-    while (i-- > 0) {
-	total++;
-	if (PageReserved(mem_map+i))
-	    reserved++;
-	else if (PageSwapCache(mem_map+i))
-	    cached++;
-	else if (!page_count(mem_map+i))
-	    free++;
-	else
-	    shared += page_count(mem_map+i) - 1;
-    }
-    printk("%d pages of RAM\n",total);
-    printk("%d free pages\n",free);
-    printk("%d reserved pages\n",reserved);
-    printk("%d pages shared\n",shared);
-    printk("%d pages swap cached\n",cached);
-}
-
 extern unsigned long memory_start;
 extern unsigned long memory_end;
 
@@ -228,4 +201,3 @@ free_initmem()
 			(int)(addr - PAGE_SIZE));
 #endif
 }
-

-- 

>From hannes@skyscraper.fehenstaub.lan Fri Apr  4 13:26:18 2008
Message-Id: <20080404112618.162376765@skyscraper.fehenstaub.lan>
References: <20080404112404.413840814@skyscraper.fehenstaub.lan>
User-Agent: quilt/0.46-1
Date: Fri, 04 Apr 2008 13:24:13 +0200
From: hannes@saeurebad.de
To: LKML <linux-kernel@vger.kernel.org>
Cc: Hirokazu Takata <takata@linux-m32r.org>
Subject: [patch 09/22] m32r: Use generic show_mem()
Content-Disposition: inline; filename=m32r-use-generic-show_mem.patch

Remove arch-specific show_mem() in favor of the generic version.

This also removes the following redundant information display:

	- pages in swapcache, printed by show_swap_cache_info()

where show_mem() calls show_free_areas(), which calls
show_swap_cache_info().

Signed-off-by: Johannes Weiner <hannes@saeurebad.de>
CC: Hirokazu Takata <takata@linux-m32r.org>
---

Index: tree-linus/arch/m32r/Kconfig
===================================================================
--- tree-linus.orig/arch/m32r/Kconfig
+++ tree-linus/arch/m32r/Kconfig
@@ -10,7 +10,6 @@ config M32R
 	default y
 	select HAVE_IDE
 	select HAVE_OPROFILE
-	select HAVE_ARCH_SHOW_MEM
 
 config SBUS
 	bool
Index: tree-linus/arch/m32r/mm/init.c
===================================================================
--- tree-linus.orig/arch/m32r/mm/init.c
+++ tree-linus/arch/m32r/mm/init.c
@@ -36,41 +36,6 @@ pgd_t swapper_pg_dir[1024];
 
 DEFINE_PER_CPU(struct mmu_gather, mmu_gathers);
 
-void show_mem(void)
-{
-	int total = 0, reserved = 0;
-	int shared = 0, cached = 0;
-	int highmem = 0;
-	struct page *page;
-	pg_data_t *pgdat;
-	unsigned long i;
-
-	printk("Mem-info:\n");
-	show_free_areas();
-	for_each_online_pgdat(pgdat) {
-		unsigned long flags;
-		pgdat_resize_lock(pgdat, &flags);
-		for (i = 0; i < pgdat->node_spanned_pages; ++i) {
-			page = pgdat_page_nr(pgdat, i);
-			total++;
-			if (PageHighMem(page))
-				highmem++;
-			if (PageReserved(page))
-				reserved++;
-			else if (PageSwapCache(page))
-				cached++;
-			else if (page_count(page))
-				shared += page_count(page) - 1;
-		}
-		pgdat_resize_unlock(pgdat, &flags);
-	}
-	printk("%d pages of RAM\n", total);
-	printk("%d pages of HIGHMEM\n",highmem);
-	printk("%d reserved pages\n",reserved);
-	printk("%d pages shared\n",shared);
-	printk("%d pages swap cached\n",cached);
-}
-
 /*
  * Cache of MMU context last used.
  */

-- 

>From hannes@skyscraper.fehenstaub.lan Fri Apr  4 13:26:18 2008
Message-Id: <20080404112618.309032229@skyscraper.fehenstaub.lan>
References: <20080404112404.413840814@skyscraper.fehenstaub.lan>
User-Agent: quilt/0.46-1
Date: Fri, 04 Apr 2008 13:24:14 +0200
From: hannes@saeurebad.de
To: LKML <linux-kernel@vger.kernel.org>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [patch 10/22] m68k: Use generic show_mem()
Content-Disposition: inline; filename=m68k-use-generic-show_mem.patch

Remove arch-specific show_mem() in favor of the generic version.

This also removes the following redundant information display:

	- free pages, printed by show_free_areas()
	- pages in swapcache, printed by show_swap_cache_info()

where show_mem() calls show_free_areas(), which calls
show_swap_cache_info().

Signed-off-by: Johannes Weiner <hannes@saeurebad.de>
CC: Geert Uytterhoeven <geert@linux-m68k.org>
---

Index: tree-linus/arch/m68k/Kconfig
===================================================================
--- tree-linus.orig/arch/m68k/Kconfig
+++ tree-linus/arch/m68k/Kconfig
@@ -6,7 +6,6 @@ config M68K
 	bool
 	default y
 	select HAVE_IDE
-	select HAVE_ARCH_SHOW_MEM
 
 config MMU
 	bool
Index: tree-linus/arch/m68k/mm/init.c
===================================================================
--- tree-linus.orig/arch/m68k/mm/init.c
+++ tree-linus/arch/m68k/mm/init.c
@@ -70,36 +70,6 @@ void __init m68k_setup_node(int node)
 
 void *empty_zero_page;
 
-void show_mem(void)
-{
-	pg_data_t *pgdat;
-	int free = 0, total = 0, reserved = 0, shared = 0;
-	int cached = 0;
-	int i;
-
-	printk("\nMem-info:\n");
-	show_free_areas();
-	for_each_online_pgdat(pgdat) {
-		for (i = 0; i < pgdat->node_spanned_pages; i++) {
-			struct page *page = pgdat->node_mem_map + i;
-			total++;
-			if (PageReserved(page))
-				reserved++;
-			else if (PageSwapCache(page))
-				cached++;
-			else if (!page_count(page))
-				free++;
-			else
-				shared += page_count(page) - 1;
-		}
-	}
-	printk("%d pages of RAM\n",total);
-	printk("%d free pages\n",free);
-	printk("%d reserved pages\n",reserved);
-	printk("%d pages shared\n",shared);
-	printk("%d pages swap cached\n",cached);
-}
-
 extern void init_pointer_table(unsigned long ptable);
 
 /* References to section boundaries */

-- 

>From hannes@skyscraper.fehenstaub.lan Fri Apr  4 13:26:18 2008
Message-Id: <20080404112618.455842702@skyscraper.fehenstaub.lan>
References: <20080404112404.413840814@skyscraper.fehenstaub.lan>
User-Agent: quilt/0.46-1
Date: Fri, 04 Apr 2008 13:24:15 +0200
From: hannes@saeurebad.de
To: LKML <linux-kernel@vger.kernel.org>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [patch 11/22] m68knommu: Use generic show_mem()
Content-Disposition: inline; filename=m68knommu-use-generic-show_mem.patch

Remove arch-specific show_mem() in favor of the generic version.

This also removes the following redundant information display:

	- free pages, printed by show_free_areas()
	- pages in swapcache, printed by show_swap_cache_info()

where show_mem() calls show_free_areas(), which calls
show_swap_cache_info().

Signed-off-by: Johannes Weiner <hannes@saeurebad.de>
CC: Geert Uytterhoeven <geert@linux-m68k.org>
---

Index: tree-linus/arch/m68knommu/Kconfig
===================================================================
--- tree-linus.orig/arch/m68knommu/Kconfig
+++ tree-linus/arch/m68knommu/Kconfig
@@ -9,7 +9,6 @@ config M68K
 	bool
 	default y
 	select HAVE_IDE
-	select HAVE_ARCH_SHOW_MEM
 
 config MMU
 	bool
Index: tree-linus/arch/m68knommu/mm/init.c
===================================================================
--- tree-linus.orig/arch/m68knommu/mm/init.c
+++ tree-linus/arch/m68knommu/mm/init.c
@@ -62,33 +62,6 @@ static unsigned long empty_bad_page;
 
 unsigned long empty_zero_page;
 
-void show_mem(void)
-{
-    unsigned long i;
-    int free = 0, total = 0, reserved = 0, shared = 0;
-    int cached = 0;
-
-    printk(KERN_INFO "\nMem-info:\n");
-    show_free_areas();
-    i = max_mapnr;
-    while (i-- > 0) {
-	total++;
-	if (PageReserved(mem_map+i))
-	    reserved++;
-	else if (PageSwapCache(mem_map+i))
-	    cached++;
-	else if (!page_count(mem_map+i))
-	    free++;
-	else
-	    shared += page_count(mem_map+i) - 1;
-    }
-    printk(KERN_INFO "%d pages of RAM\n",total);
-    printk(KERN_INFO "%d free pages\n",free);
-    printk(KERN_INFO "%d reserved pages\n",reserved);
-    printk(KERN_INFO "%d pages shared\n",shared);
-    printk(KERN_INFO "%d pages swap cached\n",cached);
-}
-
 extern unsigned long memory_start;
 extern unsigned long memory_end;
 
@@ -223,4 +196,3 @@ free_initmem()
 			(int)(addr - PAGE_SIZE));
 #endif
 }
-

-- 

>From hannes@skyscraper.fehenstaub.lan Fri Apr  4 13:26:18 2008
Message-Id: <20080404112618.601268652@skyscraper.fehenstaub.lan>
References: <20080404112404.413840814@skyscraper.fehenstaub.lan>
User-Agent: quilt/0.46-1
Date: Fri, 04 Apr 2008 13:24:16 +0200
From: hannes@saeurebad.de
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ralf Baechle <ralf@linux-mips.org>
Subject: [patch 12/22] mips: Use generic show_mem()
Content-Disposition: inline; filename=mips-use-generic-show_mem.patch

Remove arch-specific show_mem() in favor of the generic version. 

This also removes the following redundant information display:

	- pages in swapcache, printed by show_swap_cache_info()

where show_mem() calls show_free_areas(), which calls
show_swap_cache_info(). 

And show_mem() does now actually print something on configurations
with multiple nodes. 

Signed-off-by: Johannes Weiner <hannes@saeurebad.de>
Acked-by: Ralf Baechle <ralf@linux-mips.org>
---

Index: tree-linus/arch/mips/Kconfig
===================================================================
--- tree-linus.orig/arch/mips/Kconfig
+++ tree-linus/arch/mips/Kconfig
@@ -6,7 +6,6 @@ config MIPS
 	# Horrible source of confusion.  Die, die, die ...
 	select EMBEDDED
 	select RTC_LIB
-	select HAVE_ARCH_SHOW_MEM
 
 mainmenu "Linux/MIPS Kernel Configuration"
 
Index: tree-linus/arch/mips/mm/Makefile
===================================================================
--- tree-linus.orig/arch/mips/mm/Makefile
+++ tree-linus/arch/mips/mm/Makefile
@@ -3,8 +3,7 @@
 #
 
 obj-y				+= cache.o dma-default.o extable.o fault.o \
-				   init.o pgtable.o tlbex.o tlbex-fault.o \
-				   uasm.o
+				   init.o tlbex.o tlbex-fault.o uasm.o
 
 obj-$(CONFIG_32BIT)		+= ioremap.o pgtable-32.o
 obj-$(CONFIG_64BIT)		+= pgtable-64.o
Index: tree-linus/arch/mips/mm/pgtable.c
===================================================================
--- tree-linus.orig/arch/mips/mm/pgtable.c
+++ /dev/null
@@ -1,36 +0,0 @@
-#include <linux/kernel.h>
-#include <linux/mm.h>
-#include <linux/swap.h>
-
-void show_mem(void)
-{
-#ifndef CONFIG_NEED_MULTIPLE_NODES  /* XXX(hch): later.. */
-	int pfn, total = 0, reserved = 0;
-	int shared = 0, cached = 0;
-	int highmem = 0;
-	struct page *page;
-
-	printk("Mem-info:\n");
-	show_free_areas();
-	pfn = max_mapnr;
-	while (pfn-- > 0) {
-		if (!pfn_valid(pfn))
-			continue;
-		page = pfn_to_page(pfn);
-		total++;
-		if (PageHighMem(page))
-			highmem++;
-		if (PageReserved(page))
-			reserved++;
-		else if (PageSwapCache(page))
-			cached++;
-		else if (page_count(page))
-			shared += page_count(page) - 1;
-	}
-	printk("%d pages of RAM\n", total);
-	printk("%d pages of HIGHMEM\n", highmem);
-	printk("%d reserved pages\n", reserved);
-	printk("%d pages shared\n", shared);
-	printk("%d pages swap cached\n", cached);
-#endif
-}

-- 

>From hannes@skyscraper.fehenstaub.lan Fri Apr  4 13:26:18 2008
Message-Id: <20080404112618.747520866@skyscraper.fehenstaub.lan>
References: <20080404112404.413840814@skyscraper.fehenstaub.lan>
User-Agent: quilt/0.46-1
Date: Fri, 04 Apr 2008 13:24:17 +0200
From: hannes@saeurebad.de
To: LKML <linux-kernel@vger.kernel.org>
Cc: David Howells <dhowells@redhat.com>
Subject: [patch 13/22] mn10300: Use generic show_mem()
Content-Disposition: inline; filename=mn10300-use-generic-show_mem.patch

Remove arch-specific show_mem() in favor of the generic version.

This also removes the following redundant information display:

	- free pages, printed by show_free_areas()
	- pages in swapcache, printed by show_swap_cache_info()

where show_mem() calls show_free_areas(), which calls
show_swap_cache_info().

Signed-off-by: Johannes Weiner <hannes@saeurebad.de>
CC: David Howells <dhowells@redhat.com>
---

Index: tree-linus/arch/mn10300/Kconfig
===================================================================
--- tree-linus.orig/arch/mn10300/Kconfig
+++ tree-linus/arch/mn10300/Kconfig
@@ -7,7 +7,6 @@ mainmenu "Linux Kernel Configuration"
 
 config MN10300
 	def_bool y
-	select HAVE_ARCH_SHOW_MEM
 
 config AM33
 	def_bool y
Index: tree-linus/arch/mn10300/mm/pgtable.c
===================================================================
--- tree-linus.orig/arch/mn10300/mm/pgtable.c
+++ tree-linus/arch/mn10300/mm/pgtable.c
@@ -27,33 +27,6 @@
 #include <asm/tlb.h>
 #include <asm/tlbflush.h>
 
-void show_mem(void)
-{
-	unsigned long i;
-	int free = 0, total = 0, reserved = 0, shared = 0;
-
-	int cached = 0;
-	printk(KERN_INFO "Mem-info:\n");
-	show_free_areas();
-	i = max_mapnr;
-	while (i-- > 0) {
-		total++;
-		if (PageReserved(mem_map + i))
-			reserved++;
-		else if (PageSwapCache(mem_map + i))
-			cached++;
-		else if (!page_count(mem_map + i))
-			free++;
-		else
-			shared += page_count(mem_map + i) - 1;
-	}
-	printk(KERN_INFO "%d pages of RAM\n", total);
-	printk(KERN_INFO "%d free pages\n", free);
-	printk(KERN_INFO "%d reserved pages\n", reserved);
-	printk(KERN_INFO "%d pages shared\n", shared);
-	printk(KERN_INFO "%d pages swap cached\n", cached);
-}
-
 /*
  * Associate a large virtual page frame with a given physical page frame
  * and protection flags for that frame. pfn is for the base of the page,

-- 

>From hannes@skyscraper.fehenstaub.lan Fri Apr  4 13:26:19 2008
Message-Id: <20080404112618.893606965@skyscraper.fehenstaub.lan>
References: <20080404112404.413840814@skyscraper.fehenstaub.lan>
User-Agent: quilt/0.46-1
Date: Fri, 04 Apr 2008 13:24:18 +0200
From: hannes@saeurebad.de
To: LKML <linux-kernel@vger.kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Subject: [patch 14/22] powerpc: Use generic show_mem()
Content-Disposition: inline; filename=powerpc-use-generic-show_mem.patch

Remove arch-specific show_mem() in favor of the generic version.

This also removes the following redundant information display:

	- pages in swapcache, printed by show_swap_cache_info()

where show_mem() calls show_free_areas(), which calls
show_swap_cache_info().

Signed-off-by: Johannes Weiner <hannes@saeurebad.de>
CC: Paul Mackerras <paulus@samba.org>
---

Index: tree-linus/arch/powerpc/Kconfig
===================================================================
--- tree-linus.orig/arch/powerpc/Kconfig
+++ tree-linus/arch/powerpc/Kconfig
@@ -91,7 +91,6 @@ config PPC
 	select HAVE_OPROFILE
 	select HAVE_KPROBES
 	select HAVE_KRETPROBES
-	select HAVE_ARCH_SHOW_MEM
 
 config EARLY_PRINTK
 	bool
Index: tree-linus/arch/powerpc/mm/mem.c
===================================================================
--- tree-linus.orig/arch/powerpc/mm/mem.c
+++ tree-linus/arch/powerpc/mm/mem.c
@@ -164,45 +164,6 @@ walk_memory_resource(unsigned long start
 
 #endif /* CONFIG_MEMORY_HOTPLUG */
 
-void show_mem(void)
-{
-	unsigned long total = 0, reserved = 0;
-	unsigned long shared = 0, cached = 0;
-	unsigned long highmem = 0;
-	struct page *page;
-	pg_data_t *pgdat;
-	unsigned long i;
-
-	printk("Mem-info:\n");
-	show_free_areas();
-	for_each_online_pgdat(pgdat) {
-		unsigned long flags;
-		pgdat_resize_lock(pgdat, &flags);
-		for (i = 0; i < pgdat->node_spanned_pages; i++) {
-			if (!pfn_valid(pgdat->node_start_pfn + i))
-				continue;
-			page = pgdat_page_nr(pgdat, i);
-			total++;
-			if (PageHighMem(page))
-				highmem++;
-			if (PageReserved(page))
-				reserved++;
-			else if (PageSwapCache(page))
-				cached++;
-			else if (page_count(page))
-				shared += page_count(page) - 1;
-		}
-		pgdat_resize_unlock(pgdat, &flags);
-	}
-	printk("%ld pages of RAM\n", total);
-#ifdef CONFIG_HIGHMEM
-	printk("%ld pages of HIGHMEM\n", highmem);
-#endif
-	printk("%ld reserved pages\n", reserved);
-	printk("%ld pages shared\n", shared);
-	printk("%ld pages swap cached\n", cached);
-}
-
 /*
  * Initialize the bootmem system and give it all the memory we
  * have available.  If we are using highmem, we only put the

-- 

>From hannes@skyscraper.fehenstaub.lan Fri Apr  4 13:26:19 2008
Message-Id: <20080404112619.040708473@skyscraper.fehenstaub.lan>
References: <20080404112404.413840814@skyscraper.fehenstaub.lan>
User-Agent: quilt/0.46-1
Date: Fri, 04 Apr 2008 13:24:19 +0200
From: hannes@saeurebad.de
To: LKML <linux-kernel@vger.kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Subject: [patch 15/22] ppc: Use generic show_mem()
Content-Disposition: inline; filename=ppc-use-generic-show_mem.patch

Remove arch-specific show_mem() in favor of the generic version.

This also removes the following redundant information display:

	- free pages, printed by show_free_areas()
	- pages in swapcache, printed by show_swap_cache_info()

where show_mem() calls show_free_areas(), which calls
show_swap_cache_info().

Signed-off-by: Johannes Weiner <hannes@saeurebad.de>
CC: Paul Mackerras <paulus@samba.org>
---

Index: tree-linus/arch/ppc/Kconfig
===================================================================
--- tree-linus.orig/arch/ppc/Kconfig
+++ tree-linus/arch/ppc/Kconfig
@@ -45,7 +45,6 @@ config PPC
 	select HAVE_IDE
 	select HAVE_OPROFILE
 	select HAVE_KPROBES
-	select HAVE_ARCH_SHOW_MEM
 
 config PPC32
 	bool
Index: tree-linus/arch/ppc/mm/init.c
===================================================================
--- tree-linus.orig/arch/ppc/mm/init.c
+++ tree-linus/arch/ppc/mm/init.c
@@ -101,36 +101,6 @@ unsigned long __max_memory;
 /* max amount of low RAM to map in */
 unsigned long __max_low_memory = MAX_LOW_MEM;
 
-void show_mem(void)
-{
-	int i,free = 0,total = 0,reserved = 0;
-	int shared = 0, cached = 0;
-	int highmem = 0;
-
-	printk("Mem-info:\n");
-	show_free_areas();
-	i = max_mapnr;
-	while (i-- > 0) {
-		total++;
-		if (PageHighMem(mem_map+i))
-			highmem++;
-		if (PageReserved(mem_map+i))
-			reserved++;
-		else if (PageSwapCache(mem_map+i))
-			cached++;
-		else if (!page_count(mem_map+i))
-			free++;
-		else
-			shared += page_count(mem_map+i) - 1;
-	}
-	printk("%d pages of RAM\n",total);
-	printk("%d pages of HIGHMEM\n", highmem);
-	printk("%d free pages\n",free);
-	printk("%d reserved pages\n",reserved);
-	printk("%d pages shared\n",shared);
-	printk("%d pages swap cached\n",cached);
-}
-
 /* Free up now-unused memory */
 static void free_sec(unsigned long start, unsigned long end, const char *name)
 {

-- 

>From hannes@skyscraper.fehenstaub.lan Fri Apr  4 13:26:19 2008
Message-Id: <20080404112619.188248272@skyscraper.fehenstaub.lan>
References: <20080404112404.413840814@skyscraper.fehenstaub.lan>
User-Agent: quilt/0.46-1
Date: Fri, 04 Apr 2008 13:24:20 +0200
From: hannes@saeurebad.de
To: LKML <linux-kernel@vger.kernel.org>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: [patch 16/22] s390: Use generic show_mem()
Content-Disposition: inline; filename=s390-use-generic-show_mem.patch

Remove arch-specific show_mem() in favor of the generic version.

This also removes the following redundant information display:

	- pages in swapcache, printed by show_swap_cache_info()
	- dirty pages, writeback pages, mapped pages, slab pages,
	  pagetable pages, printed by show_free_areas()

where show_mem() calls show_free_areas(), which calls
show_swap_cache_info().

Signed-off-by: Johannes Weiner <hannes@saeurebad.de>
Acked-by: Heiko Carstens <heiko.carstens@de.ibm.com>
---

Index: tree-linus/arch/s390/Kconfig
===================================================================
--- tree-linus.orig/arch/s390/Kconfig
+++ tree-linus/arch/s390/Kconfig
@@ -62,7 +62,6 @@ config S390
 	select HAVE_OPROFILE
 	select HAVE_KPROBES
 	select HAVE_KRETPROBES
-	select HAVE_ARCH_SHOW_MEM
 
 source "init/Kconfig"
 
Index: tree-linus/arch/s390/mm/init.c
===================================================================
--- tree-linus.orig/arch/s390/mm/init.c
+++ tree-linus/arch/s390/mm/init.c
@@ -42,41 +42,6 @@ DEFINE_PER_CPU(struct mmu_gather, mmu_ga
 pgd_t swapper_pg_dir[PTRS_PER_PGD] __attribute__((__aligned__(PAGE_SIZE)));
 char  empty_zero_page[PAGE_SIZE] __attribute__((__aligned__(PAGE_SIZE)));
 
-void show_mem(void)
-{
-	int i, total = 0, reserved = 0;
-	int shared = 0, cached = 0;
-	struct page *page;
-
-	printk("Mem-info:\n");
-	show_free_areas();
-	i = max_mapnr;
-	while (i-- > 0) {
-		if (!pfn_valid(i))
-			continue;
-		page = pfn_to_page(i);
-		total++;
-		if (PageReserved(page))
-			reserved++;
-		else if (PageSwapCache(page))
-			cached++;
-		else if (page_count(page))
-			shared += page_count(page) - 1;
-	}
-	printk("%d pages of RAM\n", total);
-	printk("%d reserved pages\n", reserved);
-	printk("%d pages shared\n", shared);
-	printk("%d pages swap cached\n", cached);
-
-	printk("%lu pages dirty\n", global_page_state(NR_FILE_DIRTY));
-	printk("%lu pages writeback\n", global_page_state(NR_WRITEBACK));
-	printk("%lu pages mapped\n", global_page_state(NR_FILE_MAPPED));
-	printk("%lu pages slab\n",
-	       global_page_state(NR_SLAB_RECLAIMABLE) +
-	       global_page_state(NR_SLAB_UNRECLAIMABLE));
-	printk("%lu pages pagetables\n", global_page_state(NR_PAGETABLE));
-}
-
 static void __init setup_ro_region(void)
 {
 	pgd_t *pgd;

-- 

>From hannes@skyscraper.fehenstaub.lan Fri Apr  4 13:26:19 2008
Message-Id: <20080404112619.335306893@skyscraper.fehenstaub.lan>
References: <20080404112404.413840814@skyscraper.fehenstaub.lan>
User-Agent: quilt/0.46-1
Date: Fri, 04 Apr 2008 13:24:21 +0200
From: hannes@saeurebad.de
To: LKML <linux-kernel@vger.kernel.org>
Cc: Paul Mundt <lethal@linux-sh.org>
Subject: [patch 17/22] sh: Use generic show_mem()
Content-Disposition: inline; filename=sh-use-generic-show_mem.patch

Remove arch-specific show_mem() in favor of the generic version.

This also removes the following redundant information display:

	- free pages, printed by show_free_areas()
	- pages in slab, printed by show_free_areas()
	- pages in swapcache, printed by show_swap_cache_info()

where show_mem() calls show_free_areas(), which calls
show_swap_cache_info().

Signed-off-by: Johannes Weiner <hannes@saeurebad.de>
CC: Paul Mundt <lethal@linux-sh.org>
---

Index: tree-linus/arch/sh/Kconfig
===================================================================
--- tree-linus.orig/arch/sh/Kconfig
+++ tree-linus/arch/sh/Kconfig
@@ -10,7 +10,6 @@ config SUPERH
 	select EMBEDDED
 	select HAVE_IDE
 	select HAVE_OPROFILE
-	select HAVE_ARCH_SHOW_MEM
 	help
 	  The SuperH is a RISC processor targeted for use in embedded systems
 	  and consumer electronics; it was also used in the Sega Dreamcast
Index: tree-linus/arch/sh/mm/init.c
===================================================================
--- tree-linus.orig/arch/sh/mm/init.c
+++ tree-linus/arch/sh/mm/init.c
@@ -25,46 +25,6 @@ DEFINE_PER_CPU(struct mmu_gather, mmu_ga
 pgd_t swapper_pg_dir[PTRS_PER_PGD];
 unsigned long cached_to_uncached = 0;
 
-void show_mem(void)
-{
-	int total = 0, reserved = 0, free = 0;
-	int shared = 0, cached = 0, slab = 0;
-	pg_data_t *pgdat;
-
-	printk("Mem-info:\n");
-	show_free_areas();
-
-	for_each_online_pgdat(pgdat) {
-		unsigned long flags, i;
-
-		pgdat_resize_lock(pgdat, &flags);
-		for (i = 0; i < pgdat->node_spanned_pages; i++) {
-			struct page *page = pgdat_page_nr(pgdat, i);
-			total++;
-			if (PageReserved(page))
-				reserved++;
-			else if (PageSwapCache(page))
-				cached++;
-			else if (PageSlab(page))
-				slab++;
-			else if (!page_count(page))
-				free++;
-			else
-				shared += page_count(page) - 1;
-		}
-		pgdat_resize_unlock(pgdat, &flags);
-	}
-
-	printk("%d pages of RAM\n", total);
-	printk("%d free pages\n", free);
-	printk("%d reserved pages\n", reserved);
-	printk("%d slab pages\n", slab);
-	printk("%d pages shared\n", shared);
-	printk("%d pages swap cached\n", cached);
-	printk(KERN_INFO "Total of %ld pages in page table cache\n",
-	       quicklist_total_size());
-}
-
 #ifdef CONFIG_MMU
 static void set_pte_phys(unsigned long addr, unsigned long phys, pgprot_t prot)
 {

-- 

>From hannes@skyscraper.fehenstaub.lan Fri Apr  4 13:26:19 2008
Message-Id: <20080404112619.481293913@skyscraper.fehenstaub.lan>
References: <20080404112404.413840814@skyscraper.fehenstaub.lan>
User-Agent: quilt/0.46-1
Date: Fri, 04 Apr 2008 13:24:22 +0200
From: hannes@saeurebad.de
To: LKML <linux-kernel@vger.kernel.org>
Cc: "David S. Miller" <davem@davemloft.net>
Subject: [patch 18/22] sparc64: Use generic show_mem()
Content-Disposition: inline; filename=sparc64-use-generic-show_mem.patch

Remove arch-specific show_mem() in favor of the generic version.

This also removes the following redundant information display:

	- pages in swapcache, printed by show_swap_cache_info()
	- dirty pages, writeback pages, mapped pages, slab pages,
	  pagetables pages, printed by show_free_areas()

where show_mem() calls show_free_areas(), which calls
show_swap_cache_info().

Signed-off-by: Johannes Weiner <hannes@saeurebad.de>
CC: David S. Miller <davem@davemloft.net>
---

Index: tree-linus/arch/sparc64/Kconfig
===================================================================
--- tree-linus.orig/arch/sparc64/Kconfig
+++ tree-linus/arch/sparc64/Kconfig
@@ -11,7 +11,6 @@ config SPARC
 	select HAVE_OPROFILE
 	select HAVE_KPROBES
 	select HAVE_KRETPROBES
-	select HAVE_ARCH_SHOW_MEM
 
 config SPARC64
 	bool
Index: tree-linus/arch/sparc64/mm/init.c
===================================================================
--- tree-linus.orig/arch/sparc64/mm/init.c
+++ tree-linus/arch/sparc64/mm/init.c
@@ -391,49 +391,6 @@ void __kprobes flush_icache_range(unsign
 	}
 }
 
-void show_mem(void)
-{
-	unsigned long total = 0, reserved = 0;
-	unsigned long shared = 0, cached = 0;
-	pg_data_t *pgdat;
-
-	printk(KERN_INFO "Mem-info:\n");
-	show_free_areas();
-	for_each_online_pgdat(pgdat) {
-		unsigned long i, flags;
-
-		pgdat_resize_lock(pgdat, &flags);
-		for (i = 0; i < pgdat->node_spanned_pages; i++) {
-			struct page *page = pgdat_page_nr(pgdat, i);
-			total++;
-			if (PageReserved(page))
-				reserved++;
-			else if (PageSwapCache(page))
-				cached++;
-			else if (page_count(page))
-				shared += page_count(page) - 1;
-		}
-		pgdat_resize_unlock(pgdat, &flags);
-	}
-
-	printk(KERN_INFO "%lu pages of RAM\n", total);
-	printk(KERN_INFO "%lu reserved pages\n", reserved);
-	printk(KERN_INFO "%lu pages shared\n", shared);
-	printk(KERN_INFO "%lu pages swap cached\n", cached);
-
-	printk(KERN_INFO "%lu pages dirty\n",
-	       global_page_state(NR_FILE_DIRTY));
-	printk(KERN_INFO "%lu pages writeback\n",
-	       global_page_state(NR_WRITEBACK));
-	printk(KERN_INFO "%lu pages mapped\n",
-	       global_page_state(NR_FILE_MAPPED));
-	printk(KERN_INFO "%lu pages slab\n",
-		global_page_state(NR_SLAB_RECLAIMABLE) +
-		global_page_state(NR_SLAB_UNRECLAIMABLE));
-	printk(KERN_INFO "%lu pages pagetables\n",
-	       global_page_state(NR_PAGETABLE));
-}
-
 void mmu_info(struct seq_file *m)
 {
 	if (tlb_type == cheetah)

-- 

>From hannes@skyscraper.fehenstaub.lan Fri Apr  4 13:26:19 2008
Message-Id: <20080404112619.627629008@skyscraper.fehenstaub.lan>
References: <20080404112404.413840814@skyscraper.fehenstaub.lan>
User-Agent: quilt/0.46-1
Date: Fri, 04 Apr 2008 13:24:23 +0200
From: hannes@saeurebad.de
To: LKML <linux-kernel@vger.kernel.org>
Cc: Jeff Dike <jdike@addtoit.com>
Subject: [patch 19/22] um: Use generic show_mem()
Content-Disposition: inline; filename=um-use-generic-show_mem.patch

Remove arch-specific show_mem() in favor of the generic version.

This also removes the following redundant information display:

	- pages in swapcache, printed by show_swap_cache_info()

where show_mem() calls show_free_areas(), which calls
show_swap_cache_info().

Signed-off-by: Johannes Weiner <hannes@saeurebad.de>
CC: Jeff Dike <jdike@addtoit.com>
---

Index: tree-linus/arch/um/Kconfig
===================================================================
--- tree-linus.orig/arch/um/Kconfig
+++ tree-linus/arch/um/Kconfig
@@ -11,7 +11,6 @@ config GENERIC_HARDIRQS
 config UML
 	bool
 	default y
-	select HAVE_ARCH_SHOW_MEM
 
 config MMU
 	bool
Index: tree-linus/arch/um/kernel/mem.c
===================================================================
--- tree-linus.orig/arch/um/kernel/mem.c
+++ tree-linus/arch/um/kernel/mem.c
@@ -295,35 +295,6 @@ void free_initrd_mem(unsigned long start
 }
 #endif
 
-void show_mem(void)
-{
-	int pfn, total = 0, reserved = 0;
-	int shared = 0, cached = 0;
-	int high_mem = 0;
-	struct page *page;
-
-	printk(KERN_INFO "Mem-info:\n");
-	show_free_areas();
-	pfn = max_mapnr;
-	while (pfn-- > 0) {
-		page = pfn_to_page(pfn);
-		total++;
-		if (PageHighMem(page))
-			high_mem++;
-		if (PageReserved(page))
-			reserved++;
-		else if (PageSwapCache(page))
-			cached++;
-		else if (page_count(page))
-			shared += page_count(page) - 1;
-	}
-	printk(KERN_INFO "%d pages of RAM\n", total);
-	printk(KERN_INFO "%d pages of HIGHMEM\n", high_mem);
-	printk(KERN_INFO "%d reserved pages\n", reserved);
-	printk(KERN_INFO "%d pages shared\n", shared);
-	printk(KERN_INFO "%d pages swap cached\n", cached);
-}
-
 /* Allocate and free page tables. */
 
 pgd_t *pgd_alloc(struct mm_struct *mm)

-- 

>From hannes@skyscraper.fehenstaub.lan Fri Apr  4 13:26:19 2008
Message-Id: <20080404112619.774447594@skyscraper.fehenstaub.lan>
References: <20080404112404.413840814@skyscraper.fehenstaub.lan>
User-Agent: quilt/0.46-1
Date: Fri, 04 Apr 2008 13:24:24 +0200
From: hannes@saeurebad.de
To: LKML <linux-kernel@vger.kernel.org>
Cc: Miles Bader <miles@gnu.org>
Subject: [patch 20/22] v850: Use generic show_mem()
Content-Disposition: inline; filename=v850-use-generic-show_mem.patch

Remove arch-specific show_mem() in favor of the generic version.

This also removes the following redundant information display:

	- free pages, printed in show_free_areas()
	- pages in swapcache, printed by show_swap_cache_info()

where show_mem() calls show_free_areas(), which calls
show_swap_cache_info().

Signed-off-by: Johannes Weiner <hannes@saeurebad.de>
CC: Miles Bader <miles@gnu.org>
---

Index: tree-linus/arch/v850/Kconfig
===================================================================
--- tree-linus.orig/arch/v850/Kconfig
+++ tree-linus/arch/v850/Kconfig
@@ -79,7 +79,6 @@ config V850
 	bool
 	default y
 	select HAVE_IDE
-	select HAVE_ARCH_SHOW_MEM
 
 menu "Processor type and features"
 
Index: tree-linus/arch/v850/kernel/setup.c
===================================================================
--- tree-linus.orig/arch/v850/kernel/setup.c
+++ tree-linus/arch/v850/kernel/setup.c
@@ -298,33 +298,3 @@ init_mem_alloc (unsigned long ram_start,
 	free_area_init_node (0, NODE_DATA(0), zones_size,
 			     ADDR_TO_PAGE (PAGE_OFFSET), 0);
 }
-
-
-
-/* Taken from m68knommu */
-void show_mem(void)
-{
-    unsigned long i;
-    int free = 0, total = 0, reserved = 0, shared = 0;
-    int cached = 0;
-
-    printk(KERN_INFO "\nMem-info:\n");
-    show_free_areas();
-    i = max_mapnr;
-    while (i-- > 0) {
-	total++;
-	if (PageReserved(mem_map+i))
-	    reserved++;
-	else if (PageSwapCache(mem_map+i))
-	    cached++;
-	else if (!page_count(mem_map+i))
-	    free++;
-	else
-	    shared += page_count(mem_map+i) - 1;
-    }
-    printk(KERN_INFO "%d pages of RAM\n",total);
-    printk(KERN_INFO "%d free pages\n",free);
-    printk(KERN_INFO "%d reserved pages\n",reserved);
-    printk(KERN_INFO "%d pages shared\n",shared);
-    printk(KERN_INFO "%d pages swap cached\n",cached);
-}

-- 

>From hannes@skyscraper.fehenstaub.lan Fri Apr  4 13:26:20 2008
Message-Id: <20080404112619.921150040@skyscraper.fehenstaub.lan>
References: <20080404112404.413840814@skyscraper.fehenstaub.lan>
User-Agent: quilt/0.46-1
Date: Fri, 04 Apr 2008 13:24:25 +0200
From: hannes@saeurebad.de
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>
Subject: [patch 21/22] x86: Use generic show_mem()
Content-Disposition: inline; filename=x86-use-generic-show_mem.patch

Remove arch-specific show_mem() in favor of the generic version.

This also removes the following redundant information display:

	- pages in swapcache, printed by show_swap_cache_info()
	- dirty pages, writeback pages, mapped pages, slab pages,
	  pagetable pages, printed by show_free_areas()

where show_mem() calls show_free_areas(), which calls
show_swap_cache_info().

Signed-off-by: Johannes Weiner <hannes@saeurebad.de>
Acked-by: Ingo Molnar <mingo@elte.hu>
---

Index: tree-linus/arch/x86/Kconfig
===================================================================
--- tree-linus.orig/arch/x86/Kconfig
+++ tree-linus/arch/x86/Kconfig
@@ -23,7 +23,7 @@ config X86
 	select HAVE_KPROBES
 	select HAVE_KRETPROBES
 	select HAVE_KVM if ((X86_32 && !X86_VOYAGER && !X86_VISWS && !X86_NUMAQ) || X86_64)
-	select HAVE_ARCH_SHOW_MEM
+
 
 config GENERIC_LOCKBREAK
 	def_bool n
Index: tree-linus/arch/x86/mm/pgtable_32.c
===================================================================
--- tree-linus.orig/arch/x86/mm/pgtable_32.c
+++ tree-linus/arch/x86/mm/pgtable_32.c
@@ -24,53 +24,6 @@
 #include <asm/tlb.h>
 #include <asm/tlbflush.h>
 
-void show_mem(void)
-{
-	int total = 0, reserved = 0;
-	int shared = 0, cached = 0;
-	int highmem = 0;
-	struct page *page;
-	pg_data_t *pgdat;
-	unsigned long i;
-	unsigned long flags;
-
-	printk(KERN_INFO "Mem-info:\n");
-	show_free_areas();
-	for_each_online_pgdat(pgdat) {
-		pgdat_resize_lock(pgdat, &flags);
-		for (i = 0; i < pgdat->node_spanned_pages; ++i) {
-			if (unlikely(i % MAX_ORDER_NR_PAGES == 0))
-				touch_nmi_watchdog();
-			page = pgdat_page_nr(pgdat, i);
-			total++;
-			if (PageHighMem(page))
-				highmem++;
-			if (PageReserved(page))
-				reserved++;
-			else if (PageSwapCache(page))
-				cached++;
-			else if (page_count(page))
-				shared += page_count(page) - 1;
-		}
-		pgdat_resize_unlock(pgdat, &flags);
-	}
-	printk(KERN_INFO "%d pages of RAM\n", total);
-	printk(KERN_INFO "%d pages of HIGHMEM\n", highmem);
-	printk(KERN_INFO "%d reserved pages\n", reserved);
-	printk(KERN_INFO "%d pages shared\n", shared);
-	printk(KERN_INFO "%d pages swap cached\n", cached);
-
-	printk(KERN_INFO "%lu pages dirty\n", global_page_state(NR_FILE_DIRTY));
-	printk(KERN_INFO "%lu pages writeback\n",
-					global_page_state(NR_WRITEBACK));
-	printk(KERN_INFO "%lu pages mapped\n", global_page_state(NR_FILE_MAPPED));
-	printk(KERN_INFO "%lu pages slab\n",
-		global_page_state(NR_SLAB_RECLAIMABLE) +
-		global_page_state(NR_SLAB_UNRECLAIMABLE));
-	printk(KERN_INFO "%lu pages pagetables\n",
-					global_page_state(NR_PAGETABLE));
-}
-
 /*
  * Associate a virtual page frame with a given physical page frame 
  * and protection flags for that frame.
Index: tree-linus/arch/x86/mm/init_64.c
===================================================================
--- tree-linus.orig/arch/x86/mm/init_64.c
+++ tree-linus/arch/x86/mm/init_64.c
@@ -60,43 +60,6 @@ DEFINE_PER_CPU(struct mmu_gather, mmu_ga
  * around without checking the pgd every time.
  */
 
-void show_mem(void)
-{
-	long i, total = 0, reserved = 0;
-	long shared = 0, cached = 0;
-	struct page *page;
-	pg_data_t *pgdat;
-
-	printk(KERN_INFO "Mem-info:\n");
-	show_free_areas();
-	for_each_online_pgdat(pgdat) {
-		for (i = 0; i < pgdat->node_spanned_pages; ++i) {
-			/*
-			 * This loop can take a while with 256 GB and
-			 * 4k pages so defer the NMI watchdog:
-			 */
-			if (unlikely(i % MAX_ORDER_NR_PAGES == 0))
-				touch_nmi_watchdog();
-
-			if (!pfn_valid(pgdat->node_start_pfn + i))
-				continue;
-
-			page = pfn_to_page(pgdat->node_start_pfn + i);
-			total++;
-			if (PageReserved(page))
-				reserved++;
-			else if (PageSwapCache(page))
-				cached++;
-			else if (page_count(page))
-				shared += page_count(page) - 1;
-		}
-	}
-	printk(KERN_INFO "%lu pages of RAM\n",		total);
-	printk(KERN_INFO "%lu reserved pages\n",	reserved);
-	printk(KERN_INFO "%lu pages shared\n",		shared);
-	printk(KERN_INFO "%lu pages swap cached\n",	cached);
-}
-
 int after_bootmem;
 
 static __init void *spp_getpage(void)

-- 

>From hannes@skyscraper.fehenstaub.lan Fri Apr  4 13:26:20 2008
Message-Id: <20080404112620.067533141@skyscraper.fehenstaub.lan>
References: <20080404112404.413840814@skyscraper.fehenstaub.lan>
User-Agent: quilt/0.46-1
Date: Fri, 04 Apr 2008 13:24:26 +0200
From: hannes@saeurebad.de
To: LKML <linux-kernel@vger.kernel.org>
Cc: Chris Zankel <chris@zankel.net>
Subject: [patch 22/22] xtensa: Use generic show_mem()
Content-Disposition: inline; filename=xtensa-use-generic-show_mem.patch

Remove arch-specific show_mem() in favor of the generic version.

This also removes the following redundant information display:

	- free pages, printed by show_free_areas()
	- pages in swapcache, printed by show_swap_cache_info()

where show_mem() calls show_free_areas(), which calls
show_swap_cache_info().

Signed-off-by: Johannes Weiner <hannes@saeurebad.de>
CC: Chris Zankel <chris@zankel.net>
---

Index: tree-linus/arch/xtensa/Kconfig
===================================================================
--- tree-linus.orig/arch/xtensa/Kconfig
+++ tree-linus/arch/xtensa/Kconfig
@@ -15,7 +15,6 @@ config XTENSA
 	bool
 	default y
 	select HAVE_IDE
-	select HAVE_ARCH_SHOW_MEM
 	help
 	  Xtensa processors are 32-bit RISC machines designed by Tensilica
 	  primarily for embedded systems.  These processors are both
Index: tree-linus/arch/xtensa/mm/init.c
===================================================================
--- tree-linus.orig/arch/xtensa/mm/init.c
+++ tree-linus/arch/xtensa/mm/init.c
@@ -280,32 +280,6 @@ void free_initmem(void)
 	       (&__init_end - &__init_begin) >> 10);
 }
 
-void show_mem(void)
-{
-	int i, free = 0, total = 0, reserved = 0;
-	int shared = 0, cached = 0;
-
-	printk("Mem-info:\n");
-	show_free_areas();
-	i = max_mapnr;
-	while (i-- > 0) {
-		total++;
-		if (PageReserved(mem_map+i))
-			reserved++;
-		else if (PageSwapCache(mem_map+i))
-			cached++;
-		else if (!page_count(mem_map + i))
-			free++;
-		else
-			shared += page_count(mem_map + i) - 1;
-	}
-	printk("%d pages of RAM\n", total);
-	printk("%d reserved pages\n", reserved);
-	printk("%d pages shared\n", shared);
-	printk("%d pages swap cached\n",cached);
-	printk("%d free pages\n", free);
-}
-
 struct kmem_cache *pgtable_cache __read_mostly;
 
 static void pgd_ctor(struct kmem_cache *cache, void* addr)

-- 

