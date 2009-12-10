Return-Path: <linux-kernel-owner+w=401wt.eu-S1760703AbZLJHzH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760703AbZLJHzH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Dec 2009 02:55:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760639AbZLJHzA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Dec 2009 02:55:00 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:36941 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760504AbZLJHzA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Dec 2009 02:55:00 -0500
Date: Thu, 10 Dec 2009 08:54:54 +0100
From: Ingo Molnar <mingo@elte.hu>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       cl@linux-foundation.org,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       minchan.kim@gmail.com
Subject: Re: [RFC mm][PATCH 2/5] percpu cached mm counter
Message-ID: <20091210075454.GB25549@elte.hu>
References: <20091210163115.463d96a3.kamezawa.hiroyu@jp.fujitsu.com>
 <20091210163448.338a0bd2.kamezawa.hiroyu@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091210163448.338a0bd2.kamezawa.hiroyu@jp.fujitsu.com>
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


* KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:

> From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> 
> Now, mm's counter information is updated by atomic_long_xxx() 
> functions if USE_SPLIT_PTLOCKS is defined. This causes cache-miss when 
> page faults happens simultaneously in prural cpus. (Almost all 
> process-shared objects is...)
> 
> Considering accounting per-mm page usage more, one of problems is cost 
> of this counter.

I'd really like these kinds of stats available via the tool you used to 
develop this patchset:

>  After:
>     Performance counter stats for './multi-fault 2' (5 runs):
> 
>        46997471  page-faults                ( +-   0.720% )
>      1004100076  cache-references           ( +-   0.734% )
>       180959964  cache-misses               ( +-   0.374% )
>    29263437363580464  bus-cycles                 ( +-   0.002% )
> 
>    60.003315683  seconds time elapsed   ( +-   0.004% )
> 
>    cachemiss/page faults is reduced from 4.55 miss/faults to be 3.85miss/faults

I.e. why not expose these stats via perf events and counts as well, 
beyond the current (rather minimal) set of MM stats perf supports 
currently?

That way we'd get a _lot_ of interesting per task mm stats available via 
perf stat (and maybe they can be profiled as well via perf record), and 
we could perhaps avoid uglies like having to hack hooks into sched.c:

> +	/*
> +	 * sync/invaldidate per-cpu cached mm related information
> +	 * before taling rq->lock. (see include/linux/mm.h)

(minor typo: s/taling/taking )

> +	 */
> +	sync_mm_counters_atomic();
>  
>  	spin_lock_irq(&rq->lock);
>  	update_rq_clock(rq);

It's not a simple task i guess since this per mm counting business has 
grown its own variant which takes time to rearchitect, plus i'm sure 
there's performance issues to solve if such a model is exposed via perf, 
but users and developers would be _very_ well served by such 
capabilities:

 - clean, syscall based API available to monitor tasks, workloads and 
   CPUs. (or the whole system)

 - sampling (profiling)

 - tracing, post-process scripting via Perl plugins

etc.

	Ingo
