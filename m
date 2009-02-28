Return-Path: <linux-kernel-owner+w=401wt.eu-S1761997AbZB1Bxy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761997AbZB1Bxy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Feb 2009 20:53:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762946AbZB1Bv2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Feb 2009 20:51:28 -0500
Received: from adsl-76-233-236-102.dsl.pltn13.sbcglobal.net ([76.233.236.102]:45525
	"EHLO abulafia.goop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1762936AbZB1Bv0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Feb 2009 20:51:26 -0500
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: [PATCH] x86: add brk allocation for very, very early allocations
Date: Fri, 27 Feb 2009 17:51:18 -0800
Message-Id: <1235785882-17580-2-git-send-email-jeremy@goop.org>
X-Mailer: git-send-email 1.6.0.6
In-Reply-To: <1235785882-17580-1-git-send-email-jeremy@goop.org>
References: <1235785882-17580-1-git-send-email-jeremy@goop.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>

Add a brk()-like allocator which effectively extends the bss
in order to allow very early code to do dynamic allocations.
This is better than using statically allocated arrays for
data in subsystems which may never get used.

The amount of space available depends on how much the initial
kernel mappings have covered, and so is fairly limited.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 arch/x86/include/asm/setup.h |    5 +++++
 arch/x86/kernel/head32.c     |    2 ++
 arch/x86/kernel/head64.c     |    2 ++
 arch/x86/kernel/setup.c      |   30 +++++++++++++++++++++++++-----
 arch/x86/mm/pageattr.c       |    5 +++--
 arch/x86/xen/enlighten.c     |    3 +++
 6 files changed, 40 insertions(+), 7 deletions(-)

diff --git a/arch/x86/include/asm/setup.h b/arch/x86/include/asm/setup.h
index 05c6f6b..fd9b420 100644
--- a/arch/x86/include/asm/setup.h
+++ b/arch/x86/include/asm/setup.h
@@ -100,6 +100,11 @@ extern struct boot_params boot_params;
  */
 #define LOWMEMSIZE()	(0x9f000)
 
+/* exceedingly early brk-like allocator */
+extern unsigned long _brk_start, _brk_end;
+void init_brk(unsigned long start);
+void *extend_brk(size_t size, size_t align);
+
 #ifdef __i386__
 
 void __init i386_start_kernel(void);
diff --git a/arch/x86/kernel/head32.c b/arch/x86/kernel/head32.c
index ac108d1..fa9ae31 100644
--- a/arch/x86/kernel/head32.c
+++ b/arch/x86/kernel/head32.c
@@ -34,6 +34,8 @@ void __init i386_start_kernel(void)
 
 	reserve_ebda_region();
 
+	init_brk((unsigned long)__va(init_pg_tables_end));
+
 	/*
 	 * At this point everything still needed from the boot loader
 	 * or BIOS or kernel text should be early reserved or marked not
diff --git a/arch/x86/kernel/head64.c b/arch/x86/kernel/head64.c
index f5b2722..4b29802 100644
--- a/arch/x86/kernel/head64.c
+++ b/arch/x86/kernel/head64.c
@@ -91,6 +91,8 @@ void __init x86_64_start_kernel(char * real_mode_data)
 	if (console_loglevel == 10)
 		early_printk("Kernel alive\n");
 
+	init_brk((unsigned long)&_end);
+
 	x86_64_start_reservations(real_mode_data);
 }
 
diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index 4c54bc0..6a21423 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -113,6 +113,7 @@
 #endif
 
 unsigned int boot_cpu_id __read_mostly;
+__initdata unsigned long _brk_start, _brk_end;
 
 #ifdef CONFIG_X86_64
 int default_cpu_present_to_apicid(int mps_cpu)
@@ -335,6 +336,26 @@ static void __init relocate_initrd(void)
 }
 #endif
 
+void __init init_brk(unsigned long brk)
+{
+	_brk_start = _brk_end = brk;
+}
+
+void * __init extend_brk(size_t size, size_t align)
+{
+	size_t mask = align - 1;
+	void *ret;
+
+	BUG_ON(align & mask);
+
+	_brk_end = (_brk_end + mask) & ~mask;
+
+	ret = (void *)_brk_end;
+	_brk_end += size;
+
+	return ret;
+}
+
 static void __init reserve_initrd(void)
 {
 	u64 ramdisk_image = boot_params.hdr.ramdisk_image;
@@ -715,11 +736,7 @@ void __init setup_arch(char **cmdline_p)
 	init_mm.start_code = (unsigned long) _text;
 	init_mm.end_code = (unsigned long) _etext;
 	init_mm.end_data = (unsigned long) _edata;
-#ifdef CONFIG_X86_32
-	init_mm.brk = init_pg_tables_end + PAGE_OFFSET;
-#else
-	init_mm.brk = (unsigned long) &_end;
-#endif
+	init_mm.brk = _brk_end;
 
 	code_resource.start = virt_to_phys(_text);
 	code_resource.end = virt_to_phys(_etext)-1;
@@ -881,6 +898,9 @@ void __init setup_arch(char **cmdline_p)
 	acpi_numa_init();
 #endif
 
+	if (_brk_end > _brk_start)
+		reserve_early(__pa(_brk_start), __pa(_brk_end), "BRK");
+
 	initmem_init(0, max_pfn);
 
 #ifdef CONFIG_ACPI_SLEEP
diff --git a/arch/x86/mm/pageattr.c b/arch/x86/mm/pageattr.c
index 8253bc9..5b75188 100644
--- a/arch/x86/mm/pageattr.c
+++ b/arch/x86/mm/pageattr.c
@@ -16,6 +16,7 @@
 #include <asm/processor.h>
 #include <asm/tlbflush.h>
 #include <asm/sections.h>
+#include <asm/setup.h>
 #include <asm/uaccess.h>
 #include <asm/pgalloc.h>
 #include <asm/proto.h>
@@ -95,7 +96,7 @@ static inline unsigned long highmap_start_pfn(void)
 
 static inline unsigned long highmap_end_pfn(void)
 {
-	return __pa(roundup((unsigned long)_end, PMD_SIZE)) >> PAGE_SHIFT;
+	return __pa(roundup(_brk_end, PMD_SIZE)) >> PAGE_SHIFT;
 }
 
 #endif
@@ -700,7 +701,7 @@ static int cpa_process_alias(struct cpa_data *cpa)
 	 * No need to redo, when the primary call touched the high
 	 * mapping already:
 	 */
-	if (within(vaddr, (unsigned long) _text, (unsigned long) _end))
+	if (within(vaddr, (unsigned long) _text, _brk_end))
 		return 0;
 
 	/*
diff --git a/arch/x86/xen/enlighten.c b/arch/x86/xen/enlighten.c
index c52f403..a51e595 100644
--- a/arch/x86/xen/enlighten.c
+++ b/arch/x86/xen/enlighten.c
@@ -948,6 +948,9 @@ asmlinkage void __init xen_start_kernel(void)
 
 	init_mm.pgd = pgd;
 
+	/* Set up very early brk allocator after Xen pagetables */
+	init_brk(xen_start_info->pt_base + xen_start_info->nr_pt_frames * PAGE_SIZE);
+
 	/* keep using Xen gdt for now; no urgent need to change it */
 
 	pv_info.kernel_rpl = 1;
-- 
1.6.0.6

