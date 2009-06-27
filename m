Return-Path: <linux-kernel-owner+w=401wt.eu-S1752043AbZF0ST4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752043AbZF0ST4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Jun 2009 14:19:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751299AbZF0STs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Jun 2009 14:19:48 -0400
Received: from hera.kernel.org ([140.211.167.34]:58453 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750720AbZF0STs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Jun 2009 14:19:48 -0400
Subject: [PATCH -tip] perf stat: memcpy is only required if no event is
 selected and !null_run
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Sat, 27 Jun 2009 23:49:09 +0530
Message-Id: <1246126749.32198.16.camel@hpdv5.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Set attrs and nr_counters if no event is selected and !null_run

Setting of attrs should depend on number of counters,
so we need to memcpy only for sizeof(default_attrs)

and set nr_counters as ARRAY_SIZE(default_attrs) in place of hardcoded value

Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
---
 tools/perf/builtin-stat.c |   11 ++++++-----
 1 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/tools/perf/builtin-stat.c b/tools/perf/builtin-stat.c
index 3840a70..3e5ea4e 100644
--- a/tools/perf/builtin-stat.c
+++ b/tools/perf/builtin-stat.c
@@ -46,7 +46,7 @@
 #include <sys/prctl.h>
 #include <math.h>
 
-static struct perf_counter_attr default_attrs[MAX_COUNTERS] = {
+static struct perf_counter_attr default_attrs[] = {
 
   { .type = PERF_TYPE_SOFTWARE, .config = PERF_COUNT_SW_TASK_CLOCK	},
   { .type = PERF_TYPE_SOFTWARE, .config = PERF_COUNT_SW_CONTEXT_SWITCHES},
@@ -477,16 +477,17 @@ int cmd_stat(int argc, const char **argv, const char *prefix)
 {
 	int status;
 
-	memcpy(attrs, default_attrs, sizeof(attrs));
-
 	argc = parse_options(argc, argv, options, stat_usage, 0);
 	if (!argc)
 		usage_with_options(stat_usage, options);
 	if (run_count <= 0 || run_count > MAX_RUN)
 		usage_with_options(stat_usage, options);
 
-	if (!null_run && !nr_counters)
-		nr_counters = 8;
+	/* Set attrs and nr_counters if no event is selected and !null_run */
+	if (!null_run && !nr_counters) {
+		memcpy(attrs, default_attrs, sizeof(default_attrs));
+		nr_counters = ARRAY_SIZE(default_attrs);
+	}
 
 	nr_cpus = sysconf(_SC_NPROCESSORS_ONLN);
 	assert(nr_cpus <= MAX_NR_CPUS);
-- 
1.6.0.6



