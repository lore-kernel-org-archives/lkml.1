Return-Path: <linux-kernel-owner+w=401wt.eu-S1753085AbZHZTog@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753085AbZHZTog (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Aug 2009 15:44:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753033AbZHZTof
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Aug 2009 15:44:35 -0400
Received: from tomts43.bellnexxia.net ([209.226.175.110]:51152 "EHLO
	tomts43-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753011AbZHZToe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Aug 2009 15:44:34 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Au4EAI8qlUpMROOX/2dsb2JhbACBU9dfhBoF
Date: Wed, 26 Aug 2009 15:44:32 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Steven Rostedt <rostedt@goodmis.org>, Li Zefan <lizf@cn.fujitsu.com>,
       Ingo Molnar <mingo@elte.hu>, Frederic Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] tracing/profile: Fix profile_disable vs module_unload
Message-ID: <20090826194432.GA5298@Krystal>
References: <20090825103907.GB28287@elte.hu> <1251197235.7538.1142.camel@twins> <1251211963.7538.1164.camel@twins> <4A94D3A8.1090902@cn.fujitsu.com> <1251269207.7538.1217.camel@twins> <1251270092.7538.1226.camel@twins> <4A94DFF4.5030301@cn.fujitsu.com> <alpine.DEB.2.00.0908261012020.23885@gandalf.stny.rr.com> <20090826164624.GA21456@Krystal> <1251314046.18584.38.camel@twins>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <1251314046.18584.38.camel@twins>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.27.31-grsec (i686)
X-Uptime: 15:32:53 up 8 days,  6:22,  2 users,  load average: 0.24, 0.24,
	0.26
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Peter Zijlstra (peterz@infradead.org) wrote:
> On Wed, 2009-08-26 at 12:46 -0400, Mathieu Desnoyers wrote:
> > Registering tracepoints even when no tracepoint definition is currently
> > visible is the intended allowed behavior. Let's say we need to trace
> > something happening in module init: if we disallow registering the tp
> > callback before the module is initialized, we run in a chicken and egg
> > problem.
> > 
> > So I am trying to figure out the problem source there. Is it that
> > modules containing the tp callbacks need to know if those are actually
> > connected to an instrumented module ? Or is it that the instrumented
> > module needs to know if a probe module is connected to is ? Or is it the
> > teardown of the probe module ? No refcount is needed there, because we
> > surround the probe call by preempt disable/enable, and we use
> > synchronize_sched() before removing the module which contains probe
> > callbacks.
> > 
> > Mathieu-trying-to-figure-out-what-this-whole-thread-is-about :)
> 
> OK, so the whole point seems to be that tracepoints have the funny thing
> you describe above, whereas the things ftrace makes out of TRACE_EVENT()
> get instantiated along with modules.
> 
> The reason why I rejected the initial patch (and I still think that that
> fix is at the wrong layer) is that I, as a consumer of whatever
> TRACE_EVENT() offers, should never need to consider modules.
> 

Hrm, is it just me, or include/trace/ftrace.h fails to call the
following function after tracepoint unregistration ?

/*
 * tracepoint_synchronize_unregister must be called between the last tracepoint
 * probe unregistration and the end of module exit to make sure there is no
 * caller executing a probe when it is freed.
 */
static inline void tracepoint_synchronize_unregister(void)
{
        synchronize_sched();
}

This might solve all our problems.

Basically, it does not need to be called after each individual
tracepoint unregistration, but does need to be called before removal of
the module containing the probles (e.g. in module exit()).

Mathieu

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
