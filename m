Return-Path: <linux-kernel-owner+w=401wt.eu-S933956AbXCFFiF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933956AbXCFFiF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2007 00:38:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933954AbXCFFiF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Mar 2007 00:38:05 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:54784
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S933946AbXCFFiA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2007 00:38:00 -0500
Date: Mon, 05 Mar 2007 21:37:57 -0800 (PST)
Message-Id: <20070305.213757.78733139.davem@davemloft.net>
To: tglx@linutronix.de
CC: linux-kernel@vger.kernel.org, sparclinux@vger.kernel.org
Subject: [PATCH 2/4]: [SPARC64]: Unify timer interrupt handler.
From: David Miller <davem@davemloft.net>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


>From 6f7ea1d2d56aa7c6cc0e1ae98d8e40eb9de27d16 Mon Sep 17 00:00:00 2001
From: David S. Miller <davem@sunset.davemloft.net>
Date: Thu, 22 Feb 2007 06:24:10 -0800
Subject: [PATCH] [SPARC64]: Unify timer interrupt handler.

Things were scattered all over the place, split between
SMP and non-SMP.

Unify it all so that dyntick support is easier to add.

Signed-off-by: David S. Miller <davem@davemloft.net>
---
 arch/sparc64/kernel/irq.c     |   26 ------------
 arch/sparc64/kernel/smp.c     |   87 +----------------------------------------
 arch/sparc64/kernel/time.c    |   43 ++++++++------------
 arch/sparc64/kernel/ttable.S  |    6 +--
 include/asm-sparc64/cpudata.h |    4 +-
 include/asm-sparc64/smp.h     |    4 +-
 include/asm-sparc64/ttable.h  |   27 -------------
 7 files changed, 25 insertions(+), 172 deletions(-)

diff --git a/arch/sparc64/kernel/irq.c b/arch/sparc64/kernel/irq.c
index c443db1..d1bb3b3 100644
--- a/arch/sparc64/kernel/irq.c
+++ b/arch/sparc64/kernel/irq.c
@@ -589,32 +589,6 @@ void ack_bad_irq(unsigned int virt_irq)
 	       ino, virt_irq);
 }
 
-#ifndef CONFIG_SMP
-extern irqreturn_t timer_interrupt(int, void *);
-
-void timer_irq(int irq, struct pt_regs *regs)
-{
-	unsigned long clr_mask = 1 << irq;
-	unsigned long tick_mask = tick_ops->softint_mask;
-	struct pt_regs *old_regs;
-
-	if (get_softint() & tick_mask) {
-		irq = 0;
-		clr_mask = tick_mask;
-	}
-	clear_softint(clr_mask);
-
-	old_regs = set_irq_regs(regs);
-	irq_enter();
-
-	kstat_this_cpu.irqs[0]++;
-	timer_interrupt(irq, NULL);
-
-	irq_exit();
-	set_irq_regs(old_regs);
-}
-#endif
-
 void handler_irq(int irq, struct pt_regs *regs)
 {
 	struct ino_bucket *bucket;
diff --git a/arch/sparc64/kernel/smp.c b/arch/sparc64/kernel/smp.c
index fc99f7b..39deb03 100644
--- a/arch/sparc64/kernel/smp.c
+++ b/arch/sparc64/kernel/smp.c
@@ -45,7 +45,7 @@
 extern void calibrate_delay(void);
 
 /* Please don't make this stuff initdata!!!  --DaveM */
-static unsigned char boot_cpu_id;
+unsigned char boot_cpu_id;
 
 cpumask_t cpu_online_map __read_mostly = CPU_MASK_NONE;
 cpumask_t phys_cpu_present_map __read_mostly = CPU_MASK_NONE;
@@ -81,8 +81,6 @@ void __init smp_store_cpu_info(int id)
 	struct device_node *dp;
 	int def;
 
-	/* multiplier and counter set by
-	   smp_setup_percpu_timer()  */
 	cpu_data(id).udelay_val			= loops_per_jiffy;
 
 	cpu_find_by_mid(id, &dp);
@@ -1180,75 +1178,10 @@ void smp_penguin_jailcell(int irq, struct pt_regs *regs)
 	preempt_enable();
 }
 
