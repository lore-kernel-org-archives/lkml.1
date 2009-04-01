Return-Path: <linux-kernel-owner+w=401wt.eu-S1758913AbZDAKUi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758913AbZDAKUi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Apr 2009 06:20:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759054AbZDAKQE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Apr 2009 06:16:04 -0400
Received: from hera.kernel.org ([140.211.167.34]:34040 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759198AbZDAKQA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Apr 2009 06:16:00 -0400
Date: Wed, 1 Apr 2009 10:15:16 GMT
From: Mike Galbraith <efault@gmx.de>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, hpa@zytor.com,
       mingo@redhat.com, a.p.zijlstra@chello.nl, efault@gmx.de,
       tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org,
       linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl, efault@gmx.de,
       tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <new-submission>
References: <new-submission>
Subject: [tip:perfcounters/core] perf_counter tools: kerneltop: add real-time data acquisition thread
Message-ID: <tip-f0e36dc28173b65df2216dfae7109645d97a1bd9@git.kernel.org>
Git-Commit-ID: f0e36dc28173b65df2216dfae7109645d97a1bd9
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 01 Apr 2009 10:15:18 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  f0e36dc28173b65df2216dfae7109645d97a1bd9
Gitweb:     http://git.kernel.org/tip/f0e36dc28173b65df2216dfae7109645d97a1bd9
Author:     Mike Galbraith <efault@gmx.de>
AuthorDate: Fri, 27 Mar 2009 12:13:43 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 1 Apr 2009 12:08:51 +0200

perf_counter tools: kerneltop: add real-time data acquisition thread

Decouple kerneltop display from event acquisition by introducing
a separate data acquisition thread. This fixes annnoying kerneltop
display refresh jitter and missed events.

Also add a -r <prio> option, to switch the data acquisition thread
to real-time priority.

Signed-off-by: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <new-submission>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 Documentation/perf_counter/kerneltop.c |   57 ++++++++++++++++++++++----------
 1 files changed, 39 insertions(+), 18 deletions(-)

diff --git a/Documentation/perf_counter/kerneltop.c b/Documentation/perf_counter/kerneltop.c
index 430810d..33b4fcf 100644
--- a/Documentation/perf_counter/kerneltop.c
+++ b/Documentation/perf_counter/kerneltop.c
@@ -77,6 +77,8 @@
 #include <errno.h>
 #include <ctype.h>
 #include <time.h>
+#include <sched.h>
+#include <pthread.h>
 
 #include <sys/syscall.h>
 #include <sys/ioctl.h>
@@ -181,6 +183,7 @@ static int			tid				= -1;
 static int			profile_cpu			= -1;
 static int			nr_cpus				=  0;
 static int			nmi				=  1;
+static unsigned int		realtime_prio			=  0;
 static int			group				=  0;
 static unsigned int		page_size;
 static unsigned int		mmap_pages			=  16;
@@ -334,6 +337,7 @@ static void display_help(void)
 	" -l                           # show scale factor for RR events\n"
 	" -d delay  --delay=<seconds>  # sampling/display delay           [default:  2]\n"
 	" -f CNT    --filter=CNT       # min-event-count filter          [default: 100]\n\n"
+	" -r prio   --realtime=<prio>  # event acquisition runs with SCHED_FIFO policy\n"
 	" -s symbol --symbol=<symbol>  # function to be showed annotated one-shot\n"
 	" -x path   --vmlinux=<path>   # the vmlinux binary, required for -s use\n"
 	" -z        --zero             # zero counts after display\n"
@@ -620,7 +624,6 @@ static int compare(const void *__sym1, const void *__sym2)
 	return sym_weight(sym1) < sym_weight(sym2);
 }
 
-static time_t			last_refresh;
 static long			events;
 static long			userspace_events;
 static const char		CONSOLE_CLEAR[] = "[H[2J";
@@ -634,6 +637,7 @@ static void print_sym_table(void)
 	float events_per_sec = events/delay_secs;
 	float kevents_per_sec = (events-userspace_events)/delay_secs;
 
+	events = userspace_events = 0;
 	memcpy(tmp, sym_table, sizeof(sym_table[0])*sym_table_count);
 	qsort(tmp, sym_table_count, sizeof(tmp[0]), compare);
 
