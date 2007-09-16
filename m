Return-Path: <linux-kernel-owner+w=401wt.eu-S1753125AbXIPJnR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753125AbXIPJnR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Sep 2007 05:43:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751547AbXIPJnG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Sep 2007 05:43:06 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:35720 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751293AbXIPJnE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Sep 2007 05:43:04 -0400
Date: Sun, 16 Sep 2007 02:41:59 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       Pavel Machek <pavel@ucw.cz>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Gabriel C <nix.or.die@googlemail.com>,
       linux1394-devel@lists.sourceforge.net,
       Ben Collins <ben.collins@ubuntu.com>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [1/3] 2.6.23-rc6: known regressions v2 --- ieee1394, empty
 suspend stopped working
Message-Id: <20070916024159.c067dc1a.akpm@linux-foundation.org>
In-Reply-To: <46ECF8C8.5040308@s5r6.in-berlin.de>
References: <46EB436E.6030509@googlemail.com>
	<46ECF8C8.5040308@s5r6.in-berlin.de>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 16 Sep 2007 11:35:04 +0200 Stefan Richter <stefanr@s5r6.in-berlin.de> wrote:

> Michal Piotrowski wrote:
> > FireWire
> 
> Could you title it "IEEE1394" instead?  (According to the information so
> far, it's in drivers/ieee1394, not drivers/firewire.)
> 
> > Subject         : empty suspend stopped working around 2.6.23-rc4
> > References      : http://lkml.org/lkml/2007/9/11/326
> > Last known good : ?
> > Submitter       : Pavel Machek <pavel@ucw.cz>
> > Caused-By       : ?
> > Handled-By      : ?
> > Status          : unknown
> 
> I did a quick test on my main test machine, a Mac mini running x86-64
> Linux.  Regardless whether swap is on or off and whether ieee1394 and
> ohci1394 are loaded or not, it always behaves the same.  It does
> something, then ends up with power LED off but a non-blinking cursor,
> i.e. _, still shown on the text console.  Is this good or bad?  Note, I
> didn't try to resume and won't, because I'm out of spare time.

When it is in this state, try hitting a key lots of times.  It Works For Me ;)

Try Thomas's hrt tree, below.  It Also Works For Me.


GIT f5ea61b91472bcc0782aa857fd4cf24db45ce732 git+ssh://master.kernel.org/pub/scm/linux/kernel/git/tglx/linux-2.6-hrt.git#for-2.6.23

commit f5ea61b91472bcc0782aa857fd4cf24db45ce732
Author: Thomas Gleixner <tglx@linutronix.de>
Date:   Sat Sep 15 11:45:13 2007 +0200

    clockevents: prevent stale tick update on offline cpu
    
    Taking a cpu offline removes the cpu from the online mask before the
    CPU_DEAD notification is done. The clock events layer does the cleanup
    of the dead CPU from the CPU_DEAD notifier chain. tick_do_timer_cpu is
    used to avoid xtime lock contention by assigning the task of jiffies
    xtime updates to one CPU. If a CPU is taken offline, then this
    assignment becomes stale. This went unnoticed because most of the time
    the offline CPU went dead before the online CPU reached __cpu_die(),
    where the CPU_DEAD state is checked. In the case that the offline CPU did
    not reach the DEAD state before we reach __cpu_die(), the code in there
    goes to sleep for 100ms. Due to the stale time update assignment, the
    system is stuck forever.
    
    Take the assignment away when a cpu is not longer in the cpu_online_mask.
    We do this in the last call to tick_nohz_stop_sched_tick() when the offline
    CPU is on the way to the final play_dead() idle entry.
    
    Signed-off-by: Thomas Gleixner <tglx@linutronix.de>

commit 259df5c5f73b39bea8e62baa6c85e7b0ee61dff3
Author: Thomas Gleixner <tglx@linutronix.de>
Date:   Sat Sep 15 11:45:13 2007 +0200

    clockevents: do not shutdown the oneshot broadcast device
    
    When a cpu goes offline it is removed from the broadcast masks. If the
    mask becomes empty the code shuts down the broadcast device. This is
    wrong, because the broadcast device needs to be ready for the online
    cpu going idle (into a c-state, which stops the local apic timer).
    
    Signed-off-by: Thomas Gleixner <tglx@linutronix.de>

commit 63ffda310fe82212aac2bb85a9105b87430995f7
Author: Thomas Gleixner <tglx@linutronix.de>
Date:   Sat Sep 15 11:45:13 2007 +0200

    clockevents: Enforce oneshot broadcast when broadcast mask is set on resume
    
    The jinxed VAIO refuses to resume without hitting keys on the keyboard
    when this is not enforced. It is unclear why the cpu ends up in a lower
    C State without notifying the clock events layer, but enforcing the
    oneshot broadcast here is safe.
    
    Signed-off-by: Thomas Gleixner <tglx@linutronix.de>

