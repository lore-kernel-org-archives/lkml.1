Return-Path: <linux-kernel-owner+w=401wt.eu-S1758541AbZF2JeX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758541AbZF2JeX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jun 2009 05:34:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756397AbZF2Jd4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jun 2009 05:33:56 -0400
Received: from hera.kernel.org ([140.211.167.34]:44023 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758427AbZF2Jdx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jun 2009 05:33:53 -0400
Subject: [PATCH -tip] perf_counter: Add Generalized Hardware FPU support
 for AMD
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>, x86 maintainers <x86@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Mon, 29 Jun 2009 15:03:05 +0530
Message-Id: <1246267985.3185.3.camel@hpdv5.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


 $./perf stat -e add -e multiply -e fpu-store -e fpu-empty -e fpu-busy -e x87 -e mmx-3dnow -e sse-sse2 -- ls -lR /usr/include/ > /dev/null

 Performance counter stats for 'ls -lR /usr/include/':

           7335  add                       (   2.00x scaled)
           8012  multiply                  (   1.99x scaled)
           5229  fpu-store                 (   2.00x scaled)
      793097355  fpu-empty                 (   2.00x scaled)
            182  fpu-busy                  (   2.00x scaled)
              6  x87                       (   2.01x scaled)
              4  mmx-3dnow                 (   2.00x scaled)
           8933  sse-sse2                  (   2.00x scaled)

    0.393548820  seconds time elapsed

 $./perf stat -e add -e multiply -e fpu-store -e fpu-empty -e fpu-busy -e x87 -e mmx-3dnow -e sse-sse2 -- /usr/bin/rhythmbox ~jaswinder/Music/singhiskinng.mp3

 Performance counter stats for '/usr/bin/rhythmbox /home/jaswinder/Music/singhiskinng.mp3':

       19583739  add                       (   2.01x scaled)
       20856051  multiply                  (   2.01x scaled)
       18669503  fpu-store                 (   2.00x scaled)
    25100224054  fpu-empty                 (   1.99x scaled)
       12540131  fpu-busy                  (   1.99x scaled)
         207228  x87                       (   1.99x scaled)
        1768418  mmx-3dnow                 (   2.00x scaled)
       42286702  sse-sse2                  (   2.01x scaled)

  302.698647617  seconds time elapsed

 $./perf stat -e add -e multiply -e fpu-store -e fpu-empty -e fpu-busy -e x87 -e mmx-3dnow -e sse-sse2 -- /usr/bin/vlc ~jaswinder/Videos/Linus_Torvalds_interview_with_Charlie_Rose_Part_1.flv

 Performance counter stats for '/usr/bin/vlc /home/jaswinder/Videos/Linus_Torvalds_interview_with_Charlie_Rose_Part_1.flv':

     6572682335  add                       (   2.00x scaled)
    11131555181  multiply                  (   2.00x scaled)
     1317520699  fpu-store                 (   2.00x scaled)
     9089415134  fpu-empty                 (   1.99x scaled)
     2902772713  fpu-busy                  (   2.00x scaled)
          26047  x87                       (   2.00x scaled)
    24850978532  mmx-3dnow                 (   2.00x scaled)
      262276117  sse-sse2                  (   2.01x scaled)

   96.169312358  seconds time elapsed

Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
---
 arch/x86/kernel/cpu/perf_counter.c |   34 ++++++++++++++++++++++++++++++
 include/linux/perf_counter.h       |   17 +++++++++++++++
 kernel/perf_counter.c              |    1 +
 tools/perf/util/parse-events.c     |   40 ++++++++++++++++++++++++++++++++++++
 4 files changed, 92 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_counter.c b/arch/x86/kernel/cpu/perf_counter.c
index b83474b..4417edf 100644
--- a/arch/x86/kernel/cpu/perf_counter.c
+++ b/arch/x86/kernel/cpu/perf_counter.c
@@ -372,6 +372,12 @@ static const u64 atom_hw_cache_event_ids
  },
 };
 
