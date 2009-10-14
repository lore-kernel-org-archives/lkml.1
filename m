Return-Path: <linux-kernel-owner+w=401wt.eu-S1759448AbZJNTqs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759448AbZJNTqs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Oct 2009 15:46:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759396AbZJNTqq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Oct 2009 15:46:46 -0400
Received: from [71.74.56.125] ([71.74.56.125]:56522 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-FAIL-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1754462AbZJNTqo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Oct 2009 15:46:44 -0400
Message-Id: <20091014194359.520931637@goodmis.org>
User-Agent: quilt/0.48-1
Date: Wed, 14 Oct 2009 15:43:40 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Steven Rostedt <srostedt@redhat.com>
Subject: [PATCH 09/13] [PATCH 09/13] perf tools: fix bprintk reading in trace output
References: <20091014194330.980165492@goodmis.org>
Content-Disposition: inline; filename=0009-perf-tools-fix-bprintk-reading-in-trace-output.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

The bprintk parsing was broken in more ways than one.

The file parsing was incorrect, and the words used by the arguments
are always 4 bytes aligned, even on 64bit machines.

Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---
 tools/perf/util/trace-event-parse.c |   15 +++++++--------
 1 files changed, 7 insertions(+), 8 deletions(-)

diff --git a/tools/perf/util/trace-event-parse.c b/tools/perf/util/trace-event-parse.c
index f970d75..5f64644 100644
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
-- 
1.6.3.3


