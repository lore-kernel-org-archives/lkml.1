Return-Path: <linux-kernel-owner+w=401wt.eu-S1758800AbZLGHk5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758800AbZLGHk5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Dec 2009 02:40:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758623AbZLGHk4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Dec 2009 02:40:56 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:64228 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1758700AbZLGHkz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Dec 2009 02:40:55 -0500
Message-ID: <4B1CB173.8080204@cn.fujitsu.com>
Date: Mon, 07 Dec 2009 15:40:35 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 02/13] tracing: Extract calls to trace_define_common_fields()
References: <4B1CB14A.4080402@cn.fujitsu.com>
In-Reply-To: <4B1CB14A.4080402@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Call trace_define_common_fields() in event_create_dir() only.

   text    data     bss     dec     hex filename
5456157 2005772 7103796 14565725         de415d vmlinux.o
5454538 2005772 7103796 14564106         de3b0a vmlinux.o

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
---
 include/linux/ftrace_event.h  |    1 -
 include/trace/ftrace.h        |    4 ----
 kernel/trace/trace_events.c   |    7 ++++---
 kernel/trace/trace_export.c   |    4 ----
 kernel/trace/trace_kprobe.c   |    8 --------
 kernel/trace/trace_syscalls.c |    8 --------
 6 files changed, 4 insertions(+), 28 deletions(-)

diff --git a/include/linux/ftrace_event.h b/include/linux/ftrace_event.h
index 47bbdf9..02de70f 100644
--- a/include/linux/ftrace_event.h
+++ b/include/linux/ftrace_event.h
@@ -157,7 +157,6 @@ enum {
 	FILTER_PTR_STRING,
 };
 
-extern int trace_define_common_fields(struct ftrace_event_call *call);
 extern int trace_define_field(struct ftrace_event_call *call, const char *type,
 			      const char *name, int offset, int size,
 			      int is_signed, int filter_type);
diff --git a/include/trace/ftrace.h b/include/trace/ftrace.h
index 4d114c9..84d6f23 100644
--- a/include/trace/ftrace.h
+++ b/include/trace/ftrace.h
@@ -436,10 +436,6 @@ ftrace_define_fields_##call(struct ftrace_event_call *event_call)	\
 	struct ftrace_raw_##call field;					\
 	int ret;							\
 									\
-	ret = trace_define_common_fields(event_call);			\
-	if (ret)							\
-		return ret;						\
-									\
 	tstruct;							\
 									\
 	return ret;							\
diff --git a/kernel/trace/trace_events.c b/kernel/trace/trace_events.c
index 1d18315..9fa6736 100644
--- a/kernel/trace/trace_events.c
+++ b/kernel/trace/trace_events.c
@@ -78,7 +78,7 @@ EXPORT_SYMBOL_GPL(trace_define_field);
 	if (ret)							\
 		return ret;
 
-int trace_define_common_fields(struct ftrace_event_call *call)
+static int trace_define_common_fields(struct ftrace_event_call *call)
 {
 	int ret;
 	struct trace_entry ent;
@@ -91,7 +91,6 @@ int trace_define_common_fields(struct ftrace_event_call *call)
 
 	return ret;
 }
-EXPORT_SYMBOL_GPL(trace_define_common_fields);
 
 void trace_destroy_fields(struct ftrace_event_call *call)
 {
@@ -913,7 +912,9 @@ event_create_dir(struct ftrace_event_call *call, struct dentry *d_events,
 		 		  id);
 
 	if (call->define_fields) {
-		ret = call->define_fields(call);
+		ret = trace_define_common_fields(call);
+		if (!ret)
+			ret = call->define_fields(call);
 		if (ret < 0) {
 			pr_warning("Could not initialize trace point"
 				   " events/%s\n", call->name);
diff --git a/kernel/trace/trace_export.c b/kernel/trace/trace_export.c
index dff8c84..458e5bf 100644
--- a/kernel/trace/trace_export.c
+++ b/kernel/trace/trace_export.c
@@ -184,10 +184,6 @@ ftrace_define_fields_##name(struct ftrace_event_call *event_call)	\
 	struct struct_name field;					\
 	int ret;							\
 									\
-	ret = trace_define_common_fields(event_call);			\
-	if (ret)							\
-		return ret;						\
-									\
 	tstruct;							\
 									\
 	return ret;							\
diff --git a/kernel/trace/trace_kprobe.c b/kernel/trace/trace_kprobe.c
index aff5f80..e3c80e9 100644
--- a/kernel/trace/trace_kprobe.c
+++ b/kernel/trace/trace_kprobe.c
@@ -1113,10 +1113,6 @@ static int kprobe_event_define_fields(struct ftrace_event_call *event_call)
 	struct kprobe_trace_entry field;
 	struct trace_probe *tp = (struct trace_probe *)event_call->data;
 
-	ret = trace_define_common_fields(event_call);
-	if (!ret)
-		return ret;
-
 	DEFINE_FIELD(unsigned long, ip, FIELD_STRING_IP, 0);
 	DEFINE_FIELD(int, nargs, FIELD_STRING_NARGS, 1);
 	/* Set argument names as fields */
@@ -1131,10 +1127,6 @@ static int kretprobe_event_define_fields(struct ftrace_event_call *event_call)
 	struct kretprobe_trace_entry field;
 	struct trace_probe *tp = (struct trace_probe *)event_call->data;
 
-	ret = trace_define_common_fields(event_call);
-	if (!ret)
-		return ret;
-
 	DEFINE_FIELD(unsigned long, func, FIELD_STRING_FUNC, 0);
 	DEFINE_FIELD(unsigned long, ret_ip, FIELD_STRING_RETIP, 0);
 	DEFINE_FIELD(int, nargs, FIELD_STRING_NARGS, 1);
diff --git a/kernel/trace/trace_syscalls.c b/kernel/trace/trace_syscalls.c
index 57501d9..b957edd 100644
--- a/kernel/trace/trace_syscalls.c
+++ b/kernel/trace/trace_syscalls.c
@@ -217,10 +217,6 @@ int syscall_enter_define_fields(struct ftrace_event_call *call)
 	int i;
 	int offset = offsetof(typeof(trace), args);
 
-	ret = trace_define_common_fields(call);
-	if (ret)
-		return ret;
-
 	ret = trace_define_field(call, SYSCALL_FIELD(int, nr), FILTER_OTHER);
 	if (ret)
 		return ret;
@@ -241,10 +237,6 @@ int syscall_exit_define_fields(struct ftrace_event_call *call)
 	struct syscall_trace_exit trace;
 	int ret;
 
-	ret = trace_define_common_fields(call);
-	if (ret)
-		return ret;
-
 	ret = trace_define_field(call, SYSCALL_FIELD(int, nr), FILTER_OTHER);
 	if (ret)
 		return ret;
-- 
1.6.3

