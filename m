Return-Path: <linux-kernel-owner+w=401wt.eu-S936795AbZDCUQf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936795AbZDCUQf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Apr 2009 16:16:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S936563AbZDCUQK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Apr 2009 16:16:10 -0400
Received: from relay3.sgi.com ([192.48.156.57]:38314 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1759332AbZDCUQH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Apr 2009 16:16:07 -0400
X-Greylist: delayed 553 seconds by postgrey-1.27 at vger.kernel.org; Fri, 03 Apr 2009 16:16:07 EDT
Date: Fri, 3 Apr 2009 15:06:47 -0500
From: Dimitri Sivanich <sivanich@sgi.com>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>
Subject: [PATCH] Move calc_load call out from xtime_lock protection
Message-ID: <20090403200647.GA22497@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The xtime_lock is being held for long periods on larger systems due
to an extensive amount of time being spent in calc_load(),
specifically here:
  do_timer->update_times->calc_load->count_active_tasks->nr_active()

On a 64 cpu system I've seen this take approximately 55 usec.
Presumably it would be worse on larger systems.  This causes other
cpus to be held off in places such as
scheduler_tick->sched_clock_tick waiting for the xtime_lock to be
released.

Why does the xtime_lock need to be held when calc_load() is called?
Since the calculation is statistical in nature, it doesn't -seem- to
warrant protection via a write lock.

Here's a suggestion for a patch to eliminate this lock contention.

Signed-off-by: Dimitri Sivanich <sivanich@sgi.com>

---

This applies to the -tip tree master branch.

Tested on ia64 only.

 arch/alpha/kernel/time.c                   |    1 +
 arch/arm/kernel/time.c                     |    1 +
 arch/arm/mach-clps711x/include/mach/time.h |    2 ++
 arch/arm/mach-l7200/include/mach/time.h    |    2 ++
 arch/blackfin/kernel/time.c                |    2 ++
 arch/cris/arch-v10/kernel/time.c           |    2 ++
 arch/cris/arch-v32/kernel/time.c           |    1 +
 arch/frv/kernel/time.c                     |    1 +
 arch/h8300/kernel/time.c                   |    1 +
 arch/ia64/kernel/time.c                    |    1 +
 arch/ia64/xen/time.c                       |    2 ++
 arch/m32r/kernel/time.c                    |    1 +
 arch/m68k/kernel/time.c                    |    1 +
 arch/m68k/sun3/sun3ints.c                  |    1 +
 arch/m68knommu/kernel/time.c               |    2 ++
 arch/mn10300/kernel/time.c                 |    1 +
 arch/parisc/kernel/time.c                  |    1 +
 arch/sh/kernel/time_32.c                   |    1 +
 arch/sh/kernel/time_64.c                   |    1 +
 arch/sparc/kernel/pcic.c                   |    2 ++
 arch/sparc/kernel/time_32.c                |    1 +
 arch/xtensa/kernel/time.c                  |    2 ++
 include/linux/timer.h                      |    5 +++++
 kernel/time/tick-common.c                  |    1 +
 kernel/time/tick-sched.c                   |    3 +++
 kernel/timer.c                             |    4 +---
 26 files changed, 40 insertions(+), 3 deletions(-)

Index: linux-2.6.tip/arch/ia64/kernel/time.c
===================================================================
--- linux-2.6.tip.orig/arch/ia64/kernel/time.c	2009-04-03 13:00:22.003048245 -0500
+++ linux-2.6.tip/arch/ia64/kernel/time.c	2009-04-03 13:01:04.188326972 -0500
@@ -201,6 +201,7 @@ timer_interrupt (int irq, void *dev_id)
 			do_timer(1);
 			local_cpu_data->itm_next = new_itm;
 			write_sequnlock(&xtime_lock);
+			calc_load(1);
 		} else
 			local_cpu_data->itm_next = new_itm;
 
Index: linux-2.6.tip/kernel/timer.c
===================================================================
--- linux-2.6.tip.orig/kernel/timer.c	2009-04-03 13:00:32.356343285 -0500
+++ linux-2.6.tip/kernel/timer.c	2009-04-03 14:31:08.120893452 -0500
@@ -1145,9 +1145,8 @@ EXPORT_SYMBOL(avenrun);
 
 /*
  * calc_load - given tick count, update the avenrun load estimates.
- * This is called while holding a write_lock on xtime_lock.
  */
