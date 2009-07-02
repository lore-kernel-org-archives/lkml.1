Return-Path: <linux-kernel-owner+w=401wt.eu-S1755394AbZGBJpp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755394AbZGBJpp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jul 2009 05:45:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751183AbZGBJpi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Jul 2009 05:45:38 -0400
Received: from hera.kernel.org ([140.211.167.34]:49198 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751059AbZGBJpg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jul 2009 05:45:36 -0400
Subject: [PATCH 1/2 -tip] perf_counter: Add generalized hardware vectored
 co-processor support for AMD and Intel Corei7/Nehalem
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Arjan van de Ven <arjan@infradead.org>, Paul Mackerras <paulus@samba.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Anton Blanchard <anton@samba.org>, Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>, x86 maintainers <x86@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
In-Reply-To: <20090701114928.GI15958@elte.hu>
References: <1246440815.3403.3.camel@hpdv5.satnam>
	 <1246440909.3403.5.camel@hpdv5.satnam>
	 <1246440977.3403.7.camel@hpdv5.satnam>
	 <1246441043.3403.9.camel@hpdv5.satnam> <20090701112007.GD15958@elte.hu>
	 <20090701112704.GF15958@elte.hu> <1246448441.6940.3.camel@hpdv5.satnam>
	 <20090701114928.GI15958@elte.hu>
Content-Type: text/plain
Date: Thu, 02 Jul 2009 15:14:32 +0530
Message-Id: <1246527872.13659.2.camel@hpdv5.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This output is from AMD box:

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

$ ./perf list shows vector events like :

  vec-adds OR add                          [Hardware vector event]
  vec-muls OR multiply                     [Hardware vector event]
  vec-divs OR divide                       [Hardware vector event]
  vec-idle-cycles OR vec-empty-cycles      [Hardware vector event]
  vec-stall-cycles OR vec-busy-cycles      [Hardware vector event]
  vec-ops OR vec-operations                [Hardware vector event]

Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
---
 arch/x86/kernel/cpu/perf_counter.c |   45 +++++++++++++++++++++++++++++
 include/linux/perf_counter.h       |   15 ++++++++++
 kernel/perf_counter.c              |    1 +
 tools/perf/util/parse-events.c     |   55 ++++++++++++++++++++++++++++++++++++
 4 files changed, 116 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_counter.c b/arch/x86/kernel/cpu/perf_counter.c
index 36c3dc7..48f28b7 100644
--- a/arch/x86/kernel/cpu/perf_counter.c
+++ b/arch/x86/kernel/cpu/perf_counter.c
@@ -372,6 +372,22 @@ static const u64 atom_hw_cache_event_ids
  },
 };
 
+/*
+ * Generalized hw vectored co-processor event table
+ */
+
+static u64 __read_mostly hw_vector_event_ids[PERF_COUNT_HW_VECTOR_MAX];
+
+static const u64 nehalem_hw_vector_event_ids[] =
+{
+  [PERF_COUNT_HW_VECTOR_ADD]		= 0x01B1, /* UOPS_EXECUTED.PORT0     */
+  [PERF_COUNT_HW_VECTOR_MULTIPLY]	= 0x0214, /* ARITH.MUL               */
+  [PERF_COUNT_HW_VECTOR_DIVIDE]		= 0x0114, /* ARITH.CYCLES_DIV_BUSY   */
+  [PERF_COUNT_HW_VECTOR_IDLE_CYCLES]	= 0x0,
+  [PERF_COUNT_HW_VECTOR_STALL_CYCLES]	= 0x60A2, /* RESOURCE_STALLS.FPCW|MXCSR*/
+  [PERF_COUNT_HW_VECTOR_OPS]		= 0x0710, /* FP_COMP_OPS_EXE.X87|MMX|SSE_FP*/
+};
+
 static u64 intel_pmu_raw_event(u64 event)
 {
 #define CORE_EVNTSEL_EVENT_MASK		0x000000FFULL
@@ -481,6 +497,17 @@ static const u64 amd_hw_cache_event_ids
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
@@ -659,6 +686,17 @@ set_ext_hw_attr(struct hw_perf_counter *hwc, struct perf_counter_attr *attr)
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
@@ -716,6 +754,9 @@ static int __hw_perf_counter_init(struct perf_counter *counter)
 	if (attr->type == PERF_TYPE_HW_CACHE)
 		return set_ext_hw_attr(hwc, attr);
 
+	if (attr->type == PERF_TYPE_HW_VECTOR)
+		return set_hw_vector_attr(hwc, attr);
+
 	if (attr->config >= x86_pmu.max_events)
 		return -EINVAL;
 	/*
@@ -1444,6 +1485,8 @@ static int intel_pmu_init(void)
 	case 26:
 		memcpy(hw_cache_event_ids, nehalem_hw_cache_event_ids,
 		       sizeof(hw_cache_event_ids));
+		memcpy(hw_vector_event_ids, nehalem_hw_vector_event_ids,
+		       sizeof(hw_vector_event_ids));
 
 		pr_cont("Nehalem/Corei7 events, ");
 		break;
@@ -1468,6 +1511,8 @@ static int amd_pmu_init(void)
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
index 5184959..8213dfb 100644
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
@@ -280,6 +296,21 @@ static int check_events(const char *str, unsigned int i)
 	return 0;
 }
 
+static int check_vector_events(const char *str, unsigned int i)
+{
+	int n;
+
+	n = strlen(vector_event_symbols[i].symbol);
+	if (!strncmp(str, vector_event_symbols[i].symbol, n))
+		return n;
+
+	n = strlen(vector_event_symbols[i].alias);
+	if (n)
+		if (!strncmp(str, vector_event_symbols[i].alias, n))
+			return n;
+	return 0;
+}
+
 static int
 parse_symbolic_event(const char **strp, struct perf_counter_attr *attr)
 {
@@ -296,6 +327,17 @@ parse_symbolic_event(const char **strp, struct perf_counter_attr *attr)
 			return 1;
 		}
 	}
+
+	for (i = 0; i < ARRAY_SIZE(vector_event_symbols); i++) {
+		n = check_vector_events(str, i);
+		if (n > 0) {
+			attr->type = vector_event_symbols[i].type;
+			attr->config = vector_event_symbols[i].config;
+			*strp = str + n;
+			return 1;
+		}
+	}
+
 	return 0;
 }
 
@@ -420,6 +462,7 @@ static const char * const event_type_descriptors[] = {
 	"Software event",
 	"Tracepoint event",
 	"Hardware cache event",
+	"Hardware vector event",
 };
 
 /*
@@ -468,6 +511,18 @@ void print_events(void)
 	}
 
 	fprintf(stderr, "\n");
+	syms = vector_event_symbols;
+	type = syms->type;
+	for (i = 0; i < ARRAY_SIZE(vector_event_symbols); i++, syms++) {
+		if (strlen(syms->alias))
+			sprintf(name, "%s OR %s", syms->symbol, syms->alias);
+		else
+			strcpy(name, syms->symbol);
+		fprintf(stderr, "  %-40s [%s]\n", name,
+			event_type_descriptors[type]);
+	}
+
+	fprintf(stderr, "\n");
 	fprintf(stderr, "  %-40s [raw hardware event descriptor]\n",
 		"rNNN");
 	fprintf(stderr, "\n");
-- 
1.6.0.6



