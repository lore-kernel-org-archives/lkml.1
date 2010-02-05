Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933452Ab0BEUyM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Feb 2010 15:54:12 -0500
Received: from jgarrett.org ([64.5.53.252]:41755 "EHLO jgarrett.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757041Ab0BEUyH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Feb 2010 15:54:07 -0500
Date: Fri, 5 Feb 2010 14:53:12 -0600
To: Len Brown <lenb@kernel.org>
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
       linux-acpi@vger.kernel.org
Subject: Re: acpi_idle: Very idle Core i7 machine never enters C3
Message-ID: <20100205205312.GA4532@jgarrett.org>
References: <20100126084740.GA5265@jgarrett.org> <87y6jkee1b.fsf@basil.nowhere.org> <20100205160900.GA2736@jgarrett.org> <alpine.LFD.2.00.1002051238280.4050@localhost.localdomain>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="82I3+IH0IqGh5yIs"
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1002051238280.4050@localhost.localdomain>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: Jeff Garrett <jeff@jgarrett.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--82I3+IH0IqGh5yIs
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Feb 05, 2010 at 12:45:21PM -0500, Len Brown wrote:
> Jeff,
> What do you see if you apply just the patch below?
> 
> Also, in addition to "powertop -d" to show what the kernel requests,
> please run turbostat to show what the hardware actually did:
> 
> http://userweb.kernel.org/~lenb/acpi/utils/pmtools-latest/turbostat/turbostat.c
> 
> eg.
> # turbostat -d -v sleep 5
> 
> thanks,
> -Len Brown, Intel Open Source Technology Center

With the patch, powertop reports good C3 residency and wakeups
remain very low.  Seems to work.  :)

I attached the powertop & turbostat output with this patch.

However, this confuses me.  In a previous experiment in the
acpi_processor_setup_cpuidle() function, I replaced the pointer
to acpi_idle_enter_bm() with a pointer to
acpi_idle_enter_simple() even when bm_check is nonzero.  With
that, I was able to get into C3, but the wakeups ballooned.  But
the difference between what I did, and what you did, is the
difference between acpi_idle_enter_bm() with acpi_idle_bm_check()
returning zero and acpi_idle_enter_simple().  Those code paths
look almost identical.  The bm path calls acpi_unlazy_tlb(), and
doesn't appear to call the ACPI_FLUSH_CPU_CACHE(), and they call
sched_clock_idle_sleep_event() in different places.  I don't
understand why any of these differences would have had any
significant effect on wakeups.

I'm left wondering if it's a problem on my part.  I should repeat
that previous  experiment and see if there really is something
significantly different there.

BTW, getting a bit off topic, but since the two code paths are
almost identical, is there any reason not to unite them?
Something like the attached patch might work?

Thanks,
Jeff

--82I3+IH0IqGh5yIs
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="powertop.out"

PowerTOP 1.12   (C) 2007, 2008 Intel Corporation 

Collecting data for 15 seconds 


Cn	          Avg residency
C0 (cpu running)        ( 2.7%)
polling		  0.0ms ( 0.0%)
C1 mwait	  0.0ms ( 0.0%)
C2 mwait	  0.0ms ( 0.0%)
C3 mwait	151.8ms (97.3%)
P-states (frequencies)
Turbo Mode     0.0%
  2.67 Ghz     0.0%
  2.54 Ghz     0.0%
  2.40 Ghz     0.0%
  1.60 Ghz   100.0%
Wakeups-from-idle per second :  6.4	interval: 15.0s
no ACPI power usage estimate available
Top causes for wakeups:
  38.4% ( 11.2)   [extra timer interrupt]
  29.7% (  8.7)   [kernel scheduler] Load balancing tick
  11.2% (  3.3)   [kernel core] hrtimer_start (tick_sched_timer)
   7.1% (  2.1)   [Rescheduling interrupts] <kernel IPI>
   6.9% (  2.0)   [kernel core] add_timer_on (clocksource_watchdog)
   1.8% (  0.5)   events/3
   1.6% (  0.5)   [eth0] <interrupt>
   0.7% (  0.2)   [kernel core] __mod_timer (dev_watchdog)
   0.5% (  0.1)   [ata_piix, ata_piix] <interrupt>
   0.2% (  0.1)   [kernel core] __mod_timer (tcp_delack_timer)
   0.2% (  0.1)   sshd
   0.2% (  0.1)   [kernel core] enqueue_task_rt (sched_rt_period_timer)
   0.2% (  0.1)   expr
   0.2% (  0.1)   [kernel core] __mod_timer (cfq_idle_slice_timer)
   0.2% (  0.1)   [kernel core] queue_delayed_work (delayed_work_timer_fn)
   0.2% (  0.1)   [kernel core] __mod_timer (peer_check_expire)
   0.2% (  0.1)   [kernel core] __mod_timer (neigh_timer_handler)
   0.2% (  0.1)   [kernel core] __mod_timer (sync_supers_timer_fn)

