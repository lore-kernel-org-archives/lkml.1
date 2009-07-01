Return-Path: <linux-kernel-owner+w=401wt.eu-S1754574AbZGAJpk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754574AbZGAJpk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jul 2009 05:45:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753370AbZGAJpd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Jul 2009 05:45:33 -0400
Received: from hera.kernel.org ([140.211.167.34]:58319 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753055AbZGAJpc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jul 2009 05:45:32 -0400
Subject: [GIT-PULL -tip][PATCH 0/6] perf_counter patches
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Peter Zijlstra <peterz@infradead.org>, x86 maintainers <x86@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Wed, 01 Jul 2009 15:03:35 +0530
Message-Id: <1246440815.3403.3.camel@hpdv5.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo,

Please pull perf_counter patches :
The following changes since commit 092304de242705abf24edcb0fc7beed4c4276865:
  Ingo Molnar (1):
        Merge branch 'perfcounters/urgent'

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jaswinder/linux-2.6-tip.git master

Jaswinder Singh Rajput (6):
      perf stat: define MATCH_EVENT for easy attrs checking
      perf stat: treat same behaviour for all CYCLES and CLOCKS
      perf_counter: Add Generalized Hardware vectored co-processor support for AMD
      perf_counter: Add Generalized Hardware interrupt support for AMD
      perf_counter: Add hardware vector events for nehalem
      perf_counter: Add hardware interrupt events for nehalem, core2 and atom

 arch/x86/kernel/cpu/perf_counter.c |   95 ++++++++++++++++++++++++++++++++++++
 include/linux/perf_counter.h       |   27 ++++++++++
 kernel/perf_counter.c              |    2 +
 tools/perf/builtin-stat.c          |   60 ++++++++++++++---------
 tools/perf/util/parse-events.c     |   73 +++++++++++++++++++++++++++
 5 files changed, 233 insertions(+), 24 deletions(-)

Complete diff:
diff --git a/arch/x86/kernel/cpu/perf_counter.c b/arch/x86/kernel/cpu/perf_counter.c
index d4cf4ce..4ef1838 100644
--- a/arch/x86/kernel/cpu/perf_counter.c
+++ b/arch/x86/kernel/cpu/perf_counter.c
@@ -372,6 +372,42 @@ static const u64 atom_hw_cache_event_ids
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
+/*
+ * Generalized hw interrupt event table
+ */
+
+static u64 __read_mostly hw_interrupt_event_ids[PERF_COUNT_HW_INTERRUPT_MAX];
+
+static const u64 nehalem_hw_interrupt_event_ids[] =
+{
+  [PERF_COUNT_HW_INTERRUPT]		= 0x011D, /* HW_INT.RCV              */
+  [PERF_COUNT_HW_INTERRUPT_MASK]	= 0x021D, /* HW_INT.CYCLES_MASKED    */
+  [PERF_COUNT_HW_INTERRUPT_PENDING_MASK]= 0x041D, /* HW_INT.CYCLES_PENDING_AND_MASKED*/
+};
+
+static const u64 core2_atom_hw_interrupt_event_ids[] =
+{
+  [PERF_COUNT_HW_INTERRUPT]		= 0x00C8, /* HW_INT_RCV              */
+  [PERF_COUNT_HW_INTERRUPT_MASK]	= 0x01C6, /* CYCLES_INT_MASKED.CYCLES_INT_MASKED*/
+  [PERF_COUNT_HW_INTERRUPT_PENDING_MASK]= 0x02C6, /* CYCLES_INT_MASKED.CYCLES_INT_PENDING_AND_MASKED*/
+};
+
 static u64 intel_pmu_raw_event(u64 event)
 {
 #define CORE_EVNTSEL_EVENT_MASK		0x000000FFULL
@@ -481,6 +517,25 @@ static const u64 amd_hw_cache_event_ids
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
+
+static const u64 amd_hw_interrupt_event_ids[] =
+{
+  [PERF_COUNT_HW_INTERRUPT]		= 0x00CF, /* Interrupts Taken        */
+  [PERF_COUNT_HW_INTERRUPT_MASK]	= 0x00CD, /* Interrupts-Masked Cycles*/
+  [PERF_COUNT_HW_INTERRUPT_PENDING_MASK]= 0x00CE, /* Int Mask+Pending Cycles */
+};
+
 /*
  * AMD Performance Monitor K7 and later.
  */
@@ -659,6 +714,28 @@ set_ext_hw_attr(struct hw_perf_counter *hwc, struct perf_counter_attr *attr)
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
+static inline int
+set_hw_interrupt_attr(struct hw_perf_counter *hwc, struct perf_counter_attr *attr)
+{
+	if (attr->config >= PERF_COUNT_HW_INTERRUPT_MAX)
+		return -EINVAL;
+
+	hwc->config |= hw_interrupt_event_ids[attr->config];
+
+	return 0;
+}
+
 /*
  * Setup the hardware configuration for a given attr_type
  */
@@ -716,6 +793,12 @@ static int __hw_perf_counter_init(struct perf_counter *counter)
 	if (attr->type == PERF_TYPE_HW_CACHE)
 		return set_ext_hw_attr(hwc, attr);
 
+	if (attr->type == PERF_TYPE_HW_VECTOR)
+		return set_hw_vector_attr(hwc, attr);
+
+	if (attr->type == PERF_TYPE_HW_INTERRUPT)
+		return set_hw_interrupt_attr(hwc, attr);
+
 	if (attr->config >= x86_pmu.max_events)
 		return -EINVAL;
 	/*
@@ -1437,6 +1520,8 @@ static int intel_pmu_init(void)
 	case 29: /* six-core 45 nm xeon "Dunnington" */
 		memcpy(hw_cache_event_ids, core2_hw_cache_event_ids,
 		       sizeof(hw_cache_event_ids));
+		memcpy(hw_interrupt_event_ids, core2_atom_hw_interrupt_event_ids,
+		       sizeof(hw_interrupt_event_ids));
 
 		pr_cont("Core2 events, ");
 		break;
@@ -1444,12 +1529,18 @@ static int intel_pmu_init(void)
 	case 26:
 		memcpy(hw_cache_event_ids, nehalem_hw_cache_event_ids,
 		       sizeof(hw_cache_event_ids));
+		memcpy(hw_vector_event_ids, nehalem_hw_vector_event_ids,
+		       sizeof(hw_vector_event_ids));
+		memcpy(hw_interrupt_event_ids, nehalem_hw_interrupt_event_ids,
+		       sizeof(hw_interrupt_event_ids));
 
 		pr_cont("Nehalem/Corei7 events, ");
 		break;
 	case 28:
 		memcpy(hw_cache_event_ids, atom_hw_cache_event_ids,
 		       sizeof(hw_cache_event_ids));
+		memcpy(hw_interrupt_event_ids, core2_atom_hw_interrupt_event_ids,
+		       sizeof(hw_interrupt_event_ids));
 
 		pr_cont("Atom events, ");
 		break;
@@ -1468,6 +1559,10 @@ static int amd_pmu_init(void)
 	/* Events are common for all AMDs */
 	memcpy(hw_cache_event_ids, amd_hw_cache_event_ids,
 	       sizeof(hw_cache_event_ids));
+	memcpy(hw_vector_event_ids, amd_hw_vector_event_ids,
+	       sizeof(hw_vector_event_ids));
+	memcpy(hw_interrupt_event_ids, amd_hw_interrupt_event_ids,
+	       sizeof(hw_interrupt_event_ids));
 
 	return 0;
 }
diff --git a/include/linux/perf_counter.h b/include/linux/perf_counter.h
index 5e970c7..c7165b9 100644
--- a/include/linux/perf_counter.h
+++ b/include/linux/perf_counter.h
@@ -31,6 +31,8 @@ enum perf_type_id {
 	PERF_TYPE_TRACEPOINT			= 2,
 	PERF_TYPE_HW_CACHE			= 3,
 	PERF_TYPE_RAW				= 4,
+	PERF_TYPE_HW_VECTOR			= 5,
+	PERF_TYPE_HW_INTERRUPT			= 6,
 
 	PERF_TYPE_MAX,				/* non-ABI */
 };
@@ -89,6 +91,31 @@ enum perf_hw_cache_op_result_id {
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
+ * Generalized hardware inturrupt counters:
+ */
+enum perf_hw_interrupt_id {
+	PERF_COUNT_HW_INTERRUPT			= 0,
+	PERF_COUNT_HW_INTERRUPT_MASK		= 1,
+	PERF_COUNT_HW_INTERRUPT_PENDING_MASK	= 2,
+
+	PERF_COUNT_HW_INTERRUPT_MAX,		/* non-ABI */
+};
+
+/*
  * Special "software" counters provided by the kernel, even if the hardware
  * does not support performance counters. These counters measure various
  * physical and sw events of the kernel (and allow the profiling of them as
diff --git a/kernel/perf_counter.c b/kernel/perf_counter.c
index d55a50d..7a529a8 100644
--- a/kernel/perf_counter.c
+++ b/kernel/perf_counter.c
@@ -3838,6 +3838,8 @@ perf_counter_alloc(struct perf_counter_attr *attr,
 	case PERF_TYPE_RAW:
 	case PERF_TYPE_HARDWARE:
 	case PERF_TYPE_HW_CACHE:
+	case PERF_TYPE_HW_VECTOR:
+	case PERF_TYPE_HW_INTERRUPT:
 		pmu = hw_perf_counter_init(counter);
 		break;
 
diff --git a/tools/perf/builtin-stat.c b/tools/perf/builtin-stat.c
index 2e03524..af61c29 100644
--- a/tools/perf/builtin-stat.c
+++ b/tools/perf/builtin-stat.c
@@ -96,6 +96,10 @@ static u64			walltime_nsecs_noise;
 static u64			runtime_cycles_avg;
 static u64			runtime_cycles_noise;
 
+#define MATCH_EVENT(t, c, counter)			\
+	(attrs[counter].type == PERF_TYPE_##t &&	\
+	 attrs[counter].config == PERF_COUNT_##c)
+
 #define ERR_PERF_OPEN \
 "Error: counter %d, sys_perf_counter_open() syscall returned with %d (%s)\n"
 
@@ -132,13 +136,31 @@ static void create_perf_stat_counter(int counter, int pid)
  */
 static inline int nsec_counter(int counter)
 {
-	if (attrs[counter].type != PERF_TYPE_SOFTWARE)
-		return 0;
+	if (MATCH_EVENT(SOFTWARE, SW_CPU_CLOCK, counter) ||
+	    MATCH_EVENT(SOFTWARE, SW_TASK_CLOCK, counter))
+		return 1;
+
+	return 0;
+}
 
-	if (attrs[counter].config == PERF_COUNT_SW_CPU_CLOCK)
+/*
+ * Does the counter have cycles as a unit?
+ */
+static inline int cycle_counter(int counter)
+{
+	if (MATCH_EVENT(HARDWARE, HW_CPU_CYCLES, counter) ||
+	    MATCH_EVENT(HARDWARE, HW_BUS_CYCLES, counter))
 		return 1;
 
-	if (attrs[counter].config == PERF_COUNT_SW_TASK_CLOCK)
+	return 0;
+}
+
+/*
+ * Does the counter have instructions as a unit?
+ */
+static inline int instruction_counter(int counter)
+{
+	if (MATCH_EVENT(HARDWARE, HW_INSTRUCTIONS, counter))
 		return 1;
 
 	return 0;
@@ -192,11 +214,9 @@ static void read_counter(int counter)
 	/*
 	 * Save the full runtime - to allow normalization during printout:
 	 */
-	if (attrs[counter].type == PERF_TYPE_SOFTWARE &&
-		attrs[counter].config == PERF_COUNT_SW_TASK_CLOCK)
+	if (nsec_counter(counter))
 		runtime_nsecs[run_idx] = count[0];
-	if (attrs[counter].type == PERF_TYPE_HARDWARE &&
-		attrs[counter].config == PERF_COUNT_HW_CPU_CYCLES)
+	else if (cycle_counter(counter))
 		runtime_cycles[run_idx] = count[0];
 }
 
@@ -290,13 +310,10 @@ static void nsec_printout(int counter, u64 *count, u64 *noise)
 
 	fprintf(stderr, " %14.6f  %-24s", msecs, event_name(counter));
 
-	if (attrs[counter].type == PERF_TYPE_SOFTWARE &&
-		attrs[counter].config == PERF_COUNT_SW_TASK_CLOCK) {
+	if (nsec_counter(counter) && walltime_nsecs_avg)
+		fprintf(stderr, " # %10.3f CPUs ",
+			(double)count[0] / (double)walltime_nsecs_avg);
 
-		if (walltime_nsecs_avg)
-			fprintf(stderr, " # %10.3f CPUs ",
-				(double)count[0] / (double)walltime_nsecs_avg);
-	}
 	print_noise(count, noise);
 }
 
@@ -304,18 +321,13 @@ static void abs_printout(int counter, u64 *count, u64 *noise)
 {
 	fprintf(stderr, " %14Ld  %-24s", count[0], event_name(counter));
 
-	if (runtime_cycles_avg &&
-		attrs[counter].type == PERF_TYPE_HARDWARE &&
-			attrs[counter].config == PERF_COUNT_HW_INSTRUCTIONS) {
-
+	if (instruction_counter(counter) && runtime_cycles_avg)
 		fprintf(stderr, " # %10.3f IPC  ",
 			(double)count[0] / (double)runtime_cycles_avg);
-	} else {
-		if (runtime_nsecs_avg) {
-			fprintf(stderr, " # %10.3f M/sec",
-				(double)count[0]/runtime_nsecs_avg*1000.0);
-		}
-	}
+	else if (runtime_nsecs_avg)
+		fprintf(stderr, " # %10.3f M/sec",
+			(double)count[0]/runtime_nsecs_avg*1000.0);
+
 	print_noise(count, noise);
 }
 
diff --git a/tools/perf/util/parse-events.c b/tools/perf/util/parse-events.c
index 4d042f1..5ea4c12 100644
--- a/tools/perf/util/parse-events.c
+++ b/tools/perf/util/parse-events.c
@@ -40,6 +40,25 @@ static struct event_symbol event_symbols[] = {
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
+#define CHINT(x) .type = PERF_TYPE_HW_INTERRUPT, .config = PERF_COUNT_HW_##x
+
+static struct event_symbol interrupt_event_symbols[] = {
+  { CHINT(INTERRUPT),		"interrupts",		"interrupt"	},
+  { CHINT(INTERRUPT_MASK),	"int-mask-cycles",	"masked"	},
+  { CHINT(INTERRUPT_PENDING_MASK),"int-pending-mask-cycles",	""	},
+};
+
 #define __PERF_COUNTER_FIELD(config, name) \
 	((config & PERF_COUNTER_##name##_MASK) >> PERF_COUNTER_##name##_SHIFT)
 
@@ -172,6 +191,16 @@ char *event_name(int counter)
 		return event_cache_name(cache_type, cache_op, cache_result);
 	}
 
+	case PERF_TYPE_HW_VECTOR:
+		if (config < PERF_COUNT_HW_VECTOR_MAX)
+			return vector_event_symbols[config].symbol;
+		return "unknown-vector";
+
+	case PERF_TYPE_HW_INTERRUPT:
+		if (config < PERF_COUNT_HW_INTERRUPT_MAX)
+			return interrupt_event_symbols[config].symbol;
+		return "unknown-interrupt";
+
 	case PERF_TYPE_SOFTWARE:
 		if (config < PERF_COUNT_SW_MAX)
 			return sw_event_names[config];
@@ -250,6 +279,32 @@ static int check_events(const char *str, unsigned int i)
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
+static int check_interrupt_events(const char *str, unsigned int i)
+{
+	if (!strncmp(str, interrupt_event_symbols[i].symbol,
+		     strlen(interrupt_event_symbols[i].symbol)))
+		return 1;
+
+	if (strlen(interrupt_event_symbols[i].alias))
+		if (!strncmp(str, interrupt_event_symbols[i].alias,
+			     strlen(interrupt_event_symbols[i].alias)))
+			return 1;
+	return 0;
+}
+
 /*
  * Each event can have multiple symbolic names.
  * Symbolic names are (almost) exactly matched.
@@ -297,6 +352,24 @@ static int parse_event_symbols(const char *str, struct perf_counter_attr *attr)
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
+	for (i = 0; i < ARRAY_SIZE(interrupt_event_symbols); i++) {
+		if (check_interrupt_events(str, i)) {
+			attr->type = interrupt_event_symbols[i].type;
+			attr->config = interrupt_event_symbols[i].config;
+
+			return 0;
+		}
+	}
+
 	return parse_generic_hw_symbols(str, attr);
 }
 


