Return-Path: <linux-kernel-owner+w=401wt.eu-S1756622Ab0A2CIB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756622Ab0A2CIB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jan 2010 21:08:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755044Ab0A2CH6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Jan 2010 21:07:58 -0500
Received: from fg-out-1718.google.com ([72.14.220.159]:56222 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755052Ab0A2CHQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jan 2010 21:07:16 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=LePLXXlMZCEzmvZsF0UScnPz2g/eJo85fBw3v8lyWURTqAiQobss6lli1KBz9n2THX
         ynNvxcvYbDjZt2UoNuVgN6dFzy+3nAGO867SSYsitNxPkLrlq5cXhLk6gLfVrzNEJhsX
         KKFNpAdkHP97mBa+hefQWgHngrPeOlfps3trU=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>,
       Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
       Paul Mackerras <paulus@samba.org>, Jason Baron <jbaron@redhat.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 3/5] tracing/kprobe: Cleanup unused return value of tracing functions
Date: Fri, 29 Jan 2010 03:07:07 +0100
Message-Id: <1264730829-14563-4-git-send-regression-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
In-Reply-To: <1264730829-14563-1-git-send-regression-fweisbec@gmail.com>
References: <1264730829-14563-1-git-send-regression-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>

The return values of the kprobe's tracing functions are meaningless,
lets remove these.

Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
Acked-by: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Jason Baron <jbaron@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
LKML-Reference: <4B60E9A3.2040505@cn.fujitsu.com>
[fweisbec@gmail: whitespace fixes, drop useless void returns in end
of functions]
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
---
 kernel/trace/trace_kprobe.c |   27 ++++++++++-----------------
 1 files changed, 10 insertions(+), 17 deletions(-)

diff --git a/kernel/trace/trace_kprobe.c b/kernel/trace/trace_kprobe.c
index 2e28ee3..6178abf 100644
--- a/kernel/trace/trace_kprobe.c
+++ b/kernel/trace/trace_kprobe.c
@@ -942,7 +942,7 @@ static const struct file_operations kprobe_profile_ops = {
 };
 
 /* Kprobe handler */
-static __kprobes int kprobe_trace_func(struct kprobe *kp, struct pt_regs *regs)
+static __kprobes void kprobe_trace_func(struct kprobe *kp, struct pt_regs *regs)
 {
 	struct trace_probe *tp = container_of(kp, struct trace_probe, rp.kp);
 	struct kprobe_trace_entry *entry;
@@ -962,7 +962,7 @@ static __kprobes int kprobe_trace_func(struct kprobe *kp, struct pt_regs *regs)
 	event = trace_current_buffer_lock_reserve(&buffer, call->id, size,
 						  irq_flags, pc);
 	if (!event)
-		return 0;
+		return;
 
 	entry = ring_buffer_event_data(event);
 	entry->nargs = tp->nr_args;
@@ -972,11 +972,10 @@ static __kprobes int kprobe_trace_func(struct kprobe *kp, struct pt_regs *regs)
 
 	if (!filter_current_check_discard(buffer, call, entry, event))
 		trace_nowake_buffer_unlock_commit(buffer, event, irq_flags, pc);
-	return 0;
 }
 
 /* Kretprobe handler */
-static __kprobes int kretprobe_trace_func(struct kretprobe_instance *ri,
+static __kprobes void kretprobe_trace_func(struct kretprobe_instance *ri,
 					  struct pt_regs *regs)
 {
 	struct trace_probe *tp = container_of(ri->rp, struct trace_probe, rp);
@@ -995,7 +994,7 @@ static __kprobes int kretprobe_trace_func(struct kretprobe_instance *ri,
 	event = trace_current_buffer_lock_reserve(&buffer, call->id, size,
 						  irq_flags, pc);
 	if (!event)
-		return 0;
+		return;
 
 	entry = ring_buffer_event_data(event);
 	entry->nargs = tp->nr_args;
@@ -1006,8 +1005,6 @@ static __kprobes int kretprobe_trace_func(struct kretprobe_instance *ri,
 
 	if (!filter_current_check_discard(buffer, call, entry, event))
 		trace_nowake_buffer_unlock_commit(buffer, event, irq_flags, pc);
-
-	return 0;
 }
 
 /* Event entry printers */
@@ -1237,7 +1234,7 @@ static int kretprobe_event_show_format(struct ftrace_event_call *call,
 #ifdef CONFIG_PERF_EVENTS
 
 /* Kprobe profile handler */
-static __kprobes int kprobe_profile_func(struct kprobe *kp,
+static __kprobes void kprobe_profile_func(struct kprobe *kp,
 					 struct pt_regs *regs)
 {
 	struct trace_probe *tp = container_of(kp, struct trace_probe, rp.kp);
@@ -1252,11 +1249,11 @@ static __kprobes int kprobe_profile_func(struct kprobe *kp,
 	size -= sizeof(u32);
 	if (WARN_ONCE(size > FTRACE_MAX_PROFILE_SIZE,
 		     "profile buffer not large enough"))
-		return 0;
+		return;
 
 	entry = ftrace_perf_buf_prepare(size, call->id, &rctx, &irq_flags);
 	if (!entry)
-		return 0;
+		return;
 
 	entry->nargs = tp->nr_args;
 	entry->ip = (unsigned long)kp->addr;
@@ -1264,12 +1261,10 @@ static __kprobes int kprobe_profile_func(struct kprobe *kp,
 		entry->args[i] = call_fetch(&tp->args[i].fetch, regs);
 
 	ftrace_perf_buf_submit(entry, size, rctx, entry->ip, 1, irq_flags);
-
-	return 0;
 }
 
 /* Kretprobe profile handler */
-static __kprobes int kretprobe_profile_func(struct kretprobe_instance *ri,
+static __kprobes void kretprobe_profile_func(struct kretprobe_instance *ri,
 					    struct pt_regs *regs)
 {
 	struct trace_probe *tp = container_of(ri->rp, struct trace_probe, rp);
@@ -1284,11 +1279,11 @@ static __kprobes int kretprobe_profile_func(struct kretprobe_instance *ri,
 	size -= sizeof(u32);
 	if (WARN_ONCE(size > FTRACE_MAX_PROFILE_SIZE,
 		     "profile buffer not large enough"))
-		return 0;
+		return;
 
 	entry = ftrace_perf_buf_prepare(size, call->id, &rctx, &irq_flags);
 	if (!entry)
-		return 0;
+		return;
 
 	entry->nargs = tp->nr_args;
 	entry->func = (unsigned long)tp->rp.kp.addr;
@@ -1297,8 +1292,6 @@ static __kprobes int kretprobe_profile_func(struct kretprobe_instance *ri,
 		entry->args[i] = call_fetch(&tp->args[i].fetch, regs);
 
 	ftrace_perf_buf_submit(entry, size, rctx, entry->ret_ip, 1, irq_flags);
-
-	return 0;
 }
 
 static int probe_profile_enable(struct ftrace_event_call *call)
-- 
1.6.2.3

