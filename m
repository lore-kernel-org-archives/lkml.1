Return-Path: <linux-kernel-owner+w=401wt.eu-S933957AbXCFFid@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933957AbXCFFid (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2007 00:38:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933951AbXCFFiJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Mar 2007 00:38:09 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:54787
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S933953AbXCFFiD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2007 00:38:03 -0500
Date: Mon, 05 Mar 2007 21:37:59 -0800 (PST)
Message-Id: <20070305.213759.35469392.davem@davemloft.net>
To: tglx@linutronix.de
CC: linux-kernel@vger.kernel.org, sparclinux@vger.kernel.org
Subject: [PATCH 4/4]: [SPARC64]: Add clocksource/clockevents support.
From: David Miller <davem@davemloft.net>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


>From 1171ef62b18d7eef093ecf961dd09b11339d53d9 Mon Sep 17 00:00:00 2001
From: David S. Miller <davem@sunset.davemloft.net>
Date: Mon, 5 Mar 2007 15:28:37 -0800
Subject: [PATCH] [SPARC64]: Add clocksource/clockevents support.

I'd like to thank John Stul and others for helping
me along the way.

A lot of cleanups fell out of this.  For example, the get_compare()
tick_op was totally unused, so was deleted.  And the most often used
tick_op members were grouped together for cache-friendlyness.

The sparc64 TSC is given to the kernel as a one-shot timer.

tick_ops->init_timer() simply turns off the privileged bit in
the tick register (when possible), and disables the interrupt
by setting bit 63 in the compare register.  The ->disable_irq()
op also sets this bit.

tick_ops->add_compare() is changed to:

1) Add the given delta to "tick" not to "compare"
2) Return a boolean which, if true, means that the tick
   value read after writing the compare value was found
   to have incremented past the initial tick value.  This
   mirrors logic used in the HPET driver's ->next_event()
   method.

Each tick_ops implementation also now provides a name string.
And we feed this into the clocksource and clockevents layers.

Signed-off-by: David S. Miller <davem@davemloft.net>
---
 arch/sparc64/Kconfig        |   14 +-
 arch/sparc64/kernel/smp.c   |   29 +---
 arch/sparc64/kernel/time.c  |  408 +++++++++++++++++++++++--------------------
 include/asm-sparc64/timer.h |   17 +-
 4 files changed, 238 insertions(+), 230 deletions(-)

diff --git a/arch/sparc64/Kconfig b/arch/sparc64/Kconfig
index f75a686..7944169 100644
--- a/arch/sparc64/Kconfig
+++ b/arch/sparc64/Kconfig
@@ -19,6 +19,14 @@ config SPARC64
 	  SPARC64 ports; its web page is available at
 	  <http://www.ultralinux.org/>.
 
+config GENERIC_TIME
+	bool
+	default y
+
+config GENERIC_CLOCKEVENTS
+	bool
+	default y
+
 config 64BIT
 	def_bool y
 
@@ -34,10 +42,6 @@ config LOCKDEP_SUPPORT
 	bool
 	default y
 
-config TIME_INTERPOLATION
-	bool
-	default y
-
 config ARCH_MAY_HAVE_PC_FDC
 	bool
 	default y
@@ -113,6 +117,8 @@ config GENERIC_HARDIRQS
 
 menu "General machine setup"
 
+source "kernel/time/Kconfig"
+
 config SMP
 	bool "Symmetric multi-processing support"
 	---help---
diff --git a/arch/sparc64/kernel/smp.c b/arch/sparc64/kernel/smp.c
index 39deb03..d4f0a70 100644
--- a/arch/sparc64/kernel/smp.c
+++ b/arch/sparc64/kernel/smp.c
@@ -123,7 +123,7 @@ void __init smp_store_cpu_info(int id)
 	       cpu_data(id).ecache_size, cpu_data(id).ecache_line_size);
 }
 
-static void smp_setup_percpu_timer(void);
+extern void setup_sparc64_timer(void);
 
 static volatile unsigned long callin_flag = 0;
 
@@ -138,7 +138,7 @@ void __init smp_callin(void)
 
 	__flush_tlb_all();
 
-	smp_setup_percpu_timer();
+	setup_sparc64_timer();
 
 	if (cheetah_pcache_forced_on)
 		cheetah_enable_pcache();
