Return-Path: <linux-kernel-owner+w=401wt.eu-S1755490AbZFBOUQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755490AbZFBOUQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jun 2009 10:20:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756861AbZFBOT4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Jun 2009 10:19:56 -0400
Received: from hera.kernel.org ([140.211.167.34]:44590 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755227AbZFBOTy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jun 2009 10:19:54 -0400
Date: Tue, 2 Jun 2009 14:19:20 GMT
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
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
Subject: [tip:perfcounters/core] perf_counter: tools: Expand the COMM,MMAP event synthesizer
Message-ID: <tip-f70e87d7a6d9c5a23d5f43ed0a0c224c157ef597@git.kernel.org>
Git-Commit-ID: f70e87d7a6d9c5a23d5f43ed0a0c224c157ef597
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 02 Jun 2009 14:19:20 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  f70e87d7a6d9c5a23d5f43ed0a0c224c157ef597
Gitweb:     http://git.kernel.org/tip/f70e87d7a6d9c5a23d5f43ed0a0c224c157ef597
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Tue, 2 Jun 2009 14:13:24 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 2 Jun 2009 16:16:26 +0200

perf_counter: tools: Expand the COMM,MMAP event synthesizer

Include code to pre-construct mappings based on /proc,
on system wide recording.

Fix the existing code to properly fill out ->pid and ->tid.

The PID should be the Thread Group ID (PIDTYPE_PID of task->group_leader)
The TID should be the Thread ID (PIDTYPE_PID of task)

Furthermore, change the default sorting of report to comm,dso for a
better quick overview.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Marcelo Tosatti <mtosatti@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: John Kacur <jkacur@redhat.com>
LKML-Reference: <new-submission>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 Documentation/perf_counter/builtin-record.c |   84 ++++++++++++++++++++------
 Documentation/perf_counter/builtin-report.c |    2 +-
 2 files changed, 65 insertions(+), 21 deletions(-)

diff --git a/Documentation/perf_counter/builtin-record.c b/Documentation/perf_counter/builtin-record.c
index 9c151de..810fc27 100644
--- a/Documentation/perf_counter/builtin-record.c
+++ b/Documentation/perf_counter/builtin-record.c
@@ -162,7 +162,7 @@ struct comm_event {
 	char				comm[16];
 };
 
-static pid_t pid_synthesize_comm_event(pid_t pid)
+static void pid_synthesize_comm_event(pid_t pid, int full)
 {
 	struct comm_event comm_ev;
 	char filename[PATH_MAX];
@@ -170,6 +170,8 @@ static pid_t pid_synthesize_comm_event(pid_t pid)
 	int fd, ret;
 	size_t size;
 	char *field, *sep;
+	DIR *tasks;
+	struct dirent dirent, *next;
 
 	snprintf(filename, sizeof(filename), "/proc/%d/stat", pid);
 
@@ -194,29 +196,50 @@ static pid_t pid_synthesize_comm_event(pid_t pid)
 		goto out_failure;
 	size = sep - field;
 	memcpy(comm_ev.comm, field, size++);
-	field = strchr(sep + 4, ' ');
-	if (field == NULL)
-		goto out_failure;
-	comm_ev.pid = atoi(++field);
+
+	comm_ev.pid = pid;
 	comm_ev.header.type = PERF_EVENT_COMM;
-	comm_ev.tid = pid;
 	size = ALIGN(size, sizeof(uint64_t));
 	comm_ev.header.size = sizeof(comm_ev) - (sizeof(comm_ev.comm) - size);
 
-	ret = write(output, &comm_ev, comm_ev.header.size);
-	if (ret < 0) {
-		perror("failed to write");
-		exit(-1);
+	if (!full) {
+		comm_ev.tid = pid;
+
+		ret = write(output, &comm_ev, comm_ev.header.size);
+		if (ret < 0) {
+			perror("failed to write");
+			exit(-1);
+		}
+		return;
+	}
+
+	snprintf(filename, sizeof(filename), "/proc/%d/task", pid);
+
+	tasks = opendir(filename);
+	while (!readdir_r(tasks, &dirent, &next) && next) {
+		char *end;
+		pid = strtol(dirent.d_name, &end, 10);
+		if (*end)
+			continue;
+
+		comm_ev.tid = pid;
+
+		ret = write(output, &comm_ev, comm_ev.header.size);
+		if (ret < 0) {
+			perror("failed to write");
+			exit(-1);
+		}
 	}
-	return comm_ev.pid;
+	closedir(tasks);
+	return;
+
 out_failure:
 	fprintf(stderr, "couldn't get COMM and pgid, malformed %s\n",
 		filename);
 	exit(EXIT_FAILURE);
-	return -1;
 }
 
-static void pid_synthesize_mmap_events(pid_t pid, pid_t pgid)
+static void pid_synthesize_mmap_events(pid_t pid)
 {
 	char filename[PATH_MAX];
 	FILE *fp;
@@ -261,7 +284,7 @@ static void pid_synthesize_mmap_events(pid_t pid, pid_t pgid)
 			mmap_ev.len -= mmap_ev.start;
 			mmap_ev.header.size = (sizeof(mmap_ev) -
 					       (sizeof(mmap_ev.filename) - size));
-			mmap_ev.pid = pgid;
+			mmap_ev.pid = pid;
 			mmap_ev.tid = pid;
 
 			if (write(output, &mmap_ev, mmap_ev.header.size) < 0) {
@@ -274,6 +297,28 @@ static void pid_synthesize_mmap_events(pid_t pid, pid_t pgid)
 	fclose(fp);
 }
 
+static void synthesize_events(void)
+{
+	DIR *proc;
+	struct dirent dirent, *next;
+
+	proc = opendir("/proc");
+
+	while (!readdir_r(proc, &dirent, &next) && next) {
+		char *end;
+		pid_t pid;
+
+		pid = strtol(dirent.d_name, &end, 10);
+		if (*end) /* only interested in proper numerical dirents */
+			continue;
+
+		pid_synthesize_comm_event(pid, 1);
+		pid_synthesize_mmap_events(pid);
+	}
+
+	closedir(proc);
+}
+
 static void open_counters(int cpu, pid_t pid)
 {
 	struct perf_counter_hw_event hw_event;
@@ -281,8 +326,8 @@ static void open_counters(int cpu, pid_t pid)
 	int track = 1;
 
 	if (pid > 0) {
-		pid_t pgid = pid_synthesize_comm_event(pid);
-		pid_synthesize_mmap_events(pid, pgid);
+		pid_synthesize_comm_event(pid, 0);
+		pid_synthesize_mmap_events(pid);
 	}
 
 	group_fd = -1;
@@ -348,7 +393,7 @@ static int __cmd_record(int argc, const char **argv)
 	assert(nr_cpus <= MAX_NR_CPUS);
 	assert(nr_cpus >= 0);
 
-	output = open(output_name, O_CREAT|O_EXCL|O_RDWR, S_IRWXU);
+	output = open(output_name, O_CREAT|O_EXCL|O_TRUNC|O_RDWR, S_IRUSR|S_IWUSR);
 	if (output < 0) {
 		perror("failed to create output file");
 		exit(-1);
@@ -385,9 +430,8 @@ static int __cmd_record(int argc, const char **argv)
 		}
 	}
 
-	/*
-	 * TODO: store the current /proc/$/maps information somewhere
-	 */
+	if (system_wide)
+		synthesize_events();
 
 	while (!done) {
 		int hits = events;
diff --git a/Documentation/perf_counter/builtin-report.c b/Documentation/perf_counter/builtin-report.c
index 20a4e51..0558c1e 100644
--- a/Documentation/perf_counter/builtin-report.c
+++ b/Documentation/perf_counter/builtin-report.c
@@ -18,7 +18,7 @@
 
 static char		const *input_name = "perf.data";
 static char		*vmlinux = NULL;
-static char		*sort_order = "pid,symbol";
+static char		*sort_order = "comm,dso";
 static int		input;
 static int		show_mask = SHOW_KERNEL | SHOW_USER | SHOW_HV;
 
