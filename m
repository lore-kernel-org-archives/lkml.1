Return-Path: <linux-kernel-owner+w=401wt.eu-S1755289AbZEZKgV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755289AbZEZKgV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 May 2009 06:36:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751998AbZEZKgM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 May 2009 06:36:12 -0400
Received: from hera.kernel.org ([140.211.167.34]:49402 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752578AbZEZKgK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 May 2009 06:36:10 -0400
Date: Tue, 26 May 2009 10:34:27 GMT
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
Subject: [tip:perfcounters/core] perf_counter tools: Librarize event string parsing
Message-ID: <tip-8ad8db3788fd9a449941fb2392ca85af4ee1cde1@git.kernel.org>
Git-Commit-ID: 8ad8db3788fd9a449941fb2392ca85af4ee1cde1
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 26 May 2009 10:34:28 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  8ad8db3788fd9a449941fb2392ca85af4ee1cde1
Gitweb:     http://git.kernel.org/tip/8ad8db3788fd9a449941fb2392ca85af4ee1cde1
Author:     Ingo Molnar <mingo@elte.hu>
AuthorDate: Tue, 26 May 2009 11:10:09 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 26 May 2009 11:26:34 +0200

perf_counter tools: Librarize event string parsing

Extract the event string parser from builtin-record.c, and
librarize it - to be reused in other commands.

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
 Documentation/perf_counter/Makefile            |    2 +
 Documentation/perf_counter/builtin-record.c    |  154 +-----------------------
 Documentation/perf_counter/util/parse-events.c |  127 +++++++++++++++++++
 Documentation/perf_counter/util/parse-events.h |   10 ++
 4 files changed, 145 insertions(+), 148 deletions(-)

diff --git a/Documentation/perf_counter/Makefile b/Documentation/perf_counter/Makefile
index 481e4c2..45daa72 100644
--- a/Documentation/perf_counter/Makefile
+++ b/Documentation/perf_counter/Makefile
@@ -290,6 +290,7 @@ LIB_H += ../../include/linux/perf_counter.h
 LIB_H += perf.h
 LIB_H += util/levenshtein.h
 LIB_H += util/parse-options.h
+LIB_H += util/parse-events.h
 LIB_H += util/quote.h
 LIB_H += util/util.h
 LIB_H += util/help.h
@@ -304,6 +305,7 @@ LIB_OBJS += util/exec_cmd.o
 LIB_OBJS += util/help.o
 LIB_OBJS += util/levenshtein.o
 LIB_OBJS += util/parse-options.o
+LIB_OBJS += util/parse-events.o
 LIB_OBJS += util/path.o
 LIB_OBJS += util/run-command.o
 LIB_OBJS += util/quote.o
diff --git a/Documentation/perf_counter/builtin-record.c b/Documentation/perf_counter/builtin-record.c
index f12a782..6fa6ed6 100644
--- a/Documentation/perf_counter/builtin-record.c
+++ b/Documentation/perf_counter/builtin-record.c
@@ -3,44 +3,17 @@
 #include "perf.h"
 #include "util/util.h"
 #include "util/parse-options.h"
+#include "util/parse-events.h"
 #include "util/exec_cmd.h"
 
-#include <sys/types.h>
-#include <sys/stat.h>
-#include <sys/time.h>
-#include <unistd.h>
-#include <stdint.h>
-#include <stdlib.h>
-#include <string.h>
-#include <limits.h>
-#include <assert.h>
-#include <fcntl.h>
-#include <stdio.h>
-#include <errno.h>
-#include <time.h>
 #include <sched.h>
-#include <pthread.h>
-
-#include <sys/syscall.h>
-#include <sys/ioctl.h>
-#include <sys/poll.h>
-#include <sys/prctl.h>
-#include <sys/wait.h>
-#include <sys/uio.h>
-#include <sys/mman.h>
-
-#include <linux/unistd.h>
-#include <linux/types.h>
-
-
 
 #define ALIGN(x, a)		__ALIGN_MASK(x, (typeof(x))(a)-1)
 #define __ALIGN_MASK(x, mask)	(((x)+(mask))&~(mask))
 
-static int			nr_counters			=  0;
-static __u64			event_id[MAX_COUNTERS]		= { };
 static int			default_interval = 100000;
 static int			event_count[MAX_COUNTERS];
+
 static int			fd[MAX_NR_CPUS][MAX_COUNTERS];
 static int			nr_cpus				=  0;
 static unsigned int		page_size;
@@ -420,131 +393,16 @@ static int __cmd_record(int argc, const char **argv)
 	return 0;
 }
 
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
-static __u64 match_event_symbols(const char *str)
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
-static int parse_events(const struct option *opt, const char *str, int unset)
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
-static char events_help[100000];
-
-#define __PERF_COUNTER_FIELD(config, name) \
-	((config & PERF_COUNTER_##name##_MASK) >> PERF_COUNTER_##name##_SHIFT)
-
-#define PERF_COUNTER_RAW(config)	__PERF_COUNTER_FIELD(config, RAW)
-#define PERF_COUNTER_CONFIG(config)	__PERF_COUNTER_FIELD(config, CONFIG)
-#define PERF_COUNTER_TYPE(config)	__PERF_COUNTER_FIELD(config, TYPE)
-#define PERF_COUNTER_ID(config)		__PERF_COUNTER_FIELD(config, EVENT)
-
-
-
-static void create_events_help(void)
-{
-	unsigned int i;
-	char *str;
-	__u64 e;
-
-	str = events_help;
-
-	str += sprintf(str,
-	"event name: [");
-
-	for (i = 0; i < ARRAY_SIZE(event_symbols); i++) {
-		int type, id;
-
-		e = event_symbols[i].event;
-		type = PERF_COUNTER_TYPE(e);
-		id = PERF_COUNTER_ID(e);
-
-		if (i)
-			str += sprintf(str, "|");
-
-		str += sprintf(str, "%s",
-				event_symbols[i].symbol);
-	}
-
-	str += sprintf(str, "|rNNN]");
-}
-
 static const char * const record_usage[] = {
 	"perf record [<options>] <command>",
 	NULL
 };
 
+static char events_help_msg[EVENTS_HELP_MAX];
+
 const struct option options[] = {
 	OPT_CALLBACK('e', "event", NULL, "event",
-		     events_help, parse_events),
+		     events_help_msg, parse_events),
 	OPT_INTEGER('c', "count", &default_interval,
 		    "event period to sample"),
 	OPT_INTEGER('m', "mmap-pages", &mmap_pages,
@@ -566,7 +424,7 @@ int cmd_record(int argc, const char **argv, const char *prefix)
 {
 	int counter;
 
-	create_events_help();
+	create_events_help(events_help_msg);
 
 	argc = parse_options(argc, argv, options, record_usage, 0);
 	if (!argc)
diff --git a/Documentation/perf_counter/util/parse-events.c b/Documentation/perf_counter/util/parse-events.c
new file mode 100644
index 0000000..77d0917
--- /dev/null
+++ b/Documentation/perf_counter/util/parse-events.c
@@ -0,0 +1,127 @@
+
+#include "../perf.h"
+#include "util.h"
+#include "parse-options.h"
+#include "parse-events.h"
+#include "exec_cmd.h"
+
+int nr_counters;
+
+__u64			event_id[MAX_COUNTERS]		= { };
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
+int parse_events(const struct option *opt, const char *str, int unset)
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
+#define __PERF_COUNTER_FIELD(config, name) \
+	((config & PERF_COUNTER_##name##_MASK) >> PERF_COUNTER_##name##_SHIFT)
+
+#define PERF_COUNTER_RAW(config)	__PERF_COUNTER_FIELD(config, RAW)
+#define PERF_COUNTER_CONFIG(config)	__PERF_COUNTER_FIELD(config, CONFIG)
+#define PERF_COUNTER_TYPE(config)	__PERF_COUNTER_FIELD(config, TYPE)
+#define PERF_COUNTER_ID(config)		__PERF_COUNTER_FIELD(config, EVENT)
+
+/*
+ * Create the help text for the event symbols:
+ */
+void create_events_help(char *events_help_msg)
+{
+	unsigned int i;
+	char *str;
+	__u64 e;
+
+	str = events_help_msg;
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
diff --git a/Documentation/perf_counter/util/parse-events.h b/Documentation/perf_counter/util/parse-events.h
new file mode 100644
index 0000000..6e2ebe5
--- /dev/null
+++ b/Documentation/perf_counter/util/parse-events.h
@@ -0,0 +1,10 @@
+
+extern int nr_counters;
+extern __u64			event_id[MAX_COUNTERS];
+
+extern int parse_events(const struct option *opt, const char *str, int unset);
+
+#define EVENTS_HELP_MAX (128*1024)
+
+extern void create_events_help(char *help_msg);
+
