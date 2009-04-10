Return-Path: <linux-kernel-owner+w=401wt.eu-S936206AbZDJRew@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936206AbZDJRew (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Apr 2009 13:34:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757617AbZDJRel
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Apr 2009 13:34:41 -0400
Received: from relay3.sgi.com ([192.48.156.57]:60581 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1762149AbZDJRej (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Apr 2009 13:34:39 -0400
Date: Fri, 10 Apr 2009 12:34:37 -0500
From: Dimitri Sivanich <sivanich@sgi.com>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       john stultz <johnstul@us.ibm.com>, Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH v2] Move calc_load call out from xtime_lock protection
Message-ID: <20090410173437.GA23415@sgi.com>
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


>From e3e61df08f615c39d2d6f27918561c84e1439050 Mon Sep 17 00:00:00 2001
From: Dimitri Sivanich <sivanich@attica.americas.sgi.com>
Date: Thu, 9 Apr 2009 14:37:28 -0500
Subject: [PATCH] Remove calc_load from xtime_lock protection.

---

Made modifications recommended by John Stultz.  Refreshed for 2.6.30-rc1.

Tested on ia64 and x86.

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
 kernel/time/tick-sched.c                   |    2 ++
 kernel/timer.c                             |   22 +++++++++++++++-------
 26 files changed, 53 insertions(+), 7 deletions(-)

diff --git a/arch/alpha/kernel/time.c b/arch/alpha/kernel/time.c
index b04e2cb..461fe34 100644
--- a/arch/alpha/kernel/time.c
+++ b/arch/alpha/kernel/time.c
@@ -137,6 +137,7 @@ irqreturn_t timer_interrupt(int irq, void *dev)
 	}
 
 	write_sequnlock(&xtime_lock);
+	calc_load(nticks);
 
 #ifndef CONFIG_SMP
 	while (nticks--)
diff --git a/arch/arm/kernel/time.c b/arch/arm/kernel/time.c
index 4cdc4a0..aa96509 100644
--- a/arch/arm/kernel/time.c
+++ b/arch/arm/kernel/time.c
@@ -339,6 +339,7 @@ void timer_tick(void)
 	write_seqlock(&xtime_lock);
 	do_timer(1);
 	write_sequnlock(&xtime_lock);
+	calc_load(1);
 #ifndef CONFIG_SMP
 	update_process_times(user_mode(get_irq_regs()));
 #endif
diff --git a/arch/arm/mach-clps711x/include/mach/time.h b/arch/arm/mach-clps711x/include/mach/time.h
index 8fe283c..afa3c3b 100644
--- a/arch/arm/mach-clps711x/include/mach/time.h
+++ b/arch/arm/mach-clps711x/include/mach/time.h
@@ -17,6 +17,7 @@
  * along with this program; if not, write to the Free Software
  * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
  */
+#include <linux/timer.h>
 #include <asm/leds.h>
 #include <asm/hardware/clps7111.h>
 
@@ -31,6 +32,7 @@ p720t_timer_interrupt(int irq, void *dev_id)
 	struct pt_regs *regs = get_irq_regs();
 	do_leds();
 	do_timer(1);
+	calc_load(1);
 #ifndef CONFIG_SMP
 	update_process_times(user_mode(regs));
 #endif
diff --git a/arch/arm/mach-l7200/include/mach/time.h b/arch/arm/mach-l7200/include/mach/time.h
index 061771c..80df87b 100644
--- a/arch/arm/mach-l7200/include/mach/time.h
+++ b/arch/arm/mach-l7200/include/mach/time.h
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
diff --git a/arch/blackfin/kernel/time.c b/arch/blackfin/kernel/time.c
index 1bbacfb..b5b55d2 100644
--- a/arch/blackfin/kernel/time.c
+++ b/arch/blackfin/kernel/time.c
@@ -11,6 +11,7 @@
 #include <linux/module.h>
 #include <linux/profile.h>
 #include <linux/interrupt.h>
+#include <linux/timer.h>
 #include <linux/time.h>
 #include <linux/irq.h>
 #include <linux/delay.h>
@@ -164,6 +165,7 @@ irqreturn_t timer_interrupt(int irq, void *dummy)
 	}
 #endif
 	write_sequnlock(&xtime_lock);
+	calc_load(1);
 
 #ifdef CONFIG_IPIPE
 	update_root_process_times(get_irq_regs());
diff --git a/arch/cris/arch-v10/kernel/time.c b/arch/cris/arch-v10/kernel/time.c
index 2b73c7a..951712a 100644
--- a/arch/cris/arch-v10/kernel/time.c
+++ b/arch/cris/arch-v10/kernel/time.c
@@ -231,6 +231,8 @@ timer_interrupt(int irq, void *dev_id)
 	/* call the real timer interrupt handler */
 
 	do_timer(1);
