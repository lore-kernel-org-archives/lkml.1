Return-Path: <linux-kernel-owner+w=401wt.eu-S1758911AbZD2MLS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758911AbZD2MLS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Apr 2009 08:11:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758057AbZD2MKd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Apr 2009 08:10:33 -0400
Received: from hera.kernel.org ([140.211.167.34]:44074 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758307AbZD2MK1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Apr 2009 08:10:27 -0400
Date: Wed, 29 Apr 2009 12:09:50 GMT
From: tip-bot for Tom Zanussi <tzanussi@gmail.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       tzanussi@gmail.com, lizf@cn.fujitsu.com, rostedt@goodmis.org,
       tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       tzanussi@gmail.com, rostedt@goodmis.org, lizf@cn.fujitsu.com,
       tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1240905899.6416.121.camel@tropicana>
References: <1240905899.6416.121.camel@tropicana>
Subject: [tip:tracing/core] tracing/filters: a better event parser
Message-ID: <tip-8b3725621074040d380664964ffbc40610aef8c6@git.kernel.org>
Git-Commit-ID: 8b3725621074040d380664964ffbc40610aef8c6
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 29 Apr 2009 12:09:52 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  8b3725621074040d380664964ffbc40610aef8c6
Gitweb:     http://git.kernel.org/tip/8b3725621074040d380664964ffbc40610aef8c6
Author:     Tom Zanussi <tzanussi@gmail.com>
AuthorDate: Tue, 28 Apr 2009 03:04:59 -0500
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 29 Apr 2009 14:06:11 +0200

tracing/filters: a better event parser

Replace the current event parser hack with a better one.  Filters are
no longer specified predicate by predicate, but all at once and can
use parens and any of the following operators:

numeric fields:

==, !=, <, <=, >, >=

string fields:

==, !=

predicates can be combined with the logical operators:

&&, ||

examples:

"common_preempt_count > 4" > filter

"((sig >= 10 && sig < 15) || sig == 17) && comm != bash" > filter

If there was an error, the erroneous string along with an error
message can be seen by looking at the filter e.g.:

((sig >= 10 && sig < 15) || dsig == 17) && comm != bash
^
parse_error: Field not found

Currently the caret for an error always appears at the beginning of
the filter; a real position should be used, but the error message
should be useful even without it.

To clear a filter, '0' can be written to the filter file.

Filters can also be set or cleared for a complete subsystem by writing
the same filter as would be written to an individual event to the
filter file at the root of the subsytem.  Note however, that if any
event in the subsystem lacks a field specified in the filter being
set, the set will fail and all filters in the subsytem are
automatically cleared.  This change from the previous version was made
because using only the fields that happen to exist for a given event
would most likely result in a meaningless filter.

Because the logical operators are now implemented as predicates, the
maximum number of predicates in a filter was increased from 8 to 16.

[ Impact: add new, extended trace-filter implementation ]

Signed-off-by: Tom Zanussi <tzanussi@gmail.com>
Acked-by: Steven Rostedt <rostedt@goodmis.org>
Cc: fweisbec@gmail.com
Cc: Li Zefan <lizf@cn.fujitsu.com>
LKML-Reference: <1240905899.6416.121.camel@tropicana>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 include/linux/ftrace_event.h       |    2 +-
 kernel/trace/trace.h               |   66 ++-
 kernel/trace/trace_events.c        |   86 ++--
 kernel/trace/trace_events_filter.c | 1020 ++++++++++++++++++++++++++++--------
 4 files changed, 884 insertions(+), 290 deletions(-)

diff --git a/include/linux/ftrace_event.h b/include/linux/ftrace_event.h
index e61a740..5fff40c 100644
--- a/include/linux/ftrace_event.h
+++ b/include/linux/ftrace_event.h
@@ -112,7 +112,7 @@ struct ftrace_event_call {
 #endif
 };
 
-#define MAX_FILTER_PRED		8
+#define MAX_FILTER_PRED		32
 #define MAX_FILTER_STR_VAL	128
 
 extern int init_preds(struct ftrace_event_call *call);
diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
index 866d010..7736fe8 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -735,6 +735,7 @@ struct ftrace_event_field {
 struct event_filter {
 	int			n_preds;
 	struct filter_pred	**preds;
+	char			*filter_string;
 };
 
 struct event_subsystem {
@@ -746,7 +747,8 @@ struct event_subsystem {
 
 struct filter_pred;
 
-typedef int (*filter_pred_fn_t) (struct filter_pred *pred, void *event);
+typedef int (*filter_pred_fn_t) (struct filter_pred *pred, void *event,
+				 int val1, int val2);
 
 struct filter_pred {
 	filter_pred_fn_t fn;
@@ -756,23 +758,18 @@ struct filter_pred {
 	char *field_name;
 	int offset;
 	int not;
-	int or;
-	int compound;
-	int clear;
+	int op;
+	int pop_n;
 };
 
-extern void filter_free_pred(struct filter_pred *pred);
-extern void filter_print_preds(struct ftrace_event_call *call,
+extern void print_event_filter(struct ftrace_event_call *call,
 			       struct trace_seq *s);
-extern int filter_parse(char **pbuf, struct filter_pred *pred);
-extern int filter_add_pred(struct ftrace_event_call *call,
-			   struct filter_pred *pred);
-extern void filter_disable_preds(struct ftrace_event_call *call);
-extern void filter_free_subsystem_preds(struct event_subsystem *system);
-extern void filter_print_subsystem_preds(struct event_subsystem *system,
+extern int apply_event_filter(struct ftrace_event_call *call,
+			      char *filter_string);
+extern int apply_subsystem_event_filter(struct event_subsystem *system,
+					char *filter_string);
+extern void print_subsystem_event_filter(struct event_subsystem *system,
 					 struct trace_seq *s);
-extern int filter_add_subsystem_pred(struct event_subsystem *system,
-				     struct filter_pred *pred);
 
 static inline int
 filter_check_discard(struct ftrace_event_call *call, void *rec,
@@ -787,6 +784,47 @@ filter_check_discard(struct ftrace_event_call *call, void *rec,
 	return 0;
 }
 
+#define DEFINE_COMPARISON_PRED(type)					\
+static int filter_pred_##type(struct filter_pred *pred, void *event,	\
+			      int val1, int val2)			\
+{									\
+	type *addr = (type *)(event + pred->offset);			\
+	type val = (type)pred->val;					\
+	int match = 0;							\
+									\
+	switch (pred->op) {						\
+	case OP_LT:							\
+		match = (*addr < val);					\
+		break;							\
+	case OP_LE:							\
+		match = (*addr <= val);					\
+		break;							\
+	case OP_GT:							\
+		match = (*addr > val);					\
+		break;							\
+	case OP_GE:							\
+		match = (*addr >= val);					\
+		break;							\
+	default:							\
+		break;							\
+	}								\
+									\
+	return match;							\
+}
+
+#define DEFINE_EQUALITY_PRED(size)					\
+static int filter_pred_##size(struct filter_pred *pred, void *event,	\
+			      int val1, int val2)			\
+{									\
+	u##size *addr = (u##size *)(event + pred->offset);		\
+	u##size val = (u##size)pred->val;				\
+	int match;							\
+									\
+	match = (val == *addr) ^ pred->not;				\
+									\
+	return match;							\
+}
+
 extern struct list_head ftrace_events;
 
 extern const char *__start___trace_bprintk_fmt[];
diff --git a/kernel/trace/trace_events.c b/kernel/trace/trace_events.c
index bbbea74..f789ca5 100644
--- a/kernel/trace/trace_events.c
+++ b/kernel/trace/trace_events.c
@@ -492,7 +492,7 @@ event_filter_read(struct file *filp, char __user *ubuf, size_t cnt,
 
 	trace_seq_init(s);
 
-	filter_print_preds(call, s);
+	print_event_filter(call, s);
 	r = simple_read_from_buffer(ubuf, cnt, ppos, s->buffer, s->len);
 
 	kfree(s);
@@ -505,40 +505,26 @@ event_filter_write(struct file *filp, const char __user *ubuf, size_t cnt,
 		   loff_t *ppos)
 {
 	struct ftrace_event_call *call = filp->private_data;
-	char buf[64], *pbuf = buf;
-	struct filter_pred *pred;
+	char *buf;
 	int err;
 
-	if (cnt >= sizeof(buf))
+	if (cnt >= PAGE_SIZE)
 		return -EINVAL;
 
-	if (copy_from_user(&buf, ubuf, cnt))
-		return -EFAULT;
-	buf[cnt] = '\0';
-
-	pred = kzalloc(sizeof(*pred), GFP_KERNEL);
-	if (!pred)
+	buf = (char *)__get_free_page(GFP_TEMPORARY);
+	if (!buf)
 		return -ENOMEM;
 
-	err = filter_parse(&pbuf, pred);
-	if (err < 0) {
-		filter_free_pred(pred);
-		return err;
-	}
-
-	if (pred->clear) {
-		filter_disable_preds(call);
-		filter_free_pred(pred);
-		return cnt;
+	if (copy_from_user(buf, ubuf, cnt)) {
+		free_page((unsigned long) buf);
+		return -EFAULT;
 	}
+	buf[cnt] = '\0';
 
-	err = filter_add_pred(call, pred);
-	if (err < 0) {
-		filter_free_pred(pred);
+	err = apply_event_filter(call, buf);
+	free_page((unsigned long) buf);
+	if (err < 0)
 		return err;
-	}
-
-	filter_free_pred(pred);
 
 	*ppos += cnt;
 
@@ -562,7 +548,7 @@ subsystem_filter_read(struct file *filp, char __user *ubuf, size_t cnt,
 
 	trace_seq_init(s);
 
-	filter_print_subsystem_preds(system, s);
+	print_subsystem_event_filter(system, s);
 	r = simple_read_from_buffer(ubuf, cnt, ppos, s->buffer, s->len);
 
 	kfree(s);
@@ -575,38 +561,26 @@ subsystem_filter_write(struct file *filp, const char __user *ubuf, size_t cnt,
 		       loff_t *ppos)
 {
 	struct event_subsystem *system = filp->private_data;
-	char buf[64], *pbuf = buf;
-	struct filter_pred *pred;
+	char *buf;
 	int err;
 
-	if (cnt >= sizeof(buf))
+	if (cnt >= PAGE_SIZE)
 		return -EINVAL;
 
-	if (copy_from_user(&buf, ubuf, cnt))
-		return -EFAULT;
-	buf[cnt] = '\0';
-
-	pred = kzalloc(sizeof(*pred), GFP_KERNEL);
-	if (!pred)
+	buf = (char *)__get_free_page(GFP_TEMPORARY);
+	if (!buf)
 		return -ENOMEM;
 
-	err = filter_parse(&pbuf, pred);
-	if (err < 0) {
-		filter_free_pred(pred);
-		return err;
-	}
-
-	if (pred->clear) {
-		filter_free_subsystem_preds(system);
-		filter_free_pred(pred);
-		return cnt;
+	if (copy_from_user(buf, ubuf, cnt)) {
+		free_page((unsigned long) buf);
+		return -EFAULT;
 	}
+	buf[cnt] = '\0';
 
-	err = filter_add_subsystem_pred(system, pred);
-	if (err < 0) {
-		filter_free_pred(pred);
+	err = apply_subsystem_event_filter(system, buf);
+	free_page((unsigned long) buf);
+	if (err < 0)
 		return err;
-	}
 
 	*ppos += cnt;
 
@@ -760,11 +734,21 @@ event_subsystem_dir(const char *name, struct dentry *d_events)
 
 	system->filter = NULL;
 
+	system->filter = kzalloc(sizeof(struct event_filter), GFP_KERNEL);
+	if (!system->filter) {
+		pr_warning("Could not allocate filter for subsystem "
+			   "'%s'\n", name);
+		return system->entry;
+	}
+
 	entry = debugfs_create_file("filter", 0644, system->entry, system,
 				    &ftrace_subsystem_filter_fops);
-	if (!entry)
+	if (!entry) {
+		kfree(system->filter);
+		system->filter = NULL;
 		pr_warning("Could not create debugfs "
 			   "'%s/filter' entry\n", name);
+	}
 
 	return system->entry;
 }
diff --git a/kernel/trace/trace_events_filter.c b/kernel/trace/trace_events_filter.c
index 1e861ec..f494866 100644
--- a/kernel/trace/trace_events_filter.c
+++ b/kernel/trace/trace_events_filter.c
@@ -29,51 +29,130 @@
 
 static DEFINE_MUTEX(filter_mutex);
 
-static int filter_pred_64(struct filter_pred *pred, void *event)
+enum filter_op_ids
 {
-	u64 *addr = (u64 *)(event + pred->offset);
-	u64 val = (u64)pred->val;
-	int match;
-
-	match = (val == *addr) ^ pred->not;
-
-	return match;
-}
-
-static int filter_pred_32(struct filter_pred *pred, void *event)
-{
-	u32 *addr = (u32 *)(event + pred->offset);
-	u32 val = (u32)pred->val;
-	int match;
-
-	match = (val == *addr) ^ pred->not;
-
-	return match;
-}
-
-static int filter_pred_16(struct filter_pred *pred, void *event)
+	OP_OR,
+	OP_AND,
+	OP_NE,
+	OP_EQ,
+	OP_LT,
+	OP_LE,
+	OP_GT,
+	OP_GE,
+	OP_NONE,
+	OP_OPEN_PAREN,
+};
+
+struct filter_op {
+	int id;
+	char *string;
+	int precedence;
+};
+
+static struct filter_op filter_ops[] = {
+	{ OP_OR, "||", 1 },
+	{ OP_AND, "&&", 2 },
+	{ OP_NE, "!=", 4 },
+	{ OP_EQ, "==", 4 },
+	{ OP_LT, "<", 5 },
+	{ OP_LE, "<=", 5 },
+	{ OP_GT, ">", 5 },
+	{ OP_GE, ">=", 5 },
+	{ OP_NONE, "OP_NONE", 0 },
+	{ OP_OPEN_PAREN, "(", 0 },
+};
+
+enum {
+	FILT_ERR_NONE,
+	FILT_ERR_INVALID_OP,
+	FILT_ERR_UNBALANCED_PAREN,
+	FILT_ERR_TOO_MANY_OPERANDS,
+	FILT_ERR_OPERAND_TOO_LONG,
+	FILT_ERR_FIELD_NOT_FOUND,
+	FILT_ERR_ILLEGAL_FIELD_OP,
+	FILT_ERR_ILLEGAL_INTVAL,
+	FILT_ERR_BAD_SUBSYS_FILTER,
+	FILT_ERR_TOO_MANY_PREDS,
+	FILT_ERR_MISSING_FIELD,
+	FILT_ERR_INVALID_FILTER,
+};
+
+static char *err_text[] = {
+	"No error",
+	"Invalid operator",
+	"Unbalanced parens",
+	"Too many operands",
+	"Operand too long",
+	"Field not found",
+	"Illegal operation for field type",
+	"Illegal integer value",
+	"Couldn't find or set field in one of a subsystem's events",
+	"Too many terms in predicate expression",
+	"Missing field name and/or value",
+	"Meaningless filter expression",
+};
+
+struct opstack_op {
+	int op;
+	struct list_head list;
+};
+
+struct postfix_elt {
+	int op;
+	char *operand;
+	struct list_head list;
+};
+
+struct filter_parse_state {
+	struct filter_op *ops;
+	struct list_head opstack;
+	struct list_head postfix;
+	int lasterr;
+	int lasterr_pos;
+
+	struct {
+		char *string;
+		unsigned int cnt;
+		unsigned int tail;
+	} infix;
+
+	struct {
+		char string[MAX_FILTER_STR_VAL];
+		int pos;
+		unsigned int tail;
+	} operand;
+};
+
+DEFINE_COMPARISON_PRED(s64);
+DEFINE_COMPARISON_PRED(u64);
+DEFINE_COMPARISON_PRED(s32);
+DEFINE_COMPARISON_PRED(u32);
+DEFINE_COMPARISON_PRED(s16);
+DEFINE_COMPARISON_PRED(u16);
+DEFINE_COMPARISON_PRED(s8);
+DEFINE_COMPARISON_PRED(u8);
+
+DEFINE_EQUALITY_PRED(64);
+DEFINE_EQUALITY_PRED(32);
+DEFINE_EQUALITY_PRED(16);
+DEFINE_EQUALITY_PRED(8);
+
+static int filter_pred_and(struct filter_pred *pred __attribute((unused)),
+			   void *event __attribute((unused)),
+			   int val1, int val2)
 {
-	u16 *addr = (u16 *)(event + pred->offset);
-	u16 val = (u16)pred->val;
-	int match;
-
-	match = (val == *addr) ^ pred->not;
-
-	return match;
+	return val1 && val2;
 }
 
-static int filter_pred_8(struct filter_pred *pred, void *event)
+static int filter_pred_or(struct filter_pred *pred __attribute((unused)),
+			  void *event __attribute((unused)),
+			  int val1, int val2)
 {
-	u8 *addr = (u8 *)(event + pred->offset);
-	u8 val = (u8)pred->val;
-	int match;
-
-	match = (val == *addr) ^ pred->not;
-
-	return match;
+	return val1 || val2;
 }
 
-static int filter_pred_string(struct filter_pred *pred, void *event)
+static int filter_pred_string(struct filter_pred *pred, void *event,
+			      int val1, int val2)
 {
 	char *addr = (char *)(event + pred->offset);
 	int cmp, match;
@@ -85,7 +164,8 @@ static int filter_pred_string(struct filter_pred *pred, void *event)
 	return match;
 }
 
-static int filter_pred_none(struct filter_pred *pred, void *event)
+static int filter_pred_none(struct filter_pred *pred, void *event,
+			    int val1, int val2)
 {
 	return 0;
 }
@@ -94,66 +174,119 @@ static int filter_pred_none(struct filter_pred *pred, void *event)
 int filter_match_preds(struct ftrace_event_call *call, void *rec)
 {
 	struct event_filter *filter = call->filter;
-	int i, matched, and_failed = 0;
+	int match, top = 0, val1 = 0, val2 = 0;
+	int stack[MAX_FILTER_PRED];
 	struct filter_pred *pred;
+	int i;
 
 	for (i = 0; i < filter->n_preds; i++) {
 		pred = filter->preds[i];
-		if (and_failed && !pred->or)
+		if (!pred->pop_n) {
+			match = pred->fn(pred, rec, val1, val2);
+			stack[top++] = match;
 			continue;
-		matched = pred->fn(pred, rec);
-		if (!matched && !pred->or) {
-			and_failed = 1;
-			continue;
-		} else if (matched && pred->or)
-			return 1;
+		}
+		if (pred->pop_n > top) {
+			WARN_ON_ONCE(1);
+			return 0;
+		}
+		val1 = stack[--top];
+		val2 = stack[--top];
+		match = pred->fn(pred, rec, val1, val2);
+		stack[top++] = match;
 	}
 
-	if (and_failed)
-		return 0;
-
-	return 1;
+	return stack[--top];
 }
 EXPORT_SYMBOL_GPL(filter_match_preds);
 
-static void __filter_print_preds(struct event_filter *filter,
-				 struct trace_seq *s)
+static void parse_error(struct filter_parse_state *ps, int err, int pos)
 {
-	struct filter_pred *pred;
-	char *field_name;
-	int i;
+	ps->lasterr = err;
+	ps->lasterr_pos = pos;
+}
 
-	if (!filter || !filter->n_preds) {
-		trace_seq_printf(s, "none\n");
+static void remove_filter_string(struct event_filter *filter)
+{
+	kfree(filter->filter_string);
+	filter->filter_string = NULL;
+}
+
+static int replace_filter_string(struct event_filter *filter,
+				 char *filter_string)
+{
+	kfree(filter->filter_string);
+	filter->filter_string = kstrdup(filter_string, GFP_KERNEL);
+	if (!filter->filter_string)
+		return -ENOMEM;
+
+	return 0;
+}
+
+static int append_filter_string(struct event_filter *filter,
+				char *string)
+{
+	int newlen;
+	char *new_filter_string;
+
+	BUG_ON(!filter->filter_string);
+	newlen = strlen(filter->filter_string) + strlen(string) + 1;
+	new_filter_string = kmalloc(newlen, GFP_KERNEL);
+	if (!new_filter_string)
+		return -ENOMEM;
+
+	strcpy(new_filter_string, filter->filter_string);
+	strcat(new_filter_string, string);
+	kfree(filter->filter_string);
+	filter->filter_string = new_filter_string;
+
+	return 0;
+}
+
+static void append_filter_err(struct filter_parse_state *ps,
+			      struct event_filter *filter)
+{
+	int pos = ps->lasterr_pos;
+	char *buf, *pbuf;
+
+	buf = (char *)__get_free_page(GFP_TEMPORARY);
+	if (!buf)
 		return;
-	}
 
-	for (i = 0; i < filter->n_preds; i++) {
-		pred = filter->preds[i];
-		field_name = pred->field_name;
-		if (i)
-			trace_seq_printf(s, pred->or ? "|| " : "&& ");
-		trace_seq_printf(s, "%s ", field_name);
-		trace_seq_printf(s, pred->not ? "!= " : "== ");
-		if (pred->str_len)
-			trace_seq_printf(s, "%s\n", pred->str_val);
-		else
-			trace_seq_printf(s, "%llu\n", pred->val);
-	}
+	append_filter_string(filter, "\n");
+	memset(buf, ' ', PAGE_SIZE);
+	if (pos > PAGE_SIZE - 128)
+		pos = 0;
+	buf[pos] = '^';
+	pbuf = &buf[pos] + 1;
+
+	sprintf(pbuf, "\nparse_error: %s\n", err_text[ps->lasterr]);
+	append_filter_string(filter, buf);
+	free_page((unsigned long) buf);
 }
 
-void filter_print_preds(struct ftrace_event_call *call, struct trace_seq *s)
+void print_event_filter(struct ftrace_event_call *call, struct trace_seq *s)
 {
+	struct event_filter *filter = call->filter;
+
 	mutex_lock(&filter_mutex);
-	__filter_print_preds(call->filter, s);
+	if (filter->filter_string)
+		trace_seq_printf(s, "%s\n", filter->filter_string);
+	else
+		trace_seq_printf(s, "none\n");
 	mutex_unlock(&filter_mutex);
 }
 
-void filter_print_subsystem_preds(struct event_subsystem *system,
+void print_subsystem_event_filter(struct event_subsystem *system,
 				  struct trace_seq *s)
 {
+	struct event_filter *filter = system->filter;
+
 	mutex_lock(&filter_mutex);
-	__filter_print_preds(system->filter, s);
+	if (filter->filter_string)
+		trace_seq_printf(s, "%s\n", filter->filter_string);
+	else
+		trace_seq_printf(s, "none\n");
 	mutex_unlock(&filter_mutex);
 }
 
@@ -170,7 +303,7 @@ find_event_field(struct ftrace_event_call *call, char *name)
 	return NULL;
 }
 
-void filter_free_pred(struct filter_pred *pred)
+static void filter_free_pred(struct filter_pred *pred)
 {
 	if (!pred)
 		return;
@@ -191,15 +324,17 @@ static int filter_set_pred(struct filter_pred *dest,
 			   filter_pred_fn_t fn)
 {
 	*dest = *src;
-	dest->field_name = kstrdup(src->field_name, GFP_KERNEL);
-	if (!dest->field_name)
-		return -ENOMEM;
+	if (src->field_name) {
+		dest->field_name = kstrdup(src->field_name, GFP_KERNEL);
+		if (!dest->field_name)
+			return -ENOMEM;
+	}
 	dest->fn = fn;
 
 	return 0;
 }
 
-static void __filter_disable_preds(struct ftrace_event_call *call)
+static void filter_disable_preds(struct ftrace_event_call *call)
 {
 	struct event_filter *filter = call->filter;
 	int i;
@@ -211,13 +346,6 @@ static void __filter_disable_preds(struct ftrace_event_call *call)
 		filter->preds[i]->fn = filter_pred_none;
 }
 
-void filter_disable_preds(struct ftrace_event_call *call)
-{
-	mutex_lock(&filter_mutex);
-	__filter_disable_preds(call);
-	mutex_unlock(&filter_mutex);
-}
-
 int init_preds(struct ftrace_event_call *call)
 {
 	struct event_filter *filter;
@@ -258,48 +386,43 @@ oom:
 }
 EXPORT_SYMBOL_GPL(init_preds);
 
-static void __filter_free_subsystem_preds(struct event_subsystem *system)
+static void filter_free_subsystem_preds(struct event_subsystem *system)
 {
 	struct event_filter *filter = system->filter;
 	struct ftrace_event_call *call;
 	int i;
 
-	if (filter && filter->n_preds) {
+	if (filter->n_preds) {
 		for (i = 0; i < filter->n_preds; i++)
 			filter_free_pred(filter->preds[i]);
 		kfree(filter->preds);
-		kfree(filter);
-		system->filter = NULL;
+		filter->preds = NULL;
+		filter->n_preds = 0;
 	}
 
 	list_for_each_entry(call, &ftrace_events, list) {
 		if (!call->define_fields)
 			continue;
 
-		if (!strcmp(call->system, system->name))
-			__filter_disable_preds(call);
+		if (!strcmp(call->system, system->name)) {
+			filter_disable_preds(call);
+			remove_filter_string(call->filter);
+		}
 	}
 }
 
-void filter_free_subsystem_preds(struct event_subsystem *system)
-{
-	mutex_lock(&filter_mutex);
-	__filter_free_subsystem_preds(system);
-	mutex_unlock(&filter_mutex);
-}
-
-static int filter_add_pred_fn(struct ftrace_event_call *call,
+static int filter_add_pred_fn(struct filter_parse_state *ps,
+			      struct ftrace_event_call *call,
 			      struct filter_pred *pred,
 			      filter_pred_fn_t fn)
 {
 	struct event_filter *filter = call->filter;
 	int idx, err;
 
-	if (filter->n_preds && !pred->compound)
-		__filter_disable_preds(call);
-
-	if (filter->n_preds == MAX_FILTER_PRED)
+	if (filter->n_preds == MAX_FILTER_PRED) {
+		parse_error(ps, FILT_ERR_TOO_MANY_PREDS, 0);
 		return -ENOSPC;
+	}
 
 	idx = filter->n_preds;
 	filter_clear_pred(filter->preds[idx]);
@@ -321,94 +444,132 @@ static int is_string_field(const char *type)
 	return 0;
 }
 
-static int __filter_add_pred(struct ftrace_event_call *call,
-			     struct filter_pred *pred)
+static int is_legal_op(struct ftrace_event_field *field, int op)
+{
+	if (is_string_field(field->type) && (op != OP_EQ && op != OP_NE))
+		return 0;
+
+	return 1;
+}
+
+static filter_pred_fn_t select_comparison_fn(int op, int field_size,
+					     int field_is_signed)
+{
+	filter_pred_fn_t fn = NULL;
+
+	switch (field_size) {
+	case 8:
+		if (op == OP_EQ || op == OP_NE)
+			fn = filter_pred_64;
+		else if (field_is_signed)
+			fn = filter_pred_s64;
+		else
+			fn = filter_pred_u64;
+		break;
+	case 4:
+		if (op == OP_EQ || op == OP_NE)
+			fn = filter_pred_32;
+		else if (field_is_signed)
+			fn = filter_pred_s32;
+		else
+			fn = filter_pred_u32;
+		break;
+	case 2:
+		if (op == OP_EQ || op == OP_NE)
+			fn = filter_pred_16;
+		else if (field_is_signed)
+			fn = filter_pred_s16;
+		else
+			fn = filter_pred_u16;
+		break;
+	case 1:
+		if (op == OP_EQ || op == OP_NE)
+			fn = filter_pred_8;
+		else if (field_is_signed)
+			fn = filter_pred_s8;
+		else
+			fn = filter_pred_u8;
+		break;
+	}
+
+	return fn;
+}
+
+static int filter_add_pred(struct filter_parse_state *ps,
+			   struct ftrace_event_call *call,
+			   struct filter_pred *pred)
 {
 	struct ftrace_event_field *field;
 	filter_pred_fn_t fn;
 	unsigned long long val;
 
+	pred->fn = filter_pred_none;
+
+	if (pred->op == OP_AND) {
+		pred->pop_n = 2;
+		return filter_add_pred_fn(ps, call, pred, filter_pred_and);
+	} else if (pred->op == OP_OR) {
+		pred->pop_n = 2;
+		return filter_add_pred_fn(ps, call, pred, filter_pred_or);
+	}
+
 	field = find_event_field(call, pred->field_name);
-	if (!field)
+	if (!field) {
+		parse_error(ps, FILT_ERR_FIELD_NOT_FOUND, 0);
 		return -EINVAL;
+	}
 
-	pred->fn = filter_pred_none;
 	pred->offset = field->offset;
 
+	if (!is_legal_op(field, pred->op)) {
+		parse_error(ps, FILT_ERR_ILLEGAL_FIELD_OP, 0);
+		return -EINVAL;
+	}
+
 	if (is_string_field(field->type)) {
 		fn = filter_pred_string;
 		pred->str_len = field->size;
-		return filter_add_pred_fn(call, pred, fn);
+		if (pred->op == OP_NE)
+			pred->not = 1;
+		return filter_add_pred_fn(ps, call, pred, fn);
 	} else {
-		if (strict_strtoull(pred->str_val, 0, &val))
+		if (strict_strtoull(pred->str_val, 0, &val)) {
+			parse_error(ps, FILT_ERR_ILLEGAL_INTVAL, 0);
 			return -EINVAL;
+		}
 		pred->val = val;
 	}
 
-	switch (field->size) {
-	case 8:
-		fn = filter_pred_64;
-		break;
-	case 4:
-		fn = filter_pred_32;
-		break;
-	case 2:
-		fn = filter_pred_16;
-		break;
-	case 1:
-		fn = filter_pred_8;
-		break;
-	default:
+	fn = select_comparison_fn(pred->op, field->size, field->is_signed);
+	if (!fn) {
+		parse_error(ps, FILT_ERR_INVALID_OP, 0);
 		return -EINVAL;
 	}
 
-	return filter_add_pred_fn(call, pred, fn);
-}
-
-int filter_add_pred(struct ftrace_event_call *call, struct filter_pred *pred)
-{
-	int err;
-
-	mutex_lock(&filter_mutex);
-	err = __filter_add_pred(call, pred);
-	mutex_unlock(&filter_mutex);
+	if (pred->op == OP_NE)
+		pred->not = 1;
 
-	return err;
+	return filter_add_pred_fn(ps, call, pred, fn);
 }
 
-int filter_add_subsystem_pred(struct event_subsystem *system,
-			      struct filter_pred *pred)
+static int filter_add_subsystem_pred(struct filter_parse_state *ps,
+				     struct event_subsystem *system,
+				     struct filter_pred *pred,
+				     char *filter_string)
 {
 	struct event_filter *filter = system->filter;
 	struct ftrace_event_call *call;
 
-	mutex_lock(&filter_mutex);
-
-	if (filter && filter->n_preds && !pred->compound) {
-		__filter_free_subsystem_preds(system);
-		filter = NULL;
-	}
-
-	if (!filter) {
-		system->filter = kzalloc(sizeof(*filter), GFP_KERNEL);
-		if (!system->filter) {
-			mutex_unlock(&filter_mutex);
-			return -ENOMEM;
-		}
-		filter = system->filter;
+	if (!filter->preds) {
 		filter->preds = kzalloc(MAX_FILTER_PRED * sizeof(pred),
 					GFP_KERNEL);
 
-		if (!filter->preds) {
-			kfree(system->filter);
-			system->filter = NULL;
-			mutex_unlock(&filter_mutex);
+		if (!filter->preds)
 			return -ENOMEM;
-		}
 	}
 
 	if (filter->n_preds == MAX_FILTER_PRED) {
-		mutex_unlock(&filter_mutex);
+		parse_error(ps, FILT_ERR_TOO_MANY_PREDS, 0);
 		return -ENOSPC;
 	}
 
@@ -424,97 +585,508 @@ int filter_add_subsystem_pred(struct event_subsystem *system,
 		if (strcmp(call->system, system->name))
 			continue;
 
-		err = __filter_add_pred(call, pred);
-		if (err == -ENOMEM) {
-			filter->preds[filter->n_preds] = NULL;
-			filter->n_preds--;
-			mutex_unlock(&filter_mutex);
+		err = filter_add_pred(ps, call, pred);
+		if (err) {
+			filter_free_subsystem_preds(system);
+			parse_error(ps, FILT_ERR_BAD_SUBSYS_FILTER, 0);
 			return err;
 		}
+		replace_filter_string(call->filter, filter_string);
 	}
 
-	mutex_unlock(&filter_mutex);
+	return 0;
+}
+
+static void parse_init(struct filter_parse_state *ps,
+		       struct filter_op *ops,
+		       char *infix_string)
+{
+	memset(ps, '\0', sizeof(*ps));
+
+	ps->infix.string = infix_string;
+	ps->infix.cnt = strlen(infix_string);
+	ps->ops = ops;
+
+	INIT_LIST_HEAD(&ps->opstack);
+	INIT_LIST_HEAD(&ps->postfix);
+}
+
+static char infix_next(struct filter_parse_state *ps)
+{
+	ps->infix.cnt--;
+
+	return ps->infix.string[ps->infix.tail++];
+}
+
+static char infix_peek(struct filter_parse_state *ps)
+{
+	if (ps->infix.tail == strlen(ps->infix.string))
+		return 0;
+
+	return ps->infix.string[ps->infix.tail];
+}
+
+static void infix_advance(struct filter_parse_state *ps)
+{
+	ps->infix.cnt--;
+	ps->infix.tail++;
+}
+
+static inline int is_precedence_lower(struct filter_parse_state *ps,
+				      int a, int b)
+{
+	return ps->ops[a].precedence < ps->ops[b].precedence;
+}
+
+static inline int is_op_char(struct filter_parse_state *ps, char c)
+{
+	int i;
+
+	for (i = 0; strcmp(ps->ops[i].string, "OP_NONE"); i++) {
+		if (ps->ops[i].string[0] == c)
+			return 1;
+	}
 
 	return 0;
 }
 
-/*
- * The filter format can be
- *   - 0, which means remove all filter preds
- *   - [||/&&] <field> ==/!= <val>
- */
-int filter_parse(char **pbuf, struct filter_pred *pred)
-{
-	char *tok, *val_str = NULL;
-	int tok_n = 0;
-
-	while ((tok = strsep(pbuf, " \n"))) {
-		if (tok_n == 0) {
-			if (!strcmp(tok, "0")) {
-				pred->clear = 1;
-				return 0;
-			} else if (!strcmp(tok, "&&")) {
-				pred->or = 0;
-				pred->compound = 1;
-			} else if (!strcmp(tok, "||")) {
-				pred->or = 1;
-				pred->compound = 1;
-			} else
-				pred->field_name = tok;
-			tok_n = 1;
-			continue;
+static int infix_get_op(struct filter_parse_state *ps, char firstc)
+{
+	char nextc = infix_peek(ps);
+	char opstr[3];
+	int i;
+
+	opstr[0] = firstc;
+	opstr[1] = nextc;
+	opstr[2] = '\0';
+
+	for (i = 0; strcmp(ps->ops[i].string, "OP_NONE"); i++) {
+		if (!strcmp(opstr, ps->ops[i].string)) {
+			infix_advance(ps);
+			return ps->ops[i].id;
 		}
-		if (tok_n == 1) {
-			if (!pred->field_name)
-				pred->field_name = tok;
-			else if (!strcmp(tok, "!="))
-				pred->not = 1;
-			else if (!strcmp(tok, "=="))
-				pred->not = 0;
-			else {
-				pred->field_name = NULL;
+	}
+
+	opstr[1] = '\0';
+
+	for (i = 0; strcmp(ps->ops[i].string, "OP_NONE"); i++) {
+		if (!strcmp(opstr, ps->ops[i].string))
+			return ps->ops[i].id;
+	}
+
+	return OP_NONE;
+}
+
+static inline void clear_operand_string(struct filter_parse_state *ps)
+{
+	memset(ps->operand.string, '\0', MAX_FILTER_STR_VAL);
+	ps->operand.tail = 0;
+}
+
+static inline int append_operand_char(struct filter_parse_state *ps, char c)
+{
+	if (ps->operand.tail == MAX_FILTER_STR_VAL)
+		return -EINVAL;
+
+	ps->operand.string[ps->operand.tail++] = c;
+
+	return 0;
+}
+
+static int filter_opstack_push(struct filter_parse_state *ps, int op)
+{
+	struct opstack_op *opstack_op;
+
+	opstack_op = kmalloc(sizeof(*opstack_op), GFP_KERNEL);
+	if (!opstack_op)
+		return -ENOMEM;
+
+	opstack_op->op = op;
+	list_add(&opstack_op->list, &ps->opstack);
+
+	return 0;
+}
+
+static int filter_opstack_empty(struct filter_parse_state *ps)
+{
+	return list_empty(&ps->opstack);
+}
+
+static int filter_opstack_top(struct filter_parse_state *ps)
+{
+	struct opstack_op *opstack_op;
+
+	if (filter_opstack_empty(ps))
+		return OP_NONE;
+
+	opstack_op = list_first_entry(&ps->opstack, struct opstack_op, list);
+
+	return opstack_op->op;
+}
+
+static int filter_opstack_pop(struct filter_parse_state *ps)
+{
+	struct opstack_op *opstack_op;
+	int op;
+
+	if (filter_opstack_empty(ps))
+		return OP_NONE;
+
+	opstack_op = list_first_entry(&ps->opstack, struct opstack_op, list);
+	op = opstack_op->op;
+	list_del(&opstack_op->list);
+
+	kfree(opstack_op);
+
+	return op;
+}
+
+static void filter_opstack_clear(struct filter_parse_state *ps)
+{
+	while (!filter_opstack_empty(ps))
+		filter_opstack_pop(ps);
+}
+
+static char *curr_operand(struct filter_parse_state *ps)
+{
+	return ps->operand.string;
+}
+
+static int postfix_append_operand(struct filter_parse_state *ps, char *operand)
+{
+	struct postfix_elt *elt;
+
+	elt = kmalloc(sizeof(*elt), GFP_KERNEL);
+	if (!elt)
+		return -ENOMEM;
+
+	elt->op = OP_NONE;
+	elt->operand = kstrdup(operand, GFP_KERNEL);
+	if (!elt->operand) {
+		kfree(elt);
+		return -ENOMEM;
+	}
+
+	list_add_tail(&elt->list, &ps->postfix);
+
+	return 0;
+}
+
+static int postfix_append_op(struct filter_parse_state *ps, int op)
+{
+	struct postfix_elt *elt;
+
+	elt = kmalloc(sizeof(*elt), GFP_KERNEL);
+	if (!elt)
+		return -ENOMEM;
+
+	elt->op = op;
+	elt->operand = NULL;
+
+	list_add_tail(&elt->list, &ps->postfix);
+
+	return 0;
+}
+
+static void postfix_clear(struct filter_parse_state *ps)
+{
+	struct postfix_elt *elt;
+
+	while (!list_empty(&ps->postfix)) {
+		elt = list_first_entry(&ps->postfix, struct postfix_elt, list);
+		kfree(elt->operand);
+		list_del(&elt->list);
+	}
+}
+
+static int filter_parse(struct filter_parse_state *ps)
+{
+	int op, top_op;
+	char ch;
+
+	while ((ch = infix_next(ps))) {
+		if (isspace(ch))
+			continue;
+
+		if (is_op_char(ps, ch)) {
+			op = infix_get_op(ps, ch);
+			if (op == OP_NONE) {
+				parse_error(ps, FILT_ERR_INVALID_OP, 0);
 				return -EINVAL;
 			}
-			tok_n = 2;
+
+			if (strlen(curr_operand(ps))) {
+				postfix_append_operand(ps, curr_operand(ps));
+				clear_operand_string(ps);
+			}
+
+			while (!filter_opstack_empty(ps)) {
+				top_op = filter_opstack_top(ps);
+				if (!is_precedence_lower(ps, top_op, op)) {
+					top_op = filter_opstack_pop(ps);
+					postfix_append_op(ps, top_op);
+					continue;
+				}
+				break;
+			}
+
+			filter_opstack_push(ps, op);
 			continue;
 		}
-		if (tok_n == 2) {
-			if (pred->compound) {
-				if (!strcmp(tok, "!="))
-					pred->not = 1;
-				else if (!strcmp(tok, "=="))
-					pred->not = 0;
-				else {
-					pred->field_name = NULL;
-					return -EINVAL;
-				}
-			} else {
-				val_str = tok;
-				break; /* done */
+
+		if (ch == '(') {
+			filter_opstack_push(ps, OP_OPEN_PAREN);
+			continue;
+		}
+
+		if (ch == ')') {
+			if (strlen(curr_operand(ps))) {
+				postfix_append_operand(ps, curr_operand(ps));
+				clear_operand_string(ps);
+			}
+
+			top_op = filter_opstack_pop(ps);
+			while (top_op != OP_NONE) {
+				if (top_op == OP_OPEN_PAREN)
+					break;
+				postfix_append_op(ps, top_op);
+				top_op = filter_opstack_pop(ps);
+			}
+			if (top_op == OP_NONE) {
+				parse_error(ps, FILT_ERR_UNBALANCED_PAREN, 0);
+				return -EINVAL;
 			}
-			tok_n = 3;
 			continue;
 		}
-		if (tok_n == 3) {
-			val_str = tok;
-			break; /* done */
+		if (append_operand_char(ps, ch)) {
+			parse_error(ps, FILT_ERR_OPERAND_TOO_LONG, 0);
+			return -EINVAL;
+		}
+	}
+
+	if (strlen(curr_operand(ps)))
+		postfix_append_operand(ps, curr_operand(ps));
+
+	while (!filter_opstack_empty(ps)) {
+		top_op = filter_opstack_pop(ps);
+		if (top_op == OP_NONE)
+			break;
+		if (top_op == OP_OPEN_PAREN) {
+			parse_error(ps, FILT_ERR_UNBALANCED_PAREN, 0);
+			return -EINVAL;
+		}
+		postfix_append_op(ps, top_op);
+	}
+
+	return 0;
+}
+
+static struct filter_pred *create_pred(int op, char *operand1, char *operand2)
+{
+	struct filter_pred *pred;
+
+	pred = kzalloc(sizeof(*pred), GFP_KERNEL);
+	if (!pred)
+		return NULL;
+
+	pred->field_name = kstrdup(operand1, GFP_KERNEL);
+	if (!pred->field_name) {
+		kfree(pred);
+		return NULL;
+	}
+
+	strcpy(pred->str_val, operand2);
+	pred->str_len = strlen(operand2);
+
+	pred->op = op;
+
+	return pred;
+}
+
+static struct filter_pred *create_logical_pred(int op)
+{
+	struct filter_pred *pred;
+
+	pred = kzalloc(sizeof(*pred), GFP_KERNEL);
+	if (!pred)
+		return NULL;
+
+	pred->op = op;
+
+	return pred;
+}
+
+static int check_preds(struct filter_parse_state *ps)
+{
+	int n_normal_preds = 0, n_logical_preds = 0;
+	struct postfix_elt *elt;
+
+	list_for_each_entry(elt, &ps->postfix, list) {
+		if (elt->op == OP_NONE)
+			continue;
+
+		if (elt->op == OP_AND || elt->op == OP_OR) {
+			n_logical_preds++;
+			continue;
 		}
+		n_normal_preds++;
 	}
 
-	if (!val_str || !strlen(val_str)
-	    || strlen(val_str) >= MAX_FILTER_STR_VAL) {
-		pred->field_name = NULL;
+	if (!n_normal_preds || n_logical_preds >= n_normal_preds) {
+		parse_error(ps, FILT_ERR_INVALID_FILTER, 0);
 		return -EINVAL;
 	}
 
-	strcpy(pred->str_val, val_str);
-	pred->str_len = strlen(val_str);
+	return 0;
+}
 
-	pred->field_name = kstrdup(pred->field_name, GFP_KERNEL);
-	if (!pred->field_name)
-		return -ENOMEM;
+static int replace_preds(struct event_subsystem *system,
+			 struct ftrace_event_call *call,
+			 struct filter_parse_state *ps,
+			 char *filter_string)
+{
+	char *operand1 = NULL, *operand2 = NULL;
+	struct filter_pred *pred;
+	struct postfix_elt *elt;
+	int err;
+
+	err = check_preds(ps);
+	if (err)
+		return err;
+
+	list_for_each_entry(elt, &ps->postfix, list) {
+		if (elt->op == OP_NONE) {
+			if (!operand1)
+				operand1 = elt->operand;
+			else if (!operand2)
+				operand2 = elt->operand;
+			else {
+				parse_error(ps, FILT_ERR_TOO_MANY_OPERANDS, 0);
+				return -EINVAL;
+			}
+			continue;
+		}
+
+		if (elt->op == OP_AND || elt->op == OP_OR) {
+			pred = create_logical_pred(elt->op);
+			if (call) {
+				err = filter_add_pred(ps, call, pred);
+				filter_free_pred(pred);
+			} else
+				err = filter_add_subsystem_pred(ps, system,
+							pred, filter_string);
+			if (err)
+				return err;
+
+			operand1 = operand2 = NULL;
+			continue;
+		}
+
+		if (!operand1 || !operand2) {
+			parse_error(ps, FILT_ERR_MISSING_FIELD, 0);
+			return -EINVAL;
+		}
+
+		pred = create_pred(elt->op, operand1, operand2);
+		if (call) {
+			err = filter_add_pred(ps, call, pred);
+			filter_free_pred(pred);
+		} else
+			err = filter_add_subsystem_pred(ps, system, pred,
+							filter_string);
+		if (err)
+			return err;
+
+		operand1 = operand2 = NULL;
+	}
 
 	return 0;
 }
 
+int apply_event_filter(struct ftrace_event_call *call, char *filter_string)
+{
+	int err;
+
+	struct filter_parse_state *ps;
+
+	mutex_lock(&filter_mutex);
+
+	if (!strcmp(strstrip(filter_string), "0")) {
+		filter_disable_preds(call);
+		remove_filter_string(call->filter);
+		mutex_unlock(&filter_mutex);
+		return 0;
+	}
+
+	ps = kzalloc(sizeof(*ps), GFP_KERNEL);
+	if (!ps)
+		return -ENOMEM;
+
+	filter_disable_preds(call);
+	replace_filter_string(call->filter, filter_string);
+
+	parse_init(ps, filter_ops, filter_string);
+	err = filter_parse(ps);
+	if (err) {
+		append_filter_err(ps, call->filter);
+		goto out;
+	}
+
+	err = replace_preds(NULL, call, ps, filter_string);
+	if (err)
+		append_filter_err(ps, call->filter);
+
+out:
+	filter_opstack_clear(ps);
+	postfix_clear(ps);
+	kfree(ps);
+
+	mutex_unlock(&filter_mutex);
+
+	return err;
+}
+
+int apply_subsystem_event_filter(struct event_subsystem *system,
+				 char *filter_string)
+{
+	int err;
+
+	struct filter_parse_state *ps;
+
+	mutex_lock(&filter_mutex);
+
+	if (!strcmp(strstrip(filter_string), "0")) {
+		filter_free_subsystem_preds(system);
+		remove_filter_string(system->filter);
+		mutex_unlock(&filter_mutex);
+		return 0;
+	}
+
+	ps = kzalloc(sizeof(*ps), GFP_KERNEL);
+	if (!ps)
+		return -ENOMEM;
+
+	filter_free_subsystem_preds(system);
+	replace_filter_string(system->filter, filter_string);
+
+	parse_init(ps, filter_ops, filter_string);
+	err = filter_parse(ps);
+	if (err) {
+		append_filter_err(ps, system->filter);
+		goto out;
+	}
+
+	err = replace_preds(system, NULL, ps, filter_string);
+	if (err)
+		append_filter_err(ps, system->filter);
+
+out:
+	filter_opstack_clear(ps);
+	postfix_clear(ps);
+	kfree(ps);
+
+	mutex_unlock(&filter_mutex);
+
+	return err;
+}
 
