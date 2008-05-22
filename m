Return-Path: <linux-kernel-owner+w=401wt.eu-S1754261AbYEVPqs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754261AbYEVPqs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2008 11:46:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752817AbYEVPqh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 May 2008 11:46:37 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:59209 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752686AbYEVPqg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2008 11:46:36 -0400
Date: Thu, 22 May 2008 11:46:33 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Ingo Molnar <mingo@elte.hu>
cc: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] ftrace: set_ftrace_notrace feature
Message-ID: <Pine.LNX.4.58.0805221145040.14724@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


While debugging latencies in the RT kernel, I found that it would be nice
to be able to filter away functions from the trace than just to filter
on functions.

I added a new interface to the debugfs tracing directory called

  set_ftrace_notrace

When dynamic frace is enabled, this lets you filter away functions that will
not be recorded in the trace. It is similar to adding 'notrace' to those
functions but by doing it without recompiling the kernel.

Here's how set_ftrace_filter and set_ftrace_notrace interact. Remember, if
set_ftrace_filter is set, it removes all functions from the trace execpt for
those listed in the set_ftrace_filter. set_ftrace_notrace will prevent those
functions from being traced.

If you were to set one function in both set_ftrace_filter and
set_ftrace_notrace and that function was the same, then you would end up
with an empty trace.

the set of functions to trace is:

  set_ftrace_filter == empty then

     all functions not in set_ftrace_notrace

  else

     set of the set_ftrace_filter and not in set of set_ftrace_notrace.


Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---
 include/linux/ftrace.h |    1
 kernel/trace/ftrace.c  |  170 +++++++++++++++++++++++++++++++++++++------------
 2 files changed, 131 insertions(+), 40 deletions(-)

