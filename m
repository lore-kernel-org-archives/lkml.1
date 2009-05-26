Return-Path: <linux-kernel-owner+w=401wt.eu-S1755495AbZEZLha@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755495AbZEZLha (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 May 2009 07:37:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753998AbZEZLhX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 May 2009 07:37:23 -0400
Received: from hera.kernel.org ([140.211.167.34]:55472 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753731AbZEZLhV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 May 2009 07:37:21 -0400
Date: Tue, 26 May 2009 11:36:33 GMT
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
Subject: [tip:perfcounters/core] perf top: Convert to Git option parsing
Message-ID: <tip-b456bae0ff4f3cf91639dd32b2bfc49b1c30b4b0@git.kernel.org>
Git-Commit-ID: b456bae0ff4f3cf91639dd32b2bfc49b1c30b4b0
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 26 May 2009 11:36:34 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  b456bae0ff4f3cf91639dd32b2bfc49b1c30b4b0
Gitweb:     http://git.kernel.org/tip/b456bae0ff4f3cf91639dd32b2bfc49b1c30b4b0
Author:     Ingo Molnar <mingo@elte.hu>
AuthorDate: Tue, 26 May 2009 09:17:18 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 26 May 2009 12:33:04 +0200

perf top: Convert to Git option parsing

Remove getopt usage and use Git's much more advanced and more compact
command option library.

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
 Documentation/perf_counter/builtin-top.c |  559 ++++++------------------------
 1 files changed, 105 insertions(+), 454 deletions(-)

diff --git a/Documentation/perf_counter/builtin-top.c b/Documentation/perf_counter/builtin-top.c
index 626b320..87b925c 100644
--- a/Documentation/perf_counter/builtin-top.c
+++ b/Documentation/perf_counter/builtin-top.c
@@ -45,8 +45,10 @@
 
 #include "perf.h"
 #include "util/util.h"
+#include "util/util.h"
+#include "util/parse-options.h"
+#include "util/parse-events.h"
 
-#include <getopt.h>
 #include <assert.h>
 #include <fcntl.h>
 
@@ -70,8 +72,7 @@
 
 static int			system_wide			=  0;
 
-static int			nr_counters			=  0;
-static __u64			event_id[MAX_COUNTERS]		= {
+static __u64			default_event_id[MAX_COUNTERS]		= {
 	EID(PERF_TYPE_SOFTWARE, PERF_COUNT_TASK_CLOCK),
 	EID(PERF_TYPE_SOFTWARE, PERF_COUNT_CONTEXT_SWITCHES),
 	EID(PERF_TYPE_SOFTWARE, PERF_COUNT_CPU_MIGRATIONS),
@@ -88,7 +89,7 @@ static int			fd[MAX_NR_CPUS][MAX_COUNTERS];
 
 static __u64			count_filter		       = 100;
 
-static int			tid				= -1;
+static int			target_pid				= -1;
 static int			profile_cpu			= -1;
 static int			nr_cpus				=  0;
 static int			nmi				=  1;
@@ -100,8 +101,6 @@ static int			use_mmap			= 0;
 static int			use_munmap			= 0;
 static int			freq				= 0;
 
-static char			*vmlinux;
-
 static char			*sym_filter;
 static unsigned long		filter_start;
 static unsigned long		filter_end;
@@ -110,18 +109,6 @@ static int			delay_secs			=  2;
 static int			zero;
 static int			dump_symtab;
 
-static int			scale;
-
-struct source_line {
-	uint64_t		EIP;
-	unsigned long		count;
-	char			*line;
-	struct source_line	*next;
-};
-
-static struct source_line	*lines;
-static struct source_line	**lines_tail;
-
 static const unsigned int default_count[] = {
 	1000000,
 	1000000,
@@ -131,194 +118,6 @@ static const unsigned int default_count[] = {
 	  10000,
 };
 
-static char *hw_event_names[] = {
-	"CPU cycles",
-	"instructions",
-	"cache references",
-	"cache misses",
-	"branches",
-	"branch misses",
-	"bus cycles",
-};
-
-static char *sw_event_names[] = {
-	"cpu clock ticks",
-	"task clock ticks",
-	"pagefaults",
-	"context switches",
-	"CPU migrations",
-	"minor faults",
-	"major faults",
-};
-
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
-	"Usage: kerneltop [<options>]\n"
-	"   Or: kerneltop -S [<options>] COMMAND [ARGS]\n\n"
-	"KernelTop Options (up to %d event types can be specified at once):\n\n",
-		 MAX_COUNTERS);
-
-	display_events_help();
-
-	printf(
-	" -c CNT    --count=CNT        # event period to sample\n\n"
-	" -C CPU    --cpu=CPU          # CPU (-1 for all)                 [default: -1]\n"
-	" -p PID    --pid=PID          # PID of sampled task (-1 for all) [default: -1]\n\n"
-	" -l                           # show scale factor for RR events\n"
-	" -d delay  --delay=<seconds>  # sampling/display delay           [default:  2]\n"
-	" -f CNT    --filter=CNT       # min-event-count filter          [default: 100]\n\n"
-	" -r prio   --realtime=<prio>  # event acquisition runs with SCHED_FIFO policy\n"
-	" -s symbol --symbol=<symbol>  # function to be showed annotated one-shot\n"
-	" -x path   --vmlinux=<path>   # the vmlinux binary, required for -s use\n"
-	" -z        --zero             # zero counts after display\n"
-	" -D        --dump_symtab      # dump symbol table to stderr on startup\n"
-	" -m pages  --mmap_pages=<pages> # number of mmap data pages\n"
-	" -M        --mmap_info        # print mmap info stream\n"
-	" -U        --munmap_info      # print munmap info stream\n"
-	);
-
-	exit(0);
-}
-
-static char *event_name(int ctr)
-{
-	__u64 config = event_id[ctr];
-	int type = PERF_COUNTER_TYPE(config);
-	int id = PERF_COUNTER_ID(config);
-	static char buf[32];
-
-	if (PERF_COUNTER_RAW(config)) {
-		sprintf(buf, "raw 0x%llx", PERF_COUNTER_CONFIG(config));
-		return buf;
-	}
-
-	switch (type) {
-	case PERF_TYPE_HARDWARE:
-		if (id < PERF_HW_EVENTS_MAX)
-			return hw_event_names[id];
-		return "unknown-hardware";
-
-	case PERF_TYPE_SOFTWARE:
-		if (id < PERF_SW_EVENTS_MAX)
-			return sw_event_names[id];
-		return "unknown-software";
-
-	default:
-		break;
-	}
-
-	return "unknown";
-}
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
 /*
  * Symbols
  */
@@ -331,7 +130,6 @@ struct sym_entry {
 	char			*sym;
 	unsigned long		count[MAX_COUNTERS];
 	int			skip;
-	struct source_line	*source;
 };
 
 #define MAX_SYMS		100000
@@ -342,8 +140,6 @@ struct sym_entry		*sym_filter_entry;
 
 static struct sym_entry		sym_table[MAX_SYMS];
 
-static void show_details(struct sym_entry *sym);
-
 /*
  * Ordering weight: count-1 * count-2 * ... / count-n
  */
@@ -419,15 +215,15 @@ static void print_sym_table(void)
 
 	printf( "], ");
 
-	if (tid != -1)
-		printf(" (tid: %d", tid);
+	if (target_pid != -1)
+		printf(" (target_pid: %d", target_pid);
 	else
 		printf(" (all");
 
 	if (profile_cpu != -1)
 		printf(", cpu: %d)\n", profile_cpu);
 	else {
-		if (tid != -1)
+		if (target_pid != -1)
 			printf(")\n");
 		else
 			printf(", %d CPUs)\n", nr_cpus);
@@ -463,9 +259,6 @@ static void print_sym_table(void)
 				pcnt, tmp[i].addr, tmp[i].sym);
 	}
 
-	if (sym_filter_entry)
-		show_details(sym_filter_entry);
-
 	{
 		struct pollfd stdin_poll = { .fd = 0, .events = POLLIN };
 
@@ -628,134 +421,8 @@ static void parse_symbols(void)
 	}
 }
 
-/*
- * Source lines
- */
-
-static void parse_vmlinux(char *filename)
-{
-	FILE *file;
-	char command[PATH_MAX*2];
-	if (!filename)
-		return;
-
-	sprintf(command, "objdump --start-address=0x%016lx --stop-address=0x%016lx -dS %s", filter_start, filter_end, filename);
-
-	file = popen(command, "r");
-	if (!file)
-		return;
-
-	lines_tail = &lines;
-	while (!feof(file)) {
-		struct source_line *src;
-		size_t dummy = 0;
-		char *c;
-
-		src = malloc(sizeof(struct source_line));
-		assert(src != NULL);
-		memset(src, 0, sizeof(struct source_line));
-
-		if (getline(&src->line, &dummy, file) < 0)
-			break;
-		if (!src->line)
-			break;
-
-		c = strchr(src->line, '\n');
-		if (c)
-			*c = 0;
-
-		src->next = NULL;
-		*lines_tail = src;
-		lines_tail = &src->next;
-
-		if (strlen(src->line)>8 && src->line[8] == ':')
-			src->EIP = strtoull(src->line, NULL, 16);
-		if (strlen(src->line)>8 && src->line[16] == ':')
-			src->EIP = strtoull(src->line, NULL, 16);
-	}
-	pclose(file);
-}
-
-static void record_precise_ip(uint64_t ip)
-{
-	struct source_line *line;
-
-	for (line = lines; line; line = line->next) {
-		if (line->EIP == ip)
-			line->count++;
-		if (line->EIP > ip)
-			break;
-	}
-}
-
-static void lookup_sym_in_vmlinux(struct sym_entry *sym)
-{
-	struct source_line *line;
-	char pattern[PATH_MAX];
-	sprintf(pattern, "<%s>:", sym->sym);
-
-	for (line = lines; line; line = line->next) {
-		if (strstr(line->line, pattern)) {
-			sym->source = line;
-			break;
-		}
-	}
-}
-
-static void show_lines(struct source_line *line_queue, int line_queue_count)
-{
-	int i;
-	struct source_line *line;
-
-	line = line_queue;
-	for (i = 0; i < line_queue_count; i++) {
-		printf("%8li\t%s\n", line->count, line->line);
-		line = line->next;
-	}
-}
-
 #define TRACE_COUNT     3
 
-static void show_details(struct sym_entry *sym)
-{
-	struct source_line *line;
-	struct source_line *line_queue = NULL;
-	int displayed = 0;
-	int line_queue_count = 0;
-
-	if (!sym->source)
-		lookup_sym_in_vmlinux(sym);
-	if (!sym->source)
-		return;
-
-	printf("Showing details for %s\n", sym->sym);
-
-	line = sym->source;
-	while (line) {
-		if (displayed && strstr(line->line, ">:"))
-			break;
-
-		if (!line_queue_count)
-			line_queue = line;
-		line_queue_count ++;
-
-		if (line->count >= count_filter) {
-			show_lines(line_queue, line_queue_count);
-			line_queue_count = 0;
-			line_queue = NULL;
-		} else if (line_queue_count > TRACE_COUNT) {
-			line_queue = line_queue->next;
-			line_queue_count --;
-		}
-
-		line->count = 0;
-		displayed++;
-		if (displayed > 300)
-			break;
-		line = line->next;
-	}
-}
-
 /*
  * Binary search in the histogram table and record the hit:
  */
@@ -764,8 +431,6 @@ static void record_ip(uint64_t ip, int counter)
 	int left_idx, middle_idx, right_idx, idx;
 	unsigned long left, middle, right;
 
-	record_precise_ip(ip);
-
 	left_idx = 0;
 	right_idx = sym_table_count-1;
 	assert(ip <= max_ip && ip >= min_ip);
@@ -822,97 +487,6 @@ static void process_event(uint64_t ip, int counter)
 	record_ip(ip, counter);
 }
 
