Return-Path: <linux-kernel-owner+w=401wt.eu-S934943AbZJOItj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934943AbZJOItj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Oct 2009 04:49:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933118AbZJOIti
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Oct 2009 04:49:38 -0400
Received: from hera.kernel.org ([140.211.167.34]:52409 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755699AbZJOIth (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Oct 2009 04:49:37 -0400
Date: Thu, 15 Oct 2009 08:48:26 GMT
From: tip-bot for Steven Rostedt <srostedt@redhat.com>
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, hpa@zytor.com,
       mingo@redhat.com, peterz@infradead.org, fweisbec@gmail.com,
       srostedt@redhat.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, acme@redhat.com,
       linux-kernel@vger.kernel.org, fweisbec@gmail.com, srostedt@redhat.com,
       peterz@infradead.org, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20091014194357.521974680@goodmis.org>
References: <20091014194357.521974680@goodmis.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools: Fix backslash processing on trace print formats
Message-ID: <tip-91ff2bc191827f0d3f5ad0a433ff7df7d2dd9aee@git.kernel.org>
Git-Commit-ID: 91ff2bc191827f0d3f5ad0a433ff7df7d2dd9aee
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Thu, 15 Oct 2009 08:48:26 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  91ff2bc191827f0d3f5ad0a433ff7df7d2dd9aee
Gitweb:     http://git.kernel.org/tip/91ff2bc191827f0d3f5ad0a433ff7df7d2dd9aee
Author:     Steven Rostedt <srostedt@redhat.com>
AuthorDate: Wed, 14 Oct 2009 15:43:33 -0400
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 15 Oct 2009 10:42:35 +0200

perf tools: Fix backslash processing on trace print formats

The handling of backslashes was broken. It would stop parsing
when encountering one. Also, '\n', '\t', '\r' and '\\' were not
converted.

Signed-off-by: Steven Rostedt <srostedt@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
LKML-Reference: <20091014194357.521974680@goodmis.org>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 tools/perf/util/trace-event-parse.c |   27 +++++++++++++++++++++++++--
 1 files changed, 25 insertions(+), 2 deletions(-)

diff --git a/tools/perf/util/trace-event-parse.c b/tools/perf/util/trace-event-parse.c
index a05c714..2b75ec2 100644
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
