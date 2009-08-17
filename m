Return-Path: <linux-kernel-owner+w=401wt.eu-S932376AbZHQWH1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932376AbZHQWH1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Aug 2009 18:07:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758213AbZHQWHZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Aug 2009 18:07:25 -0400
Received: from hera.kernel.org ([140.211.167.34]:49475 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758223AbZHQWHW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Aug 2009 18:07:22 -0400
Date: Mon, 17 Aug 2009 22:06:42 GMT
From: tip-bot for Frederic Weisbecker <fweisbec@gmail.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, hpa@zytor.com,
       mingo@redhat.com, efault@gmx.de, peterz@infradead.org,
       fweisbec@gmail.com, rostedt@goodmis.org, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, acme@redhat.com,
       linux-kernel@vger.kernel.org, fweisbec@gmail.com, rostedt@goodmis.org,
       peterz@infradead.org, efault@gmx.de, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1250543271-8383-3-git-send-email-fweisbec@gmail.com>
References: <1250543271-8383-3-git-send-email-fweisbec@gmail.com>
Subject: [tip:perfcounters/tracing] perf tools: Record events info also when :record suffix is used.
Message-ID: <tip-9df37ddd81f54dd41dc4958055c3a3c9b6840aef@git.kernel.org>
Git-Commit-ID: 9df37ddd81f54dd41dc4958055c3a3c9b6840aef
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Mon, 17 Aug 2009 22:06:43 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  9df37ddd81f54dd41dc4958055c3a3c9b6840aef
Gitweb:     http://git.kernel.org/tip/9df37ddd81f54dd41dc4958055c3a3c9b6840aef
Author:     Frederic Weisbecker <fweisbec@gmail.com>
AuthorDate: Mon, 17 Aug 2009 23:07:50 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 18 Aug 2009 00:00:19 +0200

perf tools: Record events info also when :record suffix is used.

You can enable a counter's PERF_SAMPLE_RAW attribute in two
fashions:

- using the -R option (every counters get PERF_SAMPLE_RAW)
- using the :record suffix in a trace event counter name

Currently we record the events info in a trace.info file from
perf record when the former method is used but we omit it with
the latter.

Check both situations.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Steven Rostedt <rostedt@goodmis.org>
LKML-Reference: <1250543271-8383-3-git-send-email-fweisbec@gmail.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


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
