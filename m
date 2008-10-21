Return-Path: <linux-kernel-owner+w=401wt.eu-S1752504AbYJUEMH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752504AbYJUEMH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2008 00:12:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750833AbYJUELz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Oct 2008 00:11:55 -0400
Received: from tomts20-srv.bellnexxia.net ([209.226.175.74]:40770 "EHLO
	tomts20-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750828AbYJUELz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2008 00:11:55 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Aq8EABLv/EhMQWQ+/2dsb2JhbACBcsFmg1A
Date: Tue, 21 Oct 2008 00:11:43 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: Lockup in tracepoint unregister in sched switch ftrace plugin
Message-ID: <20081021041143.GC24142@Krystal>
References: <alpine.DEB.1.10.0810202336560.25193@gandalf.stny.rr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.10.0810202336560.25193@gandalf.stny.rr.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 00:07:11 up 138 days,  8:47,  9 users,  load average: 0.13, 0.35,
	0.47
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Steven Rostedt (rostedt@goodmis.org) wrote:
> 
> Mathieu,
> 
> I just downloaded the latest git repo from Linus's tree, and the 
> sched_switch start up test locks up. I traced it down to the first 
> unregister of a trace point. Here's the call path that I see.
> 
> kernel/trace/trace.c: register_tracer
> kernel/trace/trace_selftest.c: trace_selftest_startup_sched_switch
> kernel/trace/trace_sched_switch.c: sched_switch_trace_ctrl_update
>    " "  : stop_sched_trace
>    " "  : tracing_stop_cmdline_record
>    " "  : tracing_stop_sched_switch
>    " "  : tracing_sched_unregister
> 
>   which calls unregister_trace_sched_switch define as macro to:
> 
> kernel/tracepoint.c: tracepoint_probe_unregister
>    " "  : remove_tracepoint
> kernel/rcupdate.c: rcu_barrier_sched
>    " "  : _rcu_barrier
> 
> where it gets stuck at that "wait_for_completion".
> 
> I'm not sure if, because this is a scheduler trace point that we are 
> hitting some kind of race that is preventing the wait_for_completion to 
> finish, or what.
> 
> I'll look more at it tomorrow.
> 

Hi Steven,

Hrm, does this selftest execute early at boot-time ? If yes, and if
classic RCUs are not up yet at that point in bootup, then using
rcu_barrier() will not work well. Another thing to look into is to make
sure tracing_sched_unregister is never called with interrupts or
preemption off.

Mathieu

> -- Steve
> 
> 

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
