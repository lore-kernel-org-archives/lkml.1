Return-Path: <linux-kernel-owner+w=401wt.eu-S1752927AbZILHzU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752927AbZILHzU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Sep 2009 03:55:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752821AbZILHzS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Sep 2009 03:55:18 -0400
Received: from hera.kernel.org ([140.211.167.34]:38982 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752442AbZILHzN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Sep 2009 03:55:13 -0400
Date: Sat, 12 Sep 2009 07:55:01 GMT
From: "tip-bot for jolsa@redhat.com" <jolsa@redhat.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       rostedt@goodmis.org, tglx@linutronix.de, jolsa@redhat.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       rostedt@goodmis.org, tglx@linutronix.de, jolsa@redhat.com
In-Reply-To: <1252682969-3366-4-git-send-email-jolsa@redhat.com>
References: <1252682969-3366-4-git-send-email-jolsa@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:tracing/core] tracing: trace parser support for function and graph
Message-ID: <tip-689fd8b65d669b96d612ccc37d6fb87bf7ed6907@git.kernel.org>
Git-Commit-ID: 689fd8b65d669b96d612ccc37d6fb87bf7ed6907
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Sat, 12 Sep 2009 07:55:02 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  689fd8b65d669b96d612ccc37d6fb87bf7ed6907
Gitweb:     http://git.kernel.org/tip/689fd8b65d669b96d612ccc37d6fb87bf7ed6907
Author:     jolsa@redhat.com <jolsa@redhat.com>
AuthorDate: Fri, 11 Sep 2009 17:29:29 +0200
Committer:  Steven Rostedt <rostedt@goodmis.org>
CommitDate: Fri, 11 Sep 2009 15:20:18 -0400

tracing: trace parser support for function and graph

Convert the writing to 'set_graph_function', 'set_ftrace_filter'
and 'set_ftrace_notrace' to use the generic trace_parser
'trace_get_user' function.

Removed FTRACE_ITER_CONT flag, since it's not needed after this change.

Minor fix in set_graph_function display - g_show function.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
LKML-Reference: <1252682969-3366-4-git-send-email-jolsa@redhat.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>


---
 kernel/trace/ftrace.c |  150 +++++++++++++------------------------------------
 1 files changed, 40 insertions(+), 110 deletions(-)

diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index 8c804e2..8b23d56 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -1323,11 +1323,10 @@ static int __init ftrace_dyn_table_alloc(unsigned long num_to_init)
 
 enum {
 	FTRACE_ITER_FILTER	= (1 << 0),
-	FTRACE_ITER_CONT	= (1 << 1),
-	FTRACE_ITER_NOTRACE	= (1 << 2),
-	FTRACE_ITER_FAILURES	= (1 << 3),
-	FTRACE_ITER_PRINTALL	= (1 << 4),
-	FTRACE_ITER_HASH	= (1 << 5),
+	FTRACE_ITER_NOTRACE	= (1 << 1),
+	FTRACE_ITER_FAILURES	= (1 << 2),
+	FTRACE_ITER_PRINTALL	= (1 << 3),
+	FTRACE_ITER_HASH	= (1 << 4),
 };
 
 #define FTRACE_BUFF_MAX (KSYM_SYMBOL_LEN+4) /* room for wildcards */
@@ -1337,8 +1336,7 @@ struct ftrace_iterator {
 	int			hidx;
 	int			idx;
 	unsigned		flags;
-	unsigned char		buffer[FTRACE_BUFF_MAX+1];
-	unsigned		buffer_idx;
+	struct trace_parser	parser;
 };
 
 static void *
@@ -1604,6 +1602,11 @@ ftrace_regex_open(struct inode *inode, struct file *file, int enable)
 	if (!iter)
 		return -ENOMEM;
 
+	if (trace_parser_get_init(&iter->parser, FTRACE_BUFF_MAX)) {
+		kfree(iter);
+		return -ENOMEM;
+	}
+
 	mutex_lock(&ftrace_regex_lock);
 	if ((file->f_mode & FMODE_WRITE) &&
 	    (file->f_flags & O_TRUNC))
