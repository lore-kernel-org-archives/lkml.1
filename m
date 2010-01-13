Return-Path: <linux-kernel-owner+w=401wt.eu-S1755573Ab0AMKcI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755573Ab0AMKcI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jan 2010 05:32:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754967Ab0AMKcB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jan 2010 05:32:01 -0500
Received: from hera.kernel.org ([140.211.167.34]:34306 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754951Ab0AMKb6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jan 2010 05:31:58 -0500
Date: Wed, 13 Jan 2010 10:31:37 GMT
From: tip-bot for Frederic Weisbecker <fweisbec@gmail.com>
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, acme@redhat.com,
       hpa@zytor.com, mingo@redhat.com, peterz@infradead.org,
       fweisbec@gmail.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
       linux-kernel@vger.kernel.org, fweisbec@gmail.com, peterz@infradead.org,
       tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1262235183-5320-2-git-send-regression-fweisbec@gmail.com>
References: <1262235183-5320-2-git-send-regression-fweisbec@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf: Drop useless check for ignored frame
Message-ID: <tip-0fb8ee48d9dfff6a0913ceb0be2068d8be203763@git.kernel.org>
Git-Commit-ID: 0fb8ee48d9dfff6a0913ceb0be2068d8be203763
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 13 Jan 2010 10:31:37 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  0fb8ee48d9dfff6a0913ceb0be2068d8be203763
Gitweb:     http://git.kernel.org/tip/0fb8ee48d9dfff6a0913ceb0be2068d8be203763
Author:     Frederic Weisbecker <fweisbec@gmail.com>
AuthorDate: Thu, 31 Dec 2009 05:53:03 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 13 Jan 2010 10:09:08 +0100

perf: Drop useless check for ignored frame

The check that ignores the debug and nmi stack frames is useless
now that we have a frame pointer that makes us start at the
right place. We don't anymore have to deal with these.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Paul Mackerras <paulus@samba.org>
LKML-Reference: <1262235183-5320-2-git-send-regression-fweisbec@gmail.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/include/asm/stacktrace.h |    2 --
 arch/x86/kernel/cpu/perf_event.c  |    8 --------
 arch/x86/kernel/dumpstack_32.c    |    5 -----
 arch/x86/kernel/dumpstack_64.c    |    5 -----
 4 files changed, 0 insertions(+), 20 deletions(-)

diff --git a/arch/x86/include/asm/stacktrace.h b/arch/x86/include/asm/stacktrace.h
index 35e8912..4dab78e 100644
--- a/arch/x86/include/asm/stacktrace.h
+++ b/arch/x86/include/asm/stacktrace.h
@@ -3,8 +3,6 @@
 
 extern int kstack_depth_to_print;
 
-int x86_is_stack_id(int id, char *name);
-
 struct thread_info;
 struct stacktrace_ops;
 
diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
index d616c06..b1bb8c5 100644
--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -2297,7 +2297,6 @@ void callchain_store(struct perf_callchain_entry *entry, u64 ip)
 
 static DEFINE_PER_CPU(struct perf_callchain_entry, pmc_irq_entry);
 static DEFINE_PER_CPU(struct perf_callchain_entry, pmc_nmi_entry);
-static DEFINE_PER_CPU(int, in_ignored_frame);
 
 
 static void
@@ -2313,10 +2312,6 @@ static void backtrace_warning(void *data, char *msg)
 
 static int backtrace_stack(void *data, char *name)
 {
-	per_cpu(in_ignored_frame, smp_processor_id()) =
-			x86_is_stack_id(NMI_STACK, name) ||
-			x86_is_stack_id(DEBUG_STACK, name);
-
 	return 0;
 }
 
@@ -2324,9 +2319,6 @@ static void backtrace_address(void *data, unsigned long addr, int reliable)
 {
 	struct perf_callchain_entry *entry = data;
 
-	if (per_cpu(in_ignored_frame, smp_processor_id()))
-		return;
-
 	if (reliable)
 		callchain_store(entry, addr);
 }
diff --git a/arch/x86/kernel/dumpstack_32.c b/arch/x86/kernel/dumpstack_32.c
index ae775ca..11540a1 100644
--- a/arch/x86/kernel/dumpstack_32.c
+++ b/arch/x86/kernel/dumpstack_32.c
@@ -18,11 +18,6 @@
 
 #include "dumpstack.h"
 
-/* Just a stub for now */
-int x86_is_stack_id(int id, char *name)
-{
-	return 0;
-}
 
 void dump_trace(struct task_struct *task, struct pt_regs *regs,
 		unsigned long *stack, unsigned long bp,
diff --git a/arch/x86/kernel/dumpstack_64.c b/arch/x86/kernel/dumpstack_64.c
index 0ad9597..676bc05 100644
--- a/arch/x86/kernel/dumpstack_64.c
+++ b/arch/x86/kernel/dumpstack_64.c
@@ -33,11 +33,6 @@ static char x86_stack_ids[][8] = {
 #endif
 };
 
-int x86_is_stack_id(int id, char *name)
-{
-	return x86_stack_ids[id - 1] == name;
-}
-
 static unsigned long *in_exception_stack(unsigned cpu, unsigned long stack,
 					 unsigned *usedp, char **idp)
 {
