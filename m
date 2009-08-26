Return-Path: <linux-kernel-owner+w=401wt.eu-S1756826AbZHZGhJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756826AbZHZGhJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Aug 2009 02:37:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754066AbZHZGhI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Aug 2009 02:37:08 -0400
Received: from 124-219-29-227.vdslpro.static.apol.com.tw ([124.219.29.227]:43274
	"EHLO mswedge2.sunplus.com" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1750879AbZHZGhG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Aug 2009 02:37:06 -0400
Subject: Subject: [PATCH 20/33] score: create head files fixmap.h param.h
	resource.h setup.h sections.h segment.h string.h system.h
From: Chen Liqin <liqin.chen@sunplusct.com>
To: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Arnd Bergmann <arnd@arndb.de>, torvalds@linux-foundation.org
Content-Type: text/plain
Date: Wed, 26 Aug 2009 14:26:41 +0800
Message-Id: <1251268001.3153.7.camel@ad3ser01>
Mime-Version: 1.0
X-Mailer: Evolution 2.0.2 (2.0.2-27.rhel4.6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 17bfd28056f3b690d854ec92257e71e895930d62 Mon Sep 17 00:00:00 2001
From: Chen Liqin <liqin.chen@sunplusct.com>
Date: Wed, 26 Aug 2009 10:05:06 +0800
Subject: [PATCH 20/33] score: create head files fixmap.h param.h resource.h setup.h sections.h segment.h string.h system.h


Signed-off-by: Chen Liqin <liqin.chen@sunplusct.com>
---
 arch/score/include/asm/fixmap.h   |   82 +++++++++++++++++++++++++++++++++
 arch/score/include/asm/param.h    |    6 +++
 arch/score/include/asm/resource.h |    6 +++
 arch/score/include/asm/sections.h |    6 +++
 arch/score/include/asm/segment.h  |   21 +++++++++
 arch/score/include/asm/setup.h    |   41 +++++++++++++++++
 arch/score/include/asm/string.h   |    8 +++
 arch/score/include/asm/system.h   |   90 +++++++++++++++++++++++++++++++++++++
 8 files changed, 260 insertions(+), 0 deletions(-)
 create mode 100644 arch/score/include/asm/fixmap.h
 create mode 100644 arch/score/include/asm/param.h
 create mode 100644 arch/score/include/asm/resource.h
 create mode 100644 arch/score/include/asm/sections.h
 create mode 100644 arch/score/include/asm/segment.h
 create mode 100644 arch/score/include/asm/setup.h
 create mode 100644 arch/score/include/asm/string.h
 create mode 100644 arch/score/include/asm/system.h

diff --git a/arch/score/include/asm/fixmap.h b/arch/score/include/asm/fixmap.h
new file mode 100644
index 0000000..ee16766
--- /dev/null
+++ b/arch/score/include/asm/fixmap.h
@@ -0,0 +1,82 @@
+#ifndef _ASM_SCORE_FIXMAP_H
+#define _ASM_SCORE_FIXMAP_H
+
+#include <asm/page.h>
+
+#define PHY_RAM_BASE		0x00000000
+#define PHY_IO_BASE		0x10000000
+
+#define VIRTUAL_RAM_BASE	0xa0000000
+#define VIRTUAL_IO_BASE		0xb0000000
+
+#define RAM_SPACE_SIZE		0x10000000
+#define IO_SPACE_SIZE		0x10000000
+
+/* Kernel unmapped, cached 512MB */
+#define KSEG1			0xa0000000
+
+/*
+ * Here we define all the compile-time 'special' virtual
+ * addresses. The point is to have a constant address at
+ * compile time, but to set the physical address only
+ * in the boot process. We allocate these special addresses
+ * from the end of virtual memory (0xfffff000) backwards.
+ * Also this lets us do fail-safe vmalloc(), we
+ * can guarantee that these special addresses and
+ * vmalloc()-ed addresses never overlap.
+ *
+ * these 'compile-time allocated' memory buffers are
+ * fixed-size 4k pages. (or larger if used with an increment
+ * highger than 1) use fixmap_set(idx,phys) to associate
+ * physical memory with fixmap indices.
+ *
+ * TLB entries of such buffers will not be flushed across
+ * task switches.
+ */
+
+/*
+ * on UP currently we will have no trace of the fixmap mechanizm,
+ * no page table allocations, etc. This might change in the
+ * future, say framebuffers for the console driver(s) could be
+ * fix-mapped?
+ */
+enum fixed_addresses {
+#define FIX_N_COLOURS 8
+	FIX_CMAP_BEGIN,
+	FIX_CMAP_END = FIX_CMAP_BEGIN + FIX_N_COLOURS,
+	__end_of_fixed_addresses
+};
+
+/*
+ * used by vmalloc.c.
+ *
+ * Leave one empty page between vmalloc'ed areas and
+ * the start of the fixmap, and leave one page empty
+ * at the top of mem..
+ */
+#define FIXADDR_TOP	((unsigned long)(long)(int)0xfefe0000)
+#define FIXADDR_SIZE	(__end_of_fixed_addresses << PAGE_SHIFT)
+#define FIXADDR_START	(FIXADDR_TOP - FIXADDR_SIZE)
+
+#define __fix_to_virt(x)	(FIXADDR_TOP - ((x) << PAGE_SHIFT))
+#define __virt_to_fix(x)	\
+	((FIXADDR_TOP - ((x) & PAGE_MASK)) >> PAGE_SHIFT)
+
+extern void __this_fixmap_does_not_exist(void);
+
+/*
+ * 'index to address' translation. If anyone tries to use the idx
+ * directly without tranlation, we catch the bug with a NULL-deference
+ * kernel oops. Illegal ranges of incoming indices are caught too.
+ */
+static inline unsigned long fix_to_virt(const unsigned int idx)
+{
+	return __fix_to_virt(idx);
+}
+
+static inline unsigned long virt_to_fix(const unsigned long vaddr)
+{
+	return __virt_to_fix(vaddr);
+}
+
+#endif /* _ASM_SCORE_FIXMAP_H */
diff --git a/arch/score/include/asm/param.h b/arch/score/include/asm/param.h
new file mode 100644
index 0000000..916b869
--- /dev/null
+++ b/arch/score/include/asm/param.h
@@ -0,0 +1,6 @@
+#ifndef _ASM_SCORE_PARAM_H
+#define _ASM_SCORE_PARAM_H
+
+#include <asm-generic/param.h>
+
+#endif /* _ASM_SCORE_PARAM_H */
diff --git a/arch/score/include/asm/resource.h b/arch/score/include/asm/resource.h
new file mode 100644
index 0000000..9ce22bc
--- /dev/null
+++ b/arch/score/include/asm/resource.h
@@ -0,0 +1,6 @@
+#ifndef _ASM_SCORE_RESOURCE_H
+#define _ASM_SCORE_RESOURCE_H
+
+#include <asm-generic/resource.h>
+
+#endif /* _ASM_SCORE_RESOURCE_H */
diff --git a/arch/score/include/asm/sections.h b/arch/score/include/asm/sections.h
new file mode 100644
index 0000000..9441d23
--- /dev/null
+++ b/arch/score/include/asm/sections.h
@@ -0,0 +1,6 @@
+#ifndef _ASM_SCORE_SECTIONS_H
+#define _ASM_SCORE_SECTIONS_H
+
+#include <asm-generic/sections.h>
+
+#endif /* _ASM_SCORE_SECTIONS_H */
diff --git a/arch/score/include/asm/segment.h b/arch/score/include/asm/segment.h
new file mode 100644
index 0000000..e16cf6a
--- /dev/null
+++ b/arch/score/include/asm/segment.h
@@ -0,0 +1,21 @@
+#ifndef _ASM_SCORE_SEGMENT_H
+#define _ASM_SCORE_SEGMENT_H
+
+#ifndef __ASSEMBLY__
+
+typedef struct {
+	unsigned long seg;
+} mm_segment_t;
+
+#define KERNEL_DS	((mm_segment_t){0})
+#define USER_DS	KERNEL_DS
+
+# define get_ds()	(KERNEL_DS)
+# define get_fs()	(current_thread_info()->addr_limit)
+# define set_fs(x)	\
+	do { current_thread_info()->addr_limit = (x); } while (0)
+
+# define segment_eq(a, b)	((a).seg == (b).seg)
+
+# endif /* __ASSEMBLY__ */
+#endif /* _ASM_SCORE_SEGMENT_H */
diff --git a/arch/score/include/asm/setup.h b/arch/score/include/asm/setup.h
new file mode 100644
index 0000000..3cb944d
--- /dev/null
+++ b/arch/score/include/asm/setup.h
@@ -0,0 +1,41 @@
+#ifndef _ASM_SCORE_SETUP_H
+#define _ASM_SCORE_SETUP_H
+
+#define COMMAND_LINE_SIZE	256
+#define MEMORY_START		0
+#define MEMORY_SIZE		0x2000000
+
+#ifdef __KERNEL__
+
+extern void pagetable_init(void);
+extern void pgd_init(unsigned long page);
+
+extern void setup_early_printk(void);
+extern void cpu_cache_init(void);
+extern void tlb_init(void);
+
+extern void handle_nmi(void);
+extern void handle_adelinsn(void);
+extern void handle_adedata(void);
+extern void handle_ibe(void);
+extern void handle_pel(void);
+extern void handle_sys(void);
+extern void handle_ccu(void);
+extern void handle_ri(void);
+extern void handle_tr(void);
+extern void handle_ades(void);
+extern void handle_cee(void);
+extern void handle_cpe(void);
+extern void handle_dve(void);
+extern void handle_dbe(void);
+extern void handle_reserved(void);
+extern void handle_tlb_refill(void);
+extern void handle_tlb_invaild(void);
+extern void handle_mod(void);
+extern void debug_exception_vector(void);
+extern void general_exception_vector(void);
+extern void interrupt_exception_vector(void);
+
+#endif /* __KERNEL__ */
+
+#endif /* _ASM_SCORE_SETUP_H */
diff --git a/arch/score/include/asm/string.h b/arch/score/include/asm/string.h
new file mode 100644
index 0000000..8a6bf50
--- /dev/null
+++ b/arch/score/include/asm/string.h
@@ -0,0 +1,8 @@
+#ifndef _ASM_SCORE_STRING_H
+#define _ASM_SCORE_STRING_H
+
+extern void *memset(void *__s, int __c, size_t __count);
+extern void *memcpy(void *__to, __const__ void *__from, size_t __n);
+extern void *memmove(void *__dest, __const__ void *__src, size_t __n);
+
+#endif /* _ASM_SCORE_STRING_H */
diff --git a/arch/score/include/asm/system.h b/arch/score/include/asm/system.h
new file mode 100644
index 0000000..589d5c7
--- /dev/null
+++ b/arch/score/include/asm/system.h
@@ -0,0 +1,90 @@
+#ifndef _ASM_SCORE_SYSTEM_H
+#define _ASM_SCORE_SYSTEM_H
+
+#include <linux/types.h>
+#include <linux/irqflags.h>
+
+struct pt_regs;
+struct task_struct;
+
+extern void *resume(void *last, void *next, void *next_ti);
+
+#define switch_to(prev, next, last)				\
+do {								\
+	(last) = resume(prev, next, task_thread_info(next));	\
+} while (0)
+
+#define finish_arch_switch(prev)	do {} while (0)
+
+typedef void (*vi_handler_t)(void);
+extern unsigned long arch_align_stack(unsigned long sp);
+
+#define mb()		barrier()
+#define rmb()		barrier()
+#define wmb()		barrier()
+#define smp_mb()	barrier()
+#define smp_rmb()	barrier()
+#define smp_wmb()	barrier()
+
+#define read_barrier_depends()		do {} while (0)
+#define smp_read_barrier_depends()	do {} while (0)
+
+#define set_mb(var, value) 		do {var = value; wmb(); } while (0)
+
+#define __HAVE_ARCH_CMPXCHG	1
+
+#include <asm-generic/cmpxchg-local.h>
+
+#ifndef __ASSEMBLY__
+
+struct __xchg_dummy { unsigned long a[100]; };
+#define __xg(x) ((struct __xchg_dummy *)(x))
+
+static inline
+unsigned long __xchg(volatile unsigned long *m, unsigned long val)
+{
+	unsigned long retval;
+	unsigned long flags;
+
+	local_irq_save(flags);
+	retval = *m;
+	*m = val;
+	local_irq_restore(flags);
+	return retval;
+}
+
+#define xchg(ptr, v)						\
+	((__typeof__(*(ptr))) __xchg((unsigned long *)(ptr),	\
+					(unsigned long)(v)))
+
+static inline unsigned long __cmpxchg(volatile unsigned long *m,
+				unsigned long old, unsigned long new)
+{
+	unsigned long retval;
+	unsigned long flags;
+
+	local_irq_save(flags);
+	retval = *m;
+	if (retval == old)
+		*m = new;
+	local_irq_restore(flags);
+	return retval;
+}
+
+#define cmpxchg(ptr, o, n)					\
+	((__typeof__(*(ptr))) __cmpxchg((unsigned long *)(ptr),	\
+					(unsigned long)(o),	\
+					(unsigned long)(n)))
+
+extern void __die(const char *, struct pt_regs *, const char *,
+	const char *, unsigned long) __attribute__((noreturn));
+extern void __die_if_kernel(const char *, struct pt_regs *, const char *,
+	const char *, unsigned long);
+
+#define die(msg, regs)							\
+	__die(msg, regs, __FILE__ ":", __func__, __LINE__)
+#define die_if_kernel(msg, regs)					\
+	__die_if_kernel(msg, regs, __FILE__ ":", __func__, __LINE__)
+
+#endif /* !__ASSEMBLY__ */
+#endif /* _ASM_SCORE_SYSTEM_H */
-- 
1.6.2



