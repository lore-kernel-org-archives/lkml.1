Return-Path: <linux-kernel-owner+w=401wt.eu-S1759901AbZJNTsn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759901AbZJNTsn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Oct 2009 15:48:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932477AbZJNTsm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Oct 2009 15:48:42 -0400
Received: from [71.74.56.125] ([71.74.56.125]:56481 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-FAIL-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1759310AbZJNTqp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Oct 2009 15:46:45 -0400
Message-Id: <20091014194358.409327875@goodmis.org>
User-Agent: quilt/0.48-1
Date: Wed, 14 Oct 2009 15:43:36 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Steven Rostedt <srostedt@redhat.com>
Subject: [PATCH 05/13] [PATCH 05/13] perf tools: handle * as typecast in trace parsing
References: <20091014194330.980165492@goodmis.org>
Content-Disposition: inline; filename=0005-perf-tools-handle-as-typecast-in-trace-parsing.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

The '*' is currently only treated as a multiplication, and it needs
to be handled as a typecast pointer.

This is the version used by trace-cmd.

Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---
 tools/perf/util/trace-event-parse.c |   50 +++++++++++++++-------------------
 1 files changed, 22 insertions(+), 28 deletions(-)

diff --git a/tools/perf/util/trace-event-parse.c b/tools/perf/util/trace-event-parse.c
index 374843c..d8c86f1 100644
--- a/tools/perf/util/trace-event-parse.c
+++ b/tools/perf/util/trace-event-parse.c
@@ -1217,7 +1217,24 @@ process_op(struct event *event, struct print_arg *arg, char **tok)
 
 		right = malloc_or_die(sizeof(*right));
 
-		type = process_arg(event, right, tok);
+		type = read_token_item(&token);
+		*tok = token;
+
+		/* could just be a type pointer */
+		if ((strcmp(arg->op.op, "*") == 0) &&
+		    type == EVENT_DELIM && (strcmp(token, ")") == 0)) {
+			if (left->type != PRINT_ATOM)
+				die("bad pointer type");
+			left->atom.atom = realloc(left->atom.atom,
+					    sizeof(left->atom.atom) + 3);
+			strcat(left->atom.atom, " *");
+			*arg = *left;
+			free(arg);
+
+			return type;
+		}
+
+		type = process_arg_token(event, right, tok, type);
 
 		arg->op.right = right;
 
@@ -1548,7 +1565,6 @@ process_paren(struct event *event, struct print_arg *arg, char **tok)
 {
 	struct print_arg *item_arg;
 	enum event_type type;
-	int ptr_cast = 0;
 	char *token;
 
 	type = process_arg(event, arg, &token);
@@ -1556,26 +1572,11 @@ process_paren(struct event *event, struct print_arg *arg, char **tok)
 	if (type == EVENT_ERROR)
 		return EVENT_ERROR;
 
-	if (type == EVENT_OP) {
-		/* handle the ptr casts */
-		if (!strcmp(token, "*")) {
-			/*
-			 * FIXME: should we zapp whitespaces before ')' ?
-			 * (may require a peek_token_item())
-			 */
-			if (__peek_char() == ')') {
-				ptr_cast = 1;
-				free_token(token);
-				type = read_token_item(&token);
-			}
-		}
-		if (!ptr_cast) {
-			type = process_op(event, arg, &token);
+	if (type == EVENT_OP)
+		type = process_op(event, arg, &token);
 
-			if (type == EVENT_ERROR)
-				return EVENT_ERROR;
-		}
-	}
+	if (type == EVENT_ERROR)
+		return EVENT_ERROR;
 
 	if (test_type_token(type, token, EVENT_DELIM, (char *)")")) {
 		free_token(token);
@@ -1601,13 +1602,6 @@ process_paren(struct event *event, struct print_arg *arg, char **tok)
 		item_arg = malloc_or_die(sizeof(*item_arg));
 
 		arg->type = PRINT_TYPE;
-		if (ptr_cast) {
-			char *old = arg->atom.atom;
-
-			arg->atom.atom = malloc_or_die(strlen(old + 3));
-			sprintf(arg->atom.atom, "%s *", old);
-			free(old);
-		}
 		arg->typecast.type = arg->atom.atom;
 		arg->typecast.item = item_arg;
 		type = process_arg_token(event, item_arg, &token, type);
-- 
1.6.3.3


