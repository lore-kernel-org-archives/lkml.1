Return-Path: <linux-kernel-owner+w=401wt.eu-S1754579AbYFQC5u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754579AbYFQC5u (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2008 22:57:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753246AbYFQC5j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jun 2008 22:57:39 -0400
Received: from rv-out-0506.google.com ([209.85.198.233]:19090 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751035AbYFQC5i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2008 22:57:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:reply-to:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=kvmm1WMcRoZqg3GmOWVDd73T8KHsoCQFjk4efyYJEN16FVtNIWWfeoA5FpAkTPg3qH
         c7Xg5EkZxpS2hXCx3x/d6LETPZSBmUdJId6YJDjjQEO3kIesjAnuzCAXFDPBHUKyWc1W
         YxMwCwNltB6JmgP8UxpLTElG1VevmQDPfJXP8=
From: Yinghai Lu <yhlu.kernel@gmail.com>
Reply-To: Yinghai Lu <yhlu.kernel@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH] x86: merge setup_memory_map with e820
Date: Mon, 16 Jun 2008 19:58:28 -0700
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <200806161303.31997.yhlu.kernel@gmail.com>
In-Reply-To: <200806161303.31997.yhlu.kernel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806161958.28627.yhlu.kernel@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


and kill e820_32/64.c and e820_32/64.h

Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>

Index: linux-2.6/arch/x86/mm/init_64.c
===================================================================
--- linux-2.6.orig/arch/x86/mm/init_64.c
+++ linux-2.6/arch/x86/mm/init_64.c
@@ -48,6 +48,18 @@
 #include <asm/numa.h>
 #include <asm/cacheflush.h>
 
+/*
+ * PFN of last memory page.
+ */
+unsigned long end_pfn;
+
+/*
+ * end_pfn only includes RAM, while max_pfn_mapped includes all e820 entries.
+ * The direct mapping extends to max_pfn_mapped, so that we can directly access
+ * apertures, ACPI and other tables without having to play with fixmaps.
+ */
+unsigned long max_pfn_mapped;
+
 static unsigned long dma_reserve __initdata;
 
 DEFINE_PER_CPU(struct mmu_gather, mmu_gathers);
Index: linux-2.6/arch/x86/kernel/setup_64.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/setup_64.c
+++ linux-2.6/arch/x86/kernel/setup_64.c
@@ -281,12 +281,6 @@ static inline void __init reserve_crashk
 {}
 #endif
 
-/* Overridden in paravirt.c if CONFIG_PARAVIRT */
-void __attribute__((weak)) __init memory_setup(void)
-{
-       machine_specific_memory_setup();
-}
-
 /* Current gdt points %fs at the "master" per-cpu area: after this,
  * it's on the real one. */
 void switch_to_new_gdt(void)
@@ -330,7 +324,7 @@ void __init setup_arch(char **cmdline_p)
 
 	ARCH_SETUP
 
-	memory_setup();
+	setup_memory_map();
 	copy_edd();
 
 	if (!boot_params.hdr.root_flags)
Index: linux-2.6/arch/x86/kernel/e820_64.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/e820_64.c
+++ /dev/null
@@ -1,92 +0,0 @@
-/*
- * Handle the memory map.
- * The functions here do the job until bootmem takes over.
- *
- *  Getting sanitize_e820_map() in sync with i386 version by applying change:
- *  -  Provisions for empty E820 memory regions (reported by certain BIOSes).
- *     Alex Achenbach <xela@slit.de>, December 2002.
- *  Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
- *
- */
-#include <linux/kernel.h>
-#include <linux/types.h>
-#include <linux/init.h>
-#include <linux/bootmem.h>
-#include <linux/ioport.h>
-#include <linux/string.h>
-#include <linux/kexec.h>
-#include <linux/module.h>
-#include <linux/mm.h>
-#include <linux/pfn.h>
-#include <linux/pci.h>
-
-#include <asm/pgtable.h>
-#include <asm/page.h>
-#include <asm/e820.h>
-#include <asm/proto.h>
-#include <asm/setup.h>
-#include <asm/sections.h>
-#include <asm/kdebug.h>
-#include <asm/trampoline.h>
-
-/*
- * PFN of last memory page.
- */
-unsigned long end_pfn;
-
-/*
- * end_pfn only includes RAM, while max_pfn_mapped includes all e820 entries.
- * The direct mapping extends to max_pfn_mapped, so that we can directly access
- * apertures, ACPI and other tables without having to play with fixmaps.
- */
-unsigned long max_pfn_mapped;
-
-static void early_panic(char *msg)
-{
-	early_printk(msg);
-	panic(msg);
-}
-
-/* We're not void only for x86 32-bit compat */
-char *__init machine_specific_memory_setup(void)
-{
-	char *who = "BIOS-e820";
-	int new_nr;
-	/*
-	 * Try to copy the BIOS-supplied E820-map.
-	 *
-	 * Otherwise fake a memory map; one section from 0k->640k,
-	 * the next section from 1mb->appropriate_mem_k
-	 */
-	new_nr = boot_params.e820_entries;
-	sanitize_e820_map(boot_params.e820_map,
-			ARRAY_SIZE(boot_params.e820_map),
-			&new_nr);
-	boot_params.e820_entries = new_nr;
-	if (copy_e820_map(boot_params.e820_map, boot_params.e820_entries) < 0)
-		early_panic("Cannot find a valid memory map");
-	printk(KERN_INFO "BIOS-provided physical RAM map:\n");
-	e820_print_map(who);
-
-	/* In case someone cares... */
-	return who;
-}
-
-int __init arch_get_ram_range(int slot, u64 *addr, u64 *size)
-{
-	int i;
-
-	if (slot < 0 || slot >= e820.nr_map)
-		return -1;
-	for (i = slot; i < e820.nr_map; i++) {
-		if (e820.map[i].type != E820_RAM)
-			continue;
-		break;
-	}
-	if (i == e820.nr_map || e820.map[i].addr > (max_pfn << PAGE_SHIFT))
-		return -1;
-	*addr = e820.map[i].addr;
-	*size = min_t(u64, e820.map[i].size + e820.map[i].addr,
-		max_pfn << PAGE_SHIFT) - *addr;
-	return i + 1;
-}
Index: linux-2.6/arch/x86/kernel/e820_32.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/e820_32.c
+++ /dev/null
@@ -1,29 +0,0 @@
-#include <linux/kernel.h>
-#include <linux/types.h>
-#include <linux/init.h>
-#include <linux/bootmem.h>
-#include <linux/ioport.h>
-#include <linux/string.h>
-#include <linux/kexec.h>
-#include <linux/module.h>
-#include <linux/mm.h>
-#include <linux/pfn.h>
-#include <linux/uaccess.h>
-
-#include <asm/pgtable.h>
-#include <asm/page.h>
-#include <asm/e820.h>
-#include <asm/setup.h>
-
-/* Overridden in paravirt.c if CONFIG_PARAVIRT */
-char * __init __attribute__((weak)) memory_setup(void)
-{
-	return machine_specific_memory_setup();
-}
-
-void __init setup_memory_map(void)
-{
-	printk(KERN_INFO "BIOS-provided physical RAM map:\n");
-	e820_print_map(memory_setup());
-}
-
Index: linux-2.6/arch/x86/kernel/e820.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/e820.c
+++ linux-2.6/arch/x86/kernel/e820.c
@@ -996,4 +996,76 @@ void __init e820_reserve_resources(void)
 	}
 }
 
