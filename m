Return-Path: <linux-kernel-owner+w=401wt.eu-S1765392AbXJSFaT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765392AbXJSFaT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2007 01:30:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753709AbXJSFaH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Oct 2007 01:30:07 -0400
Received: from rex.snapgear.com ([203.143.235.140]:56517 "EHLO snapgear.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753162AbXJSFaE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2007 01:30:04 -0400
Date: Fri, 19 Oct 2007 15:29:17 +1000
From: Greg Ungerer <gerg@snapgear.com>
Message-Id: <200710190529.l9J5TH2S005354@goober>
To: torvalds@linux-foundation.org
Subject: [M68KNOMMU]: cleanup m68knommu timer code
Cc: gerg@uclinux.org, linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Reduce the function pointer mess of the m68knommu timer code.
Call direct to the local hardware's timer setup, and expose the local
common timer interrupt handler to the lower level hardware timer.
Ultimately this will save definitions of all these functions across
all the platform code to setup the function pointers (which for
any given m68knommu CPU family member can be only one set of hardware
timer functions).

Signed-off-by: Greg Ungerer <gerg@uclinux.org>
---

diffstat (relative to arch/m68knommu):
 kernel/setup.c          |    9 ---------
 kernel/time.c           |   22 ++++++++--------------
 platform/5206/config.c  |    9 ---------
 platform/5206e/config.c |   10 ----------
 platform/520x/config.c  |    8 +-------
 platform/523x/config.c  |    8 --------
 platform/5249/config.c  |   10 ----------
 platform/5272/config.c  |   10 ----------
 platform/527x/config.c  |    8 --------
 platform/528x/config.c  |    8 --------
 platform/5307/config.c  |   10 ----------
 platform/5307/pit.c     |   15 +++++++++------
 platform/5307/timers.c  |   19 +++++++++++--------
 platform/532x/config.c  |   10 ----------
 platform/5407/config.c  |   10 ----------
 15 files changed, 29 insertions(+), 137 deletions(-)


diff -Naurp linux-2.6.23/arch/m68knommu/kernel/setup.c linux-2.6.23.timers/arch/m68knommu/kernel/setup.c
--- linux-2.6.23/arch/m68knommu/kernel/setup.c	2007-10-10 06:31:38.000000000 +1000
+++ linux-2.6.23.timers/arch/m68knommu/kernel/setup.c	2007-10-19 15:08:24.000000000 +1000
@@ -287,12 +287,3 @@ struct seq_operations cpuinfo_op = {
 	.show	= show_cpuinfo,
 };
 
-void arch_gettod(int *year, int *mon, int *day, int *hour,
-		 int *min, int *sec)
-{
-	if (mach_gettod)
-		mach_gettod(year, mon, day, hour, min, sec);
-	else
-		*year = *mon = *day = *hour = *min = *sec = 0;
-}
-
diff -Naurp linux-2.6.23/arch/m68knommu/kernel/time.c linux-2.6.23.timers/arch/m68knommu/kernel/time.c
--- linux-2.6.23/arch/m68knommu/kernel/time.c	2007-10-10 06:31:38.000000000 +1000
+++ linux-2.6.23.timers/arch/m68knommu/kernel/time.c	2007-10-19 15:08:24.000000000 +1000
@@ -27,7 +27,6 @@
 
 #define	TICK_SIZE (tick_nsec / 1000)
 
-
 static inline int set_rtc_mmss(unsigned long nowtime)
 {
 	if (mach_set_clock_mmss)
@@ -39,15 +38,11 @@ static inline int set_rtc_mmss(unsigned 
  * timer_interrupt() needs to keep up the real-time clock,
  * as well as call the "do_timer()" routine every clocktick
  */
-static irqreturn_t timer_interrupt(int irq, void *dummy)
+irqreturn_t arch_timer_interrupt(int irq, void *dummy)
 {
 	/* last time the cmos clock got updated */
 	static long last_rtc_update=0;
 
-	/* may need to kick the hardware timer */
-	if (mach_tick)
-	  mach_tick();
-
 	write_seqlock(&xtime_lock);
 
 	do_timer(1);
@@ -103,10 +98,10 @@ void time_init(void)
 {
 	unsigned int year, mon, day, hour, min, sec;
 
-	extern void arch_gettod(int *year, int *mon, int *day, int *hour,
-				int *min, int *sec);
-
-	arch_gettod(&year, &mon, &day, &hour, &min, &sec);
+	if (mach_gettod)
+		mach_gettod(&year, &mon, &day, &hour, &min, &sec);
+	else
+		year = mon = day = hour = min = sec = 0;
 
 	if ((year += 1900) < 1970)
 		year += 100;
@@ -114,7 +109,7 @@ void time_init(void)
 	xtime.tv_nsec = 0;
 	wall_to_monotonic.tv_sec = -xtime.tv_sec;
 
-	mach_sched_init(timer_interrupt);
+	hw_timer_init();
 }
 
 /*
@@ -128,7 +123,7 @@ void do_gettimeofday(struct timeval *tv)
 
 	do {
 		seq = read_seqbegin_irqsave(&xtime_lock, flags);
-		usec = mach_gettimeoffset ? mach_gettimeoffset() : 0;
+		usec = hw_timer_offset();
 		sec = xtime.tv_sec;
 		usec += (xtime.tv_nsec / 1000);
 	} while (read_seqretry_irqrestore(&xtime_lock, seq, flags));
@@ -160,8 +155,7 @@ int do_settimeofday(struct timespec *tv)
 	 * Discover what correction gettimeofday
 	 * would have done, and then undo it!
 	 */
-	if (mach_gettimeoffset)
-		nsec -= (mach_gettimeoffset() * 1000);
+	nsec -= (hw_timer_offset() * 1000);
 
 	wtm_sec  = wall_to_monotonic.tv_sec + (xtime.tv_sec - sec);
 	wtm_nsec = wall_to_monotonic.tv_nsec + (xtime.tv_nsec - nsec);
diff -Naurp linux-2.6.23/arch/m68knommu/platform/5206/config.c linux-2.6.23.timers/arch/m68knommu/platform/5206/config.c
--- linux-2.6.23/arch/m68knommu/platform/5206/config.c	2007-10-10 06:31:38.000000000 +1000
+++ linux-2.6.23.timers/arch/m68knommu/platform/5206/config.c	2007-10-19 15:11:38.000000000 +1000
@@ -10,13 +10,10 @@
 /***************************************************************************/
 
 #include <linux/kernel.h>
-#include <linux/sched.h>
 #include <linux/param.h>
 #include <linux/init.h>
 #include <linux/interrupt.h>
-#include <asm/irq.h>
 #include <asm/dma.h>
-#include <asm/traps.h>
 #include <asm/machdep.h>
 #include <asm/coldfire.h>
 #include <asm/mcftimer.h>
@@ -25,9 +22,6 @@
 
 /***************************************************************************/
 
-void coldfire_tick(void);
-void coldfire_timer_init(irq_handler_t handler);
-unsigned long coldfire_timer_offset(void);
 void coldfire_reset(void);
 
 /***************************************************************************/
@@ -97,9 +91,6 @@ int mcf_timerirqpending(int timer)
 void config_BSP(char *commandp, int size)
 {
 	mcf_setimr(MCFSIM_IMR_MASKALL);
-	mach_sched_init = coldfire_timer_init;
-	mach_tick = coldfire_tick;
-	mach_gettimeoffset = coldfire_timer_offset;
 	mach_reset = coldfire_reset;
 }
 
diff -Naurp linux-2.6.23/arch/m68knommu/platform/5206e/config.c linux-2.6.23.timers/arch/m68knommu/platform/5206e/config.c
--- linux-2.6.23/arch/m68knommu/platform/5206e/config.c	2007-10-10 06:31:38.000000000 +1000
+++ linux-2.6.23.timers/arch/m68knommu/platform/5206e/config.c	2007-10-19 15:12:33.000000000 +1000
@@ -9,23 +9,16 @@
 /***************************************************************************/
 
 #include <linux/kernel.h>
-#include <linux/sched.h>
 #include <linux/param.h>
 #include <linux/interrupt.h>
-#include <asm/irq.h>
 #include <asm/dma.h>
-#include <asm/traps.h>
 #include <asm/machdep.h>
 #include <asm/coldfire.h>
-#include <asm/mcftimer.h>
 #include <asm/mcfsim.h>
 #include <asm/mcfdma.h>
 
 /***************************************************************************/
 
-void coldfire_tick(void);
-void coldfire_timer_init(irq_handler_t handler);
-unsigned long coldfire_timer_offset(void);
 void coldfire_reset(void);
 
 /***************************************************************************/
@@ -102,9 +95,6 @@ void config_BSP(char *commandp, int size
 	commandp[size-1] = 0;
 #endif /* CONFIG_NETtel */
 
-	mach_sched_init = coldfire_timer_init;
-	mach_tick = coldfire_tick;
-	mach_gettimeoffset = coldfire_timer_offset;
 	mach_reset = coldfire_reset;
 }
 
diff -Naurp linux-2.6.23/arch/m68knommu/platform/520x/config.c linux-2.6.23.timers/arch/m68knommu/platform/520x/config.c
--- linux-2.6.23/arch/m68knommu/platform/520x/config.c	2007-10-10 06:31:38.000000000 +1000
+++ linux-2.6.23.timers/arch/m68knommu/platform/520x/config.c	2007-10-19 15:13:13.000000000 +1000
@@ -27,9 +27,6 @@ unsigned int dma_device_address[MAX_M68K
 
 /***************************************************************************/
 
-void coldfire_pit_tick(void);
-void coldfire_pit_init(irq_handler_t handler);
-unsigned long coldfire_pit_offset(void);
 void coldfire_reset(void);
 
 /***************************************************************************/
@@ -47,10 +44,7 @@ void mcf_autovector(unsigned int vec)
 
 void config_BSP(char *commandp, int size)
 {
-    mach_sched_init = coldfire_pit_init;
-    mach_tick = coldfire_pit_tick;
-    mach_gettimeoffset = coldfire_pit_offset;
-    mach_reset = coldfire_reset;
+	mach_reset = coldfire_reset;
 }
 
 /***************************************************************************/
diff -Naurp linux-2.6.23/arch/m68knommu/platform/523x/config.c linux-2.6.23.timers/arch/m68knommu/platform/523x/config.c
--- linux-2.6.23/arch/m68knommu/platform/523x/config.c	2007-10-10 06:31:38.000000000 +1000
+++ linux-2.6.23.timers/arch/m68knommu/platform/523x/config.c	2007-10-19 15:13:57.000000000 +1000
@@ -13,12 +13,10 @@
 /***************************************************************************/
 
 #include <linux/kernel.h>
-#include <linux/sched.h>
 #include <linux/param.h>
 #include <linux/init.h>
 #include <linux/interrupt.h>
 #include <asm/dma.h>
-#include <asm/traps.h>
 #include <asm/machdep.h>
 #include <asm/coldfire.h>
 #include <asm/mcfsim.h>
@@ -26,9 +24,6 @@
 
 /***************************************************************************/
 
-void coldfire_pit_tick(void);
-void coldfire_pit_init(irq_handler_t handler);
-unsigned long coldfire_pit_offset(void);
 void coldfire_reset(void);
 
 /***************************************************************************/
@@ -62,9 +57,6 @@ void mcf_autovector(unsigned int vec)
 void config_BSP(char *commandp, int size)
 {
 	mcf_disableall();
-	mach_sched_init = coldfire_pit_init;
-	mach_tick = coldfire_pit_tick;
-	mach_gettimeoffset = coldfire_pit_offset;
 	mach_reset = coldfire_reset;
 }
 
diff -Naurp linux-2.6.23/arch/m68knommu/platform/5249/config.c linux-2.6.23.timers/arch/m68knommu/platform/5249/config.c
--- linux-2.6.23/arch/m68knommu/platform/5249/config.c	2007-10-10 06:31:38.000000000 +1000
+++ linux-2.6.23.timers/arch/m68knommu/platform/5249/config.c	2007-10-19 15:14:24.000000000 +1000
@@ -9,24 +9,17 @@
 /***************************************************************************/
 
 #include <linux/kernel.h>
-#include <linux/sched.h>
 #include <linux/param.h>
 #include <linux/init.h>
 #include <linux/interrupt.h>
-#include <asm/irq.h>
 #include <asm/dma.h>
-#include <asm/traps.h>
 #include <asm/machdep.h>
 #include <asm/coldfire.h>
-#include <asm/mcftimer.h>
 #include <asm/mcfsim.h>
 #include <asm/mcfdma.h>
 
 /***************************************************************************/
 
-void coldfire_tick(void);
-void coldfire_timer_init(irq_handler_t handler);
-unsigned long coldfire_timer_offset(void);
 void coldfire_reset(void);
 
 /***************************************************************************/
@@ -95,9 +88,6 @@ int mcf_timerirqpending(int timer)
 void config_BSP(char *commandp, int size)
 {
 	mcf_setimr(MCFSIM_IMR_MASKALL);
-	mach_sched_init = coldfire_timer_init;
-	mach_tick = coldfire_tick;
-	mach_gettimeoffset = coldfire_timer_offset;
 	mach_reset = coldfire_reset;
 }
 
diff -Naurp linux-2.6.23/arch/m68knommu/platform/5272/config.c linux-2.6.23.timers/arch/m68knommu/platform/5272/config.c
--- linux-2.6.23/arch/m68knommu/platform/5272/config.c	2007-10-10 06:31:38.000000000 +1000
+++ linux-2.6.23.timers/arch/m68knommu/platform/5272/config.c	2007-10-19 15:15:14.000000000 +1000
@@ -10,24 +10,17 @@
 /***************************************************************************/
 
 #include <linux/kernel.h>
-#include <linux/sched.h>
 #include <linux/param.h>
 #include <linux/init.h>
 #include <linux/interrupt.h>
-#include <asm/irq.h>
 #include <asm/dma.h>
-#include <asm/traps.h>
 #include <asm/machdep.h>
 #include <asm/coldfire.h>
-#include <asm/mcftimer.h>
 #include <asm/mcfsim.h>
 #include <asm/mcfdma.h>
 
 /***************************************************************************/
 
-void coldfire_tick(void);
-void coldfire_timer_init(irq_handler_t handler);
-unsigned long coldfire_timer_offset(void);
 void coldfire_reset(void);
 
 extern unsigned int mcf_timervector;
@@ -128,9 +121,6 @@ void config_BSP(char *commandp, int size
 
 	mcf_timervector = 69;
 	mcf_profilevector = 70;
-	mach_sched_init = coldfire_timer_init;
-	mach_tick = coldfire_tick;
-	mach_gettimeoffset = coldfire_timer_offset;
 	mach_reset = coldfire_reset;
 }
 
diff -Naurp linux-2.6.23/arch/m68knommu/platform/527x/config.c linux-2.6.23.timers/arch/m68knommu/platform/527x/config.c
--- linux-2.6.23/arch/m68knommu/platform/527x/config.c	2007-10-10 06:31:38.000000000 +1000
+++ linux-2.6.23.timers/arch/m68knommu/platform/527x/config.c	2007-10-19 15:15:33.000000000 +1000
@@ -13,12 +13,10 @@
 /***************************************************************************/
 
 #include <linux/kernel.h>
-#include <linux/sched.h>
 #include <linux/param.h>
 #include <linux/init.h>
 #include <linux/interrupt.h>
 #include <asm/dma.h>
-#include <asm/traps.h>
 #include <asm/machdep.h>
 #include <asm/coldfire.h>
 #include <asm/mcfsim.h>
@@ -26,9 +24,6 @@
 
 /***************************************************************************/
 
-void coldfire_pit_tick(void);
-void coldfire_pit_init(irq_handler_t handler);
-unsigned long coldfire_pit_offset(void);
 void coldfire_reset(void);
 
 /***************************************************************************/
@@ -62,9 +57,6 @@ void mcf_autovector(unsigned int vec)
 void config_BSP(char *commandp, int size)
 {
 	mcf_disableall();
-	mach_sched_init = coldfire_pit_init;
-	mach_tick = coldfire_pit_tick;
-	mach_gettimeoffset = coldfire_pit_offset;
 	mach_reset = coldfire_reset;
 }
 
diff -Naurp linux-2.6.23/arch/m68knommu/platform/528x/config.c linux-2.6.23.timers/arch/m68knommu/platform/528x/config.c
--- linux-2.6.23/arch/m68knommu/platform/528x/config.c	2007-10-10 06:31:38.000000000 +1000
+++ linux-2.6.23.timers/arch/m68knommu/platform/528x/config.c	2007-10-19 15:16:14.000000000 +1000
@@ -13,12 +13,10 @@
 /***************************************************************************/
 
 #include <linux/kernel.h>
-#include <linux/sched.h>
 #include <linux/param.h>
 #include <linux/init.h>
 #include <linux/interrupt.h>
 #include <asm/dma.h>
-#include <asm/traps.h>
 #include <asm/machdep.h>
 #include <asm/coldfire.h>
 #include <asm/mcfsim.h>
@@ -26,9 +24,6 @@
 
 /***************************************************************************/
 
-void coldfire_pit_tick(void);
-void coldfire_pit_init(irq_handler_t handler);
-unsigned long coldfire_pit_offset(void);
 void coldfire_reset(void);
 
 /***************************************************************************/
@@ -62,9 +57,6 @@ void mcf_autovector(unsigned int vec)
 void config_BSP(char *commandp, int size)
 {
 	mcf_disableall();
-	mach_sched_init = coldfire_pit_init;
-	mach_tick = coldfire_pit_tick;
-	mach_gettimeoffset = coldfire_pit_offset;
 	mach_reset = coldfire_reset;
 }
 
diff -Naurp linux-2.6.23/arch/m68knommu/platform/5307/config.c linux-2.6.23.timers/arch/m68knommu/platform/5307/config.c
--- linux-2.6.23/arch/m68knommu/platform/5307/config.c	2007-10-10 06:31:38.000000000 +1000
+++ linux-2.6.23.timers/arch/m68knommu/platform/5307/config.c	2007-10-19 15:16:57.000000000 +1000
@@ -10,25 +10,18 @@
 /***************************************************************************/
 
 #include <linux/kernel.h>
-#include <linux/sched.h>
 #include <linux/param.h>
 #include <linux/init.h>
 #include <linux/interrupt.h>
-#include <asm/irq.h>
 #include <asm/dma.h>
-#include <asm/traps.h>
 #include <asm/machdep.h>
 #include <asm/coldfire.h>
-#include <asm/mcftimer.h>
 #include <asm/mcfsim.h>
 #include <asm/mcfdma.h>
 #include <asm/mcfwdebug.h>
 
 /***************************************************************************/
 
-void coldfire_tick(void);
-void coldfire_timer_init(irq_handler_t handler);
-unsigned long coldfire_timer_offset(void);
 void coldfire_reset(void);
 
 extern unsigned int mcf_timervector;
@@ -122,9 +115,6 @@ void config_BSP(char *commandp, int size
 	mcf_timerlevel = 6;
 #endif
 
-	mach_sched_init = coldfire_timer_init;
-	mach_tick = coldfire_tick;
-	mach_gettimeoffset = coldfire_timer_offset;
 	mach_reset = coldfire_reset;
 
 #ifdef MCF_BDM_DISABLE
diff -Naurp linux-2.6.23/arch/m68knommu/platform/5307/pit.c linux-2.6.23.timers/arch/m68knommu/platform/5307/pit.c
--- linux-2.6.23/arch/m68knommu/platform/5307/pit.c	2007-10-10 06:31:38.000000000 +1000
+++ linux-2.6.23.timers/arch/m68knommu/platform/5307/pit.c	2007-10-19 15:04:28.000000000 +1000
@@ -17,6 +17,7 @@
 #include <linux/init.h>
 #include <linux/interrupt.h>
 #include <linux/irq.h>
+#include <asm/machdep.h>
 #include <asm/io.h>
 #include <asm/coldfire.h>
 #include <asm/mcfpit.h>
@@ -31,28 +32,30 @@
 
 /***************************************************************************/
 
-void coldfire_pit_tick(void)
+static irqreturn_t hw_tick(int irq, void *dummy)
 {
 	unsigned short pcsr;
 
 	/* Reset the ColdFire timer */
 	pcsr = __raw_readw(TA(MCFPIT_PCSR));
 	__raw_writew(pcsr | MCFPIT_PCSR_PIF, TA(MCFPIT_PCSR));
+
+	return arch_timer_interrupt(irq, dummy);
 }
 
 /***************************************************************************/
 
 static struct irqaction coldfire_pit_irq = {
-	.name    = "timer",
-	.flags   = IRQF_DISABLED | IRQF_TIMER,
+	.name	 = "timer",
+	.flags	 = IRQF_DISABLED | IRQF_TIMER,
+	.handler = hw_tick,
 };
 
-void coldfire_pit_init(irq_handler_t handler)
+void hw_timer_init(void)
 {
 	volatile unsigned char *icrp;
 	volatile unsigned long *imrp;
 
-	coldfire_pit_irq.handler = handler;
 	setup_irq(MCFINT_VECBASE + MCFINT_PIT1, &coldfire_pit_irq);
 
 	icrp = (volatile unsigned char *) (MCF_IPSBAR + MCFICM_INTC0 +
@@ -71,7 +74,7 @@ void coldfire_pit_init(irq_handler_t han
 
 /***************************************************************************/
 
-unsigned long coldfire_pit_offset(void)
+unsigned long hw_timer_offset(void)
 {
 	volatile unsigned long *ipr;
 	unsigned long pmr, pcntr, offset;
diff -Naurp linux-2.6.23/arch/m68knommu/platform/5307/timers.c linux-2.6.23.timers/arch/m68knommu/platform/5307/timers.c
--- linux-2.6.23/arch/m68knommu/platform/5307/timers.c	2007-10-10 06:31:38.000000000 +1000
+++ linux-2.6.23.timers/arch/m68knommu/platform/5307/timers.c	2007-10-19 15:07:36.000000000 +1000
@@ -9,10 +9,9 @@
 /***************************************************************************/
 
 #include <linux/kernel.h>
+#include <linux/init.h>
 #include <linux/sched.h>
-#include <linux/param.h>
 #include <linux/interrupt.h>
-#include <linux/init.h>
 #include <linux/irq.h>
 #include <asm/io.h>
 #include <asm/traps.h>
@@ -54,24 +53,28 @@ extern int mcf_timerirqpending(int timer
 
 /***************************************************************************/
 
-void coldfire_tick(void)
+static irqreturn_t hw_tick(int irq, void *dummy)
 {
 	/* Reset the ColdFire timer */
 	__raw_writeb(MCFTIMER_TER_CAP | MCFTIMER_TER_REF, TA(MCFTIMER_TER));
+
+	return arch_timer_interrupt(irq, dummy);
 }
 
 /***************************************************************************/
 
 static struct irqaction coldfire_timer_irq = {
-        .name    = "timer",
-        .flags   = IRQF_DISABLED | IRQF_TIMER,
+	.name	 = "timer",
+	.flags	 = IRQF_DISABLED | IRQF_TIMER,
+	.handler = hw_tick,
 };
 
+/***************************************************************************/
+
 static int ticks_per_intr;
 
-void coldfire_timer_init(irq_handler_t handler)
+void hw_timer_init(void)
 {
-	coldfire_timer_irq.handler = handler;
 	setup_irq(mcf_timervector, &coldfire_timer_irq);
 
 	__raw_writew(MCFTIMER_TMR_DISABLE, TA(MCFTIMER_TMR));
@@ -89,7 +92,7 @@ void coldfire_timer_init(irq_handler_t h
 
 /***************************************************************************/
 
-unsigned long coldfire_timer_offset(void)
+unsigned long hw_timer_offset(void)
 {
 	unsigned long tcn, offset;
 
diff -Naurp linux-2.6.23/arch/m68knommu/platform/532x/config.c linux-2.6.23.timers/arch/m68knommu/platform/532x/config.c
--- linux-2.6.23/arch/m68knommu/platform/532x/config.c	2007-10-10 06:31:38.000000000 +1000
+++ linux-2.6.23.timers/arch/m68knommu/platform/532x/config.c	2007-10-19 15:17:53.000000000 +1000
@@ -18,25 +18,18 @@
 /***************************************************************************/
 
 #include <linux/kernel.h>
-#include <linux/sched.h>
 #include <linux/param.h>
 #include <linux/init.h>
 #include <linux/interrupt.h>
-#include <asm/irq.h>
 #include <asm/dma.h>
-#include <asm/traps.h>
 #include <asm/machdep.h>
 #include <asm/coldfire.h>
-#include <asm/mcftimer.h>
 #include <asm/mcfsim.h>
 #include <asm/mcfdma.h>
 #include <asm/mcfwdebug.h>
 
 /***************************************************************************/
 
-void coldfire_tick(void);
-void coldfire_timer_init(irq_handler_t handler);
-unsigned long coldfire_timer_offset(void);
 void coldfire_reset(void);
 
 extern unsigned int mcf_timervector;
@@ -104,9 +97,6 @@ void config_BSP(char *commandp, int size
 
 	mcf_timervector = 64+32;
 	mcf_profilevector = 64+33;
-	mach_sched_init = coldfire_timer_init;
-	mach_tick = coldfire_tick;
-	mach_gettimeoffset = coldfire_timer_offset;
 	mach_reset = coldfire_reset;
 
 #ifdef MCF_BDM_DISABLE
diff -Naurp linux-2.6.23/arch/m68knommu/platform/5407/config.c linux-2.6.23.timers/arch/m68knommu/platform/5407/config.c
--- linux-2.6.23/arch/m68knommu/platform/5407/config.c	2007-10-10 06:31:38.000000000 +1000
+++ linux-2.6.23.timers/arch/m68knommu/platform/5407/config.c	2007-10-19 15:18:11.000000000 +1000
@@ -10,24 +10,17 @@
 /***************************************************************************/
 
 #include <linux/kernel.h>
-#include <linux/sched.h>
 #include <linux/param.h>
 #include <linux/init.h>
 #include <linux/interrupt.h>
-#include <asm/irq.h>
 #include <asm/dma.h>
-#include <asm/traps.h>
 #include <asm/machdep.h>
 #include <asm/coldfire.h>
-#include <asm/mcftimer.h>
 #include <asm/mcfsim.h>
 #include <asm/mcfdma.h>
 
 /***************************************************************************/
 
-void coldfire_tick(void);
-void coldfire_timer_init(irq_handler_t handler);
-unsigned long coldfire_timer_offset(void);
 void coldfire_reset(void);
 
 extern unsigned int mcf_timervector;
@@ -108,9 +101,6 @@ void config_BSP(char *commandp, int size
 	mcf_timerlevel = 6;
 #endif
 
-	mach_sched_init = coldfire_timer_init;
-	mach_tick = coldfire_tick;
-	mach_gettimeoffset = coldfire_timer_offset;
 	mach_reset = coldfire_reset;
 }
 
