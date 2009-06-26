Return-Path: <linux-kernel-owner+w=401wt.eu-S1760739AbZFZVmh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760739AbZFZVmh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jun 2009 17:42:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756185AbZFZVm3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jun 2009 17:42:29 -0400
Received: from hera.kernel.org ([140.211.167.34]:46716 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753113AbZFZVm2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jun 2009 17:42:28 -0400
Subject: [GIT PULL -tip][PATCH 0/3 -tip] perf stat patches
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Sat, 27 Jun 2009 03:00:52 +0530
Message-Id: <1246051852.2988.8.camel@hpdv5.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo,

These patch set :

fixes perf stat output to handle big names like 'L1-d$-prefetch-misses'

Add support for HARDWARE, SOFTWARE and cache events :
 perf stat -e all-sw-events
 perf stat -e sw-events
 perf stat -e all-hw-events
 perf stat -e hw-events
 perf stat -e all-cache-events 
 perf stat -e cache-events

The following changes since commit 18fee47ce1ce511b088ddf65f4e5eb700a9f297a:
  Ingo Molnar (1):
        Merge branch 'perfcounters/urgent'

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jaswinder/linux-2.6-tip.git master

Jaswinder Singh Rajput (3):
      perf stat: fix stat output
      perf_counter tools: Add support to set of multiple events in one shot
      perf_counter tools: Add support for all CACHE events

 tools/perf/builtin-stat.c      |   11 ++--
 tools/perf/util/parse-events.c |  129 +++++++++++++++++++++++++++++++++++++++-
 2 files changed, 132 insertions(+), 8 deletions(-)

Complete diff :

diff --git a/tools/perf/builtin-stat.c b/tools/perf/builtin-stat.c
index 8420ec5..9ff9dd5 100644
--- a/tools/perf/builtin-stat.c
+++ b/tools/perf/builtin-stat.c
@@ -32,6 +32,7 @@
  *   Wu Fengguang <fengguang.wu@intel.com>
  *   Mike Galbraith <efault@gmx.de>
  *   Paul Mackerras <paulus@samba.org>
+ *   Jaswinder Singh Rajput <jaswinder@kernel.org>
  *
  * Released under the GPL v2. (and only v2, not any later version)
  */
@@ -250,7 +251,7 @@ static void nsec_printout(int counter, u64 *count, u64 *noise)
 {
 	double msecs = (double)count[0] / 1000000;
 
-	fprintf(stderr, " %14.6f  %-20s", msecs, event_name(counter));
+	fprintf(stderr, " %14.6f  %-24s", msecs, event_name(counter));
 
 	if (attrs[counter].type == PERF_TYPE_SOFTWARE &&
 		attrs[counter].config == PERF_COUNT_SW_TASK_CLOCK) {
@@ -264,7 +265,7 @@ static void nsec_printout(int counter, u64 *count, u64 *noise)
 
 static void abs_printout(int counter, u64 *count, u64 *noise)
 {
-	fprintf(stderr, " %14Ld  %-20s", count[0], event_name(counter));
+	fprintf(stderr, " %14Ld  %-24s", count[0], event_name(counter));
 
 	if (runtime_cycles_avg &&
 		attrs[counter].type == PERF_TYPE_HARDWARE &&
@@ -294,7 +295,7 @@ static void print_counter(int counter)
 	scaled = event_scaled_avg[counter];
 
 	if (scaled == -1) {
-		fprintf(stderr, " %14s  %-20s\n",
+		fprintf(stderr, " %14s  %-24s\n",
 			"<not counted>", event_name(counter));
 		return;
 	}
@@ -305,8 +306,7 @@ static void print_counter(int counter)
 		abs_printout(counter, count, noise);
 
 	if (scaled)
-		fprintf(stderr, "  (scaled from %.2f%%)",
-			(double) count[2] / count[1] * 100);
+		fprintf(stderr, "  (%7.2fx scaled)", (double)count[1]/count[2]);
 
 	fprintf(stderr, "\n");
 }
@@ -417,7 +417,6 @@ static void print_stat(int argc, const char **argv)
 	for (counter = 0; counter < nr_counters; counter++)
 		print_counter(counter);
 
-
 	fprintf(stderr, "\n");
 	fprintf(stderr, " %14.9f  seconds time elapsed.\n",
 			(double)walltime_nsecs_avg/1e9);
diff --git a/tools/perf/util/parse-events.c b/tools/perf/util/parse-events.c
index 4d042f1..331b296 100644
--- a/tools/perf/util/parse-events.c
+++ b/tools/perf/util/parse-events.c
@@ -40,6 +40,68 @@ static struct event_symbol event_symbols[] = {
   { CSW(CPU_MIGRATIONS),	"cpu-migrations",	"migrations"	},
 };
 
+struct event_type_symbol {
+	char	*symbol;
+	char	*alias;
+};
+
+static struct event_type_symbol event_type_symbols[] = {
+ [PERF_TYPE_HARDWARE]	= { "hw-events",	"all-hw-events",	},
+ [PERF_TYPE_SOFTWARE]	= { "sw-events",	"all-sw-events",	},
+ [PERF_TYPE_TRACEPOINT]	= { "",			"",			},
+ [PERF_TYPE_HW_CACHE]	= { "cache-events",	"all-cache-events",	},
+ [PERF_TYPE_RAW]	= { "",			"",			},
+};
+
+struct event_cache_symbol {
+	u8      type;
+	u64     config;
+};
+
+#define CHCACHE(x, y, z)						\
+.type = PERF_TYPE_HW_CACHE,						\
+.config = (PERF_COUNT_HW_CACHE_##x | (PERF_COUNT_HW_CACHE_OP_##y << 8) |\
+	   (PERF_COUNT_HW_CACHE_RESULT_##z << 16))
+
+/*
+ * Generalized Hardware cache counters events
+ * L1I is READ and PREFETCH only
+ * ITLB and BPU is READ only
+ */
+static struct event_cache_symbol event_cache_symbols[] = {
+  { CHCACHE(L1D,	READ,		ACCESS)		},
+  { CHCACHE(L1D,	READ,		MISS)		},
+  { CHCACHE(L1D,	WRITE,		ACCESS)		},
+  { CHCACHE(L1D,	WRITE,		MISS)		},
+  { CHCACHE(L1D,	PREFETCH,	ACCESS)		},
+  { CHCACHE(L1D,	PREFETCH,	MISS)		},
+
+  { CHCACHE(L1I,	READ,		ACCESS)		},
+  { CHCACHE(L1I,	READ,		MISS)		},
+  { CHCACHE(L1D,	PREFETCH,	ACCESS)		},
+  { CHCACHE(L1D,	PREFETCH,	MISS)		},
+
+  { CHCACHE(LL,		READ,		ACCESS)		},
+  { CHCACHE(LL,		READ,		MISS)		},
+  { CHCACHE(LL,		WRITE,		ACCESS)		},
+  { CHCACHE(LL,		WRITE,		MISS)		},
+  { CHCACHE(LL,		PREFETCH,	ACCESS)		},
+  { CHCACHE(LL,		PREFETCH,	MISS)		},
+
+  { CHCACHE(DTLB,	READ,		ACCESS)		},
+  { CHCACHE(DTLB,	READ,		MISS)		},
+  { CHCACHE(DTLB,	WRITE,		ACCESS)		},
+  { CHCACHE(DTLB,	WRITE,		MISS)		},
+  { CHCACHE(DTLB,	PREFETCH,	ACCESS)		},
+  { CHCACHE(DTLB,	PREFETCH,	MISS)		},
+
+  { CHCACHE(ITLB,	READ,		ACCESS)		},
+  { CHCACHE(ITLB,	READ,		MISS)		},
+
+  { CHCACHE(BPU,	READ,		ACCESS)		},
+  { CHCACHE(BPU,	READ,		MISS)		},
+};
+
 #define __PERF_COUNTER_FIELD(config, name) \
 	((config & PERF_COUNTER_##name##_MASK) >> PERF_COUNTER_##name##_SHIFT)
 
@@ -237,6 +299,60 @@ parse_generic_hw_symbols(const char *str, struct perf_counter_attr *attr)
 	return 0;
 }
 
+static int set_multiple_events(unsigned int type)
+{
+	struct perf_counter_attr attr;
+	int i;
+
+	switch (type) {
+	case PERF_TYPE_HARDWARE:
+	case PERF_TYPE_SOFTWARE:
+		for (i = 0; i < ARRAY_SIZE(event_symbols); i++) {
+			if (event_symbols[i].type == type) {
+				memset(&attr, 0, sizeof(attr));
+				attr.type = event_symbols[i].type;
+				attr.config = event_symbols[i].config;
+				attrs[nr_counters] = attr;
+				nr_counters++;
+			}
+		}
+		break;
+
+	case PERF_TYPE_HW_CACHE:
+		for (i = 0; i < ARRAY_SIZE(event_cache_symbols); i++) {
+			memset(&attr, 0, sizeof(attr));
+			attr.type = event_cache_symbols[i].type;
+			attr.config = event_cache_symbols[i].config;
+			attrs[nr_counters] = attr;
+			nr_counters++;
+		}
+		break;
+
+	default:
+		return -1;
+	}
+
+	/*
+	 * parse_events() is assuming that only single event will be set,
+	 * but we are setting multiple events so we need to return magical 1
+	 */
+	return 1;
+}
+
+static int check_type_events(const char *str, unsigned int i)
+{
+	if (strlen(event_type_symbols[i].symbol))
+		if (!strncmp(str, event_type_symbols[i].symbol,
+		     strlen(event_type_symbols[i].symbol)))
+			return 1;
+
+	if (strlen(event_type_symbols[i].alias))
+		if (!strncmp(str, event_type_symbols[i].alias,
+			     strlen(event_type_symbols[i].alias)))
+			return 1;
+	return 0;
+}
+
 static int check_events(const char *str, unsigned int i)
 {
 	if (!strncmp(str, event_symbols[i].symbol,
@@ -288,6 +404,12 @@ static int parse_event_symbols(const char *str, struct perf_counter_attr *attr)
 		return 0;
 	}
 
+	for (i = 0; i < ARRAY_SIZE(event_type_symbols); i++) {
+		if (check_type_events(str, i)) {
+			return set_multiple_events(i);
+		}
+	}
+
 	for (i = 0; i < ARRAY_SIZE(event_symbols); i++) {
 		if (check_events(str, i)) {
 			attr->type = event_symbols[i].type;
@@ -314,8 +436,11 @@ again:
 	if (ret < 0)
 		return ret;
 
-	attrs[nr_counters] = attr;
-	nr_counters++;
+	/* No need to set attrs and increment counter when already set */
+	if (ret == 0) {
+		attrs[nr_counters] = attr;
+		nr_counters++;
+	}
 
 	str = strstr(str, ",");
 	if (str) {