@@ -175,8 +175,6 @@ void cpu_panic(void)
 	panic("SMP bolixed\n");
 }
 
-static unsigned long current_tick_offset __read_mostly;
-
 /* This tick register synchronization scheme is taken entirely from
  * the ia64 port, see arch/ia64/kernel/smpboot.c for details and credit.
  *
@@ -259,7 +257,7 @@ void smp_synchronize_tick_client(void)
 				} else
 					adj = -delta;
 
-				tick_ops->add_tick(adj, current_tick_offset);
+				tick_ops->add_tick(adj);
 			}
 #if DEBUG_TICK_SYNC
 			t[i].rt = rt;
@@ -1178,30 +1176,9 @@ void smp_penguin_jailcell(int irq, struct pt_regs *regs)
 	preempt_enable();
 }
 
-static void __init smp_setup_percpu_timer(void)
-{
-	unsigned long pstate;
-
-	/* Guarantee that the following sequences execute
-	 * uninterrupted.
-	 */
-	__asm__ __volatile__("rdpr	%%pstate, %0\n\t"
-			     "wrpr	%0, %1, %%pstate"
-			     : "=r" (pstate)
-			     : "i" (PSTATE_IE));
-
-	tick_ops->init_tick(current_tick_offset);
-
-	/* Restore PSTATE_IE. */
-	__asm__ __volatile__("wrpr	%0, 0x0, %%pstate"
-			     : /* no outputs */
-			     : "r" (pstate));
-}
-
 void __init smp_tick_init(void)
 {
 	boot_cpu_id = hard_smp_processor_id();
-	current_tick_offset = timer_tick_offset;
 }
 
 /* /proc/profile writes can call this, don't __init it please. */
diff --git a/arch/sparc64/kernel/time.c b/arch/sparc64/kernel/time.c
index 48e1217..21e3b0b 100644
--- a/arch/sparc64/kernel/time.c
+++ b/arch/sparc64/kernel/time.c
@@ -32,6 +32,8 @@
 #include <linux/miscdevice.h>
 #include <linux/rtc.h>
 #include <linux/kernel_stat.h>
+#include <linux/clockchips.h>
+#include <linux/clocksource.h>
 
 #include <asm/oplib.h>
 #include <asm/mostek.h>
@@ -61,6 +63,7 @@ static void __iomem *mstk48t59_regs;
 static int set_rtc_mmss(unsigned long);
 
 #define TICK_PRIV_BIT	(1UL << 63)
+#define TICKCMP_IRQ_BIT	(1UL << 63)
 
 #ifdef CONFIG_SMP
 unsigned long profile_pc(struct pt_regs *regs)
@@ -94,21 +97,22 @@ static void tick_disable_protection(void)
 	: "g2");
 }
 
-static void tick_init_tick(unsigned long offset)
+static void tick_disable_irq(void)
 {
-	tick_disable_protection();
-
 	__asm__ __volatile__(
-	"	rd	%%tick, %%g1\n"
-	"	andn	%%g1, %1, %%g1\n"
 	"	ba,pt	%%xcc, 1f\n"
-	"	 add	%%g1, %0, %%g1\n"
+	"	 nop\n"
 	"	.align	64\n"
-	"1:	wr	%%g1, 0x0, %%tick_cmpr\n"
+	"1:	wr	%0, 0x0, %%tick_cmpr\n"
 	"	rd	%%tick_cmpr, %%g0"
 	: /* no outputs */
-	: "r" (offset), "r" (TICK_PRIV_BIT)
-	: "g1");
+	: "r" (TICKCMP_IRQ_BIT));
+}
+
+static void tick_init_tick(void)
+{
+	tick_disable_protection();
+	tick_disable_irq();
 }
 
 static unsigned long tick_get_tick(void)
@@ -122,20 +126,14 @@ static unsigned long tick_get_tick(void)
 	return ret & ~TICK_PRIV_BIT;
 }
 
