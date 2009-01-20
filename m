Return-Path: <linux-kernel-owner+w=401wt.eu-S1755936AbZATCxT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755936AbZATCxT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2009 21:53:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753913AbZATCxA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Jan 2009 21:53:00 -0500
Received: from vms173001pub.verizon.net ([206.46.173.1]:54184 "EHLO
	vms173001pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753537AbZATCw6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2009 21:52:58 -0500
Date: Mon, 19 Jan 2009 21:52:54 -0500 (EST)
From: Len Brown <lenb@kernel.org>
Subject: Re: [RESEND] [PATCH] : ACPI : Use clocksource to get the C-state time
 instead of ACPI PM timer
In-reply-to: <1231818636.4026.97.camel@yakui_zhao.sh.intel.com>
X-X-Sender: lenb@localhost.localdomain
To: Zhao Yakui <yakui.zhao@intel.com>
Cc: linux-acpi@vger.kernel.org,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Message-id: <alpine.LFD.2.00.0901192148370.21686@localhost.localdomain>
MIME-version: 1.0
Content-type: TEXT/PLAIN; charset=US-ASCII
References: <20081031184233.8588.42241.stgit@thinkpad>
 <1231818636.4026.97.camel@yakui_zhao.sh.intel.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Adding Thomas Gleixner and LKML to this thread.

Thomas,
Basically we're now faced with the possibility
of cores left idle for longer than the 24-bit
pm-timer can count (4.6 seconds), we we can't
hard code use of that timer for
C-state residency accounting.

Is ktime_get_real() the right interface to use?

thanks,
-Len

On Tue, 13 Jan 2009, Zhao Yakui wrote:

> Subject: ACPI: Use clocksource to get the C-state time instead of ACPI PM timer
> From: Zhao Yakui <yakui.zhao@intel.com>
> 
>     On most boxes the ACPI PM timer is 24-bit counter that runs on 3.579545MHz
> clock. In such case the max C-state sleep time should be less than 4687ms when
> it is used to record C2/C3 duration time. 
>     But on some boxes the max C-state sleep time is more than 4687ms. In such
> case the overflow happens and the C-state duration time can't be counted
> accurately.
>     Use clocksource to get the C-state time instead of ACPI PM timer
> 
> Based on the Venki's suggestion the function of ktime_get_real is used as it 
> is unnecessary to use the monotonic time.
> 
> Signed-off-by: Yakui Zhao <yakui.zhao@intel.com>
> Signed-off-by: Alexs Shi <alex.shi@intel.com>
> Signed-off-by: Shaohua Li <shaohua.li@intel.com>
> Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
> ---
>  drivers/acpi/processor_idle.c |   68 +++++++++++++++++++++++++-----------------
>  1 file changed, 42 insertions(+), 26 deletions(-)
> 
> Index: linux-2.6/drivers/acpi/processor_idle.c
> ===================================================================
> --- linux-2.6.orig/drivers/acpi/processor_idle.c
> +++ linux-2.6/drivers/acpi/processor_idle.c
> @@ -397,8 +397,8 @@ static void acpi_processor_idle(void)
>  	struct acpi_processor_cx *cx = NULL;
>  	struct acpi_processor_cx *next_state = NULL;
>  	int sleep_ticks = 0;
> -	u32 t1, t2 = 0;
> -
> +	ktime_t kt1, kt2;
> +	u64 sleep_interval;
>  	/*
>  	 * Interrupts must be disabled during bus mastering calculations and
>  	 * for C2/C3 transitions.
> @@ -543,23 +543,26 @@ static void acpi_processor_idle(void)
>  		break;
>  
>  	case ACPI_STATE_C2:
> -		/* Get start time (ticks) */
> -		t1 = inl(acpi_gbl_FADT.xpm_timer_block.address);
> +		kt1 = ktime_get_real();
>  		/* Tell the scheduler that we are going deep-idle: */
>  		sched_clock_idle_sleep_event();
>  		/* Invoke C2 */
>  		acpi_state_timer_broadcast(pr, cx, 1);
>  		acpi_cstate_enter(cx);
>  		/* Get end time (ticks) */
> -		t2 = inl(acpi_gbl_FADT.xpm_timer_block.address);
> -
> +		kt2 = ktime_get_real();
>  #if defined (CONFIG_GENERIC_TIME) && defined (CONFIG_X86)
>  		/* TSC halts in C2, so notify users */
>  		if (tsc_halts_in_c(ACPI_STATE_C2))
>  			mark_tsc_unstable("possible TSC halt in C2");
>  #endif
> +		/*
> +		 * Use the function of ktime_sub to get the time interval and
> +		 * then convert it to microsecond
> +		 */
> +		sleep_interval = ktime_to_us(ktime_sub(kt2, kt1));
>  		/* Compute time (ticks) that we were actually asleep */
> -		sleep_ticks = ticks_elapsed(t1, t2);
> +		sleep_ticks = US_TO_PM_TIMER_TICKS(sleep_interval);
>  
>  		/* Tell the scheduler how much we idled: */
>  		sched_clock_idle_wakeup_event(sleep_ticks*PM_TIMER_TICK_NS);
> @@ -605,13 +608,13 @@ static void acpi_processor_idle(void)
>  		}
>  
>  		/* Get start time (ticks) */
> -		t1 = inl(acpi_gbl_FADT.xpm_timer_block.address);
> +		kt1 = ktime_get_real();
>  		/* Invoke C3 */
>  		/* Tell the scheduler that we are going deep-idle: */
>  		sched_clock_idle_sleep_event();
>  		acpi_cstate_enter(cx);
>  		/* Get end time (ticks) */
> -		t2 = inl(acpi_gbl_FADT.xpm_timer_block.address);
> +		kt2 = ktime_get_real();
>  		if (pr->flags.bm_check && pr->flags.bm_control) {
>  			/* Enable bus master arbitration */
>  			atomic_dec(&c3_cpu_count);
> @@ -623,8 +626,13 @@ static void acpi_processor_idle(void)
>  		if (tsc_halts_in_c(ACPI_STATE_C3))
>  			mark_tsc_unstable("TSC halts in C3");
>  #endif
> +		/*
> +		 * Use the function of ktime_sub to get the time interval
> +		 * and convert it to microsecond.
> +		 */
> +		sleep_interval = ktime_to_us(ktime_sub(kt2, kt1));
>  		/* Compute time (ticks) that we were actually asleep */
> -		sleep_ticks = ticks_elapsed(t1, t2);
> +		sleep_ticks = US_TO_PM_TIMER_TICKS(sleep_interval);
>  		/* Tell the scheduler how much we idled: */
>  		sched_clock_idle_wakeup_event(sleep_ticks*PM_TIMER_TICK_NS);
>  
> @@ -1455,7 +1463,8 @@ static inline void acpi_idle_do_entry(st
>  static int acpi_idle_enter_c1(struct cpuidle_device *dev,
>  			      struct cpuidle_state *state)
>  {
> -	u32 t1, t2;
> +	ktime_t kt1, kt2;
> +	u64 sleep_interval;
>  	struct acpi_processor *pr;
>  	struct acpi_processor_cx *cx = cpuidle_get_statedata(state);
>  
> @@ -1476,14 +1485,18 @@ static int acpi_idle_enter_c1(struct cpu
>  	if (pr->flags.bm_check)
>  		acpi_idle_update_bm_rld(pr, cx);
>  
> -	t1 = inl(acpi_gbl_FADT.xpm_timer_block.address);
> +	kt1 = ktime_get_real();
>  	acpi_idle_do_entry(cx);
> -	t2 = inl(acpi_gbl_FADT.xpm_timer_block.address);
> +	kt2 = ktime_get_real();
>  
>  	local_irq_enable();
>  	cx->usage++;
> -
> -	return ticks_elapsed_in_us(t1, t2);
> +	/*
> +	 * Use the ktime_sub to get the time interval and then convert
> +	 * it to microseconds
> +	 */
> +	sleep_interval = ktime_to_us(ktime_sub(kt2, kt1));
> +	return sleep_interval;
>  }
>  
>  /**
> @@ -1496,7 +1509,8 @@ static int acpi_idle_enter_simple(struct
>  {
>  	struct acpi_processor *pr;
>  	struct acpi_processor_cx *cx = cpuidle_get_statedata(state);
> -	u32 t1, t2;
> +	ktime_t kt1, kt2;
> +	u64 sleep_interval;
>  	int sleep_ticks = 0;
>  
>  	pr = __get_cpu_var(processors);
> @@ -1533,18 +1547,19 @@ static int acpi_idle_enter_simple(struct
>  	if (cx->type == ACPI_STATE_C3)
>  		ACPI_FLUSH_CPU_CACHE();
>  
> -	t1 = inl(acpi_gbl_FADT.xpm_timer_block.address);
> +	kt1 = ktime_get_real();
>  	/* Tell the scheduler that we are going deep-idle: */
>  	sched_clock_idle_sleep_event();
>  	acpi_idle_do_entry(cx);
> -	t2 = inl(acpi_gbl_FADT.xpm_timer_block.address);
> +	kt2 = ktime_get_real();
>  
>  #if defined (CONFIG_GENERIC_TIME) && defined (CONFIG_X86)
>  	/* TSC could halt in idle, so notify users */
>  	if (tsc_halts_in_c(cx->type))
>  		mark_tsc_unstable("TSC halts in idle");;
>  #endif
> -	sleep_ticks = ticks_elapsed(t1, t2);
> +	sleep_interval = ktime_to_us(ktime_sub(kt2, kt1));
> +	sleep_ticks = US_TO_PM_TIMER_TICKS(sleep_interval);
>  
>  	/* Tell the scheduler how much we idled: */
>  	sched_clock_idle_wakeup_event(sleep_ticks*PM_TIMER_TICK_NS);
> @@ -1556,7 +1571,7 @@ static int acpi_idle_enter_simple(struct
>  
>  	acpi_state_timer_broadcast(pr, cx, 0);
>  	cx->time += sleep_ticks;
> -	return ticks_elapsed_in_us(t1, t2);
> +	return sleep_interval;
>  }
>  
>  static int c3_cpu_count;
> @@ -1574,7 +1589,8 @@ static int acpi_idle_enter_bm(struct cpu
>  {
>  	struct acpi_processor *pr;
>  	struct acpi_processor_cx *cx = cpuidle_get_statedata(state);
> -	u32 t1, t2;
> +	ktime_t  kt1, kt2;
> +	u64 sleep_interval;
>  	int sleep_ticks = 0;
>  
>  	pr = __get_cpu_var(processors);
> @@ -1643,10 +1659,9 @@ static int acpi_idle_enter_bm(struct cpu
>  	} else if (!pr->flags.bm_check) {
>  		ACPI_FLUSH_CPU_CACHE();
>  	}
> -
> -	t1 = inl(acpi_gbl_FADT.xpm_timer_block.address);
> +	kt1 = ktime_get_real();
>  	acpi_idle_do_entry(cx);
> -	t2 = inl(acpi_gbl_FADT.xpm_timer_block.address);
> +	kt2 = ktime_get_real();
>  
>  	/* Re-enable bus master arbitration */
>  	if (pr->flags.bm_check && pr->flags.bm_control) {
> @@ -1661,7 +1676,8 @@ static int acpi_idle_enter_bm(struct cpu
>  	if (tsc_halts_in_c(ACPI_STATE_C3))
>  		mark_tsc_unstable("TSC halts in idle");
>  #endif
> -	sleep_ticks = ticks_elapsed(t1, t2);
> +	sleep_interval = ktime_to_us(ktime_sub(kt2, kt1));
> +	sleep_ticks = US_TO_PM_TIMER_TICKS(sleep_interval);
>  	/* Tell the scheduler how much we idled: */
>  	sched_clock_idle_wakeup_event(sleep_ticks*PM_TIMER_TICK_NS);
>  
> @@ -1672,7 +1688,7 @@ static int acpi_idle_enter_bm(struct cpu
>  
>  	acpi_state_timer_broadcast(pr, cx, 0);
>  	cx->time += sleep_ticks;
> -	return ticks_elapsed_in_us(t1, t2);
> +	return sleep_interval;
>  }
>  
>  struct cpuidle_driver acpi_idle_driver = {
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-acpi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> Subject: ACPI: Use clocksource to get the C-state time instead of ACPI PM timer
> From: Zhao Yakui <yakui.zhao@intel.com>
> 
>     On most boxes the ACPI PM timer is 24-bit counter that runs on 3.579545MHz
> clock. In such case the max C-state sleep time should be less than 4687ms when
> it is used to record C2/C3 duration time. 
>     But on some boxes the max C-state sleep time is more than 4687ms. In such
> case the overflow happens and the C-state duration time can't be counted
> accurately.
>     Use clocksource to get the C-state time instead of ACPI PM timer
> 
> Based on the Venki's suggestion the function of ktime_get_real is used as it 
> is unnecessary to use the monotonic time.
> 
> Signed-off-by: Yakui Zhao <yakui.zhao@intel.com>
> Signed-off-by: Alexs Shi <alex.shi@intel.com>
> Signed-off-by: Shaohua Li <shaohua.li@intel.com>
> Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
> ---
>  drivers/acpi/processor_idle.c |   68 +++++++++++++++++++++++++-----------------
>  1 file changed, 42 insertions(+), 26 deletions(-)
> 
> Index: linux-2.6/drivers/acpi/processor_idle.c
> ===================================================================
> --- linux-2.6.orig/drivers/acpi/processor_idle.c
> +++ linux-2.6/drivers/acpi/processor_idle.c
> @@ -397,8 +397,8 @@ static void acpi_processor_idle(void)
>  	struct acpi_processor_cx *cx = NULL;
>  	struct acpi_processor_cx *next_state = NULL;
>  	int sleep_ticks = 0;
> -	u32 t1, t2 = 0;
> -
> +	ktime_t kt1, kt2;
> +	u64 sleep_interval;
>  	/*
>  	 * Interrupts must be disabled during bus mastering calculations and
>  	 * for C2/C3 transitions.
> @@ -543,23 +543,26 @@ static void acpi_processor_idle(void)
>  		break;
>  
>  	case ACPI_STATE_C2:
> -		/* Get start time (ticks) */
> -		t1 = inl(acpi_gbl_FADT.xpm_timer_block.address);
> +		kt1 = ktime_get_real();
>  		/* Tell the scheduler that we are going deep-idle: */
>  		sched_clock_idle_sleep_event();
>  		/* Invoke C2 */
>  		acpi_state_timer_broadcast(pr, cx, 1);
>  		acpi_cstate_enter(cx);
>  		/* Get end time (ticks) */
> -		t2 = inl(acpi_gbl_FADT.xpm_timer_block.address);
> -
> +		kt2 = ktime_get_real();
>  #if defined (CONFIG_GENERIC_TIME) && defined (CONFIG_X86)
>  		/* TSC halts in C2, so notify users */
>  		if (tsc_halts_in_c(ACPI_STATE_C2))
>  			mark_tsc_unstable("possible TSC halt in C2");
>  #endif
> +		/*
> +		 * Use the function of ktime_sub to get the time interval and
> +		 * then convert it to microsecond
> +		 */
> +		sleep_interval = ktime_to_us(ktime_sub(kt2, kt1));
>  		/* Compute time (ticks) that we were actually asleep */
> -		sleep_ticks = ticks_elapsed(t1, t2);
> +		sleep_ticks = US_TO_PM_TIMER_TICKS(sleep_interval);
>  
>  		/* Tell the scheduler how much we idled: */
>  		sched_clock_idle_wakeup_event(sleep_ticks*PM_TIMER_TICK_NS);
> @@ -605,13 +608,13 @@ static void acpi_processor_idle(void)
>  		}
>  
>  		/* Get start time (ticks) */
> -		t1 = inl(acpi_gbl_FADT.xpm_timer_block.address);
> +		kt1 = ktime_get_real();
>  		/* Invoke C3 */
>  		/* Tell the scheduler that we are going deep-idle: */
>  		sched_clock_idle_sleep_event();
>  		acpi_cstate_enter(cx);
>  		/* Get end time (ticks) */
> -		t2 = inl(acpi_gbl_FADT.xpm_timer_block.address);
> +		kt2 = ktime_get_real();
>  		if (pr->flags.bm_check && pr->flags.bm_control) {
>  			/* Enable bus master arbitration */
>  			atomic_dec(&c3_cpu_count);
> @@ -623,8 +626,13 @@ static void acpi_processor_idle(void)
>  		if (tsc_halts_in_c(ACPI_STATE_C3))
>  			mark_tsc_unstable("TSC halts in C3");
>  #endif
> +		/*
> +		 * Use the function of ktime_sub to get the time interval
> +		 * and convert it to microsecond.
> +		 */
> +		sleep_interval = ktime_to_us(ktime_sub(kt2, kt1));
>  		/* Compute time (ticks) that we were actually asleep */
> -		sleep_ticks = ticks_elapsed(t1, t2);
> +		sleep_ticks = US_TO_PM_TIMER_TICKS(sleep_interval);
>  		/* Tell the scheduler how much we idled: */
>  		sched_clock_idle_wakeup_event(sleep_ticks*PM_TIMER_TICK_NS);
>  
> @@ -1455,7 +1463,8 @@ static inline void acpi_idle_do_entry(st
>  static int acpi_idle_enter_c1(struct cpuidle_device *dev,
>  			      struct cpuidle_state *state)
>  {
> -	u32 t1, t2;
> +	ktime_t kt1, kt2;
> +	u64 sleep_interval;
>  	struct acpi_processor *pr;
>  	struct acpi_processor_cx *cx = cpuidle_get_statedata(state);
>  
> @@ -1476,14 +1485,18 @@ static int acpi_idle_enter_c1(struct cpu
>  	if (pr->flags.bm_check)
>  		acpi_idle_update_bm_rld(pr, cx);
>  
> -	t1 = inl(acpi_gbl_FADT.xpm_timer_block.address);
> +	kt1 = ktime_get_real();
>  	acpi_idle_do_entry(cx);
> -	t2 = inl(acpi_gbl_FADT.xpm_timer_block.address);
> +	kt2 = ktime_get_real();
>  
>  	local_irq_enable();
>  	cx->usage++;
> -
> -	return ticks_elapsed_in_us(t1, t2);
> +	/*
> +	 * Use the ktime_sub to get the time interval and then convert
> +	 * it to microseconds
> +	 */
> +	sleep_interval = ktime_to_us(ktime_sub(kt2, kt1));
> +	return sleep_interval;
>  }
>  
>  /**
> @@ -1496,7 +1509,8 @@ static int acpi_idle_enter_simple(struct
>  {
>  	struct acpi_processor *pr;
>  	struct acpi_processor_cx *cx = cpuidle_get_statedata(state);
> -	u32 t1, t2;
> +	ktime_t kt1, kt2;
> +	u64 sleep_interval;
>  	int sleep_ticks = 0;
>  
>  	pr = __get_cpu_var(processors);
> @@ -1533,18 +1547,19 @@ static int acpi_idle_enter_simple(struct
>  	if (cx->type == ACPI_STATE_C3)
>  		ACPI_FLUSH_CPU_CACHE();
>  
> -	t1 = inl(acpi_gbl_FADT.xpm_timer_block.address);
> +	kt1 = ktime_get_real();
>  	/* Tell the scheduler that we are going deep-idle: */
>  	sched_clock_idle_sleep_event();
>  	acpi_idle_do_entry(cx);
> -	t2 = inl(acpi_gbl_FADT.xpm_timer_block.address);
> +	kt2 = ktime_get_real();
>  
>  #if defined (CONFIG_GENERIC_TIME) && defined (CONFIG_X86)
>  	/* TSC could halt in idle, so notify users */
>  	if (tsc_halts_in_c(cx->type))
>  		mark_tsc_unstable("TSC halts in idle");;
>  #endif
> -	sleep_ticks = ticks_elapsed(t1, t2);
> +	sleep_interval = ktime_to_us(ktime_sub(kt2, kt1));
> +	sleep_ticks = US_TO_PM_TIMER_TICKS(sleep_interval);
>  
>  	/* Tell the scheduler how much we idled: */
>  	sched_clock_idle_wakeup_event(sleep_ticks*PM_TIMER_TICK_NS);
> @@ -1556,7 +1571,7 @@ static int acpi_idle_enter_simple(struct
>  
>  	acpi_state_timer_broadcast(pr, cx, 0);
>  	cx->time += sleep_ticks;
> -	return ticks_elapsed_in_us(t1, t2);
> +	return sleep_interval;
>  }
>  
>  static int c3_cpu_count;
> @@ -1574,7 +1589,8 @@ static int acpi_idle_enter_bm(struct cpu
>  {
>  	struct acpi_processor *pr;
>  	struct acpi_processor_cx *cx = cpuidle_get_statedata(state);
> -	u32 t1, t2;
> +	ktime_t  kt1, kt2;
> +	u64 sleep_interval;
>  	int sleep_ticks = 0;
>  
>  	pr = __get_cpu_var(processors);
> @@ -1643,10 +1659,9 @@ static int acpi_idle_enter_bm(struct cpu
>  	} else if (!pr->flags.bm_check) {
>  		ACPI_FLUSH_CPU_CACHE();
>  	}
> -
> -	t1 = inl(acpi_gbl_FADT.xpm_timer_block.address);
> +	kt1 = ktime_get_real();
>  	acpi_idle_do_entry(cx);
> -	t2 = inl(acpi_gbl_FADT.xpm_timer_block.address);
> +	kt2 = ktime_get_real();
>  
>  	/* Re-enable bus master arbitration */
>  	if (pr->flags.bm_check && pr->flags.bm_control) {
> @@ -1661,7 +1676,8 @@ static int acpi_idle_enter_bm(struct cpu
>  	if (tsc_halts_in_c(ACPI_STATE_C3))
>  		mark_tsc_unstable("TSC halts in idle");
>  #endif
> -	sleep_ticks = ticks_elapsed(t1, t2);
> +	sleep_interval = ktime_to_us(ktime_sub(kt2, kt1));
> +	sleep_ticks = US_TO_PM_TIMER_TICKS(sleep_interval);
>  	/* Tell the scheduler how much we idled: */
>  	sched_clock_idle_wakeup_event(sleep_ticks*PM_TIMER_TICK_NS);
>  
> @@ -1672,7 +1688,7 @@ static int acpi_idle_enter_bm(struct cpu
>  
>  	acpi_state_timer_broadcast(pr, cx, 0);
>  	cx->time += sleep_ticks;
> -	return ticks_elapsed_in_us(t1, t2);
> +	return sleep_interval;
>  }
>  
>  struct cpuidle_driver acpi_idle_driver = {
> 
> 
