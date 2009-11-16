Return-Path: <linux-kernel-owner+w=401wt.eu-S1753930AbZKPUNt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753930AbZKPUNt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Nov 2009 15:13:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753741AbZKPUNs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Nov 2009 15:13:48 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:53883 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753643AbZKPUNr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Nov 2009 15:13:47 -0500
Date: Mon, 16 Nov 2009 21:13:35 +0100
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
Message-ID: <20091116201335.GC360@elte.hu>
References: <1258311859-6189-1-git-send-email-HIGHGuY@gmail.com>
 <20091116083521.GC20672@elte.hu>
 <alpine.LFD.2.01.0911160945470.9384@localhost.localdomain>
 <c76f371a0911161149p5416c992o64e926890b8b32c0@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c76f371a0911161149p5416c992o64e926890b8b32c0@mail.gmail.com>
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

> One extra catch, I didn't even think of in the original approach is 
> that you still need a way of saying to the kernel: no more work here.
> 
> My original approach fails bluntly and I will happily take credit for 
> that ;) The perf-approach perfectly allows for this, by waking up the 
> "controller" thread which does exactly nothing as there's no work 
> left.

Note, the perf approach does not require a 'controller thread'.

The most efficient approach using perf-events would be:

 - have the pool threads block in poll(perf_event_fd). (all threads 
   block in poll() on the same fd).

 - blocking threads wake_up() the pool and cause them to drop out of
   poll() (with no intermediary). [if there's less than
   perf_event::min_concurrency tasks running.]

 - waking threads observe the event state and only run if we are still 
   below perf_event::max_concurrency - otherwise they re-queue to the
   poll() waitqueue.

Basically the perf-event fd creates the 'group of tasks'. This can be 
created voluntarily by cooperating threads - or involuntarily as well 
via PID attach or CPU attach.

There's no 'tracing' overhead or notification overhead: we maintain a 
shared state and the 'notifications' are straight wakeups that bring the 
pool members out of poll(), to drive the workload further.

Such a special sw-event, with min_concurrency==max_concurrency==1 would 
implement Linus's interface - using standard facilities like poll(). 
(The only 'special' act is the set up of the group itself.)

So various concurrency controls could be implemented that way - 
including the one Linus suggest - even a HPC workload-queueing daemon 
could be done as well, which sheperds 100% uncooperative tasks.

I dont think this 'fancy' approach is actually a performance drag: it 
would really do precisely the same thing Linus's facility does (unless 
i'm missing something subtle - or something less subtle about Linus's 
scheme), with the two parameters set to '1'.

( It would also enable a lot of other things, and it would not tie the 
  queueing implementation into the scheduler. )

Only trying would tell us for sure though - maybe i'm wrong.

Thanks,

	Ingo
