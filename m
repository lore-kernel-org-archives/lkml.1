Return-Path: <linux-kernel-owner+w=401wt.eu-S1751727AbXDRAGg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751727AbXDRAGg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2007 20:06:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753011AbXDRAGg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Apr 2007 20:06:36 -0400
Received: from omta05ps.mx.bigpond.com ([144.140.83.195]:60073 "EHLO
	omta05ps.mx.bigpond.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751696AbXDRAGf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2007 20:06:35 -0400
Message-ID: <46256102.7030104@bigpond.net.au>
Date: Wed, 18 Apr 2007 10:06:26 +1000
From: Peter Williams <pwil3058@bigpond.net.au>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Willy Tarreau <w@1wt.eu>
CC: Gene Heskett <gene.heskett@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Con Kolivas <kernel@kolivas.org>, Nick Piggin <npiggin@suse.de>,
       Mike Galbraith <efault@gmx.de>, Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>, caglar@pardus.org.tr,
       Dmitry Adamushko <dmitry.adamushko@gmail.com>
Subject: Re: [patch] CFS (Completely Fair Scheduler), v2
References: <20070416220715.GA4071@elte.hu> <200704170053.58611.gene.heskett@gmail.com> <20070417052550.GA9491@1wt.eu>
In-Reply-To: <20070417052550.GA9491@1wt.eu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
X-Authentication-Info: Submitted using SMTP AUTH PLAIN at oaamta07ps.mx.bigpond.com from [58.164.138.40] using ID pwil3058@bigpond.net.au at Wed, 18 Apr 2007 00:06:31 +0000
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Willy Tarreau wrote:
> Hi Gene,
> 
> On Tue, Apr 17, 2007 at 12:53:56AM -0400, Gene Heskett wrote:
>> On Monday 16 April 2007, Ingo Molnar wrote:
>>> this is the second release of the CFS (Completely Fair Scheduler)
>>> patchset, against v2.6.21-rc7:
>>>
>>>   http://redhat.com/~mingo/cfs-scheduler/sched-cfs-v2.patch
>>>
>>> i'd like to thank everyone for the tremendous amount of feedback and
>>> testing the v1 patch got - i could hardly keep up with just reading the
>>> mails! Some of the stuff people addressed i couldnt implement yet, i
>>> mostly concentrated on bugs, regressions and debuggability.
>>>
>>> there's a fair amount of churn:
>>>
>>>   15 files changed, 456 insertions(+), 241 deletions(-)
>>>
>>> But it's an encouraging sign that there was no crash bug found in v1,
>>> all the bugs were related to scheduling-behavior details. The code was
>>> tested on 3 architectures so far: i686, x86_64 and ia64. Most of the
>>> code size increase in -v2 is due to debugging helpers, they'll be
>>> removed later. (The new /proc/sched_debug file can be used to see the
>>> fine details of CFS scheduling.)
>>>
>>> Changes since -v1:
>>>
>>> - make nice levels less starvable. (reported by Willy Tarreau)
>>>
>>> - fixed child-runs first. A /proc/sys/kernel/sched_child_runs_first
>>>   flag can be used to turn it on/off. (This might fix the Kaffeine bug
>>>   reported by S.Ça??lar Onur <)
>>>
>>> - changed SCHED_FAIR back to SCHED_NORMAL (suggested by Con Kolivas)
>>>
>>> - UP build fix. (reported by Gabriel C)
>>>
>>> - timer tick micro-optimization (Dmitry Adamushko)
>>>
>>> - preemption fix: sched_class->check_preempt_curr method to decide
>>>   whether to preempt after a wakeup (or at a timer tick). (Found via a
>>>   fairness-test-utility written for CFS by Mike Galbraith)
>>>
>>> - start forked children with neutral statistics instead of trying to
>>>   inherit them from the parent: Willy Tarreau reported that this
>>>   results in better behavior on extreme workloads, and it also
>>>   simplifies the code quite nicely. Removed sched_exit() and the
>>>   ->task_exit() methods.
>>>
>>> - make nice levels independent of the sched_granularity value
>>>
>>> - new /proc/sched_debug file listing runqueue details and the rbtree
>>>
>>> - new SCH-* fields in /proc/<NR>/status to see scheduling details
>>>
>>> - new cpu-hog feature (off by default) and sysctl tunable to set it:
>>>   /proc/sys/kernel/sched_max_hog_history_ns tunable defaults to
>>>   0 (off). Positive values are meant the maximum 'memory' that the
>>>   scheduler has of CPU hogs.
>>>
>>> - various code cleanups
>>>
>>> - added more statistics temporarily: sum_exec_runtime,
>>>   sum_wait_runtime.
>>>
>>> - added -CFS-v2 to EXTRAVERSION
>>>
>>> as usual, any sort of feedback, bugreports, fixes and suggestions are
>>> more than welcome,
>>>
>>> 	Ingo
>> This one (v2-rc2) is not a keeper I'm sorry to say, Ingo.  v2-rc0 was much 
>> better.  Watching amanda run with htop, kmails composer is being subjected to 
>> 5 to 10 second pauses, and htop says that gzip -best isn't getting more that 
>> 15% of the cpu, and the /amandatapes drive is being written to in a regular 
>> pattern that seems to be the cause of the pauses  according to gkrellm, which 
>> also seems to track the size of the writes, and can show anything from 4.3k 
>> to 54 megs as being written in one cycle of its screen update.
> 
> Have you tried previous version with the fair-fork patch ? It might be possible
> that your workload is sensible to the fork()'s child getting much CPU upon
> startup.
> 
> Ingo, maybe I'm saying something stupid, but in my userland scheduler, when
> new tasks are "forked", they are queued at the end of the run queue with a
> fixed priority. In our case, this would translate into assigning them the
> same prio and timeslice as their parent, but queuing them at the end so that
> they don't make existing tasks starve during huge fork() loads.
> 
> I don't know how that would be possible (nor if that would help in anything),
> but I found it was a good compromise over sharing the timeslice with the
> parent. Perhaps we should have some absolute timeslice and some relative
> timeslice (eg: X percent of total time divided by the number of tasks) ?

One way of handling forked tasks is to give them a high priority but a 
small chunk (i.e. give them a relatively short time to do some work and 
surrender the CPU voluntarily before you boot them off).  If you choose 
the size of this reduced chunk well the vast majority of tasks will 
never be booted off and will do a small bit of work and either exit or 
sleep and will suffer no penalty as a result of this mechanism.  But it 
gives you a chance to move any newly forked process that turns out to be 
a CPU hog to a lower priority before it gets its next chunk of CPU at 
which time it can revert to getting normal size chunks as pre-emption 
will stop it hogging the CPU from then on.

I've trialled this mechanism in some of my schedulers and it works well.

I found that 10 milliseconds was a good value for the initial chunk of 
CPU for a newly forked process.

Peter
-- 
Peter Williams                                   pwil3058@bigpond.net.au

"Learning, n. The kind of ignorance distinguishing the studious."
  -- Ambrose Bierce
