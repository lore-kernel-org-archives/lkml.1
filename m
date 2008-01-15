Return-Path: <linux-kernel-owner+w=401wt.eu-S1758593AbYAOU5k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758593AbYAOU5k (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2008 15:57:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757437AbYAOUuz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jan 2008 15:50:55 -0500
Received: from ms-smtp-04.nyroc.rr.com ([24.24.2.58]:63818 "EHLO
	ms-smtp-04.nyroc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756074AbYAOUug (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2008 15:50:36 -0500
Message-Id: <20080115205026.233721830@goodmis.org>
References: <20080115204907.838227723@goodmis.org>
User-Agent: quilt/0.46-1
Date: Tue, 15 Jan 2008 15:49:33 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Christoph Hellwig <hch@infradead.org>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Gregory Haskins <ghaskins@novell.com>,
       Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
       Thomas Gleixner <tglx@linutronix.de>, Tim Bird <tim.bird@am.sony.com>,
       Sam Ravnborg <sam@ravnborg.org>, "Frank Ch. Eigler" <fche@redhat.com>,
       Jan Kiszka <jan.kiszka@siemens.com>,
       Steven Rostedt <srostedt@redhat.com>
Subject: [RFC PATCH 26/30 v3] Add context switch marker to sched.c
Content-Disposition: inline; filename=add-markers-to-sched-switch.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The trace facilities here needs a hook into the context switch events.
Since Mathieu Desnoyers has been working on markers for LTTng, I figured
I take the marker he has in his patch queue.

The thing is that he only records the prev's pid, next's pid, and prev's state.
It would suit me better if it simply passed in the prev and next pointer.
Since I don't want to add markers all over the place to get the information
that I need. The latency tracer only turns on for short periods of time
and already takes up enough memory to store the traces, I don't want to add
databases keeping track of changes such as priorities, and such, when I
could simply get that information from a context switch.

Yes, that would slow down all context switches a little when tracing is on,
but for this, it should be sufficient.

Anyway, I'm not about to start a war on this, so I simply folded and will
use Mathieu's proposed marker instead. I'm just worried that in the future
we will want more information about the processes in the context switch but
will still be stuck with just the pid's and state.

Signed-off-by: Steven Rostedt <srostedt@redhat.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
---
 kernel/sched.c |    3 +++
 1 file changed, 3 insertions(+)

Index: linux-compile.git/kernel/sched.c
===================================================================
--- linux-compile.git.orig/kernel/sched.c	2008-01-14 14:57:33.000000000 -0500
+++ linux-compile.git/kernel/sched.c	2008-01-15 00:15:45.000000000 -0500
@@ -1933,6 +1933,9 @@ context_switch(struct rq *rq, struct tas
 	struct mm_struct *mm, *oldmm;
 
 	prepare_task_switch(rq, prev, next);
+	trace_mark(kernel_sched_schedule,
+		   "prev_pid %d next_pid %d prev_state %ld",
+		   prev->pid, next->pid, prev->state);
 	mm = next->mm;
 	oldmm = prev->active_mm;
 	/*

-- 
