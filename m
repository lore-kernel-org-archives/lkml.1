Return-Path: <linux-kernel-owner+w=401wt.eu-S1757641AbYFLRk7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757641AbYFLRk7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2008 13:40:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753662AbYFLRkv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jun 2008 13:40:51 -0400
Received: from mx1.redhat.com ([66.187.233.31]:55515 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753630AbYFLRku (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2008 13:40:50 -0400
Date: Thu, 12 Jun 2008 13:38:58 -0400
From: "Frank Ch. Eigler" <fche@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Hideo AOKI <haoki@redhat.com>, mingo@elte.hu,
       Masami Hiramatsu <mhiramat@redhat.com>, linux-kernel@vger.kernel.org,
       Steven Rostedt <rostedt@goodmis.org>
Subject: Re: Kernel marker has no performance impact on ia64.
Message-ID: <20080612173858.GA22454@redhat.com>
References: <48447052.3030300@redhat.com> <1212445965.6269.22.camel@lappy.programming.kicks-ass.net> <20080602232135.GA20173@Krystal> <1212618449.19205.35.camel@lappy.programming.kicks-ass.net> <20080604232241.GA8488@Krystal> <1212653539.19205.47.camel@lappy.programming.kicks-ass.net> <20080612135319.GB22348@Krystal> <1213280823.31518.114.camel@twins> <20080612155332.GA16658@redhat.com> <1213289621.31518.128.camel@twins>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1213289621.31518.128.camel@twins>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi -

On Thu, Jun 12, 2008 at 06:53:41PM +0200, Peter Zijlstra wrote:
> [...]
> > Think this through.  How should systemtap (or another user-space
> > separate-compiled tool like lttng) do this exactly?
> 
> lttng has trace handlers to write data into some buffer, right?
> The trace point need not be concerned with which data, nor into what
> buffer.

The "which data" is definitely a trace point concern.  It communicates
from the developer to users as to what values are likely to be of
interest.


> > (a) rely on debugging information?  Even assuming we could get proper
> >     anchors (PC addresses or unambiguous type names) to start
> >     searching dwarf data, we lose a key attractions of markers: that
> >     it can robustly transfer data *without* dwarf data kept around.
> 
> Perhaps you can ship a reduced set of dwarf info [...]

"I" don't ship or generate dwarf data.  Distributors do.


> > (b) rely on hand-written C code (prototypes, pointer derefrencing
> >     wrappers) distributed with systemtap?  Not only would this be a
> >     brittle maintenance pain in the form of cude duplication, but then
> >     errors in it couldn't even be detected until the final C
> >     compilation stage.  That would make a lousy user experience.
>
> Not really sure what you mean here - I throught compile time errors
> were the goal?!

For us, it's too late.  In systemtap, we try to give people useful
information when they make mistakes.  For probes of whatever sort, we
want to know the available data types and names, while just starting
to process their script, so that we can check types and suggest
alternatives.  C code compilation is quite some way removed and is
supposed to be a systemtap internal implementation detail.


> > (c) have systemtap try to parse the mhiramat-proposed "(struct
> >     task_struct * next, struct task_struct * prev)" format strings?
> >     Then we're asking systemtap to parse potentially general C type
> >     expressions, find the kernel headers that declare the types?
> >     Parse available subfields?  That seems too much to ask for.
> 
> tcc and sourcefs sound like way fun ;-)

Really...


> > (d) or another way?
> 
> Get your own tracer in kernel - that provides exactly what stap needs?

You are missing that (a) this is the point of markers - to allow the
the gajillion tracers a single place per event to hook through, and
(b) we would like to leave to subsystem developers and/or end-users as
to what data should be available.  We don't want to get into the
middle of it.


> > This is another reason why markers are a nice solution.  They allow
> > passing of actual useful values: not just the %p pointers but the most
> > interesting derived values (e.g., prev->pid). 
> 
> Useful to whoem? stap isn't the holy grail of tracing and certainly not
> the only consumer of trace points, so restricting the information to
> just what stap needs is actually making trace points less useful.

Only you are talking about "restricting".  I am talking about
thoughtfully *adding* simple scalar values that most tracing type
tools will generally want, so that they don't have to perform heroic
measures like ship their own dwarf subsets or parse kernel source
code.  

Which scalars?  Well, it depends on the subsystem and event, and you
can review here several discussions about specific lttng
instrumentation markers to see how they generally go.


- FChE
