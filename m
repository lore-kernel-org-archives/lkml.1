Return-Path: <linux-kernel-owner+w=401wt.eu-S1759093AbYFMPHf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759093AbYFMPHf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2008 11:07:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756107AbYFMPH2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jun 2008 11:07:28 -0400
Received: from mx1.redhat.com ([66.187.233.31]:48165 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756097AbYFMPHZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2008 11:07:25 -0400
Date: Fri, 13 Jun 2008 11:07:03 -0400
Message-Id: <200806131507.m5DF73Q7005595@pobox-2.corp.redhat.com>
From: Glauber Costa <gcosta@redhat.com>
To: mingo@elte.hu, tglx@linutronix.de, linux-kernel@vger.kernel.org
Subject: improved smpboot integration
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo, please pull the latest master git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/glommer/linux-2.6-integration.git master

into your tip/master tree

It contains cleanups to the smpboot process already discussed by e-mail at http://lkml.org/lkml/2008/6/9/183


Thanks!

	Glauber

------------------>
Glauber Costa (13):
      x86: use stack_start in x86_64
      x86: don't use gdt_page openly.
      x86: move x86_64 gdt closer to i386
      x86: use initial_code for i386
      x86: boot secondary cpus through initial_code
      x86: clearing io_apic harmless for x86_64
      x86: remove ifdef from stepping
      x86: change __setup_vector_irq with setup_vector_irq
      x86: provide connect_bsp_APIC for x86_64
      x86: change naming to match x86_64
      x86: remove cpu from maps
      x86: move cpu_exit_clear to process_32.c
      x86: take load_sp0 out of smpboot.c

 arch/x86/kernel/acpi/sleep.c     |    2 +-
 arch/x86/kernel/apic_64.c        |   10 ++++
 arch/x86/kernel/head_32.S        |    7 ++-
 arch/x86/kernel/head_64.S        |   53 +++-------------------
 arch/x86/kernel/io_apic_32.c     |    5 ++
 arch/x86/kernel/io_apic_64.c     |    9 +++-
 arch/x86/kernel/process_32.c     |   16 +++++++
 arch/x86/kernel/setup64.c        |    6 +--
 arch/x86/kernel/setup_64.c       |   27 +++++++++++
 arch/x86/kernel/smpboot.c        |   91 ++++---------------------------------
 arch/x86/kernel/traps_32.c       |    2 +-
 arch/x86/kernel/x8664_ksyms_64.c |    5 --
 include/asm-x86/desc.h           |   24 ++++------
 include/asm-x86/hw_irq.h         |    2 +-
 include/asm-x86/numa_32.h        |    1 +
 include/asm-x86/segment.h        |   23 +++++-----
 include/asm-x86/smp.h            |    1 -
 17 files changed, 117 insertions(+), 167 deletions(-)

diff --git a/arch/x86/kernel/acpi/sleep.c b/arch/x86/kernel/acpi/sleep.c
index afc25ee..0103af2 100644
--- a/arch/x86/kernel/acpi/sleep.c
+++ b/arch/x86/kernel/acpi/sleep.c
@@ -72,7 +72,7 @@ int acpi_save_state_mem(void)
 	saved_magic = 0x12345678;
 #else /* CONFIG_64BIT */
 	header->trampoline_segment = setup_trampoline() >> 4;
-	init_rsp = (unsigned long)temp_stack + 4096;
+	stack_start.sp = temp_stack + 4096;
 	initial_code = (unsigned long)wakeup_long64;
 	saved_magic = 0x123456789abcdef0;
 #endif /* CONFIG_64BIT */
diff --git a/arch/x86/kernel/apic_64.c b/arch/x86/kernel/apic_64.c
index e494809..5b5ae8e 100644
--- a/arch/x86/kernel/apic_64.c
+++ b/arch/x86/kernel/apic_64.c
@@ -918,6 +918,8 @@ int __init APIC_init_uniprocessor(void)
 
 	verify_local_APIC();
 
+	connect_bsp_APIC();
+
 	phys_cpu_present_map = physid_mask_of_physid(boot_cpu_physical_apicid);
 	apic_write(APIC_ID, SET_APIC_ID(boot_cpu_physical_apicid));
 
@@ -999,6 +1001,14 @@ asmlinkage void smp_error_interrupt(void)
 	irq_exit();
 }
 
