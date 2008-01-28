Return-Path: <linux-kernel-owner+w=401wt.eu-S1755096AbYA1KlY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755096AbYA1KlY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2008 05:41:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756298AbYA1Kku
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jan 2008 05:40:50 -0500
Received: from viefep18-int.chello.at ([213.46.255.22]:59141 "EHLO
	viefep11-int.chello.at" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755617AbYA1Kkp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2008 05:40:45 -0500
Message-Id: <20080128104055.935144000@chello.nl>
References: <20080128103953.326762000@chello.nl>
User-Agent: quilt/0.45-1
Date: Mon, 28 Jan 2008 11:39:54 +0100
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: rth@twiddle.net, rmk@arm.linux.org.uk, bryan.wu@analog.com,
       dhowells@redhat.com, gerg@uclinux.org, lethal@linux-sh.org,
       wli@holomorphy.com, davem@davemloft.net
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
       tglx@linutronix.de, mingo@elte.hu, torvalds@linux-foundation.org,
       a.p.zijlstra@chello.nl
Subject: [RFC][PATCH 1/2] Fix many ARM timer handlers
Content-Disposition: inline; filename=arm-xtime.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Russell King <rmk@arm.linux.org.uk>

Mostly untested patch: move the xtime write mode seqlock into
timer_tick(), so it only surrounds the call to do_timer().

This avoids a deadlock in update_process_times() ...
hrtimer_get_softirq_time() which tries to get a read mode seqlock
on xtime.

Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
---
 arch/arm/kernel/time.c                   |    2 ++
 arch/arm/mach-aaec2000/core.c            |    4 ----
 arch/arm/mach-clps711x/time.c            |    2 --
 arch/arm/mach-clps7500/core.c            |    4 ----
 arch/arm/mach-ebsa110/core.c             |    4 ----
 arch/arm/mach-ep93xx/core.c              |    4 ----
 arch/arm/mach-footbridge/dc21285-timer.c |    4 ----
 arch/arm/mach-footbridge/isa-timer.c     |    2 --
 arch/arm/mach-h720x/cpu-h7201.c          |    4 ----
 arch/arm/mach-h720x/cpu-h7202.c          |    2 --
 arch/arm/mach-integrator/core.c          |    4 ----
 arch/arm/mach-ixp2000/core.c             |    4 ----
 arch/arm/mach-ks8695/time.c              |    3 ---
 arch/arm/mach-lh7a40x/time.c             |    4 ----
 arch/arm/mach-mx3/time.c                 |    4 ----
 arch/arm/mach-netx/time.c                |    4 ----
 arch/arm/mach-omap2/timer-gp.c           |    4 ----
 arch/arm/mach-pnx4008/time.c             |    4 ----
 arch/arm/mach-realview/core.c            |    4 ----
 arch/arm/mach-sa1100/time.c              |    4 ----
 arch/arm/mach-shark/core.c               |    2 --
 21 files changed, 2 insertions(+), 71 deletions(-)

Index: linux-2.6/arch/arm/kernel/time.c
===================================================================
--- linux-2.6.orig/arch/arm/kernel/time.c
+++ linux-2.6/arch/arm/kernel/time.c
@@ -325,7 +325,9 @@ void timer_tick(void)
 	profile_tick(CPU_PROFILING);
 	do_leds();
 	do_set_rtc();
+	write_seqlock(&xtime_lock);
 	do_timer(1);
+	write_sequnlock(&xtime_lock);
 #ifndef CONFIG_SMP
 	update_process_times(user_mode(get_irq_regs()));
 #endif
Index: linux-2.6/arch/arm/mach-aaec2000/core.c
===================================================================
--- linux-2.6.orig/arch/arm/mach-aaec2000/core.c
+++ linux-2.6/arch/arm/mach-aaec2000/core.c
@@ -130,13 +130,9 @@ static irqreturn_t
 aaec2000_timer_interrupt(int irq, void *dev_id)
 {
 	/* TODO: Check timer accuracy */
-	write_seqlock(&xtime_lock);
-
 	timer_tick();
 	TIMER1_CLEAR = 1;
 
-	write_sequnlock(&xtime_lock);
-
 	return IRQ_HANDLED;
 }
 
Index: linux-2.6/arch/arm/mach-clps711x/time.c
===================================================================
--- linux-2.6.orig/arch/arm/mach-clps711x/time.c
+++ linux-2.6/arch/arm/mach-clps711x/time.c
@@ -50,9 +50,7 @@ static unsigned long clps711x_gettimeoff
 static irqreturn_t
 p720t_timer_interrupt(int irq, void *dev_id)
 {
-	write_seqlock(&xtime_lock);
 	timer_tick();
-	write_sequnlock(&xtime_lock);
 	return IRQ_HANDLED;
 }
 
Index: linux-2.6/arch/arm/mach-clps7500/core.c
===================================================================
--- linux-2.6.orig/arch/arm/mach-clps7500/core.c
+++ linux-2.6/arch/arm/mach-clps7500/core.c
@@ -298,8 +298,6 @@ extern unsigned long ioc_timer_gettimeof
 static irqreturn_t
 clps7500_timer_interrupt(int irq, void *dev_id)
 {
-	write_seqlock(&xtime_lock);
-
 	timer_tick();
 
 	/* Why not using do_leds interface?? */
@@ -313,8 +311,6 @@ clps7500_timer_interrupt(int irq, void *
 		}
 	}
 
-	write_sequnlock(&xtime_lock);
-
 	return IRQ_HANDLED;
 }
 
