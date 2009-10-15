Return-Path: <linux-kernel-owner+w=401wt.eu-S1761726AbZJODXz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761726AbZJODXz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Oct 2009 23:23:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760131AbZJODXy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Oct 2009 23:23:54 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:57409 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1756959AbZJODXx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Oct 2009 23:23:53 -0400
Message-ID: <4AD6955F.90602@cn.fujitsu.com>
Date: Thu, 15 Oct 2009 11:22:07 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>, Tom Zanussi <tzanussi@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 4/4] perf trace: Add filter Suppport
References: <4AD694B8.2020206@cn.fujitsu.com>
In-Reply-To: <4AD694B8.2020206@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a new option "--filter <filter_str>" to perf record, and
it should be right after "-e trace_point":

 #./perf record -R -f -e irq:irq_handler_entry --filter irq==18
 ^C
 # ./perf trace
            perf-4303  ... irq_handler_entry: irq=18 handler=eth0
            init-0     ... irq_handler_entry: irq=18 handler=eth0
            init-0     ... irq_handler_entry: irq=18 handler=eth0
            init-0     ... irq_handler_entry: irq=18 handler=eth0
            init-0     ... irq_handler_entry: irq=18 handler=eth0

See Documentation/trace/events.txt for the syntax of filter
expressions.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
---
 tools/perf/builtin-record.c    |   15 ++++++++++++++-
 tools/perf/util/parse-events.c |   26 ++++++++++++++++++++++++--
 tools/perf/util/parse-events.h |    2 ++
 3 files changed, 40 insertions(+), 3 deletions(-)

diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index 4e3a374..8b2c860 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -374,9 +374,11 @@ static struct perf_header_attr *get_header_attr(struct perf_event_attr *a, int n
 
 static void create_counter(int counter, int cpu, pid_t pid)
 {
+	char *filter = filters[counter];
 	struct perf_event_attr *attr = attrs + counter;
 	struct perf_header_attr *h_attr;
 	int track = !counter; /* only the first counter needs these */
+	int ret;
 	struct {
 		u64 count;
 		u64 time_enabled;
@@ -479,7 +481,6 @@ try_again:
 		multiplex_fd = fd[nr_cpu][counter];
 
 	if (multiplex && fd[nr_cpu][counter] != multiplex_fd) {
-		int ret;
 
 		ret = ioctl(fd[nr_cpu][counter], PERF_EVENT_IOC_SET_OUTPUT, multiplex_fd);
 		assert(ret != -1);
@@ -499,6 +500,16 @@ try_again:
 		}
 	}
 
+	if (filter != NULL) {
+		ret = ioctl(fd[nr_cpu][counter],
+			    PERF_EVENT_IOC_SET_FILTER, filter);
+		if (ret) {
+			error("failed to set filter with %d (%s)\n", errno,
+			      strerror(errno));
+			exit(-1);
+		}
+	}
+
 	ioctl(fd[nr_cpu][counter], PERF_EVENT_IOC_ENABLE);
 }
 
@@ -676,6 +687,8 @@ static const struct option options[] = {
 	OPT_CALLBACK('e', "event", NULL, "event",
 		     "event selector. use 'perf list' to list available events",
 		     parse_events),
+	OPT_CALLBACK(0, "filter", NULL, "filter",
+		     "event filter", parse_filter),
 	OPT_INTEGER('p', "pid", &target_pid,
 		    "record events on existing pid"),
 	OPT_INTEGER('r', "realtime", &realtime_prio,
diff --git a/tools/perf/util/parse-events.c b/tools/perf/util/parse-events.c
index 8cfb48c..b097570 100644
--- a/tools/perf/util/parse-events.c
+++ b/tools/perf/util/parse-events.c
@@ -8,9 +8,10 @@
 #include "cache.h"
 #include "header.h"
 
-int					nr_counters;
+int				nr_counters;
 
 struct perf_event_attr		attrs[MAX_COUNTERS];
+char				*filters[MAX_COUNTERS];
 
 struct event_symbol {
 	u8		type;
@@ -708,7 +709,6 @@ static void store_event_type(const char *orgname)
 	perf_header__push_event(id, orgname);
 }
 
-
 int parse_events(const struct option *opt __used, const char *str, int unset __used)
 {
 	struct perf_event_attr attr;
@@ -745,6 +745,28 @@ int parse_events(const struct option *opt __used, const char *str, int unset __u
 	return 0;
 }
 
+int parse_filter(const struct option *opt __used, const char *str,
+		 int unset __used)
+{
+	int i = nr_counters - 1;
+	int len = strlen(str);
+
+	if (i < 0 || attrs[i].type != PERF_TYPE_TRACEPOINT) {
+		fprintf(stderr,
+			"-F option should follow a -e tracepoint option\n");
+		return -1;
+	}
+
+	filters[i] = malloc(len + 1);
+	if (!filters[i]) {
+		fprintf(stderr, "not enough memory to hold filter string\n");
+		return -1;
+	}
+	strcpy(filters[i], str);
+
+	return 0;
+}
+
 static const char * const event_type_descriptors[] = {
 	"",
 	"Hardware event",
diff --git a/tools/perf/util/parse-events.h b/tools/perf/util/parse-events.h
index 8626a43..b8c1f64 100644
--- a/tools/perf/util/parse-events.h
+++ b/tools/perf/util/parse-events.h
@@ -17,11 +17,13 @@ extern struct tracepoint_path *tracepoint_id_to_path(u64 config);
 extern int			nr_counters;
 
 extern struct perf_event_attr attrs[MAX_COUNTERS];
+extern char *filters[MAX_COUNTERS];
 
 extern const char *event_name(int ctr);
 extern const char *__event_name(int type, u64 config);
 
 extern int parse_events(const struct option *opt, const char *str, int unset);
+extern int parse_filter(const struct option *opt, const char *str, int unset);
 
 #define EVENTS_HELP_MAX (128*1024)
 
-- 
1.6.3

