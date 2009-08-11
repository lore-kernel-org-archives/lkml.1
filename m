Return-Path: <linux-kernel-owner+w=401wt.eu-S1755036AbZHKTWY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755036AbZHKTWY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Aug 2009 15:22:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753653AbZHKTWX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Aug 2009 15:22:23 -0400
Received: from mx2.redhat.com ([66.187.237.31]:46950 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754132AbZHKTWW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Aug 2009 15:22:22 -0400
Date: Tue, 11 Aug 2009 16:22:00 -0300
From: Arnaldo Carvalho de Melo <acme@redhat.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Peter Zijlstra <peterz@infradead.org>,
       Mike Galbraith <efault@gmx.de>,
       =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH tip 2/3] perf record: Fill .tid and .pid correctly when
	synthesizing events
Message-ID: <20090811192200.GF18061@ghostprotocols.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Noticed when trying to record events for a firefox thread. We were
synthesizing both .tid and .pid with the pid passed via --pid. Fix it by
reading /proc/PID/status and getting the tgid to use in .pid, .tid gets
the specified "pid".

Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Frédéric Weisbecker <fweisbec@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-record.c |   71 +++++++++++++++++++++++--------------------
 1 files changed, 38 insertions(+), 33 deletions(-)

diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index 0345aad..30b83de 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -203,46 +203,48 @@ static void sig_atexit(void)
 	kill(getpid(), signr);
 }
 
-static void pid_synthesize_comm_event(pid_t pid, int full)
+static pid_t pid_synthesize_comm_event(pid_t pid, int full)
 {
 	struct comm_event comm_ev;
 	char filename[PATH_MAX];
 	char bf[BUFSIZ];
-	int fd;
-	size_t size;
-	char *field, *sep;
+	FILE *fp;
+	size_t size = 0;
 	DIR *tasks;
 	struct dirent dirent, *next;
+	pid_t tgid = 0;
 
-	snprintf(filename, sizeof(filename), "/proc/%d/stat", pid);
+	snprintf(filename, sizeof(filename), "/proc/%d/status", pid);
 
-	fd = open(filename, O_RDONLY);
-	if (fd < 0) {
+	fp = fopen(filename, "r");
+	if (fd == NULL) {
 		/*
 		 * We raced with a task exiting - just return:
 		 */
 		if (verbose)
 			fprintf(stderr, "couldn't open %s\n", filename);
-		return;
+		return 0;
 	}
-	if (read(fd, bf, sizeof(bf)) < 0) {
-		fprintf(stderr, "couldn't read %s\n", filename);
-		exit(EXIT_FAILURE);
-	}
-	close(fd);
 
-	/* 9027 (cat) R 6747 9027 6747 34816 9027 ... */
 	memset(&comm_ev, 0, sizeof(comm_ev));
-	field = strchr(bf, '(');
-	if (field == NULL)
-		goto out_failure;
-	sep = strchr(++field, ')');
-	if (sep == NULL)
-		goto out_failure;
-	size = sep - field;
-	memcpy(comm_ev.comm, field, size++);
-
-	comm_ev.pid = pid;
+	while (!comm_ev.comm[0] || !comm_ev.pid) {
+		if (fgets(bf, sizeof(bf), fp) == NULL)
+			goto out_failure;
+
+		if (memcmp(bf, "Name:", 5) == 0) {
+			char *name = bf + 5;
+			while (*name && isspace(*name))
+				++name;
+			size = strlen(name) - 1;
+			memcpy(comm_ev.comm, name, size++);
+		} else if (memcmp(bf, "Tgid:", 5) == 0) {
+			char *tgids = bf + 5;
+			while (*tgids && isspace(*tgids))
+				++tgids;
+			tgid = comm_ev.pid = atoi(tgids);
+		}
+	}
+
 	comm_ev.header.type = PERF_EVENT_COMM;
 	size = ALIGN(size, sizeof(u64));
 	comm_ev.header.size = sizeof(comm_ev) - (sizeof(comm_ev.comm) - size);
@@ -251,7 +253,7 @@ static void pid_synthesize_comm_event(pid_t pid, int full)
 		comm_ev.tid = pid;
 
 		write_output(&comm_ev, comm_ev.header.size);
-		return;
+		goto out_fclose;
 	}
 
 	snprintf(filename, sizeof(filename), "/proc/%d/task", pid);
@@ -268,7 +270,10 @@ static void pid_synthesize_comm_event(pid_t pid, int full)
 		write_output(&comm_ev, comm_ev.header.size);
 	}
 	closedir(tasks);
-	return;
+
+out_fclose:
+	fclose(fp);
+	return tgid;
 
 out_failure:
 	fprintf(stderr, "couldn't get COMM and pgid, malformed %s\n",
@@ -276,7 +281,7 @@ out_failure:
 	exit(EXIT_FAILURE);
 }
 
-static void pid_synthesize_mmap_samples(pid_t pid)
+static void pid_synthesize_mmap_samples(pid_t pid, pid_t tgid)
 {
 	char filename[PATH_MAX];
 	FILE *fp;
@@ -328,7 +333,7 @@ static void pid_synthesize_mmap_samples(pid_t pid)
 			mmap_ev.len -= mmap_ev.start;
 			mmap_ev.header.size = (sizeof(mmap_ev) -
 					       (sizeof(mmap_ev.filename) - size));
-			mmap_ev.pid = pid;
+			mmap_ev.pid = tgid;
 			mmap_ev.tid = pid;
 
 			write_output(&mmap_ev, mmap_ev.header.size);
@@ -347,14 +352,14 @@ static void synthesize_all(void)
 
 	while (!readdir_r(proc, &dirent, &next) && next) {
 		char *end;
-		pid_t pid;
+		pid_t pid, tgid;
 
 		pid = strtol(dirent.d_name, &end, 10);
 		if (*end) /* only interested in proper numerical dirents */
 			continue;
 
-		pid_synthesize_comm_event(pid, 1);
-		pid_synthesize_mmap_samples(pid);
+		tgid = pid_synthesize_comm_event(pid, 1);
+		pid_synthesize_mmap_samples(pid, tgid);
 	}
 
 	closedir(proc);
@@ -567,8 +572,8 @@ static int __cmd_record(int argc, const char **argv)
 		perf_header__write(header, output);
 
 	if (!system_wide) {
-		pid_synthesize_comm_event(pid, 0);
-		pid_synthesize_mmap_samples(pid);
+		pid_t tgid = pid_synthesize_comm_event(pid, 0);
+		pid_synthesize_mmap_samples(pid, tgid);
 	} else
 		synthesize_all();
 
-- 
1.6.2.5

