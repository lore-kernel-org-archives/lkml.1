Return-Path: <linux-kernel-owner+w=401wt.eu-S1751835AbZHSHzx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751835AbZHSHzx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Aug 2009 03:55:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751471AbZHSHzx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Aug 2009 03:55:53 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:51097 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751245AbZHSHzw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Aug 2009 03:55:52 -0400
Message-ID: <4A8BAFB8.1010304@cn.fujitsu.com>
Date: Wed, 19 Aug 2009 15:54:32 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>
CC: Ingo Molnar <mingo@elte.hu>, Jason Baron <jbaron@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 4/5] tracing/events: Add trace_define_common_fields()
References: <4A8BAF16.8040504@cn.fujitsu.com>
In-Reply-To: <4A8BAF16.8040504@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Extract duplicate code. Also prepare for the later patch.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
---
 include/linux/ftrace_event.h |    8 +-------
 include/trace/ftrace.h       |    8 +++-----
 kernel/trace/trace_events.c  |   22 ++++++++++++++++++++++
 kernel/trace/trace_export.c  |    8 +++-----
 4 files changed, 29 insertions(+), 17 deletions(-)

diff --git a/include/linux/ftrace_event.h b/include/linux/ftrace_event.h
index 35b3a4a..427cbae 100644
--- a/include/linux/ftrace_event.h
+++ b/include/linux/ftrace_event.h
@@ -142,6 +142,7 @@ extern int filter_current_check_discard(struct ftrace_event_call *call,
 
 extern int trace_define_field(struct ftrace_event_call *call, char *type,
 			      char *name, int offset, int size, int is_signed);
+extern int trace_define_common_fields(struct ftrace_event_call *call);
 
 #define is_signed_type(type)	(((type)(-1)) < 0)
 
@@ -166,11 +167,4 @@ do {									\
 		__trace_printk(ip, fmt, ##args);			\
 } while (0)
 
-#define __common_field(type, item, is_signed)				\
-	ret = trace_define_field(event_call, #type, "common_" #item,	\
-				 offsetof(typeof(field.ent), item),	\
-				 sizeof(field.ent.item), is_signed);	\
-	if (ret)							\
-		return ret;
-
 #endif /* _LINUX_FTRACE_EVENT_H */
diff --git a/include/trace/ftrace.h b/include/trace/ftrace.h
index 4e81c9b..1274002 100644
--- a/include/trace/ftrace.h
+++ b/include/trace/ftrace.h
@@ -299,11 +299,9 @@ ftrace_define_fields_##call(struct ftrace_event_call *event_call)	\
 	struct ftrace_raw_##call field;					\
 	int ret;							\
 									\
-	__common_field(int, type, 1);					\
-	__common_field(unsigned char, flags, 0);			\
-	__common_field(unsigned char, preempt_count, 0);		\
-	__common_field(int, pid, 1);					\
-	__common_field(int, tgid, 1);					\
+	ret = trace_define_common_fields(event_call);			\
+	if (ret)							\
+		return ret;						\
 									\
 	tstruct;							\
 									\
diff --git a/kernel/trace/trace_events.c b/kernel/trace/trace_events.c
index af8fb8e..9c7ecfb 100644
--- a/kernel/trace/trace_events.c
+++ b/kernel/trace/trace_events.c
@@ -62,6 +62,28 @@ err:
 }
 EXPORT_SYMBOL_GPL(trace_define_field);
 
+#define __common_field(type, item)					\
+	ret = trace_define_field(call, #type, "common_" #item,		\
+				 offsetof(typeof(ent), item),		\
+				 sizeof(ent.item),			\
+				 is_signed_type(type));			\
+	if (ret)							\
+		return ret;
+
+int trace_define_common_fields(struct ftrace_event_call *call)
+{
+	int ret;
+	struct trace_entry ent;
+
+	__common_field(unsigned short, type);
+	__common_field(unsigned char, flags);
+	__common_field(unsigned char, preempt_count);
+	__common_field(int, pid);
+	__common_field(int, tgid);
+
+	return ret;
+}
+
 #ifdef CONFIG_MODULES
 
 static void trace_destroy_fields(struct ftrace_event_call *call)
diff --git a/kernel/trace/trace_export.c b/kernel/trace/trace_export.c
index cf2c752..7087530 100644
--- a/kernel/trace/trace_export.c
+++ b/kernel/trace/trace_export.c
@@ -189,11 +189,9 @@ ftrace_define_fields_##call(struct ftrace_event_call *event_call)	\
 	struct args field;						\
 	int ret;							\
 									\
-	__common_field(unsigned char, type, 0);				\
-	__common_field(unsigned char, flags, 0);			\
-	__common_field(unsigned char, preempt_count, 0);		\
-	__common_field(int, pid, 1);					\
-	__common_field(int, tgid, 1);					\
+	ret = trace_define_common_fields(event_call);			\
+	if (ret)							\
+		return ret;						\
 									\
 	tstruct;							\
 									\
-- 
1.6.3

