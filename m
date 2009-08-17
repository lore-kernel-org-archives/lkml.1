Return-Path: <linux-kernel-owner+w=401wt.eu-S1758135AbZHQVIB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758135AbZHQVIB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Aug 2009 17:08:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758131AbZHQVIA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Aug 2009 17:08:00 -0400
Received: from mail-ew0-f228.google.com ([209.85.219.228]:45319 "EHLO
	mail-ew0-f228.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758111AbZHQVH5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Aug 2009 17:07:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=YBjXRmqO5ouZyxt2DMOw0qPCwOLXMF80bRRnAAx9xaWOhphRwgtD4xesOfi4lZeqRK
         h6/gIzNel5cSE8MM5YHPOOPzAgC+PH7/wUOZLDMARu/PW69jNAlttqg7jQoUOWaKHsDz
         47njb6lCY+rZsmDoCDNCAbUh80RQT7FU8m5Vo=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Mike Galbraith <efault@gmx.de>, Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH 4/4] perf tools: Make trace event format parser aware of cast to pointers
Date: Mon, 17 Aug 2009 23:07:51 +0200
Message-Id: <1250543271-8383-4-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
In-Reply-To: <20090817144007.GC3602@elte.hu>
References: <20090817144007.GC3602@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The ftrace event format parser handles the usual casts but not the
cast to pointers. Such casts have been introduced recently with the
module trace events and raise the following parsing error:

	Fatal: bad op token )

This is because it considers the "*" character as a binary operator.
Make it then aware of casts to pointers.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Steven Rostedt <rostedt@goodmis.org>
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
-- 
1.6.2.3