+char *__init __attribute__((weak)) machine_specific_memory_setup(void)
+{
+	char *who = "BIOS-e820";
+	int new_nr;
+	/*
+	 * Try to copy the BIOS-supplied E820-map.
+	 *
+	 * Otherwise fake a memory map; one section from 0k->640k,
+	 * the next section from 1mb->appropriate_mem_k
+	 */
+	new_nr = boot_params.e820_entries;
+	sanitize_e820_map(boot_params.e820_map,
+			ARRAY_SIZE(boot_params.e820_map),
+			&new_nr);
+	boot_params.e820_entries = new_nr;
+	if (copy_e820_map(boot_params.e820_map, boot_params.e820_entries) < 0) {
+#ifdef CONFIG_X86_64
+		early_panic("Cannot find a valid memory map");
+#else
+		unsigned long mem_size;
 
+		/* compare results from other methods and take the greater */
+		if (boot_params.alt_mem_k
+		    < boot_params.screen_info.ext_mem_k) {
+			mem_size = boot_params.screen_info.ext_mem_k;
+			who = "BIOS-88";
+		} else {
+			mem_size = boot_params.alt_mem_k;
+			who = "BIOS-e801";
+		}
+
+		e820.nr_map = 0;
+		e820_add_region(0, LOWMEMSIZE(), E820_RAM);
+		e820_add_region(HIGH_MEMORY, mem_size << 10, E820_RAM);
+#endif
+	}
+
+	/* In case someone cares... */
+	return who;
+}
+
+/* Overridden in paravirt.c if CONFIG_PARAVIRT */
+char * __init __attribute__((weak)) memory_setup(void)
+{
+	return machine_specific_memory_setup();
+}
+
+void __init setup_memory_map(void)
+{
+	printk(KERN_INFO "BIOS-provided physical RAM map:\n");
+	e820_print_map(memory_setup());
+}
+
+#ifdef CONFIG_X86_64
+int __init arch_get_ram_range(int slot, u64 *addr, u64 *size)
+{
+	int i;
+
+	if (slot < 0 || slot >= e820.nr_map)
+		return -1;
+	for (i = slot; i < e820.nr_map; i++) {
+		if (e820.map[i].type != E820_RAM)
+			continue;
+		break;
+	}
+	if (i == e820.nr_map || e820.map[i].addr > (max_pfn << PAGE_SHIFT))
+		return -1;
+	*addr = e820.map[i].addr;
+	*size = min_t(u64, e820.map[i].size + e820.map[i].addr,
+		max_pfn << PAGE_SHIFT) - *addr;
+	return i + 1;
+}
+#endif
Index: linux-2.6/include/asm-x86/e820_32.h
===================================================================
--- linux-2.6.orig/include/asm-x86/e820_32.h
+++ /dev/null
@@ -1,24 +0,0 @@
-/*
- * structures and definitions for the int 15, ax=e820 memory map
- * scheme.
- *
- * In a nutshell, arch/i386/boot/setup.S populates a scratch table
- * in the empty_zero_block that contains a list of usable address/size
- * duples.   In arch/i386/kernel/setup.c, this information is
- * transferred into the e820map, and in arch/i386/mm/init.c, that
- * new information is used to mark pages reserved or not.
- *
- */
-#ifndef __E820_HEADER
-#define __E820_HEADER
-
-#include <linux/ioport.h>
-
-#define HIGH_MEMORY	(1024*1024)
-
-#ifndef __ASSEMBLY__
-
-extern void setup_memory_map(void);
-
-#endif/*!__ASSEMBLY__*/
-#endif/*__E820_HEADER*/
Index: linux-2.6/include/asm-x86/e820_64.h
===================================================================
--- linux-2.6.orig/include/asm-x86/e820_64.h
+++ /dev/null
@@ -1,26 +0,0 @@
-/*
- * structures and definitions for the int 15, ax=e820 memory map
- * scheme.
- *
- * In a nutshell, setup.S populates a scratch table in the
- * empty_zero_block that contains a list of usable address/size
- * duples.  setup.c, this information is transferred into the e820map,
- * and in init.c/numa.c, that new information is used to mark pages
- * reserved or not.
- */
-#ifndef __E820_HEADER
-#define __E820_HEADER
-
-#include <linux/ioport.h>
-
-#ifndef __ASSEMBLY__
-extern void setup_memory_region(void);
-extern void contig_e820_setup(void);
-extern int e820_any_non_reserved(unsigned long start, unsigned long end);
-extern int is_memory_any_valid(unsigned long start, unsigned long end);
-extern int e820_all_non_reserved(unsigned long start, unsigned long end);
-extern int is_memory_all_valid(unsigned long start, unsigned long end);
-
-#endif/*!__ASSEMBLY__*/
-
-#endif/*__E820_HEADER*/
Index: linux-2.6/include/asm-x86/e820.h
===================================================================
--- linux-2.6.orig/include/asm-x86/e820.h
+++ linux-2.6/include/asm-x86/e820.h
@@ -99,6 +99,9 @@ extern void e820_register_active_regions
 extern u64 e820_hole_size(u64 start, u64 end);
 extern void finish_e820_parsing(void);
 extern void e820_reserve_resources(void);
