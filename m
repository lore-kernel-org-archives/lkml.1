Return-Path: <linux-kernel-owner+w=401wt.eu-S932676AbZJMCU3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932676AbZJMCU3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Oct 2009 22:20:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932587AbZJMCU2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Oct 2009 22:20:28 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:62902 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S932583AbZJMCU1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Oct 2009 22:20:27 -0400
Message-ID: <4AD3E380.4000908@cn.fujitsu.com>
Date: Tue, 13 Oct 2009 10:18:40 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>, Tom Zanussi <tzanussi@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/4] tracing/filters: Use a different op for glob match
References: <4AD3E34C.1020301@cn.fujitsu.com>
In-Reply-To: <4AD3E34C.1020301@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"==" will always do a full match, and "~" will do a glob match.

In the future, we may add "=~" for regex match.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
---
 kernel/trace/trace.h               |    2 +-
 kernel/trace/trace_events_filter.c |   59 +++++++++++++++++-------------------
 2 files changed, 29 insertions(+), 32 deletions(-)

diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
index 300cdae..b5f30d5 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -724,7 +724,7 @@ typedef int (*filter_pred_fn_t) (struct filter_pred *pred, void *event,
 typedef int (*regex_match_func)(char *str, struct regex *r, int len);
 
 enum regex_type {
-	MATCH_FULL,
+	MATCH_FULL = 0,
 	MATCH_FRONT_ONLY,
 	MATCH_MIDDLE_ONLY,
 	MATCH_END_ONLY,
diff --git a/kernel/trace/trace_events_filter.c b/kernel/trace/trace_events_filter.c
index 1d22749..c7e1a54 100644
--- a/kernel/trace/trace_events_filter.c
+++ b/kernel/trace/trace_events_filter.c
@@ -29,6 +29,7 @@ enum filter_op_ids
 {
 	OP_OR,
 	OP_AND,
+	OP_GLOB,
 	OP_NE,
 	OP_EQ,
 	OP_LT,
@@ -46,16 +47,17 @@ struct filter_op {
 };
 
 static struct filter_op filter_ops[] = {
-	{ OP_OR, "||", 1 },
-	{ OP_AND, "&&", 2 },
-	{ OP_NE, "!=", 4 },
-	{ OP_EQ, "==", 4 },
-	{ OP_LT, "<", 5 },
-	{ OP_LE, "<=", 5 },
-	{ OP_GT, ">", 5 },
-	{ OP_GE, ">=", 5 },
-	{ OP_NONE, "OP_NONE", 0 },
-	{ OP_OPEN_PAREN, "(", 0 },
+	{ OP_OR,	"||",		1 },
+	{ OP_AND,	"&&",		2 },
+	{ OP_GLOB,	"~",		4 },
+	{ OP_NE,	"!=",		4 },
+	{ OP_EQ,	"==",		4 },
+	{ OP_LT,	"<",		5 },
+	{ OP_LE,	"<=",		5 },
+	{ OP_GT,	">",		5 },
+	{ OP_GE,	">=",		5 },
+	{ OP_NONE,	"OP_NONE",	0 },
+	{ OP_OPEN_PAREN, "(",		0 },
 };
 
 enum {
@@ -329,22 +331,18 @@ enum regex_type filter_parse_regex(char *buff, int len, char **search, int *not)
 	return type;
 }
 
-static int filter_build_regex(struct filter_pred *pred)
+static void filter_build_regex(struct filter_pred *pred)
 {
 	struct regex *r = &pred->regex;
-	char *search, *dup;
-	enum regex_type type;
-	int not;
-
-	type = filter_parse_regex(r->pattern, r->len, &search, &not);
-	dup = kstrdup(search, GFP_KERNEL);
-	if (!dup)
-		return -ENOMEM;
-
-	strcpy(r->pattern, dup);
-	kfree(dup);
-
-	r->len = strlen(r->pattern);
+	char *search;
+	enum regex_type type = MATCH_FULL;
+	int not = 0;
+
+	if (pred->op == OP_GLOB) {
+		type = filter_parse_regex(r->pattern, r->len, &search, &not);
+		r->len = strlen(search);
+		memmove(r->pattern, search, r->len+1);
+	}
 
 	switch (type) {
 	case MATCH_FULL:
@@ -362,8 +360,6 @@ static int filter_build_regex(struct filter_pred *pred)
 	}
 
 	pred->not ^= not;
-
-	return 0;
 }
 
 /* return 1 if event matches, 0 otherwise (discard) */
@@ -676,7 +672,10 @@ static bool is_string_field(struct ftrace_event_field *field)
 
 static int is_legal_op(struct ftrace_event_field *field, int op)
 {
-	if (is_string_field(field) && (op != OP_EQ && op != OP_NE))
+	if (is_string_field(field) &&
+	    (op != OP_EQ && op != OP_NE && op != OP_GLOB))
+		return 0;
+	if (!is_string_field(field) && op == OP_GLOB)
 		return 0;
 
 	return 1;
@@ -761,15 +760,13 @@ static int filter_add_pred(struct filter_parse_state *ps,
 	}
 
 	if (is_string_field(field)) {
-		ret = filter_build_regex(pred);
-		if (ret)
-			return ret;
+		filter_build_regex(pred);
 
 		if (field->filter_type == FILTER_STATIC_STRING) {
 			fn = filter_pred_string;
 			pred->regex.field_len = field->size;
 		} else if (field->filter_type == FILTER_DYN_STRING)
-				fn = filter_pred_strloc;
+			fn = filter_pred_strloc;
 		else {
 			fn = filter_pred_pchar;
 			pred->regex.field_len = strlen(pred->regex.pattern);
-- 
1.6.3

