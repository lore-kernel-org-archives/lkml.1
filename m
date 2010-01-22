Return-Path: <linux-kernel-owner+w=401wt.eu-S1752197Ab0AVEKJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752197Ab0AVEKJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jan 2010 23:10:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751211Ab0AVEKI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jan 2010 23:10:08 -0500
Received: from tomts20-srv.bellnexxia.net ([209.226.175.74]:41004 "EHLO
	tomts20-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751094Ab0AVEKH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jan 2010 23:10:07 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ar4EAPeyWEuuWOiG/2dsb2JhbACBRthChDwE
Date: Thu, 21 Jan 2010 23:09:59 -0500
From: Mathieu Desnoyers <compudj@krystal.dyndns.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>, Li Zefan <lizf@cn.fujitsu.com>,
       Lai Jiangshan <laijs@cn.fujitsu.com>,
       Masami Hiramatsu <mhiramat@redhat.com>
Subject: Re: [RFC PATCH 03/10] ftrace: Drop the ftrace_profile_enabled
	checks in tracing hot path
Message-ID: <20100122040959.GA11827@Krystal>
References: <1264122982-1553-1-git-send-regression-fweisbec@gmail.com> <1264122982-1553-4-git-send-regression-fweisbec@gmail.com> <1264125917.31321.312.camel@gandalf.stny.rr.com> <20100122022858.GA2604@Krystal> <1264129978.31321.333.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <1264129978.31321.333.camel@gandalf.stny.rr.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.27.31-grsec (i686)
X-Uptime: 23:09:23 up 36 days, 12:27,  4 users,  load average: 0.18, 0.13,
	0.09
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Steven Rostedt (rostedt@goodmis.org) wrote:
> On Thu, 2010-01-21 at 21:28 -0500, Mathieu Desnoyers wrote:
> > * Steven Rostedt (rostedt@goodmis.org) wrote:
> 
> > > Now for the reason I Cc'd Paul and Mathieu...
> > > 
> > > If we had a synchronize_sched() like function that would wait and return
> > > when all preempted tasks have been scheduled again and went to either
> > > userspace or called schedule directly, then we could actually do this.
> > > 
> > > After unregistering the function graph trace, you call this
> > > "synchronize_tasks()" and it will guarantee that all currently preempted
> > > tasks have either went to userspace or have called schedule() directly.
> > > Then it would be safe to remove this check.
> > 
> > OK, so basically you need to know when you reach a quiescent state, but
> > preemption is enabled and there is no RCU read lock taken around these
> > code paths, am I correct ?
> > 
> > With tracepoints, life is easy because I disable preemption around the
> > calls, so I can use synchronize_sched() to know when quiescent state is
> > reached.
> > 
> > I recommend looking at kernel/kprobes.c:check_safety(). It uses
> > thaw_processes() and synchronize_sched() for this purpose. Basically, it
> > rely on the "refrigeration" points to detect such quiescent state. This
> > trick should do the job for the function graph tracer too.
> > 
> > I'm adding Masami in CC. He is the one who implemented check_safety(),
> > and I remember discussing it with him in the past.
> 
> Hmm, interesting. Maybe something like that might work. But what if
> CONFIG_PREEMPT is enabled but CONFIG_FREEZER is not?

Then you may want to make the function tracer depend on CONFIG_FREEZER,
but maybe Masami has other ideas ?

Mathieu

> 
> -- Steve
> 
> 

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
