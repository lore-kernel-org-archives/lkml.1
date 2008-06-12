Return-Path: <linux-kernel-owner+w=401wt.eu-S1756877AbYFLTwC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756877AbYFLTwC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2008 15:52:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755493AbYFLTvj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jun 2008 15:51:39 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:35230 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754748AbYFLTvh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2008 15:51:37 -0400
Date: Thu, 12 Jun 2008 21:51:06 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: the arch/x86 maintainers <x86@kernel.org>, linux-kernel@vger.kernel.org
Subject: [git pull] x86 fixes
Message-ID: <20080612195106.GA17100@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

please pull the latest x86 fixes tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git x86-fixes-for-linus

	Ingo

------------------>
David Howells (1):
      x86: fix an incompatible pointer type warning on 64-bit compilations

Henry Nestler (1):
      x86: fix endless page faults in mount_block_root for Linux 2.6

Ingo Molnar (2):
      geode: fix modular build
      Revert "x86: fix ioapic bug again"

Joe Korty (1):
      x86: fix asm warning in head_32.S

Manish Katiyar (1):
      x86: fix unused variable 'loops' warning in arch/x86/boot/a20.c

Peter Zijlstra (1):
      x86: fix lockdep warning during suspend-to-ram

Vegard Nossum (1):
      x86, lockdep: fix "WARNING: at kernel/lockdep.c:2658 check_flags+0x4c/0x128()"

 arch/x86/boot/a20.c          |    3 +--
 arch/x86/kernel/entry_32.S   |    1 +
 arch/x86/kernel/head_32.S    |    2 +-
 arch/x86/kernel/io_apic_32.c |   12 ++----------
 arch/x86/kernel/mfgpt_32.c   |    2 ++
 arch/x86/kernel/nmi_32.c     |    9 ++-------
 arch/x86/kernel/traps_32.c   |    1 +
 arch/x86/mm/fault.c          |    5 +++++
 arch/x86/mm/init_64.c        |    4 ++--
 9 files changed, 17 insertions(+), 22 deletions(-)

