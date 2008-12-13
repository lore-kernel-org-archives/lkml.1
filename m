Return-Path: <linux-kernel-owner+w=401wt.eu-S1752672AbYLMTSq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752672AbYLMTSq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Dec 2008 14:18:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751992AbYLMTSc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Dec 2008 14:18:32 -0500
Received: from mail-bw0-f21.google.com ([209.85.218.21]:60494 "EHLO
	mail-bw0-f21.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751753AbYLMTSU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Dec 2008 14:18:20 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :content-type:content-transfer-encoding;
        b=b7qdl36nsBcoXXjn8iqowtT8oe+wCTgZjv2xDbHI3eOawBLUKIB13r4y2FjqBui38C
         6yrMd/wVyEprCW18iZMsdN3a7HF14fFmLVmJ/Y2K5d7z/27Ax5fDgFloTxVXHezossTH
         iNQ3QMn83ilQQiVTf2hQwtz6ra3LuzDMof+4o=
Message-ID: <49440A75.301@gmail.com>
Date: Sat, 13 Dec 2008 20:18:13 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
User-Agent: Thunderbird 2.0.0.18 (X11/20081125)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Steven Rostedt <rostedt@goodmis.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] tracing/ftrace: add the printk-msg-only option
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: display ftrace_printk messages "as is"

By default, ftrace_printk() messages find their output with some other
informations like pid, caller, ...
Sometimes a developer just want to have the ftrace_printk left "as is", without
other information.

This is done by providing a default-off option called printk-msg-only.
To enable it, just do `echo printk-msg-only > /debugfs/tracing/trace_options`

Before the patch:

           <...>-2739  [000]   145.692153: __might_sleep: I'm an ftrace_printk msg in __might_sleep
           <...>-2739  [000]   145.692155: __might_sleep: I'm another ftrace_printk msg in __might_sleep

After the patch and the printk-msg-only option enabled:

I'm an ftrace_printk msg in __might_sleep
I'm another ftrace_printk msg in __might_sleep

Cc: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
---
diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 8fd3c5a..cd4dbf2 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -287,6 +287,7 @@ static const char *trace_options[] = {
 	"annotate",
 	"userstacktrace",
 	"sym-userobj",
+	"printk-msg-only",
 	NULL
 };
 
@@ -2265,6 +2266,25 @@ static enum print_line_t print_hex_fmt(struct trace_iterator *iter)
 	return TRACE_TYPE_HANDLED;
 }
 
+static enum print_line_t print_printk_msg_only(struct trace_iterator *iter)
+{
+	struct trace_seq *s = &iter->seq;
+	struct trace_entry *entry = iter->ent;
+	struct print_entry *field;
+	int ret;
+
+	trace_assign_type(field, entry);
+
+	ret = trace_seq_printf(s, field->buf);
+	if (!ret)
+		return TRACE_TYPE_PARTIAL_LINE;
+
+	if (entry->flags & TRACE_FLAG_CONT)
+		trace_seq_print_cont(s, iter);
+
+	return TRACE_TYPE_HANDLED;
+}
+
 static enum print_line_t print_bin_fmt(struct trace_iterator *iter)
 {
 	struct trace_seq *s = &iter->seq;
@@ -2345,6 +2365,11 @@ static enum print_line_t print_trace_line(struct trace_iterator *iter)
 			return ret;
 	}
 
+	if (iter->ent->type == TRACE_PRINT &&
+			trace_flags & TRACE_ITER_PRINTK &&
+			trace_flags & TRACE_ITER_PRINTK_MSGONLY)
+		return print_printk_msg_only(iter);
+
 	if (trace_flags & TRACE_ITER_BIN)
 		return print_bin_fmt(iter);
 
diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
index f07c246..fc75dce 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -578,7 +578,8 @@ enum trace_iterator_flags {
 	TRACE_ITER_BRANCH		= 0x1000,
 	TRACE_ITER_ANNOTATE		= 0x2000,
 	TRACE_ITER_USERSTACKTRACE       = 0x4000,
-	TRACE_ITER_SYM_USEROBJ          = 0x8000
+	TRACE_ITER_SYM_USEROBJ          = 0x8000,
+	TRACE_ITER_PRINTK_MSGONLY	= 0x10000
 };
 
 /*
-- 
1.6.0.4

