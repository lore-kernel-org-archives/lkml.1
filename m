Return-Path: <linux-kernel-owner+w=401wt.eu-S1753599AbZG1PFU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753599AbZG1PFU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jul 2009 11:05:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753304AbZG1PFT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Jul 2009 11:05:19 -0400
Received: from mail.windriver.com ([147.11.1.11]:64333 "EHLO mail.wrs.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752520AbZG1PFR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jul 2009 11:05:17 -0400
Message-ID: <4A6F139C.6070806@windriver.com>
Date: Tue, 28 Jul 2009 10:05:00 -0500
From: Jason Wessel <jason.wessel@windriver.com>
User-Agent: Thunderbird 2.0.0.22 (X11/20090608)
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Ingo Molnar <mingo@elte.hu>, lkml <linux-kernel@vger.kernel.org>,
       "Deng, Dongdong" <Dongdong.Deng@windriver.com>
Subject: Re: [PATCH] softlockup: fix problem with long kernel pauses from
 kgdb
References: <4A6E0825.3020604@windriver.com> <1248725893.6987.2055.camel@twins>
In-Reply-To: <1248725893.6987.2055.camel@twins>
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 28 Jul 2009 15:04:57.0640 (UTC) FILETIME=[C57D9A80:01CA0F94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra wrote:
> On Mon, 2009-07-27 at 15:03 -0500, Jason Wessel wrote:
>> The fix is to simply invoke sched_clock_tick() to update "cpu sched
>> clock" on exit from kgdb_handle_exception.
> 
> Is that a regular IRQ context, or is that NMI context?
> 
>> Signed-off-by: Dongdong Deng <Dongdong.Deng@windriver.com>
>> Signed-off-by: Jason Wessel <jason.wessel@windriver.com>
>> Cc: Ingo Molnar <mingo@elte.hu>
>> Cc: peterz@infradead.org
>> ---
>>  kernel/softlockup.c |    3 +++
>>  1 file changed, 3 insertions(+)
>>
>> --- a/kernel/softlockup.c
>> +++ b/kernel/softlockup.c
>> @@ -118,6 +118,9 @@ void softlockup_tick(void)
>>         }
>>  
>>         if (touch_timestamp == 0) {
>> +               /* If the time stamp was touched externally make sure the
>> +                * scheduler tick is up to date as well */
>> +               sched_clock_tick();
>>                 __touch_softlockup_watchdog();
>>                 return;
>>         }
>>
> 
> Aside from the funny comment style (please fix) the fix does look
> sensible.

It turns out that further testing of this patch shows a regression in
the ability to detect certain lockups.  It is a direct result of the
way the scheduling code makes use of the touch_softlockup_watchdog().
With the above proposed patch the tick was getting updated after a
resume, but was also getting updated with the run_timers(), and if
that happened before the softlockup tick, no softlockup would get
reported (note that I was using some test code to induce softlockups).

The patch below is a bit more invasive but solves the problem by
allowing kgdb to request that the sched cpu clock is updated only when
returning from a state where we know we need to force the update.

Would this change be an acceptable solution to allow kgdb to
peacefully exist with the softlockup code?

Thanks,
Jason.


-----
From: Jason Wessel <jason.wessel@windriver.com>
Subject: [PATCH] softlockup: add sched_clock_tick() to avoid kernel warning on kgdb resume

When CONFIG_HAVE_UNSTABLE_SCHED_CLOCK is set sched_clock() gets the
time from hardware, such as from TSC.  In this configuration kgdb will
report a softlock warning messages on resuming or detaching from a
debug session.

Sequence of events in the problem case:

1) "cpu sched clock" and "hardware time" are at 100 sec prior
   to a call to kgdb_handle_exception()

2) Debugger waits in kgdb_handle_exception() for 80 sec and on exit
   the following is called ...  touch_softlockup_watchdog() -->
   __raw_get_cpu_var(touch_timestamp) = 0;

3) "cpu sched clock" = 100s (it was not updated, because the interrupt
   was disabled in kgdb) but the "hardware time" = 180 sec

4) The first timer interrupt after resuming from kgdb_handle_exception
   updates the watchdog from the "cpu sched clock"

