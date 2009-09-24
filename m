Return-Path: <linux-kernel-owner+w=401wt.eu-S1754615AbZIXTtv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754615AbZIXTtv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Sep 2009 15:49:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754223AbZIXTtt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Sep 2009 15:49:49 -0400
Received: from mail-ew0-f211.google.com ([209.85.219.211]:54837 "EHLO
	mail-ew0-f211.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753845AbZIXTtr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Sep 2009 15:49:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=ds96oNcqCPoXejTNUO+552G8z9GHz2OeX113xGlM1kv5CUXiQSydzAHIGCCJRur9g4
         3HWpIshr//O5SFBRkkJs+QZKsyAhJu9YWfkJn2CN2ccfai8XZeQrRmlTUA4i6hH7nijS
         7GSXx7GMx3s2SbV5U+O92451SbO98wdp9qABk=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>, Tom Zanussi <tzanussi@gmail.com>,
       Li Zefan <lizf@cn.fujitsu.com>
Subject: [PATCH 4/5 v2] tracing/filters: Provide basic regex support
Date: Thu, 24 Sep 2009 21:49:34 +0200
Message-Id: <1253821775-8618-5-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
In-Reply-To: <1253821775-8618-1-git-send-email-fweisbec@gmail.com>
References: <1253821775-8618-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch provides basic support for regular expressions in filters.

It supports the following types of regexp:

- *match_beginning
- *match_middle*
- match_end*
- !don't match

Example:
	cd /debug/tracing/events/bkl/lock_kernel
	echo 'file == "*reiserfs*"' > filter
	echo 1 > enable

           gedit-4941  [000]   457.735437: lock_kernel: depth: 0, fs/reiserfs/namei.c:334 reiserfs_lookup()
     sync_supers-227   [001]   461.379985: lock_kernel: depth: 0, fs/reiserfs/super.c:69 reiserfs_sync_fs()
     sync_supers-227   [000]   461.383096: lock_kernel: depth: 0, fs/reiserfs/journal.c:1069 flush_commit_list()
      reiserfs/1-1369  [001]   461.479885: lock_kernel: depth: 0, fs/reiserfs/journal.c:3509 flush_async_commits()

Every string is now handled as a regexp in the filter framework, which
helps to factorize the code for handling both simple strings and
regexp comparisons.

(The regexp parsing code has been wildly cherry picked from ftrace.c
written by Steve.)

v2: Simplify the whole and drop the filter_regex file

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Tom Zanussi <tzanussi@gmail.com>
Cc: Li Zefan <lizf@cn.fujitsu.com>
---
 kernel/trace/trace.h               |   27 ++++--
 kernel/trace/trace_events_filter.c |  155 ++++++++++++++++++++++++++++++++----
 2 files changed, 157 insertions(+), 25 deletions(-)

diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
index 86bcff9..8d0db60 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -702,20 +702,29 @@ struct event_subsystem {
 };
 
 struct filter_pred;
+struct regex;
 
 typedef int (*filter_pred_fn_t) (struct filter_pred *pred, void *event,
 				 int val1, int val2);
 
+typedef int (*regex_match_func)(char *str, struct regex *r, int len);
+
+struct regex {
+	char			pattern[MAX_FILTER_STR_VAL];
+	int			len;
+	int			field_len;
+	regex_match_func	match;
+};
+
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
diff --git a/kernel/trace/trace_events_filter.c b/kernel/trace/trace_events_filter.c
index 189663d..d3c94c1 100644
--- a/kernel/trace/trace_events_filter.c
+++ b/kernel/trace/trace_events_filter.c
@@ -195,9 +195,9 @@ static int filter_pred_string(struct filter_pred *pred, void *event,
 	char *addr = (char *)(event + pred->offset);
 	int cmp, match;
 
-	cmp = strncmp(addr, pred->str_val, pred->str_len);
+	cmp = pred->regex.match(addr, &pred->regex, pred->regex.field_len);
 
-	match = (!cmp) ^ pred->not;
+	match = cmp ^ pred->not;
 
 	return match;
 }
@@ -209,9 +209,9 @@ static int filter_pred_pchar(struct filter_pred *pred, void *event,
 	char **addr = (char **)(event + pred->offset);
 	int cmp, match;
 
-	cmp = strncmp(*addr, pred->str_val, pred->str_len);
+	cmp = pred->regex.match(*addr, &pred->regex, pred->regex.field_len);
 
-	match = (!cmp) ^ pred->not;
+	match = cmp ^ pred->not;
 
 	return match;
 }
@@ -235,9 +235,9 @@ static int filter_pred_strloc(struct filter_pred *pred, void *event,
 	char *addr = (char *)(event + str_loc);
 	int cmp, match;
 
-	cmp = strncmp(addr, pred->str_val, str_len);
+	cmp = pred->regex.match(addr, &pred->regex, str_len);
 
-	match = (!cmp) ^ pred->not;
+	match = cmp ^ pred->not;
 
 	return match;
 }
@@ -248,6 +248,126 @@ static int filter_pred_none(struct filter_pred *pred, void *event,
 	return 0;
 }
 
+/* Basic regex callbacks */
+static int regex_match_full(char *str, struct regex *r, int len)
+{
+	if (strncmp(str, r->pattern, len) == 0)
+		return 1;
+	return 0;
+}
+
+static int regex_match_front(char *str, struct regex *r, int len)
+{
+	if (strncmp(str, r->pattern, len) == 0)
+		return 1;
+	return 0;
+}
+
+static int regex_match_middle(char *str, struct regex *r, int len)
+{
+	if (strstr(str, r->pattern))
+		return 1;
+	return 0;
+}
+
+static int regex_match_end(char *str, struct regex *r, int len)
+{
+	char *ptr = strstr(str, r->pattern);
+
+	if (ptr && (ptr[r->len] == 0))
+		return 1;
+	return 0;
+}
+
+enum regex_type {
+	MATCH_FULL,
+	MATCH_FRONT_ONLY,
+	MATCH_MIDDLE_ONLY,
+	MATCH_END_ONLY,
+};
+
+/*
+ * Pass in a buffer containing a regex and this function will
+ * set search to point to the search part of the buffer and
+ * return the type of search it is (see enum above).
+ * This does modify buff.
+ *
+ * Returns enum type.
+ *  search returns the pointer to use for comparison.
+ *  not returns 1 if buff started with a '!'
+ *     0 otherwise.
+ */
+static enum regex_type
+filter_parse_regex(char *buff, int len, char **search, int *not)
+{
+	int type = MATCH_FULL;
+	int i;
+
+	if (buff[0] == '!') {
+		*not = 1;
+		buff++;
+		len--;
+	} else
+		*not = 0;
+
+	*search = buff;
+
+	for (i = 0; i < len; i++) {
+		if (buff[i] == '*') {
+			if (!i) {
+				*search = buff + 1;
+				type = MATCH_END_ONLY;
+			} else {
+				if (type == MATCH_END_ONLY)
+					type = MATCH_MIDDLE_ONLY;
+				else
+					type = MATCH_FRONT_ONLY;
+				buff[i] = 0;
+				break;
+			}
+		}
+	}
+
+	return type;
+}
+
+static int filter_build_regex(struct filter_pred *pred)
+{
+	struct regex *r = &pred->regex;
+	char *search, *dup;
+	enum regex_type type;
+	int not;
+
+	type = filter_parse_regex(r->pattern, r->len, &search, &not);
+	dup = kstrdup(search, GFP_KERNEL);
+	if (!dup)
+		return -ENOMEM;
+
+	strcpy(r->pattern, dup);
+	kfree(dup);
+
+	r->len = strlen(r->pattern);
+
+	switch (type) {
+	case MATCH_FULL:
+		r->match = regex_match_full;
+		break;
+	case MATCH_FRONT_ONLY:
+		r->match = regex_match_front;
+		break;
+	case MATCH_MIDDLE_ONLY:
+		r->match = regex_match_middle;
+		break;
+	case MATCH_END_ONLY:
+		r->match = regex_match_end;
+		break;
+	}
+
+	pred->not ^= not;
+
+	return 0;
+}
+
 /* return 1 if event matches, 0 otherwise (discard) */
 int filter_match_preds(struct ftrace_event_call *call, void *rec)
 {
@@ -394,7 +514,7 @@ static void filter_clear_pred(struct filter_pred *pred)
 {
 	kfree(pred->field_name);
 	pred->field_name = NULL;
-	pred->str_len = 0;
+	pred->regex.len = 0;
 }
 
 static int filter_set_pred(struct filter_pred *dest,
@@ -658,21 +778,24 @@ static int filter_add_pred(struct filter_parse_state *ps,
 	}
 
 	if (is_string_field(field)) {
-		pred->str_len = field->size;
+		ret = filter_build_regex(pred);
+		if (ret)
+			return ret;
 
-		if (field->filter_type == FILTER_STATIC_STRING)
+		if (field->filter_type == FILTER_STATIC_STRING) {
 			fn = filter_pred_string;
-		else if (field->filter_type == FILTER_DYN_STRING)
-			fn = filter_pred_strloc;
+			pred->regex.field_len = field->size;
+		} else if (field->filter_type == FILTER_DYN_STRING)
+				fn = filter_pred_strloc;
 		else {
 			fn = filter_pred_pchar;
-			pred->str_len = strlen(pred->str_val);
+			pred->regex.field_len = strlen(pred->regex.pattern);
 		}
 	} else {
 		if (field->is_signed)
-			ret = strict_strtoll(pred->str_val, 0, &val);
+			ret = strict_strtoll(pred->regex.pattern, 0, &val);
 		else
-			ret = strict_strtoull(pred->str_val, 0, &val);
+			ret = strict_strtoull(pred->regex.pattern, 0, &val);
 		if (ret) {
 			parse_error(ps, FILT_ERR_ILLEGAL_INTVAL, 0);
 			return -EINVAL;
@@ -1042,8 +1165,8 @@ static struct filter_pred *create_pred(int op, char *operand1, char *operand2)
 		return NULL;
 	}
 
-	strcpy(pred->str_val, operand2);
-	pred->str_len = strlen(operand2);
+	strcpy(pred->regex.pattern, operand2);
+	pred->regex.len = strlen(pred->regex.pattern);
 
 	pred->op = op;
 
-- 
1.6.2.3

