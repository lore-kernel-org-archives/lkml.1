Return-Path: <linux-kernel-owner+w=401wt.eu-S1753541AbZILOOJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753541AbZILOOJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Sep 2009 10:14:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752625AbZILOOJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Sep 2009 10:14:09 -0400
Received: from tomts10.bellnexxia.net ([209.226.175.54]:37601 "EHLO
	tomts10-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752360AbZILOOH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Sep 2009 10:14:07 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AigFAANGq0pMROOX/2dsb2JhbACBU9h5hBgF
Date: Sat, 12 Sep 2009 10:14:08 -0400
From: Mathieu Desnoyers <compudj@krystal.dyndns.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: rostedt@goodmis.org, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Li Zefan <lizf@cn.fujitsu.com>
Subject: Re: [PATCH 2/3] tracing/profile: add ref count for registering
	profile events
Message-ID: <20090912141408.GD22876@Krystal>
References: <20090911135452.866274568@goodmis.org> <20090911135626.421489476@goodmis.org> <1252677861.7126.32.camel@laptop> <1252678183.7126.34.camel@laptop> <1252679606.18996.681.camel@gandalf.stny.rr.com> <1252679849.7126.37.camel@laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <1252679849.7126.37.camel@laptop>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.27.31-grsec (i686)
X-Uptime: 09:59:10 up 25 days, 48 min,  4 users,  load average: 0.09, 0.18,
	0.16
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Peter Zijlstra (peterz@infradead.org) wrote:
> On Fri, 2009-09-11 at 10:33 -0400, Steven Rostedt wrote:
> > > Or we can go with Li's original patch, that was less ugly.
> > 
> > I can go back to Li's original patch, but the talk on that was
> > "fragile". If you no longer feel that way, then I'll use his instead.
> > 
> > For now, I'll pull out this patch altogether, and resubmit the pull
> > request without it. I'd like the other changes to not be held up by
> > this.
> 
> Right, I still think its at the wrong level,. see below.
> 
> > > 
> > > I still think tracepoints/markers should sort this out, because we now
> > > have a sematic difference between the two wrt modules.
> > 
> > I originally tried to do it in the tracepoint logic, but that broke a
> > lot of assumptions about tracepoints that Mathieu pointed out. This is
> > not a normal use of tracepoints. It is expected that if you register a
> > probe in a module, you will unregister it before exiting.
> > 
> > I can't remember all the details, but at the end, it seemed that the fix
> > belonged at the ftrace level.
> 
> Right, Mathieu thinks its sane to be able to attach to
> tracepoints/markers before they exist, so you can put them in module
> init code. I disagree.

I know we disagree on this topic, but AFAIK you did not propose any
solution to solve the problem of tracepoints in module init code. This
leaves a tracepoint user who need to trace module init with no way to do
it, because he will run in the chicken and egg problem of having to load
the module to make the tracepoint appear, but needing to trace module
load. A similar problem applies to kernel boot tracing for tracepoints
in init code of the kernel image.

Maybe you have a solution for this in mind ? Or is it simply to reduce
tracepoint instrumentation coverage to exclude init functions ? You not
caring about this use case does not mean no one care about it.

> 
> ftrace doesn't mirror this behaviour, that is the source of the problem.
> If it did the ftrace structures wouldn't go away on unload and there
> wouldn't be no crash.

Ftrace and lttng need to perform refcounting the probe module
independently of this specific behavior, because they offer an interface
located outside of tracepoint or probe module to manage the
tracepoints/probes connected. Ftrace does it in ftrace, LTTng does it
within the markers. It therefore make sense to keep a global registry of
loaded probes, and to refcount the probe module before connecting a
probe to a tracepoint. I think the solution Li proposed is good.

Thanks,

Mathieu

> 
> But if you want to maintain this disparity between the two frameworks
> then yes Li's patch, or yours (they're identical) seems the way to solve
> it.
> 
> Still think its daft though.
> 

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
