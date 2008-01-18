Return-Path: <linux-kernel-owner+w=401wt.eu-S933002AbYARWtf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933002AbYARWtf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2008 17:49:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762987AbYARWt0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jan 2008 17:49:26 -0500
Received: from ms-smtp-05.nyroc.rr.com ([24.24.2.59]:60263 "EHLO
	ms-smtp-05.nyroc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762736AbYARWtZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2008 17:49:25 -0500
Date: Fri, 18 Jan 2008 17:49:19 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
cc: "Frank Ch. Eigler" <fche@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Christoph Hellwig <hch@infradead.org>,
       Gregory Haskins <ghaskins@novell.com>,
       Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
       Thomas Gleixner <tglx@linutronix.de>, Tim Bird <tim.bird@am.sony.com>,
       Sam Ravnborg <sam@ravnborg.org>, Steven Rostedt <srostedt@redhat.com>,
       Paul Mackerras <paulus@samba.org>, Daniel Walker <dwalker@mvista.com>
Subject: Re: [RFC PATCH 16/22 -v2] add get_monotonic_cycles
In-Reply-To: <20080118222637.GA30900@Krystal>
Message-ID: <Pine.LNX.4.58.0801181735140.13971@gandalf.stny.rr.com>
References: <20080116145604.GB31329@Krystal> <Pine.LNX.4.58.0801161003010.15758@gandalf.stny.rr.com>
 <20080116152838.GA970@Krystal> <Pine.LNX.4.58.0801161041010.15998@gandalf.stny.rr.com>
 <20080116170011.GA3651@Krystal> <Pine.LNX.4.58.0801161428180.14368@gandalf.stny.rr.com>
 <20080116201713.GA14336@Krystal> <Pine.LNX.4.58.0801171440360.28350@gandalf.stny.rr.com>
 <20080117203740.GA24397@redhat.com> <Pine.LNX.4.58.0801171555120.28350@gandalf.stny.rr.com>
 <20080118222637.GA30900@Krystal>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 18 Jan 2008, Mathieu Desnoyers wrote:
>
> But I have not seen a lot of situations where that kind of glue-code was
> needed, so I think it makes sense to keep markers simple to use and
> efficient for the common case.
>
> Then, in this glue-code, we can put trace_mark() and calls to in-kernel
> tracers.

I'm almost done with the latency tracer work, and there are only a total
of 6 hooks that I needed.

 - schedule context switch
 - try_to_wake_up
 - hard_irqs_off (which is already there for lockdep)
 - hard irqs on (also for lockdep)
 - lock_contention (already in for the lock contention code)
 - lock acquire (also in there for contention code)

With the above, we could have this (if this is what I think you are
recommending). For example in the context_switch case:

	trace_switch_to(prev, next);
	switch_to(prev, next, prev);

and in sched.h I could have:

static inline trace_switch_to(struct task_struct *prev,
			struct task_struct *next)
{
	trace_mark(kernel_schedudule,
		"prev_pid %d next_pid %d prev_state %ld",
		prev->pid, next->pid, prev->pid);

	trace_context_switch(prev, next);
}

and have the trace_context_switch code be something that is turned on with
the latency tracing utility (config option). That way production code can
keep it off.

-- Steve