+/**
+ *  * connect_bsp_APIC - attach the APIC to the interrupt system
+ *   */
+void __init connect_bsp_APIC(void)
+{
+	enable_apic_mode();
+}
+
 void disconnect_bsp_APIC(int virt_wire_setup)
 {
 	/* Go back to Virtual Wire compatibility mode */
diff --git a/arch/x86/kernel/head_32.S b/arch/x86/kernel/head_32.S
index b98b338..f67e934 100644
--- a/arch/x86/kernel/head_32.S
+++ b/arch/x86/kernel/head_32.S
@@ -452,10 +452,13 @@ is386:	movl $2,%ecx		# set MP
 	je   1f
 	movl $(__KERNEL_PERCPU), %eax
 	movl %eax,%fs		# set this cpu's percpu
-	jmp initialize_secondary # all other CPUs call initialize_secondary
+	movl (stack_start), %esp
 1:
 #endif /* CONFIG_SMP */
-	jmp i386_start_kernel
+	jmp *(initial_code)
+.align 4
+ENTRY(initial_code)
+	.long i386_start_kernel
 
 /*
  * We depend on ET to be correct. This checks for 287/387.
diff --git a/arch/x86/kernel/head_64.S b/arch/x86/kernel/head_64.S
index d8ed325..febeabb 100644
--- a/arch/x86/kernel/head_64.S
+++ b/arch/x86/kernel/head_64.S
@@ -191,7 +191,7 @@ ENTRY(secondary_startup_64)
 	movq	%rax, %cr0
 
 	/* Setup a boot time stack */
-	movq init_rsp(%rip),%rsp
+	movq stack_start(%rip),%rsp
 
 	/* zero EFLAGS after setting rsp */
 	pushq $0
@@ -203,7 +203,7 @@ ENTRY(secondary_startup_64)
 	 * addresses where we're currently running on. We have to do that here
 	 * because in 32bit we couldn't load a 64bit linear address.
 	 */
-	lgdt	cpu_gdt_descr(%rip)
+	lgdt	early_gdt_descr(%rip)
 
 	/* set up data segments. actually 0 would do too */
 	movl $__KERNEL_DS,%eax
@@ -252,8 +252,9 @@ ENTRY(secondary_startup_64)
 	.quad	x86_64_start_kernel
 	__FINITDATA
 
-	ENTRY(init_rsp)
+	ENTRY(stack_start)
 	.quad  init_thread_union+THREAD_SIZE-8
+	.word  0
 
 bad_address:
 	jmp bad_address
@@ -390,54 +391,16 @@ NEXT_PAGE(level2_spare_pgt)
 
 	.data
 	.align 16
-	.globl cpu_gdt_descr
-cpu_gdt_descr:
-	.word	gdt_end-cpu_gdt_table-1
-gdt:
-	.quad	cpu_gdt_table
-#ifdef CONFIG_SMP
-	.rept	NR_CPUS-1
-	.word	0
-	.quad	0
-	.endr
-#endif
+	.globl early_gdt_descr
+early_gdt_descr:
+	.word	GDT_ENTRIES*8-1
+	.quad   per_cpu__gdt_page
 
 ENTRY(phys_base)
 	/* This must match the first entry in level2_kernel_pgt */
 	.quad   0x0000000000000000
 
-/* We need valid kernel segments for data and code in long mode too
- * IRET will check the segment types  kkeil 2000/10/28
- * Also sysret mandates a special GDT layout 
- */
-		 		
-	.section .data.page_aligned, "aw"
-	.align PAGE_SIZE
-
-/* The TLS descriptors are currently at a different place compared to i386.
-   Hopefully nobody expects them at a fixed place (Wine?) */
 	
-ENTRY(cpu_gdt_table)
-	.quad	0x0000000000000000	/* NULL descriptor */
-	.quad	0x00cf9b000000ffff	/* __KERNEL32_CS */
-	.quad	0x00af9b000000ffff	/* __KERNEL_CS */
-	.quad	0x00cf93000000ffff	/* __KERNEL_DS */
-	.quad	0x00cffb000000ffff	/* __USER32_CS */
-	.quad	0x00cff3000000ffff	/* __USER_DS, __USER32_DS  */
-	.quad	0x00affb000000ffff	/* __USER_CS */
-	.quad	0x0			/* unused */
-	.quad	0,0			/* TSS */
-	.quad	0,0			/* LDT */
-	.quad   0,0,0			/* three TLS descriptors */ 
-	.quad	0x0000f40000000000	/* node/CPU stored in limit */
-gdt_end:	
-	/* asm/segment.h:GDT_ENTRIES must match this */	
-	/* This should be a multiple of the cache line size */
-	/* GDTs of other CPUs are now dynamically allocated */
-
-	/* zero the remaining page */
-	.fill PAGE_SIZE / 8 - GDT_ENTRIES,8,0
-
 	.section .bss, "aw", @nobits
 	.align L1_CACHE_BYTES
 ENTRY(idt_table)
diff --git a/arch/x86/kernel/io_apic_32.c b/arch/x86/kernel/io_apic_32.c
index e71f352..9b3907d 100644
--- a/arch/x86/kernel/io_apic_32.c
+++ b/arch/x86/kernel/io_apic_32.c
@@ -1211,6 +1211,11 @@ static int assign_irq_vector(int irq)
 
 	return vector;
 }
