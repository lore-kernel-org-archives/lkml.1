Return-Path: <linux-kernel-owner+w=401wt.eu-S1756776AbYJGBYa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756776AbYJGBYa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2008 21:24:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753569AbYJGBYV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Oct 2008 21:24:21 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:37755 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754302AbYJGBYV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2008 21:24:21 -0400
Date: Mon, 6 Oct 2008 21:24:18 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: LKML <linux-kernel@vger.kernel.org>
cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH] ftrace: stack tracer only record when on stack
Message-ID: <alpine.DEB.1.10.0810062122420.19491@gandalf.stny.rr.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


The stack trace API does not record if the stack is not on the current
task's stack. That is, if the stack is the interrupt stack or NMI stack,
the output does not show. Also, the size of those stacks are not
consistent with the size of the thread stack, this makes the calculation
of the stack size usually bogus.

This all confuses the stack tracer. I unfortunately do not have time to
fix all these problems, but this patch does record the worst stack when
the stack pointer is on the tasks stack (instead of bogus numbers).

The patch simply returns if the stack pointer is not on the task's stack.

Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---
 kernel/trace/trace_stack.c |    4 ++++
 1 file changed, 4 insertions(+)

Index: linux-tip.git/kernel/trace/trace_stack.c
===================================================================
--- linux-tip.git.orig/kernel/trace/trace_stack.c	2008-10-04 00:42:31.000000000 -0400
+++ linux-tip.git/kernel/trace/trace_stack.c	2008-10-06 21:06:20.000000000 -0400
@@ -44,6 +44,10 @@ static inline void check_stack(void)
 	if (this_size <= max_stack_size)
 		return;
 
+	/* we do not handle interrupt stacks yet */
+	if (!object_is_on_stack(&this_size))
+		return;
+
 	raw_local_irq_save(flags);
 	__raw_spin_lock(&max_stack_lock);
 

