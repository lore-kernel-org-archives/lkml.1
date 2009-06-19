Return-Path: <linux-kernel-owner+w=401wt.eu-S1757226AbZFSLxh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757226AbZFSLxh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jun 2009 07:53:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755313AbZFSLww
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Jun 2009 07:52:52 -0400
Received: from hera.kernel.org ([140.211.167.34]:46773 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754893AbZFSLwt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jun 2009 07:52:49 -0400
Date: Fri, 19 Jun 2009 11:52:18 GMT
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       a.p.zijlstra@chello.nl, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       a.p.zijlstra@chello.nl, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <new-submission>
References: <new-submission>
Subject: [tip:perfcounters/core] perf_counter tools: Add a data file header
Message-ID: <tip-f5970550d5ccf90453cbd7d260370ea99d1f6513@git.kernel.org>
Git-Commit-ID: f5970550d5ccf90453cbd7d260370ea99d1f6513
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Fri, 19 Jun 2009 11:52:19 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  f5970550d5ccf90453cbd7d260370ea99d1f6513
Gitweb:     http://git.kernel.org/tip/f5970550d5ccf90453cbd7d260370ea99d1f6513
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Thu, 18 Jun 2009 23:22:55 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 19 Jun 2009 13:42:36 +0200

perf_counter tools: Add a data file header

Add a data file header so we can transfer data between record and report.

LKML-Reference: <new-submission>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 tools/perf/builtin-record.c |   94 ++++++++++++++++++++++++-------------------
 tools/perf/builtin-report.c |   16 +++++++-
 tools/perf/perf.h           |    6 +++
 3 files changed, 73 insertions(+), 43 deletions(-)

diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index 06fdfb8..2830467 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -51,6 +51,9 @@ static struct pollfd		event_array[MAX_NR_CPUS * MAX_COUNTERS];
 static int			nr_poll;
 static int			nr_cpu;
 
+static int			file_new = 1;
+static struct perf_file_header	file_header;
+
 struct mmap_event {
 	struct perf_event_header	header;
 	__u32				pid;
@@ -100,6 +103,21 @@ static void mmap_write_tail(struct mmap_data *md, unsigned long tail)
 	pc->data_tail = tail;
 }
 
+static void write_output(void *buf, size_t size)
+{
+	while (size) {
+		int ret = write(output, buf, size);
+
+		if (ret < 0)
+			die("failed to write");
+
+		size -= ret;
+		buf += ret;
+
+		bytes_written += ret;
+	}
+}
+
 static void mmap_read(struct mmap_data *md)
 {
 	unsigned int head = mmap_read_head(md);
@@ -148,34 +166,14 @@ static void mmap_read(struct mmap_data *md)
 		size = md->mask + 1 - (old & md->mask);
 		old += size;
 
-		while (size) {
-			int ret = write(output, buf, size);
-
-			if (ret < 0)
-				die("failed to write");
-
-			size -= ret;
-			buf += ret;
-
-			bytes_written += ret;
-		}
+		write_output(buf, size);
 	}
 
 	buf = &data[old & md->mask];
 	size = head - old;
 	old += size;
 
-	while (size) {
-		int ret = write(output, buf, size);
-
-		if (ret < 0)
-			die("failed to write");
-
-		size -= ret;
-		buf += ret;
-
-		bytes_written += ret;
-	}
+	write_output(buf, size);
 
 	md->prev = old;
 	mmap_write_tail(md, old);
@@ -204,7 +202,7 @@ static void pid_synthesize_comm_event(pid_t pid, int full)
 	struct comm_event comm_ev;
 	char filename[PATH_MAX];
 	char bf[BUFSIZ];
-	int fd, ret;
+	int fd;
 	size_t size;
 	char *field, *sep;
 	DIR *tasks;
@@ -246,11 +244,7 @@ static void pid_synthesize_comm_event(pid_t pid, int full)
 	if (!full) {
 		comm_ev.tid = pid;
 
-		ret = write(output, &comm_ev, comm_ev.header.size);
-		if (ret < 0) {
-			perror("failed to write");
-			exit(-1);
-		}
+		write_output(&comm_ev, comm_ev.header.size);
 		return;
 	}
 
@@ -265,11 +259,7 @@ static void pid_synthesize_comm_event(pid_t pid, int full)
 
 		comm_ev.tid = pid;
 
-		ret = write(output, &comm_ev, comm_ev.header.size);
-		if (ret < 0) {
-			perror("failed to write");
-			exit(-1);
-		}
+		write_output(&comm_ev, comm_ev.header.size);
 	}
 	closedir(tasks);
 	return;
@@ -332,10 +322,7 @@ static void pid_synthesize_mmap_samples(pid_t pid)
 			mmap_ev.pid = pid;
 			mmap_ev.tid = pid;
 