Index: linux-2.6/arch/arm/mach-ebsa110/core.c
===================================================================
--- linux-2.6.orig/arch/arm/mach-ebsa110/core.c
+++ linux-2.6/arch/arm/mach-ebsa110/core.c
@@ -178,8 +178,6 @@ ebsa110_timer_interrupt(int irq, void *d
 {
 	u32 count;
 
-	write_seqlock(&xtime_lock);
-
 	/* latch and read timer 1 */
 	__raw_writeb(0x40, PIT_CTRL);
 	count = __raw_readb(PIT_T1);
@@ -192,8 +190,6 @@ ebsa110_timer_interrupt(int irq, void *d
 
 	timer_tick();
 
-	write_sequnlock(&xtime_lock);
-
 	return IRQ_HANDLED;
 }
 
Index: linux-2.6/arch/arm/mach-ep93xx/core.c
===================================================================
--- linux-2.6.orig/arch/arm/mach-ep93xx/core.c
+++ linux-2.6/arch/arm/mach-ep93xx/core.c
@@ -99,8 +99,6 @@ static unsigned int last_jiffy_time;
 
 static int ep93xx_timer_interrupt(int irq, void *dev_id)
 {
-	write_seqlock(&xtime_lock);
-
 	__raw_writel(1, EP93XX_TIMER1_CLEAR);
 	while ((signed long)
 		(__raw_readl(EP93XX_TIMER4_VALUE_LOW) - last_jiffy_time)
@@ -109,8 +107,6 @@ static int ep93xx_timer_interrupt(int ir
 		timer_tick();
 	}
 
-	write_sequnlock(&xtime_lock);
-
 	return IRQ_HANDLED;
 }
 
Index: linux-2.6/arch/arm/mach-footbridge/dc21285-timer.c
===================================================================
--- linux-2.6.orig/arch/arm/mach-footbridge/dc21285-timer.c
+++ linux-2.6/arch/arm/mach-footbridge/dc21285-timer.c
@@ -30,14 +30,10 @@ static unsigned long timer1_gettimeoffse
 static irqreturn_t
 timer1_interrupt(int irq, void *dev_id)
 {
-	write_seqlock(&xtime_lock);
-
 	*CSR_TIMER1_CLR = 0;
 
 	timer_tick();
 
-	write_sequnlock(&xtime_lock);
-
 	return IRQ_HANDLED;
 }
 
Index: linux-2.6/arch/arm/mach-footbridge/isa-timer.c
===================================================================
--- linux-2.6.orig/arch/arm/mach-footbridge/isa-timer.c
+++ linux-2.6/arch/arm/mach-footbridge/isa-timer.c
@@ -64,9 +64,7 @@ static unsigned long isa_gettimeoffset(v
 static irqreturn_t
 isa_timer_interrupt(int irq, void *dev_id)
 {
-	write_seqlock(&xtime_lock);
 	timer_tick();
-	write_sequnlock(&xtime_lock);
 	return IRQ_HANDLED;
 }
 
Index: linux-2.6/arch/arm/mach-h720x/cpu-h7201.c
===================================================================
--- linux-2.6.orig/arch/arm/mach-h720x/cpu-h7201.c
+++ linux-2.6/arch/arm/mach-h720x/cpu-h7201.c
@@ -29,13 +29,9 @@
 static irqreturn_t
 h7201_timer_interrupt(int irq, void *dev_id)
 {
-	write_seqlock(&xtime_lock);
-
 	CPU_REG (TIMER_VIRT, TIMER_TOPSTAT);
 	timer_tick();
 
-	write_sequnlock(&xtime_lock);
-
 	return IRQ_HANDLED;
 }
 
Index: linux-2.6/arch/arm/mach-h720x/cpu-h7202.c
===================================================================
--- linux-2.6.orig/arch/arm/mach-h720x/cpu-h7202.c
+++ linux-2.6/arch/arm/mach-h720x/cpu-h7202.c
@@ -113,9 +113,7 @@ h7202_timerx_demux_handler(unsigned int 
 	mask = CPU_REG (TIMER_VIRT, TIMER_TOPSTAT);
 
 	if ( mask & TSTAT_T0INT ) {
-		write_seqlock(&xtime_lock);
 		timer_tick();
-		write_sequnlock(&xtime_lock);
 		if( mask == TSTAT_T0INT )
 			return;
 	}
Index: linux-2.6/arch/arm/mach-integrator/core.c
===================================================================
--- linux-2.6.orig/arch/arm/mach-integrator/core.c
+++ linux-2.6/arch/arm/mach-integrator/core.c
@@ -250,8 +250,6 @@ unsigned long integrator_gettimeoffset(v
 static irqreturn_t
 integrator_timer_interrupt(int irq, void *dev_id)
 {
-	write_seqlock(&xtime_lock);
-
 	/*
 	 * clear the interrupt
 	 */
@@ -259,8 +257,6 @@ integrator_timer_interrupt(int irq, void
 
 	timer_tick();
 
-	write_sequnlock(&xtime_lock);
-
 	return IRQ_HANDLED;
 }
 
Index: linux-2.6/arch/arm/mach-ixp2000/core.c
===================================================================
--- linux-2.6.orig/arch/arm/mach-ixp2000/core.c
+++ linux-2.6/arch/arm/mach-ixp2000/core.c
@@ -206,8 +206,6 @@ unsigned long ixp2000_gettimeoffset (voi
 
 static int ixp2000_timer_interrupt(int irq, void *dev_id)
 {
-	write_seqlock(&xtime_lock);
-
 	/* clear timer 1 */
 	ixp2000_reg_wrb(IXP2000_T1_CLR, 1);
 
@@ -217,8 +215,6 @@ static int ixp2000_timer_interrupt(int i
 		next_jiffy_time -= ticks_per_jiffy;
 	}
 
-	write_sequnlock(&xtime_lock);
-
 	return IRQ_HANDLED;
 }
 
Index: linux-2.6/arch/arm/mach-ks8695/time.c
===================================================================
--- linux-2.6.orig/arch/arm/mach-ks8695/time.c
+++ linux-2.6/arch/arm/mach-ks8695/time.c
@@ -70,10 +70,7 @@ static unsigned long ks8695_gettimeoffse
  */
 static irqreturn_t ks8695_timer_interrupt(int irq, void *dev_id)
 {
-	write_seqlock(&xtime_lock);
 	timer_tick();
-	write_sequnlock(&xtime_lock);
-
 	return IRQ_HANDLED;
 }
 
Index: linux-2.6/arch/arm/mach-lh7a40x/time.c
===================================================================
--- linux-2.6.orig/arch/arm/mach-lh7a40x/time.c
+++ linux-2.6/arch/arm/mach-lh7a40x/time.c
@@ -41,13 +41,9 @@
 static irqreturn_t
 lh7a40x_timer_interrupt(int irq, void *dev_id)
 {
-	write_seqlock(&xtime_lock);
-
 	TIMER_EOI = 0;
 	timer_tick();
 
-	write_sequnlock(&xtime_lock);
-
 	return IRQ_HANDLED;
 }
 
Index: linux-2.6/arch/arm/mach-mx3/time.c
===================================================================
--- linux-2.6.orig/arch/arm/mach-mx3/time.c
+++ linux-2.6/arch/arm/mach-mx3/time.c
@@ -45,8 +45,6 @@ static irqreturn_t mxc_timer_interrupt(i
 {
 	unsigned int next_match;
 
-	write_seqlock(&xtime_lock);
-
 	if (__raw_readl(MXC_GPT_GPTSR) & GPTSR_OF1) {
 		do {
 			timer_tick();
@@ -57,8 +55,6 @@ static irqreturn_t mxc_timer_interrupt(i
 				       __raw_readl(MXC_GPT_GPTCNT)) <= 0);
 	}
 
-	write_sequnlock(&xtime_lock);
-
 	return IRQ_HANDLED;
 }
 
Index: linux-2.6/arch/arm/mach-netx/time.c
===================================================================
--- linux-2.6.orig/arch/arm/mach-netx/time.c
+++ linux-2.6/arch/arm/mach-netx/time.c
@@ -33,12 +33,8 @@
 static irqreturn_t
 netx_timer_interrupt(int irq, void *dev_id)
 {
-	write_seqlock(&xtime_lock);
-
 	timer_tick();
 
-	write_sequnlock(&xtime_lock);
-
 	/* acknowledge interrupt */
 	writel(COUNTER_BIT(0), NETX_GPIO_IRQ);
 
Index: linux-2.6/arch/arm/mach-omap2/timer-gp.c
===================================================================
--- linux-2.6.orig/arch/arm/mach-omap2/timer-gp.c
+++ linux-2.6/arch/arm/mach-omap2/timer-gp.c
@@ -40,13 +40,9 @@ static inline void omap2_gp_timer_start(
 
 static irqreturn_t omap2_gp_timer_interrupt(int irq, void *dev_id)
 {
-	write_seqlock(&xtime_lock);
-
 	omap_dm_timer_write_status(gptimer, OMAP_TIMER_INT_OVERFLOW);
 	timer_tick();
 
-	write_sequnlock(&xtime_lock);
-
 	return IRQ_HANDLED;
 }
 
Index: linux-2.6/arch/arm/mach-pnx4008/time.c
===================================================================
--- linux-2.6.orig/arch/arm/mach-pnx4008/time.c
+++ linux-2.6/arch/arm/mach-pnx4008/time.c
@@ -51,8 +51,6 @@ static irqreturn_t pnx4008_timer_interru
 {
 	if (__raw_readl(HSTIM_INT) & MATCH0_INT) {
 
-		write_seqlock(&xtime_lock);
-
 		do {
 			timer_tick();
 
@@ -73,8 +71,6 @@ static irqreturn_t pnx4008_timer_interru
 		} while ((signed)
 			 (__raw_readl(HSTIM_MATCH0) -
 			  __raw_readl(HSTIM_COUNTER)) < 0);
-
-		write_sequnlock(&xtime_lock);
 	}
 
 	return IRQ_HANDLED;
Index: linux-2.6/arch/arm/mach-realview/core.c
===================================================================
--- linux-2.6.orig/arch/arm/mach-realview/core.c
+++ linux-2.6/arch/arm/mach-realview/core.c
@@ -530,8 +530,6 @@ static unsigned long realview_gettimeoff
  */
 static irqreturn_t realview_timer_interrupt(int irq, void *dev_id)
 {
-	write_seqlock(&xtime_lock);
-
 	// ...clear the interrupt
 	writel(1, TIMER0_VA_BASE + TIMER_INTCLR);
 
@@ -542,8 +540,6 @@ static irqreturn_t realview_timer_interr
 	update_process_times(user_mode(get_irq_regs()));
 #endif
 
-	write_sequnlock(&xtime_lock);
-
 	return IRQ_HANDLED;
 }
 
Index: linux-2.6/arch/arm/mach-sa1100/time.c
===================================================================
--- linux-2.6.orig/arch/arm/mach-sa1100/time.c
+++ linux-2.6/arch/arm/mach-sa1100/time.c
@@ -62,8 +62,6 @@ sa1100_timer_interrupt(int irq, void *de
 {
 	unsigned int next_match;
 
-	write_seqlock(&xtime_lock);
-
 #ifdef CONFIG_NO_IDLE_HZ
 	if (match_posponed) {
 		match_posponed = 0;
@@ -85,8 +83,6 @@ sa1100_timer_interrupt(int irq, void *de
 		next_match = (OSMR0 += LATCH);
 	} while ((signed long)(next_match - OSCR) <= 0);
 
-	write_sequnlock(&xtime_lock);
-
 	return IRQ_HANDLED;
 }
 
Index: linux-2.6/arch/arm/mach-shark/core.c
===================================================================
--- linux-2.6.orig/arch/arm/mach-shark/core.c
+++ linux-2.6/arch/arm/mach-shark/core.c
@@ -82,9 +82,7 @@ static void __init shark_map_io(void)
 static irqreturn_t
 shark_timer_interrupt(int irq, void *dev_id)
 {
-	write_seqlock(&xtime_lock);
 	timer_tick();
-	write_sequnlock(&xtime_lock);
 	return IRQ_HANDLED;
 }
 

--

