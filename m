Return-Path: <linux-kernel-owner+w=401wt.eu-S1761706AbZFZVnX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761706AbZFZVnX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jun 2009 17:43:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753113AbZFZVnO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jun 2009 17:43:14 -0400
Received: from hera.kernel.org ([140.211.167.34]:46915 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758941AbZFZVnO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jun 2009 17:43:14 -0400
Subject: [PATCH 3/3 -tip] perf_counter tools: Add support for all CACHE
 events
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1246051996.2988.12.camel@hpdv5.satnam>
References: <1246051852.2988.8.camel@hpdv5.satnam>
	 <1246051927.2988.10.camel@hpdv5.satnam>
	 <1246051996.2988.12.camel@hpdv5.satnam>
Content-Type: text/plain
Date: Sat, 27 Jun 2009 03:05:26 +0530
Message-Id: <1246052126.2988.15.camel@hpdv5.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Add support for all CACHE events :
 perf stat -e all-cache-events
 perf stat -e cache-events

On AMD box (<not-counted> events are not available for AMD):

 $./perf stat -e all-cache-events -- ls -lR /usr/include/ > /dev/null

 Performance counter stats for 'ls -lR /usr/include/':

      246786934  L1-d$-loads               (   4.64x scaled)
         936899  L1-d$-load-misses         (   4.53x scaled)
         138961  L1-d$-stores              (   4.46x scaled)
  <not counted>  L1-d$-store-misses
         348659  L1-d$-prefetches          (   4.41x scaled)
         236550  L1-d$-prefetch-misses     (   4.41x scaled)
      248192242  L1-i$-loads               (   4.46x scaled)
        3805771  L1-i$-load-misses         (   4.46x scaled)
         334292  L1-d$-prefetches          (   4.46x scaled)
         239715  L1-d$-prefetch-misses     (   4.47x scaled)
        4966124  LLC-loads                 (   4.47x scaled)
         531900  LLC-load-misses           (   4.47x scaled)
        5605759  LLC-stores                (   4.47x scaled)
  <not counted>  LLC-store-misses
  <not counted>  LLC-prefetches
  <not counted>  LLC-prefetch-misses
      253681838  dTLB-loads                (   4.48x scaled)
        4634809  dTLB-load-misses          (   4.49x scaled)
  <not counted>  dTLB-stores
  <not counted>  dTLB-store-misses
  <not counted>  dTLB-prefetches
  <not counted>  dTLB-prefetch-misses
      253610942  iTLB-loads                (   4.51x scaled)
           3271  iTLB-load-misses          (   4.56x scaled)
      105697493  branch-loads              (   4.61x scaled)
        5136856  branch-load-misses        (   4.66x scaled)

    0.375218449  seconds time elapsed.

Reported-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
---
 tools/perf/util/parse-events.c |   67 ++++++++++++++++++++++++++++++++++++++-
 1 files changed, 65 insertions(+), 2 deletions(-)

diff --git a/tools/perf/util/parse-events.c b/tools/perf/util/parse-events.c
index a368728..331b296 100644
--- a/tools/perf/util/parse-events.c
+++ b/tools/perf/util/parse-events.c
@@ -48,6 +48,58 @@ struct event_type_symbol {
 static struct event_type_symbol event_type_symbols[] = {
  [PERF_TYPE_HARDWARE]	= { "hw-events",	"all-hw-events",	},
  [PERF_TYPE_SOFTWARE]	= { "sw-events",	"all-sw-events",	},
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
 };
 
 #define __PERF_COUNTER_FIELD(config, name) \
@@ -266,6 +318,16 @@ static int set_multiple_events(unsigned int type)
 		}
 		break;
 
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
 	default:
 		return -1;
 	}
@@ -279,9 +341,10 @@ static int set_multiple_events(unsigned int type)
 
 static int check_type_events(const char *str, unsigned int i)
 {
-	if (!strncmp(str, event_type_symbols[i].symbol,
+	if (strlen(event_type_symbols[i].symbol))
+		if (!strncmp(str, event_type_symbols[i].symbol,
 		     strlen(event_type_symbols[i].symbol)))
-		return 1;
+			return 1;
 
 	if (strlen(event_type_symbols[i].alias))
 		if (!strncmp(str, event_type_symbols[i].alias,
-- 
1.6.0.6



