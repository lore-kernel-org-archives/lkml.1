Return-Path: <linux-kernel-owner+w=401wt.eu-S934302AbZARQmm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934302AbZARQmm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Jan 2009 11:42:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762979AbZARQjm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Jan 2009 11:39:42 -0500
Received: from hera.kernel.org ([140.211.167.34]:55227 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761164AbZARQjk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Jan 2009 11:39:40 -0500
From: Tejun Heo <tj@kernel.org>
To: mingo@elte.hu, linux-kernel@vger.kernel.org, brgerst@gmail.com
Cc: Tejun Heo <tj@kernel.org>
Subject: [PATCH 05/12] x86-64: Move cpu number from PDA to per-cpu and consolidate with 32-bit.
Date: Mon, 19 Jan 2009 01:39:12 +0900
Message-Id: <1232296759-2253-6-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <1232296759-2253-1-git-send-email-tj@kernel.org>
References: <1232296759-2253-1-git-send-email-tj@kernel.org>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Sun, 18 Jan 2009 16:39:31 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Brian Gerst <brgerst@gmail.com>

tj: moved cpu_number definition out of CONFIG_HAVE_SETUP_PER_CPU_AREA
    for voyager.

Signed-off-by: Brian Gerst <brgerst@gmail.com>
Signed-off-by: Tejun Heo <tj@kernel.org>
---
 arch/x86/include/asm/pda.h       |    2 +-
 arch/x86/include/asm/smp.h       |    4 +---
 arch/x86/kernel/asm-offsets_64.c |    1 -
 arch/x86/kernel/cpu/common.c     |    1 -
 arch/x86/kernel/process_32.c     |    3 ---
 arch/x86/kernel/setup_percpu.c   |   10 ++++++++++
 arch/x86/kernel/smpcommon.c      |    2 --
 7 files changed, 12 insertions(+), 11 deletions(-)

diff --git a/arch/x86/include/asm/pda.h b/arch/x86/include/asm/pda.h
index 09965f7..668d5a5 100644
--- a/arch/x86/include/asm/pda.h
+++ b/arch/x86/include/asm/pda.h
@@ -16,7 +16,7 @@ struct x8664_pda {
 	unsigned long kernelstack;	/* 16 top of kernel stack for current */
 	unsigned long oldrsp;		/* 24 user rsp for system call */
 	int irqcount;			/* 32 Irq nesting counter. Starts -1 */
-	unsigned int cpunumber;		/* 36 Logical CPU number */
+	unsigned int unused6;		/* 36 was cpunumber */
 #ifdef CONFIG_CC_STACKPROTECTOR
 	unsigned long stack_canary;	/* 40 stack canary value */
 					/* gcc-ABI: this canary MUST be at
diff --git a/arch/x86/include/asm/smp.h b/arch/x86/include/asm/smp.h
index c7bbbbe..68636e7 100644
--- a/arch/x86/include/asm/smp.h
+++ b/arch/x86/include/asm/smp.h
@@ -25,9 +25,7 @@ extern unsigned int num_processors;
 DECLARE_PER_CPU(cpumask_t, cpu_sibling_map);
 DECLARE_PER_CPU(cpumask_t, cpu_core_map);
 DECLARE_PER_CPU(u16, cpu_llc_id);
-#ifdef CONFIG_X86_32
 DECLARE_PER_CPU(int, cpu_number);
-#endif
 
 static inline struct cpumask *cpu_sibling_mask(int cpu)
 {
@@ -164,7 +162,7 @@ extern unsigned disabled_cpus __cpuinitdata;
 extern int safe_smp_processor_id(void);
 
 #elif defined(CONFIG_X86_64_SMP)
-#define raw_smp_processor_id()	read_pda(cpunumber)
+#define raw_smp_processor_id() (percpu_read(cpu_number))
 
 #define stack_smp_processor_id()					\
 ({								\
diff --git a/arch/x86/kernel/asm-offsets_64.c b/arch/x86/kernel/asm-offsets_64.c
index 5b821fb..cae6697 100644
--- a/arch/x86/kernel/asm-offsets_64.c
+++ b/arch/x86/kernel/asm-offsets_64.c
@@ -53,7 +53,6 @@ int main(void)
 	ENTRY(oldrsp); 
 	ENTRY(pcurrent); 
 	ENTRY(irqcount);
-	ENTRY(cpunumber);
 	DEFINE(pda_size, sizeof(struct x8664_pda));
 	BLANK();
 #undef ENTRY
diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index b6d7eec..4221e92 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -899,7 +899,6 @@ void __cpuinit pda_init(int cpu)
 
 	load_pda_offset(cpu);
 
-	pda->cpunumber = cpu;
 	pda->irqcount = -1;
 	pda->kernelstack = (unsigned long)stack_thread_info() -
 				 PDA_STACKOFFSET + THREAD_SIZE;
diff --git a/arch/x86/kernel/process_32.c b/arch/x86/kernel/process_32.c
index 77d5468..2c00a57 100644
--- a/arch/x86/kernel/process_32.c
+++ b/arch/x86/kernel/process_32.c
@@ -66,9 +66,6 @@ asmlinkage void ret_from_fork(void) __asm__("ret_from_fork");
 DEFINE_PER_CPU(struct task_struct *, current_task) = &init_task;
 EXPORT_PER_CPU_SYMBOL(current_task);
 
-DEFINE_PER_CPU(int, cpu_number);
-EXPORT_PER_CPU_SYMBOL(cpu_number);
-
 /*
  * Return saved PC of a blocked thread.
  */
diff --git a/arch/x86/kernel/setup_percpu.c b/arch/x86/kernel/setup_percpu.c
index 8b53ef8..258497f 100644
--- a/arch/x86/kernel/setup_percpu.c
+++ b/arch/x86/kernel/setup_percpu.c
@@ -22,6 +22,15 @@
 # define DBG(x...)
 #endif
 
+/*
+ * Could be inside CONFIG_HAVE_SETUP_PER_CPU_AREA with other stuff but
+ * voyager wants cpu_number too.
+ */
+#ifdef CONFIG_SMP
+DEFINE_PER_CPU(int, cpu_number);
+EXPORT_PER_CPU_SYMBOL(cpu_number);
+#endif
+
 #ifdef CONFIG_X86_LOCAL_APIC
 unsigned int num_processors;
 unsigned disabled_cpus __cpuinitdata;
@@ -193,6 +202,7 @@ void __init setup_per_cpu_areas(void)
 		memcpy(ptr, __per_cpu_load, __per_cpu_end - __per_cpu_start);
 		per_cpu_offset(cpu) = ptr - __per_cpu_start;
 		per_cpu(this_cpu_off, cpu) = per_cpu_offset(cpu);
+		per_cpu(cpu_number, cpu) = cpu;
 #ifdef CONFIG_X86_64
 		per_cpu(irq_stack_ptr, cpu) =
 			(char *)per_cpu(irq_stack, cpu) + IRQ_STACK_SIZE - 64;
diff --git a/arch/x86/kernel/smpcommon.c b/arch/x86/kernel/smpcommon.c
index 7e15781..add36b4 100644
--- a/arch/x86/kernel/smpcommon.c
+++ b/arch/x86/kernel/smpcommon.c
@@ -28,7 +28,5 @@ __cpuinit void init_gdt(int cpu)
 
 	write_gdt_entry(get_cpu_gdt_table(cpu),
 			GDT_ENTRY_PERCPU, &gdt, DESCTYPE_S);
-
-	per_cpu(cpu_number, cpu) = cpu;
 }
 #endif
-- 
1.6.0.2

