Return-Path: <linux-kernel-owner+w=401wt.eu-S1751453AbZBQFQS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751453AbZBQFQS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Feb 2009 00:16:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752507AbZBQFON
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Feb 2009 00:14:13 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:42017 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751672AbZBQFOH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Feb 2009 00:14:07 -0500
Message-Id: <20090217051406.383069690@goodmis.org>
References: <20090217051227.957864159@goodmis.org>
User-Agent: quilt/0.46-1
Date: Tue, 17 Feb 2009 00:12:34 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Steven Rostedt <srostedt@redhat.com>
Subject: [PATCH 07/15] ftrace: add command interface for function selection
Content-Disposition: inline; filename=0007-ftrace-add-command-interface-for-function-selection.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

Allow for other tracers to add their own commands for function
selection. This interface gives a trace the ability to name a
command for function selection. Right now it is pretty limited
in what it offers, but this is a building step for more features.

The :mod: command is converted to this interface and also serves
as a template for other implementations.

Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---
 include/linux/ftrace.h |   16 +++++++
 kernel/trace/ftrace.c  |  106 +++++++++++++++++++++++++++++++++++++++++++-----
 2 files changed, 111 insertions(+), 11 deletions(-)

diff --git a/include/linux/ftrace.h b/include/linux/ftrace.h
index 106b790..f0a0ecc 100644
--- a/include/linux/ftrace.h
+++ b/include/linux/ftrace.h
@@ -95,6 +95,13 @@ stack_trace_sysctl(struct ctl_table *table, int write,
 		   loff_t *ppos);
 #endif
 
+struct ftrace_func_command {
+	struct list_head	list;
+	char			*name;
+	int			(*func)(char *func, char *cmd,
+					char *params, int enable);
+};
+
 #ifdef CONFIG_DYNAMIC_FTRACE
 /* asm/ftrace.h must be defined for archs supporting dynamic ftrace */
 #include <asm/ftrace.h>
@@ -119,6 +126,9 @@ struct dyn_ftrace {
 int ftrace_force_update(void);
 void ftrace_set_filter(unsigned char *buf, int len, int reset);
 
+int register_ftrace_command(struct ftrace_func_command *cmd);
+int unregister_ftrace_command(struct ftrace_func_command *cmd);
+
 /* defined in arch */
 extern int ftrace_ip_converted(unsigned long ip);
 extern int ftrace_dyn_arch_init(void *data);
@@ -202,6 +212,12 @@ extern void ftrace_enable_daemon(void);
 # define ftrace_disable_daemon()		do { } while (0)
 # define ftrace_enable_daemon()			do { } while (0)
 static inline void ftrace_release(void *start, unsigned long size) { }
+static inline int register_ftrace_command(struct ftrace_func_command *cmd)
+{
+}
+static inline int unregister_ftrace_command(char *cmd_name)
+{
+}
 #endif /* CONFIG_DYNAMIC_FTRACE */
 
 /* totally disable ftrace - can not re-enable after this */
diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index 340f88b..45a44c4 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -1239,9 +1239,93 @@ static void ftrace_match_module_records(char *buff, char *mod, int enable)
 	spin_unlock(&ftrace_lock);
 }
 
+/*
+ * We register the module command as a template to show others how
+ * to register the a command as well.
+ */
+
+static int
+ftrace_mod_callback(char *func, char *cmd, char *param, int enable)
+{
+	char *mod;
+
+	/*
+	 * cmd == 'mod' because we only registered this func
+	 * for the 'mod' ftrace_func_command.
+	 * But if you register one func with multiple commands,
+	 * you can tell which command was used by the cmd
+	 * parameter.
+	 */
+
+	/* we must have a module name */
+	if (!param)
+		return -EINVAL;
+
+	mod = strsep(&param, ":");
+	if (!strlen(mod))
+		return -EINVAL;
+
+	ftrace_match_module_records(func, mod, enable);
+	return 0;
+}
+
+static struct ftrace_func_command ftrace_mod_cmd = {
+	.name			= "mod",
+	.func			= ftrace_mod_callback,
+};
+
+static int __init ftrace_mod_cmd_init(void)
+{
+	return register_ftrace_command(&ftrace_mod_cmd);
+}
+device_initcall(ftrace_mod_cmd_init);
+
+static LIST_HEAD(ftrace_commands);
+static DEFINE_MUTEX(ftrace_cmd_mutex);
+
+int register_ftrace_command(struct ftrace_func_command *cmd)
+{
+	struct ftrace_func_command *p;
+	int ret = 0;
+
+	mutex_lock(&ftrace_cmd_mutex);
+	list_for_each_entry(p, &ftrace_commands, list) {
+		if (strcmp(cmd->name, p->name) == 0) {
+			ret = -EBUSY;
+			goto out_unlock;
+		}
+	}
+	list_add(&cmd->list, &ftrace_commands);
+ out_unlock:
+	mutex_unlock(&ftrace_cmd_mutex);
+
+	return ret;
+}
+
+int unregister_ftrace_command(struct ftrace_func_command *cmd)
+{
+	struct ftrace_func_command *p, *n;
+	int ret = -ENODEV;
+
+	mutex_lock(&ftrace_cmd_mutex);
+	list_for_each_entry_safe(p, n, &ftrace_commands, list) {
+		if (strcmp(cmd->name, p->name) == 0) {
+			ret = 0;
+			list_del_init(&p->list);
+			goto out_unlock;
+		}
+	}
+ out_unlock:
+	mutex_unlock(&ftrace_cmd_mutex);
+
+	return ret;
+}
+
 static int ftrace_process_regex(char *buff, int len, int enable)
 {
-	char *func, *mod, *command, *next = buff;
+	struct ftrace_func_command *p;
+	char *func, *command, *next = buff;
+	int ret = -EINVAL;
 
 	func = strsep(&next, ":");
 
@@ -1250,21 +1334,21 @@ static int ftrace_process_regex(char *buff, int len, int enable)
 		return 0;
 	}
 
-	/* command fonud */
+	/* command found */
 
 	command = strsep(&next, ":");
 
-	if (strcmp(command, "mod") == 0) {
-		/* only match modules */
-		if (!next)
-			return -EINVAL;
-
-		mod = strsep(&next, ":");
-		ftrace_match_module_records(func, mod, enable);
-		return 0;
+	mutex_lock(&ftrace_cmd_mutex);
+	list_for_each_entry(p, &ftrace_commands, list) {
+		if (strcmp(p->name, command) == 0) {
+			ret = p->func(func, command, next, enable);
+			goto out_unlock;
+		}
 	}
+ out_unlock:
+	mutex_unlock(&ftrace_cmd_mutex);
 
-	return -EINVAL;
+	return ret;
 }
 
 static ssize_t
-- 
1.5.6.5

-- 
