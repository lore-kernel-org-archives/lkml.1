Return-Path: <linux-kernel-owner+w=401wt.eu-S932526AbXF1Xju@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932526AbXF1Xju (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2007 19:39:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760105AbXF1Xjn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Jun 2007 19:39:43 -0400
Received: from ms-smtp-01.nyroc.rr.com ([24.24.2.55]:65308 "EHLO
	ms-smtp-01.nyroc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757524AbXF1Xjm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2007 19:39:42 -0400
Date: Thu, 28 Jun 2007 19:38:55 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: LKML <linux-kernel@vger.kernel.org>
cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH RT] Move RECURSION_LIMIT define up for global use.
In-Reply-To: <Pine.LNX.4.58.0706281846580.28911@gandalf.stny.rr.com>
Message-ID: <Pine.LNX.4.58.0706281936520.29589@gandalf.stny.rr.com>
References: <Pine.LNX.4.58.0706281846580.28911@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 28 Jun 2007, Steven Rostedt wrote:
>
> If one has CONFIG_PROVE_LOCKING off but CONFIG_TRACE_IRQFLAGS on, the
> RECURSION_LIMIT definition is not defined.  This patch move
> RECURSION_LIMIT up for global use.

Arg, this wasn't good enough.

Here's a better patch (drop the previous one please).

I also added a ifdef that removes a warning of unused static function.

Thanks,

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Index: linux-2.6.21.5-rt18/kernel/lockdep.c
===================================================================
--- linux-2.6.21.5-rt18.orig/kernel/lockdep.c	2007-06-28 18:36:32.000000000 -0400
+++ linux-2.6.21.5-rt18/kernel/lockdep.c	2007-06-28 19:30:43.000000000 -0400
@@ -687,6 +687,21 @@ static void print_kernel_version(void)
 		init_utsname()->version);
 }

+#if defined(CONFIG_PROVE_LOCKING) || defined(CONFIG_TRACE_IRQFLAGS)
+
+#define RECURSION_LIMIT 40
+
+static int noinline print_infinite_recursion_bug(void)
+{
+	if (!debug_locks_off_graph_unlock())
+		return 0;
+
+	WARN_ON(1);
+
+	return 0;
+}
+#endif /* CONFIG_PROVE_LOCKING || CONFIG_TRACE_IRQFLAGS */
+
 #ifdef CONFIG_PROVE_LOCKING
 /*
  * When a circular dependency is detected, print the
@@ -740,18 +755,6 @@ static noinline int print_circular_bug_t
 	return 0;
 }

-#define RECURSION_LIMIT 40
-
-static int noinline print_infinite_recursion_bug(void)
-{
-	if (!debug_locks_off_graph_unlock())
-		return 0;
-
-	WARN_ON(1);
-
-	return 0;
-}
-
 /*
  * Prove that the dependency graph starting at <entry> can not
  * lead to <target>. Print an error and return 0 if it does.
@@ -878,6 +881,7 @@ find_usage_backwards(struct lock_class *
 	return 1;
 }

+#ifdef CONFIG_PROVE_LOCKING
 static int
 print_bad_irq_dependency(struct task_struct *curr,
 			 struct held_lock *prev,
@@ -960,6 +964,7 @@ check_usage(struct task_struct *curr, st
 	return print_bad_irq_dependency(curr, prev, next,
 			bit_backwards, bit_forwards, irqclass);
 }
+#endif /* CONFIG_PROVE_LOCKING */

 #endif

