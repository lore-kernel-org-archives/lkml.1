Return-Path: <linux-kernel-owner+w=401wt.eu-S1758814AbZLGHlO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758814AbZLGHlO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Dec 2009 02:41:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758712AbZLGHlM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Dec 2009 02:41:12 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:49574 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1758623AbZLGHlL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Dec 2009 02:41:11 -0500
Message-ID: <4B1CB183.7040202@cn.fujitsu.com>
Date: Mon, 07 Dec 2009 15:40:51 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 03/13] tracing: Move a printk out of ftrace_raw_reg_event_foo()
References: <4B1CB14A.4080402@cn.fujitsu.com>
In-Reply-To: <4B1CB14A.4080402@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move the printk from each ftrace_raw_reg_event_foo() to
its caller ftrace_event_enable_disable().

See how much space this saves:

   text    data     bss     dec     hex filename
5454538 2005772 7103796 14564106         de3b0a vmlinux.o
5440766 2005772 7103796 14550334         de053e vmlinux.o

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
---
 include/trace/ftrace.h        |   16 ++--------------
 kernel/trace/trace_events.c   |   17 +++++++++++++----
 kernel/trace/trace_syscalls.c |   10 ++--------
 3 files changed, 17 insertions(+), 26 deletions(-)

diff --git a/include/trace/ftrace.h b/include/trace/ftrace.h
index 84d6f23..4aac981 100644
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
@@ -733,13 +727,7 @@ static void ftrace_raw_event_##call(proto)				\
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
index 9fa6736..f22eaec 100644
--- a/kernel/trace/trace_events.c
+++ b/kernel/trace/trace_events.c
@@ -104,9 +104,11 @@ void trace_destroy_fields(struct ftrace_event_call *call)
 	}
 }
 
-static void ftrace_event_enable_disable(struct ftrace_event_call *call,
+static int ftrace_event_enable_disable(struct ftrace_event_call *call,
 					int enable)
 {
+	int ret = 0;
+
 	switch (enable) {
 	case 0:
 		if (call->enabled) {
@@ -117,12 +119,19 @@ static void ftrace_event_enable_disable(struct ftrace_event_call *call,
 		break;
 	case 1:
 		if (!call->enabled) {
+			if (ret) {
+				pr_info("event trace: Could not enable event "
+					"%s\n", call->name);
+				break;
+			}
 			call->enabled = 1;
 			tracing_start_cmdline_record();
-			call->regfunc(call);
+			ret = call->regfunc(call);
 		}
 		break;
 	}
+
+	return ret;
 }
 
 static void ftrace_clear_events(void)
@@ -401,7 +410,7 @@ event_enable_write(struct file *filp, const char __user *ubuf, size_t cnt,
 	case 0:
 	case 1:
 		mutex_lock(&event_mutex);
-		ftrace_event_enable_disable(call, val);
+		ret = ftrace_event_enable_disable(call, val);
 		mutex_unlock(&event_mutex);
 		break;
 
@@ -411,7 +420,7 @@ event_enable_write(struct file *filp, const char __user *ubuf, size_t cnt,
 
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
1.6.3

