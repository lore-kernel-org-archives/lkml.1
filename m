Return-Path: <linux-kernel-owner+w=401wt.eu-S1758469AbZCZPL1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758469AbZCZPL1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Mar 2009 11:11:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756890AbZCZPLS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Mar 2009 11:11:18 -0400
Received: from hera.kernel.org ([140.211.167.34]:60243 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756742AbZCZPLR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Mar 2009 11:11:17 -0400
Subject: [git-pull -tip] x86: unification and cleanup patches 20090326
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Ingo Molnar <mingo@elte.hu>, x86 maintainers <x86@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>, Andi Kleen <andi@firstfloor.org>,
       Rusty Russell <rusty@rustcorp.com.au>
Content-Type: text/plain
Date: Thu, 26 Mar 2009 20:40:31 +0530
Message-Id: <1238080231.2852.4.camel@ht.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Individual log and patches are available at:
http://git.kernel.org/?p=linux/kernel/git/jaswinder/linux-2.6-tip.git;a=shortlog;h=x86/core

The following changes since commit 29219683c46cb89edf5c58418b5305b14646d030:
  Ingo Molnar (1):
        Merge branches 'x86/apic', 'x86/cleanups', 'x86/mm', 'x86/pat', 'x86/setup' and 'x86/signal'; commit 'v2.6.29' into x86/core

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jaswinder/linux-2.6-tip.git x86/core

Jaswinder Singh Rajput (3):
      x86: unification of cpu/bugs.c
      x86: cpu/bugs.c cleanup
      x86: unification of module.c

 arch/x86/kernel/Makefile                  |    2 +-
 arch/x86/kernel/cpu/Makefile              |    5 +-
 arch/x86/kernel/cpu/bugs.c                |   87 ++++++++++++-----
 arch/x86/kernel/cpu/bugs_64.c             |   33 ------
 arch/x86/kernel/{module_64.c => module.c} |  123 ++++++++++++++++++------
 arch/x86/kernel/module_32.c               |  152 -----------------------------
 6 files changed, 160 insertions(+), 242 deletions(-)
 delete mode 100644 arch/x86/kernel/cpu/bugs_64.c
 rename arch/x86/kernel/{module_64.c => module.c} (70%)
 delete mode 100644 arch/x86/kernel/module_32.c

Complete diff:
diff --git a/arch/x86/kernel/Makefile b/arch/x86/kernel/Makefile
index 339ce35..87b1c05 100644
--- a/arch/x86/kernel/Makefile
+++ b/arch/x86/kernel/Makefile
@@ -72,7 +72,7 @@ obj-$(CONFIG_KEXEC)		+= relocate_kernel_$(BITS).o crash.o
 obj-$(CONFIG_CRASH_DUMP)	+= crash_dump_$(BITS).o
 obj-$(CONFIG_X86_VSMP)		+= vsmp_64.o
 obj-$(CONFIG_KPROBES)		+= kprobes.o
-obj-$(CONFIG_MODULES)		+= module_$(BITS).o
+obj-$(CONFIG_MODULES)		+= module.o
 obj-$(CONFIG_EFI) 		+= efi.o efi_$(BITS).o efi_stub_$(BITS).o
 obj-$(CONFIG_DOUBLEFAULT) 	+= doublefault_32.o
 obj-$(CONFIG_KGDB)		+= kgdb.o
diff --git a/arch/x86/kernel/cpu/Makefile b/arch/x86/kernel/cpu/Makefile
index 4e242f9..90a96ee 100644
--- a/arch/x86/kernel/cpu/Makefile
+++ b/arch/x86/kernel/cpu/Makefile
@@ -9,10 +9,9 @@ endif
 
 obj-y			:= intel_cacheinfo.o addon_cpuid_features.o
 obj-y			+= proc.o capflags.o powerflags.o common.o
-obj-y			+= vmware.o hypervisor.o
+obj-y			+= vmware.o hypervisor.o bugs.o
 
-obj-$(CONFIG_X86_32)	+= bugs.o cmpxchg.o
-obj-$(CONFIG_X86_64)	+= bugs_64.o
+obj-$(CONFIG_X86_32)			+= cmpxchg.o
 
 obj-$(CONFIG_X86_CPU_DEBUG)		+= cpu_debug.o
 
diff --git a/arch/x86/kernel/cpu/bugs.c b/arch/x86/kernel/cpu/bugs.c
index c8e315f..e314704 100644
--- a/arch/x86/kernel/cpu/bugs.c
+++ b/arch/x86/kernel/cpu/bugs.c
@@ -6,17 +6,25 @@
  *        <rreilova@ececs.uc.edu>
  *	- Channing Corn (tests & fixes),
  *	- Andrew D. Balsa (code cleanup).
+ *
+ *  Copyright (C) 2000 SuSE
  */
-#include <linux/init.h>
+
 #include <linux/utsname.h>
-#include <asm/bugs.h>
-#include <asm/processor.h>
+#include <linux/kernel.h>
+#include <linux/init.h>
+
 #include <asm/processor-flags.h>
+#include <asm/alternative.h>
+#include <asm/cacheflush.h>
+#include <asm/processor.h>
+#include <asm/paravirt.h>
+#include <asm/pgtable.h>
 #include <asm/i387.h>
+#include <asm/bugs.h>
 #include <asm/msr.h>
-#include <asm/paravirt.h>
-#include <asm/alternative.h>
 
+#ifdef CONFIG_X86_32
 static int __init no_halt(char *s)
 {
 	boot_cpu_data.hlt_works_ok = 0;
@@ -56,7 +64,8 @@ static void __init check_fpu(void)
 #ifndef CONFIG_MATH_EMULATION
 		printk(KERN_EMERG "No coprocessor found and no math emulation present.\n");
 		printk(KERN_EMERG "Giving up.\n");
-		for (;;) ;
+		for (;;)
+			;
 #endif
 		return;
 	}
@@ -67,21 +76,21 @@ static void __init check_fpu(void)
 	 *
 	 * Test for the divl bug..
 	 */
-	__asm__("fninit\n\t"
-		"fldl %1\n\t"
-		"fdivl %2\n\t"
-		"fmull %2\n\t"
-		"fldl %1\n\t"
-		"fsubp %%st,%%st(1)\n\t"
-		"fistpl %0\n\t"
-		"fwait\n\t"
+	__asm__("fninit				\n\t"
+		"fldl	%1			\n\t"
+		"fdivl	%2			\n\t"
+		"fmull	%2			\n\t"
+		"fldl	%1			\n\t"
+		"fsubp	%%st,%%st(1)		\n\t"
+		"fistpl	%0			\n\t"
+		"fwait				\n\t"
 		"fninit"
 		: "=m" (*&fdiv_bug)
 		: "m" (*&x), "m" (*&y));
 
 	boot_cpu_data.fdiv_bug = fdiv_bug;
 	if (boot_cpu_data.fdiv_bug)
-		printk("Hmm, FPU with FDIV bug.\n");
+		printk(KERN_INFO "Hmm, FPU with FDIV bug.\n");
 }
 
 static void __init check_hlt(void)
@@ -91,7 +100,7 @@ static void __init check_hlt(void)
 
 	printk(KERN_INFO "Checking 'hlt' instruction... ");
 	if (!boot_cpu_data.hlt_works_ok) {
-		printk("disabled\n");
+		printk(KERN_INFO "disabled\n");
 		return;
 	}
 	halt();
@@ -113,10 +122,14 @@ static void __init check_popad(void)
 
 	printk(KERN_INFO "Checking for popad bug... ");
 	__asm__ __volatile__(
-	  "movl $12345678,%%eax; movl $0,%%edi; pusha; popa; movl (%%edx,%%edi),%%ecx "
-	  : "=&a" (res)
-	  : "d" (inp)
-	  : "ecx", "edi");
+		"movl	$12345678,%%eax		\n\t"
+		"movl	$0,%%edi		\n\t"
+		"pusha				\n\t"
+		"popa				\n\t"
+		"movl	(%%edx,%%edi),%%ecx"
+		: "=&a" (res)
+		: "d" (inp)
+		: "ecx", "edi");
 	/*
 	 * If this fails, it means that any user program may lock the
 	 * CPU hard. Too bad.
@@ -151,19 +164,43 @@ static void __init check_config(void)
 #endif
 }
 
+/*
+ * Check various bugs
+ */
+static void __init check_various_bugs(void)
+{
+	check_config();
+	check_fpu();
+	check_hlt();
+	check_popad();
+}
+#else /* CONFIG_X86_32 */
+static inline void __init check_various_bugs(void) {}
+#endif /* CONFIG_X86_32 */
 
 void __init check_bugs(void)
 {
 	identify_boot_cpu();
 #ifndef CONFIG_SMP
-	printk("CPU: ");
+	printk(KERN_INFO "CPU: ");
 	print_cpu_info(&boot_cpu_data);
 #endif
-	check_config();
-	check_fpu();
-	check_hlt();
-	check_popad();
+	check_various_bugs();
+
 	init_utsname()->machine[1] =
 		'0' + (boot_cpu_data.x86 > 6 ? 6 : boot_cpu_data.x86);
 	alternative_instructions();
+
+#ifdef CONFIG_X86_64
+	/*
+	 * Make sure the first 2MB area is not mapped by huge pages
+	 * There are typically fixed size MTRRs in there and overlapping
+	 * MTRRs into large pages causes slow downs.
+	 *
+	 * Right now we don't do that with gbpages because there seems
+	 * very little benefit for that case.
+	 */
+	if (!direct_gbpages)
+		set_memory_4k((unsigned long)__va(0), 1);
+#endif /* CONFIG_X86_64 */
 }