commit 112044df762a5e6e8946a3e5773312345f0154cf
Author: Thomas Gleixner <tglx@linutronix.de>
Date:   Sat Sep 15 11:45:13 2007 +0200

    ACPI: Reevaluate C/P/T states when a cpu becomes online
    
    Reevaluate C/P/T states when a cpu becomes online. This avoids
    the caching of the broadcast information in the clockevents layer.
    
    Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
    Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
    Cc: Len Brown <len.brown@intel.com>

commit e07fd18c03e3e8a03454074d46e052e622a0fdff
Author: Thomas Gleixner <tglx@linutronix.de>
Date:   Sat Sep 15 11:45:12 2007 +0200

    timekeeping: Prevent time going backwards on resume
    
    Timekeeping resume adjusts xtime by adding the slept time in seconds and
    resets the reference value of the clock source (clock->cycle_last).
    clock->cycle last is used to calculate the delta between the last xtime
    update and the readout of the clock source in __get_nsec_offset(). xtime
    plus the offset is the current time. The resume code ignores the delta
    which had already elapsed between the last xtime update and the actual
    time of suspend. If the suspend time is short, then we can see time
    going backwards on resume.
    
    Suspend:
    offs_s = clock->read() - clock->cycle_last;
    now = xtime + offs_s;
    timekeeping_suspend_time = read_rtc();
    
    Resume:
    sleep_time = read_rtc() - timekeeping_suspend_time;
    xtime.tv_sec += sleep_time;
    clock->cycle_last = clock->read();
    offs_r = clock->read() - clock->cycle_last;
    now = xtime + offs_r;
    
    if sleep_time_seconds == 0 and offs_r < offs_s, then time goes
    backwards.
    
    Fix this by storing the offset from the last xtime update and add it to
    xtime during resume, when we reset clock->cycle_last:
    
    sleep_time = read_rtc() - timekeeping_suspend_time;
    xtime.tv_sec += sleep_time;
    xtime += offs_s;	/* Fixup xtime offset at suspend time */
    clock->cycle_last = clock->read();
    offs_r = clock->read() - clock->cycle_last;
    now = xtime + offs_r;
    
    Thanks to Marcelo for tracking this down on the OLPC and providing the
    necessary details to analyze the root cause.
    
    Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
    Cc: John Stultz <johnstul@us.ibm.com>
    Cc: Tosatti <marcelo@kvack.org>

commit 1d4a40ed14684b198f873e16be1f84835afade9b
Author: Thomas Gleixner <tglx@linutronix.de>
Date:   Sat Sep 15 11:45:12 2007 +0200

    timekeeping: access rtc outside of xtime lock
    
    Lockdep complains about the access of rtc in timekeeping_suspend
    inside the interrupt disabled region of the write locked xtime lock.
    Move the access outside.
    
    Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
    Cc: John Stultz <johnstul@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/acpi/processor_core.c |   21 +++++++++++++++++++++
 kernel/time/tick-broadcast.c  |   24 ++++++++++++++++--------
 kernel/time/tick-sched.c      |   12 ++++++++++++
 kernel/time/timekeeping.c     |   10 +++++++++-
 4 files changed, 58 insertions(+), 9 deletions(-)

diff -puN drivers/acpi/processor_core.c~git-hrt drivers/acpi/processor_core.c
--- a/drivers/acpi/processor_core.c~git-hrt
+++ a/drivers/acpi/processor_core.c
@@ -725,6 +725,25 @@ static void acpi_processor_notify(acpi_h
 	return;
 }
 
+static int acpi_cpu_soft_notify(struct notifier_block *nfb,
+		unsigned long action, void *hcpu)
+{
+	unsigned int cpu = (unsigned long)hcpu;
+	struct acpi_processor *pr = processors[cpu];
+
+	if (action == CPU_ONLINE && pr) {
+		acpi_processor_ppc_has_changed(pr);
+		acpi_processor_cst_has_changed(pr);
+		acpi_processor_tstate_has_changed(pr);
+	}
+	return NOTIFY_OK;
+}
+
+static struct notifier_block acpi_cpu_notifier =
+{
+	    .notifier_call = acpi_cpu_soft_notify,
+};
+
 static int acpi_processor_add(struct acpi_device *device)
 {
 	struct acpi_processor *pr = NULL;
@@ -988,6 +1007,7 @@ void acpi_processor_install_hotplug_noti
 			    ACPI_UINT32_MAX,
 			    processor_walk_namespace_cb, &action, NULL);
 #endif
+	register_hotcpu_notifier(&acpi_cpu_notifier);
 }
 
 static
@@ -1000,6 +1020,7 @@ void acpi_processor_uninstall_hotplug_no
 			    ACPI_UINT32_MAX,
 			    processor_walk_namespace_cb, &action, NULL);
 #endif