+extern void setup_memory_map(void);
+extern char *machine_specific_memory_setup(void);
+extern char *memory_setup(void);
 
 #endif /* __ASSEMBLY__ */
 
@@ -109,10 +112,10 @@ extern void e820_reserve_resources(void)
 #define BIOS_END		0x00100000
 
 #ifdef __KERNEL__
+#include <linux/ioport.h>
+
 #ifdef CONFIG_X86_32
-# include "e820_32.h"
-#else
-# include "e820_64.h"
+#define HIGH_MEMORY	(1024*1024)
 #endif
 #endif /* __KERNEL__ */
 
Index: linux-2.6/arch/x86/mach-default/setup.c
===================================================================
--- linux-2.6.orig/arch/x86/mach-default/setup.c
+++ linux-2.6/arch/x86/mach-default/setup.c
@@ -142,50 +142,3 @@ static int __init print_ipi_mode(void)
 
 late_initcall(print_ipi_mode);
 
-/**
- * machine_specific_memory_setup - Hook for machine specific memory setup.
- *
- * Description:
- *	This is included late in kernel/setup.c so that it can make
- *	use of all of the static functions.
- **/
-
-char * __init machine_specific_memory_setup(void)
-{
-	char *who;
-	int new_nr;
-
-
-	who = "BIOS-e820";
-
-	/*
-	 * Try to copy the BIOS-supplied E820-map.
-	 *
-	 * Otherwise fake a memory map; one section from 0k->640k,
-	 * the next section from 1mb->appropriate_mem_k
-	 */
-	new_nr = boot_params.e820_entries;
-	sanitize_e820_map(boot_params.e820_map,
-			ARRAY_SIZE(boot_params.e820_map),
-			&new_nr);
-	boot_params.e820_entries = new_nr;
-	if (copy_e820_map(boot_params.e820_map, boot_params.e820_entries)
-	    < 0) {
-		unsigned long mem_size;
-
-		/* compare results from other methods and take the greater */
-		if (boot_params.alt_mem_k
-		    < boot_params.screen_info.ext_mem_k) {
-			mem_size = boot_params.screen_info.ext_mem_k;
-			who = "BIOS-88";
-		} else {
-			mem_size = boot_params.alt_mem_k;
-			who = "BIOS-e801";
-		}
-
-		e820.nr_map = 0;
-		e820_add_region(0, LOWMEMSIZE(), E820_RAM);
-		e820_add_region(HIGH_MEMORY, mem_size << 10, E820_RAM);
-  	}
-	return who;
-}
Index: linux-2.6/include/asm-x86/setup.h
===================================================================
--- linux-2.6.orig/include/asm-x86/setup.h
+++ linux-2.6/include/asm-x86/setup.h
@@ -8,7 +8,6 @@
 /* Interrupt control for vSMPowered x86_64 systems */
 void vsmp_init(void);
 
