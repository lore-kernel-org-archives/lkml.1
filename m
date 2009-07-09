Return-Path: <linux-kernel-owner+w=401wt.eu-S1761475AbZGIQOS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761475AbZGIQOS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jul 2009 12:14:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760476AbZGIQOI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Jul 2009 12:14:08 -0400
Received: from mail128.messagelabs.com ([216.82.250.131]:34561 "EHLO
	mail128.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759397AbZGIQOG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jul 2009 12:14:06 -0400
X-VirusChecked: Checked
X-Env-Sender: yuan-bo.ye@motorola.com
X-Msg-Ref: server-14.tower-128.messagelabs.com!1247156044!24072599!1
X-StarScan-Version: 6.0.0; banners=-,-,-
X-Originating-IP: [136.182.1.13]
Subject: [RFC][PATCH] Check write to slab memory which freed already using
 mudflap
From: Janboe Ye <yuan-bo.ye@motorola.com>
To: linux-kernel@vger.kernel.org
Cc: vegard.nossum@gmail.com, penberg@cs.helsinki.fi, graydon@redhat.com,
       fche@redhat.com, mingo@elte.hu
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Thu, 09 Jul 2009 11:13:40 -0500
Message-Id: <1247156020.27671.40.camel@debian-nb>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.2 
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

slab debug detects the corruption when it allocates and frees the slab. But if someone write to slab memory when it already freed, slab debug could only report its last free point when slab allocates the same block.

This information is not enough for debugging when system has complex memory usage. gcc mudflap could insert some check point when a memory is writing and it is helpful to check if the address is writing freed.

Because most codes of kernel are drivers, it is most possible that drivers have such problem. So I use mudflap to compile all drivers.

kmemcheck is also helpful to check same issue, and it triggers trap every reading and writing, and it need to analysis the instruct which trigger the trap to get the memory address.
This heavy depends on the cpu capability. arm has no single-step like x86, so kmemcheck is too heavy to run on real arm system. mudflap way is lighter than kmemcheck for this purpose.

As stack allocation is useless for checking slab, kernel mudflap does not implement alloc which is required by gcc mudflap when codes use variable array. So variable array, such as array[i] which i could not determined by compiler, is not supported.

Thanks a lot for comments!

Signed-off-by: janboe <yuan-bo.ye@motorola.com>

 arch/arm/include/asm/elf.h |    1 +
 arch/arm/kernel/module.c   |    1 +
 drivers/Makefile           |    4 +-
 include/mf-runtime.h       |   42 ++++++++++++++
 kernel/Makefile            |    2 +-
 kernel/mudflap.c           |  132 ++++++++++++++++++++++++++++++++++++++++++++
 lib/Kconfig.debug          |    7 ++
 mm/slab.c                  |   53 ++++++++++++++++++
 8 files changed, 240 insertions(+), 2 deletions(-)

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
diff --git a/include/mf-runtime.h b/include/mf-runtime.h
new file mode 100644
index 0000000..4639d9d
--- /dev/null
+++ b/include/mf-runtime.h
@@ -0,0 +1,42 @@
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
+
+#define LOOKUP_CACHE_MASK_DFL 1023
+#define LOOKUP_CACHE_SIZE_MAX 65536 /* Allows max CACHE_MASK 0xFFFF */
+#define LOOKUP_CACHE_SHIFT_DFL 2
+typedef void *__mf_ptr_t;
+typedef unsigned int __mf_uintptr_t;
+struct __mf_cache { __mf_uintptr_t low; __mf_uintptr_t high; };
+void __mf_check(void *ptr, unsigned int sz, int type, const char *location);
+void __mf_register(void *ptr, size_t sz, int type, const char *name);
+void __mf_init(void);
+void __mf_unregister(void *ptr, size_t sz, int type);
+#ifdef _MUDFLAP
+#pragma redefine_extname memcpy __mfwrap_memcpy
+#pragma redefine_extname memset __mfwrap_memset
+#pragma redefine_extname strcpy __mfwrap_strcpy
+#pragma redefine_extname strncpy __mfwrap_strncpy
+#pragma redefine_extname __memzero __mfwrap_memzero
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
index 0000000..d0331c1
--- /dev/null
+++ b/kernel/mudflap.c
@@ -0,0 +1,132 @@
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
+#undef DEBUG  /* define this for verbose EDID parsing output */
+
+#ifdef DEBUG
+#define DPRINTK(fmt, args...) printk(fmt, ## args)
+#else
+#define DPRINTK(fmt, args...)
+#endif
+
+/* Codes to describe the type of access to check */
+#define __MF_CHECK_READ 0
+#define __MF_CHECK_WRITE 1
+
+typedef void *__mf_ptr_t;
+typedef unsigned int __mf_uintptr_t;
+struct __mf_cache { __mf_uintptr_t low; __mf_uintptr_t high; };
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
+void check_slab_write(void *ptr, unsigned int sz,
+		int type, const char *location);
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
+		check_slab_write(ptr, sz, type, location);
+}
+EXPORT_SYMBOL(__mf_check);
+
+void *__mfwrap_memset(void *s, int c, size_t count)
+{
+	__mf_check(s, count, __MF_CHECK_WRITE, "memset dest");
+	return memset(s, c, count);
+}
+EXPORT_SYMBOL(__mfwrap_memset);
+
+void *__mfwrap_memcpy(void *dest, const void *src, size_t count)
+{
+	__mf_check(dest, count, __MF_CHECK_WRITE, "memcpy dest");
+	return memcpy(dest, src, count);
+}
+EXPORT_SYMBOL(__mfwrap_memcpy);
+
+char *__mfwrap_strcpy(char *dest, const char *src)
+{
+	size_t n = strlen(src);
+	 __mf_check(dest, n, __MF_CHECK_WRITE, "strcpy dest");
+	return strcpy(dest, src);
+}
+EXPORT_SYMBOL(__mfwrap_strcpy);
+
+void *__mfwrap_strncpy(char *dest, const char *src, size_t count)
+{
+	size_t len = strnlen(src, count);
+	 __mf_check(dest, len, __MF_CHECK_WRITE, "strncpy dest");
+	return strncpy(dest, src, count);
+}
+EXPORT_SYMBOL(__mfwrap_strncpy);
+
+#ifdef CONFIG_ARM
+void __mfwrap_memzero(void *ptr, __kernel_size_t n)
+{
+	__mf_check(ptr, n, __MF_CHECK_WRITE, "memzero dest");
+	return __memzero(ptr, n);
+}
+EXPORT_SYMBOL(__mfwrap_memzero);
+#endif
+
+void
+__mf_register(void *ptr, size_t sz, int type, const char *name)
+{
+	DPRINTK("ptr: %p, sz: %d, type: %d, %s\n", ptr, sz, type, name);
+}
+EXPORT_SYMBOL(__mf_register);
+
+void
+__mf_unregister(void *ptr, size_t sz, int type)
+{
+	DPRINTK("ptr: %p, sz: %d, type: %d\n", ptr, sz, type);
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
index 12327b2..6f782e7 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -35,6 +35,13 @@ config FRAME_WARN
 	  Setting this too low will cause a lot of warnings.
 	  Setting it to 0 disables the warning.
 	  Requires gcc 4.4
+config MUDFLAP
+	bool "Enable mudflap to check slab write after free"
+	depends on SLAB && DEBUG_SLAB
+	help
+	  This uses mudflap which introduced by gcc4 to check slab corruption
+	  which is caused by writing after free.
+	  This is smaller and faster than kmemcheck.
 
 config MAGIC_SYSRQ
 	bool "Magic SysRq key"
diff --git a/mm/slab.c b/mm/slab.c
index 7b5d4de..bb0d57c 100644
--- a/mm/slab.c
+++ b/mm/slab.c
@@ -4503,3 +4503,56 @@ size_t ksize(const void *objp)
 	return obj_size(virt_to_cache(objp));
 }
 EXPORT_SYMBOL(ksize);
