Return-Path: <linux-kernel-owner+w=401wt.eu-S1758495AbZEOHhk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758495AbZEOHhk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 May 2009 03:37:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755869AbZEOHha
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 May 2009 03:37:30 -0400
Received: from hera.kernel.org ([140.211.167.34]:52690 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755609AbZEOHh3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 May 2009 03:37:29 -0400
Date: Fri, 15 May 2009 07:36:50 GMT
From: tip-bot for Arnaldo Carvalho de Melo <acme@redhat.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, hpa@zytor.com,
       mingo@redhat.com, jkacur@redhat.com, williams@redhat.com,
       peterz@infradead.org, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, acme@redhat.com,
       linux-kernel@vger.kernel.org, jkacur@redhat.com, williams@redhat.com,
       peterz@infradead.org, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20090515015046.GA13664@ghostprotocols.net>
References: <20090515015046.GA13664@ghostprotocols.net>
Subject: [tip:perfcounters/core] perf record: Allow specifying a pid to record
Message-ID: <tip-1a853e36871b533ccc3f3c5bdd5cd0d867043a00@git.kernel.org>
Git-Commit-ID: 1a853e36871b533ccc3f3c5bdd5cd0d867043a00
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Fri, 15 May 2009 07:36:52 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  1a853e36871b533ccc3f3c5bdd5cd0d867043a00
Gitweb:     http://git.kernel.org/tip/1a853e36871b533ccc3f3c5bdd5cd0d867043a00
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Thu, 14 May 2009 22:50:46 -0300
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 15 May 2009 09:35:24 +0200

perf record: Allow specifying a pid to record

Allow specifying a pid instead of always fork+exec'ing a command.

Because the PERF_EVENT_COMM and PERF_EVENT_MMAP events happened before
we connected, we must synthesize them so that 'perf report' can get what
it needs.

[ Impact: add new command line option ]

Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Clark Williams <williams@redhat.com>
Cc: John Kacur <jkacur@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
LKML-Reference: <20090515015046.GA13664@ghostprotocols.net>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 Documentation/perf_counter/builtin-record.c |  163 ++++++++++++++++++++++++---
 1 files changed, 146 insertions(+), 17 deletions(-)

diff --git a/Documentation/perf_counter/builtin-record.c b/Documentation/perf_counter/builtin-record.c
index 5f5e6df..efb8759 100644
--- a/Documentation/perf_counter/builtin-record.c
+++ b/Documentation/perf_counter/builtin-record.c
@@ -34,6 +34,9 @@
 
 #include "perf.h"
 
+#define ALIGN(x,a)		__ALIGN_MASK(x,(typeof(x))(a)-1)
+#define __ALIGN_MASK(x,mask)	(((x)+(mask))&~(mask))
+
 static int			nr_counters			=  0;
 static __u64			event_id[MAX_COUNTERS]		= { };
 static int			default_interval = 100000;
@@ -47,6 +50,7 @@ static char 			*output_name			= "output.perf";
 static int			group				= 0;
 static unsigned int		realtime_prio			= 0;
 static int			system_wide			= 0;
+static pid_t			target_pid			= -1;
 static int			inherit				= 1;
 static int			nmi				= 1;
 
@@ -180,6 +184,7 @@ static void display_help(void)
 	" -c CNT    --count=CNT          # event period to sample\n"
 	" -m pages  --mmap_pages=<pages> # number of mmap data pages\n"
 	" -o file   --output=<file>      # output file\n"
+	" -p pid    --pid=<pid>		 # record events on existing pid\n"
 	" -r prio   --realtime=<prio>    # use RT prio\n"
 	" -s        --system             # system wide profiling\n"
 	);
@@ -199,13 +204,14 @@ static void process_options(int argc, const char *argv[])
 			{"event",	required_argument,	NULL, 'e'},
 			{"mmap_pages",	required_argument,	NULL, 'm'},
 			{"output",	required_argument,	NULL, 'o'},
+			{"pid",		required_argument,	NULL, 'p'},
 			{"realtime",	required_argument,	NULL, 'r'},
 			{"system",	no_argument,		NULL, 's'},
 			{"inherit",	no_argument,		NULL, 'i'},
 			{"nmi",		no_argument,		NULL, 'n'},
 			{NULL,		0,			NULL,  0 }
 		};
-		int c = getopt_long(argc, argv, "+:c:e:m:o:r:sin",
+		int c = getopt_long(argc, argv, "+:c:e:m:o:p:r:sin",
 				    long_options, &option_index);
 		if (c == -1)
 			break;
@@ -215,6 +221,7 @@ static void process_options(int argc, const char *argv[])
 		case 'e': error				= parse_events(optarg); break;
 		case 'm': mmap_pages			=   atoi(optarg); break;
 		case 'o': output_name			= strdup(optarg); break;
+		case 'p': target_pid			=   atoi(optarg); break;
 		case 'r': realtime_prio			=   atoi(optarg); break;
 		case 's': system_wide                   ^=             1; break;
 		case 'i': inherit			^=	       1; break;
@@ -223,7 +230,7 @@ static void process_options(int argc, const char *argv[])
 		}
 	}
 
-	if (argc - optind == 0)
+	if (argc - optind == 0 && target_pid == -1)
 		error = 1;
 
 	if (error)
@@ -350,15 +357,135 @@ static struct mmap_data mmap_array[MAX_NR_CPUS][MAX_COUNTERS];
 static int nr_poll;
 static int nr_cpu;
 
