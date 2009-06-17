Return-Path: <linux-kernel-owner+w=401wt.eu-S1762942AbZFQIpx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762942AbZFQIpx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jun 2009 04:45:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765239AbZFQIpi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Jun 2009 04:45:38 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:64088 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1765285AbZFQIpf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jun 2009 04:45:35 -0400
Message-ID: <4A38AD93.4070300@cn.fujitsu.com>
Date: Wed, 17 Jun 2009 16:47:15 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>
CC: Frederic Weisbecker <fweisbec@gmail.com>, Tom Zanussi <tzanussi@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/2] tracing/filters: remove error messages
References: <4A38AD7F.2070408@cn.fujitsu.com>
In-Reply-To: <4A38AD7F.2070408@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now we restore original filter is the new one can't be applied,
and no long show error messages, so we can remove them totally.

Another reason is, I don't think it's good to show error messages
when reading a control file.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
---
 kernel/trace/trace_events_filter.c |  168 ++++++------------------------------
 1 files changed, 27 insertions(+), 141 deletions(-)

diff --git a/kernel/trace/trace_events_filter.c b/kernel/trace/trace_events_filter.c
index 2f706e5..cd7a928 100644
--- a/kernel/trace/trace_events_filter.c
+++ b/kernel/trace/trace_events_filter.c
@@ -60,36 +60,6 @@ static struct filter_op filter_ops[] = {
 	{ OP_OPEN_PAREN, "(", 0 },
 };
 
