Return-Path: <linux-kernel-owner+w=401wt.eu-S1755974AbZAMKjR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755974AbZAMKjR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2009 05:39:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751853AbZAMKjA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Jan 2009 05:39:00 -0500
Received: from hera.kernel.org ([140.211.167.34]:51095 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751243AbZAMKi7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2009 05:38:59 -0500
From: Tejun Heo <tj@kernel.org>
To: ebiederm@xmission.com, cl@linux-foundation.org, rusty@rustcorp.com.au,
       mingo@elte.hu, travis@sgi.com, linux-kernel@vger.kernel.org,
       hpa@zytor.com, akpm@linux-foundation.org, steiner@sgi.com,
       hugh@veritas.com
Cc: Tejun Heo <tj@kernel.org>
Subject: [PATCH 10/13] x86_64: make pda a percpu variable
Date: Tue, 13 Jan 2009 19:38:14 +0900
Message-Id: <1231843097-18003-11-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.5.6
In-Reply-To: <1231843097-18003-1-git-send-email-tj@kernel.org>
References: <1231843097-18003-1-git-send-email-tj@kernel.org>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 13 Jan 2009 10:38:37 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As pda is now allocated in percpu area, it can easily be made a proper
percpu variable.  Make it so by defining per cpu symbol from linker
script and declaring it in C code for SMP and simply defining it for
UP.  This change cleans up code and brings SMP and UP closer a bit.

A lot of this patch is taken from Mike Travis' "x86_64: Fold pda into
per cpu area" and "x86_64: Reference zero-based percpu variables
offset from gs" patches.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Mike Travis <travis@sgi.com>
---
 arch/x86/include/asm/pda.h       |    5 +++--
 arch/x86/kernel/cpu/common.c     |    3 ---
 arch/x86/kernel/head64.c         |   10 ----------
 arch/x86/kernel/head_64.S        |    5 +++--
 arch/x86/kernel/setup_percpu.c   |   16 ++++++++++++++--
 arch/x86/kernel/vmlinux_64.lds.S |    4 +++-
 6 files changed, 23 insertions(+), 20 deletions(-)

diff --git a/arch/x86/include/asm/pda.h b/arch/x86/include/asm/pda.h
index e91558e..66ae104 100644
--- a/arch/x86/include/asm/pda.h
+++ b/arch/x86/include/asm/pda.h
@@ -7,6 +7,7 @@
 #include <linux/cache.h>
 #include <linux/threads.h>
 #include <asm/page.h>
+#include <asm/percpu.h>
 
 /* Per processor datastructure. %gs points to it while the kernel runs */
 struct x8664_pda {
@@ -39,10 +40,10 @@ struct x8664_pda {
 	unsigned irq_spurious_count;
 } ____cacheline_aligned_in_smp;
 
-extern struct x8664_pda *_cpu_pda[NR_CPUS];
+DECLARE_PER_CPU(struct x8664_pda, __pda);
 extern void pda_init(int);
 
-#define cpu_pda(i) (_cpu_pda[i])
+#define cpu_pda(cpu)		(&per_cpu(__pda, cpu))
 
 /*
  * There is no fast way to get the base address of the PDA, all the accesses
diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index cdd419a..bd38a0f 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -859,9 +859,6 @@ __setup("clearcpuid=", setup_disablecpuid);
 cpumask_t cpu_initialized __cpuinitdata = CPU_MASK_NONE;
 
 #ifdef CONFIG_X86_64
-struct x8664_pda *_cpu_pda[NR_CPUS] __read_mostly;
-EXPORT_SYMBOL(_cpu_pda);
-
 struct desc_ptr idt_descr = { 256 * 16 - 1, (unsigned long) idt_table };
 
 static char boot_cpu_stack[IRQSTACKSIZE] __page_aligned_bss;
diff --git a/arch/x86/kernel/head64.c b/arch/x86/kernel/head64.c
index 9194074..71b6f6e 100644
--- a/arch/x86/kernel/head64.c
+++ b/arch/x86/kernel/head64.c
@@ -26,18 +26,8 @@
 #include <asm/bios_ebda.h>
 #include <asm/trampoline.h>
 
-#ifndef CONFIG_SMP
-/* boot cpu pda, referenced by head_64.S to initialize %gs on UP */
-struct x8664_pda _boot_cpu_pda __read_mostly;
-#endif
-
 void __init x86_64_init_pda(void)
 {
-#ifdef CONFIG_SMP
-	cpu_pda(0) = (void *)__per_cpu_load;
-#else
-	cpu_pda(0) = &_boot_cpu_pda;
-#endif
 	pda_init(0);
 }
 
diff --git a/arch/x86/kernel/head_64.S b/arch/x86/kernel/head_64.S
index 519185f..ce5975c 100644
--- a/arch/x86/kernel/head_64.S
+++ b/arch/x86/kernel/head_64.S
@@ -19,6 +19,7 @@
 #include <asm/msr.h>
 #include <asm/cache.h>
 #include <asm/processor-flags.h>
+#include <asm/percpu.h>
 
 #ifdef CONFIG_PARAVIRT
 #include <asm/asm-offsets.h>
@@ -250,7 +251,7 @@ ENTRY(secondary_startup_64)
 	 * secondary CPU,initial_gs should be set to its pda address
 	 * before the CPU runs this code.
 	 *
-	 * On UP, initial_gs points to _boot_cpu_pda and doesn't
+	 * On UP, initial_gs points to PER_CPU_VAR(__pda) and doesn't
 	 * change.
 	 */
 	movl	$MSR_GS_BASE,%ecx
@@ -284,7 +285,7 @@ ENTRY(secondary_startup_64)
 #ifdef CONFIG_SMP
 	.quad	__per_cpu_load
 #else
-	.quad	_boot_cpu_pda
+	.quad	PER_CPU_VAR(__pda)
 #endif
 	__FINITDATA
 
diff --git a/arch/x86/kernel/setup_percpu.c b/arch/x86/kernel/setup_percpu.c
index 76a2498..9edc081 100644
--- a/arch/x86/kernel/setup_percpu.c
+++ b/arch/x86/kernel/setup_percpu.c
@@ -66,6 +66,16 @@ static void __init setup_node_to_cpumask_map(void);
 static inline void setup_node_to_cpumask_map(void) { }
 #endif
 
+/*
+ * Define load_pda_offset() and per-cpu __pda for x86_64.
+ * load_pda_offset() is responsible for loading the offset of pda into
+ * %gs.
+ *
+ * On SMP, pda offset also duals as percpu base address and thus it
+ * should be at the start of per-cpu area.  To achieve this, it's
+ * preallocated in vmlinux_64.lds.S directly instead of using
+ * DEFINE_PER_CPU().
+ */
 #ifdef CONFIG_X86_64
 void __cpuinit load_pda_offset(int cpu)
 {
@@ -74,6 +84,10 @@ void __cpuinit load_pda_offset(int cpu)
 	wrmsrl(MSR_GS_BASE, cpu_pda(cpu));
 	mb();
 }
+#ifndef CONFIG_SMP
+DEFINE_PER_CPU(struct x8664_pda, __pda);
+#endif
+EXPORT_PER_CPU_SYMBOL(__pda);
 #endif
 
 #ifdef CONFIG_HAVE_SETUP_PER_CPU_AREA
@@ -161,8 +175,6 @@ void __init setup_per_cpu_areas(void)
 		memcpy(ptr, __per_cpu_load, __per_cpu_end - __per_cpu_start);
 		per_cpu_offset(cpu) = ptr - __per_cpu_start;
 #ifdef CONFIG_X86_64
-		cpu_pda(cpu) = (void *)ptr;
-
 		/*
 		 * CPU0 modified pda in the init data area, reload pda
 		 * offset for CPU0 and clear the area for others.
diff --git a/arch/x86/kernel/vmlinux_64.lds.S b/arch/x86/kernel/vmlinux_64.lds.S
index 962f21f..d2a0baa 100644
--- a/arch/x86/kernel/vmlinux_64.lds.S
+++ b/arch/x86/kernel/vmlinux_64.lds.S
@@ -217,10 +217,12 @@ SECTIONS
    * percpu offsets are zero-based on SMP.  PERCPU_VADDR() changes the
    * output PHDR, so the next output section - __data_nosave - should
    * switch it back to data.init.  Also, pda should be at the head of
-   * percpu area.  Preallocate it.
+   * percpu area.  Preallocate it and define the percpu offset symbol
+   * so that it can be accessed as a percpu variable.
    */
   . = ALIGN(PAGE_SIZE);
   PERCPU_VADDR_PREALLOC(0, :percpu, pda_size)
+  per_cpu____pda = __per_cpu_start;
 #else
   PERCPU(PAGE_SIZE)
 #endif
-- 
1.5.6

