Return-Path: <linux-kernel-owner+w=401wt.eu-S1764019AbXGVK7S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764019AbXGVK7S (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jul 2007 06:59:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753862AbXGVK7I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Jul 2007 06:59:08 -0400
Received: from ozlabs.org ([203.10.76.45]:54991 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753697AbXGVK7H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jul 2007 06:59:07 -0400
Subject: [PATCH] Fix lguest clock when jiffies not available
From: Rusty Russell <rusty@rustcorp.com.au>
To: lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>,
       virtualization <virtualization@lists.linux-foundation.org>
Cc: "Luiz Fernando N. Capitulino" <lcapitulino@gmail.com>,
       tglx <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>
Content-Type: text/plain
Date: Sun, 22 Jul 2007 20:58:19 +1000
Message-Id: <1185101899.6344.92.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

[ Ingo, Thomas cc'd in case this issue effects normal jiffies clock too? ]

When the Host TSC is unreliable or can change, lguest guests use the
jiffies clock.  However, the clock value seems to creep upwards in
sub-jiffies increments, and then tick_handle_periodic() goes into an
infinite loop.

Instead, the host writes the current time into the lguest page on
every interrupt.  This doesn't cost much but is more precise and at
least as accurate as the jiffies clock.  It also gets rid of the
GET_WALLCLOCK hypercall.

Also, delay setting sched_clock until our clock is set up, otherwise
the early printk timestamps can go backwards.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>

diff -r 144835834edd drivers/lguest/hypercalls.c
--- a/drivers/lguest/hypercalls.c	Sat Jul 21 11:12:01 2007 +1000
+++ b/drivers/lguest/hypercalls.c	Sun Jul 22 20:49:12 2007 +1000
@@ -44,12 +44,6 @@ static void do_hcall(struct lguest *lg, 
 		else
 			guest_pagetable_flush_user(lg);
 		break;
-	case LHCALL_GET_WALLCLOCK: {
-		struct timespec ts;
-		ktime_get_real_ts(&ts);
-		regs->eax = ts.tv_sec;
-		break;
-	}
 	case LHCALL_BIND_DMA:
 		regs->eax = bind_dma(lg, regs->edx, regs->ebx,
 				     regs->ecx >> 8, regs->ecx & 0xFF);
@@ -160,6 +154,8 @@ static void initialize(struct lguest *lg
 	    || put_user(lg->guestid, &lg->lguest_data->guestid))
 		kill_guest(lg, "bad guest page %p", lg->lguest_data);
 
+	write_timestamp(lg);
+
 	/* This is the one case where the above accesses might have
 	 * been the first write to a Guest page.  This may have caused
 	 * a copy-on-write fault, but the Guest might be referring to
@@ -190,3 +186,11 @@ void do_hypercalls(struct lguest *lg)
 		clear_hcall(lg);
 	}
 }
+
+void write_timestamp(struct lguest *lg)
+{
+	struct timespec now;
+	ktime_get_real_ts(&now);
+	if (put_user(now, &lg->lguest_data->time))
+		kill_guest(lg, "Writing timestamp");
+}
diff -r 144835834edd drivers/lguest/interrupts_and_traps.c
--- a/drivers/lguest/interrupts_and_traps.c	Sat Jul 21 11:12:01 2007 +1000
+++ b/drivers/lguest/interrupts_and_traps.c	Sun Jul 22 20:47:51 2007 +1000
@@ -107,6 +107,7 @@ void maybe_do_interrupt(struct lguest *l
 		clear_bit(irq, lg->irqs_pending);
 		set_guest_interrupt(lg, idt->a, idt->b, 0);
 	}
+	write_timestamp(lg);
 }
 
 static int has_err(unsigned int trap)
diff -r 144835834edd drivers/lguest/lg.h
--- a/drivers/lguest/lg.h	Sat Jul 21 11:12:01 2007 +1000
+++ b/drivers/lguest/lg.h	Sun Jul 22 20:49:03 2007 +1000
@@ -243,6 +243,7 @@ unsigned long get_dma_buffer(struct lgue
 
 /* hypercalls.c: */
 void do_hypercalls(struct lguest *lg);
+void write_timestamp(struct lguest *lg);
 
 #define kill_guest(lg, fmt...)					\
 do {								\
diff -r 144835834edd drivers/lguest/lguest.c
--- a/drivers/lguest/lguest.c	Sat Jul 21 11:12:01 2007 +1000
+++ b/drivers/lguest/lguest.c	Sun Jul 22 19:14:19 2007 +1000
@@ -345,15 +345,24 @@ static void __init lguest_init_IRQ(void)
 
 static unsigned long lguest_get_wallclock(void)
 {
-	return hcall(LHCALL_GET_WALLCLOCK, 0, 0, 0);
+	return lguest_data.time.tv_sec;
 }
 
 static cycle_t lguest_clock_read(void)
 {
+	unsigned long sec, nsec;
+
 	if (lguest_data.tsc_khz)
 		return native_read_tsc();
-	else
-		return jiffies;
+
+	/* Standard loop to make sure we get matching seconds & nanoseconds */
+	do {
+		sec = lguest_data.time.tv_sec;
+		rmb();
+		nsec = lguest_data.time.tv_nsec;
+		rmb();
+	} while (unlikely(lguest_data.time.tv_sec != sec));
+	return sec*1000000000ULL + nsec;
 }
 
 /* This is what we tell the kernel is our clocksource.  */
@@ -361,6 +370,8 @@ static struct clocksource lguest_clock =
 	.name		= "lguest",
 	.rating		= 400,
 	.read		= lguest_clock_read,
+	.mask		= CLOCKSOURCE_MASK(64),
+	.mult		= 1,
 };
 
 static unsigned long long lguest_sched_clock(void)
@@ -430,22 +441,17 @@ static void lguest_time_init(void)
 {
 	set_irq_handler(0, lguest_time_irq);
 
-	/* We use the TSC if the Host tells us we can, otherwise a dumb
-	 * jiffies-based clock. */
+	/* We use the TSC if the Host tells us we can, otherwise we use
+	 * the timestamp the Host sets. */
 	if (lguest_data.tsc_khz) {
 		lguest_clock.shift = 22;
 		lguest_clock.mult = clocksource_khz2mult(lguest_data.tsc_khz,
 							 lguest_clock.shift);
-		lguest_clock.mask = CLOCKSOURCE_MASK(64);
 		lguest_clock.flags = CLOCK_SOURCE_IS_CONTINUOUS;
-	} else {
-		/* To understand this, start at kernel/time/jiffies.c... */
-		lguest_clock.shift = 8;
-		lguest_clock.mult = (((u64)NSEC_PER_SEC<<8)/ACTHZ) << 8;
-		lguest_clock.mask = CLOCKSOURCE_MASK(32);
 	}
 	clock_base = lguest_clock_read();
 	clocksource_register(&lguest_clock);
+	paravirt_ops.sched_clock = lguest_sched_clock;
 
 	/* We can't set cpumask in the initializer: damn C limitations! */
 	lguest_clockevent.cpumask = cpumask_of_cpu(0);
@@ -590,7 +596,6 @@ __init void lguest_init(void *boot)
 	paravirt_ops.time_init = lguest_time_init;
 	paravirt_ops.set_lazy_mode = lguest_lazy_mode;
 	paravirt_ops.wbinvd = lguest_wbinvd;
-	paravirt_ops.sched_clock = lguest_sched_clock;
 
 	hcall(LHCALL_LGUEST_INIT, __pa(&lguest_data), 0, 0);
 
diff -r 144835834edd include/linux/lguest.h
--- a/include/linux/lguest.h	Sat Jul 21 11:12:01 2007 +1000
+++ b/include/linux/lguest.h	Sun Jul 22 19:10:30 2007 +1000
@@ -17,7 +17,6 @@
 #define LHCALL_TS		8
 #define LHCALL_SET_CLOCKEVENT	9
 #define LHCALL_HALT		10
-#define LHCALL_GET_WALLCLOCK	11
 #define LHCALL_BIND_DMA		12
 #define LHCALL_SEND_DMA		13
 #define LHCALL_SET_PTE		14
@@ -64,6 +63,9 @@ struct lguest_data
 	/* Virtual address of page fault. */
 	unsigned long cr2;
 
+	/* Wallclock time. */
+	struct timespec time;
+
 	/* Async hypercall ring.  0xFF == done, 0 == pending. */
 	u8 hcall_status[LHCALL_RING_SIZE];
 	struct hcall_ring hcalls[LHCALL_RING_SIZE];