-#define prof_multiplier(__cpu)		cpu_data(__cpu).multiplier
-#define prof_counter(__cpu)		cpu_data(__cpu).counter
-
-void smp_percpu_timer_interrupt(struct pt_regs *regs)
-{
-	unsigned long compare, tick, pstate;
-	int cpu = smp_processor_id();
-	int user = user_mode(regs);
-	struct pt_regs *old_regs;
-
-	/*
-	 * Check for level 14 softint.
-	 */
-	{
-		unsigned long tick_mask = tick_ops->softint_mask;
-
-		if (!(get_softint() & tick_mask)) {
-			extern void handler_irq(int, struct pt_regs *);
-
-			handler_irq(14, regs);
-			return;
-		}
-		clear_softint(tick_mask);
-	}
-
-	old_regs = set_irq_regs(regs);
-	do {
-		profile_tick(CPU_PROFILING);
-		if (!--prof_counter(cpu)) {
-			irq_enter();
-
-			if (cpu == boot_cpu_id) {
-				kstat_this_cpu.irqs[0]++;
-				timer_tick_interrupt(regs);
-			}
-
-			update_process_times(user);
-
-			irq_exit();
-
-			prof_counter(cpu) = prof_multiplier(cpu);
-		}
-
-		/* Guarantee that the following sequences execute
-		 * uninterrupted.
-		 */
-		__asm__ __volatile__("rdpr	%%pstate, %0\n\t"
-				     "wrpr	%0, %1, %%pstate"
-				     : "=r" (pstate)
-				     : "i" (PSTATE_IE));
-
-		compare = tick_ops->add_compare(current_tick_offset);
-		tick = tick_ops->get_tick();
-
-		/* Restore PSTATE_IE. */
-		__asm__ __volatile__("wrpr	%0, 0x0, %%pstate"
-				     : /* no outputs */
-				     : "r" (pstate));
-	} while (time_after_eq(tick, compare));
-	set_irq_regs(old_regs);
-}
-
 static void __init smp_setup_percpu_timer(void)
 {
-	int cpu = smp_processor_id();
 	unsigned long pstate;
 
-	prof_counter(cpu) = prof_multiplier(cpu) = 1;
-
 	/* Guarantee that the following sequences execute
 	 * uninterrupted.
 	 */
@@ -1269,28 +1202,12 @@ void __init smp_tick_init(void)
 {
 	boot_cpu_id = hard_smp_processor_id();
 	current_tick_offset = timer_tick_offset;
-
-	prof_counter(boot_cpu_id) = prof_multiplier(boot_cpu_id) = 1;
 }
 
 /* /proc/profile writes can call this, don't __init it please. */
-static DEFINE_SPINLOCK(prof_setup_lock);
-
 int setup_profiling_timer(unsigned int multiplier)
 {
-	unsigned long flags;
-	int i;
-
-	if ((!multiplier) || (timer_tick_offset / multiplier) < 1000)
-		return -EINVAL;
-
-	spin_lock_irqsave(&prof_setup_lock, flags);
-	for_each_possible_cpu(i)
-		prof_multiplier(i) = multiplier;
-	current_tick_offset = (timer_tick_offset / multiplier);
-	spin_unlock_irqrestore(&prof_setup_lock, flags);
-
-	return 0;
+	return -EINVAL;
 }
 
 static void __init smp_tune_scheduling(void)
diff --git a/arch/sparc64/kernel/time.c b/arch/sparc64/kernel/time.c
index d457079..48e1217 100644
--- a/arch/sparc64/kernel/time.c
+++ b/arch/sparc64/kernel/time.c
@@ -31,6 +31,7 @@
 #include <linux/profile.h>
 #include <linux/miscdevice.h>
 #include <linux/rtc.h>
+#include <linux/kernel_stat.h>
 
 #include <asm/oplib.h>
 #include <asm/mostek.h>
@@ -423,12 +424,6 @@ static struct sparc64_tick_ops hbtick_operations __read_mostly = {
 	.softint_mask	=	1UL << 0,
 };
 
-/* timer_interrupt() needs to keep up the real-time clock,
- * as well as call the "do_timer()" routine every clocktick
- *
- * NOTE: On SUN5 systems the ticker interrupt comes in using 2
- *       interrupts, one at level14 and one with softint bit 0.
- */
 unsigned long timer_tick_offset __read_mostly;
 
 static unsigned long timer_ticks_per_nsec_quotient __read_mostly;
@@ -487,18 +482,27 @@ void notify_arch_cmos_timer(void)
 	mod_timer(&sync_cmos_timer, jiffies + 1);
 }
 
