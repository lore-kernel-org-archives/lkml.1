Return-Path: <linux-kernel-owner+w=401wt.eu-S1752209AbZBCCdG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752209AbZBCCdG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Feb 2009 21:33:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751214AbZBCCcy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Feb 2009 21:32:54 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:51502 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751058AbZBCCcy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Feb 2009 21:32:54 -0500
Date: Mon, 2 Feb 2009 21:32:51 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Frederic Weisbecker <fweisbec@gmail.com>
cc: Arnaldo Carvalho de Melo <acme@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Jens Axboe <jens.axboe@oracle.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH tip 1/3] trace: better manage the context info for
 events
In-Reply-To: <20090203020746.GB22718@nowhere>
Message-ID: <alpine.DEB.1.10.0902022128130.2192@gandalf.stny.rr.com>
References: <20090202222921.GB12082@ghostprotocols.net> <20090203020746.GB22718@nowhere>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 3 Feb 2009, Frederic Weisbecker wrote:

> On Mon, Feb 02, 2009 at 08:29:21PM -0200, Arnaldo Carvalho de Melo wrote:
> > From: Frederic Weisbecker <fweisbec@gmail.com>
> > 
> > Impact: make trace_event more convenient for tracers
> > 
> > All tracers (for the moment) that use the struct trace_event want to
> > have the context info printed before their own output: the pid/cmdline,
> > cpu, and timestamp.
> > 
> > But some other tracers that want to implement their trace_event
> > callbacks will not necessary need these information or they may want to
> > format them as they want.
> > 
> > This patch adds a new default-enabled trace option:
> > TRACE_ITER_CONTEXT_INFO When disabled through:
> > 
> > echo nocontext-info > /debugfs/tracing/trace_options
> > 
> > The pid, cpu and timestamps headers will not be printed.
> > 
> > IE with the sched_switch tracer with context-info (default):
> > 
> >      bash-2935 [001] 100.356561: 2935:120:S ==> [001]  0:140:R <idle>
> >    <idle>-0    [000] 100.412804:    0:140:R   + [000] 11:115:S events/0
> >    <idle>-0    [000] 100.412816:    0:140:R ==> [000] 11:115:R events/0
> >  events/0-11   [000] 100.412829:   11:115:S ==> [000]  0:140:R <idle>
> > 
> > Without context-info:
> > 
> >  2935:120:S ==> [001]  0:140:R <idle>
> >     0:140:R   + [000] 11:115:S events/0
> >     0:140:R ==> [000] 11:115:R events/0
> >    11:115:S ==> [000]  0:140:R <idle>
> > 
> > A tracer can disable it at runtime by clearing the bit
> > TRACE_ITER_CONTEXT_INFO in trace_flags.
> > 
> > The print routines were renamed to trace_print_context and
> > trace_print_lat_context, so that they can be used by tracers if they
> > want to use them for one of the trace_event callbacks.
> 
> 
> Actually, I wonder if this is not breaking the sense of the TRACE_ITER_CONTEXT_INFO
> flag.

Yeah, I agree with Frederic here. Let the user decide this as a global 
flag for about of data to print. The tracer should just provide a callback 
incase the tracer has a different context format.

> 
> In the first patch I made about it, I thought this flag was to decide whether we want to
> print the context information in the standard way.
> 
> Then, Steven suggested to actually provide callbacks for the tracers which want
> to override the standard context information printer.
> The flag then got more logical: TRACE_ITER_CONTEXT_INFO was not only about deciding
> whether we want or not the standard context info, it tells if we want in a global way
> the context info to be printed, whatever how the tracer decides to print it.
> (This is the theory, but since we couldn't override the bin/raw/hex cases, the
> practical case didn't follow this idea).
> 
> If someone doesn't want to see these informations in the blk tracer, this flag will
> not help him. Worst, it will double print the context info if the user enables the flag.
> 
> Now that I see the practical case, I'm not sure the design of my patch was valuable.
> A tracer has to play with the flag if it wants to override the context info in
> the bin/raw/hex cases. And I don't think this is a good way to proceed.
> 
> In my opinion, the ITER_CONTEXT_INFO flag should mostly be set by the user.

I think it should _only_ be set by user.

> 
> And only one callback could be added to trace_event: context_info()
> Then, the tracer will manage itself the raw/hex/bin/normal cases inside
> this callback.

Yeah, this is a good idea. The callback can be passed an enum to what kind
of trace it is: TRACE_FMT_RAW TRACE_FMT_HEX ...


> 
> We can provide the default callbacks available for the tracers which want it and even
> one function which proceed all of them, depending on the flags.
> ftrace/preempt/sched.... tracers can register this function for their context_info callback
> and other tracers too if they want.
> 
> Or they can override it, and even pick the default callbacks for dedicated flags when they want.
> 
> Then, when the user wants the context info to be printed or not, he just have to
> set/clear the context-info flag manually.
> 
> A tracer can even decide to set/clear it by default, but for its real sense: print or not
> these context info.
> 
> What do you think?

I'm not sure a tracer should decide if it should have the format or not. 
In its context callback, it might decide there. But if the user does not 
want it, it should be off.

Unless you are saying have the tracer decide if it is enabled on or off 
when the trace is selected?

-- Steve
