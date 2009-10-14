Return-Path: <linux-kernel-owner+w=401wt.eu-S1759774AbZJNTsL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759774AbZJNTsL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Oct 2009 15:48:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759445AbZJNTqs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Oct 2009 15:46:48 -0400
Received: from [71.74.56.124] ([71.74.56.124]:54315 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-FAIL-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1759249AbZJNTqq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Oct 2009 15:46:46 -0400
Message-Id: <20091014194359.190809589@goodmis.org>
User-Agent: quilt/0.48-1
Date: Wed, 14 Oct 2009 15:43:39 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Steven Rostedt <srostedt@redhat.com>
Subject: [PATCH 08/13] [PATCH 08/13] perf tools: still continue on failed parsing of an event
References: <20091014194330.980165492@goodmis.org>
Content-Disposition: inline; filename=0008-perf-tools-still-continue-on-failed-parsing-of-an-ev.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

Even though an event may fail to parse, we should not kill the entire
report. The trace should still be able to show what it can.

If an event fails to parse, a warning is printed, and the output
continues.

Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---
 tools/perf/util/trace-event-parse.c |   38 ++++++++++++++++++++++++----------
 tools/perf/util/trace-event.h       |   14 +++++++-----
 2 files changed, 35 insertions(+), 17 deletions(-)

diff --git a/tools/perf/util/trace-event-parse.c b/tools/perf/util/trace-event-parse.c
index 6319bf2..f970d75 100644
--- a/tools/perf/util/trace-event-parse.c
+++ b/tools/perf/util/trace-event-parse.c
@@ -613,7 +613,7 @@ static enum event_type read_token_item(char **tok)
 static int test_type(enum event_type type, enum event_type expect)
 {
 	if (type != expect) {
-		die("Error: expected type %d but read %d",
+		warning("Error: expected type %d but read %d",
 		    expect, type);
 		return -1;
 	}
@@ -624,13 +624,13 @@ static int test_type_token(enum event_type type, char *token,
 		    enum event_type expect, char *expect_tok)
 {
 	if (type != expect) {
-		die("Error: expected type %d but read %d",
+		warning("Error: expected type %d but read %d",
 		    expect, type);
 		return -1;
 	}
 
 	if (strcmp(token, expect_tok) != 0) {
-		die("Error: expected '%s' but read '%s'",
+		warning("Error: expected '%s' but read '%s'",
 		    expect_tok, token);
 		return -1;
 	}
@@ -668,7 +668,7 @@ static int __read_expected(enum event_type expect, char *str, int newline_ok)
 
 	free_token(token);
 
-	return 0;
+	return ret;
 }
 
 static int read_expected(enum event_type expect, char *str)
@@ -1258,12 +1258,12 @@ process_op(struct event *event, struct print_arg *arg, char **tok)
 		type = process_array(event, arg, tok);
 
 	} else {
-		die("unknown op '%s'", token);
+		warning("unknown op '%s'", token);
+		event->flags |= EVENT_FL_FAILED;
 		/* the arg is now the left side */
 		return EVENT_NONE;
 	}
 
-
 	if (type == EVENT_OP) {
 		int prio;
 
@@ -2873,7 +2873,7 @@ void print_event(int cpu, void *data, int size, unsigned long long nsecs,
 
 	event = trace_find_event(type);
 	if (!event) {
-		printf("ug! no event found for type %d\n", type);
+		warning("ug! no event found for type %d", type);
 		return;
 	}
 
@@ -2887,6 +2887,12 @@ void print_event(int cpu, void *data, int size, unsigned long long nsecs,
 	       comm, pid,  cpu,
 	       secs, nsecs, event->name);
 
+	if (event->flags & EVENT_FL_FAILED) {
+		printf("EVENT '%s' FAILED TO PARSE\n",
+		       event->name);
+		return;
+	}
+
 	pretty_print(data, size, event);
 	printf("\n");
 }
@@ -3120,12 +3126,16 @@ int parse_event_file(char *buf, unsigned long size, char *sys)
 		die("failed to read event id");
 
 	ret = event_read_format(event);
-	if (ret < 0)
-		die("failed to read event format");
+	if (ret < 0) {
+		warning("failed to read event format for %s", event->name);
+		goto event_failed;
+	}
 
 	ret = event_read_print(event);
-	if (ret < 0)
-		die("failed to read event print fmt");
+	if (ret < 0) {
+		warning("failed to read event print fmt for %s", event->name);
+		goto event_failed;
+	}
 
 	event->system = strdup(sys);
 
@@ -3135,6 +3145,12 @@ int parse_event_file(char *buf, unsigned long size, char *sys)
 
 	add_event(event);
 	return 0;
+
+ event_failed:
+	event->flags |= EVENT_FL_FAILED;
+	/* still add it even if it failed */
+	add_event(event);
+	return -1;
 }
 
 void parse_set_info(int nr_cpus, int long_sz)
diff --git a/tools/perf/util/trace-event.h b/tools/perf/util/trace-event.h
index da77e07..29821ac 100644
--- a/tools/perf/util/trace-event.h
+++ b/tools/perf/util/trace-event.h
@@ -139,12 +139,14 @@ struct event {
 };
 
 enum {
-	EVENT_FL_ISFTRACE	= 1,
-	EVENT_FL_ISPRINT	= 2,
-	EVENT_FL_ISBPRINT	= 4,
-	EVENT_FL_ISFUNC		= 8,
-	EVENT_FL_ISFUNCENT	= 16,
-	EVENT_FL_ISFUNCRET	= 32,
+	EVENT_FL_ISFTRACE	= 0x01,
+	EVENT_FL_ISPRINT	= 0x02,
+	EVENT_FL_ISBPRINT	= 0x04,
+	EVENT_FL_ISFUNC		= 0x08,
+	EVENT_FL_ISFUNCENT	= 0x10,
+	EVENT_FL_ISFUNCRET	= 0x20,
+
+	EVENT_FL_FAILED		= 0x80000000
 };
 
 struct record {
-- 
1.6.3.3


