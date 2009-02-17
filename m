Return-Path: <linux-kernel-owner+w=401wt.eu-S1751618AbZBQFPx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751618AbZBQFPx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Feb 2009 00:15:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752438AbZBQFOM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Feb 2009 00:14:12 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:42002 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751659AbZBQFOH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Feb 2009 00:14:07 -0500
Message-Id: <20090217051405.962230769@goodmis.org>
References: <20090217051227.957864159@goodmis.org>
User-Agent: quilt/0.46-1
Date: Tue, 17 Feb 2009 00:12:32 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Steven Rostedt <srostedt@redhat.com>
Subject: [PATCH 05/15] ftrace: add module command function filter selection
Content-Disposition: inline; filename=0005-ftrace-add-module-command-function-filter-selection.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

This patch adds a "command" syntax to the function filtering files:

  /debugfs/tracing/set_ftrace_filter
  /debugfs/tracing/set_ftrace_notrace

Of the format:  <function>:<command>:<parameter>

The command is optional, and dependent on the command, so are
the parameters.

 echo do_fork > set_ftrace_filter

Will only trace 'do_fork'.

 echo 'sched_*' > set_ftrace_filter

Will only trace functions starting with the letters 'sched_'.

 echo '*:mod:ext3' > set_ftrace_filter

Will trace only the ext3 module functions.

 echo '*write*:mod:ext3' > set_ftrace_notrace

Will prevent the ext3 functions with the letters 'write' in
the name from being traced.

 echo '!*_allocate:mod:ext3' > set_ftrace_filter

Will remove the functions in ext3 that end with the letters
'_allocate' from the ftrace filter.

Although this patch implements the 'command' format, only the
'mod' command is supported. More commands to follow.

Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---
 kernel/trace/ftrace.c |  115 ++++++++++++++++++++++++++++++++++++++++++++++---
 1 files changed, 109 insertions(+), 6 deletions(-)

diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index fcec313..9e60ae4 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -1067,7 +1067,7 @@ enum {
  *     0 otherwise.
  */
 static int
-ftrace_setup_glob(unsigned char *buff, int len, char **search, int *not)
+ftrace_setup_glob(char *buff, int len, char **search, int *not)
 {
 	int type = MATCH_FULL;
 	int i;
@@ -1100,14 +1100,11 @@ ftrace_setup_glob(unsigned char *buff, int len, char **search, int *not)
 	return type;
 }
 
-static int
-ftrace_match_record(struct dyn_ftrace *rec, char *regex, int len, int type)
+static int ftrace_match(char *str, char *regex, int len, int type)
 {
-	char str[KSYM_SYMBOL_LEN];
 	int matched = 0;
 	char *ptr;
 
-	kallsyms_lookup(rec->ip, NULL, NULL, NULL, str);
 	switch (type) {
 	case MATCH_FULL:
 		if (strcmp(str, regex) == 0)
@@ -1131,6 +1128,15 @@ ftrace_match_record(struct dyn_ftrace *rec, char *regex, int len, int type)
 	return matched;
 }
 
+static int
+ftrace_match_record(struct dyn_ftrace *rec, char *regex, int len, int type)
+{
+	char str[KSYM_SYMBOL_LEN];
+
+	kallsyms_lookup(rec->ip, NULL, NULL, NULL, str);
+	return ftrace_match(str, regex, len, type);
+}
+
 static void ftrace_match_records(char *buff, int len, int enable)
 {
 	char *search;
@@ -1165,6 +1171,100 @@ static void ftrace_match_records(char *buff, int len, int enable)
 	spin_unlock(&ftrace_lock);
 }
 
+static int
+ftrace_match_module_record(struct dyn_ftrace *rec, char *mod,
+			   char *regex, int len, int type)
+{
+	char str[KSYM_SYMBOL_LEN];
+	char *modname;
+
+	kallsyms_lookup(rec->ip, NULL, NULL, &modname, str);
+
+	if (!modname || strcmp(modname, mod))
+		return 0;
+
+	/* blank search means to match all funcs in the mod */
+	if (len)
+		return ftrace_match(str, regex, len, type);
+	else
+		return 1;
+}
+
+static void ftrace_match_module_records(char *buff, char *mod, int enable)
+{
+	char *search = buff;
+	struct ftrace_page *pg;
+	struct dyn_ftrace *rec;
+	int type = MATCH_FULL;
+	unsigned long flag = enable ? FTRACE_FL_FILTER : FTRACE_FL_NOTRACE;
+	unsigned search_len = 0;
+	int not = 0;
+
+	/* blank or '*' mean the same */
+	if (strcmp(buff, "*") == 0)
+		buff[0] = 0;
+
+	/* handle the case of 'dont filter this module' */
+	if (strcmp(buff, "!") == 0 || strcmp(buff, "!*") == 0) {
+		buff[0] = 0;
+		not = 1;
+	}
+
+	if (strlen(buff)) {
+		type = ftrace_setup_glob(buff, strlen(buff), &search, &not);
+		search_len = strlen(search);
+	}
+
+	/* should not be called from interrupt context */
+	spin_lock(&ftrace_lock);
+	if (enable)
+		ftrace_filtered = 1;
+
+	do_for_each_ftrace_rec(pg, rec) {
+
+		if (rec->flags & FTRACE_FL_FAILED)
+			continue;
+
+		if (ftrace_match_module_record(rec, mod,
+					       search, search_len, type)) {
+			if (not)
+				rec->flags &= ~flag;
+			else
+				rec->flags |= flag;
+		}
+
+	} while_for_each_ftrace_rec();
+	spin_unlock(&ftrace_lock);
+}
+
+static int ftrace_process_regex(char *buff, int len, int enable)
+{
+	char *func, *mod, *command, *next = buff;
+
+	func = strsep(&next, ":");
+
+	if (!next) {
+		ftrace_match_records(func, len, enable);
+		return 0;
+	}
+
+	/* command fonud */
+
+	command = strsep(&next, ":");
+
+	if (strcmp(command, "mod") == 0) {
+		/* only match modules */
+		if (!next)
+			return -EINVAL;
+
+		mod = strsep(&next, ":");
+		ftrace_match_module_records(func, mod, enable);
+		return 0;
+	}
+
+	return -EINVAL;
+}
+
 static ssize_t
 ftrace_regex_write(struct file *file, const char __user *ubuf,
 		   size_t cnt, loff_t *ppos, int enable)
@@ -1232,7 +1332,10 @@ ftrace_regex_write(struct file *file, const char __user *ubuf,
 	if (isspace(ch)) {
 		iter->filtered++;
 		iter->buffer[iter->buffer_idx] = 0;
-		ftrace_match_records(iter->buffer, iter->buffer_idx, enable);
+		ret = ftrace_process_regex(iter->buffer,
+					   iter->buffer_idx, enable);
+		if (ret)
+			goto out;
 		iter->buffer_idx = 0;
 	} else
 		iter->flags |= FTRACE_ITER_CONT;
-- 
1.5.6.5

-- 