Suggestion: Enable the CONFIG_USB_SUSPEND kernel configuration option.
This option will automatically disable UHCI USB when not in use, and may
save approximately 1 Watt of power.

Recent USB suspend statistics
Active  Device name

Recent audio activity statistics
Active  Device name

Recent SATA AHCI link activity statistics
Active	Partial	Slumber	Device name

--82I3+IH0IqGh5yIs
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="turbostat.out"

turbostat Jan-27, 2010 - Len Brown <lenb@kernel.org>
num_cpus 8
CPUID GenuineIntel 11 levels family:model:stepping 6:26:4
Nehalem multiplier 20, TSC frequency 2667 MHz
MSR_NEHALEM_PLATFORM_INFO: 0xc0000001400
Nehalem 4 cores active: 21 mult, max turbo frequency = 2800 MHz
Nehalem 3 cores active: 21 mult, max turbo frequency = 2800 MHz
Nehalem 2 cores active: 21 mult, max turbo frequency = 2800 MHz
Nehalem 1 core active: 22 mult, max turbo frequency = 2933 MHz
5.002349 sec
 CPU   GHz    TSC    %c0    %c1    %c3    %c6   %pc3   %pc6   %pc7 
   0   1.60   2.66   0.02   0.07   0.00  99.92   0.00   0.00   0.00
   1   1.60   2.66   0.01   0.02   0.00  99.97   0.00   0.00   0.00
   2   1.60   2.66   0.02   0.04   0.00  99.94   0.00   0.00   0.00
   3   1.60   2.66   0.09   0.13   0.00  99.78   0.00   0.00   0.00
   4   1.60   2.66   0.05   0.04   0.00  99.91   0.00   0.00   0.00
   5   1.60   2.66   0.01   0.02   0.00  99.97   0.00   0.00   0.00
   6   1.60   2.66   0.01   0.05   0.00  99.94   0.00   0.00   0.00
   7   1.59   2.66   0.05   0.16   0.00  99.79   0.00   0.00   0.00

--82I3+IH0IqGh5yIs
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=patch

diff --git a/drivers/acpi/processor_idle.c b/drivers/acpi/processor_idle.c
index 7c0441f..8c636de 100644
--- a/drivers/acpi/processor_idle.c
+++ b/drivers/acpi/processor_idle.c
@@ -849,73 +851,6 @@ static int acpi_idle_enter_c1(struct cpuidle_device *dev,
 	return idle_time;
 }
 
-/**
- * acpi_idle_enter_simple - enters an ACPI state without BM handling
- * @dev: the target CPU
- * @state: the state data
- */
-static int acpi_idle_enter_simple(struct cpuidle_device *dev,
-				  struct cpuidle_state *state)
-{
-	struct acpi_processor *pr;
-	struct acpi_processor_cx *cx = cpuidle_get_statedata(state);
-	ktime_t  kt1, kt2;
-	s64 idle_time;
-	s64 sleep_ticks = 0;
-
-	pr = __get_cpu_var(processors);
-
-	if (unlikely(!pr))
-		return 0;
-
-	if (acpi_idle_suspend)
-		return(acpi_idle_enter_c1(dev, state));
-
-	local_irq_disable();
-	current_thread_info()->status &= ~TS_POLLING;
-	/*
-	 * TS_POLLING-cleared state must be visible before we test
-	 * NEED_RESCHED:
-	 */
-	smp_mb();
-
-	if (unlikely(need_resched())) {
-		current_thread_info()->status |= TS_POLLING;
-		local_irq_enable();
-		return 0;
-	}
-
-	/*
-	 * Must be done before busmaster disable as we might need to
-	 * access HPET !
-	 */
-	lapic_timer_state_broadcast(pr, cx, 1);
-
-	if (cx->type == ACPI_STATE_C3)
-		ACPI_FLUSH_CPU_CACHE();
-
-	kt1 = ktime_get_real();
-	/* Tell the scheduler that we are going deep-idle: */
-	sched_clock_idle_sleep_event();
-	acpi_idle_do_entry(cx);
-	kt2 = ktime_get_real();
-	idle_time =  ktime_to_us(ktime_sub(kt2, kt1));
-
-	sleep_ticks = us_to_pm_timer_ticks(idle_time);
-
-	/* Tell the scheduler how much we idled: */
-	sched_clock_idle_wakeup_event(sleep_ticks*PM_TIMER_TICK_NS);
-
-	local_irq_enable();
-	current_thread_info()->status |= TS_POLLING;
-
-	cx->usage++;
-
-	lapic_timer_state_broadcast(pr, cx, 0);
-	cx->time += sleep_ticks;
-	return idle_time;
-}
-
 static int c3_cpu_count;
 static DEFINE_SPINLOCK(c3_lock);
 