+/*
+ * Generalized hw fpu event table
+ */
+
+static u64 __read_mostly hw_fpu_event_ids[PERF_COUNT_HW_FPU_MAX];
+
 static u64 intel_pmu_raw_event(u64 event)
 {
 #define CORE_EVNTSEL_EVENT_MASK		0x000000FFULL
@@ -481,6 +487,18 @@ static const u64 amd_hw_cache_event_ids
  },
 };
 
+static const u64 amd_hw_fpu_event_ids[] =
+{
+  [PERF_COUNT_HW_FPU_ADD]		= 0x0100, /* Dispatched FPU Add	     */
+  [PERF_COUNT_HW_FPU_MULTIPLY]		= 0x0200, /* Dispatched FPU Multiply */
+  [PERF_COUNT_HW_FPU_STORE]		= 0x0400, /* Dispatched FPU Store    */
+  [PERF_COUNT_HW_FPU_EMPTY]		= 0x0001, /* FPU Empty cycles        */
+  [PERF_COUNT_HW_FPU_BUSY]		= 0x00D7, /* Dispatch stall for FPU  */
+  [PERF_COUNT_HW_FPU_X87_INSTR]		= 0x01CB, /* Retired x87 Instructions*/
+  [PERF_COUNT_HW_FPU_MMX_3DNOW_INSTR]	= 0x02CB, /* Retired MMX & 3DNow Inst*/
+  [PERF_COUNT_HW_FPU_SSE_SSE2_INSTR]	= 0x0CCB, /* Retired SSE & SSE2 Instr*/
+};
+
 /*
  * AMD Performance Monitor K7 and later.
  */
@@ -659,6 +677,17 @@ set_ext_hw_attr(struct hw_perf_counter *hwc, struct perf_counter_attr *attr)
 	return 0;
 }
 
+static inline int
+set_hw_fpu_attr(struct hw_perf_counter *hwc, struct perf_counter_attr *attr)
+{
+	if (attr->config >= PERF_COUNT_HW_FPU_MAX)
+		return -EINVAL;
+
+	hwc->config |= hw_fpu_event_ids[attr->config];
+
+	return 0;
+}
+
 /*
  * Setup the hardware configuration for a given attr_type
  */
@@ -716,6 +745,9 @@ static int __hw_perf_counter_init(struct perf_counter *counter)
 	if (attr->type == PERF_TYPE_HW_CACHE)
 		return set_ext_hw_attr(hwc, attr);
 
+	if (attr->type == PERF_TYPE_HW_FPU)
+		return set_hw_fpu_attr(hwc, attr);
+
 	if (attr->config >= x86_pmu.max_events)
 		return -EINVAL;
 	/*
@@ -1468,6 +1500,8 @@ static int amd_pmu_init(void)
 	/* Events are common for all AMDs */
 	memcpy(hw_cache_event_ids, amd_hw_cache_event_ids,
 	       sizeof(hw_cache_event_ids));
+	memcpy(hw_fpu_event_ids, amd_hw_fpu_event_ids,
+	       sizeof(hw_fpu_event_ids));
 
 	return 0;
 }
diff --git a/include/linux/perf_counter.h b/include/linux/perf_counter.h
index 3078e23..89b3370 100644
--- a/include/linux/perf_counter.h
+++ b/include/linux/perf_counter.h
@@ -31,6 +31,7 @@ enum perf_type_id {
 	PERF_TYPE_TRACEPOINT			= 2,
 	PERF_TYPE_HW_CACHE			= 3,
 	PERF_TYPE_RAW				= 4,
+	PERF_TYPE_HW_FPU			= 5,
 
 	PERF_TYPE_MAX,				/* non-ABI */
 };
