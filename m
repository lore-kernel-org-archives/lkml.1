Return-Path: <linux-kernel-owner+w=401wt.eu-S1757289AbYGONxt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757289AbYGONxt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 09:53:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753150AbYGONxl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 09:53:41 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:57689 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753111AbYGONxk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 09:53:40 -0400
Date: Tue, 15 Jul 2008 09:53:37 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: LKML <linux-kernel@vger.kernel.org>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>
Subject: [PATCH] ftrace: only trace preempt off with preempt tracer
Message-ID: <Pine.LNX.4.58.0807150952080.8218@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


When PREEMPT_TRACER and IRQSOFF_TRACER are both configured and irqsoff
tracer is running, the preempt_off sections might also be traced.

Thanks to Andrew Morton for pointing out my mistake of spin_lock disabling
interrupts while he was reviewing ftrace.txt. Seems that my example I used
actually hit this bug.

Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---
 kernel/trace/trace_irqsoff.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

Index: linus.git/kernel/trace/trace_irqsoff.c
===================================================================
--- linus.git.orig/kernel/trace/trace_irqsoff.c	2008-07-14 23:08:16.000000000 -0400
+++ linus.git/kernel/trace/trace_irqsoff.c	2008-07-15 00:22:59.000000000 -0400
@@ -337,12 +337,14 @@ EXPORT_SYMBOL(trace_hardirqs_off_caller)
 #ifdef CONFIG_PREEMPT_TRACER
 void trace_preempt_on(unsigned long a0, unsigned long a1)
 {
-	stop_critical_timing(a0, a1);
+	if (preempt_trace())
+		stop_critical_timing(a0, a1);
 }

 void trace_preempt_off(unsigned long a0, unsigned long a1)
 {
-	start_critical_timing(a0, a1);
+	if (preempt_trace())
+		start_critical_timing(a0, a1);
 }
 #endif /* CONFIG_PREEMPT_TRACER */


