Return-Path: <linux-kernel-owner+w=401wt.eu-S1756993AbZKKIJW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756993AbZKKIJW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Nov 2009 03:09:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756810AbZKKIJW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Nov 2009 03:09:22 -0500
Received: from hera.kernel.org ([140.211.167.34]:44833 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756761AbZKKIJV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Nov 2009 03:09:21 -0500
Message-ID: <4AFA70FB.60706@kernel.org>
Date: Wed, 11 Nov 2009 17:08:27 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: "Rafael J. Wysocki" <rjw@sisk.pl>, Thomas Gleixner <tglx@linutronix.de>,
       Mike Galbraith <efault@gmx.de>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>, Greg KH <gregkh@suse.de>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Oleg Nesterov <oleg@redhat.com>
Subject: Re: GPF in run_workqueue()/list_del_init(cwq->worklist.next) on resume
References: <200911091250.31626.rjw@sisk.pl> <200911092145.27485.rjw@sisk.pl> <alpine.LFD.2.01.0911091339290.31845@localhost.localdomain> <200911100119.38019.rjw@sisk.pl> <alpine.LFD.2.01.0911101343590.31845@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.01.0911101343590.31845@localhost.localdomain>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Linus Torvalds wrote:
> On Tue, 10 Nov 2009, Rafael J. Wysocki wrote:
> And the code really is pretty subtle. queue_delayed_work_on(), for 
> example, uses raw_smp_processor_id() to basically pick a target CPU for 
> the work ("whatever the CPU happens to be now"). But does that have to 
> match the CPU that the timeout will trigger on? I dunno.

It will queue on the cpu the timer callback runs, so delayed work will
follow timer which can be a little bit surprising at times, I suppose.

> I've walked through the code many times, but every time I end up
> forgetting all the subtleties a few days later.

A lot of those subtleties come from the fact struct work is not around
once the work function is invoked, so after that the workqueue code
doesn't have much to work with but the pointer value itself.

> The workqueue code is very fragile in many ways. I'm adding Oleg and Tejun 
> to the Cc, because Oleg is definitely one of the workqueue locking 
> masters, and Tejun has worked on it to make it way more robust, so they 
> may have ideas.

One thing that I can think of which might cause this early release is
self-requeueing works which assume that only one instance of the
function will be executed at any given time.  While preparing to bring
down a cpu, worker threads are unbound from the cpu.  After cpu is
brought down, the workqueue for that cpu is flushed.  This means that
any work which was running or on queue at the time of cpu down will
run on a different cpu.  So, let's assume there's a work function
which looks like the following,

void my_work_fn(struct work_struct *work)
{
	struct my_struct *me = container_of(work, something...);

	DO SOMETHING;

	if (--me->todo)
		schedule_work(work);
	else
		free(me);
}

Which will work perfectly as long as all cpus stay alive as the work
will be pinned on a single cpu and cwq guarantees that a single work
is never executed in parallel.  However, if a cpu is brought down
while my_work_fn() was doing SOMETHING and me->todo was above 1,
schedule_work() will schedule itself to a different cpu which will
happily execute the work in parallel.

As worker threads become unbound, they may bounce among different cpus
while executing and create more than two instances of parallel
execution of the work which can lead to freeings work which is still
on workqueue list with the above code but with different code just two
parallel executions should be able to achieve it.

Another related issue is the behavior flush_work() when a work ends up
scheduled on a different cpu.  flush_work() will only look at a single
cpu workqueue on each flush attempt and if the work is not on the cpu
or there but also running on other cpus, it won't do nothing about it.
So, it's not too difficult to write code where the caller incorrectly
assumes the work is done after flush_work() is finished while the work
actually ended up being scheduled on a different cpu.

One way to debug I can think of is to record work pointer -> function
mapping in a percpu ring buffer and when the bug occurs (can be
detected by matching the 6b poison pattern before dereferencing next
pointer) print out function pointer for the matching work pointer.
The async nature makes the problem very difficult to track down.  :-(

Thanks.

-- 
tejun