+	unregister_hotcpu_notifier(&acpi_cpu_notifier);
 }
 
 /*
diff -puN kernel/time/tick-broadcast.c~git-hrt kernel/time/tick-broadcast.c
--- a/kernel/time/tick-broadcast.c~git-hrt
+++ a/kernel/time/tick-broadcast.c
@@ -382,12 +382,23 @@ static int tick_broadcast_set_event(ktim
 
 int tick_resume_broadcast_oneshot(struct clock_event_device *bc)
 {
+	int cpu = smp_processor_id();
+
+	/*
+	 * If the CPU is marked for broadcast, enforce oneshot
+	 * broadcast mode. The jinxed VAIO does not resume otherwise.
+	 * No idea why it ends up in a lower C State during resume
+	 * without notifying the clock events layer.
+	 */
+	if (cpu_isset(cpu, tick_broadcast_mask))
+		cpu_set(cpu, tick_broadcast_oneshot_mask);
+
 	clockevents_set_mode(bc, CLOCK_EVT_MODE_ONESHOT);
 
 	if(!cpus_empty(tick_broadcast_oneshot_mask))
 		tick_broadcast_set_event(ktime_get(), 1);
 
-	return cpu_isset(smp_processor_id(), tick_broadcast_oneshot_mask);
+	return cpu_isset(cpu, tick_broadcast_oneshot_mask);
 }
 
 /*
@@ -549,20 +560,17 @@ void tick_broadcast_switch_to_oneshot(vo
  */
 void tick_shutdown_broadcast_oneshot(unsigned int *cpup)
 {
-	struct clock_event_device *bc;
 	unsigned long flags;
 	unsigned int cpu = *cpup;
 
 	spin_lock_irqsave(&tick_broadcast_lock, flags);
 
-	bc = tick_broadcast_device.evtdev;
+	/*
+	 * Clear the broadcast mask flag for the dead cpu, but do not
+	 * stop the broadcast device!
+	 */
 	cpu_clear(cpu, tick_broadcast_oneshot_mask);
 
-	if (tick_broadcast_device.mode == TICKDEV_MODE_ONESHOT) {
-		if (bc && cpus_empty(tick_broadcast_oneshot_mask))
-			clockevents_set_mode(bc, CLOCK_EVT_MODE_SHUTDOWN);
-	}
-
 	spin_unlock_irqrestore(&tick_broadcast_lock, flags);
 }
 
diff -puN kernel/time/tick-sched.c~git-hrt kernel/time/tick-sched.c
--- a/kernel/time/tick-sched.c~git-hrt
+++ a/kernel/time/tick-sched.c
@@ -161,6 +161,18 @@ void tick_nohz_stop_sched_tick(void)
 	cpu = smp_processor_id();
 	ts = &per_cpu(tick_cpu_sched, cpu);
 
+	/*
+	 * If this cpu is offline and it is the one which updates
+	 * jiffies, then give up the assignment and let it be taken by
+	 * the cpu which runs the tick timer next. If we don't drop
+	 * this here the jiffies might be stale and do_timer() never
+	 * invoked.
+	 */
+	if (unlikely(!cpu_online(cpu))) {
+		if (cpu == tick_do_timer_cpu)
+			tick_do_timer_cpu = -1;
+	}
+
 	if (unlikely(ts->nohz_mode == NOHZ_MODE_INACTIVE))
 		goto end;
 
diff -puN kernel/time/timekeeping.c~git-hrt kernel/time/timekeeping.c
--- a/kernel/time/timekeeping.c~git-hrt
+++ a/kernel/time/timekeeping.c
@@ -217,6 +217,7 @@ static void change_clocksource(void)
 }
 #else
 static inline void change_clocksource(void) { }
+static inline s64 __get_nsec_offset(void) { return 0; }
 #endif
 
 /**
@@ -280,6 +281,8 @@ void __init timekeeping_init(void)
 static int timekeeping_suspended;
 /* time in seconds when suspend began */
 static unsigned long timekeeping_suspend_time;
+/* xtime offset when we went into suspend */
+static s64 timekeeping_suspend_nsecs;
 
 /**
  * timekeeping_resume - Resumes the generic timekeeping subsystem.
@@ -305,6 +308,8 @@ static int timekeeping_resume(struct sys
 		wall_to_monotonic.tv_sec -= sleep_length;
 		total_sleep_time += sleep_length;
 	}
+	/* Make sure that we have the correct xtime reference */
+	timespec_add_ns(&xtime, timekeeping_suspend_nsecs);
 	/* re-base the last cycle value */
 	clock->cycle_last = clocksource_read(clock);
 	clock->error = 0;
@@ -325,9 +330,12 @@ static int timekeeping_suspend(struct sy
 {
 	unsigned long flags;
 
+	timekeeping_suspend_time = read_persistent_clock();
+
 	write_seqlock_irqsave(&xtime_lock, flags);
+	/* Get the current xtime offset */
+	timekeeping_suspend_nsecs = __get_nsec_offset();
 	timekeeping_suspended = 1;
-	timekeeping_suspend_time = read_persistent_clock();
 	write_sequnlock_irqrestore(&xtime_lock, flags);
 
 	clockevents_notify(CLOCK_EVT_NOTIFY_SUSPEND, NULL);
_

