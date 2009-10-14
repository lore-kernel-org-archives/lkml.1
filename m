Return-Path: <linux-kernel-owner+w=401wt.eu-S1759584AbZJNTqw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759584AbZJNTqw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Oct 2009 15:46:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759400AbZJNTqv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Oct 2009 15:46:51 -0400
Received: from [71.74.56.123] ([71.74.56.123]:56582 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-FAIL-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1759482AbZJNTqt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Oct 2009 15:46:49 -0400
Message-Id: <20091014194358.124833639@goodmis.org>
User-Agent: quilt/0.48-1
Date: Wed, 14 Oct 2009 15:43:35 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Steven Rostedt <srostedt@redhat.com>
Subject: [PATCH 04/13] [PATCH 04/13] perf tools: handle arrays in print fields for trace parsing
References: <20091014194330.980165492@goodmis.org>
Content-Disposition: inline; filename=0004-perf-tools-handle-arrays-in-print-fields-for-trace-p.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

The array used by the ftrace stack events (caller[x]) causes issues with
the parser. This adds code to handle the case, but it also assumes
that the array is of type long.

Note, this is a special case used (currently) only by the ftrace
user and kernel stack records.

Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---
 tools/perf/util/trace-event-parse.c |   62 +++++++++++++++++++++++++++++++++++
 1 files changed, 62 insertions(+), 0 deletions(-)

diff --git a/tools/perf/util/trace-event-parse.c b/tools/perf/util/trace-event-parse.c
index 8388238..374843c 100644
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
-- 
1.6.3.3


