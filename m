Return-Path: <linux-kernel-owner+w=401wt.eu-S1752004AbZKPIgy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752004AbZKPIgy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Nov 2009 03:36:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751878AbZKPIgx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Nov 2009 03:36:53 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:44578 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751871AbZKPIgw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Nov 2009 03:36:52 -0500
Date: Mon, 16 Nov 2009 09:35:21 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Stijn Devriendt <highguy@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Mike Galbraith <efault@gmx.de>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Andrea Arcangeli <andrea@suse.de>, Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: peterz@infradead.org, linux-kernel@vger.kernel.org
Subject: [RFC] observe and act upon workload parallelism:
 PERF_TYPE_PARALLELISM (Was: [RFC][PATCH] sched_wait_block: wait for blocked
 threads)
Message-ID: <20091116083521.GC20672@elte.hu>
References: <1258311859-6189-1-git-send-email-HIGHGuY@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1258311859-6189-1-git-send-email-HIGHGuY@gmail.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.2.5
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


(Cc:-ed more interested parties)

* Stijn Devriendt <highguy@gmail.com> wrote:

> Hi Ingo, Peter, all,
> 
> The attached patch is a prototype for a new system call which allows 
> threads to wait for other threads being blocked.
> 
> Its main use is to allow threading libraries to resume executing more 
> CPU-bound work when one of its threads is blocked while not having to 
> over-allocating threads in a normal situation.
> 
> Benefit over asynchronous I/O is that a threadpool thread that 
> performs asynchronous I/O might not have work enough in one item to 
> keep the CPU busy during the whole asynchronous operation and that not 
> all operations are async capable. Giving control back to the library 
> through a thread waiting for the blocked one allows new workitems to 
> be executed as long as the former is blocked.
> 
> Code performing this wait could look like:
>   pid_t parent = ...;
>   while (waitpid(parent, NULL, WNOHANG) != 0)
>   {
>     if (sched_wait_block(parent, NULL) == 0)
> 		{
>       // do work, possibly notify threadpool manager
> 			// to start another thread blocked on this one
> 			// first
> 		}
>   }
> 
> Any feedback on the concept is much appreciated.

That is a ... rather interesting idea IMO.

Regarding the API and your patch, i think we can and should do something 
different and more capable - while still keeping your basic idea:

Lets turn it all around on its head and add the capability to user-space 
to observe the 'parallelism' of a workload (not limit it to the blocking 
of a single task) and allow the poll()ing of that quantity - without 
affecting workloads.

It should not be limited to a single task, and it should work with 
existing syscall APIs - i.e. be fd based.

Incidentally we already have a syscall and a kernel subsystem that is 
best suited to deal with such types of issues: perf events. I think we 
can create a new, special performance event type that observes 
task/workload (or CPU) parallelism:

	PERF_TYPE_PARALLELISM

With a 'parallelism_threshold' attribute. (which is '1' for a single 
task. See below.)

And then we can use poll() in the thread manager task to observe PIDs, 
workloads or full CPUs. The poll() implementation of perf events is fast 
and scalable.

( Note: there's no need to actually _capture_ the events into the 
  ring-buffer - this is done by not mmap()-ing the fd. I.e. we'll just 
  have a pure poll() wakeup overhead and no tracing overhead. )

The semantics are basically that we are observing task 
schedule/unschedule events and keep a count and a threshold - and can 
poll() on that. perf_event_attr can be used to inject a 'minimum 
parallelism' threshold value (and maybe a 'max parallelism' value as 
well).

Events are emitted (and poll() returns) if the observed workload gets 
'blocked' according to the parallelism threshold - i.e. if the number of 
runnable tasks drops below the threshold.

This fits very nicely into the existing perf events API and we wouldnt 
have to add a new syscall.

Usage is very simple and straightforward, and can happen on various 
levels of 'observation detail':

 - the new fd can be attached to a specific PID (like your syscall).
   perf_event_attr::threshold == 1 means we get the semantics of your
   sched_wait_block() system call. Note that poll() wont have to do a 
   PID lookup (as it is already attached) so it will be much faster than 
   sched_wait_block().

 - the new fd can be attached to a hieararchy of tasks and observe _all_ 
   of the parallelism there. This has the advantage of not having to 
   track each thread in a pool of threads. (this is done via inherited 
   events, see include/linux/perf_event.h:perf_event_attr::inherit) In 
   this case a parallelism threshold value larger than 1 makes sense 
   too, to allow the workload to spread to a number of CPUs. On a 4-CPU 
   system if we set threshold==4 it means that we'll return from poll()
   if the number of runnable tasks drops below 4.

 - the new fd can be attached to a CPU - observing parallelism of a full
   CPU without having to track all workloads. In this case threshold==1
   means that we'll return from poll() if the last task on that CPU 
   schedules out - i.e. if the CPU becomes idle.

etc.

This would make a very powerful task queueing framework. It basically 
allows a 'lazy' user-space scheduler, which only activates if the kernel 
scheduler has run out of work.

What do you think?

	Ingo
