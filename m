Return-Path: <linux-kernel-owner+w=401wt.eu-S1755448AbYIYVmk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755448AbYIYVmk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2008 17:42:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753169AbYIYVm1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Sep 2008 17:42:27 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:42203 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753000AbYIYVm0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2008 17:42:26 -0400
Date: Thu, 25 Sep 2008 23:41:34 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Steven Rostedt <rostedt@goodmis.org>, Martin Bligh <mbligh@google.com>,
       Peter Zijlstra <peterz@infradead.org>, Martin Bligh <mbligh@mbligh.org>,
       linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>, prasad@linux.vnet.ibm.com,
       Mathieu Desnoyers <compudj@krystal.dyndns.org>,
       "Frank Ch. Eigler" <fche@redhat.com>, David Wilder <dwilder@us.ibm.com>,
       hch@lst.de, Tom Zanussi <zanussi@comcast.net>,
       Steven Rostedt <srostedt@redhat.com>
Subject: Re: [RFC PATCH 1/3] Unified trace buffer
Message-ID: <20080925214134.GA23025@elte.hu>
References: <33307c790809250825u567d3680w682899c111e10ed6@mail.gmail.com> <20080925153635.GA12840@elte.hu> <alpine.LFD.1.10.0809250924460.3265@nehalem.linux-foundation.org> <alpine.DEB.1.10.0809251247010.27920@gandalf.stny.rr.com> <alpine.LFD.1.10.0809251002290.3265@nehalem.linux-foundation.org> <20080925195522.GA22248@elte.hu> <20080925201211.GA1878@elte.hu> <alpine.LFD.1.10.0809251318270.3265@nehalem.linux-foundation.org> <alpine.LFD.1.10.0809251325450.3265@nehalem.linux-foundation.org> <20080925211017.GA12689@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080925211017.GA12689@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Ingo Molnar <mingo@elte.hu> wrote:

> * Linus Torvalds <torvalds@linux-foundation.org> wrote:
> 
> > On Thu, 25 Sep 2008, Linus Torvalds wrote:
> > > 
> > > You also ignore the early trace issues, and have apparently not used 
> > > it for FTRACE. You also ignore the fact that without TSC, it goes 
> > > into the same "crap mode" that is appropriate for the scheduler, but 
> > > totally useless for tracing.
> > 
> > Oh, and I didn't notice (because Steven pointed out "notrace" and I 
> > didn't see any of them), that in order to get things to work you had 
> > just added
> > 
> > CFLAGS_REMOVE_lockdep.o = -pg
> > CFLAGS_REMOVE_lockdep_proc.o = -pg
> > CFLAGS_REMOVE_mutex-debug.o = -pg
> > CFLAGS_REMOVE_rtmutex-debug.o = -pg
> > CFLAGS_REMOVE_cgroup-debug.o = -pg
> > CFLAGS_REMOVE_sched_clock.o = -pg
> > CFLAGS_REMOVE_sched.o = -mno-spe -pg
> > 
> > all ovr the place, which was part of my argument against this crap in 
> > the first place.
> 
> Really, we traced all these files for ages. I can restore it if it's 
> worthwile - but lockdep totally kills the usability of function 
> traces, it inserts thousands of uninteresting events over and over 
> again.

to prove it, i just applied this patch:

Index: linux/kernel/Makefile
===================================================================
--- linux.orig/kernel/Makefile
+++ linux/kernel/Makefile
@@ -21,7 +21,6 @@ CFLAGS_REMOVE_mutex-debug.o = -pg
 CFLAGS_REMOVE_rtmutex-debug.o = -pg
 CFLAGS_REMOVE_cgroup-debug.o = -pg
 CFLAGS_REMOVE_sched_clock.o = -pg
-CFLAGS_REMOVE_sched.o = -mno-spe -pg
 endif
 
 obj-$(CONFIG_PROFILING) += profile.o

and sched.o was fully traced again. For example schedule() to idle is 38 
function calls:

$ cd /debug/tracing
$ echo ftrace > current_tracer
$ cat trace

# tracer: ftrace
#
#           TASK-PID    CPU#    TIMESTAMP  FUNCTION
#              | |       |          |         |
[...]
             ssh-2734  [001]    52.291772: schedule <-schedule_timeout
             ssh-2734  [001]    52.291772: hrtick_clear <-schedule
             ssh-2734  [001]    52.291774: _spin_lock <-schedule
             ssh-2734  [001]    52.291775: deactivate_task <-schedule
             ssh-2734  [001]    52.291776: dequeue_task <-deactivate_task
             ssh-2734  [001]    52.291777: dequeue_task_fair <-dequeue_task
             ssh-2734  [001]    52.291778: update_curr <-dequeue_task_fair
             ssh-2734  [001]    52.291779: calc_delta_mine <-update_curr
             ssh-2734  [001]    52.291780: hrtick_start_fair <-dequeue_task_fair
             ssh-2734  [001]    52.291782: find_busiest_group <-schedule
             ssh-2734  [001]    52.291783: idle_cpu <-find_busiest_group
             ssh-2734  [001]    52.291784: target_load <-find_busiest_group
             ssh-2734  [001]    52.291785: weighted_cpuload <-target_load
             ssh-2734  [001]    52.291786: weighted_cpuload <-find_busiest_group
             ssh-2734  [001]    52.291787: cpu_avg_load_per_task <-find_busiest_group
             ssh-2734  [001]    52.291788: source_load <-find_busiest_group
             ssh-2734  [001]    52.291789: weighted_cpuload <-source_load
             ssh-2734  [001]    52.291790: weighted_cpuload <-find_busiest_group
             ssh-2734  [001]    52.291791: cpu_avg_load_per_task <-find_busiest_group
             ssh-2734  [001]    52.291792: msecs_to_jiffies <-schedule
             ssh-2734  [001]    52.291792: msecs_to_jiffies <-schedule
             ssh-2734  [001]    52.291793: put_prev_task_fair <-schedule
             ssh-2734  [001]    52.291795: pick_next_task_fair <-schedule
             ssh-2734  [001]    52.291796: pick_next_task_rt <-schedule
             ssh-2734  [001]    52.291796: pick_next_task_fair <-schedule
             ssh-2734  [001]    52.291797: pick_next_task_idle <-schedule
             ssh-2734  [001]    52.291798: _spin_trylock <-tracing_record_cmdline
             ssh-2734  [001]    52.291800: _spin_unlock <-tracing_record_cmdline
             ssh-2734  [001]    52.291802: __switch_to <-thread_return
          <idle>-0     [001]    52.291804: finish_task_switch <-thread_return
          <idle>-0     [001]    52.291805: _spin_unlock_irq <-finish_task_switch
          <idle>-0     [001]    52.291806: tick_nohz_stop_sched_tick <-cpu_idle
          <idle>-0     [001]    52.291807: ktime_get <-tick_nohz_stop_sched_tick
          <idle>-0     [001]    52.291807: ktime_get_ts <-ktime_get
          <idle>-0     [001]    52.291808: getnstimeofday <-ktime_get_ts
          <idle>-0     [001]    52.291808: acpi_pm_read <-getnstimeofday
          <idle>-0     [001]    52.291810: set_normalized_timespec <-ktime_get_ts
          <idle>-0     [001]    52.291811: get_next_timer_interrupt <-tick_nohz_stop_sched_tick

it worked just fine in my first blind attempt.

	Ingo