-irqreturn_t timer_interrupt(int irq, void *dev_id)
+void timer_interrupt(int irq, struct pt_regs *regs)
 {
+	struct pt_regs *old_regs = set_irq_regs(regs);
 	unsigned long ticks, compare, pstate;
+	unsigned long tick_mask = tick_ops->softint_mask;
+
+	clear_softint(tick_mask);
+
+	irq_enter();
 
-	write_seqlock(&xtime_lock);
+	kstat_this_cpu.irqs[0]++;
 
 	do {
-#ifndef CONFIG_SMP
 		profile_tick(CPU_PROFILING);
 		update_process_times(user_mode(get_irq_regs()));
-#endif
-		do_timer(1);
+
+		if (smp_processor_id() == boot_cpu_id) {
+			write_seqlock(&xtime_lock);
+			do_timer(1);
+			write_sequnlock(&xtime_lock);
+		}
 
 		/* Guarantee that the following sequences execute
 		 * uninterrupted.
@@ -515,24 +519,13 @@ irqreturn_t timer_interrupt(int irq, void *dev_id)
 		__asm__ __volatile__("wrpr	%0, 0x0, %%pstate"
 				     : /* no outputs */
 				     : "r" (pstate));
-	} while (time_after_eq(ticks, compare));
+	} while (unlikely(time_after_eq(ticks, compare)));
 
-	write_sequnlock(&xtime_lock);
+	irq_exit();
 
-	return IRQ_HANDLED;
+	set_irq_regs(old_regs);
 }
 
