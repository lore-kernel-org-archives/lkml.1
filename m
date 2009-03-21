Return-Path: <linux-kernel-owner+w=401wt.eu-S1756918AbZCUL5b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756918AbZCUL5b (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Mar 2009 07:57:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752878AbZCUL5W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Mar 2009 07:57:22 -0400
Received: from casper.infradead.org ([85.118.1.10]:34383 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752450AbZCUL5V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Mar 2009 07:57:21 -0400
Subject: Re: [PATCH][GIT PULL] tracing: add function profiler
From: Peter Zijlstra <peterz@infradead.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Steven Rostedt <rostedt@goodmis.org>, LKML <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       =?ISO-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
       Arjan van de Ven <arjan@infradead.org>,
       Paul Mackerras <paulus@samba.org>
In-Reply-To: <20090321042633.1dfa536a.akpm@linux-foundation.org>
References: <alpine.DEB.2.00.0903210036590.13615@gandalf.stny.rr.com>
	 <20090321042633.1dfa536a.akpm@linux-foundation.org>
Content-Type: text/plain
Date: Sat, 21 Mar 2009 12:57:03 +0100
Message-Id: <1237636623.4667.223.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2009-03-21 at 04:26 -0700, Andrew Morton wrote:
> On Sat, 21 Mar 2009 00:37:59 -0400 (EDT) Steven Rostedt <rostedt@goodmis.org> wrote:
> 
> >    This patch adds a function profiler. In debugfs/tracing/ two new
> >     files are created.
> >     
> >       function_profile_enabled  - to enable or disable profiling
> >     
> >       trace_stat/functions   - the profiled functions.
> >     
> >     For example:
> >     
> >       echo 1 > /debugfs/tracing/function_profile_enabled
> >       ./hackbench 50
> >       echo 0 > /debugfs/tracing/function_profile_enabled
> >     
> >     yields:
> >     
> >       cat /debugfs/tracing/trace_stat/functions
> >     
> >       Function                               Hit
> >       --------                               ---
> >       _spin_lock                        10106442
> >       _spin_unlock                      10097492
> >       kfree                              6013704
> >       _spin_unlock_irqrestore            4423941
> >       _spin_lock_irqsave                 4406825
> >       __phys_addr                        4181686
> >       __slab_free                        4038222
> >       dput                               4030130
> >       path_put                           4023387
> >       unroll_tree_refs                   4019532
> >     [...]
> >     
> >     The most hit functions are listed first. Functions that are not
> >     hit are not listed.
> 
> Why is this useful?
> 
> Can we think of any scenarios where kernel developers would get
> useful-to-them results from this?  Results which couldn't be 
> obtained by other similarly-accessible means?
> 
> <strains a bit>
> 
> I guess that one could run workload A, look at
> /debugfs/tracing/trace_stat/functions changes, then run worklaod B, then
> look at its /debugfs/tracing/trace_stat/functions changes, then somehow
> glean some information about the differences between the effects of the two
> workloads on the kernel.  Or something.
> 
> But in this rather fake example and, I suspect, in many others, the result
> will be less useful than using oprofile/etc in the same fashion.

I have to agree with Andrew here, my  plan is to remove all the
profiling stuff from kernel/trace in favour of perf counters.

If you want exact function count profiling we could try to do something
perf counter based, eg. stick a software counter in the mcount thingy.

After that you'd need to get something like
this_pt_regs()/caller_pt_regs() which would provide the current kernel
stack information to generate profile information from.

Current software events use get_irq_regs() ?: task_pt_regs() for lack of
anything better.