-static inline void calc_load(unsigned long ticks)
+void calc_load(unsigned long ticks)
 {
 	unsigned long active_tasks; /* fixed-point */
 	static int count = LOAD_FREQ;
@@ -1196,7 +1195,6 @@ void run_local_timers(void)
 static inline void update_times(unsigned long ticks)
 {
 	update_wall_time();
-	calc_load(ticks);
 }
 
 /*
Index: linux-2.6.tip/include/linux/timer.h
===================================================================
--- linux-2.6.tip.orig/include/linux/timer.h	2009-04-03 13:00:31.976295541 -0500
+++ linux-2.6.tip/include/linux/timer.h	2009-04-03 13:01:04.232332441 -0500
@@ -183,6 +183,11 @@ extern unsigned long next_timer_interrup
 extern unsigned long get_next_timer_interrupt(unsigned long now);
 
 /*
+ * Calculated load averages.
+ */
+extern void calc_load(unsigned long);
+
+/*
  * Timer-statistics info:
  */
 #ifdef CONFIG_TIMER_STATS
Index: linux-2.6.tip/kernel/time/tick-common.c
===================================================================
--- linux-2.6.tip.orig/kernel/time/tick-common.c	2009-04-03 13:00:32.352342994 -0500
+++ linux-2.6.tip/kernel/time/tick-common.c	2009-04-03 13:01:04.256335288 -0500
@@ -67,6 +67,7 @@ static void tick_periodic(int cpu)
 
 		do_timer(1);
 		write_sequnlock(&xtime_lock);
+		calc_load(1);
 	}
 
 	update_process_times(user_mode(get_irq_regs()));
Index: linux-2.6.tip/kernel/time/tick-sched.c
===================================================================
--- linux-2.6.tip.orig/kernel/time/tick-sched.c	2009-04-03 13:00:32.352342994 -0500
+++ linux-2.6.tip/kernel/time/tick-sched.c	2009-04-03 13:01:04.276337859 -0500
@@ -81,6 +81,9 @@ static void tick_do_update_jiffies64(kti
 		tick_next_period = ktime_add(last_jiffies_update, tick_period);
 	}
 	write_sequnlock(&xtime_lock);
+	if (ticks) {
+		calc_load(ticks);
+	}
 }
 
 /*
Index: linux-2.6.tip/arch/ia64/xen/time.c
===================================================================
--- linux-2.6.tip.orig/arch/ia64/xen/time.c	2009-04-03 13:00:22.095059557 -0500
+++ linux-2.6.tip/arch/ia64/xen/time.c	2009-04-03 13:01:04.296340131 -0500
@@ -23,6 +23,7 @@
 #include <linux/delay.h>
 #include <linux/kernel_stat.h>
 #include <linux/posix-timers.h>
+#include <linux/timer.h>
 #include <linux/irq.h>
 #include <linux/clocksource.h>
 
@@ -145,6 +146,7 @@ consider_steal_time(unsigned long new_it
 			do_timer(stolen + blocked);
 			local_cpu_data->itm_next = delta_itm + new_itm;
 			write_sequnlock(&xtime_lock);
+			calc_load(stolen + blocked);
 		} else {
 			local_cpu_data->itm_next = delta_itm + new_itm;
 		}
Index: linux-2.6.tip/arch/alpha/kernel/time.c
===================================================================
--- linux-2.6.tip.orig/arch/alpha/kernel/time.c	2009-04-03 13:00:19.506735829 -0500
+++ linux-2.6.tip/arch/alpha/kernel/time.c	2009-04-03 13:01:04.340345434 -0500
@@ -137,6 +137,7 @@ irqreturn_t timer_interrupt(int irq, voi
 	}
 
 	write_sequnlock(&xtime_lock);
+	calc_load(nticks);
 
 #ifndef CONFIG_SMP
 	while (nticks--)
Index: linux-2.6.tip/arch/arm/kernel/time.c
===================================================================
--- linux-2.6.tip.orig/arch/arm/kernel/time.c	2009-04-03 13:00:19.954791345 -0500
+++ linux-2.6.tip/arch/arm/kernel/time.c	2009-04-03 13:01:04.368348822 -0500
@@ -339,6 +339,7 @@ void timer_tick(void)
 	write_seqlock(&xtime_lock);
 	do_timer(1);
 	write_sequnlock(&xtime_lock);
+	calc_load(1);
 #ifndef CONFIG_SMP
 	update_process_times(user_mode(get_irq_regs()));
 #endif
Index: linux-2.6.tip/arch/blackfin/kernel/time.c
===================================================================
--- linux-2.6.tip.orig/arch/blackfin/kernel/time.c	2009-04-03 13:00:21.154942494 -0500
+++ linux-2.6.tip/arch/blackfin/kernel/time.c	2009-04-03 13:01:04.396352487 -0500
@@ -11,6 +11,7 @@
 #include <linux/module.h>
 #include <linux/profile.h>
 #include <linux/interrupt.h>
+#include <linux/timer.h>
 #include <linux/time.h>
 #include <linux/irq.h>
 #include <linux/delay.h>
@@ -164,6 +165,7 @@ irqreturn_t timer_interrupt(int irq, voi
 	}
 #endif
 	write_sequnlock(&xtime_lock);
+	calc_load(1);
 
 #ifdef CONFIG_IPIPE
 	update_root_process_times(get_irq_regs());
Index: linux-2.6.tip/arch/frv/kernel/time.c
===================================================================
--- linux-2.6.tip.orig/arch/frv/kernel/time.c	2009-04-03 13:00:21.731013732 -0500
+++ linux-2.6.tip/arch/frv/kernel/time.c	2009-04-03 13:01:04.420355756 -0500
@@ -97,6 +97,7 @@ static irqreturn_t timer_interrupt(int i
 #endif /* CONFIG_HEARTBEAT */
 
 	write_sequnlock(&xtime_lock);
