Return-Path: <linux-kernel-owner+w=401wt.eu-S1756616AbYDWUl1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756616AbYDWUl1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2008 16:41:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752966AbYDWUlU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Apr 2008 16:41:20 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:60837 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752049AbYDWUlT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2008 16:41:19 -0400
Date: Wed, 23 Apr 2008 16:41:17 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: LKML <linux-kernel@vger.kernel.org>
cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>
Subject: [PATCH] ftrace: use raw_smp_processor_id for mcount functions
Message-ID: <Pine.LNX.4.58.0804231639490.28387@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Due to debug hooks in the kernel that can change the way smp_processor_id
works, use raw_smp_processor_id in mcount called functions (namely
ftrace_record_ip). Currently we annotate most debug functions from calling
mcount, but we should not rely on that to prevent kernel lockups.

This patch uses the raw_smp_processor_id to prevent a recusive crash
that can happen if a debug hook in smp_processor_id calls mcount.

Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---
 kernel/trace/ftrace.c |   15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

Index: linux-sched-devel.git/kernel/trace/ftrace.c
===================================================================
--- linux-sched-devel.git.orig/kernel/trace/ftrace.c	2008-04-09 11:47:32.000000000 -0400
+++ linux-sched-devel.git/kernel/trace/ftrace.c	2008-04-23 16:39:05.000000000 -0400
@@ -267,6 +267,7 @@ ftrace_record_ip(unsigned long ip)
 	unsigned long key;
 	int resched;
 	int atomic;
+	int cpu;

 	if (!ftrace_enabled || ftrace_disabled)
 		return;
@@ -274,9 +275,15 @@ ftrace_record_ip(unsigned long ip)
 	resched = need_resched();
 	preempt_disable_notrace();

-	/* We simply need to protect against recursion */
-	__get_cpu_var(ftrace_shutdown_disable_cpu)++;
-	if (__get_cpu_var(ftrace_shutdown_disable_cpu) != 1)
+	/*
+	 * We simply need to protect against recursion.
+	 * Use the the raw version of smp_processor_id and not
+	 * __get_cpu_var which can call debug hooks that can
+	 * cause a recursive crash here.
+	 */
+	cpu = raw_smp_processor_id();
+	per_cpu(ftrace_shutdown_disable_cpu, cpu)++;
+	if (per_cpu(ftrace_shutdown_disable_cpu, cpu) != 1)
 		goto out;

 	if (unlikely(ftrace_record_suspend))
@@ -317,7 +324,7 @@ ftrace_record_ip(unsigned long ip)
  out_unlock:
 	spin_unlock_irqrestore(&ftrace_shutdown_lock, flags);
  out:
-	__get_cpu_var(ftrace_shutdown_disable_cpu)--;
+	per_cpu(ftrace_shutdown_disable_cpu, cpu)--;

 	/* prevent recursion with scheduler */
 	if (resched)