-char *machine_specific_memory_setup(void);
 #ifndef CONFIG_PARAVIRT
 #define paravirt_post_allocator_init()	do {} while (0)
 #endif
@@ -50,10 +49,6 @@ extern struct boot_params boot_params;
  */
 #define LOWMEMSIZE()	(0x9f000)
 
-char * __init machine_specific_memory_setup(void);
-char *memory_setup(void);
-
-
 void __init i386_start_kernel(void);
 
 extern unsigned long init_pg_tables_start;
Index: linux-2.6/arch/x86/kernel/Makefile
===================================================================
--- linux-2.6.orig/arch/x86/kernel/Makefile
+++ linux-2.6/arch/x86/kernel/Makefile
@@ -30,7 +30,7 @@ obj-y			+= setup_$(BITS).o i8259.o irqin
 obj-$(CONFIG_X86_32)	+= sys_i386_32.o i386_ksyms_32.o
 obj-$(CONFIG_X86_64)	+= sys_x86_64.o x8664_ksyms_64.o
 obj-$(CONFIG_X86_64)	+= syscall_64.o vsyscall_64.o setup64.o
-obj-y			+= bootflag.o e820_$(BITS).o e820.o
+obj-y			+= bootflag.o e820.o
 obj-y			+= pci-dma.o quirks.o i8237.o topology.o kdebugfs.o
 obj-y			+= alternative.o i8253.o pci-nommu.o
 obj-y			+= tsc_$(BITS).o io_delay.o rtc.o
