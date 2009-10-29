Return-Path: <linux-kernel-owner+w=401wt.eu-S1756078AbZJ2VFq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756078AbZJ2VFq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Oct 2009 17:05:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755623AbZJ2VF2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Oct 2009 17:05:28 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:41582 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754164AbZJ2VFX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Oct 2009 17:05:23 -0400
Message-Id: <20091029210526.883556842@goodmis.org>
User-Agent: quilt/0.48-1
Date: Thu, 29 Oct 2009 16:51:53 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Li Zefan <lizf@cn.fujitsu.com>,
       Lai Jiangshan <laijs@cn.fujitsu.com>,
       "David S. Miller" <davem@davemloft.net>,
       Stephen Hemminger <shemminger@linux-foundation.org>
Subject: [PATCH 2/3][RFC] [PATCH 2/3] tracing: Add calls to permanently disable functions from tracing
References: <20091029205151.852744305@goodmis.org>
Content-Disposition: inline; filename=0002-tracing-Add-calls-to-permanently-disable-functions-f.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

There are cases in the kernel where functions need to be dynamically
disabled from tracing. One known instance is with jprobes. Functions
registered as a jprobe will not work with the funtion graph tracer.
This is because the implementation of jprobes and the function graph
tracer collide, and will cause the function graph tracer to panic the
kernel.

This patch adds ftrace_set_disable() and ftrace_disable_function()
to allow other parts of the kernel to mark a function as not to be traced.
These two new functions will permanently disable the function passed in
from being traced by the function and function graph tracer.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 include/linux/ftrace.h |    4 +
 kernel/trace/ftrace.c  |  147 +++++++++++++++++++++++++++++++++++++++++-------
 2 files changed, 130 insertions(+), 21 deletions(-)

