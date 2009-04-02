Return-Path: <linux-kernel-owner+w=401wt.eu-S1759557AbZDBLsB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759557AbZDBLsB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Apr 2009 07:48:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755502AbZDBLrT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Apr 2009 07:47:19 -0400
Received: from viefep15-int.chello.at ([62.179.121.35]:46009 "EHLO
	viefep15-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758325AbZDBLrS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Apr 2009 07:47:18 -0400
X-SourceIP: 213.93.53.227
Subject: Re: [PATCH 2/6] RFC perf_counter: singleshot support
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>,
       Corey Ashford <cjashfor@linux.vnet.ibm.com>,
       linux-kernel@vger.kernel.org
In-Reply-To: <20090402105151.GB10828@elte.hu>
References: <20090402091158.291810516@chello.nl>
	 <20090402091319.257773792@chello.nl>  <20090402105151.GB10828@elte.hu>
Content-Type: text/plain
Date: Thu, 02 Apr 2009 13:48:13 +0200
Message-Id: <1238672893.8530.5909.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-04-02 at 12:51 +0200, Ingo Molnar wrote:
> * Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> 
> > By request, provide a way for counters to disable themselves and 
> > signal at the first counter overflow.
> > 
> > This isn't complete, we really want pending work to be done ASAP 
> > after queueing it. My preferred method would be a self-IPI, that 
> > would ensure we run the code in a usable context right after the 
> > current (IRQ-off, NMI) context is done.
> 
> Hm. I do think self-IPIs can be fragile but the more work we do in 
> NMI context the more compelling of a case can be made for a 
> self-IPI. So no big arguments against that.

Its not only NMI, but also things like software events in the scheduler
under rq->lock, or hrtimers in irq context. You cannot do a wakeup from
under rq->lock, nor hrtimer_cancel() from within the timer handler.

All these nasty little issues stack up and could be solved with a
self-IPI.


Then there is the software task-time clock which uses
p->se.sum_exec_runtime which requires the rq->lock to be read. Coupling
this with for example an NMI overflow handler gives an instant deadlock.

Would you terribly mind if I remove all that sum_exec_runtime and
rq->lock stuff and simply use cpu_clock() to keep count. These things
get context switched along with tasks anyway.



> So i think we need 3 separate things:
> 
>  - the ability to set a signal attribute of the counter (during 
>    creation) via a (signo,tid) pair. 
> 
>    Semantics:
> 
>     - it can be a regular signal (signo < 32),
>       or an RT/queued signal (signo >= 32).
> 
>     - It may be sent to the task that generated the event (tid == 0), 
>       or it may be sent to a specific task (tid > 0),
>       or it may be sent to a task group (tid < 0).

kill_pid() seems to be able to do all of that:

        struct pid *pid;
        int tid, priv;

        perf_counter_disable(counter);

        rcu_read_lock();
        tid = counter->hw_event.signal_tid;
        if (!tid)
                tid = current->pid;
        priv = 1;
        if (tid < 0) {
                priv = 0;
                tid = -tid;
        }
        pid = find_vpid(tid);
        if (pid)
                kill_pid(pid, counter->hw_event.signal_nr, priv);
        rcu_read_unlock();

Should do I afaict.

Except I probably should look into this pid-namespace mess and clean all
that up.

>  - 'event limit' attribute: the ability to pause new events after N 
>    events. This limit auto-decrements on each event.
>    limit==1 is the special case for single-shot.

That should go along with a toggle on what an event is I suppose, either
an 'output' event or a filled page?

Or do we want to limit that to counter overflow?

>  - new ioctl method to refill the limit, when user-space is ready to 
>    receive new events. A special-case of this is when a signal 
>    handler calls ioctl(refill_limit, 1) in the single-shot case - 
>    this re-enables events after the signal has been handled.

Right, with the method implemented above, its simply a matter of the
enable ioctl.

> Another observation: i think perf_counter_output() needs to depend 
> on whether the counter is signalling, not on the single-shot-ness of 
> the counter.
> 
> A completely valid use of this would be for user-space to create an 
> mmap() buffer of 1024 events, then set the limit to 1024, and wait 
> for the 1024 events to happen - process them and close the counter. 
> Without any signalling.

Say we have a limit > 1, and a signal, that would mean we do not
generate event output?



