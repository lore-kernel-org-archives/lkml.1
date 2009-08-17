Return-Path: <linux-kernel-owner+w=401wt.eu-S1758129AbZHQVH7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758129AbZHQVH7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Aug 2009 17:07:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758122AbZHQVH6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Aug 2009 17:07:58 -0400
Received: from mail-ew0-f228.google.com ([209.85.219.228]:47999 "EHLO
	mail-ew0-f228.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753865AbZHQVH4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Aug 2009 17:07:56 -0400
X-Greylist: delayed 466 seconds by postgrey-1.27 at vger.kernel.org; Mon, 17 Aug 2009 17:07:29 EDT
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=Fme0+kDfhKOyTWWJ3lDjow2EXHw/krBlw0Pt3QdqYVnrZoC4UePkUcMmNPYDlEKr8N
         E8xZWpgfs/0sYJfxRASyU06IDZHrZbWSLcgsANE1/14CuBVhkZeGlIFnactXqPhcwspw
         VGu15y3VrN8qIjmHrvx6XqPbuWSfcmEP7ipnU=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Mike Galbraith <efault@gmx.de>, Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH 3/4] perf tools: Record events info also when :record suffix is used.
Date: Mon, 17 Aug 2009 23:07:50 +0200
Message-Id: <1250543271-8383-3-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
In-Reply-To: <20090817144007.GC3602@elte.hu>
References: <20090817144007.GC3602@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

You can enable a counter's PERF_SAMPLE_RAW attribute in two fashions:

- using the -R option (every counters get PERF_SAMPLE_RAW)
- using the :record suffix in a trace event counter name

Currently we record the events info in a trace.info file from perf
record when the former method is used but we omit it with the latter.

Check both situations.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Steven Rostedt <rostedt@goodmis.org>
---
 tools/perf/builtin-record.c |   14 +++++++++++---
 1 files changed, 11 insertions(+), 3 deletions(-)

diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index 3ce2f03..acbe594 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -520,9 +520,6 @@ static int __cmd_record(int argc, const char **argv)
 	signal(SIGCHLD, sig_handler);
 	signal(SIGINT, sig_handler);
 
-	if (raw_samples)
-		read_tracing_data();
-
 	if (!stat(output_name, &st) && st.st_size) {
 		if (!force && !append_file) {
 			fprintf(stderr, "Error, output file %s exists, use -A to append or -f to overwrite.\n",
@@ -550,6 +547,17 @@ static int __cmd_record(int argc, const char **argv)
 	else
 		header = perf_header__new();
 
+
+	if (raw_samples) {
+		read_tracing_data();
+	} else {
+		for (i = 0; i < nr_counters; i++) {
+			if (attrs[i].sample_type & PERF_SAMPLE_RAW) {
+				read_tracing_data();
+				break;
+			}
+		}
+	}
 	atexit(atexit_header);
 
 	if (!system_wide) {
-- 
1.6.2.3

