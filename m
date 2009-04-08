Return-Path: <linux-kernel-owner+w=401wt.eu-S1765491AbZDHNI6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765491AbZDHNI6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 09:08:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765335AbZDHNDm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 09:03:42 -0400
Received: from casper.infradead.org ([85.118.1.10]:48875 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765333AbZDHNDi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 09:03:38 -0400
Message-Id: <20090408130409.220518450@chello.nl>
References: <20090408130124.715559390@chello.nl>
User-Agent: quilt/0.46-1
Date: Wed, 08 Apr 2009 15:01:31 +0200
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>,
       Corey Ashford <cjashfor@linux.vnet.ibm.com>,
       linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Subject: [PATCH 7/9] perf_counter: some simple userspace profiling
Content-Disposition: inline; filename=perf-tools.patch
X-Bad-Reply: References but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 # perf-record make -j4 kernel/
 # perf-report | tail -15

  0.39              cc1 [kernel] lock_acquired
  0.42              cc1 [kernel] lock_acquire
  0.51              cc1 [ user ] /lib64/libc-2.8.90.so: _int_free
  0.51               as [kernel] clear_page_c
  0.53              cc1 [ user ] /lib64/libc-2.8.90.so: memcpy
  0.56              cc1 [ user ] /lib64/libc-2.8.90.so: _IO_vfprintf
  0.63              cc1 [kernel] lock_release
  0.67              cc1 [ user ] /lib64/libc-2.8.90.so: strlen
  0.68              cc1 [kernel] debug_smp_processor_id
  1.38              cc1 [ user ] /lib64/libc-2.8.90.so: _int_malloc
  1.55              cc1 [ user ] /lib64/libc-2.8.90.so: memset
  1.77              cc1 [kernel] __lock_acquire
  1.88              cc1 [kernel] clear_page_c
  3.61               as [ user ] /usr/bin/as: <unknown>
 59.16              cc1 [ user ] /usr/libexec/gcc/x86_64-redhat-linux/4.3.2/cc1: <unknown>

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
---
 Documentation/perf_counter/Makefile       |    8 
 Documentation/perf_counter/perf-record.c  |  530 ++++++++++++++++++++++++++++++
 Documentation/perf_counter/perf-report.cc |  472 ++++++++++++++++++++++++++
 3 files changed, 1009 insertions(+), 1 deletion(-)

Index: linux-2.6/Documentation/perf_counter/Makefile
===================================================================
--- linux-2.6.orig/Documentation/perf_counter/Makefile
+++ linux-2.6/Documentation/perf_counter/Makefile
@@ -1,10 +1,16 @@
-BINS = kerneltop perfstat
+BINS = kerneltop perfstat perf-record perf-report
 
 all: $(BINS)
 
 kerneltop: kerneltop.c ../../include/linux/perf_counter.h
 	cc -O6 -Wall -lrt -o $@ $<
 
+perf-record: perf-record.c ../../include/linux/perf_counter.h
+	cc -O6 -Wall -lrt -o $@ $<
+
+perf-report: perf-report.cc ../../include/linux/perf_counter.h
+	g++ -O6 -Wall -lrt -o $@ $<
+
 perfstat: kerneltop
 	ln -sf kerneltop perfstat
 
Index: linux-2.6/Documentation/perf_counter/perf-record.c
===================================================================
--- /dev/null
+++ linux-2.6/Documentation/perf_counter/perf-record.c
@@ -0,0 +1,530 @@
+
+
+#define _GNU_SOURCE
+#include <sys/types.h>
+#include <sys/stat.h>
+#include <sys/time.h>
+#include <unistd.h>
+#include <stdint.h>
+#include <stdlib.h>
+#include <string.h>
+#include <limits.h>
+#include <getopt.h>
+#include <assert.h>
+#include <fcntl.h>
+#include <stdio.h>
+#include <errno.h>
+#include <ctype.h>
+#include <time.h>
+#include <sched.h>
+#include <pthread.h>
+
+#include <sys/syscall.h>
+#include <sys/ioctl.h>
+#include <sys/poll.h>
+#include <sys/prctl.h>
+#include <sys/wait.h>
+#include <sys/uio.h>
+#include <sys/mman.h>
+
+#include <linux/unistd.h>
+#include <linux/types.h>
+
+#include "../../include/linux/perf_counter.h"
+
+
+/*
+ * prctl(PR_TASK_PERF_COUNTERS_DISABLE) will (cheaply) disable all
+ * counters in the current task.
+ */
+#define PR_TASK_PERF_COUNTERS_DISABLE   31
+#define PR_TASK_PERF_COUNTERS_ENABLE    32
+
+#define ARRAY_SIZE(x) (sizeof(x) / sizeof((x)[0]))
+
+#define rdclock()                                       \
+({                                                      \
+        struct timespec ts;                             \
+                                                        \
+        clock_gettime(CLOCK_MONOTONIC, &ts);            \
+        ts.tv_sec * 1000000000ULL + ts.tv_nsec;         \
+})
+
+/*
+ * Pick up some kernel type conventions:
+ */
+#define __user
+#define asmlinkage
+
+#ifdef __x86_64__
+#define __NR_perf_counter_open 295
+#define rmb()		asm volatile("lfence" ::: "memory")
+#define cpu_relax()	asm volatile("rep; nop" ::: "memory");
+#endif
+
+#ifdef __i386__
+#define __NR_perf_counter_open 333
+#define rmb()		asm volatile("lfence" ::: "memory")
+#define cpu_relax()	asm volatile("rep; nop" ::: "memory");
+#endif
+
+#ifdef __powerpc__
+#define __NR_perf_counter_open 319
+#define rmb() 		asm volatile ("sync" ::: "memory")
+#define cpu_relax()	asm volatile ("" ::: "memory");
+#endif
+
+#define unlikely(x)	__builtin_expect(!!(x), 0)
+#define min(x, y) ({				\
+	typeof(x) _min1 = (x);			\
+	typeof(y) _min2 = (y);			\
+	(void) (&_min1 == &_min2);		\
+	_min1 < _min2 ? _min1 : _min2; })
+
+asmlinkage int sys_perf_counter_open(
+        struct perf_counter_hw_event    *hw_event_uptr          __user,
+        pid_t                           pid,
+        int                             cpu,
+        int                             group_fd,
+        unsigned long                   flags)
+{
+        return syscall(
+                __NR_perf_counter_open, hw_event_uptr, pid, cpu, group_fd, flags);
+}
+
+#define MAX_COUNTERS			64
+#define MAX_NR_CPUS			256
+
+#define EID(type, id) (((__u64)(type) << PERF_COUNTER_TYPE_SHIFT) | (id))
+
+static int			nr_counters			=  0;
+static __u64			event_id[MAX_COUNTERS]		= { };
+static int			default_interval = 100000;
+static int			event_count[MAX_COUNTERS];
+static int			fd[MAX_NR_CPUS][MAX_COUNTERS];
+static int			nr_cpus				=  0;
+static unsigned int		page_size;
+static unsigned int		mmap_pages			= 16;
+static int			output;
+static char 			*output_name			= "output.perf";
+static int			group				= 0;
+static unsigned int		realtime_prio			=  0;
+
+const unsigned int default_count[] = {
+	1000000,
+	1000000,
+	  10000,
+	  10000,
+	1000000,
+	  10000,
+};
+
+static char *hw_event_names[] = {
+	"CPU cycles",
+	"instructions",
+	"cache references",
+	"cache misses",
+	"branches",
+	"branch misses",
+	"bus cycles",
+};
+
+static char *sw_event_names[] = {
+	"cpu clock ticks",
+	"task clock ticks",
+	"pagefaults",
+	"context switches",
+	"CPU migrations",
+	"minor faults",
+	"major faults",
+};
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
+static __u64 match_event_symbols(char *str)
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
+static int parse_events(char *str)
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
+static void display_events_help(void)
+{
+	unsigned int i;
+	__u64 e;
+
+	printf(
+	" -e EVENT     --event=EVENT   #  symbolic-name        abbreviations");
+
+	for (i = 0; i < ARRAY_SIZE(event_symbols); i++) {
+		int type, id;
+
+		e = event_symbols[i].event;
+		type = PERF_COUNTER_TYPE(e);
+		id = PERF_COUNTER_ID(e);
+
+		printf("\n                             %d:%d: %-20s",
+				type, id, event_symbols[i].symbol);
+	}
+
+	printf("\n"
+	"                           rNNN: raw PMU events (eventsel+umask)\n\n");
+}
+
+static void display_help(void)
+{
+	printf(
+	"Usage: perf-record [<options>]\n"
+	"perf-record Options (up to %d event types can be specified at once):\n\n",
+		 MAX_COUNTERS);
+
+	display_events_help();
+
+	printf(
+	" -c CNT    --count=CNT          # event period to sample\n"
+	" -m pages  --mmap_pages=<pages> # number of mmap data pages\n"
+	" -o file   --output=<file>      # output file\n"
+	" -r prio   --realtime=<prio>    # use RT prio\n"
+	);
+
+	exit(0);
+}
+
+static void process_options(int argc, char *argv[])
+{
+	int error = 0, counter;
+
+	for (;;) {
+		int option_index = 0;
+		/** Options for getopt */
+		static struct option long_options[] = {
+			{"count",	required_argument,	NULL, 'c'},
+			{"event",	required_argument,	NULL, 'e'},
+			{"mmap_pages",	required_argument,	NULL, 'm'},
+			{"output",	required_argument,	NULL, 'o'},
+			{"realtime",	required_argument,	NULL, 'r'},
+			{NULL,		0,			NULL,  0 }
+		};
+		int c = getopt_long(argc, argv, "+:c:e:m:o:r:",
+				    long_options, &option_index);
+		if (c == -1)
+			break;
+
+		switch (c) {
+		case 'c': default_interval		=   atoi(optarg); break;
+		case 'e': error				= parse_events(optarg); break;
+		case 'm': mmap_pages			=   atoi(optarg); break;
+		case 'o': output_name			= strdup(optarg); break;
+		case 'r': realtime_prio			=   atoi(optarg); break;
+		default: error = 1; break;
+		}
+	}
+	if (error)
+		display_help();
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
+}
+
+struct mmap_data {
+	int counter;
+	void *base;
+	unsigned int mask;
+	unsigned int prev;
+};
+
+static unsigned int mmap_read_head(struct mmap_data *md)
+{
+	struct perf_counter_mmap_page *pc = md->base;
+	int head;
+
+	head = pc->data_head;
+	rmb();
+
+	return head;
+}
+
+static long events;
+static struct timeval last_read, this_read;
+
+static void mmap_read(struct mmap_data *md)
+{
+	unsigned int head = mmap_read_head(md);
+	unsigned int old = md->prev;
+	unsigned char *data = md->base + page_size;
+	unsigned long size;
+	void *buf;
+	int diff;
+
+	gettimeofday(&this_read, NULL);
+
+	/*
+	 * If we're further behind than half the buffer, there's a chance
+	 * the writer will bite our tail and screw up the events under us.
+	 *
+	 * If we somehow ended up ahead of the head, we got messed up.
+	 *
+	 * In either case, truncate and restart at head.
+	 */
+	diff = head - old;
+	if (diff > md->mask / 2 || diff < 0) {
+		struct timeval iv;
+		unsigned long msecs;
+
+		timersub(&this_read, &last_read, &iv);
+		msecs = iv.tv_sec*1000 + iv.tv_usec/1000;
+
+		fprintf(stderr, "WARNING: failed to keep up with mmap data."
+				"  Last read %lu msecs ago.\n", msecs);
+
+		/*
+		 * head points to a known good entry, start there.
+		 */
+		old = head;
+	}
+
+	last_read = this_read;
+
+	if (old != head)
+		events++;
+
+	size = head - old;
+
+	if ((old & md->mask) + size != (head & md->mask)) {
+		buf = &data[old & md->mask];
+		size = md->mask + 1 - (old & md->mask);
+		old += size;
+		while (size) {
+			int ret = write(output, buf, size);
+			if (ret < 0) {
+				perror("failed to write");
+				exit(-1);
+			}
+			size -= ret;
+			buf += ret;
+		}
+	}
+
+	buf = &data[old & md->mask];
+	size = head - old;
+	old += size;
+	while (size) {
+		int ret = write(output, buf, size);
+		if (ret < 0) {
+			perror("failed to write");
+			exit(-1);
+		}
+		size -= ret;
+		buf += ret;
+	}
+
+	md->prev = old;
+}
+
+static volatile int done = 0;
+
+static void sigchld_handler(int sig)
+{
+	if (sig == SIGCHLD)
+		done = 1;
+}
+
+int main(int argc, char *argv[])
+{
+	struct pollfd event_array[MAX_NR_CPUS * MAX_COUNTERS];
+	struct mmap_data mmap_array[MAX_NR_CPUS][MAX_COUNTERS];
+	struct perf_counter_hw_event hw_event;
+	int i, counter, group_fd, nr_poll = 0;
+	pid_t pid;
+	int ret;
+
+	page_size = sysconf(_SC_PAGE_SIZE);
+
+	process_options(argc, argv);
+
+	nr_cpus = sysconf(_SC_NPROCESSORS_ONLN);
+	assert(nr_cpus <= MAX_NR_CPUS);
+	assert(nr_cpus >= 0);
+
+	output = open(output_name, O_CREAT|O_RDWR, S_IRWXU);
+	if (output < 0) {
+		perror("failed to create output file");
+		exit(-1);
+	}
+
+	argc -= optind;
+	argv += optind;
+
+	for (i = 0; i < nr_cpus; i++) {
+		group_fd = -1;
+		for (counter = 0; counter < nr_counters; counter++) {
+
+			memset(&hw_event, 0, sizeof(hw_event));
+			hw_event.config		= event_id[counter];
+			hw_event.irq_period	= event_count[counter];
+			hw_event.record_type	= PERF_RECORD_IP | PERF_RECORD_TID;
+			hw_event.nmi		= 1;
+			hw_event.mmap		= 1;
+			hw_event.comm		= 1;
+
+			fd[i][counter] = sys_perf_counter_open(&hw_event, -1, i, group_fd, 0);
+			if (fd[i][counter] < 0) {
+				int err = errno;
+				printf("kerneltop error: syscall returned with %d (%s)\n",
+					fd[i][counter], strerror(err));
+				if (err == EPERM)
+					printf("Are you root?\n");
+				exit(-1);
+			}
+			assert(fd[i][counter] >= 0);
+			fcntl(fd[i][counter], F_SETFL, O_NONBLOCK);
+
+			/*
+			 * First counter acts as the group leader:
+			 */
+			if (group && group_fd == -1)
+				group_fd = fd[i][counter];
+
+			event_array[nr_poll].fd = fd[i][counter];
+			event_array[nr_poll].events = POLLIN;
+			nr_poll++;
+
+			mmap_array[i][counter].counter = counter;
+			mmap_array[i][counter].prev = 0;
+			mmap_array[i][counter].mask = mmap_pages*page_size - 1;
+			mmap_array[i][counter].base = mmap(NULL, (mmap_pages+1)*page_size,
+					PROT_READ, MAP_SHARED, fd[i][counter], 0);
+			if (mmap_array[i][counter].base == MAP_FAILED) {
+				printf("kerneltop error: failed to mmap with %d (%s)\n",
+						errno, strerror(errno));
+				exit(-1);
+			}
+		}
+	}
+
+	signal(SIGCHLD, sigchld_handler);
+
+	pid = fork();
+	if (pid < 0)
+		perror("failed to fork");
+
+	if (!pid) {
+		if (execvp(argv[0], argv)) {
+			perror(argv[0]);
+			exit(-1);
+		}
+	}
+
+	if (realtime_prio) {
+		struct sched_param param;
+
+		param.sched_priority = realtime_prio;
+		if (sched_setscheduler(0, SCHED_FIFO, &param)) {
+			printf("Could not set realtime priority.\n");
+			exit(-1);
+		}
+	}
+
+	/*
+	 * TODO: store the current /proc/$/maps information somewhere
+	 */
+
+	while (!done) {
+		int hits = events;
+
+		for (i = 0; i < nr_cpus; i++) {
+			for (counter = 0; counter < nr_counters; counter++)
+				mmap_read(&mmap_array[i][counter]);
+		}
+
+		if (hits == events)
+			ret = poll(event_array, nr_poll, 100);
+	}
+
+	return 0;
+}
Index: linux-2.6/Documentation/perf_counter/perf-report.cc
===================================================================
--- /dev/null
+++ linux-2.6/Documentation/perf_counter/perf-report.cc
@@ -0,0 +1,472 @@
+#define _GNU_SOURCE
+#include <sys/types.h>
+#include <sys/stat.h>
+#include <sys/time.h>
+#include <unistd.h>
+#include <stdint.h>
+#include <stdlib.h>
+#include <string.h>
+#include <limits.h>
+#include <fcntl.h>
+#include <stdio.h>
+#include <errno.h>
+#include <ctype.h>
+#include <time.h>
+#include <getopt.h>
+
+#include <sys/ioctl.h>
+#include <sys/poll.h>
+#include <sys/prctl.h>
+#include <sys/wait.h>
+#include <sys/mman.h>
+#include <sys/types.h>
+#include <sys/stat.h>
+
+#include <linux/unistd.h>
+#include <linux/types.h>
+
+#include "../../include/linux/perf_counter.h"
+
+#include <set>
+#include <map>
+#include <string>
+
+
+static char 		const *input_name = "output.perf";
+static int		input;
+
+static unsigned long	page_size;
+static unsigned long	mmap_window = 32;
+
+struct ip_event {
+	struct perf_event_header header;
+	__u64 ip;
+	__u32 pid, tid;
+};
+struct mmap_event {
+	struct perf_event_header header;
+	__u32 pid, tid;
+	__u64 start;
+	__u64 len;
+	__u64 pgoff;
+	char filename[PATH_MAX];
+};
+struct comm_event {
+	struct perf_event_header header;
+	__u32 pid,tid;
+	char comm[16];
+};
+
+typedef union event_union {
+	struct perf_event_header header;
+	struct ip_event ip;
+	struct mmap_event mmap;
+	struct comm_event comm;
+} event_t;
+
+struct section {
+	uint64_t start;
+	uint64_t end;
+
+	uint64_t offset;
+
+	std::string name;
+
+	section() { };
+
+	section(uint64_t stab) : end(stab) { };
+
+	section(uint64_t start, uint64_t size, uint64_t offset, std::string name) :
+		start(start), end(start + size), offset(offset), name(name)
+	{ };
+
+	bool operator < (const struct section &s) const {
+		return end < s.end;
+	};
+};
+
+typedef std::set<struct section> sections_t;
+
+struct symbol {
+	uint64_t start;
+	uint64_t end;
+
+	std::string name;
+
+	symbol() { };
+
+	symbol(uint64_t ip) : start(ip) { }
+
+	symbol(uint64_t start, uint64_t len, std::string name) :
+		start(start), end(start + len), name(name)
+	{ };
+
+	bool operator < (const struct symbol &s) const {
+		return start < s.start;
+	};
+};
+
+typedef std::set<struct symbol> symbols_t;
+
+struct dso {
+	sections_t sections;
+	symbols_t syms;
+};
+
+static std::map<std::string, struct dso> dsos;
+
+static void load_dso_sections(std::string dso_name)
+{
+	struct dso &dso = dsos[dso_name];
+
+	std::string cmd = "readelf -DSW " + dso_name;
+
+	FILE *file = popen(cmd.c_str(), "r");
+	if (!file) {
+		perror("failed to open pipe");
+		exit(-1);
+	}
+
+	char *line = NULL;
+	size_t n = 0;
+
+	while (!feof(file)) {
+		uint64_t addr, off, size;
+		char name[32];
+
+		if (getline(&line, &n, file) < 0)
+			break;
+		if (!line)
+			break;
+
+		if (sscanf(line, "  [%*2d] %16s %*14s %Lx %Lx %Lx",
+					name, &addr, &off, &size) == 4) {
+
+			dso.sections.insert(section(addr, size, addr - off, name));
+		}
+#if 0
+		/*
+		 * for reading readelf symbols (-s), however these don't seem
+		 * to include nearly everything, so use nm for that.
+		 */
+		if (sscanf(line, " %*4d %*3d: %Lx %5Lu %*7s %*6s %*7s %3d %s",
+			   &start, &size, &section, sym) == 4) {
+
+			start -= dso.section_offsets[section];
+
+			dso.syms.insert(symbol(start, size, std::string(sym)));
+		}
+#endif
+	}
+	pclose(file);
+}
+
+static void load_dso_symbols(std::string dso_name, std::string args)
+{
+	struct dso &dso = dsos[dso_name];
+
+	std::string cmd = "nm -nSC " + args + " " + dso_name;
+
+	FILE *file = popen(cmd.c_str(), "r");
+	if (!file) {
+		perror("failed to open pipe");
+		exit(-1);
+	}
+
+	char *line = NULL;
+	size_t n = 0;
+
+	while (!feof(file)) {
+		uint64_t start, size;
+		char c;
+		char sym[1024];
+
+		if (getline(&line, &n, file) < 0)
+			break;
+		if (!line)
+			break;
+
+
+		if (sscanf(line, "%Lx %Lx %c %s", &start, &size, &c, sym) == 4) {
+			sections_t::const_iterator si =
+				dso.sections.upper_bound(section(start));
+			if (si == dso.sections.end()) {
+				printf("symbol in unknown section: %s\n", sym);
+				continue;
+			}
+
+			start -= si->offset;
+
+			dso.syms.insert(symbol(start, size, sym));
+		}
+	}
+	pclose(file);
+}
+
+static void load_dso(std::string dso_name)
+{
+	load_dso_sections(dso_name);
+	load_dso_symbols(dso_name, "-D"); /* dynamic symbols */
+	load_dso_symbols(dso_name, "");   /* regular ones */
+}
+
+void load_kallsyms(void)
+{
+	struct dso &dso = dsos["[kernel]"];
+
+	FILE *file = fopen("/proc/kallsyms", "r");
+	if (!file) {
+		perror("failed to open kallsyms");
+		exit(-1);
+	}
+
+	char *line;
+	size_t n;
+
+	while (!feof(file)) {
+		uint64_t start;
+		char c;
+		char sym[1024];
+
+		if (getline(&line, &n, file) < 0)
+			break;
+		if (!line)
+			break;
+
+		if (sscanf(line, "%Lx %c %s", &start, &c, sym) == 3)
+			dso.syms.insert(symbol(start, 0x1000000, std::string(sym)));
+	}
+	fclose(file);
+}
+
+struct map {
+	uint64_t start;
+	uint64_t end;
+	uint64_t pgoff;
+
+	std::string dso;
+
+	map() { };
+
+	map(uint64_t ip) : end(ip) { }
+
+	map(mmap_event *mmap) {
+		start = mmap->start;
+		end = mmap->start + mmap->len;
+		pgoff = mmap->pgoff;
+
+		dso = std::string(mmap->filename);
+
+		if (dsos.find(dso) == dsos.end())
+			load_dso(dso);
+	};
+
+	bool operator < (const struct map &m) const {
+		return end < m.end;
+	};
+};
+
+typedef std::set<struct map> maps_t;
+
+static std::map<int, maps_t> maps;
+
+static std::map<int, std::string> comms;
+
+static std::map<std::string, int> hist;
+static std::multimap<int, std::string> rev_hist;
+
+static std::string resolve_comm(int pid)
+{
+	std::string comm = "<unknown>";
+	std::map<int, std::string>::const_iterator ci = comms.find(pid);
+	if (ci != comms.end())
+		comm = ci->second;
+
+	return comm;
+}
+
+static std::string resolve_user_symbol(int pid, uint64_t ip)
+{
+	std::string sym = "<unknown>";
+
+	maps_t &m = maps[pid];
+	maps_t::const_iterator mi = m.upper_bound(map(ip));
+	if (mi == m.end())
+		return sym;
+
+	ip -= mi->start + mi->pgoff;
+
+	symbols_t &s = dsos[mi->dso].syms;
+	symbols_t::const_iterator si = s.upper_bound(symbol(ip));
+
+	sym = mi->dso + ": <unknown>";
+
+	if (si == s.begin())
+		return sym;
+	si--;
+
+	if (si->start <= ip && ip < si->end)
+		sym = mi->dso + ": " + si->name;
+#if 0
+	else if (si->start <= ip)
+		sym = mi->dso + ": ?" + si->name;
+#endif
+
+	return sym;
+}
+
+static std::string resolve_kernel_symbol(uint64_t ip)
+{
+	std::string sym = "<unknown>";
+
+	symbols_t &s = dsos["[kernel]"].syms;
+	symbols_t::const_iterator si = s.upper_bound(symbol(ip));
+
+	if (si == s.begin())
+		return sym;
+	si--;
+
+	if (si->start <= ip && ip < si->end)
+		sym = si->name;
+
+	return sym;
+}
+
+static void display_help(void)
+{
+	printf(
+	"Usage: perf-report [<options>]\n"
+	" -i file   --input=<file>      # input file\n"
+	);
+
+	exit(0);
+}
+
+static void process_options(int argc, char *argv[])
+{
+	int error = 0;
+
+	for (;;) {
+		int option_index = 0;
+		/** Options for getopt */
+		static struct option long_options[] = {
+			{"input",	required_argument,	NULL, 'i'},
+			{NULL,		0,			NULL,  0 }
+		};
+		int c = getopt_long(argc, argv, "+:i:",
+				    long_options, &option_index);
+		if (c == -1)
+			break;
+
+		switch (c) {
+		case 'i': input_name			= strdup(optarg); break;
+		default: error = 1; break;
+		}
+	}
+
+	if (error)
+		display_help();
+}
+
+int main(int argc, char *argv[])
+{
+	unsigned long offset = 0;
+	unsigned long head = 0;
+	struct stat stat;
+	char *buf;
+	event_t *event;
+	int ret;
+	unsigned long total = 0;
+
+	page_size = getpagesize();
+
+	process_options(argc, argv);
+
+	input = open(input_name, O_RDONLY);
+	if (input < 0) {
+		perror("failed to open file");
+		exit(-1);
+	}
+
+	ret = fstat(input, &stat);
+	if (ret < 0) {
+		perror("failed to stat file");
+		exit(-1);
+	}
+
+	load_kallsyms();
+
+remap:
+	buf = (char *)mmap(NULL, page_size * mmap_window, PROT_READ,
+			   MAP_SHARED, input, offset);
+	if (buf == MAP_FAILED) {
+		perror("failed to mmap file");
+		exit(-1);
+	}
+
+more:
+	event = (event_t *)(buf + head);
+
+	if (head + event->header.size >= page_size * mmap_window) {
+		unsigned long shift = page_size * (head / page_size);
+
+		munmap(buf, page_size * mmap_window);
+		offset += shift;
+		head -= shift;
+		goto remap;
+	}
+	head += event->header.size;
+
+	if (event->header.misc & PERF_EVENT_MISC_OVERFLOW) {
+		std::string comm, sym, level;
+		char output[1024];
+
+		if (event->header.misc & PERF_EVENT_MISC_KERNEL) {
+			level = "[kernel]";
+			sym = resolve_kernel_symbol(event->ip.ip);
+		} else if (event->header.misc & PERF_EVENT_MISC_USER) {
+			level = "[ user ]";
+			sym = resolve_user_symbol(event->ip.pid, event->ip.ip);
+		} else {
+			level = "[  hv  ]";
+		}
+		comm = resolve_comm(event->ip.pid);
+
+		snprintf(output, sizeof(output), "%16s %s %s",
+				comm.c_str(), level.c_str(), sym.c_str());
+		hist[output]++;
+
+		total++;
+
+	} else switch (event->header.type) {
+	case PERF_EVENT_MMAP:
+		maps[event->mmap.pid].insert(map(&event->mmap));
+		break;
+
+	case PERF_EVENT_COMM:
+		comms[event->comm.pid] = std::string(event->comm.comm);
+		break;
+	}
+
+	if (offset + head < stat.st_size)
+		goto more;
+
+	close(input);
+
+	std::map<std::string, int>::iterator hi = hist.begin();
+
+	while (hi != hist.end()) {
+		rev_hist.insert(std::pair<int, std::string>(hi->second, hi->first));
+		hist.erase(hi++);
+	}
+
+	std::multimap<int, std::string>::const_iterator ri = rev_hist.begin();
+
+	while (ri != rev_hist.end()) {
+		printf(" %5.2f %s\n", (100.0 * ri->first)/total, ri->second.c_str());
+		ri++;
+	}
+
+	return 0;
+}
+

-- 

