Return-Path: <linux-kernel-owner+w=401wt.eu-S1763503AbXE1TT2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763503AbXE1TT2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 May 2007 15:19:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760116AbXE1TS7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 May 2007 15:18:59 -0400
Received: from astra.telenet-ops.be ([195.130.132.58]:56630 "EHLO
	astra.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751452AbXE1TS5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 May 2007 15:18:57 -0400
Message-Id: <20070528191715.352919509@mail.of.borg>
References: <20070528191630.377693320@mail.of.borg>
User-Agent: quilt/0.46-1
Date: Mon, 28 May 2007 21:16:31 +0200
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Linus Torvalds <torvalds@osdl.org>, Andrew Morton <akpm@osdl.org>
Cc: linux-kernel@vger.kernel.org, linux-m68k@vger.kernel.org,
       Roman Zippel <zippel@linux-m68k.org>
Subject: [patch 1/2] m68k: runtime patching infrastructure
Content-Disposition: inline; filename=611-module_fixup.diff
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Roman Zippel <zippel@linux-m68k.org>

Add the basic infrastructure to allow runtime patching of kernel and
modules to optimize a few functions with parameters, which are only
calculated once during bootup and are otherwise constant.
Use this for the conversion between virtual and physical addresses.

Signed-off-by: Roman Zippel <zippel@linux-m68k.org>
Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 arch/m68k/Makefile                |    1 +
 arch/m68k/kernel/Makefile         |    3 +--
 arch/m68k/kernel/module.c         |   28 +++++++++++++++++++++++++++-
 arch/m68k/kernel/module.lds       |    7 +++++++
 arch/m68k/kernel/vmlinux-std.lds  |    5 +++++
 arch/m68k/kernel/vmlinux-sun3.lds |    5 +++++
 arch/m68k/mm/motorola.c           |    3 +++
 include/asm-m68k/module.h         |   33 ++++++++++++++++++++++++++++++++-
 include/asm-m68k/page.h           |   29 ++++++++++++++++++++++++++---
 9 files changed, 107 insertions(+), 7 deletions(-)

--- a/arch/m68k/Makefile
+++ b/arch/m68k/Makefile
@@ -19,6 +19,7 @@ COMPILE_ARCH = $(shell uname -m)
 # override top level makefile
 AS += -m68020
 LDFLAGS := -m m68kelf
+LDFLAGS_MODULE += -T $(srctree)/arch/m68k/kernel/module.lds
 ifneq ($(COMPILE_ARCH),$(ARCH))
 	# prefix for cross-compiling binaries
 	CROSS_COMPILE = m68k-linux-gnu-
--- a/arch/m68k/kernel/Makefile
+++ b/arch/m68k/kernel/Makefile
@@ -9,13 +9,12 @@ else
 endif
 extra-y	+= vmlinux.lds
 
-obj-y	:= entry.o process.o traps.o ints.o signal.o ptrace.o \
+obj-y	:= entry.o process.o traps.o ints.o signal.o ptrace.o module.o \
 	   sys_m68k.o time.o semaphore.o setup.o m68k_ksyms.o devres.o
 
 devres-y = ../../../kernel/irq/devres.o
 
 obj-$(CONFIG_PCI)	+= bios32.o
-obj-$(CONFIG_MODULES)	+= module.o
 obj-y$(CONFIG_MMU_SUN3) += dma.o	# no, it's not a typo
 
 EXTRA_AFLAGS := -traditional
--- a/arch/m68k/kernel/module.c
+++ b/arch/m68k/kernel/module.c
@@ -1,3 +1,9 @@
+/*
+ * This file is subject to the terms and conditions of the GNU General Public
+ * License.  See the file COPYING in the main directory of this archive
+ * for more details.
+ */
+
 #include <linux/moduleloader.h>
 #include <linux/elf.h>
 #include <linux/vmalloc.h>
@@ -11,6 +17,8 @@
 #define DEBUGP(fmt...)
 #endif
 
+#ifdef CONFIG_MODULES
+
 void *module_alloc(unsigned long size)
 {
 	if (size == 0)
@@ -118,11 +126,29 @@ int apply_relocate_add(Elf32_Shdr *sechd
 
 int module_finalize(const Elf_Ehdr *hdr,
 		    const Elf_Shdr *sechdrs,
-		    struct module *me)
+		    struct module *mod)
 {
+	module_fixup(mod, mod->arch.fixup_start, mod->arch.fixup_end);
+
 	return 0;
 }
 
 void module_arch_cleanup(struct module *mod)
 {
 }
+
+#endif /* CONFIG_MODULES */
+
+void module_fixup(struct module *mod, struct m68k_fixup_info *start,
+		  struct m68k_fixup_info *end)
+{
+	struct m68k_fixup_info *fixup;
+
+	for (fixup = start; fixup < end; fixup++) {
+		switch (fixup->type) {
+		case m68k_fixup_memoffset:
+			*(u32 *)fixup->addr = m68k_memoffset;
+			break;
+		}
+	}
+}
--- /dev/null
+++ b/arch/m68k/kernel/module.lds
@@ -0,0 +1,7 @@
+SECTIONS {
+	.m68k_fixup : {
+		__start_fixup = .;
+		*(.m68k_fixup)
+		__stop_fixup = .;
+	}
+}
--- a/arch/m68k/kernel/vmlinux-std.lds
+++ b/arch/m68k/kernel/vmlinux-std.lds
@@ -60,6 +60,11 @@ SECTIONS
   __con_initcall_start = .;
   .con_initcall.init : { *(.con_initcall.init) }
   __con_initcall_end = .;
+  .m68k_fixup : {
+	__start_fixup = .;
+	*(.m68k_fixup)
+	__stop_fixup = .;
+  }
   SECURITY_INIT
 #ifdef CONFIG_BLK_DEV_INITRD
   . = ALIGN(8192);
--- a/arch/m68k/kernel/vmlinux-sun3.lds
+++ b/arch/m68k/kernel/vmlinux-sun3.lds
@@ -54,6 +54,11 @@ __init_begin = .;
 	__con_initcall_start = .;
 	.con_initcall.init : { *(.con_initcall.init) }
 	__con_initcall_end = .;
+	.m68k_fixup : {
+		__start_fixup = .;
+		*(.m68k_fixup)
+		__stop_fixup = .;
+	}
 	SECURITY_INIT
 #ifdef CONFIG_BLK_DEV_INITRD
 	. = ALIGN(8192);
--- a/arch/m68k/mm/motorola.c
+++ b/arch/m68k/mm/motorola.c
@@ -222,6 +222,9 @@ void __init paging_init(void)
 			pgprot_val(protection_map[i]) |= _PAGE_CACHE040;
 	}
 
+	module_fixup(NULL, __start_fixup, __stop_fixup);
+	flush_icache();
+
 	/*
 	 * Map the physical memory available into the kernel virtual
 	 * address space.  It may allocate some memory for page
--- a/include/asm-m68k/module.h
+++ b/include/asm-m68k/module.h
@@ -1,7 +1,38 @@
 #ifndef _ASM_M68K_MODULE_H
 #define _ASM_M68K_MODULE_H
-struct mod_arch_specific { };
+
+struct mod_arch_specific {
+	struct m68k_fixup_info *fixup_start, *fixup_end;
+};
+
+#define MODULE_ARCH_INIT {				\
+	.fixup_start		= __start_fixup,	\
+	.fixup_end		= __stop_fixup,		\
+}
+
 #define Elf_Shdr Elf32_Shdr
 #define Elf_Sym Elf32_Sym
 #define Elf_Ehdr Elf32_Ehdr
+
+
+enum m68k_fixup_type {
+	m68k_fixup_memoffset,
+};
+
+struct m68k_fixup_info {
+	enum m68k_fixup_type type;
+	void *addr;
+};
+
+#define m68k_fixup(type, addr)			\
+	"	.section \".m68k_fixup\",\"aw\"\n"	\
+	"	.long " #type "," #addr "\n"	\
+	"	.previous\n"
+
+extern struct m68k_fixup_info __start_fixup[], __stop_fixup[];
+
+struct module;
+extern void module_fixup(struct module *mod, struct m68k_fixup_info *start,
+			 struct m68k_fixup_info *end);
+
 #endif /* _ASM_M68K_MODULE_H */
--- a/include/asm-m68k/page.h
+++ b/include/asm-m68k/page.h
@@ -27,6 +27,8 @@
 
 #ifndef __ASSEMBLY__
 
+#include <asm/module.h>
+
 #define get_user_page(vaddr)		__get_free_page(GFP_KERNEL)
 #define free_user_page(page, addr)	free_page(addr)
 
@@ -114,14 +116,35 @@ typedef struct { unsigned long pgprot; }
 
 #ifndef __ASSEMBLY__
 
+extern unsigned long m68k_memoffset;
+
 #ifndef CONFIG_SUN3
 
 #define WANT_PAGE_VIRTUAL
 #ifdef CONFIG_SINGLE_MEMORY_CHUNK
-extern unsigned long m68k_memoffset;
 
-#define __pa(vaddr)		((unsigned long)(vaddr)+m68k_memoffset)
-#define __va(paddr)		((void *)((unsigned long)(paddr)-m68k_memoffset))
+static inline unsigned long ___pa(void *vaddr)
+{
+	unsigned long paddr;
+	asm (
+		"1:	addl #0,%0\n"
+		m68k_fixup(%c2, 1b+2)
+		: "=r" (paddr)
+		: "0" (vaddr), "i" (m68k_fixup_memoffset));
+	return paddr;
+}
+#define __pa(vaddr)    ___pa((void *)(vaddr))
+static inline void *__va(unsigned long paddr)
+{
+	void *vaddr;
+	asm (
+		"1:	subl #0,%0\n"
+		m68k_fixup(%c2, 1b+2)
+		: "=r" (vaddr)
+		: "0" (paddr), "i" (m68k_fixup_memoffset));
+	return vaddr;
+}
+
 #else
 #define __pa(vaddr)		virt_to_phys((void *)(vaddr))
 #define __va(paddr)		phys_to_virt((unsigned long)(paddr))

-- 
Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds

