Return-Path: <linux-kernel-owner+w=401wt.eu-S1759507AbZACCYT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759507AbZACCYT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jan 2009 21:24:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758672AbZACCYF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Jan 2009 21:24:05 -0500
Received: from kumera.dghda.com ([80.68.90.171]:47813 "EHLO kumera.dghda.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755528AbZACCYE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jan 2009 21:24:04 -0500
From: "Duane Griffin" <duaneg@dghda.com>
Date: Sat, 3 Jan 2009 02:23:58 +0000
To: Chris Adams <cmadams@hiwaay.net>
Cc: Linas Vepstas <linasvepstas@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: Bug: Status/Summary of slashdot leap-second crash on new years
	2008-2009
Message-ID: <20090103022358.GA2454@dastardly.home.dghda.com>
References: <3ae3aa420901021125n1153053fsdf2378e7d11abbc0@mail.gmail.com> <20090103002114.GA1538533@hiwaay.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090103002114.GA1538533@hiwaay.net>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 02, 2009 at 06:21:14PM -0600, Chris Adams wrote:
> Once upon a time, Linas Vepstas <linasvepstas@gmail.com> said:
> > Below follows a summary of the reported crashes. I'm ignoring the
> > zillions of "mine didn't crash" reports, or the "you're a paranoid
> > conspiracy theorist, its random chance" reports.
> 
> I have reproduced this and got a stack trace (this is with Fedora 8 and
> kernel kernel-2.6.26.6-49.fc8.x86_64):
> 
> #0  ktime_get_ts (ts=0xffffffff8158bb30) at include/asm/processor.h:691
> #1  0xffffffff8104c09a in ktime_get () at kernel/hrtimer.c:59
> #2  0xffffffff8102a39a in hrtick_start_fair (rq=0xffff810009013880, 
>     p=<value optimized out>) at kernel/sched.c:1064
> #3  0xffffffff8102decc in enqueue_task_fair (rq=0xffff810009013880, 
>     p=0xffff81003fb02d40, wakeup=1) at kernel/sched_fair.c:863
> #4  0xffffffff81029a08 in enqueue_task (rq=0xffffffff8158bb30, 
>     p=0xffff81003b8ac418, wakeup=-994836480) at kernel/sched.c:1550
> #5  0xffffffff81029a39 in activate_task (rq=0xffff810009013880, 
>     p=0xffff81003b8ac418, wakeup=20045) at kernel/sched.c:1614
> #6  0xffffffff8102be38 in try_to_wake_up (p=0xffff81003fb02d40, 
>     state=<value optimized out>, sync=0) at kernel/sched.c:2173
> #7  0xffffffff8102be9c in default_wake_function (curr=<value optimized out>, 
>     mode=998949912, sync=20045, key=0x4c4b40000) at kernel/sched.c:4366
> #8  0xffffffff810492ed in autoremove_wake_function (wait=0xffffffff8158bb30, 
>     mode=998949912, sync=20045, key=0x4c4b40000) at kernel/wait.c:132
> #9  0xffffffff810296a2 in __wake_up_common (q=0xffffffff813d3180, mode=1, 
>     nr_exclusive=1, sync=0, key=0x0) at kernel/sched.c:4387
> #10 0xffffffff8102b97b in __wake_up (q=0xffffffff813d3180, mode=1, 
>     nr_exclusive=1, key=0x0) at kernel/sched.c:4406
> #11 0xffffffff8103692f in wake_up_klogd () at kernel/printk.c:1005
> #12 0xffffffff81036abb in release_console_sem () at kernel/printk.c:1051
> #13 0xffffffff81036fd1 in vprintk (fmt=<value optimized out>, 
>     args=<value optimized out>) at kernel/printk.c:789
> #14 0xffffffff81037081 in printk (
>     fmt=0xffffffff8158bb30 "yj$\201????\2008\001\t") at kernel/printk.c:613
> #15 0xffffffff8104ec16 in ntp_leap_second (timer=<value optimized out>)
>     at kernel/time/ntp.c:143
> #16 0xffffffff8104b7a6 in run_hrtimer_pending (cpu_base=0xffff81000900f740)
>     at kernel/hrtimer.c:1204
> #17 0xffffffff8104b86a in run_hrtimer_softirq (h=<value optimized out>)
>     at kernel/hrtimer.c:1355
> #18 0xffffffff8103b31f in __do_softirq () at kernel/softirq.c:234
> #19 0xffffffff8100d52c in call_softirq () at include/asm/current_64.h:10
> #20 0xffffffff8100ed5e in do_softirq () at arch/x86/kernel/irq_64.c:262
> #21 0xffffffff8103b280 in irq_exit () at kernel/softirq.c:310
> #22 0xffffffff8101b0fe in smp_apic_timer_interrupt (regs=<value optimized out>)
>     at arch/x86/kernel/apic_64.c:514
> #23 0xffffffff8100cf52 in apic_timer_interrupt ()
>     at include/asm/current_64.h:10
> #24 0xffff81003b9d5a90 in ?? ()
> #25 0x0000000000000000 in ?? ()
> 
> 
> Basically (to my untrained eye), the leap second code is called from the
> timer interrupt handler, which holds xtime_lock.  The leap second code
> does a printk to notify about the leap second.  The printk code tries to
> wake up klogd (I assume to prioritize kernel messages), and (under some
> conditions), the scheduler attempts to get the current time, which tries
> to get xtime_lock => deadlock.
> 
> I can only reproduce this if the system is busy.  If the system is
> otherwise idle at the timer interrupt, I guess the scheduler doesn't try
> to get the time.  I can run a "find / | xargs cat > /dev/nul" in one
> window and then trigger the leap second in another, and the system dies
> most of the time.
> 
> I'm looking at the source for the RHEL 4 kernel 2.6.9-67.0.7.EL (which I
> had crash on a system), and the scheduler is enough different that I am
> not finding the path to the deadlock right off.
> 
> In any case, the quick-n-dirty fix would be to not try to printk while
> holding xtime_lock (I think the NTP code is the only thing that does).
> However, it would be nice to still get the leap second notification, so
> some other fix would be better I guess.

How about just moving the printk out of the lock? I.e. something like
this:

diff --git a/kernel/time/ntp.c b/kernel/time/ntp.c
index f5f793d..ad3e2b7 100644
--- a/kernel/time/ntp.c
+++ b/kernel/time/ntp.c
@@ -140,8 +140,6 @@ static enum hrtimer_restart ntp_leap_second(struct hrtimer *timer)
 		xtime.tv_sec--;
 		wall_to_monotonic.tv_sec++;
 		time_state = TIME_OOP;
-		printk(KERN_NOTICE "Clock: "
-		       "inserting leap second 23:59:60 UTC\n");
 		hrtimer_add_expires_ns(&leap_timer, NSEC_PER_SEC);
 		res = HRTIMER_RESTART;
 		break;
@@ -166,6 +164,10 @@ static enum hrtimer_restart ntp_leap_second(struct hrtimer *timer)
 
 	write_sequnlock(&xtime_lock);
 
+	if (res == HRTIMER_RESTART)
+		printk(KERN_NOTICE "Clock: "
+		       "inserting leap second 23:59:60 UTC\n");
+
 	return res;
 }
 

> -- 
> Chris Adams <cmadams@hiwaay.net>
> Systems and Network Administrator - HiWAAY Internet Services
> I don't speak for anybody but myself - that's enough trouble.

Cheers,
Duane.

-- 
"I never could learn to drink that blood and call it wine" - Bob Dylan
