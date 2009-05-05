Return-Path: <linux-kernel-owner+w=401wt.eu-S1754120AbZEESgo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754120AbZEESgo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 May 2009 14:36:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757991AbZEESff
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 May 2009 14:35:35 -0400
Received: from hera.kernel.org ([140.211.167.34]:58346 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757363AbZEESfa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 May 2009 14:35:30 -0400
Date: Tue, 5 May 2009 18:34:57 GMT
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, hpa@zytor.com,
       mingo@redhat.com, a.p.zijlstra@chello.nl, tglx@linutronix.de,
       cjashfor@linux.vnet.ibm.com, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org,
       linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
       tglx@linutronix.de, cjashfor@linux.vnet.ibm.com, mingo@elte.hu
In-Reply-To: <20090505155437.389163017@chello.nl>
References: <20090505155437.389163017@chello.nl>
Subject: [tip:perfcounters/core] perf_counter: tools: update the tools to support process and inherited counters
Message-ID: <tip-16c8a10932aef971292c9570eb5f60b5d4e83ed2@git.kernel.org>
Git-Commit-ID: 16c8a10932aef971292c9570eb5f60b5d4e83ed2
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 05 May 2009 18:35:00 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  16c8a10932aef971292c9570eb5f60b5d4e83ed2
Gitweb:     http://git.kernel.org/tip/16c8a10932aef971292c9570eb5f60b5d4e83ed2
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Tue, 5 May 2009 17:50:27 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 5 May 2009 20:18:33 +0200

perf_counter: tools: update the tools to support process and inherited counters

"perf record":
 - per task counter
 - inherit switch
 - nmi switch

"perf report":
 - userspace/kernel filter

"perf stat":
 - userspace/kernel filter

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
LKML-Reference: <20090505155437.389163017@chello.nl>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 Documentation/perf_counter/builtin-record.c |  155 +++++++++++++++++----------
 Documentation/perf_counter/builtin-stat.c   |   24 ++++-
 Documentation/perf_counter/perf-report.cc   |   27 ++++-
 3 files changed, 140 insertions(+), 66 deletions(-)

diff --git a/Documentation/perf_counter/builtin-record.c b/Documentation/perf_counter/builtin-record.c
index ddfdcf8..5f5e6df 100644
--- a/Documentation/perf_counter/builtin-record.c
+++ b/Documentation/perf_counter/builtin-record.c
@@ -45,7 +45,10 @@ static unsigned int		mmap_pages			= 16;
 static int			output;
 static char 			*output_name			= "output.perf";
 static int			group				= 0;
-static unsigned int		realtime_prio			=  0;
+static unsigned int		realtime_prio			= 0;
+static int			system_wide			= 0;
+static int			inherit				= 1;
+static int			nmi				= 1;
 
 const unsigned int default_count[] = {
 	1000000,
@@ -167,7 +170,7 @@ static void display_events_help(void)
 static void display_help(void)
 {
 	printf(
-	"Usage: perf-record [<options>]\n"
+	"Usage: perf-record [<options>] <cmd>\n"
 	"perf-record Options (up to %d event types can be specified at once):\n\n",
 		 MAX_COUNTERS);
 
@@ -178,12 +181,13 @@ static void display_help(void)
 	" -m pages  --mmap_pages=<pages> # number of mmap data pages\n"
 	" -o file   --output=<file>      # output file\n"
 	" -r prio   --realtime=<prio>    # use RT prio\n"
+	" -s        --system             # system wide profiling\n"
 	);
 
 	exit(0);
 }
 
-static void process_options(int argc, char *argv[])
+static void process_options(int argc, const char *argv[])
 {
 	int error = 0, counter;
 
@@ -196,9 +200,12 @@ static void process_options(int argc, char *argv[])
 			{"mmap_pages",	required_argument,	NULL, 'm'},
 			{"output",	required_argument,	NULL, 'o'},
 			{"realtime",	required_argument,	NULL, 'r'},
+			{"system",	no_argument,		NULL, 's'},
+			{"inherit",	no_argument,		NULL, 'i'},
+			{"nmi",		no_argument,		NULL, 'n'},
 			{NULL,		0,			NULL,  0 }
 		};
-		int c = getopt_long(argc, argv, "+:c:e:m:o:r:",
+		int c = getopt_long(argc, argv, "+:c:e:m:o:r:sin",
 				    long_options, &option_index);
 		if (c == -1)
 			break;
@@ -209,9 +216,16 @@ static void process_options(int argc, char *argv[])
 		case 'm': mmap_pages			=   atoi(optarg); break;
 		case 'o': output_name			= strdup(optarg); break;
 		case 'r': realtime_prio			=   atoi(optarg); break;
+		case 's': system_wide                   ^=             1; break;
+		case 'i': inherit			^=	       1; break;
+		case 'n': nmi				^=	       1; break;
 		default: error = 1; break;
 		}
 	}
