Return-Path: <linux-kernel-owner+w=401wt.eu-S1754448AbZFFLQv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754448AbZFFLQv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Jun 2009 07:16:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752860AbZFFLQn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 6 Jun 2009 07:16:43 -0400
Received: from hera.kernel.org ([140.211.167.34]:41362 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752555AbZFFLQl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Jun 2009 07:16:41 -0400
Date: Sat, 6 Jun 2009 11:16:03 GMT
From: tip-bot for Ingo Molnar <mingo@elte.hu>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, paulus@samba.org,
       hpa@zytor.com, mingo@redhat.com, a.p.zijlstra@chello.nl, efault@gmx.de,
       mtosatti@redhat.com, tglx@linutronix.de, cjashfor@linux.vnet.ibm.com,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org, acme@redhat.com,
       linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl, efault@gmx.de,
       mtosatti@redhat.com, tglx@linutronix.de, cjashfor@linux.vnet.ibm.com,
       mingo@elte.hu
In-Reply-To: <new-submission>
References: <new-submission>
Subject: [tip:perfcounters/core] perf_counter: Implement generalized cache event types
Message-ID: <tip-8326f44da090d6d304d29b9fdc7fb3e20889e329@git.kernel.org>
Git-Commit-ID: 8326f44da090d6d304d29b9fdc7fb3e20889e329
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Sat, 06 Jun 2009 11:16:05 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  8326f44da090d6d304d29b9fdc7fb3e20889e329
Gitweb:     http://git.kernel.org/tip/8326f44da090d6d304d29b9fdc7fb3e20889e329
Author:     Ingo Molnar <mingo@elte.hu>
AuthorDate: Fri, 5 Jun 2009 20:22:46 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sat, 6 Jun 2009 13:14:47 +0200

perf_counter: Implement generalized cache event types

Extend generic event enumeration with the PERF_TYPE_HW_CACHE
method.

This is a 3-dimensional space:

       { L1-D, L1-I, L2, ITLB, DTLB, BPU } x
       { load, store, prefetch } x
       { accesses, misses }

User-space passes in the 3 coordinates and the kernel provides
a counter. (if the hardware supports that type and if the
combination makes sense.)

Combinations that make no sense produce a -EINVAL.
Combinations that are not supported by the hardware produce -ENOTSUP.

Extend the tools to deal with this, and rewrite the event symbol
parsing code with various popular aliases for the units and
access methods above. So 'l1-cache-miss' and 'l1d-read-ops' are
both valid aliases.

( x86 is supported for now, with the Nehalem event table filled in,
  and with Core2 and Atom having placeholder tables. )

Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Marcelo Tosatti <mtosatti@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
LKML-Reference: <new-submission>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 Documentation/perf_counter/util/parse-events.c |  104 ++++++++++++-
 arch/x86/kernel/cpu/perf_counter.c             |  201 +++++++++++++++++++++++-
 include/linux/perf_counter.h                   |   34 ++++
 kernel/perf_counter.c                          |    1 +
 4 files changed, 329 insertions(+), 11 deletions(-)

diff --git a/Documentation/perf_counter/util/parse-events.c b/Documentation/perf_counter/util/parse-events.c
index eb56bd9..de9a77c 100644
--- a/Documentation/perf_counter/util/parse-events.c
+++ b/Documentation/perf_counter/util/parse-events.c
@@ -6,6 +6,8 @@
 #include "exec_cmd.h"
 #include "string.h"
 
+extern char *strcasestr(const char *haystack, const char *needle);
+
 int					nr_counters;
 
 struct perf_counter_attr		attrs[MAX_COUNTERS];
@@ -17,6 +19,7 @@ struct event_symbol {
 };
 
 #define C(x, y) .type = PERF_TYPE_##x, .config = PERF_COUNT_##y
+#define CR(x, y) .type = PERF_TYPE_##x, .config = y
 
 static struct event_symbol event_symbols[] = {
   { C(HARDWARE, CPU_CYCLES),		"cpu-cycles",		},
@@ -69,6 +72,28 @@ static char *sw_event_names[] = {
 	"major faults",
 };
 
+#define MAX_ALIASES 8
+
+static char *hw_cache [][MAX_ALIASES] = {
+	{ "l1-d" ,	"l1d" ,	"l1", "l1-data-cache"			},
+	{ "l1-i" ,	"l1i" ,	"l1-instruction-cache"		},
+	{ "l2"  , },
+	{ "dtlb", },
+	{ "itlb", },
+	{ "bpu" , "btb", "branch-cache", NULL },
+};
+
+static char *hw_cache_op [][MAX_ALIASES] = {
+	{ "read"	, "load" },
+	{ "write"	, "store" },
+	{ "prefetch"	, "speculative-read", "speculative-load" },
+};
+
+static char *hw_cache_result [][MAX_ALIASES] = {
+	{ "access", "ops" },
+	{ "miss", },
+};
+
 char *event_name(int counter)
 {
 	__u64 config = attrs[counter].config;
@@ -86,6 +111,30 @@ char *event_name(int counter)
 			return hw_event_names[config];
 		return "unknown-hardware";
 
+	case PERF_TYPE_HW_CACHE: {
+		__u8 cache_type, cache_op, cache_result;
+		static char name[100];
+
+		cache_type   = (config >>  0) & 0xff;
+		if (cache_type > PERF_COUNT_HW_CACHE_MAX)
+			return "unknown-ext-hardware-cache-type";
+
+		cache_op     = (config >>  8) & 0xff;
+		if (cache_type > PERF_COUNT_HW_CACHE_OP_MAX)
+			return "unknown-ext-hardware-cache-op-type";
+
+		cache_result = (config >> 16) & 0xff;
+		if (cache_type > PERF_COUNT_HW_CACHE_RESULT_MAX)
+			return "unknown-ext-hardware-cache-result-type";
+
+		sprintf(name, "%s:%s:%s",
+			hw_cache[cache_type][0],
+			hw_cache_op[cache_op][0],
+			hw_cache_result[cache_result][0]);
+
+		return name;
+	}
+
 	case PERF_TYPE_SOFTWARE:
 		if (config < PERF_SW_EVENTS_MAX)
 			return sw_event_names[config];
@@ -98,11 +147,60 @@ char *event_name(int counter)
 	return "unknown";
 }
 
+static int parse_aliases(const char *str, char *names[][MAX_ALIASES], int size)
+{
+	int i, j;
+
+	for (i = 0; i < size; i++) {
+		for (j = 0; j < MAX_ALIASES; j++) {
+			if (!names[i][j])
+				break;
+			if (strcasestr(str, names[i][j]))
+				return i;
+		}
+	}
+
+	return 0;
+}
+
+static int parse_generic_hw_symbols(const char *str, struct perf_counter_attr *attr)
+{
+	__u8 cache_type = -1, cache_op = 0, cache_result = 0;
+
+	cache_type = parse_aliases(str, hw_cache, PERF_COUNT_HW_CACHE_MAX);
+	/*
+	 * No fallback - if we cannot get a clear cache type
+	 * then bail out:
+	 */
+	if (cache_type == -1)
+		return -EINVAL;
+
+	cache_op = parse_aliases(str, hw_cache_op, PERF_COUNT_HW_CACHE_OP_MAX);
+	/*
+	 * Fall back to reads:
+	 */
+	if (cache_type == -1)
+		cache_type = PERF_COUNT_HW_CACHE_OP_READ;
+
+	cache_result = parse_aliases(str, hw_cache_result,
+					PERF_COUNT_HW_CACHE_RESULT_MAX);
+	/*
+	 * Fall back to accesses:
+	 */
+	if (cache_result == -1)
+		cache_result = PERF_COUNT_HW_CACHE_RESULT_ACCESS;
+
+	attr->config = cache_type | (cache_op << 8) | (cache_result << 16);
+	attr->type = PERF_TYPE_HW_CACHE;
+
+	return 0;
+}
+
 /*
  * Each event can have multiple symbolic names.
  * Symbolic names are (almost) exactly matched.
  */
-static int match_event_symbols(const char *str, struct perf_counter_attr *attr)
+static int parse_event_symbols(const char *str, struct perf_counter_attr *attr)
 {
 	__u64 config, id;
 	int type;
@@ -147,7 +245,7 @@ static int match_event_symbols(const char *str, struct perf_counter_attr *attr)
 		}
 	}
 
-	return -EINVAL;
+	return parse_generic_hw_symbols(str, attr);
 }
 
 int parse_events(const struct option *opt, const char *str, int unset)
