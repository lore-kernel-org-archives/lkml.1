Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752530Ab0BJHms (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Feb 2010 02:42:48 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:54572 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750749Ab0BJHmr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Feb 2010 02:42:47 -0500
Message-ID: <4B726388.2000408@cn.fujitsu.com>
Date: Wed, 10 Feb 2010 15:43:04 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] ftrace: Allow to remove a single function from function graph
 filter
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I don't see why we can only clear all functions from the filter.

After patching:

  # echo sys_open > set_graph_function
  # echo sys_close >> set_graph_function
  # cat set_graph_function
  sys_open
  sys_close
  # echo '!sys_close' >> set_graph_function
  # cat set_graph_function
  sys_open

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
---
 kernel/trace/ftrace.c |   51 +++++++++++++++++++++++++++++-------------------
 kernel/trace/trace.h  |    3 +-
 2 files changed, 33 insertions(+), 21 deletions(-)

diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index 1904797..8378357 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -2402,6 +2402,7 @@ static const struct file_operations ftrace_notrace_fops = {
 static DEFINE_MUTEX(graph_lock);
 
 int ftrace_graph_count;
+int ftrace_graph_filter_enabled;
 unsigned long ftrace_graph_funcs[FTRACE_GRAPH_MAX_FUNCS] __read_mostly;
 
 static void *
@@ -2424,7 +2425,7 @@ static void *g_start(struct seq_file *m, loff_t *pos)
 	mutex_lock(&graph_lock);
 
 	/* Nothing, tell g_show to print all functions are enabled */
-	if (!ftrace_graph_count && !*pos)
+	if (!ftrace_graph_filter_enabled && !*pos)
 		return (void *)1;
 
 	return __g_next(m, pos);
@@ -2470,6 +2471,7 @@ ftrace_graph_open(struct inode *inode, struct file *file)
 	mutex_lock(&graph_lock);
 	if ((file->f_mode & FMODE_WRITE) &&
 	    (file->f_flags & O_TRUNC)) {
+		ftrace_graph_filter_enabled = 0;
 		ftrace_graph_count = 0;
 		memset(ftrace_graph_funcs, 0, sizeof(ftrace_graph_funcs));
 	}
@@ -2495,7 +2497,7 @@ ftrace_set_func(unsigned long *array, int *idx, char *buffer)
 	struct dyn_ftrace *rec;
 	struct ftrace_page *pg;
 	int search_len;
-	int found = 0;
+	int fail = 1;
 	int type, not;
 	char *search;
 	bool exists;
@@ -2506,37 +2508,51 @@ ftrace_set_func(unsigned long *array, int *idx, char *buffer)
 
 	/* decode regex */
 	type = filter_parse_regex(buffer, strlen(buffer), &search, &not);
-	if (not)
-		return -EINVAL;
+	if (!not && *idx >= FTRACE_GRAPH_MAX_FUNCS)
+		return -EBUSY;
 
 	search_len = strlen(search);
 
 	mutex_lock(&ftrace_lock);
 	do_for_each_ftrace_rec(pg, rec) {
 
-		if (*idx >= FTRACE_GRAPH_MAX_FUNCS)
-			break;
-
 		if (rec->flags & (FTRACE_FL_FAILED | FTRACE_FL_FREE))
 			continue;
 
 		if (ftrace_match_record(rec, search, search_len, type)) {
-			/* ensure it is not already in the array */
+			/* if it is in the array */
 			exists = false;
-			for (i = 0; i < *idx; i++)
+			for (i = 0; i < *idx; i++) {
 				if (array[i] == rec->ip) {
 					exists = true;
 					break;
 				}
-			if (!exists)
-				array[(*idx)++] = rec->ip;
-			found = 1;
+			}
+
+			if (!not) {
+				fail = 0;
+				if (!exists) {
+					array[(*idx)++] = rec->ip;
+					if (*idx >= FTRACE_GRAPH_MAX_FUNCS)
+						goto out;
+				}
+			} else {
+				if (exists) {
+					array[i] = array[--(*idx)];
+					array[*idx] = 0;
+					fail = 0;
+				}
+			}
 		}
 	} while_for_each_ftrace_rec();
-
+out:
 	mutex_unlock(&ftrace_lock);
 
-	return found ? 0 : -EINVAL;
+	if (fail)
+		return -EINVAL;
+
+	ftrace_graph_filter_enabled = 1;
+	return 0;
 }
 
 static ssize_t
@@ -2546,16 +2562,11 @@ ftrace_graph_write(struct file *file, const char __user *ubuf,
 	struct trace_parser parser;
 	ssize_t read, ret;
 
-	if (!cnt || cnt < 0)
+	if (!cnt)
 		return 0;
 
 	mutex_lock(&graph_lock);
 
-	if (ftrace_graph_count >= FTRACE_GRAPH_MAX_FUNCS) {
-		ret = -EBUSY;
-		goto out_unlock;
-	}
-
 	if (trace_parser_get_init(&parser, FTRACE_BUFF_MAX)) {
 		ret = -ENOMEM;
 		goto out_unlock;
diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
index 9a69b9c..d2929ca 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -499,6 +499,7 @@ trace_print_graph_duration(unsigned long long duration, struct trace_seq *s);
 #ifdef CONFIG_DYNAMIC_FTRACE
 /* TODO: make this variable */
 #define FTRACE_GRAPH_MAX_FUNCS		32
+extern int ftrace_graph_filter_enabled;
 extern int ftrace_graph_count;
 extern unsigned long ftrace_graph_funcs[FTRACE_GRAPH_MAX_FUNCS];
 
@@ -506,7 +507,7 @@ static inline int ftrace_graph_addr(unsigned long addr)
 {
 	int i;
 
-	if (!ftrace_graph_count)
+	if (!ftrace_graph_filter_enabled)
 		return 1;
 
 	for (i = 0; i < ftrace_graph_count; i++) {
-- 
1.6.3

