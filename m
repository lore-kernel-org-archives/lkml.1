Return-Path: <linux-kernel-owner+w=401wt.eu-S1755469AbZGAJs3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755469AbZGAJs3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jul 2009 05:48:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754189AbZGAJsV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Jul 2009 05:48:21 -0400
Received: from hera.kernel.org ([140.211.167.34]:52599 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752902AbZGAJsU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jul 2009 05:48:20 -0400
Subject: [PATCH 3/6 -tip] perf_counter: Add Generalized Hardware vectored
 co-processor support for AMD
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>, x86 maintainers <x86@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
In-Reply-To: <1246440977.3403.7.camel@hpdv5.satnam>
References: <1246440815.3403.3.camel@hpdv5.satnam>
	 <1246440909.3403.5.camel@hpdv5.satnam>
	 <1246440977.3403.7.camel@hpdv5.satnam>
Content-Type: text/plain
Date: Wed, 01 Jul 2009 15:07:23 +0530
Message-Id: <1246441043.3403.9.camel@hpdv5.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


$ ./perf stat -e add -e multiply -e divide -e vec-idle-cycles -e vec-stall-cycles -e vec-ops -- ls -lR /usr/include/ > /dev/null

 Performance counter stats for 'ls -lR /usr/include/':

           4218  vec-adds                  (scaled from 66.60%)
           7426  vec-muls                  (scaled from 66.67%)
           5441  vec-divs                  (scaled from 66.29%)
      821982187  vec-idle-cycles           (scaled from 66.45%)
           2681  vec-stall-cycles          (scaled from 67.11%)
           7887  vec-ops                   (scaled from 66.88%)

    0.417614573  seconds time elapsed

$ ./perf stat -e add -e multiply -e divide -e vec-idle-cycles -e vec-stall-cycles -e vec-ops -- /usr/bin/rhythmbox ~jaswinder/Music/singhiskinng.mp3

 Performance counter stats for '/usr/bin/rhythmbox /home/jaswinder/Music/singhiskinng.mp3':

       17552264  vec-adds                  (scaled from 66.28%)
       19715258  vec-muls                  (scaled from 66.63%)
       15862733  vec-divs                  (scaled from 66.82%)
    23735187095  vec-idle-cycles           (scaled from 66.89%)
       11353159  vec-stall-cycles          (scaled from 66.90%)
       36628571  vec-ops                   (scaled from 66.48%)

  298.350012843  seconds time elapsed

$ ./perf stat -e add -e multiply -e divide -e vec-idle-cycles -e vec-stall-cycles -e vec-ops -- /usr/bin/vlc ~jaswinder/Videos/Linus_Torvalds_interview_with_Charlie_Rose_Part_1.flv

 Performance counter stats for '/usr/bin/vlc /home/jaswinder/Videos/Linus_Torvalds_interview_with_Charlie_Rose_Part_1.flv':

    20177177044  vec-adds                  (scaled from 66.63%)
    34101687027  vec-muls                  (scaled from 66.64%)
     3984060862  vec-divs                  (scaled from 66.71%)
    26349684710  vec-idle-cycles           (scaled from 66.65%)
     9052001905  vec-stall-cycles          (scaled from 66.66%)
    76440734242  vec-ops                   (scaled from 66.71%)

  272.523058097  seconds time elapsed

Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
---
 arch/x86/kernel/cpu/perf_counter.c |   33 +++++++++++++++++++++++++++++++
 include/linux/perf_counter.h       |   15 ++++++++++++++
 kernel/perf_counter.c              |    1 +
 tools/perf/util/parse-events.c     |   38 ++++++++++++++++++++++++++++++++++++
 4 files changed, 87 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_counter.c b/arch/x86/kernel/cpu/perf_counter.c
index d4cf4ce..8092200 100644
--- a/arch/x86/kernel/cpu/perf_counter.c
+++ b/arch/x86/kernel/cpu/perf_counter.c
@@ -372,6 +372,12 @@ static const u64 atom_hw_cache_event_ids
  },
 };
 
