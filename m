Return-Path: <linux-kernel-owner+w=401wt.eu-S1754572AbZG0UEW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754572AbZG0UEW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jul 2009 16:04:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754555AbZG0UEV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Jul 2009 16:04:21 -0400
Received: from mail.windriver.com ([147.11.1.11]:49944 "EHLO mail.wrs.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754553AbZG0UEV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jul 2009 16:04:21 -0400
Message-ID: <4A6E0825.3020604@windriver.com>
Date: Mon, 27 Jul 2009 15:03:49 -0500
From: Jason Wessel <jason.wessel@windriver.com>
User-Agent: Thunderbird 2.0.0.22 (X11/20090608)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: lkml <linux-kernel@vger.kernel.org>,
       "Deng, Dongdong" <Dongdong.Deng@windriver.com>, peterz@infradead.org
Subject: [PATCH] softlockup: fix problem with long kernel pauses from kgdb
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 27 Jul 2009 20:03:50.0932 (UTC) FILETIME=[5C270D40:01CA0EF5]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Ingo,

Given that you are the maintainer of kernel/softlockup.c, I am seeking
advice as to how to properly fix this problem.

The short version of the problem is:

  * CONFIG_HAVE_UNSTABLE_SCHED_CLOCK=y
  * Attach to kgdb after boot
  * Wait for 90 seconds
  * Execute a continue in gdb
  * You receive a warning about softlockup

The patch that follows is a lengthy analysis on the issue, but the
question here is what is the right way to fix this?

It seems that a provision is required in order to get the clock synced
up prior to touching the watch dog.  It was not clear that it was a
good idea to unconditionally call the sched_clock_tick() from the
softlockup touch code.

Your input on this issue is greatly appreciated.

Thanks,
Jason.

----------
From: "Dongdong Deng" <Dongdong.Deng@windriver.com>
Subject: [PATCH] softlockup: add sched_clock_tick() to avoid kernel warning on kgdb resume

When CONFIG_HAVE_UNSTABLE_SCHED_CLOCK is set and the sched_clock()
was gets the time from hardware, such as from TSC, kgdb often
causes softlock warning messages on resuming or detaching from
a debug session.

Sequence of events in the problem case:

1) "cpu sched clock" and "hardware time" are at 100 seconds prior
to a call to kgdb_handle_exception()

2) Debugger waits in kgdb_handle_exception() for 80 seconds and on
   exit the following is called
    ...
    touch_softlockup_watchdog()
       --> __raw_get_cpu_var(touch_timestamp) = 0;

3) "cpu sched clock" = 100s (it didn't be updated, because the
   interrupt was disabled in kgdb) but the "hardware time" = 180s

4) The first timer interrupt after resuming from kgdb_handle_exception
   updates the watchdog from the "cpu sched clock"

update_process_times()
{
    ...
    run_local_timers()
          --> softlockup_tick()
              --> check (touch_timestamp == 0)
                (it is "YES" here, we have set "touch_timestamp = 0"
                at kgdb)
                --> __touch_softlockup_watchdog()
              ***(A)--> reset "touch_timestamp" to "get_timestamp()"
                     (Here, the "touch_timestamp" will still be set to
                      100s.)
    ...

    scheduler_tick()
      ***(B)--> sched_clock_tick()
               (update "cpu sched clock" to "hardware time" = 180s)
    ...
}

5) The Second timer interrupt handler appears to have a large jump and
   trips the softlockup warning.

update_process_times()
{
    ...
    run_local_timers()
        --> softlockup_tick()
           --> "cpu sched clock" - "touch_timestamp" = 180s-100s > 60s
           --> printk "soft lockup error messages"
    ...
}

note:
***(A) reset "touch_timestamp" to "get_timestamp(this_cpu)"

Why "touch_timestamp" will be 100s, not 180s ?

We enable "CONFIG_HAVE_UNSTABLE_SCHED_CLOCK",
so the call trace of get_timestamp() is:

get_timestamp(this_cpu)
      -->cpu_clock(this_cpu)
         -->sched_clock_cpu(this_cpu)
            -->__update_sched_clock(sched_clock_data, now)

22 static u64 __update_sched_clock(struct sched_clock_data *scd, u64 =
now)
23 {
24    s64 delta = now - scd->tick_raw;
25    u64 clock, min_clock, max_clock;
26
27    WARN_ON_ONCE(!irqs_disabled());
28
29    if (unlikely(delta < 0))
30        delta = 0;
31
32    clock = scd->tick_gtod + delta;
33
34    min_clock = wrap_max(scd->tick_gtod, scd->clock);
35    max_clock = wrap_max(scd->clock, scd->tick_gtod + TICK_NSEC);
36
37    clock = wrap_max(clock, min_clock);
38    clock = wrap_min(clock, max_clock);
39
40    scd->clock = clock;
41
42    return scd->clock;
43 }

Please pay attention to __update_sched_clock() function, it uses the
GTOD tick value to create a window to filter crazy "now" values.  So
if "now" values is too big for sched_clock_data, it will be ignored.

as the data of "step 3)",
"now" = sched_clock() = "hardware time" = 180s and
sched_clock_data = 100s.
180s is too big for 100s, it will be ignored.

That's why the touch_timestamp will be set to 100s, not 180s.

The fix is to simply invoke sched_clock_tick() to update "cpu sched
clock" on exit from kgdb_handle_exception.

Signed-off-by: Dongdong Deng <Dongdong.Deng@windriver.com>
Signed-off-by: Jason Wessel <jason.wessel@windriver.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: peterz@infradead.org

---
 kernel/softlockup.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/kernel/softlockup.c
+++ b/kernel/softlockup.c
@@ -118,6 +118,9 @@ void softlockup_tick(void)
 	}
 
 	if (touch_timestamp == 0) {
+		/* If the time stamp was touched externally make sure the
+		 * scheduler tick is up to date as well */
+		sched_clock_tick();
 		__touch_softlockup_watchdog();
 		return;
 	}
