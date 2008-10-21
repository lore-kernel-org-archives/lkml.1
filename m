Return-Path: <linux-kernel-owner+w=401wt.eu-S1753208AbYJUDtA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753208AbYJUDtA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2008 23:49:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752086AbYJUDsw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Oct 2008 23:48:52 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:47580 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751946AbYJUDsv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2008 23:48:51 -0400
Date: Mon, 20 Oct 2008 23:48:48 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Lockup in tracepoint unregister in sched switch ftrace plugin
Message-ID: <alpine.DEB.1.10.0810202336560.25193@gandalf.stny.rr.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Mathieu,

I just downloaded the latest git repo from Linus's tree, and the 
sched_switch start up test locks up. I traced it down to the first 
unregister of a trace point. Here's the call path that I see.

kernel/trace/trace.c: register_tracer
kernel/trace/trace_selftest.c: trace_selftest_startup_sched_switch
kernel/trace/trace_sched_switch.c: sched_switch_trace_ctrl_update
   " "  : stop_sched_trace
   " "  : tracing_stop_cmdline_record
   " "  : tracing_stop_sched_switch
   " "  : tracing_sched_unregister

  which calls unregister_trace_sched_switch define as macro to:

kernel/tracepoint.c: tracepoint_probe_unregister
   " "  : remove_tracepoint
kernel/rcupdate.c: rcu_barrier_sched
   " "  : _rcu_barrier

where it gets stuck at that "wait_for_completion".

I'm not sure if, because this is a scheduler trace point that we are 
hitting some kind of race that is preventing the wait_for_completion to 
finish, or what.

I'll look more at it tomorrow.

-- Steve