+
+void setup_vector_irq(int cpu)
+{
+}
+
 static struct irq_chip ioapic_chip;
 
 #define IOAPIC_AUTO	-1
diff --git a/arch/x86/kernel/io_apic_64.c b/arch/x86/kernel/io_apic_64.c
index 84f233f..b62d19f 100644
--- a/arch/x86/kernel/io_apic_64.c
+++ b/arch/x86/kernel/io_apic_64.c
@@ -781,7 +781,7 @@ static void __clear_irq_vector(int irq)
 	cpus_clear(cfg->domain);
 }
 
-void __setup_vector_irq(int cpu)
+static void __setup_vector_irq(int cpu)
 {
 	/* Initialize vector_irq on a new cpu */
 	/* This function must be called with vector_lock held */
@@ -804,6 +804,13 @@ void __setup_vector_irq(int cpu)
 	}
 }
 
+void setup_vector_irq(int cpu)
+{
+	spin_lock(&vector_lock);
+	__setup_vector_irq(smp_processor_id());
+	spin_unlock(&vector_lock);
+}
+
 
 static struct irq_chip ioapic_chip;
 
diff --git a/arch/x86/kernel/process_32.c b/arch/x86/kernel/process_32.c
index 7832829..9046deb 100644
--- a/arch/x86/kernel/process_32.c
+++ b/arch/x86/kernel/process_32.c
@@ -74,6 +74,22 @@ unsigned long thread_saved_pc(struct task_struct *tsk)
 
 #ifdef CONFIG_HOTPLUG_CPU
 #include <asm/nmi.h>
