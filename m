Return-Path: <linux-kernel-owner+w=401wt.eu-S1753218AbZLaExS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753218AbZLaExS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Dec 2009 23:53:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753192AbZLaExO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Dec 2009 23:53:14 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:43294 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752958AbZLaExJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Dec 2009 23:53:09 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=o3XaRyxTlR3WJVl1RZqA7MBJSvlXqd9TyXZPP7gjjZW6a6htaPaP7EUYx1P4lTOJXA
         AnUGxD0p8amnxCL971xMO7bFl7xAhbEO+jD1JW4v0Eh6b9dfU64M+6q2YBszJUCaNm0u
         O2Z7P9VAYMDzDSZCyunmnzbb4S/OqdRgpkElI=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Paul Mackerras <paulus@samba.org>
Subject: [PATCH 2/2] perf: Drop useless check for ignored frame
Date: Thu, 31 Dec 2009 05:53:03 +0100
Message-Id: <1262235183-5320-2-git-send-regression-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
In-Reply-To: <1262235183-5320-1-git-send-regression-fweisbec@gmail.com>
References: <1262235183-5320-1-git-send-regression-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The check that ignores the debug and nmi stack frames is useless
now that we have a frame pointer that makes us start at the right
place. We don't anymore have to deal with these.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Paul Mackerras <paulus@samba.org>
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
-- 
1.6.2.3