@@ -160,7 +258,7 @@ again:
 	if (nr_counters == MAX_COUNTERS)
 		return -1;
 
-	ret = match_event_symbols(str, &attr);
+	ret = parse_event_symbols(str, &attr);
 	if (ret < 0)
 		return ret;
 
diff --git a/arch/x86/kernel/cpu/perf_counter.c b/arch/x86/kernel/cpu/perf_counter.c
index 430e048..e86679f 100644
--- a/arch/x86/kernel/cpu/perf_counter.c
+++ b/arch/x86/kernel/cpu/perf_counter.c
@@ -83,6 +83,128 @@ static u64 intel_pmu_event_map(int event)
 	return intel_perfmon_event_map[event];
 }
 
+/*
+ * Generalized hw caching related event table, filled
+ * in on a per model basis. A value of 0 means
+ * 'not supported', -1 means 'event makes no sense on
+ * this CPU', any other value means the raw event
+ * ID.
+ */
+
+#define C(x) PERF_COUNT_HW_CACHE_##x
+
+static u64 __read_mostly hw_cache_event_ids
+				[PERF_COUNT_HW_CACHE_MAX]
+				[PERF_COUNT_HW_CACHE_OP_MAX]
+				[PERF_COUNT_HW_CACHE_RESULT_MAX];
+
+static const u64 nehalem_hw_cache_event_ids
+				[PERF_COUNT_HW_CACHE_MAX]
+				[PERF_COUNT_HW_CACHE_OP_MAX]
+				[PERF_COUNT_HW_CACHE_RESULT_MAX] =
+{
+ [ C(L1D) ] = {
+	[ C(OP_READ) ] = {
+		[ C(RESULT_ACCESS) ] = 0x0f40, /* L1D_CACHE_LD.MESI            */
+		[ C(RESULT_MISS)   ] = 0x0140, /* L1D_CACHE_LD.I_STATE         */
+	},
+	[ C(OP_WRITE) ] = {
+		[ C(RESULT_ACCESS) ] = 0x0f41, /* L1D_CACHE_ST.MESI            */
+		[ C(RESULT_MISS)   ] = 0x0141, /* L1D_CACHE_ST.I_STATE         */
+	},
+	[ C(OP_PREFETCH) ] = {
+		[ C(RESULT_ACCESS) ] = 0x014e, /* L1D_PREFETCH.REQUESTS        */
+		[ C(RESULT_MISS)   ] = 0x024e, /* L1D_PREFETCH.MISS            */
+	},
+ },
+ [ C(L1I ) ] = {
+	[ C(OP_READ) ] = {
+		[ C(RESULT_ACCESS) ] = 0x0480, /* L1I.READS                    */
+		[ C(RESULT_MISS)   ] = 0x0280, /* L1I.MISSES                   */
+	},
+	[ C(OP_WRITE) ] = {
+		[ C(RESULT_ACCESS) ] = -1,
+		[ C(RESULT_MISS)   ] = -1,
+	},
+	[ C(OP_PREFETCH) ] = {
+		[ C(RESULT_ACCESS) ] = 0x0,
+		[ C(RESULT_MISS)   ] = 0x0,
+	},
+ },
+ [ C(L2  ) ] = {
+	[ C(OP_READ) ] = {
+		[ C(RESULT_ACCESS) ] = 0x0324, /* L2_RQSTS.LOADS               */
+		[ C(RESULT_MISS)   ] = 0x0224, /* L2_RQSTS.LD_MISS             */
+	},
+	[ C(OP_WRITE) ] = {
+		[ C(RESULT_ACCESS) ] = 0x0c24, /* L2_RQSTS.RFOS                */
+		[ C(RESULT_MISS)   ] = 0x0824, /* L2_RQSTS.RFO_MISS            */
+	},
+	[ C(OP_PREFETCH) ] = {
+		[ C(RESULT_ACCESS) ] = 0xc024, /* L2_RQSTS.PREFETCHES          */
+		[ C(RESULT_MISS)   ] = 0x8024, /* L2_RQSTS.PREFETCH_MISS       */
+	},
+ },
+ [ C(DTLB) ] = {
+	[ C(OP_READ) ] = {
+		[ C(RESULT_ACCESS) ] = 0x0f40, /* L1D_CACHE_LD.MESI   (alias)  */
+		[ C(RESULT_MISS)   ] = 0x0108, /* DTLB_LOAD_MISSES.ANY         */
+	},
+	[ C(OP_WRITE) ] = {
+		[ C(RESULT_ACCESS) ] = 0x0f41, /* L1D_CACHE_ST.MESI   (alias)  */
+		[ C(RESULT_MISS)   ] = 0x010c, /* MEM_STORE_RETIRED.DTLB_MISS  */
+	},
+	[ C(OP_PREFETCH) ] = {
+		[ C(RESULT_ACCESS) ] = 0x0,
+		[ C(RESULT_MISS)   ] = 0x0,
+	},
+ },
+ [ C(ITLB) ] = {
+	[ C(OP_READ) ] = {
+		[ C(RESULT_ACCESS) ] = 0x01c0, /* INST_RETIRED.ANY_P           */
+		[ C(RESULT_MISS)   ] = 0x0185, /* ITLB_MISS_RETIRED            */
+	},
+	[ C(OP_WRITE) ] = {
+		[ C(RESULT_ACCESS) ] = -1,
+		[ C(RESULT_MISS)   ] = -1,
+	},
+	[ C(OP_PREFETCH) ] = {
+		[ C(RESULT_ACCESS) ] = -1,
+		[ C(RESULT_MISS)   ] = -1,
+	},
+ },
+ [ C(BPU ) ] = {
+	[ C(OP_READ) ] = {
+		[ C(RESULT_ACCESS) ] = 0x00c4, /* BR_INST_RETIRED.ALL_BRANCHES */
+		[ C(RESULT_MISS)   ] = 0x03e8, /* BPU_CLEARS.ANY               */
+	},
+	[ C(OP_WRITE) ] = {
+		[ C(RESULT_ACCESS) ] = -1,
+		[ C(RESULT_MISS)   ] = -1,
+	},
+	[ C(OP_PREFETCH) ] = {
+		[ C(RESULT_ACCESS) ] = -1,
+		[ C(RESULT_MISS)   ] = -1,
+	},
+ },
+};
+
+static const u64 core2_hw_cache_event_ids
+				[PERF_COUNT_HW_CACHE_MAX]
+				[PERF_COUNT_HW_CACHE_OP_MAX]
+				[PERF_COUNT_HW_CACHE_RESULT_MAX] =
+{
+	/* To be filled in */
+};
+
+static const u64 atom_hw_cache_event_ids
+				[PERF_COUNT_HW_CACHE_MAX]
+				[PERF_COUNT_HW_CACHE_OP_MAX]
+				[PERF_COUNT_HW_CACHE_RESULT_MAX] =
+{
+	/* To be filled in */
+};
+
 static u64 intel_pmu_raw_event(u64 event)
 {
 #define CORE_EVNTSEL_EVENT_MASK		0x000000FFULL
@@ -246,6 +368,39 @@ static inline int x86_pmu_initialized(void)
 	return x86_pmu.handle_irq != NULL;
 }
 
