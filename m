Return-Path: <linux-kernel-owner+w=401wt.eu-S1759208AbYBEAdZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759208AbYBEAdZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2008 19:33:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758718AbYBEAcz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Feb 2008 19:32:55 -0500
Received: from ithilien.qualcomm.com ([129.46.51.59]:51400 "EHLO
	ithilien.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757503AbYBEAcw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2008 19:32:52 -0500
Message-ID: <47A7AEA1.1090602@qualcomm.com>
Date: Mon, 04 Feb 2008 16:32:33 -0800
From: Max Krasnyanskiy <maxk@qualcomm.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Steven Rostedt <rostedt@goodmis.org>, Paul Jackson <pj@sgi.com>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Gregory Haskins <ghaskins@novell.com>
Subject: CPU isolation and workqueues [was Re: [CPUISOL] CPU isolation extensions]
References: <1201493382-29804-1-git-send-email-maxk@qualcomm.com>	 <1201511305.6149.30.camel@lappy> <20080128085910.7d38e9f5.pj@sgi.com>	 <20080128163450.GC12598@goodmis.org> <479E2305.3040408@qualcomm.com>	 <Pine.LNX.4.58.0801281358070.10419@gandalf.stny.rr.com> <1201551730.28547.54.camel@lappy>
In-Reply-To: <1201551730.28547.54.camel@lappy>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Peter Zijlstra wrote:
> On Mon, 2008-01-28 at 14:00 -0500, Steven Rostedt wrote:
>> On Mon, 28 Jan 2008, Max Krasnyanskiy wrote:
>>>>>   [PATCH] [CPUISOL] Support for workqueue isolation
>>>> The thing about workqueues is that they should only be woken on a CPU if
>>>> something on that CPU accessed them. IOW, the workqueue on a CPU handles
>>>> work that was called by something on that CPU. Which means that
>>>> something that high prio task did triggered a workqueue to do some work.
>>>> But this can also be triggered by interrupts, so by keeping interrupts
>>>> off the CPU no workqueue should be activated.
>>> No no no. That's what I though too ;-). The problem is that things like NFS and friends
>>> expect _all_ their workqueue threads to report back when they do certain things like
>>> flushing buffers and stuff. The reason I added this is because my machines were getting
>>> stuck because CPU0 was waiting for CPU1 to run NFS work queue threads even though no IRQs
>>> or other things are running on it.
>> This sounds more like we should fix NFS than add this for all workqueues.
>> Again, we want workqueues to run on the behalf of whatever is running on
>> that CPU, including those tasks that are running on an isolcpu.
> 
> agreed, by looking at my top output (and not the nfs code) it looks like
> it just spawns a configurable number of active kernel threads which are
> not cpu bound by in any way. I think just removing the isolated cpus
> from their runnable mask should take care of them.

Peter, Steven,

I think I convinced you guys last time but I did not have a convincing example. So here is some
more info on why workqueues need to be aware of isolated cpus.

Here is how a work queue gets flushed.
 
static int flush_cpu_workqueue(struct cpu_workqueue_struct *cwq)
{
        int active;

        if (cwq->thread == current) {
                /*
                 * Probably keventd trying to flush its own queue. So simply run
                 * it by hand rather than deadlocking.
                 */
                run_workqueue(cwq);
                active = 1;
        } else {
                struct wq_barrier barr;

                active = 0;
                spin_lock_irq(&cwq->lock);
                if (!list_empty(&cwq->worklist) || cwq->current_work != NULL) {
                        insert_wq_barrier(cwq, &barr, 1);
                        active = 1;
                }
                spin_unlock_irq(&cwq->lock);

                if (active)
                        wait_for_completion(&barr.done);
        }

        return active;
}

void fastcall flush_workqueue(struct workqueue_struct *wq)
{
        const cpumask_t *cpu_map = wq_cpu_map(wq);
        int cpu;

        might_sleep();
        lock_acquire(&wq->lockdep_map, 0, 0, 0, 2, _THIS_IP_);
        lock_release(&wq->lockdep_map, 1, _THIS_IP_);
        for_each_cpu_mask(cpu, *cpu_map)
                flush_cpu_workqueue(per_cpu_ptr(wq->cpu_wq, cpu));
}

In other words it schedules some work on each cpu and expects workqueue thread to run and 
trigger the completion. This is what I meant that _all_ threads are expected to report 
back even if there is nothing running on that CPU.

So my patch simply makes sure that isolated CPUs are ignored (if work queue isolation is enabled)
that work queue threads are not started on isolated in the CPUs that are isolated.

Max