update_process_times() { ...  run_local_timers() --> softlockup_tick()
--> check (touch_timestamp == 0) (it is "YES" here, we have set
"touch_timestamp = 0" at kgdb) --> __touch_softlockup_watchdog()
***(A)--> reset "touch_timestamp" to "get_timestamp()" (Here, the
"touch_timestamp" will still be set to 100s.)  ...

    scheduler_tick() ***(B)--> sched_clock_tick() (update "cpu sched
    clock" to "hardware time" = 180s) ...  }

5) The Second timer interrupt handler appears to have a large jump and
   trips the softlockup warning.

update_process_times() { ...  run_local_timers() --> softlockup_tick()
--> "cpu sched clock" - "touch_timestamp" = 180s-100s > 60s --> printk
"soft lockup error messages" ...  }

note: ***(A) reset "touch_timestamp" to "get_timestamp(this_cpu)"

Why "touch_timestamp" is 100 sec, instead of 180 sec?

With the CONFIG_HAVE_UNSTABLE_SCHED_CLOCK" set the call trace of
get_timestamp() is:

get_timestamp(this_cpu) -->cpu_clock(this_cpu)
-->sched_clock_cpu(this_cpu) -->__update_sched_clock(sched_clock_data,
now)

The __update_sched_clock() function uses the GTOD tick value to create
a window to normalize the "now" values.  So if "now" values is too big
for sched_clock_data, it will be ignored.

The fix is to invoke sched_clock_tick() to update "cpu sched clock" in
order to recover from this state.  This is done by introducing the
function touch_softlockup_watchdog_sync(), which allows kgdb to
request that the sched clock is updated when the watchdog thread runs
the first time after a resume from kgdb.

Signed-off-by: Jason Wessel <jason.wessel@windriver.com>
Signed-off-by: Dongdong Deng <Dongdong.Deng@windriver.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: peterz@infradead.org

---
 include/linux/sched.h |    4 ++++
 kernel/kgdb.c         |    6 +++---
 kernel/softlockup.c   |   16 ++++++++++++++++
 3 files changed, 23 insertions(+), 3 deletions(-)

--- a/kernel/softlockup.c
+++ b/kernel/softlockup.c
@@ -79,6 +79,14 @@ void touch_softlockup_watchdog(void)
 }
 EXPORT_SYMBOL(touch_softlockup_watchdog);
 
+static int softlock_touch_sync[NR_CPUS];
+
+void touch_softlockup_watchdog_sync(void)
+{
+	softlock_touch_sync[raw_smp_processor_id()] = 1;
+	__raw_get_cpu_var(touch_timestamp) = 0;
+}
+
 void touch_all_softlockup_watchdogs(void)
 {
 	int cpu;
@@ -118,6 +126,14 @@ void softlockup_tick(void)
 	}
 
 	if (touch_timestamp == 0) {
+		if (unlikely(softlock_touch_sync[this_cpu])) {
+			/*
+			 * If the time stamp was touched atomically
+			 * make sure the scheduler tick is up to date.
+			 */
+			softlock_touch_sync[this_cpu] = 0;
+			sched_clock_tick();
+		}
 		__touch_softlockup_watchdog();
 		return;
 	}
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -300,6 +300,7 @@ extern void sched_show_task(struct task_
 #ifdef CONFIG_DETECT_SOFTLOCKUP
 extern void softlockup_tick(void);
 extern void touch_softlockup_watchdog(void);
+extern void touch_softlockup_watchdog_sync(void);
 extern void touch_all_softlockup_watchdogs(void);
 extern int proc_dosoftlockup_thresh(struct ctl_table *table, int write,
 				    struct file *filp, void __user *buffer,
@@ -313,6 +314,9 @@ static inline void softlockup_tick(void)
 static inline void touch_softlockup_watchdog(void)
 {
 }
+static inline void touch_softlockup_watchdog_sync(void)
+{
+}
 static inline void touch_all_softlockup_watchdogs(void)
 {
 }
--- a/kernel/kgdb.c
+++ b/kernel/kgdb.c
@@ -590,7 +590,7 @@ static void kgdb_wait(struct pt_regs *re
 
 	/* Signal the primary CPU that we are done: */
 	atomic_set(&cpu_in_kgdb[cpu], 0);
-	touch_softlockup_watchdog();
+	touch_softlockup_watchdog_sync();
 	clocksource_touch_watchdog();
 	local_irq_restore(flags);
 }
@@ -1433,7 +1433,7 @@ acquirelock:
 	    atomic_read(&kgdb_cpu_doing_single_step) != cpu) {
 
 		atomic_set(&kgdb_active, -1);
-		touch_softlockup_watchdog();
+		touch_softlockup_watchdog_sync();
 		clocksource_touch_watchdog();
 		local_irq_restore(flags);
 
@@ -1526,7 +1526,7 @@ acquirelock:
 kgdb_restore:
 	/* Free kgdb_active */
 	atomic_set(&kgdb_active, -1);
-	touch_softlockup_watchdog();
+	touch_softlockup_watchdog_sync();
 	clocksource_touch_watchdog();
 	local_irq_restore(flags);
 