-static void open_counters(int cpu)
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
+static pid_t pid_synthesize_comm_event(pid_t pid)
+{
+	char filename[PATH_MAX];
+	char bf[BUFSIZ];
+	struct comm_event comm_ev;
+	size_t size;
+	int fd;
+
+	snprintf(filename, sizeof(filename), "/proc/%d/stat", pid);
+
+	fd = open(filename, O_RDONLY);
+	if (fd < 0) {
+		fprintf(stderr, "couldn't open %s\n", filename);
+		exit(EXIT_FAILURE);
+	}
+	if (read(fd, bf, sizeof(bf)) < 0) {
+		fprintf(stderr, "couldn't read %s\n", filename);
+		exit(EXIT_FAILURE);
+	}
+	close(fd);
+
+	pid_t spid, ppid;
+	char state;
+	char comm[18];
+
+	memset(&comm_ev, 0, sizeof(comm_ev));
+        int nr = sscanf(bf, "%d %s %c %d %d ",
+			&spid, comm, &state, &ppid, &comm_ev.pid);
+	if (nr != 5) {
+		fprintf(stderr, "couldn't get COMM and pgid, malformed %s\n",
+			filename);
+		exit(EXIT_FAILURE);
+	}
+	comm_ev.header.type = PERF_EVENT_COMM;
+	comm_ev.tid = pid;
+	size = strlen(comm);
+	comm[--size] = '\0'; /* Remove the ')' at the end */
+	--size; /* Remove the '(' at the begin */
+	memcpy(comm_ev.comm, comm + 1, size);
+	size = ALIGN(size, sizeof(uint64_t));
+	comm_ev.header.size = sizeof(comm_ev) - (sizeof(comm_ev.comm) - size);
+	int ret = write(output, &comm_ev, comm_ev.header.size);
+	if (ret < 0) {
+		perror("failed to write");
+		exit(-1);
+	}
+	return comm_ev.pid;
+}
+
+static void pid_synthesize_mmap_events(pid_t pid, pid_t pgid)
+{
+	char filename[PATH_MAX];
+	FILE *fp;
+
+	snprintf(filename, sizeof(filename), "/proc/%d/maps", pid);
+
+	fp = fopen(filename, "r");
+	if (fp == NULL) {
+		fprintf(stderr, "couldn't open %s\n", filename);
+		exit(EXIT_FAILURE);
+	}
+	while (1) {
+		char bf[BUFSIZ];
+		unsigned char vm_read, vm_write, vm_exec, vm_mayshare;
+		struct mmap_event mmap_ev = {
+			.header.type = PERF_EVENT_MMAP,
+		};
+		unsigned long ino;
+		int major, minor;
+		size_t size;
+		if (fgets(bf, sizeof(bf), fp) == NULL)
+			break;
+
+		/* 00400000-0040c000 r-xp 00000000 fd:01 41038  /bin/cat */
+		sscanf(bf, "%llx-%llx %c%c%c%c %llx %x:%x %lu",
+			&mmap_ev.start, &mmap_ev.len,
+                        &vm_read, &vm_write, &vm_exec, &vm_mayshare,
+                        &mmap_ev.pgoff, &major, &minor, &ino);
+		if (vm_exec == 'x') {
+			char *execname = strrchr(bf, ' ');
+
+			if (execname == NULL || execname[1] != '/')
+				continue;
+
+			execname += 1;
+			size = strlen(execname);
+			execname[size - 1] = '\0'; /* Remove \n */
+			memcpy(mmap_ev.filename, execname, size);
+			size = ALIGN(size, sizeof(uint64_t));
+			mmap_ev.len -= mmap_ev.start;
+			mmap_ev.header.size = (sizeof(mmap_ev) -
+					       (sizeof(mmap_ev.filename) - size));
+			mmap_ev.pid = pgid;
+			mmap_ev.tid = pid;
+
+			if (write(output, &mmap_ev, mmap_ev.header.size) < 0) {
+				perror("failed to write");
+				exit(-1);
+			}
+		}
+	}
+
+	fclose(fp);
+}
+
+static void open_counters(int cpu, pid_t pid)
 {
 	struct perf_counter_hw_event hw_event;
 	int counter, group_fd;
 	int track = 1;
-	pid_t pid = -1;
 
-	if (cpu < 0)
-		pid = 0;
+	if (pid > 0) {
+		pid_t pgid = pid_synthesize_comm_event(pid);
+		pid_synthesize_mmap_events(pid, pgid);
+	}
 
 	group_fd = -1;
 	for (counter = 0; counter < nr_counters; counter++) {
@@ -435,22 +562,24 @@ int cmd_record(int argc, const char **argv)
 	argc -= optind;
 	argv += optind;
 
-	if (!system_wide)
-		open_counters(-1);
-	else for (i = 0; i < nr_cpus; i++)
-		open_counters(i);
+	if (!system_wide) {
+		open_counters(-1, target_pid != -1 ? target_pid : 0);
+	} else for (i = 0; i < nr_cpus; i++)
+		open_counters(i, target_pid);
 
 	signal(SIGCHLD, sig_handler);
 	signal(SIGINT, sig_handler);
 
-	pid = fork();
-	if (pid < 0)
-		perror("failed to fork");
+	if (target_pid == -1) {
+		pid = fork();
+		if (pid < 0)
+			perror("failed to fork");
 
-	if (!pid) {
-		if (execvp(argv[0], argv)) {
-			perror(argv[0]);
-			exit(-1);
+		if (!pid) {
+			if (execvp(argv[0], argv)) {
+				perror(argv[0]);
+				exit(-1);
+			}
 		}
 	}
 
