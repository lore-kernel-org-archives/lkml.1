Return-Path: <linux-kernel-owner+w=401wt.eu-S933609AbZJNTsv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933609AbZJNTsv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Oct 2009 15:48:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759303AbZJNTqp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Oct 2009 15:46:45 -0400
Received: from [71.74.56.122] ([71.74.56.122]:56444 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-FAIL-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1753301AbZJNTqo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Oct 2009 15:46:44 -0400
Message-Id: <20091014194357.521974680@goodmis.org>
User-Agent: quilt/0.48-1
Date: Wed, 14 Oct 2009 15:43:33 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Steven Rostedt <srostedt@redhat.com>
Subject: [PATCH 02/13] [PATCH 02/13] perf tools: fix backslash processing on trace print formats
References: <20091014194330.980165492@goodmis.org>
Content-Disposition: inline; filename=0002-perf-tools-fix-backslash-processing-on-trace-print-f.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

The handling of backslashes was broken. It would stop parsing when
accountering one. Also, '\n', '\t', '\r' and '\\' were not converted.

Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---
 tools/perf/util/trace-event-parse.c |   27 +++++++++++++++++++++++++--
 1 files changed, 25 insertions(+), 2 deletions(-)

diff --git a/tools/perf/util/trace-event-parse.c b/tools/perf/util/trace-event-parse.c
index 2fee75f..cae88de 100644
--- a/tools/perf/util/trace-event-parse.c
+++ b/tools/perf/util/trace-event-parse.c
@@ -522,7 +522,10 @@ static enum event_type __read_token(char **tok)
 			last_ch = ch;
 			ch = __read_char();
 			buf[i++] = ch;
-		} while (ch != quote_ch && last_ch != '\\');
+			/* the '\' '\' will cancel itself */
+			if (ch == '\\' && last_ch == '\\')
+				last_ch = 0;
+		} while (ch != quote_ch || last_ch == '\\');
 		/* remove the last quote */
 		i--;
 		goto out;
@@ -2325,7 +2328,27 @@ static void pretty_print(void *data, int size, struct event *event)
 
 	for (; *ptr; ptr++) {
 		ls = 0;
-		if (*ptr == '%') {
+		if (*ptr == '\\') {
+			ptr++;
+			switch (*ptr) {
+			case 'n':
+				printf("\n");
+				break;
+			case 't':
+				printf("\t");
+				break;
+			case 'r':
+				printf("\r");
+				break;
+			case '\\':
+				printf("\\");
+				break;
+			default:
+				printf("%c", *ptr);
+				break;
+			}
+
+		} else if (*ptr == '%') {
 			saveptr = ptr;
 			show_func = 0;
  cont_process:
-- 
1.6.3.3