+static inline int
+set_ext_hw_attr(struct hw_perf_counter *hwc, struct perf_counter_attr *attr)
+{
+	unsigned int cache_type, cache_op, cache_result;
+	u64 config, val;
+
+	config = attr->config;
+
+	cache_type = (config >>  0) & 0xff;
+	if (cache_type >= PERF_COUNT_HW_CACHE_MAX)
+		return -EINVAL;
+
+	cache_op = (config >>  8) & 0xff;
+	if (cache_op >= PERF_COUNT_HW_CACHE_OP_MAX)
+		return -EINVAL;
+
+	cache_result = (config >> 16) & 0xff;
+	if (cache_result >= PERF_COUNT_HW_CACHE_RESULT_MAX)
+		return -EINVAL;
+
+	val = hw_cache_event_ids[cache_type][cache_op][cache_result];
+
+	if (val == 0)
+		return -ENOENT;
+
+	if (val == -1)
+		return -EINVAL;
+
+	hwc->config |= val;
+
+	return 0;
+}
+
 /*
  * Setup the hardware configuration for a given attr_type
  */
@@ -288,22 +443,25 @@ static int __hw_perf_counter_init(struct perf_counter *counter)
 		hwc->sample_period = x86_pmu.max_period;
 
 	atomic64_set(&hwc->period_left, hwc->sample_period);
