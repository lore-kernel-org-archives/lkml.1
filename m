Return-Path: <linux-kernel-owner+w=401wt.eu-S934995AbZJOIuT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934995AbZJOIuT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Oct 2009 04:50:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934976AbZJOIuS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Oct 2009 04:50:18 -0400
Received: from hera.kernel.org ([140.211.167.34]:33752 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934941AbZJOIuM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Oct 2009 04:50:12 -0400
Date: Thu, 15 Oct 2009 08:48:55 GMT
From: tip-bot for Steven Rostedt <srostedt@redhat.com>
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, hpa@zytor.com,
       mingo@redhat.com, peterz@infradead.org, fweisbec@gmail.com,
       srostedt@redhat.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, acme@redhat.com,
       linux-kernel@vger.kernel.org, fweisbec@gmail.com, srostedt@redhat.com,
       peterz@infradead.org, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20091014194358.124833639@goodmis.org>
References: <20091014194358.124833639@goodmis.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools: Handle arrays in print fields for trace parsing
Message-ID: <tip-0959b8d65ce26131c2d5ccfa518a7b76529280fa@git.kernel.org>
Git-Commit-ID: 0959b8d65ce26131c2d5ccfa518a7b76529280fa
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Thu, 15 Oct 2009 08:48:56 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  0959b8d65ce26131c2d5ccfa518a7b76529280fa
Gitweb:     http://git.kernel.org/tip/0959b8d65ce26131c2d5ccfa518a7b76529280fa
Author:     Steven Rostedt <srostedt@redhat.com>
AuthorDate: Wed, 14 Oct 2009 15:43:35 -0400
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 15 Oct 2009 10:42:36 +0200

perf tools: Handle arrays in print fields for trace parsing

The array used by the ftrace stack events (caller[x]) causes
issues with the parser. This adds code to handle the case, but
it also assumes that the array is of type long.

Note, this is a special case used (currently) only by the ftrace
user and kernel stack records.

Signed-off-by: Steven Rostedt <srostedt@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
LKML-Reference: <20091014194358.124833639@goodmis.org>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 tools/perf/util/trace-event-parse.c |   62 +++++++++++++++++++++++++++++++++++
 1 files changed, 62 insertions(+), 0 deletions(-)

diff --git a/tools/perf/util/trace-event-parse.c b/tools/perf/util/trace-event-parse.c
index 3e643f5..7aeedb0 100644
--- a/tools/perf/util/trace-event-parse.c
+++ b/tools/perf/util/trace-event-parse.c
@@ -1046,6 +1046,35 @@ out_free:
 	return EVENT_ERROR;
 }
 
+static enum event_type
+process_array(struct event *event, struct print_arg *top, char **tok)
+{
+	struct print_arg *arg;
+	enum event_type type;
+	char *token = NULL;
+
+	arg = malloc_or_die(sizeof(*arg));
+	memset(arg, 0, sizeof(*arg));
+
+	*tok = NULL;
+	type = process_arg(event, arg, &token);
+	if (test_type_token(type, token, EVENT_OP, (char *)"]"))
+		goto out_free;
+
+	top->op.right = arg;
+
+	free_token(token);
+	type = read_token_item(&token);
+	*tok = token;
+
+	return type;
+
+out_free:
+	free_token(*tok);
+	free_arg(arg);
+	return EVENT_ERROR;
+}
+
 static int get_op_prio(char *op)
 {
 	if (!op[1]) {
@@ -1192,6 +1221,18 @@ process_op(struct event *event, struct print_arg *arg, char **tok)
 
 		arg->op.right = right;
 
+	} else if (strcmp(token, "[") == 0) {
+
+		left = malloc_or_die(sizeof(*left));
+		*left = *arg;
+
+		arg->type = PRINT_OP;
+		arg->op.op = token;
+		arg->op.left = left;
+
+		arg->op.prio = 0;
+		type = process_array(event, arg, tok);
+
 	} else {
 		die("unknown op '%s'", token);
 		/* the arg is now the left side */
@@ -1931,6 +1972,7 @@ static unsigned long long eval_num_arg(void *data, int size,
 {
 	unsigned long long val = 0;
 	unsigned long long left, right;
+	struct print_arg *larg;
 
 	switch (arg->type) {
 	case PRINT_NULL:
@@ -1957,6 +1999,26 @@ static unsigned long long eval_num_arg(void *data, int size,
 		return 0;
 		break;
 	case PRINT_OP:
+		if (strcmp(arg->op.op, "[") == 0) {
+			/*
+			 * Arrays are special, since we don't want
+			 * to read the arg as is.
+			 */
+			if (arg->op.left->type != PRINT_FIELD)
+				goto default_op; /* oops, all bets off */
+			larg = arg->op.left;
+			if (!larg->field.field) {
+				larg->field.field =
+					find_any_field(event, larg->field.name);
+				if (!larg->field.field)
+					die("field %s not found", larg->field.name);
+			}
+			right = eval_num_arg(data, size, event, arg->op.right);
+			val = read_size(data + larg->field.field->offset +
+					right * long_size, long_size);
+			break;
+		}
+ default_op:
 		left = eval_num_arg(data, size, event, arg->op.left);
 		right = eval_num_arg(data, size, event, arg->op.right);
 		switch (arg->op.op[0]) {
