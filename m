Return-Path: <linux-kernel-owner+w=401wt.eu-S1762533AbZJOJl3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762533AbZJOJl3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Oct 2009 05:41:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761250AbZJOJl3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Oct 2009 05:41:29 -0400
Received: from hera.kernel.org ([140.211.167.34]:57349 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758052AbZJOJl1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Oct 2009 05:41:27 -0400
Date: Thu, 15 Oct 2009 09:40:01 GMT
From: tip-bot for Li Zefan <lizf@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       tzanussi@gmail.com, lizf@cn.fujitsu.com, peterz@infradead.org,
       fweisbec@gmail.com, rostedt@goodmis.org, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       tzanussi@gmail.com, lizf@cn.fujitsu.com, peterz@infradead.org,
       fweisbec@gmail.com, rostedt@goodmis.org, tglx@linutronix.de,
       mingo@elte.hu
In-Reply-To: <4AD69528.3050309@cn.fujitsu.com>
References: <4AD69528.3050309@cn.fujitsu.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] tracing/filters: Use a different op for glob match
Message-ID: <tip-b0f1a59a98d7ac2102e7e4f22904c26d564a5628@git.kernel.org>
Git-Commit-ID: b0f1a59a98d7ac2102e7e4f22904c26d564a5628
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Thu, 15 Oct 2009 09:40:02 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  b0f1a59a98d7ac2102e7e4f22904c26d564a5628
Gitweb:     http://git.kernel.org/tip/b0f1a59a98d7ac2102e7e4f22904c26d564a5628
Author:     Li Zefan <lizf@cn.fujitsu.com>
AuthorDate: Thu, 15 Oct 2009 11:21:12 +0800
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 15 Oct 2009 11:35:22 +0200

tracing/filters: Use a different op for glob match

"==" will always do a full match, and "~" will do a glob match.

In the future, we may add "=~" for regex match.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
Acked-by: Peter Zijlstra <peterz@infradead.org>
Acked-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Tom Zanussi <tzanussi@gmail.com>
LKML-Reference: <4AD69528.3050309@cn.fujitsu.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/trace/trace.h               |    2 +-
 kernel/trace/trace_events_filter.c |   59 +++++++++++++++++-------------------
 2 files changed, 29 insertions(+), 32 deletions(-)

diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
index 6286145..ffe53dd 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -702,7 +702,7 @@ typedef int (*filter_pred_fn_t) (struct filter_pred *pred, void *event,
 typedef int (*regex_match_func)(char *str, struct regex *r, int len);
 
 enum regex_type {
-	MATCH_FULL,
+	MATCH_FULL = 0,
 	MATCH_FRONT_ONLY,
 	MATCH_MIDDLE_ONLY,
 	MATCH_END_ONLY,
diff --git a/kernel/trace/trace_events_filter.c b/kernel/trace/trace_events_filter.c
index 9c4f9a0..273845f 100644
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
