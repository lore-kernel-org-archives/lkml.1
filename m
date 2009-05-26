Return-Path: <linux-kernel-owner+w=401wt.eu-S1754938AbZEZKfX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754938AbZEZKfX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 May 2009 06:35:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753683AbZEZKfE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 May 2009 06:35:04 -0400
Received: from hera.kernel.org ([140.211.167.34]:56452 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753635AbZEZKe7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 May 2009 06:34:59 -0400
Date: Tue, 26 May 2009 10:34:14 GMT
From: tip-bot for Ingo Molnar <mingo@elte.hu>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, paulus@samba.org,
       hpa@zytor.com, mingo@redhat.com, jkacur@redhat.com,
       a.p.zijlstra@chello.nl, efault@gmx.de, mtosatti@redhat.com,
       tglx@linutronix.de, cjashfor@linux.vnet.ibm.com, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org, acme@redhat.com,
       linux-kernel@vger.kernel.org, jkacur@redhat.com, a.p.zijlstra@chello.nl,
       efault@gmx.de, mtosatti@redhat.com, tglx@linutronix.de,
       cjashfor@linux.vnet.ibm.com, mingo@elte.hu
In-Reply-To: <new-submission>
References: <new-submission>
Subject: [tip:perfcounters/core] perf record: Convert to Git option parsing
Message-ID: <tip-0e9b20b8a1cab6c6ab4f98f917a2d98783103969@git.kernel.org>
Git-Commit-ID: 0e9b20b8a1cab6c6ab4f98f917a2d98783103969
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 26 May 2009 10:34:15 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  0e9b20b8a1cab6c6ab4f98f917a2d98783103969
Gitweb:     http://git.kernel.org/tip/0e9b20b8a1cab6c6ab4f98f917a2d98783103969
Author:     Ingo Molnar <mingo@elte.hu>
AuthorDate: Tue, 26 May 2009 09:17:18 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 26 May 2009 11:26:32 +0200

perf record: Convert to Git option parsing

Remove getopt usage and use Git's much more advanced and more compact
command option library.

Git's library (util/parse-options.[ch]) constructs help texts and
error messages automatically, and has a number of other convenience
features as well.

Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Marcelo Tosatti <mtosatti@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: John Kacur <jkacur@redhat.com>
LKML-Reference: <new-submission>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 Documentation/perf_counter/builtin-record.c |  372 +++++++++++++--------------
 Documentation/perf_counter/builtin-top.c    |    3 +
 2 files changed, 177 insertions(+), 198 deletions(-)

diff --git a/Documentation/perf_counter/builtin-record.c b/Documentation/perf_counter/builtin-record.c
index f225efa..f12a782 100644
--- a/Documentation/perf_counter/builtin-record.c
+++ b/Documentation/perf_counter/builtin-record.c
@@ -2,6 +2,8 @@
 
 #include "perf.h"
 #include "util/util.h"
+#include "util/parse-options.h"
+#include "util/exec_cmd.h"
 
 #include <sys/types.h>
 #include <sys/stat.h>
@@ -11,7 +13,6 @@
 #include <stdlib.h>
 #include <string.h>
 #include <limits.h>
-#include <getopt.h>
 #include <assert.h>
 #include <fcntl.h>
 #include <stdio.h>
@@ -33,8 +34,8 @@
 
 
 
-#define ALIGN(x,a)		__ALIGN_MASK(x,(typeof(x))(a)-1)
-#define __ALIGN_MASK(x,mask)	(((x)+(mask))&~(mask))
+#define ALIGN(x, a)		__ALIGN_MASK(x, (typeof(x))(a)-1)
+#define __ALIGN_MASK(x, mask)	(((x)+(mask))&~(mask))
 
 static int			nr_counters			=  0;
 static __u64			event_id[MAX_COUNTERS]		= { };
@@ -45,7 +46,7 @@ static int			nr_cpus				=  0;
 static unsigned int		page_size;
 static unsigned int		mmap_pages			= 16;
 static int			output;
-static char 			*output_name			= "output.perf";
+static const char		*output_name			= "output.perf";
 static int			group				= 0;
 static unsigned int		realtime_prio			= 0;
 static int			system_wide			= 0;
@@ -62,192 +63,6 @@ const unsigned int default_count[] = {
 	  10000,
 };
 
-struct event_symbol {
-	__u64 event;
-	char *symbol;
-};
-
-static struct event_symbol event_symbols[] = {
-	{EID(PERF_TYPE_HARDWARE, PERF_COUNT_CPU_CYCLES),		"cpu-cycles",		},
-	{EID(PERF_TYPE_HARDWARE, PERF_COUNT_CPU_CYCLES),		"cycles",		},
-	{EID(PERF_TYPE_HARDWARE, PERF_COUNT_INSTRUCTIONS),		"instructions",		},
-	{EID(PERF_TYPE_HARDWARE, PERF_COUNT_CACHE_REFERENCES),		"cache-references",	},
-	{EID(PERF_TYPE_HARDWARE, PERF_COUNT_CACHE_MISSES),		"cache-misses",		},
-	{EID(PERF_TYPE_HARDWARE, PERF_COUNT_BRANCH_INSTRUCTIONS),	"branch-instructions",	},
-	{EID(PERF_TYPE_HARDWARE, PERF_COUNT_BRANCH_INSTRUCTIONS),	"branches",		},
-	{EID(PERF_TYPE_HARDWARE, PERF_COUNT_BRANCH_MISSES),		"branch-misses",	},
-	{EID(PERF_TYPE_HARDWARE, PERF_COUNT_BUS_CYCLES),		"bus-cycles",		},
-
-	{EID(PERF_TYPE_SOFTWARE, PERF_COUNT_CPU_CLOCK),			"cpu-clock",		},
-	{EID(PERF_TYPE_SOFTWARE, PERF_COUNT_TASK_CLOCK),		"task-clock",		},
-	{EID(PERF_TYPE_SOFTWARE, PERF_COUNT_PAGE_FAULTS),		"page-faults",		},
-	{EID(PERF_TYPE_SOFTWARE, PERF_COUNT_PAGE_FAULTS),		"faults",		},
-	{EID(PERF_TYPE_SOFTWARE, PERF_COUNT_PAGE_FAULTS_MIN),		"minor-faults",		},
-	{EID(PERF_TYPE_SOFTWARE, PERF_COUNT_PAGE_FAULTS_MAJ),		"major-faults",		},
-	{EID(PERF_TYPE_SOFTWARE, PERF_COUNT_CONTEXT_SWITCHES),		"context-switches",	},
-	{EID(PERF_TYPE_SOFTWARE, PERF_COUNT_CONTEXT_SWITCHES),		"cs",			},
-	{EID(PERF_TYPE_SOFTWARE, PERF_COUNT_CPU_MIGRATIONS),		"cpu-migrations",	},
-	{EID(PERF_TYPE_SOFTWARE, PERF_COUNT_CPU_MIGRATIONS),		"migrations",		},
-};
-
-/*
- * Each event can have multiple symbolic names.
- * Symbolic names are (almost) exactly matched.
- */
-static __u64 match_event_symbols(char *str)
-{
-	__u64 config, id;
-	int type;
-	unsigned int i;
-
-	if (sscanf(str, "r%llx", &config) == 1)
-		return config | PERF_COUNTER_RAW_MASK;
-
-	if (sscanf(str, "%d:%llu", &type, &id) == 2)
-		return EID(type, id);
-
-	for (i = 0; i < ARRAY_SIZE(event_symbols); i++) {
-		if (!strncmp(str, event_symbols[i].symbol,
-			     strlen(event_symbols[i].symbol)))
-			return event_symbols[i].event;
-	}
-
-	return ~0ULL;
-}
-
-static int parse_events(char *str)
-{
-	__u64 config;
-
-again:
-	if (nr_counters == MAX_COUNTERS)
-		return -1;
-
-	config = match_event_symbols(str);
-	if (config == ~0ULL)
-		return -1;
-
-	event_id[nr_counters] = config;
-	nr_counters++;
-
-	str = strstr(str, ",");
-	if (str) {
-		str++;
-		goto again;
-	}
-
-	return 0;
-}
-
-#define __PERF_COUNTER_FIELD(config, name) \
-	((config & PERF_COUNTER_##name##_MASK) >> PERF_COUNTER_##name##_SHIFT)
-
-#define PERF_COUNTER_RAW(config)	__PERF_COUNTER_FIELD(config, RAW)
-#define PERF_COUNTER_CONFIG(config)	__PERF_COUNTER_FIELD(config, CONFIG)
-#define PERF_COUNTER_TYPE(config)	__PERF_COUNTER_FIELD(config, TYPE)
-#define PERF_COUNTER_ID(config)		__PERF_COUNTER_FIELD(config, EVENT)
-
-static void display_events_help(void)
-{
-	unsigned int i;
-	__u64 e;
-
-	printf(
-	" -e EVENT     --event=EVENT   #  symbolic-name        abbreviations");
-
-	for (i = 0; i < ARRAY_SIZE(event_symbols); i++) {
-		int type, id;
-
-		e = event_symbols[i].event;
-		type = PERF_COUNTER_TYPE(e);
-		id = PERF_COUNTER_ID(e);
-
-		printf("\n                             %d:%d: %-20s",
-				type, id, event_symbols[i].symbol);
-	}
-
-	printf("\n"
-	"                           rNNN: raw PMU events (eventsel+umask)\n\n");
-}
-
-static void display_help(void)
-{
-	printf(
-	"Usage: perf-record [<options>] <cmd>\n"
-	"perf-record Options (up to %d event types can be specified at once):\n\n",
-		 MAX_COUNTERS);
-
-	display_events_help();
-
-	printf(
-	" -c CNT    --count=CNT          # event period to sample\n"
-	" -m pages  --mmap_pages=<pages> # number of mmap data pages\n"
-	" -o file   --output=<file>      # output file\n"
-	" -p pid    --pid=<pid>		 # record events on existing pid\n"
-	" -r prio   --realtime=<prio>    # use RT prio\n"
-	" -s        --system             # system wide profiling\n"
-	);
-
-	exit(0);
-}
-
-static void process_options(int argc, char * const argv[])
-{
-	int error = 0, counter;
-
-	for (;;) {
-		int option_index = 0;
-		/** Options for getopt */
-		static struct option long_options[] = {
-			{"count",	required_argument,	NULL, 'c'},
-			{"event",	required_argument,	NULL, 'e'},
-			{"mmap_pages",	required_argument,	NULL, 'm'},
-			{"output",	required_argument,	NULL, 'o'},
-			{"pid",		required_argument,	NULL, 'p'},
-			{"realtime",	required_argument,	NULL, 'r'},
-			{"system",	no_argument,		NULL, 's'},
-			{"inherit",	no_argument,		NULL, 'i'},
-			{"nmi",		no_argument,		NULL, 'n'},
-			{NULL,		0,			NULL,  0 }
-		};
-		int c = getopt_long(argc, argv, "+:c:e:m:o:p:r:sin",
-				    long_options, &option_index);
-		if (c == -1)
-			break;
-
-		switch (c) {
-		case 'c': default_interval		=   atoi(optarg); break;
-		case 'e': error				= parse_events(optarg); break;
-		case 'm': mmap_pages			=   atoi(optarg); break;
-		case 'o': output_name			= strdup(optarg); break;
-		case 'p': target_pid			=   atoi(optarg); break;
-		case 'r': realtime_prio			=   atoi(optarg); break;
-		case 's': system_wide                   ^=             1; break;
-		case 'i': inherit			^=	       1; break;
-		case 'n': nmi				^=	       1; break;
-		default: error = 1; break;
-		}
-	}
-
-	if (argc - optind == 0 && target_pid == -1)
-		error = 1;
-
-	if (error)
-		display_help();
-
-	if (!nr_counters) {
-		nr_counters = 1;
-		event_id[0] = 0;
-	}
-
-	for (counter = 0; counter < nr_counters; counter++) {
-		if (event_count[counter])
-			continue;
-
-		event_count[counter] = default_interval;
-	}
-}
-
 struct mmap_data {
 	int counter;
 	void *base;
@@ -538,16 +353,13 @@ static void open_counters(int cpu, pid_t pid)
 	nr_cpu++;
 }
 
-int cmd_record(int argc, char * const argv[])
+static int __cmd_record(int argc, const char **argv)
 {
 	int i, counter;
 	pid_t pid;
 	int ret;
 
 	page_size = sysconf(_SC_PAGE_SIZE);
-
-	process_options(argc, argv);
-
 	nr_cpus = sysconf(_SC_NPROCESSORS_ONLN);
 	assert(nr_cpus <= MAX_NR_CPUS);
 	assert(nr_cpus >= 0);
@@ -558,9 +370,6 @@ int cmd_record(int argc, char * const argv[])
 		exit(-1);
 	}
 
-	argc -= optind;
-	argv += optind;
-
 	if (!system_wide) {
 		open_counters(-1, target_pid != -1 ? target_pid : 0);
 	} else for (i = 0; i < nr_cpus; i++)
@@ -575,7 +384,7 @@ int cmd_record(int argc, char * const argv[])
 			perror("failed to fork");
 
 		if (!pid) {
-			if (execvp(argv[0], argv)) {
+			if (execvp(argv[0], (char **)argv)) {
 				perror(argv[0]);
 				exit(-1);
 			}
@@ -610,3 +419,170 @@ int cmd_record(int argc, char * const argv[])
 
 	return 0;
 }
+
+struct event_symbol {
+	__u64 event;
+	char *symbol;
+};
+
+static struct event_symbol event_symbols[] = {
+	{EID(PERF_TYPE_HARDWARE, PERF_COUNT_CPU_CYCLES),		"cpu-cycles",		},
+	{EID(PERF_TYPE_HARDWARE, PERF_COUNT_CPU_CYCLES),		"cycles",		},
+	{EID(PERF_TYPE_HARDWARE, PERF_COUNT_INSTRUCTIONS),		"instructions",		},
+	{EID(PERF_TYPE_HARDWARE, PERF_COUNT_CACHE_REFERENCES),		"cache-references",	},
+	{EID(PERF_TYPE_HARDWARE, PERF_COUNT_CACHE_MISSES),		"cache-misses",		},
+	{EID(PERF_TYPE_HARDWARE, PERF_COUNT_BRANCH_INSTRUCTIONS),	"branch-instructions",	},
+	{EID(PERF_TYPE_HARDWARE, PERF_COUNT_BRANCH_INSTRUCTIONS),	"branches",		},
+	{EID(PERF_TYPE_HARDWARE, PERF_COUNT_BRANCH_MISSES),		"branch-misses",	},
+	{EID(PERF_TYPE_HARDWARE, PERF_COUNT_BUS_CYCLES),		"bus-cycles",		},
+
+	{EID(PERF_TYPE_SOFTWARE, PERF_COUNT_CPU_CLOCK),			"cpu-clock",		},
+	{EID(PERF_TYPE_SOFTWARE, PERF_COUNT_TASK_CLOCK),		"task-clock",		},
+	{EID(PERF_TYPE_SOFTWARE, PERF_COUNT_PAGE_FAULTS),		"page-faults",		},
+	{EID(PERF_TYPE_SOFTWARE, PERF_COUNT_PAGE_FAULTS),		"faults",		},
+	{EID(PERF_TYPE_SOFTWARE, PERF_COUNT_PAGE_FAULTS_MIN),		"minor-faults",		},
+	{EID(PERF_TYPE_SOFTWARE, PERF_COUNT_PAGE_FAULTS_MAJ),		"major-faults",		},
+	{EID(PERF_TYPE_SOFTWARE, PERF_COUNT_CONTEXT_SWITCHES),		"context-switches",	},
+	{EID(PERF_TYPE_SOFTWARE, PERF_COUNT_CONTEXT_SWITCHES),		"cs",			},
+	{EID(PERF_TYPE_SOFTWARE, PERF_COUNT_CPU_MIGRATIONS),		"cpu-migrations",	},
+	{EID(PERF_TYPE_SOFTWARE, PERF_COUNT_CPU_MIGRATIONS),		"migrations",		},
+};
+
+/*
+ * Each event can have multiple symbolic names.
+ * Symbolic names are (almost) exactly matched.
+ */
+static __u64 match_event_symbols(const char *str)
+{
+	__u64 config, id;
+	int type;
+	unsigned int i;
+
+	if (sscanf(str, "r%llx", &config) == 1)
+		return config | PERF_COUNTER_RAW_MASK;
+
+	if (sscanf(str, "%d:%llu", &type, &id) == 2)
+		return EID(type, id);
+
+	for (i = 0; i < ARRAY_SIZE(event_symbols); i++) {
+		if (!strncmp(str, event_symbols[i].symbol,
+			     strlen(event_symbols[i].symbol)))
+			return event_symbols[i].event;
+	}
+
+	return ~0ULL;
+}
+
+static int parse_events(const struct option *opt, const char *str, int unset)
+{
+	__u64 config;
+
+again:
+	if (nr_counters == MAX_COUNTERS)
+		return -1;
+
+	config = match_event_symbols(str);
+	if (config == ~0ULL)
+		return -1;
+
+	event_id[nr_counters] = config;
+	nr_counters++;
+
+	str = strstr(str, ",");
+	if (str) {
+		str++;
+		goto again;
+	}
+
+	return 0;
+}
+
+static char events_help[100000];
+
+#define __PERF_COUNTER_FIELD(config, name) \
+	((config & PERF_COUNTER_##name##_MASK) >> PERF_COUNTER_##name##_SHIFT)
+
+#define PERF_COUNTER_RAW(config)	__PERF_COUNTER_FIELD(config, RAW)
+#define PERF_COUNTER_CONFIG(config)	__PERF_COUNTER_FIELD(config, CONFIG)
+#define PERF_COUNTER_TYPE(config)	__PERF_COUNTER_FIELD(config, TYPE)
+#define PERF_COUNTER_ID(config)		__PERF_COUNTER_FIELD(config, EVENT)
+
+
+
+static void create_events_help(void)
+{
+	unsigned int i;
+	char *str;
+	__u64 e;
+
+	str = events_help;
+
+	str += sprintf(str,
+	"event name: [");
+
+	for (i = 0; i < ARRAY_SIZE(event_symbols); i++) {
+		int type, id;
+
+		e = event_symbols[i].event;
+		type = PERF_COUNTER_TYPE(e);
+		id = PERF_COUNTER_ID(e);
+
+		if (i)
+			str += sprintf(str, "|");
+
+		str += sprintf(str, "%s",
+				event_symbols[i].symbol);
+	}
+
+	str += sprintf(str, "|rNNN]");
+}
+
+static const char * const record_usage[] = {
+	"perf record [<options>] <command>",
+	NULL
+};
+
+const struct option options[] = {
+	OPT_CALLBACK('e', "event", NULL, "event",
+		     events_help, parse_events),
+	OPT_INTEGER('c', "count", &default_interval,
+		    "event period to sample"),
+	OPT_INTEGER('m', "mmap-pages", &mmap_pages,
+		    "number of mmap data pages"),
+	OPT_STRING('o', "output", &output_name, "file",
+		    "output file name"),
+	OPT_BOOLEAN('i', "inherit", &inherit,
+		    "child tasks inherit counters"),
+	OPT_INTEGER('p', "pid", &target_pid,
+		    "record events on existing pid"),
+	OPT_INTEGER('r', "realtime", &realtime_prio,
+		    "collect data with this RT SCHED_FIFO priority"),
+	OPT_BOOLEAN('a', "all-cpus", &system_wide,
+			    "system-wide collection from all CPUs"),
+	OPT_END()
+};
+
+int cmd_record(int argc, const char **argv, const char *prefix)
+{
+	int counter;
+
+	create_events_help();
+
+	argc = parse_options(argc, argv, options, record_usage, 0);
+	if (!argc)
+		usage_with_options(record_usage, options);
+
+	if (!nr_counters) {
+		nr_counters = 1;
+		event_id[0] = 0;
+	}
+
+	for (counter = 0; counter < nr_counters; counter++) {
+		if (event_count[counter])
+			continue;
+
+		event_count[counter] = default_interval;
+	}
+
+	return __cmd_record(argc, argv);
+}
diff --git a/Documentation/perf_counter/builtin-top.c b/Documentation/perf_counter/builtin-top.c
index 4bed265..626b320 100644
--- a/Documentation/perf_counter/builtin-top.c
+++ b/Documentation/perf_counter/builtin-top.c
@@ -42,13 +42,16 @@
   * Released under the GPL v2. (and only v2, not any later version)
   */
 
+
 #include "perf.h"
 #include "util/util.h"
 
 #include <getopt.h>
 #include <assert.h>
 #include <fcntl.h>
+
 #include <stdio.h>
+
 #include <errno.h>
 #include <time.h>
 #include <sched.h>
