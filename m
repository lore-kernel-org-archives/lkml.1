Return-Path: <linux-kernel-owner+w=401wt.eu-S1751332AbZAZGSw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751332AbZAZGSw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2009 01:18:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751745AbZAZGPs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Jan 2009 01:15:48 -0500
Received: from yw-out-2324.google.com ([74.125.46.28]:41676 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752102AbZAZGPq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2009 01:15:46 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=PgqSvSwSFhZBXgbyphHUgdiG5Ku54iPts4USkBCrHg/xZXZJEF24IE0v8kNBXPI1fx
         e/5538+7oLkW3U2/u9cnu404ASpG2z4uUsOndYTt0po4pN40O1VtT6uvhNwTDYQ8YRDU
         Vq0JrRC5fYRlX2OMMdU3kXQGlmj1kfNgPn6/U=
From: Brian Gerst <brgerst@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org
Subject: [PATCH 10/12] x86: Initialize per-cpu GDT segment in per-cpu setup
Date: Mon, 26 Jan 2009 01:15:30 -0500
Message-Id: <1232950532-22923-10-git-send-email-brgerst@gmail.com>
X-Mailer: git-send-email 1.6.1
In-Reply-To: <73c1f2160901252214k394d198dn815670e7f667b3ac@mail.gmail.com>
References: <73c1f2160901252214k394d198dn815670e7f667b3ac@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: cleanup

Rename init_gdt() to setup_percpu_segment(), and move it to
setup_percpu.c.

Signed-off-by: Brian Gerst <brgerst@gmail.com>
---
 arch/x86/include/asm/processor.h    |    1 -
 arch/x86/kernel/Makefile            |    3 +--
 arch/x86/kernel/setup_percpu.c      |   14 ++++++++++++++
 arch/x86/kernel/smpboot.c           |    4 ----
 arch/x86/kernel/smpcommon.c         |   25 -------------------------
 arch/x86/mach-voyager/voyager_smp.c |    2 --
 arch/x86/xen/smp.c                  |    1 -
 7 files changed, 15 insertions(+), 35 deletions(-)
 delete mode 100644 arch/x86/kernel/smpcommon.c

diff --git a/arch/x86/include/asm/processor.h b/arch/x86/include/asm/processor.h
index 48676b9..32c30b0 100644
--- a/arch/x86/include/asm/processor.h
+++ b/arch/x86/include/asm/processor.h
@@ -778,7 +778,6 @@ extern struct desc_ptr		early_gdt_descr;
 extern void cpu_set_gdt(int);
 extern void switch_to_new_gdt(void);
 extern void cpu_init(void);
-extern void init_gdt(int cpu);
 
 static inline unsigned long get_debugctlmsr(void)
 {
diff --git a/arch/x86/kernel/Makefile b/arch/x86/kernel/Makefile
index 73de055..37fa30b 100644
--- a/arch/x86/kernel/Makefile
+++ b/arch/x86/kernel/Makefile
@@ -60,8 +60,7 @@ obj-$(CONFIG_APM)		+= apm.o
 obj-$(CONFIG_X86_SMP)		+= smp.o
 obj-$(CONFIG_X86_SMP)		+= smpboot.o tsc_sync.o ipi.o
 obj-$(CONFIG_SMP)		+= setup_percpu.o
-obj-$(CONFIG_X86_32_SMP)	+= smpcommon.o
-obj-$(CONFIG_X86_64_SMP)	+= tsc_sync.o smpcommon.o
+obj-$(CONFIG_X86_64_SMP)	+= tsc_sync.o
 obj-$(CONFIG_X86_TRAMPOLINE)	+= trampoline_$(BITS).o
 obj-$(CONFIG_X86_MPPARSE)	+= mpparse.o
 obj-$(CONFIG_X86_LOCAL_APIC)	+= apic.o nmi.o
diff --git a/arch/x86/kernel/setup_percpu.c b/arch/x86/kernel/setup_percpu.c
index 599dc1c..bcca3a7 100644
--- a/arch/x86/kernel/setup_percpu.c
+++ b/arch/x86/kernel/setup_percpu.c
@@ -40,6 +40,19 @@ unsigned long __per_cpu_offset[NR_CPUS] __read_mostly = {
 };
 EXPORT_SYMBOL(__per_cpu_offset);
 
+static inline void setup_percpu_segment(int cpu)
+{
+#ifdef CONFIG_X86_32
+	struct desc_struct gdt;
+
+	pack_descriptor(&gdt, per_cpu_offset(cpu), 0xFFFFF,
+			0x2 | DESCTYPE_S, 0x8);
+	gdt.s = 1;
+	write_gdt_entry(get_cpu_gdt_table(cpu),
+			GDT_ENTRY_PERCPU, &gdt, DESCTYPE_S);
+#endif
+}
+
 /*
  * Great future plan:
  * Declare PDA itself and support (irqstack,tss,pgd) as per cpu data.
@@ -81,6 +94,7 @@ void __init setup_per_cpu_areas(void)
 		per_cpu_offset(cpu) = ptr - __per_cpu_start;
 		per_cpu(this_cpu_off, cpu) = per_cpu_offset(cpu);
 		per_cpu(cpu_number, cpu) = cpu;
+		setup_percpu_segment(cpu);
 		/*
 		 * Copy data used in early init routines from the initial arrays to the
 		 * per cpu data areas.  These arrays then become expendable and the
diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index def770b..f9dbcff 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -793,7 +793,6 @@ static int __cpuinit do_boot_cpu(int apicid, int cpu)
 do_rest:
 	per_cpu(current_task, cpu) = c_idle.idle;
 #ifdef CONFIG_X86_32
-	init_gdt(cpu);
 	/* Stack for startup_32 can be just as for start_secondary onwards */
 	irq_ctx_init(cpu);
 #else
@@ -1186,9 +1185,6 @@ out:
 void __init native_smp_prepare_boot_cpu(void)
 {
 	int me = smp_processor_id();
-#ifdef CONFIG_X86_32
-	init_gdt(me);
-#endif
 	switch_to_new_gdt();
 	/* already set me in cpu_online_mask in boot_cpu_init() */
 	cpumask_set_cpu(me, cpu_callout_mask);
diff --git a/arch/x86/kernel/smpcommon.c b/arch/x86/kernel/smpcommon.c
deleted file mode 100644
index 5ec29a1..0000000
--- a/arch/x86/kernel/smpcommon.c
+++ /dev/null
@@ -1,25 +0,0 @@
-/*
- * SMP stuff which is common to all sub-architectures.
- */
-#include <linux/module.h>
-#include <asm/smp.h>
-#include <asm/sections.h>
-
-#ifdef CONFIG_X86_32
-/*
- * Initialize the CPU's GDT.  This is either the boot CPU doing itself
- * (still using the master per-cpu area), or a CPU doing it for a
- * secondary which will soon come up.
- */
-__cpuinit void init_gdt(int cpu)
-{
-	struct desc_struct gdt;
-
-	pack_descriptor(&gdt, __per_cpu_offset[cpu], 0xFFFFF,
-			0x2 | DESCTYPE_S, 0x8);
-	gdt.s = 1;
-
-	write_gdt_entry(get_cpu_gdt_table(cpu),
-			GDT_ENTRY_PERCPU, &gdt, DESCTYPE_S);
-}
-#endif
diff --git a/arch/x86/mach-voyager/voyager_smp.c b/arch/x86/mach-voyager/voyager_smp.c
index dd82f20..331cd6d 100644
--- a/arch/x86/mach-voyager/voyager_smp.c
+++ b/arch/x86/mach-voyager/voyager_smp.c
@@ -530,7 +530,6 @@ static void __init do_boot_cpu(__u8 cpu)
 	/* init_tasks (in sched.c) is indexed logically */
 	stack_start.sp = (void *)idle->thread.sp;
 
-	init_gdt(cpu);
 	per_cpu(current_task, cpu) = idle;
 	early_gdt_descr.address = (unsigned long)get_cpu_gdt_table(cpu);
 	irq_ctx_init(cpu);
@@ -1747,7 +1746,6 @@ static void __init voyager_smp_prepare_cpus(unsigned int max_cpus)
 
 static void __cpuinit voyager_smp_prepare_boot_cpu(void)
 {
-	init_gdt(smp_processor_id());
 	switch_to_new_gdt();
 
 	cpu_set(smp_processor_id(), cpu_online_map);
diff --git a/arch/x86/xen/smp.c b/arch/x86/xen/smp.c
index 72c2eb9..7735e3d 100644
--- a/arch/x86/xen/smp.c
+++ b/arch/x86/xen/smp.c
@@ -281,7 +281,6 @@ static int __cpuinit xen_cpu_up(unsigned int cpu)
 
 	per_cpu(current_task, cpu) = idle;
 #ifdef CONFIG_X86_32
-	init_gdt(cpu);
 	irq_ctx_init(cpu);
 #else
 	clear_tsk_thread_flag(idle, TIF_FORK);
-- 
1.6.1

