Return-Path: <linux-kernel-owner+w=401wt.eu-S1756111AbZF1Nnk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756111AbZF1Nnk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Jun 2009 09:43:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752665AbZF1Nnc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Jun 2009 09:43:32 -0400
Received: from hera.kernel.org ([140.211.167.34]:43267 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751595AbZF1Nnb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Jun 2009 09:43:31 -0400
Date: Sun, 28 Jun 2009 13:42:56 GMT
From: tip-bot for Jaswinder Singh Rajput <jaswinder@kernel.org>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       peterz@infradead.org, jaswinder@kernel.org, jaswinderrajput@gmail.com,
       tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       jaswinder@kernel.org, peterz@infradead.org, jaswinderrajput@gmail.com,
       tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1246126749.32198.16.camel@hpdv5.satnam>
References: <1246126749.32198.16.camel@hpdv5.satnam>
Subject: [tip:perfcounters/urgent] perf stat: Micro-optimize the code: memcpy is only required if no event is selected and !null_run
Message-ID: <tip-c3043569dc8fbe9228b76174f15d1a7152c48a20@git.kernel.org>
Git-Commit-ID: c3043569dc8fbe9228b76174f15d1a7152c48a20
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Sun, 28 Jun 2009 13:42:57 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  c3043569dc8fbe9228b76174f15d1a7152c48a20
Gitweb:     http://git.kernel.org/tip/c3043569dc8fbe9228b76174f15d1a7152c48a20
Author:     Jaswinder Singh Rajput <jaswinder@kernel.org>
AuthorDate: Sat, 27 Jun 2009 23:49:09 +0530
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sun, 28 Jun 2009 15:22:47 +0200

perf stat: Micro-optimize the code: memcpy is only required if no event is selected and !null_run

Set attrs and nr_counters if no event is selected and !null_run.

Setting of attrs should depend on number of counters,
so we need to memcpy only for sizeof(default_attrs)

Also set nr_counters as ARRAY_SIZE(default_attrs) in place of
hardcoded value.

Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
LKML-Reference: <1246126749.32198.16.camel@hpdv5.satnam>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


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
