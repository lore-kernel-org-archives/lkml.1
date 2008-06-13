Return-Path: <linux-kernel-owner+w=401wt.eu-S1757474AbYFMLBi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757474AbYFMLBi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2008 07:01:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753914AbYFMLB2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jun 2008 07:01:28 -0400
Received: from casper.infradead.org ([85.118.1.10]:40101 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752407AbYFMLB1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2008 07:01:27 -0400
Subject: Re: Kernel marker has no performance impact on ia64.
From: Peter Zijlstra <peterz@infradead.org>
To: "Frank Ch. Eigler" <fche@redhat.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Hideo AOKI <haoki@redhat.com>, mingo@elte.hu,
       Masami Hiramatsu <mhiramat@redhat.com>, linux-kernel@vger.kernel.org,
       Steven Rostedt <rostedt@goodmis.org>
In-Reply-To: <20080612173858.GA22454@redhat.com>
References: <48447052.3030300@redhat.com>
	 <1212445965.6269.22.camel@lappy.programming.kicks-ass.net>
	 <20080602232135.GA20173@Krystal>
	 <1212618449.19205.35.camel@lappy.programming.kicks-ass.net>
	 <20080604232241.GA8488@Krystal>
	 <1212653539.19205.47.camel@lappy.programming.kicks-ass.net>
	 <20080612135319.GB22348@Krystal> <1213280823.31518.114.camel@twins>
	 <20080612155332.GA16658@redhat.com> <1213289621.31518.128.camel@twins>
	 <20080612173858.GA22454@redhat.com>
Content-Type: text/plain
Date: Fri, 13 Jun 2008 13:01:12 +0200
Message-Id: <1213354872.31518.193.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-06-12 at 13:38 -0400, Frank Ch. Eigler wrote:
> Hi -
> 
> On Thu, Jun 12, 2008 at 06:53:41PM +0200, Peter Zijlstra wrote:
> > [...]
> > > Think this through.  How should systemtap (or another user-space
> > > separate-compiled tool like lttng) do this exactly?
> > 
> > lttng has trace handlers to write data into some buffer, right?
> > The trace point need not be concerned with which data, nor into what
> > buffer.
> 
> The "which data" is definitely a trace point concern.  It communicates
> from the developer to users as to what values are likely to be of
> interest.

But that is tracer specific - I might write a scheduler tracer that
looks at the quality of scheduling decisions and thus wants to look at
the virtual timeline variables and the scheduling class of the tasks
involved.

That's a whole different context, but the trace points are the same. Are
you saying trace points are not to allow me to do that?

> > > (a) rely on debugging information?  Even assuming we could get proper
> > >     anchors (PC addresses or unambiguous type names) to start
> > >     searching dwarf data, we lose a key attractions of markers: that
> > >     it can robustly transfer data *without* dwarf data kept around.
> > 
> > Perhaps you can ship a reduced set of dwarf info [...]
> 
> "I" don't ship or generate dwarf data.  Distributors do.

That's ignoring the point - 'someone' could generate reduced debug info
to allow you to easily get what you want.

> > > (b) rely on hand-written C code (prototypes, pointer derefrencing
> > >     wrappers) distributed with systemtap?  Not only would this be a
> > >     brittle maintenance pain in the form of cude duplication, but then
> > >     errors in it couldn't even be detected until the final C
> > >     compilation stage.  That would make a lousy user experience.
> >
> > Not really sure what you mean here - I throught compile time errors
> > were the goal?!
> 
> For us, it's too late.  In systemtap, we try to give people useful
> information when they make mistakes.  For probes of whatever sort, we
> want to know the available data types and names, while just starting
> to process their script, so that we can check types and suggest
> alternatives.  C code compilation is quite some way removed and is
> supposed to be a systemtap internal implementation detail.

Sounds like you have an incomplete Native-Interface system then. You
should be able to match a native function description back to your
script language.

> > > (c) have systemtap try to parse the mhiramat-proposed "(struct
> > >     task_struct * next, struct task_struct * prev)" format strings?
> > >     Then we're asking systemtap to parse potentially general C type
> > >     expressions, find the kernel headers that declare the types?
> > >     Parse available subfields?  That seems too much to ask for.
> > 
> > tcc and sourcefs sound like way fun ;-)
> 
> Really...

Yeah, wouldn't it be cool if the kernel came with an embedded compiler
and a filesystem that included its exact source code? Together with the
entry instrumentation site and dynamic jump patches you can do really
weird stuff... /me dreams on :-)

> > > (d) or another way?
> > 
> > Get your own tracer in kernel - that provides exactly what stap needs?
> 
> You are missing that (a) this is the point of markers - to allow the
> the gajillion tracers a single place per event to hook through, and
> (b) we would like to leave to subsystem developers and/or end-users as
> to what data should be available.  We don't want to get into the
> middle of it.

I think a) and b) contradict each other, you cannot cater for all
tracers and limit the data they can use.