+	counter->destroy = hw_perf_counter_destroy;
 
 	/*
 	 * Raw event type provide the config in the event structure
 	 */
 	if (attr->type == PERF_TYPE_RAW) {
 		hwc->config |= x86_pmu.raw_event(attr->config);
-	} else {
-		if (attr->config >= x86_pmu.max_events)
-			return -EINVAL;
-		/*
-		 * The generic map:
-		 */
-		hwc->config |= x86_pmu.event_map(attr->config);
+		return 0;
 	}
 
-	counter->destroy = hw_perf_counter_destroy;
+	if (attr->type == PERF_TYPE_HW_CACHE)
+		return set_ext_hw_attr(hwc, attr);
+
+	if (attr->config >= x86_pmu.max_events)
+		return -EINVAL;
+	/*
+	 * The generic map:
+	 */
+	hwc->config |= x86_pmu.event_map(attr->config);
 
 	return 0;
 }
@@ -989,6 +1147,33 @@ static int intel_pmu_init(void)
 
 	rdmsrl(MSR_CORE_PERF_GLOBAL_CTRL, x86_pmu.intel_ctrl);
 
+	/*
+	 * Nehalem:
+	 */
+	switch (boot_cpu_data.x86_model) {
+	case 17:
+		memcpy(hw_cache_event_ids, core2_hw_cache_event_ids,
+		sizeof(u64)*PERF_COUNT_HW_CACHE_MAX*
+			PERF_COUNT_HW_CACHE_OP_MAX*PERF_COUNT_HW_CACHE_RESULT_MAX);
+
+		pr_info("... installed Core2 event tables\n");
+		break;
+	default:
+	case 26:
+		memcpy(hw_cache_event_ids, nehalem_hw_cache_event_ids,
+		sizeof(u64)*PERF_COUNT_HW_CACHE_MAX*
+			PERF_COUNT_HW_CACHE_OP_MAX*PERF_COUNT_HW_CACHE_RESULT_MAX);
+
+		pr_info("... installed Nehalem/Corei7 event tables\n");
+		break;
+	case 28:
+		memcpy(hw_cache_event_ids, atom_hw_cache_event_ids,
+		sizeof(u64)*PERF_COUNT_HW_CACHE_MAX*
+			PERF_COUNT_HW_CACHE_OP_MAX*PERF_COUNT_HW_CACHE_RESULT_MAX);
+
+		pr_info("... installed Atom event tables\n");
+		break;
+	}
 	return 0;
 }
 
