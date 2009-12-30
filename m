Return-Path: <linux-kernel-owner+w=401wt.eu-S1752764AbZL3Q0x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752764AbZL3Q0x (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Dec 2009 11:26:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752649AbZL3Q0S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Dec 2009 11:26:18 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:36579 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752594AbZL3Q0R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Dec 2009 11:26:17 -0500
X-Authority-Analysis: v=1.0 c=1 a=CdcSZcodVQwA:10 a=omOdbC7AAAAA:8 a=meVymXHHAAAA:8 a=nuYltA4d6o793rn2EusA:9 a=REuMhl2XboJsMJ8p9ZEpLwa6NKAA:4 a=jeBq3FmKZ4MA:10
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Message-Id: <20091230162615.388792789@goodmis.org>
User-Agent: quilt/0.48-1
Date: Wed, 30 Dec 2009 11:23:06 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Li Zefan <lizf@cn.fujitsu.com>, Lai Jiangshan <laijs@cn.fujitsu.com>
Subject: [PATCH 3/3] tracing: Fix sign fields in ftrace_define_fields_##call()
References: <20091230162303.088852290@goodmis.org>
Content-Disposition: inline; filename=0003-tracing-Fix-sign-fields-in-ftrace_define_fields_-cal.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lai Jiangshan <laijs@cn.fujitsu.com>

Add is_signed_type() call to trace_define_field() in ftrace macros.

The code previously just passed in 0 (false), disregarding whether
or not the field was actually a signed type.

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
LKML-Reference: <4B273D3A.6020007@cn.fujitsu.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 include/trace/ftrace.h      |    7 ++++---
 kernel/trace/trace_export.c |    7 ++++---
 2 files changed, 8 insertions(+), 6 deletions(-)

diff --git a/include/trace/ftrace.h b/include/trace/ftrace.h
index 7352315..c6fe03e 100644
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
index 458e5bf..d4fa5dc 100644
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
 
-- 
1.6.5


