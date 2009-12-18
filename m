Return-Path: <linux-kernel-owner+w=401wt.eu-S1753561AbZLRNqs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753561AbZLRNqs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Dec 2009 08:46:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752885AbZLRNqr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Dec 2009 08:46:47 -0500
Received: from casper.infradead.org ([85.118.1.10]:37623 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752769AbZLRNqq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Dec 2009 08:46:46 -0500
Subject: Re: workqueue thing
From: Peter Zijlstra <peterz@infradead.org>
To: Tejun Heo <tj@kernel.org>
Cc: torvalds@linux-foundation.org, awalls@radix.net,
       linux-kernel@vger.kernel.org, jeff@garzik.org, mingo@elte.hu,
       akpm@linux-foundation.org, jens.axboe@oracle.com, rusty@rustcorp.com.au,
       cl@linux-foundation.org, dhowells@redhat.com, arjan@linux.intel.com,
       avi@redhat.com, johannes@sipsolutions.net, andi@firstfloor.org
In-Reply-To: <1261141088-2014-1-git-send-email-tj@kernel.org>
References: <1261141088-2014-1-git-send-email-tj@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 18 Dec 2009 14:45:24 +0100
Message-ID: <1261143924.20899.169.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-12-18 at 21:57 +0900, Tejun Heo wrote:
> 
> C. While discussing issue B [3], Peter Zijlstra objected to the
>    basic design of cmwq.  Peter's objections are...
> 
>    o1. It isn't a generic worker pool mechanism in that it can't serve
>        cpu-intensive workloads because all works are affined to local
>        cpus.
> 
>    o2. Allowing long (> 5s for example) running works isn't a good
>        idea and by not allowing long running works, the need to
>        migrate back workers when cpu comes back online can be removed.
> 
>    o3. It's a fork-fest.
> 
>    My rationales for each are
> 
>    r1. The first design goal of cmwq is solving the issues the current
>        workqueue implementation has including hard to detect
>        deadlocks, 

lockdep is quite proficient at finding these these days.

>	 unexpectedly long latencies caused by long running
>        works which share the workqueue and excessive number of worker
>        threads necessitated by each workqueue having its own workers.

works shouldn't be long running to begin with

>        cmwq solves these issues quite efficiently without depending on
>        fragile and complex heuristics.  Concurrency is managed to
>        minimal yet sufficient level, workers are reused as much as
>        possible and only necessary number of workers are created and
>        maintained.
> 
>        cmwq is cpu affine because its target workloads are not cpu
>        intensive.  Most works are context hungry not cpu cycle hungry
>        and as such providing the necessary context (or concurrency)
>        from the local CPU is the most efficient way to serve them.

Things cannot be not cpu intensive and long running.

And this design is patently unsuited for cpu intensive tasks, hence they
should not be long running.

The only way something can be not cpu intensive and long 'running' is if
it got blocked that long, and the right solution is to fix that
contention, things should not be blocked for seconds.

>        The second design goal is to unify different async mechanisms
>        in kernel.  Although cmwq wouldn't be able to serve CPU cycle
>        intensive workload, most in-kernel async mechanisms are there
>        to provide context and concurrency and they all can be
>        converted to use cmwq.

Which specifically, the ones I'm aware of are mostly cpu intensive.

>        Async workloads which need to burn large amount of CPU cycles
>        such as encryption and IO checksumming have pretty different
>        requirements and worker pool designed to serve them would
>        probably require fair amount of heuristics to determine the
>        appropriate level of concurrency.  Workqueue API may be
>        extended to cover such workloads by providing an anonymous CPU
>        for those works to bind to but the underlying operation would
>        be fairly different.  If this is something necessary, let's
>        pursue it but I don't think it's exclusive with cmwq.

The interesting bit is limiting runnable tasks, that will introduce
deadlock potential. 

>    r2. The only thing necessary to support long running works is the
>        ability to rebind workers to the cpu if it comes back online
>        and allowing long running works will allow most existing worker
>        pools to be served by cmwq and also make CPU down/up latencies
>        more predictable.

That's not necessary at all, and introduces quite a lot of ugly code.

Furthermore, let me restate that having long running works is the
problem.

>    r3. I don't think there is any way to implement shared worker pool
>        without forking when more concurrency is required and the
>        actual amount of forking would be low as cmwq scales the number
>        of idle workers to keep according to the current concurrency
>        level and uses rather long timeout (5min) for idlers.

I'm still not convinced more concurrency is required.

