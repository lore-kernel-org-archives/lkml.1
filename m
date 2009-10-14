Return-Path: <linux-kernel-owner+w=401wt.eu-S1759630AbZJNTqx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759630AbZJNTqx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Oct 2009 15:46:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759482AbZJNTqw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Oct 2009 15:46:52 -0400
Received: from [71.74.56.123] ([71.74.56.123]:54254 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-FAIL-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1759497AbZJNTqt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Oct 2009 15:46:49 -0400
Message-Id: <20091014194357.253818714@goodmis.org>
User-Agent: quilt/0.48-1
Date: Wed, 14 Oct 2009 15:43:32 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 01/13] [PATCH 01/13] perf tools: handle print concatinations in event format file
References: <20091014194330.980165492@goodmis.org>
Content-Disposition: inline; filename=0001-perf-tools-handle-print-concatinations-in-event-form.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

kmem_alloc ftrace event format had a string that was broken up by
two tokens. "string 1" "string 2". This patch lets the parser be able
to handle the concatination.

Signef-off-by: Steven Rostedt <srostedt@redhat.com>
---
 tools/perf/util/trace-event-parse.c |   16 ++++++++++++++++
 1 files changed, 16 insertions(+), 0 deletions(-)

diff --git a/tools/perf/util/trace-event-parse.c b/tools/perf/util/trace-event-parse.c
index 6f851f9..2fee75f 100644
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
 
-- 
1.6.3.3


