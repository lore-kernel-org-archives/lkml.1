Return-Path: <linux-kernel-owner+w=401wt.eu-S1759974AbYE3EMx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759974AbYE3EMx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2008 00:12:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756423AbYE3EBY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 May 2008 00:01:24 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:40517 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753289AbYE3EAZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2008 00:00:25 -0400
Message-Id: <20080530040023.099128332@sgi.com>
References: <20080530035620.587204923@sgi.com>
User-Agent: quilt/0.46-1
Date: Thu, 29 May 2008 20:56:56 -0700
From: Christoph Lameter <clameter@sgi.com>
To: akpm@linux-foundation.org
Cc: linux-arch@vger.kernel.org, Mike Travis <travis@sgi.com>
Cc: linux-kernel@vger.kernel.org
Cc: David Miller <davem@davemloft.net>
Cc: Eric Dumazet <dada1@cosmosbay.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Subject: [patch 36/41] Zero based percpu: Infrastructure to rebase the per cpu area to zero
Content-Disposition: inline; filename=zero_based_infrastructure
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

    * Support an option

	CONFIG_HAVE_ZERO_BASED_PER_CPU

      to make offsets for per cpu variables to start at zero.

      If a percpu area starts at zero then:

	-  We do not need RELOC_HIDE anymore

	-  Provides for the future capability of architectures providing
	   a per cpu allocator that returns offsets instead of pointers.
	   The offsets would be independent of the processor so that
	   address calculations can be done in a processor independent way.
	   Per cpu instructions can then add the processor specific offset
	   at the last minute possibly in an atomic instruction.

      The data the linker provides is different for zero based percpu segments:

	__per_cpu_load	-> The address at which the percpu area was loaded
	__per_cpu_size	-> The length of the per cpu area

    * Removes the &__per_cpu_x in lockdep. The __per_cpu_x are already
      pointers. There is no need to take the address.

    * Updates kernel/module.c to be able to deal with a percpu area that
      is loaded at __per_cpu_load but is accessed at __per_cpu_start.

Signed-off-by: Christoph Lameter <clameter@sgi.com>
Signed-off-by: Mike Travis <travis@sgi.com>
---
 include/asm-generic/percpu.h      |    9 ++++++++-
 include/asm-generic/sections.h    |   10 ++++++++++
 include/asm-generic/vmlinux.lds.h |   16 ++++++++++++++++
 include/linux/percpu.h            |    8 ++++++++
 kernel/lockdep.c                  |    4 ++--
 5 files changed, 44 insertions(+), 3 deletions(-)

