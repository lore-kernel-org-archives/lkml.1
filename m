Return-Path: <linux-kernel-owner+w=401wt.eu-S1755675AbZGAJsm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755675AbZGAJsm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jul 2009 05:48:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755401AbZGAJsc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Jul 2009 05:48:32 -0400
Received: from hera.kernel.org ([140.211.167.34]:52609 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755504AbZGAJsb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jul 2009 05:48:31 -0400
Subject: [PATCH 4/6 -tip] perf_counter: Add Generalized Hardware interrupt
 support for AMD
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>, x86 maintainers <x86@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
In-Reply-To: <1246441043.3403.9.camel@hpdv5.satnam>
References: <1246440815.3403.3.camel@hpdv5.satnam>
	 <1246440909.3403.5.camel@hpdv5.satnam>
	 <1246440977.3403.7.camel@hpdv5.satnam>
	 <1246441043.3403.9.camel@hpdv5.satnam>
Content-Type: text/plain
Date: Wed, 01 Jul 2009 15:08:14 +0530
Message-Id: <1246441094.3403.10.camel@hpdv5.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


$ ./perf stat -e interrupts -e masked -e int-pending-mask-cycles -- ls -lR /usr/include/ > /dev/null

 Performance counter stats for 'ls -lR /usr/include/':

            377  interrupts
       53429936  int-mask-cycles
           1119  int-pending-mask-cycles

    0.371457539  seconds time elapsed

Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
---
 arch/x86/kernel/cpu/perf_counter.c |   30 ++++++++++++++++++++++++++++++
 include/linux/perf_counter.h       |   12 ++++++++++++
 kernel/perf_counter.c              |    1 +
 tools/perf/util/parse-events.c     |   35 +++++++++++++++++++++++++++++++++++
 4 files changed, 78 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_counter.c b/arch/x86/kernel/cpu/perf_counter.c
index 8092200..487df5c 100644
--- a/arch/x86/kernel/cpu/perf_counter.c
+++ b/arch/x86/kernel/cpu/perf_counter.c
@@ -378,6 +378,12 @@ static const u64 atom_hw_cache_event_ids
 
 static u64 __read_mostly hw_vector_event_ids[PERF_COUNT_HW_VECTOR_MAX];
 
+/*
+ * Generalized hw interrupt event table
+ */
+
+static u64 __read_mostly hw_interrupt_event_ids[PERF_COUNT_HW_INTERRUPT_MAX];
+
 static u64 intel_pmu_raw_event(u64 event)
 {
 #define CORE_EVNTSEL_EVENT_MASK		0x000000FFULL
@@ -498,6 +504,14 @@ static const u64 amd_hw_vector_event_ids[] =
 						   |SSE & SSE2) Instructions */
 };
 
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
@@ -687,6 +701,17 @@ set_hw_vector_attr(struct hw_perf_counter *hwc, struct perf_counter_attr *attr)
 	return 0;
 }
 
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
@@ -747,6 +772,9 @@ static int __hw_perf_counter_init(struct perf_counter *counter)
 	if (attr->type == PERF_TYPE_HW_VECTOR)
 		return set_hw_vector_attr(hwc, attr);
 
+	if (attr->type == PERF_TYPE_HW_INTERRUPT)
+		return set_hw_interrupt_attr(hwc, attr);
+
 	if (attr->config >= x86_pmu.max_events)
 		return -EINVAL;
 	/*
@@ -1501,6 +1529,8 @@ static int amd_pmu_init(void)
 	       sizeof(hw_cache_event_ids));
 	memcpy(hw_vector_event_ids, amd_hw_vector_event_ids,
 	       sizeof(hw_vector_event_ids));
+	memcpy(hw_interrupt_event_ids, amd_hw_interrupt_event_ids,
+	       sizeof(hw_interrupt_event_ids));
 
 	return 0;
 }
diff --git a/include/linux/perf_counter.h b/include/linux/perf_counter.h
index e91b712..c7165b9 100644
--- a/include/linux/perf_counter.h
+++ b/include/linux/perf_counter.h
@@ -32,6 +32,7 @@ enum perf_type_id {
 	PERF_TYPE_HW_CACHE			= 3,
 	PERF_TYPE_RAW				= 4,
 	PERF_TYPE_HW_VECTOR			= 5,
+	PERF_TYPE_HW_INTERRUPT			= 6,
 
 	PERF_TYPE_MAX,				/* non-ABI */
 };
@@ -104,6 +105,17 @@ enum perf_hw_vector_id {
 };
 
 /*
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
index dd3848a..7a529a8 100644
--- a/kernel/perf_counter.c
+++ b/kernel/perf_counter.c
@@ -3839,6 +3839,7 @@ perf_counter_alloc(struct perf_counter_attr *attr,
 	case PERF_TYPE_HARDWARE:
 	case PERF_TYPE_HW_CACHE:
 	case PERF_TYPE_HW_VECTOR:
+	case PERF_TYPE_HW_INTERRUPT:
 		pmu = hw_perf_counter_init(counter);
 		break;
 
diff --git a/tools/perf/util/parse-events.c b/tools/perf/util/parse-events.c
index 5e5d17e..5ea4c12 100644
--- a/tools/perf/util/parse-events.c
+++ b/tools/perf/util/parse-events.c
@@ -51,6 +51,14 @@ static struct event_symbol vector_event_symbols[] = {
   { CHVECTOR(OPS),		"vec-ops",		"vec-operations"},
 };
 
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
 
@@ -188,6 +196,11 @@ char *event_name(int counter)
 			return vector_event_symbols[config].symbol;
 		return "unknown-vector";
 
+	case PERF_TYPE_HW_INTERRUPT:
+		if (config < PERF_COUNT_HW_INTERRUPT_MAX)
+			return interrupt_event_symbols[config].symbol;
+		return "unknown-interrupt";
+
 	case PERF_TYPE_SOFTWARE:
 		if (config < PERF_COUNT_SW_MAX)
 			return sw_event_names[config];
@@ -279,6 +292,19 @@ static int check_vector_events(const char *str, unsigned int i)
 	return 0;
 }
 
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
@@ -335,6 +361,15 @@ static int parse_event_symbols(const char *str, struct perf_counter_attr *attr)
 		}
 	}
 
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
 
-- 
1.6.0.6



