Return-Path: <linux-kernel-owner+w=401wt.eu-S932856AbXFEP3V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932856AbXFEP3V (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2007 11:29:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933030AbXFEP2n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jun 2007 11:28:43 -0400
Received: from ozlabs.org ([203.10.76.45]:37514 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932969AbXFEP2l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2007 11:28:41 -0400
Subject: [PATCH 5/6] lguest use TSC
From: Rusty Russell <rusty@rustcorp.com.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>,
       James Morris <jmorris@namei.org>, Andi Kleen <ak@muc.de>
In-Reply-To: <1181055606.14054.43.camel@localhost.localdomain>
References: <1181055308.14054.36.camel@localhost.localdomain>
	 <1181055396.14054.38.camel@localhost.localdomain>
	 <1181055483.14054.40.camel@localhost.localdomain>
	 <1181055606.14054.43.camel@localhost.localdomain>
Content-Type: text/plain
Date: Wed, 06 Jun 2007 01:02:40 +1000
Message-Id: <1181055760.14054.47.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

James: Add rudimentary TSC-based clocksource support (based on Rusty's original
patch).
Rusty: Add rudimentary code to handle TSC changing.  We can use the native
sched_clock again, we just have to tell it the TSC speed (get_cpu_khz).

(Note on benchmarks: Linux only sets the clock to the nearest second,
so expect it to be up to up to 1000000000 ns out.  But the narrowness
of the max - min range indicates consistency.)

Before:
Approximate accuracy of clock: 827460500 (819802000 - 834640500)

After:
Approximate accuracy of clock: 326354500 (326257000 - 327937500)

Signed-off-by: James Morris <jmorris@namei.org>
Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
---
 arch/i386/kernel/tsc.c  |    1 +
 drivers/lguest/core.c   |    9 +++++++++
 drivers/lguest/lg.h     |    1 +
 drivers/lguest/lguest.c |   40 ++++++++++++++++++++++++++++++++--------
 include/linux/lguest.h  |    2 ++
 5 files changed, 45 insertions(+), 8 deletions(-)

===================================================================
--- a/arch/i386/kernel/tsc.c
+++ b/arch/i386/kernel/tsc.c
@@ -27,6 +27,7 @@ static int tsc_enabled;
  * an extra value to store the TSC freq
  */
 unsigned int tsc_khz;
+EXPORT_SYMBOL_GPL(tsc_khz);
 
 int tsc_disable;
 
===================================================================
--- a/drivers/lguest/core.c
+++ b/drivers/lguest/core.c
@@ -332,6 +333,14 @@ int run_guest(struct lguest *lg, unsigne
 			continue;
 		}
 
+		/* If the Guest hasn't been told the clock multiplier to use or
+		 * it's changed, we update it here. */
+		if (unlikely(lg->tsc_khz != tsc_khz) && lg->lguest_data) {
+			lg->tsc_khz = tsc_khz;
+			if (put_user(lg->tsc_khz, &lg->lguest_data->tsc_khz))
+				return -EFAULT;
+		}
+
 		local_irq_disable();
 
 		/* Even if *we* don't want FPU trap, guest might... */
===================================================================
--- a/drivers/lguest/lg.h
+++ b/drivers/lguest/lg.h
@@ -160,6 +160,7 @@ struct lguest
 	unsigned long pending_key; /* address they're sending to */
 
 	unsigned int stack_pages;
+	u32 tsc_khz;
 
 	struct lguest_dma_info dma[LGUEST_MAX_DMA];
 
===================================================================
--- a/drivers/lguest/lguest.c
+++ b/drivers/lguest/lguest.c
@@ -25,6 +25,7 @@
 #include <linux/screen_info.h>
 #include <linux/irq.h>
 #include <linux/interrupt.h>
+#include <linux/clocksource.h>
 #include <linux/lguest.h>
 #include <linux/lguest_launcher.h>
 #include <linux/lguest_bus.h>
@@ -37,6 +38,7 @@
 #include <asm/e820.h>
 #include <asm/mce.h>
 #include <asm/io.h>
+#include <asm/sched-clock.h>
 
 /* Declarations for definitions in lguest_guest.S */
 extern char lguest_noirq_start[], lguest_noirq_end[];
@@ -209,8 +211,8 @@ static void lguest_cpuid(unsigned int *e
 	case 1:	/* Basic feature request. */
 		/* We only allow kernel to see SSE3, CMPXCHG16B and SSSE3 */
 		*ecx &= 0x00002201;
-		/* Similarly: SSE, SSE2, FXSR, MMX, CMOV, CMPXCHG8B, FPU. */
-		*edx &= 0x07808101;
+		/* SSE, SSE2, FXSR, MMX, CMOV, CMPXCHG8B, TSC, FPU. */
+		*edx &= 0x07808111;
 		/* Host wants to know when we flush kernel pages: set PGE. */
 		*edx |= 0x00002000;
 		break;
@@ -345,24 +347,46 @@ static unsigned long lguest_get_wallcloc
 	return hcall(LHCALL_GET_WALLCLOCK, 0, 0, 0);
 }
 
+/* This is what we tell the kernel is our clocksource.  It's the normal "Time
+ * Stamp Counter": the Host tells us what speed it's going at. */
+static struct clocksource lguest_clock = {
+	.name		= "lguest",
+	.rating		= 400,
+	.read		= native_read_tsc,
+	.mask		= CLOCKSOURCE_MASK(64),
+	.mult		= 0, /* to be set */
+	.shift		= 22,
+	.flags		= CLOCK_SOURCE_IS_CONTINUOUS,
+};
+
 static void lguest_time_irq(unsigned int irq, struct irq_desc *desc)
 {
+	/* Check in case host TSC has changed rate. */
+	if (unlikely(tsc_khz != lguest_data.tsc_khz)) {
+		tsc_khz = lguest_data.tsc_khz;
+		lguest_clock.mult = clocksource_khz2mult(tsc_khz, 22);
+		__get_cpu_var(sc_data).cyc2ns_scale
+			= (1000000 << CYC2NS_SCALE_FACTOR) / tsc_khz;
+	}
 	do_timer(hcall(LHCALL_TIMER_READ, 0, 0, 0));
 	update_process_times(user_mode_vm(get_irq_regs()));
 }
 
-static u64 sched_clock_base;
 static void lguest_time_init(void)
 {
 	set_irq_handler(0, lguest_time_irq);
+
+	lguest_clock.mult = clocksource_khz2mult(tsc_khz, 22);
+	clocksource_register(&lguest_clock);
+
 	hcall(LHCALL_TIMER_READ, 0, 0, 0);
-	sched_clock_base = jiffies_64;
 	enable_lguest_irq(0);
 }
 
-static unsigned long long lguest_sched_clock(void)
-{
-	return (jiffies_64 - sched_clock_base) * (1000000000 / HZ);
+static unsigned long lguest_get_cpu_khz(void)
+{
+	/* The Host tells us the TSC speed */
+	return lguest_data.tsc_khz;
 }
 
 static void lguest_load_esp0(struct tss_struct *tss,
@@ -501,7 +525,7 @@ __init void lguest_init(void *boot)
 	paravirt_ops.time_init = lguest_time_init;
 	paravirt_ops.set_lazy_mode = lguest_lazy_mode;
 	paravirt_ops.wbinvd = lguest_wbinvd;
-	paravirt_ops.sched_clock = lguest_sched_clock;
+	paravirt_ops.get_cpu_khz = lguest_get_cpu_khz;
 
 	hcall(LHCALL_LGUEST_INIT, __pa(&lguest_data), 0, 0);
 
===================================================================
--- a/include/linux/lguest.h
+++ b/include/linux/lguest.h
@@ -70,6 +70,8 @@ struct lguest_data
 	unsigned long reserve_mem;
 	/* ID of this guest (used by network driver to set ethernet address) */
 	u16 guestid;
+	/* KHz for the TSC clock. */
+	u32 tsc_khz;
 
 /* Fields initialized by the guest at boot: */
 	/* Instruction range to suppress interrupts even if enabled */


