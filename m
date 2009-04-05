Return-Path: <linux-kernel-owner+w=401wt.eu-S1758298AbZDEUm7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758298AbZDEUm7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Apr 2009 16:42:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758118AbZDEUmu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Apr 2009 16:42:50 -0400
Received: from relay1.sgi.com ([192.48.179.29]:43286 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758045AbZDEUms (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Apr 2009 16:42:48 -0400
Date: Sun, 5 Apr 2009 15:42:43 -0500
From: Dimitri Sivanich <sivanich@sgi.com>
To: john stultz <johnstul@us.ibm.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH] Move calc_load call out from xtime_lock protection
Message-ID: <20090405204243.GA17934@sgi.com>
References: <20090403200647.GA22497@sgi.com> <1f1b08da0904031728m1369bfbat20e07a37b4a62604@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1f1b08da0904031728m1369bfbat20e07a37b4a62604@mail.gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 03, 2009 at 05:28:44PM -0700, john stultz wrote:
> On Fri, Apr 3, 2009 at 1:06 PM, Dimitri Sivanich <sivanich@sgi.com> wrote:
> > Why does the xtime_lock need to be held when calc_load() is called?
> > Since the calculation is statistical in nature, it doesn't -seem- to
> > warrant protection via a write lock.
> 
> I'm not very savvy on users of the loadavg values, so I'm not as
> confident that this won't break anything. In fact, without changes to
> the CALC_LOAD() macros so it uses an intermediate value, I expect some
> very incorrect values could be seen.
> 
> However, assuming that's fixed, and folks don't object to reading
> valid but inconsistent load avg values (ie: the 5 minute load not
> including high load seen in the 1minute load)  in the two functions
> above, then this might work.

John,

Instead of modifying the CALC_LOAD macros to avoid writing intermediate
results, how about going one step further and writing out the final
results at the end of the loop?

Also, maybe adding an avenrun_lock for writers might be a good thing as
well, in case anyone does call this from multiple cpus.

I've added both changes to the patch.

Again, there is no read lock however.  We could have the readers (that
currently take the xtime_lock) take the avenrun_lock, but I'm not sure
that's needed and have not included that in the following patch.

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
 kernel/time/tick-sched.c                   |    2 ++
 kernel/timer.c                             |   22 +++++++++++++++-------
 26 files changed, 53 insertions(+), 7 deletions(-)

Index: linux-2.6.tip/arch/ia64/kernel/time.c
===================================================================
--- linux-2.6.tip.orig/arch/ia64/kernel/time.c	2009-04-05 13:02:19.359763821 -0500
+++ linux-2.6.tip/arch/ia64/kernel/time.c	2009-04-05 13:02:54.836212099 -0500
@@ -201,6 +201,7 @@ timer_interrupt (int irq, void *dev_id)
 			do_timer(1);
 			local_cpu_data->itm_next = new_itm;
 			write_sequnlock(&xtime_lock);
+			calc_load(1);
 		} else
 			local_cpu_data->itm_next = new_itm;
 