-#ifdef CONFIG_SMP
-void timer_tick_interrupt(struct pt_regs *regs)
-{
-	write_seqlock(&xtime_lock);
-
-	do_timer(1);
-
-	write_sequnlock(&xtime_lock);
-}
-#endif
-
 /* Kick start a stopped clock (procedure from the Sun NVRAM/hostid FAQ). */
 static void __init kick_start_clock(void)
 {
diff --git a/arch/sparc64/kernel/ttable.S b/arch/sparc64/kernel/ttable.S
index d7d2a8b..7575aa3 100644
--- a/arch/sparc64/kernel/ttable.S
+++ b/arch/sparc64/kernel/ttable.S
@@ -60,11 +60,7 @@ tl0_irq4:	BTRAP(0x44)
 tl0_irq5:	TRAP_IRQ(handler_irq, 5)
 tl0_irq6:	BTRAP(0x46) BTRAP(0x47) BTRAP(0x48) BTRAP(0x49)
 tl0_irq10:	BTRAP(0x4a) BTRAP(0x4b) BTRAP(0x4c) BTRAP(0x4d)
-#ifndef CONFIG_SMP
-tl0_irq14:	TRAP_IRQ(timer_irq, 14)
-#else
-tl0_irq14:	TICK_SMP_IRQ
-#endif
+tl0_irq14:	TRAP_IRQ(timer_interrupt, 14)
 tl0_irq15:	TRAP_IRQ(handler_irq, 15)
 tl0_resv050:	BTRAP(0x50) BTRAP(0x51) BTRAP(0x52) BTRAP(0x53) BTRAP(0x54) BTRAP(0x55)
 tl0_resv056:	BTRAP(0x56) BTRAP(0x57) BTRAP(0x58) BTRAP(0x59) BTRAP(0x5a) BTRAP(0x5b)
diff --git a/include/asm-sparc64/cpudata.h b/include/asm-sparc64/cpudata.h
index f2cc941..e89922d 100644
--- a/include/asm-sparc64/cpudata.h
+++ b/include/asm-sparc64/cpudata.h
@@ -17,8 +17,8 @@
 typedef struct {
 	/* Dcache line 1 */
 	unsigned int	__softirq_pending; /* must be 1st, see rtrap.S */
-	unsigned int	multiplier;
-	unsigned int	counter;
+	unsigned int	__pad0_1;
+	unsigned int	__pad0_2;
 	unsigned int	__pad1;
 	unsigned long	clock_tick;	/* %tick's per second */
 	unsigned long	udelay_val;
diff --git a/include/asm-sparc64/smp.h b/include/asm-sparc64/smp.h
index 388249b..cca5480 100644
--- a/include/asm-sparc64/smp.h
+++ b/include/asm-sparc64/smp.h
@@ -42,15 +42,15 @@ extern int hard_smp_processor_id(void);
 #define raw_smp_processor_id() (current_thread_info()->cpu)
 
 extern void smp_setup_cpu_possible_map(void);
+extern unsigned char boot_cpu_id;
 
 #endif /* !(__ASSEMBLY__) */
 
 #else
 
 #define smp_setup_cpu_possible_map() do { } while (0)
+#define boot_cpu_id	(0)
 
 #endif /* !(CONFIG_SMP) */
 
-#define NO_PROC_ID		0xFF
-
 #endif /* !(_SPARC64_SMP_H) */
diff --git a/include/asm-sparc64/ttable.h b/include/asm-sparc64/ttable.h
index c2a16e1..bbb9c8f 100644
--- a/include/asm-sparc64/ttable.h
+++ b/include/asm-sparc64/ttable.h
@@ -157,23 +157,6 @@
 	ba,a,pt	%xcc, rtrap_irq;			\
 	.previous;
 
-#define TICK_SMP_IRQ					\
-	rdpr	%pil, %g2;				\
-	wrpr	%g0, 15, %pil;				\
-	sethi	%hi(1f-4), %g7;				\
-	ba,pt	%xcc, etrap_irq;			\
-	 or	%g7, %lo(1f-4), %g7;			\
-	nop;						\
-	nop;						\
-	nop;						\
-	.subsection	2;				\
-1:	call	trace_hardirqs_off;			\
-	 nop;						\
-	call	smp_percpu_timer_interrupt;		\
-	 add	%sp, PTREGS_OFF, %o0;			\
-	ba,a,pt	%xcc, rtrap_irq;			\
-	.previous;
-
 #else
 
 #define TRAP_IRQ(routine, level)			\
@@ -186,16 +169,6 @@
 	 add	%sp, PTREGS_OFF, %o1;			\
 	ba,a,pt	%xcc, rtrap_irq;
 	
-#define TICK_SMP_IRQ					\
-	rdpr	%pil, %g2;				\
-	wrpr	%g0, 15, %pil;				\
-	sethi	%hi(109f), %g7;				\
-	ba,pt	%xcc, etrap_irq;			\
-109:	 or	%g7, %lo(109b), %g7;			\
-	call	smp_percpu_timer_interrupt;		\
-	 add	%sp, PTREGS_OFF, %o0;			\
-	ba,a,pt	%xcc, rtrap_irq;
-
 #endif
 
 #define TRAP_IVEC TRAP_NOSAVE(do_ivec)
-- 
1.5.0