+
+	if (argc - optind == 0)
+		error = 1;
+
 	if (error)
 		display_help();
 
@@ -325,18 +339,82 @@ static void mmap_read(struct mmap_data *md)
 
 static volatile int done = 0;
 
-static void sigchld_handler(int sig)
+static void sig_handler(int sig)
 {
-	if (sig == SIGCHLD)
-		done = 1;
+	done = 1;
 }
 
-int cmd_record(int argc, char **argv)
+static struct pollfd event_array[MAX_NR_CPUS * MAX_COUNTERS];
+static struct mmap_data mmap_array[MAX_NR_CPUS][MAX_COUNTERS];
+
+static int nr_poll;
+static int nr_cpu;
+
+static void open_counters(int cpu)
 {
-	struct pollfd event_array[MAX_NR_CPUS * MAX_COUNTERS];
-	struct mmap_data mmap_array[MAX_NR_CPUS][MAX_COUNTERS];
 	struct perf_counter_hw_event hw_event;
-	int i, counter, group_fd, nr_poll = 0;
+	int counter, group_fd;
+	int track = 1;
+	pid_t pid = -1;
+
+	if (cpu < 0)
+		pid = 0;
+
+	group_fd = -1;
+	for (counter = 0; counter < nr_counters; counter++) {
+
+		memset(&hw_event, 0, sizeof(hw_event));
+		hw_event.config		= event_id[counter];
+		hw_event.irq_period	= event_count[counter];
+		hw_event.record_type	= PERF_RECORD_IP | PERF_RECORD_TID;
+		hw_event.nmi		= nmi;
+		hw_event.mmap		= track;
+		hw_event.comm		= track;
+		hw_event.inherit	= (cpu < 0) && inherit;
+
+		track = 0; // only the first counter needs these
+
+		fd[nr_cpu][counter] =
+			sys_perf_counter_open(&hw_event, pid, cpu, group_fd, 0);
+
+		if (fd[nr_cpu][counter] < 0) {
+			int err = errno;
+			printf("kerneltop error: syscall returned with %d (%s)\n",
+					fd[nr_cpu][counter], strerror(err));
+			if (err == EPERM)
+				printf("Are you root?\n");
+			exit(-1);
+		}
+		assert(fd[nr_cpu][counter] >= 0);
+		fcntl(fd[nr_cpu][counter], F_SETFL, O_NONBLOCK);
+
+		/*
+		 * First counter acts as the group leader:
+		 */
+		if (group && group_fd == -1)
+			group_fd = fd[nr_cpu][counter];
+
+		event_array[nr_poll].fd = fd[nr_cpu][counter];
+		event_array[nr_poll].events = POLLIN;
+		nr_poll++;
+
+		mmap_array[nr_cpu][counter].counter = counter;
+		mmap_array[nr_cpu][counter].prev = 0;
+		mmap_array[nr_cpu][counter].mask = mmap_pages*page_size - 1;
+		mmap_array[nr_cpu][counter].base = mmap(NULL, (mmap_pages+1)*page_size,
+				PROT_READ, MAP_SHARED, fd[nr_cpu][counter], 0);
+		if (mmap_array[nr_cpu][counter].base == MAP_FAILED) {
+			printf("kerneltop error: failed to mmap with %d (%s)\n",
+					errno, strerror(errno));
+			exit(-1);
+		}
+	}
+	nr_cpu++;
+}
+
+int cmd_record(int argc, const char **argv)
+{
+	int i, counter;
 	pid_t pid;
 	int ret;
 
@@ -357,54 +435,13 @@ int cmd_record(int argc, char **argv)
 	argc -= optind;
 	argv += optind;
 
-	for (i = 0; i < nr_cpus; i++) {
-		group_fd = -1;
-		for (counter = 0; counter < nr_counters; counter++) {
-
-			memset(&hw_event, 0, sizeof(hw_event));
-			hw_event.config		= event_id[counter];
-			hw_event.irq_period	= event_count[counter];
-			hw_event.record_type	= PERF_RECORD_IP | PERF_RECORD_TID;
-			hw_event.nmi		= 1;
-			hw_event.mmap		= 1;
-			hw_event.comm		= 1;
-
-			fd[i][counter] = sys_perf_counter_open(&hw_event, -1, i, group_fd, 0);
-			if (fd[i][counter] < 0) {
-				int err = errno;
-				printf("kerneltop error: syscall returned with %d (%s)\n",
-					fd[i][counter], strerror(err));
-				if (err == EPERM)
-					printf("Are you root?\n");
-				exit(-1);
-			}
-			assert(fd[i][counter] >= 0);
-			fcntl(fd[i][counter], F_SETFL, O_NONBLOCK);
-
-			/*
-			 * First counter acts as the group leader:
-			 */
-			if (group && group_fd == -1)
-				group_fd = fd[i][counter];
-
-			event_array[nr_poll].fd = fd[i][counter];
-			event_array[nr_poll].events = POLLIN;
-			nr_poll++;
-
-			mmap_array[i][counter].counter = counter;
-			mmap_array[i][counter].prev = 0;
-			mmap_array[i][counter].mask = mmap_pages*page_size - 1;
-			mmap_array[i][counter].base = mmap(NULL, (mmap_pages+1)*page_size,
-					PROT_READ, MAP_SHARED, fd[i][counter], 0);
-			if (mmap_array[i][counter].base == MAP_FAILED) {
-				printf("kerneltop error: failed to mmap with %d (%s)\n",
-						errno, strerror(errno));
-				exit(-1);
-			}
-		}
-	}
+	if (!system_wide)
+		open_counters(-1);
+	else for (i = 0; i < nr_cpus; i++)
+		open_counters(i);
 
-	signal(SIGCHLD, sigchld_handler);
+	signal(SIGCHLD, sig_handler);
+	signal(SIGINT, sig_handler);
 
 	pid = fork();
 	if (pid < 0)
@@ -434,7 +471,7 @@ int cmd_record(int argc, char **argv)
 	while (!done) {
 		int hits = events;
 
-		for (i = 0; i < nr_cpus; i++) {
+		for (i = 0; i < nr_cpu; i++) {
 			for (counter = 0; counter < nr_counters; counter++)
 				mmap_read(&mmap_array[i][counter]);
 		}
diff --git a/Documentation/perf_counter/builtin-stat.c b/Documentation/perf_counter/builtin-stat.c
index 6de38d2..e2fa117 100644
--- a/Documentation/perf_counter/builtin-stat.c
+++ b/Documentation/perf_counter/builtin-stat.c
@@ -87,6 +87,9 @@
 
 #include "perf.h"
 
+#define EVENT_MASK_KERNEL		1
+#define EVENT_MASK_USER			2
+
 static int			system_wide			=  0;
 
 static int			nr_counters			=  0;
@@ -104,6 +107,7 @@ static __u64			event_id[MAX_COUNTERS]		= {
 static int			default_interval = 100000;
 static int			event_count[MAX_COUNTERS];
 static int			fd[MAX_NR_CPUS][MAX_COUNTERS];
+static int			event_mask[MAX_COUNTERS];
 
 static int			tid				= -1;
 static int			profile_cpu			= -1;
@@ -258,12 +262,23 @@ static __u64 match_event_symbols(char *str)
 	__u64 config, id;
 	int type;
 	unsigned int i;
+	char mask_str[4];
 
 	if (sscanf(str, "r%llx", &config) == 1)
 		return config | PERF_COUNTER_RAW_MASK;
 
-	if (sscanf(str, "%d:%llu", &type, &id) == 2)
-		return EID(type, id);
+	switch (sscanf(str, "%d:%llu:%2s", &type, &id, mask_str)) {
+		case 3:
+			if (strchr(mask_str, 'u'))
+				event_mask[nr_counters] |= EVENT_MASK_USER;
+			if (strchr(mask_str, 'k'))
+				event_mask[nr_counters] |= EVENT_MASK_KERNEL;
+		case 2:
+			return EID(type, id);
+
+		default:
+			break;
+	}
 
 	for (i = 0; i < ARRAY_SIZE(event_symbols); i++) {
 		if (!strncmp(str, event_symbols[i].symbol,
@@ -313,6 +328,11 @@ static void create_perfstat_counter(int counter)
 	hw_event.config		= event_id[counter];
 	hw_event.record_type	= 0;
 	hw_event.nmi		= 0;
+	hw_event.exclude_kernel = event_mask[counter] & EVENT_MASK_KERNEL;
+	hw_event.exclude_user   = event_mask[counter] & EVENT_MASK_USER;
+
+printf("exclude: %d\n", event_mask[counter]);
+
 	if (scale)
 		hw_event.read_format	= PERF_FORMAT_TOTAL_TIME_ENABLED |
 					  PERF_FORMAT_TOTAL_TIME_RUNNING;
diff --git a/Documentation/perf_counter/perf-report.cc b/Documentation/perf_counter/perf-report.cc
index 911d7f3..8855107 100644
--- a/Documentation/perf_counter/perf-report.cc
+++ b/Documentation/perf_counter/perf-report.cc
@@ -33,8 +33,13 @@
 #include <string>
 
 
+#define SHOW_KERNEL	1
+#define SHOW_USER	2
+#define SHOW_HV		4
+
 static char 		const *input_name = "output.perf";
 static int		input;
+static int		show_mask = SHOW_KERNEL | SHOW_USER | SHOW_HV;
 
 static unsigned long	page_size;
 static unsigned long	mmap_window = 32;
@@ -359,15 +364,21 @@ static void process_options(int argc, char *argv[])
 		/** Options for getopt */
 		static struct option long_options[] = {
 			{"input",	required_argument,	NULL, 'i'},
+			{"no-user",	no_argument,		NULL, 'u'},
+			{"no-kernel",	no_argument,		NULL, 'k'},
+			{"no-hv",	no_argument,		NULL, 'h'},
 			{NULL,		0,			NULL,  0 }
 		};
-		int c = getopt_long(argc, argv, "+:i:",
+		int c = getopt_long(argc, argv, "+:i:kuh",
 				    long_options, &option_index);
 		if (c == -1)
 			break;
 
 		switch (c) {
 		case 'i': input_name			= strdup(optarg); break;
+		case 'k': show_mask &= ~SHOW_KERNEL; break;
+		case 'u': show_mask &= ~SHOW_USER; break;
+		case 'h': show_mask &= ~SHOW_HV; break;
 		default: error = 1; break;
 		}
 	}
@@ -443,22 +454,28 @@ more:
 
 	if (event->header.misc & PERF_EVENT_MISC_OVERFLOW) {
 		std::string comm, sym, level;
+		int show = 0;
 		char output[1024];
 
 		if (event->header.misc & PERF_EVENT_MISC_KERNEL) {
+			show |= SHOW_KERNEL;
 			level = " [k] ";
 			sym = resolve_kernel_symbol(event->ip.ip);
 		} else if (event->header.misc & PERF_EVENT_MISC_USER) {
+			show |= SHOW_USER;
 			level = " [.] ";
 			sym = resolve_user_symbol(event->ip.pid, event->ip.ip);
 		} else {
+			show |= SHOW_HV;
 			level = " [H] ";
 		}
-		comm = resolve_comm(event->ip.pid);
 
-		snprintf(output, sizeof(output), "%16s %s %s",
-				comm.c_str(), level.c_str(), sym.c_str());
-		hist[output]++;
+		if (show & show_mask) {
+			comm = resolve_comm(event->ip.pid);
+			snprintf(output, sizeof(output), "%16s %s %s",
+					comm.c_str(), level.c_str(), sym.c_str());
+			hist[output]++;
+		}
 
 		total++;
 
