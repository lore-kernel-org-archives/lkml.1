Return-Path: <linux-kernel-owner+w=401wt.eu-S1764718AbYETJ2Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764718AbYETJ2Y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 05:28:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755414AbYETJ2L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 05:28:11 -0400
Received: from nf-out-0910.google.com ([64.233.182.185]:22339 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758971AbYETJ2K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 05:28:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:to:cc:subject:message-id:mime-version:content-type:content-disposition:user-agent:from;
        b=GrHqC3/tALb0fh3zaJ6QwA9upCcjdGPhDG8FcNRsUiPBXO/bO8bY7XRaTjcvvRigeQTuulXESYMt2Btp4lHMv8rcW+9iGVE6ynzxLpVpAOvjztbzxp97SepY7w37/CcqLwXszARAT1EgAcgXPHrWtj/8T9UWZvs8G4Xt7dAogYI=
Date: Tue, 20 May 2008 11:28:03 +0200
To: Ingo Molnar <mingo@elte.hu>
Cc: Arjan van de Ven <arjan@linux.intel.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>, linux-kernel@vger.kernel.org
Subject: [PATCH] x86: add save_stack_trace_bp() for tracing from a specific
	stack frame
Message-ID: <20080520092803.GA6893@damson.getinternet.no>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
From: Vegard Nossum <vegard.nossum@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

I'll put this at the front of the kmemcheck queue. Looks ok?

Vegard


>From 03c790cd13efc34c26b9866db46e501dc645faf8 Mon Sep 17 00:00:00 2001
From: Vegard Nossum <vegard.nossum@gmail.com>
Date: Tue, 20 May 2008 11:15:43 +0200
Subject: [PATCH] x86: add save_stack_trace_bp() for tracing from a specific stack frame

This will help kmemcheck (and possibly other debugging tools) since we
can now simply pass regs->bp to the stack tracer instead of specifying
the number of stack frames to skip, which is unreliable if gcc decides
to inline functions, etc.

Note that this makes the API incomplete for other architectures, but I
expect that those can be updated lazily, e.g. when they need it.

Cc: Arjan van de Ven <arjan@linux.intel.com>
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
1.5.4.1

