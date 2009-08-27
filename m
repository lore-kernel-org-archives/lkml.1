Return-Path: <linux-kernel-owner+w=401wt.eu-S1752645AbZH0Pvb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752645AbZH0Pvb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Aug 2009 11:51:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752035AbZH0Pva
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Aug 2009 11:51:30 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:61702 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751850AbZH0Pv3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Aug 2009 11:51:29 -0400
Date: Thu, 27 Aug 2009 11:51:29 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
cc: Li Zefan <lizf@cn.fujitsu.com>, Peter Zijlstra <peterz@infradead.org>,
       Ingo Molnar <mingo@elte.hu>, Frederic Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] tracing/profile: Fix profile_disable vs module_unload
In-Reply-To: <20090827151118.GD3552@Krystal>
Message-ID: <alpine.DEB.2.00.0908271125030.11745@gandalf.stny.rr.com>
References: <alpine.DEB.2.00.0908261012020.23885@gandalf.stny.rr.com> <20090826164624.GA21456@Krystal> <alpine.DEB.2.00.0908261343010.11291@gandalf.stny.rr.com> <20090826180114.GA29130@Krystal> <20090826181758.GA30248@Krystal> <alpine.DEB.2.00.0908261544590.11291@gandalf.stny.rr.com>
 <4A95E737.5080805@cn.fujitsu.com> <alpine.DEB.2.00.0908262209460.18923@gandalf.stny.rr.com> <20090827143902.GA3552@Krystal> <alpine.DEB.2.00.0908271052370.27674@gandalf.stny.rr.com> <20090827151118.GD3552@Krystal>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 27 Aug 2009, Mathieu Desnoyers wrote:

> * Steven Rostedt (rostedt@goodmis.org) wrote:
> > 
> > On Thu, 27 Aug 2009, Mathieu Desnoyers wrote:
> > 
> > > Looks good. Just don't forget to eventually add the "synchronize" calls
> > > between tracepoint unregistration and the removal of their module. There
> > > is a race condition in the way you do it currently.
> > 
> > I'm trying to figure out the race here. What will disappear in the 
> > tracepoint? Could you give a brief example of the issue.
> 
> Sure,
> 
> Let's say we have a tracepoint in module instrumented.c, and a probe in
> module probe.c. The probe is registered by module probe.c init through
> the tracepoint infrastructure to connect to the tracepoint in
> instrumented.c. Unregistration is done in probe.c module exit.
> 
> As the instrumented code get executed (let's say periodically), it calls
> the connected probe. Preemption is disabled around the call.
> 
> If you unload the probe.c module, the module exit will unregister the
> probe, but the probe code can still be in use by another CPU. You have
> to wait for quiescent state with the tracepoint synchronize (which is
> just a wrapper over synchronize_sched() before you are allowed to
> complete module unload. Otherwise, you will end up reclaiming module
> memory that is still used by probe execution.
> 
> A test-case for this would be to create a probe with a delay in it, and
> an instrumented module calling the instrumentation in a loop. On a SMP
> system, running the instrumented code and probe load/unload in loops
> should trigger this race.

Thanks for the explanation. So let me see if I get this correct.

For this race to occur, the probe (code that hooks to the tracepoint) must 
be in module that does not contain the tracepoint. We don't even need more 
than one module, this could occur even with a core tracepoint. If a module 
registers it, if it unregisters before unloading, the tracepoint may be 
hit before the unregister and executing while the module is unloading.

I don't think we need to worry about this with the case of TRACE_EVENT and 
ftrace.h. The reason is that the trace point and probes are always in the 
same location. The MACROS set up the probe code with the modules. Thus, to 
remove the module, you must also remove the tracepoint itself along with 
the probe. If you can be executing in the probe, then you must have hit 
the trace point. If you hit the trace point, then you are executing code 
inside the module you are removing, which is a bug in the module code 
itself.

Using the ftrace.h MACROS limits the use of tracepoints and this race 
does not exist. I feel we are safe not needing to have the 
tracepoint_synchronize_unregister within the ftrace.h code.

-- Steve

