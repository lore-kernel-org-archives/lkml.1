Return-Path: <linux-kernel-owner+w=401wt.eu-S1759854AbZCWRES@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759854AbZCWRES (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Mar 2009 13:04:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755829AbZCWREE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Mar 2009 13:04:04 -0400
Received: from tomts10.bellnexxia.net ([209.226.175.54]:41146 "EHLO
	tomts10-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753061AbZCWREB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Mar 2009 13:04:01 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApsEACtdx0lMQW1W/2dsb2JhbACBUNEzg34G
Date: Mon, 23 Mar 2009 13:03:56 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: "Frank Ch. Eigler" <fche@redhat.com>
Cc: Masami Hiramatsu <mhiramat@redhat.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Roland McGrath <roland@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>,
       Lai Jiangshan <laijs@cn.fujitsu.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Jiaying Zhang <jiayingz@google.com>, Martin Bligh <mbligh@google.com>,
       utrace-devel@redhat.com
Subject: Re: [RFC][PATCH 1/2] tracing/ftrace: syscall tracing infrastructure
Message-ID: <20090323170356.GD24084@Krystal>
References: <1236401580-5758-1-git-send-email-fweisbec@gmail.com> <1236401580-5758-2-git-send-email-fweisbec@gmail.com> <49BEAA5A.4030708@redhat.com> <20090316201526.GE8393@nowhere> <49BEB8C4.2010606@redhat.com> <20090316214526.GA15119@Krystal> <20090316221800.GE12974@redhat.com> <20090323164208.GB22501@Krystal> <20090323165242.GB18774@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20090323165242.GB18774@redhat.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 12:58:22 up 23 days, 13:24,  1 user,  load average: 0.75, 0.73,
	0.68
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Frank Ch. Eigler (fche@redhat.com) wrote:
> Hi -
> 
> On Mon, Mar 23, 2009 at 12:42:08PM -0400, Mathieu Desnoyers wrote:
> > [...]
> 
> (Please trim emails you're responding to.)
> 
> > [...]
> > > > So if the system has, say 3000 threads, then we have 3000 struct
> > > > utrace_engine created ? I wonder what effet this could have one
> > > > cachelines if this is used to trace hot paths like system call
> > > > entry/exit. Have you benchmarked this kind of scenario under tbench ?
> > > 
> > > It has not been a problem, since utrace_engines are designed to be
> > > lightweight.  Starting or stopping a systemtap script of the form
> > > 
> > >     probe process.syscall {}
> > > 
> > > appears to have no noticable impact on a tbench suite.
> > 
> > Do you mean starting this script for a single process or for _all_ the
> > processes and threads running on the system ?
> 
> The script above usually applies to all threads.
> 

Hrm, I already spent more time installing and benchmarking systemtap
than I should, so I don't have time currently to run further systemtap
benchmarks, but I seriously doubt about this. Have you run the following
benchmark ?

Baseline :
vanilla kernel, without utrace

Comparison with :
utrace-enabled kernel, with the syscall probe activated

?

If you are comparing a utrace-enabled kernel with and without the
syscall probes activated, then you are probably missing some performance
impact. Also make sure AUDIT SYSCALL, secure computing and
frame pointers are disabled in your baseline kernel too.

If this is what you did, I would really like to see the numbers.

> 
> > > > Looking at utrace_set_events(), we seem to be limited to 32 events on a
> > > > 32-bits architectures because it uses a bitmask ? Isn't it a bit small?
> > > 
> > > There are only a few types of thread events that involve different
> > > classes of treatment, or different degrees of freedom in terms of
> > > interference with the uninstrumented fast path of the threads. [...]
> > 
> > If we limit ourself to thread-interaction events, I agree that they are
> > limited. But in the system-wide tracing scenario, the criterions for
> > filtering can apply to many more event categories.
> 
> If those different criteria have equivalent impact on running threads,
> there is no need to differentiate them at the low (utrace event flag)
> level.  Could you offer an example to clarify?
> 
> 
> > Referring to Roland's reply, I think using utrace to enable
> > system-wide collection of data would just be a waste of
> > resources. Going through a more lightweight system-wide activation
> > seems more appropriate to me.  [...]
> 
> Perhaps.  OTOH it also makes sense to me to use (and improve) one
> general facility, if it can do the right thing almost as fast as a
> wholly separate facility that's specialized for one small purpose.
> The decision would probably rest with a more data-based comparison of
> performance & code size.
> 

Sure.

Mathieu

> 
> - FChE

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