+
+	calc_load(1);
 	
         cris_do_profile(regs); /* Save profiling information */
 
diff --git a/arch/cris/arch-v32/kernel/time.c b/arch/cris/arch-v32/kernel/time.c
index 65633d0..2b4bb52 100644
--- a/arch/cris/arch-v32/kernel/time.c
+++ b/arch/cris/arch-v32/kernel/time.c
@@ -240,6 +240,7 @@ timer_interrupt(int irq, void *dev_id)
 	/* Call the real timer interrupt handler */
 	do_timer(1);
 
+	calc_load(1);
 	/*
 	 * If we have an externally synchronized Linux clock, then update
 	 * CMOS clock accordingly every ~11 minutes. Set_rtc_mmss() has to be
diff --git a/arch/frv/kernel/time.c b/arch/frv/kernel/time.c
index fb0ce75..3d73275 100644
--- a/arch/frv/kernel/time.c
+++ b/arch/frv/kernel/time.c
@@ -97,6 +97,7 @@ static irqreturn_t timer_interrupt(int irq, void *dummy)
 #endif /* CONFIG_HEARTBEAT */
 
 	write_sequnlock(&xtime_lock);
+	calc_load(1);
 
 	update_process_times(user_mode(get_irq_regs()));
 
diff --git a/arch/h8300/kernel/time.c b/arch/h8300/kernel/time.c
index 7f2d6cf..d3a9b6f 100644
--- a/arch/h8300/kernel/time.c
+++ b/arch/h8300/kernel/time.c
@@ -38,6 +38,7 @@ void h8300_timer_tick(void)
 	write_seqlock(&xtime_lock);
 	do_timer(1);
 	write_sequnlock(&xtime_lock);
+	calc_load(1);
 	update_process_times(user_mode(get_irq_regs()));
 }
 
diff --git a/arch/ia64/kernel/time.c b/arch/ia64/kernel/time.c
index 641c8b6..022786f 100644
--- a/arch/ia64/kernel/time.c
+++ b/arch/ia64/kernel/time.c
@@ -201,6 +201,7 @@ timer_interrupt (int irq, void *dev_id)
 			do_timer(1);
 			local_cpu_data->itm_next = new_itm;
 			write_sequnlock(&xtime_lock);
+			calc_load(1);
 		} else
 			local_cpu_data->itm_next = new_itm;
 
diff --git a/arch/ia64/xen/time.c b/arch/ia64/xen/time.c
index fb83326..59dcadc 100644
--- a/arch/ia64/xen/time.c
+++ b/arch/ia64/xen/time.c
@@ -23,6 +23,7 @@
 #include <linux/delay.h>
 #include <linux/kernel_stat.h>
 #include <linux/posix-timers.h>
+#include <linux/timer.h>
 #include <linux/irq.h>
 #include <linux/clocksource.h>
 
@@ -145,6 +146,7 @@ consider_steal_time(unsigned long new_itm)
 			do_timer(stolen + blocked);
 			local_cpu_data->itm_next = delta_itm + new_itm;
 			write_sequnlock(&xtime_lock);
+			calc_load(stolen + blocked);
 		} else {
 			local_cpu_data->itm_next = delta_itm + new_itm;
 		}
diff --git a/arch/m32r/kernel/time.c b/arch/m32r/kernel/time.c
index cada3ba..8df1e8a 100644
--- a/arch/m32r/kernel/time.c
+++ b/arch/m32r/kernel/time.c
@@ -193,6 +193,7 @@ static irqreturn_t timer_interrupt(int irq, void *dev_id)
 	profile_tick(CPU_PROFILING);
 #endif
 	do_timer(1);
+	calc_load(1);
 
 #ifndef CONFIG_SMP
 	update_process_times(user_mode(get_irq_regs()));
