Return-Path: <linux-kernel-owner+w=401wt.eu-S1753614AbZBAKD1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753614AbZBAKD1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Feb 2009 05:03:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752771AbZBAKDR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Feb 2009 05:03:17 -0500
Received: from mga02.intel.com ([134.134.136.20]:42995 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752618AbZBAKDP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Feb 2009 05:03:15 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.37,359,1231142400"; 
   d="scan'208";a="382976744"
Subject: Re: [patch]: fixing of pmtimer overflow that make Cx states time
	incorrect
From: "alex.shi" <alex.shi@intel.com>
Reply-To: alex.shi@intel.com
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
       "; linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       ";venkatesh.pallipadi"@intel.com
In-Reply-To: <1233453863.3715.35.camel@localhost.localdomain>
References: <1232342024.21839.6.camel@alexs-hp>
	 <20090126225235.5e64d0ef.akpm@linux-foundation.org>
	 <1233453863.3715.35.camel@localhost.localdomain>
Content-Type: text/plain
Date: Sun, 01 Feb 2009 18:03:40 +0800
Message-Id: <1233482620.4069.9.camel@alexs-hp>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2009-02-01 at 10:04 +0800, Zhao, Yakui wrote:
> On Tue, 2009-01-27 at 14:52 +0800, Andrew Morton wrote:
> > The fix looks reasonable to me.
> > 
> > Please always cc linux-acpi@vger.kernel.org on acpi patches.
> > 
> > The patch was quite a mess: inlined code plus an attachment, mangled
> > email headers, funny characters in the email body, 300-column lines,
> > etc.
> > 
> > I reproduce a cleaned up copy below.
> Thanks for the clean up.
> But it seems that there exists a potential overflow.
> In the clean-up patch the data type of idle_time is defined as u32.
> And the idle_time will be converted to sleep_tick by using the macro
> definition of US_TO_PM_TIMER. 
> >#define US_TO_PM_TIMER_TICKS(t) ((t*(PM_TIMER_FREQUENCY/1000))/1000)
>  If the idle_time is more than 4.687s, the overflow will happen. 
>  So the interval variable(idle_time) had better be defined as 64-bit
> type.  
> 
> In fact the following patch is already updated based on the Venki's
> suggestion. 
>     The monotonic time is not required while getting the C-state sleep
> state. In such case the function of ktime_get_real is enough 
> 
> thanks.
> 
yes, this kind of overflow will cause a little Cx sleep time omit. So we
try to use s64 bit idle_time to present the Cx sleep time. For this
purpose we need to use div64_u64 to convert US_TO_PM_TICKS in i386
mode. So we rewrite this patch on 2.6.29-rc3 as following. Please revert
previous version before patch it. 

Alex 
> It's a bit odd that several of these functions (for example,
> acpi_idle_enter_bm()) return number-of-microseconds in a plain `int'. 
> It should be an unsigned scalar - `unsigned int', `u32', `u64', etc.

> 
> Also, all those functions have kerneldoc comments, but none of them
> document the function's return value, which is a rather important part
> of the interface!
> 
> Oh well.
> 
> 
> 
> From: Alex Shi <alex.shi@intel.com>
> 
> We found Cx states time abnormal in our some of machines which have 16
> LCPUs, the C0 take too many time while system is really idle when
kernel
> enabled tickless and highres.  powertop output is below: 
> 
>      PowerTOP version 1.9       (C) 2007 Intel Corporation
> 
> Cn                Avg residency       P-states (frequencies)
> C0 (cpu running)        (40.5%)         2.53 Ghz     0.0%
> C1                0.0ms ( 0.0%)         2.53 Ghz     0.0%
> C2              128.8ms (59.5%)         2.40 Ghz     0.0%
>                                         1.60 Ghz   100.0%
> 
> 
> Wakeups-from-idle per second :  4.7     interval: 20.0s
> no ACPI power usage estimate available
> 
> Top causes for wakeups:
>   41.4% ( 24.9)       <interrupt> : extra timer interrupt 
>   20.2% ( 12.2)     <kernel core> : usb_hcd_poll_rh_status
(rh_timer_func)
> 
> 
> After tacking detailed for this issue, Yakui and I find it is due to
24
> bit PM timer overflows when some of cpu sleep more than 4 seconds.
With
> tickless kernel, the CPU want to sleep as much as possible when system
> idle.  But the Cx sleep time are recorded by pmtimer which length is
> determined by BIOS.  The current Cx time was gotten in the following
> function from driver/acpi/processor_idle.c:
> 
> static inline u32 ticks_elapsed(u32 t1, u32 t2)
> {
>        if (t2 >= t1)
>                return (t2 - t1);
>        else if (!(acpi_gbl_FADT.flags & ACPI_FADT_32BIT_TIMER))
>                return (((0x00FFFFFF - t1) + t2) & 0x00FFFFFF);
>        else
>                return ((0xFFFFFFFF - t1) + t2);
> }
> 
> If pmtimer is 24 bits and it take 5 seconds from t1 to t2, in above
> function, just about 1 seconds ticks was recorded.  So the Cx time
will be
> reduced about 4 seconds.  and this is why we see above powertop
output.  
> 
> 
> To resolve this problem, Yakui and I use ktime_get() to record the Cx
> states time instead of PM timer as the following patch.  the patch was
> tested with i386/x86_64 modes on several platforms.  and the Cx states
> time become good.  this patch do not fully remove PM timer for Cx idle
> time recording.  Maybe it can be recovered if the PM timer get
improved in
> hardware.

Signed-off-by: Alex Shi <alex.shi@intel.com>
Signed-off-by: Yakui.zhao <yakui.zhao@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---
Index: linux-2.6.29-rc3/drivers/acpi/processor_idle.c
===================================================================
--- linux-2.6.29-rc3.orig/drivers/acpi/processor_idle.c
+++ linux-2.6.29-rc3/drivers/acpi/processor_idle.c
@@ -64,7 +64,8 @@
 #define _COMPONENT              ACPI_PROCESSOR_COMPONENT
 ACPI_MODULE_NAME("processor_idle");
 #define ACPI_PROCESSOR_FILE_POWER	"power"
-#define US_TO_PM_TIMER_TICKS(t)		((t * (PM_TIMER_FREQUENCY/1000)) / 1000)
+#define US_TO_PM_TIMER_TICKS(t)		div64_u64(\
+	(t * (PM_TIMER_FREQUENCY/1000)), 1000ULL)
 #define PM_TIMER_TICK_NS		(1000000000ULL/PM_TIMER_FREQUENCY)
 #ifndef CONFIG_CPU_IDLE
 #define C2_OVERHEAD			4	/* 1us (3.579 ticks per us) */
@@ -396,8 +397,9 @@ static void acpi_processor_idle(void)
 	struct acpi_processor *pr = NULL;
 	struct acpi_processor_cx *cx = NULL;
 	struct acpi_processor_cx *next_state = NULL;
-	int sleep_ticks = 0;
-	u32 t1, t2 = 0;
+	s64 sleep_ticks = 0;
+	ktime_t  kt1, kt2;
+	s64 idle_time;
 
 	/*
 	 * Interrupts must be disabled during bus mastering calculations and
@@ -544,14 +546,15 @@ static void acpi_processor_idle(void)
 
 	case ACPI_STATE_C2:
 		/* Get start time (ticks) */
-		t1 = inl(acpi_gbl_FADT.xpm_timer_block.address);
+		kt1 = ktime_get_real();
 		/* Tell the scheduler that we are going deep-idle: */
 		sched_clock_idle_sleep_event();
 		/* Invoke C2 */
 		acpi_state_timer_broadcast(pr, cx, 1);
 		acpi_cstate_enter(cx);
 		/* Get end time (ticks) */
-		t2 = inl(acpi_gbl_FADT.xpm_timer_block.address);
+		kt2 = ktime_get_real();
+		idle_time =  ktime_to_us(ktime_sub(kt2, kt1));
 
 #if defined (CONFIG_GENERIC_TIME) && defined (CONFIG_X86)
 		/* TSC halts in C2, so notify users */
@@ -559,7 +562,7 @@ static void acpi_processor_idle(void)
 			mark_tsc_unstable("possible TSC halt in C2");
 #endif
 		/* Compute time (ticks) that we were actually asleep */
-		sleep_ticks = ticks_elapsed(t1, t2);
+		sleep_ticks = US_TO_PM_TIMER_TICKS(idle_time);
 
 		/* Tell the scheduler how much we idled: */
 		sched_clock_idle_wakeup_event(sleep_ticks*PM_TIMER_TICK_NS);
@@ -605,13 +608,14 @@ static void acpi_processor_idle(void)
 		}
 
 		/* Get start time (ticks) */
-		t1 = inl(acpi_gbl_FADT.xpm_timer_block.address);
+		kt1 = ktime_get_real();
 		/* Invoke C3 */
 		/* Tell the scheduler that we are going deep-idle: */
 		sched_clock_idle_sleep_event();
 		acpi_cstate_enter(cx);
 		/* Get end time (ticks) */
-		t2 = inl(acpi_gbl_FADT.xpm_timer_block.address);
+		kt2 = ktime_get_real();
+		idle_time =  ktime_to_us(ktime_sub(kt2, kt1));
 		if (pr->flags.bm_check && pr->flags.bm_control) {
 			/* Enable bus master arbitration */
 			atomic_dec(&c3_cpu_count);
@@ -624,7 +628,7 @@ static void acpi_processor_idle(void)
 			mark_tsc_unstable("TSC halts in C3");
 #endif
 		/* Compute time (ticks) that we were actually asleep */
-		sleep_ticks = ticks_elapsed(t1, t2);
+		sleep_ticks = US_TO_PM_TIMER_TICKS(idle_time);
 		/* Tell the scheduler how much we idled: */
 		sched_clock_idle_wakeup_event(sleep_ticks*PM_TIMER_TICK_NS);
 
@@ -1455,7 +1459,8 @@ static inline void acpi_idle_do_entry(st
 static int acpi_idle_enter_c1(struct cpuidle_device *dev,
 			      struct cpuidle_state *state)
 {
-	u32 t1, t2;
+	ktime_t  kt1, kt2;
+	s64 idle_time;
 	struct acpi_processor *pr;
 	struct acpi_processor_cx *cx = cpuidle_get_statedata(state);
 
@@ -1476,14 +1481,15 @@ static int acpi_idle_enter_c1(struct cpu
 	if (pr->flags.bm_check)
 		acpi_idle_update_bm_rld(pr, cx);
 
-	t1 = inl(acpi_gbl_FADT.xpm_timer_block.address);
+	kt1 = ktime_get_real();
 	acpi_idle_do_entry(cx);
-	t2 = inl(acpi_gbl_FADT.xpm_timer_block.address);
+	kt2 = ktime_get_real();
+	idle_time =  ktime_to_us(ktime_sub(kt2, kt1));
 
 	local_irq_enable();
 	cx->usage++;
 
-	return ticks_elapsed_in_us(t1, t2);
+	return idle_time;
 }
 
 /**
@@ -1496,8 +1502,9 @@ static int acpi_idle_enter_simple(struct
 {
 	struct acpi_processor *pr;
 	struct acpi_processor_cx *cx = cpuidle_get_statedata(state);
-	u32 t1, t2;
-	int sleep_ticks = 0;
+	ktime_t  kt1, kt2;
+	s64 idle_time;
+	s64 sleep_ticks = 0;
 
 	pr = __get_cpu_var(processors);
 
@@ -1533,18 +1540,19 @@ static int acpi_idle_enter_simple(struct
 	if (cx->type == ACPI_STATE_C3)
 		ACPI_FLUSH_CPU_CACHE();
 
-	t1 = inl(acpi_gbl_FADT.xpm_timer_block.address);
+	kt1 = ktime_get_real();
 	/* Tell the scheduler that we are going deep-idle: */
 	sched_clock_idle_sleep_event();
 	acpi_idle_do_entry(cx);
-	t2 = inl(acpi_gbl_FADT.xpm_timer_block.address);
+	kt2 = ktime_get_real();
+	idle_time =  ktime_to_us(ktime_sub(kt2, kt1));
 
 #if defined (CONFIG_GENERIC_TIME) && defined (CONFIG_X86)
 	/* TSC could halt in idle, so notify users */
 	if (tsc_halts_in_c(cx->type))
 		mark_tsc_unstable("TSC halts in idle");;
 #endif
-	sleep_ticks = ticks_elapsed(t1, t2);
+	sleep_ticks = US_TO_PM_TIMER_TICKS(idle_time);
 
 	/* Tell the scheduler how much we idled: */
 	sched_clock_idle_wakeup_event(sleep_ticks*PM_TIMER_TICK_NS);
@@ -1556,7 +1564,7 @@ static int acpi_idle_enter_simple(struct
 
 	acpi_state_timer_broadcast(pr, cx, 0);
 	cx->time += sleep_ticks;
-	return ticks_elapsed_in_us(t1, t2);
+	return idle_time;
 }
 
 static int c3_cpu_count;
@@ -1574,8 +1582,9 @@ static int acpi_idle_enter_bm(struct cpu
 {
 	struct acpi_processor *pr;
 	struct acpi_processor_cx *cx = cpuidle_get_statedata(state);
-	u32 t1, t2;
-	int sleep_ticks = 0;
+	ktime_t  kt1, kt2;
+	s64 idle_time;
+	s64 sleep_ticks = 0;
 
 	pr = __get_cpu_var(processors);
 
@@ -1644,9 +1653,10 @@ static int acpi_idle_enter_bm(struct cpu
 		ACPI_FLUSH_CPU_CACHE();
 	}
 
-	t1 = inl(acpi_gbl_FADT.xpm_timer_block.address);
+	kt1 = ktime_get_real();
 	acpi_idle_do_entry(cx);
-	t2 = inl(acpi_gbl_FADT.xpm_timer_block.address);
+	kt2 = ktime_get_real();
+	idle_time =  ktime_to_us(ktime_sub(kt2, kt1));
 
 	/* Re-enable bus master arbitration */
 	if (pr->flags.bm_check && pr->flags.bm_control) {
@@ -1661,7 +1671,7 @@ static int acpi_idle_enter_bm(struct cpu
 	if (tsc_halts_in_c(ACPI_STATE_C3))
 		mark_tsc_unstable("TSC halts in idle");
 #endif
-	sleep_ticks = ticks_elapsed(t1, t2);
+	sleep_ticks = US_TO_PM_TIMER_TICKS(idle_time);
 	/* Tell the scheduler how much we idled: */
 	sched_clock_idle_wakeup_event(sleep_ticks*PM_TIMER_TICK_NS);
 
@@ -1672,7 +1682,7 @@ static int acpi_idle_enter_bm(struct cpu
 
 	acpi_state_timer_broadcast(pr, cx, 0);
 	cx->time += sleep_ticks;
-	return ticks_elapsed_in_us(t1, t2);
+	return idle_time;
 }
 
 struct cpuidle_driver acpi_idle_driver = {


