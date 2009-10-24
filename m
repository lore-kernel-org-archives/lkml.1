Return-Path: <linux-kernel-owner+w=401wt.eu-S1753499AbZJXBKh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753499AbZJXBKh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Oct 2009 21:10:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753247AbZJXBKf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Oct 2009 21:10:35 -0400
Received: from hera.kernel.org ([140.211.167.34]:51640 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752791AbZJXBET (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Oct 2009 21:04:19 -0400
Date: Sat, 24 Oct 2009 01:03:57 GMT
From: tip-bot for Steven Rostedt <srostedt@redhat.com>
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, hpa@zytor.com,
       mingo@redhat.com, peterz@infradead.org, fweisbec@gmail.com,
       rostedt@goodmis.org, srostedt@redhat.com, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, acme@redhat.com,
       linux-kernel@vger.kernel.org, peterz@infradead.org, fweisbec@gmail.com,
       rostedt@goodmis.org, srostedt@redhat.com, tglx@linutronix.de,
       mingo@elte.hu
In-Reply-To: <20091020232034.237814877@goodmis.org>
References: <20091020232034.237814877@goodmis.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:branch?] perf tools: Use strsep() over strtok_r() for parsing single line
Message-ID: <tip-4e3b799d7dbb2a12ca8dca8d3594d32095772973@git.kernel.org>
Git-Commit-ID: 4e3b799d7dbb2a12ca8dca8d3594d32095772973
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  4e3b799d7dbb2a12ca8dca8d3594d32095772973
Gitweb:     http://git.kernel.org/tip/4e3b799d7dbb2a12ca8dca8d3594d32095772973
Author:     Steven Rostedt <srostedt@redhat.com>
AuthorDate: Tue, 20 Oct 2009 19:19:35 -0400
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 21 Oct 2009 13:39:57 +0200

perf tools: Use strsep() over strtok_r() for parsing single line

The second argument in the strtok_r() function is not to be used
generically and can have different implementations. Currently
the function parsing of the perf trace code uses the second
argument to copy data from. This can crash the tool or just have
unpredictable results.

The correct solution is to use strsep() which has a defined
result.

I also added a check to see if the result was correct, and will
break out of the loop in case it fails to parse as expected.

Reported-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
LKML-Reference: <20091020232034.237814877@goodmis.org>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
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
