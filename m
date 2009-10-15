Return-Path: <linux-kernel-owner+w=401wt.eu-S935022AbZJOIv1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935022AbZJOIv1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Oct 2009 04:51:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934983AbZJOIvX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Oct 2009 04:51:23 -0400
Received: from hera.kernel.org ([140.211.167.34]:33825 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934911AbZJOIvV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Oct 2009 04:51:21 -0400
Date: Thu, 15 Oct 2009 08:50:09 GMT
From: tip-bot for Steven Rostedt <srostedt@redhat.com>
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, hpa@zytor.com,
       mingo@redhat.com, peterz@infradead.org, fweisbec@gmail.com,
       srostedt@redhat.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, acme@redhat.com,
       linux-kernel@vger.kernel.org, fweisbec@gmail.com, srostedt@redhat.com,
       peterz@infradead.org, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20091014194359.520931637@goodmis.org>
References: <20091014194359.520931637@goodmis.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools: Fix bprintk reading in trace output
Message-ID: <tip-ffa1895561645103d8f8059b35d9c06e6eeead2e@git.kernel.org>
Git-Commit-ID: ffa1895561645103d8f8059b35d9c06e6eeead2e
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Thu, 15 Oct 2009 08:50:10 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  ffa1895561645103d8f8059b35d9c06e6eeead2e
Gitweb:     http://git.kernel.org/tip/ffa1895561645103d8f8059b35d9c06e6eeead2e
Author:     Steven Rostedt <srostedt@redhat.com>
AuthorDate: Wed, 14 Oct 2009 15:43:40 -0400
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 15 Oct 2009 10:42:38 +0200

perf tools: Fix bprintk reading in trace output

The bprintk parsing was broken in more ways than one.

The file parsing was incorrect, and the words used by the
arguments are always 4 bytes aligned, even on 64-bit machines.

Signed-off-by: Steven Rostedt <srostedt@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
LKML-Reference: <20091014194359.520931637@goodmis.org>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 tools/perf/util/trace-event-parse.c |   15 +++++++--------
 1 files changed, 7 insertions(+), 8 deletions(-)

diff --git a/tools/perf/util/trace-event-parse.c b/tools/perf/util/trace-event-parse.c
index eda0a24..93a82fe 100644
--- a/tools/perf/util/trace-event-parse.c
+++ b/tools/perf/util/trace-event-parse.c
@@ -284,18 +284,16 @@ void parse_ftrace_printk(char *file, unsigned int size __unused)
 	char *line;
 	char *next = NULL;
 	char *addr_str;
-	int ret;
+	char *fmt;
 	int i;
 
 	line = strtok_r(file, "\n", &next);
 	while (line) {
 		item = malloc_or_die(sizeof(*item));
-		ret = sscanf(line, "%as : %as",
-			     (float *)(void *)&addr_str, /* workaround gcc warning */
-			     (float *)(void *)&item->printk);
+		addr_str = strtok_r(line, ":", &fmt);
 		item->addr = strtoull(addr_str, NULL, 16);
-		free(addr_str);
-
+		/* fmt still has a space, skip it */
+		item->printk = strdup(fmt+1);
 		item->next = list;
 		list = item;
 		line = strtok_r(NULL, "\n", &next);
@@ -2274,8 +2272,9 @@ static struct print_arg *make_bprint_args(char *fmt, void *data, int size, struc
 			case 'u':
 			case 'x':
 			case 'i':
-				bptr = (void *)(((unsigned long)bptr + (long_size - 1)) &
-						~(long_size - 1));
+				/* the pointers are always 4 bytes aligned */
+				bptr = (void *)(((unsigned long)bptr + 3) &
+						~3);
 				switch (ls) {
 				case 0:
 				case 1:
