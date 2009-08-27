Return-Path: <linux-kernel-owner+w=401wt.eu-S1752809AbZH0QEp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752809AbZH0QEp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Aug 2009 12:04:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752251AbZH0QEp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Aug 2009 12:04:45 -0400
Received: from tomts16.bellnexxia.net ([209.226.175.4]:33379 "EHLO
	tomts16-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752080AbZH0QEo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Aug 2009 12:04:44 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvQEAOdJlkpMROOX/2dsb2JhbACBU9gihBkF
Date: Thu, 27 Aug 2009 11:59:39 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Li Zefan <lizf@cn.fujitsu.com>, Peter Zijlstra <peterz@infradead.org>,
       Ingo Molnar <mingo@elte.hu>, Frederic Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] tracing/profile: Fix profile_disable vs module_unload
Message-ID: <20090827155939.GA11070@Krystal>
References: <alpine.DEB.2.00.0908261343010.11291@gandalf.stny.rr.com> <20090826180114.GA29130@Krystal> <20090826181758.GA30248@Krystal> <alpine.DEB.2.00.0908261544590.11291@gandalf.stny.rr.com> <4A95E737.5080805@cn.fujitsu.com> <alpine.DEB.2.00.0908262209460.18923@gandalf.stny.rr.com> <20090827143902.GA3552@Krystal> <alpine.DEB.2.00.0908271052370.27674@gandalf.stny.rr.com> <20090827151118.GD3552@Krystal> <alpine.DEB.2.00.0908271125030.11745@gandalf.stny.rr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.0908271125030.11745@gandalf.stny.rr.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.27.31-grsec (i686)
X-Uptime: 11:57:57 up 9 days,  2:47,  3 users,  load average: 0.80, 0.46,
	0.36
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Steven Rostedt (rostedt@goodmis.org) wrote:
> 
> On Thu, 27 Aug 2009, Mathieu Desnoyers wrote:
> 
> > * Steven Rostedt (rostedt@goodmis.org) wrote:
> > > 
> > > On Thu, 27 Aug 2009, Mathieu Desnoyers wrote:
> > > 
> > > > Looks good. Just don't forget to eventually add the "synchronize" calls
> > > > between tracepoint unregistration and the removal of their module. There
> > > > is a race condition in the way you do it currently.
> > > 
> > > I'm trying to figure out the race here. What will disappear in the 
> > > tracepoint? Could you give a brief example of the issue.
> > 
> > Sure,
> > 
> > Let's say we have a tracepoint in module instrumented.c, and a probe in
> > module probe.c. The probe is registered by module probe.c init through
> > the tracepoint infrastructure to connect to the tracepoint in
> > instrumented.c. Unregistration is done in probe.c module exit.
> > 
> > As the instrumented code get executed (let's say periodically), it calls
> > the connected probe. Preemption is disabled around the call.
> > 
> > If you unload the probe.c module, the module exit will unregister the
> > probe, but the probe code can still be in use by another CPU. You have
> > to wait for quiescent state with the tracepoint synchronize (which is
> > just a wrapper over synchronize_sched() before you are allowed to
> > complete module unload. Otherwise, you will end up reclaiming module
> > memory that is still used by probe execution.
> > 
> > A test-case for this would be to create a probe with a delay in it, and
> > an instrumented module calling the instrumentation in a loop. On a SMP
> > system, running the instrumented code and probe load/unload in loops
> > should trigger this race.
> 
> Thanks for the explanation. So let me see if I get this correct.
> 
> For this race to occur, the probe (code that hooks to the tracepoint) must 
> be in module that does not contain the tracepoint. We don't even need more 
> than one module, this could occur even with a core tracepoint. If a module 
> registers it, if it unregisters before unloading, the tracepoint may be 
> hit before the unregister and executing while the module is unloading.
> 
> I don't think we need to worry about this with the case of TRACE_EVENT and 
> ftrace.h. The reason is that the trace point and probes are always in the 
> same location. The MACROS set up the probe code with the modules. Thus, to 
> remove the module, you must also remove the tracepoint itself along with 
> the probe. If you can be executing in the probe, then you must have hit 
> the trace point. If you hit the trace point, then you are executing code 
> inside the module you are removing, which is a bug in the module code 
> itself.
> 
> Using the ftrace.h MACROS limits the use of tracepoints and this race 
> does not exist. I feel we are safe not needing to have the 
> tracepoint_synchronize_unregister within the ftrace.h code.
> 

Looks right. If you can guarantee that the probe is only called from
tracepoints located within the same module as the probe, you should be
safe without tracepoint_synchronize_unregister. It's worth adding a
comment in ftrace.h explaining that though.

Mathieu

> -- Steve
> 

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