@@ -2196,9 +2199,8 @@ ftrace_regex_write(struct file *file, const char __user *ubuf,
 		   size_t cnt, loff_t *ppos, int enable)
 {
 	struct ftrace_iterator *iter;
-	char ch;
-	size_t read = 0;
-	ssize_t ret;
+	struct trace_parser *parser;
+	ssize_t ret, read;
 
 	if (!cnt || cnt < 0)
 		return 0;
@@ -2211,72 +2213,23 @@ ftrace_regex_write(struct file *file, const char __user *ubuf,
 	} else
 		iter = file->private_data;
 
-	if (!*ppos) {
-		iter->flags &= ~FTRACE_ITER_CONT;
-		iter->buffer_idx = 0;
-	}
-
-	ret = get_user(ch, ubuf++);
-	if (ret)
-		goto out;
-	read++;
-	cnt--;
-
-	/*
-	 * If the parser haven't finished with the last write,
-	 * continue reading the user input without skipping spaces.
-	 */
-	if (!(iter->flags & FTRACE_ITER_CONT)) {
-		/* skip white space */
-		while (cnt && isspace(ch)) {
-			ret = get_user(ch, ubuf++);
-			if (ret)
-				goto out;
-			read++;
-			cnt--;
-		}
+	parser = &iter->parser;
+	read = trace_get_user(parser, ubuf, cnt, ppos);
 
-		/* only spaces were written */
-		if (isspace(ch)) {
-			*ppos += read;
-			ret = read;
-			goto out;
-		}
-
-		iter->buffer_idx = 0;
-	}
-
-	while (cnt && !isspace(ch)) {
-		if (iter->buffer_idx < FTRACE_BUFF_MAX)
-			iter->buffer[iter->buffer_idx++] = ch;
-		else {
-			ret = -EINVAL;
-			goto out;
-		}
-		ret = get_user(ch, ubuf++);
+	if (trace_parser_loaded(parser) &&
+	    !trace_parser_cont(parser)) {
+		ret = ftrace_process_regex(parser->buffer,
+					   parser->idx, enable);
 		if (ret)
 			goto out;
-		read++;
-		cnt--;
-	}
 
-	if (isspace(ch)) {
-		iter->buffer[iter->buffer_idx] = 0;
-		ret = ftrace_process_regex(iter->buffer,
-					   iter->buffer_idx, enable);
-		if (ret)
-			goto out;
-		iter->buffer_idx = 0;
-	} else {
-		iter->flags |= FTRACE_ITER_CONT;
-		iter->buffer[iter->buffer_idx++] = ch;
+		trace_parser_clear(parser);
 	}
 
-	*ppos += read;
 	ret = read;
- out:
-	mutex_unlock(&ftrace_regex_lock);
 
+	mutex_unlock(&ftrace_regex_lock);
+out:
 	return ret;
 }
 
@@ -2381,6 +2334,7 @@ ftrace_regex_release(struct inode *inode, struct file *file, int enable)
 {
 	struct seq_file *m = (struct seq_file *)file->private_data;
 	struct ftrace_iterator *iter;
+	struct trace_parser *parser;
 
 	mutex_lock(&ftrace_regex_lock);
 	if (file->f_mode & FMODE_READ) {
@@ -2390,9 +2344,10 @@ ftrace_regex_release(struct inode *inode, struct file *file, int enable)
 	} else
 		iter = file->private_data;
 
-	if (iter->buffer_idx) {
-		iter->buffer[iter->buffer_idx] = 0;
-		ftrace_match_records(iter->buffer, iter->buffer_idx, enable);
+	parser = &iter->parser;
+	if (trace_parser_loaded(parser)) {
+		parser->buffer[parser->idx] = 0;
+		ftrace_match_records(parser->buffer, parser->idx, enable);
 	}
 
 	mutex_lock(&ftrace_lock);
@@ -2400,7 +2355,9 @@ ftrace_regex_release(struct inode *inode, struct file *file, int enable)
 		ftrace_run_update_code(FTRACE_ENABLE_CALLS);
 	mutex_unlock(&ftrace_lock);
 
+	trace_parser_put(parser);
 	kfree(iter);
+
 	mutex_unlock(&ftrace_regex_lock);
 	return 0;
 }
@@ -2499,7 +2456,7 @@ static int g_show(struct seq_file *m, void *v)
 		return 0;
 	}
 
-	seq_printf(m, "%pf\n", v);
+	seq_printf(m, "%pf\n", (void *)*ptr);
 
 	return 0;
 }
@@ -2602,12 +2559,10 @@ static ssize_t
 ftrace_graph_write(struct file *file, const char __user *ubuf,
 		   size_t cnt, loff_t *ppos)
 {
-	unsigned char buffer[FTRACE_BUFF_MAX+1];
+	struct trace_parser parser;
 	unsigned long *array;
 	size_t read = 0;
 	ssize_t ret;
-	int index = 0;
-	char ch;
 
 	if (!cnt || cnt < 0)
 		return 0;
@@ -2625,51 +2580,26 @@ ftrace_graph_write(struct file *file, const char __user *ubuf,
 	} else
 		array = file->private_data;
 
-	ret = get_user(ch, ubuf++);
-	if (ret)
+	if (trace_parser_get_init(&parser, FTRACE_BUFF_MAX)) {
+		ret = -ENOMEM;
 		goto out;
-	read++;
-	cnt--;
-
-	/* skip white space */
-	while (cnt && isspace(ch)) {
-		ret = get_user(ch, ubuf++);
-		if (ret)
-			goto out;
-		read++;
-		cnt--;
 	}
 
-	if (isspace(ch)) {
-		*ppos += read;
-		ret = read;
-		goto out;
-	}
+	read = trace_get_user(&parser, ubuf, cnt, ppos);
 
-	while (cnt && !isspace(ch)) {
-		if (index < FTRACE_BUFF_MAX)
-			buffer[index++] = ch;
-		else {
-			ret = -EINVAL;
-			goto out;
-		}
-		ret = get_user(ch, ubuf++);
+	if (trace_parser_loaded((&parser))) {
+		parser.buffer[parser.idx] = 0;
+
+		/* we allow only one expression at a time */
+		ret = ftrace_set_func(array, &ftrace_graph_count,
+					parser.buffer);
 		if (ret)
 			goto out;
-		read++;
-		cnt--;
 	}
-	buffer[index] = 0;
-
-	/* we allow only one expression at a time */
-	ret = ftrace_set_func(array, &ftrace_graph_count, buffer);
-	if (ret)
-		goto out;
-
-	file->f_pos += read;
 
 	ret = read;
  out:
+	trace_parser_put(&parser);
 	mutex_unlock(&graph_lock);
 
 	return ret;
