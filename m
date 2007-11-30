Return-Path: <linux-kernel-owner+w=401wt.eu-S933776AbXK3God@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933776AbXK3God (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2007 01:44:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932355AbXK3GoF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Nov 2007 01:44:05 -0500
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:51772 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755810AbXK3GoC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2007 01:44:02 -0500
Message-Id: <20071130064359.604365398@sgi.com>
References: <20071130064305.459255715@sgi.com>
User-Agent: quilt/0.46-1
Date: Thu, 29 Nov 2007 22:43:06 -0800
From: Christoph Lameter <clameter@sgi.com>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Andi Kleen <ak@suse.de>, Jeremy Fitzhardinge <jeremy@goop.org>
Cc: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Subject: [patch 1/3] Percpu infrastructure to rebase the per cpu area to 0UL
Content-Disposition: inline; filename=zero_based_infrastructure
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Support an option

	CONFIG_PERCPU_ZERO_BASED

that makes offsets for per cpu variables start at zero.

If a percpu area starts at zero then

1. We do not need RELOC_HIDE anymore

2. Indexes off the per cpu area for each processor are small

3. The percpu area "addresses" are offsets and we can then
   have allocpercpu/cpu_alloc in the future also use these
   offsets so that percpu functions can take any type of
   percpu address if it is provided by a percpu variable
   or a pointer obtained via allocpercpu/cpu_alloc.

The linker area boundaries variables are different for zero based
percpu segments:

__per_cpu_load	-> The address at which the percpu area was loaded
__per_cpu_size	-> The length of the per cpu area


Removes the &__per_cpu_x in lockdep. AFAICT The __per_cpu_x are already
pointers.

Signed-off-by: Christoph Lameter <clameter@sgi.com>

---
 include/asm-generic/percpu.h      |    7 ++++++-
 include/asm-generic/sections.h    |   10 ++++++++++
 include/asm-generic/vmlinux.lds.h |   15 +++++++++++++++
 init/main.c                       |   17 +++++++++--------
 kernel/lockdep.c                  |    4 ++--
 5 files changed, 42 insertions(+), 11 deletions(-)

Index: linux-2.6.24-rc3-mm2/include/asm-generic/percpu.h
===================================================================
--- linux-2.6.24-rc3-mm2.orig/include/asm-generic/percpu.h	2007-11-29 22:05:58.359576450 -0800
+++ linux-2.6.24-rc3-mm2/include/asm-generic/percpu.h	2007-11-29 22:06:22.750825804 -0800
@@ -42,8 +42,13 @@ extern unsigned long __per_cpu_offset[NR
  * Only S390 provides its own means of moving the pointer.
  */
 #ifndef SHIFT_PTR
+#ifdef CONFIG_PERCPU_ZERO_BASED
+#define SHIFT_PTR(__p, __offset) \
+	((__typeof(__p))(((void *)(__p)) + (__offset)))
+#else
 #define SHIFT_PTR(__p, __offset)	RELOC_HIDE((__p), (__offset))
-#endif
+#endif /* CONFIG_PER_CPU_ZERO_BASED */
+#endif /* SHIFT_PTR */
 
 /*
  * A percpu variable may point to a discarded reghions. The following are
Index: linux-2.6.24-rc3-mm2/include/asm-generic/sections.h
===================================================================
--- linux-2.6.24-rc3-mm2.orig/include/asm-generic/sections.h	2007-11-29 22:05:58.367576240 -0800
+++ linux-2.6.24-rc3-mm2/include/asm-generic/sections.h	2007-11-29 22:06:22.754826440 -0800
@@ -9,7 +9,17 @@ extern char __bss_start[], __bss_stop[];
 extern char __init_begin[], __init_end[];
 extern char _sinittext[], _einittext[];
 extern char _end[];
+#ifdef CONFIG_PERCPU_ZERO_BASED
+extern char __per_cpu_load[];
+extern char ____per_cpu_size[];
+#define __per_cpu_size ((unsigned long)&____per_cpu_size)
+#define __per_cpu_start ((char *)0)
+#define __per_cpu_end ((char *)__per_cpu_size)
+#else
 extern char __per_cpu_start[], __per_cpu_end[];
+#define __per_cpu_load __per_cpu_start
+#define __per_cpu_size (__per_cpu_end - __per_cpu_start)
+#endif
 extern char __kprobes_text_start[], __kprobes_text_end[];
 extern char __initdata_begin[], __initdata_end[];
 extern char __start_rodata[], __end_rodata[];
Index: linux-2.6.24-rc3-mm2/include/asm-generic/vmlinux.lds.h
===================================================================
--- linux-2.6.24-rc3-mm2.orig/include/asm-generic/vmlinux.lds.h	2007-11-29 22:06:03.486826118 -0800
+++ linux-2.6.24-rc3-mm2/include/asm-generic/vmlinux.lds.h	2007-11-29 22:06:22.754826440 -0800
@@ -255,6 +255,20 @@
   	*(.initcall7.init)						\
   	*(.initcall7s.init)
 
+#ifdef CONFIG_PERCPU_ZERO_BASED
+#define PERCPU(align)							\
+	. = ALIGN(align);						\
+	percpu : { } :percpu						\
+	__per_cpu_load = .;						\
+	.data.percpu 0 : AT(__per_cpu_load - LOAD_OFFSET) {		\
+		*(.data.percpu.first)					\
+		*(.data.percpu)						\
+		*(.data.percpu.shared_aligned)				\
+		____per_cpu_size = .;					\
+	}								\
+	. = __per_cpu_load + ____per_cpu_size;				\
+	data : { } :data
+#else
 #define PERCPU(align)							\
 	. = ALIGN(align);						\
 	__per_cpu_start = .;						\
@@ -263,3 +277,4 @@
 		*(.data.percpu.shared_aligned)				\
 	}								\
 	__per_cpu_end = .;
+#endif
Index: linux-2.6.24-rc3-mm2/init/main.c
===================================================================
--- linux-2.6.24-rc3-mm2.orig/init/main.c	2007-11-29 22:06:01.607326159 -0800
+++ linux-2.6.24-rc3-mm2/init/main.c	2007-11-29 22:06:22.754826440 -0800
@@ -370,18 +370,19 @@ EXPORT_SYMBOL(__per_cpu_offset);
 
 static void __init setup_per_cpu_areas(void)
 {
-	unsigned long size, i;
-	char *ptr;
-	unsigned long nr_possible_cpus = num_possible_cpus();
+	unsigned long size;
+	int cpu;
 
 	/* Copy section for each CPU (we discard the original) */
 	size = ALIGN(PERCPU_ENOUGH_ROOM, PAGE_SIZE);
-	ptr = alloc_bootmem_pages(size * nr_possible_cpus);
 
-	for_each_possible_cpu(i) {
-		__per_cpu_offset[i] = ptr - __per_cpu_start;
-		memcpy(ptr, __per_cpu_start, __per_cpu_end - __per_cpu_start);
-		ptr += size;
+	for_each_possible_cpu(cpu) {
+		char *ptr;
+
+		ptr = alloc_bootmem_pages_node(NODE_DATA(cpu_to_node(cpu)),
+								size);
+		__per_cpu_offset[cpu] = ptr - __per_cpu_start;
+		memcpy(ptr, __per_cpu_load, __per_cpu_size);
 	}
 }
 #endif /* CONFIG_ARCH_SETS_UP_CPU_AREA */
Index: linux-2.6.24-rc3-mm2/kernel/lockdep.c
===================================================================
--- linux-2.6.24-rc3-mm2.orig/kernel/lockdep.c	2007-11-29 22:05:58.391576218 -0800
+++ linux-2.6.24-rc3-mm2/kernel/lockdep.c	2007-11-29 22:06:22.754826440 -0800
@@ -613,8 +613,8 @@ static int static_obj(void *obj)
 	 * percpu var?
 	 */
 	for_each_possible_cpu(i) {
-		start = (unsigned long) &__per_cpu_start + per_cpu_offset(i);
-		end   = (unsigned long) &__per_cpu_start + PERCPU_ENOUGH_ROOM
+		start = (unsigned long) __per_cpu_start + per_cpu_offset(i);
+		end   = (unsigned long) __per_cpu_start + PERCPU_ENOUGH_ROOM
 					+ per_cpu_offset(i);
 
 		if ((addr >= start) && (addr < end))

-- 
