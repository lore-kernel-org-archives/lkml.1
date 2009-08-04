Return-Path: <linux-kernel-owner+w=401wt.eu-S1755475AbZHDOQf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755475AbZHDOQf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Aug 2009 10:16:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755436AbZHDOQe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Aug 2009 10:16:34 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:58572 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755433AbZHDOQd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Aug 2009 10:16:33 -0400
Date: Tue, 4 Aug 2009 16:16:23 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jason Wessel <jason.wessel@windriver.com>,
       Thomas Gleixner <tglx@linutronix.de>
Cc: Peter Zijlstra <peterz@infradead.org>, lkml <linux-kernel@vger.kernel.org>,
       "Deng, Dongdong" <Dongdong.Deng@windriver.com>
Subject: Re: [PATCH] softlockup: fix problem with long kernel pauses from
	kgdb
Message-ID: <20090804141623.GD7746@elte.hu>
References: <4A6E0825.3020604@windriver.com> <1248725893.6987.2055.camel@twins> <4A6F139C.6070806@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A6F139C.6070806@windriver.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Jason Wessel <jason.wessel@windriver.com> wrote:

> Peter Zijlstra wrote:
> > On Mon, 2009-07-27 at 15:03 -0500, Jason Wessel wrote:
> >> The fix is to simply invoke sched_clock_tick() to update "cpu sched
> >> clock" on exit from kgdb_handle_exception.
> > 
> > Is that a regular IRQ context, or is that NMI context?
> > 
> >> Signed-off-by: Dongdong Deng <Dongdong.Deng@windriver.com>
> >> Signed-off-by: Jason Wessel <jason.wessel@windriver.com>
> >> Cc: Ingo Molnar <mingo@elte.hu>
> >> Cc: peterz@infradead.org
> >> ---
> >>  kernel/softlockup.c |    3 +++
> >>  1 file changed, 3 insertions(+)
> >>
> >> --- a/kernel/softlockup.c
> >> +++ b/kernel/softlockup.c
> >> @@ -118,6 +118,9 @@ void softlockup_tick(void)
> >>         }
> >>  
> >>         if (touch_timestamp == 0) {
> >> +               /* If the time stamp was touched externally make sure the
> >> +                * scheduler tick is up to date as well */
> >> +               sched_clock_tick();
> >>                 __touch_softlockup_watchdog();
> >>                 return;
> >>         }
> >>
> > 
> > Aside from the funny comment style (please fix) the fix does look
> > sensible.
> 
> It turns out that further testing of this patch shows a regression in
> the ability to detect certain lockups.  It is a direct result of the
> way the scheduling code makes use of the touch_softlockup_watchdog().
> With the above proposed patch the tick was getting updated after a
> resume, but was also getting updated with the run_timers(), and if
> that happened before the softlockup tick, no softlockup would get
> reported (note that I was using some test code to induce softlockups).
> 
> The patch below is a bit more invasive but solves the problem by
> allowing kgdb to request that the sched cpu clock is updated only when
> returning from a state where we know we need to force the update.
> 
> Would this change be an acceptable solution to allow kgdb to
> peacefully exist with the softlockup code?
> 
> Thanks,
> Jason.
> 
> 
> -----
> From: Jason Wessel <jason.wessel@windriver.com>
> Subject: [PATCH] softlockup: add sched_clock_tick() to avoid kernel warning on kgdb resume
> 
> When CONFIG_HAVE_UNSTABLE_SCHED_CLOCK is set sched_clock() gets the
> time from hardware, such as from TSC.  In this configuration kgdb will
> report a softlock warning messages on resuming or detaching from a
> debug session.
> 
> Sequence of events in the problem case:
> 
> 1) "cpu sched clock" and "hardware time" are at 100 sec prior
>    to a call to kgdb_handle_exception()
> 
> 2) Debugger waits in kgdb_handle_exception() for 80 sec and on exit
>    the following is called ...  touch_softlockup_watchdog() -->
>    __raw_get_cpu_var(touch_timestamp) = 0;
> 
> 3) "cpu sched clock" = 100s (it was not updated, because the interrupt
>    was disabled in kgdb) but the "hardware time" = 180 sec
> 
> 4) The first timer interrupt after resuming from kgdb_handle_exception
>    updates the watchdog from the "cpu sched clock"
> 
> update_process_times() { ...  run_local_timers() --> softlockup_tick()
> --> check (touch_timestamp == 0) (it is "YES" here, we have set
> "touch_timestamp = 0" at kgdb) --> __touch_softlockup_watchdog()
> ***(A)--> reset "touch_timestamp" to "get_timestamp()" (Here, the
> "touch_timestamp" will still be set to 100s.)  ...
> 
>     scheduler_tick() ***(B)--> sched_clock_tick() (update "cpu sched
>     clock" to "hardware time" = 180s) ...  }
> 
> 5) The Second timer interrupt handler appears to have a large jump and
>    trips the softlockup warning.
> 
> update_process_times() { ...  run_local_timers() --> softlockup_tick()
> --> "cpu sched clock" - "touch_timestamp" = 180s-100s > 60s --> printk
> "soft lockup error messages" ...  }
> 
> note: ***(A) reset "touch_timestamp" to "get_timestamp(this_cpu)"
> 
> Why "touch_timestamp" is 100 sec, instead of 180 sec?
> 
> With the CONFIG_HAVE_UNSTABLE_SCHED_CLOCK" set the call trace of
> get_timestamp() is:
> 
> get_timestamp(this_cpu) -->cpu_clock(this_cpu)
> -->sched_clock_cpu(this_cpu) -->__update_sched_clock(sched_clock_data,
> now)
> 
> The __update_sched_clock() function uses the GTOD tick value to create
> a window to normalize the "now" values.  So if "now" values is too big
> for sched_clock_data, it will be ignored.
> 
> The fix is to invoke sched_clock_tick() to update "cpu sched clock" in
> order to recover from this state.  This is done by introducing the
> function touch_softlockup_watchdog_sync(), which allows kgdb to
> request that the sched clock is updated when the watchdog thread runs
> the first time after a resume from kgdb.
> 
> Signed-off-by: Jason Wessel <jason.wessel@windriver.com>
> Signed-off-by: Dongdong Deng <Dongdong.Deng@windriver.com>
> Cc: Ingo Molnar <mingo@elte.hu>
> Cc: peterz@infradead.org
> 
> ---
>  include/linux/sched.h |    4 ++++
>  kernel/kgdb.c         |    6 +++---
>  kernel/softlockup.c   |   16 ++++++++++++++++
>  3 files changed, 23 insertions(+), 3 deletions(-)
> 
> --- a/kernel/softlockup.c
> +++ b/kernel/softlockup.c
> @@ -79,6 +79,14 @@ void touch_softlockup_watchdog(void)
>  }
>  EXPORT_SYMBOL(touch_softlockup_watchdog);
>  
> +static int softlock_touch_sync[NR_CPUS];
> +
> +void touch_softlockup_watchdog_sync(void)
> +{
> +	softlock_touch_sync[raw_smp_processor_id()] = 1;
> +	__raw_get_cpu_var(touch_timestamp) = 0;
> +}
> +
>  void touch_all_softlockup_watchdogs(void)
>  {
>  	int cpu;
> @@ -118,6 +126,14 @@ void softlockup_tick(void)
>  	}
>  
>  	if (touch_timestamp == 0) {
> +		if (unlikely(softlock_touch_sync[this_cpu])) {
> +			/*
> +			 * If the time stamp was touched atomically
> +			 * make sure the scheduler tick is up to date.
> +			 */
> +			softlock_touch_sync[this_cpu] = 0;
> +			sched_clock_tick();
> +		}

Hm, this looks quite ugly. Peter, Thomas, can you think of a cleaner 
solution?

	Ingo