-			if (write(output, &mmap_ev, mmap_ev.header.size) < 0) {
-				perror("failed to write");
-				exit(-1);
-			}
+			write_output(&mmap_ev, mmap_ev.header.size);
 		}
 	}
 
@@ -382,6 +369,15 @@ static void create_counter(int counter, int cpu, pid_t pid)
 	if (call_graph)
 		attr->sample_type	|= PERF_SAMPLE_CALLCHAIN;
 
+	if (file_new) {
+		file_header.sample_type = attr->sample_type;
+	} else {
+		if (file_header.sample_type != attr->sample_type) {
+			fprintf(stderr, "incompatible append\n");
+			exit(-1);
+		}
+	}
+
 	attr->mmap		= track;
 	attr->comm		= track;
 	attr->inherit		= (cpu < 0) && inherit;
@@ -461,6 +457,13 @@ static void open_counters(int cpu, pid_t pid)
 	nr_cpu++;
 }
 
+static void atexit_header(void)
+{
+	file_header.data_size += bytes_written;
+
+	pwrite(output, &file_header, sizeof(file_header), 0);
+}
+
 static int __cmd_record(int argc, const char **argv)
 {
 	int i, counter;
@@ -474,6 +477,10 @@ static int __cmd_record(int argc, const char **argv)
 	assert(nr_cpus <= MAX_NR_CPUS);
 	assert(nr_cpus >= 0);
 
+	atexit(sig_atexit);
+	signal(SIGCHLD, sig_handler);
+	signal(SIGINT, sig_handler);
+
 	if (!stat(output_name, &st) && !force && !append_file) {
 		fprintf(stderr, "Error, output file %s exists, use -A to append or -f to overwrite.\n",
 				output_name);
@@ -482,7 +489,7 @@ static int __cmd_record(int argc, const char **argv)
 
 	flags = O_CREAT|O_RDWR;
 	if (append_file)
-		flags |= O_APPEND;
+		file_new = 0;
 	else
 		flags |= O_TRUNC;
 
@@ -492,15 +499,18 @@ static int __cmd_record(int argc, const char **argv)
 		exit(-1);
 	}
 
+	if (!file_new) {
+		read(output, &file_header, sizeof(file_header));
+		lseek(output, file_header.data_size, SEEK_CUR);
+	}
+
+	atexit(atexit_header);
+
 	if (!system_wide) {
 		open_counters(-1, target_pid != -1 ? target_pid : getpid());
 	} else for (i = 0; i < nr_cpus; i++)
 		open_counters(i, target_pid);
 
-	atexit(sig_atexit);
-	signal(SIGCHLD, sig_handler);
-	signal(SIGINT, sig_handler);
-
 	if (target_pid == -1 && argc) {
 		pid = fork();
 		if (pid < 0)
diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index 7a6577b..37b26ec 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -1366,11 +1366,13 @@ process_event(event_t *event, unsigned long offset, unsigned long head)
 	return 0;
 }
 
+static struct perf_file_header		file_header;
+
 static int __cmd_report(void)
 {
 	int ret, rc = EXIT_FAILURE;
 	unsigned long offset = 0;
-	unsigned long head = 0;
+	unsigned long head = sizeof(file_header);
 	struct stat stat;
 	event_t *event;
 	uint32_t size;
@@ -1398,6 +1400,14 @@ static int __cmd_report(void)
 		exit(0);
 	}
 
+	read(input, &file_header, sizeof(file_header));
+
+	if (sort__has_parent &&
+	    !(file_header.sample_type & PERF_SAMPLE_CALLCHAIN)) {
+		fprintf(stderr, "selected --sort parent, but no callchain data\n");
+		exit(-1);
+	}
+
 	if (load_kernel() < 0) {
 		perror("failed to load kernel symbols");
 		return EXIT_FAILURE;
@@ -1469,9 +1479,13 @@ more:
 
 	head += size;
 
+	if (offset + head >= sizeof(file_header) + file_header.data_size)
+		goto done;
+
 	if (offset + head < stat.st_size)
 		goto more;
 
+done:
 	rc = EXIT_SUCCESS;
 	close(input);
 
diff --git a/tools/perf/perf.h b/tools/perf/perf.h
index 87a1aca..55c62f4 100644
--- a/tools/perf/perf.h
+++ b/tools/perf/perf.h
@@ -65,4 +65,10 @@ sys_perf_counter_open(struct perf_counter_attr *attr,
 #define MAX_COUNTERS			256
 #define MAX_NR_CPUS			256
 
+struct perf_file_header {
+	__u64	version;
+	__u64	sample_type;
+	__u64	data_size;
+};
+
 #endif
