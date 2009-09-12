Return-Path: <linux-kernel-owner+w=401wt.eu-S1753995AbZILLFR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753995AbZILLFR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Sep 2009 07:05:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753839AbZILLFQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Sep 2009 07:05:16 -0400
Received: from casper.infradead.org ([85.118.1.10]:43156 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753671AbZILLEJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Sep 2009 07:04:09 -0400
Date: Sat, 12 Sep 2009 13:06:45 +0200
From: Arjan van de Ven <arjan@infradead.org>
To: linux-kernel@vger.kernel.org
Cc: Arjan van de Ven <arjan@infradead.org>, mingo@elte.hu, fweisbec@gmail.com,
       peterz@infradead.org
Subject: [PATCH 7/8] perf: Add a perf record --timechart option
Message-ID: <20090912130645.2765de6d@infradead.org>
In-Reply-To: <20090912130306.5d0086ea@infradead.org>
References: <20090912130306.5d0086ea@infradead.org>
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

>From 2f2ee48c6cbf556724929c55b6c0842f737e9658 Mon Sep 17 00:00:00 2001
From: Arjan van de Ven <arjan@linux.intel.com>
Date: Sat, 12 Sep 2009 12:52:13 +0200
Subject: [PATCH] perf: Add a perf record --timechart option

This patch adds a "perf record --timechart" option, to make it easy
to capture traces for use by the timechart tool.

Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
---
 tools/perf/builtin-record.c |   28 ++++++++++++++++++++++++++++
 1 files changed, 28 insertions(+), 0 deletions(-)

diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index 99a12fe..f06a447 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -47,6 +47,7 @@ static int			append_file			= 0;
 static int			call_graph			= 0;
 static int			inherit_stat			= 0;
 static int			no_samples			= 0;
+static int			timechart			= 0;
 static int			sample_address			= 0;
 
 static long			samples;
@@ -385,6 +386,12 @@ static void create_counter(int counter, int cpu, pid_t pid)
 
 	attr->sample_type	|= PERF_SAMPLE_IP | PERF_SAMPLE_TID;
 
+	if (timechart) {
+		attr->sample_type |= PERF_SAMPLE_CPU;
+		attr->sample_type |= PERF_SAMPLE_TIME;
+		attr->sample_type |= PERF_SAMPLE_RAW;
+	}
+
 	if (freq) {
 		attr->sample_type	|= PERF_SAMPLE_PERIOD;
 		attr->freq		= 1;
@@ -637,6 +644,24 @@ static int __cmd_record(int argc, const char **argv)
 	return 0;
 }
 
+static int do_timechart(const struct option *opt __used, const char *str __used, int unset __used)
+{
+	parse_events(NULL, "power:power_start", 0);
+	parse_events(NULL, "power:power_end", 0);
+	parse_events(NULL, "power:power_frequency", 0);
+	parse_events(NULL, "sched:sched_wakeup", 0);
+	parse_events(NULL, "sched:sched_switch", 0);
+	default_interval = 1;
+	system_wide = 1;
+	timechart = 1;
+	if (!nr_counters) {
+		printf("No counters found.. is debugfs mounted?\n");
+		exit(0);
+	}
+	return 0;
+}
+
+
 static const char * const record_usage[] = {
 	"perf record [<options>] [<command>]",
 	"perf record [<options>] -- <command> [<options>]",
@@ -681,6 +706,9 @@ static const struct option options[] = {
 		    "Sample addresses"),
 	OPT_BOOLEAN('n', "no-samples", &no_samples,
 		    "don't sample"),
+	OPT_CALLBACK_NOOPT('t', "timechart", NULL, NULL,
+		     "create a timechart recording",
+		     do_timechart),
 	OPT_END()
 };
 
-- 
1.6.0.6




-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
