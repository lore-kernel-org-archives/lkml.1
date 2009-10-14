Return-Path: <linux-kernel-owner+w=401wt.eu-S932411AbZJNTq7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932411AbZJNTq7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Oct 2009 15:46:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759710AbZJNTq6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Oct 2009 15:46:58 -0400
Received: from [71.74.56.125] ([71.74.56.125]:54458 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-FAIL-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S932070AbZJNTq4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Oct 2009 15:46:56 -0400
Message-Id: <20091014194358.888239553@goodmis.org>
User-Agent: quilt/0.48-1
Date: Wed, 14 Oct 2009 15:43:38 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Steven Rostedt <srostedt@redhat.com>
Subject: [PATCH 07/13] [PATCH 07/13] perf tools: handle the case with and without the "signed" trace field
References: <20091014194330.980165492@goodmis.org>
Content-Disposition: inline; filename=0007-perf-tools-handle-the-case-with-and-without-the-sign.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

The trace format files now have a "signed" field. But we should still
be able to handle the kernels that do not have this field.

Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---
 tools/perf/util/trace-event-parse.c |   81 ++++++++++++++++++++++------------
 1 files changed, 52 insertions(+), 29 deletions(-)

diff --git a/tools/perf/util/trace-event-parse.c b/tools/perf/util/trace-event-parse.c
index 5dba81d..6319bf2 100644
--- a/tools/perf/util/trace-event-parse.c
+++ b/tools/perf/util/trace-event-parse.c
@@ -924,23 +924,30 @@ static int event_read_fields(struct event *event, struct format_field **fields)
 		if (read_expected(EVENT_OP, (char *)";") < 0)
 			goto fail_expect;
 
-		if (read_expected(EVENT_ITEM, (char *)"signed") < 0)
-			goto fail_expect;
+		type = read_token(&token);
+		if (type != EVENT_NEWLINE) {
+			/* newer versions of the kernel have a "signed" type */
+			if (test_type_token(type, token, EVENT_ITEM, (char *)"signed"))
+				goto fail;
 
-		if (read_expected(EVENT_OP, (char *)":") < 0)
-			goto fail_expect;
+			free_token(token);
 
-		if (read_expect_type(EVENT_ITEM, &token))
-			goto fail;
-		if (strtoul(token, NULL, 0))
-			field->flags |= FIELD_IS_SIGNED;
-		free_token(token);
+			if (read_expected(EVENT_OP, (char *)":") < 0)
+				goto fail_expect;
 
-		if (read_expected(EVENT_OP, (char *)";") < 0)
-			goto fail_expect;
+			if (read_expect_type(EVENT_ITEM, &token))
+				goto fail;
+
+			/* add signed type */
+
+			free_token(token);
+			if (read_expected(EVENT_OP, (char *)";") < 0)
+				goto fail_expect;
+
+			if (read_expect_type(EVENT_NEWLINE, &token))
+				goto fail;
+		}
 
-		if (read_expect_type(EVENT_NEWLINE, &token) < 0)
-			goto fail;
 		free_token(token);
 
 		*fields = field;
@@ -2949,21 +2956,23 @@ static void print_args(struct print_arg *args)
 	}
 }
 
-static void parse_header_field(char *type,
+static void parse_header_field(char *field,
 			       int *offset, int *size)
 {
 	char *token;
+	int type;
 
 	if (read_expected(EVENT_ITEM, (char *)"field") < 0)
 		return;
 	if (read_expected(EVENT_OP, (char *)":") < 0)
 		return;
+
 	/* type */
 	if (read_expect_type(EVENT_ITEM, &token) < 0)
-		return;
+		goto fail;
 	free_token(token);
 
-	if (read_expected(EVENT_ITEM, type) < 0)
+	if (read_expected(EVENT_ITEM, field) < 0)
 		return;
 	if (read_expected(EVENT_OP, (char *)";") < 0)
 		return;
@@ -2972,7 +2981,7 @@ static void parse_header_field(char *type,
 	if (read_expected(EVENT_OP, (char *)":") < 0)
 		return;
 	if (read_expect_type(EVENT_ITEM, &token) < 0)
-		return;
+		goto fail;
 	*offset = atoi(token);
 	free_token(token);
 	if (read_expected(EVENT_OP, (char *)";") < 0)
@@ -2982,22 +2991,36 @@ static void parse_header_field(char *type,
 	if (read_expected(EVENT_OP, (char *)":") < 0)
 		return;
 	if (read_expect_type(EVENT_ITEM, &token) < 0)
-		return;
+		goto fail;
 	*size = atoi(token);
 	free_token(token);
 	if (read_expected(EVENT_OP, (char *)";") < 0)
 		return;
-	if (read_expected(EVENT_ITEM, (char *)"signed") < 0)
-		return;
-	if (read_expected(EVENT_OP, (char *)":") < 0)
-		return;
-	if (read_expect_type(EVENT_ITEM, &token) < 0)
-		return;
-	free_token(token);
-	if (read_expected(EVENT_OP, (char *)";") < 0)
-		return;
-	if (read_expect_type(EVENT_NEWLINE, &token) < 0)
-		return;
+	type = read_token(&token);
+	if (type != EVENT_NEWLINE) {
+		/* newer versions of the kernel have a "signed" type */
+		if (type != EVENT_ITEM)
+			goto fail;
+
+		if (strcmp(token, (char *)"signed") != 0)
+			goto fail;
+
+		free_token(token);
+
+		if (read_expected(EVENT_OP, (char *)":") < 0)
+			return;
+
+		if (read_expect_type(EVENT_ITEM, &token))
+			goto fail;
+
+		free_token(token);
+		if (read_expected(EVENT_OP, (char *)";") < 0)
+			return;
+
+		if (read_expect_type(EVENT_NEWLINE, &token))
+			goto fail;
+	}
+ fail:
 	free_token(token);
 }
 
-- 
1.6.3.3


