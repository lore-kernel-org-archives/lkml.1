Return-Path: <linux-kernel-owner+w=401wt.eu-S1758431AbZCUOMr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758431AbZCUOMr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Mar 2009 10:12:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752700AbZCUOMi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Mar 2009 10:12:38 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:53515 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752150AbZCUOMh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Mar 2009 10:12:37 -0400
Date: Sat, 21 Mar 2009 15:12:00 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
       Arjan van de Ven <arjan@infradead.org>,
       Paul Mackerras <paulus@samba.org>
Subject: Re: [PATCH][GIT PULL] tracing: add function profiler
Message-ID: <20090321141200.GA20710@elte.hu>
References: <alpine.DEB.2.00.0903210036590.13615@gandalf.stny.rr.com> <20090321042633.1dfa536a.akpm@linux-foundation.org> <1237636623.4667.223.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1237636623.4667.223.camel@laptop>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Peter Zijlstra <peterz@infradead.org> wrote:

> On Sat, 2009-03-21 at 04:26 -0700, Andrew Morton wrote:
> > On Sat, 21 Mar 2009 00:37:59 -0400 (EDT) Steven Rostedt <rostedt@goodmis.org> wrote:
> > 
> > >    This patch adds a function profiler. In debugfs/tracing/ two new
> > >     files are created.
> > >     
> > >       function_profile_enabled  - to enable or disable profiling
> > >     
> > >       trace_stat/functions   - the profiled functions.
> > >     
> > >     For example:
> > >     
> > >       echo 1 > /debugfs/tracing/function_profile_enabled
> > >       ./hackbench 50
> > >       echo 0 > /debugfs/tracing/function_profile_enabled
> > >     
> > >     yields:
> > >     
> > >       cat /debugfs/tracing/trace_stat/functions
> > >     
> > >       Function                               Hit
> > >       --------                               ---
> > >       _spin_lock                        10106442
> > >       _spin_unlock                      10097492
> > >       kfree                              6013704
> > >       _spin_unlock_irqrestore            4423941
> > >       _spin_lock_irqsave                 4406825
> > >       __phys_addr                        4181686
> > >       __slab_free                        4038222
> > >       dput                               4030130
> > >       path_put                           4023387
> > >       unroll_tree_refs                   4019532
> > >     [...]
> > >     
> > >     The most hit functions are listed first. Functions that are not
> > >     hit are not listed.
> > 
> > Why is this useful?
> > 
> > Can we think of any scenarios where kernel developers would get
> > useful-to-them results from this?  Results which couldn't be 
> > obtained by other similarly-accessible means?
> > 
> > <strains a bit>
> > 
> > I guess that one could run workload A, look at
> > /debugfs/tracing/trace_stat/functions changes, then run worklaod B, then
> > look at its /debugfs/tracing/trace_stat/functions changes, then somehow
> > glean some information about the differences between the effects of the two
> > workloads on the kernel.  Or something.
> > 
> > But in this rather fake example and, I suspect, in many others, 
> > the result will be less useful than using oprofile/etc in the 
> > same fashion.
> 
> I have to agree with Andrew here, my plan is to remove all the 
> profiling stuff from kernel/trace in favour of perf counters.

i agree with that - but still it would be useful to also have the 
ability to do in-kernel histograms and the likely/unlikely profiler 
(which is using the same histogram code) is already using that 
facility.

But instead of the single-purpose likely/unlikely and now function 
histogram code, we should allow individual counters/events to be 
linked up with an in-kernel histogram - or route it to user-space 
via perfcounters.

> If you want exact function count profiling we could try to do 
> something perf counter based, eg. stick a software counter in the 
> mcount thingy.

while i agree in general - lets realize that function (and branch) 
software events _are_ special due to their sheer mass. I dont think 
it's feasible to route that much information to user-space - just to 
collapse it into a histogram there. Even doing it in the kernel is 
already straining the performance envelope quite a bit.

	Ingo
