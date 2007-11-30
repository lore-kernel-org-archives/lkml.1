Return-Path: <linux-kernel-owner+w=401wt.eu-S933831AbXK3LZ2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933831AbXK3LZ2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2007 06:25:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756446AbXK3LZI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Nov 2007 06:25:08 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:51244 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758250AbXK3LZE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2007 06:25:04 -0500
Date: Fri, 30 Nov 2007 12:24:29 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Christoph Lameter <clameter@sgi.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>, Andi Kleen <ak@suse.de>,
       Jeremy Fitzhardinge <jeremy@goop.org>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [patch 0/3] Per cpu relocation to ZERO and x86_32 percpu ops
	on x86_64
Message-ID: <20071130112429.GA3605@elte.hu>
References: <20071130064305.459255715@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20071130064305.459255715@sgi.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Christoph Lameter <clameter@sgi.com> wrote:

> This patchset allows the use of x86_32 percpu ops on x86_64 while 
> maintaining %gs pointing to the pda. It does that by moving the x86_64 
> pda into the percpu area (thereby pointing %gs at the per cpu area) 
> and then relocating the x86_64 per cpu variables to start at 0.
> 
> Patch applies on top of the per cpu cleanup patches V2. See 
> http://marc.info/?l=linux-kernel&m=119628478316525&w=2
> 
> Ultimately I think we can make the per cpu accessors arch independent 
> (see the RFC at 
> http://marc.info/?l=linux-kernel&m=119552126330405&w=2). There is a 
> performance benefit from using these in core code.

i've picked up your cleanup series and this relocation series as well, 
but it crashed on x86 32-bit UP, with:

 [   78.692936] Freeing unused kernel memory: 656k freed
 [   78.697750] BUG: spinlock wrong owner on CPU#0, /0�

(no other messages, hard lockup)

find below my manual merge against x86.git, maybe i made some merging 
mistake. x86.git can be picked up via:

 git-pull git://git.kernel.org/pub/scm/linux/kernel/git/x86/linux-2.6-x86.git mm

	Ingo

-------------------->
Index: linux-x86.q/arch/ia64/Kconfig
===================================================================
--- linux-x86.q.orig/arch/ia64/Kconfig
+++ linux-x86.q/arch/ia64/Kconfig
@@ -75,6 +75,9 @@ config GENERIC_TIME_VSYSCALL
 	bool
 	default y
 
+config ARCH_SETS_UP_PER_CPU_AREA
+	def_bool y
+
 config DMI
 	bool
 	default y
Index: linux-x86.q/arch/powerpc/Kconfig
===================================================================
--- linux-x86.q.orig/arch/powerpc/Kconfig
+++ linux-x86.q/arch/powerpc/Kconfig
@@ -42,6 +42,9 @@ config GENERIC_HARDIRQS
 	bool
 	default y
 
+config ARCH_SETS_UP_PER_CPU_AREA
+	def_bool PPC64
+
 config IRQ_PER_CPU
 	bool
 	default y
Index: linux-x86.q/arch/sparc64/Kconfig
===================================================================
--- linux-x86.q.orig/arch/sparc64/Kconfig
+++ linux-x86.q/arch/sparc64/Kconfig
@@ -66,6 +66,9 @@ config AUDIT_ARCH
 	bool
 	default y
 
+config ARCH_SETS_UP_PER_CPU_AREA
+	def_bool y
+
 config ARCH_NO_VIRT_TO_BUS
 	def_bool y
 
Index: linux-x86.q/arch/sparc64/mm/init.c
===================================================================
--- linux-x86.q.orig/arch/sparc64/mm/init.c
+++ linux-x86.q/arch/sparc64/mm/init.c
@@ -1323,6 +1323,11 @@ pgd_t swapper_pg_dir[2048];
 static void sun4u_pgprot_init(void);
 static void sun4v_pgprot_init(void);
 
+/* Dummy function */
+void __init setup_per_cpu_areas(void)
+{
+}
+
 void __init paging_init(void)
 {
 	unsigned long end_pfn, pages_avail, shift, phys_base;
Index: linux-x86.q/arch/x86/Kconfig
===================================================================
--- linux-x86.q.orig/arch/x86/Kconfig
+++ linux-x86.q/arch/x86/Kconfig
@@ -116,9 +116,13 @@ config GENERIC_TIME_VSYSCALL
 	bool
 	default X86_64
 
+config ARCH_SETS_UP_PER_CPU_AREA
+	def_bool X86_64
 
-
-
+config PERCPU_ZERO_BASED
+	bool
+	depends on X86_64 && SMP
+	default y
 
 config ZONE_DMA32
 	bool
Index: linux-x86.q/arch/x86/kernel/head64.c
===================================================================
--- linux-x86.q.orig/arch/x86/kernel/head64.c
+++ linux-x86.q/arch/x86/kernel/head64.c
@@ -22,6 +22,12 @@
 #include <asm/sections.h>
 #include <asm/kdebug.h>
 
+/*
+ * Only used before the per cpu areas are setup. The use for the non possible
+ * cpus continues after boot
+ */
+static struct x8664_pda boot_cpu_pda[NR_CPUS] __cacheline_aligned;
+
 static void __init zap_identity_mappings(void)
 {
 	pgd_t *pgd = pgd_offset_k(0UL);
Index: linux-x86.q/arch/x86/kernel/setup64.c
===================================================================
--- linux-x86.q.orig/arch/x86/kernel/setup64.c
+++ linux-x86.q/arch/x86/kernel/setup64.c
@@ -30,7 +30,9 @@ cpumask_t cpu_initialized __cpuinitdata 
 
 struct x8664_pda *_cpu_pda[NR_CPUS] __read_mostly;
 EXPORT_SYMBOL(_cpu_pda);
-struct x8664_pda boot_cpu_pda[NR_CPUS] __cacheline_aligned;
+
+DEFINE_PER_CPU_FIRST(struct x8664_pda, pda);
+EXPORT_PER_CPU_SYMBOL(pda);
 
 struct desc_ptr idt_descr = { 256 * 16 - 1, (unsigned long) idt_table };
 
@@ -109,10 +111,15 @@ void __init setup_per_cpu_areas(void)
 		}
 		if (!ptr)
 			panic("Cannot allocate cpu data for CPU %d\n", i);
-		cpu_pda(i)->data_offset = ptr - __per_cpu_start;
-		memcpy(ptr, __per_cpu_start, __per_cpu_end - __per_cpu_start);
+		memcpy(ptr, __per_cpu_load, __per_cpu_size);
+		/* Relocate the pda */
+		memcpy(ptr, cpu_pda(i), sizeof(struct x8664_pda));
+		cpu_pda(i) = (struct x8664_pda *)ptr;
+		cpu_pda(i)->data_offset = (unsigned long)ptr;
 	}
-} 
+	/* Fix up pda for this processor .... */
+	pda_init(0);
+}
 
 void pda_init(int cpu)
 { 
Index: linux-x86.q/arch/x86/kernel/smpboot_64.c
===================================================================
--- linux-x86.q.orig/arch/x86/kernel/smpboot_64.c
+++ linux-x86.q/arch/x86/kernel/smpboot_64.c
@@ -556,22 +556,6 @@ static int __cpuinit do_boot_cpu(int cpu
 		return -1;
 	}
 
-	/* Allocate node local memory for AP pdas */
-	if (cpu_pda(cpu) == &boot_cpu_pda[cpu]) {
-		struct x8664_pda *newpda, *pda;
-		int node = cpu_to_node(cpu);
-		pda = cpu_pda(cpu);
-		newpda = kmalloc_node(sizeof (struct x8664_pda), GFP_ATOMIC,
-				      node);
-		if (newpda) {
-			memcpy(newpda, pda, sizeof (struct x8664_pda));
-			cpu_pda(cpu) = newpda;
-		} else
-			printk(KERN_ERR
-		"Could not allocate node local PDA for CPU %d on node %d\n",
-				cpu, node);
-	}
-
 	alternatives_smp_switch(1);
 
 	c_idle.idle = get_idle_for_cpu(cpu);
Index: linux-x86.q/arch/x86/kernel/vmlinux_64.lds.S
===================================================================
--- linux-x86.q.orig/arch/x86/kernel/vmlinux_64.lds.S
+++ linux-x86.q/arch/x86/kernel/vmlinux_64.lds.S
@@ -16,6 +16,7 @@ jiffies_64 = jiffies;
 _proxy_pda = 1;
 PHDRS {
 	text PT_LOAD FLAGS(5);	/* R_E */
+	percpu PT_LOAD FLAGS(4);	/* R__ */
 	data PT_LOAD FLAGS(7);	/* RWE */
 	user PT_LOAD FLAGS(7);	/* RWE */
 	data.init PT_LOAD FLAGS(7);	/* RWE */
Index: linux-x86.q/include/asm-generic/percpu.h
===================================================================
--- linux-x86.q.orig/include/asm-generic/percpu.h
+++ linux-x86.q/include/asm-generic/percpu.h
@@ -3,28 +3,65 @@
 #include <linux/compiler.h>
 #include <linux/threads.h>
 
-#define __GENERIC_PER_CPU
+/*
+ * Determine the real variable name from the name visible in the
+ * kernel sources.
+ */
+#define per_cpu_var(var) per_cpu__##var
+
 #ifdef CONFIG_SMP
 
+/*
+ * per_cpu_offset() is the offset that has to be added to a
+ * percpu variable to get to the instance for a certain processor.
+ *
+ * Most arches use the __per_cpu_offset array for those offsets but
+ * some arches have their own ways of determining the offset (x86_64, s390).
+ */
+#ifndef __per_cpu_offset
 extern unsigned long __per_cpu_offset[NR_CPUS];
-
 #define per_cpu_offset(x) (__per_cpu_offset[x])
+#endif
 
-/* Separate out the type, so (int[3], foo) works. */
-#define DEFINE_PER_CPU(type, name) \
-    __attribute__((__section__(".data.percpu"))) __typeof__(type) per_cpu__##name
-
-#define DEFINE_PER_CPU_SHARED_ALIGNED(type, name)		\
-    __attribute__((__section__(".data.percpu.shared_aligned"))) \
-    __typeof__(type) per_cpu__##name				\
-    ____cacheline_aligned_in_smp
-
-/* var is in discarded region: offset to particular copy we want */
-#define per_cpu(var, cpu) (*({				\
-	extern int simple_identifier_##var(void);	\
-	RELOC_HIDE(&per_cpu__##var, __per_cpu_offset[cpu]); }))
-#define __get_cpu_var(var) per_cpu(var, smp_processor_id())
-#define __raw_get_cpu_var(var) per_cpu(var, raw_smp_processor_id())
+/*
+ * Determine the offset for the currently active processor.
+ * An arch may define __my_cpu_offset to provide a more effective
+ * means of obtaining the offset to the per cpu variables of the
+ * current processor.
+ */
+#ifndef __my_cpu_offset
+#define __my_cpu_offset per_cpu_offset(raw_smp_processor_id())
+#define my_cpu_offset per_cpu_offset(smp_processor_id())
+#else
+#define my_cpu_offset __my_cpu_offset
+#endif
+
+/*
+ * Add a offset to a pointer but keep the pointer as is.
+ *
+ * Only S390 provides its own means of moving the pointer.
+ */
+#ifndef SHIFT_PTR
+#ifdef CONFIG_PERCPU_ZERO_BASED
+#define SHIFT_PTR(__p, __offset) \
+	((__typeof(__p))(((void *)(__p)) + (__offset)))
+#else
+#define SHIFT_PTR(__p, __offset)	RELOC_HIDE((__p), (__offset))
+#endif /* CONFIG_PER_CPU_ZERO_BASED */
+#endif /* SHIFT_PTR */
+
+/*
+ * A percpu variable may point to a discarded reghions. The following are
+ * established ways to produce a usable pointer from the percpu variable
+ * offset.
+ */
+#define per_cpu(var, cpu) (*SHIFT_PTR(&per_cpu_var(var), per_cpu_offset(cpu)))
+#define __get_cpu_var(var) (*SHIFT_PTR(&per_cpu_var(var), my_cpu_offset))
+#define __raw_get_cpu_var(var) (*SHIFT_PTR(&per_cpu_var(var), __my_cpu_offset))
+
+#ifdef CONFIG_ARCH_SETS_UP_PER_CPU_AREA
+extern void setup_per_cpu_areas(void);
+#endif
 
 /* A macro to avoid #include hell... */
 #define percpu_modcopy(pcpudst, src, size)			\
@@ -36,21 +73,17 @@ do {								\
 } while (0)
 #else /* ! SMP */
 
-#define DEFINE_PER_CPU(type, name) \
-    __typeof__(type) per_cpu__##name
-
-#define DEFINE_PER_CPU_SHARED_ALIGNED(type, name)	\
-    DEFINE_PER_CPU(type, name)
-
-#define per_cpu(var, cpu)			(*((void)(cpu), &per_cpu__##var))
-#define __get_cpu_var(var)			per_cpu__##var
-#define __raw_get_cpu_var(var)			per_cpu__##var
+#define per_cpu(var, cpu)			(*((void)(cpu), &per_cpu_var(var)))
+#define __get_cpu_var(var)			per_cpu_var(var)
+#define __raw_get_cpu_var(var)			per_cpu_var(var)
 
 #endif	/* SMP */
 
-#define DECLARE_PER_CPU(type, name) extern __typeof__(type) per_cpu__##name
+#ifndef PER_CPU_ATTRIBUTES
+#define PER_CPU_ATTRIBUTES
+#endif
 
-#define EXPORT_PER_CPU_SYMBOL(var) EXPORT_SYMBOL(per_cpu__##var)
-#define EXPORT_PER_CPU_SYMBOL_GPL(var) EXPORT_SYMBOL_GPL(per_cpu__##var)
+#define DECLARE_PER_CPU(type, name) extern PER_CPU_ATTRIBUTES \
+					__typeof__(type) per_cpu_var(name)
 
 #endif /* _ASM_GENERIC_PERCPU_H_ */
Index: linux-x86.q/include/asm-generic/sections.h
===================================================================
--- linux-x86.q.orig/include/asm-generic/sections.h
+++ linux-x86.q/include/asm-generic/sections.h
@@ -11,7 +11,17 @@ extern char _sinittext[], _einittext[];
 extern char _sextratext[] __attribute__((weak));
 extern char _eextratext[] __attribute__((weak));
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
Index: linux-x86.q/include/asm-generic/vmlinux.lds.h
===================================================================
--- linux-x86.q.orig/include/asm-generic/vmlinux.lds.h
+++ linux-x86.q/include/asm-generic/vmlinux.lds.h
@@ -255,11 +255,27 @@
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
 	.data.percpu  : AT(ADDR(.data.percpu) - LOAD_OFFSET) {		\
+		*(.data.percpu.first)					\
 		*(.data.percpu)						\
 		*(.data.percpu.shared_aligned)				\
 	}								\
 	__per_cpu_end = .;
+#endif
Index: linux-x86.q/include/asm-ia64/percpu.h
===================================================================
--- linux-x86.q.orig/include/asm-ia64/percpu.h
+++ linux-x86.q/include/asm-ia64/percpu.h
@@ -12,31 +12,10 @@
 # define THIS_CPU(var)	(per_cpu__##var)  /* use this to mark accesses to per-CPU variables... */
 #else /* !__ASSEMBLY__ */
 
-
 #include <linux/threads.h>
 
 #ifdef HAVE_MODEL_SMALL_ATTRIBUTE
-# define __SMALL_ADDR_AREA	__attribute__((__model__ (__small__)))
-#else
-# define __SMALL_ADDR_AREA
-#endif
-
-#define DECLARE_PER_CPU(type, name)				\
-	extern __SMALL_ADDR_AREA __typeof__(type) per_cpu__##name
-
-/* Separate out the type, so (int[3], foo) works. */
-#define DEFINE_PER_CPU(type, name)				\
-	__attribute__((__section__(".data.percpu")))		\
-	__SMALL_ADDR_AREA __typeof__(type) per_cpu__##name
-
-#ifdef CONFIG_SMP
-#define DEFINE_PER_CPU_SHARED_ALIGNED(type, name)			\
-	__attribute__((__section__(".data.percpu.shared_aligned")))	\
-	__SMALL_ADDR_AREA __typeof__(type) per_cpu__##name		\
-	____cacheline_aligned_in_smp
-#else
-#define DEFINE_PER_CPU_SHARED_ALIGNED(type, name)	\
-	DEFINE_PER_CPU(type, name)
+# define PER_CPU_ATTRIBUTES	__attribute__((__model__ (__small__)))
 #endif
 
 /*
@@ -45,39 +24,29 @@
  */
 #ifdef CONFIG_SMP
 
-extern unsigned long __per_cpu_offset[NR_CPUS];
-#define per_cpu_offset(x) (__per_cpu_offset[x])
-
-/* Equal to __per_cpu_offset[smp_processor_id()], but faster to access: */
-DECLARE_PER_CPU(unsigned long, local_per_cpu_offset);
-
-#define per_cpu(var, cpu)  (*RELOC_HIDE(&per_cpu__##var, __per_cpu_offset[cpu]))
-#define __get_cpu_var(var) (*RELOC_HIDE(&per_cpu__##var, __ia64_per_cpu_var(local_per_cpu_offset)))
-#define __raw_get_cpu_var(var) (*RELOC_HIDE(&per_cpu__##var, __ia64_per_cpu_var(local_per_cpu_offset)))
+#define __my_cpu_offset	__ia64_per_cpu_var(local_per_cpu_offset)
 
 extern void percpu_modcopy(void *pcpudst, const void *src, unsigned long size);
-extern void setup_per_cpu_areas (void);
 extern void *per_cpu_init(void);
 
 #else /* ! SMP */
 
-#define per_cpu(var, cpu)			(*((void)(cpu), &per_cpu__##var))
-#define __get_cpu_var(var)			per_cpu__##var
-#define __raw_get_cpu_var(var)			per_cpu__##var
 #define per_cpu_init()				(__phys_per_cpu_start)
 
 #endif	/* SMP */
 
-#define EXPORT_PER_CPU_SYMBOL(var)		EXPORT_SYMBOL(per_cpu__##var)
-#define EXPORT_PER_CPU_SYMBOL_GPL(var)		EXPORT_SYMBOL_GPL(per_cpu__##var)
-
 /*
  * Be extremely careful when taking the address of this variable!  Due to virtual
  * remapping, it is different from the canonical address returned by __get_cpu_var(var)!
  * On the positive side, using __ia64_per_cpu_var() instead of __get_cpu_var() is slightly
  * more efficient.
  */
-#define __ia64_per_cpu_var(var)	(per_cpu__##var)
+#define __ia64_per_cpu_var(var)	per_cpu__##var
+
+#include <asm-generic/percpu.h>
+
+/* Equal to __per_cpu_offset[smp_processor_id()], but faster to access: */
+DECLARE_PER_CPU(unsigned long, local_per_cpu_offset);
 
 #endif /* !__ASSEMBLY__ */
 
Index: linux-x86.q/include/asm-powerpc/percpu.h
===================================================================
--- linux-x86.q.orig/include/asm-powerpc/percpu.h
+++ linux-x86.q/include/asm-powerpc/percpu.h
@@ -16,20 +16,6 @@
 #define __my_cpu_offset() get_paca()->data_offset
 #define per_cpu_offset(x) (__per_cpu_offset(x))
 
-/* Separate out the type, so (int[3], foo) works. */
-#define DEFINE_PER_CPU(type, name) \
-    __attribute__((__section__(".data.percpu"))) __typeof__(type) per_cpu__##name
-
-#define DEFINE_PER_CPU_SHARED_ALIGNED(type, name)		\
-    __attribute__((__section__(".data.percpu.shared_aligned"))) \
-    __typeof__(type) per_cpu__##name				\
-    ____cacheline_aligned_in_smp
-
-/* var is in discarded region: offset to particular copy we want */
-#define per_cpu(var, cpu) (*RELOC_HIDE(&per_cpu__##var, __per_cpu_offset(cpu)))
-#define __get_cpu_var(var) (*RELOC_HIDE(&per_cpu__##var, __my_cpu_offset()))
-#define __raw_get_cpu_var(var) (*RELOC_HIDE(&per_cpu__##var, local_paca->data_offset))
-
 /* A macro to avoid #include hell... */
 #define percpu_modcopy(pcpudst, src, size)			\
 do {								\
@@ -39,28 +25,7 @@ do {								\
 		       (src), (size));				\
 } while (0)
 
-extern void setup_per_cpu_areas(void);
-
-#else /* ! SMP */
-
-#define DEFINE_PER_CPU(type, name) \
-    __typeof__(type) per_cpu__##name
-#define DEFINE_PER_CPU_SHARED_ALIGNED(type, name)	\
-    DEFINE_PER_CPU(type, name)
-
-#define per_cpu(var, cpu)			(*((void)(cpu), &per_cpu__##var))
-#define __get_cpu_var(var)			per_cpu__##var
-#define __raw_get_cpu_var(var)			per_cpu__##var
-
 #endif	/* SMP */
-
-#define DECLARE_PER_CPU(type, name) extern __typeof__(type) per_cpu__##name
-
-#define EXPORT_PER_CPU_SYMBOL(var) EXPORT_SYMBOL(per_cpu__##var)
-#define EXPORT_PER_CPU_SYMBOL_GPL(var) EXPORT_SYMBOL_GPL(per_cpu__##var)
-
-#else
-#include <asm-generic/percpu.h>
 #endif
-
+#include <asm-generic/percpu.h>
 #endif /* _ASM_POWERPC_PERCPU_H_ */
Index: linux-x86.q/include/asm-s390/percpu.h
===================================================================
--- linux-x86.q.orig/include/asm-s390/percpu.h
+++ linux-x86.q/include/asm-s390/percpu.h
@@ -4,8 +4,6 @@
 #include <linux/compiler.h>
 #include <asm/lowcore.h>
 
-#define __GENERIC_PER_CPU
-
 /*
  * s390 uses its own implementation for per cpu data, the offset of
  * the cpu local data area is cached in the cpu's lowcore memory.
@@ -15,41 +13,24 @@
  */
 #if defined(__s390x__) && defined(MODULE)
 
-#define __reloc_hide(var,offset) (*({			\
+#define SHIFT_PTR(ptr,offset) (({			\
 	extern int simple_identifier_##var(void);	\
 	unsigned long *__ptr;				\
-	asm ( "larl %0,per_cpu__"#var"@GOTENT"		\
-	    : "=a" (__ptr) : "X" (per_cpu__##var) );	\
-	(typeof(&per_cpu__##var))((*__ptr) + (offset));	}))
+	asm ( "larl %0, %1@GOTENT"		\
+	    : "=a" (__ptr) : "X" (ptr) );		\
+	(typeof(ptr))((*__ptr) + (offset));	}))
 
 #else
 
-#define __reloc_hide(var, offset) (*({				\
+#define SHIFT_PTR(ptr, offset) (({				\
 	extern int simple_identifier_##var(void);		\
 	unsigned long __ptr;					\
-	asm ( "" : "=a" (__ptr) : "0" (&per_cpu__##var) );	\
-	(typeof(&per_cpu__##var)) (__ptr + (offset)); }))
+	asm ( "" : "=a" (__ptr) : "0" (ptr) );			\
+	(typeof(ptr)) (__ptr + (offset)); }))
 
 #endif
 
-#ifdef CONFIG_SMP
-
-extern unsigned long __per_cpu_offset[NR_CPUS];
-
-/* Separate out the type, so (int[3], foo) works. */
-#define DEFINE_PER_CPU(type, name) \
-    __attribute__((__section__(".data.percpu"))) \
-    __typeof__(type) per_cpu__##name
-
-#define DEFINE_PER_CPU_SHARED_ALIGNED(type, name)		\
-    __attribute__((__section__(".data.percpu.shared_aligned"))) \
-    __typeof__(type) per_cpu__##name				\
-    ____cacheline_aligned_in_smp
-
-#define __get_cpu_var(var) __reloc_hide(var,S390_lowcore.percpu_offset)
-#define __raw_get_cpu_var(var) __reloc_hide(var,S390_lowcore.percpu_offset)
-#define per_cpu(var,cpu) __reloc_hide(var,__per_cpu_offset[cpu])
-#define per_cpu_offset(x) (__per_cpu_offset[x])
+#define __my_cpu_offset S390_lowcore.percpu_offset
 
 /* A macro to avoid #include hell... */
 #define percpu_modcopy(pcpudst, src, size)			\
@@ -60,22 +41,6 @@ do {								\
 		       (src), (size));				\
 } while (0)
 
-#else /* ! SMP */
-
-#define DEFINE_PER_CPU(type, name) \
-    __typeof__(type) per_cpu__##name
-#define DEFINE_PER_CPU_SHARED_ALIGNED(type, name)	\
-    DEFINE_PER_CPU(type, name)
-
-#define __get_cpu_var(var) __reloc_hide(var,0)
-#define __raw_get_cpu_var(var) __reloc_hide(var,0)
-#define per_cpu(var,cpu) __reloc_hide(var,0)
-
-#endif /* SMP */
-
-#define DECLARE_PER_CPU(type, name) extern __typeof__(type) per_cpu__##name
-
-#define EXPORT_PER_CPU_SYMBOL(var) EXPORT_SYMBOL(per_cpu__##var)
-#define EXPORT_PER_CPU_SYMBOL_GPL(var) EXPORT_SYMBOL_GPL(per_cpu__##var)
+#include <asm-generic/percpu.h>
 
 #endif /* __ARCH_S390_PERCPU__ */
Index: linux-x86.q/include/asm-sparc64/percpu.h
===================================================================
--- linux-x86.q.orig/include/asm-sparc64/percpu.h
+++ linux-x86.q/include/asm-sparc64/percpu.h
@@ -7,7 +7,6 @@ register unsigned long __local_per_cpu_o
 
 #ifdef CONFIG_SMP
 
-#define setup_per_cpu_areas()			do { } while (0)
 extern void real_setup_per_cpu_areas(void);
 
 extern unsigned long __per_cpu_base;
@@ -16,15 +15,6 @@ extern unsigned long __per_cpu_shift;
 	(__per_cpu_base + ((unsigned long)(__cpu) << __per_cpu_shift))
 #define per_cpu_offset(x) (__per_cpu_offset(x))
 
-/* Separate out the type, so (int[3], foo) works. */
-#define DEFINE_PER_CPU(type, name) \
-    __attribute__((__section__(".data.percpu"))) __typeof__(type) per_cpu__##name
-
-#define DEFINE_PER_CPU_SHARED_ALIGNED(type, name)		\
-    __attribute__((__section__(".data.percpu.shared_aligned"))) \
-    __typeof__(type) per_cpu__##name				\
-    ____cacheline_aligned_in_smp
-
 /* var is in discarded region: offset to particular copy we want */
 #define per_cpu(var, cpu) (*RELOC_HIDE(&per_cpu__##var, __per_cpu_offset(cpu)))
 #define __get_cpu_var(var) (*RELOC_HIDE(&per_cpu__##var, __local_per_cpu_offset))
@@ -41,10 +31,6 @@ do {								\
 #else /* ! SMP */
 
 #define real_setup_per_cpu_areas()		do { } while (0)
-#define DEFINE_PER_CPU(type, name) \
-    __typeof__(type) per_cpu__##name
-#define DEFINE_PER_CPU_SHARED_ALIGNED(type, name)	\
-    DEFINE_PER_CPU(type, name)
 
 #define per_cpu(var, cpu)			(*((void)cpu, &per_cpu__##var))
 #define __get_cpu_var(var)			per_cpu__##var
@@ -54,7 +40,4 @@ do {								\
 
 #define DECLARE_PER_CPU(type, name) extern __typeof__(type) per_cpu__##name
 
-#define EXPORT_PER_CPU_SYMBOL(var) EXPORT_SYMBOL(per_cpu__##var)
-#define EXPORT_PER_CPU_SYMBOL_GPL(var) EXPORT_SYMBOL_GPL(per_cpu__##var)
-
 #endif /* __ARCH_SPARC64_PERCPU__ */
Index: linux-x86.q/include/asm-x86/pda.h
===================================================================
--- linux-x86.q.orig/include/asm-x86/pda.h
+++ linux-x86.q/include/asm-x86/pda.h
@@ -39,7 +39,6 @@ struct x8664_pda {
 } ____cacheline_aligned_in_smp;
 
 extern struct x8664_pda *_cpu_pda[];
-extern struct x8664_pda boot_cpu_pda[];
 extern void pda_init(int);
 
 #define cpu_pda(i) (_cpu_pda[i])
Index: linux-x86.q/include/asm-x86/percpu.h
===================================================================
--- linux-x86.q.orig/include/asm-x86/percpu.h
+++ linux-x86.q/include/asm-x86/percpu.h
@@ -1,5 +1,152 @@
-#ifdef CONFIG_X86_32
-# include "percpu_32.h"
+#ifndef _ASM_X86_PERCPU_H_
+#define _ASM_X86_PERCPU_H_
+
+#ifdef CONFIG_X86_64
+#include <linux/compiler.h>
+
+/* Same as asm-generic/percpu.h, except that we store the per cpu offset
+   in the PDA. Longer term the PDA and every per cpu variable
+   should be just put into a single section and referenced directly
+   from %gs */
+
+#ifdef CONFIG_SMP
+#include <asm/pda.h>
+
+#define __per_cpu_offset(cpu) (cpu_pda(cpu)->data_offset)
+#define __my_cpu_offset read_pda(data_offset)
+
+#define per_cpu_offset(x) (__per_cpu_offset(x))
+
+#define __percpu_seg "%%gs:"
+
 #else
-# include "percpu_64.h"
+
+#define __percpu_seg ""
+
 #endif
+#include <asm-generic/percpu.h>
+
+DECLARE_PER_CPU(struct x8664_pda, pda);
+
+#else /* CONFIG_X86_64 */
+
+#ifdef __ASSEMBLY__
+
+/*
+ * PER_CPU finds an address of a per-cpu variable.
+ *
+ * Args:
+ *    var - variable name
+ *    reg - 32bit register
+ *
+ * The resulting address is stored in the "reg" argument.
+ *
+ * Example:
+ *    PER_CPU(cpu_gdt_descr, %ebx)
+ */
+#ifdef CONFIG_SMP
+#define PER_CPU(var, reg)				\
+	movl %fs:per_cpu__##this_cpu_off, reg;		\
+	lea per_cpu__##var(reg), reg
+#define PER_CPU_VAR(var)	%fs:per_cpu__##var
+#else /* ! SMP */
+#define PER_CPU(var, reg)			\
+	movl $per_cpu__##var, reg
+#define PER_CPU_VAR(var)	per_cpu__##var
+#endif	/* SMP */
+
+#else /* ...!ASSEMBLY */
+
+/*
+ * PER_CPU finds an address of a per-cpu variable.
+ *
+ * Args:
+ *    var - variable name
+ *    cpu - 32bit register containing the current CPU number
+ *
+ * The resulting address is stored in the "cpu" argument.
+ *
+ * Example:
+ *    PER_CPU(cpu_gdt_descr, %ebx)
+ */
+#ifdef CONFIG_SMP
+
+#define __my_cpu_offset x86_read_percpu(this_cpu_off)
+
+/* fs segment starts at (positive) offset == __per_cpu_offset[cpu] */
+#define __percpu_seg "%%fs:"
+
+#else  /* !SMP */
+
+#define __percpu_seg ""
+
+#endif	/* SMP */
+
+#include <asm-generic/percpu.h>
+
+/* We can use this directly for local CPU (faster). */
+DECLARE_PER_CPU(unsigned long, this_cpu_off);
+
+#endif /* __ASSEMBLY__ */
+#endif /* !CONFIG_X86_64 */
+
+#ifndef __ASSEMBLY__
+
+/* For arch-specific code, we can use direct single-insn ops (they
+ * don't give an lvalue though). */
+extern void __bad_percpu_size(void);
+
+#define percpu_to_op(op,var,val)				\
+	do {							\
+		typedef typeof(var) T__;			\
+		if (0) { T__ tmp__; tmp__ = (val); }		\
+		switch (sizeof(var)) {				\
+		case 1:						\
+			asm(op "b %1,"__percpu_seg"%0"		\
+			    : "+m" (var)			\
+			    :"ri" ((T__)val));			\
+			break;					\
+		case 2:						\
+			asm(op "w %1,"__percpu_seg"%0"		\
+			    : "+m" (var)			\
+			    :"ri" ((T__)val));			\
+			break;					\
+		case 4:						\
+			asm(op "l %1,"__percpu_seg"%0"		\
+			    : "+m" (var)			\
+			    :"ri" ((T__)val));			\
+			break;					\
+		default: __bad_percpu_size();			\
+		}						\
+	} while (0)
+
+#define percpu_from_op(op,var)					\
+	({							\
+		typeof(var) ret__;				\
+		switch (sizeof(var)) {				\
+		case 1:						\
+			asm(op "b "__percpu_seg"%1,%0"		\
+			    : "=r" (ret__)			\
+			    : "m" (var));			\
+			break;					\
+		case 2:						\
+			asm(op "w "__percpu_seg"%1,%0"		\
+			    : "=r" (ret__)			\
+			    : "m" (var));			\
+			break;					\
+		case 4:						\
+			asm(op "l "__percpu_seg"%1,%0"		\
+			    : "=r" (ret__)			\
+			    : "m" (var));			\
+			break;					\
+		default: __bad_percpu_size();			\
+		}						\
+		ret__; })
+
+#define x86_read_percpu(var) percpu_from_op("mov", per_cpu__##var)
+#define x86_write_percpu(var,val) percpu_to_op("mov", per_cpu__##var, val)
+#define x86_add_percpu(var,val) percpu_to_op("add", per_cpu__##var, val)
+#define x86_sub_percpu(var,val) percpu_to_op("sub", per_cpu__##var, val)
+#define x86_or_percpu(var,val) percpu_to_op("or", per_cpu__##var, val)
+#endif /* !__ASSEMBLY__ */
+#endif /* _ASM_X86_PERCPU_H_ */
Index: linux-x86.q/include/asm-x86/percpu_32.h
===================================================================
--- linux-x86.q.orig/include/asm-x86/percpu_32.h
+++ /dev/null
@@ -1,154 +0,0 @@
-#ifndef __ARCH_I386_PERCPU__
-#define __ARCH_I386_PERCPU__
-
-#ifdef __ASSEMBLY__
-
-/*
- * PER_CPU finds an address of a per-cpu variable.
- *
- * Args:
- *    var - variable name
- *    reg - 32bit register
- *
- * The resulting address is stored in the "reg" argument.
- *
- * Example:
- *    PER_CPU(cpu_gdt_descr, %ebx)
- */
-#ifdef CONFIG_SMP
-#define PER_CPU(var, reg)				\
-	movl %fs:per_cpu__##this_cpu_off, reg;		\
-	lea per_cpu__##var(reg), reg
-#define PER_CPU_VAR(var)	%fs:per_cpu__##var
-#else /* ! SMP */
-#define PER_CPU(var, reg)			\
-	movl $per_cpu__##var, reg
-#define PER_CPU_VAR(var)	per_cpu__##var
-#endif	/* SMP */
-
-#else /* ...!ASSEMBLY */
-
-/*
- * PER_CPU finds an address of a per-cpu variable.
- *
- * Args:
- *    var - variable name
- *    cpu - 32bit register containing the current CPU number
- *
- * The resulting address is stored in the "cpu" argument.
- *
- * Example:
- *    PER_CPU(cpu_gdt_descr, %ebx)
- */
-#ifdef CONFIG_SMP
-/* Same as generic implementation except for optimized local access. */
-#define __GENERIC_PER_CPU
-
-/* This is used for other cpus to find our section. */
-extern unsigned long __per_cpu_offset[];
-
-#define per_cpu_offset(x) (__per_cpu_offset[x])
-
-/* Separate out the type, so (int[3], foo) works. */
-#define DECLARE_PER_CPU(type, name) extern __typeof__(type) per_cpu__##name
-#define DEFINE_PER_CPU(type, name) \
-    __attribute__((__section__(".data.percpu"))) __typeof__(type) per_cpu__##name
-
-#define DEFINE_PER_CPU_SHARED_ALIGNED(type, name)		\
-    __attribute__((__section__(".data.percpu.shared_aligned"))) \
-    __typeof__(type) per_cpu__##name				\
-    ____cacheline_aligned_in_smp
-
-/* We can use this directly for local CPU (faster). */
-DECLARE_PER_CPU(unsigned long, this_cpu_off);
-
-/* var is in discarded region: offset to particular copy we want */
-#define per_cpu(var, cpu) (*({				\
-	extern int simple_indentifier_##var(void);	\
-	RELOC_HIDE(&per_cpu__##var, __per_cpu_offset[cpu]); }))
-
-#define __raw_get_cpu_var(var) (*({					\
-	extern int simple_indentifier_##var(void);			\
-	RELOC_HIDE(&per_cpu__##var, x86_read_percpu(this_cpu_off));	\
-}))
-
-#define __get_cpu_var(var) __raw_get_cpu_var(var)
-
-/* A macro to avoid #include hell... */
-#define percpu_modcopy(pcpudst, src, size)			\
-do {								\
-	unsigned int __i;					\
-	for_each_possible_cpu(__i)				\
-		memcpy((pcpudst)+__per_cpu_offset[__i],		\
-		       (src), (size));				\
-} while (0)
-
-#define EXPORT_PER_CPU_SYMBOL(var) EXPORT_SYMBOL(per_cpu__##var)
-#define EXPORT_PER_CPU_SYMBOL_GPL(var) EXPORT_SYMBOL_GPL(per_cpu__##var)
-
-/* fs segment starts at (positive) offset == __per_cpu_offset[cpu] */
-#define __percpu_seg "%%fs:"
-#else  /* !SMP */
-#include <asm-generic/percpu.h>
-#define __percpu_seg ""
-#endif	/* SMP */
-
-/* For arch-specific code, we can use direct single-insn ops (they
- * don't give an lvalue though). */
-extern void __bad_percpu_size(void);
-
-#define percpu_to_op(op,var,val)				\
-	do {							\
-		typedef typeof(var) T__;			\
-		if (0) { T__ tmp__; tmp__ = (val); }		\
-		switch (sizeof(var)) {				\
-		case 1:						\
-			asm(op "b %1,"__percpu_seg"%0"		\
-			    : "+m" (var)			\
-			    :"ri" ((T__)val));			\
-			break;					\
-		case 2:						\
-			asm(op "w %1,"__percpu_seg"%0"		\
-			    : "+m" (var)			\
-			    :"ri" ((T__)val));			\
-			break;					\
-		case 4:						\
-			asm(op "l %1,"__percpu_seg"%0"		\
-			    : "+m" (var)			\
-			    :"ri" ((T__)val));			\
-			break;					\
-		default: __bad_percpu_size();			\
-		}						\
-	} while (0)
-
-#define percpu_from_op(op,var)					\
-	({							\
-		typeof(var) ret__;				\
-		switch (sizeof(var)) {				\
-		case 1:						\
-			asm(op "b "__percpu_seg"%1,%0"		\
-			    : "=r" (ret__)			\
-			    : "m" (var));			\
-			break;					\
-		case 2:						\
-			asm(op "w "__percpu_seg"%1,%0"		\
-			    : "=r" (ret__)			\
-			    : "m" (var));			\
-			break;					\
-		case 4:						\
-			asm(op "l "__percpu_seg"%1,%0"		\
-			    : "=r" (ret__)			\
-			    : "m" (var));			\
-			break;					\
-		default: __bad_percpu_size();			\
-		}						\
-		ret__; })
-
-#define x86_read_percpu(var) percpu_from_op("mov", per_cpu__##var)
-#define x86_write_percpu(var,val) percpu_to_op("mov", per_cpu__##var, val)
-#define x86_add_percpu(var,val) percpu_to_op("add", per_cpu__##var, val)
-#define x86_sub_percpu(var,val) percpu_to_op("sub", per_cpu__##var, val)
-#define x86_or_percpu(var,val) percpu_to_op("or", per_cpu__##var, val)
-#endif /* !__ASSEMBLY__ */
-
-#endif /* __ARCH_I386_PERCPU__ */
Index: linux-x86.q/include/asm-x86/percpu_64.h
===================================================================
--- linux-x86.q.orig/include/asm-x86/percpu_64.h
+++ /dev/null
@@ -1,68 +0,0 @@
-#ifndef _ASM_X8664_PERCPU_H_
-#define _ASM_X8664_PERCPU_H_
-#include <linux/compiler.h>
-
-/* Same as asm-generic/percpu.h, except that we store the per cpu offset
-   in the PDA. Longer term the PDA and every per cpu variable
-   should be just put into a single section and referenced directly
-   from %gs */
-
-#ifdef CONFIG_SMP
-
-#include <asm/pda.h>
-
-#define __per_cpu_offset(cpu) (cpu_pda(cpu)->data_offset)
-#define __my_cpu_offset() read_pda(data_offset)
-
-#define per_cpu_offset(x) (__per_cpu_offset(x))
-
-/* Separate out the type, so (int[3], foo) works. */
-#define DEFINE_PER_CPU(type, name) \
-    __attribute__((__section__(".data.percpu"))) __typeof__(type) per_cpu__##name
-
-#define DEFINE_PER_CPU_SHARED_ALIGNED(type, name)		\
-    __attribute__((__section__(".data.percpu.shared_aligned"))) \
-    __typeof__(type) per_cpu__##name				\
-    ____cacheline_internodealigned_in_smp
-
-/* var is in discarded region: offset to particular copy we want */
-#define per_cpu(var, cpu) (*({				\
-	extern int simple_identifier_##var(void);	\
-	RELOC_HIDE(&per_cpu__##var, __per_cpu_offset(cpu)); }))
-#define __get_cpu_var(var) (*({				\
-	extern int simple_identifier_##var(void);	\
-	RELOC_HIDE(&per_cpu__##var, __my_cpu_offset()); }))
-#define __raw_get_cpu_var(var) (*({			\
-	extern int simple_identifier_##var(void);	\
-	RELOC_HIDE(&per_cpu__##var, __my_cpu_offset()); }))
-
-/* A macro to avoid #include hell... */
-#define percpu_modcopy(pcpudst, src, size)			\
-do {								\
-	unsigned int __i;					\
-	for_each_possible_cpu(__i)				\
-		memcpy((pcpudst)+__per_cpu_offset(__i),		\
-		       (src), (size));				\
-} while (0)
-
-extern void setup_per_cpu_areas(void);
-
-#else /* ! SMP */
-
-#define DEFINE_PER_CPU(type, name) \
-    __typeof__(type) per_cpu__##name
-#define DEFINE_PER_CPU_SHARED_ALIGNED(type, name)	\
-    DEFINE_PER_CPU(type, name)
-
-#define per_cpu(var, cpu)			(*((void)(cpu), &per_cpu__##var))
-#define __get_cpu_var(var)			per_cpu__##var
-#define __raw_get_cpu_var(var)			per_cpu__##var
-
-#endif	/* SMP */
-
-#define DECLARE_PER_CPU(type, name) extern __typeof__(type) per_cpu__##name
-
-#define EXPORT_PER_CPU_SYMBOL(var) EXPORT_SYMBOL(per_cpu__##var)
-#define EXPORT_PER_CPU_SYMBOL_GPL(var) EXPORT_SYMBOL_GPL(per_cpu__##var)
-
-#endif /* _ASM_X8664_PERCPU_H_ */
Index: linux-x86.q/include/linux/percpu.h
===================================================================
--- linux-x86.q.orig/include/linux/percpu.h
+++ linux-x86.q/include/linux/percpu.h
@@ -9,6 +9,27 @@
 
 #include <asm/percpu.h>
 
+#define DEFINE_PER_CPU(type, name)					\
+	__attribute__((__section__(".data.percpu")))			\
+	PER_CPU_ATTRIBUTES __typeof__(type) per_cpu__##name
+
+#ifdef CONFIG_SMP
+#define DEFINE_PER_CPU_SHARED_ALIGNED(type, name)			\
+	__attribute__((__section__(".data.percpu.shared_aligned")))	\
+	PER_CPU_ATTRIBUTES __typeof__(type) per_cpu__##name		\
+	____cacheline_aligned_in_smp
+#else
+#define DEFINE_PER_CPU_SHARED_ALIGNED(type, name)		      \
+	DEFINE_PER_CPU(type, name)
+#endif
+
+#define DEFINE_PER_CPU_FIRST(type, name)				\
+	__attribute__((__section__(".data.percpu.first")))		\
+	PER_CPU_ATTRIBUTES __typeof__(type) per_cpu__##name
+
+#define EXPORT_PER_CPU_SYMBOL(var) EXPORT_SYMBOL(per_cpu__##var)
+#define EXPORT_PER_CPU_SYMBOL_GPL(var) EXPORT_SYMBOL_GPL(per_cpu__##var)
+
 /* Enough to cover all DEFINE_PER_CPUs in kernel, including modules. */
 #ifndef PERCPU_ENOUGH_ROOM
 #ifdef CONFIG_MODULES
Index: linux-x86.q/init/main.c
===================================================================
--- linux-x86.q.orig/init/main.c
+++ linux-x86.q/init/main.c
@@ -363,28 +363,29 @@ static inline void smp_prepare_cpus(unsi
 
 #else
 
-#ifdef __GENERIC_PER_CPU
+#ifndef CONFIG_ARCH_SETS_UP_PER_CPU_AREA
 unsigned long __per_cpu_offset[NR_CPUS] __read_mostly;
 
 EXPORT_SYMBOL(__per_cpu_offset);
 
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
-#endif /* !__GENERIC_PER_CPU */
+#endif /* CONFIG_ARCH_SETS_UP_CPU_AREA */
 
 /* Called by boot processor to activate the rest. */
 static void __init smp_init(void)
Index: linux-x86.q/kernel/lockdep.c
===================================================================
--- linux-x86.q.orig/kernel/lockdep.c
+++ linux-x86.q/kernel/lockdep.c
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
