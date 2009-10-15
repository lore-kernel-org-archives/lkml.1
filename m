Return-Path: <linux-kernel-owner+w=401wt.eu-S934952AbZJOItT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934952AbZJOItT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Oct 2009 04:49:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933118AbZJOItS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Oct 2009 04:49:18 -0400
Received: from hera.kernel.org ([140.211.167.34]:52391 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934847AbZJOItQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Oct 2009 04:49:16 -0400
Date: Thu, 15 Oct 2009 08:48:10 GMT
From: tip-bot for Steven Rostedt <srostedt@redhat.com>
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, hpa@zytor.com,
       mingo@redhat.com, peterz@infradead.org, fweisbec@gmail.com,
       srostedt@redhat.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, acme@redhat.com,
       linux-kernel@vger.kernel.org, fweisbec@gmail.com, srostedt@redhat.com,
       peterz@infradead.org, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20091014194357.253818714@goodmis.org>
References: <20091014194357.253818714@goodmis.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools: Handle print concatenations in event format file
Message-ID: <tip-924a79af2cdee26a034b9bdce8c9c76995b5c901@git.kernel.org>
Git-Commit-ID: 924a79af2cdee26a034b9bdce8c9c76995b5c901
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Thu, 15 Oct 2009 08:48:11 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  924a79af2cdee26a034b9bdce8c9c76995b5c901
Gitweb:     http://git.kernel.org/tip/924a79af2cdee26a034b9bdce8c9c76995b5c901
Author:     Steven Rostedt <srostedt@redhat.com>
AuthorDate: Wed, 14 Oct 2009 15:43:32 -0400
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 15 Oct 2009 10:42:34 +0200

perf tools: Handle print concatenations in event format file

kmem_alloc ftrace event format had a string that was broken up
by two tokens. "string 1" "string 2". This patch lets the parser
be able to handle the concatenation.

Signed-off-by: Steven Rostedt <srostedt@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
LKML-Reference: <20091014194357.253818714@goodmis.org>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 tools/perf/util/trace-event-parse.c |   16 ++++++++++++++++
 1 files changed, 16 insertions(+), 0 deletions(-)

diff --git a/tools/perf/util/trace-event-parse.c b/tools/perf/util/trace-event-parse.c
index eef60df..a05c714 100644
--- a/tools/perf/util/trace-event-parse.c
+++ b/tools/perf/util/trace-event-parse.c
@@ -1734,6 +1734,7 @@ static int event_read_print(struct event *event)
 	if (read_expect_type(EVENT_DQUOTE, &token) < 0)
 		goto fail;
 
+ concat:
 	event->print_fmt.format = token;
 	event->print_fmt.args = NULL;
 
@@ -1743,6 +1744,21 @@ static int event_read_print(struct event *event)
 	if (type == EVENT_NONE)
 		return 0;
 
+	/* Handle concatination of print lines */
+	if (type == EVENT_DQUOTE) {
+		char *cat;
+
+		cat = malloc_or_die(strlen(event->print_fmt.format) +
+				    strlen(token) + 1);
+		strcpy(cat, event->print_fmt.format);
+		strcat(cat, token);
+		free_token(token);
+		free_token(event->print_fmt.format);
+		event->print_fmt.format = NULL;
+		token = cat;
+		goto concat;
+	}
+			     
 	if (test_type_token(type, token, EVENT_DELIM, (char *)","))
 		goto fail;
 