Index: linux-2.6.tip/kernel/timer.c
===================================================================
--- linux-2.6.tip.orig/kernel/timer.c	2009-04-05 13:02:19.511782284 -0500
+++ linux-2.6.tip/kernel/timer.c	2009-04-05 14:29:41.036904141 -0500
@@ -1137,30 +1137,39 @@ static unsigned long count_active_tasks(
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
 
@@ -1196,7 +1205,6 @@ void run_local_timers(void)
 static inline void update_times(unsigned long ticks)
 {
 	update_wall_time();
-	calc_load(ticks);
 }
 
 /*
Index: linux-2.6.tip/include/linux/timer.h
===================================================================
--- linux-2.6.tip.orig/include/linux/timer.h	2009-04-05 13:02:19.555787402 -0500
+++ linux-2.6.tip/include/linux/timer.h	2009-04-05 14:10:09.017993176 -0500
@@ -183,6 +183,11 @@ extern unsigned long next_timer_interrup
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
Index: linux-2.6.tip/kernel/time/tick-common.c
===================================================================
--- linux-2.6.tip.orig/kernel/time/tick-common.c	2009-04-05 13:02:19.527783887 -0500
+++ linux-2.6.tip/kernel/time/tick-common.c	2009-04-05 13:02:54.888217283 -0500
@@ -67,6 +67,7 @@ static void tick_periodic(int cpu)
 
 		do_timer(1);
 		write_sequnlock(&xtime_lock);
+		calc_load(1);
 	}
 
 	update_process_times(user_mode(get_irq_regs()));
Index: linux-2.6.tip/kernel/time/tick-sched.c
===================================================================
--- linux-2.6.tip.orig/kernel/time/tick-sched.c	2009-04-05 13:02:19.539785321 -0500
+++ linux-2.6.tip/kernel/time/tick-sched.c	2009-04-05 14:34:01.249525583 -0500
@@ -81,6 +81,8 @@ static void tick_do_update_jiffies64(kti
 		tick_next_period = ktime_add(last_jiffies_update, tick_period);
 	}
 	write_sequnlock(&xtime_lock);
+	if (ticks)
+		calc_load(ticks);
 }
 
 /*
Index: linux-2.6.tip/arch/ia64/xen/time.c
===================================================================
--- linux-2.6.tip.orig/arch/ia64/xen/time.c	2009-04-05 13:02:19.371764627 -0500
+++ linux-2.6.tip/arch/ia64/xen/time.c	2009-04-05 13:02:54.928222711 -0500
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
--- linux-2.6.tip.orig/arch/alpha/kernel/time.c	2009-04-05 13:02:19.375765524 -0500
+++ linux-2.6.tip/arch/alpha/kernel/time.c	2009-04-05 13:02:54.952226080 -0500
@@ -137,6 +137,7 @@ irqreturn_t timer_interrupt(int irq, voi
 	}
 
 	write_sequnlock(&xtime_lock);
+	calc_load(nticks);
 
 #ifndef CONFIG_SMP
 	while (nticks--)
Index: linux-2.6.tip/arch/arm/kernel/time.c
===================================================================
--- linux-2.6.tip.orig/arch/arm/kernel/time.c	2009-04-05 13:02:19.391767506 -0500
+++ linux-2.6.tip/arch/arm/kernel/time.c	2009-04-05 13:02:54.972228358 -0500
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
--- linux-2.6.tip.orig/arch/blackfin/kernel/time.c	2009-04-05 13:02:19.427771709 -0500
+++ linux-2.6.tip/arch/blackfin/kernel/time.c	2009-04-05 13:02:54.992230730 -0500
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
--- linux-2.6.tip.orig/arch/frv/kernel/time.c	2009-04-05 13:02:19.427771709 -0500
+++ linux-2.6.tip/arch/frv/kernel/time.c	2009-04-05 13:02:55.020234374 -0500
@@ -97,6 +97,7 @@ static irqreturn_t timer_interrupt(int i
 #endif /* CONFIG_HEARTBEAT */
 
 	write_sequnlock(&xtime_lock);
+	calc_load(1);
 
 	update_process_times(user_mode(get_irq_regs()));
 
Index: linux-2.6.tip/arch/h8300/kernel/time.c
===================================================================
--- linux-2.6.tip.orig/arch/h8300/kernel/time.c	2009-04-05 13:02:19.431772456 -0500
+++ linux-2.6.tip/arch/h8300/kernel/time.c	2009-04-05 13:02:55.040236795 -0500
@@ -38,6 +38,7 @@ void h8300_timer_tick(void)
 	write_seqlock(&xtime_lock);
 	do_timer(1);
 	write_sequnlock(&xtime_lock);
+	calc_load(1);
 	update_process_times(user_mode(get_irq_regs()));
 }
 