-static unsigned long tick_get_compare(void)
+static int tick_add_compare(unsigned long adj)
 {
-	unsigned long ret;
+	unsigned long orig_tick, new_tick, new_compare;
 
-	__asm__ __volatile__("rd	%%tick_cmpr, %0\n\t"
-			     "mov	%0, %0"
-			     : "=r" (ret));
+	__asm__ __volatile__("rd	%%tick, %0"
+			     : "=r" (orig_tick));
 
-	return ret;
-}
-
-static unsigned long tick_add_compare(unsigned long adj)
-{
-	unsigned long new_compare;
+	orig_tick &= ~TICKCMP_IRQ_BIT;
 
 	/* Workaround for Spitfire Errata (#54 I think??), I discovered
 	 * this via Sun BugID 4008234, mentioned in Solaris-2.5.1 patch
@@ -146,44 +144,41 @@ static unsigned long tick_add_compare(unsigned long adj)
 	 * at the start of an I-cache line, and perform a dummy
 	 * read back from %tick_cmpr right after writing to it. -DaveM
 	 */
-	__asm__ __volatile__("rd	%%tick_cmpr, %0\n\t"
-			     "ba,pt	%%xcc, 1f\n\t"
-			     " add	%0, %1, %0\n\t"
+	__asm__ __volatile__("ba,pt	%%xcc, 1f\n\t"
+			     " add	%1, %2, %0\n\t"
 			     ".align	64\n"
 			     "1:\n\t"
 			     "wr	%0, 0, %%tick_cmpr\n\t"
-			     "rd	%%tick_cmpr, %%g0"
-			     : "=&r" (new_compare)
-			     : "r" (adj));
+			     "rd	%%tick_cmpr, %%g0\n\t"
+			     : "=r" (new_compare)
+			     : "r" (orig_tick), "r" (adj));
+
+	__asm__ __volatile__("rd	%%tick, %0"
+			     : "=r" (new_tick));
+	new_tick &= ~TICKCMP_IRQ_BIT;
 
-	return new_compare;
+	return ((long)(new_tick - (orig_tick+adj))) > 0L;
 }
 
-static unsigned long tick_add_tick(unsigned long adj, unsigned long offset)
+static unsigned long tick_add_tick(unsigned long adj)
 {
-	unsigned long new_tick, tmp;
+	unsigned long new_tick;
 
 	/* Also need to handle Blackbird bug here too. */
 	__asm__ __volatile__("rd	%%tick, %0\n\t"
-			     "add	%0, %2, %0\n\t"
+			     "add	%0, %1, %0\n\t"
 			     "wrpr	%0, 0, %%tick\n\t"
-			     "andn	%0, %4, %1\n\t"
-			     "ba,pt	%%xcc, 1f\n\t"
-			     " add	%1, %3, %1\n\t"
-			     ".align	64\n"
-			     "1:\n\t"
-			     "wr	%1, 0, %%tick_cmpr\n\t"
-			     "rd	%%tick_cmpr, %%g0"
-			     : "=&r" (new_tick), "=&r" (tmp)
-			     : "r" (adj), "r" (offset), "r" (TICK_PRIV_BIT));
+			     : "=&r" (new_tick)
+			     : "r" (adj));
 
 	return new_tick;
 }
 
 static struct sparc64_tick_ops tick_operations __read_mostly = {
+	.name		=	"tick",
 	.init_tick	=	tick_init_tick,
+	.disable_irq	=	tick_disable_irq,
 	.get_tick	=	tick_get_tick,
-	.get_compare	=	tick_get_compare,
 	.add_tick	=	tick_add_tick,
 	.add_compare	=	tick_add_compare,
 	.softint_mask	=	1UL << 0,
@@ -191,7 +186,15 @@ static struct sparc64_tick_ops tick_operations __read_mostly = {
 
 struct sparc64_tick_ops *tick_ops __read_mostly = &tick_operations;
 
-static void stick_init_tick(unsigned long offset)
+static void stick_disable_irq(void)
+{
+	__asm__ __volatile__(
+	"wr	%0, 0x0, %%asr25"
+	: /* no outputs */
+	: "r" (TICKCMP_IRQ_BIT));
+}
+
+static void stick_init_tick(void)
 {
 	/* Writes to the %tick and %stick register are not
 	 * allowed on sun4v.  The Hypervisor controls that
@@ -199,6 +202,7 @@ static void stick_init_tick(unsigned long offset)
 	 */
 	if (tlb_type != hypervisor) {
 		tick_disable_protection();
+		tick_disable_irq();
 
 		/* Let the user get at STICK too. */
 		__asm__ __volatile__(
@@ -210,14 +214,7 @@ static void stick_init_tick(unsigned long offset)
 		: "g1", "g2");
 	}
 
-	__asm__ __volatile__(
-	"	rd	%%asr24, %%g1\n"
-	"	andn	%%g1, %1, %%g1\n"
-	"	add	%%g1, %0, %%g1\n"
-	"	wr	%%g1, 0x0, %%asr25"
-	: /* no outputs */
-	: "r" (offset), "r" (TICK_PRIV_BIT)
-	: "g1");
+	stick_disable_irq();
 }
 
 static unsigned long stick_get_tick(void)
@@ -230,49 +227,43 @@ static unsigned long stick_get_tick(void)
 	return ret & ~TICK_PRIV_BIT;
 }
 
-static unsigned long stick_get_compare(void)
-{
-	unsigned long ret;
-
-	__asm__ __volatile__("rd	%%asr25, %0"
-			     : "=r" (ret));
-
-	return ret;
-}
-
-static unsigned long stick_add_tick(unsigned long adj, unsigned long offset)
+static unsigned long stick_add_tick(unsigned long adj)
 {
-	unsigned long new_tick, tmp;
+	unsigned long new_tick;
 
 	__asm__ __volatile__("rd	%%asr24, %0\n\t"
-			     "add	%0, %2, %0\n\t"
+			     "add	%0, %1, %0\n\t"
 			     "wr	%0, 0, %%asr24\n\t"
-			     "andn	%0, %4, %1\n\t"
-			     "add	%1, %3, %1\n\t"
-			     "wr	%1, 0, %%asr25"
-			     : "=&r" (new_tick), "=&r" (tmp)
-			     : "r" (adj), "r" (offset), "r" (TICK_PRIV_BIT));
+			     : "=&r" (new_tick)
+			     : "r" (adj));
 
 	return new_tick;
 }
 