diff --git a/arch/x86/boot/a20.c b/arch/x86/boot/a20.c
index 90943f8..e01aafd 100644
--- a/arch/x86/boot/a20.c
+++ b/arch/x86/boot/a20.c
@@ -115,8 +115,6 @@ static void enable_a20_fast(void)
 
 int enable_a20(void)
 {
-	int loops = A20_ENABLE_LOOPS;
-
 #if defined(CONFIG_X86_ELAN)
 	/* Elan croaks if we try to touch the KBC */
 	enable_a20_fast();
@@ -128,6 +126,7 @@ int enable_a20(void)
 	enable_a20_kbc();
 	return 0;
 #else
+       int loops = A20_ENABLE_LOOPS;
 	while (loops--) {
 		/* First, check to see if A20 is already enabled
 		   (legacy free, etc.) */
diff --git a/arch/x86/kernel/entry_32.S b/arch/x86/kernel/entry_32.S
index 2a609dc..c778e4f 100644
--- a/arch/x86/kernel/entry_32.S
+++ b/arch/x86/kernel/entry_32.S
@@ -248,6 +248,7 @@ ENTRY(resume_userspace)
  	DISABLE_INTERRUPTS(CLBR_ANY)	# make sure we don't miss an interrupt
 					# setting need_resched or sigpending
 					# between sampling and the iret
+	TRACE_IRQS_OFF
 	movl TI_flags(%ebp), %ecx
 	andl $_TIF_WORK_MASK, %ecx	# is there any work to be done on
 					# int/exception return?
diff --git a/arch/x86/kernel/head_32.S b/arch/x86/kernel/head_32.S
index b2cc737..f7357cc 100644
--- a/arch/x86/kernel/head_32.S
+++ b/arch/x86/kernel/head_32.S
@@ -189,7 +189,7 @@ default_entry:
 	 * this stage.
 	 */
 
-#define KPMDS ((0x100000000-__PAGE_OFFSET) >> 30) /* Number of kernel PMDs */
+#define KPMDS (((-__PAGE_OFFSET) >> 30) & 3) /* Number of kernel PMDs */
 
 	xorl %ebx,%ebx				/* %ebx is kept at zero */
 
diff --git a/arch/x86/kernel/io_apic_32.c b/arch/x86/kernel/io_apic_32.c
index a40d54f..4dc8600 100644
--- a/arch/x86/kernel/io_apic_32.c
+++ b/arch/x86/kernel/io_apic_32.c
@@ -2130,14 +2130,10 @@ static inline void __init check_timer(void)
 {
 	int apic1, pin1, apic2, pin2;
 	int vector;
-	unsigned int ver;
 	unsigned long flags;
 
 	local_irq_save(flags);
 
-	ver = apic_read(APIC_LVR);
-	ver = GET_APIC_VERSION(ver);
-
 	/*
 	 * get/set the timer IRQ vector:
 	 */
@@ -2150,15 +2146,11 @@ static inline void __init check_timer(void)
 	 * mode for the 8259A whenever interrupts are routed
 	 * through I/O APICs.  Also IRQ0 has to be enabled in
 	 * the 8259A which implies the virtual wire has to be
-	 * disabled in the local APIC.  Finally timer interrupts
-	 * need to be acknowledged manually in the 8259A for
-	 * timer_interrupt() and for the i82489DX when using
-	 * the NMI watchdog.
+	 * disabled in the local APIC.
 	 */
 	apic_write_around(APIC_LVT0, APIC_LVT_MASKED | APIC_DM_EXTINT);
 	init_8259A(1);
-	timer_ack = !cpu_has_tsc;
-	timer_ack |= (nmi_watchdog == NMI_IO_APIC && !APIC_INTEGRATED(ver));
+	timer_ack = 1;
 	if (timer_over_8254 > 0)
 		enable_8259A_irq(0);
 
diff --git a/arch/x86/kernel/mfgpt_32.c b/arch/x86/kernel/mfgpt_32.c
index 3cad17f..07c0f82 100644
--- a/arch/x86/kernel/mfgpt_32.c
+++ b/arch/x86/kernel/mfgpt_32.c
@@ -155,6 +155,7 @@ int geode_mfgpt_toggle_event(int timer, int cmp, int event, int enable)
 	wrmsr(msr, value, dummy);
 	return 0;
 }
+EXPORT_SYMBOL_GPL(geode_mfgpt_toggle_event);
 
 int geode_mfgpt_set_irq(int timer, int cmp, int irq, int enable)
 {
@@ -222,6 +223,7 @@ int geode_mfgpt_alloc_timer(int timer, int domain)
 	/* No timers available - too bad */
 	return -1;
 }
+EXPORT_SYMBOL_GPL(geode_mfgpt_alloc_timer);
 
 
 #ifdef CONFIG_GEODE_MFGPT_TIMER
diff --git a/arch/x86/kernel/nmi_32.c b/arch/x86/kernel/nmi_32.c
index 11b14bb..84160f7 100644
--- a/arch/x86/kernel/nmi_32.c
+++ b/arch/x86/kernel/nmi_32.c
@@ -26,7 +26,6 @@
 
 #include <asm/smp.h>
 #include <asm/nmi.h>
-#include <asm/timer.h>
 
 #include "mach_traps.h"
 
@@ -82,7 +81,7 @@ int __init check_nmi_watchdog(void)
 
 	prev_nmi_count = kmalloc(NR_CPUS * sizeof(int), GFP_KERNEL);
 	if (!prev_nmi_count)
-		goto error;
+		return -1;
 
 	printk(KERN_INFO "Testing NMI watchdog ... ");
 
@@ -119,7 +118,7 @@ int __init check_nmi_watchdog(void)
 	if (!atomic_read(&nmi_active)) {
 		kfree(prev_nmi_count);
 		atomic_set(&nmi_active, -1);
-		goto error;
+		return -1;
 	}
 	printk("OK.\n");
 
@@ -130,10 +129,6 @@ int __init check_nmi_watchdog(void)
 
 	kfree(prev_nmi_count);
 	return 0;
-error:
-	timer_ack = !cpu_has_tsc;
-
-	return -1;
 }
 
 static int __init setup_nmi_watchdog(char *str)
diff --git a/arch/x86/kernel/traps_32.c b/arch/x86/kernel/traps_32.c
index bde6f63..08d752d 100644
--- a/arch/x86/kernel/traps_32.c
+++ b/arch/x86/kernel/traps_32.c
@@ -544,6 +544,7 @@ vm86_trap:
 #define DO_ERROR(trapnr, signr, str, name)				\
 void do_##name(struct pt_regs *regs, long error_code)			\
 {									\
+	trace_hardirqs_fixup();						\
 	if (notify_die(DIE_TRAP, str, regs, error_code, trapnr, signr)	\
 						== NOTIFY_STOP)		\
 		return;							\
diff --git a/arch/x86/mm/fault.c b/arch/x86/mm/fault.c
index fd7e179..8bcb6f4 100644
--- a/arch/x86/mm/fault.c
+++ b/arch/x86/mm/fault.c
@@ -497,6 +497,11 @@ static int vmalloc_fault(unsigned long address)
 	unsigned long pgd_paddr;
 	pmd_t *pmd_k;
 	pte_t *pte_k;
+
+	/* Make sure we are in vmalloc area */
+	if (!(address >= VMALLOC_START && address < VMALLOC_END))
+		return -1;
+
 	/*
 	 * Synchronize this task's top level page-table
 	 * with the 'reference' page table.
diff --git a/arch/x86/mm/init_64.c b/arch/x86/mm/init_64.c
index 156e6d7..998a06e 100644
--- a/arch/x86/mm/init_64.c
+++ b/arch/x86/mm/init_64.c
@@ -506,7 +506,7 @@ early_param("memtest", parse_memtest);
 
 static void __init early_memtest(unsigned long start, unsigned long end)
 {
-	u64 t_start, t_size;
+	unsigned long t_start, t_size;
 	unsigned pattern;
 
 	if (!memtest_pattern)
@@ -525,7 +525,7 @@ static void __init early_memtest(unsigned long start, unsigned long end)
 			if (t_start + t_size > end)
 				t_size = end - t_start;
 
-			printk(KERN_CONT "\n  %016llx - %016llx pattern %d",
+			printk(KERN_CONT "\n  %016lx - %016lx pattern %d",
 				t_start, t_start + t_size, pattern);
 
 			memtest(t_start, t_size, pattern);