Index: linux-2.6.tip/arch/m32r/kernel/time.c
===================================================================
--- linux-2.6.tip.orig/arch/m32r/kernel/time.c	2009-04-05 13:02:19.431772456 -0500
+++ linux-2.6.tip/arch/m32r/kernel/time.c	2009-04-05 13:02:55.060239474 -0500
@@ -193,6 +193,7 @@ static irqreturn_t timer_interrupt(int i
 	profile_tick(CPU_PROFILING);
 #endif
 	do_timer(1);
+	calc_load(1);
 
 #ifndef CONFIG_SMP
 	update_process_times(user_mode(get_irq_regs()));
Index: linux-2.6.tip/arch/m68k/kernel/time.c
===================================================================
--- linux-2.6.tip.orig/arch/m68k/kernel/time.c	2009-04-05 13:02:19.431772456 -0500
+++ linux-2.6.tip/arch/m68k/kernel/time.c	2009-04-05 13:02:55.080241974 -0500
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
--- linux-2.6.tip.orig/arch/m68k/sun3/sun3ints.c	2009-04-05 13:02:19.435772753 -0500
+++ linux-2.6.tip/arch/m68k/sun3/sun3ints.c	2009-04-05 13:02:55.096243905 -0500
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
--- linux-2.6.tip.orig/arch/m68knommu/kernel/time.c	2009-04-05 13:02:19.435772753 -0500
+++ linux-2.6.tip/arch/m68knommu/kernel/time.c	2009-04-05 13:02:55.120246973 -0500
@@ -50,6 +50,8 @@ irqreturn_t arch_timer_interrupt(int irq
 
 	write_sequnlock(&xtime_lock);
 
+	calc_load(1);
+
 #ifndef CONFIG_SMP
 	update_process_times(user_mode(get_irq_regs()));
 #endif
Index: linux-2.6.tip/arch/mn10300/kernel/time.c
===================================================================
--- linux-2.6.tip.orig/arch/mn10300/kernel/time.c	2009-04-05 13:02:19.435772753 -0500
+++ linux-2.6.tip/arch/mn10300/kernel/time.c	2009-04-05 13:02:55.144249920 -0500
@@ -111,6 +111,7 @@ static irqreturn_t timer_interrupt(int i
 		/* advance the kernel's time tracking system */
 		profile_tick(CPU_PROFILING);
 		do_timer(1);
+		calc_load(1);
 		check_rtc_time();
 	}
 
Index: linux-2.6.tip/arch/parisc/kernel/time.c
===================================================================
--- linux-2.6.tip.orig/arch/parisc/kernel/time.c	2009-04-05 13:02:19.439773571 -0500
+++ linux-2.6.tip/arch/parisc/kernel/time.c	2009-04-05 13:02:55.168253139 -0500
@@ -147,6 +147,7 @@ irqreturn_t timer_interrupt(int irq, voi
 		write_seqlock(&xtime_lock);
 		do_timer(ticks_elapsed);
 		write_sequnlock(&xtime_lock);
+		calc_load(ticks_elapsed);
 	}
 
 	return IRQ_HANDLED;
Index: linux-2.6.tip/arch/sh/kernel/time_32.c
===================================================================
--- linux-2.6.tip.orig/arch/sh/kernel/time_32.c	2009-04-05 13:02:19.451774806 -0500
+++ linux-2.6.tip/arch/sh/kernel/time_32.c	2009-04-05 13:02:55.192255858 -0500
@@ -142,6 +142,7 @@ void handle_timer_tick(void)
 			last_rtc_update = xtime.tv_sec - 600;
 	}
 	write_sequnlock(&xtime_lock);
+	calc_load(1);
 
 #ifndef CONFIG_SMP
 	update_process_times(user_mode(get_irq_regs()));
Index: linux-2.6.tip/arch/sh/kernel/time_64.c
===================================================================
--- linux-2.6.tip.orig/arch/sh/kernel/time_64.c	2009-04-05 13:02:19.467777487 -0500
+++ linux-2.6.tip/arch/sh/kernel/time_64.c	2009-04-05 13:02:55.204257420 -0500
@@ -256,6 +256,7 @@ static inline void do_timer_interrupt(vo
 			last_rtc_update = xtime.tv_sec - 600;
 	}
 	write_sequnlock(&xtime_lock);
+	calc_load(1);
 
 #ifndef CONFIG_SMP
 	update_process_times(user_mode(get_irq_regs()));
Index: linux-2.6.tip/arch/sparc/kernel/pcic.c
===================================================================
--- linux-2.6.tip.orig/arch/sparc/kernel/pcic.c	2009-04-05 13:02:19.479779071 -0500
+++ linux-2.6.tip/arch/sparc/kernel/pcic.c	2009-04-05 13:02:55.228260239 -0500
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
--- linux-2.6.tip.orig/arch/sparc/kernel/time_32.c	2009-04-05 13:02:19.491779806 -0500
+++ linux-2.6.tip/arch/sparc/kernel/time_32.c	2009-04-05 13:02:55.248262767 -0500
@@ -110,6 +110,7 @@ static irqreturn_t timer_interrupt(int d
 	    last_rtc_update = xtime.tv_sec - 600; /* do it again in 60 s */
 	}
 	write_sequnlock(&xtime_lock);
+	calc_load(1);
 
 #ifndef CONFIG_SMP
 	update_process_times(user_mode(get_irq_regs()));
Index: linux-2.6.tip/arch/xtensa/kernel/time.c
===================================================================
--- linux-2.6.tip.orig/arch/xtensa/kernel/time.c	2009-04-05 13:02:19.507782037 -0500
+++ linux-2.6.tip/arch/xtensa/kernel/time.c	2009-04-05 13:02:55.268265289 -0500
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
--- linux-2.6.tip.orig/arch/arm/mach-clps711x/include/mach/time.h	2009-04-05 13:02:19.395767924 -0500
+++ linux-2.6.tip/arch/arm/mach-clps711x/include/mach/time.h	2009-04-05 13:02:55.292268436 -0500
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
--- linux-2.6.tip.orig/arch/arm/mach-l7200/include/mach/time.h	2009-04-05 13:02:19.411769806 -0500
+++ linux-2.6.tip/arch/arm/mach-l7200/include/mach/time.h	2009-04-05 13:02:55.312271086 -0500
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
--- linux-2.6.tip.orig/arch/cris/arch-v10/kernel/time.c	2009-04-05 13:02:19.511782284 -0500
+++ linux-2.6.tip/arch/cris/arch-v10/kernel/time.c	2009-04-05 13:02:55.336274183 -0500
@@ -231,6 +231,8 @@ timer_interrupt(int irq, void *dev_id)
 	/* call the real timer interrupt handler */
 
 	do_timer(1);
+
+	calc_load(1);
 	
         cris_do_profile(regs); /* Save profiling information */
 
Index: linux-2.6.tip/arch/cris/arch-v32/kernel/time.c
===================================================================
--- linux-2.6.tip.orig/arch/cris/arch-v32/kernel/time.c	2009-04-05 13:02:19.511782284 -0500
+++ linux-2.6.tip/arch/cris/arch-v32/kernel/time.c	2009-04-05 13:02:55.360277002 -0500
@@ -240,6 +240,7 @@ timer_interrupt(int irq, void *dev_id)
 	/* Call the real timer interrupt handler */
 	do_timer(1);
 
+	calc_load(1);
 	/*
 	 * If we have an externally synchronized Linux clock, then update
 	 * CMOS clock accordingly every ~11 minutes. Set_rtc_mmss() has to be
