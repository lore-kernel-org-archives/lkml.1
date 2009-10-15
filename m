Return-Path: <linux-kernel-owner+w=401wt.eu-S935014AbZJOIvH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935014AbZJOIvH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Oct 2009 04:51:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934908AbZJOIvG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Oct 2009 04:51:06 -0400
Received: from hera.kernel.org ([140.211.167.34]:33809 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934887AbZJOIvC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Oct 2009 04:51:02 -0400
Date: Thu, 15 Oct 2009 08:49:54 GMT
From: tip-bot for Steven Rostedt <srostedt@redhat.com>
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, hpa@zytor.com,
       mingo@redhat.com, peterz@infradead.org, fweisbec@gmail.com,
       srostedt@redhat.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, acme@redhat.com,
       linux-kernel@vger.kernel.org, fweisbec@gmail.com, srostedt@redhat.com,
       peterz@infradead.org, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20091014194359.190809589@goodmis.org>
References: <20091014194359.190809589@goodmis.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools: Still continue on failed parsing of an event
Message-ID: <tip-07a4bdddcf2546ccfbfb3c782deab636c371edeb@git.kernel.org>
Git-Commit-ID: 07a4bdddcf2546ccfbfb3c782deab636c371edeb
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Thu, 15 Oct 2009 08:49:55 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  07a4bdddcf2546ccfbfb3c782deab636c371edeb
Gitweb:     http://git.kernel.org/tip/07a4bdddcf2546ccfbfb3c782deab636c371edeb
Author:     Steven Rostedt <srostedt@redhat.com>
AuthorDate: Wed, 14 Oct 2009 15:43:39 -0400
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 15 Oct 2009 10:42:38 +0200

perf tools: Still continue on failed parsing of an event

Even though an event may fail to parse, we should not kill the
entire report. The trace should still be able to show what it
can.

If an event fails to parse, a warning is printed, and the output
continues.

Signed-off-by: Steven Rostedt <srostedt@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
LKML-Reference: <20091014194359.190809589@goodmis.org>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 tools/perf/util/trace-event-parse.c |   38 ++++++++++++++++++++++++----------
 tools/perf/util/trace-event.h       |   14 +++++++-----
 2 files changed, 35 insertions(+), 17 deletions(-)

diff --git a/tools/perf/util/trace-event-parse.c b/tools/perf/util/trace-event-parse.c
index 0739b12..eda0a24 100644
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
 		    enum event_type expect, const char *expect_tok)
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
@@ -668,7 +668,7 @@ static int __read_expected(enum event_type expect, const char *str, int newline_
 
 	free_token(token);
 
-	return 0;
+	return ret;
 }
 
 static int read_expected(enum event_type expect, const char *str)
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
