Return-Path: <linux-kernel-owner+w=401wt.eu-S1756968AbZCZNJc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756968AbZCZNJc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Mar 2009 09:09:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754283AbZCZNJY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Mar 2009 09:09:24 -0400
Received: from hera.kernel.org ([140.211.167.34]:58508 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753872AbZCZNJW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Mar 2009 09:09:22 -0400
Subject: [PATCH -tip] x86: unification of module.c
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Ingo Molnar <mingo@elte.hu>, x86 maintainers <x86@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Rusty Russell <rusty@rustcorp.com.au>, Andi Kleen <andi@firstfloor.org>
Content-Type: text/plain
Date: Thu, 26 Mar 2009 18:38:33 +0530
Message-Id: <1238072913.2507.3.camel@ht.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch is based on -tip:x86/core:

From: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
Date: Thu, 26 Mar 2009 18:33:45 +0530
Subject: [PATCH] x86: unification of module.c

Impact: Unification, cleanup

Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
---
 arch/x86/kernel/Makefile    |    2 +-
 arch/x86/kernel/module.c    |  261 +++++++++++++++++++++++++++++++++++++++++++
 arch/x86/kernel/module_32.c |  152 -------------------------
 arch/x86/kernel/module_64.c |  194 --------------------------------
 4 files changed, 262 insertions(+), 347 deletions(-)
 create mode 100644 arch/x86/kernel/module.c
 delete mode 100644 arch/x86/kernel/module_32.c
 delete mode 100644 arch/x86/kernel/module_64.c

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
-- 
1.6.0.6



