Return-Path: <linux-kernel-owner+w=401wt.eu-S1751460AbZH0PLU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751460AbZH0PLU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Aug 2009 11:11:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752187AbZH0PLS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Aug 2009 11:11:18 -0400
Received: from tomts22-srv.bellnexxia.net ([209.226.175.184]:55057 "EHLO
	tomts22-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750761AbZH0PLS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Aug 2009 11:11:18 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvQEAAM9lkpMROOX/2dsb2JhbACBU9cshBkF
Date: Thu, 27 Aug 2009 11:11:18 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Li Zefan <lizf@cn.fujitsu.com>, Peter Zijlstra <peterz@infradead.org>,
       Ingo Molnar <mingo@elte.hu>, Frederic Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] tracing/profile: Fix profile_disable vs module_unload
Message-ID: <20090827151118.GD3552@Krystal>
References: <alpine.DEB.2.00.0908261012020.23885@gandalf.stny.rr.com> <20090826164624.GA21456@Krystal> <alpine.DEB.2.00.0908261343010.11291@gandalf.stny.rr.com> <20090826180114.GA29130@Krystal> <20090826181758.GA30248@Krystal> <alpine.DEB.2.00.0908261544590.11291@gandalf.stny.rr.com> <4A95E737.5080805@cn.fujitsu.com> <alpine.DEB.2.00.0908262209460.18923@gandalf.stny.rr.com> <20090827143902.GA3552@Krystal> <alpine.DEB.2.00.0908271052370.27674@gandalf.stny.rr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.0908271052370.27674@gandalf.stny.rr.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.27.31-grsec (i686)
X-Uptime: 11:02:16 up 9 days,  1:51,  2 users,  load average: 0.84, 0.41,
	0.33
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Steven Rostedt (rostedt@goodmis.org) wrote:
> 
> On Thu, 27 Aug 2009, Mathieu Desnoyers wrote:
> 
> > Looks good. Just don't forget to eventually add the "synchronize" calls
> > between tracepoint unregistration and the removal of their module. There
> > is a race condition in the way you do it currently.
> 
> I'm trying to figure out the race here. What will disappear in the 
> tracepoint? Could you give a brief example of the issue.

Sure,

Let's say we have a tracepoint in module instrumented.c, and a probe in
module probe.c. The probe is registered by module probe.c init through
the tracepoint infrastructure to connect to the tracepoint in
instrumented.c. Unregistration is done in probe.c module exit.

As the instrumented code get executed (let's say periodically), it calls
the connected probe. Preemption is disabled around the call.

If you unload the probe.c module, the module exit will unregister the
probe, but the probe code can still be in use by another CPU. You have
to wait for quiescent state with the tracepoint synchronize (which is
just a wrapper over synchronize_sched() before you are allowed to
complete module unload. Otherwise, you will end up reclaiming module
memory that is still used by probe execution.

A test-case for this would be to create a probe with a delay in it, and
an instrumented module calling the instrumentation in a loop. On a SMP
system, running the instrumented code and probe load/unload in loops
should trigger this race.

Mathieu


> 
> Thanks,
> 
> -- Steve
> 
> 

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
