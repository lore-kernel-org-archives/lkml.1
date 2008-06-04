Return-Path: <linux-kernel-owner+w=401wt.eu-S1757622AbYFDAbZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757622AbYFDAbZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2008 20:31:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753246AbYFDAaZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jun 2008 20:30:25 -0400
Received: from relay2.sgi.com ([192.48.171.30]:56084 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751925AbYFDAaV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2008 20:30:21 -0400
Message-Id: <20080604003019.084427000@polaris-admin.engr.sgi.com>
References: <20080604003018.538497000@polaris-admin.engr.sgi.com>
User-Agent: quilt/0.46-1
Date: Tue, 03 Jun 2008 17:30:19 -0700
From: Mike Travis <travis@sgi.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Christoph Lameter <clameter@sgi.com>,
       David Miller <davem@davemloft.net>, Eric Dumazet <dada1@cosmosbay.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>, linux-kernel@vger.kernel.org
Subject: [PATCH 1/4] Zero based percpu: Infrastructure to rebase the per cpu area to zero
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

Based on linux-2.6.tip

Signed-off-by: Christoph Lameter <clameter@sgi.com>
Signed-off-by: Mike Travis <travis@sgi.com>
---
 include/asm-generic/percpu.h      |    9 ++++++++-
 include/asm-generic/sections.h    |   10 ++++++++++
 include/asm-generic/vmlinux.lds.h |   16 ++++++++++++++++
 include/linux/percpu.h            |   17 ++++++++++++++++-
 kernel/lockdep.c                  |    4 ++--
 kernel/module.c                   |    7 ++++---
 6 files changed, 56 insertions(+), 7 deletions(-)

--- linux-2.6.tip.orig/include/asm-generic/percpu.h
+++ linux-2.6.tip/include/asm-generic/percpu.h
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
 
--- linux-2.6.tip.orig/include/asm-generic/sections.h
+++ linux-2.6.tip/include/asm-generic/sections.h
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
--- linux-2.6.tip.orig/include/asm-generic/vmlinux.lds.h
+++ linux-2.6.tip/include/asm-generic/vmlinux.lds.h
@@ -371,6 +371,21 @@
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
@@ -380,3 +395,4 @@
 		*(.data.percpu.shared_aligned)				\
 	}								\
 	__per_cpu_end = .;
+#endif
--- linux-2.6.tip.orig/include/linux/percpu.h
+++ linux-2.6.tip/include/linux/percpu.h
@@ -27,7 +27,18 @@
 #define DEFINE_PER_CPU_PAGE_ALIGNED(type, name)			\
 	__attribute__((__section__(".data.percpu.page_aligned")))	\
 	PER_CPU_ATTRIBUTES __typeof__(type) per_cpu__##name
+
+#ifdef CONFIG_HAVE_ZERO_BASED_PER_CPU
+#define DEFINE_PER_CPU_FIRST(type, name)				\
+	__attribute__((__section__(".data.percpu.first")))		\
+	PER_CPU_ATTRIBUTES __typeof__(type) per_cpu__##name
 #else
+#define DEFINE_PER_CPU_FIRST(type, name)				\
+	DEFINE_PER_CPU(type, name)
+#endif
+
+#else /* !CONFIG_SMP */
+
 #define DEFINE_PER_CPU(type, name)					\
 	PER_CPU_ATTRIBUTES __typeof__(type) per_cpu__##name
 
@@ -36,7 +47,11 @@
 
 #define DEFINE_PER_CPU_PAGE_ALIGNED(type, name)		      \
 	DEFINE_PER_CPU(type, name)
-#endif
+
+#define DEFINE_PER_CPU_FIRST(type, name)				\
+	DEFINE_PER_CPU(type, name)
+
+#endif /* !CONFIG_SMP */
 
 #define EXPORT_PER_CPU_SYMBOL(var) EXPORT_SYMBOL(per_cpu__##var)
 #define EXPORT_PER_CPU_SYMBOL_GPL(var) EXPORT_SYMBOL_GPL(per_cpu__##var)
--- linux-2.6.tip.orig/kernel/lockdep.c
+++ linux-2.6.tip/kernel/lockdep.c
@@ -614,8 +614,8 @@ static int static_obj(void *obj)
 	 * percpu var?
 	 */
 	for_each_possible_cpu(i) {
-		start = (unsigned long) &__per_cpu_start + per_cpu_offset(i);
-		end   = (unsigned long) &__per_cpu_start + PERCPU_ENOUGH_ROOM
+		start = (unsigned long) __per_cpu_start + per_cpu_offset(i);
+		end   = (unsigned long) __per_cpu_start + PERCPU_ENOUGH_ROOM
 					+ per_cpu_offset(i);
 
 		if ((addr >= start) && (addr < end))
--- linux-2.6.tip.orig/kernel/module.c
+++ linux-2.6.tip/kernel/module.c
@@ -45,6 +45,7 @@
 #include <linux/unwind.h>
 #include <asm/uaccess.h>
 #include <asm/cacheflush.h>
+#include <asm/sections.h>
 #include <linux/license.h>
 #include <asm/sections.h>
 #include <linux/marker.h>
@@ -367,7 +368,7 @@ static void *percpu_modalloc(unsigned lo
 		align = PAGE_SIZE;
 	}
 
-	ptr = __per_cpu_start;
+	ptr = __per_cpu_load;
 	for (i = 0; i < pcpu_num_used; ptr += block_size(pcpu_size[i]), i++) {
 		/* Extra for alignment requirement. */
 		extra = ALIGN((unsigned long)ptr, align) - (unsigned long)ptr;
@@ -402,7 +403,7 @@ static void *percpu_modalloc(unsigned lo
 static void percpu_modfree(void *freeme)
 {
 	unsigned int i;
-	void *ptr = __per_cpu_start + block_size(pcpu_size[0]);
+	void *ptr = __per_cpu_load + block_size(pcpu_size[0]);
 
 	/* First entry is core kernel percpu data. */
 	for (i = 1; i < pcpu_num_used; ptr += block_size(pcpu_size[i]), i++) {
@@ -453,7 +454,7 @@ static int percpu_modinit(void)
 	pcpu_size = kmalloc(sizeof(pcpu_size[0]) * pcpu_num_allocated,
 			    GFP_KERNEL);
 	/* Static in-kernel percpu data (used). */
-	pcpu_size[0] = -(__per_cpu_end-__per_cpu_start);
+	pcpu_size[0] = -__per_cpu_size;
 	/* Free room. */
 	pcpu_size[1] = PERCPU_ENOUGH_ROOM + pcpu_size[0];
 	if (pcpu_size[1] < 0) {

-- 