diff --git a/arch/x86/kernel/cpu/bugs_64.c b/arch/x86/kernel/cpu/bugs_64.c
deleted file mode 100644
index 9a3ed06..0000000
--- a/arch/x86/kernel/cpu/bugs_64.c
+++ /dev/null
@@ -1,33 +0,0 @@
-/*
- *  Copyright (C) 1994  Linus Torvalds
- *  Copyright (C) 2000  SuSE
- */
-
-#include <linux/kernel.h>
-#include <linux/init.h>
-#include <asm/alternative.h>
-#include <asm/bugs.h>
-#include <asm/processor.h>
-#include <asm/mtrr.h>
-#include <asm/cacheflush.h>
-
-void __init check_bugs(void)
-{
-	identify_boot_cpu();
-#if !defined(CONFIG_SMP)
-	printk("CPU: ");
-	print_cpu_info(&boot_cpu_data);
-#endif
-	alternative_instructions();
-
-	/*
-	 * Make sure the first 2MB area is not mapped by huge pages
-	 * There are typically fixed size MTRRs in there and overlapping
-	 * MTRRs into large pages causes slow downs.
-	 *
-	 * Right now we don't do that with gbpages because there seems
-	 * very little benefit for that case.
-	 */
-	if (!direct_gbpages)
-		set_memory_4k((unsigned long)__va(0), 1);
-}
diff --git a/arch/x86/kernel/module.c b/arch/x86/kernel/module.c
new file mode 100644
index 0000000..051b4d0
--- /dev/null
+++ b/arch/x86/kernel/module.c
@@ -0,0 +1,261 @@
+/*  Kernel module help for x86.
+    Copyright (C) 2001 Rusty Russell.
+    Copyright (C) 2002,2003 Andi Kleen, SuSE Labs.
+
+    This program is free software; you can redistribute it and/or modify
+    it under the terms of the GNU General Public License as published by
+    the Free Software Foundation; either version 2 of the License, or
+    (at your option) any later version.
+
+    This program is distributed in the hope that it will be useful,
+    but WITHOUT ANY WARRANTY; without even the implied warranty of
+    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+    GNU General Public License for more details.
+
+    You should have received a copy of the GNU General Public License
+    along with this program; if not, write to the Free Software
+    Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
+*/
+#include <linux/moduleloader.h>
+#include <linux/vmalloc.h>
+#include <linux/kernel.h>
+#include <linux/string.h>
+#include <linux/slab.h>
+#include <linux/bug.h>
+#include <linux/elf.h>
+#include <linux/fs.h>
+#include <linux/mm.h>
+
+#include <asm/pgtable.h>
+#include <asm/system.h>
+#include <asm/page.h>
+
+#define DEBUGP(fmt...)
+
+#if (defined(CONFIG_X86_32) || !defined(CONFIG_UML))
+
+#ifdef CONFIG_X86_64
+static inline void *module_vmalloc(unsigned long size)
+{
+	struct vm_struct *area;
+
+	size = PAGE_ALIGN(size);
+	if (size > MODULES_LEN)
+		return NULL;
+
+	area = __get_vm_area(size, VM_ALLOC, MODULES_VADDR, MODULES_END);
+	if (!area)
+		return NULL;
+
+	return __vmalloc_area(area, GFP_KERNEL, PAGE_KERNEL_EXEC);
+}
+#else
+static inline void *module_vmalloc(unsigned long size)
+{
+	return vmalloc_exec(size);
+}
+#endif
+
+void *module_alloc(unsigned long size)
+{
+	if (size == 0)
+		return NULL;
+	return module_vmalloc(size);
+}
+
+
+/* Free memory returned from module_alloc */
+void module_free(struct module *mod, void *module_region)
+{
+	vfree(module_region);
+	/* FIXME: If module_region == mod->init_region, trim exception
+	   table entries. */
+}
+#endif
+
+/* We don't need anything special. */
+int module_frob_arch_sections(Elf_Ehdr *hdr,
+			      Elf_Shdr *sechdrs,
+			      char *secstrings,
+			      struct module *mod)
+{
+	return 0;
+}
+
+#ifdef CONFIG_X86_32
+int apply_relocate(Elf32_Shdr *sechdrs,
+		   const char *strtab,
+		   unsigned int symindex,
+		   unsigned int relsec,
+		   struct module *me)
+{
+	unsigned int i;
+	Elf32_Rel *rel = (void *)sechdrs[relsec].sh_addr;
+	Elf32_Sym *sym;
+	uint32_t *location;
+
+	DEBUGP("Applying relocate section %u to %u\n", relsec,
+	       sechdrs[relsec].sh_info);
+	for (i = 0; i < sechdrs[relsec].sh_size / sizeof(*rel); i++) {
+		/* This is where to make the change */
+		location = (void *)sechdrs[sechdrs[relsec].sh_info].sh_addr
+			+ rel[i].r_offset;
+		/* This is the symbol it is referring to.  Note that all
+		   undefined symbols have been resolved.  */
+		sym = (Elf32_Sym *)sechdrs[symindex].sh_addr
+			+ ELF32_R_SYM(rel[i].r_info);
+
+		switch (ELF32_R_TYPE(rel[i].r_info)) {
+		case R_386_32:
+			/* We add the value into the location given */
+			*location += sym->st_value;
+			break;
+		case R_386_PC32:
+			/* Add the value, subtract its postition */
+			*location += sym->st_value - (uint32_t)location;
+			break;
+		default:
+			printk(KERN_ERR "module %s: Unknown relocation: %u\n",
+			       me->name, ELF32_R_TYPE(rel[i].r_info));
+			return -ENOEXEC;
+		}
+	}
+	return 0;
+}
+
+int apply_relocate_add(Elf32_Shdr *sechdrs,
+		       const char *strtab,
+		       unsigned int symindex,
+		       unsigned int relsec,
+		       struct module *me)
+{
+	printk(KERN_ERR "module %s: add relocation not supported\n", me->name);
+	return -ENOEXEC;
+}
+
+#else /* CONFIG_X86_32 */
+int apply_relocate_add(Elf64_Shdr *sechdrs,
+		       const char *strtab,
+		       unsigned int symindex,
+		       unsigned int relsec,
+		       struct module *me)
+{
+	unsigned int i;
+	Elf64_Rela *rel = (void *)sechdrs[relsec].sh_addr;
+	Elf64_Sym *sym;
+	void *loc;
+	u64 val;
+
+	DEBUGP("Applying relocate section %u to %u\n", relsec,
+		sechdrs[relsec].sh_info);
+	for (i = 0; i < sechdrs[relsec].sh_size / sizeof(*rel); i++) {
+		/* This is where to make the change */
+		loc = (void *)sechdrs[sechdrs[relsec].sh_info].sh_addr
+			+ rel[i].r_offset;
+
+		/*
+		 * This is the symbol it is referring to.  Note that all
+		 * undefined symbols have been resolved.
+		 */
+		sym = (Elf64_Sym *)sechdrs[symindex].sh_addr
+			+ ELF64_R_SYM(rel[i].r_info);
+
+		DEBUGP("type %d st_value %Lx r_addend %Lx loc %Lx\n",
+			(int)ELF64_R_TYPE(rel[i].r_info),
+			sym->st_value, rel[i].r_addend, (u64)loc);
+
+		val = sym->st_value + rel[i].r_addend;
+
+		switch (ELF64_R_TYPE(rel[i].r_info)) {
+		case R_X86_64_NONE:
+			break;
+		case R_X86_64_64:
+			*(u64 *)loc = val;
+			break;
+		case R_X86_64_32:
+			*(u32 *)loc = val;
+			if (val != *(u32 *)loc)
+				goto overflow;
+			break;
+		case R_X86_64_32S:
+			*(s32 *)loc = val;
+			if ((s64)val != *(s32 *)loc)
+				goto overflow;
+			break;
+		case R_X86_64_PC32:
+			val -= (u64)loc;
+			*(u32 *)loc = val;
+			break;
+		default:
+			printk(KERN_ERR "module %s: Unknown rela relocation: %llu\n",
+				me->name, ELF64_R_TYPE(rel[i].r_info));
+			return -ENOEXEC;
+		}
+	}
+	return 0;
+
+overflow:
+	printk(KERN_ERR "overflow in relocation type %d val %Lx\n",
+		(int)ELF64_R_TYPE(rel[i].r_info), val);
+	printk(KERN_ERR "`%s' likely not compiled with -mcmodel=kernel\n",
+		me->name);
+	return -ENOEXEC;
+}
+
+int apply_relocate(Elf_Shdr *sechdrs,
+		   const char *strtab,
+		   unsigned int symindex,
+		   unsigned int relsec,
+		   struct module *me)
+{
+	printk(KERN_ERR "module %s: add relocation not supported\n", me->name);
+	return -ENOSYS;
+}
+
+#endif /* CONFIG_X86_32 */
+
+int module_finalize(const Elf_Ehdr *hdr,
+		    const Elf_Shdr *sechdrs,
+		    struct module *me)
+{
+	const Elf_Shdr *s, *text = NULL, *alt = NULL, *locks = NULL,
+		*para = NULL;
+	char *secstrings = (void *)hdr + sechdrs[hdr->e_shstrndx].sh_offset;
+
+	for (s = sechdrs; s < sechdrs + hdr->e_shnum; s++) {
+		if (!strcmp(".text", secstrings + s->sh_name))
+			text = s;
+		if (!strcmp(".altinstructions", secstrings + s->sh_name))
+			alt = s;
+		if (!strcmp(".smp_locks", secstrings + s->sh_name))
+			locks = s;
+		if (!strcmp(".parainstructions", secstrings + s->sh_name))
+			para = s;
+	}
+
+	if (alt) {
+		/* patch .altinstructions */
+		void *aseg = (void *)alt->sh_addr;
+		apply_alternatives(aseg, aseg + alt->sh_size);
+	}
+	if (locks && text) {
+		void *lseg = (void *)locks->sh_addr;
+		void *tseg = (void *)text->sh_addr;
+		alternatives_smp_module_add(me, me->name,
+					    lseg, lseg + locks->sh_size,
+					    tseg, tseg + text->sh_size);
+	}
+
+	if (para) {
+		void *pseg = (void *)para->sh_addr;
+		apply_paravirt(pseg, pseg + para->sh_size);
+	}
+
+	return module_bug_finalize(hdr, sechdrs, me);
+}
+
+void module_arch_cleanup(struct module *mod)
+{
+	alternatives_smp_module_del(mod);
+	module_bug_cleanup(mod);
+}
diff --git a/arch/x86/kernel/module_32.c b/arch/x86/kernel/module_32.c
deleted file mode 100644
index 0edd819..0000000
--- a/arch/x86/kernel/module_32.c
+++ /dev/null
@@ -1,152 +0,0 @@
-/*  Kernel module help for i386.
-    Copyright (C) 2001 Rusty Russell.
-
-    This program is free software; you can redistribute it and/or modify
-    it under the terms of the GNU General Public License as published by
-    the Free Software Foundation; either version 2 of the License, or
-    (at your option) any later version.
-
-    This program is distributed in the hope that it will be useful,
-    but WITHOUT ANY WARRANTY; without even the implied warranty of
-    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
-    GNU General Public License for more details.
-
-    You should have received a copy of the GNU General Public License
-    along with this program; if not, write to the Free Software
-    Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
-*/
-#include <linux/moduleloader.h>
-#include <linux/elf.h>
-#include <linux/vmalloc.h>
-#include <linux/fs.h>
-#include <linux/string.h>
-#include <linux/kernel.h>
-#include <linux/bug.h>
-
-#if 0
-#define DEBUGP printk
-#else
-#define DEBUGP(fmt...)
-#endif
-
-void *module_alloc(unsigned long size)
-{
-	if (size == 0)
-		return NULL;
-	return vmalloc_exec(size);
-}
-
-
-/* Free memory returned from module_alloc */
-void module_free(struct module *mod, void *module_region)
-{
-	vfree(module_region);
-	/* FIXME: If module_region == mod->init_region, trim exception
-	   table entries. */
-}
-
-/* We don't need anything special. */
-int module_frob_arch_sections(Elf_Ehdr *hdr,
-			      Elf_Shdr *sechdrs,
-			      char *secstrings,
-			      struct module *mod)
-{
-	return 0;
-}
-
-int apply_relocate(Elf32_Shdr *sechdrs,
-		   const char *strtab,
-		   unsigned int symindex,
-		   unsigned int relsec,
-		   struct module *me)
-{
-	unsigned int i;
-	Elf32_Rel *rel = (void *)sechdrs[relsec].sh_addr;
-	Elf32_Sym *sym;
-	uint32_t *location;
-
-	DEBUGP("Applying relocate section %u to %u\n", relsec,
-	       sechdrs[relsec].sh_info);
-	for (i = 0; i < sechdrs[relsec].sh_size / sizeof(*rel); i++) {
-		/* This is where to make the change */
-		location = (void *)sechdrs[sechdrs[relsec].sh_info].sh_addr
-			+ rel[i].r_offset;
-		/* This is the symbol it is referring to.  Note that all
-		   undefined symbols have been resolved.  */
-		sym = (Elf32_Sym *)sechdrs[symindex].sh_addr
-			+ ELF32_R_SYM(rel[i].r_info);
-
-		switch (ELF32_R_TYPE(rel[i].r_info)) {
-		case R_386_32:
-			/* We add the value into the location given */
-			*location += sym->st_value;
-			break;
-		case R_386_PC32:
-			/* Add the value, subtract its postition */
-			*location += sym->st_value - (uint32_t)location;
-			break;
-		default:
-			printk(KERN_ERR "module %s: Unknown relocation: %u\n",
-			       me->name, ELF32_R_TYPE(rel[i].r_info));
-			return -ENOEXEC;
-		}
-	}
-	return 0;
-}
-
-int apply_relocate_add(Elf32_Shdr *sechdrs,
-		       const char *strtab,
-		       unsigned int symindex,
-		       unsigned int relsec,
-		       struct module *me)
-{
-	printk(KERN_ERR "module %s: ADD RELOCATION unsupported\n",
-	       me->name);
-	return -ENOEXEC;
-}
-
-int module_finalize(const Elf_Ehdr *hdr,
-		    const Elf_Shdr *sechdrs,
-		    struct module *me)
-{
-	const Elf_Shdr *s, *text = NULL, *alt = NULL, *locks = NULL,
-		*para = NULL;
-	char *secstrings = (void *)hdr + sechdrs[hdr->e_shstrndx].sh_offset;
-
-	for (s = sechdrs; s < sechdrs + hdr->e_shnum; s++) {
-		if (!strcmp(".text", secstrings + s->sh_name))
-			text = s;
-		if (!strcmp(".altinstructions", secstrings + s->sh_name))
-			alt = s;
-		if (!strcmp(".smp_locks", secstrings + s->sh_name))
-			locks = s;
-		if (!strcmp(".parainstructions", secstrings + s->sh_name))
-			para = s;
-	}
-
-	if (alt) {
-		/* patch .altinstructions */
-		void *aseg = (void *)alt->sh_addr;
-		apply_alternatives(aseg, aseg + alt->sh_size);
-	}
-	if (locks && text) {
-		void *lseg = (void *)locks->sh_addr;
-		void *tseg = (void *)text->sh_addr;
-		alternatives_smp_module_add(me, me->name,
-					    lseg, lseg + locks->sh_size,
-					    tseg, tseg + text->sh_size);
-	}
-
-	if (para) {
-		void *pseg = (void *)para->sh_addr;
-		apply_paravirt(pseg, pseg + para->sh_size);
-	}
-
-	return module_bug_finalize(hdr, sechdrs, me);
-}
-
-void module_arch_cleanup(struct module *mod)
-{
-	alternatives_smp_module_del(mod);
-	module_bug_cleanup(mod);
-}
diff --git a/arch/x86/kernel/module_64.c b/arch/x86/kernel/module_64.c
deleted file mode 100644
index c23880b..0000000
--- a/arch/x86/kernel/module_64.c
+++ /dev/null
@@ -1,194 +0,0 @@
-/*  Kernel module help for x86-64
-    Copyright (C) 2001 Rusty Russell.
-    Copyright (C) 2002,2003 Andi Kleen, SuSE Labs.
-
-    This program is free software; you can redistribute it and/or modify
-    it under the terms of the GNU General Public License as published by
-    the Free Software Foundation; either version 2 of the License, or
-    (at your option) any later version.
-
-    This program is distributed in the hope that it will be useful,
-    but WITHOUT ANY WARRANTY; without even the implied warranty of
-    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
-    GNU General Public License for more details.
-
-    You should have received a copy of the GNU General Public License
-    along with this program; if not, write to the Free Software
-    Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
-*/
-#include <linux/moduleloader.h>
-#include <linux/elf.h>
-#include <linux/vmalloc.h>
-#include <linux/fs.h>
-#include <linux/string.h>
-#include <linux/kernel.h>
-#include <linux/mm.h>
-#include <linux/slab.h>
-#include <linux/bug.h>
-
-#include <asm/system.h>
-#include <asm/page.h>
-#include <asm/pgtable.h>
-
-#define DEBUGP(fmt...)
-
-#ifndef CONFIG_UML
-void module_free(struct module *mod, void *module_region)
-{
-	vfree(module_region);
-	/* FIXME: If module_region == mod->init_region, trim exception
-	   table entries. */
-}
-
-void *module_alloc(unsigned long size)
-{
-	struct vm_struct *area;
-
-	if (!size)
-		return NULL;
-	size = PAGE_ALIGN(size);
-	if (size > MODULES_LEN)
-		return NULL;
-
-	area = __get_vm_area(size, VM_ALLOC, MODULES_VADDR, MODULES_END);
-	if (!area)
-		return NULL;
-
-	return __vmalloc_area(area, GFP_KERNEL, PAGE_KERNEL_EXEC);
-}
-#endif
-
-/* We don't need anything special. */
-int module_frob_arch_sections(Elf_Ehdr *hdr,
-			      Elf_Shdr *sechdrs,
-			      char *secstrings,
-			      struct module *mod)
-{
-	return 0;
-}
-
-int apply_relocate_add(Elf64_Shdr *sechdrs,
-		   const char *strtab,
-		   unsigned int symindex,
-		   unsigned int relsec,
-		   struct module *me)
-{
-	unsigned int i;
-	Elf64_Rela *rel = (void *)sechdrs[relsec].sh_addr;
-	Elf64_Sym *sym;
-	void *loc;
-	u64 val;
-
-	DEBUGP("Applying relocate section %u to %u\n", relsec,
-	       sechdrs[relsec].sh_info);
-	for (i = 0; i < sechdrs[relsec].sh_size / sizeof(*rel); i++) {
-		/* This is where to make the change */
-		loc = (void *)sechdrs[sechdrs[relsec].sh_info].sh_addr
-			+ rel[i].r_offset;
-
-		/* This is the symbol it is referring to.  Note that all
-		   undefined symbols have been resolved.  */
-		sym = (Elf64_Sym *)sechdrs[symindex].sh_addr
-			+ ELF64_R_SYM(rel[i].r_info);
-
-		DEBUGP("type %d st_value %Lx r_addend %Lx loc %Lx\n",
-			(int)ELF64_R_TYPE(rel[i].r_info),
-			sym->st_value, rel[i].r_addend, (u64)loc);
-
-		val = sym->st_value + rel[i].r_addend;
-
-		switch (ELF64_R_TYPE(rel[i].r_info)) {
-		case R_X86_64_NONE:
-			break;
-		case R_X86_64_64:
-			*(u64 *)loc = val;
-			break;
-		case R_X86_64_32:
-			*(u32 *)loc = val;
-			if (val != *(u32 *)loc)
-				goto overflow;
-			break;
-		case R_X86_64_32S:
-			*(s32 *)loc = val;
-			if ((s64)val != *(s32 *)loc)
-				goto overflow;
-			break;
-		case R_X86_64_PC32:
-			val -= (u64)loc;
-			*(u32 *)loc = val;
-#if 0
-			if ((s64)val != *(s32 *)loc)
-				goto overflow;
-#endif
-			break;
-		default:
-			printk(KERN_ERR "module %s: Unknown rela relocation: %llu\n",
-			       me->name, ELF64_R_TYPE(rel[i].r_info));
-			return -ENOEXEC;
-		}
-	}
-	return 0;
-
-overflow:
-	printk(KERN_ERR "overflow in relocation type %d val %Lx\n",
-	       (int)ELF64_R_TYPE(rel[i].r_info), val);
-	printk(KERN_ERR "`%s' likely not compiled with -mcmodel=kernel\n",
-	       me->name);
-	return -ENOEXEC;
-}
-
-int apply_relocate(Elf_Shdr *sechdrs,
-		   const char *strtab,
-		   unsigned int symindex,
-		   unsigned int relsec,
-		   struct module *me)
-{
-	printk(KERN_ERR "non add relocation not supported\n");
-	return -ENOSYS;
-}
-
-int module_finalize(const Elf_Ehdr *hdr,
-		    const Elf_Shdr *sechdrs,
-		    struct module *me)
-{
-	const Elf_Shdr *s, *text = NULL, *alt = NULL, *locks = NULL,
-		*para = NULL;
-	char *secstrings = (void *)hdr + sechdrs[hdr->e_shstrndx].sh_offset;
-
-	for (s = sechdrs; s < sechdrs + hdr->e_shnum; s++) {
-		if (!strcmp(".text", secstrings + s->sh_name))
-			text = s;
-		if (!strcmp(".altinstructions", secstrings + s->sh_name))
-			alt = s;
-		if (!strcmp(".smp_locks", secstrings + s->sh_name))
-			locks = s;
-		if (!strcmp(".parainstructions", secstrings + s->sh_name))
-			para = s;
-	}
-
-	if (alt) {
-		/* patch .altinstructions */
-		void *aseg = (void *)alt->sh_addr;
-		apply_alternatives(aseg, aseg + alt->sh_size);
-	}
-	if (locks && text) {
-		void *lseg = (void *)locks->sh_addr;
-		void *tseg = (void *)text->sh_addr;
-		alternatives_smp_module_add(me, me->name,
-					    lseg, lseg + locks->sh_size,
-					    tseg, tseg + text->sh_size);
-	}
-
-	if (para) {
-		void *pseg = (void *)para->sh_addr;
-		apply_paravirt(pseg, pseg + para->sh_size);
-	}
-
-	return module_bug_finalize(hdr, sechdrs, me);
-}
-
-void module_arch_cleanup(struct module *mod)
-{
-	alternatives_smp_module_del(mod);
-	module_bug_cleanup(mod);
-}


