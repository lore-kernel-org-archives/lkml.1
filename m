Return-Path: <linux-kernel-owner+w=401wt.eu-S1754961AbZEZIhL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754961AbZEZIhL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 May 2009 04:37:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754893AbZEZIgb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 May 2009 04:36:31 -0400
Received: from mx2.redhat.com ([66.187.237.31]:51172 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754936AbZEZIg3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 May 2009 04:36:29 -0400
Date: Tue, 26 May 2009 04:35:22 -0400
From: Amerigo Wang <amwang@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, rusty@rustcorp.com.au, jdike@addtoit.com,
       mingo@elte.hu, Amerigo Wang <amwang@redhat.com>
Message-Id: <20090526083734.5050.25473.sendpatchset@localhost.localdomain>
In-Reply-To: <20090526083717.5050.32719.sendpatchset@localhost.localdomain>
References: <20090526083717.5050.32719.sendpatchset@localhost.localdomain>
Subject: [Patch 2/4] x86 module: merge the rest functions with macros
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Merge the rest functions together, with preprocessing directives.
Finally remove module_{32|64}.c.

Signed-off-by: WANG Cong <amwang@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>

---
Index: linux-2.6/arch/x86/kernel/Makefile
===================================================================
--- linux-2.6.orig/arch/x86/kernel/Makefile
+++ linux-2.6/arch/x86/kernel/Makefile
@@ -72,7 +72,7 @@ obj-$(CONFIG_KEXEC)		+= machine_kexec_$(
 obj-$(CONFIG_KEXEC)		+= relocate_kernel_$(BITS).o crash.o
 obj-$(CONFIG_CRASH_DUMP)	+= crash_dump_$(BITS).o
 obj-$(CONFIG_KPROBES)		+= kprobes.o
-obj-$(CONFIG_MODULES)		+= module.o module_$(BITS).o
+obj-$(CONFIG_MODULES)		+= module.o
 obj-$(CONFIG_EFI) 		+= efi.o efi_$(BITS).o efi_stub_$(BITS).o
 obj-$(CONFIG_DOUBLEFAULT) 	+= doublefault_32.o
 obj-$(CONFIG_KGDB)		+= kgdb.o
Index: linux-2.6/arch/x86/kernel/module.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/module.c
+++ linux-2.6/arch/x86/kernel/module.c
@@ -34,6 +34,32 @@
 #define DEBUGP(fmt...)
 #endif
 
+#if defined(CONFIG_UML) || defined(CONFIG_X86_32)
+void *module_alloc(unsigned long size)
+{
+	if (size == 0)
+		return NULL;
+	return vmalloc_exec(size);
+}
+#else /*X86_64*/
+void *module_alloc(unsigned long size)
+{
+	struct vm_struct *area;
+
+	if (!size)
+		return NULL;
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
+#endif
+
 /* Free memory returned from module_alloc */
 void module_free(struct module *mod, void *module_region)
 {
@@ -51,6 +77,140 @@ int module_frob_arch_sections(Elf_Ehdr *
 	return 0;
 }
 
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
+	printk(KERN_ERR "module %s: ADD RELOCATION unsupported\n",
+	       me->name);
+	return -ENOEXEC;
+}
+#else /*X86_64*/
+int apply_relocate_add(Elf64_Shdr *sechdrs,
+		   const char *strtab,
+		   unsigned int symindex,
+		   unsigned int relsec,
+		   struct module *me)
+{
+	unsigned int i;
+	Elf64_Rela *rel = (void *)sechdrs[relsec].sh_addr;
+	Elf64_Sym *sym;
+	void *loc;
+	u64 val;
+
+	DEBUGP("Applying relocate section %u to %u\n", relsec,
+	       sechdrs[relsec].sh_info);
+	for (i = 0; i < sechdrs[relsec].sh_size / sizeof(*rel); i++) {
+		/* This is where to make the change */
+		loc = (void *)sechdrs[sechdrs[relsec].sh_info].sh_addr
+			+ rel[i].r_offset;
+
+		/* This is the symbol it is referring to.  Note that all
+		   undefined symbols have been resolved.  */
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
+#if 0
+			if ((s64)val != *(s32 *)loc)
+				goto overflow;
+#endif
+			break;
+		default:
+			printk(KERN_ERR "module %s: Unknown rela relocation: %llu\n",
+			       me->name, ELF64_R_TYPE(rel[i].r_info));
+			return -ENOEXEC;
+		}
+	}
+	return 0;
+
+overflow:
+	printk(KERN_ERR "overflow in relocation type %d val %Lx\n",
+	       (int)ELF64_R_TYPE(rel[i].r_info), val);
+	printk(KERN_ERR "`%s' likely not compiled with -mcmodel=kernel\n",
+	       me->name);
+	return -ENOEXEC;
+}
+
+int apply_relocate(Elf_Shdr *sechdrs,
+		   const char *strtab,
+		   unsigned int symindex,
+		   unsigned int relsec,
+		   struct module *me)
+{
+	printk(KERN_ERR "non add relocation not supported\n");
+	return -ENOSYS;
+}
+
+#endif
+
 int module_finalize(const Elf_Ehdr *hdr,
 		    const Elf_Shdr *sechdrs,
 		    struct module *me)
Index: linux-2.6/arch/x86/kernel/module_32.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/module_32.c
+++ /dev/null
@@ -1,90 +0,0 @@
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
Index: linux-2.6/arch/x86/kernel/module_64.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/module_64.c
+++ /dev/null
@@ -1,133 +0,0 @@
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
