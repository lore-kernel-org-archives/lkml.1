Return-Path: <linux-kernel-owner+w=401wt.eu-S935005AbZJOIvF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935005AbZJOIvF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Oct 2009 04:51:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934908AbZJOIvD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Oct 2009 04:51:03 -0400
Received: from hera.kernel.org ([140.211.167.34]:33806 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933140AbZJOIvA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Oct 2009 04:51:00 -0400
Date: Thu, 15 Oct 2009 08:49:39 GMT
From: tip-bot for Steven Rostedt <srostedt@redhat.com>
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, hpa@zytor.com,
       mingo@redhat.com, peterz@infradead.org, fweisbec@gmail.com,
       srostedt@redhat.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, acme@redhat.com,
       linux-kernel@vger.kernel.org, fweisbec@gmail.com, srostedt@redhat.com,
       peterz@infradead.org, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20091014194358.888239553@goodmis.org>
References: <20091014194358.888239553@goodmis.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools: Handle the case with and without the "signed" trace field
Message-ID: <tip-13999e59343b042b0807be2df6ae5895d29782a0@git.kernel.org>
Git-Commit-ID: 13999e59343b042b0807be2df6ae5895d29782a0
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Thu, 15 Oct 2009 08:49:40 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  13999e59343b042b0807be2df6ae5895d29782a0
Gitweb:     http://git.kernel.org/tip/13999e59343b042b0807be2df6ae5895d29782a0
Author:     Steven Rostedt <srostedt@redhat.com>
AuthorDate: Wed, 14 Oct 2009 15:43:38 -0400
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 15 Oct 2009 10:42:37 +0200

perf tools: Handle the case with and without the "signed" trace field

The trace format files now have a "signed" field. But we should
still be able to handle the kernels that do not have this field.

Signed-off-by: Steven Rostedt <srostedt@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
LKML-Reference: <20091014194358.888239553@goodmis.org>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 tools/perf/util/trace-event-parse.c |   81 ++++++++++++++++++++++------------
 1 files changed, 52 insertions(+), 29 deletions(-)

diff --git a/tools/perf/util/trace-event-parse.c b/tools/perf/util/trace-event-parse.c
index 59e4e4d..0739b12 100644
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
 
