Return-Path: <linux-kernel-owner+w=401wt.eu-S1758236AbZHQWHj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758236AbZHQWHj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Aug 2009 18:07:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932428AbZHQWHh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Aug 2009 18:07:37 -0400
Received: from hera.kernel.org ([140.211.167.34]:49478 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932448AbZHQWHd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Aug 2009 18:07:33 -0400
Date: Mon, 17 Aug 2009 22:06:56 GMT
From: tip-bot for Frederic Weisbecker <fweisbec@gmail.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, hpa@zytor.com,
       mingo@redhat.com, efault@gmx.de, peterz@infradead.org,
       fweisbec@gmail.com, rostedt@goodmis.org, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, acme@redhat.com,
       linux-kernel@vger.kernel.org, fweisbec@gmail.com, rostedt@goodmis.org,
       peterz@infradead.org, efault@gmx.de, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1250543271-8383-4-git-send-email-fweisbec@gmail.com>
References: <1250543271-8383-4-git-send-email-fweisbec@gmail.com>
Subject: [tip:perfcounters/tracing] perf tools: Make trace event format parser aware of cast to pointers
Message-ID: <tip-3f9edc2382d5f7c97c693838abb207a9d6bab1fa@git.kernel.org>
Git-Commit-ID: 3f9edc2382d5f7c97c693838abb207a9d6bab1fa
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Mon, 17 Aug 2009 22:06:57 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  3f9edc2382d5f7c97c693838abb207a9d6bab1fa
Gitweb:     http://git.kernel.org/tip/3f9edc2382d5f7c97c693838abb207a9d6bab1fa
Author:     Frederic Weisbecker <fweisbec@gmail.com>
AuthorDate: Mon, 17 Aug 2009 23:07:51 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 18 Aug 2009 00:00:19 +0200

perf tools: Make trace event format parser aware of cast to pointers

The ftrace event format parser handles the usual casts but not
the cast to pointers. Such casts have been introduced recently
with the module trace events and raise the following parsing
error:

	Fatal: bad op token )

This is because it considers the "*" character as a binary
operator. Make it then aware of casts to pointers.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Steven Rostedt <rostedt@goodmis.org>
LKML-Reference: <1250543271-8383-4-git-send-email-fweisbec@gmail.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 tools/perf/util/trace-event-parse.c |   31 +++++++++++++++++++++++++++----
 1 files changed, 27 insertions(+), 4 deletions(-)

diff --git a/tools/perf/util/trace-event-parse.c b/tools/perf/util/trace-event-parse.c
index ead6a9a..b53b27f 100644
--- a/tools/perf/util/trace-event-parse.c
+++ b/tools/perf/util/trace-event-parse.c
@@ -1462,6 +1462,7 @@ process_paren(struct event *event, struct print_arg *arg, char **tok)
 {
 	struct print_arg *item_arg;
 	enum event_type type;
+	int ptr_cast = 0;
 	char *token;
 
 	type = process_arg(event, arg, &token);
@@ -1469,11 +1470,26 @@ process_paren(struct event *event, struct print_arg *arg, char **tok)
 	if (type == EVENT_ERROR)
 		return EVENT_ERROR;
 
-	if (type == EVENT_OP)
-		type = process_op(event, arg, &token);
+	if (type == EVENT_OP) {
+		/* handle the ptr casts */
+		if (!strcmp(token, "*")) {
+			/*
+			 * FIXME: should we zapp whitespaces before ')' ?
+			 * (may require a peek_token_item())
+			 */
+			if (__peek_char() == ')') {
+				ptr_cast = 1;
+				free_token(token);
+				type = read_token_item(&token);
+			}
+		}
+		if (!ptr_cast) {
+			type = process_op(event, arg, &token);
 
-	if (type == EVENT_ERROR)
-		return EVENT_ERROR;
+			if (type == EVENT_ERROR)
+				return EVENT_ERROR;
+		}
+	}
 
 	if (test_type_token(type, token, EVENT_DELIM, (char *)")")) {
 		free_token(token);
@@ -1499,6 +1515,13 @@ process_paren(struct event *event, struct print_arg *arg, char **tok)
 		item_arg = malloc_or_die(sizeof(*item_arg));
 
 		arg->type = PRINT_TYPE;
+		if (ptr_cast) {
+			char *old = arg->atom.atom;
+
+			arg->atom.atom = malloc_or_die(strlen(old + 3));
+			sprintf(arg->atom.atom, "%s *", old);
+			free(old);
+		}
 		arg->typecast.type = arg->atom.atom;
 		arg->typecast.item = item_arg;
 		type = process_arg_token(event, item_arg, &token, type);
