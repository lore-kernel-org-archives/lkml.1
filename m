Return-Path: <linux-kernel-owner+w=401wt.eu-S1756824AbZFSLxY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756824AbZFSLxY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jun 2009 07:53:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753401AbZFSLwq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Jun 2009 07:52:46 -0400
Received: from hera.kernel.org ([140.211.167.34]:46767 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753072AbZFSLwn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jun 2009 07:52:43 -0400
Date: Fri, 19 Jun 2009 11:51:52 GMT
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, paulus@samba.org,
       hpa@zytor.com, mingo@redhat.com, a.p.zijlstra@chello.nl, efault@gmx.de,
       tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org, acme@redhat.com,
       linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl, efault@gmx.de,
       tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <new-submission>
References: <new-submission>
Subject: [tip:perfcounters/core] perf_counter: Make callchain samples extensible
Message-ID: <tip-f9188e023c248d73f5b4a589b480e065c1864068@git.kernel.org>
Git-Commit-ID: f9188e023c248d73f5b4a589b480e065c1864068
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Fri, 19 Jun 2009 11:51:54 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  f9188e023c248d73f5b4a589b480e065c1864068
Gitweb:     http://git.kernel.org/tip/f9188e023c248d73f5b4a589b480e065c1864068
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Thu, 18 Jun 2009 22:20:52 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 19 Jun 2009 13:42:34 +0200

perf_counter: Make callchain samples extensible

Before exposing upstream tools to a callchain-samples ABI, tidy it
up to make it more extensible in the future:

Use markers in the IP chain to denote context, use (u64)-1..-4095 range
for these context markers because we use them for ERR_PTR(), so these
addresses are unlikely to be mapped.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
LKML-Reference: <new-submission>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/x86/kernel/cpu/perf_counter.c |   29 ++++++-----------------------
 include/linux/perf_counter.h       |   28 +++++++++++++++++-----------
 2 files changed, 23 insertions(+), 34 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_counter.c b/arch/x86/kernel/cpu/perf_counter.c
index ce1ae3f..76dfef2 100644
--- a/arch/x86/kernel/cpu/perf_counter.c
+++ b/arch/x86/kernel/cpu/perf_counter.c
@@ -1555,9 +1555,9 @@ const struct pmu *hw_perf_counter_init(struct perf_counter *counter)
  */
 
 static inline
-void callchain_store(struct perf_callchain_entry *entry, unsigned long ip)
+void callchain_store(struct perf_callchain_entry *entry, u64 ip)
 {
-	if (entry->nr < MAX_STACK_DEPTH)
+	if (entry->nr < PERF_MAX_STACK_DEPTH)
 		entry->ip[entry->nr++] = ip;
 }
 
@@ -1602,22 +1602,10 @@ static const struct stacktrace_ops backtrace_ops = {
 static void
 perf_callchain_kernel(struct pt_regs *regs, struct perf_callchain_entry *entry)
 {
-	unsigned long bp;
-	char *stack;
-	int nr = entry->nr;
-
+	callchain_store(entry, PERF_CONTEXT_KERNEL);
 	callchain_store(entry, regs->ip);
 
-	stack = ((char *)regs + sizeof(struct pt_regs));
-#ifdef CONFIG_FRAME_POINTER
-	get_bp(bp);
-#else
-	bp = 0;
-#endif
-
-	dump_trace(NULL, regs, (void *)&stack, bp, &backtrace_ops, entry);
-
-	entry->kernel = entry->nr - nr;
+	dump_trace(NULL, regs, NULL, 0, &backtrace_ops, entry);
 }
 
 /*
@@ -1669,16 +1657,16 @@ perf_callchain_user(struct pt_regs *regs, struct perf_callchain_entry *entry)
 {
 	struct stack_frame frame;
 	const void __user *fp;
-	int nr = entry->nr;
 
 	if (!user_mode(regs))
 		regs = task_pt_regs(current);
 
 	fp = (void __user *)regs->bp;
 
+	callchain_store(entry, PERF_CONTEXT_USER);
 	callchain_store(entry, regs->ip);
 
-	while (entry->nr < MAX_STACK_DEPTH) {
+	while (entry->nr < PERF_MAX_STACK_DEPTH) {
 		frame.next_frame	     = NULL;
 		frame.return_address = 0;
 
@@ -1691,8 +1679,6 @@ perf_callchain_user(struct pt_regs *regs, struct perf_callchain_entry *entry)
 		callchain_store(entry, frame.return_address);
 		fp = frame.next_frame;
 	}
-
-	entry->user = entry->nr - nr;
 }
 
 static void
@@ -1728,9 +1714,6 @@ struct perf_callchain_entry *perf_callchain(struct pt_regs *regs)
 		entry = &__get_cpu_var(irq_entry);
 
 	entry->nr = 0;
-	entry->hv = 0;
-	entry->kernel = 0;
-	entry->user = 0;
 
 	perf_do_callchain(regs, entry);
 
diff --git a/include/linux/perf_counter.h b/include/linux/perf_counter.h
index 0765e8e..e7e7e02 100644
--- a/include/linux/perf_counter.h
+++ b/include/linux/perf_counter.h
@@ -343,23 +343,22 @@ enum perf_event_type {
 	 *	{ u64			nr;
 	 *	  { u64 id, val; }	cnt[nr];  } && PERF_SAMPLE_GROUP
 	 *
-	 *	{ u16			nr,
-	 *				hv,
-	 *				kernel,
-	 *				user;
+	 *	{ u64			nr,
 	 *	  u64			ips[nr];  } && PERF_SAMPLE_CALLCHAIN
 	 * };
 	 */
 };
 
-#define MAX_STACK_DEPTH			255
+enum perf_callchain_context {
+	PERF_CONTEXT_HV			= (__u64)-32,
+	PERF_CONTEXT_KERNEL		= (__u64)-128,
+	PERF_CONTEXT_USER		= (__u64)-512,
 
-struct perf_callchain_entry {
-	__u16				nr;
-	__u16				hv;
-	__u16				kernel;
-	__u16				user;
-	__u64				ip[MAX_STACK_DEPTH];
+	PERF_CONTEXT_GUEST		= (__u64)-2048,
+	PERF_CONTEXT_GUEST_KERNEL	= (__u64)-2176,
+	PERF_CONTEXT_GUEST_USER		= (__u64)-2560,
+
+	PERF_CONTEXT_MAX		= (__u64)-4095,
 };
 
 #ifdef __KERNEL__
@@ -381,6 +380,13 @@ struct perf_callchain_entry {
 #include <linux/pid_namespace.h>
 #include <asm/atomic.h>
 
+#define PERF_MAX_STACK_DEPTH		255
+
+struct perf_callchain_entry {
+	__u64				nr;
+	__u64				ip[PERF_MAX_STACK_DEPTH];
+};
+
 struct task_struct;
 
 /**
