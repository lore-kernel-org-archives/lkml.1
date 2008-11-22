Return-Path: <linux-kernel-owner+w=401wt.eu-S1759240AbYKVRe1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759240AbYKVRe1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Nov 2008 12:34:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759155AbYKVRd5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Nov 2008 12:33:57 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:55305 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759139AbYKVRdz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Nov 2008 12:33:55 -0500
To: torvalds@linux-foundation.org
Subject: [PATCH 4/32] sparc32 cpuinit flase positives
Cc: linux-kernel@vger.kernel.org, davem@davemloft.net
Message-Id: <E1L3wMk-0006Iq-IO@ZenIV.linux.org.uk>
From: Al Viro <viro@ftp.linux.org.uk>
Date: Sat, 22 Nov 2008 17:33:54 +0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


All noise since we don't have CPU hotplug there.  However, they
did expose something very odd-looking in there - poke_viking()
does a bunch of identical btfixup each time it's called (i.e.
for each CPU).  That one is left alone for now; just the trivial
misannotation fixes.

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 arch/sparc/kernel/cpu.c        |    2 +-
 arch/sparc/kernel/smp.c        |    4 ++--
 arch/sparc/kernel/sun4d_smp.c  |    4 ++--
 arch/sparc/kernel/sun4m_smp.c  |    2 +-
 arch/sparc/kernel/trampoline.S |    4 ++--
 arch/sparc/mm/srmmu.c          |   14 +++++++-------
 6 files changed, 15 insertions(+), 15 deletions(-)

diff --git a/arch/sparc/kernel/cpu.c b/arch/sparc/kernel/cpu.c
--- a/arch/sparc/kernel/cpu.c
+++ b/arch/sparc/kernel/cpu.c
@@ -126,7 +126,7 @@ char *sparc_fpu_type;
 
 unsigned int fsr_storage;
 
-void __init cpu_probe(void)
+void __cpuinit cpu_probe(void)
 {
 	int psr_impl, psr_vers, fpu_vers;
 	int i, psr;
diff --git a/arch/sparc/kernel/smp.c b/arch/sparc/kernel/smp.c
--- a/arch/sparc/kernel/smp.c
+++ b/arch/sparc/kernel/smp.c
@@ -35,7 +35,7 @@
 
 #include "irq.h"
 
-volatile unsigned long cpu_callin_map[NR_CPUS] __initdata = {0,};
+volatile unsigned long cpu_callin_map[NR_CPUS] __cpuinitdata = {0,};
 unsigned char boot_cpu_id = 0;
 unsigned char boot_cpu_id4 = 0; /* boot_cpu_id << 2 */
 
@@ -120,7 +120,7 @@ void cpu_panic(void)
 	panic("SMP bolixed\n");
 }
 
-struct linux_prom_registers smp_penguin_ctable __initdata = { 0 };
+struct linux_prom_registers smp_penguin_ctable __cpuinitdata = { 0 };
 
 void smp_send_reschedule(int cpu)
 {
diff --git a/arch/sparc/kernel/sun4d_smp.c b/arch/sparc/kernel/sun4d_smp.c
--- a/arch/sparc/kernel/sun4d_smp.c
+++ b/arch/sparc/kernel/sun4d_smp.c
@@ -83,7 +83,7 @@ static inline void show_leds(int cpuid)
 			      "i" (ASI_M_CTL));
 }
 
