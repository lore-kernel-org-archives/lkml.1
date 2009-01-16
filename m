Return-Path: <linux-kernel-owner+w=401wt.eu-S1756362AbZAPAl4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756362AbZAPAl4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2009 19:41:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754537AbZAPAlZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Jan 2009 19:41:25 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:58177 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754239AbZAPAlX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2009 19:41:23 -0500
Message-Id: <20090116004121.039250781@goodmis.org>
References: <20090116004050.273665842@goodmis.org>
User-Agent: quilt/0.46-1
Date: Thu, 15 Jan 2009 19:40:51 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Chris Mason <chris.mason@oracle.com>,
       Lai Jiangshan <laijs@cn.fujitsu.com>,
       Steven Rostedt <srostedt@redhat.com>
Subject: [PATCH 1/2] ftrace: fix trace_output
Content-Disposition: inline; filename=0001-ftrace-fix-trace_output.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lai Jiangshan <laijs@cn.fujitsu.com>

Impact: fix bug for handling partial line

trace_seq_printf(), seq_print_userip_objs(), ... return
0          -- partial line was written
other(>0)  -- success

duplicate output is also removed in trace_print_raw().

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---
 kernel/trace/trace_output.c |   65 ++++++++++++++++++++----------------------
 kernel/trace/trace_output.h |    4 +-
 2 files changed, 33 insertions(+), 36 deletions(-)

diff --git a/kernel/trace/trace_output.c b/kernel/trace/trace_output.c
index df0c25c..4e3ad36 100644
--- a/kernel/trace/trace_output.c
+++ b/kernel/trace/trace_output.c
@@ -440,9 +440,9 @@ trace_fn_raw(struct trace_seq *s, struct trace_entry *entry, int flags)
 
 	trace_assign_type(field, entry);
 
-	if (trace_seq_printf(s, "%x %x\n",
-			     field->ip,
-			     field->parent_ip))
+	if (!trace_seq_printf(s, "%x %x\n",
+			      field->ip,
+			      field->parent_ip))
 		return TRACE_TYPE_PARTIAL_LINE;
 
 	return 0;
@@ -497,14 +497,14 @@ trace_ctxwake_print(struct trace_seq *s, struct trace_entry *entry, int flags,
 	T = task_state_char(field->next_state);
 	S = task_state_char(field->prev_state);
 	comm = trace_find_cmdline(field->next_pid);
-	if (trace_seq_printf(s, " %5d:%3d:%c %s [%03d] %5d:%3d:%c %s\n",
-			     field->prev_pid,
-			     field->prev_prio,
-			     S, delim,
-			     field->next_cpu,
-			     field->next_pid,
-			     field->next_prio,
-			     T, comm))
+	if (!trace_seq_printf(s, " %5d:%3d:%c %s [%03d] %5d:%3d:%c %s\n",
+			      field->prev_pid,
+			      field->prev_prio,
+			      S, delim,
+			      field->next_cpu,
+			      field->next_pid,
+			      field->next_prio,
+			      T, comm))
 		return TRACE_TYPE_PARTIAL_LINE;
 
 	return 0;
@@ -534,14 +534,14 @@ trace_ctxwake_raw(struct trace_seq *s, struct trace_entry *entry, int flags,
 	if (!S)
 		task_state_char(field->prev_state);
 	T = task_state_char(field->next_state);
-	if (trace_seq_printf(s, "%d %d %c %d %d %d %c\n",
-			     field->prev_pid,
-			     field->prev_prio,
-			     S,
-			     field->next_cpu,
-			     field->next_pid,
-			     field->next_prio,
-			     T))
+	if (!trace_seq_printf(s, "%d %d %c %d %d %d %c\n",
+			      field->prev_pid,
+			      field->prev_prio,
+			      S,
+			      field->next_cpu,
+			      field->next_pid,
+			      field->next_prio,
+			      T))
 		return TRACE_TYPE_PARTIAL_LINE;
 
 	return 0;
@@ -639,10 +639,10 @@ trace_special_print(struct trace_seq *s, struct trace_entry *entry, int flags)
 
 	trace_assign_type(field, entry);
 
-	if (trace_seq_printf(s, "# %ld %ld %ld\n",
-			     field->arg1,
-			     field->arg2,
-			     field->arg3))
+	if (!trace_seq_printf(s, "# %ld %ld %ld\n",
+			      field->arg1,
+			      field->arg2,
+			      field->arg3))
 		return TRACE_TYPE_PARTIAL_LINE;
 
 	return 0;
@@ -697,13 +697,13 @@ trace_stack_print(struct trace_seq *s, struct trace_entry *entry, int flags)
 
 	for (i = 0; i < FTRACE_STACK_ENTRIES; i++) {
 		if (i) {
-			if (trace_seq_puts(s, " <= "))
+			if (!trace_seq_puts(s, " <= "))
 				goto partial;
 
-			if (seq_print_ip_sym(s, field->caller[i], flags))
+			if (!seq_print_ip_sym(s, field->caller[i], flags))
 				goto partial;
 		}
-		if (trace_seq_puts(s, "\n"))
+		if (!trace_seq_puts(s, "\n"))
 			goto partial;
 	}
 
@@ -731,10 +731,10 @@ trace_user_stack_print(struct trace_seq *s, struct trace_entry *entry,
 
 	trace_assign_type(field, entry);
 
-	if (seq_print_userip_objs(field, s, flags))
+	if (!seq_print_userip_objs(field, s, flags))
 		goto partial;
 
-	if (trace_seq_putc(s, '\n'))
+	if (!trace_seq_putc(s, '\n'))
 		goto partial;
 
 	return 0;
@@ -760,10 +760,10 @@ trace_print_print(struct trace_seq *s, struct trace_entry *entry, int flags)
 
 	trace_assign_type(field, entry);
 
-	if (seq_print_ip_sym(s, field->ip, flags))
+	if (!seq_print_ip_sym(s, field->ip, flags))
 		goto partial;
 
-	if (trace_seq_printf(s, ": %s", field->buf))
+	if (!trace_seq_printf(s, ": %s", field->buf))
 		goto partial;
 
 	return 0;
@@ -779,10 +779,7 @@ trace_print_raw(struct trace_seq *s, struct trace_entry *entry, int flags)
 
 	trace_assign_type(field, entry);
 
-	if (seq_print_ip_sym(s, field->ip, flags))
-		goto partial;
-
-	if (trace_seq_printf(s, "# %lx %s", field->ip, field->buf))
+	if (!trace_seq_printf(s, "# %lx %s", field->ip, field->buf))
 		goto partial;
 
 	return 0;
diff --git a/kernel/trace/trace_output.h b/kernel/trace/trace_output.h
index ecab4ea..b2c1461 100644
--- a/kernel/trace/trace_output.h
+++ b/kernel/trace/trace_output.h
@@ -45,14 +45,14 @@ trace_nop_print(struct trace_seq *s, struct trace_entry *entry, int flags);
 #define SEQ_PUT_FIELD_RET(s, x)				\
 do {							\
 	if (!trace_seq_putmem(s, &(x), sizeof(x)))	\
-		return 0;				\
+		return TRACE_TYPE_PARTIAL_LINE;		\
 } while (0)
 
 #define SEQ_PUT_HEX_FIELD_RET(s, x)			\
 do {							\
 	BUILD_BUG_ON(sizeof(x) > MAX_MEMHEX_BYTES);	\
 	if (!trace_seq_putmem_hex(s, &(x), sizeof(x)))	\
-		return 0;				\
+		return TRACE_TYPE_PARTIAL_LINE;		\
 } while (0)
 
 #endif
-- 
1.5.6.5

-- 
