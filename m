Return-Path: <linux-kernel-owner+w=401wt.eu-S1754155AbYLWRPs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754155AbYLWRPs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Dec 2008 12:15:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752831AbYLWRPH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Dec 2008 12:15:07 -0500
Received: from yx-out-2324.google.com ([74.125.44.28]:31988 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752782AbYLWRPB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Dec 2008 12:15:01 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=PbWlSSUwLan38TAERPQttvTT2PD4rPnduofNaMIj4n4ubJpbR7SxWpu11vynscPW5s
         f+Rh6xc4WFOOe24q5jCDzrBrcegqxY8YPgpGFFEzNEpKGRxn4mdw1Gx0SHh2ipgf7sSn
         73ZaEZLRN03bORrOcP4+RRVNGfHjZ+xXVSbXU=
From: Brian Gerst <brgerst@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Brian Gerst <brgerst@gmail.com>
Subject: [PATCH 3/3] x86-64: Move cpu number from PDA to per-cpu and consolidate with 32-bit.
Date: Tue, 23 Dec 2008 12:15:06 -0500
Message-Id: <1230052506-5041-3-git-send-email-brgerst@gmail.com>
X-Mailer: git-send-email 1.6.1.rc1
In-Reply-To: <1230052506-5041-2-git-send-email-brgerst@gmail.com>
References: <1230052506-5041-1-git-send-email-brgerst@gmail.com>
 <1230052506-5041-2-git-send-email-brgerst@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A simple example of what can now be done to consolidate with the 32-bit
code.

Signed-off-by: Brian Gerst <brgerst@gmail.com>
---
 arch/x86/include/asm/pda.h       |    2 +-
 arch/x86/include/asm/smp.h       |    4 +---
 arch/x86/kernel/asm-offsets_64.c |    1 -
 arch/x86/kernel/cpu/common.c     |    1 -
 arch/x86/kernel/process_32.c     |    3 ---
 arch/x86/kernel/setup_percpu.c   |    4 ++++
 arch/x86/kernel/smpcommon.c      |    1 -
 7 files changed, 6 insertions(+), 10 deletions(-)

diff --git a/arch/x86/include/asm/pda.h b/arch/x86/include/asm/pda.h
index b008127..3ace2b9 100644
--- a/arch/x86/include/asm/pda.h
+++ b/arch/x86/include/asm/pda.h
@@ -15,7 +15,7 @@ struct x8664_pda {
 	unsigned long kernelstack;	/* 16 top of kernel stack for current */
 	unsigned long oldrsp;		/* 24 user rsp for system call */
 	int irqcount;			/* 32 Irq nesting counter. Starts -1 */
-	unsigned int cpunumber;		/* 36 Logical CPU number */
+	unsigned int unused1;		/* 36 was cpunumber */
 #ifdef CONFIG_CC_STACKPROTECTOR
 	unsigned long stack_canary;	/* 40 stack canary value */
 					/* gcc-ABI: this canary MUST be at
diff --git a/arch/x86/include/asm/smp.h b/arch/x86/include/asm/smp.h
index d12811c..f2e4b9c 100644
--- a/arch/x86/include/asm/smp.h
+++ b/arch/x86/include/asm/smp.h
@@ -34,9 +34,7 @@ extern cpumask_t cpu_initialized;
 DECLARE_PER_CPU(cpumask_t, cpu_sibling_map);
 DECLARE_PER_CPU(cpumask_t, cpu_core_map);
 DECLARE_PER_CPU(u16, cpu_llc_id);
-#ifdef CONFIG_X86_32
 DECLARE_PER_CPU(int, cpu_number);
-#endif
 
 DECLARE_EARLY_PER_CPU(u16, x86_cpu_to_apicid);
 DECLARE_EARLY_PER_CPU(u16, x86_bios_cpu_apicid);
@@ -169,7 +167,7 @@ extern unsigned disabled_cpus __cpuinitdata;
 extern int safe_smp_processor_id(void);
 
 #elif defined(CONFIG_X86_64_SMP)
-#define raw_smp_processor_id()	read_pda(cpunumber)
+#define raw_smp_processor_id() (x86_read_percpu(cpu_number))
 
 #define stack_smp_processor_id()					\
 ({								\
diff --git a/arch/x86/kernel/asm-offsets_64.c b/arch/x86/kernel/asm-offsets_64.c
index 7fcf63d..b14bb4e 100644
--- a/arch/x86/kernel/asm-offsets_64.c
+++ b/arch/x86/kernel/asm-offsets_64.c
@@ -51,7 +51,6 @@ int main(void)
 	ENTRY(oldrsp); 
 	ENTRY(pcurrent); 
 	ENTRY(irqcount);
-	ENTRY(cpunumber);
 	ENTRY(irqstackptr);
 	ENTRY(data_offset);
 	BLANK();
diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index 7d741ef..82ad755 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -876,7 +876,6 @@ void __cpuinit pda_init(int cpu)
 	wrmsrl(MSR_GS_BASE, pda);
 	mb();
 
-	pda->cpunumber = cpu;
 	pda->irqcount = -1;
 	pda->kernelstack = (unsigned long)stack_thread_info() -
 				 PDA_STACKOFFSET + THREAD_SIZE;
diff --git a/arch/x86/kernel/process_32.c b/arch/x86/kernel/process_32.c
index 0a1302f..4bb0a7d 100644
--- a/arch/x86/kernel/process_32.c
+++ b/arch/x86/kernel/process_32.c
@@ -65,9 +65,6 @@ asmlinkage void ret_from_fork(void) __asm__("ret_from_fork");
 DEFINE_PER_CPU(struct task_struct *, current_task) = &init_task;
 EXPORT_PER_CPU_SYMBOL(current_task);
 
-DEFINE_PER_CPU(int, cpu_number);
-EXPORT_PER_CPU_SYMBOL(cpu_number);
-
 /*
  * Return saved PC of a blocked thread.
  */
diff --git a/arch/x86/kernel/setup_percpu.c b/arch/x86/kernel/setup_percpu.c
index fb0ccdc..f013781 100644
--- a/arch/x86/kernel/setup_percpu.c
+++ b/arch/x86/kernel/setup_percpu.c
@@ -15,6 +15,9 @@
 #include <asm/apicdef.h>
 #include <asm/highmem.h>
 
+DEFINE_PER_CPU(int, cpu_number);
+EXPORT_PER_CPU_SYMBOL(cpu_number);
+
 #ifdef CONFIG_X86_LOCAL_APIC
 unsigned int num_processors;
 unsigned disabled_cpus __cpuinitdata;
@@ -133,6 +136,7 @@ void __init setup_per_cpu_areas(void)
 			memset(&per_cpu(pda, cpu), 0, sizeof(struct x8664_pda));
 		per_cpu(pda, cpu).data_offset = __per_cpu_offset[cpu];
 #endif
+		per_cpu(cpu_number, cpu) = cpu;
 	}
 
 #ifdef CONFIG_X86_64
diff --git a/arch/x86/kernel/smpcommon.c b/arch/x86/kernel/smpcommon.c
index 397e309..db7c5a6 100644
--- a/arch/x86/kernel/smpcommon.c
+++ b/arch/x86/kernel/smpcommon.c
@@ -25,6 +25,5 @@ __cpuinit void init_gdt(int cpu)
 			GDT_ENTRY_PERCPU, &gdt, DESCTYPE_S);
 
 	per_cpu(this_cpu_off, cpu) = __per_cpu_offset[cpu];
-	per_cpu(cpu_number, cpu) = cpu;
 }
 #endif
-- 
1.6.1.rc1