-static unsigned long stick_add_compare(unsigned long adj)
+static int stick_add_compare(unsigned long adj)
 {
-	unsigned long new_compare;
+	unsigned long orig_tick, new_tick;
 
-	__asm__ __volatile__("rd	%%asr25, %0\n\t"
-			     "add	%0, %1, %0\n\t"
-			     "wr	%0, 0, %%asr25"
-			     : "=&r" (new_compare)
-			     : "r" (adj));
+	__asm__ __volatile__("rd	%%asr24, %0"
+			     : "=r" (orig_tick));
+	orig_tick &= ~TICKCMP_IRQ_BIT;
+
+	__asm__ __volatile__("wr	%0, 0, %%asr25"
+			     : /* no outputs */
+			     : "r" (orig_tick + adj));
+
+	__asm__ __volatile__("rd	%%asr24, %0"
+			     : "=r" (new_tick));
+	new_tick &= ~TICKCMP_IRQ_BIT;
 
-	return new_compare;
+	return ((long)(new_tick - (orig_tick+adj))) > 0L;
 }
 
 static struct sparc64_tick_ops stick_operations __read_mostly = {
+	.name		=	"stick",
 	.init_tick	=	stick_init_tick,
+	.disable_irq	=	stick_disable_irq,
 	.get_tick	=	stick_get_tick,
-	.get_compare	=	stick_get_compare,
 	.add_tick	=	stick_add_tick,
 	.add_compare	=	stick_add_compare,
 	.softint_mask	=	1UL << 16,
@@ -321,20 +312,6 @@ static unsigned long __hbird_read_stick(void)
 	return ret;
 }
 
-static unsigned long __hbird_read_compare(void)
-{
-	unsigned long low, high;
-	unsigned long addr = HBIRD_STICKCMP_ADDR;
-
-	__asm__ __volatile__("ldxa	[%2] %3, %0\n\t"
-			     "add	%2, 0x8, %2\n\t"
-			     "ldxa	[%2] %3, %1"
-			     : "=&r" (low), "=&r" (high), "=&r" (addr)
-			     : "i" (ASI_PHYS_BYPASS_EC_E), "2" (addr));
-
-	return (high << 32UL) | low;
-}
-
 static void __hbird_write_stick(unsigned long val)
 {
 	unsigned long low = (val & 0xffffffffUL);
@@ -365,10 +342,13 @@ static void __hbird_write_compare(unsigned long val)
 			       "i" (ASI_PHYS_BYPASS_EC_E));
 }
 
