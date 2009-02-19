Return-Path: <linux-kernel-owner+w=401wt.eu-S1758205AbZBSVFX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758205AbZBSVFX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Feb 2009 16:05:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755648AbZBSVFH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Feb 2009 16:05:07 -0500
Received: from mail-bw0-f161.google.com ([209.85.218.161]:63325 "EHLO
	mail-bw0-f161.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754551AbZBSVFF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Feb 2009 16:05:05 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:from:to:cc:date:subject;
        b=UdMt2cNa7efNevyNWAh8I4gfarxHRP2+Z0zK8c6wFdtX4Gy8E41H0qumqfQu7ZFLiJ
         2zwe3/9nLO4qSU7ToZTTvCV+6O/lSHAiTR5fKabTxKjHHzI1b0hqkVmAXin0e+SNDufG
         fhojLIXnAADB0g77FmCRmVPqMjwJlDtt+a5Gk=
Message-ID: <499dc97d.257d420a.0f93.1be5@mx.google.com>
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>, linux-kernel@vger.kernel.org
Date: Thu, 19 Feb 2009 21:13:12 +0100
Subject: [PATCH] tracing/function-graph-tracer: make set_graph_function file support ftrace regex
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: trace only functions matching a pattern

The set_graph_function file let one to trace only one or several
chosen functions and follow all their code flow.

Currently, only a constant function name is allowed so this patch
allows the ftrace_regex functions:

_ matches all functions that end with "name":
  echo *name > set_graph_function

_ matches all functions that begin with "name":
  echo name* > set_graph_function

_ matches all functions that contains "name":
  echo *name* > set_graph_function

Example:

echo mutex* > set_graph_function

 0)               |  mutex_lock_nested() {
 0)   0.563 us    |    __might_sleep();
 0)   2.072 us    |  }
 0)               |  mutex_unlock() {
 0)   1.036 us    |    __mutex_unlock_slowpath();
 0)   2.433 us    |  }
 0)               |  mutex_unlock() {
 0)   0.691 us    |    __mutex_unlock_slowpath();
 0)   1.787 us    |  }
 0)               |  mutex_lock_interruptible_nested() {
 0)   0.548 us    |    __might_sleep();
 0)   1.945 us    |  }

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
---
 kernel/trace/ftrace.c |   56 +++++++++++++++++++++++++++++++++---------------
 1 files changed, 38 insertions(+), 18 deletions(-)

diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index 7dd5a2b..cf59f4c 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -1895,6 +1895,10 @@ static void *g_start(struct seq_file *m, loff_t *pos)
 
 	mutex_lock(&graph_lock);
 
+	/* Nothing, tell g_show to print all functions are enabled */
+	if (!ftrace_graph_count && !*pos)
+		return (void *)1;
+
 	p = g_next(m, p, pos);
 
 	return p;
@@ -1913,6 +1917,11 @@ static int g_show(struct seq_file *m, void *v)
 	if (!ptr)
 		return 0;
 
+	if (ptr == (unsigned long *)1) {
+		seq_printf(m, "#### all functions enabled ####\n");
+		return 0;
+	}
+
 	kallsyms_lookup(*ptr, NULL, NULL, NULL, str);
 
 	seq_printf(m, "%s\n", str);
@@ -1966,38 +1975,51 @@ ftrace_graph_read(struct file *file, char __user *ubuf,
 }
 
 static int
-ftrace_set_func(unsigned long *array, int idx, char *buffer)
+ftrace_set_func(unsigned long *array, int *idx, char *buffer)
 {
-	char str[KSYM_SYMBOL_LEN];
 	struct dyn_ftrace *rec;
 	struct ftrace_page *pg;
+	int search_len;
 	int found = 0;
-	int j;
+	int type, not;
+	char *search;
+	bool exists;
+	int i;
 
 	if (ftrace_disabled)
 		return -ENODEV;
 
+	/* decode regex */
+	type = ftrace_setup_glob(buffer, strlen(buffer), &search, &not);
+	if (not)
+		return -EINVAL;
+
+	search_len = strlen(search);
+
 	mutex_lock(&ftrace_lock);
 	do_for_each_ftrace_rec(pg, rec) {
 
+		if (*idx >= FTRACE_GRAPH_MAX_FUNCS)
+			break;
+
 		if (rec->flags & (FTRACE_FL_FAILED | FTRACE_FL_FREE))
 			continue;
 
-		kallsyms_lookup(rec->ip, NULL, NULL, NULL, str);
-		if (strcmp(str, buffer) == 0) {
-			/* Return 1 if we add it to the array */
-			found = 1;
-			for (j = 0; j < idx; j++)
-				if (array[j] == rec->ip) {
-					found = 0;
+		if (ftrace_match_record(rec, search, search_len, type)) {
+			/* ensure it is not already in the array */
+			exists = false;
+			for (i = 0; i < *idx; i++)
+				if (array[i] == rec->ip) {
+					exists = true;
 					break;
 				}
-			if (found)
-				array[idx] = rec->ip;
-			goto out;
+			if (!exists) {
+				array[(*idx)++] = rec->ip;
+				found = 1;
+			}
 		}
 	} while_for_each_ftrace_rec();
- out:
+
 	mutex_unlock(&ftrace_lock);
 
 	return found ? 0 : -EINVAL;
@@ -2066,13 +2088,11 @@ ftrace_graph_write(struct file *file, const char __user *ubuf,
 	}
 	buffer[index] = 0;
 
-	/* we allow only one at a time */
-	ret = ftrace_set_func(array, ftrace_graph_count, buffer);
+	/* we allow only one expression at a time */
+	ret = ftrace_set_func(array, &ftrace_graph_count, buffer);
 	if (ret)
 		goto out;
 
-	ftrace_graph_count++;
-
 	file->f_pos += read;
 
 	ret = read;
-- 
1.6.1