-static void process_options(int argc, char **argv)
-{
-	int error = 0, counter;
-
-	for (;;) {
-		int option_index = 0;
-		/** Options for getopt */
-		static struct option long_options[] = {
-			{"count",	required_argument,	NULL, 'c'},
-			{"cpu",		required_argument,	NULL, 'C'},
-			{"delay",	required_argument,	NULL, 'd'},
-			{"dump_symtab",	no_argument,		NULL, 'D'},
-			{"event",	required_argument,	NULL, 'e'},
-			{"filter",	required_argument,	NULL, 'f'},
-			{"group",	required_argument,	NULL, 'g'},
-			{"help",	no_argument,		NULL, 'h'},
-			{"nmi",		required_argument,	NULL, 'n'},
-			{"mmap_info",	no_argument,		NULL, 'M'},
-			{"mmap_pages",	required_argument,	NULL, 'm'},
-			{"munmap_info",	no_argument,		NULL, 'U'},
-			{"pid",		required_argument,	NULL, 'p'},
-			{"realtime",	required_argument,	NULL, 'r'},
-			{"scale",	no_argument,		NULL, 'l'},
-			{"symbol",	required_argument,	NULL, 's'},
-			{"stat",	no_argument,		NULL, 'S'},
-			{"vmlinux",	required_argument,	NULL, 'x'},
-			{"zero",	no_argument,		NULL, 'z'},
-			{"freq",	required_argument,	NULL, 'F'},
-			{NULL,		0,			NULL,  0 }
-		};
-		int c = getopt_long(argc, argv, "+:ac:C:d:De:f:g:hln:m:p:r:s:Sx:zMUF:",
-				    long_options, &option_index);
-		if (c == -1)
-			break;
-
-		switch (c) {
-		case 'a': system_wide			=	       1; break;
-		case 'c': default_interval		=   atoi(optarg); break;
-		case 'C':
-			/* CPU and PID are mutually exclusive */
-			if (tid != -1) {
-				printf("WARNING: CPU switch overriding PID\n");
-				sleep(1);
-				tid = -1;
-			}
-			profile_cpu			=   atoi(optarg); break;
-		case 'd': delay_secs			=   atoi(optarg); break;
-		case 'D': dump_symtab			=              1; break;
-
-		case 'e': error				= parse_events(optarg); break;
-
-		case 'f': count_filter			=   atoi(optarg); break;
-		case 'g': group				=   atoi(optarg); break;
-		case 'h':      				  display_help(); break;
-		case 'l': scale				=	       1; break;
-		case 'n': nmi				=   atoi(optarg); break;
-		case 'p':
-			/* CPU and PID are mutually exclusive */
-			if (profile_cpu != -1) {
-				printf("WARNING: PID switch overriding CPU\n");
-				sleep(1);
-				profile_cpu = -1;
-			}
-			tid				=   atoi(optarg); break;
-		case 'r': realtime_prio			=   atoi(optarg); break;
-		case 's': sym_filter			= strdup(optarg); break;
-		case 'x': vmlinux			= strdup(optarg); break;
-		case 'z': zero				=              1; break;
-		case 'm': mmap_pages			=   atoi(optarg); break;
-		case 'M': use_mmap			=              1; break;
-		case 'U': use_munmap			=              1; break;
-		case 'F': freq = 1; default_interval	=   atoi(optarg); break;
-		default: error = 1; break;
-		}
-	}
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
@@ -973,11 +547,11 @@ static void mmap_read(struct mmap_data *md)
 		struct ip_event {
 			struct perf_event_header header;
 			__u64 ip;
-			__u32 pid, tid;
+			__u32 pid, target_pid;
 		};
 		struct mmap_event {
 			struct perf_event_header header;
-			__u32 pid, tid;
+			__u32 pid, target_pid;
 			__u64 start;
 			__u64 len;
 			__u64 pgoff;
@@ -1043,7 +617,7 @@ static void mmap_read(struct mmap_data *md)
 static struct pollfd event_array[MAX_NR_CPUS * MAX_COUNTERS];
 static struct mmap_data mmap_array[MAX_NR_CPUS][MAX_COUNTERS];
 
-int cmd_top(int argc, char **argv, const char *prefix)
+static int __cmd_top(void)
 {
 	struct perf_counter_hw_event hw_event;
 	pthread_t thread;
@@ -1051,27 +625,12 @@ int cmd_top(int argc, char **argv, const char *prefix)
 	unsigned int cpu;
 	int ret;
 
-	page_size = sysconf(_SC_PAGE_SIZE);
-
-	process_options(argc, argv);
-
-	nr_cpus = sysconf(_SC_NPROCESSORS_ONLN);
-	assert(nr_cpus <= MAX_NR_CPUS);
-	assert(nr_cpus >= 0);
-
-	if (tid != -1 || profile_cpu != -1)
-		nr_cpus = 1;
-
-	parse_symbols();
-	if (vmlinux && sym_filter_entry)
-		parse_vmlinux(vmlinux);
-
 	for (i = 0; i < nr_cpus; i++) {
 		group_fd = -1;
 		for (counter = 0; counter < nr_counters; counter++) {
 
 			cpu	= profile_cpu;
-			if (tid == -1 && profile_cpu == -1)
+			if (target_pid == -1 && profile_cpu == -1)
 				cpu = i;
 
 			memset(&hw_event, 0, sizeof(hw_event));
@@ -1083,7 +642,7 @@ int cmd_top(int argc, char **argv, const char *prefix)
 			hw_event.munmap		= use_munmap;
 			hw_event.freq		= freq;
 
-			fd[i][counter] = sys_perf_counter_open(&hw_event, tid, cpu, group_fd, 0);
+			fd[i][counter] = sys_perf_counter_open(&hw_event, target_pid, cpu, group_fd, 0);
 			if (fd[i][counter] < 0) {
 				int err = errno;
 				printf("kerneltop error: syscall returned with %d (%s)\n",
@@ -1147,3 +706,95 @@ int cmd_top(int argc, char **argv, const char *prefix)
 
 	return 0;
 }
+
+static const char * const top_usage[] = {
+	"perf top [<options>]",
+	NULL
+};
+
+static char events_help_msg[EVENTS_HELP_MAX];
+
+static const struct option options[] = {
+	OPT_CALLBACK('e', "event", NULL, "event",
+		     events_help_msg, parse_events),
+	OPT_INTEGER('c', "count", &default_interval,
+		    "event period to sample"),
+	OPT_INTEGER('p', "pid", &target_pid,
+		    "profile events on existing pid"),
+	OPT_BOOLEAN('a', "all-cpus", &system_wide,
+			    "system-wide collection from all CPUs"),
+	OPT_INTEGER('C', "CPU", &profile_cpu,
+		    "CPU to profile on"),
+	OPT_INTEGER('m', "mmap-pages", &mmap_pages,
+		    "number of mmap data pages"),
+	OPT_INTEGER('r', "realtime", &realtime_prio,
+		    "collect data with this RT SCHED_FIFO priority"),
+	OPT_INTEGER('d', "delay", &realtime_prio,
+		    "number of seconds to delay between refreshes"),
+	OPT_BOOLEAN('D', "dump-symtab", &dump_symtab,
+			    "dump the symbol table used for profiling"),
+	OPT_INTEGER('f', "--count-filter", &count_filter,
+		    "only display functions with more events than this"),
+	OPT_BOOLEAN('g', "group", &group,
+			    "put the counters into a counter group"),
+	OPT_STRING('s', "sym-filter", &sym_filter, "pattern",
+		    "only display symbols matchig this pattern"),
+	OPT_BOOLEAN('z', "zero", &group,
+		    "zero history across updates"),
+	OPT_BOOLEAN('M', "use-mmap", &use_mmap,
+		    "track mmap events"),
+	OPT_BOOLEAN('U', "use-munmap", &use_munmap,
+		    "track munmap events"),
+	OPT_INTEGER('F', "--freq", &freq,
+		    "profile at this frequency"),
+	OPT_END()
+};
+
+int cmd_top(int argc, const char **argv, const char *prefix)
+{
+	int counter;
+
+	page_size = sysconf(_SC_PAGE_SIZE);
+
+	create_events_help(events_help_msg);
+	memcpy(event_id, default_event_id, sizeof(default_event_id));
+
+	argc = parse_options(argc, argv, options, top_usage, 0);
+	if (argc)
+		usage_with_options(top_usage, options);
+
+	if (freq) {
+		default_interval = freq;
+		freq = 1;
+	}
+
+	/* CPU and PID are mutually exclusive */
+	if (target_pid != -1 && profile_cpu != -1) {
+		printf("WARNING: PID switch overriding CPU\n");
+		sleep(1);
+		profile_cpu = -1;
+	}
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
+	nr_cpus = sysconf(_SC_NPROCESSORS_ONLN);
+	assert(nr_cpus <= MAX_NR_CPUS);
+	assert(nr_cpus >= 0);
+
+	if (target_pid != -1 || profile_cpu != -1)
+		nr_cpus = 1;
+
+	parse_symbols();
+
+	return __cmd_top();
+}