@@ -89,6 +90,22 @@ enum perf_hw_cache_op_result_id {
 };
 
 /*
+ * Generalized hardware FPU counters:
+ */
+enum perf_hw_fpu_id {
+	PERF_COUNT_HW_FPU_ADD			= 0,
+	PERF_COUNT_HW_FPU_MULTIPLY		= 1,
+	PERF_COUNT_HW_FPU_STORE			= 2,
+	PERF_COUNT_HW_FPU_EMPTY			= 3,
+	PERF_COUNT_HW_FPU_BUSY			= 4,
+	PERF_COUNT_HW_FPU_X87_INSTR		= 5,
+	PERF_COUNT_HW_FPU_MMX_3DNOW_INSTR	= 6,
+	PERF_COUNT_HW_FPU_SSE_SSE2_INSTR	= 7,
+
+	PERF_COUNT_HW_FPU_MAX,			/* non-ABI */
+};
+
+/*
  * Special "software" counters provided by the kernel, even if the hardware
  * does not support performance counters. These counters measure various
  * physical and sw events of the kernel (and allow the profiling of them as
diff --git a/kernel/perf_counter.c b/kernel/perf_counter.c
index 66ab1e9..c40132f 100644
--- a/kernel/perf_counter.c
+++ b/kernel/perf_counter.c
@@ -3788,6 +3788,7 @@ perf_counter_alloc(struct perf_counter_attr *attr,
 	case PERF_TYPE_RAW:
 	case PERF_TYPE_HARDWARE:
 	case PERF_TYPE_HW_CACHE:
+	case PERF_TYPE_HW_FPU:
 		pmu = hw_perf_counter_init(counter);
 		break;
 
diff --git a/tools/perf/util/parse-events.c b/tools/perf/util/parse-events.c
index 4d042f1..4d03061 100644
--- a/tools/perf/util/parse-events.c
+++ b/tools/perf/util/parse-events.c
@@ -40,6 +40,19 @@ static struct event_symbol event_symbols[] = {
   { CSW(CPU_MIGRATIONS),	"cpu-migrations",	"migrations"	},
 };
 
+#define CHFPU(x) .type = PERF_TYPE_HW_FPU, .config = PERF_COUNT_HW_FPU_##x
+
+static struct event_symbol fpu_event_symbols[] = {
+  { CHFPU(ADD),			"add",			"addition"	},
+  { CHFPU(MULTIPLY),		"multiply",		"multiplication"},
+  { CHFPU(STORE),		"fpu-store",		""		},
+  { CHFPU(EMPTY),		"fpu-empty",		""		},
+  { CHFPU(BUSY),		"fpu-busy",		""		},
+  { CHFPU(X87_INSTR),		"x87",			""		},
+  { CHFPU(MMX_3DNOW_INSTR),	"mmx-3dnow",		""		},
+  { CHFPU(SSE_SSE2_INSTR),	"sse-sse2",		"sse"		},
+};
+
 #define __PERF_COUNTER_FIELD(config, name) \
 	((config & PERF_COUNTER_##name##_MASK) >> PERF_COUNTER_##name##_SHIFT)
 
@@ -172,6 +185,11 @@ char *event_name(int counter)
 		return event_cache_name(cache_type, cache_op, cache_result);
 	}
 
+	case PERF_TYPE_HW_FPU:
+		if (config < PERF_COUNT_HW_FPU_MAX)
+			return fpu_event_symbols[config].symbol;
+		return "unknown-fpu";
+
 	case PERF_TYPE_SOFTWARE:
 		if (config < PERF_COUNT_SW_MAX)
 			return sw_event_names[config];
@@ -250,6 +268,19 @@ static int check_events(const char *str, unsigned int i)
 	return 0;
 }
 
+static int check_fpu_events(const char *str, unsigned int i)
+{
+	if (!strncmp(str, fpu_event_symbols[i].symbol,
+		     strlen(fpu_event_symbols[i].symbol)))
+		return 1;
+
+	if (strlen(fpu_event_symbols[i].alias))
+		if (!strncmp(str, fpu_event_symbols[i].alias,
+			     strlen(fpu_event_symbols[i].alias)))
+			return 1;
+	return 0;
+}
+
 /*
  * Each event can have multiple symbolic names.
  * Symbolic names are (almost) exactly matched.
@@ -297,6 +328,15 @@ static int parse_event_symbols(const char *str, struct perf_counter_attr *attr)
 		}
 	}
 
+	for (i = 0; i < ARRAY_SIZE(fpu_event_symbols); i++) {
+		if (check_fpu_events(str, i)) {
+			attr->type = fpu_event_symbols[i].type;
+			attr->config = fpu_event_symbols[i].config;
+
+			return 0;
+		}
+	}
+
 	return parse_generic_hw_symbols(str, attr);
 }
 
-- 
1.6.0.6