+
+static void cpu_exit_clear(void)
+{
+	int cpu = raw_smp_processor_id();
+
+	idle_task_exit();
+
+	cpu_uninit();
+	irq_ctx_exit(cpu);
+
+	cpu_clear(cpu, cpu_callout_map);
+	cpu_clear(cpu, cpu_callin_map);
+
+	numa_remove_cpu(cpu);
+}
+
 /* We don't actually take CPU down, just spin without interrupts. */
 static inline void play_dead(void)
 {
diff --git a/arch/x86/kernel/setup64.c b/arch/x86/kernel/setup64.c
index fc1a56d..151d315 100644
--- a/arch/x86/kernel/setup64.c
+++ b/arch/x86/kernel/setup64.c
@@ -202,11 +202,8 @@ void __cpuinit cpu_init (void)
 	 * Initialize the per-CPU GDT with the boot GDT,
 	 * and set up the GDT descriptor:
 	 */
-	if (cpu)
-		memcpy(get_cpu_gdt_table(cpu), cpu_gdt_table, GDT_SIZE);
 
-	cpu_gdt_descr[cpu].size = GDT_SIZE;
-	load_gdt((const struct desc_ptr *)&cpu_gdt_descr[cpu]);
+	switch_to_new_gdt();
 	load_idt((const struct desc_ptr *)&idt_descr);
 
 	memset(me->thread.tls_array, 0, GDT_ENTRY_TLS_ENTRIES * 8);
@@ -250,6 +247,7 @@ void __cpuinit cpu_init (void)
 		BUG();
 	enter_lazy_tlb(&init_mm, me);
 
+	load_sp0(t, &current->thread);
 	set_tss_desc(cpu, t);
 	load_TR_desc();
 	load_LDT(&init_mm.context);
diff --git a/arch/x86/kernel/setup_64.c b/arch/x86/kernel/setup_64.c
index 650eafa..de2645e 100644
--- a/arch/x86/kernel/setup_64.c
+++ b/arch/x86/kernel/setup_64.c
@@ -81,6 +81,22 @@
 #define ARCH_SETUP
 #endif
 
+/* We need valid kernel segments for data and code in long mode too
+ * IRET will check the segment types  kkeil 2000/10/28
+ * Also sysret mandates a special GDT layout
+ */
+/* The TLS descriptors are currently at a different place compared to i386.
+   Hopefully nobody expects them at a fixed place (Wine?) */
+DEFINE_PER_CPU_PAGE_ALIGNED(struct gdt_page, gdt_page) = { .gdt = {
+	[GDT_ENTRY_KERNEL32_CS] = { { { 0x0000ffff, 0x00cf9b00 } } },
+	[GDT_ENTRY_KERNEL_CS] = { { { 0x0000ffff, 0x00af9b00 } } },
+	[GDT_ENTRY_KERNEL_DS] = { { { 0x0000ffff, 0x00cf9300 } } },
+	[GDT_ENTRY_DEFAULT_USER32_CS] = { { { 0x0000ffff, 0x00cffb00 } } },
+	[GDT_ENTRY_DEFAULT_USER_DS] = { { { 0x0000ffff, 0x00cff300 } } },
+	[GDT_ENTRY_DEFAULT_USER_CS] = { { { 0x0000ffff, 0x00affb00 } } },
+} };
+EXPORT_PER_CPU_SYMBOL_GPL(gdt_page);
+
 /*
  * Machine setup..
  */
@@ -271,6 +287,17 @@ void __attribute__((weak)) __init memory_setup(void)
        machine_specific_memory_setup();
 }
 
+/* Current gdt points %fs at the "master" per-cpu area: after this,
+ * it's on the real one. */
+void switch_to_new_gdt(void)
+{
+	struct desc_ptr gdt_descr;
+
+	gdt_descr.address = (long)get_cpu_gdt_table(smp_processor_id());
+	gdt_descr.size = GDT_SIZE - 1;
+	load_gdt(&gdt_descr);
+}
+
 /*
  * setup_arch - architecture-specific boot-time initializations
  *
diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index 722b24b..adf54ea 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -181,13 +181,12 @@ static void map_cpu_to_logical_apicid(void)
 	map_cpu_to_node(cpu, node);
 }
 
-static void unmap_cpu_to_logical_apicid(int cpu)
+void numa_remove_cpu(int cpu)
 {
 	cpu_2_logical_apicid[cpu] = BAD_APICID;
 	unmap_cpu_to_node(cpu);
 }
 #else
-#define unmap_cpu_to_logical_apicid(cpu) do {} while (0)
 #define map_cpu_to_logical_apicid()  do {} while (0)
 #endif
 
@@ -329,15 +328,8 @@ static void __cpuinit start_secondary(void *unused)
 	 * smp_call_function().
 	 */
 	lock_ipi_call_lock();
