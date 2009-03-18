Return-Path: <linux-kernel-owner+w=401wt.eu-S1758016AbZCRUfA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758016AbZCRUfA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Mar 2009 16:35:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753108AbZCRUbx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Mar 2009 16:31:53 -0400
Received: from 178-47-31-89.wifiinternet.cz ([89.31.47.178]:56227 "EHLO
	monstr.eu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753066AbZCRUbn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Mar 2009 16:31:43 -0400
From: monstr@monstr.eu
To: linux-kernel@vger.kernel.org
Cc: john.williams@petalogix.com, Michal Simek <monstr@monstr.eu>
Subject: [PATCH 11/57] microblaze_v7: kernel modules support
Date: Wed, 18 Mar 2009 21:30:38 +0100
Message-Id: <f7f2d17e21a3df9931c75976c37a003d11190cc9.1237407249.git.monstr@monstr.eu>
X-Mailer: git-send-email 1.5.5.1
In-Reply-To: <2f48efc353c11dfdfc7b052bdfe052b71c09ab23.1237407249.git.monstr@monstr.eu>
References: <1237408284-8674-1-git-send-email-monstr@monstr.eu>
 <0168f03c96e9479ede695a9859c8a0691baa8ef3.1237407249.git.monstr@monstr.eu>
 <c1bdfabf85ce10babc3aa38d3bb7558a093bc49e.1237407249.git.monstr@monstr.eu>
 <4b5aee01d11fc790c7842838ea63a82ee3273003.1237407249.git.monstr@monstr.eu>
 <af309ba8e95f503b7990461384d9f8453f45dbbd.1237407249.git.monstr@monstr.eu>
 <5f8b2a60496983f572ef6d3b4e2f986c167a8336.1237407249.git.monstr@monstr.eu>
 <fbef554ff1d05fa50312d91e61a0d63d3207076c.1237407249.git.monstr@monstr.eu>
 <dad2353f129217470f0595eeed98412b4c84ed6b.1237407249.git.monstr@monstr.eu>
 <20fd42a1e8837c7352d35d157aa3393e88152c32.1237407249.git.monstr@monstr.eu>
 <f7c1685bd3f387be8633db5fb3dd4cb5e7c2d792.1237407249.git.monstr@monstr.eu>
 <2f48efc353c11dfdfc7b052bdfe052b71c09ab23.1237407249.git.monstr@monstr.eu>
In-Reply-To: <0168f03c96e9479ede695a9859c8a0691baa8ef3.1237407249.git.monstr@monstr.eu>
References: <0168f03c96e9479ede695a9859c8a0691baa8ef3.1237407249.git.monstr@monstr.eu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michal Simek <monstr@monstr.eu>


Signed-off-by: Michal Simek <monstr@monstr.eu>
---
 arch/microblaze/include/asm/module.h      |   37 +++++++
 arch/microblaze/kernel/microblaze_ksyms.c |   46 +++++++++
 arch/microblaze/kernel/module.c           |  148 +++++++++++++++++++++++++++++
 3 files changed, 231 insertions(+), 0 deletions(-)
 create mode 100644 arch/microblaze/include/asm/module.h
 create mode 100644 arch/microblaze/kernel/microblaze_ksyms.c
 create mode 100644 arch/microblaze/kernel/module.c

diff --git a/arch/microblaze/include/asm/module.h b/arch/microblaze/include/asm/module.h
new file mode 100644
index 0000000..914565a
--- /dev/null
+++ b/arch/microblaze/include/asm/module.h
@@ -0,0 +1,37 @@
+/*
+ * Copyright (C) 2006 Atmark Techno, Inc.
+ *
+ * This file is subject to the terms and conditions of the GNU General Public
+ * License. See the file "COPYING" in the main directory of this archive
+ * for more details.
+ */
+
+#ifndef _ASM_MICROBLAZE_MODULE_H
+#define _ASM_MICROBLAZE_MODULE_H
+
+/* Microblaze Relocations */
+#define R_MICROBLAZE_NONE 0
+#define R_MICROBLAZE_32 1
+#define R_MICROBLAZE_32_PCREL 2
+#define R_MICROBLAZE_64_PCREL 3
+#define R_MICROBLAZE_32_PCREL_LO 4
+#define R_MICROBLAZE_64 5
+#define R_MICROBLAZE_32_LO 6
+#define R_MICROBLAZE_SRO32 7
+#define R_MICROBLAZE_SRW32 8
+#define R_MICROBLAZE_64_NONE 9
+#define R_MICROBLAZE_32_SYM_OP_SYM 10
+/* Keep this the last entry. */
+#define R_MICROBLAZE_NUM 11
+
+struct mod_arch_specific {
+	int foo;
+};
+
+#define Elf_Shdr	Elf32_Shdr
+#define Elf_Sym		Elf32_Sym
+#define Elf_Ehdr	Elf32_Ehdr
+
+typedef struct { volatile int counter; } module_t;
+
+#endif /* _ASM_MICROBLAZE_MODULE_H */
diff --git a/arch/microblaze/kernel/microblaze_ksyms.c b/arch/microblaze/kernel/microblaze_ksyms.c
new file mode 100644
index 0000000..e8ffb6f
--- /dev/null
+++ b/arch/microblaze/kernel/microblaze_ksyms.c
@@ -0,0 +1,46 @@
+/*
+ * Copyright (C) 2008 Michal Simek <monstr@monstr.eu>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/module.h>
+#include <linux/string.h>
+#include <linux/cryptohash.h>
+#include <linux/delay.h>
+#include <linux/in6.h>
+#include <linux/syscalls.h>
+
+#include <asm/checksum.h>
+#include <linux/io.h>
+#include <asm/page.h>
+#include <asm/system.h>
+#include <linux/uaccess.h>
+
+/*
+ * libgcc functions - functions that are used internally by the
+ * compiler... (prototypes are not correct though, but that
+ * doesn't really matter since they're not versioned).
+ */
+extern void __ashldi3(void);
+EXPORT_SYMBOL(__ashldi3);
+extern void __ashrdi3(void);
+EXPORT_SYMBOL(__ashrdi3);
+extern void __divsi3(void);
+EXPORT_SYMBOL(__divsi3);
+extern void __lshrdi3(void);
+EXPORT_SYMBOL(__lshrdi3);
+extern void __modsi3(void);
+EXPORT_SYMBOL(__modsi3);
+extern void __mulsi3(void);
+EXPORT_SYMBOL(__mulsi3);
+extern void __muldi3(void);
+EXPORT_SYMBOL(__muldi3);
+extern void __ucmpdi2(void);
+EXPORT_SYMBOL(__ucmpdi2);
+extern void __udivsi3(void);
+EXPORT_SYMBOL(__udivsi3);
+extern void __umodsi3(void);
+EXPORT_SYMBOL(__umodsi3);
diff --git a/arch/microblaze/kernel/module.c b/arch/microblaze/kernel/module.c
new file mode 100644
index 0000000..92549a2
--- /dev/null
+++ b/arch/microblaze/kernel/module.c
@@ -0,0 +1,148 @@
+/*
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/module.h>
+#include <linux/moduleloader.h>
+#include <linux/kernel.h>
+#include <linux/elf.h>
+#include <linux/vmalloc.h>
+#include <linux/slab.h>
+#include <linux/fs.h>
+#include <linux/string.h>
+
+#include <asm/pgtable.h>
+
+void *module_alloc(unsigned long size)
+{
+	void *ret;
+	ret = (size == 0) ? NULL : vmalloc(size);
+	pr_debug("module_alloc (%08lx@%08lx)\n", size, (unsigned long int)ret);
+	return ret;
+}
+
+void module_free(struct module *module, void *region)
+{
+	pr_debug("module_free(%s,%08lx)\n", module->name,
+					(unsigned long)region);
+	vfree(region);
+}
+
+int module_frob_arch_sections(Elf_Ehdr *hdr,
+				Elf_Shdr *sechdrs,
+				char *secstrings,
+				struct module *mod)
+{
+	return 0;
+}
+
+int apply_relocate(Elf32_Shdr *sechdrs, const char *strtab,
+	unsigned int symindex, unsigned int relsec, struct module *module)
+{
+	printk(KERN_ERR "module %s: ADD RELOCATION unsupported\n",
+		module->name);
+	return -ENOEXEC;
+}
+
+int apply_relocate_add(Elf32_Shdr *sechdrs, const char *strtab,
+	unsigned int symindex, unsigned int relsec, struct module *module)
+{
+
+	unsigned int i;
+	Elf32_Rela *rela = (void *)sechdrs[relsec].sh_addr;
+	Elf32_Sym *sym;
+	unsigned long int *location;
+	unsigned long int locoffs;
+	unsigned long int value;
+#if __GNUC__ < 4
+	unsigned long int old_value;
+#endif
+
+	pr_debug("Applying add relocation section %u to %u\n",
+		relsec, sechdrs[relsec].sh_info);
+
+	for (i = 0; i < sechdrs[relsec].sh_size / sizeof(*rela); i++) {
+
+		location = (void *)sechdrs[sechdrs[relsec].sh_info].sh_addr +
+				rela[i].r_offset;
+		sym = (Elf32_Sym *)sechdrs[symindex].sh_addr +
+			ELF32_R_SYM(rela[i].r_info);
+		value = sym->st_value + rela[i].r_addend;
+
+		switch (ELF32_R_TYPE(rela[i].r_info)) {
+
+		/*
+		 * Be careful! mb-gcc / mb-ld splits the relocs between the
+		 * text and the reloc table. In general this means we must
+		 * read the current contents of (*location), add any offset
+		 * then store the result back in
+		 */
+
+		case R_MICROBLAZE_32:
+#if __GNUC__ < 4
+			old_value = *location;
+			*location = value + old_value;
+
+			pr_debug("R_MICROBLAZE_32 (%08lx->%08lx)\n",
+				old_value, value);
+#else
+			*location = value;
+#endif
+			break;
+
+		case R_MICROBLAZE_64:
+#if __GNUC__ < 4
+			/* Split relocs only required/used pre gcc4.1.1 */
+			old_value = ((location[0] & 0x0000FFFF) << 16) |
+					(location[1] & 0x0000FFFF);
+			value += old_value;
+#endif
+			location[0] = (location[0] & 0xFFFF0000) |
+					(value >> 16);
+			location[1] = (location[1] & 0xFFFF0000) |
+					(value & 0xFFFF);
+#if __GNUC__ < 4
+			pr_debug("R_MICROBLAZE_64 (%08lx->%08lx)\n",
+				old_value, value);
+#endif
+			break;
+
+		case R_MICROBLAZE_64_PCREL:
+			locoffs = (location[0] & 0xFFFF) << 16 |
+				(location[1] & 0xFFFF);
+			value -= (unsigned long int)(location) + 4 +
+				locoffs;
+			location[0] = (location[0] & 0xFFFF0000) |
+					(value >> 16);
+			location[1] = (location[1] & 0xFFFF0000) |
+					(value & 0xFFFF);
+			pr_debug("R_MICROBLAZE_64_PCREL (%08lx)\n",
+				value);
+			break;
+
+		case R_MICROBLAZE_NONE:
+			pr_debug("R_MICROBLAZE_NONE\n");
+			break;
+
+		default:
+			printk(KERN_ERR "module %s: "
+				"Unknown relocation: %u\n",
+				module->name,
+				ELF32_R_TYPE(rela->r_info));
+			return -ENOEXEC;
+		}
+	}
+	return 0;
+}
+
+int module_finalize(const Elf32_Ehdr *hdr, const Elf_Shdr *sechdrs,
+		struct module *module)
+{
+	return 0;
+}
+
+void module_arch_cleanup(struct module *mod)
+{
+}
-- 
1.5.5.1

