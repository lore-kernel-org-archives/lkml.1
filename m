Return-Path: <linux-kernel-owner+w=401wt.eu-S1753826AbZFFJrE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753826AbZFFJrE (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Jun 2009 05:47:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751462AbZFFJqy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 6 Jun 2009 05:46:54 -0400
Received: from hera.kernel.org ([140.211.167.34]:46656 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750792AbZFFJqu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Jun 2009 05:46:50 -0400
Date: Sat, 6 Jun 2009 09:46:14 GMT
From: tip-bot for Ingo Molnar <mingo@elte.hu>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, paulus@samba.org,
       hpa@zytor.com, mingo@redhat.com, a.p.zijlstra@chello.nl, efault@gmx.de,
       mtosatti@redhat.com, tglx@linutronix.de, cjashfor@linux.vnet.ibm.com,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org, acme@redhat.com,
       linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl, efault@gmx.de,
       mtosatti@redhat.com, tglx@linutronix.de, cjashfor@linux.vnet.ibm.com,
       mingo@elte.hu
In-Reply-To: <new-submission>
References: <new-submission>
Subject: [tip:perfcounters/core] perf_counter: Separate out attr->type from attr->config
Message-ID: <tip-a21ca2cac582886a3e95c8bb84ff7c52d4d15e54@git.kernel.org>
Git-Commit-ID: a21ca2cac582886a3e95c8bb84ff7c52d4d15e54
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Sat, 06 Jun 2009 09:46:16 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  a21ca2cac582886a3e95c8bb84ff7c52d4d15e54
Gitweb:     http://git.kernel.org/tip/a21ca2cac582886a3e95c8bb84ff7c52d4d15e54
Author:     Ingo Molnar <mingo@elte.hu>
AuthorDate: Sat, 6 Jun 2009 09:58:57 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sat, 6 Jun 2009 11:37:22 +0200

perf_counter: Separate out attr->type from attr->config

Counter type is a frequently used value and we do a lot of
bit juggling by encoding and decoding it from attr->config.

Clean this up by creating a separate attr->type field.

Also clean up the various similarly complex user-space bits
all around counter attribute management.

The net improvement is significant, and it will be easier
to add a new major type (which is what triggered this cleanup).

(This changes the ABI, all tools are adapted.)
(PowerPC build-tested.)

Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Marcelo Tosatti <mtosatti@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
LKML-Reference: <new-submission>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 Documentation/perf_counter/builtin-record.c    |  105 +++++++++------------
 Documentation/perf_counter/builtin-stat.c      |   76 ++++++---------
 Documentation/perf_counter/builtin-top.c       |   67 +++++---------
 Documentation/perf_counter/perf.h              |    2 -
 Documentation/perf_counter/util/parse-events.c |  120 +++++++++++++-----------
 Documentation/perf_counter/util/parse-events.h |    7 +-
 arch/powerpc/kernel/perf_counter.c             |    6 +-
 arch/x86/kernel/cpu/perf_counter.c             |    8 +-
 include/linux/perf_counter.h                   |   65 +++----------
 kernel/perf_counter.c                          |   14 +--
 10 files changed, 196 insertions(+), 274 deletions(-)

diff --git a/Documentation/perf_counter/builtin-record.c b/Documentation/perf_counter/builtin-record.c
index c22ea0c..130fd88 100644
--- a/Documentation/perf_counter/builtin-record.c
+++ b/Documentation/perf_counter/builtin-record.c
@@ -20,10 +20,10 @@
 #define ALIGN(x, a)		__ALIGN_MASK(x, (typeof(x))(a)-1)
 #define __ALIGN_MASK(x, mask)	(((x)+(mask))&~(mask))
 
-static long			default_interval = 100000;
-static long			event_count[MAX_COUNTERS];
-
 static int			fd[MAX_NR_CPUS][MAX_COUNTERS];
+
+static long			default_interval		= 100000;
+
 static int			nr_cpus				= 0;
 static unsigned int		page_size;
 static unsigned int		mmap_pages			= 128;
@@ -38,22 +38,44 @@ static int			inherit				= 1;
 static int			force				= 0;
 static int			append_file			= 0;
 
-const unsigned int default_count[] = {
-	1000000,
-	1000000,
-	  10000,
-	  10000,
-	1000000,
-	  10000,
+static long			samples;
+static struct timeval		last_read;
+static struct timeval		this_read;
+
+static __u64			bytes_written;
+
+static struct pollfd		event_array[MAX_NR_CPUS * MAX_COUNTERS];
+
+static int			nr_poll;
+static int			nr_cpu;
+
+struct mmap_event {
+	struct perf_event_header	header;
+	__u32				pid;
+	__u32				tid;
+	__u64				start;
+	__u64				len;
+	__u64				pgoff;
+	char				filename[PATH_MAX];
+};
+
+struct comm_event {
+	struct perf_event_header	header;
+	__u32				pid;
+	__u32				tid;
+	char				comm[16];
 };
 
+
 struct mmap_data {
-	int counter;
-	void *base;
-	unsigned int mask;
-	unsigned int prev;
+	int			counter;
+	void			*base;
+	unsigned int		mask;
+	unsigned int		prev;
 };
 
+static struct mmap_data		mmap_array[MAX_NR_CPUS][MAX_COUNTERS];
+
 static unsigned int mmap_read_head(struct mmap_data *md)
 {
 	struct perf_counter_mmap_page *pc = md->base;
@@ -65,11 +87,6 @@ static unsigned int mmap_read_head(struct mmap_data *md)
 	return head;
 }
 
-static long samples;
-static struct timeval last_read, this_read;
-
-static __u64 bytes_written;
-
 static void mmap_read(struct mmap_data *md)
 {
 	unsigned int head = mmap_read_head(md);
@@ -157,29 +174,6 @@ static void sig_handler(int sig)
 	done = 1;
 }
 
-static struct pollfd event_array[MAX_NR_CPUS * MAX_COUNTERS];
-static struct mmap_data mmap_array[MAX_NR_CPUS][MAX_COUNTERS];
-
-static int nr_poll;
-static int nr_cpu;
-
-struct mmap_event {
-	struct perf_event_header	header;
-	__u32				pid;
-	__u32				tid;
-	__u64				start;
-	__u64				len;
-	__u64				pgoff;
-	char				filename[PATH_MAX];
-};
-
-struct comm_event {
-	struct perf_event_header	header;
-	__u32				pid;
-	__u32				tid;
-	char				comm[16];
-};
-
 static void pid_synthesize_comm_event(pid_t pid, int full)
 {
 	struct comm_event comm_ev;
@@ -341,24 +335,21 @@ static int group_fd;
 
 static void create_counter(int counter, int cpu, pid_t pid)
 {
-	struct perf_counter_attr attr;
+	struct perf_counter_attr *attr = attrs + counter;
 	int track = 1;
 
-	memset(&attr, 0, sizeof(attr));
-	attr.config		= event_id[counter];
-	attr.sample_period	= event_count[counter];
-	attr.sample_type	= PERF_SAMPLE_IP | PERF_SAMPLE_TID | PERF_SAMPLE_PERIOD;
+	attr->sample_type	= PERF_SAMPLE_IP | PERF_SAMPLE_TID | PERF_SAMPLE_PERIOD;
 	if (freq) {
-		attr.freq		= 1;
-		attr.sample_freq	= freq;
+		attr->freq		= 1;
+		attr->sample_freq	= freq;
 	}
-	attr.mmap		= track;
-	attr.comm		= track;
-	attr.inherit		= (cpu < 0) && inherit;
+	attr->mmap		= track;
+	attr->comm		= track;
+	attr->inherit		= (cpu < 0) && inherit;
 
 	track = 0; /* only the first counter needs these */
 
-	fd[nr_cpu][counter] = sys_perf_counter_open(&attr, pid, cpu, group_fd, 0);
+	fd[nr_cpu][counter] = sys_perf_counter_open(attr, pid, cpu, group_fd, 0);
 
 	if (fd[nr_cpu][counter] < 0) {
 		int err = errno;
@@ -542,16 +533,14 @@ int cmd_record(int argc, const char **argv, const char *prefix)
 	if (!argc && target_pid == -1 && !system_wide)
 		usage_with_options(record_usage, options);
 
-	if (!nr_counters) {
+	if (!nr_counters)
 		nr_counters = 1;
-		event_id[0] = 0;
-	}
 
 	for (counter = 0; counter < nr_counters; counter++) {
-		if (event_count[counter])
+		if (attrs[counter].sample_period)
 			continue;
 
-		event_count[counter] = default_interval;
+		attrs[counter].sample_period = default_interval;
 	}
 
 	return __cmd_record(argc, argv);
diff --git a/Documentation/perf_counter/builtin-stat.c b/Documentation/perf_counter/builtin-stat.c
index 4fc0d80..9711e55 100644
--- a/Documentation/perf_counter/builtin-stat.c
+++ b/Documentation/perf_counter/builtin-stat.c
@@ -44,23 +44,22 @@
 
 #include <sys/prctl.h>
 
-static int			system_wide			=  0;
-static int			inherit				=  1;
+static struct perf_counter_attr default_attrs[MAX_COUNTERS] = {
 
-static __u64			default_event_id[MAX_COUNTERS]	= {
-	EID(PERF_TYPE_SOFTWARE, PERF_COUNT_TASK_CLOCK),
-	EID(PERF_TYPE_SOFTWARE, PERF_COUNT_CONTEXT_SWITCHES),
-	EID(PERF_TYPE_SOFTWARE, PERF_COUNT_CPU_MIGRATIONS),
-	EID(PERF_TYPE_SOFTWARE, PERF_COUNT_PAGE_FAULTS),
+  { .type = PERF_TYPE_SOFTWARE, .config = PERF_COUNT_TASK_CLOCK		},
+  { .type = PERF_TYPE_SOFTWARE, .config = PERF_COUNT_CONTEXT_SWITCHES	},
+  { .type = PERF_TYPE_SOFTWARE, .config = PERF_COUNT_CPU_MIGRATIONS	},
+  { .type = PERF_TYPE_SOFTWARE, .config = PERF_COUNT_PAGE_FAULTS	},
 
-	EID(PERF_TYPE_HARDWARE, PERF_COUNT_CPU_CYCLES),
-	EID(PERF_TYPE_HARDWARE, PERF_COUNT_INSTRUCTIONS),
-	EID(PERF_TYPE_HARDWARE, PERF_COUNT_CACHE_REFERENCES),
-	EID(PERF_TYPE_HARDWARE, PERF_COUNT_CACHE_MISSES),
+  { .type = PERF_TYPE_HARDWARE, .config = PERF_COUNT_CPU_CYCLES		},
+  { .type = PERF_TYPE_HARDWARE, .config = PERF_COUNT_INSTRUCTIONS	},
+  { .type = PERF_TYPE_HARDWARE, .config = PERF_COUNT_CACHE_REFERENCES	},
+  { .type = PERF_TYPE_HARDWARE, .config = PERF_COUNT_CACHE_MISSES	},
 };
 
-static int			default_interval = 100000;
-static int			event_count[MAX_COUNTERS];
+static int			system_wide			=  0;
+static int			inherit				=  1;
+
 static int			fd[MAX_NR_CPUS][MAX_COUNTERS];
 
 static int			target_pid			= -1;
@@ -86,22 +85,16 @@ static __u64			walltime_nsecs;
 
 static void create_perfstat_counter(int counter)
 {
-	struct perf_counter_attr attr;
-
-	memset(&attr, 0, sizeof(attr));
-	attr.config		= event_id[counter];
-	attr.sample_type	= 0;
-	attr.exclude_kernel = event_mask[counter] & EVENT_MASK_KERNEL;
-	attr.exclude_user   = event_mask[counter] & EVENT_MASK_USER;
+	struct perf_counter_attr *attr = attrs + counter;
 
 	if (scale)
-		attr.read_format	= PERF_FORMAT_TOTAL_TIME_ENABLED |
-					  PERF_FORMAT_TOTAL_TIME_RUNNING;
+		attr->read_format = PERF_FORMAT_TOTAL_TIME_ENABLED |
+				    PERF_FORMAT_TOTAL_TIME_RUNNING;
 
 	if (system_wide) {
 		int cpu;
 		for (cpu = 0; cpu < nr_cpus; cpu ++) {
-			fd[cpu][counter] = sys_perf_counter_open(&attr, -1, cpu, -1, 0);
+			fd[cpu][counter] = sys_perf_counter_open(attr, -1, cpu, -1, 0);
 			if (fd[cpu][counter] < 0) {
 				printf("perfstat error: syscall returned with %d (%s)\n",
 						fd[cpu][counter], strerror(errno));
@@ -109,10 +102,10 @@ static void create_perfstat_counter(int counter)
 			}
 		}
 	} else {
-		attr.inherit	= inherit;
-		attr.disabled	= 1;
+		attr->inherit	= inherit;
+		attr->disabled	= 1;
 
-		fd[0][counter] = sys_perf_counter_open(&attr, 0, -1, -1, 0);
+		fd[0][counter] = sys_perf_counter_open(attr, 0, -1, -1, 0);
 		if (fd[0][counter] < 0) {
 			printf("perfstat error: syscall returned with %d (%s)\n",
 					fd[0][counter], strerror(errno));
@@ -126,9 +119,13 @@ static void create_perfstat_counter(int counter)
  */
 static inline int nsec_counter(int counter)
 {
-	if (event_id[counter] == EID(PERF_TYPE_SOFTWARE, PERF_COUNT_CPU_CLOCK))
+	if (attrs[counter].type != PERF_TYPE_SOFTWARE)
+		return 0;
+
+	if (attrs[counter].config == PERF_COUNT_CPU_CLOCK)
 		return 1;
-	if (event_id[counter] == EID(PERF_TYPE_SOFTWARE, PERF_COUNT_TASK_CLOCK))
+
+	if (attrs[counter].config == PERF_COUNT_TASK_CLOCK)
 		return 1;
 
 	return 0;
@@ -177,7 +174,8 @@ static void read_counter(int counter)
 	/*
 	 * Save the full runtime - to allow normalization during printout:
 	 */
-	if (event_id[counter] == EID(PERF_TYPE_SOFTWARE, PERF_COUNT_TASK_CLOCK))
+	if (attrs[counter].type == PERF_TYPE_SOFTWARE &&
+		attrs[counter].config == PERF_COUNT_TASK_CLOCK)
 		runtime_nsecs = count[0];
 }
 
@@ -203,8 +201,8 @@ static void print_counter(int counter)
 
 		fprintf(stderr, " %14.6f  %-20s",
 			msecs, event_name(counter));
-		if (event_id[counter] ==
-				EID(PERF_TYPE_SOFTWARE, PERF_COUNT_TASK_CLOCK)) {
+		if (attrs[counter].type == PERF_TYPE_SOFTWARE &&
+			attrs[counter].config == PERF_COUNT_TASK_CLOCK) {
 
 			fprintf(stderr, " # %11.3f CPU utilization factor",
 				(double)count[0] / (double)walltime_nsecs);
@@ -300,8 +298,6 @@ static char events_help_msg[EVENTS_HELP_MAX];
 static const struct option options[] = {
 	OPT_CALLBACK('e', "event", NULL, "event",
 		     events_help_msg, parse_events),
-	OPT_INTEGER('c', "count", &default_interval,
-		    "event period to sample"),
 	OPT_BOOLEAN('i', "inherit", &inherit,
 		    "child tasks inherit counters"),
 	OPT_INTEGER('p', "pid", &target_pid,
@@ -315,27 +311,19 @@ static const struct option options[] = {
 
 int cmd_stat(int argc, const char **argv, const char *prefix)
 {
-	int counter;
-
 	page_size = sysconf(_SC_PAGE_SIZE);
 
 	create_events_help(events_help_msg);
-	memcpy(event_id, default_event_id, sizeof(default_event_id));
+
+	memcpy(attrs, default_attrs, sizeof(attrs));
 
 	argc = parse_options(argc, argv, options, stat_usage, 0);
 	if (!argc)
 		usage_with_options(stat_usage, options);
 
-	if (!nr_counters) {
+	if (!nr_counters)
 		nr_counters = 8;
-	}
-
-	for (counter = 0; counter < nr_counters; counter++) {
-		if (event_count[counter])
-			continue;
 
-		event_count[counter] = default_interval;
-	}
 	nr_cpus = sysconf(_SC_NPROCESSORS_ONLN);
 	assert(nr_cpus <= MAX_NR_CPUS);
 	assert(nr_cpus >= 0);
diff --git a/Documentation/perf_counter/builtin-top.c b/Documentation/perf_counter/builtin-top.c
index b2f480b..98a6d53 100644
--- a/Documentation/perf_counter/builtin-top.c
+++ b/Documentation/perf_counter/builtin-top.c
@@ -48,22 +48,11 @@
 #include <linux/unistd.h>
 #include <linux/types.h>
 
-static int			system_wide			=  0;
+static int			fd[MAX_NR_CPUS][MAX_COUNTERS];
 
-static __u64			default_event_id[MAX_COUNTERS]		= {
-	EID(PERF_TYPE_SOFTWARE, PERF_COUNT_TASK_CLOCK),
-	EID(PERF_TYPE_SOFTWARE, PERF_COUNT_CONTEXT_SWITCHES),
-	EID(PERF_TYPE_SOFTWARE, PERF_COUNT_CPU_MIGRATIONS),
-	EID(PERF_TYPE_SOFTWARE, PERF_COUNT_PAGE_FAULTS),
+static int			system_wide			=  0;
 
-	EID(PERF_TYPE_HARDWARE, PERF_COUNT_CPU_CYCLES),
-	EID(PERF_TYPE_HARDWARE, PERF_COUNT_INSTRUCTIONS),
-	EID(PERF_TYPE_HARDWARE, PERF_COUNT_CACHE_REFERENCES),
-	EID(PERF_TYPE_HARDWARE, PERF_COUNT_CACHE_MISSES),
-};
-static int			default_interval = 100000;
-static int			event_count[MAX_COUNTERS];
-static int			fd[MAX_NR_CPUS][MAX_COUNTERS];
+static int			default_interval		= 100000;
 
 static __u64			count_filter			=  5;
 static int			print_entries			= 15;
@@ -85,15 +74,6 @@ static int			delay_secs			=  2;
 static int			zero;
 static int			dump_symtab;
 
-static const unsigned int default_count[] = {
-	1000000,
-	1000000,
-	  10000,
-	  10000,
-	1000000,
-	  10000,
-};
-
 /*
  * Symbols
  */
@@ -112,7 +92,7 @@ struct sym_entry {
 
 struct sym_entry		*sym_filter_entry;
 
-struct dso *kernel_dso;
+struct dso			*kernel_dso;
 
 /*
  * Symbols will be added here in record_ip and will get out
@@ -213,7 +193,7 @@ static void print_sym_table(void)
 		100.0 - (100.0*((samples_per_sec-ksamples_per_sec)/samples_per_sec)));
 
 	if (nr_counters == 1) {
-		printf("%d", event_count[0]);
+		printf("%Ld", attrs[0].sample_period);
 		if (freq)
 			printf("Hz ");
 		else
@@ -421,10 +401,10 @@ static void process_event(uint64_t ip, int counter)
 }
 
 struct mmap_data {
-	int counter;
-	void *base;
-	unsigned int mask;
-	unsigned int prev;
+	int			counter;
+	void			*base;
+	unsigned int		mask;
+	unsigned int		prev;
 };
 
 static unsigned int mmap_read_head(struct mmap_data *md)
@@ -539,7 +519,7 @@ static struct mmap_data mmap_array[MAX_NR_CPUS][MAX_COUNTERS];
 
 static int __cmd_top(void)
 {
-	struct perf_counter_attr attr;
+	struct perf_counter_attr *attr;
 	pthread_t thread;
 	int i, counter, group_fd, nr_poll = 0;
 	unsigned int cpu;
@@ -553,13 +533,12 @@ static int __cmd_top(void)
 			if (target_pid == -1 && profile_cpu == -1)
 				cpu = i;
 
-			memset(&attr, 0, sizeof(attr));
-			attr.config		= event_id[counter];
-			attr.sample_period	= event_count[counter];
-			attr.sample_type	= PERF_SAMPLE_IP | PERF_SAMPLE_TID;
-			attr.freq		= freq;
+			attr = attrs + counter;
 
-			fd[i][counter] = sys_perf_counter_open(&attr, target_pid, cpu, group_fd, 0);
+			attr->sample_type	= PERF_SAMPLE_IP | PERF_SAMPLE_TID;
+			attr->freq		= freq;
+
+			fd[i][counter] = sys_perf_counter_open(attr, target_pid, cpu, group_fd, 0);
 			if (fd[i][counter] < 0) {
 				int err = errno;
 
@@ -670,7 +649,6 @@ int cmd_top(int argc, const char **argv, const char *prefix)
 	page_size = sysconf(_SC_PAGE_SIZE);
 
 	create_events_help(events_help_msg);
-	memcpy(event_id, default_event_id, sizeof(default_event_id));
 
 	argc = parse_options(argc, argv, options, top_usage, 0);
 	if (argc)
@@ -688,19 +666,22 @@ int cmd_top(int argc, const char **argv, const char *prefix)
 		profile_cpu = -1;
 	}
 
-	if (!nr_counters) {
+	if (!nr_counters)
 		nr_counters = 1;
-		event_id[0] = 0;
-	}
 
 	if (delay_secs < 1)
 		delay_secs = 1;
 
+	parse_symbols();
+
+	/*
+	 * Fill in the ones not specifically initialized via -c:
+	 */
 	for (counter = 0; counter < nr_counters; counter++) {
-		if (event_count[counter])
+		if (attrs[counter].sample_period)
 			continue;
 
-		event_count[counter] = default_interval;
+		attrs[counter].sample_period = default_interval;
 	}
 
 	nr_cpus = sysconf(_SC_NPROCESSORS_ONLN);
@@ -710,7 +691,5 @@ int cmd_top(int argc, const char **argv, const char *prefix)
 	if (target_pid != -1 || profile_cpu != -1)
 		nr_cpus = 1;
 
-	parse_symbols();
-
 	return __cmd_top();
 }
diff --git a/Documentation/perf_counter/perf.h b/Documentation/perf_counter/perf.h
index 10622a4..af0a504 100644
--- a/Documentation/perf_counter/perf.h
+++ b/Documentation/perf_counter/perf.h
@@ -64,6 +64,4 @@ sys_perf_counter_open(struct perf_counter_attr *attr_uptr,
 #define MAX_COUNTERS			256
 #define MAX_NR_CPUS			256
 
-#define EID(type, id) (((__u64)(type) << PERF_COUNTER_TYPE_SHIFT) | (id))
-
 #endif
diff --git a/Documentation/perf_counter/util/parse-events.c b/Documentation/perf_counter/util/parse-events.c
index 2fdfd1d..eb56bd9 100644
--- a/Documentation/perf_counter/util/parse-events.c
+++ b/Documentation/perf_counter/util/parse-events.c
@@ -6,37 +6,39 @@
 #include "exec_cmd.h"
 #include "string.h"
 
-int nr_counters;
+int					nr_counters;
 
-__u64			event_id[MAX_COUNTERS]		= { };
-int			event_mask[MAX_COUNTERS];
+struct perf_counter_attr		attrs[MAX_COUNTERS];
 
 struct event_symbol {
-	__u64 event;
-	char *symbol;
+	__u8	type;
+	__u64	config;
+	char	*symbol;
 };
 
+#define C(x, y) .type = PERF_TYPE_##x, .config = PERF_COUNT_##y
+
 static struct event_symbol event_symbols[] = {
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
+  { C(HARDWARE, CPU_CYCLES),		"cpu-cycles",		},
+  { C(HARDWARE, CPU_CYCLES),		"cycles",		},
+  { C(HARDWARE, INSTRUCTIONS),		"instructions",		},
+  { C(HARDWARE, CACHE_REFERENCES),	"cache-references",	},
+  { C(HARDWARE, CACHE_MISSES),		"cache-misses",		},
+  { C(HARDWARE, BRANCH_INSTRUCTIONS),	"branch-instructions",	},
+  { C(HARDWARE, BRANCH_INSTRUCTIONS),	"branches",		},
+  { C(HARDWARE, BRANCH_MISSES),		"branch-misses",	},
+  { C(HARDWARE, BUS_CYCLES),		"bus-cycles",		},
+
+  { C(SOFTWARE, CPU_CLOCK),		"cpu-clock",		},
+  { C(SOFTWARE, TASK_CLOCK),		"task-clock",		},
+  { C(SOFTWARE, PAGE_FAULTS),		"page-faults",		},
+  { C(SOFTWARE, PAGE_FAULTS),		"faults",		},
+  { C(SOFTWARE, PAGE_FAULTS_MIN),	"minor-faults",		},
+  { C(SOFTWARE, PAGE_FAULTS_MAJ),	"major-faults",		},
+  { C(SOFTWARE, CONTEXT_SWITCHES),	"context-switches",	},
+  { C(SOFTWARE, CONTEXT_SWITCHES),	"cs",			},
+  { C(SOFTWARE, CPU_MIGRATIONS),	"cpu-migrations",	},
+  { C(SOFTWARE, CPU_MIGRATIONS),	"migrations",		},
 };
 
 #define __PERF_COUNTER_FIELD(config, name) \
@@ -67,27 +69,26 @@ static char *sw_event_names[] = {
 	"major faults",
 };
 
-char *event_name(int ctr)
+char *event_name(int counter)
 {
-	__u64 config = event_id[ctr];
-	int type = PERF_COUNTER_TYPE(config);
-	int id = PERF_COUNTER_ID(config);
+	__u64 config = attrs[counter].config;
+	int type = attrs[counter].type;
 	static char buf[32];
 
-	if (PERF_COUNTER_RAW(config)) {
-		sprintf(buf, "raw 0x%llx", PERF_COUNTER_CONFIG(config));
+	if (attrs[counter].type == PERF_TYPE_RAW) {
+		sprintf(buf, "raw 0x%llx", config);
 		return buf;
 	}
 
 	switch (type) {
 	case PERF_TYPE_HARDWARE:
-		if (id < PERF_HW_EVENTS_MAX)
-			return hw_event_names[id];
+		if (config < PERF_HW_EVENTS_MAX)
+			return hw_event_names[config];
 		return "unknown-hardware";
 
 	case PERF_TYPE_SOFTWARE:
-		if (id < PERF_SW_EVENTS_MAX)
-			return sw_event_names[id];
+		if (config < PERF_SW_EVENTS_MAX)
+			return sw_event_names[config];
 		return "unknown-software";
 
 	default:
@@ -101,15 +102,19 @@ char *event_name(int ctr)
  * Each event can have multiple symbolic names.
  * Symbolic names are (almost) exactly matched.
  */
-static __u64 match_event_symbols(const char *str)
+static int match_event_symbols(const char *str, struct perf_counter_attr *attr)
 {
 	__u64 config, id;
 	int type;
 	unsigned int i;
 	const char *sep, *pstr;
 
-	if (str[0] == 'r' && hex2u64(str + 1, &config) > 0)
-		return config | PERF_COUNTER_RAW_MASK;
+	if (str[0] == 'r' && hex2u64(str + 1, &config) > 0) {
+		attr->type = PERF_TYPE_RAW;
+		attr->config = config;
+
+		return 0;
+	}
 
 	pstr = str;
 	sep = strchr(pstr, ':');
@@ -121,35 +126,45 @@ static __u64 match_event_symbols(const char *str)
 		if (sep) {
 			pstr = sep + 1;
 			if (strchr(pstr, 'k'))
-				event_mask[nr_counters] |= EVENT_MASK_USER;
+				attr->exclude_user = 1;
 			if (strchr(pstr, 'u'))
-				event_mask[nr_counters] |= EVENT_MASK_KERNEL;
+				attr->exclude_kernel = 1;
 		}
-		return EID(type, id);
+		attr->type = type;
+		attr->config = id;
+
+		return 0;
 	}
 
 	for (i = 0; i < ARRAY_SIZE(event_symbols); i++) {
 		if (!strncmp(str, event_symbols[i].symbol,
-			     strlen(event_symbols[i].symbol)))
-			return event_symbols[i].event;
+			     strlen(event_symbols[i].symbol))) {
+
+			attr->type = event_symbols[i].type;
+			attr->config = event_symbols[i].config;
+
+			return 0;
+		}
 	}
 
-	return ~0ULL;
+	return -EINVAL;
 }
 
 int parse_events(const struct option *opt, const char *str, int unset)
 {
-	__u64 config;
+	struct perf_counter_attr attr;
+	int ret;
 
+	memset(&attr, 0, sizeof(attr));
 again:
 	if (nr_counters == MAX_COUNTERS)
 		return -1;
 
-	config = match_event_symbols(str);
-	if (config == ~0ULL)
-		return -1;
+	ret = match_event_symbols(str, &attr);
+	if (ret < 0)
+		return ret;
 
-	event_id[nr_counters] = config;
+	attrs[nr_counters] = attr;
 	nr_counters++;
 
 	str = strstr(str, ",");
@@ -168,7 +183,6 @@ void create_events_help(char *events_help_msg)
 {
 	unsigned int i;
 	char *str;
-	__u64 e;
 
 	str = events_help_msg;
 
@@ -178,9 +192,8 @@ void create_events_help(char *events_help_msg)
 	for (i = 0; i < ARRAY_SIZE(event_symbols); i++) {
 		int type, id;
 
-		e = event_symbols[i].event;
-		type = PERF_COUNTER_TYPE(e);
-		id = PERF_COUNTER_ID(e);
+		type = event_symbols[i].type;
+		id = event_symbols[i].config;
 
 		if (i)
 			str += sprintf(str, "|");
@@ -191,4 +204,3 @@ void create_events_help(char *events_help_msg)
 
 	str += sprintf(str, "|rNNN]");
 }
-
diff --git a/Documentation/perf_counter/util/parse-events.h b/Documentation/perf_counter/util/parse-events.h
index 0da306b..542971c 100644
--- a/Documentation/perf_counter/util/parse-events.h
+++ b/Documentation/perf_counter/util/parse-events.h
@@ -3,12 +3,9 @@
  * Parse symbolic events/counts passed in as options:
  */
 
-extern int nr_counters;
-extern __u64			event_id[MAX_COUNTERS];
-extern int			event_mask[MAX_COUNTERS];
+extern int			nr_counters;
 
-#define EVENT_MASK_KERNEL	1
-#define EVENT_MASK_USER		2
+extern struct perf_counter_attr attrs[MAX_COUNTERS];
 
 extern char *event_name(int ctr);
 
diff --git a/arch/powerpc/kernel/perf_counter.c b/arch/powerpc/kernel/perf_counter.c
index 232b00a..4786ad9 100644
--- a/arch/powerpc/kernel/perf_counter.c
+++ b/arch/powerpc/kernel/perf_counter.c
@@ -867,13 +867,13 @@ const struct pmu *hw_perf_counter_init(struct perf_counter *counter)
 
 	if (!ppmu)
 		return ERR_PTR(-ENXIO);
-	if (!perf_event_raw(&counter->attr)) {
-		ev = perf_event_id(&counter->attr);
+	if (counter->attr.type != PERF_TYPE_RAW) {
+		ev = counter->attr.config;
 		if (ev >= ppmu->n_generic || ppmu->generic_events[ev] == 0)
 			return ERR_PTR(-EOPNOTSUPP);
 		ev = ppmu->generic_events[ev];
 	} else {
-		ev = perf_event_config(&counter->attr);
+		ev = counter->attr.config;
 	}
 	counter->hw.config_base = ev;
 	counter->hw.idx = 0;
diff --git a/arch/x86/kernel/cpu/perf_counter.c b/arch/x86/kernel/cpu/perf_counter.c
index 8f53f3a..430e048 100644
--- a/arch/x86/kernel/cpu/perf_counter.c
+++ b/arch/x86/kernel/cpu/perf_counter.c
@@ -292,15 +292,15 @@ static int __hw_perf_counter_init(struct perf_counter *counter)
 	/*
 	 * Raw event type provide the config in the event structure
 	 */
-	if (perf_event_raw(attr)) {
-		hwc->config |= x86_pmu.raw_event(perf_event_config(attr));
+	if (attr->type == PERF_TYPE_RAW) {
+		hwc->config |= x86_pmu.raw_event(attr->config);
 	} else {
-		if (perf_event_id(attr) >= x86_pmu.max_events)
+		if (attr->config >= x86_pmu.max_events)
 			return -EINVAL;
 		/*
 		 * The generic map:
 		 */
-		hwc->config |= x86_pmu.event_map(perf_event_id(attr));
+		hwc->config |= x86_pmu.event_map(attr->config);
 	}
 
 	counter->destroy = hw_perf_counter_destroy;
diff --git a/include/linux/perf_counter.h b/include/linux/perf_counter.h
index 4f9d39e..f794c69 100644
--- a/include/linux/perf_counter.h
+++ b/include/linux/perf_counter.h
@@ -73,26 +73,6 @@ enum sw_event_ids {
 	PERF_SW_EVENTS_MAX		= 7,
 };
 
-#define __PERF_COUNTER_MASK(name)			\
-	(((1ULL << PERF_COUNTER_##name##_BITS) - 1) <<	\
-	 PERF_COUNTER_##name##_SHIFT)
-
-#define PERF_COUNTER_RAW_BITS		1
-#define PERF_COUNTER_RAW_SHIFT		63
-#define PERF_COUNTER_RAW_MASK		__PERF_COUNTER_MASK(RAW)
-
-#define PERF_COUNTER_CONFIG_BITS	63
-#define PERF_COUNTER_CONFIG_SHIFT	0
-#define PERF_COUNTER_CONFIG_MASK	__PERF_COUNTER_MASK(CONFIG)
-
-#define PERF_COUNTER_TYPE_BITS		7
-#define PERF_COUNTER_TYPE_SHIFT		56
-#define PERF_COUNTER_TYPE_MASK		__PERF_COUNTER_MASK(TYPE)
-
-#define PERF_COUNTER_EVENT_BITS		56
-#define PERF_COUNTER_EVENT_SHIFT	0
-#define PERF_COUNTER_EVENT_MASK		__PERF_COUNTER_MASK(EVENT)
-
 /*
  * Bits that can be set in attr.sample_type to request information
  * in the overflow packets.
@@ -125,10 +105,13 @@ enum perf_counter_read_format {
  */
 struct perf_counter_attr {
 	/*
-	 * The MSB of the config word signifies if the rest contains cpu
-	 * specific (raw) counter configuration data, if unset, the next
-	 * 7 bits are an event type and the rest of the bits are the event
-	 * identifier.
+	 * Major type: hardware/software/tracepoint/etc.
+	 */
+	__u32			type;
+	__u32			__reserved_1;
+
+	/*
+	 * Type specific configuration information.
 	 */
 	__u64			config;
 
@@ -152,12 +135,11 @@ struct perf_counter_attr {
 				comm	       :  1, /* include comm data     */
 				freq           :  1, /* use freq, not period  */
 
-				__reserved_1   : 53;
+				__reserved_2   : 53;
 
 	__u32			wakeup_events;	/* wakeup every n events */
-	__u32			__reserved_2;
+	__u32			__reserved_3;
 
-	__u64			__reserved_3;
 	__u64			__reserved_4;
 };
 
@@ -278,8 +260,8 @@ enum perf_event_type {
 
 	/*
 	 * struct {
-	 * 	struct perf_event_header	header;
-	 * 	u32				pid, ppid;
+	 *	struct perf_event_header	header;
+	 *	u32				pid, ppid;
 	 * };
 	 */
 	PERF_EVENT_FORK			= 7,
@@ -331,27 +313,6 @@ enum perf_event_type {
 
 struct task_struct;
 
-static inline u64 perf_event_raw(struct perf_counter_attr *attr)
-{
-	return attr->config & PERF_COUNTER_RAW_MASK;
-}
-
-static inline u64 perf_event_config(struct perf_counter_attr *attr)
-{
-	return attr->config & PERF_COUNTER_CONFIG_MASK;
-}
-
-static inline u64 perf_event_type(struct perf_counter_attr *attr)
-{
-	return (attr->config & PERF_COUNTER_TYPE_MASK) >>
-		PERF_COUNTER_TYPE_SHIFT;
-}
-
-static inline u64 perf_event_id(struct perf_counter_attr *attr)
-{
-	return attr->config & PERF_COUNTER_EVENT_MASK;
-}
-
 /**
  * struct hw_perf_counter - performance counter hardware details:
  */
@@ -616,8 +577,8 @@ extern int perf_counter_overflow(struct perf_counter *counter,
  */
 static inline int is_software_counter(struct perf_counter *counter)
 {
-	return !perf_event_raw(&counter->attr) &&
-		perf_event_type(&counter->attr) != PERF_TYPE_HARDWARE;
+	return (counter->attr.type != PERF_TYPE_RAW) &&
+		(counter->attr.type != PERF_TYPE_HARDWARE);
 }
 
 extern void perf_swcounter_event(u32, u64, int, struct pt_regs *, u64);
diff --git a/kernel/perf_counter.c b/kernel/perf_counter.c
index 47c92fb..75ae767 100644
--- a/kernel/perf_counter.c
+++ b/kernel/perf_counter.c
@@ -3091,14 +3091,12 @@ static int perf_swcounter_match(struct perf_counter *counter,
 				enum perf_event_types type,
 				u32 event, struct pt_regs *regs)
 {
-	u64 event_config;
-
-	event_config = ((u64) type << PERF_COUNTER_TYPE_SHIFT) | event;
-
 	if (!perf_swcounter_is_counting(counter))
 		return 0;
 
-	if (counter->attr.config != event_config)
+	if (counter->attr.type != type)
+		return 0;
+	if (counter->attr.config != event)
 		return 0;
 
 	if (regs) {
@@ -3403,7 +3401,7 @@ static const struct pmu *sw_perf_counter_init(struct perf_counter *counter)
 	 * to be kernel events, and page faults are never hypervisor
 	 * events.
 	 */
-	switch (perf_event_id(&counter->attr)) {
+	switch (counter->attr.config) {
 	case PERF_COUNT_CPU_CLOCK:
 		pmu = &perf_ops_cpu_clock;
 
@@ -3496,12 +3494,12 @@ perf_counter_alloc(struct perf_counter_attr *attr,
 	if (attr->inherit && (attr->sample_type & PERF_SAMPLE_GROUP))
 		goto done;
 
-	if (perf_event_raw(attr)) {
+	if (attr->type == PERF_TYPE_RAW) {
 		pmu = hw_perf_counter_init(counter);
 		goto done;
 	}
 
-	switch (perf_event_type(attr)) {
+	switch (attr->type) {
 	case PERF_TYPE_HARDWARE:
 		pmu = hw_perf_counter_init(counter);
 		break;
