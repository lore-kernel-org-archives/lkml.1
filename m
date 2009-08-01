Return-Path: <linux-kernel-owner+w=401wt.eu-S1752045AbZHAHXy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752045AbZHAHXy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Aug 2009 03:23:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751930AbZHAHXx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Aug 2009 03:23:53 -0400
Received: from mail-fx0-f217.google.com ([209.85.220.217]:55116 "EHLO
	mail-fx0-f217.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751946AbZHAHXg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Aug 2009 03:23:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=pRxWTBkrOjc2Fuu3H00/4y1wQZUVPY+ny57Ntm2nsC8MLhT+XlM56IlISf0gnzT8ln
         oASORpiBT1WvpxylMxjPKY6PhflUjNqzu/0UGi4NYIXrhaKa1savJjwrhGEA+0KYCcAY
         kC2eQYKmVvmi48TcNibuGnFX5SlnZhezmn0eA=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>, Li Zefan <lizf@cn.fujitsu.com>,
       Lai Jiangshan <laijs@cn.fujitsu.com>, Tom Zanussi <tzanussi@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>
Subject: [RFC][PATCH 4/5] tracing/filters: Provide basic regex support
Date: Sat,  1 Aug 2009 09:23:27 +0200
Message-Id: <1249111408-8657-5-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
In-Reply-To: <1249111408-8657-1-git-send-email-fweisbec@gmail.com>
References: <1249111408-8657-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch provides basic support for regular expressions in filters.
The common filter file doesn't support any regex but a new
filter_regex file is created for each subsystem/event.

It supports the following types of regexp:

- *match_beginning
- *match_middle*
- match_end*
- !don't match

Every string is now handled as a regexp in the filter framework, which
helps to factorize the code for handling both simple strings and
regexp comparisons.

(The regexp code has been savagely cherry picked from ftrace.c
writtent by Steve. If this patch makes its way, I'll be happy
to change ftrace to use the new filter helpers)

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Tom Zanussi <tzanussi@gmail.com>
---
 kernel/trace/trace.h               |   33 +++++---
 kernel/trace/trace_events.c        |   83 ++++++++++++++++---
 kernel/trace/trace_events_filter.c |  163 ++++++++++++++++++++++++++++--------
 3 files changed, 222 insertions(+), 57 deletions(-)

diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
index 94305c7..d96a54c 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -761,28 +761,37 @@ struct event_subsystem {
 };
 
 struct filter_pred;
+struct regex;
 
 typedef int (*filter_pred_fn_t) (struct filter_pred *pred, void *event,
 				 int val1, int val2);
+typedef int (*regex_match_func)(char *str, struct regex *r);
+
+struct regex {
+	char			pattern[MAX_FILTER_STR_VAL];
+	int			len;
+	char			*search;
+	int			search_len;
+	regex_match_func	match;
+};
 
 struct filter_pred {
-	filter_pred_fn_t fn;
-	u64 val;
-	char str_val[MAX_FILTER_STR_VAL];
-	int str_len;
-	char *field_name;
-	int offset;
-	int not;
-	int op;
-	int pop_n;
+	filter_pred_fn_t 	fn;
+	u64 			val;
+	struct regex		regex;
+	char 			*field_name;
+	int 			offset;
+	int 			not;
+	int 			op;
+	int 			pop_n;
 };
 
 extern void print_event_filter(struct ftrace_event_call *call,
 			       struct trace_seq *s);
 extern int apply_event_filter(struct ftrace_event_call *call,
-			      char *filter_string);
+			      char *filter_string, bool regex);
 extern int apply_subsystem_event_filter(struct event_subsystem *system,
-					char *filter_string);
+					char *filter_string, bool regex);
 extern void print_subsystem_event_filter(struct event_subsystem *system,
 					 struct trace_seq *s);
 
@@ -840,6 +849,8 @@ static int filter_pred_##size(struct filter_pred *pred, void *event,	\
 	return match;							\
 }
 
+void filter_parse_regex(char *buff, int len, struct regex *r, int *not);
+
 extern struct mutex event_mutex;
 extern struct list_head ftrace_events;
 
