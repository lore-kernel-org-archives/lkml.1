Return-Path: <linux-kernel-owner+w=401wt.eu-S1753288AbZL3Sh2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753288AbZL3Sh2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Dec 2009 13:37:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753276AbZL3ShY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Dec 2009 13:37:24 -0500
Received: from hera.kernel.org ([140.211.167.34]:35627 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753019AbZL3ShT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Dec 2009 13:37:19 -0500
Date: Wed, 30 Dec 2009 18:37:02 GMT
From: tip-bot for Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       rostedt@goodmis.org, tglx@linutronix.de, laijs@cn.fujitsu.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       rostedt@goodmis.org, tglx@linutronix.de, laijs@cn.fujitsu.com
In-Reply-To: <4B273D3A.6020007@cn.fujitsu.com>
References: <4B273D3A.6020007@cn.fujitsu.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:tracing/urgent] tracing: Fix sign fields in ftrace_define_fields_##call()
Message-ID: <tip-fb7ae981cb9fe8665b9da97e8734745e030c151d@git.kernel.org>
Git-Commit-ID: fb7ae981cb9fe8665b9da97e8734745e030c151d
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  fb7ae981cb9fe8665b9da97e8734745e030c151d
Gitweb:     http://git.kernel.org/tip/fb7ae981cb9fe8665b9da97e8734745e030c151d
Author:     Lai Jiangshan <laijs@cn.fujitsu.com>
AuthorDate: Tue, 15 Dec 2009 15:39:38 +0800
Committer:  Steven Rostedt <rostedt@goodmis.org>
CommitDate: Wed, 30 Dec 2009 10:27:06 -0500

tracing: Fix sign fields in ftrace_define_fields_##call()

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
 
