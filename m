Return-Path: <linux-kernel-owner+w=401wt.eu-S1756212AbZBBBql@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756212AbZBBBql (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Feb 2009 20:46:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751722AbZBBBqb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Feb 2009 20:46:31 -0500
Received: from mga11.intel.com ([192.55.52.93]:47349 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751419AbZBBBqa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Feb 2009 20:46:30 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.37,362,1231142400"; 
   d="scan'208";a="661859654"
Subject: Re: [patch]: fixing of pmtimer overflow that make Cx states time
	incorrect
From: "alex.shi" <alex.shi@intel.com>
Reply-To: alex.shi@intel.com
To: Andrew Morton <akpm@linux-foundation.org>, "; lenb"@kernel.org
Cc: "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
       "; linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "; venkatesh.pallipadi"@intel.com
In-Reply-To: <1233453863.3715.35.camel@localhost.localdomain>
References: <1232342024.21839.6.camel@alexs-hp>
	 <20090126225235.5e64d0ef.akpm@linux-foundation.org>
	 <1233453863.3715.35.camel@localhost.localdomain>
Content-Type: text/plain
Date: Mon, 02 Feb 2009 09:46:57 +0800
Message-Id: <1233539217.4069.24.camel@alexs-hp>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yagui want to give a clear explanation to be used for commitment. So I resend
this again. 

    On most boxes the ACPI PM timer is 24-bit counter that runs on 3.579545MHz
clock. In such case the max C-state sleep time should be less than 4687ms when
it is used to record C2/C3 duration time. 
    But on some boxes the max C-state sleep time is more than 4687ms. In such
case the overflow happens and the C-state duration time can't be counted
accurately.

    Use clocksource to get the C-state time instead of ACPI PM timer. and use
div64_u64 to convert US_TO_PM_TIME_TICKS in i386 mode.

Thanks
Alex 

Asked-by: venkatesh.pallipadi@intel.com
Tested-by: Alex Shi <alex.shi@intel.com>
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