diff --git a/kernel/trace/trace_events.c b/kernel/trace/trace_events.c
index d8d8434..199ee49 100644
--- a/kernel/trace/trace_events.c
+++ b/kernel/trace/trace_events.c
@@ -644,7 +644,7 @@ event_filter_read(struct file *filp, char __user *ubuf, size_t cnt,
 
 static ssize_t
 event_filter_write(struct file *filp, const char __user *ubuf, size_t cnt,
-		   loff_t *ppos)
+		   loff_t *ppos, bool regex)
 {
 	struct ftrace_event_call *call = filp->private_data;
 	char *buf;
@@ -663,7 +663,7 @@ event_filter_write(struct file *filp, const char __user *ubuf, size_t cnt,
 	}
 	buf[cnt] = '\0';
 
-	err = apply_event_filter(call, buf);
+	err = apply_event_filter(call, buf, regex);
 	free_page((unsigned long) buf);
 	if (err < 0)
 		return err;
@@ -674,6 +674,20 @@ event_filter_write(struct file *filp, const char __user *ubuf, size_t cnt,
 }
 
 static ssize_t
+event_filter_write_regex(struct file *filp, const char __user *ubuf, size_t cnt,
+			 loff_t *ppos)
+{
+	return event_filter_write(filp, ubuf, cnt, ppos, true);
+}
+
+static ssize_t
+event_filter_write_common(struct file *filp, const char __user *ubuf, size_t cnt,
+			 loff_t *ppos)
+{
+	return event_filter_write(filp, ubuf, cnt, ppos, false);
+}
+
+static ssize_t
 subsystem_filter_read(struct file *filp, char __user *ubuf, size_t cnt,
 		      loff_t *ppos)
 {
@@ -700,7 +714,7 @@ subsystem_filter_read(struct file *filp, char __user *ubuf, size_t cnt,
 
 static ssize_t
 subsystem_filter_write(struct file *filp, const char __user *ubuf, size_t cnt,
-		       loff_t *ppos)
+		       loff_t *ppos, bool regex)
 {
 	struct event_subsystem *system = filp->private_data;
 	char *buf;
@@ -719,7 +733,7 @@ subsystem_filter_write(struct file *filp, const char __user *ubuf, size_t cnt,
 	}
 	buf[cnt] = '\0';
 
-	err = apply_subsystem_event_filter(system, buf);
+	err = apply_subsystem_event_filter(system, buf, regex);
 	free_page((unsigned long) buf);
 	if (err < 0)
 		return err;
@@ -730,6 +744,20 @@ subsystem_filter_write(struct file *filp, const char __user *ubuf, size_t cnt,
 }
 
 static ssize_t
+subsystem_filter_write_regex(struct file *filp, const char __user *ubuf, size_t cnt,
+			     loff_t *ppos)
+{
+	return subsystem_filter_write(filp, ubuf, cnt, ppos, true);
+}
+
+static ssize_t
+subsystem_filter_write_common(struct file *filp, const char __user *ubuf, size_t cnt,
+			      loff_t *ppos)
+{
+	return subsystem_filter_write(filp, ubuf, cnt, ppos, false);
+}
+
+static ssize_t
 show_header(struct file *filp, char __user *ubuf, size_t cnt, loff_t *ppos)
 {
 	int (*func)(struct trace_seq *s) = filp->private_data;
@@ -798,16 +826,28 @@ static const struct file_operations ftrace_event_id_fops = {
 	.read = event_id_read,
 };
 
-static const struct file_operations ftrace_event_filter_fops = {
+static const struct file_operations ftrace_event_filter_regex_fops = {
+	.open = tracing_open_generic,
+	.read = event_filter_read,
+	.write = event_filter_write_regex,
+};
+
+static const struct file_operations ftrace_event_filter_common_fops = {
 	.open = tracing_open_generic,
 	.read = event_filter_read,
-	.write = event_filter_write,
+	.write = event_filter_write_common,
+};
+
+static const struct file_operations ftrace_subsystem_filter_regex_fops = {
+	.open = tracing_open_generic,
+	.read = subsystem_filter_read,
+	.write = subsystem_filter_write_regex,
 };
 
-static const struct file_operations ftrace_subsystem_filter_fops = {
+static const struct file_operations ftrace_subsystem_filter_common_fops = {
 	.open = tracing_open_generic,
 	.read = subsystem_filter_read,
-	.write = subsystem_filter_write,
+	.write = subsystem_filter_write_common,
 };
 
 static const struct file_operations ftrace_system_enable_fops = {
@@ -893,7 +933,7 @@ event_subsystem_dir(const char *name, struct dentry *d_events)
 	}
 
 	entry = debugfs_create_file("filter", 0644, system->entry, system,
-				    &ftrace_subsystem_filter_fops);
+				    &ftrace_subsystem_filter_common_fops);
 	if (!entry) {
 		kfree(system->filter);
 		system->filter = NULL;
@@ -901,6 +941,15 @@ event_subsystem_dir(const char *name, struct dentry *d_events)
 			   "'%s/filter' entry\n", name);
 	}
 
+	entry = debugfs_create_file("filter_regex", 0644, system->entry, system,
+				    &ftrace_subsystem_filter_regex_fops);
+	if (!entry) {
+		kfree(system->filter);
+		system->filter = NULL;
+		pr_warning("Could not create debugfs "
+			   "'%s/filter_regex' entry\n", name);
+	}
+
 	trace_create_file("enable", 0644, system->entry,
 			  (void *)system->name,
 			  &ftrace_system_enable_fops);
@@ -939,6 +988,7 @@ event_create_dir(struct ftrace_event_call *call, struct dentry *d_events,
 		 const struct file_operations *id,
 		 const struct file_operations *enable,
 		 const struct file_operations *filter,
+		 const struct file_operations *filter_regex,
 		 const struct file_operations *format)
 {
 	int ret;
@@ -983,6 +1033,8 @@ event_create_dir(struct ftrace_event_call *call, struct dentry *d_events,
 		}
 		trace_create_file("filter", 0644, call->dir, call,
 				  filter);
+		trace_create_file("filter_regex", 0644, call->dir, call,
+				  filter_regex);
 	}
 
 	/* A trace may not want to export its format */
@@ -1015,6 +1067,7 @@ struct ftrace_module_file_ops {
 	struct file_operations		enable;
 	struct file_operations		format;
 	struct file_operations		filter;
+	struct file_operations		filter_regex;
 };
 
 static struct ftrace_module_file_ops *
@@ -1041,9 +1094,12 @@ trace_create_file_ops(struct module *mod)
 	file_ops->enable = ftrace_enable_fops;
 	file_ops->enable.owner = mod;
 
-	file_ops->filter = ftrace_event_filter_fops;
+	file_ops->filter = ftrace_event_filter_common_fops;
 	file_ops->filter.owner = mod;
 
+	file_ops->filter_regex = ftrace_event_filter_regex_fops;
+	file_ops->filter_regex.owner = mod;
+
 	file_ops->format = ftrace_event_format_fops;
 	file_ops->format.owner = mod;
 
@@ -1086,7 +1142,8 @@ static void trace_module_add_events(struct module *mod)
 		list_add(&call->list, &ftrace_events);
 		event_create_dir(call, d_events,
 				 &file_ops->id, &file_ops->enable,
-				 &file_ops->filter, &file_ops->format);
+				 &file_ops->filter, &file_ops->filter_regex,
+				 &file_ops->format);
 	}
 }
 
@@ -1226,7 +1283,9 @@ static __init int event_trace_init(void)
 			continue;
 		list_add(&call->list, &ftrace_events);
 		event_create_dir(call, d_events, &ftrace_event_id_fops,
-				 &ftrace_enable_fops, &ftrace_event_filter_fops,
+				 &ftrace_enable_fops,
+				 &ftrace_event_filter_common_fops,
+				 &ftrace_event_filter_regex_fops,
 				 &ftrace_event_format_fops);
 	}
 