@@ -944,7 +879,7 @@ static int acpi_idle_enter_bm(struct cpuidle_device *dev,
 	if (acpi_idle_suspend)
 		return(acpi_idle_enter_c1(dev, state));
 
-	if (acpi_idle_bm_check()) {
+	if (cx->type == ACPI_STATE_C3 && pr->flags.bm_check && acpi_idle_bm_check()) {
 		if (dev->safe_state) {
 			dev->last_state = dev->safe_state;
 			return dev->safe_state->enter(dev, dev->safe_state);
@@ -970,17 +905,24 @@ static int acpi_idle_enter_bm(struct cpuidle_device *dev,
 		return 0;
 	}
 
-	acpi_unlazy_tlb(smp_processor_id());
+	if (cx->type == ACPI_STATE_C3 && pr->flags.bm_check)
+		acpi_unlazy_tlb(smp_processor_id());
 
 	/* Tell the scheduler that we are going deep-idle: */
-	sched_clock_idle_sleep_event();
+	if (cx->type == ACPI_STATE_C3 && pr->flags.bm_check)
+		sched_clock_idle_sleep_event();
 	/*
 	 * Must be done before busmaster disable as we might need to
 	 * access HPET !
 	 */
 	lapic_timer_state_broadcast(pr, cx, 1);
 
+	if (cx->type == ACPI_STATE_C3 && !pr->flags.bm_check)
+		ACPI_FLUSH_CPU_CACHE();
+
 	kt1 = ktime_get_real();
+	if (cx->type != ACPI_STATE_C3 || !pr->flags.bm_check)
+		sched_clock_idle_sleep_event();
 	/*
 	 * disable bus master
 	 * bm_check implies we need ARB_DIS
@@ -991,21 +933,19 @@ static int acpi_idle_enter_bm(struct cpuidle_device *dev,
 	 * not set. In that case we cannot do much, we enter C3
 	 * without doing anything.
 	 */
-	if (pr->flags.bm_check && pr->flags.bm_control) {
+	if (cx->type == ACPI_STATE_C3 && pr->flags.bm_check && pr->flags.bm_control) {
 		spin_lock(&c3_lock);
 		c3_cpu_count++;
 		/* Disable bus master arbitration when all CPUs are in C3 */
 		if (c3_cpu_count == num_online_cpus())
 			acpi_write_bit_register(ACPI_BITREG_ARB_DISABLE, 1);
 		spin_unlock(&c3_lock);
-	} else if (!pr->flags.bm_check) {
-		ACPI_FLUSH_CPU_CACHE();
 	}
 
 	acpi_idle_do_entry(cx);
 
 	/* Re-enable bus master arbitration */
-	if (pr->flags.bm_check && pr->flags.bm_control) {
+	if (cx->type == ACPI_STATE_C3 && pr->flags.bm_check && pr->flags.bm_control) {
 		spin_lock(&c3_lock);
 		acpi_write_bit_register(ACPI_BITREG_ARB_DISABLE, 0);
 		c3_cpu_count--;
@@ -1095,7 +1035,7 @@ static int acpi_processor_setup_cpuidle(struct acpi_processor *pr)
 			case ACPI_STATE_C2:
 			state->flags |= CPUIDLE_FLAG_BALANCED;
 			state->flags |= CPUIDLE_FLAG_TIME_VALID;
-			state->enter = acpi_idle_enter_simple;
+			state->enter = acpi_idle_enter_bm;
 			dev->safe_state = state;
 			break;
 
@@ -1103,9 +1043,7 @@ static int acpi_processor_setup_cpuidle(struct acpi_processor *pr)
 			state->flags |= CPUIDLE_FLAG_DEEP;
 			state->flags |= CPUIDLE_FLAG_TIME_VALID;
 			state->flags |= CPUIDLE_FLAG_CHECK_BM;
-			state->enter = pr->flags.bm_check ?
-					acpi_idle_enter_bm :
-					acpi_idle_enter_simple;
+			state->enter = acpi_idle_enter_bm;
 			break;
 		}
 

--82I3+IH0IqGh5yIs--
