Return-Path: <linux-kernel-owner+w=401wt.eu-S1756212AbYGNOem@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756212AbYGNOem (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2008 10:34:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754026AbYGNOee
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jul 2008 10:34:34 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:42521 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753470AbYGNOee (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2008 10:34:34 -0400
Date: Mon, 14 Jul 2008 16:34:13 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [git pull] core/percpu for v2.6.27
Message-ID: <20080714143413.GA19134@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest core/percpu git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git core/percpu

Thanks,

	Ingo

------------------>
Eric Dumazet (1):
      percpu: introduce DEFINE_PER_CPU_PAGE_ALIGNED() macro

Heiko Carstens (1):
      percpu: zero based percpu build error on s390

Mike Travis (2):
      x86: extend percpu ops to 64 bit
      Zero based percpu: infrastructure to rebase the per cpu area to zero


 arch/x86/kernel/cpu/common.c      |    2 +-
 arch/x86/kernel/vmlinux_32.lds.S  |    1 +
 include/asm-generic/percpu.h      |   11 ++++-
 include/asm-generic/sections.h    |   10 ++++
 include/asm-generic/vmlinux.lds.h |   17 ++++++++
 include/asm-x86/percpu.h          |   83 ++++++++++++++++++++++++++++++++++--
 include/linux/percpu.h            |   24 ++++++++++-
 kernel/lockdep.c                  |    4 +-
 kernel/module.c                   |    7 ++-
 9 files changed, 146 insertions(+), 13 deletions(-)

diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index d0463a9..b2f54fa 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -21,7 +21,7 @@
 
 #include "cpu.h"
 
-DEFINE_PER_CPU(struct gdt_page, gdt_page) = { .gdt = {
+DEFINE_PER_CPU_PAGE_ALIGNED(struct gdt_page, gdt_page) = { .gdt = {
 	[GDT_ENTRY_KERNEL_CS] = { { { 0x0000ffff, 0x00cf9a00 } } },
 	[GDT_ENTRY_KERNEL_DS] = { { { 0x0000ffff, 0x00cf9200 } } },
 	[GDT_ENTRY_DEFAULT_USER_CS] = { { { 0x0000ffff, 0x00cffa00 } } },
diff --git a/arch/x86/kernel/vmlinux_32.lds.S b/arch/x86/kernel/vmlinux_32.lds.S
index ce5ed08..0f7c29a 100644
--- a/arch/x86/kernel/vmlinux_32.lds.S
+++ b/arch/x86/kernel/vmlinux_32.lds.S
@@ -189,6 +189,7 @@ SECTIONS
   . = ALIGN(PAGE_SIZE);
   .data.percpu  : AT(ADDR(.data.percpu) - LOAD_OFFSET) {
 	__per_cpu_start = .;
+	*(.data.percpu.page_aligned)
 	*(.data.percpu)
 	*(.data.percpu.shared_aligned)
 	__per_cpu_end = .;
diff --git a/include/asm-generic/percpu.h b/include/asm-generic/percpu.h
index b0e63c6..1c02250 100644
--- a/include/asm-generic/percpu.h
+++ b/include/asm-generic/percpu.h
@@ -45,7 +45,12 @@ extern unsigned long __per_cpu_offset[NR_CPUS];
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
@@ -70,6 +75,10 @@ extern void setup_per_cpu_areas(void);
 #define per_cpu(var, cpu)			(*((void)(cpu), &per_cpu_var(var)))
 #define __get_cpu_var(var)			per_cpu_var(var)
 #define __raw_get_cpu_var(var)			per_cpu_var(var)
+#ifndef SHIFT_PERCPU_PTR
+# define SHIFT_PERCPU_PTR(__p, __offset)		(__p)
+#endif
+#define per_cpu_offset(x)			0L
 
 #endif	/* SMP */
 
diff --git a/include/asm-generic/sections.h b/include/asm-generic/sections.h
index 8feeae1..f697620 100644
--- a/include/asm-generic/sections.h
+++ b/include/asm-generic/sections.h
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
diff --git a/include/asm-generic/vmlinux.lds.h b/include/asm-generic/vmlinux.lds.h
index f054778..465a97a 100644
--- a/include/asm-generic/vmlinux.lds.h
+++ b/include/asm-generic/vmlinux.lds.h
@@ -344,11 +344,28 @@
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
 	.data.percpu  : AT(ADDR(.data.percpu) - LOAD_OFFSET) {		\
+		*(.data.percpu.page_aligned)				\
 		*(.data.percpu)						\
 		*(.data.percpu.shared_aligned)				\
 	}								\
 	__per_cpu_end = .;
+#endif
diff --git a/include/asm-x86/percpu.h b/include/asm-x86/percpu.h
index 736fc3b..d85e5aa 100644
--- a/include/asm-x86/percpu.h
+++ b/include/asm-x86/percpu.h
@@ -108,6 +108,11 @@ do {							\
 		    : "+m" (var)			\
 		    : "ri" ((T__)val));			\
 		break;					\
+	case 8:						\
+		asm(op "q %1,"__percpu_seg"%0"		\
+		    : "+m" (var)			\
+		    : "ri" ((T__)val));			\
+		break;					\
 	default: __bad_percpu_size();			\
 	}						\
 } while (0)
@@ -131,16 +136,84 @@ do {							\
 		    : "=r" (ret__)			\
 		    : "m" (var));			\
 		break;					\
+	case 8:						\
+		asm(op "q "__percpu_seg"%1,%0"		\
+		    : "=r" (ret__)			\
+		    : "m" (var));			\
+		break;					\
 	default: __bad_percpu_size();			\
 	}						\
 	ret__;						\
 })
 
-#define x86_read_percpu(var) percpu_from_op("mov", per_cpu__##var)
-#define x86_write_percpu(var, val) percpu_to_op("mov", per_cpu__##var, val)
-#define x86_add_percpu(var, val) percpu_to_op("add", per_cpu__##var, val)
-#define x86_sub_percpu(var, val) percpu_to_op("sub", per_cpu__##var, val)
-#define x86_or_percpu(var, val) percpu_to_op("or", per_cpu__##var, val)
+#define percpu_addr_op(op, var)				\
+({							\
+	switch (sizeof(var)) {				\
+	case 1:						\
+		asm(op "b "__percpu_seg"%0"		\
+				: : "m"(var));		\
+		break;					\
+	case 2:						\
+		asm(op "w "__percpu_seg"%0"		\
+				: : "m"(var));		\
+		break;					\
+	case 4:						\
+		asm(op "l "__percpu_seg"%0"		\
+				: : "m"(var));		\
+		break;					\
+	case 8:						\
+		asm(op "q "__percpu_seg"%0"		\
+				: : "m"(var));		\
+		break;					\
+	default: __bad_percpu_size();			\
+	}						\
+})
+
+#define percpu_cmpxchg_op(var, old, new)				\
+({									\
+	typeof(var) prev;						\
+	switch (sizeof(var)) {						\
+	case 1:								\
+		asm("cmpxchgb %b1, "__percpu_seg"%2"			\
+				     : "=a"(prev)			\
+				     : "q"(new), "m"(var), "0"(old)	\
+				     : "memory");			\
+		break;							\
+	case 2:								\
+		asm("cmpxchgw %w1, "__percpu_seg"%2"			\
+				     : "=a"(prev)			\
+				     : "r"(new), "m"(var), "0"(old)	\
+				     : "memory");			\
+		break;							\
+	case 4:								\
+		asm("cmpxchgl %k1, "__percpu_seg"%2"			\
+				     : "=a"(prev)			\
+				     : "r"(new), "m"(var), "0"(old)	\
+				     : "memory");			\
+		break;							\
+	case 8:								\
+		asm("cmpxchgq %1, "__percpu_seg"%2"			\
+				     : "=a"(prev)			\
+				     : "r"(new), "m"(var), "0"(old)	\
+				     : "memory");			\
+		break;							\
+	default:							\
+		__bad_percpu_size();					\
+	}								\
+	return prev;							\
+})
+
+#define x86_read_percpu(var) percpu_from_op("mov", per_cpu_var(var))
+#define x86_write_percpu(var, val) percpu_to_op("mov", per_cpu_var(var), val)
+#define x86_add_percpu(var, val) percpu_to_op("add", per_cpu_var(var), val)
+#define x86_sub_percpu(var, val) percpu_to_op("sub", per_cpu_var(var), val)
+#define x86_inc_percpu(var) percpu_addr_op("inc", per_cpu_var(var))
+#define x86_dec_percpu(var) percpu_addr_op("dec", per_cpu_var(var))
+#define x86_or_percpu(var, val) percpu_to_op("or", per_cpu_var(var), val)
+#define x86_xchg_percpu(var, val) percpu_to_op("xchg", per_cpu_var(var), val)
+#define x86_cmpxchg_percpu(var, old, new) \
+				percpu_cmpxchg_op(per_cpu_var(var), old, new)
+
 #endif /* !__ASSEMBLY__ */
 #endif /* !CONFIG_X86_64 */
 #endif /* _ASM_X86_PERCPU_H_ */
diff --git a/include/linux/percpu.h b/include/linux/percpu.h
index 4cdd393..3d1a7f6 100644
--- a/include/linux/percpu.h
+++ b/include/linux/percpu.h
@@ -23,13 +23,35 @@
 	__attribute__((__section__(SHARED_ALIGNED_SECTION)))		\
 	PER_CPU_ATTRIBUTES __typeof__(type) per_cpu__##name		\
 	____cacheline_aligned_in_smp
+
+#define DEFINE_PER_CPU_PAGE_ALIGNED(type, name)			\
+	__attribute__((__section__(".data.percpu.page_aligned")))	\
+	PER_CPU_ATTRIBUTES __typeof__(type) per_cpu__##name
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
 
 #define DEFINE_PER_CPU_SHARED_ALIGNED(type, name)		      \
 	DEFINE_PER_CPU(type, name)
-#endif
+
+#define DEFINE_PER_CPU_PAGE_ALIGNED(type, name)		      \
+	DEFINE_PER_CPU(type, name)
+
+#define DEFINE_PER_CPU_FIRST(type, name)				\
+	DEFINE_PER_CPU(type, name)
+
+#endif /* !CONFIG_SMP */
 
 #define EXPORT_PER_CPU_SYMBOL(var) EXPORT_SYMBOL(per_cpu__##var)
 #define EXPORT_PER_CPU_SYMBOL_GPL(var) EXPORT_SYMBOL_GPL(per_cpu__##var)
diff --git a/kernel/lockdep.c b/kernel/lockdep.c
index 81a4e4a..965b9c7 100644
--- a/kernel/lockdep.c
+++ b/kernel/lockdep.c
@@ -609,8 +609,8 @@ static int static_obj(void *obj)
 	 * percpu var?
 	 */
 	for_each_possible_cpu(i) {
-		start = (unsigned long) &__per_cpu_start + per_cpu_offset(i);
-		end   = (unsigned long) &__per_cpu_start + PERCPU_ENOUGH_ROOM
+		start = (unsigned long) __per_cpu_start + per_cpu_offset(i);
+		end   = (unsigned long) __per_cpu_start + PERCPU_ENOUGH_ROOM
 					+ per_cpu_offset(i);
 
 		if ((addr >= start) && (addr < end))
diff --git a/kernel/module.c b/kernel/module.c
index 5f80478..f525015 100644
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -44,6 +44,7 @@
 #include <linux/unwind.h>
 #include <asm/uaccess.h>
 #include <asm/cacheflush.h>
+#include <asm/sections.h>
 #include <linux/license.h>
 #include <asm/sections.h>
 
@@ -365,7 +366,7 @@ static void *percpu_modalloc(unsigned long size, unsigned long align,
 		align = PAGE_SIZE;
 	}
 
-	ptr = __per_cpu_start;
+	ptr = __per_cpu_load;
 	for (i = 0; i < pcpu_num_used; ptr += block_size(pcpu_size[i]), i++) {
 		/* Extra for alignment requirement. */
 		extra = ALIGN((unsigned long)ptr, align) - (unsigned long)ptr;
@@ -400,7 +401,7 @@ static void *percpu_modalloc(unsigned long size, unsigned long align,
 static void percpu_modfree(void *freeme)
 {
 	unsigned int i;
-	void *ptr = __per_cpu_start + block_size(pcpu_size[0]);
+	void *ptr = __per_cpu_load + block_size(pcpu_size[0]);
 
 	/* First entry is core kernel percpu data. */
 	for (i = 1; i < pcpu_num_used; ptr += block_size(pcpu_size[i]), i++) {
@@ -451,7 +452,7 @@ static int percpu_modinit(void)
 	pcpu_size = kmalloc(sizeof(pcpu_size[0]) * pcpu_num_allocated,
 			    GFP_KERNEL);
 	/* Static in-kernel percpu data (used). */
-	pcpu_size[0] = -(__per_cpu_end-__per_cpu_start);
+	pcpu_size[0] = -__per_cpu_size;
 	/* Free room. */
 	pcpu_size[1] = PERCPU_ENOUGH_ROOM + pcpu_size[0];
 	if (pcpu_size[1] < 0) {