diff --git a/kernel/trace/trace_events_filter.c b/kernel/trace/trace_events_filter.c
index a2f8bef..51b4e24 100644
--- a/kernel/trace/trace_events_filter.c
+++ b/kernel/trace/trace_events_filter.c
@@ -153,9 +153,9 @@ static int filter_pred_string(struct filter_pred *pred, void *event,
 	char *addr = (char *)(event + pred->offset);
 	int cmp, match;
 
-	cmp = strncmp(addr, pred->str_val, pred->str_len);
+	cmp = pred->regex.match(addr, &pred->regex);
 
-	match = (!cmp) ^ pred->not;
+	match = cmp ^ pred->not;
 
 	return match;
 }
@@ -177,9 +177,9 @@ static int filter_pred_strloc(struct filter_pred *pred, void *event,
 	char *addr = (char *)(event + str_loc);
 	int cmp, match;
 
-	cmp = strncmp(addr, pred->str_val, pred->str_len);
+	cmp = pred->regex.match(addr, &pred->regex);
 
-	match = (!cmp) ^ pred->not;
+	match = cmp ^ pred->not;
 
 	return match;
 }
@@ -190,6 +190,95 @@ static int filter_pred_none(struct filter_pred *pred, void *event,
 	return 0;
 }
 
+/* Basic regex callbacks */
+static int regex_match_full(char *str, struct regex *r)
+{
+	if (strcmp(str, r->search) == 0)
+		return 1;
+	return 0;
+}
+
+static int regex_match_front(char *str, struct regex *r)
+{
+	if (strncmp(str, r->search, r->search_len) == 0)
+		return 1;
+	return 0;
+}
+
+static int regex_match_middle(char *str, struct regex *r)
+{
+	if (strstr(str, r->search))
+		return 1;
+	return 0;
+}
+
+static int regex_match_end(char *str, struct regex *r)
+{
+	char *ptr = strstr(str, r->search);
+
+	if (ptr && (ptr[r->search_len] == 0))
+		return 1;
+	return 0;
+}
+
+/*
+ *
+ * Pass in a buffer containing a regex and this function will
+ * set search to point to the search part of the buffer and
+ * the callback to handle it properly
+ * This does modify buff.
+ *
+ */
+void filter_parse_regex(char *buff, int len, struct regex *r, int *not)
+{
+	int i;
+
+	r->match = regex_match_full;
+
+	if (buff[0] == '!') {
+		*not = 1;
+		buff++;
+		len--;
+	} else
+		*not = 0;
+
+	r->search = buff;
+
+	for (i = 0; i < len; i++) {
+		if (buff[i] != '*')
+			continue;
+
+		if (!i) {
+			r->search = buff + 1;
+			r->match = regex_match_end;
+		} else {
+			if (r->match == regex_match_end)
+				r->match = regex_match_middle;
+			else
+				r->match = regex_match_front;
+			buff[i] = 0;
+			break;
+		}
+	}
+
+	r->search_len = strlen(r->search);
+}
+
+static void filter_build_regex(struct filter_pred *pred, bool regex)
+{
+	struct regex *r = &pred->regex;
+	int not;
+
+	if (regex) {
+		filter_parse_regex(r->pattern, r->len, r, &not);
+		pred->not ^= not;
+	} else {
+		r->search = r->pattern;
+		r->search_len = r->len;
+		r->match = regex_match_full;
+	}
+}
+
 /* return 1 if event matches, 0 otherwise (discard) */
 int filter_match_preds(struct ftrace_event_call *call, void *rec)
 {
@@ -336,7 +425,7 @@ static void filter_clear_pred(struct filter_pred *pred)
 {
 	kfree(pred->field_name);
 	pred->field_name = NULL;
-	pred->str_len = 0;
+	pred->regex.len = 0;
 }
 
 static int filter_set_pred(struct filter_pred *dest,
@@ -457,7 +546,7 @@ static int filter_add_pred_fn(struct filter_parse_state *ps,
 
 enum {
 	FILTER_STATIC_STRING = 1,
-	FILTER_DYN_STRING
+	FILTER_DYN_STRING,
 };
 
 static int is_string_field(const char *type)
@@ -524,7 +613,7 @@ static filter_pred_fn_t select_comparison_fn(int op, int field_size,
 
 static int filter_add_pred(struct filter_parse_state *ps,
 			   struct ftrace_event_call *call,
-			   struct filter_pred *pred)
+			   struct filter_pred *pred, bool regex)
 {
 	struct ftrace_event_field *field;
 	filter_pred_fn_t fn;
@@ -557,26 +646,30 @@ static int filter_add_pred(struct filter_parse_state *ps,
 
 	string_type = is_string_field(field->type);
 	if (string_type) {
-		if (string_type == FILTER_STATIC_STRING)
-			fn = filter_pred_string;
-		else
+		if (string_type == FILTER_DYN_STRING)
 			fn = filter_pred_strloc;
-		pred->str_len = field->size;
+		else
+			fn = filter_pred_string;
+
+		pred->regex.len = field->size;
 		if (pred->op == OP_NE)
 			pred->not = 1;
+
+		filter_build_regex(pred, regex);
+
 		return filter_add_pred_fn(ps, call, pred, fn);
-	} else {
-		if (field->is_signed)
-			ret = strict_strtoll(pred->str_val, 0, &val);
-		else
-			ret = strict_strtoull(pred->str_val, 0, &val);
-		if (ret) {
-			parse_error(ps, FILT_ERR_ILLEGAL_INTVAL, 0);
-			return -EINVAL;
-		}
-		pred->val = val;
 	}
 
+	if (field->is_signed)
+		ret = strict_strtoll(pred->regex.pattern, 0, &val);
+	else
+		ret = strict_strtoull(pred->regex.pattern, 0, &val);
+	if (ret) {
+		parse_error(ps, FILT_ERR_ILLEGAL_INTVAL, 0);
+		return -EINVAL;
+	}
+	pred->val = val;
+
 	fn = select_comparison_fn(pred->op, field->size, field->is_signed);
 	if (!fn) {
 		parse_error(ps, FILT_ERR_INVALID_OP, 0);
@@ -592,7 +685,7 @@ static int filter_add_pred(struct filter_parse_state *ps,
 static int filter_add_subsystem_pred(struct filter_parse_state *ps,
 				     struct event_subsystem *system,
 				     struct filter_pred *pred,
-				     char *filter_string)
+				     char *filter_string, bool regex)
 {
 	struct ftrace_event_call *call;
 	int err = 0;
@@ -605,7 +698,7 @@ static int filter_add_subsystem_pred(struct filter_parse_state *ps,
 		if (strcmp(call->system, system->name))
 			continue;
 
-		err = filter_add_pred(ps, call, pred);
+		err = filter_add_pred(ps, call, pred, regex);
 		if (err) {
 			filter_free_subsystem_preds(system);
 			parse_error(ps, FILT_ERR_BAD_SUBSYS_FILTER, 0);
@@ -925,8 +1018,8 @@ static struct filter_pred *create_pred(int op, char *operand1, char *operand2)
 		return NULL;
 	}
 
-	strcpy(pred->str_val, operand2);
-	pred->str_len = strlen(operand2);
+	strcpy(pred->regex.pattern, operand2);
+	pred->regex.len = strlen(operand2);
 
 	pred->op = op;
 
@@ -973,7 +1066,7 @@ static int check_preds(struct filter_parse_state *ps)
 static int replace_preds(struct event_subsystem *system,
 			 struct ftrace_event_call *call,
 			 struct filter_parse_state *ps,
-			 char *filter_string)
+			 char *filter_string, bool regex)
 {
 	char *operand1 = NULL, *operand2 = NULL;
 	struct filter_pred *pred;
@@ -1000,10 +1093,11 @@ static int replace_preds(struct event_subsystem *system,
 		if (elt->op == OP_AND || elt->op == OP_OR) {
 			pred = create_logical_pred(elt->op);
 			if (call)
-				err = filter_add_pred(ps, call, pred);
+				err = filter_add_pred(ps, call, pred, regex);
 			else
 				err = filter_add_subsystem_pred(ps, system,
-							pred, filter_string);
+							pred, filter_string,
+							regex);
 			filter_free_pred(pred);
 			if (err)
 				return err;
@@ -1019,10 +1113,10 @@ static int replace_preds(struct event_subsystem *system,
 
 		pred = create_pred(elt->op, operand1, operand2);
 		if (call)
-			err = filter_add_pred(ps, call, pred);
+			err = filter_add_pred(ps, call, pred, regex);
 		else
 			err = filter_add_subsystem_pred(ps, system, pred,
-							filter_string);
+							filter_string, regex);
 		filter_free_pred(pred);
 		if (err)
 			return err;
@@ -1033,7 +1127,8 @@ static int replace_preds(struct event_subsystem *system,
 	return 0;
 }
 
-int apply_event_filter(struct ftrace_event_call *call, char *filter_string)
+int apply_event_filter(struct ftrace_event_call *call, char *filter_string,
+			bool regex)
 {
 	int err;
 
@@ -1063,7 +1158,7 @@ int apply_event_filter(struct ftrace_event_call *call, char *filter_string)
 		goto out;
 	}
 
-	err = replace_preds(NULL, call, ps, filter_string);
+	err = replace_preds(NULL, call, ps, filter_string, regex);
 	if (err)
 		append_filter_err(ps, call->filter);
 
@@ -1078,7 +1173,7 @@ out_unlock:
 }
 
 int apply_subsystem_event_filter(struct event_subsystem *system,
-				 char *filter_string)
+				 char *filter_string, bool regex)
 {
 	int err;
 
@@ -1108,7 +1203,7 @@ int apply_subsystem_event_filter(struct event_subsystem *system,
 		goto out;
 	}
 
-	err = replace_preds(system, NULL, ps, filter_string);
+	err = replace_preds(system, NULL, ps, filter_string, regex);
 	if (err)
 		append_filter_err(ps, system->filter);
 
-- 
1.6.2.3

