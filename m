Return-Path: <linux-kernel-owner+w=401wt.eu-S1761488AbYFZNfI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761488AbYFZNfI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2008 09:35:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753538AbYFZNex
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jun 2008 09:34:53 -0400
Received: from 238.225.broadband7.iol.cz ([88.102.225.238]:24158 "EHLO
	monstr.eu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753289AbYFZNev (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2008 09:34:51 -0400
From: monstr@seznam.cz
To: linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, linux-arch@vger.kernel.org, stephen.neuendorffer@xilinx.com,
       John.Linn@xilinx.com, john.williams@petalogix.com, matthew@wil.cx,
       will.newton@gmail.com, drepper@redhat.com,
       microblaze-uclinux@itee.uq.edu.au, grant.likely@secretlab.ca,
       linuxppc-dev@ozlabs.org, vapier.adi@gmail.com, alan@lxorguk.ukuu.org.uk,
       hpa@zytor.com, Michal Simek <monstr@monstr.eu>
Subject: [PATCH 13/60] microblaze_v4: kernel modules support
Date: Thu, 26 Jun 2008 14:29:42 +0200
Message-Id: <1214483429-32360-14-git-send-email-monstr@seznam.cz>
X-Mailer: git-send-email 1.5.4.GIT
In-Reply-To: <1214483429-32360-13-git-send-email-monstr@seznam.cz>
References: <1214483429-32360-1-git-send-email-monstr@seznam.cz>
 <1214483429-32360-2-git-send-email-monstr@seznam.cz>
 <1214483429-32360-3-git-send-email-monstr@seznam.cz>
 <1214483429-32360-4-git-send-email-monstr@seznam.cz>
 <1214483429-32360-5-git-send-email-monstr@seznam.cz>
 <1214483429-32360-6-git-send-email-monstr@seznam.cz>
 <1214483429-32360-7-git-send-email-monstr@seznam.cz>
 <1214483429-32360-8-git-send-email-monstr@seznam.cz>
 <1214483429-32360-9-git-send-email-monstr@seznam.cz>
 <1214483429-32360-10-git-send-email-monstr@seznam.cz>
 <1214483429-32360-11-git-send-email-monstr@seznam.cz>
 <1214483429-32360-12-git-send-email-monstr@seznam.cz>
 <1214483429-32360-13-git-send-email-monstr@seznam.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michal Simek <monstr@monstr.eu>


Signed-off-by: Michal Simek <monstr@monstr.eu>
---
 arch/microblaze/kernel/microblaze_ksyms.c |   47 ++++++++++
 arch/microblaze/kernel/module.c           |  140 +++++++++++++++++++++++++++++
 include/asm-microblaze/module.h           |   37 ++++++++
 3 files changed, 224 insertions(+), 0 deletions(-)
 create mode 100644 arch/microblaze/kernel/microblaze_ksyms.c
 create mode 100644 arch/microblaze/kernel/module.c
 create mode 100644 include/asm-microblaze/module.h

diff --git a/arch/microblaze/kernel/microblaze_ksyms.c b/arch/microblaze/kernel/microblaze_ksyms.c
new file mode 100644
index 0000000..297cd68
--- /dev/null
+++ b/arch/microblaze/kernel/microblaze_ksyms.c
@@ -0,0 +1,47 @@
+/*
+ * Copyright (C) 2008 Michal Simek <monstr@monstr.eu>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+#include <linux/module.h>
+#include <linux/string.h>
+#include <linux/cryptohash.h>
+#include <linux/delay.h>
+#include <linux/in6.h>
+#include <linux/syscalls.h>
+
+#include <asm/checksum.h>
+#include <asm/io.h>
+#include <asm/page.h>
+#include <asm/system.h>
+#include <asm/uaccess.h>
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
+/*extern void fpundefinstr(void);
+extern void fp_enter(void);*/
diff --git a/arch/microblaze/kernel/module.c b/arch/microblaze/kernel/module.c
new file mode 100644
index 0000000..a59b2e5
--- /dev/null
+++ b/arch/microblaze/kernel/module.c
@@ -0,0 +1,140 @@
+/*
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ */
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
+#undef DEBUG
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
+
+	printk(KERN_ERR "module %s: ADD RELOCATION unsupported\n",
+		module->name);
+	return -ENOEXEC;
+
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
+	unsigned long int old_value;
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
+			old_value = *location;
+			*location = value + old_value;
+			pr_debug("R_MICROBLAZE_32 (%08lx->%08lx)\n",
+				old_value, value);
+			break;
+
+		case R_MICROBLAZE_64:
+			old_value = ((location[0] & 0x0000FFFF) << 16) |
+				((location[1] & 0x0000FFFF));
+			value += old_value;
+			location[0] = (location[0] & 0xFFFF0000) |
+					(value >> 16);
+			location[1] = (location[1] & 0xFFFF0000) |
+					(value & 0xFFFF);
+			pr_debug("R_MICROBLAZE_64 (%08lx->%08lx)\n",
+				old_value, value);
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
diff --git a/include/asm-microblaze/module.h b/include/asm-microblaze/module.h
new file mode 100644
index 0000000..914565a
--- /dev/null
+++ b/include/asm-microblaze/module.h
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
-- 
1.5.4.GIT

