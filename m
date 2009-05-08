Return-Path: <linux-kernel-owner+w=401wt.eu-S1755954AbZEHCbR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755954AbZEHCbR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 May 2009 22:31:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753947AbZEHCa5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 May 2009 22:30:57 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:61500 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753504AbZEHCa4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 May 2009 22:30:56 -0400
Message-ID: <4A03998E.3020503@cn.fujitsu.com>
Date: Fri, 08 May 2009 10:31:42 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>
CC: Frederic Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/2] tracing/events: clean up for ftrace_set_clr_event()
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a helper function __ftrace_set_clr_event(), and replace some
ftrace_set_clr_event() calls with this helper, thus we don't need any
kstrdup() or kmalloc().

As a side effect, this patch fixes an issue in self tests code, which is
similar to the one fixed in commit d6bf81ef0f7474434c2a049e8bf3c9146a14dd96
("tracing: append ":*" to internal setting of system events")

It's a small issue and won't cause any bug in fact, but we should do things
right anyway.

[ Impact: clean up ]

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
---
 kernel/trace/trace_events.c |  126 ++++++++++++++++---------------------------
 1 files changed, 46 insertions(+), 80 deletions(-)

diff --git a/kernel/trace/trace_events.c b/kernel/trace/trace_events.c
index 8d0fae3..45f1099 100644
--- a/kernel/trace/trace_events.c
+++ b/kernel/trace/trace_events.c
@@ -111,11 +111,44 @@ static void ftrace_event_enable_disable(struct ftrace_event_call *call,
 	}
 }
 