Index: linux-tip.git/include/linux/ftrace.h
===================================================================
--- linux-tip.git.orig/include/linux/ftrace.h	2008-05-22 08:07:35.000000000 -0400
+++ linux-tip.git/include/linux/ftrace.h	2008-05-22 08:07:59.000000000 -0400
@@ -48,6 +48,7 @@ enum {
 	FTRACE_FL_FAILED	= (1 << 1),
 	FTRACE_FL_FILTER	= (1 << 2),
 	FTRACE_FL_ENABLED	= (1 << 3),
+	FTRACE_FL_NOTRACE	= (1 << 4),
 };

 struct dyn_ftrace {
Index: linux-tip.git/kernel/trace/ftrace.c
===================================================================
--- linux-tip.git.orig/kernel/trace/ftrace.c	2008-05-22 00:10:40.000000000 -0400
+++ linux-tip.git/kernel/trace/ftrace.c	2008-05-22 10:38:38.000000000 -0400
@@ -170,7 +170,7 @@ static DEFINE_PER_CPU(int, ftrace_shutdo

 static DEFINE_SPINLOCK(ftrace_shutdown_lock);
 static DEFINE_MUTEX(ftraced_lock);
-static DEFINE_MUTEX(ftrace_filter_lock);
+static DEFINE_MUTEX(ftrace_regex_lock);

 struct ftrace_page {
 	struct ftrace_page	*next;
@@ -337,13 +337,12 @@ static void
 __ftrace_replace_code(struct dyn_ftrace *rec,
 		      unsigned char *old, unsigned char *new, int enable)
 {
-	unsigned long ip;
+	unsigned long ip, fl;
 	int failed;

 	ip = rec->ip;

 	if (ftrace_filtered && enable) {
-		unsigned long fl;
 		/*
 		 * If filtering is on:
 		 *
@@ -356,13 +355,16 @@ __ftrace_replace_code(struct dyn_ftrace
 		 * If this record is not set to be filtered
 		 * and it is not enabled do nothing.
 		 *
+		 * If this record is set not to trace then
+		 * do nothing.
+		 *
 		 * If this record is not set to be filtered and
 		 * it is enabled, disable it.
 		 */
 		fl = rec->flags & (FTRACE_FL_FILTER | FTRACE_FL_ENABLED);

 		if ((fl ==  (FTRACE_FL_FILTER | FTRACE_FL_ENABLED)) ||
-		    (fl == 0))
+		    (fl == 0) || (rec->flags & FTRACE_FL_NOTRACE))
 			return;

 		/*
@@ -380,9 +382,17 @@ __ftrace_replace_code(struct dyn_ftrace
 		}
 	} else {

-		if (enable)
+		if (enable) {
+			/*
+			 * If this record is set not to trace and is
+			 * not enabled, do nothing.
+			 */
+			fl = rec->flags & (FTRACE_FL_NOTRACE | FTRACE_FL_ENABLED);
+			if (fl == FTRACE_FL_NOTRACE)
+				return;
+
 			new = ftrace_call_replace(ip, FTRACE_ADDR);
-		else
+		} else
 			old = ftrace_call_replace(ip, FTRACE_ADDR);

 		if (enable) {
@@ -721,6 +731,7 @@ static int __init ftrace_dyn_table_alloc
 enum {
 	FTRACE_ITER_FILTER	= (1 << 0),
 	FTRACE_ITER_CONT	= (1 << 1),
+	FTRACE_ITER_NOTRACE	= (1 << 2),
 };

 #define FTRACE_BUFF_MAX (KSYM_SYMBOL_LEN+4) /* room for wildcards */
@@ -754,7 +765,9 @@ t_next(struct seq_file *m, void *v, loff
 		rec = &iter->pg->records[iter->idx++];
 		if ((rec->flags & FTRACE_FL_FAILED) ||
 		    ((iter->flags & FTRACE_ITER_FILTER) &&
-		     !(rec->flags & FTRACE_FL_FILTER))) {
+		     !(rec->flags & FTRACE_FL_FILTER)) ||
+		    ((iter->flags & FTRACE_ITER_NOTRACE) &&
+		     !(rec->flags & FTRACE_FL_NOTRACE))) {
 			rec = NULL;
 			goto retry;
 		}
@@ -847,22 +860,24 @@ int ftrace_avail_release(struct inode *i
 	return 0;
 }

-static void ftrace_filter_reset(void)
+static void ftrace_filter_reset(int enable)
 {
 	struct ftrace_page *pg;
 	struct dyn_ftrace *rec;
+	unsigned long type = enable ? FTRACE_FL_FILTER : FTRACE_FL_NOTRACE;
 	unsigned i;

 	/* keep kstop machine from running */
 	preempt_disable();
-	ftrace_filtered = 0;
+	if (enable)
+		ftrace_filtered = 0;
 	pg = ftrace_pages_start;
 	while (pg) {
 		for (i = 0; i < pg->index; i++) {
 			rec = &pg->records[i];
 			if (rec->flags & FTRACE_FL_FAILED)
 				continue;
-			rec->flags &= ~FTRACE_FL_FILTER;
+			rec->flags &= ~type;
 		}
 		pg = pg->next;
 	}
@@ -870,7 +885,7 @@ static void ftrace_filter_reset(void)
 }

 static int
-ftrace_filter_open(struct inode *inode, struct file *file)
+ftrace_regex_open(struct inode *inode, struct file *file, int enable)
 {
 	struct ftrace_iterator *iter;
 	int ret = 0;
@@ -882,15 +897,16 @@ ftrace_filter_open(struct inode *inode,
 	if (!iter)
 		return -ENOMEM;

-	mutex_lock(&ftrace_filter_lock);
+	mutex_lock(&ftrace_regex_lock);
 	if ((file->f_mode & FMODE_WRITE) &&
 	    !(file->f_flags & O_APPEND))
-		ftrace_filter_reset();
+		ftrace_filter_reset(enable);

 	if (file->f_mode & FMODE_READ) {
 		iter->pg = ftrace_pages_start;
 		iter->pos = -1;
-		iter->flags = FTRACE_ITER_FILTER;
+		iter->flags = enable ? FTRACE_ITER_FILTER :
+			FTRACE_ITER_NOTRACE;

 		ret = seq_open(file, &show_ftrace_seq_ops);
 		if (!ret) {
@@ -900,13 +916,25 @@ ftrace_filter_open(struct inode *inode,
 			kfree(iter);
 	} else
 		file->private_data = iter;
-	mutex_unlock(&ftrace_filter_lock);
+	mutex_unlock(&ftrace_regex_lock);

 	return ret;
 }

+static int
+ftrace_filter_open(struct inode *inode, struct file *file)
+{
+	return ftrace_regex_open(inode, file, 1);
+}
+
+static int
+ftrace_notrace_open(struct inode *inode, struct file *file)
+{
+	return ftrace_regex_open(inode, file, 0);
+}
+
 static ssize_t
-ftrace_filter_read(struct file *file, char __user *ubuf,
+ftrace_regex_read(struct file *file, char __user *ubuf,
 		       size_t cnt, loff_t *ppos)
 {
 	if (file->f_mode & FMODE_READ)
@@ -916,7 +944,7 @@ ftrace_filter_read(struct file *file, ch
 }

 static loff_t
-ftrace_filter_lseek(struct file *file, loff_t offset, int origin)
+ftrace_regex_lseek(struct file *file, loff_t offset, int origin)
 {
 	loff_t ret;

@@ -936,13 +964,14 @@ enum {
 };

 static void
-ftrace_match(unsigned char *buff, int len)
+ftrace_match(unsigned char *buff, int len, int enable)
 {
 	char str[KSYM_SYMBOL_LEN];
 	char *search = NULL;
 	struct ftrace_page *pg;
 	struct dyn_ftrace *rec;
 	int type = MATCH_FULL;
+	unsigned long flag = enable ? FTRACE_FL_FILTER : FTRACE_FL_NOTRACE;
 	unsigned i, match = 0, search_len = 0;

 	for (i = 0; i < len; i++) {
@@ -966,7 +995,8 @@ ftrace_match(unsigned char *buff, int le

 	/* keep kstop machine from running */
 	preempt_disable();
-	ftrace_filtered = 1;
+	if (enable)
+		ftrace_filtered = 1;
 	pg = ftrace_pages_start;
 	while (pg) {
 		for (i = 0; i < pg->index; i++) {
@@ -997,7 +1027,7 @@ ftrace_match(unsigned char *buff, int le
 				break;
 			}
 			if (matched)
-				rec->flags |= FTRACE_FL_FILTER;
+				rec->flags |= flag;
 		}
 		pg = pg->next;
 	}
@@ -1005,8 +1035,8 @@ ftrace_match(unsigned char *buff, int le
 }

 static ssize_t
-ftrace_filter_write(struct file *file, const char __user *ubuf,
-		    size_t cnt, loff_t *ppos)
+ftrace_regex_write(struct file *file, const char __user *ubuf,
+		   size_t cnt, loff_t *ppos, int enable)
 {
 	struct ftrace_iterator *iter;
 	char ch;
@@ -1016,7 +1046,7 @@ ftrace_filter_write(struct file *file, c
 	if (!cnt || cnt < 0)
 		return 0;

-	mutex_lock(&ftrace_filter_lock);
+	mutex_lock(&ftrace_regex_lock);

 	if (file->f_mode & FMODE_READ) {
 		struct seq_file *m = file->private_data;
@@ -1045,7 +1075,6 @@ ftrace_filter_write(struct file *file, c
 			cnt--;
 		}

-
 		if (isspace(ch)) {
 			file->f_pos += read;
 			ret = read;
@@ -1072,7 +1101,7 @@ ftrace_filter_write(struct file *file, c
 	if (isspace(ch)) {
 		iter->filtered++;
 		iter->buffer[iter->buffer_idx] = 0;
-		ftrace_match(iter->buffer, iter->buffer_idx);
+		ftrace_match(iter->buffer, iter->buffer_idx, enable);
 		iter->buffer_idx = 0;
 	} else
 		iter->flags |= FTRACE_ITER_CONT;
@@ -1082,11 +1111,39 @@ ftrace_filter_write(struct file *file, c

 	ret = read;
  out:
-	mutex_unlock(&ftrace_filter_lock);
+	mutex_unlock(&ftrace_regex_lock);

 	return ret;
 }

+static ssize_t
+ftrace_filter_write(struct file *file, const char __user *ubuf,
+		    size_t cnt, loff_t *ppos)
+{
+	return ftrace_regex_write(file, ubuf, cnt, ppos, 1);
+}
+
+static ssize_t
+ftrace_notrace_write(struct file *file, const char __user *ubuf,
+		     size_t cnt, loff_t *ppos)
+{
+	return ftrace_regex_write(file, ubuf, cnt, ppos, 0);
+}
+
+static void
+ftrace_set_regex(unsigned char *buf, int len, int reset, int enable)
+{
+	if (unlikely(ftrace_disabled))
+		return;
+
+	mutex_lock(&ftrace_regex_lock);
+	if (reset)
+		ftrace_filter_reset(enable);
+	if (buf)
+		ftrace_match(buf, len, enable);
+	mutex_unlock(&ftrace_regex_lock);
+}
+
 /**
  * ftrace_set_filter - set a function to filter on in ftrace
  * @buf - the string that holds the function filter text.
@@ -1098,24 +1155,31 @@ ftrace_filter_write(struct file *file, c
  */
 void ftrace_set_filter(unsigned char *buf, int len, int reset)
 {
-	if (unlikely(ftrace_disabled))
-		return;
+	ftrace_set_regex(buf, len, reset, 1);
+}

-	mutex_lock(&ftrace_filter_lock);
-	if (reset)
-		ftrace_filter_reset();
-	if (buf)
-		ftrace_match(buf, len);
-	mutex_unlock(&ftrace_filter_lock);
+/**
+ * ftrace_set_notrace - set a function to not trace in ftrace
+ * @buf - the string that holds the function notrace text.
+ * @len - the length of the string.
+ * @reset - non zero to reset all filters before applying this filter.
+ *
+ * Notrace Filters denote which functions should not be enabled when tracing
+ * is enabled. If @buf is NULL and reset is set, all functions will be enabled
+ * for tracing.
+ */
+void ftrace_set_notrace(unsigned char *buf, int len, int reset)
+{
+	ftrace_set_regex(buf, len, reset, 0);
 }

 static int
-ftrace_filter_release(struct inode *inode, struct file *file)
+ftrace_regex_release(struct inode *inode, struct file *file, int enable)
 {
 	struct seq_file *m = (struct seq_file *)file->private_data;
 	struct ftrace_iterator *iter;

-	mutex_lock(&ftrace_filter_lock);
+	mutex_lock(&ftrace_regex_lock);
 	if (file->f_mode & FMODE_READ) {
 		iter = m->private;

@@ -1126,7 +1190,7 @@ ftrace_filter_release(struct inode *inod
 	if (iter->buffer_idx) {
 		iter->filtered++;
 		iter->buffer[iter->buffer_idx] = 0;
-		ftrace_match(iter->buffer, iter->buffer_idx);
+		ftrace_match(iter->buffer, iter->buffer_idx, enable);
 	}

 	mutex_lock(&ftrace_sysctl_lock);
@@ -1137,10 +1201,22 @@ ftrace_filter_release(struct inode *inod
 	mutex_unlock(&ftrace_sysctl_lock);

 	kfree(iter);
-	mutex_unlock(&ftrace_filter_lock);
+	mutex_unlock(&ftrace_regex_lock);
 	return 0;
 }

+static int
+ftrace_filter_release(struct inode *inode, struct file *file)
+{
+	return ftrace_regex_release(inode, file, 1);
+}
+
+static int
+ftrace_notrace_release(struct inode *inode, struct file *file)
+{
+	return ftrace_regex_release(inode, file, 0);
+}
+
 static struct file_operations ftrace_avail_fops = {
 	.open = ftrace_avail_open,
 	.read = seq_read,
@@ -1150,12 +1226,20 @@ static struct file_operations ftrace_ava

 static struct file_operations ftrace_filter_fops = {
 	.open = ftrace_filter_open,
-	.read = ftrace_filter_read,
+	.read = ftrace_regex_read,
 	.write = ftrace_filter_write,
-	.llseek = ftrace_filter_lseek,
+	.llseek = ftrace_regex_lseek,
 	.release = ftrace_filter_release,
 };

+static struct file_operations ftrace_notrace_fops = {
+	.open = ftrace_notrace_open,
+	.read = ftrace_regex_read,
+	.write = ftrace_notrace_write,
+	.llseek = ftrace_regex_lseek,
+	.release = ftrace_notrace_release,
+};
+
 /**
  * ftrace_force_update - force an update to all recording ftrace functions
  *
@@ -1239,6 +1323,12 @@ static __init int ftrace_init_debugfs(vo
 	if (!entry)
 		pr_warning("Could not create debugfs "
 			   "'set_ftrace_filter' entry\n");
+
+	entry = debugfs_create_file("set_ftrace_notrace", 0644, d_tracer,
+				    NULL, &ftrace_notrace_fops);
+	if (!entry)
+		pr_warning("Could not create debugfs "
+			   "'set_ftrace_notrace' entry\n");
 	return 0;
 }


