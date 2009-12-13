Return-Path: <linux-kernel-owner+w=401wt.eu-S1752944AbZLMNI2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752944AbZLMNI2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Dec 2009 08:08:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752371AbZLMNIX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Dec 2009 08:08:23 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:51043 "HELO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752293AbZLMNIV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Dec 2009 08:08:21 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=iS03ZG8jXczqbNfeaBYAGXDgj8d+RU8aaKH+jwu6UMawYtlnOhsOdzKS9jM+UJU2NN
         LIZ7LTuUbTJS0mO4rPT1EYBzluzVqPNUVoKjQT6rTUDnT6N66ITpMtVyUfRBWggXPZnX
         +k9/WLx0LFBvJu7bNYR44X/4GVQtS5eYQFokY=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>, Li Zefan <lizf@cn.fujitsu.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       "K.Prasad" <prasad@linux.vnet.ibm.com>,
       Arjan van de Ven <arjan@linux.intel.com>,
       Jason Baron <jbaron@redhat.com>, Masami Hiramatsu <mhiramat@redhat.com>,
       Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 02/13] tracing: Pull up calls to trace_define_common_fields()
Date: Sun, 13 Dec 2009 14:08:03 +0100
Message-Id: <1260709694-5166-3-git-send-regression-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
In-Reply-To: <1260709694-5166-1-git-send-regression-fweisbec@gmail.com>
References: <1260709694-5166-1-git-send-regression-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Li Zefan <lizf@cn.fujitsu.com>

Call trace_define_common_fields() in event_create_dir() only.
This avoids trace events to handle it from their define_fields
callbacks and shrinks the kernel code size:

   text    data     bss     dec     hex filename
5346802 1961864 7103260 14411926         dbe896 vmlinux.o.old
5345151 1961864 7103260 14410275         dbe223 vmlinux.o

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
Acked-by: Steven Rostedt <rostedt@goodmis.org>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Jason Baron <jbaron@redhat.com>
Cc: Masami Hiramatsu <mhiramat@redhat.com>
LKML-Reference: <4B1DC49C.8000107@cn.fujitsu.com>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
---
 include/linux/ftrace_event.h  |    1 -
 include/trace/ftrace.h        |    4 ----
 kernel/trace/trace_events.c   |    7 ++++---
 kernel/trace/trace_export.c   |    4 ----
 kernel/trace/trace_kprobe.c   |    8 --------
 kernel/trace/trace_syscalls.c |    8 --------
 6 files changed, 4 insertions(+), 28 deletions(-)

diff --git a/include/linux/ftrace_event.h b/include/linux/ftrace_event.h
index ea44b89..db97c64 100644
--- a/include/linux/ftrace_event.h
+++ b/include/linux/ftrace_event.h
@@ -159,7 +159,6 @@ enum {
 };
 
 extern int trace_event_raw_init(struct ftrace_event_call *call);
-extern int trace_define_common_fields(struct ftrace_event_call *call);
 extern int trace_define_field(struct ftrace_event_call *call, const char *type,
 			      const char *name, int offset, int size,
 			      int is_signed, int filter_type);
diff --git a/include/trace/ftrace.h b/include/trace/ftrace.h
index f46ad26..f978376 100644
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
index 8ed66e0..97b0b3a 100644
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
@@ -927,7 +926,9 @@ event_create_dir(struct ftrace_event_call *call, struct dentry *d_events,
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
1.6.2.3

