Return-Path: <linux-kernel-owner+w=401wt.eu-S1758369AbXEMLMT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758369AbXEMLMT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 May 2007 07:12:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755628AbXEMLML
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 May 2007 07:12:11 -0400
Received: from e1.ny.us.ibm.com ([32.97.182.141]:54723 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754561AbXEMLMJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 May 2007 07:12:09 -0400
Date: Sun, 13 May 2007 14:03:57 +0530
From: Gautham R Shenoy <ego@in.ibm.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Pavel Machek <pavel@ucw.cz>,
       Oleg Nesterov <oleg@tv-sign.ru>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Dipankar Sarma <dipankar@in.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       Srivatsa Vaddagiri <vatsa@in.ibm.com>,
       Paul E McKenney <paulmck@us.ibm.com>
Subject: Re: [RFD] Freezing of kernel threads
Message-ID: <20070513083357.GA12985@in.ibm.com>
Reply-To: ego@in.ibm.com
References: <200705122017.32792.rjw@sisk.pl> <20070512193609.GA31426@in.ibm.com> <alpine.LFD.0.98.0705121241300.3986@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.0.98.0705121241300.3986@woody.linux-foundation.org>
User-Agent: Mutt/1.5.12-2006-07-14
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus, 

I apologise for citing 'for_each_online_cpu()' as the reason, when
I actually was thinking about 'online_cpu_map'. That only proves 
that I should not reply to stuff when I am sleepy!

Anyway, coming back to the freezer cpu hotplug part, cpu-hotplug locking
has been broken for almost a year now. Primarily because of it's global
locking scheme, which is fairly easy to break.

Freezer was considered as a solution only recently.
Freezer was the last resort, not the first one.

I have already posted three RFC's to fix the cpu-hotplug locking
problem earlier and none of them used freezer :-) And I remember
cc'ing you on all these mails.  

So to answer your question, why the do synchronization
primitives don't work, here's a gist of what we tried before
resorting to freezer, just incase you missed out. I am sorry for
writing such a long e-mail. But if the problem were so simple,
it would (or should) have been solved by now.

RFC #1: Use get_hot_cpus()- put_hot_cpus() , which follow the
well known refcounting model. I believe this is the most
natural solution to this problem, since we do not want to 
lock cpus. We want to keep a reference to them so that they don't
come/go away while we are in some per-cpu-critical section.

So a cpu-hotplug aware function can it as follows:

foo ()
{
	get_hot_cpus();
	some_data = function_of(cpu_online_map);

	/* We will some_data here. So we prefer that 
	 * cpu's don't come up and go down while we are
	 * operating in this section. And yeah, we might
	 * also sleep!
	 */

	put_hot_cpus();
}

There are only 2 simple rules:

* In get_hot_cpus(), we check if a cpu-hotplug operation is 
  underway, in which case we sleep. Otherwise, we bump up the 
  refcount and return.

* A cpu-hotplug operation cannot proceed until the refcount
  is/goes to zero.

RFC #2: A Scalable version of the above which eliminated any barriers, 
atomic instructions on the get_hot_cpus fastpath.
Too bad, this one did not get any review at all. Bad timing? Maybe.

RFC #3: Per subsystem mutexes. Let each cpu-hotplug aware subsystem
maintain it's own hot_cpu_mutex to protect it's cpu-hotplug critical
data. Something like

foo ()
{
	mutex_lock(&my_hot_cpu_mutex);
	some_data = function_of(cpu_online_map);

	/* We use some_data here. So we prefer that 
	 * cpu's don't come up and go down while we are
	 * operating in this section. And yeah, we might
	 * also sleep!
	 */

	mutex_unlock(&my_hot_cpu_mutex);
}

my_hotplug_cpu_callback(int cpu, int event)
{
	switch(event) {
		case CPU_LOCK_ACQUIRE:
			/*
			 * We are about to begin a cpu-hotplug operation.
			 * so make sure that code like foo, doesn't run while
			 * we do this.
			 */
			mutex_lock(&my_hot_cpu_mutex);

		case CPU_DOWN_PREPARE:

		case CPU_DOWN_FAILED:

		case CPU_DEAD:

		case CPU_LOCK_RELEASE:
			/* 
			 * Cpu hotplug is done. Release
			 * mutex so that foo can run
			 */

			 mutex_unlock(&my_hot_cpu_mutex);
	}
}

and 

