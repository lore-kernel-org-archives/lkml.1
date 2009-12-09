Return-Path: <linux-kernel-owner+w=401wt.eu-S935888AbZLIHQS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935888AbZLIHQS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Dec 2009 02:16:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757188AbZLIHQQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Dec 2009 02:16:16 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:55700 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1757169AbZLIHQO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Dec 2009 02:16:14 -0500
Message-ID: <4B1F4E97.5060406@cn.fujitsu.com>
Date: Wed, 09 Dec 2009 15:15:35 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Masami Hiramatsu <mhiramat@redhat.com>, Jason Baron <jbaron@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 05/10] tracing: make signs the same
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


ftrace_format_##call() and ftrace_define_fields_##call() are
inconsistent at signs of fields.

After reviewed codes, ftrace_format_##call() is correct,
so we change ftrace_define_fields_##call().

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
diff --git a/include/trace/ftrace.h b/include/trace/ftrace.h
index 0c21af8..54258a0 100644
--- a/include/trace/ftrace.h
+++ b/include/trace/ftrace.h
@@ -414,7 +414,8 @@ ftrace_raw_output_##call(struct trace_iterator *iter, int flags)	\
 	BUILD_BUG_ON(len > MAX_FILTER_STR_VAL);				\
 	ret = trace_define_field(event_call, #type "[" #len "]", #item,	\
 				 offsetof(typeof(field), item),		\
-				 sizeof(field.item), 0, FILTER_OTHER);	\
+				 sizeof(field.item),			\
+				 is_signed_type(type), FILTER_OTHER);	\
 	if (ret)							\
 		return ret;
 
@@ -422,8 +423,8 @@ ftrace_raw_output_##call(struct trace_iterator *iter, int flags)	\
 #define __dynamic_array(type, item, len)				       \
 	ret = trace_define_field(event_call, "__data_loc " #type "[]", #item,  \
 				 offsetof(typeof(field), __data_loc_##item),   \
-				 sizeof(field.__data_loc_##item), 0,	       \
-				 FILTER_OTHER);
+				 sizeof(field.__data_loc_##item),	       \
+				 is_signed_type(type), FILTER_OTHER);
 
 #undef __string
 #define __string(item, src) __dynamic_array(char, item, -1)
diff --git a/kernel/trace/trace_export.c b/kernel/trace/trace_export.c
index 511bc36..9978a4f 100644
--- a/kernel/trace/trace_export.c
+++ b/kernel/trace/trace_export.c
@@ -158,7 +158,8 @@ ftrace_format_##name(struct ftrace_event_call *unused,			\
 	BUILD_BUG_ON(len > MAX_FILTER_STR_VAL);				\
 	ret = trace_define_field(event_call, #type "[" #len "]", #item,	\
 				 offsetof(typeof(field), item),		\
-				 sizeof(field.item), 0, FILTER_OTHER);	\
+				 sizeof(field.item),			\
+				 is_signed_type(type), FILTER_OTHER);	\
 	if (ret)							\
 		return ret;
 
@@ -168,8 +169,8 @@ ftrace_format_##name(struct ftrace_event_call *unused,			\
 	ret = trace_define_field(event_call, #type "[" #len "]", #item,	\
 				 offsetof(typeof(field),		\
 					  container.item),		\
-				 sizeof(field.container.item), 0,	\
-				 FILTER_OTHER);				\
+				 sizeof(field.container.item),		\
+				 is_signed_type(type), FILTER_OTHER);	\
 	if (ret)							\
 		return ret;
 


