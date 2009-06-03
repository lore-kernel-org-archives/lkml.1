Return-Path: <linux-kernel-owner+w=401wt.eu-S1757919AbZFCPS3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757919AbZFCPS3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jun 2009 11:18:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754554AbZFCPSV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Jun 2009 11:18:21 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:37103 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753885AbZFCPSU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jun 2009 11:18:20 -0400
Message-Id: <20090603151820.843681458@goodmis.org>
References: <20090603151724.144915858@goodmis.org>
User-Agent: quilt/0.46-1
Date: Wed, 03 Jun 2009 11:17:26 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       walimis <walimisdev@gmail.com>
Subject: [PATCH 2/5] tracing/events: fix output format of kernel stack
Content-Disposition: inline; filename=0002-tracing-events-fix-output-format-of-kernel-stack.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: walimis <walimisdev@gmail.com>

According to "events/ftrace/kernel_stack/format", output format of
kernel stack should use "=>" instead of "<=".

The second problem is that we shouldn't skip the first entry in the stack,
although it seems to be duplicated when used in the "function" tracer,
but events also use it. If we skip the first one, we will drop the topmost
entry of the stack.

The last problem is that if the last entry is ULONG_MAX(0xffffffff), we should
drop it, otherwise it will print a NULL name line.

before fix:

      sh-1072  [000]   26.957239: sched_process_fork: parent sh:1072 child sh:1073
      sh-1072  [000]   26.957262:
 <= syscall_call
 <=
      sh-1072  [000]   26.957744: sched_switch: task sh:1072 [120] (R) ==> sh:1073 [120]
      sh-1072  [000]   26.957752:
 <= preempt_schedule
 <= wake_up_new_task
 <= do_fork
 <= sys_clone
 <= syscall_call
 <=

After fix:

      sh-1075  [000]    39.791848: sched_process_fork: parent sh:1075  child sh:1076
      sh-1075  [000]    39.791871:
 => sys_clone
 => syscall_call
      sh-1075  [000]    39.792713: sched_switch: task sh:1075 [120] (R) ==> sh:1076 [120]
      sh-1075  [000]    39.792722:
 => schedule
 => preempt_schedule
 => wake_up_new_task
 => do_fork
 => sys_clone
 => syscall_call

Signed-off-by: walimis <walimisdev@gmail.com>
LKML-Reference: <1244016090-7814-2-git-send-email-walimisdev@gmail.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace_output.c |   14 +++++++-------
 1 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/kernel/trace/trace_output.c b/kernel/trace/trace_output.c
index 0fe3b22..64596a5 100644
--- a/kernel/trace/trace_output.c
+++ b/kernel/trace/trace_output.c
@@ -975,16 +975,16 @@ static enum print_line_t trace_stack_print(struct trace_iterator *iter,
 
 	trace_assign_type(field, iter->ent);
 
+	if (!trace_seq_puts(s, "\n"))
+		goto partial;
 	for (i = 0; i < FTRACE_STACK_ENTRIES; i++) {
-		if (!field->caller[i])
+		if (!field->caller[i] || (field->caller[i] == ULONG_MAX))
 			break;
-		if (i) {
-			if (!trace_seq_puts(s, " <= "))
-				goto partial;
+		if (!trace_seq_puts(s, " => "))
+			goto partial;
 
-			if (!seq_print_ip_sym(s, field->caller[i], flags))
-				goto partial;
-		}
+		if (!seq_print_ip_sym(s, field->caller[i], flags))
+			goto partial;
 		if (!trace_seq_puts(s, "\n"))
 			goto partial;
 	}
-- 
1.6.3.1

-- 