-static void hbtick_init_tick(unsigned long offset)
+static void hbtick_disable_irq(void)
 {
-	unsigned long val;
+	__hbird_write_compare(TICKCMP_IRQ_BIT);
+}
 
+static void hbtick_init_tick(void)
+{
 	tick_disable_protection();
 
 	/* XXX This seems to be necessary to 'jumpstart' Hummingbird
@@ -378,8 +358,7 @@ static void hbtick_init_tick(unsigned long offset)
 	 */
 	__hbird_write_stick(__hbird_read_stick());
 
-	val = __hbird_read_stick() & ~TICK_PRIV_BIT;
-	__hbird_write_compare(val + offset);
+	hbtick_disable_irq();
 }
 
 static unsigned long hbtick_get_tick(void)
@@ -387,45 +366,40 @@ static unsigned long hbtick_get_tick(void)
 	return __hbird_read_stick() & ~TICK_PRIV_BIT;
 }
 
-static unsigned long hbtick_get_compare(void)
-{
-	return __hbird_read_compare();
-}
-
-static unsigned long hbtick_add_tick(unsigned long adj, unsigned long offset)
+static unsigned long hbtick_add_tick(unsigned long adj)
 {
 	unsigned long val;
 
 	val = __hbird_read_stick() + adj;
 	__hbird_write_stick(val);
 
-	val &= ~TICK_PRIV_BIT;
-	__hbird_write_compare(val + offset);
-
 	return val;
 }
 
-static unsigned long hbtick_add_compare(unsigned long adj)
+static int hbtick_add_compare(unsigned long adj)
 {
-	unsigned long val = __hbird_read_compare() + adj;
+	unsigned long val = __hbird_read_stick();
+	unsigned long val2;
 
-	val &= ~TICK_PRIV_BIT;
+	val &= ~TICKCMP_IRQ_BIT;
+	val += adj;
 	__hbird_write_compare(val);
 
-	return val;
+	val2 = __hbird_read_stick() & ~TICKCMP_IRQ_BIT;
+
+	return ((long)(val2 - val)) > 0L;
 }
 
 static struct sparc64_tick_ops hbtick_operations __read_mostly = {
+	.name		=	"hbtick",
 	.init_tick	=	hbtick_init_tick,
+	.disable_irq	=	hbtick_disable_irq,
 	.get_tick	=	hbtick_get_tick,
-	.get_compare	=	hbtick_get_compare,
 	.add_tick	=	hbtick_add_tick,
 	.add_compare	=	hbtick_add_compare,
 	.softint_mask	=	1UL << 0,
 };
 
-unsigned long timer_tick_offset __read_mostly;
-
 static unsigned long timer_ticks_per_nsec_quotient __read_mostly;
 
 #define TICK_SIZE (tick_nsec / 1000)
@@ -482,50 +456,6 @@ void notify_arch_cmos_timer(void)
 	mod_timer(&sync_cmos_timer, jiffies + 1);
 }
 
-void timer_interrupt(int irq, struct pt_regs *regs)
-{
-	struct pt_regs *old_regs = set_irq_regs(regs);
-	unsigned long ticks, compare, pstate;
-	unsigned long tick_mask = tick_ops->softint_mask;
-
-	clear_softint(tick_mask);
-
-	irq_enter();
-
-	kstat_this_cpu.irqs[0]++;
-
-	do {
-		profile_tick(CPU_PROFILING);
-		update_process_times(user_mode(get_irq_regs()));
-
-		if (smp_processor_id() == boot_cpu_id) {
-			write_seqlock(&xtime_lock);
-			do_timer(1);
-			write_sequnlock(&xtime_lock);
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
-		compare = tick_ops->add_compare(timer_tick_offset);
-		ticks = tick_ops->get_tick();
-
-		/* Restore PSTATE_IE. */
-		__asm__ __volatile__("wrpr	%0, 0x0, %%pstate"
-				     : /* no outputs */
-				     : "r" (pstate));
-	} while (unlikely(time_after_eq(ticks, compare)));
-
-	irq_exit();
-
-	set_irq_regs(old_regs);
-}
-
 /* Kick start a stopped clock (procedure from the Sun NVRAM/hostid FAQ). */
 static void __init kick_start_clock(void)
 {
@@ -923,7 +853,6 @@ static unsigned long sparc64_init_timers(void)
 		prop = of_find_property(dp, "stick-frequency", NULL);
 	}
 	clock = *(unsigned int *) prop->value;
-	timer_tick_offset = clock / HZ;
 
 #ifdef CONFIG_SMP
 	smp_tick_init();
@@ -932,26 +861,6 @@ static unsigned long sparc64_init_timers(void)
 	return clock;
 }
 
