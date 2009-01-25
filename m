Return-Path: <linux-kernel-owner+w=401wt.eu-S1756093AbZAYQZQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756093AbZAYQZQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Jan 2009 11:25:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754109AbZAYQZC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Jan 2009 11:25:02 -0500
Received: from mail-ew0-f10.google.com ([209.85.219.10]:52944 "EHLO
	mail-ew0-f10.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753722AbZAYQZA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Jan 2009 11:25:00 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=GMF4UWNTqV44pr2b5QjlMSQ3iopjoa+LHZ9BJ56Ua+AZA9+7Qms+DGw5B6RwkNUYDI
         R8Y91f17cmgeT7vGshh8Z4EmJS8TMuMzdG/otyMwhYnLwdgF2zvdAxWd4EE6jljSxrwo
         OB5dUl5McQVhRh0Vqvx9l3edhg6b62yDVwBLY=
Date: Sun, 25 Jan 2009 17:24:55 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Subject: Re: [PATCH] tracing/ftrace: add an option to not print the context
	info for events
Message-ID: <20090125162454.GB6749@nowhere>
References: <497671d4.1358560a.7a83.6114@mx.google.com> <alpine.DEB.1.10.0901202151180.14906@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.10.0901202151180.14906@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 20, 2009 at 09:55:17PM -0500, Steven Rostedt wrote:
> 
> On Tue, 20 Jan 2009, Frederic Weisbecker wrote:
> 
> > Impact: make trace_event more convenient for tracers
> > 
> > All tracers (for the moment) that use the struct trace_event want to have
> > the context info printed before their own output: the pid/cmdline, cpu, and timestamp.
> > 
> > But some other tracers that want to implement their trace_event callbacks will
> > not necessary need these information.
> > 
> > This patch adds a new default-enabled trace option: TRACE_ITER_CONTEXT_INFO
> > When disabled through:
> > 
> > echo nocontext-info > /debugfs/tracing/trace_options
> 
> Thanks Frederic,
> 
> > 
> > The pid, cpu and timestamps headers will not be printed.
> > 
> > IE with the sched_switch tracer with context-info (default):
> > 
> >             bash-2935  [001]   100.356561:   2935:120:S ==> [001]     0:140:R <idle>
> >           <idle>-0     [000]   100.412804:      0:140:R   + [000]    11:115:S events/0
> >           <idle>-0     [000]   100.412816:      0:140:R ==> [000]    11:115:R events/0
> >         events/0-11    [000]   100.412829:     11:115:S ==> [000]     0:140:R <idle>
> > 
> > Without context-info:
> > 
> >   2935:120:S ==> [001]     0:140:R <idle>
> >      0:140:R   + [000]    11:115:S events/0
> >      0:140:R ==> [000]    11:115:R events/0
> >     11:115:S ==> [000]     0:140:R <idle>
> > 
> > A tracer can disable it at runtime by clearing the bit TRACE_ITER_CONTEXT_INFO in trace_flags.
> 
> How about adding another function method into the tracer, where it could 
> be what is printed at the start. The default being what is now printed. 
> This would be for trace and latency trace only.
> 
> 
> > 
> > Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
> > ---
> >  kernel/trace/trace.c |   61 ++++++++++++++++++++++++++++---------------------
> >  kernel/trace/trace.h |    3 +-
> >  2 files changed, 37 insertions(+), 27 deletions(-)
> > 
> > diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
> > index 220c264..a59ba48 100644
> > --- a/kernel/trace/trace.c
> > +++ b/kernel/trace/trace.c
> > @@ -227,7 +227,7 @@ static DECLARE_WAIT_QUEUE_HEAD(trace_wait);
> >  
> >  /* trace_flags holds trace_options default values */
> >  unsigned long trace_flags = TRACE_ITER_PRINT_PARENT | TRACE_ITER_PRINTK |
> > -	TRACE_ITER_ANNOTATE;
> > +	TRACE_ITER_ANNOTATE | TRACE_ITER_CONTEXT_INFO;
> >  
> >  /**
> >   * trace_wake_up - wake up tasks waiting for trace input
> > @@ -285,6 +285,7 @@ static const char *trace_options[] = {
> >  	"userstacktrace",
> >  	"sym-userobj",
> >  	"printk-msg-only",
> > +	"context-info",
> >  	NULL
> >  };
> >  
> > @@ -1487,21 +1488,23 @@ static enum print_line_t print_trace_fmt(struct trace_iterator *iter)
> >  
> >  	test_cpu_buff_start(iter);
> >  
> > -	comm = trace_find_cmdline(iter->ent->pid);
> > -
> > -	t = ns2usecs(iter->ts);
> > -	usec_rem = do_div(t, 1000000ULL);
> > -	secs = (unsigned long)t;
> > -
> > -	ret = trace_seq_printf(s, "%16s-%-5d ", comm, entry->pid);
> > -	if (!ret)
> > -		return TRACE_TYPE_PARTIAL_LINE;
> > -	ret = trace_seq_printf(s, "[%03d] ", iter->cpu);
> > -	if (!ret)
> > -		return TRACE_TYPE_PARTIAL_LINE;
> > -	ret = trace_seq_printf(s, "%5lu.%06lu: ", secs, usec_rem);
> > -	if (!ret)
> > -		return TRACE_TYPE_PARTIAL_LINE;
> > +	if (trace_flags & TRACE_ITER_CONTEXT_INFO) {
> > +		comm = trace_find_cmdline(iter->ent->pid);
> > +
> > +		t = ns2usecs(iter->ts);
> > +		usec_rem = do_div(t, 1000000ULL);
> > +		secs = (unsigned long)t;
> > +
> > +		ret = trace_seq_printf(s, "%16s-%-5d ", comm, entry->pid);
> > +		if (!ret)
> > +			return TRACE_TYPE_PARTIAL_LINE;
> > +		ret = trace_seq_printf(s, "[%03d] ", iter->cpu);
> > +		if (!ret)
> > +			return TRACE_TYPE_PARTIAL_LINE;
> > +		ret = trace_seq_printf(s, "%5lu.%06lu: ", secs, usec_rem);
> > +		if (!ret)
> > +			return TRACE_TYPE_PARTIAL_LINE;
> > +	}
> 
> Or here we can do a:
> 
> 	if (iter->tr->context_info)
> 		ret = iter->tr->context_info(s, iter);
> 	else
> 		ret = default_context_info(s, iter);
> 
> This may give a tracer more control as to what to print for each entry.
> 
> -- Steve
> 


So what do you suggest actually? To keep TRACE_ITER_CONTEXT_INFO and add
two callbacks to control trace and latency_trace?

Or completely drop the option and only add these callbacks?

Keeping both will let a tracer decide if it wants to keep the headers for binary, hex
and raw too..

