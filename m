Return-Path: <linux-kernel-owner+w=401wt.eu-S1751534AbZISRB2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751534AbZISRB2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Sep 2009 13:01:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751232AbZISRB1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Sep 2009 13:01:27 -0400
Received: from hera.kernel.org ([140.211.167.34]:36522 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751179AbZISRB0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Sep 2009 13:01:26 -0400
Date: Sat, 19 Sep 2009 17:00:53 GMT
From: tip-bot for Arjan van de Ven <arjan@infradead.org>
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, arjan@infradead.org,
       hpa@zytor.com, mingo@redhat.com, arjan@linux.intel.com,
       tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, arjan@infradead.org,
       paulus@samba.org, linux-kernel@vger.kernel.org, arjan@linux.intel.com,
       tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20090919133442.0dc2c7f5@infradead.org>
References: <20090919133442.0dc2c7f5@infradead.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perfcounters/core] perf timechart: Add "perf timechart record"
Message-ID: <tip-3c09eebd61eaacca866cd60b50416f18640bc731@git.kernel.org>
Git-Commit-ID: 3c09eebd61eaacca866cd60b50416f18640bc731
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Sat, 19 Sep 2009 17:00:53 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  3c09eebd61eaacca866cd60b50416f18640bc731
Gitweb:     http://git.kernel.org/tip/3c09eebd61eaacca866cd60b50416f18640bc731
Author:     Arjan van de Ven <arjan@infradead.org>
AuthorDate: Sat, 19 Sep 2009 13:34:42 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sat, 19 Sep 2009 18:57:51 +0200

perf timechart: Add "perf timechart record"

Add a command line option to record a trace, similar to "perf sched record".

Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
Cc: fweisbec@gmail.com
Cc: peterz@infradead.org
Cc: Paul Mackerras <paulus@samba.org>
LKML-Reference: <20090919133442.0dc2c7f5@infradead.org>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 tools/perf/builtin-timechart.c |   47 +++++++++++++++++++++++++++++++++------
 1 files changed, 39 insertions(+), 8 deletions(-)

diff --git a/tools/perf/builtin-timechart.c b/tools/perf/builtin-timechart.c
index 00fac1b..58d737e 100644
--- a/tools/perf/builtin-timechart.c
+++ b/tools/perf/builtin-timechart.c
@@ -1086,11 +1086,42 @@ done:
 	return rc;
 }
 
-static const char * const report_usage[] = {
-	"perf report [<options>] <command>",
+static const char * const timechart_usage[] = {
+	"perf timechart [<options>] {record}",
 	NULL
 };
 
+static const char *record_args[] = {
+	"record",
+	"-a",
+	"-R",
+	"-M",
+	"-f",
+	"-c", "1",
+	"-e", "power:power_start",
+	"-e", "power:power_end",
+	"-e", "power:power_frequency",
+	"-e", "sched:sched_wakeup",
+	"-e", "sched:sched_switch",
+};
+
+static int __cmd_record(int argc, const char **argv)
+{
+	unsigned int rec_argc, i, j;
+	const char **rec_argv;
+
+	rec_argc = ARRAY_SIZE(record_args) + argc - 1;
+	rec_argv = calloc(rec_argc + 1, sizeof(char *));
+
+	for (i = 0; i < ARRAY_SIZE(record_args); i++)
+		rec_argv[i] = strdup(record_args[i]);
+
+	for (j = 1; j < (unsigned int)argc; j++, i++)
+		rec_argv[i] = argv[j];
+
+	return cmd_record(i, rec_argv, NULL);
+}
+
 static const struct option options[] = {
 	OPT_STRING('i', "input", &input_name, "file",
 		    "input file name"),
@@ -1106,13 +1137,13 @@ int cmd_timechart(int argc, const char **argv, const char *prefix __used)
 
 	page_size = getpagesize();
 
-	argc = parse_options(argc, argv, options, report_usage, 0);
+	argc = parse_options(argc, argv, options, timechart_usage,
+			PARSE_OPT_STOP_AT_NON_OPTION);
 
-	/*
-	 * Any (unrecognized) arguments left?
-	 */
-	if (argc)
-		usage_with_options(report_usage, options);
+	if (argc && !strncmp(argv[0], "rec", 3))
+		return __cmd_record(argc, argv);
+	else if (argc)
+		usage_with_options(timechart_usage, options);
 
 	setup_pager();
 
