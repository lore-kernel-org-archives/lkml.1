Return-Path: <linux-kernel-owner+w=401wt.eu-S1756236AbZGBJqw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756236AbZGBJqw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jul 2009 05:46:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754737AbZGBJqp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Jul 2009 05:46:45 -0400
Received: from hera.kernel.org ([140.211.167.34]:49259 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752482AbZGBJqo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jul 2009 05:46:44 -0400
Subject: [PATCH 2/2 -tip] perf_counter: Add generalized hardware interrupt
 support for AMD and Intel Corei7/Nehalem, Core2 and Atom
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Arjan van de Ven <arjan@infradead.org>, Paul Mackerras <paulus@samba.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Anton Blanchard <anton@samba.org>, Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>, x86 maintainers <x86@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
In-Reply-To: <1246527872.13659.2.camel@hpdv5.satnam>
References: <1246440815.3403.3.camel@hpdv5.satnam>
	 <1246440909.3403.5.camel@hpdv5.satnam>
	 <1246440977.3403.7.camel@hpdv5.satnam>
	 <1246441043.3403.9.camel@hpdv5.satnam> <20090701112007.GD15958@elte.hu>
	 <20090701112704.GF15958@elte.hu> <1246448441.6940.3.camel@hpdv5.satnam>
	 <20090701114928.GI15958@elte.hu>  <1246527872.13659.2.camel@hpdv5.satnam>
Content-Type: text/plain
Date: Thu, 02 Jul 2009 15:15:51 +0530
Message-Id: <1246527951.13659.4.camel@hpdv5.satnam>
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

$ ./perf list shows interrupt events like :

  interrupts OR interrupt                  [Hardware interrupt event]
  int-mask-cycles OR masked                [Hardware interrupt event]
  int-pending-mask-cycles                  [Hardware interrupt event]

Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
---
 arch/x86/kernel/cpu/perf_counter.c |   50 +++++++++++++++++++++++++++++++++++
 include/linux/perf_counter.h       |   12 ++++++++
 kernel/perf_counter.c              |    1 +
 tools/perf/util/parse-events.c     |   51 ++++++++++++++++++++++++++++++++++++
 4 files changed, 114 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_counter.c b/arch/x86/kernel/cpu/perf_counter.c
index 48f28b7..43b24ad 100644
--- a/arch/x86/kernel/cpu/perf_counter.c
+++ b/arch/x86/kernel/cpu/perf_counter.c
@@ -388,6 +388,26 @@ static const u64 nehalem_hw_vector_event_ids[] =
   [PERF_COUNT_HW_VECTOR_OPS]		= 0x0710, /* FP_COMP_OPS_EXE.X87|MMX|SSE_FP*/
 };
 
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
@@ -508,6 +528,14 @@ static const u64 amd_hw_vector_event_ids[] =
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
@@ -697,6 +725,17 @@ set_hw_vector_attr(struct hw_perf_counter *hwc, struct perf_counter_attr *attr)
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
@@ -757,6 +796,9 @@ static int __hw_perf_counter_init(struct perf_counter *counter)
 	if (attr->type == PERF_TYPE_HW_VECTOR)
 		return set_hw_vector_attr(hwc, attr);
 
+	if (attr->type == PERF_TYPE_HW_INTERRUPT)
+		return set_hw_interrupt_attr(hwc, attr);
+
 	if (attr->config >= x86_pmu.max_events)
 		return -EINVAL;
 	/*
@@ -1478,6 +1520,8 @@ static int intel_pmu_init(void)
 	case 29: /* six-core 45 nm xeon "Dunnington" */
 		memcpy(hw_cache_event_ids, core2_hw_cache_event_ids,
 		       sizeof(hw_cache_event_ids));
+		memcpy(hw_interrupt_event_ids, core2_atom_hw_interrupt_event_ids,
+		       sizeof(hw_interrupt_event_ids));
 
 		pr_cont("Core2 events, ");
 		break;
@@ -1487,12 +1531,16 @@ static int intel_pmu_init(void)
 		       sizeof(hw_cache_event_ids));
 		memcpy(hw_vector_event_ids, nehalem_hw_vector_event_ids,
 		       sizeof(hw_vector_event_ids));
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
@@ -1513,6 +1561,8 @@ static int amd_pmu_init(void)
 	       sizeof(hw_cache_event_ids));
 	memcpy(hw_vector_event_ids, amd_hw_vector_event_ids,
 	       sizeof(hw_vector_event_ids));
+	memcpy(hw_interrupt_event_ids, amd_hw_interrupt_event_ids,
+	       sizeof(hw_interrupt_event_ids));
 
 	return 0;
 }
diff --git a/include/linux/perf_counter.h b/include/linux/perf_counter.h
index e91b712..a53081b 100644
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
+ * Generalized hardware interrupt counters:
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
index 8213dfb..d085b8f 100644
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
@@ -311,6 +324,21 @@ static int check_vector_events(const char *str, unsigned int i)
 	return 0;
 }
 
+static int check_interrupt_events(const char *str, unsigned int i)
+{
+	int n;
+
+	n = strlen(interrupt_event_symbols[i].symbol);
+	if (!strncmp(str, interrupt_event_symbols[i].symbol, n))
+		return n;
+
+	n = strlen(interrupt_event_symbols[i].alias);
+	if (n)
+		if (!strncmp(str, interrupt_event_symbols[i].alias, n))
+			return n;
+	return 0;
+}
+
 static int
 parse_symbolic_event(const char **strp, struct perf_counter_attr *attr)
 {
@@ -338,6 +366,16 @@ parse_symbolic_event(const char **strp, struct perf_counter_attr *attr)
 		}
 	}
 
+	for (i = 0; i < ARRAY_SIZE(interrupt_event_symbols); i++) {
+		n = check_interrupt_events(str, i);
+		if (n > 0) {
+			attr->type = interrupt_event_symbols[i].type;
+			attr->config = interrupt_event_symbols[i].config;
+			*strp = str + n;
+			return 1;
+		}
+	}
+
 	return 0;
 }
 
@@ -463,6 +501,7 @@ static const char * const event_type_descriptors[] = {
 	"Tracepoint event",
 	"Hardware cache event",
 	"Hardware vector event",
+	"Hardware interrupt event",
 };
 
 /*
@@ -523,6 +562,18 @@ void print_events(void)
 	}
 
 	fprintf(stderr, "\n");
+	syms = interrupt_event_symbols;
+	type = syms->type;
+	for (i = 0; i < ARRAY_SIZE(interrupt_event_symbols); i++, syms++) {
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



