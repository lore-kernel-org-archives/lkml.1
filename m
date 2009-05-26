Return-Path: <linux-kernel-owner+w=401wt.eu-S1754721AbZEZIgd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754721AbZEZIgd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 May 2009 04:36:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754416AbZEZIgR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 May 2009 04:36:17 -0400
Received: from mx2.redhat.com ([66.187.237.31]:51161 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754185AbZEZIgP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 May 2009 04:36:15 -0400
Date: Tue, 26 May 2009 04:35:13 -0400
From: Amerigo Wang <amwang@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, rusty@rustcorp.com.au, jdike@addtoit.com,
       mingo@elte.hu, Amerigo Wang <amwang@redhat.com>
Message-Id: <20090526083725.5050.53124.sendpatchset@localhost.localdomain>
In-Reply-To: <20090526083717.5050.32719.sendpatchset@localhost.localdomain>
References: <20090526083717.5050.32719.sendpatchset@localhost.localdomain>
Subject: [Patch 1/4] x86 module: merge the same functions in module_32.c and module_64.c
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Merge the same functions both in module_32.c and module_64.c into
module.c.

Signed-off-by: WANG Cong <amwang@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu> 

---
Index: linux-2.6/arch/x86/kernel/module.c
===================================================================
--- /dev/null
+++ linux-2.6/arch/x86/kernel/module.c
@@ -0,0 +1,98 @@
+/*  Kernel module help for x86.
+    Copyright (C) 2001 Rusty Russell.
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
+#include <linux/elf.h>
+#include <linux/vmalloc.h>
+#include <linux/fs.h>
+#include <linux/string.h>
+#include <linux/kernel.h>
+#include <linux/bug.h>
+#include <linux/mm.h>
+
+#include <asm/system.h>
+#include <asm/page.h>
+#include <asm/pgtable.h>
+
+#if 0
+#define DEBUGP printk
+#else
+#define DEBUGP(fmt...)
+#endif
+
+/* Free memory returned from module_alloc */
+void module_free(struct module *mod, void *module_region)
+{
+	vfree(module_region);
+	/* FIXME: If module_region == mod->init_region, trim exception
+	   table entries. */
+}
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
Index: linux-2.6/arch/x86/kernel/Makefile
===================================================================
--- linux-2.6.orig/arch/x86/kernel/Makefile
+++ linux-2.6/arch/x86/kernel/Makefile
@@ -72,7 +72,7 @@ obj-$(CONFIG_KEXEC)		+= machine_kexec_$(
 obj-$(CONFIG_KEXEC)		+= relocate_kernel_$(BITS).o crash.o
 obj-$(CONFIG_CRASH_DUMP)	+= crash_dump_$(BITS).o
 obj-$(CONFIG_KPROBES)		+= kprobes.o
-obj-$(CONFIG_MODULES)		+= module_$(BITS).o
+obj-$(CONFIG_MODULES)		+= module.o module_$(BITS).o
 obj-$(CONFIG_EFI) 		+= efi.o efi_$(BITS).o efi_stub_$(BITS).o
 obj-$(CONFIG_DOUBLEFAULT) 	+= doublefault_32.o
 obj-$(CONFIG_KGDB)		+= kgdb.o
Index: linux-2.6/arch/x86/kernel/module_32.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/module_32.c
+++ linux-2.6/arch/x86/kernel/module_32.c
@@ -37,23 +37,6 @@ void *module_alloc(unsigned long size)
 }
 
 
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
 int apply_relocate(Elf32_Shdr *sechdrs,
 		   const char *strtab,
 		   unsigned int symindex,
@@ -105,48 +88,3 @@ int apply_relocate_add(Elf32_Shdr *sechd
 	return -ENOEXEC;
 }
 
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
Index: linux-2.6/arch/x86/kernel/module_64.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/module_64.c
+++ linux-2.6/arch/x86/kernel/module_64.c
@@ -33,13 +33,6 @@
 #define DEBUGP(fmt...)
 
 #ifndef CONFIG_UML
-void module_free(struct module *mod, void *module_region)
-{
-	vfree(module_region);
-	/* FIXME: If module_region == mod->init_region, trim exception
-	   table entries. */
-}
-
 void *module_alloc(unsigned long size)
 {
 	struct vm_struct *area;
@@ -58,15 +51,6 @@ void *module_alloc(unsigned long size)
 }
 #endif
 
-/* We don't need anything special. */
-int module_frob_arch_sections(Elf_Ehdr *hdr,
-			      Elf_Shdr *sechdrs,
-			      char *secstrings,
-			      struct module *mod)
-{
-	return 0;
-}
-
 int apply_relocate_add(Elf64_Shdr *sechdrs,
 		   const char *strtab,
 		   unsigned int symindex,
@@ -147,48 +131,3 @@ int apply_relocate(Elf_Shdr *sechdrs,
 	return -ENOSYS;
 }
 
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