diff --git a/arch/m68k/kernel/time.c b/arch/m68k/kernel/time.c
index 54d9807..a3b6f80 100644
--- a/arch/m68k/kernel/time.c
+++ b/arch/m68k/kernel/time.c
@@ -42,6 +42,7 @@ static inline int set_rtc_mmss(unsigned long nowtime)
 static irqreturn_t timer_interrupt(int irq, void *dummy)
 {
 	do_timer(1);
+	calc_load(1);
 #ifndef CONFIG_SMP
 	update_process_times(user_mode(get_irq_regs()));
 #endif
diff --git a/arch/m68k/sun3/sun3ints.c b/arch/m68k/sun3/sun3ints.c
index ad90393..55c63be 100644
--- a/arch/m68k/sun3/sun3ints.c
+++ b/arch/m68k/sun3/sun3ints.c
@@ -67,6 +67,7 @@ static irqreturn_t sun3_int5(int irq, void *dev_id)
 	intersil_clear();
 #endif
         do_timer(1);
+	calc_load(1);
 #ifndef CONFIG_SMP
 	update_process_times(user_mode(get_irq_regs()));
 #endif
diff --git a/arch/m68knommu/kernel/time.c b/arch/m68knommu/kernel/time.c
index d182b2f..55dc581 100644
--- a/arch/m68knommu/kernel/time.c
+++ b/arch/m68knommu/kernel/time.c
@@ -50,6 +50,8 @@ irqreturn_t arch_timer_interrupt(int irq, void *dummy)
 
 	write_sequnlock(&xtime_lock);
 
+	calc_load(1);
+
 #ifndef CONFIG_SMP
 	update_process_times(user_mode(get_irq_regs()));
 #endif
diff --git a/arch/mn10300/kernel/time.c b/arch/mn10300/kernel/time.c
index 395caf0..1d9c2d6 100644
--- a/arch/mn10300/kernel/time.c
+++ b/arch/mn10300/kernel/time.c
@@ -111,6 +111,7 @@ static irqreturn_t timer_interrupt(int irq, void *dev_id)
 		/* advance the kernel's time tracking system */
 		profile_tick(CPU_PROFILING);
 		do_timer(1);
+		calc_load(1);
 		check_rtc_time();
 	}
 
diff --git a/arch/parisc/kernel/time.c b/arch/parisc/kernel/time.c
index d4dd056..75fcf95 100644
--- a/arch/parisc/kernel/time.c
+++ b/arch/parisc/kernel/time.c
@@ -148,6 +148,7 @@ irqreturn_t __irq_entry timer_interrupt(int irq, void *dev_id)
 		write_seqlock(&xtime_lock);
 		do_timer(ticks_elapsed);
 		write_sequnlock(&xtime_lock);
+		calc_load(ticks_elapsed);
 	}
 
 	return IRQ_HANDLED;
diff --git a/arch/sh/kernel/time_32.c b/arch/sh/kernel/time_32.c
index c34e1e0..0c712b2 100644
--- a/arch/sh/kernel/time_32.c
+++ b/arch/sh/kernel/time_32.c
@@ -142,6 +142,7 @@ void handle_timer_tick(void)
 			last_rtc_update = xtime.tv_sec - 600;
 	}
 	write_sequnlock(&xtime_lock);
+	calc_load(1);
 
 #ifndef CONFIG_SMP
 	update_process_times(user_mode(get_irq_regs()));
diff --git a/arch/sh/kernel/time_64.c b/arch/sh/kernel/time_64.c
index 988c77c..db6739f 100644
--- a/arch/sh/kernel/time_64.c
+++ b/arch/sh/kernel/time_64.c
@@ -256,6 +256,7 @@ static inline void do_timer_interrupt(void)
 			last_rtc_update = xtime.tv_sec - 600;
 	}
 	write_sequnlock(&xtime_lock);
+	calc_load(1);
 
 #ifndef CONFIG_SMP
 	update_process_times(user_mode(get_irq_regs()));
diff --git a/arch/sparc/kernel/pcic.c b/arch/sparc/kernel/pcic.c
index 85e7037..4b8ef99 100644
--- a/arch/sparc/kernel/pcic.c
+++ b/arch/sparc/kernel/pcic.c
@@ -12,6 +12,7 @@
 
 #include <linux/kernel.h>
 #include <linux/types.h>
+#include <linux/timer.h>
 #include <linux/init.h>
 #include <linux/mm.h>
 #include <linux/slab.h>
@@ -707,6 +708,7 @@ static irqreturn_t pcic_timer_handler (int irq, void *h)
 	pcic_clear_clock_irq();
 	do_timer(1);
 	write_sequnlock(&xtime_lock);
+	calc_load(1);
 #ifndef CONFIG_SMP
 	update_process_times(user_mode(get_irq_regs()));
 #endif
diff --git a/arch/sparc/kernel/time_32.c b/arch/sparc/kernel/time_32.c
index 614ac7b..d032145 100644
--- a/arch/sparc/kernel/time_32.c
+++ b/arch/sparc/kernel/time_32.c
@@ -110,6 +110,7 @@ static irqreturn_t timer_interrupt(int dummy, void *dev_id)
 	    last_rtc_update = xtime.tv_sec - 600; /* do it again in 60 s */
 	}
 	write_sequnlock(&xtime_lock);
