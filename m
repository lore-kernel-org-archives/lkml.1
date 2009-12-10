Return-Path: <linux-kernel-owner+w=401wt.eu-S1761191AbZLJRQ2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761191AbZLJRQ2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Dec 2009 12:16:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760974AbZLJRQ0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Dec 2009 12:16:26 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:41473 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760972AbZLJRQ0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Dec 2009 12:16:26 -0500
X-Authority-Analysis: v=1.0 c=1 a=0ZecOPpkQPkA:10 a=7U3hwN5JcxgA:10 a=6rwbAIvUBEH4o4Ec5SAA:9 a=JihFW5UbCuvvXS6r4zxTohzDEqUA:4
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Subject: Re: [PATCH 2/4] ftrace - add function_duration tracer
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: Ingo Molnar <mingo@elte.hu>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Tim Bird <tim.bird@am.sony.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Li Zefan <lizf@cn.fujitsu.com>, Thomas Gleixner <tglx@linutronix.de>,
       linux kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <20091210165238.GA13775@elte.hu>
References: <4B202778.4030801@am.sony.com> <20091210070800.GB16874@elte.hu>
	 <20091210120332.GA5042@nowhere> <20091210141121.GB1436@elte.hu>
	 <1260456803.2146.167.camel@gandalf.stny.rr.com>
	 <20091210153845.GA28230@elte.hu>
	 <1260462132.2146.198.camel@gandalf.stny.rr.com>
	 <20091210165238.GA13775@elte.hu>
Content-Type: text/plain; charset="ISO-8859-15"
Organization: Kihon Technologies Inc.
Date: Thu, 10 Dec 2009 12:16:29 -0500
Message-ID: <1260465389.2146.212.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-12-10 at 17:52 +0100, Ingo Molnar wrote:

> > Note, we also need a way to "store" the max. The fly recorder method 
> > is not good enough.
> 
> Yeah. What we want in the larger scheme of things is to have operations 
> connected to events. One such operation would be "start measuring max", 
> another would be "stop measuring the max".
> 
> [ Whether the max is intrinsic to the context structure, or is perhaps 
>   some _third_ event (so the max can be recovered by observing that 
>   event) is a detail. ]
> 
> Note that other operations make sense as well, such as:
> 
>  - if event X happens then enable event Y
>  - if event X happens then disable event Y

This is exactly what I was implementing, but I got pulled off to do
other things before I completed it. The idea is to use the filtering
infrastructure to be able to start or stop other events.

> 
> A popular use of that would be to enable the function events on the 
> 'start' event of a latency measurement, and disable function events on 
> the 'stop' event.

Function events will need to be start and stopped via a variable. It's
too much overhead and risk to do the full patching.

Code already exists that is like this. It is done in the function graph
tracer with set_graph_function, and the function tracer set_ftrace_pid.

> 
> Yet another use would be to enable cache miss events when 'entering' a 
> specific function event, and disable cache miss counting on 'exiting' 
> that function. (this would be an event of the function graph tracer)

This could tap into the "set_ftrace_filter" infrastructure. I'm not
saying that it needs to use that file. But that file supports setting
specific actions to a particular function. We could extend the interface
(if it isn't already there) to allow a perf ioctl or whatever to do the
same thing.


>  
> This would allow the precise cache miss profiling of a given function 
> and all its sub-functions - and only of that function.
> 
> Note that the existing filter engine functionality connects in a natural 
> way here as well: it can already be used to limit events and thus can be 
> used to further shape the behavior of tracing, runtime.

Yep.

> 
> Other interesting event operations are possible as well. Key is to 
> expose this via the unified interface and to stop adding new 
> functionality-limited crap via the ftrace plugin infrastructure - it's 
> clearly not suitable for this purpose. We now have found how to do these 
> things properly and cleanly.

Yes, I agree that we should not add any new plugins. But I will still
maintain the ones that are there until we have a replacement. I can
continue my work on getting the events to pass data, and also add a
kernel API to access hooks to functions.

> 
> And the thing is, _you_ implemented unified ftrace events, all i'm 
> asking you is to realize the power of them and to stop adding new 
> ftrace-plugins [which are crap in comparison] and contcentrate on 
> exposing new tracing functionality via unified ftrace events, ok? ;-)

Ah, I think we had a misunderstanding here. I was defending the current
plugins and that they still needed to be supported (I'm working on some
enhancements now). But I agree that no new plugins should be introduced,
and that work should happen on finding alternatives. But until
alternatives are ready, I'll still maintain the current plugins that are
there. If anything, they help us understand what needs to be done with
whatever replaces them.

I think you thought I was pushing to extend plugins. That wasn't my
argument. I was just arguing that the plugins still serve a purpose and
I'll support and maintain the current plugins until they become
obsolete.

-- Steve


