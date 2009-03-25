Return-Path: <linux-kernel-owner+w=401wt.eu-S1763667AbZCYRgt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763667AbZCYRgt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Mar 2009 13:36:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763573AbZCYRfs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Mar 2009 13:35:48 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:65092 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763577AbZCYRfq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Mar 2009 13:35:46 -0400
Date: Wed, 25 Mar 2009 13:35:43 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Ingo Molnar <mingo@elte.hu>
cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Tim Bird <tim.bird@am.sony.com>, Steven Rostedt <srostedt@redhat.com>
Subject: Re: [PATCH 5/5][RFC] function-graph: add option to calculate graph
 time or not
In-Reply-To: <20090325101139.GJ2341@elte.hu>
Message-ID: <alpine.DEB.2.00.0903251328290.5675@gandalf.stny.rr.com>
References: <20090325035646.662994901@goodmis.org> <20090325040833.213388591@goodmis.org> <20090325101139.GJ2341@elte.hu>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 25 Mar 2009, Ingo Molnar wrote:

> 
> * Steven Rostedt <rostedt@goodmis.org> wrote:
> 
> > --- a/kernel/trace/trace_functions_graph.c
> > +++ b/kernel/trace/trace_functions_graph.c
> > @@ -104,9 +105,6 @@ ftrace_pop_return_trace(struct ftrace_graph_ret *trace, unsigned long *ret)
> >  	trace->calltime = current->ret_stack[index].calltime;
> >  	trace->overrun = atomic_read(&current->trace_overrun);
> >  	trace->depth = index;
> > -	barrier();
> > -	current->curr_ret_stack--;
> > -
> >  }
> >  
> >  /*
> > @@ -121,6 +119,8 @@ unsigned long ftrace_return_to_handler(void)
> >  	ftrace_pop_return_trace(&trace, &ret);
> >  	trace.rettime = trace_clock_local();
> >  	ftrace_graph_return(&trace);
> > +	barrier();
> > +	current->curr_ret_stack--;
> 
> this will modify the regular graph tracer too. No discussion of this 
> change in the changelog - is it a fix?

Ah, sorry, I should have commented that.

This is to prevent a race in the profiler code. This is not a problem with 
current function graph code.

What happens is that the profiler references the ret_stack from the 
ftrace_graph_return function. If we update the curr_ret_stack and we take 
an interrupt then we run the risk of reading incorrect data. Once we 
decrement the curr_ret_stack, the ret_stack for the function is fair game 
to be used again by an interrupt.

Perhaps I should pull this change out and add it for core. This will let 
any function graph user safely reference the ret_stack.

-- Steve

