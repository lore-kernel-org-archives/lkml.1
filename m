Return-Path: <linux-kernel-owner+w=401wt.eu-S1752157AbZIGIPp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752157AbZIGIPp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Sep 2009 04:15:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752026AbZIGIPo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Sep 2009 04:15:44 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:49486 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751436AbZIGIPn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Sep 2009 04:15:43 -0400
Message-ID: <4AA4C0E6.2010806@cn.fujitsu.com>
Date: Mon, 07 Sep 2009 16:14:30 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Peter Zijlstra <peterz@infradead.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Tom Zanussi <tzanussi@gmail.com>, Jason Baron <jbaron@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 6/6] perf trace: Add filter support
References: <4AA4C04D.1050201@cn.fujitsu.com>
In-Reply-To: <4AA4C04D.1050201@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 #./perf record -f -e irq:irq_handler_entry:irq==18:record
 or
 #./perf record -f -e irq:irq_handler_entry:irq==18 -R
 ^C
 # ./perf trace
 version = 0.5
            perf-4303  ... irq_handler_entry: irq=18 handler=eth0
            init-0     ... irq_handler_entry: irq=18 handler=eth0
            init-0     ... irq_handler_entry: irq=18 handler=eth0
            init-0     ... irq_handler_entry: irq=18 handler=eth0
            init-0     ... irq_handler_entry: irq=18 handler=eth0

The usage is not changed if filter is not used:

 #./perf record -f -e irq:irq_handler_entry:record

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
---
 tools/perf/builtin-record.c    |   12 ++++++++++
 tools/perf/util/parse-events.c |   46 +++++++++++++++++++++++++++++++++------
 tools/perf/util/parse-events.h |    1 +
 3 files changed, 52 insertions(+), 7 deletions(-)

diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index 99a12fe..7749982 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -369,9 +369,11 @@ static struct perf_header_attr *get_header_attr(struct perf_counter_attr *a, int
 
 static void create_counter(int counter, int cpu, pid_t pid)
 {
+	char *filter = filters[counter];
 	struct perf_counter_attr *attr = attrs + counter;
 	struct perf_header_attr *h_attr;
 	int track = !counter; /* only the first counter needs these */
+	int ret;
 	struct {
 		u64 count;
 		u64 time_enabled;
@@ -485,6 +487,16 @@ try_again:
 		exit(-1);
 	}
 
+	if (attr->type == PERF_TYPE_TRACEPOINT && filter != NULL) {
+		ret = ioctl(fd[nr_cpu][counter],
+				PERF_COUNTER_IOC_SET_FILTER, filter);
+		if (ret) {
+			error("failed to set filter with %d (%s)\n", errno,
+			      strerror(errno));
+			exit(-1);
+		}
+	}
+
 	ioctl(fd[nr_cpu][counter], PERF_COUNTER_IOC_ENABLE);
 }
 
diff --git a/tools/perf/util/parse-events.c b/tools/perf/util/parse-events.c
index 892d931..a7d2ef6 100644
--- a/tools/perf/util/parse-events.c
+++ b/tools/perf/util/parse-events.c
@@ -10,6 +10,7 @@
 int					nr_counters;
 
 struct perf_counter_attr		attrs[MAX_COUNTERS];
+char					*filters[MAX_COUNTERS];
 
 struct event_symbol {
 	u8		type;
@@ -405,15 +406,26 @@ parse_generic_hw_event(const char **str, struct perf_counter_attr *attr)
 	return 1;
 }
 
+static int tracepoint_event_set_flags(const char *flags,
+				     struct perf_counter_attr *attr)
+{
+	if (!strncmp(flags, "record", strlen(flags))) {
+		attr->sample_type |= PERF_SAMPLE_RAW;
+		return 1;
+	}
+	return 0;
+}
+
 static int parse_tracepoint_event(const char **strp,
 				    struct perf_counter_attr *attr)
 {
+	char sys_name[MAX_EVENT_LENGTH];
 	const char *evt_name;
+	char *filter;
 	char *flags;
-	char sys_name[MAX_EVENT_LENGTH];
 	char id_buf[4];
 	int fd;
-	unsigned int sys_length, evt_length;
+	unsigned int sys_length, evt_length, filter_length;
 	u64 id;
 	char evt_path[MAXPATHLEN];
 
@@ -433,13 +445,33 @@ static int parse_tracepoint_event(const char **strp,
 	evt_name = evt_name + 1;
 
 	flags = strchr(evt_name, ':');
-	if (flags) {
-		*flags = '\0';
-		flags++;
-		if (!strncmp(flags, "record", strlen(flags)))
-			attr->sample_type |= PERF_SAMPLE_RAW;
+	if (!flags)
+		goto next;
+
+	*flags++ = '\0';
+	if (tracepoint_event_set_flags(flags, attr))
+		goto next;
+
+	filter = flags;
+
+	flags = strchr(filter, ':');
+	if (!flags)
+		filter_length = strlen(filter);
+	else {
+		filter_length = flags++ - filter;
+		if (!tracepoint_event_set_flags(flags, attr))
+			return 0;
+	}
+
+	filters[nr_counters] = malloc(filter_length + 1);
+	if (!filters[nr_counters]) {
+		fprintf(stderr, "Not enough memory to hold filter string\n");
+		exit(-1);
 	}
+	strncpy(filters[nr_counters], filter, filter_length);
+	filters[nr_counters][filter_length] = '\0';
 
+next:
 	evt_length = strlen(evt_name);
 	if (evt_length >= MAX_EVENT_LENGTH)
 		return 0;
diff --git a/tools/perf/util/parse-events.h b/tools/perf/util/parse-events.h
index 60704c1..0ae146e 100644
--- a/tools/perf/util/parse-events.h
+++ b/tools/perf/util/parse-events.h
@@ -17,6 +17,7 @@ extern struct tracepoint_path *tracepoint_id_to_path(u64 config);
 extern int			nr_counters;
 
 extern struct perf_counter_attr attrs[MAX_COUNTERS];
+extern char *filters[MAX_COUNTERS];
 
 extern const char *event_name(int ctr);
 extern const char *__event_name(int type, u64 config);
-- 1.6.3 
