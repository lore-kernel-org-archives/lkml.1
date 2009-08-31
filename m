Return-Path: <linux-kernel-owner+w=401wt.eu-S1753103AbZHaIi3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753103AbZHaIi3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Aug 2009 04:38:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752847AbZHaIi2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Aug 2009 04:38:28 -0400
Received: from hera.kernel.org ([140.211.167.34]:57253 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752947AbZHaIi1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Aug 2009 04:38:27 -0400
Date: Mon, 31 Aug 2009 08:37:56 GMT
From: tip-bot for Frederic Weisbecker <fweisbec@gmail.com>
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, hpa@zytor.com,
       mingo@redhat.com, peterz@infradead.org, fweisbec@gmail.com,
       rostedt@goodmis.org, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, acme@redhat.com,
       linux-kernel@vger.kernel.org, fweisbec@gmail.com, rostedt@goodmis.org,
       peterz@infradead.org, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1251693921-6579-4-git-send-email-fweisbec@gmail.com>
References: <1251693921-6579-4-git-send-email-fweisbec@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perfcounters/core] perf tools: Complete support for dynamic strings
Message-ID: <tip-561f732c1233f6bf7c3c5c5fb9b4d90bb6c107aa@git.kernel.org>
Git-Commit-ID: 561f732c1233f6bf7c3c5c5fb9b4d90bb6c107aa
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Mon, 31 Aug 2009 08:37:57 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  561f732c1233f6bf7c3c5c5fb9b4d90bb6c107aa
Gitweb:     http://git.kernel.org/tip/561f732c1233f6bf7c3c5c5fb9b4d90bb6c107aa
Author:     Frederic Weisbecker <fweisbec@gmail.com>
AuthorDate: Mon, 31 Aug 2009 06:45:21 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 31 Aug 2009 10:04:49 +0200

perf tools: Complete support for dynamic strings

Complete support for __str_loc type strings of ftrace events
which have dynamic offsets values set for each of them inside
their sammples.

Before:
        geany-5759  [000]     0.000000: lock_release: name
        geany-5759  [000]     0.000000: lock_release: name
        geany-5759  [000]     0.000000: lock_release: name
  kondemand/0-362   [000]     0.000000: lock_release: name
      pdflush-421   [000]     0.000000: lock_release: name

After:
        geany-5759  [000]     0.000000: lock_release: &u->lock
        geany-5759  [000]     0.000000: lock_release: key
        geany-5759  [000]     0.000000: lock_release: &group->notification_mutex
  kondemand/0-362   [000]     0.000000: lock_release: &rq->lock
      pdflush-421   [000]     0.000000: lock_release: &rq->lock

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
LKML-Reference: <1251693921-6579-4-git-send-email-fweisbec@gmail.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Steven Rostedt <rostedt@goodmis.org>


---
 tools/perf/util/trace-event-parse.c |   16 ++++++++++++++--
 tools/perf/util/trace-event.h       |    1 +
 2 files changed, 15 insertions(+), 2 deletions(-)

diff --git a/tools/perf/util/trace-event-parse.c b/tools/perf/util/trace-event-parse.c
index 96c5e97..665dac2 100644
--- a/tools/perf/util/trace-event-parse.c
+++ b/tools/perf/util/trace-event-parse.c
@@ -1548,6 +1548,7 @@ process_str(struct event *event __unused, struct print_arg *arg, char **tok)
 
 	arg->type = PRINT_STRING;
 	arg->string.string = token;
+	arg->string.offset = -1;
 
 	if (read_expected(EVENT_DELIM, (char *)")") < 0)
 		return EVENT_ERROR;
@@ -2031,9 +2032,20 @@ static void print_str_arg(void *data, int size,
 
 	case PRINT_TYPE:
 		break;
-	case PRINT_STRING:
-		printf("%s", arg->string.string);
+	case PRINT_STRING: {
+		int str_offset;
+
+		if (arg->string.offset == -1) {
+			struct format_field *f;
+
+			f = find_any_field(event, arg->string.string);
+			arg->string.offset = f->offset;
+		}
+		str_offset = *(int *)(data + arg->string.offset);
+		str_offset &= 0xffff;
+		printf("%s", ((char *)data) + str_offset);
 		break;
+	}
 	case PRINT_OP:
 		/*
 		 * The only op for string should be ? :
diff --git a/tools/perf/util/trace-event.h b/tools/perf/util/trace-event.h
index 051fcf3..420294a 100644
--- a/tools/perf/util/trace-event.h
+++ b/tools/perf/util/trace-event.h
@@ -50,6 +50,7 @@ struct print_arg_atom {
 
 struct print_arg_string {
 	char			*string;
+	int			offset;
 };
 
 struct print_arg_field {
