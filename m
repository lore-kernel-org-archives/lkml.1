Return-Path: <linux-kernel-owner+w=401wt.eu-S933231AbXCMUsy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933231AbXCMUsy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2007 16:48:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933232AbXCMUsy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Mar 2007 16:48:54 -0400
Received: from gw.goop.org ([64.81.55.164]:34805 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933231AbXCMUsx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2007 16:48:53 -0400
Message-ID: <45F70E25.7050704@goop.org>
Date: Tue, 13 Mar 2007 13:48:37 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Rusty Russell <rusty@rustcorp.com.au>
CC: lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Zachary Amsden <zach@vmware.com>,
       Jeremy Fitzhardinge <jeremy@xensource.com>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>, Andi Kleen <ak@suse.de>
Subject: Re: [PATCH 0/8] x86 boot, pda and gdt cleanups
References: <1173184747.4644.23.camel@localhost.localdomain>
In-Reply-To: <1173184747.4644.23.camel@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Rusty Russell wrote:
> Hi all,
>
> 	The GDT stuff on x86 is a little more complex than it need be, but
> playing with boot code is always dangerous.  These compile and boot on
> UP and SMP for me, but Andrew should let the cook in -mm for a while.
>   
Hi Rusty,

This is my rough hacking patch I needed to get things into a Xen-shape
state.

There are a few of things here:

    * init_gdt should always use write_gdt_entry when touching the gdt;
      if it doesn't and it ends up touching an already-installed gdt
      under Xen, it will get a write fault.  This happens because
      init_gdt ends up getting called twice in SMP (see below).
    * init_gdt should always be called before bringing up the cpu,
      rather than by the cpu itself (and therefore, cpu_init() shouldn't
      call it).  Obviously the the boot cpu is an exception.
    * secondary_cpu_init stops being necessary.
    * On SMP, init_gdt can get called twice: first time in
      smp_prepare_boot_cpu, and a second time in  trap_init.  On UP,
      trap_init is the only caller.

diff -r 8dcd1dc9b298 arch/i386/kernel/cpu/common.c
--- a/arch/i386/kernel/cpu/common.c	Tue Mar 13 00:33:37 2007 -0700
+++ b/arch/i386/kernel/cpu/common.c	Tue Mar 13 13:13:08 2007 -0700
@@ -620,14 +620,24 @@ __cpuinit void init_gdt(int cpu, struct 
 __cpuinit void init_gdt(int cpu, struct task_struct *idle)
 {
 	struct desc_struct *gdt = per_cpu(gdt_page, cpu).gdt;
+	int i;
 
 	/* Based on boot_gdt_table: set percpu so it can be used immediately */
- 	memcpy(gdt, boot_gdt_table, GDT_SIZE);
+	for(i = 0; i < GDT_ENTRIES; i++) {
+		const struct desc_struct *bgdtt = &boot_gdt_table[i];
+		write_gdt_entry(gdt, i, bgdtt->a, bgdtt->b);
+	}
+
 #ifdef CONFIG_SMP
-	pack_descriptor((u32 *)&gdt[GDT_ENTRY_PERCPU].a,
-			(u32 *)&gdt[GDT_ENTRY_PERCPU].b,
-			__per_cpu_offset[cpu], 0xFFFFF,
-			0x80 | DESCTYPE_S | 0x2, 0); /* present read-write data segment */
+	{
+		u32 a, b;
+
+		/* present read-write data segment, pagesize granularity */
+		pack_descriptor(&a, &b, __per_cpu_offset[cpu], 0xFFFFF,
+				0x80 | DESCTYPE_S | 0x2, 0x8);
+		write_gdt_entry(gdt, GDT_ENTRY_PERCPU, a, b);
+	}
+
 	per_cpu(this_cpu_off, cpu) = __per_cpu_offset[cpu];
 	per_cpu(cpu_number, cpu) = cpu;
 #endif /* SMP*/
@@ -709,30 +719,21 @@ static void __cpuinit _cpu_init(int cpu,
 	mxcsr_feature_mask_init();
 }
 
-/* Entrypoint to initialize secondary CPU */
-void __cpuinit secondary_cpu_init(void)
-{
-	int cpu = smp_processor_id();
-	struct task_struct *curr = current;
-
-	_cpu_init(cpu, curr);
-}
-
 /*
  * cpu_init() initializes state that is per-CPU. Some data is already
  * initialized (naturally) in the bootstrap process, such as the GDT
  * and IDT. We reload them nevertheless, this function acts as a
  * 'CPU state barrier', nothing should get across.
+ * 
+ * Note: we expect the gdt itself to be already set up for this
+ * processor; we just point the cpu at it.
  */
 void __cpuinit cpu_init(void)
 {
 	int cpu = smp_processor_id();
-	struct task_struct *curr = current;
-
-	/* Set up the real GDT so we can transition from the boot_gdt_table. */
-	init_gdt(cpu, curr);
+
 	cpu_set_gdt(cpu);
-	_cpu_init(cpu, curr);
+	_cpu_init(cpu, current);
 }
 
 #ifdef CONFIG_HOTPLUG_CPU
diff -r 8dcd1dc9b298 arch/i386/kernel/smpboot.c
--- a/arch/i386/kernel/smpboot.c	Tue Mar 13 00:33:37 2007 -0700
+++ b/arch/i386/kernel/smpboot.c	Tue Mar 13 13:13:08 2007 -0700
@@ -381,14 +381,14 @@ static void __cpuinit start_secondary(vo
 static void __cpuinit start_secondary(void *unused)
 {
 	/*
-	 * Don't put *anything* before secondary_cpu_init(), SMP
-	 * booting is too fragile that we want to limit the
-	 * things done here to the most necessary things.
+	 * Don't put *anything* before cpu_init(), SMP booting is too
+	 * fragile that we want to limit the things done here to the
+	 * most necessary things.
 	 */
 #ifdef CONFIG_VMI
 	vmi_bringup();
 #endif
-	secondary_cpu_init();
+	cpu_init();
 	preempt_disable();
 	smp_callin();
 	while (!cpu_isset(smp_processor_id(), smp_commenced_mask))
@@ -1165,15 +1165,17 @@ void __init native_smp_prepare_cpus(unsi
 
 void __devinit native_smp_prepare_boot_cpu(void)
 {
-	cpu_set(smp_processor_id(), cpu_online_map);
-	cpu_set(smp_processor_id(), cpu_callout_map);
-	cpu_set(smp_processor_id(), cpu_present_map);
-	cpu_set(smp_processor_id(), cpu_possible_map);
-	per_cpu(cpu_state, smp_processor_id()) = CPU_ONLINE;
+	int cpu = smp_processor_id();
+
+	cpu_set(cpu, cpu_online_map);
+	cpu_set(cpu, cpu_callout_map);
+	cpu_set(cpu, cpu_present_map);
+	cpu_set(cpu, cpu_possible_map);
+	per_cpu(cpu_state, cpu) = CPU_ONLINE;
 
 	/* Set up %fs to point to our per-CPU area now it's allocated */
-	init_gdt(smp_processor_id(), &init_task);
-	cpu_set_gdt(smp_processor_id());
+	init_gdt(cpu, &init_task);
+	cpu_set_gdt(cpu);
 }
 
 #ifdef CONFIG_HOTPLUG_CPU
diff -r 8dcd1dc9b298 arch/i386/kernel/traps.c
--- a/arch/i386/kernel/traps.c	Tue Mar 13 00:33:37 2007 -0700
+++ b/arch/i386/kernel/traps.c	Tue Mar 13 13:13:08 2007 -0700
@@ -1181,6 +1181,7 @@ void __init trap_init(void)
 	/*
 	 * Should be a barrier for any external CPU state.
 	 */
+	init_gdt(smp_processor_id(), current);
 	cpu_init();
 
 	trap_init_hook();
diff -r 8dcd1dc9b298 include/asm-i386/processor.h
--- a/include/asm-i386/processor.h	Tue Mar 13 00:33:37 2007 -0700
+++ b/include/asm-i386/processor.h	Tue Mar 13 13:13:08 2007 -0700
@@ -744,6 +744,6 @@ extern int sysenter_setup(void);
 
 extern void init_gdt(int cpu, struct task_struct *idle);
 extern void cpu_set_gdt(int);
-extern void secondary_cpu_init(void);
+extern void cpu_init(void);
 
 #endif /* __ASM_I386_PROCESSOR_H */


