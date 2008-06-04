Return-Path: <linux-kernel-owner+w=401wt.eu-S1758474AbYFDHjT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758474AbYFDHjT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2008 03:39:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752237AbYFDHjE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jun 2008 03:39:04 -0400
Received: from wf-out-1314.google.com ([209.85.200.170]:54807 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750971AbYFDHjB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2008 03:39:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:reply-to:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-disposition:message-id:content-type:content-transfer-encoding;
        b=HdbR+bvCMTUPqmmhKEkqcygWJeyRHkffHePoDiZYYdTVFigDRCfORu/viSgzkk+knRcQQ5yqdsILwoTwuWskAuCbaKLNY2Zscl+pijkJJo6aI41Lmt/E7fBf8ZtXcP7MHQyGB4OYhQSuRWCK0gSDvef5i0KlwJjwfaGrPShohps=
From: Yinghai Lu <yhlu.kernel@gmail.com>
Reply-To: Yinghai Lu <yhlu.kernel@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] x86: e820 merge parse mem/memmap
Date: Wed, 4 Jun 2008 00:39:16 -0700
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <200806031025.55026.yhlu.kernel@gmail.com> <200806031934.01198.yhlu.kernel@gmail.com> <200806031935.05202.yhlu.kernel@gmail.com>
In-Reply-To: <200806031935.05202.yhlu.kernel@gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200806040039.17091.yhlu.kernel@gmail.com>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


after we get 32 bit support e820_register_active_regions

we could merge parse mem/memmap

Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>

Index: linux-2.6/arch/x86/kernel/e820.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/e820.c
+++ linux-2.6/arch/x86/kernel/e820.c
@@ -873,3 +873,89 @@ u64 __init e820_hole_size(u64 start, u64
 	}
 	return end - start - ((u64)ram << PAGE_SHIFT);
 }
+
+static void early_panic(char *msg)
+{
+	early_printk(msg);
+	panic(msg);
+}
+
+/* "mem=nopentium" disables the 4MB page tables. */
+static int __init parse_memopt(char *p)
+{
+	u64 mem_size;
+
+	if (!p)
+		return -EINVAL;
+
+#ifdef CONFIG_X86_32
+	if (!strcmp(p, "nopentium")) {
+		setup_clear_cpu_cap(X86_FEATURE_PSE);
+		return 0;
+	}
+#endif
+
+	mem_size = memparse(p, &p);
+	end_user_pfn = mem_size>>PAGE_SHIFT;
+	return 0;
+}
+early_param("mem", parse_memopt);
+
+static int userdef __initdata;
+
+static int __init parse_memmap_opt(char *p)
+{
+	char *oldp;
+	u64 start_at, mem_size;
+
+	if (!strcmp(p, "exactmap")) {
+#ifdef CONFIG_CRASH_DUMP
+		/*
+		 * If we are doing a crash dump, we still need to know
+		 * the real mem size before original memory map is
+		 * reset.
+		 */
+		e820_register_active_regions(0, 0, -1UL);
+		saved_max_pfn = e820_end_of_ram();
+		remove_all_active_ranges();
+#endif
+		e820.nr_map = 0;
+		userdef = 1;
+		return 0;
+	}
+
+	oldp = p;
+	mem_size = memparse(p, &p);
+	if (p == oldp)
+		return -EINVAL;
+
+	userdef = 1;
+	if (*p == '@') {
+		start_at = memparse(p+1, &p);
+		add_memory_region(start_at, mem_size, E820_RAM);
+	} else if (*p == '#') {
+		start_at = memparse(p+1, &p);
+		add_memory_region(start_at, mem_size, E820_ACPI);
+	} else if (*p == '$') {
+		start_at = memparse(p+1, &p);
+		add_memory_region(start_at, mem_size, E820_RESERVED);
+	} else {
+		end_user_pfn = (mem_size >> PAGE_SHIFT);
+	}
+	return *p == '\0' ? 0 : -EINVAL;
+}
+early_param("memmap", parse_memmap_opt);
+
+void __init finish_e820_parsing(void)
+{
+	if (userdef) {
+		int nr = e820.nr_map;
+
+		if (sanitize_e820_map(e820.map, ARRAY_SIZE(e820.map), &nr) < 0)
+			early_panic("Invalid user supplied memory map");
+		e820.nr_map = nr;
+
+		printk(KERN_INFO "user-defined physical RAM map:\n");
+		e820_print_map("user");
+	}
+}
Index: linux-2.6/arch/x86/kernel/e820_32.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/e820_32.c
+++ linux-2.6/arch/x86/kernel/e820_32.c
@@ -207,36 +207,6 @@ void __init init_iomem_resources(struct 
 	}
 }
 
