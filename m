Return-Path: <linux-kernel-owner+w=401wt.eu-S1755843AbZFGKWc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755843AbZFGKWc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Jun 2009 06:22:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755731AbZFGKWW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Jun 2009 06:22:22 -0400
Received: from hera.kernel.org ([140.211.167.34]:41893 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755758AbZFGKWU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Jun 2009 06:22:20 -0400
Date: Sun, 7 Jun 2009 10:21:59 GMT
From: tip-bot for walimis <walimisdev@gmail.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, walimisdev@gmail.com, hpa@zytor.com,
       mingo@redhat.com, rostedt@goodmis.org, tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, walimisdev@gmail.com,
       linux-kernel@vger.kernel.org, rostedt@goodmis.org, tglx@linutronix.de
In-Reply-To: <1244016090-7814-2-git-send-email-walimisdev@gmail.com>
References: <1244016090-7814-2-git-send-email-walimisdev@gmail.com>
Subject: [tip:tracing/core] tracing/events: fix output format of kernel stack
Message-ID: <tip-f11b3f4e2932bfdcfc458ab8d1ece62724ceabfc@git.kernel.org>
Git-Commit-ID: f11b3f4e2932bfdcfc458ab8d1ece62724ceabfc
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Sun, 07 Jun 2009 10:21:59 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  f11b3f4e2932bfdcfc458ab8d1ece62724ceabfc
Gitweb:     http://git.kernel.org/tip/f11b3f4e2932bfdcfc458ab8d1ece62724ceabfc
Author:     walimis <walimisdev@gmail.com>
AuthorDate: Wed, 3 Jun 2009 16:01:29 +0800
Committer:  Steven Rostedt <rostedt@goodmis.org>
CommitDate: Wed, 3 Jun 2009 10:25:15 -0400

tracing/events: fix output format of kernel stack

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
