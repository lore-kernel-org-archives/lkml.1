Return-Path: <linux-kernel-owner+w=401wt.eu-S1754588AbZCVIbo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754588AbZCVIbo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Mar 2009 04:31:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754423AbZCVIbP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Mar 2009 04:31:15 -0400
Received: from yx-out-2324.google.com ([74.125.44.30]:31094 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754322AbZCVIbJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Mar 2009 04:31:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=wgDr3ghlHl/xrm6DwBE4vhc1KfTr/fn7+AOvOj70oilUbONJjIyUFQIxv2uKvHquMN
         znZT5k+obmzm0iHXocLw5b3IX+jP/iYx1pOp+J4rwO5CFPPKLcxkEyVMoivSleKQuRxx
         /SeJ0wsHTRs78lLR+TzKy+4dsCgocjlgWUEE8=
Subject: [PATCH 3/4] tracing: add per-event filtering
From: Tom Zanussi <tzanussi@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
       =?ISO-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>
Content-Type: text/plain
Date: Sun, 22 Mar 2009 03:31:04 -0500
Message-Id: <1237710665.7703.48.camel@charm-linux>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds per-event filtering to the event tracing subsystem.

It adds a 'filter' debugfs file to each event directory.  This file can
be written to to set filters; reading from it will display the current
set of filters set for that event.

Basically, any field listed in the 'format' file for an event can be
filtered on (including strings, but not yet other array types) using
either matching ('==') or non-matching ('!=') 'predicates'.  A
'predicate' can be either a single expression:

# echo pid != 0 > filter

# cat filter
pid != 0

or a compound expression of up to 8 sub-expressions combined using '&&'
or '||':

# echo comm == Xorg > filter
# echo "&& sig != 29" > filter

# cat filter
comm == Xorg
&& sig != 29

Only events having field values matching an expression will be available
in the trace output; non-matching events are discarded.

Note that a compound expression is built up by echoing each
sub-expression separately - it's not the most efficient way to do
things, but it keeps the parser simple and assumes that compound
expressions will be relatively uncommon.  In any case, a subsequent
patch introducing a way to set filters for entire subsystems should
mitigate any need to do this for lots of events.

Setting a filter without an '&&' or '||' clears the previous filter
completely and sets the filter to the new expression:

# cat filter
comm == Xorg
&& sig != 29

# echo comm != Xorg

#cat filter
comm != Xorg

To clear a filter, echo 0 to the filter file:

# echo 0 > filter
# cat filter
none

The limit of 8 predicates for a compound expression is arbitrary - for
efficiency, it's implemented as an array of pointers to predicates, and
8 seemed more than enough for any filter...

Signed-off-by: Tom Zanussi <tzanussi@gmail.com>

---
 kernel/trace/Makefile               |    1 +
 kernel/trace/trace.h                |   28 +++
 kernel/trace/trace_events.c         |   77 ++++++++
 kernel/trace/trace_events_filter.c  |  326 +++++++++++++++++++++++++++++++++++
 kernel/trace/trace_events_stage_3.h |    4 +
 5 files changed, 436 insertions(+), 0 deletions(-)
 create mode 100644 kernel/trace/trace_events_filter.c

diff --git a/kernel/trace/Makefile b/kernel/trace/Makefile
index 0e45c20..2630f51 100644
--- a/kernel/trace/Makefile
+++ b/kernel/trace/Makefile
@@ -45,5 +45,6 @@ obj-$(CONFIG_EVENT_TRACER) += events.o
 obj-$(CONFIG_EVENT_TRACER) += trace_export.o
 obj-$(CONFIG_FTRACE_SYSCALLS) += trace_syscalls.o
 obj-$(CONFIG_EVENT_PROFILE) += trace_event_profile.o
+obj-$(CONFIG_EVENT_TRACER) += trace_events_filter.o
 
 libftrace-y := ftrace.o
diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
index 9288dc7..d9eb39e 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -795,6 +795,7 @@ struct ftrace_event_call {
 	int			(*show_format)(struct trace_seq *s);
 	int			(*define_fields)(void);
 	struct list_head	fields;
+	struct filter_pred	**preds;
 
 #ifdef CONFIG_EVENT_PROFILE
 	atomic_t	profile_count;
@@ -803,8 +804,35 @@ struct ftrace_event_call {
 #endif
 };
 
+#define MAX_FILTER_PRED 8
+
+struct filter_pred;
+
+typedef int (*filter_pred_fn_t) (struct filter_pred *pred, void *event);
+
+struct filter_pred {
+	filter_pred_fn_t fn;
+	u64 val;
+	char *str_val;
+	int str_len;
+	char *field_name;
+	int offset;
+	int not;
+	int or;
+	int compound;
+	int clear;
+};
+
 int trace_define_field(struct ftrace_event_call *call, char *type,
 		       char *name, int offset, int size);
+extern void filter_free_pred(struct filter_pred *pred);
+extern int filter_print_preds(struct filter_pred **preds, char *buf);
+extern int filter_parse(char **pbuf, struct filter_pred *pred);
+extern int filter_add_pred(struct ftrace_event_call *call,
+			   struct filter_pred *pred);
+extern void filter_free_preds(struct ftrace_event_call *call);
+extern int filter_match_preds(struct ftrace_event_call *call, void *rec);
+
 void event_trace_printk(unsigned long ip, const char *fmt, ...);
 extern struct ftrace_event_call __start_ftrace_events[];
 extern struct ftrace_event_call __stop_ftrace_events[];
diff --git a/kernel/trace/trace_events.c b/kernel/trace/trace_events.c
index 961b057..97470c4 100644
--- a/kernel/trace/trace_events.c
+++ b/kernel/trace/trace_events.c
@@ -459,6 +459,71 @@ event_id_read(struct file *filp, char __user *ubuf, size_t cnt, loff_t *ppos)
 	return r;
 }
 
+static ssize_t
+event_filter_read(struct file *filp, char __user *ubuf, size_t cnt,
+		  loff_t *ppos)
+{
+	struct ftrace_event_call *call = filp->private_data;
+	struct trace_seq *s;
+	int r;
+
+	if (*ppos)
+		return 0;
+
+	s = kmalloc(sizeof(*s), GFP_KERNEL);
+	if (!s)
+		return -ENOMEM;
+
+	trace_seq_init(s);
+
+	r = filter_print_preds(call->preds, s->buffer);
+	r = simple_read_from_buffer(ubuf, cnt, ppos, s->buffer, r);
+
+	kfree(s);
+
+	return r;
+}
+
+static ssize_t
+event_filter_write(struct file *filp, const char __user *ubuf, size_t cnt,
+		   loff_t *ppos)
+{
+	struct ftrace_event_call *call = filp->private_data;
+	char buf[64], *pbuf = buf;
+	struct filter_pred *pred;
+	int err;
+
+	if (cnt >= sizeof(buf))
+		return -EINVAL;
+
+	if (copy_from_user(&buf, ubuf, cnt))
+		return -EFAULT;
+
+	pred = kzalloc(sizeof(*pred), GFP_KERNEL);
+	if (!pred)
+		return -ENOMEM;
+
+	err = filter_parse(&pbuf, pred);
+	if (err < 0) {
+		filter_free_pred(pred);
+		return err;
+	}
+
+	if (pred->clear) {
+		filter_free_preds(call);
+		return cnt;
+	}
+
+	if (filter_add_pred(call, pred)) {
+		filter_free_pred(pred);
+		return -EINVAL;
+	}
+
+	*ppos += cnt;
+
+	return cnt;
+}
+
 static const struct seq_operations show_event_seq_ops = {
 	.start = t_start,
 	.next = t_next,
@@ -504,6 +569,12 @@ static const struct file_operations ftrace_event_id_fops = {
 	.read = event_id_read,
 };
 
+static const struct file_operations ftrace_event_filter_fops = {
+	.open = tracing_open_generic,
+	.read = event_filter_read,
+	.write = event_filter_write,
+};
+
 static struct dentry *event_trace_events_dir(void)
 {
 	static struct dentry *d_tracer;
@@ -619,6 +690,12 @@ event_create_dir(struct ftrace_event_call *call, struct dentry *d_events)
 		}
 	}
 
+	entry = debugfs_create_file("filter", 0444, call->dir, call,
+				    &ftrace_event_filter_fops);
+	if (!entry)
+		pr_warning("Could not create debugfs "
+			   "'%s/filter' entry\n", call->name);
+
 	/* A trace may not want to export its format */
 	if (!call->show_format)
 		return 0;
diff --git a/kernel/trace/trace_events_filter.c b/kernel/trace/trace_events_filter.c
new file mode 100644
index 0000000..8e8c5fa
--- /dev/null
+++ b/kernel/trace/trace_events_filter.c
@@ -0,0 +1,326 @@
+/*
+ * trace_events_filter - generic event filtering
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
+ *
+ * Copyright (C) 2009 Tom Zanussi <tzanussi@gmail.com>
+ */
+
+#include <linux/debugfs.h>
+#include <linux/uaccess.h>
+#include <linux/module.h>
+#include <linux/ctype.h>
+
+#include "trace.h"
+
+static int filter_pred_64(struct filter_pred *pred, void *event)
+{
+	u64 *addr = (u64 *)(event + pred->offset);
+	u64 val = (u64)pred->val;
+	int match;
+
+	match = (val == *addr) ^ pred->not;
+
+	return match;
+}
+
+static int filter_pred_32(struct filter_pred *pred, void *event)
+{
+	u32 *addr = (u32 *)(event + pred->offset);
+	u32 val = (u32)pred->val;
+	int match;
+
+	match = (val == *addr) ^ pred->not;
+
+	return match;
+}
+
+static int filter_pred_16(struct filter_pred *pred, void *event)
+{
+	u16 *addr = (u16 *)(event + pred->offset);
+	u16 val = (u16)pred->val;
+	int match;
+
+	match = (val == *addr) ^ pred->not;
+
+	return match;
+}
+
+static int filter_pred_8(struct filter_pred *pred, void *event)
+{
+	u8 *addr = (u8 *)(event + pred->offset);
+	u8 val = (u8)pred->val;
+	int match;
+
+	match = (val == *addr) ^ pred->not;
+
+	return match;
+}
+
+static int filter_pred_string(struct filter_pred *pred, void *event)
+{
+	char *addr = (char *)(event + pred->offset);
+	int cmp, match;
+
+	cmp = strncmp(addr, pred->str_val, pred->str_len);
+
+	match = (!cmp) ^ pred->not;
+
+	return match;
+}
+
+/* return 1 if event matches, 0 otherwise (discard) */
+int filter_match_preds(struct ftrace_event_call *call, void *rec)
+{
+	int i, matched, and_failed = 0;
+	struct filter_pred *pred;
+
+	for (i = 0; i < MAX_FILTER_PRED; i++) {
+		if (call->preds[i]) {
+			pred = call->preds[i];
+			if (and_failed && !pred->or)
+				continue;
+			matched = pred->fn(pred, rec);
+			if (!matched && !pred->or) {
+				and_failed = 1;
+				continue;
+			} else if (matched && pred->or)
+				return 1;
+		} else
+			break;
+	}
+
+	if (and_failed)
+		return 0;
+
+	return 1;
+}
+
+int filter_print_preds(struct filter_pred **preds, char *buf)
+{
+	ssize_t this_len = 0;
+	char *field_name;
+	struct filter_pred *pred;
+	int i;
+
+	if (!preds) {
+		this_len += sprintf(buf + this_len, "none\n");
+		return this_len;
+	}
+
+	for (i = 0; i < MAX_FILTER_PRED; i++) {
+		if (preds[i]) {
+			pred = preds[i];
+			field_name = pred->field_name;
+			if (i)
+				this_len += sprintf(buf + this_len,
+					    pred->or ? "|| " : "&& ");
+			this_len += sprintf(buf + this_len,
+					    "%s ", field_name);
+			this_len += sprintf(buf + this_len,
+					    pred->not ? "!= " : "== ");
+			if (pred->str_val)
+				this_len += sprintf(buf + this_len,
+						    "%s\n", pred->str_val);
+			else
+				this_len += sprintf(buf + this_len,
+						    "%llu\n", pred->val);
+		} else
+			break;
+	}
+
+	return this_len;
+}
+
+static struct ftrace_event_field *
+find_event_field(struct ftrace_event_call *call, char *name)
+{
+	struct ftrace_event_field *field;
+	struct list_head *entry, *tmp;
+
+	list_for_each_safe(entry, tmp, &call->fields) {
+		field = list_entry(entry, struct ftrace_event_field, link);
+		if (!strcmp(field->name, name))
+			return field;
+	}
+
+	return NULL;
+}
+
+void filter_free_pred(struct filter_pred *pred)
+{
+	if (!pred)
+		return;
+
+	kfree(pred->field_name);
+	kfree(pred->str_val);
+	kfree(pred);
+}
+
+void filter_free_preds(struct ftrace_event_call *call)
+{
+	int i;
+
+	if (call->preds) {
+		for (i = 0; i < MAX_FILTER_PRED; i++)
+			filter_free_pred(call->preds[i]);
+		kfree(call->preds);
+		call->preds = NULL;
+	}
+}
+
+static int __filter_add_pred(struct ftrace_event_call *call,
+			     struct filter_pred *pred)
+{
+	int i;
+
+	if (call->preds && !pred->compound)
+		filter_free_preds(call);
+
+	if (!call->preds) {
+		call->preds = kzalloc(MAX_FILTER_PRED * sizeof(pred),
+				      GFP_KERNEL);
+		if (!call->preds)
+			return -ENOMEM;
+	}
+
+	for (i = 0; i < MAX_FILTER_PRED; i++) {
+		if (!call->preds[i]) {
+			call->preds[i] = pred;
+			return 0;
+		}
+	}
+
+	return -ENOMEM;
+}
+
+static int is_string_field(const char *type)
+{
+	if (strchr(type, '[') && strstr(type, "char"))
+		return 1;
+
+	return 0;
+}
+
+int filter_add_pred(struct ftrace_event_call *call, struct filter_pred *pred)
+{
+	struct ftrace_event_field *field;
+
+	field = find_event_field(call, pred->field_name);
+	if (!field)
+		return -EINVAL;
+
+	pred->offset = field->offset;
+
+	if (is_string_field(field->type)) {
+		pred->fn = filter_pred_string;
+		pred->str_len = field->size;
+		return __filter_add_pred(call, pred);
+	}
+
+	switch (field->size) {
+	case 8:
+		pred->fn = filter_pred_64;
+		break;
+	case 4:
+		pred->fn = filter_pred_32;
+		break;
+	case 2:
+		pred->fn = filter_pred_16;
+		break;
+	case 1:
+		pred->fn = filter_pred_8;
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	return __filter_add_pred(call, pred);
+}
+
+int filter_parse(char **pbuf, struct filter_pred *pred)
+{
+	char *tmp, *tok, *val_str = NULL;
+	int tok_n = 0;
+
+	/* field ==/!= number, or/and field ==/!= number, number */
+	while ((tok = strsep(pbuf, " \n"))) {
+		if (tok_n == 0) {
+			if (!strcmp(tok, "0")) {
+				pred->clear = 1;
+				return 0;
+			} else if (!strcmp(tok, "&&")) {
+				pred->or = 0;
+				pred->compound = 1;
+			} else if (!strcmp(tok, "||")) {
+				pred->or = 1;
+				pred->compound = 1;
+			} else
+				pred->field_name = tok;
+			tok_n = 1;
+			continue;
+		}
+		if (tok_n == 1) {
+			if (!pred->field_name)
+				pred->field_name = tok;
+			else if (!strcmp(tok, "!="))
+				pred->not = 1;
+			else if (!strcmp(tok, "=="))
+				pred->not = 0;
+			else {
+				pred->field_name = NULL;
+				return -EINVAL;
+			}
+			tok_n = 2;
+			continue;
+		}
+		if (tok_n == 2) {
+			if (pred->compound) {
+				if (!strcmp(tok, "!="))
+					pred->not = 1;
+				else if (!strcmp(tok, "=="))
+					pred->not = 0;
+				else {
+					pred->field_name = NULL;
+					return -EINVAL;
+				}
+			} else {
+				val_str = tok;
+				break; /* done */
+			}
+			tok_n = 3;
+			continue;
+		}
+		if (tok_n == 3) {
+			val_str = tok;
+			break; /* done */
+		}
+	}
+
+	pred->field_name = kstrdup(pred->field_name, GFP_KERNEL);
+	if (!pred->field_name)
+		return -ENOMEM;
+
+	pred->val = simple_strtoull(val_str, &tmp, 10);
+	if (tmp == val_str) {
+		pred->str_val = kstrdup(val_str, GFP_KERNEL);
+		if (!pred->str_val)
+			return -ENOMEM;
+	}
+
+	return 0;
+}
+
+
diff --git a/kernel/trace/trace_events_stage_3.h b/kernel/trace/trace_events_stage_3.h
index 468938f..ebf215e 100644
--- a/kernel/trace/trace_events_stage_3.h
+++ b/kernel/trace/trace_events_stage_3.h
@@ -204,6 +204,7 @@ static struct ftrace_event_call event_##call;				\
 									\
 static void ftrace_raw_event_##call(proto)				\
 {									\
+	struct ftrace_event_call *call = &event_##call;			\
 	struct ring_buffer_event *event;				\
 	struct ftrace_raw_##call *entry;				\
 	unsigned long irq_flags;					\
@@ -222,6 +223,9 @@ static void ftrace_raw_event_##call(proto)				\
 	assign;								\
 									\
 	trace_current_buffer_unlock_commit(event, irq_flags, pc);	\
+									\
+	if (call->preds && !filter_match_preds(call, entry))		\
+		ring_buffer_event_discard(event);			\
 }									\
 									\
 static int ftrace_raw_reg_event_##call(void)				\
-- 
1.5.6.3