+	calc_load(1);
 
 #ifndef CONFIG_SMP
 	update_process_times(user_mode(get_irq_regs()));
diff --git a/arch/xtensa/kernel/time.c b/arch/xtensa/kernel/time.c
index 8848120..9e8cfd9 100644
--- a/arch/xtensa/kernel/time.c
+++ b/arch/xtensa/kernel/time.c
@@ -13,6 +13,7 @@
  */
 
 #include <linux/errno.h>
+#include <linux/timer.h>
 #include <linux/time.h>
 #include <linux/clocksource.h>
 #include <linux/interrupt.h>
@@ -111,6 +112,7 @@ again:
 		set_linux_timer(next);
 
 		write_sequnlock(&xtime_lock);
+		calc_load(1);
 	}
 
 	/* Allow platform to do something useful (Wdog). */
diff --git a/include/linux/timer.h b/include/linux/timer.h
index 6cdb6f3..9060a13 100644
--- a/include/linux/timer.h
+++ b/include/linux/timer.h
@@ -183,6 +183,11 @@ extern unsigned long next_timer_interrupt(void);
 extern unsigned long get_next_timer_interrupt(unsigned long now);
 
 /*
+ * Calculate load averages.
+ */
+extern void calc_load(unsigned long);
+
+/*
  * Timer-statistics info:
  */
 #ifdef CONFIG_TIMER_STATS
diff --git a/kernel/time/tick-common.c b/kernel/time/tick-common.c
index 21a5ca8..094aab9 100644
--- a/kernel/time/tick-common.c
+++ b/kernel/time/tick-common.c
@@ -67,6 +67,7 @@ static void tick_periodic(int cpu)
 
 		do_timer(1);
 		write_sequnlock(&xtime_lock);
+		calc_load(1);
 	}
 
 	update_process_times(user_mode(get_irq_regs()));
diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
index d3f1ef4..fd4f058 100644
--- a/kernel/time/tick-sched.c
+++ b/kernel/time/tick-sched.c
@@ -81,6 +81,8 @@ static void tick_do_update_jiffies64(ktime_t now)
 		tick_next_period = ktime_add(last_jiffies_update, tick_period);
 	}
 	write_sequnlock(&xtime_lock);
+	if (ticks)
+		calc_load(ticks);
 }
 
 /*
diff --git a/kernel/timer.c b/kernel/timer.c
index cffffad..472e9b1 100644
--- a/kernel/timer.c
+++ b/kernel/timer.c
@@ -1136,30 +1136,39 @@ static unsigned long count_active_tasks(void)
  * Nothing else seems to be standardized: the fractional size etc
  * all seem to differ on different machines.
  *
- * Requires xtime_lock to access.
+ * Requires avenrun_lock to write.  Readers are not protected.
  */
 unsigned long avenrun[3];
+static DEFINE_SPINLOCK(avenrun_lock);
 
 EXPORT_SYMBOL(avenrun);
 
 /*
  * calc_load - given tick count, update the avenrun load estimates.
- * This is called while holding a write_lock on xtime_lock.
  */
-static inline void calc_load(unsigned long ticks)
+void calc_load(unsigned long ticks)
 {
 	unsigned long active_tasks; /* fixed-point */
 	static int count = LOAD_FREQ;
 
 	count -= ticks;
 	if (unlikely(count < 0)) {
+		unsigned long avr_1, avr_5, avr_15;
 		active_tasks = count_active_tasks();
+		spin_lock(&avenrun_lock);
+		avr_1 = avenrun[0];
+		avr_5 = avenrun[1];
+		avr_15 = avenrun[2];
 		do {
-			CALC_LOAD(avenrun[0], EXP_1, active_tasks);
-			CALC_LOAD(avenrun[1], EXP_5, active_tasks);
-			CALC_LOAD(avenrun[2], EXP_15, active_tasks);
+			CALC_LOAD(avr_1, EXP_1, active_tasks);
+			CALC_LOAD(avr_5, EXP_5, active_tasks);
+			CALC_LOAD(avr_15, EXP_15, active_tasks);
 			count += LOAD_FREQ;
 		} while (count < 0);
+		avenrun[0] = avr_1;
+		avenrun[1] = avr_5;
+		avenrun[2] = avr_15;
+		spin_unlock(&avenrun_lock);
 	}
 }
 
@@ -1193,7 +1202,6 @@ void run_local_timers(void)
 static inline void update_times(unsigned long ticks)
 {
 	update_wall_time();
-	calc_load(ticks);
 }
 
 /*
-- 
1.5.4.rc3

