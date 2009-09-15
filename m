Return-Path: <linux-kernel-owner+w=401wt.eu-S934144AbZIOCsU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934144AbZIOCsU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Sep 2009 22:48:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934329AbZIOCsL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Sep 2009 22:48:11 -0400
Received: from mail153.messagelabs.com ([216.82.253.51]:8746 "EHLO
	mail153.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933035AbZIOCsJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Sep 2009 22:48:09 -0400
X-VirusChecked: Checked
X-Env-Sender: yuan-bo.ye@motorola.com
X-Msg-Ref: server-2.tower-153.messagelabs.com!1252982891!18334278!1
X-StarScan-Version: 6.1.3; banners=-,-,-
X-Originating-IP: [136.182.1.14]
Subject: [PATCH] Check write to slab memory which freed already using
 mudflap v3
From: Janboe Ye <yuan-bo.ye@motorola.com>
To: vegard.nossum@gmail.com, graydon@redhat.com, fche@redhat.com,
       mingo@elte.hu, cl@linux-foundation.org, penberg@cs.helsinki.fi
Cc: linux-arm-kernel@lists.arm.linux.org.uk,
       linux-kernel <linux-kernel@vger.kernel.org>, janboe.ye@gmail.com
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Tue, 15 Sep 2009 10:48:01 +0800
Message-Id: <1252982881.3445.7.camel@debian-nb>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

slab debug detects the corruption when it allocates and frees the slab. But if someone write to slab memory when it already freed, slab debug could only report its last free point when slab allocates the same block.

This information is not enough for debugging when system has complex memory usage. gcc mudflap could insert some check point when a memory is writing and it is helpful to check if the address is writing freed.

Because most codes of kernel are drivers, it is most possible that drivers have such problem. So I use mudflap to compile all drivers.

kmemcheck is also helpful to check same issue, and it triggers trap every reading and writing, and it need to analysis the instruct which trigger the trap to get the memory address.
This heavy depends on the cpu capability. arm has no single-step like x86, so kmemcheck is too heavy to run on real arm system. mudflap way is lighter than kmemcheck for this purpose.

As stack allocation is useless for checking slab, kernel mudflap does not implement alloc which is required by gcc mudflap when codes use variable array. So variable array, such as array[i] which i could not determined by compiler, is not supported.

Note: gcc 4.1.2 generates a wrong code in kbd_init of drivers/char/keyboard.c when use mudflap flag. Version 4.2 and 4.3 are ok.

mudflap link: http://gcc.gnu.org/wiki/Mudflap_Pointer_Debugging

Thanks a lot for comments

Changeslong:
V3: make codes more arch independence according to Pekka Enberg comments
V2: add slub support according to Pekka Enberg comments
V1: add mudflap core and slab support

Signed-off-by: janboe <yuan-bo.ye@motorola.com>

 arch/arm/include/asm/elf.h        |    1 +
 arch/arm/include/asm/mf-runtime.h |    6 ++
 arch/arm/kernel/Makefile          |    2 +-
 arch/arm/kernel/module.c          |    1 +
 arch/arm/kernel/mudflap.c         |   24 ++++++++
 drivers/Makefile                  |    4 +-
 include/linux/slab_def.h          |    4 ++
 include/linux/slub_def.h          |    4 ++
 include/mf-runtime.h              |   45 ++++++++++++++++
 kernel/Makefile                   |    2 +-
 kernel/mudflap.c                  |  105 +++++++++++++++++++++++++++++++++++++
 lib/Kconfig.debug                 |    7 +++
 mm/slab.c                         |   40 ++++++++++++++
 mm/slub.c                         |   28 ++++++++++
 14 files changed, 270 insertions(+), 3 deletions(-)

diff --git a/arch/arm/include/asm/elf.h b/arch/arm/include/asm/elf.h
index c207504..30cb4b7 100644
--- a/arch/arm/include/asm/elf.h
+++ b/arch/arm/include/asm/elf.h
@@ -50,6 +50,7 @@ typedef struct user_fp elf_fpregset_t;
 #define R_ARM_ABS32		2
 #define R_ARM_CALL		28
 #define R_ARM_JUMP24		29
+#define R_ARM_TARGET1		38
 #define R_ARM_V4BX		40
 #define R_ARM_PREL31		42
 #define R_ARM_MOVW_ABS_NC	43
diff --git a/arch/arm/include/asm/mf-runtime.h b/arch/arm/include/asm/mf-runtime.h
new file mode 100644
index 0000000..c1ba871
--- /dev/null
+++ b/arch/arm/include/asm/mf-runtime.h
@@ -0,0 +1,6 @@
+#ifndef _LINUX_ARM_MF_RUNTIME
+#define _LINUX_ARM_MF_RUNTIME
+#ifdef _MUDFLAP
+#pragma redefine_extname __memzero kmudflap_memzero
+#endif /* _MUDFLAP */
+#endif
diff --git a/arch/arm/kernel/Makefile b/arch/arm/kernel/Makefile
index ff89d0b..30d2c00 100644
--- a/arch/arm/kernel/Makefile
+++ b/arch/arm/kernel/Makefile
@@ -13,7 +13,7 @@ endif
 obj-y		:= compat.o elf.o entry-armv.o entry-common.o irq.o \
 		   process.o ptrace.o setup.o signal.o \
 		   sys_arm.o stacktrace.o time.o traps.o
-
+obj-$(CONFIG_MUDFLAP)		+= mudflap.o
 obj-$(CONFIG_ISA_DMA_API)	+= dma.o
 obj-$(CONFIG_ARCH_ACORN)	+= ecard.o 
 obj-$(CONFIG_FIQ)		+= fiq.o
diff --git a/arch/arm/kernel/module.c b/arch/arm/kernel/module.c
index bac03c8..8cfe5f5 100644
--- a/arch/arm/kernel/module.c
+++ b/arch/arm/kernel/module.c
@@ -128,6 +128,7 @@ apply_relocate(Elf32_Shdr *sechdrs, const char *strtab, unsigned int symindex,
 			break;
 
 		case R_ARM_ABS32:
+		case R_ARM_TARGET1:
 			*(u32 *)loc += sym->st_value;
 			break;
 
diff --git a/arch/arm/kernel/mudflap.c b/arch/arm/kernel/mudflap.c
new file mode 100644
index 0000000..d8f5594
--- /dev/null
+++ b/arch/arm/kernel/mudflap.c
@@ -0,0 +1,24 @@
+/*
+ * kernel/mudflap.c
+ *
+ * Copyright (C) 2009 Motorola Inc.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ */
+#include<mf-runtime.h>
+#include<asm/string.h>
+#include<linux/module.h>
+
+void kmudflap_memzero(void *ptr, __kernel_size_t n)
+{
+	__mf_check(ptr, n, __MF_CHECK_WRITE, "memzero dest");
+	return __memzero(ptr, n);
+}
+EXPORT_SYMBOL(kmudflap_memzero);
diff --git a/drivers/Makefile b/drivers/Makefile
index bc4205d..d5e5063 100644
--- a/drivers/Makefile
+++ b/drivers/Makefile
@@ -4,7 +4,9 @@
 # 15 Sep 2000, Christoph Hellwig <hch@infradead.org>
 # Rewritten to use lists instead of if-statements.
 #
-
+ifdef CONFIG_MUDFLAP
+subdir-ccflags-y += -fmudflap -fmudflapir
+endif
 obj-y				+= gpio/
 obj-$(CONFIG_PCI)		+= pci/
 obj-$(CONFIG_PARISC)		+= parisc/
diff --git a/include/linux/slab_def.h b/include/linux/slab_def.h
index 850d057..34be697 100644
--- a/include/linux/slab_def.h
+++ b/include/linux/slab_def.h
@@ -220,4 +220,8 @@ found:
 
 #endif	/* CONFIG_NUMA */
 
+#ifdef CONFIG_MUDFLAP
+void slab_check_write(void *ptr, unsigned int sz, const char *location);
+#endif
+
 #endif	/* _LINUX_SLAB_DEF_H */
diff --git a/include/linux/slub_def.h b/include/linux/slub_def.h
index 4dcbc2c..e31443a 100644
--- a/include/linux/slub_def.h
+++ b/include/linux/slub_def.h
@@ -304,4 +304,8 @@ static __always_inline void *kmalloc_node(size_t size, gfp_t flags, int node)
 
 void __init kmem_cache_init_late(void);
 
+#ifdef CONFIG_MUDFLAP
+void slab_check_write(void *ptr, unsigned int sz, const char *location);
+#endif
+
 #endif /* _LINUX_SLUB_DEF_H */
diff --git a/include/mf-runtime.h b/include/mf-runtime.h
new file mode 100644
index 0000000..b69708a
--- /dev/null
+++ b/include/mf-runtime.h
@@ -0,0 +1,45 @@
+#ifndef _LINUX_MF_RUNTIME
+#define _LINUX_MF_RUNTIME
+/*
+ * Copyright (C) 2009 Motorola Inc.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
+ *
+ */
+
+#include<linux/kernel.h>
+#include<asm/mf-runtime.h>
+
+/* Codes to describe the type of access to check */
+#define __MF_CHECK_READ 0
+#define __MF_CHECK_WRITE 1
+
+typedef void *__mf_ptr_t;
+typedef unsigned int __mf_uintptr_t;
+struct __mf_cache { __mf_uintptr_t low; __mf_uintptr_t high; };
+
+void __mf_check(void *ptr, unsigned int sz, int type, const char *location);
+void __mf_register(void *ptr, size_t sz, int type, const char *name);
+void __mf_init(void);
+void __mf_unregister(void *ptr, size_t sz, int type);
+
+#ifdef _MUDFLAP
+#pragma redefine_extname memcpy kmudflap_memcpy
+#pragma redefine_extname memset kmudflap_memset
+#pragma redefine_extname strcpy kmudflap_strcpy
+#pragma redefine_extname strncpy kmudflap_strncpy
+#endif /* _MUDFLAP */
+
+#endif
diff --git a/kernel/Makefile b/kernel/Makefile
index 2093a69..c4c2402 100644
--- a/kernel/Makefile
+++ b/kernel/Makefile
@@ -22,7 +22,7 @@ CFLAGS_REMOVE_rtmutex-debug.o = -pg
 CFLAGS_REMOVE_cgroup-debug.o = -pg
 CFLAGS_REMOVE_sched_clock.o = -pg
 endif
-
+obj-$(CONFIG_MUDFLAP) += mudflap.o
 obj-$(CONFIG_FREEZER) += freezer.o
 obj-$(CONFIG_PROFILING) += profile.o
 obj-$(CONFIG_SYSCTL_SYSCALL_CHECK) += sysctl_check.o
diff --git a/kernel/mudflap.c b/kernel/mudflap.c
new file mode 100644
index 0000000..29e82cb
--- /dev/null
+++ b/kernel/mudflap.c
@@ -0,0 +1,105 @@
+/*
+ * kernel/mudflap.c
+ *
+ * Copyright (C) 2009 Motorola Inc.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ */
+
+#include<linux/kernel.h>
+#include<linux/slab.h>
+#include<linux/module.h>
+#include<linux/mm.h>
+#include<mf-runtime.h>
+
+#define LOOKUP_CACHE_MASK_DFL 1023
+#define LOOKUP_CACHE_SIZE_MAX 65536 /* Allows max CACHE_MASK 0xFFFF */
+#define LOOKUP_CACHE_SHIFT_DFL 2
+
+struct __mf_cache __mf_lookup_cache[LOOKUP_CACHE_SIZE_MAX];
+EXPORT_SYMBOL(__mf_lookup_cache);
+
+uintptr_t __mf_lc_mask = LOOKUP_CACHE_MASK_DFL;
+EXPORT_SYMBOL(__mf_lc_mask);
+
+unsigned char __mf_lc_shift = LOOKUP_CACHE_SHIFT_DFL;
+EXPORT_SYMBOL(__mf_lc_shift);
+
+static inline int verify_ptr(unsigned long ptr)
+{
+	if (ptr < PAGE_OFFSET ||
+		(ptr > (unsigned long)high_memory && high_memory != 0))
+		return -EFAULT;
+
+	return 0;
+}
+
+void __mf_check(void *ptr, unsigned int sz, int type, const char *location)
+{
+	if (verify_ptr((unsigned long)ptr))
+		return;
+	if (type) /* write */
+		slab_check_write(ptr, sz, location);
+}
+EXPORT_SYMBOL(__mf_check);
+
+void *kmudflap_memset(void *s, int c, size_t count)
+{
+	__mf_check(s, count, __MF_CHECK_WRITE, "memset dest");
+	return memset(s, c, count);
+}
+EXPORT_SYMBOL(kmudflap_memset);
+
+void *kmudflap_memcpy(void *dest, const void *src, size_t count)
+{
+	__mf_check(dest, count, __MF_CHECK_WRITE, "memcpy dest");
+	return memcpy(dest, src, count);
+}
+EXPORT_SYMBOL(kmudflap_memcpy);
+
+char *kmudflap_strcpy(char *dest, const char *src)
+{
+	size_t n = strlen(src);
+	 __mf_check(dest, n, __MF_CHECK_WRITE, "strcpy dest");
+	return strcpy(dest, src);
+}
+EXPORT_SYMBOL(kmudflap_strcpy);
+
+void *kmudflap_strncpy(char *dest, const char *src, size_t count)
+{
+	size_t len = strnlen(src, count);
+	 __mf_check(dest, len, __MF_CHECK_WRITE, "strncpy dest");
+	return strncpy(dest, src, count);
+}
+EXPORT_SYMBOL(kmudflap_strncpy);
+
+void
+__mf_register(void *ptr, size_t sz, int type, const char *name)
+{
+}
+EXPORT_SYMBOL(__mf_register);
+
+void
+__mf_unregister(void *ptr, size_t sz, int type)
+{
+}
+EXPORT_SYMBOL(__mf_unregister);
+
+void __mf_init(void)
+{
+}
+EXPORT_SYMBOL(__mf_init);
+
+int
+__mf_set_options(const char *optstr)
+{
+	return 0;
+}
+EXPORT_SYMBOL(__mf_set_options);
diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index 12327b2..5e1f7ff 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -35,6 +35,13 @@ config FRAME_WARN
 	  Setting this too low will cause a lot of warnings.
 	  Setting it to 0 disables the warning.
 	  Requires gcc 4.4
+config MUDFLAP
+	bool "Enable mudflap to check slab write after free"
+	depends on DEBUG_SLAB_LEAK || SLUB_DEBUG_ON
+	help
+	  This uses mudflap which introduced by gcc4 to check slab corruption
+	  which is caused by writing after free.
+	  This is smaller and faster than kmemcheck.
 
 config MAGIC_SYSRQ
 	bool "Magic SysRq key"
diff --git a/mm/slab.c b/mm/slab.c
index 7b5d4de..cb91a9d 100644
--- a/mm/slab.c
+++ b/mm/slab.c
@@ -4503,3 +4503,43 @@ size_t ksize(const void *objp)
 	return obj_size(virt_to_cache(objp));
 }
 EXPORT_SYMBOL(ksize);
+
+#ifdef CONFIG_MUDFLAP
+void slab_check_write(void *ptr, unsigned int sz, const char *location)
+{
+	struct page *page;
+	struct kmem_cache *cache;
+	struct slab *slab;
+	char *realobj;
+	void *obj;
+	unsigned long objnr, size;
+
+	page = virt_to_head_page(ptr);
+	if (!PageSlab(page))
+		return;
+
+	cache = page_get_cache(page);
+	slab = page_get_slab(page);
+	objnr = (unsigned)(ptr - slab->s_mem) / cache->buffer_size;
+	obj = index_to_obj(cache, slab, objnr);
+	realobj = obj + obj_offset(cache);
+	size = obj_size(cache);
+
+	if (slab_bufctl(slab)[objnr] != BUFCTL_FREE)
+		return;
+
+	printk(KERN_ERR "ptr: %p, sz: %d, location: %s\n",
+			ptr, sz, location);
+	printk(KERN_ERR "write to freed object, size %ld\n",
+			size);
+	if (cache->flags & SLAB_STORE_USER) {
+		printk(KERN_ERR "Last user: [<%p>]",
+				*dbg_userword(cache, obj));
+		print_symbol("(%s)",
+				(unsigned long)*dbg_userword(cache, obj));
+		printk("\n");
+	}
+
+	dump_stack();
+}
+#endif
diff --git a/mm/slub.c b/mm/slub.c
index a9201d8..4f13514 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -4729,3 +4729,31 @@ static int __init slab_proc_init(void)
 }
 module_init(slab_proc_init);
 #endif /* CONFIG_SLABINFO */
+
+#ifdef CONFIG_MUDFLAP
+void slab_check_write(void *ptr, unsigned int sz, const char *location)
+{
+	struct page *page;
+	struct kmem_cache *s;
+	void *obj, *start;
+	unsigned long objnr;
+
+	page = virt_to_head_page(ptr);
+	if (!PageSlab(page))
+		return;
+
+	s = page->slab;
+	start = page_address(page);
+	objnr = (unsigned long)(ptr - start) / s->size;
+	obj = start + s->size * objnr;
+	if (!on_freelist(s, page, obj))
+		return;
+
+	printk(KERN_ERR "ptr: %p, sz: %d, location: %s\n",
+			ptr, sz, location);
+	printk(KERN_ERR "write to freed object, size %d\n",
+			s->size);
+	print_tracking(s, obj);
+	dump_stack();
+}
+#endif