@@ -714,8 +718,6 @@ static void print_sym_table(void)
 	if (sym_filter_entry)
 		show_details(sym_filter_entry);
 
-	last_refresh = time(NULL);
-
 	{
 		struct pollfd stdin_poll = { .fd = 0, .events = POLLIN };
 
@@ -726,6 +728,16 @@ static void print_sym_table(void)
 	}
 }
 
+static void *display_thread(void *arg)
+{
+	printf("KernelTop refresh period: %d seconds\n", delay_secs);
+
+	while (!sleep(delay_secs))
+		print_sym_table();
+
+	return NULL;
+}
+
 static int read_symbol(FILE *in, struct sym_entry *s)
 {
 	static int filter_match = 0;
@@ -1081,19 +1093,20 @@ static void process_options(int argc, char *argv[])
 			{"filter",	required_argument,	NULL, 'f'},
 			{"group",	required_argument,	NULL, 'g'},
 			{"help",	no_argument,		NULL, 'h'},
-			{"scale",	no_argument,		NULL, 'l'},
 			{"nmi",		required_argument,	NULL, 'n'},
+			{"mmap_info",	no_argument,		NULL, 'M'},
+			{"mmap_pages",	required_argument,	NULL, 'm'},
+			{"munmap_info",	no_argument,		NULL, 'U'},
 			{"pid",		required_argument,	NULL, 'p'},
-			{"vmlinux",	required_argument,	NULL, 'x'},
+			{"realtime",	required_argument,	NULL, 'r'},
+			{"scale",	no_argument,		NULL, 'l'},
 			{"symbol",	required_argument,	NULL, 's'},
 			{"stat",	no_argument,		NULL, 'S'},
+			{"vmlinux",	required_argument,	NULL, 'x'},
 			{"zero",	no_argument,		NULL, 'z'},
-			{"mmap_pages",	required_argument,	NULL, 'm'},
-			{"mmap_info",	no_argument,		NULL, 'M'},
-			{"munmap_info",	no_argument,		NULL, 'U'},
 			{NULL,		0,			NULL,  0 }
 		};
-		int c = getopt_long(argc, argv, "+:ac:C:d:De:f:g:hln:m:p:s:Sx:zMU",
+		int c = getopt_long(argc, argv, "+:ac:C:d:De:f:g:hln:m:p:r:s:Sx:zMU",
 				    long_options, &option_index);
 		if (c == -1)
 			break;
@@ -1127,6 +1140,7 @@ static void process_options(int argc, char *argv[])
 				profile_cpu = -1;
 			}
 			tid				=   atoi(optarg); break;
+		case 'r': realtime_prio			=   atoi(optarg); break;
 		case 's': sym_filter			= strdup(optarg); break;
 		case 'S': run_perfstat			=	       1; break;
 		case 'x': vmlinux			= strdup(optarg); break;
@@ -1289,6 +1303,7 @@ int main(int argc, char *argv[])
 	struct pollfd event_array[MAX_NR_CPUS * MAX_COUNTERS];
 	struct mmap_data mmap_array[MAX_NR_CPUS][MAX_COUNTERS];
 	struct perf_counter_hw_event hw_event;
+	pthread_t thread;
 	int i, counter, group_fd, nr_poll = 0;
 	unsigned int cpu;
 	int ret;
@@ -1363,8 +1378,20 @@ int main(int argc, char *argv[])
 		}
 	}
 
-	printf("KernelTop refresh period: %d seconds\n", delay_secs);
-	last_refresh = time(NULL);
+	if (pthread_create(&thread, NULL, display_thread, NULL)) {
+		printf("Could not create display thread.\n");
+		exit(-1);
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
 
 	while (1) {
 		int hits = events;
@@ -1374,14 +1401,8 @@ int main(int argc, char *argv[])
 				mmap_read(&mmap_array[i][counter]);
 		}
 
-		if (time(NULL) >= last_refresh + delay_secs) {
-			print_sym_table();
-			events = userspace_events = 0;
-		}
-
 		if (hits == events)
-			ret = poll(event_array, nr_poll, 1000);
-		hits = events;
+			ret = poll(event_array, nr_poll, 100);
 	}
 
 	return 0;