+/*
+ * Generalized hw vectored co-processor event table
+ */
+
+static u64 __read_mostly hw_vector_event_ids[PERF_COUNT_HW_VECTOR_MAX];
+
 static u64 intel_pmu_raw_event(u64 event)
 {
 #define CORE_EVNTSEL_EVENT_MASK		0x000000FFULL
@@ -481,6 +487,17 @@ static const u64 amd_hw_cache_event_ids
  },
 };
 
+static const u64 amd_hw_vector_event_ids[] =
+{
+  [PERF_COUNT_HW_VECTOR_ADD]		= 0x0100, /* Dispatched FPU Add	     */
+  [PERF_COUNT_HW_VECTOR_MULTIPLY]	= 0x0200, /* Dispatched FPU Multiply */
+  [PERF_COUNT_HW_VECTOR_DIVIDE]		= 0x0400, /* Dispatched FPU Store    */
+  [PERF_COUNT_HW_VECTOR_IDLE_CYCLES]	= 0x0001, /* FPU Empty cycles        */
+  [PERF_COUNT_HW_VECTOR_STALL_CYCLES]	= 0x00D7, /* Dispatch stall for FPU  */
+  [PERF_COUNT_HW_VECTOR_OPS]		= 0x0FCB, /* Retired x87|(MMX & 3Dnow)
+						   |SSE & SSE2) Instructions */
+};
+
 /*
  * AMD Performance Monitor K7 and later.
  */
@@ -659,6 +676,17 @@ set_ext_hw_attr(struct hw_perf_counter *hwc, struct perf_counter_attr *attr)
 	return 0;
 }
 
+static inline int
+set_hw_vector_attr(struct hw_perf_counter *hwc, struct perf_counter_attr *attr)
+{
+	if (attr->config >= PERF_COUNT_HW_VECTOR_MAX)
+		return -EINVAL;
+
+	hwc->config |= hw_vector_event_ids[attr->config];
+
+	return 0;
+}
+
 /*
  * Setup the hardware configuration for a given attr_type
  */
@@ -716,6 +744,9 @@ static int __hw_perf_counter_init(struct perf_counter *counter)
 	if (attr->type == PERF_TYPE_HW_CACHE)
 		return set_ext_hw_attr(hwc, attr);
 
+	if (attr->type == PERF_TYPE_HW_VECTOR)
+		return set_hw_vector_attr(hwc, attr);
+
 	if (attr->config >= x86_pmu.max_events)
 		return -EINVAL;
 	/*
@@ -1468,6 +1499,8 @@ static int amd_pmu_init(void)
 	/* Events are common for all AMDs */
 	memcpy(hw_cache_event_ids, amd_hw_cache_event_ids,
 	       sizeof(hw_cache_event_ids));
+	memcpy(hw_vector_event_ids, amd_hw_vector_event_ids,
+	       sizeof(hw_vector_event_ids));
 
 	return 0;
 }
diff --git a/include/linux/perf_counter.h b/include/linux/perf_counter.h
index 5e970c7..e91b712 100644
--- a/include/linux/perf_counter.h
+++ b/include/linux/perf_counter.h
@@ -31,6 +31,7 @@ enum perf_type_id {
 	PERF_TYPE_TRACEPOINT			= 2,
 	PERF_TYPE_HW_CACHE			= 3,
 	PERF_TYPE_RAW				= 4,
+	PERF_TYPE_HW_VECTOR			= 5,
 
 	PERF_TYPE_MAX,				/* non-ABI */
 };