-void __init smp4d_callin(void)
+void __cpuinit smp4d_callin(void)
 {
 	int cpuid = hard_smp4d_processor_id();
 	extern spinlock_t sun4d_imsk_lock;
@@ -386,7 +386,7 @@ void smp4d_percpu_timer_interrupt(struct pt_regs *regs)
 
 extern unsigned int lvl14_resolution;
 
-static void __init smp_setup_percpu_timer(void)
+static void __cpuinit smp_setup_percpu_timer(void)
 {
 	int cpu = hard_smp4d_processor_id();
 
diff --git a/arch/sparc/kernel/sun4m_smp.c b/arch/sparc/kernel/sun4m_smp.c
--- a/arch/sparc/kernel/sun4m_smp.c
+++ b/arch/sparc/kernel/sun4m_smp.c
@@ -343,7 +343,7 @@ void smp4m_percpu_timer_interrupt(struct pt_regs *regs)
 
 extern unsigned int lvl14_resolution;
 
-static void __init smp_setup_percpu_timer(void)
+static void __cpuinit smp_setup_percpu_timer(void)
 {
 	int cpu = smp_processor_id();
 
diff --git a/arch/sparc/kernel/trampoline.S b/arch/sparc/kernel/trampoline.S
--- a/arch/sparc/kernel/trampoline.S
+++ b/arch/sparc/kernel/trampoline.S
@@ -18,7 +18,7 @@
 	.globl sun4m_cpu_startup, __smp4m_processor_id
 	.globl sun4d_cpu_startup, __smp4d_processor_id
 
-	__INIT
+	__CPUINIT
 	.align 4
 
 /* When we start up a cpu for the first time it enters this routine.
@@ -109,7 +109,7 @@ __smp4d_processor_id:
 /* CPUID in bootbus can be found at PA 0xff0140000 */
 #define SUN4D_BOOTBUS_CPUID	0xf0140000
 
-	__INIT
+	__CPUINIT
 	.align	4
 
 sun4d_cpu_startup:
diff --git a/arch/sparc/mm/srmmu.c b/arch/sparc/mm/srmmu.c
--- a/arch/sparc/mm/srmmu.c
+++ b/arch/sparc/mm/srmmu.c
@@ -1251,7 +1251,7 @@ static inline void map_kernel(void)
 /* Paging initialization on the Sparc Reference MMU. */
 extern void sparc_context_init(int);
 
-void (*poke_srmmu)(void) __initdata = NULL;
+void (*poke_srmmu)(void) __cpuinitdata = NULL;
 
 extern unsigned long bootmem_init(unsigned long *pages_avail);
 
@@ -1446,7 +1446,7 @@ static void __init init_vac_layout(void)
 	       (int)vac_cache_size, (int)vac_line_size);
 }
 
-static void __init poke_hypersparc(void)
+static void __cpuinit poke_hypersparc(void)
 {
 	volatile unsigned long clear;
 	unsigned long mreg = srmmu_get_mmureg();
@@ -1501,7 +1501,7 @@ static void __init init_hypersparc(void)
 	hypersparc_setup_blockops();
 }
 
-static void __init poke_cypress(void)
+static void __cpuinit poke_cypress(void)
 {
 	unsigned long mreg = srmmu_get_mmureg();
 	unsigned long faddr, tagval;
@@ -1589,7 +1589,7 @@ static void __init init_cypress_605(unsigned long mrev)
 	init_cypress_common();
 }
 
-static void __init poke_swift(void)
+static void __cpuinit poke_swift(void)
 {
 	unsigned long mreg;
 
@@ -1771,7 +1771,7 @@ static void turbosparc_flush_tlb_page(struct vm_area_struct *vma, unsigned long
 }
 
 
-static void __init poke_turbosparc(void)
+static void __cpuinit poke_turbosparc(void)
 {
 	unsigned long mreg = srmmu_get_mmureg();
 	unsigned long ccreg;
@@ -1834,7 +1834,7 @@ static void __init init_turbosparc(void)
 	poke_srmmu = poke_turbosparc;
 }
 
-static void __init poke_tsunami(void)
+static void __cpuinit poke_tsunami(void)
 {
 	unsigned long mreg = srmmu_get_mmureg();
 
@@ -1876,7 +1876,7 @@ static void __init init_tsunami(void)
 	tsunami_setup_blockops();
 }
 
-static void __init poke_viking(void)
+static void __cpuinit poke_viking(void)
 {
 	unsigned long mreg = srmmu_get_mmureg();
 	static int smp_catch;