-void __init limit_regions(unsigned long long size)
-{
-	unsigned long long current_addr;
-	int i;
-
-	e820_print_map("limit_regions start");
-	for (i = 0; i < e820.nr_map; i++) {
-		current_addr = e820.map[i].addr + e820.map[i].size;
-		if (current_addr < size)
-			continue;
-
-		if (e820.map[i].type != E820_RAM)
-			continue;
-
-		if (e820.map[i].addr >= size) {
-			/*
-			 * This region starts past the end of the
-			 * requested size, skip it completely.
-			 */
-			e820.nr_map = i;
-		} else {
-			e820.nr_map = i + 1;
-			e820.map[i].size -= current_addr - size;
-		}
-		e820_print_map("limit_regions endfor");
-		return;
-	}
-	e820_print_map("limit_regions endfunc");
-}
-
 /* Overridden in paravirt.c if CONFIG_PARAVIRT */
 char * __init __attribute__((weak)) memory_setup(void)
 {
@@ -249,93 +219,3 @@ void __init setup_memory_map(void)
 	e820_print_map(memory_setup());
 }
 
-static int __initdata user_defined_memmap;
-
-/*
- * "mem=nopentium" disables the 4MB page tables.
- * "mem=XXX[kKmM]" defines a memory region from HIGH_MEM
- * to <mem>, overriding the bios size.
- * "memmap=XXX[KkmM]@XXX[KkmM]" defines a memory region from
- * <start> to <start>+<mem>, overriding the bios size.
- *
- * HPA tells me bootloaders need to parse mem=, so no new
- * option should be mem=  [also see Documentation/i386/boot.txt]
- */
-static int __init parse_mem(char *arg)
-{
-	if (!arg)
-		return -EINVAL;
-
-	if (strcmp(arg, "nopentium") == 0) {
-		setup_clear_cpu_cap(X86_FEATURE_PSE);
-	} else {
-		/* If the user specifies memory size, we
-		 * limit the BIOS-provided memory map to
-		 * that size. exactmap can be used to specify
-		 * the exact map. mem=number can be used to
-		 * trim the existing memory map.
-		 */
-		unsigned long long mem_size;
-
-		mem_size = memparse(arg, &arg);
-		limit_regions(mem_size);
-		user_defined_memmap = 1;
-	}
-	return 0;
-}
-early_param("mem", parse_mem);
-
-static int __init parse_memmap(char *arg)
-{
-	if (!arg)
-		return -EINVAL;
-
-	if (strcmp(arg, "exactmap") == 0) {
-#ifdef CONFIG_CRASH_DUMP
-		/* If we are doing a crash dump, we
-		 * still need to know the real mem
-		 * size before original memory map is
-		 * reset.
-		 */
-		e820_register_active_regions(0, 0, -1UL);
-		saved_max_pfn = e820_end_of_ram();
-		remove_all_active_ranges();
-#endif
-		e820.nr_map = 0;
-		user_defined_memmap = 1;
-	} else {
-		/* If the user specifies memory size, we
-		 * limit the BIOS-provided memory map to
-		 * that size. exactmap can be used to specify
-		 * the exact map. mem=number can be used to
-		 * trim the existing memory map.
-		 */
-		unsigned long long start_at, mem_size;
-
-		mem_size = memparse(arg, &arg);
-		if (*arg == '@') {
-			start_at = memparse(arg+1, &arg);
-			add_memory_region(start_at, mem_size, E820_RAM);
-		} else if (*arg == '#') {
-			start_at = memparse(arg+1, &arg);
-			add_memory_region(start_at, mem_size, E820_ACPI);
-		} else if (*arg == '$') {
-			start_at = memparse(arg+1, &arg);
-			add_memory_region(start_at, mem_size, E820_RESERVED);
-		} else {
-			limit_regions(mem_size);
-			user_defined_memmap = 1;
-		}
-	}
-	return 0;
-}
-early_param("memmap", parse_memmap);
-
-void __init finish_e820_parsing(void)
-{
-	if (user_defined_memmap) {
-		printk(KERN_INFO "user-defined physical RAM map:\n");
-		e820_print_map("user");
-	}
-}
-
Index: linux-2.6/arch/x86/kernel/e820_64.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/e820_64.c
+++ linux-2.6/arch/x86/kernel/e820_64.c
@@ -96,75 +96,6 @@ char *__init machine_specific_memory_set
 	return who;
 }
 