+
+#ifdef CONFIG_MUDFLAP
+void check_slab_write(void *ptr, unsigned int sz, int type,
+		const char *location)
+{
+	struct page *page;
+	struct kmem_cache *cachep;
+	struct slab *slabp;
+	char *realobj;
+	void *objp;
+	int objnr, size, i = 0, count, free_count = 0;
+	page = virt_to_page(ptr);
+	page = compound_head(page);
+	if (PageSlab(page)) {
+		cachep = page_get_cache(page);
+		slabp = page_get_slab(page);
+		objnr = (unsigned)(ptr - slabp->s_mem) / cachep->buffer_size;
+		objp = index_to_obj(cachep, slabp, objnr);
+		size = obj_size(cachep);
+		count = size - 1;
+		realobj = (char *)objp + obj_offset(cachep);
+		while (count--) {
+			i++;
+			if (realobj[i] == POISON_FREE)
+				free_count++;
+			else
+				break;
+		}
+
+		if (i == free_count) {
+			printk(KERN_ERR "ptr: %p, sz: %d, location: %s\n",
+					ptr, sz, location);
+			printk(KERN_ERR "write to freed object, size %d\n",
+					size);
+			i = 0;
+			while (size--) {
+				printk(KERN_ERR "%x", realobj[i]);
+				i++;
+			}
+			printk(KERN_ERR "%x\n", realobj[i]);
+			if (cachep->flags & SLAB_STORE_USER) {
+				printk(KERN_ERR "Last user: [<%p>]",
+						*dbg_userword(cachep, objp));
+				print_symbol("(%s)",
+				    (unsigned long)*dbg_userword(cachep, objp));
+				printk("\n");
+			}
+
+			dump_stack();
+		}
+	}
+}
+#endif
