Return-Path: <linux-kernel-owner+w=401wt.eu-S1756377AbZLUDCR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756377AbZLUDCR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Dec 2009 22:02:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755662AbZLUDCQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Dec 2009 22:02:16 -0500
Received: from hera.kernel.org ([140.211.167.34]:39179 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752424AbZLUDCP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Dec 2009 22:02:15 -0500
Message-ID: <4B2EE5A5.2030208@kernel.org>
Date: Mon, 21 Dec 2009 12:04:05 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091130 SUSE/3.0.0-1.1.1 Thunderbird/3.0
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: torvalds@linux-foundation.org, awalls@radix.net,
       linux-kernel@vger.kernel.org, jeff@garzik.org, mingo@elte.hu,
       akpm@linux-foundation.org, jens.axboe@oracle.com, rusty@rustcorp.com.au,
       cl@linux-foundation.org, dhowells@redhat.com, arjan@linux.intel.com,
       avi@redhat.com, johannes@sipsolutions.net, andi@firstfloor.org
Subject: Re: workqueue thing
References: <1261141088-2014-1-git-send-email-tj@kernel.org> <1261143924.20899.169.camel@laptop>
In-Reply-To: <1261143924.20899.169.camel@laptop>
X-Enigmail-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 12/18/2009 10:45 PM, Peter Zijlstra wrote:
>>    r1. The first design goal of cmwq is solving the issues the current
>>        workqueue implementation has including hard to detect
>>        deadlocks, 
> 
> lockdep is quite proficient at finding these these days.

I've been thinking there are cases which the current lockdep
annotations can't detect but I can't think of any.  But still when
these possible deadlocks are detected, the only solution we now have
is to put one into a separate workqueue.  As it often is an overkill
to create multithread workqueue for that single work, it usually ends
up being a singlethread one, which often isn't optimal.  With cmwq,
this problem is gone.

>> 	 unexpectedly long latencies caused by long running
>>        works which share the workqueue and excessive number of worker
>>        threads necessitated by each workqueue having its own workers.
> 
> works shouldn't be long running to begin with

Let's discuss this below.

>>        cmwq is cpu affine because its target workloads are not cpu
>>        intensive.  Most works are context hungry not cpu cycle hungry
>>        and as such providing the necessary context (or concurrency)
>>        from the local CPU is the most efficient way to serve them.
> 
> Things cannot be not cpu intensive and long running.

What are you talking about?  There's a huge world outside of CPUs and
RAMs where taking seconds or even tens of seconds isn't too strange.
SCSI/ATA exception conditions can easily take tens of seconds which in
turn makes anything which may depend on IO may take tens of seconds.

> And this design is patently unsuited for cpu intensive tasks, hence they
> should not be long running.

Burning a lot of CPU cycles in kernel is and must be very rare
exceptions.  Waiting for IO or other external events is far less so.
Seriously, take a look at other async mechanisms we have - async, long
works, SCSI EHs.  They're there to provide concurrency so that they
can wait for *EVENTS* not to burn CPU cycles.

> The only way something can be not cpu intensive and long 'running' is if
> it got blocked that long, and the right solution is to fix that
> contention, things should not be blocked for seconds.

IOs and events.  Not CPUs or RAMs.

>>        The second design goal is to unify different async mechanisms
>>        in kernel.  Although cmwq wouldn't be able to serve CPU cycle
>>        intensive workload, most in-kernel async mechanisms are there
>>        to provide context and concurrency and they all can be
>>        converted to use cmwq.
> 
> Which specifically, the ones I'm aware of are mostly cpu intensive.

Async which currently is only used to make ATA probing parallel.  Long
works which are used for fscache.  SCSI/ATA EHs.  ATA polling PIO and
probing helper workers.  To-be-implemented in-kernel media presence
polling.  xfs or other fs IO threads.

The ones you're aware of are very different from the ones I'm aware
of.  The difference is probably coming from where we usually work on.
CPU intensive ones require pretty different solution from the ones
which just need the contexts to wait for events.  For the latter,
things can be made very mechanical as the optimal level of concurrency
is easily defined as minimal level which is just enough to avoid
blocking other works as the resource they're competeing for - the
contexts - isn't scarce.  And for this, the work interface is very
well suited.

For CPU intensive ones, it's more difficult as CPU cycles are in
contention and things like fairness needs to be considered.  It's a
different class of problem.  From what I can see, this class of
problems are still smaller in volume than the event waiting class of
problems.  Increasing popularities in FS end-to-end verification and
maybe encryption are likely to increase pressure here tho.  This is
gonna require a different solution where scheduler would play the core
role.

>>    r2. The only thing necessary to support long running works is the
>>        ability to rebind workers to the cpu if it comes back online
>>        and allowing long running works will allow most existing worker
>>        pools to be served by cmwq and also make CPU down/up latencies
>>        more predictable.
> 
> That's not necessary at all, and introduces quite a lot of ugly code.
>
> Furthermore, let me restate that having long running works is the
> problem.

I guess I explained this enough.  When IO goes wrong, in extreme
cases, it can easily take over thirty secs to recover and that's
required by the hardware specifications, so anything which ends up
waiting on IO can take a pretty long time.  The only piece of code
which is necessary to support that is the code necessary to migrate
back tasks to CPUs when they come online again.  It's not a lot of
ugly code.

>>    r3. I don't think there is any way to implement shared worker pool
>>        without forking when more concurrency is required and the
>>        actual amount of forking would be low as cmwq scales the number
>>        of idle workers to keep according to the current concurrency
>>        level and uses rather long timeout (5min) for idlers.
> 
> I'm still not convinced more concurrency is required.

Hope my explanations helped convincing you.

Thanks.

-- 
tejun
