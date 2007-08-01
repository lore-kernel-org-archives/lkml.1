Return-Path: <linux-kernel-owner+w=401wt.eu-S1760027AbXHAD1e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760027AbXHAD1e (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2007 23:27:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753414AbXHAD10
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Jul 2007 23:27:26 -0400
Received: from ms-smtp-02.nyroc.rr.com ([24.24.2.56]:35883 "EHLO
	ms-smtp-02.nyroc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752467AbXHAD1Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2007 23:27:25 -0400
Date: Tue, 31 Jul 2007 23:26:40 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Ingo Molnar <mingo@elte.hu>
cc: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>,
       linux-rt-users <linux-rt-users@vger.kernel.org>
Subject: [PATCH RT] Move RECURSION_LIMIT define up for more global use (take
 2)
Message-ID: <Pine.LNX.4.58.0707312315210.10742@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


OK, I sent this out once before but it must have slipped under the radar.
http://lkml.org/lkml/2007/6/28/325

My config fails miserably with lockdep:

kernel/lockdep.c: In function 'find_usage_forwards':
kernel/lockdep.c:814: error: 'RECURSION_LIMIT' undeclared (first use in
this function)
kernel/lockdep.c:814: error: (Each undeclared identifier is reported only
once
kernel/lockdep.c:814: error: for each function it appears in.)
kernel/lockdep.c:815: warning: implicit declaration of function
'print_infinite_recursion_bug'
kernel/lockdep.c: In function 'find_usage_backwards':
kernel/lockdep.c:856: error: 'RECURSION_LIMIT' undeclared (first use in
this function)
make[1]: *** [kernel/lockdep.o] Error 1

But this patch fixes it nicely.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>

Index: linux-2.6.22.1-rt9/kernel/lockdep.c
===================================================================
--- linux-2.6.22.1-rt9.orig/kernel/lockdep.c	2007-07-31 23:14:12.000000000 -0400
+++ linux-2.6.22.1-rt9/kernel/lockdep.c	2007-07-31 23:25:04.000000000 -0400
@@ -683,6 +683,21 @@ static void print_kernel_version(void)
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
@@ -736,18 +751,6 @@ static noinline int print_circular_bug_t
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
@@ -874,6 +877,7 @@ find_usage_backwards(struct lock_class *
 	return 1;
 }

+#ifdef CONFIG_PROVE_LOCKING
 static int
 print_bad_irq_dependency(struct task_struct *curr,
 			 struct held_lock *prev,
@@ -956,6 +960,7 @@ check_usage(struct task_struct *curr, st
 	return print_bad_irq_dependency(curr, prev, next,
 			bit_backwards, bit_forwards, irqclass);
 }
+#endif /* CONFIG_PROVE_LOCKING */

 #endif