diff --git a/include/linux/ftrace.h b/include/linux/ftrace.h
index 5d31e93..0d518ef 100644
--- a/include/linux/ftrace.h
+++ b/include/linux/ftrace.h
@@ -159,6 +159,8 @@ struct dyn_ftrace {
 int ftrace_force_update(void);
 void ftrace_set_filter(unsigned char *buf, int len, int reset);
 void ftrace_set_notrace(unsigned char *buf, int len, int reset);
+void ftrace_set_disable(unsigned char *buf, int len);
+void ftrace_disable_function(void *func);
 
 int register_ftrace_command(struct ftrace_func_command *cmd);
 int unregister_ftrace_command(struct ftrace_func_command *cmd);
@@ -251,6 +253,8 @@ static inline void
 ftrace_set_filter(unsigned char *buf, int len, int reset) { }
 static inline void
 ftrace_set_notrace(unsigned char *buf, int len, int reset) { }
+static inline void ftrace_set_disable(unsigned char *buf, int len) { }
+static inline void ftrace_disable_function(void *func) { }
 static inline void ftrace_release_mod(struct module *mod) {}
 static inline int register_ftrace_command(struct ftrace_func_command *cmd)
 {
diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index 1ed514f..b1d784c 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -60,6 +60,18 @@ static int last_ftrace_enabled;
 /* Quick disabling of function tracer. */
 int function_trace_stop;
 
+/*
+ * Flags to pass to regex functions.
+ *  NOTRACE - set the function to not be traced
+ *  FILTER  - set the function to be filtered (only these function are traced)
+ *  DISABLE - disable the function completely (do not let users enable it)
+ */
+enum ftrace_regex {
+	FTRACE_REGEX_NOTRACE		= 0,
+	FTRACE_REGEX_FILTER		= 1,
+	FTRACE_REGEX_DISABLE		= 2,
+};
+
 /* List for set_ftrace_pid's pids. */
 LIST_HEAD(ftrace_pids);
 struct ftrace_pid {
@@ -1602,12 +1614,16 @@ ftrace_failures_open(struct inode *inode, struct file *file)
 }
 
 
-static void ftrace_filter_reset(int enable)
+static void ftrace_filter_reset(enum ftrace_regex enable)
 {
 	struct ftrace_page *pg;
 	struct dyn_ftrace *rec;
 	unsigned long type = enable ? FTRACE_FL_FILTER : FTRACE_FL_NOTRACE;
 
+	/* This function should never be called with DISABLE */
+	if (WARN_ON_ONCE(enable == FTRACE_REGEX_DISABLE))
+		return;
+
 	mutex_lock(&ftrace_lock);
 	if (enable)
 		ftrace_filtered = 0;
@@ -1620,11 +1636,16 @@ static void ftrace_filter_reset(int enable)
 }
 
 static int
-ftrace_regex_open(struct inode *inode, struct file *file, int enable)
+ftrace_regex_open(struct inode *inode, struct file *file,
+		  enum ftrace_regex enable)
 {
 	struct ftrace_iterator *iter;
 	int ret = 0;
 
+	/* Users should not be able to permanently disable functions */
+	if (WARN_ON_ONCE(enable == FTRACE_REGEX_DISABLE))
+		return -EINVAL;
+
 	if (unlikely(ftrace_disabled))
 		return -ENODEV;
 
@@ -1665,13 +1686,13 @@ ftrace_regex_open(struct inode *inode, struct file *file, int enable)
 static int
 ftrace_filter_open(struct inode *inode, struct file *file)
 {
-	return ftrace_regex_open(inode, file, 1);
+	return ftrace_regex_open(inode, file, FTRACE_REGEX_FILTER);
 }
 
 static int
 ftrace_notrace_open(struct inode *inode, struct file *file)
 {
-	return ftrace_regex_open(inode, file, 0);
+	return ftrace_regex_open(inode, file, FTRACE_REGEX_NOTRACE);
 }
 
 static loff_t
@@ -1724,7 +1745,8 @@ ftrace_match_record(struct dyn_ftrace *rec, char *regex, int len, int type)
 	return ftrace_match(str, regex, len, type);
 }
 
-static void ftrace_match_records(char *buff, int len, int enable)
+static void ftrace_match_records(char *buff, int len,
+				 enum ftrace_regex enable)
 {
 	unsigned int search_len;
 	struct ftrace_page *pg;
@@ -1734,7 +1756,21 @@ static void ftrace_match_records(char *buff, int len, int enable)
 	int type;
 	int not;
 
-	flag = enable ? FTRACE_FL_FILTER : FTRACE_FL_NOTRACE;
+	switch (enable) {
+	case FTRACE_REGEX_NOTRACE:
+		flag = FTRACE_FL_NOTRACE;
+		break;
+	case FTRACE_REGEX_FILTER:
+		flag = FTRACE_FL_FILTER;
+		break;
+	case FTRACE_REGEX_DISABLE:
+		flag = FTRACE_FL_FAILED;
+		break;
+	default:
+		WARN_ON_ONCE(1);
+		return;
+	}
+
 	type = filter_parse_regex(buff, len, &search, &not);
 
 	search_len = strlen(search);
@@ -1755,7 +1791,8 @@ static void ftrace_match_records(char *buff, int len, int enable)
 		 * Only enable filtering if we have a function that
 		 * is filtered on.
 		 */
-		if (enable && (rec->flags & FTRACE_FL_FILTER))
+		if (enable == FTRACE_REGEX_FILTER &&
+		    (rec->flags & FTRACE_FL_FILTER))
 			ftrace_filtered = 1;
 	} while_for_each_ftrace_rec();
 	mutex_unlock(&ftrace_lock);
@@ -1763,7 +1800,8 @@ static void ftrace_match_records(char *buff, int len, int enable)
 
 static int
 ftrace_match_module_record(struct dyn_ftrace *rec, char *mod,
-			   char *regex, int len, int type)
+			   char *regex, int len,
+			   enum ftrace_regex enable)
 {
 	char str[KSYM_SYMBOL_LEN];
 	char *modname;
@@ -1775,12 +1813,13 @@ ftrace_match_module_record(struct dyn_ftrace *rec, char *mod,
 
 	/* blank search means to match all funcs in the mod */
 	if (len)
-		return ftrace_match(str, regex, len, type);
+		return ftrace_match(str, regex, len, enable);
 	else
 		return 1;
 }
 
-static void ftrace_match_module_records(char *buff, char *mod, int enable)
+static void ftrace_match_module_records(char *buff, char *mod,
+					enum ftrace_regex enable)
 {
 	unsigned search_len = 0;
 	struct ftrace_page *pg;
@@ -1790,6 +1829,10 @@ static void ftrace_match_module_records(char *buff, char *mod, int enable)
 	unsigned long flag;
 	int not = 0;
 
+	/* this function should not be called for disabling */
+	if (WARN_ON_ONCE(enable == FTRACE_REGEX_DISABLE))
+		return;
+
 	flag = enable ? FTRACE_FL_FILTER : FTRACE_FL_NOTRACE;
 
 	/* blank or '*' mean the same */
@@ -2142,12 +2185,16 @@ int unregister_ftrace_command(struct ftrace_func_command *cmd)
 	return ret;
 }
 
-static int ftrace_process_regex(char *buff, int len, int enable)
+static int ftrace_process_regex(char *buff, int len,
+				enum ftrace_regex enable)
 {
 	char *func, *command, *next = buff;
 	struct ftrace_func_command *p;
 	int ret = -EINVAL;
 
+	if (enable == FTRACE_REGEX_DISABLE)
+		return -EINVAL;
+
 	func = strsep(&next, ":");
 
 	if (!next) {
@@ -2174,7 +2221,7 @@ static int ftrace_process_regex(char *buff, int len, int enable)
 
 static ssize_t
 ftrace_regex_write(struct file *file, const char __user *ubuf,
-		   size_t cnt, loff_t *ppos, int enable)
+		   size_t cnt, loff_t *ppos, enum ftrace_regex enable)
 {
 	struct ftrace_iterator *iter;
 	struct trace_parser *parser;
@@ -2183,6 +2230,9 @@ ftrace_regex_write(struct file *file, const char __user *ubuf,
 	if (!cnt)
 		return 0;
 
+	if (WARN_ON_ONCE(enable == FTRACE_REGEX_DISABLE))
+		return -EINVAL;
+
 	mutex_lock(&ftrace_regex_lock);
 
 	if (file->f_mode & FMODE_READ) {
@@ -2215,27 +2265,35 @@ static ssize_t
 ftrace_filter_write(struct file *file, const char __user *ubuf,
 		    size_t cnt, loff_t *ppos)
 {
-	return ftrace_regex_write(file, ubuf, cnt, ppos, 1);
+	return ftrace_regex_write(file, ubuf, cnt, ppos, FTRACE_REGEX_FILTER);
 }
 
 static ssize_t
 ftrace_notrace_write(struct file *file, const char __user *ubuf,
 		     size_t cnt, loff_t *ppos)
 {
-	return ftrace_regex_write(file, ubuf, cnt, ppos, 0);
+	return ftrace_regex_write(file, ubuf, cnt, ppos, FTRACE_REGEX_NOTRACE);
 }
 
 static void
-ftrace_set_regex(unsigned char *buf, int len, int reset, int enable)
+__ftrace_set_regex(unsigned char *buf, int len, int reset,
+		   enum ftrace_regex enable)
 {
 	if (unlikely(ftrace_disabled))
 		return;
 
-	mutex_lock(&ftrace_regex_lock);
 	if (reset)
 		ftrace_filter_reset(enable);
 	if (buf)
 		ftrace_match_records(buf, len, enable);
+}
+
+static void
+ftrace_set_regex(unsigned char *buf, int len, int reset,
+		 enum ftrace_regex enable)
+{
+	mutex_lock(&ftrace_regex_lock);
+	__ftrace_set_regex(buf, len, reset, enable);
 	mutex_unlock(&ftrace_regex_lock);
 }
 
@@ -2250,7 +2308,7 @@ ftrace_set_regex(unsigned char *buf, int len, int reset, int enable)
  */
 void ftrace_set_filter(unsigned char *buf, int len, int reset)
 {
-	ftrace_set_regex(buf, len, reset, 1);
+	ftrace_set_regex(buf, len, reset, FTRACE_REGEX_FILTER);
 }
 
 /**
@@ -2265,7 +2323,53 @@ void ftrace_set_filter(unsigned char *buf, int len, int reset)
  */
 void ftrace_set_notrace(unsigned char *buf, int len, int reset)
 {
-	ftrace_set_regex(buf, len, reset, 0);
+	ftrace_set_regex(buf, len, reset, FTRACE_REGEX_NOTRACE);
+}
+
+/**
+ * ftrace_set_disable - permanently disable function from tracing
+ * @buf - the string that holds the function to be disabled.
+ * @len - the length of the string.
+ *
+ * This will permanently disable @buf function from ever being
+ * traced.
+ */
+void ftrace_set_disable(unsigned char *buf, int len)
+{
+	if (len < 0)
+		return;
+	mutex_lock(&ftrace_regex_lock);
+	/*
+	 * If function tracer is currently running, we must disable
+	 * the function first using the notrace filter. Otherwise
+	 * we will end up doing the opposite of what we want.
+	 * We would permanently enable the function.
+	 */
+	mutex_lock(&ftrace_lock);
+	if (ftrace_start_up && ftrace_enabled) {
+		__ftrace_set_regex(buf, len, 0, FTRACE_REGEX_NOTRACE);
+		ftrace_run_update_code(FTRACE_ENABLE_CALLS);
+	}
+	mutex_unlock(&ftrace_lock);
+	__ftrace_set_regex(buf, len, 0, FTRACE_REGEX_DISABLE);
+	mutex_unlock(&ftrace_regex_lock);
+ }
+
+/**
+ * ftrace_disable_function - permanently disable a function from tracing
+ * @func - a pointer to the function to be disabled.
+ *
+ * This is called by code that registers functions dynamically that
+ * can cause a problem with tracing. For example, kprobes can use
+ * this to prevent a probe function from being traced.
+ */
+void ftrace_disable_function(void *func)
+{
+	char str[KSYM_SYMBOL_LEN];
+
+	/* Get the name of this function */
+	kallsyms_lookup((unsigned long)func, NULL, NULL, NULL, str);
+	ftrace_set_disable(str, strlen(str));
 }
 
 /*
@@ -2338,7 +2442,8 @@ static void __init set_ftrace_early_filters(void)
 }
 
 static int
-ftrace_regex_release(struct inode *inode, struct file *file, int enable)
+ftrace_regex_release(struct inode *inode, struct file *file,
+		     enum ftrace_regex enable)
 {
 	struct seq_file *m = (struct seq_file *)file->private_data;
 	struct ftrace_iterator *iter;
@@ -2373,13 +2478,13 @@ ftrace_regex_release(struct inode *inode, struct file *file, int enable)
 static int
 ftrace_filter_release(struct inode *inode, struct file *file)
 {
-	return ftrace_regex_release(inode, file, 1);
+	return ftrace_regex_release(inode, file, FTRACE_REGEX_FILTER);
 }
 
 static int
 ftrace_notrace_release(struct inode *inode, struct file *file)
 {
-	return ftrace_regex_release(inode, file, 0);
+	return ftrace_regex_release(inode, file, FTRACE_REGEX_NOTRACE);
 }
 
 static const struct file_operations ftrace_avail_fops = {
-- 
1.6.3.3


