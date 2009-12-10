Return-Path: <linux-kernel-owner+w=401wt.eu-S1761829AbZLJVzl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761829AbZLJVzl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Dec 2009 16:55:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761791AbZLJVzk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Dec 2009 16:55:40 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:55970 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761784AbZLJVzj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Dec 2009 16:55:39 -0500
X-Authority-Analysis: v=1.0 c=1 a=0ZecOPpkQPkA:10 a=7U3hwN5JcxgA:10 a=iTgKfAJrboIqH5JK9owA:9 a=mwqlUaMaCUiEQHaqvB8A:7 a=Xg0XYZfBeA9t_BrIvDVQouhdQ_cA:4
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Subject: Re: [PATCH 2/4] ftrace - add function_duration tracer
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, Tim Bird <tim.bird@am.sony.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Li Zefan <lizf@cn.fujitsu.com>, Thomas Gleixner <tglx@linutronix.de>,
       linux kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <20091210202317.GA6135@nowhere>
References: <4B202778.4030801@am.sony.com> <20091210070800.GB16874@elte.hu>
	 <20091210120332.GA5042@nowhere>
	 <1260455367.2146.143.camel@gandalf.stny.rr.com>
	 <20091210202317.GA6135@nowhere>
Content-Type: text/plain; charset="ISO-8859-15"
Organization: Kihon Technologies Inc.
Date: Thu, 10 Dec 2009 16:55:43 -0500
Message-ID: <1260482143.2146.224.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-12-10 at 21:23 +0100, Frederic Weisbecker wrote:
> On Thu, Dec 10, 2009 at 09:29:27AM -0500, Steven Rostedt wrote:
> > On Thu, 2009-12-10 at 13:03 +0100, Frederic Weisbecker wrote:
> > 
> > > This makes me feel I'm going to try converting the function graph tracer
> > > into an event during the next cycle. It does not mean I could make it
> > > usable as a perf event right away in the same shot that said, as you can
> > > guess this is not a trivial plug. The current perf fast path is not yet
> > > adapted for that.
> > 
> > I curious how you plan on doing this. The current event system shows one
> > event per trace point. A straight forward approach would make every
> > entry and exit of a function a trace point and that would lead to a very
> > large kernel to handle that.
> 
> 
> Oh no, I'm not planning to use tracepoints for that.

Thank goodness ;-)

> 
> 
> > Perhaps we could abstract out all entries and exits. We need to be able
> > to link to a single point (entry or exit) not all.  This also has the
> > added issue of using the ftrace infrastructure of nop the mcount call.
> > We also need a way to enable a set of functions.
> > 
> > We may be able to abstract this out, but I'm hesitant on making this the
> > only interface.
> 
> 
> Hmm, yeah. The idea was just to move the use the struct trace to struct
> trace_event. This would be about straightforward. A bit like kprobes: by
> not using the TRACE_EVENT macros (would be impossible anyway) but
> specific callbacks.

Hmm, please keep the use of struct tracer around. That is still a very
powerful utility.

> 
> It would be one event.
> 
> set_ftrace_filter and set_graph_function can still be used to further
> control dynamic patching. That's what I intended for a first conversion.
> 
> Another idea would be to abstract it through one trace event subsystem
> that has one event per function. But that sounds a bit too much in term
> of memory footprint. Also it's perhaps sufficient to abstract the
> dynamic patching, but not enough to abstract set_graph_function.

Yeah, making something store an event per function would be too much
memory consumption. We could dynamically make it perhaps, but this will
take a lot of thought.

> 
> But later on, a full trace event integration would probably imply
> dicossiating dynamic tracing from the two function tracers.
> For example if the function graph tracer asks to nop a function,
> this shouldn't be propagated to a parallel function tracer user.
> That's even worse once we get a perf integration, we can have
> multiple parallel users of the function tracer. And patching
> should probably adapt to parallel uses, maintaining a kind of
> refcounting, extending the current function hashlist we have
> for function profiling could probably help for that.

Yeah, this gets a bit complicated. The biggest issue is that the mcount
call is not C abi, so it must go through some sort of trampoline. I've
thought about making a dynamic trampoline, but again, that will start
hogging up memory, and I'm not sure it is worth it.

I gave this some thought, and the best we could do is have a ref counter
with the ftrace record itself. We need a global flag to know if all
functions need to replace a nop to trace caller, or just some. That way
we can have one tracer tracing all functions and another tracing just
some. We sorta have that today though.

Making the API to this infrastructure will also take some thought. We
currently can register a function to be called by the function tracer
(we can today register more than one). But the filtering is at a global
level. We need a way to have a tracer tell ftrace that it wants to trace
all or some functions, as well as make up its mind later. Then this
function can be called by all, or if a function in some hash table says
its OK to be called.

-- Steve


