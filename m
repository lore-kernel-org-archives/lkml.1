Return-Path: <linux-kernel-owner+w=401wt.eu-S1757910AbYEEIMN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757910AbYEEIMN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2008 04:12:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753874AbYEEIL4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 May 2008 04:11:56 -0400
Received: from 178-47-31-89.wifiinternet.cz ([89.31.47.178]:33566 "EHLO
	monstr.eu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753940AbYEEILx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2008 04:11:53 -0400
From: monstr@seznam.cz
To: linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, linux-arch@vger.kernel.org, stephen.neuendorffer@xilinx.com,
       John.Linn@xilinx.com, john.williams@petalogix.com, matthew@wil.cx,
       will.newton@gmail.com, drepper@redhat.com,
       microblaze-uclinux@itee.uq.edu.au, grant.likely@secretlab.ca,
       Michal Simek <monstr@monstr.eu>
Subject: [PATCH 09/56] microblaze_v2: cache support
Date: Sun,  4 May 2008 13:40:58 +0200
Message-Id: <2f801c33caee22e112af51ae927c264ce99ead01.1209897266.git.monstr@monstr.eu>
X-Mailer: git-send-email 1.5.4.GIT
In-Reply-To: <932956128c9c655a218a940eaf02017a5dd0bdf9.1209897266.git.monstr@monstr.eu>
References: <1209901305-6404-1-git-send-email-monstr@seznam.cz>
 <a4a778e34c66d126f5c4bf1ca423cf32950ea5ab.1209897266.git.monstr@monstr.eu>
 <c805caeb1dd7f6d1349c4a463cb88a5342a170d2.1209897266.git.monstr@monstr.eu>
 <f120ababf2bade9aab7199bffb3014aa606e5a1c.1209897266.git.monstr@monstr.eu>
 <684c36e5ad3f598e5079e88ec195545c4a7150c2.1209897266.git.monstr@monstr.eu>
 <ed3695121faf485d491cecdd96d5d4dcc498411d.1209897266.git.monstr@monstr.eu>
 <0674b1f7abb9a3d564b68c95bc28adc2c2fe9551.1209897266.git.monstr@monstr.eu>
 <9a7c6646e5dd9724c1cf34767adec181481fa3ef.1209897266.git.monstr@monstr.eu>
 <932956128c9c655a218a940eaf02017a5dd0bdf9.1209897266.git.monstr@monstr.eu>
In-Reply-To: <a4a778e34c66d126f5c4bf1ca423cf32950ea5ab.1209897266.git.monstr@monstr.eu>
References: <a4a778e34c66d126f5c4bf1ca423cf32950ea5ab.1209897266.git.monstr@monstr.eu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michal Simek <monstr@monstr.eu>


Signed-off-by: Michal Simek <monstr@monstr.eu>
---
 arch/microblaze/kernel/cpu/cache.c  |  256 +++++++++++++++++++++++++++++++++++
 include/asm-microblaze/cache.h      |   47 +++++++
 include/asm-microblaze/cacheflush.h |   72 ++++++++++
 3 files changed, 375 insertions(+), 0 deletions(-)
 create mode 100644 arch/microblaze/kernel/cpu/cache.c
 create mode 100644 include/asm-microblaze/cache.h
 create mode 100644 include/asm-microblaze/cacheflush.h

diff --git a/arch/microblaze/kernel/cpu/cache.c b/arch/microblaze/kernel/cpu/cache.c
new file mode 100644
index 0000000..d6a1eab
--- /dev/null
+++ b/arch/microblaze/kernel/cpu/cache.c
@@ -0,0 +1,256 @@
+/*
+ * arch/microblaze/kernel/cpu/cache.c
+ * Cache control for MicroBlaze cache memories
+ *
+ * Copyright (C) 2007 Michal Simek <monstr@monstr.eu>
+ * Copyright (C) 2007 PetaLogix
+ * Copyright (C) 2007 John Williams <john.williams@petalogix.com>
+ *
+ * This file is subject to the terms and conditions of the GNU General
+ * Public License. See the file COPYING in the main directory of this
+ * archive for more details.
+ *
+ */
+
+#include <asm/cacheflush.h>
+#include <asm/cache.h>
+#include <asm/cpuinfo.h>
+
+/* Exported functions */
+
+void _enable_icache(void)
+{
+	if (cpuinfo.use_icache) {
+#if CONFIG_XILINX_MICROBLAZE0_USE_MSR_INSTR
+		__asm__ __volatile__ ("					\
+				msrset	r0, %0;				\
+				nop; "					\
+				:					\
+				: "i" (MSR_ICE)				\
+				: "memory");
+#else
+		__asm__ __volatile__ ("					\
+				mfs	r12, rmsr;			\
+				ori	r12, r12, %0;			\
+				mts	rmsr, r12;			\
+				nop; "					\
+				:					\
+				: "i" (MSR_ICE)				\
+				: "memory", "r12");
+#endif
+	}
+}
+
+void _disable_icache(void)
+{
+	if (cpuinfo.use_icache) {
+#if CONFIG_XILINX_MICROBLAZE0_USE_MSR_INSTR
+		__asm__ __volatile__ ("					\
+				msrclr r0, %0;				\
+				nop; "					\
+				:					\
+				: "i" (MSR_ICE)				\
+				: "memory");
+#else
+		__asm__ __volatile__ ("					\
+				mfs	r12, rmsr;			\
+				andi	r12, r12, ~%0;			\
+				mts	rmsr, r12;			\
+				nop; "					\
+				:					\
+				: "i" (MSR_ICE)				\
+				: "memory", "r12");
+#endif
+	}
+}
+
+void _invalidate_icache(unsigned int addr)
+{
+	if (cpuinfo.use_icache) {
+		__asm__ __volatile__ ("					\
+				wic	%0, r0"				\
+				:					\
+				: "r" (addr));
+	}
+}
+
+void _enable_dcache(void)
+{
+	if (cpuinfo.use_dcache) {
+#if CONFIG_XILINX_MICROBLAZE0_USE_MSR_INSTR
+		__asm__ __volatile__ ("					\
+				msrset	r0, %0;				\
+				nop; "					\
+				:					\
+				: "i" (MSR_DCE)				\
+				: "memory");
+#else
+		__asm__ __volatile__ ("					\
+				mfs	r12, rmsr;			\
+				ori	r12, r12, %0;			\
+				mts	rmsr, r12;			\
+				nop; "					\
+				:					\
+				: "i" (MSR_DCE)			\
+				: "memory", "r12");
+#endif
+	}
+}
+
+void _disable_dcache(void)
+{
+	if (cpuinfo.use_dcache) {
+#if CONFIG_XILINX_MICROBLAZE0_USE_MSR_INSTR
+		__asm__ __volatile__ ("					\
+				msrclr	r0, %0;				\
+				nop; "					\
+				:					\
+				: "i" (MSR_DCE)			\
+				: "memory");
+#else
+		__asm__ __volatile__ ("					\
+				mfs	r12, rmsr;			\
+				andi	r12, r12, ~%0;			\
+				mts	rmsr, r12;			\
+				nop; "					\
+				:					\
+				: "i" (MSR_DCE)			\
+				: "memory", "r12");
+#endif
+	}
+}
+
+void _invalidate_dcache(unsigned int addr)
+{
+	if (cpuinfo.use_dcache)
+		__asm__ __volatile__ ("					\
+				wdc	%0, r0"				\
+				:					\
+				: "r" (addr));
+}
+
+void __flush_icache_all(void)
+{
+	unsigned int i;
+	unsigned flags;
+
+	if (cpuinfo.use_icache) {
+		local_irq_save(flags);
+		__disable_icache();
+
+		/* Just loop through cache size and invalidate, no need to add
+			CACHE_BASE address */
+		for (i = 0; i < cpuinfo.icache_size;
+			i += cpuinfo.icache_line)
+				__invalidate_icache(i);
+
+		__enable_icache();
+		local_irq_restore(flags);
+	}
+}
+
+void __flush_icache_range(unsigned long start, unsigned long end)
+{
+	unsigned int i;
+	unsigned flags;
+	unsigned int align;
+
+	if (cpuinfo.use_icache) {
+		/*
+		 * No need to cover entire cache range,
+		 * just cover cache footprint
+		 */
+		end = min(start + cpuinfo.icache_size, end);
+		align = ~(cpuinfo.icache_line - 1);
+		start &= align; /* Make sure we are aligned */
+		/* Push end up to the next cache line */
+		end = ((end & align) + cpuinfo.icache_line);
+
+		local_irq_save(flags);
+		__disable_icache();
+
+		for (i = start; i < end; i += cpuinfo.icache_line)
+			__invalidate_icache(i);
+
+		__enable_icache();
+		local_irq_restore(flags);
+	}
+}
+
+void __flush_icache_page(struct vm_area_struct *vma, struct page *page)
+{
+	__flush_icache_all();
+}
+
+void __flush_icache_user_range(struct vm_area_struct *vma,
+				struct page *page, unsigned long adr,
+				int len)
+{
+	__flush_icache_all();
+}
+
+void __flush_cache_sigtramp(unsigned long addr)
+{
+	__flush_icache_range(addr, addr + 8);
+}
+
+void __flush_dcache_all(void)
+{
+	unsigned int i;
+	unsigned flags;
+
+	if (cpuinfo.use_dcache) {
+		local_irq_save(flags);
+		__disable_dcache();
+
+		/*
+		 * Just loop through cache size and invalidate,
+		 * no need to add CACHE_BASE address
+		 */
+		for (i = 0; i < cpuinfo.dcache_size;
+			i += cpuinfo.dcache_line)
+				__invalidate_dcache(i);
+
+		__enable_dcache();
+		local_irq_restore(flags);
+	}
+}
+
+void __flush_dcache_range(unsigned long start, unsigned long end)
+{
+	unsigned int i;
+	unsigned flags;
+	unsigned int align;
+
+	if (cpuinfo.use_dcache) {
+		/*
+		 * No need to cover entire cache range,
+		 * just cover cache footprint
+		 */
+		end = min(start + cpuinfo.dcache_size, end);
+		align = ~(cpuinfo.dcache_line - 1);
+		start &= align; /* Make sure we are aligned */
+		/* Push end up to the next cache line */
+		end = ((end & align) + cpuinfo.dcache_line);
+		local_irq_save(flags);
+		__disable_dcache();
+
+		for (i = start; i < end; i += cpuinfo.dcache_line)
+			__invalidate_dcache(i);
+
+		__enable_dcache();
+		local_irq_restore(flags);
+	}
+}
+
+void __flush_dcache_page(struct vm_area_struct *vma, struct page *page)
+{
+	__flush_dcache_all();
+}
+
+void __flush_dcache_user_range(struct vm_area_struct *vma,
+				struct page *page, unsigned long adr,
+				int len)
+{
+	__flush_dcache_all();
+}
diff --git a/include/asm-microblaze/cache.h b/include/asm-microblaze/cache.h
new file mode 100644
index 0000000..6aa1abd
--- /dev/null
+++ b/include/asm-microblaze/cache.h
@@ -0,0 +1,47 @@
+/*
+ * include/asm-microblaze/cache.h
+ *
+ * Cache operations
+ *
+ * Copyright (C) 2007 Michal Simek <monstr@monstr.eu>
+ * Copyright (C) 2003 John Williams <jwilliams@itee.uq.edu.au>
+ *
+ * This file is subject to the terms and conditions of the GNU General
+ * Public License. See the file COPYING in the main directory of this
+ * archive for more details.
+ *
+ */
+
+#ifndef _ASM_MICROBLAZE_CACHE_H
+#define _ASM_MICROBLAZE_CACHE_H
+
+#include <asm/registers.h>
+#include <linux/autoconf.h>
+
+#ifndef L1_CACHE_BYTES
+/* word-granular cache in microblaze */
+#define L1_CACHE_BYTES		4
+#endif
+
+void _enable_icache(void);
+void _disable_icache(void);
+void _invalidate_icache(unsigned int addr);
+
+#define __enable_icache()		_enable_icache()
+#define __disable_icache()		_disable_icache()
+#define __invalidate_icache(addr)	_invalidate_icache(addr)
+
+void _enable_dcache(void);
+void _disable_dcache(void);
+void _invalidate_dcache(unsigned int addr);
+
+#define __enable_dcache()		_enable_dcache()
+#define __disable_dcache()		_disable_dcache()
+#define __invalidate_dcache(addr)	_invalidate_dcache(addr)
+
+/* FIXME - I don't think this is right */
+#ifdef CONFIG_XILINX_UNCACHED_SHADOW
+#define UNCACHED_SHADOW_MASK (CONFIG_XILINX_ERAM_SIZE)
+#endif
+
+#endif /* _ASM_MICROBLAZE_CACHE_H */
diff --git a/include/asm-microblaze/cacheflush.h b/include/asm-microblaze/cacheflush.h
new file mode 100644
index 0000000..ba7339d
--- /dev/null
+++ b/include/asm-microblaze/cacheflush.h
@@ -0,0 +1,72 @@
+/*
+ * include/asm-microblaze/cacheflush.h
+ *
+ * Copyright (C) 2007 PetaLogix
+ * Copyright (C) 2007 John Williams <john.williams@petalogix.com>
+ * based on v850 version which was
+ * Copyright (C) 2001,02,03 NEC Electronics Corporation
+ * Copyright (C) 2001,02,03 Miles Bader <miles@gnu.org>
+ *
+ * This file is subject to the terms and conditions of the GNU General
+ * Public License. See the file COPYING in the main directory of this
+ * archive for more details.
+ *
+ */
+
+#ifndef _ASM_MICROBLAZE_CACHEFLUSH_H
+#define _ASM_MICROBLAZE_CACHEFLUSH_H
+
+/* Somebody depends on this; sigh... */
+#include <linux/mm.h>
+
+#define flush_cache_all()			__flush_cache_all()
+#define flush_cache_mm(mm)			do { } while (0)
+#define flush_cache_range(vma, start, end)	__flush_cache_all()
+#define flush_cache_page(vma, vmaddr, pfn)	do { } while (0)
+
+#define flush_dcache_range(start, end)	__flush_dcache_range(start, end)
+#define flush_dcache_page(page)		do { } while (0)
+#define flush_dcache_mmap_lock(mapping)		do { } while (0)
+#define flush_dcache_mmap_unlock(mapping)	do { } while (0)
+
+#define flush_icache_range(start, len)	__flush_icache_range(start, len)
+#define flush_icache_page(vma, pg)		do { } while (0)
+#define flush_icache_user_range(start, len)	do { } while (0)
+
+#define flush_cache_vmap(start, end)		do { } while (0)
+#define flush_cache_vunmap(start, end)		do { } while (0)
+
+struct page;
+struct mm_struct;
+struct vm_area_struct;
+
+/* see arch/microblaze/kernel/cache.c */
+extern void __flush_icache_all(void);
+extern void __flush_icache_range(unsigned long start, unsigned long end);
+extern void __flush_icache_page(struct vm_area_struct *vma, struct page *page);
+extern void __flush_icache_user_range(struct vm_area_struct *vma,
+				struct page *page,
+				unsigned long adr, int len);
+extern void __flush_cache_sigtramp(unsigned long addr);
+
+extern void __flush_dcache_all(void);
+extern void __flush_dcache_range(unsigned long start, unsigned long end);
+extern void __flush_dcache_page(struct vm_area_struct *vma, struct page *page);
+extern void __flush_dcache_user_range(struct vm_area_struct *vma,
+				struct page *page,
+				unsigned long adr, int len);
+
+extern inline void __flush_cache_all(void)
+{
+	__flush_icache_all();
+	__flush_dcache_all();
+}
+
+#define copy_to_user_page(vma, page, vaddr, dst, src, len) \
+do { memcpy(dst, src, len); \
+	flush_icache_user_range(vma, page, vaddr, len); \
+} while (0)
+#define copy_from_user_page(vma, page, vaddr, dst, src, len) \
+	memcpy(dst, src, len)
+
+#endif /* _ASM_MICROBLAZE_CACHEFLUSH_H */
-- 
1.5.4.GIT

