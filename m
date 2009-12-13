Return-Path: <linux-kernel-owner+w=401wt.eu-S1753179AbZLMNIp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753179AbZLMNIp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Dec 2009 08:08:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752689AbZLMNI1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Dec 2009 08:08:27 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:53483 "HELO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752335AbZLMNIX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Dec 2009 08:08:23 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=copSlVSoFd3yQgkinpwNffgMk8KQYfQQLgMpUV+JsW7ugVUkyBwve2OlgcWl+To94D
         U5KR/TRguzqsH7hW5/Dvk3T+vqy0aJLRAYgW9I6GfDTy5ZN5hPndmL8+5OjySQlbAyJk
         XP7oDD+gIKWPRlld5Gjml7PsQgM/KjwNVj154=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>, Li Zefan <lizf@cn.fujitsu.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       "K.Prasad" <prasad@linux.vnet.ibm.com>,
       Arjan van de Ven <arjan@linux.intel.com>,
       Jason Baron <jbaron@redhat.com>, Masami Hiramatsu <mhiramat@redhat.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 03/13] tracing: Move a printk out of ftrace_raw_reg_event_foo()
Date: Sun, 13 Dec 2009 14:08:04 +0100
Message-Id: <1260709694-5166-4-git-send-regression-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
In-Reply-To: <1260709694-5166-1-git-send-regression-fweisbec@gmail.com>
References: <1260709694-5166-1-git-send-regression-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Li Zefan <lizf@cn.fujitsu.com>

Move the printk from each ftrace_raw_reg_event_foo() to
its caller ftrace_event_enable_disable(). This avoids each
regfunc trace event callbacks to handle a same error report
that can be carried from the caller.

See how much space this saves:

   text    data     bss     dec     hex filename
5345151 1961864 7103260 14410275         dbe223 vmlinux.o.old
5331487 1961864 7103260 14396611         dbacc3 vmlinux.o

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
Acked-by: Steven Rostedt <rostedt@goodmis.org>
Cc: Jason Baron <jbaron@redhat.com>
LKML-Reference: <4B1DC4AC.802@cn.fujitsu.com>
[start cmdline record before calling regfunc to avoid lost
window of pid to comm resolution]
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
---
 include/trace/ftrace.h        |   16 ++--------------
 kernel/trace/trace_events.c   |   20 +++++++++++++++-----
 kernel/trace/trace_syscalls.c |   10 ++--------
 3 files changed, 19 insertions(+), 27 deletions(-)

diff --git a/include/trace/ftrace.h b/include/trace/ftrace.h
index f978376..0c21af8 100644
--- a/include/trace/ftrace.h
+++ b/include/trace/ftrace.h
@@ -555,13 +555,7 @@ static void ftrace_profile_disable_##name(struct ftrace_event_call *unused)\
  *
  * static int ftrace_reg_event_<call>(struct ftrace_event_call *unused)
  * {
- *	int ret;
- *
- *	ret = register_trace_<call>(ftrace_event_<call>);
- *	if (!ret)
- *		pr_info("event trace: Could not activate trace point "
- *			"probe to  <call>");
- *	return ret;
+ *	return register_trace_<call>(ftrace_event_<call>);
  * }
  *
  * static void ftrace_unreg_event_<call>(struct ftrace_event_call *unused)
@@ -710,13 +704,7 @@ static void ftrace_raw_event_##call(proto)				\
 									\
 static int ftrace_raw_reg_event_##call(struct ftrace_event_call *unused)\
 {									\
-	int ret;							\
-									\
-	ret = register_trace_##call(ftrace_raw_event_##call);		\
-	if (ret)							\
-		pr_info("event trace: Could not activate trace point "	\
-			"probe to " #call "\n");			\
-	return ret;							\
+	return register_trace_##call(ftrace_raw_event_##call);		\
 }									\
 									\
 static void ftrace_raw_unreg_event_##call(struct ftrace_event_call *unused)\
diff --git a/kernel/trace/trace_events.c b/kernel/trace/trace_events.c
index 97b0b3a..189b09b 100644
--- a/kernel/trace/trace_events.c
+++ b/kernel/trace/trace_events.c
@@ -118,9 +118,11 @@ int trace_event_raw_init(struct ftrace_event_call *call)
 }
 EXPORT_SYMBOL_GPL(trace_event_raw_init);
 
-static void ftrace_event_enable_disable(struct ftrace_event_call *call,
+static int ftrace_event_enable_disable(struct ftrace_event_call *call,
 					int enable)
 {
+	int ret = 0;
+
 	switch (enable) {
 	case 0:
 		if (call->enabled) {
@@ -131,12 +133,20 @@ static void ftrace_event_enable_disable(struct ftrace_event_call *call,
 		break;
 	case 1:
 		if (!call->enabled) {
-			call->enabled = 1;
 			tracing_start_cmdline_record();
-			call->regfunc(call);
+			ret = call->regfunc(call);
+			if (ret) {
+				tracing_stop_cmdline_record();
+				pr_info("event trace: Could not enable event "
+					"%s\n", call->name);
+				break;
+			}
+			call->enabled = 1;
 		}
 		break;
 	}
+
+	return ret;
 }
 
 static void ftrace_clear_events(void)
@@ -415,7 +425,7 @@ event_enable_write(struct file *filp, const char __user *ubuf, size_t cnt,
 	case 0:
 	case 1:
 		mutex_lock(&event_mutex);
-		ftrace_event_enable_disable(call, val);
+		ret = ftrace_event_enable_disable(call, val);
 		mutex_unlock(&event_mutex);
 		break;
 
@@ -425,7 +435,7 @@ event_enable_write(struct file *filp, const char __user *ubuf, size_t cnt,
 
 	*ppos += cnt;
 
-	return cnt;
+	return ret ? ret : cnt;
 }
 
 static ssize_t
diff --git a/kernel/trace/trace_syscalls.c b/kernel/trace/trace_syscalls.c
index b957edd..75289f3 100644
--- a/kernel/trace/trace_syscalls.c
+++ b/kernel/trace/trace_syscalls.c
@@ -325,10 +325,7 @@ int reg_event_syscall_enter(struct ftrace_event_call *call)
 	mutex_lock(&syscall_trace_lock);
 	if (!sys_refcount_enter)
 		ret = register_trace_sys_enter(ftrace_syscall_enter);
-	if (ret) {
-		pr_info("event trace: Could not activate"
-				"syscall entry trace point");
-	} else {
+	if (!ret) {
 		set_bit(num, enabled_enter_syscalls);
 		sys_refcount_enter++;
 	}
@@ -362,10 +359,7 @@ int reg_event_syscall_exit(struct ftrace_event_call *call)
 	mutex_lock(&syscall_trace_lock);
 	if (!sys_refcount_exit)
 		ret = register_trace_sys_exit(ftrace_syscall_exit);
-	if (ret) {
-		pr_info("event trace: Could not activate"
-				"syscall exit trace point");
-	} else {
+	if (!ret) {
 		set_bit(num, enabled_exit_syscalls);
 		sys_refcount_exit++;
 	}
-- 
1.6.2.3

