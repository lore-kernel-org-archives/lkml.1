Return-Path: <linux-kernel-owner+w=401wt.eu-S1752986AbZJTXUb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752986AbZJTXUb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Oct 2009 19:20:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752957AbZJTXUb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Oct 2009 19:20:31 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:62518 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751319AbZJTXUa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Oct 2009 19:20:30 -0400
Message-Id: <20091020232034.237814877@goodmis.org>
User-Agent: quilt/0.48-1
Date: Tue, 20 Oct 2009 19:19:35 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 2/2] [PATCH 2/2] perf tools: use strsep over strtok_r for parsing single line
References: <20091020231933.203083200@goodmis.org>
Content-Disposition: inline; filename=0002-perf-tools-use-strsep-over-strtok_r-for-parsing-sing.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

The second argument in the strtok_r is not to be used generically and can
have different implementations. Currently the function parsing of
the perf trace code uses the second argument to copy data from.
This can crash the tool or just have unpredictable results.

The correct solution is to use strsep which has a defined result.

I also added a check to see if the result was correct, and will break
out of the loop in case it fails to parse as expected.

Reported-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
LKML-Reference: <1255971369-11368-1-git-send-email-acme@redhat.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 tools/perf/util/trace-event-parse.c |    9 ++++++---
 1 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/tools/perf/util/trace-event-parse.c b/tools/perf/util/trace-event-parse.c
index 4b61b49..eae5605 100644
--- a/tools/perf/util/trace-event-parse.c
+++ b/tools/perf/util/trace-event-parse.c
@@ -286,16 +286,19 @@ void parse_ftrace_printk(char *file, unsigned int size __unused)
 	char *line;
 	char *next = NULL;
 	char *addr_str;
-	char *fmt;
 	int i;
 
 	line = strtok_r(file, "\n", &next);
 	while (line) {
+		addr_str = strsep(&line, ":");
+		if (!line) {
+			warning("error parsing print strings");
+			break;
+		}
 		item = malloc_or_die(sizeof(*item));
-		addr_str = strtok_r(line, ":", &fmt);
 		item->addr = strtoull(addr_str, NULL, 16);
 		/* fmt still has a space, skip it */
-		item->printk = strdup(fmt+1);
+		item->printk = strdup(line+1);
 		item->next = list;
 		list = item;
 		line = strtok_r(NULL, "\n", &next);
-- 
1.6.3.3