@@ -89,6 +90,20 @@ enum perf_hw_cache_op_result_id {
 };
 
 /*
+ * Generalized hardware vectored co-processor counters:
+ */
+enum perf_hw_vector_id {
+	PERF_COUNT_HW_VECTOR_ADD		= 0,
+	PERF_COUNT_HW_VECTOR_MULTIPLY		= 1,
+	PERF_COUNT_HW_VECTOR_DIVIDE		= 2,
+	PERF_COUNT_HW_VECTOR_IDLE_CYCLES	= 3,
+	PERF_COUNT_HW_VECTOR_STALL_CYCLES	= 4,
+	PERF_COUNT_HW_VECTOR_OPS		= 5,
+
+	PERF_COUNT_HW_VECTOR_MAX,		/* non-ABI */
+};
+
+/*
  * Special "software" counters provided by the kernel, even if the hardware
  * does not support performance counters. These counters measure various
  * physical and sw events of the kernel (and allow the profiling of them as
diff --git a/kernel/perf_counter.c b/kernel/perf_counter.c
index d55a50d..dd3848a 100644
--- a/kernel/perf_counter.c
+++ b/kernel/perf_counter.c
@@ -3838,6 +3838,7 @@ perf_counter_alloc(struct perf_counter_attr *attr,
 	case PERF_TYPE_RAW:
 	case PERF_TYPE_HARDWARE:
 	case PERF_TYPE_HW_CACHE:
+	case PERF_TYPE_HW_VECTOR:
 		pmu = hw_perf_counter_init(counter);
 		break;
 
diff --git a/tools/perf/util/parse-events.c b/tools/perf/util/parse-events.c
index 4d042f1..5e5d17e 100644
--- a/tools/perf/util/parse-events.c
+++ b/tools/perf/util/parse-events.c
@@ -40,6 +40,17 @@ static struct event_symbol event_symbols[] = {
   { CSW(CPU_MIGRATIONS),	"cpu-migrations",	"migrations"	},
 };
 
+#define CHVECTOR(x) .type = PERF_TYPE_HW_VECTOR, .config = PERF_COUNT_HW_VECTOR_##x
+
+static struct event_symbol vector_event_symbols[] = {
+  { CHVECTOR(ADD),		"vec-adds",		"add"		},
+  { CHVECTOR(MULTIPLY),		"vec-muls",		"multiply"	},
+  { CHVECTOR(DIVIDE),		"vec-divs",		"divide"	},
+  { CHVECTOR(IDLE_CYCLES),	"vec-idle-cycles",	"vec-empty-cycles"},
+  { CHVECTOR(STALL_CYCLES),	"vec-stall-cycles",	"vec-busy-cycles"},
+  { CHVECTOR(OPS),		"vec-ops",		"vec-operations"},
+};
+
 #define __PERF_COUNTER_FIELD(config, name) \
 	((config & PERF_COUNTER_##name##_MASK) >> PERF_COUNTER_##name##_SHIFT)
 
@@ -172,6 +183,11 @@ char *event_name(int counter)
 		return event_cache_name(cache_type, cache_op, cache_result);
 	}
 
+	case PERF_TYPE_HW_VECTOR:
+		if (config < PERF_COUNT_HW_VECTOR_MAX)
+			return vector_event_symbols[config].symbol;
+		return "unknown-vector";
+
 	case PERF_TYPE_SOFTWARE:
 		if (config < PERF_COUNT_SW_MAX)
 			return sw_event_names[config];
@@ -250,6 +266,19 @@ static int check_events(const char *str, unsigned int i)
 	return 0;
 }
 
+static int check_vector_events(const char *str, unsigned int i)
+{
+	if (!strncmp(str, vector_event_symbols[i].symbol,
+		     strlen(vector_event_symbols[i].symbol)))
+		return 1;
+
+	if (strlen(vector_event_symbols[i].alias))
+		if (!strncmp(str, vector_event_symbols[i].alias,
+			     strlen(vector_event_symbols[i].alias)))
+			return 1;
+	return 0;
+}
+
 /*
  * Each event can have multiple symbolic names.
  * Symbolic names are (almost) exactly matched.
@@ -297,6 +326,15 @@ static int parse_event_symbols(const char *str, struct perf_counter_attr *attr)
 		}
 	}
 
+	for (i = 0; i < ARRAY_SIZE(vector_event_symbols); i++) {
+		if (check_vector_events(str, i)) {
+			attr->type = vector_event_symbols[i].type;
+			attr->config = vector_event_symbols[i].config;
+
+			return 0;
+		}
+	}
+
 	return parse_generic_hw_symbols(str, attr);
 }
 
-- 
1.6.0.6



