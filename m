Return-Path: <linux-kernel-owner+w=401wt.eu-S1756889AbYJQQyT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756889AbYJQQyT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2008 12:54:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754913AbYJQQyJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Oct 2008 12:54:09 -0400
Received: from tomts22.bellnexxia.net ([209.226.175.184]:64695 "EHLO
	tomts22-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754815AbYJQQyI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2008 12:54:08 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AugEADdd+EhMQWq+/2dsb2JhbACBcr8fg2w
Date: Fri, 17 Oct 2008 12:54:06 -0400
From: Mathieu Desnoyers <compudj@krystal.dyndns.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Jason Baron <jbaron@redhat.com>, linux-kernel@vger.kernel.org,
       fche@redhat.com, fweisbec@gmail.com, edwintorok@gmail.com,
       mingo@elte.hu, Steven Rostedt <rostedt@goodmis.org>
Subject: Re: tracepoints for kernel/mutex.c
Message-ID: <20081017165406.GH5696@Krystal>
References: <20081016210430.GC25738@redhat.com> <1224192879.16038.82.camel@lappy.programming.kicks-ass.net> <20081017144820.GA3167@redhat.com> <1224262119.16038.87.camel@lappy.programming.kicks-ass.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <1224262119.16038.87.camel@lappy.programming.kicks-ass.net>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 12:52:22 up 134 days, 21:32,  9 users,  load average: 1.42, 0.99,
	0.89
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Peter Zijlstra (peterz@infradead.org) wrote:
> On Fri, 2008-10-17 at 10:48 -0400, Jason Baron wrote:
> > On Thu, Oct 16, 2008 at 11:34:38PM +0200, Peter Zijlstra wrote:
> > > On Thu, 2008-10-16 at 17:04 -0400, Jason Baron wrote:
> > > 
> > > > Below are 3 tracepoints I've been playing with in kernel/mutex.c using
> > > > a SystemTap script. The idea is to detect and determine the cause of
> > > > lock contention. Currently I get the following output:
> > > > 
> > > > <contended mutex nam> <process name and pid of the contention> <time of
> > > > contention> <pid that woke me up(caused the contention?)>
> > > 
> > > > I think this approach has a number of advantages. It has low
> > > > overhead in the off case, since its based on tracepoints. It is
> > > > minimally invasive in the code path (3 tracepoints). It also allows me
> > > > to explore data structures and parts of the kernel by simply modifying
> > > > the SystemTap script. I do not need to re-compile the kernel and reboot.
> > > 
> > > *sigh* this is why I hate markers and all related things...
> > > 
> > > _IFF_ you want to place tracepoints, get them in the same place as the
> > > lock-dep/stat hooks, that way you get all the locks, not only mutexes.
> > 
> > makes sense. So we could layer lock-dep/stat on top of tracepoints? That
> > would potentially also make lock-dep/stat more dynamic.
> 
> I'm afraid that won't work. Both lockdep and lockstat rely on added data
> to the lock structure. But what you can do is expose the hooks as
> tracepoints when lockdep/lockstat is configured.
> 
> > > 
> > > This is the same reason I absolutely _hate_ Edwin's rwsem tracer.
> > > 
> > 
> > i'm trying to get some consensus on these types of patches. Do we
> > want to create a new tracer for each thing we want to trace, or add
> > tracepoints?
> 
> The only thing I'd consider is one lock-tracer that exposes all
> lockdep/lockstat hooks. Any half-assed partial solution won't fly.
> 
> > > Folks, lets please start by getting the tracing infrastructure in and
> > > those few high-level trace-points google proposed.
> > > 
> > > Until we get the basics in, I think I'm going to NAK any and all
> > > tracepoint/marker patches.
> > > 
> > 
> > I think that core locking functions are pretty basic...
> 
> For kernel developers, yes. For userspace stuff like latencytop should
> be good enough to notice something is up.
> 
> And kernel developers can recompile their kernel - that's the only way
> you're going to do anything about lock contention anyway.
> 

We also have to consider if a less specific instrumentation can extract
this kind of data. Scheduler instrumentation can do a big part of that
job, namely identifying the wakeup cause. We would not have the
information about it being mutex-related unless we activate lockdep
tracing, potentially with tracepoints in the lockdep handlers. I think
this would fly. But let's keep this for later.

Mathieu


-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
