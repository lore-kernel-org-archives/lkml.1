Return-Path: <linux-kernel-owner+w=401wt.eu-S1755270Ab0A2CHR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755270Ab0A2CHR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jan 2010 21:07:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754972Ab0A2CHP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Jan 2010 21:07:15 -0500
Received: from mail-fx0-f215.google.com ([209.85.220.215]:53075 "EHLO
	mail-fx0-f215.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752191Ab0A2CHO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jan 2010 21:07:14 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=GDw4oRLEHxtD2Q82Xa+GN2bWkZ3Rn3RK+NnMz2drcbncz2UWPPaGxAuultBha+2as2
         8qtxQXah20u+fm8AFHOW3npC9Rx5KjASKMwsptg4z54cEAI+aNriiUncRzxP89Z1JPFz
         2apvCgx36t8LiD+fCNwEC6TEM0i+msV/hT7fU=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>, Anton Blanchard <anton@samba.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Paul Mundt <lethal@linux-sh.org>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 1/5] perf: Fix inconsistency between IP and callchain sampling
Date: Fri, 29 Jan 2010 03:07:05 +0100
Message-Id: <1264730829-14563-2-git-send-regression-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
In-Reply-To: <1264730829-14563-1-git-send-regression-fweisbec@gmail.com>
References: <1264730829-14563-1-git-send-regression-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Anton Blanchard <anton@samba.org>

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
 
-- 
1.6.2.3

