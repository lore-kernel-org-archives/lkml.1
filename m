Return-Path: <linux-kernel-owner+w=401wt.eu-S1754967AbZLNJqk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754967AbZLNJqk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Dec 2009 04:46:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753749AbZLNJqh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Dec 2009 04:46:37 -0500
Received: from hera.kernel.org ([140.211.167.34]:59654 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754805AbZLNJqg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Dec 2009 04:46:36 -0500
Date: Mon, 14 Dec 2009 09:46:04 GMT
From: tip-bot for Li Zefan <lizf@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       fweisbec@gmail.com, rostedt@goodmis.org, lizf@cn.fujitsu.com,
       jbaron@redhat.com, tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       lizf@cn.fujitsu.com, fweisbec@gmail.com, rostedt@goodmis.org,
       jbaron@redhat.com, tglx@linutronix.de
In-Reply-To: <4B1DC4AC.802@cn.fujitsu.com>
References: <4B1DC4AC.802@cn.fujitsu.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:tracing/urgent] tracing: Move a printk out of ftrace_raw_reg_event_foo()
Message-ID: <tip-3b8e4273814a7f9e9a74ece517d9206fea919aaa@git.kernel.org>
Git-Commit-ID: 3b8e4273814a7f9e9a74ece517d9206fea919aaa
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  3b8e4273814a7f9e9a74ece517d9206fea919aaa
Gitweb:     http://git.kernel.org/tip/3b8e4273814a7f9e9a74ece517d9206fea919aaa
Author:     Li Zefan <lizf@cn.fujitsu.com>
AuthorDate: Tue, 8 Dec 2009 11:14:52 +0800
Committer:  Frederic Weisbecker <fweisbec@gmail.com>
CommitDate: Sun, 13 Dec 2009 18:37:25 +0100

tracing: Move a printk out of ftrace_raw_reg_event_foo()

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
index 2af2f7a..0c21af8 100644
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
-			"probe to %s\n", #call);			\
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