-#ifdef CONFIG_X86_64
-	spin_lock(&vector_lock);
-
-	/* Setup the per cpu irq handling data structures */
-	__setup_vector_irq(smp_processor_id());
-	/*
-	 * Allow the master to continue.
-	 */
-	spin_unlock(&vector_lock);
+#ifdef CONFIG_X86_IO_APIC
+	setup_vector_irq(smp_processor_id());
 #endif
 	cpu_set(smp_processor_id(), cpu_online_map);
 	unlock_ipi_call_lock();
@@ -349,31 +341,8 @@ static void __cpuinit start_secondary(void *unused)
 	cpu_idle();
 }
 
-#ifdef CONFIG_X86_32
-/*
- * Everything has been set up for the secondary
- * CPUs - they just need to reload everything
- * from the task structure
- * This function must not return.
- */
-void __devinit initialize_secondary(void)
-{
-	/*
-	 * We don't actually need to load the full TSS,
-	 * basically just the stack pointer and the ip.
-	 */
-
-	asm volatile(
-		"movl %0,%%esp\n\t"
-		"jmp *%1"
-		:
-		:"m" (current->thread.sp), "m" (current->thread.ip));
-}
-#endif
-
 static void __cpuinit smp_apply_quirks(struct cpuinfo_x86 *c)
 {
-#ifdef CONFIG_X86_32
 	/*
 	 * Mask B, Pentium, but not Pentium MMX
 	 */
@@ -423,7 +392,6 @@ static void __cpuinit smp_apply_quirks(struct cpuinfo_x86 *c)
 
 valid_k7:
 	;
-#endif
 }
 
 static void __cpuinit smp_checks(void)
@@ -714,11 +682,7 @@ wakeup_secondary_cpu(int phys_apicid, unsigned long start_eip)
 	 * target processor state.
 	 */
 	startup_ipi_hook(phys_apicid, (unsigned long) start_secondary,
-#ifdef CONFIG_X86_64
-			 (unsigned long)init_rsp);
-#else
 			 (unsigned long)stack_start.sp);
-#endif
 
 	/*
 	 * Run STARTUP IPI loop.
@@ -853,14 +817,8 @@ static int __cpuinit do_boot_cpu(int apicid, int cpu)
 		.done = COMPLETION_INITIALIZER_ONSTACK(c_idle.done),
 	};
 	INIT_WORK(&c_idle.work, do_fork_idle);
-#ifdef CONFIG_X86_64
-	/* allocate memory for gdts of secondary cpus. Hotplug is considered */
-	if (!cpu_gdt_descr[cpu].address &&
-		!(cpu_gdt_descr[cpu].address = get_zeroed_page(GFP_KERNEL))) {
-		printk(KERN_ERR "Failed to allocate GDT for CPU %d\n", cpu);
-		return -1;
-	}
 
