Return-Path: <linux-kernel-owner+w=401wt.eu-S932316AbZE0XgO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932316AbZE0XgO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 May 2009 19:36:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760885AbZE0Xfe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 May 2009 19:35:34 -0400
Received: from mail-bw0-f222.google.com ([209.85.218.222]:49543 "EHLO
	mail-bw0-f222.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757880AbZE0Xfc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 May 2009 19:35:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=ulUBE8sWnozXJxpXxgR+dJQEEwNuGQcvmPooib1SMgPJW98R1Q9kDsuzwdUDfRDD3W
         9booIPFQImlsS82axCD7lAUwXqJs09sZY/zDmI7qm6q8PHGn4QWqiWlBb461g8DdovJh
         x73uzxHh/FT6reS12pv0H3gffpGb69TVFtrps=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>, Zhaolei <zhaolei@cn.fujitsu.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 2/2] ftrace: don't convert function's local variable name in macro
Date: Thu, 28 May 2009 01:35:27 +0200
Message-Id: <1243467327-13194-3-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
In-Reply-To: <1243467327-13194-1-git-send-email-fweisbec@gmail.com>
References: <1243467327-13194-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Zhaolei <zhaolei@cn.fujitsu.com>

"call" is an argument of macro, but it is also used as a local
variable name of function in macro.
We should keep this local variable name distinct from any
CPP macro parameter name if both are in the same macro scope,
although it hasn't caused any problem yet.

[ Impact: robustify macro ]

Signed-off-by: Zhao Lei <zhaolei@cn.fujitsu.com>
Acked-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
---
 include/trace/ftrace.h |   20 ++++++++++----------
 1 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/include/trace/ftrace.h b/include/trace/ftrace.h
index 87fc227..b4ec83a 100644
--- a/include/trace/ftrace.h
+++ b/include/trace/ftrace.h
@@ -397,19 +397,19 @@ static void ftrace_profile_##call(proto)				\
 	perf_tpcounter_event(event_##call.id);				\
 }									\
 									\
-static int ftrace_profile_enable_##call(struct ftrace_event_call *call) \
+static int ftrace_profile_enable_##call(struct ftrace_event_call *event_call) \
 {									\
 	int ret = 0;							\
 									\
-	if (!atomic_inc_return(&call->profile_count))			\
+	if (!atomic_inc_return(&event_call->profile_count))		\
 		ret = register_trace_##call(ftrace_profile_##call);	\
 									\
 	return ret;							\
 }									\
 									\
-static void ftrace_profile_disable_##call(struct ftrace_event_call *call) \
+static void ftrace_profile_disable_##call(struct ftrace_event_call *event_call)\
 {									\
-	if (atomic_add_negative(-1, &call->profile_count))		\
+	if (atomic_add_negative(-1, &event_call->profile_count))	\
 		unregister_trace_##call(ftrace_profile_##call);		\
 }
 
@@ -433,9 +433,9 @@ static void ftrace_profile_disable_##call(struct ftrace_event_call *call) \
 #define __array(type, item, len)
 
 #undef __string
-#define __string(item, src)						       \
-	__str_offsets.item = __str_size +				       \
-			     offsetof(typeof(*entry), __str_data);	       \
+#define __string(item, src)						\
+	__str_offsets.item = __str_size +				\
+			     offsetof(typeof(*entry), __str_data);	\
 	__str_size += strlen(src) + 1;
 
 #undef __assign_str
@@ -451,8 +451,8 @@ static struct ftrace_event_call event_##call;				\
 									\
 static void ftrace_raw_event_##call(proto)				\
 {									\
-	struct ftrace_str_offsets_##call __maybe_unused __str_offsets;  \
-	struct ftrace_event_call *call = &event_##call;			\
+	struct ftrace_str_offsets_##call __maybe_unused __str_offsets;	\
+	struct ftrace_event_call *event_call = &event_##call;		\
 	struct ring_buffer_event *event;				\
 	struct ftrace_raw_##call *entry;				\
 	unsigned long irq_flags;					\
@@ -473,7 +473,7 @@ static void ftrace_raw_event_##call(proto)				\
 									\
 	assign;								\
 									\
-	if (!filter_current_check_discard(call, entry, event))		\
+	if (!filter_current_check_discard(event_call, entry, event))	\
 		trace_nowake_buffer_unlock_commit(event, irq_flags, pc); \
 }									\
 									\
-- 
1.6.2.3