-static int __init parse_memopt(char *p)
-{
-	if (!p)
-		return -EINVAL;
-	end_user_pfn = memparse(p, &p);
-	end_user_pfn >>= PAGE_SHIFT;
-	return 0;
-}
-early_param("mem", parse_memopt);
-
-static int userdef __initdata;
-
-static int __init parse_memmap_opt(char *p)
-{
-	char *oldp;
-	unsigned long long start_at, mem_size;
-
-	if (!strcmp(p, "exactmap")) {
-#ifdef CONFIG_CRASH_DUMP
-		/*
-		 * If we are doing a crash dump, we still need to know
-		 * the real mem size before original memory map is
-		 * reset.
-		 */
-		e820_register_active_regions(0, 0, -1UL);
-		saved_max_pfn = e820_end_of_ram();
-		remove_all_active_ranges();
-#endif
-		e820.nr_map = 0;
-		userdef = 1;
-		return 0;
-	}
-
-	oldp = p;
-	mem_size = memparse(p, &p);
-	if (p == oldp)
-		return -EINVAL;
-
-	userdef = 1;
-	if (*p == '@') {
-		start_at = memparse(p+1, &p);
-		add_memory_region(start_at, mem_size, E820_RAM);
-	} else if (*p == '#') {
-		start_at = memparse(p+1, &p);
-		add_memory_region(start_at, mem_size, E820_ACPI);
-	} else if (*p == '$') {
-		start_at = memparse(p+1, &p);
-		add_memory_region(start_at, mem_size, E820_RESERVED);
-	} else {
-		end_user_pfn = (mem_size >> PAGE_SHIFT);
-	}
-	return *p == '\0' ? 0 : -EINVAL;
-}
-early_param("memmap", parse_memmap_opt);
-
-void __init finish_e820_parsing(void)
-{
-	if (userdef) {
-		int nr = e820.nr_map;
-
-		if (sanitize_e820_map(e820.map, ARRAY_SIZE(e820.map), &nr) < 0)
-			early_panic("Invalid user supplied memory map");
-		e820.nr_map = nr;
-
-		printk(KERN_INFO "user-defined physical RAM map:\n");
-		e820_print_map("user");
-	}
-}
-
 int __init arch_get_ram_range(int slot, u64 *addr, u64 *size)
 {
 	int i;
Index: linux-2.6/include/asm-x86/e820.h
===================================================================
--- linux-2.6.orig/include/asm-x86/e820.h
+++ linux-2.6/include/asm-x86/e820.h
@@ -97,6 +97,8 @@ extern int e820_find_active_region(const
 extern void e820_register_active_regions(int nid, unsigned long start_pfn,
 					 unsigned long end_pfn);
 extern u64 e820_hole_size(u64 start, u64 end);
+extern void finish_e820_parsing(void);
+
 #endif /* __ASSEMBLY__ */
 
 #define ISA_START_ADDRESS	0xa0000
Index: linux-2.6/include/asm-x86/e820_32.h
===================================================================
--- linux-2.6.orig/include/asm-x86/e820_32.h
+++ linux-2.6/include/asm-x86/e820_32.h
@@ -19,9 +19,7 @@
 #ifndef __ASSEMBLY__
 
 extern void setup_memory_map(void);
-extern void finish_e820_parsing(void);
 
-extern void limit_regions(unsigned long long size);
 extern void init_iomem_resources(struct resource *code_resource,
 				 struct resource *data_resource,
 				 struct resource *bss_resource);
Index: linux-2.6/include/asm-x86/e820_64.h
===================================================================
--- linux-2.6.orig/include/asm-x86/e820_64.h
+++ linux-2.6/include/asm-x86/e820_64.h
@@ -22,8 +22,6 @@ extern int is_memory_any_valid(unsigned 
 extern int e820_all_non_reserved(unsigned long start, unsigned long end);
 extern int is_memory_all_valid(unsigned long start, unsigned long end);
 
-extern void finish_e820_parsing(void);
-
 #endif/*!__ASSEMBLY__*/
 
 #endif/*__E820_HEADER*/

