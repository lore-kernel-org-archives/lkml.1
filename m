Return-Path: <linux-kernel-owner+w=401wt.eu-S1753616AbZHaEpq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753616AbZHaEpq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Aug 2009 00:45:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753309AbZHaEpp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Aug 2009 00:45:45 -0400
Received: from mail-ew0-f228.google.com ([209.85.219.228]:64608 "EHLO
	mail-ew0-f228.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751921AbZHaEpZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Aug 2009 00:45:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=ZBGBsxoX87etDlAFeLMxLEoNdT8S5p9XAmOrO0NTUeXUrcF/KFUb5WY5BTSXW3+1BH
         q58WexvN1aAX0umO5BN4mL1p3PNjeip4noes/NicSSbiWfiOZd94bcxuzOlaqU8N9ttr
         K5wgTpq9pQBvE/qsDNpZyeUYyqtlh6UOobl2k=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH 4/4] perf tools: Complete support for dynamic strings
Date: Mon, 31 Aug 2009 06:45:21 +0200
Message-Id: <1251693921-6579-4-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
In-Reply-To: <1251682323-10395-1-git-send-email-fweisbec@gmail.com>
References: <1251682323-10395-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Complete support for __str_loc type strings of ftrace events which
have dynamic offsets values set for each of them inside their sammples.

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
-- 
1.6.2.3

