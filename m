Return-Path: <linux-kernel-owner+w=401wt.eu-S1752085AbYAPWeZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752085AbYAPWeZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2008 17:34:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757086AbYAPW1P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jan 2008 17:27:15 -0500
Received: from mail.suse.de ([195.135.220.2]:56770 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756210AbYAPW1M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2008 17:27:12 -0500
From: Andi Kleen <ak@suse.de>
References: <200801161127.268350000@suse.de>
In-Reply-To: <200801161127.268350000@suse.de>
To: peterz@infradead.org, mingo@elte.hu, tglx@linutronix.de,
       linux-kernel@vger.kernel.org
Subject: [PATCH] [5/7] Replace hard coded reservations in x86-64 early boot code with dynamic table v2
Message-Id: <20080116222708.A0DBB14EE3@wotan.suse.de>
Date: Wed, 16 Jan 2008 23:27:08 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On x86-64 there are several memory allocations before bootmem. To avoid
them stomping on each other they used to be all hard coded in bad_area().
Replace this with an array that is filled as needed.

This cleans up the code considerably and allows to expand its use.

v1->v2: add one tab

Cc: peterz@infradead.org

Signed-off-by: Andi Kleen <ak@suse.de>

---
 arch/x86/kernel/e820_64.c  |   95 ++++++++++++++++++++++++---------------------
 arch/x86/kernel/head64.c   |   48 ++++++++++++++++++++++
 arch/x86/kernel/setup_64.c |   72 +---------------------------------
 arch/x86/mm/init_64.c      |    5 +-
 arch/x86/mm/numa_64.c      |    1 
 include/asm-x86/e820_64.h  |    4 -
 include/asm-x86/proto.h    |    2 
 7 files changed, 110 insertions(+), 117 deletions(-)

Index: linux/arch/x86/kernel/e820_64.c
===================================================================
--- linux.orig/arch/x86/kernel/e820_64.c
+++ linux/arch/x86/kernel/e820_64.c
@@ -47,56 +47,65 @@ unsigned long end_pfn_map;
  */
 static unsigned long __initdata end_user_pfn = MAXMEM>>PAGE_SHIFT;
 
-/* Check for some hardcoded bad areas that early boot is not allowed to touch */
-static inline int bad_addr(unsigned long *addrp, unsigned long size)
-{
-	unsigned long addr = *addrp, last = addr + size;
-
-	/* various gunk below that needed for SMP startup */
-	if (addr < 0x8000) {
-		*addrp = PAGE_ALIGN(0x8000);
-		return 1;
-	}
-
-	/* direct mapping tables of the kernel */
-	if (last >= table_start<<PAGE_SHIFT && addr < table_end<<PAGE_SHIFT) {
-		*addrp = PAGE_ALIGN(table_end << PAGE_SHIFT);
-		return 1;
-	}
-
-	/* initrd */
-#ifdef CONFIG_BLK_DEV_INITRD
-	if (boot_params.hdr.type_of_loader && boot_params.hdr.ramdisk_image) {
-		unsigned long ramdisk_image = boot_params.hdr.ramdisk_image;
-		unsigned long ramdisk_size  = boot_params.hdr.ramdisk_size;
-		unsigned long ramdisk_end   = ramdisk_image+ramdisk_size;
+/*
+ * Early reserved memory areas.
+ */
+#define MAX_EARLY_RES 20
 
-		if (last >= ramdisk_image && addr < ramdisk_end) {
-			*addrp = PAGE_ALIGN(ramdisk_end);
-			return 1;
-		}
-	}
+struct early_res {
+	unsigned long start, end;
+};
+static struct early_res early_res[MAX_EARLY_RES] __initdata = {
+	{ 0, PAGE_SIZE },			/* BIOS data page */
+#ifdef CONFIG_SMP
+	{ SMP_TRAMPOLINE_BASE, SMP_TRAMPOLINE_BASE + 2*PAGE_SIZE },
 #endif
-	/* kernel code */
-	if (last >= __pa_symbol(&_text) && addr < __pa_symbol(&_end)) {
-		*addrp = PAGE_ALIGN(__pa_symbol(&_end));
-		return 1;
+	{}
+};
+
+void __init reserve_early(unsigned long start, unsigned long end)
+{
+	int i;
+	struct early_res *r;
+	for (i = 0; i < MAX_EARLY_RES && early_res[i].end; i++) {
+		r = &early_res[i];
+		if (end > r->start && start < r->end)
+			panic("Duplicated early reservation %lx-%lx\n",
+			      start, end);
 	}
+	if (i >= MAX_EARLY_RES)
+		panic("Too many early reservations");
+	r = &early_res[i];
+	r->start = start;
+	r->end = end;
+}
 
-	if (last >= ebda_addr && addr < ebda_addr + ebda_size) {
-		*addrp = PAGE_ALIGN(ebda_addr + ebda_size);
-		return 1;
+void __init early_res_to_bootmem(void)
+{
+	int i;
+	for (i = 0; i < MAX_EARLY_RES && early_res[i].end; i++) {
+		struct early_res *r = &early_res[i];
+		reserve_bootmem_generic(r->start, r->end - r->start);
 	}
+}
 
-#ifdef CONFIG_NUMA
-	/* NUMA memory to node map */
-	if (last >= nodemap_addr && addr < nodemap_addr + nodemap_size) {
-		*addrp = nodemap_addr + nodemap_size;
-		return 1;
+/* Check for already reserved areas */
+static inline int bad_addr(unsigned long *addrp, unsigned long size)
+{
+	int i;
+	unsigned long addr = *addrp, last;
+	int changed = 0;
+again:
+	last = addr + size;
+	for (i = 0; i < MAX_EARLY_RES && early_res[i].end; i++) {
+		struct early_res *r = &early_res[i];
+		if (last >= r->start && addr < r->end) {
+			*addrp = addr = r->end;
+			changed = 1;
+			goto again;
+		}
 	}
-#endif
-	/* XXX ramdisk image here? */
-	return 0;
+	return changed;
 }
 
 /*
Index: linux/arch/x86/kernel/head64.c
===================================================================
--- linux.orig/arch/x86/kernel/head64.c
+++ linux/arch/x86/kernel/head64.c
@@ -21,6 +21,7 @@
 #include <asm/tlbflush.h>
 #include <asm/sections.h>
 #include <asm/kdebug.h>
+#include <asm/e820.h>
 
 static void __init zap_identity_mappings(void)
 {
@@ -48,6 +49,35 @@ static void __init copy_bootdata(char *r
 	}
 }
 
+#define EBDA_ADDR_POINTER 0x40E
+
+static __init void reserve_ebda(void)
+{
+	unsigned ebda_addr, ebda_size;
+
+	/*
+	 * there is a real-mode segmented pointer pointing to the
+	 * 4K EBDA area at 0x40E
+	 */
+	ebda_addr = *(unsigned short *)__va(EBDA_ADDR_POINTER);
+	ebda_addr <<= 4;
+
+	if (!ebda_addr)
+		return;
+
+	ebda_size = *(unsigned short *)__va(ebda_addr);
+
+	/* Round EBDA up to pages */
+	if (ebda_size == 0)
+		ebda_size = 1;
+	ebda_size <<= 10;
+	ebda_size = round_up(ebda_size + (ebda_addr & ~PAGE_MASK), PAGE_SIZE);
+	if (ebda_size > 64*1024)
+		ebda_size = 64*1024;
+
+	reserve_early(ebda_addr, ebda_addr + ebda_size);
+}
+
 void __init x86_64_start_kernel(char * real_mode_data)
 {
 	int i;
@@ -75,5 +105,23 @@ void __init x86_64_start_kernel(char * r
 	pda_init(0);
 	copy_bootdata(__va(real_mode_data));
 
+	reserve_early(__pa_symbol(&_text), __pa_symbol(&_end));
+
+	/* Reserve INITRD */
+	if (boot_params.hdr.type_of_loader && boot_params.hdr.ramdisk_image) {
+		unsigned long ramdisk_image = boot_params.hdr.ramdisk_image;
+		unsigned long ramdisk_size  = boot_params.hdr.ramdisk_size;
+		unsigned long ramdisk_end   = ramdisk_image + ramdisk_size;
+		reserve_early(ramdisk_image, ramdisk_end);
+	}
+
+	reserve_ebda();
+
+	/*
+	 * At this point everything still needed from the boot loader
+	 * or BIOS or kernel text should be early reserved or marked not
+	 * RAM in e820. All other memory is free game.
+	 */
+
 	start_kernel();
 }
Index: linux/arch/x86/kernel/setup_64.c
===================================================================
--- linux.orig/arch/x86/kernel/setup_64.c
+++ linux/arch/x86/kernel/setup_64.c
@@ -247,46 +247,6 @@ static inline void __init reserve_crashk
 {}
 #endif
 
-unsigned __initdata ebda_addr;
-unsigned __initdata ebda_size;
-
-static void __init discover_ebda(void)
-{
-	unsigned short *ptr;
-	/*
-	 * there is a real-mode segmented pointer pointing to the
-	 * 4K EBDA area at 0x40E
-	 */
-	/*
-	 * There can be some situations, like paravirtualized guests,
-	 * in which there is no available ebda information. In such
-	 * case, just skip it
-	 */
-
-	ebda_addr = get_bios_ebda();
-	if (!ebda_addr) {
-		ebda_size = 0;
-		return;
-	}
-
-	ptr = (unsigned short *)early_ioremap(ebda_addr, 2);
-	if (!ptr) {
-		ebda_addr = 0;
-		ebda_size = 0;
-		return;
-	}
-	ebda_size = *(unsigned short *)ptr;
-	early_iounmap((char *)ptr, 2);
-
-	/* Round EBDA up to pages */
-	if (ebda_size == 0)
-		ebda_size = 1;
-	ebda_size <<= 10;
-	ebda_size = round_up(ebda_size + (ebda_addr & ~PAGE_MASK), PAGE_SIZE);
-	if (ebda_size > 64*1024)
-		ebda_size = 64*1024;
-}
-
 /* Overridden in paravirt.c if CONFIG_PARAVIRT */
 void __attribute__((weak)) __init memory_setup(void)
 {
@@ -366,8 +326,6 @@ void __init setup_arch(char **cmdline_p)
 
 	check_efer();
 
-	discover_ebda();
-
 	init_memory_mapping(0, (end_pfn_map << PAGE_SHIFT));
 	if (efi_enabled)
 		efi_init();
@@ -414,33 +372,7 @@ void __init setup_arch(char **cmdline_p)
 	contig_initmem_init(0, end_pfn);
 #endif
 
-	/* Reserve direct mapping */
-	reserve_bootmem_generic(table_start << PAGE_SHIFT,
-				(table_end - table_start) << PAGE_SHIFT);
-
-	/* reserve kernel */
-	reserve_bootmem_generic(__pa_symbol(&_text),
-				__pa_symbol(&_end) - __pa_symbol(&_text));
-
-	/*
-	 * reserve physical page 0 - it's a special BIOS page on many boxes,
-	 * enabling clean reboots, SMP operation, laptop functions.
-	 */
-	reserve_bootmem_generic(0, PAGE_SIZE);
-
-	/* reserve ebda region */
-	if (ebda_addr)
-		reserve_bootmem_generic(ebda_addr, ebda_size);
-#ifdef CONFIG_NUMA
-	/* reserve nodemap region */
-	if (nodemap_addr)
-		reserve_bootmem_generic(nodemap_addr, nodemap_size);
-#endif
-
-#ifdef CONFIG_SMP
-	/* Reserve SMP trampoline */
-	reserve_bootmem_generic(SMP_TRAMPOLINE_BASE, 2*PAGE_SIZE);
-#endif
+	early_res_to_bootmem();
 
 #ifdef CONFIG_ACPI_SLEEP
 	/*
@@ -470,6 +402,8 @@ void __init setup_arch(char **cmdline_p)
 			initrd_start = ramdisk_image + PAGE_OFFSET;
 			initrd_end = initrd_start+ramdisk_size;
 		} else {
+			/* Assumes everything on node 0 */
+			free_bootmem(ramdisk_image, ramdisk_size);
 			printk(KERN_ERR "initrd extends beyond end of memory "
 			       "(0x%08lx > 0x%08lx)\ndisabling initrd\n",
 			       ramdisk_end, end_of_mem);
Index: linux/arch/x86/mm/numa_64.c
===================================================================
--- linux.orig/arch/x86/mm/numa_64.c
+++ linux/arch/x86/mm/numa_64.c
@@ -104,6 +104,7 @@ static int __init allocate_cachealigned_
 	}
 	pad_addr = (nodemap_addr + pad) & ~pad;
 	memnodemap = phys_to_virt(pad_addr);
+	reserve_early(nodemap_addr, nodemap_addr + nodemap_size);
 
 	printk(KERN_DEBUG "NUMA: Allocated memnodemap from %lx - %lx\n",
 	       nodemap_addr, nodemap_addr + nodemap_size);
Index: linux/include/asm-x86/e820_64.h
===================================================================
--- linux.orig/include/asm-x86/e820_64.h
+++ linux/include/asm-x86/e820_64.h
@@ -41,8 +41,8 @@ extern void finish_e820_parsing(void);
 extern struct e820map e820;
 extern void update_e820(void);
 
-extern unsigned ebda_addr, ebda_size;
-extern unsigned long nodemap_addr, nodemap_size;
+extern void reserve_early(unsigned long start, unsigned long end);
+extern void early_res_to_bootmem(void);
 
 #endif/*!__ASSEMBLY__*/
 
Index: linux/arch/x86/mm/init_64.c
===================================================================
--- linux.orig/arch/x86/mm/init_64.c
+++ linux/arch/x86/mm/init_64.c
@@ -176,7 +176,8 @@ __set_fixmap (enum fixed_addresses idx, 
 	set_pte_phys(address, phys, prot);
 }
 
-unsigned long __meminitdata table_start, table_end;
+static unsigned long __initdata table_start;
+static unsigned long __meminitdata table_end;
 
 static __meminit void *alloc_low_page(unsigned long *phys)
 { 
@@ -391,6 +392,8 @@ void __init_refok init_memory_mapping(un
 	if (!after_bootmem)
 		mmu_cr4_features = read_cr4();
 	__flush_tlb_all();
+
+	reserve_early(table_start << PAGE_SHIFT, table_end << PAGE_SHIFT);
 }
 
 #ifndef CONFIG_NUMA
Index: linux/include/asm-x86/proto.h
===================================================================
--- linux.orig/include/asm-x86/proto.h
+++ linux/include/asm-x86/proto.h
@@ -22,8 +22,6 @@ extern void syscall32_cpu_init(void);
 
 extern void check_efer(void);
 
-extern unsigned long table_start, table_end;
-
 extern int reboot_force;
 
 long do_arch_prctl(struct task_struct *task, int code, unsigned long addr);
