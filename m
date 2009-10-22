Return-Path: <linux-kernel-owner+w=401wt.eu-S1756726AbZJVQiT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756726AbZJVQiT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Oct 2009 12:38:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756548AbZJVQiT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Oct 2009 12:38:19 -0400
Received: from nfitmail.nfit.au.dk ([130.225.31.129]:22018 "EHLO
	smtp.nfit.au.dk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754968AbZJVQiS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Oct 2009 12:38:18 -0400
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Fr??d??ric Weisbecker <fweisbec@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH] x86: Get bp from the IRQ regs instead of directly from the CPU
From: Soeren Sandmann <sandmann@daimi.au.dk>
Date: 22 Oct 2009 18:38:22 +0200
In-Reply-To: <ye8vdi7mluz.fsf@camel16.daimi.au.dk>
Message-ID: <ye8ljj3mlj5.fsf@camel16.daimi.au.dk>
User-Agent: Gnus/5.09 (Gnus v5.9.0) Emacs/21.4
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
X-NFIT-RelayAddr: 130.225.16.135
X-NFIT-Solido-Score: 0.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Passing 0 for bp causes dump_trace() to get bp directly from the
hardware register. This leads to the IRQ stack being included in the
generated call chains, which means the stack looks something like
this:

	[ ip ] [ IRQ stack ] [ rest of stack trace ]

which is incorrect and confusing to user space.

Getting bp from the IRQ regs instead makes the tracing start after the
IRQ stack:

	[ ip ] [ rest of stack trace ]

Signed-off-by: Søren Sandmann Pedersen <sandmann@redhat.com>
---
 arch/x86/kernel/cpu/perf_event.c |   10 +++++++++-
 1 files changed, 9 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
index b5801c3..39b1d0c 100644
--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -2177,10 +2177,18 @@ static const struct stacktrace_ops backtrace_ops = {
 static void
 perf_callchain_kernel(struct pt_regs *regs, struct perf_callchain_entry *entry)
 {
+	unsigned long bp;
+    
 	callchain_store(entry, PERF_CONTEXT_KERNEL);
 	callchain_store(entry, regs->ip);
 
-	dump_trace(NULL, regs, NULL, 0, &backtrace_ops, entry);
+#ifdef CONFIG_FRAME_POINTER
+	bp = regs->bp;
+#else
+	bp = 0;
+#endif
+	
+	dump_trace(NULL, regs, NULL, bp, &backtrace_ops, entry);
 }
 
 /*
-- 
1.6.5.rc2