cpu_down(int cpu)
{
	/* send notifications for CPU_LOCK_ACQUIRE */
	notifier_blocking_chain(cpu, CPU_LOCK_ACQUIRE);

	/* 
	 * None of the cpu hotplug aware subsystems are running in
	 * critical section. So we are safe to perform a cpu-hotplug
	 * operation. So lets do it here.
	 */

	/* send notifications for CPU_LOCK_ACQUIRE */
	notifier_blocking_chain(cpu, CPU_LOCK_RELEASE);
	
}

This is the commit 6f7cc11aa6c7d5002e16096c7590944daece70ed which you
were referring to in one of your previous mails.

So why won't any of these work???

RFC #3, though is nice and transactional doesn't work because foo() 
can be called from cpu-hotplug call back path 
(i.e, from a subsystem's CPU_DOWN_PREPARE / CPU_DEAD/ CPU_UP_PREPARE/
 CPU_ONLINE call path.)

This will definitely result in a deadlock, since we would have
already acquired the my_hot_cpu_mutex in CPU_LOCK_ACQUIRE.

The case in point being the preempt rcu implementation of
synchronize_sched(), which has to call sched_setaffinity(), which
acquires sched_hotcpu_mutex.

Now consider update_sched_domains() which is a cpu-hotplug callback function.
CPU_LOCK_ACQUIRE:
|	|-> mutex_lock(&sched_hotcpu_mutex);
|
CPU_DOWN_PREPARE: 
|--> update_sched_domains()
	|--> detach_destroy_domains()
		|--> synchronize_sched()
			|--> sched_setaffinity() 
				|-> mutex_lock(&sched_hotcpu_mutex);

A deadlock! 

Ofcourse, we can do

__sched_schedaffinity()
{
	/* Acquire sched_hotcpu_mutex before calling this */
}

sched_setaffinity()
{
	mutex_lock(&sched_hotcpu_mutex);
	__sched_setaffinity();
	mutex_unlock(&sched_hotcpu_mutex);
}

However, now the caller (say update_sched_domains) has to wonder, 
if he has to call the callpath with locked function, or the raw one.

I am pretty confident as the code evolves, we will encounter more such
dependencies leading to deadlocks. So should we go for two variants of
the same function, one locked or one lockless?? I personally feel that
this approach will only uglyfy the code.
Probably a matter of taste, something which I guess I am yet to 
acquire. So I won't argue more.

RFC #1 and #2 DO work. But, the discussions in the thread
http://lkml.org/lkml/2007/1/26/282 gave me the impression
that we would be better off without any code audits to
make the code paths cpu-hotplug safe. I would leave it for others
to shed more light here.

So it is not that we cannot do cpu-hotplug without freezer. 
We have done it in the past and we definitely can do it in 
the future as well. 
But many believe, by using freezer for cpu hotplug,
a) stupid people will have to try really hard to break cpu-hotplug.
b) We can avoid a lot many ugly and redundant checks in the code
   paths to ensure that a cpu is still there, or a new cpu has
   not come up. 
c) We can avoid locks to protect data in frequently accessed codepath
   from cpu hotplug, an operation which we do like once in a year or so. 

All this is ofcourse, with the assumption that the freezer is bug free
which at the moment it is not. That's why we are working on it.

And regarding stop_machine_run(), freezer is not a replacement for
it. No, freezer is just a replacement for lock_cpu_hotplug() or
whatever locking mechanism we are currently using to ensure
that the whole code path from CPU_DOWN_PREPARE to 
CPU_DEAD / CPU_DOWN_FAILED (and corresponding CPU_* notifiers 
for cpu up) is atomic.

In _cpu_down(), we use stop_machine run() to
-> disable the interrupts on the cpu to be removed.
-> clear the cpu's bit from cpu_online_map
-> schedule a high priority SCHED_FIFO idle thread on the cpu to be
offlined so that we can fake cpu's death.

It clearly doesn't provide us any protection in sections like
CPU_DOWN_PREPARE/CPU_DEAD.

And yeah, we can make for_each_offline_cpu() take some mutex/lock
which will *hold* the hotplug operation. But, for_each_online_cpu()
is not the only place where we reference the cpu_online map. 
There are zillion other places. We need a better scheme to address 
all of them.

If you have come down to this point, I hope you have understood why
we went the freezer way. If you still feel that we can solve it using
a simpler, cleaner better method, I am all for it. 

Why, even I would like to see this problem fixed, as much as you do, 
if not more :-)

Thanks and Regards
gautham.
-- 
Gautham R Shenoy
Linux Technology Center
IBM India.
"Freedom comes with a price tag of responsibility, which is still a bargain,
because Freedom is priceless!"
