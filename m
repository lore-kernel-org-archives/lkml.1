Return-Path: <linux-kernel-owner+w=401wt.eu-S1751703AbZFOIFd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751703AbZFOIFd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jun 2009 04:05:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752257AbZFOIFS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Jun 2009 04:05:18 -0400
Received: from hera.kernel.org ([140.211.167.34]:56400 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751930AbZFOIFQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jun 2009 04:05:16 -0400
Date: Mon, 15 Jun 2009 08:03:33 GMT
From: tip-bot for Ingo Molnar <mingo@elte.hu>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, paulus@samba.org,
       hpa@zytor.com, mingo@redhat.com, a.p.zijlstra@chello.nl, efault@gmx.de,
       tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org, acme@redhat.com,
       linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl, efault@gmx.de,
       tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <new-submission>
References: <new-submission>
Subject: [tip:perfcounters/core] perf_counter, x86: Fix kernel-space call-chains
Message-ID: <tip-1f3d4ecee6fe08ca7ed1ef131a8a8903d613d730@git.kernel.org>
Git-Commit-ID: 1f3d4ecee6fe08ca7ed1ef131a8a8903d613d730
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Mon, 15 Jun 2009 08:03:34 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  1f3d4ecee6fe08ca7ed1ef131a8a8903d613d730
Gitweb:     http://git.kernel.org/tip/1f3d4ecee6fe08ca7ed1ef131a8a8903d613d730
Author:     Ingo Molnar <mingo@elte.hu>
AuthorDate: Mon, 15 Jun 2009 09:57:59 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 15 Jun 2009 09:58:00 +0200

perf_counter, x86: Fix kernel-space call-chains

Kernel-space call-chains were trimmed at the first entry because
we never processed anything beyond the first stack context.

Allow the backtrace to jump from NMI to IRQ stack then to task stack
and finally user-space stack.

Also calculate the stack and bp variables correctly so that the
stack walker does not exit early.

We can get deep traces as a result, visible in perf report -D output:

0x32af0 [0xe0]: PERF_EVENT (IP, 5): 15134: 0xffffffff815225fd period: 1
... chain: u:2, k:22, nr:24
.....  0: 0xffffffff815225fd
.....  1: 0xffffffff810ac51c
.....  2: 0xffffffff81018e29
.....  3: 0xffffffff81523939
.....  4: 0xffffffff81524b8f
.....  5: 0xffffffff81524bd9
.....  6: 0xffffffff8105e498
.....  7: 0xffffffff8152315a
.....  8: 0xffffffff81522c3a
.....  9: 0xffffffff810d9b74
..... 10: 0xffffffff810dbeec
..... 11: 0xffffffff810dc3fb

This is a 22-entries kernel-space chain.

(We still only record reliable stack entries.)

Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
LKML-Reference: <new-submission>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/x86/kernel/cpu/perf_counter.c |   22 +++++++++-------------
 1 files changed, 9 insertions(+), 13 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_counter.c b/arch/x86/kernel/cpu/perf_counter.c
index 09d8cb6..6d5e7cf 100644
--- a/arch/x86/kernel/cpu/perf_counter.c
+++ b/arch/x86/kernel/cpu/perf_counter.c
@@ -1575,8 +1575,8 @@ static void backtrace_warning(void *data, char *msg)
 
 static int backtrace_stack(void *data, char *name)
 {
-	/* Don't bother with IRQ stacks for now */
-	return -1;
+	/* Process all stacks: */
+	return 0;
 }
 
 static void backtrace_address(void *data, unsigned long addr, int reliable)
@@ -1594,6 +1594,8 @@ static const struct stacktrace_ops backtrace_ops = {
 	.address		= backtrace_address,
 };
 
+#include "../dumpstack.h"
+
 static void
 perf_callchain_kernel(struct pt_regs *regs, struct perf_callchain_entry *entry)
 {
@@ -1601,26 +1603,20 @@ perf_callchain_kernel(struct pt_regs *regs, struct perf_callchain_entry *entry)
 	char *stack;
 	int nr = entry->nr;
 
-	callchain_store(entry, instruction_pointer(regs));
+	callchain_store(entry, regs->ip);
 
 	stack = ((char *)regs + sizeof(struct pt_regs));
 #ifdef CONFIG_FRAME_POINTER
-	bp = frame_pointer(regs);
+	get_bp(bp);
 #else
 	bp = 0;
 #endif
 
-	dump_trace(NULL, regs, (void *)stack, bp, &backtrace_ops, entry);
+	dump_trace(NULL, regs, (void *)&stack, bp, &backtrace_ops, entry);
 
 	entry->kernel = entry->nr - nr;
 }
 
-
-struct stack_frame {
-	const void __user	*next_fp;
-	unsigned long		return_address;
-};
-
 static int copy_stack_frame(const void __user *fp, struct stack_frame *frame)
 {
 	int ret;
@@ -1652,7 +1648,7 @@ perf_callchain_user(struct pt_regs *regs, struct perf_callchain_entry *entry)
 	callchain_store(entry, regs->ip);
 
 	while (entry->nr < MAX_STACK_DEPTH) {
-		frame.next_fp	     = NULL;
+		frame.next_frame	     = NULL;
 		frame.return_address = 0;
 
 		if (!copy_stack_frame(fp, &frame))
@@ -1662,7 +1658,7 @@ perf_callchain_user(struct pt_regs *regs, struct perf_callchain_entry *entry)
 			break;
 
 		callchain_store(entry, frame.return_address);
-		fp = frame.next_fp;
+		fp = frame.next_frame;
 	}
 
 	entry->user = entry->nr - nr;
