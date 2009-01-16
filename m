Return-Path: <linux-kernel-owner+w=401wt.eu-S935511AbZAPORY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935511AbZAPORY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2009 09:17:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933428AbZAPOQp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Jan 2009 09:16:45 -0500
Received: from yx-out-2324.google.com ([74.125.44.30]:32961 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760167AbZAPOQo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2009 09:16:44 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=Nyy74fJWSL23Osv9pC8rFAT9sr6tKWcWqc33NG8VHKQAM+ZLWMlGz0NvIEM7gL65Le
         Zsn7M21gFPuKxkRFJ43tqYGC7AqI2BmHmbQCPwH3uigYb/D8FVnjX0c4710INvsXKIFz
         uU3E2Y0PAgWEwWnrWREPVDuUJ0ff+8RS6apME=
From: Brian Gerst <brgerst@gmail.com>
To: Tejun Heo <tj@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Brian Gerst <brgerst@gmail.com>
Subject: [PATCH 05/17] x86-64: Move cpu number from PDA to per-cpu and consolidate with 32-bit.
Date: Fri, 16 Jan 2009 09:16:24 -0500
Message-Id: <1232115396-26367-5-git-send-email-brgerst@gmail.com>
X-Mailer: git-send-email 1.6.1.rc1
In-Reply-To: <1232115396-26367-4-git-send-email-brgerst@gmail.com>
References: <73c1f2160901160610l57e31a64j56fe9544bd2fd309@mail.gmail.com>
 <1232115396-26367-1-git-send-email-brgerst@gmail.com>
 <1232115396-26367-2-git-send-email-brgerst@gmail.com>
 <1232115396-26367-3-git-send-email-brgerst@gmail.com>
 <1232115396-26367-4-git-send-email-brgerst@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Brian Gerst <brgerst@gmail.com>
---
 arch/x86/include/asm/pda.h       |    2 +-
 arch/x86/include/asm/smp.h       |    4 +---
 arch/x86/kernel/asm-offsets_64.c |    1 -
 arch/x86/kernel/cpu/common.c     |    1 -
 arch/x86/kernel/process_32.c     |    3 ---
 arch/x86/kernel/setup_percpu.c   |    4 ++++
 arch/x86/kernel/smpcommon.c      |    2 --
 7 files changed, 6 insertions(+), 11 deletions(-)

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
index 70ce998..1cf466f 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -894,7 +894,6 @@ void __cpuinit pda_init(int cpu)
 
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
index e3d399f..bd38127 100644
--- a/arch/x86/kernel/setup_percpu.c
+++ b/arch/x86/kernel/setup_percpu.c
@@ -147,6 +147,9 @@ unsigned long __per_cpu_offset[NR_CPUS] __read_mostly;
 #endif
 EXPORT_SYMBOL(__per_cpu_offset);
 
+DEFINE_PER_CPU(int, cpu_number);
+EXPORT_PER_CPU_SYMBOL(cpu_number);
+
 /*
  * Great future plan:
  * Declare PDA itself and support (irqstack,tss,pgd) as per cpu data.
@@ -193,6 +196,7 @@ void __init setup_per_cpu_areas(void)
 		memcpy(ptr, __per_cpu_load, __per_cpu_end - __per_cpu_start);
 		per_cpu_offset(cpu) = ptr - __per_cpu_start;
 		per_cpu(this_cpu_off, cpu) = per_cpu_offset(cpu);
+		per_cpu(cpu_number, cpu) = cpu;
 #ifdef CONFIG_X86_64
 		per_cpu(irqstackptr, cpu) = per_cpu(irqstack, cpu) + IRQSTACKSIZE - 64;
 		/*
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
1.6.1.rc1

