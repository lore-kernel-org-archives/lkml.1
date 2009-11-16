Return-Path: <linux-kernel-owner+w=401wt.eu-S1753948AbZKPUWX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753948AbZKPUWX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Nov 2009 15:22:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753201AbZKPUWW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Nov 2009 15:22:22 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:34971 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753142AbZKPUWW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Nov 2009 15:22:22 -0500
Date: Mon, 16 Nov 2009 21:22:14 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Stijn Devriendt <highguy@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Mike Galbraith <efault@gmx.de>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Andrea Arcangeli <andrea@suse.de>, Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>, peterz@infradead.org,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC] observe and act upon workload parallelism:
 PERF_TYPE_PARALLELISM (Was: [RFC][PATCH] sched_wait_block: wait for blocked
 threads)
Message-ID: <20091116202214.GD360@elte.hu>
References: <1258311859-6189-1-git-send-email-HIGHGuY@gmail.com>
 <20091116083521.GC20672@elte.hu>
 <c76f371a0911161113v60eef516qee0a1a9cf99d2ae@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c76f371a0911161113v60eef516qee0a1a9cf99d2ae@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Stijn Devriendt <highguy@gmail.com> wrote:

> > And then we can use poll() in the thread manager task to observe 
> > PIDs, workloads or full CPUs. The poll() implementation of perf 
> > events is fast and scalable.
> 
> I've had a quick peek at the perf code and how it currently hooks into 
> the scheduler and at first glance it looks like 2 additional context 
> switches are required when using perf. The scheduler will first 
> schedule the idle thread to later find out that the schedule tail woke 
> up another process to run. My initial solution woke up the process 
> before making a scheduling decision. Depending on context switch times 
> the original blocking operation may have been unblocked (especially on 
> SMP); e.g. a blocked user-space mutex which was held shortly. Feel 
> free to correct me here as it was merely a quick peek.

( Btw., the PERF_TYPE_PARALLELISM name sucks. A better name would be
  PERF_COUNT_SW_TASKS or PERF_COUNT_SW_THREAD_POOL or so. )

I'd definitely not advocate a 'controller thread' approach: it's an 
unnecessary extra intermediary and it doubles the context switch cost 
and tears cache footprint apart.

We want any such scheme to schedule 'naturally' and optimally: i.e. a 
blocking thread will schedule an available thread - no ifs and when.

The only limit we want is on concurrency - and we can do that by waking 
tasks from the poll() waitqueue if a task blocks - and by requeueing 
woken tasks to the poll() waitqueue if a task wakes (and if the 
concurrency threshold does not allow it to run)..

In a sense the poll() waitqueue becomes a mini-runqueue for 'ready' 
tasks - and the 'number of tasks running' value of the sw event object a 
rq->nr_running value. It does not make the tasks available to the real 
scheduler - but it's a list of tasks that are willing to run.

This would be a perfect and suitable use of poll() concepts i think - 
and well-optimized one as well. It could even be plugged into epoll().

	Ingo