+#ifdef CONFIG_X86_64
 	/* Allocate node local memory for AP pdas */
 	if (cpu > 0) {
 		boot_error = get_local_pda(cpu);
@@ -902,18 +860,15 @@ do_rest:
 #ifdef CONFIG_X86_32
 	per_cpu(current_task, cpu) = c_idle.idle;
 	init_gdt(cpu);
-	early_gdt_descr.address = (unsigned long)get_cpu_gdt_table(cpu);
-	c_idle.idle->thread.ip = (unsigned long) start_secondary;
 	/* Stack for startup_32 can be just as for start_secondary onwards */
-	stack_start.sp = (void *) c_idle.idle->thread.sp;
 	irq_ctx_init(cpu);
 #else
 	cpu_pda(cpu)->pcurrent = c_idle.idle;
-	init_rsp = c_idle.idle->thread.sp;
-	load_sp0(&per_cpu(init_tss, cpu), &c_idle.idle->thread);
-	initial_code = (unsigned long)start_secondary;
 	clear_tsk_thread_flag(c_idle.idle, TIF_FORK);
 #endif
+	early_gdt_descr.address = (unsigned long)get_cpu_gdt_table(cpu);
+	initial_code = (unsigned long)start_secondary;
+	stack_start.sp = (void *) c_idle.idle->thread.sp;
 
 	/* start_ip had better be page-aligned! */
 	start_ip = setup_trampoline();
@@ -989,10 +944,7 @@ restore_state:
 
 	if (boot_error) {
 		/* Try to put things back the way they were before ... */
-		unmap_cpu_to_logical_apicid(cpu);
-#ifdef CONFIG_X86_64
 		numa_remove_cpu(cpu); /* was set by numa_add_cpu */
-#endif
 		cpu_clear(cpu, cpu_callout_map); /* was set by do_boot_cpu() */
 		cpu_clear(cpu, cpu_initialized); /* was set by cpu_init() */
 		cpu_clear(cpu, cpu_possible_map);
@@ -1087,9 +1039,8 @@ static __init void disable_smp(void)
 {
 	cpu_present_map = cpumask_of_cpu(0);
 	cpu_possible_map = cpumask_of_cpu(0);
-#ifdef CONFIG_X86_32
 	smpboot_clear_io_apic_irqs();
-#endif
+
 	if (smp_found_config)
 		phys_cpu_present_map =
 				physid_mask_of_physid(boot_cpu_physical_apicid);
@@ -1162,9 +1113,7 @@ static int __init smp_sanity_check(unsigned max_cpus)
 
 		localise_nmi_watchdog();
 
-#ifdef CONFIG_X86_32
 		connect_bsp_APIC();
-#endif
 		setup_local_APIC();
 		end_local_APIC_setup();
 		return -1;
@@ -1219,9 +1168,8 @@ void __init native_smp_prepare_cpus(unsigned int max_cpus)
 	}
 	preempt_enable();
 
-#ifdef CONFIG_X86_32
 	connect_bsp_APIC();
-#endif
+
 	/*
 	 * Switch from PIC to APIC mode.
 	 */
@@ -1259,8 +1207,8 @@ void __init native_smp_prepare_boot_cpu(void)
 	int me = smp_processor_id();
 #ifdef CONFIG_X86_32
 	init_gdt(me);
-	switch_to_new_gdt();
 #endif
+	switch_to_new_gdt();
 	/* already set me in cpu_online_map in boot_cpu_init() */
 	cpu_set(me, cpu_callout_map);
 	per_cpu(cpu_state, me) = CPU_ONLINE;
@@ -1280,23 +1228,6 @@ void __init native_smp_cpus_done(unsigned int max_cpus)
 
 #ifdef CONFIG_HOTPLUG_CPU
 
-#  ifdef CONFIG_X86_32
-void cpu_exit_clear(void)
-{
-	int cpu = raw_smp_processor_id();
-
-	idle_task_exit();
-
-	cpu_uninit();
-	irq_ctx_exit(cpu);
-
-	cpu_clear(cpu, cpu_callout_map);
-	cpu_clear(cpu, cpu_callin_map);
-
-	unmap_cpu_to_logical_apicid(cpu);
-}
-#  endif /* CONFIG_X86_32 */
-
 static void remove_siblinginfo(int cpu)
 {
 	int sibling;
@@ -1372,13 +1303,11 @@ __init void prefill_possible_map(void)
 static void __ref remove_cpu_from_maps(int cpu)
 {
 	cpu_clear(cpu, cpu_online_map);
-#ifdef CONFIG_X86_64
 	cpu_clear(cpu, cpu_callout_map);
 	cpu_clear(cpu, cpu_callin_map);
 	/* was set by cpu_init() */
 	clear_bit(cpu, (unsigned long *)&cpu_initialized);
 	numa_remove_cpu(cpu);
-#endif
 }
 
 int __cpu_disable(void)
diff --git a/arch/x86/kernel/traps_32.c b/arch/x86/kernel/traps_32.c
index 1ad3c48..f6f46eb 100644
--- a/arch/x86/kernel/traps_32.c
+++ b/arch/x86/kernel/traps_32.c
@@ -1136,7 +1136,7 @@ void do_spurious_interrupt_bug(struct pt_regs *regs, long error_code)
 
 unsigned long patch_espfix_desc(unsigned long uesp, unsigned long kesp)
 {
-	struct desc_struct *gdt = __get_cpu_var(gdt_page).gdt;
+	struct desc_struct *gdt = get_cpu_gdt_table(smp_processor_id());
 	unsigned long base = (kesp - uesp) & -THREAD_SIZE;
 	unsigned long new_kesp = kesp - base;
 	unsigned long lim_pages = (new_kesp | (THREAD_SIZE - 1)) >> PAGE_SHIFT;
diff --git a/arch/x86/kernel/x8664_ksyms_64.c b/arch/x86/kernel/x8664_ksyms_64.c
index 122885b..16a6751 100644
--- a/arch/x86/kernel/x8664_ksyms_64.c
+++ b/arch/x86/kernel/x8664_ksyms_64.c
@@ -60,8 +60,3 @@ EXPORT_SYMBOL(init_level4_pgt);
 EXPORT_SYMBOL(load_gs_index);
 
 EXPORT_SYMBOL(_proxy_pda);
-
-#ifdef CONFIG_PARAVIRT
-/* Virtualized guests may want to use it */
-EXPORT_SYMBOL_GPL(cpu_gdt_descr);
-#endif
diff --git a/include/asm-x86/desc.h b/include/asm-x86/desc.h
index b3875d4..07f9f2b 100644
--- a/include/asm-x86/desc.h
+++ b/include/asm-x86/desc.h
@@ -29,11 +29,17 @@ static inline void fill_ldt(struct desc_struct *desc,
 extern struct desc_ptr idt_descr;
 extern gate_desc idt_table[];
 
+struct gdt_page {
+	struct desc_struct gdt[GDT_ENTRIES];
+} __attribute__((aligned(PAGE_SIZE)));
+DECLARE_PER_CPU(struct gdt_page, gdt_page);
+
+static inline struct desc_struct *get_cpu_gdt_table(unsigned int cpu)
+{
+	return per_cpu(gdt_page, cpu).gdt;
+}
+
 #ifdef CONFIG_X86_64
-extern struct desc_struct cpu_gdt_table[GDT_ENTRIES];
-extern struct desc_ptr cpu_gdt_descr[];
-/* the cpu gdt accessor */
-#define get_cpu_gdt_table(x) ((struct desc_struct *)cpu_gdt_descr[x].address)
 
 static inline void pack_gate(gate_desc *gate, unsigned type, unsigned long func,
 			     unsigned dpl, unsigned ist, unsigned seg)
@@ -51,16 +57,6 @@ static inline void pack_gate(gate_desc *gate, unsigned type, unsigned long func,
 }
 
 #else
-struct gdt_page {
-	struct desc_struct gdt[GDT_ENTRIES];
-} __attribute__((aligned(PAGE_SIZE)));
-DECLARE_PER_CPU(struct gdt_page, gdt_page);
-
-static inline struct desc_struct *get_cpu_gdt_table(unsigned int cpu)
-{
-	return per_cpu(gdt_page, cpu).gdt;
-}
-
 static inline void pack_gate(gate_desc *gate, unsigned char type,
 			     unsigned long base, unsigned dpl, unsigned flags,
 			     unsigned short seg)
diff --git a/include/asm-x86/hw_irq.h b/include/asm-x86/hw_irq.h
index 1428b41..18f067c 100644
--- a/include/asm-x86/hw_irq.h
+++ b/include/asm-x86/hw_irq.h
@@ -97,9 +97,9 @@ extern void (*const interrupt[NR_IRQS])(void);
 #else
 typedef int vector_irq_t[NR_VECTORS];
 DECLARE_PER_CPU(vector_irq_t, vector_irq);
-extern void __setup_vector_irq(int cpu);
 extern spinlock_t vector_lock;
 #endif
+extern void setup_vector_irq(int cpu);
 
 #endif /* !ASSEMBLY_ */
 
diff --git a/include/asm-x86/numa_32.h b/include/asm-x86/numa_32.h
index 03d0f7a..205015f 100644
--- a/include/asm-x86/numa_32.h
+++ b/include/asm-x86/numa_32.h
@@ -2,6 +2,7 @@
 #define _ASM_X86_32_NUMA_H 1
 
 extern int pxm_to_nid(int pxm);
+extern void numa_remove_cpu(int cpu);
 
 #ifdef CONFIG_NUMA
 extern void __init remap_numa_kva(void);
diff --git a/include/asm-x86/segment.h b/include/asm-x86/segment.h
index ed5131d..dfc8601 100644
--- a/include/asm-x86/segment.h
+++ b/include/asm-x86/segment.h
@@ -61,18 +61,14 @@
 #define GDT_ENTRY_TLS_MAX 	(GDT_ENTRY_TLS_MIN + GDT_ENTRY_TLS_ENTRIES - 1)
 
 #define GDT_ENTRY_DEFAULT_USER_CS	14
-#define __USER_CS (GDT_ENTRY_DEFAULT_USER_CS * 8 + 3)
 
 #define GDT_ENTRY_DEFAULT_USER_DS	15
-#define __USER_DS (GDT_ENTRY_DEFAULT_USER_DS * 8 + 3)
 
 #define GDT_ENTRY_KERNEL_BASE	12
 
 #define GDT_ENTRY_KERNEL_CS		(GDT_ENTRY_KERNEL_BASE + 0)
-#define __KERNEL_CS (GDT_ENTRY_KERNEL_CS * 8)
 
 #define GDT_ENTRY_KERNEL_DS		(GDT_ENTRY_KERNEL_BASE + 1)
-#define __KERNEL_DS (GDT_ENTRY_KERNEL_DS * 8)
 
 #define GDT_ENTRY_TSS			(GDT_ENTRY_KERNEL_BASE + 4)
 #define GDT_ENTRY_LDT			(GDT_ENTRY_KERNEL_BASE + 5)
@@ -139,10 +135,11 @@
 #else
 #include <asm/cache.h>
 
-#define __KERNEL_CS	0x10
-#define __KERNEL_DS	0x18
+#define GDT_ENTRY_KERNEL32_CS 1
+#define GDT_ENTRY_KERNEL_CS 2
+#define GDT_ENTRY_KERNEL_DS 3
 
-#define __KERNEL32_CS   0x08
+#define __KERNEL32_CS   (GDT_ENTRY_KERNEL32_CS * 8)
 
 /*
  * we cannot use the same code segment descriptor for user and kernel
@@ -150,10 +147,10 @@
  * The segment offset needs to contain a RPL. Grr. -AK
  * GDT layout to get 64bit syscall right (sysret hardcodes gdt offsets)
  */
-
-#define __USER32_CS   0x23   /* 4*8+3 */
-#define __USER_DS     0x2b   /* 5*8+3 */
-#define __USER_CS     0x33   /* 6*8+3 */
+#define GDT_ENTRY_DEFAULT_USER32_CS 4
+#define GDT_ENTRY_DEFAULT_USER_DS 5
+#define GDT_ENTRY_DEFAULT_USER_CS 6
+#define __USER32_CS   (GDT_ENTRY_DEFAULT_USER32_CS * 8 + 3)
 #define __USER32_DS	__USER_DS
 
 #define GDT_ENTRY_TSS 8	/* needs two entries */
@@ -175,6 +172,10 @@
 
 #endif
 
+#define __KERNEL_CS	(GDT_ENTRY_KERNEL_CS * 8)
+#define __KERNEL_DS	(GDT_ENTRY_KERNEL_DS * 8)
+#define __USER_DS     (GDT_ENTRY_DEFAULT_USER_DS* 8 + 3)
+#define __USER_CS     (GDT_ENTRY_DEFAULT_USER_CS* 8 + 3)
 #ifndef CONFIG_PARAVIRT
 #define get_kernel_rpl()  0
 #endif
diff --git a/include/asm-x86/smp.h b/include/asm-x86/smp.h
index fc10073..fad45f6 100644
--- a/include/asm-x86/smp.h
+++ b/include/asm-x86/smp.h
@@ -188,7 +188,6 @@ static inline int hard_smp_processor_id(void)
 #endif /* CONFIG_X86_LOCAL_APIC */
 
 #ifdef CONFIG_HOTPLUG_CPU
-extern void cpu_exit_clear(void);
 extern void cpu_uninit(void);
 #endif
 
