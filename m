Return-Path: <linux-kernel-owner+w=401wt.eu-S1755021AbZBQFRa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755021AbZBQFRa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Feb 2009 00:17:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751293AbZBQFOV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Feb 2009 00:14:21 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:53237 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751975AbZBQFOI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Feb 2009 00:14:08 -0500
Message-Id: <20090217051407.422977785@goodmis.org>
References: <20090217051227.957864159@goodmis.org>
User-Agent: quilt/0.46-1
Date: Tue, 17 Feb 2009 00:12:39 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Steven Rostedt <srostedt@redhat.com>
Subject: [PATCH 12/15] ftrace: add traceon traceoff commands to enable/disable the buffers
Content-Disposition: inline; filename=0012-ftrace-add-traceon-traceoff-commands-to-enable-disa.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

This patch adds the new function selection commands traceon and
traceoff. traceon sets the function to enable the ring buffers
while traceoff disables the ring buffers.  You can pass in the
number of times you want the command to be executed when the function
is hit. It will only execute if the state of the buffers are not
already in that state.

Example:

 # echo do_fork:traceon:4

Will enable the ring buffers if they are disabled every time it
hits do_fork, up to 4 times.

 # echo sys_close:traceoff

This will disable the ring buffers every time (unlimited) when
sys_close is called.

Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---
 kernel/trace/trace_functions.c |  135 ++++++++++++++++++++++++++++++++++++++++
 1 files changed, 135 insertions(+), 0 deletions(-)

diff --git a/kernel/trace/trace_functions.c b/kernel/trace/trace_functions.c
index 36bf956..5c95708 100644
--- a/kernel/trace/trace_functions.c
+++ b/kernel/trace/trace_functions.c
@@ -9,6 +9,7 @@
  *  Copyright (C) 2004-2006 Ingo Molnar
  *  Copyright (C) 2004 William Lee Irwin III
  */
+#include <linux/ring_buffer.h>
 #include <linux/debugfs.h>
 #include <linux/uaccess.h>
 #include <linux/ftrace.h>
@@ -231,9 +232,143 @@ static struct tracer function_trace __read_mostly =
 #endif
 };
 
+#ifdef CONFIG_DYNAMIC_FTRACE
+static void
+ftrace_traceon(unsigned long ip, unsigned long parent_ip, void **data)
+{
+	long *count = (long *)data;
+
+	if (tracing_is_on())
+		return;
+
+	if (!*count)
+		return;
+
+	if (*count != -1)
+		(*count)--;
+
+	tracing_on();
+}
+
+static void
+ftrace_traceoff(unsigned long ip, unsigned long parent_ip, void **data)
+{
+	long *count = (long *)data;
+
+	if (!tracing_is_on())
+		return;
+
+	if (!*count)
+		return;
+
+	if (*count != -1)
+		(*count)--;
+
+	tracing_off();
+}
+
+static struct ftrace_hook_ops traceon_hook_ops = {
+	.func			= ftrace_traceon,
+};
+
+static struct ftrace_hook_ops traceoff_hook_ops = {
+	.func			= ftrace_traceoff,
+};
+
+static int
+ftrace_trace_onoff_unreg(char *glob, char *cmd, char *param)
+{
+	struct ftrace_hook_ops *ops;
+
+	/* we register both traceon and traceoff to this callback */
+	if (strcmp(cmd, "traceon") == 0)
+		ops = &traceon_hook_ops;
+	else
+		ops = &traceoff_hook_ops;
+
+	unregister_ftrace_function_hook_func(glob, ops);
+
+	return 0;
+}
+
+static int
+ftrace_trace_onoff_callback(char *glob, char *cmd, char *param, int enable)
+{
+	struct ftrace_hook_ops *ops;
+	void *count = (void *)-1;
+	char *number;
+	int ret;
+
+	/* hash funcs only work with set_ftrace_filter */
+	if (!enable)
+		return -EINVAL;
+
+	if (glob[0] == '!')
+		return ftrace_trace_onoff_unreg(glob+1, cmd, param);
+
+	/* we register both traceon and traceoff to this callback */
+	if (strcmp(cmd, "traceon") == 0)
+		ops = &traceon_hook_ops;
+	else
+		ops = &traceoff_hook_ops;
+
+	if (!param)
+		goto out_reg;
+
+	number = strsep(&param, ":");
+
+	if (!strlen(number))
+		goto out_reg;
+
+	/*
+	 * We use the callback data field (which is a pointer)
+	 * as our counter.
+	 */
+	ret = strict_strtoul(number, 0, (unsigned long *)&count);
+	if (ret)
+		return ret;
+
+ out_reg:
+	ret = register_ftrace_function_hook(glob, ops, count);
+
+	return ret;
+}
+
+static struct ftrace_func_command ftrace_traceon_cmd = {
+	.name			= "traceon",
+	.func			= ftrace_trace_onoff_callback,
+};
+
+static struct ftrace_func_command ftrace_traceoff_cmd = {
+	.name			= "traceoff",
+	.func			= ftrace_trace_onoff_callback,
+};
+
+static int __init init_func_cmd_traceon(void)
+{
+	int ret;
+
+	ret = register_ftrace_command(&ftrace_traceoff_cmd);
+	if (ret)
+		return ret;
+
+	ret = register_ftrace_command(&ftrace_traceon_cmd);
+	if (ret)
+		unregister_ftrace_command(&ftrace_traceoff_cmd);
+	return ret;
+}
+#else
+static inline int init_func_cmd_traceon(void)
+{
+	return 0;
+}
+#endif /* CONFIG_DYNAMIC_FTRACE */
+
 static __init int init_function_trace(void)
 {
+	init_func_cmd_traceon();
 	return register_tracer(&function_trace);
 }
 
 device_initcall(init_function_trace);
+
-- 
1.5.6.5

-- 
