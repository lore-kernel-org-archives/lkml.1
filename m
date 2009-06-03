Return-Path: <linux-kernel-owner+w=401wt.eu-S1757534AbZFCIKQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757534AbZFCIKQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jun 2009 04:10:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756193AbZFCIJ6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Jun 2009 04:09:58 -0400
Received: from mail-px0-f182.google.com ([209.85.216.182]:63414 "EHLO
	mail-px0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753458AbZFCIJ5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jun 2009 04:09:57 -0400
X-Greylist: delayed 471 seconds by postgrey-1.27 at vger.kernel.org; Wed, 03 Jun 2009 04:09:57 EDT
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=qn9xEWNdExLMKsC2HUdSqvlF0sSfpawVUnIhU95Sk5dHzWhHnsrVO7tTup5tMnPRDw
         iNz5Jex4FkjBYSoogQyGdgizorWfQdtVlb+ZgUIu6sXYNylk/S2wZB9cACe3lIFfS8U9
         Tw7dnkYR+VTfdz10HUYw/Xe/b24yFVC2MpCVc=
From: walimis <walimisdev@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 2/3] tracing/events: fix output format of kernel stack
Date: Wed,  3 Jun 2009 16:01:29 +0800
Message-Id: <1244016090-7814-2-git-send-email-walimisdev@gmail.com>
X-Mailer: git-send-email 1.6.0.3
In-Reply-To: <1244016090-7814-1-git-send-email-walimisdev@gmail.com>
References: <1244016090-7814-1-git-send-email-walimisdev@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
1.6.0.3

