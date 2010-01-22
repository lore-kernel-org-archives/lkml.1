Return-Path: <linux-kernel-owner+w=401wt.eu-S1755759Ab0AVC3I@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755759Ab0AVC3I (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jan 2010 21:29:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755702Ab0AVC3H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jan 2010 21:29:07 -0500
Received: from tomts22-srv.bellnexxia.net ([209.226.175.184]:56117 "EHLO
	tomts22-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751433Ab0AVC3F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jan 2010 21:29:05 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AuAEAAOYWEuuWOiG/2dsb2JhbACBRtgXhDwE
Date: Thu, 21 Jan 2010 21:28:58 -0500
From: Mathieu Desnoyers <compudj@krystal.dyndns.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>, Li Zefan <lizf@cn.fujitsu.com>,
       Lai Jiangshan <laijs@cn.fujitsu.com>,
       Masami Hiramatsu <mhiramat@redhat.com>
Subject: Re: [RFC PATCH 03/10] ftrace: Drop the ftrace_profile_enabled
	checks in tracing hot path
Message-ID: <20100122022858.GA2604@Krystal>
References: <1264122982-1553-1-git-send-regression-fweisbec@gmail.com> <1264122982-1553-4-git-send-regression-fweisbec@gmail.com> <1264125917.31321.312.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <1264125917.31321.312.camel@gandalf.stny.rr.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.27.31-grsec (i686)
X-Uptime: 21:22:19 up 36 days, 10:40,  4 users,  load average: 0.06, 0.10,
	0.09
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Steven Rostedt (rostedt@goodmis.org) wrote:
> On Fri, 2010-01-22 at 02:16 +0100, Frederic Weisbecker wrote:
> > Every time we enter the function profiler tracing callbacks, we first
> > check if the function profiling is enabled.
> > 
> > This check is useless because we register the function graph
> > callbacks only after the hashlist has been initialized.
> 
> Unfortunately, since the previous patch is incorrect, it makes this one
> buggy too.
> 
> If you remove the check to ftrace_profile_enabled, the call to the
> profiled code could have been preempted and pending to be called.
> 
> Stop machine may remove all calls to the tracing, but it only affects
> new hits. Pending hits may still exist.
> 
> If you remove this check, and the user re-enables the profiling, then
> all PER_CPU hashs will be reset. If in the process of this happening,
> the task with the pending trace wakes up, it may access the PER_CPU list
> and corrupt it.
> 
> Now for the reason I Cc'd Paul and Mathieu...
> 
> If we had a synchronize_sched() like function that would wait and return
> when all preempted tasks have been scheduled again and went to either
> userspace or called schedule directly, then we could actually do this.
> 
> After unregistering the function graph trace, you call this
> "synchronize_tasks()" and it will guarantee that all currently preempted
> tasks have either went to userspace or have called schedule() directly.
> Then it would be safe to remove this check.

OK, so basically you need to know when you reach a quiescent state, but
preemption is enabled and there is no RCU read lock taken around these
code paths, am I correct ?

With tracepoints, life is easy because I disable preemption around the
calls, so I can use synchronize_sched() to know when quiescent state is
reached.

I recommend looking at kernel/kprobes.c:check_safety(). It uses
thaw_processes() and synchronize_sched() for this purpose. Basically, it
rely on the "refrigeration" points to detect such quiescent state. This
trick should do the job for the function graph tracer too.

I'm adding Masami in CC. He is the one who implemented check_safety(),
and I remember discussing it with him in the past.

Thanks,

Mathieu

> 
> -- Steve
> 
> > 
> > Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
> > Cc: Steven Rostedt <rostedt@goodmis.org>
> > Cc: Li Zefan <lizf@cn.fujitsu.com>
> > Cc: Lai Jiangshan <laijs@cn.fujitsu.com>
> > ---
> >  kernel/trace/ftrace.c |    7 ++-----
> >  1 files changed, 2 insertions(+), 5 deletions(-)
> > 
> > diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
> > index 94117ec..f258f67 100644
> > --- a/kernel/trace/ftrace.c
> > +++ b/kernel/trace/ftrace.c
> > @@ -381,13 +381,10 @@ function_profile_call(unsigned long ip, unsigned long parent_ip)
> >  	struct func_node *rec;
> >  	unsigned long flags;
> >  
> > -	if (!ftrace_profile_enabled)
> > -		return;
> > -
> >  	local_irq_save(flags);
> >  
> >  	hlist = &__get_cpu_var(func_hlist_cpu);
> > -	if (!hlist->hash || !ftrace_profile_enabled)
> > +	if (!hlist->hash)
> >  		goto out;
> >  
> >  	rec = function_find_hlist_node(hlist, ip);
> > @@ -418,7 +415,7 @@ static void profile_graph_return(struct ftrace_graph_ret *trace)
> >  
> >  	local_irq_save(flags);
> >  	hlist = &__get_cpu_var(func_hlist_cpu);
> > -	if (!hlist->hash || !ftrace_profile_enabled)
> > +	if (!hlist->hash)
> >  		goto out;
> >  
> >  	calltime = trace->rettime - trace->calltime;
> 
> 

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