-static int ftrace_set_clr_event(char *buf, int set)
+/*
+ * __ftrace_set_clr_event(NULL, NULL, NULL, set) will set/unset all events.
+ */
+static int __ftrace_set_clr_event(const char *match, const char *sub,
+				  const char *event, int set)
 {
 	struct ftrace_event_call *call;
+	int ret;
+
+	mutex_lock(&event_mutex);
+	list_for_each_entry(call, &ftrace_events, list) {
+
+		if (!call->name || !call->regfunc)
+			continue;
+
+		if (match &&
+		    strcmp(match, call->name) != 0 &&
+		    strcmp(match, call->system) != 0)
+			continue;
+
+		if (sub && strcmp(sub, call->system) != 0)
+			continue;
+
+		if (event && strcmp(event, call->name) != 0)
+			continue;
+
+		ftrace_event_enable_disable(call, set);
+
+		ret = 0;
+	}
+	mutex_unlock(&event_mutex);
+
+	return ret;
+}
+
+static int ftrace_set_clr_event(char *buf, int set)
+{
 	char *event = NULL, *sub = NULL, *match;
-	int ret = -EINVAL;
 
 	/*
 	 * The buf format can be <subsystem>:<event-name>
@@ -141,30 +174,7 @@ static int ftrace_set_clr_event(char *buf, int set)
 			event = NULL;
 	}
 
-	mutex_lock(&event_mutex);
-	list_for_each_entry(call, &ftrace_events, list) {
-
-		if (!call->name || !call->regfunc)
-			continue;
-
-		if (match &&
-		    strcmp(match, call->name) != 0 &&
-		    strcmp(match, call->system) != 0)
-			continue;
-
-		if (sub && strcmp(sub, call->system) != 0)
-			continue;
-
-		if (event && strcmp(event, call->name) != 0)
-			continue;
-
-		ftrace_event_enable_disable(call, set);
-
-		ret = 0;
-	}
-	mutex_unlock(&event_mutex);
-
-	return ret;
+	return __ftrace_set_clr_event(match, sub, event, set);
 }
 
 /* 128 should be much more than enough */
@@ -408,18 +418,14 @@ system_enable_read(struct file *filp, char __user *ubuf, size_t cnt,
 	struct ftrace_event_call *call;
 	char buf[2];
 	int set = -1;
-	int all = 0;
 	int ret;
 
-	if (system[0] == '*')
-		all = 1;
-
 	mutex_lock(&event_mutex);
 	list_for_each_entry(call, &ftrace_events, list) {
 		if (!call->name || !call->regfunc)
 			continue;
 
-		if (!all && strcmp(call->system, system) != 0)
+		if (system && strcmp(call->system, system) != 0)
 			continue;
 
 		/*
@@ -480,7 +486,6 @@ system_enable_write(struct file *filp, const char __user *ubuf, size_t cnt,
 {
 	const char *system = filp->private_data;
 	unsigned long val;
-	char *command;
 	char buf[64];
 	ssize_t ret;
 
@@ -500,30 +505,16 @@ system_enable_write(struct file *filp, const char __user *ubuf, size_t cnt,
 	if (ret < 0)
 		return ret;
 
-	switch (val) {
-	case 0:
-	case 1:
-		break;
-
-	default:
+	if (val != 0 && val != 1)
 		return -EINVAL;
-	}
 
-	/* +3 for the ":*\0" */
-	command = kmalloc(strlen(system)+3, GFP_KERNEL);
-	if (!command)
-		return -ENOMEM;
-	sprintf(command, "%s:*", system);
-
-	ret = ftrace_set_clr_event(command, val);
+	ret = __ftrace_set_clr_event(NULL, system, NULL, val);
 	if (ret)
-		goto out_free;
+		goto out;
 
 	ret = cnt;
 
- out_free:
-	kfree(command);
-
+out:
 	*ppos += cnt;
 
 	return ret;
@@ -1181,7 +1172,7 @@ static __init int event_trace_init(void)
 			  &ftrace_show_header_fops);
 
 	trace_create_file("enable", 0644, d_events,
-			  "*", &ftrace_system_enable_fops);
+			  NULL, &ftrace_system_enable_fops);
 
 	for_each_event(call, __start_ftrace_events, __stop_ftrace_events) {
 		/* The linker may leave blanks */
@@ -1259,7 +1250,6 @@ static __init void event_trace_self_tests(void)
 {
 	struct ftrace_event_call *call;
 	struct event_subsystem *system;
-	char *sysname;
 	int ret;
 
 	pr_info("Running tests on trace events:\n");
@@ -1305,14 +1295,7 @@ static __init void event_trace_self_tests(void)
 
 		pr_info("Testing event system %s: ", system->name);
 
-		/* ftrace_set_clr_event can modify the name passed in. */
-		sysname = kstrdup(system->name, GFP_KERNEL);
-		if (WARN_ON(!sysname)) {
-			pr_warning("Can't allocate memory, giving up!\n");
-			return;
-		}
-		ret = ftrace_set_clr_event(sysname, 1);
-		kfree(sysname);
+		ret = __ftrace_set_clr_event(NULL, system->name, NULL, 1);
 		if (WARN_ON_ONCE(ret)) {
 			pr_warning("error enabling system %s\n",
 				   system->name);
@@ -1321,14 +1304,7 @@ static __init void event_trace_self_tests(void)
 
 		event_test_stuff();
 
-		sysname = kstrdup(system->name, GFP_KERNEL);
-		if (WARN_ON(!sysname)) {
-			pr_warning("Can't allocate memory, giving up!\n");
-			return;
-		}
-		ret = ftrace_set_clr_event(sysname, 0);
-		kfree(sysname);
-
+		ret = __ftrace_set_clr_event(NULL, system->name, NULL, 0);
 		if (WARN_ON_ONCE(ret))
 			pr_warning("error disabling system %s\n",
 				   system->name);
@@ -1341,15 +1317,8 @@ static __init void event_trace_self_tests(void)
 	pr_info("Running tests on all trace events:\n");
 	pr_info("Testing all events: ");
 
-	sysname = kmalloc(4, GFP_KERNEL);
-	if (WARN_ON(!sysname)) {
-		pr_warning("Can't allocate memory, giving up!\n");
-		return;
-	}
-	memcpy(sysname, "*:*", 4);
-	ret = ftrace_set_clr_event(sysname, 1);
+	ret = __ftrace_set_clr_event(NULL, NULL, NULL, 1);
 	if (WARN_ON_ONCE(ret)) {
-		kfree(sysname);
 		pr_warning("error enabling all events\n");
 		return;
 	}
@@ -1357,10 +1326,7 @@ static __init void event_trace_self_tests(void)
 	event_test_stuff();
 
 	/* reset sysname */
-	memcpy(sysname, "*:*", 4);
-	ret = ftrace_set_clr_event(sysname, 0);
-	kfree(sysname);
-
+	ret = __ftrace_set_clr_event(NULL, NULL, NULL, 0);
 	if (WARN_ON_ONCE(ret)) {
 		pr_warning("error disabling all events\n");
 		return;
-- 
1.5.4.rc3