-enum {
-	FILT_ERR_NONE,
-	FILT_ERR_INVALID_OP,
-	FILT_ERR_UNBALANCED_PAREN,
-	FILT_ERR_TOO_MANY_OPERANDS,
-	FILT_ERR_OPERAND_TOO_LONG,
-	FILT_ERR_FIELD_NOT_FOUND,
-	FILT_ERR_ILLEGAL_FIELD_OP,
-	FILT_ERR_ILLEGAL_INTVAL,
-	FILT_ERR_BAD_SUBSYS_FILTER,
-	FILT_ERR_TOO_MANY_PREDS,
-	FILT_ERR_MISSING_FIELD,
-	FILT_ERR_INVALID_FILTER,
-};
-
-static char *err_text[] = {
-	"No error",
-	"Invalid operator",
-	"Unbalanced parens",
-	"Too many operands",
-	"Operand too long",
-	"Field not found",
-	"Illegal operation for field type",
-	"Illegal integer value",
-	"Couldn't find or set field in one of a subsystem's events",
-	"Too many terms in predicate expression",
-	"Missing field name and/or value",
-	"Meaningless filter expression",
-};
-
 struct opstack_op {
 	int op;
 	struct list_head list;
@@ -105,8 +75,6 @@ struct filter_parse_state {
 	struct filter_op *ops;
 	struct list_head opstack;
 	struct list_head postfix;
-	int lasterr;
-	int lasterr_pos;
 
 	struct {
 		char *string;
@@ -223,12 +191,6 @@ int filter_match_preds(struct ftrace_event_call *call, void *rec)
 }
 EXPORT_SYMBOL_GPL(filter_match_preds);
 
-static void parse_error(struct filter_parse_state *ps, int err, int pos)
-{
-	ps->lasterr = err;
-	ps->lasterr_pos = pos;
-}
-
 static void remove_filter_string(struct event_filter *filter)
 {
 	kfree(filter->filter_string);
@@ -269,48 +231,6 @@ static void free_old_filter(struct event_filter *filter)
 	filter->old_filter = NULL;
 }
 
-static int append_filter_string(struct event_filter *filter,
-				char *string)
-{
-	int newlen;
-	char *new_filter_string;
-
-	BUG_ON(!filter->filter_string);
-	newlen = strlen(filter->filter_string) + strlen(string) + 1;
-	new_filter_string = kmalloc(newlen, GFP_KERNEL);
-	if (!new_filter_string)
-		return -ENOMEM;
-
-	strcpy(new_filter_string, filter->filter_string);
-	strcat(new_filter_string, string);
-	kfree(filter->filter_string);
-	filter->filter_string = new_filter_string;
-
-	return 0;
-}
-
-static void append_filter_err(struct filter_parse_state *ps,
-			      struct event_filter *filter)
-{
-	int pos = ps->lasterr_pos;
-	char *buf, *pbuf;
-
-	buf = (char *)__get_free_page(GFP_TEMPORARY);
-	if (!buf)
-		return;
-
-	append_filter_string(filter, "\n");
-	memset(buf, ' ', PAGE_SIZE);
-	if (pos > PAGE_SIZE - 128)
-		pos = 0;
-	buf[pos] = '^';
-	pbuf = &buf[pos] + 1;
-
-	sprintf(pbuf, "\nparse_error: %s\n", err_text[ps->lasterr]);
-	append_filter_string(filter, buf);
-	free_page((unsigned long) buf);
-}
-
 void print_event_filter(struct ftrace_event_call *call, struct trace_seq *s)
 {
 	struct event_filter *filter = call->filter;
@@ -478,18 +398,15 @@ static void filter_free_subsystem_preds(struct event_subsystem *system,
 	}
 }
 
-static int filter_add_pred_fn(struct filter_parse_state *ps,
-			      struct ftrace_event_call *call,
+static int filter_add_pred_fn(struct ftrace_event_call *call,
 			      struct filter_pred *pred,
 			      filter_pred_fn_t fn)
 {
 	struct event_filter *filter = call->filter;
 	int idx, err;
 
-	if (filter->n_preds == MAX_FILTER_PRED) {
-		parse_error(ps, FILT_ERR_TOO_MANY_PREDS, 0);
+	if (filter->n_preds == MAX_FILTER_PRED)
 		return -ENOSPC;
-	}
 
 	idx = filter->n_preds;
 	filter_clear_pred(filter->preds[idx]);
@@ -570,8 +487,7 @@ static filter_pred_fn_t select_comparison_fn(int op, int field_size,
 	return fn;
 }
 
-static int filter_add_pred(struct filter_parse_state *ps,
-			   struct ftrace_event_call *call,
+static int filter_add_pred(struct ftrace_event_call *call,
 			   struct filter_pred *pred)
 {
 	struct ftrace_event_field *field;
@@ -584,24 +500,20 @@ static int filter_add_pred(struct filter_parse_state *ps,
 
 	if (pred->op == OP_AND) {
 		pred->pop_n = 2;
-		return filter_add_pred_fn(ps, call, pred, filter_pred_and);
+		return filter_add_pred_fn(call, pred, filter_pred_and);
 	} else if (pred->op == OP_OR) {
 		pred->pop_n = 2;
-		return filter_add_pred_fn(ps, call, pred, filter_pred_or);
+		return filter_add_pred_fn(call, pred, filter_pred_or);
 	}
 
 	field = find_event_field(call, pred->field_name);
-	if (!field) {
-		parse_error(ps, FILT_ERR_FIELD_NOT_FOUND, 0);
+	if (!field)
 		return -EINVAL;
-	}
 
 	pred->offset = field->offset;
 
-	if (!is_legal_op(field, pred->op)) {
-		parse_error(ps, FILT_ERR_ILLEGAL_FIELD_OP, 0);
+	if (!is_legal_op(field, pred->op))
 		return -EINVAL;
-	}
 
 	string_type = is_string_field(field->type);
 	if (string_type) {
@@ -612,33 +524,28 @@ static int filter_add_pred(struct filter_parse_state *ps,
 		pred->str_len = field->size;
 		if (pred->op == OP_NE)
 			pred->not = 1;
-		return filter_add_pred_fn(ps, call, pred, fn);
+		return filter_add_pred_fn(call, pred, fn);
 	} else {
 		if (field->is_signed)
 			ret = strict_strtoll(pred->str_val, 0, &val);
 		else
 			ret = strict_strtoull(pred->str_val, 0, &val);
-		if (ret) {
-			parse_error(ps, FILT_ERR_ILLEGAL_INTVAL, 0);
+		if (ret)
 			return -EINVAL;
-		}
 		pred->val = val;
 	}
 
 	fn = select_comparison_fn(pred->op, field->size, field->is_signed);
-	if (!fn) {
-		parse_error(ps, FILT_ERR_INVALID_OP, 0);
+	if (!fn)
 		return -EINVAL;
-	}
 
 	if (pred->op == OP_NE)
 		pred->not = 1;
 
-	return filter_add_pred_fn(ps, call, pred, fn);
+	return filter_add_pred_fn(call, pred, fn);
 }
 
-static int filter_add_subsystem_pred(struct filter_parse_state *ps,
-				     struct event_subsystem *system,
+static int filter_add_subsystem_pred(struct event_subsystem *system,
 				     struct filter_pred *pred,
 				     char *filter_string)
 {
@@ -655,10 +562,8 @@ static int filter_add_subsystem_pred(struct filter_parse_state *ps,
 			return -ENOMEM;
 	}
 
-	if (filter->n_preds == MAX_FILTER_PRED) {
-		parse_error(ps, FILT_ERR_TOO_MANY_PREDS, 0);
+	if (filter->n_preds == MAX_FILTER_PRED)
 		return -ENOSPC;
-	}
 
 	filter->preds[filter->n_preds] = pred;
 	filter->n_preds++;
@@ -676,7 +581,7 @@ static int filter_add_subsystem_pred(struct filter_parse_state *ps,
 		if (call_filter->need_reset)
 			continue;
 
-		err = filter_add_pred(ps, call, pred);
+		err = filter_add_pred(call, pred);
 		if (err)
 			call_filter->need_reset = true;
 	}
@@ -906,10 +811,8 @@ static int filter_parse(struct filter_parse_state *ps)
 
 		if (is_op_char(ps, ch)) {
 			op = infix_get_op(ps, ch);
-			if (op == OP_NONE) {
-				parse_error(ps, FILT_ERR_INVALID_OP, 0);
+			if (op == OP_NONE)
 				return -EINVAL;
-			}
 
 			if (strlen(curr_operand(ps))) {
 				postfix_append_operand(ps, curr_operand(ps));
@@ -948,17 +851,13 @@ static int filter_parse(struct filter_parse_state *ps)
 				postfix_append_op(ps, top_op);
 				top_op = filter_opstack_pop(ps);
 			}
-			if (top_op == OP_NONE) {
-				parse_error(ps, FILT_ERR_UNBALANCED_PAREN, 0);
+			if (top_op == OP_NONE)
 				return -EINVAL;
-			}
 			continue;
 		}
 parse_operand:
-		if (append_operand_char(ps, ch)) {
-			parse_error(ps, FILT_ERR_OPERAND_TOO_LONG, 0);
+		if (append_operand_char(ps, ch))
 			return -EINVAL;
-		}
 	}
 
 	if (strlen(curr_operand(ps)))
@@ -968,10 +867,8 @@ parse_operand:
 		top_op = filter_opstack_pop(ps);
 		if (top_op == OP_NONE)
 			break;
-		if (top_op == OP_OPEN_PAREN) {
-			parse_error(ps, FILT_ERR_UNBALANCED_PAREN, 0);
+		if (top_op == OP_OPEN_PAREN)
 			return -EINVAL;
-		}
 		postfix_append_op(ps, top_op);
 	}
 
@@ -1029,10 +926,8 @@ static int check_preds(struct filter_parse_state *ps)
 		n_normal_preds++;
 	}
 
-	if (!n_normal_preds || n_logical_preds >= n_normal_preds) {
-		parse_error(ps, FILT_ERR_INVALID_FILTER, 0);
+	if (!n_normal_preds || n_logical_preds >= n_normal_preds)
 		return -EINVAL;
-	}
 
 	return 0;
 }
@@ -1057,21 +952,19 @@ static int replace_preds(struct event_subsystem *system,
 				operand1 = elt->operand;
 			else if (!operand2)
 				operand2 = elt->operand;
-			else {
-				parse_error(ps, FILT_ERR_TOO_MANY_OPERANDS, 0);
+			else
 				return -EINVAL;
-			}
 			continue;
 		}
 
 		if (elt->op == OP_AND || elt->op == OP_OR) {
 			pred = create_logical_pred(elt->op);
 			if (call) {
-				err = filter_add_pred(ps, call, pred);
+				err = filter_add_pred(call, pred);
 				filter_free_pred(pred);
 			} else
-				err = filter_add_subsystem_pred(ps, system,
-							pred, filter_string);
+				err = filter_add_subsystem_pred(system, pred,
+								filter_string);
 			if (err)
 				return err;
 
@@ -1079,17 +972,15 @@ static int replace_preds(struct event_subsystem *system,
 			continue;
 		}
 
-		if (!operand1 || !operand2) {
-			parse_error(ps, FILT_ERR_MISSING_FIELD, 0);
+		if (!operand1 || !operand2)
 			return -EINVAL;
-		}
 
 		pred = create_pred(elt->op, operand1, operand2);
 		if (call) {
-			err = filter_add_pred(ps, call, pred);
+			err = filter_add_pred(call, pred);
 			filter_free_pred(pred);
 		} else
-			err = filter_add_subsystem_pred(ps, system, pred,
+			err = filter_add_subsystem_pred(system, pred,
 							filter_string);
 		if (err)
 			return err;
@@ -1121,15 +1012,10 @@ int __apply_event_filter(struct ftrace_event_call *call, char *filter_string)
 
 	parse_init(ps, filter_ops, filter_string);
 	err = filter_parse(ps);
-	if (err) {
-		append_filter_err(ps, call->filter);
+	if (err)
 		goto out;
-	}
 
 	err = replace_preds(NULL, call, ps, filter_string);
-	if (err)
-		append_filter_err(ps, call->filter);
-
 out:
 	filter_opstack_clear(ps);
 	postfix_clear(ps);
-- 1.5.4.rc3 
