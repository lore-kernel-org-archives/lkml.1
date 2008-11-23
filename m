Return-Path: <linux-kernel-owner+w=401wt.eu-S1758045AbYKWKjZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758045AbYKWKjZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Nov 2008 05:39:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756147AbYKWKjP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Nov 2008 05:39:15 -0500
Received: from mu-out-0910.google.com ([209.85.134.187]:22511 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755883AbYKWKjO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Nov 2008 05:39:14 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references
         :mime-version:content-type:content-transfer-encoding;
        b=NdyXomdT2WvUjd6YaaVrkmEI5nG31zjFt2LROV8W83BRxHZvZ10icVbhjzBTvjJV5t
         hxSGyNKlsJ7NtpqZJakTgpLvapaaap2+aLpeO7D+KOcpnXrTMn0L3+MWma2hSNxwTvk0
         h1+KZUtKvw4MOaSabSLRc0R46myTrJzZZezXg=
From: =?utf-8?q?T=C3=B6r=C3=B6k=20Edwin?= <edwintorok@gmail.com>
To: mingo@elte.hu
Cc: srostedt@redhat.com, a.p.zijlstra@chello.nl, sandmann@daimi.au.dk,
       linux-kernel@vger.kernel.org, viro@ZenIV.linux.org.uk,
       =?utf-8?q?T=C3=B6r=C3=B6k=20Edwin?= <edwintorok@gmail.com>
Subject: [PATCH 1/3] tracing/stack-tracer: fix style issues
Date: Sun, 23 Nov 2008 12:39:06 +0200
Message-Id: <1227436748-17075-1-git-send-email-edwintorok@gmail.com>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <20081123085310.GF30453@elte.hu>
References: <20081123085310.GF30453@elte.hu> <20081123083740.GD30453@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Török Edwin <edwintorok@gmail.com>
---
 arch/x86/kernel/stacktrace.c |   51 +++++++++++++++++++++++------------------
 include/linux/stacktrace.h   |    2 +-
 kernel/trace/trace.c         |    7 ++---
 3 files changed, 33 insertions(+), 27 deletions(-)

diff --git a/arch/x86/kernel/stacktrace.c b/arch/x86/kernel/stacktrace.c
index b151530..10786af 100644
--- a/arch/x86/kernel/stacktrace.c
+++ b/arch/x86/kernel/stacktrace.c
@@ -89,7 +89,7 @@ EXPORT_SYMBOL_GPL(save_stack_trace_tsk);
 
 struct stack_frame {
 	const void __user	*next_fp;
-	unsigned long		return_address;
+	unsigned long		ret_addr;
 };
 
 static int copy_stack_frame(const void __user *fp, struct stack_frame *frame)
@@ -108,33 +108,40 @@ static int copy_stack_frame(const void __user *fp, struct stack_frame *frame)
 	return ret;
 }
 
+static inline void __save_stack_trace_user(struct stack_trace *trace)
+{
+	const struct pt_regs *regs = task_pt_regs(current);
+	const void __user *fp = (const void __user *)regs->bp;
+
+	if (trace->nr_entries < trace->max_entries)
+		trace->entries[trace->nr_entries++] = regs->ip;
+
+	while (trace->nr_entries < trace->max_entries) {
+		struct stack_frame frame;
+
+		frame.next_fp = NULL;
+		frame.ret_addr = 0;
+		if (!copy_stack_frame(fp, &frame))
+			break;
+		if ((unsigned long)fp < regs->sp)
+			break;
+		if (frame.ret_addr) {
+			trace->entries[trace->nr_entries++] =
+				frame.ret_addr;
+		}
+		if (fp == frame.next_fp)
+			break;
+		fp = frame.next_fp;
+	}
+}
+
 void save_stack_trace_user(struct stack_trace *trace)
 {
 	/*
 	 * Trace user stack if we are not a kernel thread
 	 */
 	if (current->mm) {
-		const struct pt_regs *regs = task_pt_regs(current);
-		const void __user *fp = (const void __user *)regs->bp;
-
-		if (trace->nr_entries < trace->max_entries)
-			trace->entries[trace->nr_entries++] = regs->ip;
-
-		while (trace->nr_entries < trace->max_entries) {
-			struct stack_frame frame;
-			frame.next_fp = NULL;
-			frame.return_address = 0;
-			if (!copy_stack_frame(fp, &frame))
-				break;
-			if ((unsigned long)fp < regs->sp)
-				break;
-			if (frame.return_address)
-				trace->entries[trace->nr_entries++] =
-					frame.return_address;
-			if (fp == frame.next_fp)
-				break;
-			fp = frame.next_fp;
-		}
+		__save_stack_trace_user(trace);
 	}
 	if (trace->nr_entries < trace->max_entries)
 		trace->entries[trace->nr_entries++] = ULONG_MAX;
diff --git a/include/linux/stacktrace.h b/include/linux/stacktrace.h
index 68de514..fd42d68 100644
--- a/include/linux/stacktrace.h
+++ b/include/linux/stacktrace.h
@@ -25,7 +25,7 @@ extern void save_stack_trace_user(struct stack_trace *trace);
 #else
 # define save_stack_trace(trace)			do { } while (0)
 # define save_stack_trace_tsk(tsk, trace)		do { } while (0)
-# define save_stack_trace_user(trace)              do { } while (0)
+# define save_stack_trace_user(trace)			do { } while (0)
 # define print_stack_trace(trace, spaces)		do { } while (0)
 #endif
 
diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 62776b7..dedf35f 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -948,9 +948,9 @@ static void ftrace_trace_userstack(struct trace_array *tr,
 		   struct trace_array_cpu *data,
 		   unsigned long flags, int pc)
 {
+	struct ring_buffer_event *event;
 	struct userstack_entry *entry;
 	struct stack_trace trace;
-	struct ring_buffer_event *event;
 	unsigned long irq_flags;
 
 	if (!(trace_flags & TRACE_ITER_USERSTACKTRACE))
@@ -1471,8 +1471,7 @@ static inline int seq_print_user_ip(struct trace_seq *s, struct mm_struct *mm,
 	if (file) {
 		ret = trace_seq_path(s, &file->f_path);
 		if (ret)
-			ret = trace_seq_printf(s, "[+0x%lx]",
-					ip - vmstart);
+			ret = trace_seq_printf(s, "[+0x%lx]", ip - vmstart);
 	}
 	if (ret && ((sym_flags & TRACE_ITER_SYM_ADDR) || !file))
 		ret = trace_seq_printf(s, " <" IP_FMT ">", ip);
@@ -1485,7 +1484,7 @@ seq_print_userip_objs(const struct userstack_entry *entry, struct trace_seq *s,
 {
 	struct mm_struct *mm = NULL;
 	int ret = 1;
-	unsigned i;
+	unsigned int i;
 
 	if (trace_flags & TRACE_ITER_SYM_USEROBJ) {
 		struct task_struct *task;
-- 
1.5.6.5

