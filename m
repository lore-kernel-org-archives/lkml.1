Return-Path: <linux-kernel-owner+w=401wt.eu-S1752028Ab0ARFti@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752028Ab0ARFti (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jan 2010 00:49:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750730Ab0ARFth
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jan 2010 00:49:37 -0500
Received: from ozlabs.org ([203.10.76.45]:58668 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750714Ab0ARFtg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jan 2010 00:49:36 -0500
Date: Mon, 18 Jan 2010 16:47:07 +1100
From: Anton Blanchard <anton@samba.org>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
       Ingo Molnar <mingo@elte.hu>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Paul Mundt <lethal@linux-sh.org>,
       Frederic Weisbecker <fweisbec@gmail.com>, linux-kernel@vger.kernel.org
Subject: [PATCH] perf: Fix inconsistency between IP and callchain sampling
Message-ID: <20100118054707.GT12666@kryten>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


When running perf across all cpus with backtracing (-a -g), sometimes we
get samples without associated backtraces:

    23.44%         init  [kernel]                     [k] restore
    11.46%         init                       eeba0c  [k] 0x00000000eeba0c
     6.77%      swapper  [kernel]                     [k] .perf_ctx_adjust_freq
     5.73%         init  [kernel]                     [k] .__trace_hcall_entry
     4.69%         perf  libc-2.9.so                  [.] 0x0000000006bb8c
                       |          
                       |--11.11%-- 0xfffa941bbbc

It turns out the backtrace code has a check for the idle task and the IP
sampling does not. This creates problems when profiling an interrupt
heavy workload (in my case 10Gbit ethernet) since we get no backtraces
for interrupts received while idle (ie most of the workload).

Right now x86 and sh check that current is not NULL, which should never
happen so remove that too.

Signed-off-by: Anton Blanchard <anton@samba.org>
---

The exclusion of idle tasks should be in the common perf events code,
perhaps keying off the exclude_idle field. It should also ensure that
we weren't in an interrupt at the time.

I also notice this:

        if (is_user && current->state != TASK_RUNNING)

But I'm not exactly sure what that will catch. When would we get a userspace
sample from something that isnt running?

Index: linux.trees.git/arch/powerpc/kernel/perf_callchain.c
===================================================================
--- linux.trees.git.orig/arch/powerpc/kernel/perf_callchain.c	2010-01-18 16:10:10.000000000 +1100
+++ linux.trees.git/arch/powerpc/kernel/perf_callchain.c	2010-01-18 16:10:17.000000000 +1100
@@ -495,9 +495,6 @@ struct perf_callchain_entry *perf_callch
 
 	entry->nr = 0;
 
-	if (current->pid == 0)		/* idle task? */
-		return entry;
-
 	if (!user_mode(regs)) {
 		perf_callchain_kernel(regs, entry);
 		if (current->mm)
Index: linux.trees.git/arch/x86/kernel/cpu/perf_event.c
===================================================================
--- linux.trees.git.orig/arch/x86/kernel/cpu/perf_event.c	2010-01-18 16:10:36.000000000 +1100
+++ linux.trees.git/arch/x86/kernel/cpu/perf_event.c	2010-01-18 16:17:33.000000000 +1100
@@ -2425,9 +2425,6 @@ perf_do_callchain(struct pt_regs *regs, 
 
 	is_user = user_mode(regs);
 
-	if (!current || current->pid == 0)
-		return;
-
 	if (is_user && current->state != TASK_RUNNING)
 		return;
 
Index: linux.trees.git/arch/sh/kernel/perf_callchain.c
===================================================================
--- linux.trees.git.orig/arch/sh/kernel/perf_callchain.c	2010-01-18 16:18:24.000000000 +1100
+++ linux.trees.git/arch/sh/kernel/perf_callchain.c	2010-01-18 16:18:37.000000000 +1100
@@ -68,9 +68,6 @@ perf_do_callchain(struct pt_regs *regs, 
 
 	is_user = user_mode(regs);
 
-	if (!current || current->pid == 0)
-		return;
-
 	if (is_user && current->state != TASK_RUNNING)
 		return;
 