+	calc_load(1);
 
 	update_process_times(user_mode(get_irq_regs()));
 
Index: linux-2.6.tip/arch/h8300/kernel/time.c
===================================================================
--- linux-2.6.tip.orig/arch/h8300/kernel/time.c	2009-04-03 13:00:21.803022738 -0500
+++ linux-2.6.tip/arch/h8300/kernel/time.c	2009-04-03 13:01:04.440358428 -0500
@@ -38,6 +38,7 @@ void h8300_timer_tick(void)
 	write_seqlock(&xtime_lock);
 	do_timer(1);
 	write_sequnlock(&xtime_lock);
+	calc_load(1);
 	update_process_times(user_mode(get_irq_regs()));
 }
 
Index: linux-2.6.tip/arch/m32r/kernel/time.c
===================================================================
--- linux-2.6.tip.orig/arch/m32r/kernel/time.c	2009-04-03 13:00:22.131064354 -0500
+++ linux-2.6.tip/arch/m32r/kernel/time.c	2009-04-03 13:01:04.464360597 -0500
@@ -193,6 +193,7 @@ static irqreturn_t timer_interrupt(int i
 	profile_tick(CPU_PROFILING);
 #endif
 	do_timer(1);
+	calc_load(1);
 
 #ifndef CONFIG_SMP
 	update_process_times(user_mode(get_irq_regs()));
Index: linux-2.6.tip/arch/m68k/kernel/time.c
===================================================================
--- linux-2.6.tip.orig/arch/m68k/kernel/time.c	2009-04-03 13:00:22.351091789 -0500
+++ linux-2.6.tip/arch/m68k/kernel/time.c	2009-04-03 13:01:04.484363275 -0500
@@ -41,6 +41,7 @@ static inline int set_rtc_mmss(unsigned
 static irqreturn_t timer_interrupt(int irq, void *dummy)
 {
 	do_timer(1);
+	calc_load(1);
 #ifndef CONFIG_SMP
 	update_process_times(user_mode(get_irq_regs()));
 #endif
Index: linux-2.6.tip/arch/m68k/sun3/sun3ints.c
===================================================================
--- linux-2.6.tip.orig/arch/m68k/sun3/sun3ints.c	2009-04-03 13:00:22.391096432 -0500
+++ linux-2.6.tip/arch/m68k/sun3/sun3ints.c	2009-04-03 13:01:04.508367128 -0500
@@ -67,6 +67,7 @@ static irqreturn_t sun3_int5(int irq, vo
 	intersil_clear();
 #endif
         do_timer(1);
+	calc_load(1);
 #ifndef CONFIG_SMP
 	update_process_times(user_mode(get_irq_regs()));
 #endif
Index: linux-2.6.tip/arch/m68knommu/kernel/time.c
===================================================================
--- linux-2.6.tip.orig/arch/m68knommu/kernel/time.c	2009-04-03 13:00:22.423101095 -0500
+++ linux-2.6.tip/arch/m68knommu/kernel/time.c	2009-04-03 13:01:04.536370431 -0500
@@ -50,6 +50,8 @@ irqreturn_t arch_timer_interrupt(int irq
 
 	write_sequnlock(&xtime_lock);
 
+	calc_load(1);
+
 #ifndef CONFIG_SMP
 	update_process_times(user_mode(get_irq_regs()));
 #endif
Index: linux-2.6.tip/arch/mn10300/kernel/time.c
===================================================================
--- linux-2.6.tip.orig/arch/mn10300/kernel/time.c	2009-04-03 13:00:23.227200691 -0500
+++ linux-2.6.tip/arch/mn10300/kernel/time.c	2009-04-03 13:01:04.572374784 -0500
@@ -111,6 +111,7 @@ static irqreturn_t timer_interrupt(int i
 		/* advance the kernel's time tracking system */
 		profile_tick(CPU_PROFILING);
 		do_timer(1);
+		calc_load(1);
 		check_rtc_time();
 	}
 
Index: linux-2.6.tip/arch/parisc/kernel/time.c
===================================================================
--- linux-2.6.tip.orig/arch/parisc/kernel/time.c	2009-04-03 13:00:23.327213369 -0500
+++ linux-2.6.tip/arch/parisc/kernel/time.c	2009-04-03 13:01:04.592376919 -0500
@@ -147,6 +147,7 @@ irqreturn_t timer_interrupt(int irq, voi
 		write_seqlock(&xtime_lock);
 		do_timer(ticks_elapsed);
 		write_sequnlock(&xtime_lock);
+		calc_load(ticks_elapsed);
 	}
 
 	return IRQ_HANDLED;
Index: linux-2.6.tip/arch/sh/kernel/time_32.c
===================================================================
--- linux-2.6.tip.orig/arch/sh/kernel/time_32.c	2009-04-03 13:00:24.407348904 -0500
+++ linux-2.6.tip/arch/sh/kernel/time_32.c	2009-04-03 13:01:04.616380672 -0500
@@ -142,6 +142,7 @@ void handle_timer_tick(void)
 			last_rtc_update = xtime.tv_sec - 600;
 	}
 	write_sequnlock(&xtime_lock);
+	calc_load(1);
 
 #ifndef CONFIG_SMP
 	update_process_times(user_mode(get_irq_regs()));
Index: linux-2.6.tip/arch/sh/kernel/time_64.c
===================================================================
--- linux-2.6.tip.orig/arch/sh/kernel/time_64.c	2009-04-03 13:00:24.407348904 -0500
+++ linux-2.6.tip/arch/sh/kernel/time_64.c	2009-04-03 13:01:04.632382434 -0500
@@ -256,6 +256,7 @@ static inline void do_timer_interrupt(vo
 			last_rtc_update = xtime.tv_sec - 600;
 	}
 	write_sequnlock(&xtime_lock);
+	calc_load(1);
 
 #ifndef CONFIG_SMP
 	update_process_times(user_mode(get_irq_regs()));
Index: linux-2.6.tip/arch/sparc/kernel/pcic.c
===================================================================
--- linux-2.6.tip.orig/arch/sparc/kernel/pcic.c	2009-04-03 13:00:24.575370248 -0500
+++ linux-2.6.tip/arch/sparc/kernel/pcic.c	2009-04-03 13:01:04.660385934 -0500
@@ -12,6 +12,7 @@
 
 #include <linux/kernel.h>
 #include <linux/types.h>
+#include <linux/timer.h>
 #include <linux/init.h>
 #include <linux/mm.h>
 #include <linux/slab.h>
@@ -707,6 +708,7 @@ static irqreturn_t pcic_timer_handler (i
 	pcic_clear_clock_irq();
 	do_timer(1);
 	write_sequnlock(&xtime_lock);
+	calc_load(1);
 #ifndef CONFIG_SMP
 	update_process_times(user_mode(get_irq_regs()));
 #endif
Index: linux-2.6.tip/arch/sparc/kernel/time_32.c
===================================================================
--- linux-2.6.tip.orig/arch/sparc/kernel/time_32.c	2009-04-03 13:00:24.591372001 -0500
+++ linux-2.6.tip/arch/sparc/kernel/time_32.c	2009-04-03 13:01:04.676387209 -0500
@@ -110,6 +110,7 @@ static irqreturn_t timer_interrupt(int d
 	    last_rtc_update = xtime.tv_sec - 600; /* do it again in 60 s */
 	}
 	write_sequnlock(&xtime_lock);
+	calc_load(1);
 
 #ifndef CONFIG_SMP
 	update_process_times(user_mode(get_irq_regs()));
Index: linux-2.6.tip/arch/xtensa/kernel/time.c
===================================================================
--- linux-2.6.tip.orig/arch/xtensa/kernel/time.c	2009-04-03 13:00:25.319463444 -0500
+++ linux-2.6.tip/arch/xtensa/kernel/time.c	2009-04-03 13:01:04.700390400 -0500
@@ -13,6 +13,7 @@
  */
 
 #include <linux/errno.h>
+#include <linux/timer.h>
 #include <linux/time.h>
 #include <linux/timex.h>
 #include <linux/interrupt.h>
@@ -189,6 +190,7 @@ again:
 				last_rtc_update += 60;
 		}
 		write_sequnlock(&xtime_lock);
+		calc_load(1);
 	}
 
 	/* Allow platform to do something useful (Wdog). */
Index: linux-2.6.tip/arch/arm/mach-clps711x/include/mach/time.h
===================================================================
--- linux-2.6.tip.orig/arch/arm/mach-clps711x/include/mach/time.h	2009-04-03 13:00:20.034802123 -0500
+++ linux-2.6.tip/arch/arm/mach-clps711x/include/mach/time.h	2009-04-03 13:01:04.728393872 -0500
@@ -17,6 +17,7 @@
  * along with this program; if not, write to the Free Software
  * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
  */
+#include <linux/timer.h>
 #include <asm/leds.h>
 #include <asm/hardware/clps7111.h>
 
@@ -31,6 +32,7 @@ p720t_timer_interrupt(int irq, void *dev
 	struct pt_regs *regs = get_irq_regs();
 	do_leds();
 	do_timer(1);
+	calc_load(1);
 #ifndef CONFIG_SMP
 	update_process_times(user_mode(regs));
 #endif
Index: linux-2.6.tip/arch/arm/mach-l7200/include/mach/time.h
===================================================================
--- linux-2.6.tip.orig/arch/arm/mach-l7200/include/mach/time.h	2009-04-03 13:00:20.294834023 -0500
+++ linux-2.6.tip/arch/arm/mach-l7200/include/mach/time.h	2009-04-03 13:01:04.756397793 -0500
@@ -11,6 +11,7 @@
 #ifndef _ASM_ARCH_TIME_H
 #define _ASM_ARCH_TIME_H
 
+#include <linux/timer.h>
 #include <mach/irqs.h>
 
 /*
@@ -47,6 +48,7 @@ timer_interrupt(int irq, void *dev_id)
 {
 	struct pt_regs *regs = get_irq_regs();
 	do_timer(1);
+	calc_load(1);
 #ifndef CONFIG_SMP
 	update_process_times(user_mode(regs));
 #endif
Index: linux-2.6.tip/arch/cris/arch-v10/kernel/time.c
===================================================================
--- linux-2.6.tip.orig/arch/cris/arch-v10/kernel/time.c	2009-04-03 13:00:21.374969323 -0500
+++ linux-2.6.tip/arch/cris/arch-v10/kernel/time.c	2009-04-03 13:01:04.780401662 -0500
@@ -231,6 +231,8 @@ timer_interrupt(int irq, void *dev_id)
 	/* call the real timer interrupt handler */
 
 	do_timer(1);
+
+	calc_load(1);
 	
         cris_do_profile(regs); /* Save profiling information */
 
Index: linux-2.6.tip/arch/cris/arch-v32/kernel/time.c
===================================================================
--- linux-2.6.tip.orig/arch/cris/arch-v32/kernel/time.c	2009-04-03 13:00:21.430977004 -0500
+++ linux-2.6.tip/arch/cris/arch-v32/kernel/time.c	2009-04-03 13:01:04.804403669 -0500
@@ -240,6 +240,7 @@ timer_interrupt(int irq, void *dev_id)
 	/* Call the real timer interrupt handler */
 	do_timer(1);
 
+	calc_load(1);
 	/*
 	 * If we have an externally synchronized Linux clock, then update
 	 * CMOS clock accordingly every ~11 minutes. Set_rtc_mmss() has to be
