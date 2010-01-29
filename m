Return-Path: <linux-kernel-owner+w=401wt.eu-S1755478Ab0A2J0A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755478Ab0A2J0A (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jan 2010 04:26:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754467Ab0A2JZ7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jan 2010 04:25:59 -0500
Received: from hera.kernel.org ([140.211.167.34]:50601 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754433Ab0A2JZ6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jan 2010 04:25:58 -0500
Date: Fri, 29 Jan 2010 09:24:54 GMT
From: tip-bot for Anton Blanchard <anton@samba.org>
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, anton@samba.org,
       hpa@zytor.com, mingo@redhat.com, a.p.zijlstra@chello.nl,
       lethal@linux-sh.org, fweisbec@gmail.com, benh@kernel.crashing.org,
       tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, anton@samba.org, paulus@samba.org,
       linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
       lethal@linux-sh.org, fweisbec@gmail.com, benh@kernel.crashing.org,
       tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20100118054707.GT12666@kryten>
References: <20100118054707.GT12666@kryten>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf: Fix inconsistency between IP and callchain sampling
Message-ID: <tip-339ce1a4dc2ca26444c4f65c31b71a5056f3bb0b@git.kernel.org>
Git-Commit-ID: 339ce1a4dc2ca26444c4f65c31b71a5056f3bb0b
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 29 Jan 2010 09:24:56 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  339ce1a4dc2ca26444c4f65c31b71a5056f3bb0b
Gitweb:     http://git.kernel.org/tip/339ce1a4dc2ca26444c4f65c31b71a5056f3bb0b
Author:     Anton Blanchard <anton@samba.org>
AuthorDate: Mon, 18 Jan 2010 16:47:07 +1100
Committer:  Frederic Weisbecker <fweisbec@gmail.com>
CommitDate: Thu, 28 Jan 2010 14:31:20 +0100

perf: Fix inconsistency between IP and callchain sampling

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

Idle task's exclusion must be performed from the core code, on top
of perf_event_attr:exclude_idle.

Signed-off-by: Anton Blanchard <anton@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mundt <lethal@linux-sh.org>
LKML-Reference: <20100118054707.GT12666@kryten>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
---
 arch/powerpc/kernel/perf_callchain.c |    3 ---
 arch/sh/kernel/perf_callchain.c      |    3 ---
 arch/x86/kernel/cpu/perf_event.c     |    3 ---
 3 files changed, 0 insertions(+), 9 deletions(-)

diff --git a/arch/powerpc/kernel/perf_callchain.c b/arch/powerpc/kernel/perf_callchain.c
index a3c11ca..95ad9da 100644
--- a/arch/powerpc/kernel/perf_callchain.c
+++ b/arch/powerpc/kernel/perf_callchain.c
@@ -495,9 +495,6 @@ struct perf_callchain_entry *perf_callchain(struct pt_regs *regs)
 
 	entry->nr = 0;
 
-	if (current->pid == 0)		/* idle task? */
-		return entry;
-
 	if (!user_mode(regs)) {
 		perf_callchain_kernel(regs, entry);
 		if (current->mm)
diff --git a/arch/sh/kernel/perf_callchain.c b/arch/sh/kernel/perf_callchain.c
index 24ea837..a9dd3ab 100644
--- a/arch/sh/kernel/perf_callchain.c
+++ b/arch/sh/kernel/perf_callchain.c
@@ -68,9 +68,6 @@ perf_do_callchain(struct pt_regs *regs, struct perf_callchain_entry *entry)
 
 	is_user = user_mode(regs);
 
-	if (!current || current->pid == 0)
-		return;
-
 	if (is_user && current->state != TASK_RUNNING)
 		return;
 
diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
index b1bb8c5..ed1998b 100644
--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -2425,9 +2425,6 @@ perf_do_callchain(struct pt_regs *regs, struct perf_callchain_entry *entry)
 
 	is_user = user_mode(regs);
 
-	if (!current || current->pid == 0)
-		return;
-
 	if (is_user && current->state != TASK_RUNNING)
 		return;
 
