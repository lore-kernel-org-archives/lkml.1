Return-Path: <linux-kernel-owner+w=401wt.eu-S1758655AbYGPAXc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758655AbYGPAXc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 20:23:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758273AbYGPAWu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 20:22:50 -0400
Received: from ug-out-1314.google.com ([66.249.92.173]:8513 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758247AbYGPAWs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 20:22:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:to:subject:message-id:mime-version:content-type
         :content-disposition:user-agent:from;
        b=QzoK3gqj4Eeui7qJsZV+aLV7yT+vPyard7K0vgw2YLkIU4tnwlG2ErNcoiIWnxsim0
         I2ZyZL7y/cidWjv3PIebO7sX8eRNY5L312QJrZc4TS4ozA6doqdY0VvBjTv3yS+7mPCI
         uS2JuSNBeqgEsR32np9MZyEW81Ye0vxvAVPkA=
Date: Wed, 16 Jul 2008 02:22:31 +0200
To: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org
Subject: [PATCH 02/13] x86: add save_stack_trace_bp() for tracing from a
	specific stack frame
Message-ID: <20080716002231.GC12564@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
From: Vegard Nossum <vegard.nossum@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 05b948089c63279690712028d2d75b89385048be Mon Sep 17 00:00:00 2001
From: Vegard Nossum <vegard.nossum@gmail.com>
Date: Tue, 20 May 2008 11:15:43 +0200
Subject: [PATCH 02/13] x86: add save_stack_trace_bp() for tracing from a specific stack frame

This will help kmemcheck (and possibly other debugging tools) since we
can now simply pass regs->bp to the stack tracer instead of specifying
the number of stack frames to skip, which is unreliable if gcc decides
to inline functions, etc.

Note that this makes the API incomplete for other architectures, but I
expect that those can be updated lazily, e.g. when they need it.

Signed-off-by: Vegard Nossum <vegard.nossum@gmail.com>
---
 arch/x86/kernel/stacktrace.c |    7 +++++++
 include/linux/stacktrace.h   |    1 +
 2 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/stacktrace.c b/arch/x86/kernel/stacktrace.c
index c28c342..97202ad 100644
--- a/arch/x86/kernel/stacktrace.c
+++ b/arch/x86/kernel/stacktrace.c
@@ -75,6 +75,13 @@ void save_stack_trace(struct stack_trace *trace)
 		trace->entries[trace->nr_entries++] = ULONG_MAX;
 }
 
+void save_stack_trace_bp(struct stack_trace *trace, unsigned long bp)
+{
+	dump_trace(current, NULL, NULL, bp, &save_stack_ops, trace);
+	if (trace->nr_entries < trace->max_entries)
+		trace->entries[trace->nr_entries++] = ULONG_MAX;
+}
+
 void save_stack_trace_tsk(struct task_struct *tsk, struct stack_trace *trace)
 {
 	dump_trace(tsk, NULL, NULL, 0, &save_stack_ops_nosched, trace);
diff --git a/include/linux/stacktrace.h b/include/linux/stacktrace.h
index 5da9794..2a3cbe8 100644
--- a/include/linux/stacktrace.h
+++ b/include/linux/stacktrace.h
@@ -9,6 +9,7 @@ struct stack_trace {
 };
 
 extern void save_stack_trace(struct stack_trace *trace);
+extern void save_stack_trace_bp(struct stack_trace *trace, unsigned long bp);
 extern void save_stack_trace_tsk(struct task_struct *tsk,
 				struct stack_trace *trace);
 
-- 
1.5.5.1

