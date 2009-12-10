Return-Path: <linux-kernel-owner+w=401wt.eu-S1760799AbZLJIXi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760799AbZLJIXi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Dec 2009 03:23:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760734AbZLJIXe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Dec 2009 03:23:34 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:47838 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760729AbZLJIXd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Dec 2009 03:23:33 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Thu, 10 Dec 2009 17:20:40 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       cl@linux-foundation.org,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       minchan.kim@gmail.com
Subject: Re: [RFC mm][PATCH 2/5] percpu cached mm counter
Message-Id: <20091210172040.37d259d3.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20091210075454.GB25549@elte.hu>
References: <20091210163115.463d96a3.kamezawa.hiroyu@jp.fujitsu.com>
	<20091210163448.338a0bd2.kamezawa.hiroyu@jp.fujitsu.com>
	<20091210075454.GB25549@elte.hu>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 10 Dec 2009 08:54:54 +0100
Ingo Molnar <mingo@elte.hu> wrote:

> 
> * KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:
> 
> > From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> > 
> > Now, mm's counter information is updated by atomic_long_xxx() 
> > functions if USE_SPLIT_PTLOCKS is defined. This causes cache-miss when 
> > page faults happens simultaneously in prural cpus. (Almost all 
> > process-shared objects is...)
> > 
> > Considering accounting per-mm page usage more, one of problems is cost 
> > of this counter.
> 
> I'd really like these kinds of stats available via the tool you used to 
> develop this patchset:
> 
> >  After:
> >     Performance counter stats for './multi-fault 2' (5 runs):
> > 
> >        46997471  page-faults                ( +-   0.720% )
> >      1004100076  cache-references           ( +-   0.734% )
> >       180959964  cache-misses               ( +-   0.374% )
> >    29263437363580464  bus-cycles                 ( +-   0.002% )
> > 
> >    60.003315683  seconds time elapsed   ( +-   0.004% )
> > 
> >    cachemiss/page faults is reduced from 4.55 miss/faults to be 3.85miss/faults
> 
> I.e. why not expose these stats via perf events and counts as well, 
> beyond the current (rather minimal) set of MM stats perf supports 
> currently?
> 
> That way we'd get a _lot_ of interesting per task mm stats available via 
> perf stat (and maybe they can be profiled as well via perf record), and 
> we could perhaps avoid uglies like having to hack hooks into sched.c:
> 

As I wrote in 0/5, this is finally for oom-killer, for "kernel internal use".


Not for user's perf evetns.

 - http://marc.info/?l=linux-mm&m=125714672531121&w=2

And Christoph has concerns on cache-miss on this counter.

 - http://archives.free.net.ph/message/20091104.191441.1098b93c.ja.html

This patch is for replcacing atomic_long_add() with percpu counter.


> > +	/*
> > +	 * sync/invaldidate per-cpu cached mm related information
> > +	 * before taling rq->lock. (see include/linux/mm.h)
> 
> (minor typo: s/taling/taking )
> 
Oh, thanks.

> > +	 */
> > +	sync_mm_counters_atomic();
> >  
> >  	spin_lock_irq(&rq->lock);
> >  	update_rq_clock(rq);
> 
> It's not a simple task i guess since this per mm counting business has 
> grown its own variant which takes time to rearchitect, plus i'm sure 
> there's performance issues to solve if such a model is exposed via perf, 
> but users and developers would be _very_ well served by such 
> capabilities:
> 
>  - clean, syscall based API available to monitor tasks, workloads and 
>    CPUs. (or the whole system)
> 
>  - sampling (profiling)
> 
>  - tracing, post-process scripting via Perl plugins
> 

I'm sorry If I miss your point...are you saying remove all mm_counter completely
and remake them under perf ? If so, some proc file (/proc/<pid>/statm etc)
will be corrupted ?

Thanks,
-Kame