Index: linux-2.6/include/asm-generic/percpu.h
===================================================================
--- linux-2.6.orig/include/asm-generic/percpu.h	2008-05-29 17:57:39.788714222 -0700
+++ linux-2.6/include/asm-generic/percpu.h	2008-05-29 18:03:12.432714383 -0700
@@ -45,7 +45,12 @@ extern unsigned long __per_cpu_offset[NR
  * Only S390 provides its own means of moving the pointer.
  */
 #ifndef SHIFT_PERCPU_PTR
-#define SHIFT_PERCPU_PTR(__p, __offset)	RELOC_HIDE((__p), (__offset))
+# ifdef CONFIG_HAVE_ZERO_BASED_PER_CPU
+#  define SHIFT_PERCPU_PTR(__p, __offset) \
+	((__typeof(__p))(((void *)(__p)) + (__offset)))
+# else
+#  define SHIFT_PERCPU_PTR(__p, __offset)	RELOC_HIDE((__p), (__offset))
+# endif /* CONFIG_HAVE_ZERO_BASED_PER_CPU */
 #endif
 
 /*
@@ -70,6 +75,8 @@ extern void setup_per_cpu_areas(void);
 #define per_cpu(var, cpu)			(*((void)(cpu), &per_cpu_var(var)))
 #define __get_cpu_var(var)			per_cpu_var(var)
 #define __raw_get_cpu_var(var)			per_cpu_var(var)
+#define SHIFT_PERCPU_PTR(__p, __offset)		(__p)
+#define per_cpu_offset(x)			0L
 
 #endif	/* SMP */
 
Index: linux-2.6/include/asm-generic/sections.h
===================================================================
--- linux-2.6.orig/include/asm-generic/sections.h	2008-05-29 17:57:39.792714337 -0700
+++ linux-2.6/include/asm-generic/sections.h	2008-05-29 18:03:12.432714383 -0700
@@ -9,7 +9,17 @@ extern char __bss_start[], __bss_stop[];
 extern char __init_begin[], __init_end[];
 extern char _sinittext[], _einittext[];
 extern char _end[];
+#ifdef CONFIG_HAVE_ZERO_BASED_PER_CPU
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
Index: linux-2.6/include/asm-generic/vmlinux.lds.h
===================================================================
--- linux-2.6.orig/include/asm-generic/vmlinux.lds.h	2008-05-29 17:57:39.800714018 -0700
+++ linux-2.6/include/asm-generic/vmlinux.lds.h	2008-05-29 18:03:12.432714383 -0700
@@ -344,6 +344,21 @@
   	*(.initcall7.init)						\
   	*(.initcall7s.init)
 
+#ifdef CONFIG_HAVE_ZERO_BASED_PER_CPU
+#define PERCPU(align)							\
+	. = ALIGN(align);						\
+	percpu : { } :percpu						\
+	__per_cpu_load = .;						\
+	.data.percpu 0 : AT(__per_cpu_load - LOAD_OFFSET) {		\
+		*(.data.percpu.first)					\
+		*(.data.percpu.shared_aligned)				\
+		*(.data.percpu)						\
+		*(.data.percpu.page_aligned)				\
+		____per_cpu_size = .;					\
+	}								\
+	. = __per_cpu_load + ____per_cpu_size;				\
+	data : { } :data
+#else
 #define PERCPU(align)							\
 	. = ALIGN(align);						\
 	__per_cpu_start = .;						\
@@ -352,3 +367,4 @@
 		*(.data.percpu.shared_aligned)				\
 	}								\
 	__per_cpu_end = .;
+#endif
Index: linux-2.6/kernel/lockdep.c
===================================================================
--- linux-2.6.orig/kernel/lockdep.c	2008-05-29 17:59:22.697422432 -0700
+++ linux-2.6/kernel/lockdep.c	2008-05-29 18:03:33.013702733 -0700
@@ -609,8 +609,8 @@ static int static_obj(void *obj)
 	 * percpu var?
 	 */
 	for_each_possible_cpu(i) {
-		start = (unsigned long) &__per_cpu_start + per_cpu_offset(i);
-		end   = (unsigned long) &__per_cpu_start + __per_cpu_size
+		start = (unsigned long) __per_cpu_start + per_cpu_offset(i);
+		end   = (unsigned long) __per_cpu_start + __per_cpu_size
 					+ per_cpu_offset(i);
 
 		if ((addr >= start) && (addr < end))
Index: linux-2.6/include/linux/percpu.h
===================================================================
--- linux-2.6.orig/include/linux/percpu.h	2008-05-29 18:01:22.260714623 -0700
+++ linux-2.6/include/linux/percpu.h	2008-05-29 18:03:12.436714003 -0700
@@ -23,12 +23,20 @@
 	__attribute__((__section__(SHARED_ALIGNED_SECTION)))		\
 	PER_CPU_ATTRIBUTES __typeof__(type) per_cpu__##name		\
 	____cacheline_aligned_in_smp
+
+#define DEFINE_PER_CPU_FIRST(type, name)				\
+	__attribute__((__section__(".data.percpu.first")))		\
+	PER_CPU_ATTRIBUTES __typeof__(type) per_cpu__##name
+
 #else
 #define DEFINE_PER_CPU(type, name)					\
 	PER_CPU_ATTRIBUTES __typeof__(type) per_cpu__##name
 
 #define DEFINE_PER_CPU_SHARED_ALIGNED(type, name)		      \
 	DEFINE_PER_CPU(type, name)
+
+#define DEFINE_PER_CPU_FIRST(type, name)			      \
+	DEFINE_PER_CPU(type, name)
 #endif
 
 #define EXPORT_PER_CPU_SYMBOL(var) EXPORT_SYMBOL(per_cpu__##var)

-- 
