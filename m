Return-Path: <linux-kernel-owner+w=401wt.eu-S1754710AbZALDHw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754710AbZALDHw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jan 2009 22:07:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753835AbZALDHT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Jan 2009 22:07:19 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:63280 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753677AbZALDHR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jan 2009 22:07:17 -0500
Message-ID: <496AB3B2.6080407@cn.fujitsu.com>
Date: Mon, 12 Jan 2009 11:06:26 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.19 (Windows/20081209)
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH -tip] ftrace: fix trace_output
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Impact: fix bug for handling partial line

trace_seq_printf(), seq_print_userip_objs(), ... return
0          -- partial line was written
other(>0)  -- success

duplicate output is also removed in trace_print_raw().

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
diff --git a/kernel/trace/trace_output.c b/kernel/trace/trace_output.c
index df0c25c..c688c16 100644
--- a/kernel/trace/trace_output.c
+++ b/kernel/trace/trace_output.c
@@ -443,9 +443,9 @@ trace_fn_raw(struct trace_seq *s, struct trace_entry *entry, int flags)
 	if (trace_seq_printf(s, "%x %x\n",
 			     field->ip,
 			     field->parent_ip))
-		return TRACE_TYPE_PARTIAL_LINE;
+		return 0;
 
-	return 0;
+	return TRACE_TYPE_PARTIAL_LINE;
 }
 
 static int
@@ -505,9 +505,9 @@ trace_ctxwake_print(struct trace_seq *s, struct trace_entry *entry, int flags,
 			     field->next_pid,
 			     field->next_prio,
 			     T, comm))
-		return TRACE_TYPE_PARTIAL_LINE;
+		return 0;
 
-	return 0;
+	return TRACE_TYPE_PARTIAL_LINE;
 }
 
 static int
@@ -542,9 +542,9 @@ trace_ctxwake_raw(struct trace_seq *s, struct trace_entry *entry, int flags,
 			     field->next_pid,
 			     field->next_prio,
 			     T))
-		return TRACE_TYPE_PARTIAL_LINE;
+		return 0;
 
-	return 0;
+	return TRACE_TYPE_PARTIAL_LINE;
 }
 
 static int
@@ -643,9 +643,9 @@ trace_special_print(struct trace_seq *s, struct trace_entry *entry, int flags)
 			     field->arg1,
 			     field->arg2,
 			     field->arg3))
-		return TRACE_TYPE_PARTIAL_LINE;
+		return 0;
 
-	return 0;
+	return TRACE_TYPE_PARTIAL_LINE;
 }
 
 static int
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