diff --git a/include/linux/perf_counter.h b/include/linux/perf_counter.h
index f794c69..3586df8 100644
--- a/include/linux/perf_counter.h
+++ b/include/linux/perf_counter.h
@@ -28,6 +28,7 @@ enum perf_event_types {
 	PERF_TYPE_HARDWARE		= 0,
 	PERF_TYPE_SOFTWARE		= 1,
 	PERF_TYPE_TRACEPOINT		= 2,
+	PERF_TYPE_HW_CACHE		= 3,
 
 	/*
 	 * available TYPE space, raw is the max value.
@@ -56,6 +57,39 @@ enum attr_ids {
 };
 
 /*
+ * Generalized hardware cache counters:
+ *
+ *       { L1-D, L1-I, L2, LLC, ITLB, DTLB, BPU } x
+ *       { read, write, prefetch } x
+ *       { accesses, misses }
+ */
+enum hw_cache_id {
+	PERF_COUNT_HW_CACHE_L1D,
+	PERF_COUNT_HW_CACHE_L1I,
+	PERF_COUNT_HW_CACHE_L2,
+	PERF_COUNT_HW_CACHE_DTLB,
+	PERF_COUNT_HW_CACHE_ITLB,
+	PERF_COUNT_HW_CACHE_BPU,
+
+	PERF_COUNT_HW_CACHE_MAX,
+};
+
+enum hw_cache_op_id {
+	PERF_COUNT_HW_CACHE_OP_READ,
+	PERF_COUNT_HW_CACHE_OP_WRITE,
+	PERF_COUNT_HW_CACHE_OP_PREFETCH,
+
+	PERF_COUNT_HW_CACHE_OP_MAX,
+};
+
+enum hw_cache_op_result_id {
+	PERF_COUNT_HW_CACHE_RESULT_ACCESS,
+	PERF_COUNT_HW_CACHE_RESULT_MISS,
+
+	PERF_COUNT_HW_CACHE_RESULT_MAX,
+};
+
+/*
  * Special "software" counters provided by the kernel, even if the hardware
  * does not support performance counters. These counters measure various
  * physical and sw events of the kernel (and allow the profiling of them as
diff --git a/kernel/perf_counter.c b/kernel/perf_counter.c
index 75ae767..5eacaaf 100644
--- a/kernel/perf_counter.c
+++ b/kernel/perf_counter.c
@@ -3501,6 +3501,7 @@ perf_counter_alloc(struct perf_counter_attr *attr,
 
 	switch (attr->type) {
 	case PERF_TYPE_HARDWARE:
+	case PERF_TYPE_HW_CACHE:
 		pmu = hw_perf_counter_init(counter);
 		break;
 
