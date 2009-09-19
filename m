Return-Path: <linux-kernel-owner+w=401wt.eu-S1757567AbZISLg2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757567AbZISLg2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Sep 2009 07:36:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757407AbZISLg1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Sep 2009 07:36:27 -0400
Received: from casper.infradead.org ([85.118.1.10]:50785 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757008AbZISLg0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Sep 2009 07:36:26 -0400
Date: Sat, 19 Sep 2009 13:34:42 +0200
From: Arjan van de Ven <arjan@infradead.org>
To: mingo@elte.hu
Cc: Arjan van de Ven <arjan@infradead.org>, linux-kernel@vger.kernel.org,
       fweisbec@gmail.com, peterz@infradead.org,
       Paul Mackerras <paulus@samba.org>
Subject: [PATCH] perf: Add "perf timechart record"
Message-ID: <20090919133442.0dc2c7f5@infradead.org>
In-Reply-To: <20090919133410.7b23e270@infradead.org>
References: <20090919133410.7b23e270@infradead.org>
Organization: Intel
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.14.7; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


>From f11a27881ef0fcdf459e6f52dd57885c7af93426 Mon Sep 17 00:00:00 2001
From: Arjan van de Ven <arjan@linux.intel.com>
Date: Sat, 19 Sep 2009 12:59:47 +0200
Subject: [PATCH] perf: Add "perf timechart record"

Add a command line option to record a trace, similar to "perf sched record".

Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
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
 
-- 
1.6.0.6


-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
