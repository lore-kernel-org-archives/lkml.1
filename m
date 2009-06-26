Return-Path: <linux-kernel-owner+w=401wt.eu-S1761649AbZFZVnB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761649AbZFZVnB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jun 2009 17:43:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758941AbZFZVmw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jun 2009 17:42:52 -0400
Received: from hera.kernel.org ([140.211.167.34]:46842 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761605AbZFZVmv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jun 2009 17:42:51 -0400
Subject: [PATCH 2/3 -tip] perf_counter tools: Add support to set of
 multiple events in one shot
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1246051927.2988.10.camel@hpdv5.satnam>
References: <1246051852.2988.8.camel@hpdv5.satnam>
	 <1246051927.2988.10.camel@hpdv5.satnam>
Content-Type: text/plain
Date: Sat, 27 Jun 2009 03:03:16 +0530
Message-Id: <1246051996.2988.12.camel@hpdv5.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Add support for HARDWARE and SOFTWARE events :
 perf stat -e all-sw-events
 perf stat -e sw-events
 perf stat -e all-hw-events
 perf stat -e hw-events

On AMD box :

$ ./perf stat -e hw-events -e all-sw-events -- ls -lR /usr/include/  > /dev/null

 Performance counter stats for 'ls -lR /usr/include/':

      744418792  cycles                   #   2027.230 M/sec  (   3.28x scaled)
      515314667  instructions             #      0.692 IPC    (   3.29x scaled)
      247900772  cache-references         #    675.093 M/sec  (   1.18x scaled)
        3587971  cache-misses             #      9.771 M/sec  (   1.18x scaled)
       65830547  branches                 #    179.272 M/sec  (   1.18x scaled)
        3743637  branch-misses            #     10.195 M/sec  (   1.18x scaled)
  <not counted>  bus-cycles
     367.880756  cpu-clock-msecs
     367.209910  task-clock-msecs         #      0.990 CPUs
            441  page-faults              #      0.001 M/sec
            441  minor-faults             #      0.001 M/sec
              0  major-faults             #      0.000 M/sec
             41  context-switches         #      0.000 M/sec
              1  CPU-migrations           #      0.000 M/sec

    0.371065298  seconds time elapsed.

Reported-by : Ingo Molnar <mingo@elte.hu>
Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
---
 tools/perf/util/parse-events.c |   66 ++++++++++++++++++++++++++++++++++++++-
 1 files changed, 64 insertions(+), 2 deletions(-)

diff --git a/tools/perf/util/parse-events.c b/tools/perf/util/parse-events.c
index 4d042f1..a368728 100644
--- a/tools/perf/util/parse-events.c
+++ b/tools/perf/util/parse-events.c
@@ -40,6 +40,16 @@ static struct event_symbol event_symbols[] = {
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
+};
+
 #define __PERF_COUNTER_FIELD(config, name) \
 	((config & PERF_COUNTER_##name##_MASK) >> PERF_COUNTER_##name##_SHIFT)
 
@@ -237,6 +247,49 @@ parse_generic_hw_symbols(const char *str, struct perf_counter_attr *attr)
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
+	if (!strncmp(str, event_type_symbols[i].symbol,
+		     strlen(event_type_symbols[i].symbol)))
+		return 1;
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
@@ -288,6 +341,12 @@ static int parse_event_symbols(const char *str, struct perf_counter_attr *attr)
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
@@ -314,8 +373,11 @@ again:
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
-- 
1.6.0.6