-static void sparc64_start_timers(void)
-{
-	unsigned long pstate;
-
-	/* Guarantee that the following sequences execute
-	 * uninterrupted.
-	 */
-	__asm__ __volatile__("rdpr	%%pstate, %0\n\t"
-			     "wrpr	%0, %1, %%pstate"
-			     : "=r" (pstate)
-			     : "i" (PSTATE_IE));
-
-	tick_ops->init_tick(timer_tick_offset);
-
-	/* Restore PSTATE_IE. */
-	__asm__ __volatile__("wrpr	%0, 0x0, %%pstate"
-			     : /* no outputs */
-			     : "r" (pstate));
-}
-
 struct freq_table {
 	unsigned long clock_tick_ref;
 	unsigned int ref_freq;
@@ -998,29 +907,148 @@ static struct notifier_block sparc64_cpufreq_notifier_block = {
 
 #endif /* CONFIG_CPU_FREQ */
 
-static struct time_interpolator sparc64_cpu_interpolator = {
-	.source		=	TIME_SOURCE_CPU,
-	.shift		=	16,
-	.mask		=	0xffffffffffffffffLL
+static int sparc64_next_event(unsigned long delta,
+			      struct clock_event_device *evt)
+{
+	return tick_ops->add_compare(delta);
+}
+
+static void sparc64_timer_setup(enum clock_event_mode mode,
+				struct clock_event_device *evt)
+{
+	switch (mode) {
+	case CLOCK_EVT_MODE_ONESHOT:
+		break;
+
+	case CLOCK_EVT_MODE_SHUTDOWN:
+		tick_ops->disable_irq();
+		break;
+
+	case CLOCK_EVT_MODE_PERIODIC:
+	case CLOCK_EVT_MODE_UNUSED:
+		WARN_ON(1);
+		break;
+	};
+}
+
+static struct clock_event_device sparc64_clockevent = {
+	.features	= CLOCK_EVT_FEAT_ONESHOT,
+	.set_mode	= sparc64_timer_setup,
+	.set_next_event	= sparc64_next_event,
+	.rating		= 100,
+	.shift		= 30,
+	.irq		= -1,
 };
+static DEFINE_PER_CPU(struct clock_event_device, sparc64_events);
 
-/* The quotient formula is taken from the IA64 port. */
-#define SPARC64_NSEC_PER_CYC_SHIFT	10UL
-void __init time_init(void)
+void timer_interrupt(int irq, struct pt_regs *regs)
 {
-	unsigned long clock = sparc64_init_timers();
+	struct pt_regs *old_regs = set_irq_regs(regs);
+	unsigned long tick_mask = tick_ops->softint_mask;
+	int cpu = smp_processor_id();
+	struct clock_event_device *evt = &per_cpu(sparc64_events, cpu);
+
+	clear_softint(tick_mask);
+
+	irq_enter();
+
+	kstat_this_cpu.irqs[0]++;
+
+	if (unlikely(!evt->event_handler)) {
+		printk(KERN_WARNING
+		       "Spurious SPARC64 timer interrupt on cpu %d\n", cpu);
+	} else
+		evt->event_handler(evt);
+
+	irq_exit();
+
+	set_irq_regs(old_regs);
+}
 
-	sparc64_cpu_interpolator.frequency = clock;
-	register_time_interpolator(&sparc64_cpu_interpolator);
+void __devinit setup_sparc64_timer(void)
+{
+	struct clock_event_device *sevt;
+	unsigned long pstate;
 
-	/* Now that the interpolator is registered, it is
-	 * safe to start the timer ticking.
+	/* Guarantee that the following sequences execute
+	 * uninterrupted.
 	 */
-	sparc64_start_timers();
+	__asm__ __volatile__("rdpr	%%pstate, %0\n\t"
+			     "wrpr	%0, %1, %%pstate"
+			     : "=r" (pstate)
+			     : "i" (PSTATE_IE));
+
+	tick_ops->init_tick();
+
+	/* Restore PSTATE_IE. */
+	__asm__ __volatile__("wrpr	%0, 0x0, %%pstate"
+			     : /* no outputs */
+			     : "r" (pstate));
+
+	sevt = &__get_cpu_var(sparc64_events);
+
+	memcpy(sevt, &sparc64_clockevent, sizeof(*sevt));
+	sevt->cpumask = cpumask_of_cpu(smp_processor_id());
+
+	clockevents_register_device(sevt);
+}
+
+#define SPARC64_NSEC_PER_CYC_SHIFT	32UL
+
+static struct clocksource clocksource_tick = {
+	.rating		= 100,
+	.mask		= CLOCKSOURCE_MASK(64),
+	.shift		= 16,
+	.flags		= CLOCK_SOURCE_IS_CONTINUOUS,
+};
+
+static void __init setup_clockevent_multiplier(unsigned long hz)
+{
+	unsigned long mult, shift = 32;
+
+	while (1) {
+		mult = div_sc(hz, NSEC_PER_SEC, shift);
+		if (mult && (mult >> 32UL) == 0UL)
+			break;
+
+		shift--;
+	}
+
+	sparc64_clockevent.shift = shift;
+	sparc64_clockevent.mult = mult;
+}
+
+void __init time_init(void)
+{
+	unsigned long clock = sparc64_init_timers();
 
 	timer_ticks_per_nsec_quotient =
-		(((NSEC_PER_SEC << SPARC64_NSEC_PER_CYC_SHIFT) +
-		  (clock / 2)) / clock);
+		clocksource_hz2mult(clock, SPARC64_NSEC_PER_CYC_SHIFT);
+
+	clocksource_tick.name = tick_ops->name;
+	clocksource_tick.mult =
+		clocksource_hz2mult(clock,
+				    clocksource_tick.shift);
+	clocksource_tick.read = tick_ops->get_tick;
+
+	printk("clocksource: mult[%x] shift[%d]\n",
+	       clocksource_tick.mult, clocksource_tick.shift);
+
+	clocksource_register(&clocksource_tick);
+
+	sparc64_clockevent.name = tick_ops->name;
+
+	setup_clockevent_multiplier(clock);
+
+	sparc64_clockevent.max_delta_ns =
+		clockevent_delta2ns(0x7fffffffffffffff, &sparc64_clockevent);
+	sparc64_clockevent.min_delta_ns =
+		clockevent_delta2ns(0xF, &sparc64_clockevent);
+
+	printk("clockevent: mult[%lx] shift[%d]\n",
+	       sparc64_clockevent.mult, sparc64_clockevent.shift);
+
+	setup_sparc64_timer();
 
 #ifdef CONFIG_CPU_FREQ
 	cpufreq_register_notifier(&sparc64_cpufreq_notifier_block,
diff --git a/include/asm-sparc64/timer.h b/include/asm-sparc64/timer.h
index d435594..ccbd694 100644
--- a/include/asm-sparc64/timer.h
+++ b/include/asm-sparc64/timer.h
@@ -11,22 +11,19 @@
 
 
 struct sparc64_tick_ops {
-	void (*init_tick)(unsigned long);
 	unsigned long (*get_tick)(void);
-	unsigned long (*get_compare)(void);
-	unsigned long (*add_tick)(unsigned long, unsigned long);
-	unsigned long (*add_compare)(unsigned long);
+	int (*add_compare)(unsigned long);
 	unsigned long softint_mask;
+	void (*disable_irq)(void);
+
+	void (*init_tick)(void);
+	unsigned long (*add_tick)(unsigned long);
+
+	char *name;
 };
 
 extern struct sparc64_tick_ops *tick_ops;
 
-#ifdef CONFIG_SMP
-extern unsigned long timer_tick_offset;
-struct pt_regs;
-extern void timer_tick_interrupt(struct pt_regs *);
-#endif
-
 extern unsigned long sparc64_get_clock_tick(unsigned int cpu);
 
 #endif /* _SPARC64_TIMER_H */
-- 
1.5.0

