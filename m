Return-Path: <linux-kernel-owner+w=401wt.eu-S1752808AbZHSNce@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752808AbZHSNce (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Aug 2009 09:32:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752304AbZHSNce
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Aug 2009 09:32:34 -0400
Received: from hera.kernel.org ([140.211.167.34]:34662 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751596AbZHSNcd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Aug 2009 09:32:33 -0400
Date: Wed, 19 Aug 2009 13:31:47 GMT
From: tip-bot for Li Zefan <lizf@cn.fujitsu.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       lizf@cn.fujitsu.com, fweisbec@gmail.com, rostedt@goodmis.org,
       tglx@linutronix.de, jbaron@redhat.com, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       lizf@cn.fujitsu.com, fweisbec@gmail.com, rostedt@goodmis.org,
       tglx@linutronix.de, jbaron@redhat.com, mingo@elte.hu
In-Reply-To: <4A8BAFB8.1010304@cn.fujitsu.com>
References: <4A8BAFB8.1010304@cn.fujitsu.com>
Subject: [tip:tracing/core] tracing/events: Add trace_define_common_fields()
Message-ID: <tip-e647d6b314266adb904d4b84973eda0afa856946@git.kernel.org>
Git-Commit-ID: e647d6b314266adb904d4b84973eda0afa856946
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 19 Aug 2009 13:31:48 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  e647d6b314266adb904d4b84973eda0afa856946
Gitweb:     http://git.kernel.org/tip/e647d6b314266adb904d4b84973eda0afa856946
Author:     Li Zefan <lizf@cn.fujitsu.com>
AuthorDate: Wed, 19 Aug 2009 15:54:32 +0800
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 19 Aug 2009 15:02:24 +0200

tracing/events: Add trace_define_common_fields()

Extract duplicate code. Also prepare for the later patch.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
Cc: Jason Baron <jbaron@redhat.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
LKML-Reference: <4A8BAFB8.1010304@cn.fujitsu.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


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
