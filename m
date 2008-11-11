Return-Path: <linux-kernel-owner+w=401wt.eu-S1754570AbYKKS2V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754570AbYKKS2V (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2008 13:28:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751096AbYKKS2H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Nov 2008 13:28:07 -0500
Received: from tomts13-srv.bellnexxia.net ([209.226.175.34]:64546 "EHLO
	tomts13-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750922AbYKKS2F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2008 13:28:05 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AhAFAPtZGUlMQWxa/2dsb2JhbACBdstJg1c
Date: Tue, 11 Nov 2008 13:28:00 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Nicolas Pitre <nico@cam.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, torvalds@linux-foundation.org,
       rmk+lkml@arm.linux.org.uk, dhowells@redhat.com, mingo@elte.hu,
       a.p.zijlstra@chello.nl, linux-kernel@vger.kernel.org,
       ralf@linux-mips.org, benh@kernel.crashing.org, paulus@samba.org,
       davem@davemloft.net, mingo@redhat.com, tglx@linutronix.de,
       rostedt@goodmis.org, linux-arch@vger.kernel.org
Subject: [PATCH] convert cnt32_to_63 to inline
Message-ID: <20081111182759.GA8052@Krystal>
References: <20081109064855.GA23782@Krystal> <alpine.LFD.2.00.0811090827160.13034@xanadu.home> <20081109162250.GB10181@Krystal> <alpine.LFD.2.00.0811092304300.13034@xanadu.home> <20081109204256.89ab7925.akpm@linux-foundation.org> <alpine.LFD.2.00.0811101627510.13034@xanadu.home> <20081110135850.0d620f3c.akpm@linux-foundation.org> <alpine.LFD.2.00.0811101811130.13034@xanadu.home> <20081110152221.64948d23.akpm@linux-foundation.org> <alpine.LFD.2.00.0811101917450.13034@xanadu.home>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0811101917450.13034@xanadu.home>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 13:22:41 up 159 days, 23:03, 10 users,  load average: 1.13, 1.04,
	0.88
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Nicolas Pitre (nico@cam.org) wrote:
> On Mon, 10 Nov 2008, Andrew Morton wrote:
> 
> > On Mon, 10 Nov 2008 18:15:32 -0500 (EST)
> > Nicolas Pitre <nico@cam.org> wrote:
> > 
> > > On Mon, 10 Nov 2008, Andrew Morton wrote:
> > > 
> > > > This references its second argument twice, which can cause correctness
> > > > or efficiency problems.
> > > > 
> > > > There is no reason that this had to be implemented in cpp. 
> > > > Implementing it in C will fix the above problem.
> > > 
> > > No, it won't, for correctness and efficiency reasons.
> > > 
> > > And I've explained why already.
> > 
> > I'd be very surprised if you've really found a case where a macro is
> > faster than an inlined function.  I don't think that has happened
> > before.
> 
> That hasn't anything to do with "a macro is faster" at all.  It's all 
> about the order used to evaluate provided arguments.  And the first one 
> might be anything like a memory value, an IO operation, an expression, 
> etc.  An inline function would work correctly with pointers only and 
> therefore totally break apart on x86 for example.
> 
> 
> Nicolas

Let's see what it gives once implemented. Only compile-tested. Assumes
pxa, sa110 and mn10300 are all UP-only. Correct smp_rmb() are used for
arm versatile.

Turn cnt32_to_63 into an inline function.
Change all callers to new API.
Document barrier usage.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
CC: Nicolas Pitre <nico@cam.org>
CC: Andrew Morton <akpm@linux-foundation.org>
CC: torvalds@linux-foundation.org
CC: rmk+lkml@arm.linux.org.uk
CC: dhowells@redhat.com
CC: paulus@samba.org
CC: a.p.zijlstra@chello.nl
CC: mingo@elte.hu
CC: benh@kernel.crashing.org
CC: rostedt@goodmis.org
CC: tglx@linutronix.de
CC: davem@davemloft.net
CC: ralf@linux-mips.org
---
 arch/arm/mach-pxa/time.c       |   14 ++++++++++++-
 arch/arm/mach-sa1100/generic.c |   15 +++++++++++++-
 arch/arm/mach-versatile/core.c |   12 ++++++++++-
 arch/mn10300/kernel/time.c     |   19 +++++++++++++-----
 include/linux/cnt32_to_63.h    |   42 +++++++++++++++++++++++++++++------------
 5 files changed, 82 insertions(+), 20 deletions(-)

Index: linux.trees.git/arch/arm/mach-pxa/time.c
===================================================================
--- linux.trees.git.orig/arch/arm/mach-pxa/time.c	2008-11-11 12:20:42.000000000 -0500
+++ linux.trees.git/arch/arm/mach-pxa/time.c	2008-11-11 13:05:01.000000000 -0500
@@ -37,6 +37,10 @@
 #define OSCR2NS_SCALE_FACTOR 10
 
 static unsigned long oscr2ns_scale;
+static u32 sched_clock_cnt_hi;	/*
+				 * Shared cnt_hi OK with cycle counter only
+				 * for UP systems.
+				 */
 
 static void __init set_oscr2ns_scale(unsigned long oscr_rate)
 {
@@ -54,7 +58,15 @@ static void __init set_oscr2ns_scale(uns
 
 unsigned long long sched_clock(void)
 {
-	unsigned long long v = cnt32_to_63(OSCR);
+	u32 cnt_lo, cnt_hi;
+	unsigned long long v;
+
+	preempt_disable_notrace();
+	cnt_hi = sched_clock_cnt_hi;
+	barrier();	/* read cnt_hi before cnt_lo */
+	cnt_lo = OSCR;
+	v = cnt32_to_63(cnt_hi, cnt_lo, &sched_clock_cnt_hi);
+	preempt_enable_notrace();
 	return (v * oscr2ns_scale) >> OSCR2NS_SCALE_FACTOR;
 }
 
Index: linux.trees.git/include/linux/cnt32_to_63.h
===================================================================
--- linux.trees.git.orig/include/linux/cnt32_to_63.h	2008-11-11 12:20:17.000000000 -0500
+++ linux.trees.git/include/linux/cnt32_to_63.h	2008-11-11 13:10:44.000000000 -0500
@@ -32,7 +32,9 @@ union cnt32_to_63 {
 
 /**
  * cnt32_to_63 - Expand a 32-bit counter to a 63-bit counter
- * @cnt_lo: The low part of the counter
+ * @cnt_hi: The high part of the counter (read first)
+ * @cnt_lo: The low part of the counter (read after cnt_hi)
+ * @cnt_hi_ptr: Pointer to high part of the counter
  *
  * Many hardware clock counters are only 32 bits wide and therefore have
  * a relatively short period making wrap-arounds rather frequent.  This
@@ -57,7 +59,10 @@ union cnt32_to_63 {
  * code must be executed at least once per each half period of the 32-bit
  * counter to properly update the state bit in memory. This is usually not a
  * problem in practice, but if it is then a kernel timer could be scheduled
- * to manage for this code to be executed often enough.
+ * to manage for this code to be executed often enough. If a per-cpu cnt_hi is
+ * used, the value must be updated at least once per 32-bits half-period on each
+ * CPU. If cnt_hi is shared between CPUs, it suffice to update it once per
+ * 32-bits half-period on any CPU.
  *
  * Note that the top bit (bit 63) in the returned value should be considered
  * as garbage.  It is not cleared here because callers are likely to use a
@@ -65,16 +70,29 @@ union cnt32_to_63 {
  * implicitly by making the multiplier even, therefore saving on a runtime
  * clear-bit instruction. Otherwise caller must remember to clear the top
  * bit explicitly.
+ *
+ * Preemption must be disabled when reading the cnt_hi and cnt_lo values and
+ * calling this function.
+ *
+ * The cnt_hi parameter _must_ be read before cnt_lo. This implies using the
+ * proper barriers :
+ * - smp_rmb() if cnt_lo is read from mmio and the cnt_hi variable is shared
+ *   across CPUs.
+ * - use a per-cpu variable for cnt_high if cnt_lo is read from per-cpu cycles
+ *   counters or to read the counters with only a barrier().
  */
-#define cnt32_to_63(cnt_lo) \
-({ \
-	static volatile u32 __m_cnt_hi; \
-	union cnt32_to_63 __x; \
-	__x.hi = __m_cnt_hi; \
-	__x.lo = (cnt_lo); \
-	if (unlikely((s32)(__x.hi ^ __x.lo) < 0)) \
-		__m_cnt_hi = __x.hi = (__x.hi ^ 0x80000000) + (__x.hi >> 31); \
-	__x.val; \
-})
+static inline u64 cnt32_to_63(u32 cnt_hi, u32 cnt_lo, u32 *cnt_hi_ptr)
+{
+	union cnt32_to_63 __x = {
+		{
+			.hi = cnt_hi,
+			.lo = cnt_lo,
+		},
+	};
+
+	if (unlikely((s32)(__x.hi ^ __x.lo) < 0))
+		*cnt_hi_ptr = __x.hi = (__x.hi ^ 0x80000000) + (__x.hi >> 31);
+	return __x.val;	/* Remember to clear the top bit in the caller */
+}
 
 #endif
Index: linux.trees.git/arch/arm/mach-sa1100/generic.c
===================================================================
--- linux.trees.git.orig/arch/arm/mach-sa1100/generic.c	2008-11-11 12:20:42.000000000 -0500
+++ linux.trees.git/arch/arm/mach-sa1100/generic.c	2008-11-11 13:05:10.000000000 -0500
@@ -34,6 +34,11 @@
 unsigned int reset_status;
 EXPORT_SYMBOL(reset_status);
 
+static u32 sched_clock_cnt_hi;	/*
+				 * Shared cnt_hi OK with cycle counter only
+				 * for UP systems.
+				 */
+
 #define NR_FREQS	16
 
 /*
@@ -133,7 +138,15 @@ EXPORT_SYMBOL(cpufreq_get);
  */
 unsigned long long sched_clock(void)
 {
-	unsigned long long v = cnt32_to_63(OSCR);
+	u32 cnt_lo, cnt_hi;
+	unsigned long long v;
+
+	preempt_disable_notrace();
+	cnt_hi = sched_clock_cnt_hi;
+	barrier();	/* read cnt_hi before cnt_lo */
+	cnt_lo = OSCR;
+	v = cnt32_to_63(cnt_hi, cnt_lo, &sched_clock_cnt_hi);
+	preempt_enable_notrace();
 
 	/* the <<1 gets rid of the cnt_32_to_63 top bit saving on a bic insn */
 	v *= 78125<<1;
Index: linux.trees.git/arch/arm/mach-versatile/core.c
===================================================================
--- linux.trees.git.orig/arch/arm/mach-versatile/core.c	2008-11-11 12:20:42.000000000 -0500
+++ linux.trees.git/arch/arm/mach-versatile/core.c	2008-11-11 12:57:55.000000000 -0500
@@ -60,6 +60,8 @@
 #define VA_VIC_BASE		__io_address(VERSATILE_VIC_BASE)
 #define VA_SIC_BASE		__io_address(VERSATILE_SIC_BASE)
 
+static u32 sched_clock_cnt_hi;
+
 static void sic_mask_irq(unsigned int irq)
 {
 	irq -= IRQ_SIC_START;
@@ -238,7 +240,15 @@ void __init versatile_map_io(void)
  */
 unsigned long long sched_clock(void)
 {
-	unsigned long long v = cnt32_to_63(readl(VERSATILE_REFCOUNTER));
+	u32 cnt_lo, cnt_hi;
+	unsigned long long v;
+
+	preempt_disable_notrace();
+	cnt_hi = sched_clock_cnt_hi;
+	smp_rmb();
+	cnt_lo = readl(VERSATILE_REFCOUNTER);
+	v = cnt32_to_63(cnt_hi, cnt_lo, &sched_clock_cnt_hi);
+	preempt_enable_notrace();
 
 	/* the <<1 gets rid of the cnt_32_to_63 top bit saving on a bic insn */
 	v *= 125<<1;
Index: linux.trees.git/arch/mn10300/kernel/time.c
===================================================================
--- linux.trees.git.orig/arch/mn10300/kernel/time.c	2008-11-11 12:41:42.000000000 -0500
+++ linux.trees.git/arch/mn10300/kernel/time.c	2008-11-11 13:04:42.000000000 -0500
@@ -29,6 +29,11 @@ unsigned long mn10300_iobclk;		/* system
 unsigned long mn10300_tsc_per_HZ;	/* number of ioclks per jiffy */
 #endif /* CONFIG_MN10300_RTC */
 
+static u32 sched_clock_cnt_hi;	/*
+				 * shared cnt_hi OK with cycle counter only
+				 * for UP systems.
+				 */
+
 static unsigned long mn10300_last_tsc;	/* time-stamp counter at last time
 					 * interrupt occurred */
 
@@ -52,18 +57,22 @@ unsigned long long sched_clock(void)
 		unsigned long long ll;
 		unsigned l[2];
 	} tsc64, result;
-	unsigned long tsc, tmp;
+	unsigned long tmp;
 	unsigned product[3]; /* 96-bit intermediate value */
+	u32 cnt_lo, cnt_hi;
 
-	/* read the TSC value
-	 */
-	tsc = 0 - get_cycles(); /* get_cycles() counts down */
+	preempt_disable_notrace();
+	cnt_hi = sched_clock_cnt_hi;
+	barrier();			/* read cnt_hi before cnt_lo */
+	cnt_lo = 0 - get_cycles();	/* get_cycles() counts down */
 
 	/* expand to 64-bits.
 	 * - sched_clock() must be called once a minute or better or the
 	 *   following will go horribly wrong - see cnt32_to_63()
 	 */
-	tsc64.ll = cnt32_to_63(tsc) & 0x7fffffffffffffffULL;
+	tsc64.ll = cnt32_to_63(cnt_hi, cnt_lo, &sched_clock_cnt_hi);
+	tsc64.ll &= 0x7fffffffffffffffULL;
+	preempt_enable_notrace();
 
 	/* scale the 64-bit TSC value to a nanosecond value via a 96-bit
 	 * intermediate


-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
