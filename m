Return-Path: <linux-kernel-owner+w=401wt.eu-S1755616AbZAAAOT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755616AbZAAAOT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Dec 2008 19:14:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753526AbZAAANq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Dec 2008 19:13:46 -0500
Received: from an-out-0708.google.com ([209.85.132.240]:63091 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750933AbZAAANp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Dec 2008 19:13:45 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=M1DNz33x5kjXip2v6xYvBWyZzEfbZhd7Lxlj/f0YVRNfWeWsGeDZUHTfpf8wjhKXaE
         n0cG5QclT8nvOnLkIASdtd2lFb5Goj/9HXjhO7HuPYtle5vwvQP8nsvrixOIbM7cty1i
         BI3oBF6OsVzaUiPHDRfSZenUNA7A7MaKyyvsw=
From: Brian Gerst <brgerst@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Brian Gerst <brgerst@gmail.com>
Subject: [PATCH 1/4] x86-64: Convert the PDA to percpu.
Date: Wed, 31 Dec 2008 19:13:40 -0500
Message-Id: <1230768823-31037-2-git-send-email-brgerst@gmail.com>
X-Mailer: git-send-email 1.6.1.rc1
In-Reply-To: <1230768823-31037-1-git-send-email-brgerst@gmail.com>
References: <1230768823-31037-1-git-send-email-brgerst@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch makes the PDA a normal per-cpu variable, allowing the
removal of the special allocator code.  %gs still points to the
base of the PDA.

Tested on a dual-core AMD64 system.

Signed-off-by: Brian Gerst <brgerst@gmail.com>
---
 arch/x86/include/asm/pda.h     |    4 --
 arch/x86/include/asm/percpu.h  |    3 --
 arch/x86/include/asm/setup.h   |    1 -
 arch/x86/kernel/cpu/common.c   |    6 ++--
 arch/x86/kernel/dumpstack_64.c |    8 ++--
 arch/x86/kernel/head64.c       |   23 +------------
 arch/x86/kernel/irq.c          |    2 +-
 arch/x86/kernel/nmi.c          |    2 +-
 arch/x86/kernel/setup_percpu.c |   70 ++++++++--------------------------------
 arch/x86/kernel/smpboot.c      |   58 +--------------------------------
 arch/x86/xen/enlighten.c       |    2 +-
 arch/x86/xen/smp.c             |   12 +------
 12 files changed, 27 insertions(+), 164 deletions(-)

diff --git a/arch/x86/include/asm/pda.h b/arch/x86/include/asm/pda.h
index 2fbfff8..60e8d91 100644
--- a/arch/x86/include/asm/pda.h
+++ b/arch/x86/include/asm/pda.h
@@ -23,7 +23,6 @@ struct x8664_pda {
 #endif
 	char *irqstackptr;
 	short nodenumber;		/* number of current node (32k max) */
-	short in_bootmem;		/* pda lives in bootmem */
 	unsigned int __softirq_pending;
 	unsigned int __nmi_count;	/* number of NMI on this CPUs */
 	short mmu_state;
@@ -39,11 +38,8 @@ struct x8664_pda {
 	unsigned irq_spurious_count;
 } ____cacheline_aligned_in_smp;
 
-extern struct x8664_pda **_cpu_pda;
 extern void pda_init(int);
 
-#define cpu_pda(i) (_cpu_pda[i])
-
 /*
  * There is no fast way to get the base address of the PDA, all the accesses
  * have to mention %fs/%gs.  So it needs to be done this Torvaldian way.
diff --git a/arch/x86/include/asm/percpu.h b/arch/x86/include/asm/percpu.h
index ece7205..6f866fd 100644
--- a/arch/x86/include/asm/percpu.h
+++ b/arch/x86/include/asm/percpu.h
@@ -12,11 +12,8 @@
 #ifdef CONFIG_SMP
 #include <asm/pda.h>
 
-#define __per_cpu_offset(cpu) (cpu_pda(cpu)->data_offset)
 #define __my_cpu_offset read_pda(data_offset)
 
-#define per_cpu_offset(x) (__per_cpu_offset(x))
-
 #endif
 #include <asm-generic/percpu.h>
 
diff --git a/arch/x86/include/asm/setup.h b/arch/x86/include/asm/setup.h
index f12d372..b751aaf 100644
--- a/arch/x86/include/asm/setup.h
+++ b/arch/x86/include/asm/setup.h
@@ -93,7 +93,6 @@ extern unsigned long init_pg_tables_start;
 extern unsigned long init_pg_tables_end;
 
 #else
-void __init x86_64_init_pda(void);
 void __init x86_64_start_kernel(char *real_mode);
 void __init x86_64_start_reservations(char *real_mode_data);
 
diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index b9c9ea0..eaf404f 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -857,8 +857,8 @@ __setup("clearcpuid=", setup_disablecpuid);
 cpumask_t cpu_initialized __cpuinitdata = CPU_MASK_NONE;
 
 #ifdef CONFIG_X86_64
-struct x8664_pda **_cpu_pda __read_mostly;
-EXPORT_SYMBOL(_cpu_pda);
+DEFINE_PER_CPU_SHARED_ALIGNED(struct x8664_pda, pda);
+EXPORT_PER_CPU_SYMBOL(pda);
 
 struct desc_ptr idt_descr = { 256 * 16 - 1, (unsigned long) idt_table };
 
@@ -866,7 +866,7 @@ char boot_cpu_stack[IRQSTACKSIZE] __page_aligned_bss;
 
 void __cpuinit pda_init(int cpu)
 {
-	struct x8664_pda *pda = cpu_pda(cpu);
+	struct x8664_pda *pda = &per_cpu(pda, cpu);
 
 	/* Setup up data that may be needed in __get_free_pages early */
 	loadsegment(fs, 0);
diff --git a/arch/x86/kernel/dumpstack_64.c b/arch/x86/kernel/dumpstack_64.c
index 96a5db7..1098b21 100644
--- a/arch/x86/kernel/dumpstack_64.c
+++ b/arch/x86/kernel/dumpstack_64.c
@@ -163,7 +163,7 @@ void dump_trace(struct task_struct *task, struct pt_regs *regs,
 		const struct stacktrace_ops *ops, void *data)
 {
 	const unsigned cpu = get_cpu();
-	unsigned long *irqstack_end = (unsigned long *)cpu_pda(cpu)->irqstackptr;
+	unsigned long *irqstack_end = (unsigned long *)per_cpu(pda, cpu).irqstackptr;
 	unsigned used = 0;
 	struct thread_info *tinfo;
 
@@ -306,9 +306,9 @@ show_stack_log_lvl(struct task_struct *task, struct pt_regs *regs,
 	int i;
 	const int cpu = smp_processor_id();
 	unsigned long *irqstack_end =
-		(unsigned long *) (cpu_pda(cpu)->irqstackptr);
+		(unsigned long *) (per_cpu(pda, cpu).irqstackptr);
 	unsigned long *irqstack =
-		(unsigned long *) (cpu_pda(cpu)->irqstackptr - IRQSTACKSIZE);
+		(unsigned long *) (per_cpu(pda, cpu).irqstackptr - IRQSTACKSIZE);
 
 	/*
 	 * debugging aid: "show_stack(NULL, NULL);" prints the
@@ -374,7 +374,7 @@ void show_registers(struct pt_regs *regs)
 	int i;
 	unsigned long sp;
 	const int cpu = smp_processor_id();
-	struct task_struct *cur = cpu_pda(cpu)->pcurrent;
+	struct task_struct *cur = per_cpu(pda, cpu).pcurrent;
 
 	sp = regs->sp;
 	printk("CPU %d ", cpu);
diff --git a/arch/x86/kernel/head64.c b/arch/x86/kernel/head64.c
index d16084f..274e2a9 100644
--- a/arch/x86/kernel/head64.c
+++ b/arch/x86/kernel/head64.c
@@ -25,27 +25,6 @@
 #include <asm/e820.h>
 #include <asm/bios_ebda.h>
 
-/* boot cpu pda */
-static struct x8664_pda _boot_cpu_pda __read_mostly;
-
-#ifdef CONFIG_SMP
-/*
- * We install an empty cpu_pda pointer table to indicate to early users
- * (numa_set_node) that the cpu_pda pointer table for cpus other than
- * the boot cpu is not yet setup.
- */
-static struct x8664_pda *__cpu_pda[NR_CPUS] __initdata;
-#else
-static struct x8664_pda *__cpu_pda[NR_CPUS] __read_mostly;
-#endif
-
-void __init x86_64_init_pda(void)
-{
-	_cpu_pda = __cpu_pda;
-	cpu_pda(0) = &_boot_cpu_pda;
-	pda_init(0);
-}
-
 static void __init zap_identity_mappings(void)
 {
 	pgd_t *pgd = pgd_offset_k(0UL);
@@ -111,7 +90,7 @@ void __init x86_64_start_kernel(char * real_mode_data)
 	if (console_loglevel == 10)
 		early_printk("Kernel alive\n");
 
-	x86_64_init_pda();
+	pda_init(0);
 
 	x86_64_start_reservations(real_mode_data);
 }
diff --git a/arch/x86/kernel/irq.c b/arch/x86/kernel/irq.c
index d1d4dc5..066e680 100644
--- a/arch/x86/kernel/irq.c
+++ b/arch/x86/kernel/irq.c
@@ -38,7 +38,7 @@ void ack_bad_irq(unsigned int irq)
 #ifdef CONFIG_X86_32
 # define irq_stats(x)		(&per_cpu(irq_stat, x))
 #else
-# define irq_stats(x)		cpu_pda(x)
+# define irq_stats(x)		(&per_cpu(pda, x))
 #endif
 /*
  * /proc/interrupts printing:
diff --git a/arch/x86/kernel/nmi.c b/arch/x86/kernel/nmi.c
index 2c97f07..4a5bb40 100644
--- a/arch/x86/kernel/nmi.c
+++ b/arch/x86/kernel/nmi.c
@@ -64,7 +64,7 @@ static int endflag __initdata;
 static inline unsigned int get_nmi_count(int cpu)
 {
 #ifdef CONFIG_X86_64
-	return cpu_pda(cpu)->__nmi_count;
+	return per_cpu(pda, cpu).__nmi_count;
 #else
 	return nmi_count(cpu);
 #endif
diff --git a/arch/x86/kernel/setup_percpu.c b/arch/x86/kernel/setup_percpu.c
index ae0c0d3..fb0ccdc 100644
--- a/arch/x86/kernel/setup_percpu.c
+++ b/arch/x86/kernel/setup_percpu.c
@@ -80,58 +80,8 @@ static void __init setup_per_cpu_maps(void)
 #endif
 }
 
-#ifdef CONFIG_X86_32
-/*
- * Great future not-so-futuristic plan: make i386 and x86_64 do it
- * the same way
- */
 unsigned long __per_cpu_offset[NR_CPUS] __read_mostly;
 EXPORT_SYMBOL(__per_cpu_offset);
-static inline void setup_cpu_pda_map(void) { }
-
-#elif !defined(CONFIG_SMP)
-static inline void setup_cpu_pda_map(void) { }
-
-#else /* CONFIG_SMP && CONFIG_X86_64 */
-
-/*
- * Allocate cpu_pda pointer table and array via alloc_bootmem.
- */
-static void __init setup_cpu_pda_map(void)
-{
-	char *pda;
-	struct x8664_pda **new_cpu_pda;
-	unsigned long size;
-	int cpu;
-
-	size = roundup(sizeof(struct x8664_pda), cache_line_size());
-
-	/* allocate cpu_pda array and pointer table */
-	{
-		unsigned long tsize = nr_cpu_ids * sizeof(void *);
-		unsigned long asize = size * (nr_cpu_ids - 1);
-
-		tsize = roundup(tsize, cache_line_size());
-		new_cpu_pda = alloc_bootmem(tsize + asize);
-		pda = (char *)new_cpu_pda + tsize;
-	}
-
-	/* initialize pointer table to static pda's */
-	for_each_possible_cpu(cpu) {
-		if (cpu == 0) {
-			/* leave boot cpu pda in place */
-			new_cpu_pda[0] = cpu_pda(0);
-			continue;
-		}
-		new_cpu_pda[cpu] = (struct x8664_pda *)pda;
-		new_cpu_pda[cpu]->in_bootmem = 1;
-		pda += size;
-	}
-
-	/* point to new pointer table */
-	_cpu_pda = new_cpu_pda;
-}
-#endif
 
 /*
  * Great future plan:
@@ -145,9 +95,6 @@ void __init setup_per_cpu_areas(void)
 	int cpu;
 	unsigned long align = 1;
 
-	/* Setup cpu_pda map */
-	setup_cpu_pda_map();
-
 	/* Copy section for each CPU (we discard the original) */
 	old_size = PERCPU_ENOUGH_ROOM;
 	align = max_t(unsigned long, PAGE_SIZE, align);
@@ -179,10 +126,21 @@ void __init setup_per_cpu_areas(void)
 					 cpu, node, __pa(ptr));
 		}
 #endif
-		per_cpu_offset(cpu) = ptr - __per_cpu_start;
+		__per_cpu_offset[cpu] = ptr - __per_cpu_start;
 		memcpy(ptr, __per_cpu_start, __per_cpu_end - __per_cpu_start);
+#ifdef CONFIG_X86_64
+		if (cpu)
+			memset(&per_cpu(pda, cpu), 0, sizeof(struct x8664_pda));
+		per_cpu(pda, cpu).data_offset = __per_cpu_offset[cpu];
+#endif
 	}
 
+#ifdef CONFIG_X86_64
+	mb();
+	wrmsrl(MSR_GS_BASE, &per_cpu(pda, 0));
+	mb();
+#endif
+
 	printk(KERN_DEBUG "NR_CPUS: %d, nr_cpu_ids: %d, nr_node_ids %d\n",
 		NR_CPUS, nr_cpu_ids, nr_node_ids);
 
@@ -229,8 +187,8 @@ void __cpuinit numa_set_node(int cpu, int node)
 {
 	int *cpu_to_node_map = early_per_cpu_ptr(x86_cpu_to_node_map);
 
-	if (cpu_pda(cpu) && node != NUMA_NO_NODE)
-		cpu_pda(cpu)->nodenumber = node;
+	if (node != NUMA_NO_NODE)
+		per_cpu(pda, cpu).nodenumber = node;
 
 	if (cpu_to_node_map)
 		cpu_to_node_map[cpu] = node;
diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index f71f96f..d25b989 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -753,52 +753,6 @@ static void __cpuinit do_fork_idle(struct work_struct *work)
 	complete(&c_idle->done);
 }
 
-#ifdef CONFIG_X86_64
-
-/* __ref because it's safe to call free_bootmem when after_bootmem == 0. */
-static void __ref free_bootmem_pda(struct x8664_pda *oldpda)
-{
-	if (!after_bootmem)
-		free_bootmem((unsigned long)oldpda, sizeof(*oldpda));
-}
-
-/*
- * Allocate node local memory for the AP pda.
- *
- * Must be called after the _cpu_pda pointer table is initialized.
- */
-int __cpuinit get_local_pda(int cpu)
-{
-	struct x8664_pda *oldpda, *newpda;
-	unsigned long size = sizeof(struct x8664_pda);
-	int node = cpu_to_node(cpu);
-
-	if (cpu_pda(cpu) && !cpu_pda(cpu)->in_bootmem)
-		return 0;
-
-	oldpda = cpu_pda(cpu);
-	newpda = kmalloc_node(size, GFP_ATOMIC, node);
-	if (!newpda) {
-		printk(KERN_ERR "Could not allocate node local PDA "
-			"for CPU %d on node %d\n", cpu, node);
-
-		if (oldpda)
-			return 0;	/* have a usable pda */
-		else
-			return -1;
-	}
-
-	if (oldpda) {
-		memcpy(newpda, oldpda, size);
-		free_bootmem_pda(oldpda);
-	}
-
-	newpda->in_bootmem = 0;
-	cpu_pda(cpu) = newpda;
-	return 0;
-}
-#endif /* CONFIG_X86_64 */
-
 static int __cpuinit do_boot_cpu(int apicid, int cpu)
 /*
  * NOTE - on most systems this is a PHYSICAL apic ID, but on multiquad
@@ -816,16 +770,6 @@ static int __cpuinit do_boot_cpu(int apicid, int cpu)
 	};
 	INIT_WORK(&c_idle.work, do_fork_idle);
 
-#ifdef CONFIG_X86_64
-	/* Allocate node local memory for AP pdas */
-	if (cpu > 0) {
-		boot_error = get_local_pda(cpu);
-		if (boot_error)
-			goto restore_state;
-			/* if can't get pda memory, can't start cpu */
-	}
-#endif
-
 	alternatives_smp_switch(1);
 
 	c_idle.idle = get_idle_for_cpu(cpu);
@@ -861,7 +805,7 @@ do_rest:
 	/* Stack for startup_32 can be just as for start_secondary onwards */
 	irq_ctx_init(cpu);
 #else
-	cpu_pda(cpu)->pcurrent = c_idle.idle;
+	per_cpu(pda, cpu).pcurrent = c_idle.idle;
 	clear_tsk_thread_flag(c_idle.idle, TIF_FORK);
 #endif
 	early_gdt_descr.address = (unsigned long)get_cpu_gdt_table(cpu);
diff --git a/arch/x86/xen/enlighten.c b/arch/x86/xen/enlighten.c
index 5e4686d..0160bb6 100644
--- a/arch/x86/xen/enlighten.c
+++ b/arch/x86/xen/enlighten.c
@@ -1649,7 +1649,7 @@ asmlinkage void __init xen_start_kernel(void)
 #ifdef CONFIG_X86_64
 	/* Disable until direct per-cpu data access. */
 	have_vcpu_info_placement = 0;
-	x86_64_init_pda();
+	pda_init(0);
 #endif
 
 	xen_smp_init();
diff --git a/arch/x86/xen/smp.c b/arch/x86/xen/smp.c
index acd9b67..17823cb 100644
--- a/arch/x86/xen/smp.c
+++ b/arch/x86/xen/smp.c
@@ -280,22 +280,12 @@ static int __cpuinit xen_cpu_up(unsigned int cpu)
 	struct task_struct *idle = idle_task(cpu);
 	int rc;
 
-#ifdef CONFIG_X86_64
-	/* Allocate node local memory for AP pdas */
-	WARN_ON(cpu == 0);
-	if (cpu > 0) {
-		rc = get_local_pda(cpu);
-		if (rc)
-			return rc;
-	}
-#endif
-
 #ifdef CONFIG_X86_32
 	init_gdt(cpu);
 	per_cpu(current_task, cpu) = idle;
 	irq_ctx_init(cpu);
 #else
-	cpu_pda(cpu)->pcurrent = idle;
+	per_cpu(pda, cpu).pcurrent = idle;
 	clear_tsk_thread_flag(idle, TIF_FORK);
 #endif
 	xen_setup_timer(cpu);
-- 
1.6.1.rc1

