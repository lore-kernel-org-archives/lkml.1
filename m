Return-Path: <linux-kernel-owner+w=401wt.eu-S1754442AbZFYVDZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754442AbZFYVDZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jun 2009 17:03:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751865AbZFYVDR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jun 2009 17:03:17 -0400
Received: from hera.kernel.org ([140.211.167.34]:53968 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751225AbZFYVDQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jun 2009 17:03:16 -0400
Subject: [PATCH -tip] perf_counter tools: add support to set of multiple
 events in one short
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Fri, 26 Jun 2009 02:32:44 +0530
Message-Id: <1245963764.10962.2.camel@hpdv5.satnam>
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

./perf stat -e hw-events -e all-sw-events -- ls -lR > /dev/null

 Performance counter stats for 'ls -lR':

        9977353  cycles               #    557.193 M/sec  (scaled from 21.81%)
        4244800  instructions         #      0.425 IPC    (scaled from 27.51%)
        2953188  cache-references     #    164.923 M/sec  (scaled from 89.10%)
          72469  cache-misses         #      4.047 M/sec  (scaled from 89.13%)
         775760  branches             #     43.323 M/sec  (scaled from 89.10%)
          57814  branch-misses        #      3.229 M/sec  (scaled from 83.34%)
  <not counted>  bus-cycles
      17.970985  cpu-clock-msecs
      17.906460  task-clock-msecs     #      0.955 CPUs
            386  page-faults          #      0.022 M/sec
            386  minor-faults         #      0.022 M/sec
              0  major-faults         #      0.000 M/sec
              4  context-switches     #      0.000 M/sec
              1  CPU-migrations       #      0.000 M/sec

    0.018750671  seconds time elapsed.

Reported-by : Ingo Molnar <mingo@elte.hu>
Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
---
 tools/perf/util/parse-events.c |   66 ++++++++++++++++++++++++++++++++++++++-
 1 files changed, 64 insertions(+), 2 deletions(-)

diff --git a/tools/perf/util/parse-events.c b/tools/perf/util/parse-events.c
index 430f060..85d8021 100644
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
+ [PERF_TYPE_HARDWARE] = { "hw-events",		"all-hw-events",	},
+ [PERF_TYPE_SOFTWARE] = { "sw-events",		"all-sw-events",	},
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
+
+		break;
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



