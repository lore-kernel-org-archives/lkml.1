Return-Path: <linux-kernel-owner+w=401wt.eu-S934989AbZJOIuT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934989AbZJOIuT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Oct 2009 04:50:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934975AbZJOIuQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Oct 2009 04:50:16 -0400
Received: from hera.kernel.org ([140.211.167.34]:33751 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934911AbZJOIuM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Oct 2009 04:50:12 -0400
Date: Thu, 15 Oct 2009 08:49:10 GMT
From: tip-bot for Steven Rostedt <srostedt@redhat.com>
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, hpa@zytor.com,
       mingo@redhat.com, peterz@infradead.org, fweisbec@gmail.com,
       srostedt@redhat.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, acme@redhat.com,
       linux-kernel@vger.kernel.org, fweisbec@gmail.com, srostedt@redhat.com,
       peterz@infradead.org, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20091014194358.409327875@goodmis.org>
References: <20091014194358.409327875@goodmis.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools: Handle * as typecast in trace parsing
Message-ID: <tip-b99af874829cba2b30d212bc6fd31b56275ee4d2@git.kernel.org>
Git-Commit-ID: b99af874829cba2b30d212bc6fd31b56275ee4d2
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Thu, 15 Oct 2009 08:49:13 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  b99af874829cba2b30d212bc6fd31b56275ee4d2
Gitweb:     http://git.kernel.org/tip/b99af874829cba2b30d212bc6fd31b56275ee4d2
Author:     Steven Rostedt <srostedt@redhat.com>
AuthorDate: Wed, 14 Oct 2009 15:43:36 -0400
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 15 Oct 2009 10:42:36 +0200

perf tools: Handle * as typecast in trace parsing

The '*' is currently only treated as a multiplication, and it
needs to be handled as a typecast pointer.

This is the version used by trace-cmd.

Signed-off-by: Steven Rostedt <srostedt@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
LKML-Reference: <20091014194358.409327875@goodmis.org>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 tools/perf/util/trace-event-parse.c |   50 +++++++++++++++-------------------
 1 files changed, 22 insertions(+), 28 deletions(-)

diff --git a/tools/perf/util/trace-event-parse.c b/tools/perf/util/trace-event-parse.c
index 7aeedb0..f73ee55 100644
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
