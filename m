Return-Path: <linux-kernel-owner+w=401wt.eu-S1754753AbZJ0NEf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754753AbZJ0NEf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Oct 2009 09:04:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754507AbZJ0NEe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Oct 2009 09:04:34 -0400
Received: from hera.kernel.org ([140.211.167.34]:49146 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754521AbZJ0NEa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Oct 2009 09:04:30 -0400
Date: Tue, 27 Oct 2009 13:03:50 GMT
From: tip-bot for Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, acme@redhat.com,
       hpa@zytor.com, mingo@redhat.com, efault@gmx.de, peterz@infradead.org,
       fweisbec@gmail.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
       linux-kernel@vger.kernel.org, fweisbec@gmail.com, peterz@infradead.org,
       efault@gmx.de, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1256592199-9608-2-git-send-email-acme@redhat.com>
References: <1256592199-9608-2-git-send-email-acme@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools: Generalize event synthesizing routines
Message-ID: <tip-234fbbf508c58c5084292b11b242377553897459@git.kernel.org>
Git-Commit-ID: 234fbbf508c58c5084292b11b242377553897459
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  234fbbf508c58c5084292b11b242377553897459
Gitweb:     http://git.kernel.org/tip/234fbbf508c58c5084292b11b242377553897459
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Mon, 26 Oct 2009 19:23:18 -0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 27 Oct 2009 13:51:53 +0100

perf tools: Generalize event synthesizing routines

Because we will need it in 'perf top' to support userspace
symbols for existing threads.

Now we pass a callback that will receive the synthesized event
and then write it to the output file in 'perf record' and in the
upcoming patch for 'perf top' we will just immediatelly create
the in memory representation of threads and maps.

Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Mike Galbraith <efault@gmx.de>
LKML-Reference: <1256592199-9608-2-git-send-email-acme@redhat.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 tools/perf/Makefile         |    1 +
 tools/perf/builtin-record.c |  181 +++----------------------------------------
 tools/perf/util/event.c     |  177 ++++++++++++++++++++++++++++++++++++++++++
 tools/perf/util/event.h     |    3 +
 4 files changed, 191 insertions(+), 171 deletions(-)

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index 0a40c29..9f4488d 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -380,6 +380,7 @@ LIB_OBJS += util/alias.o
 LIB_OBJS += util/config.o
 LIB_OBJS += util/ctype.o
 LIB_OBJS += util/environment.o
+LIB_OBJS += util/event.o
 LIB_OBJS += util/exec_cmd.o
 LIB_OBJS += util/help.o
 LIB_OBJS += util/levenshtein.o
diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index 9e1638c..4a73d89 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -109,6 +109,12 @@ static void write_output(void *buf, size_t size)
 	}
 }
 
+static int process_synthesized_event(event_t *event)
+{
+	write_output(event, event->header.size);
+	return 0;
+}
+
 static void mmap_read(struct mmap_data *md)
 {
 	unsigned int head = mmap_read_head(md);
@@ -191,172 +197,6 @@ static void sig_atexit(void)
 	kill(getpid(), signr);
 }
 
-static pid_t pid_synthesize_comm_event(pid_t pid, int full)
-{
-	struct comm_event comm_ev;
-	char filename[PATH_MAX];
-	char bf[BUFSIZ];
-	FILE *fp;
-	size_t size = 0;
-	DIR *tasks;
-	struct dirent dirent, *next;
-	pid_t tgid = 0;
-
-	snprintf(filename, sizeof(filename), "/proc/%d/status", pid);
-
-	fp = fopen(filename, "r");
-	if (fp == NULL) {
-out_race:	
-		/*
-		 * We raced with a task exiting - just return:
-		 */
-		if (verbose)
-			fprintf(stderr, "couldn't open %s\n", filename);
-		return 0;
-	}
-
-	memset(&comm_ev, 0, sizeof(comm_ev));
-	while (!comm_ev.comm[0] || !comm_ev.pid) {
-		if (fgets(bf, sizeof(bf), fp) == NULL)
-			goto out_failure;
-
-		if (memcmp(bf, "Name:", 5) == 0) {
-			char *name = bf + 5;
-			while (*name && isspace(*name))
-				++name;
-			size = strlen(name) - 1;
-			memcpy(comm_ev.comm, name, size++);
-		} else if (memcmp(bf, "Tgid:", 5) == 0) {
-			char *tgids = bf + 5;
-			while (*tgids && isspace(*tgids))
-				++tgids;
-			tgid = comm_ev.pid = atoi(tgids);
-		}
-	}
-
-	comm_ev.header.type = PERF_RECORD_COMM;
-	size = ALIGN(size, sizeof(u64));
-	comm_ev.header.size = sizeof(comm_ev) - (sizeof(comm_ev.comm) - size);
-
-	if (!full) {
-		comm_ev.tid = pid;
-
-		write_output(&comm_ev, comm_ev.header.size);
-		goto out_fclose;
-	}
-
-	snprintf(filename, sizeof(filename), "/proc/%d/task", pid);
-
-	tasks = opendir(filename);
-	if (tasks == NULL)
-		goto out_race;
-
-	while (!readdir_r(tasks, &dirent, &next) && next) {
-		char *end;
-		pid = strtol(dirent.d_name, &end, 10);
-		if (*end)
-			continue;
-
-		comm_ev.tid = pid;
-
-		write_output(&comm_ev, comm_ev.header.size);
-	}
-	closedir(tasks);
-
-out_fclose:
-	fclose(fp);
-	return tgid;
-
-out_failure:
-	fprintf(stderr, "couldn't get COMM and pgid, malformed %s\n",
-		filename);
-	exit(EXIT_FAILURE);
-}
-
-static void pid_synthesize_mmap_samples(pid_t pid, pid_t tgid)
-{
-	char filename[PATH_MAX];
-	FILE *fp;
-
-	snprintf(filename, sizeof(filename), "/proc/%d/maps", pid);
-
-	fp = fopen(filename, "r");
-	if (fp == NULL) {
-		/*
-		 * We raced with a task exiting - just return:
-		 */
-		if (verbose)
-			fprintf(stderr, "couldn't open %s\n", filename);
-		return;
-	}
-	while (1) {
-		char bf[BUFSIZ], *pbf = bf;
-		struct mmap_event mmap_ev = {
-			.header = { .type = PERF_RECORD_MMAP },
-		};
-		int n;
-		size_t size;
-		if (fgets(bf, sizeof(bf), fp) == NULL)
-			break;
-
-		/* 00400000-0040c000 r-xp 00000000 fd:01 41038  /bin/cat */
-		n = hex2u64(pbf, &mmap_ev.start);
-		if (n < 0)
-			continue;
-		pbf += n + 1;
-		n = hex2u64(pbf, &mmap_ev.len);
-		if (n < 0)
-			continue;
-		pbf += n + 3;
-		if (*pbf == 'x') { /* vm_exec */
-			char *execname = strchr(bf, '/');
-
-			/* Catch VDSO */
-			if (execname == NULL)
-				execname = strstr(bf, "[vdso]");
-
-			if (execname == NULL)
-				continue;
-
-			size = strlen(execname);
-			execname[size - 1] = '\0'; /* Remove \n */
-			memcpy(mmap_ev.filename, execname, size);
-			size = ALIGN(size, sizeof(u64));
-			mmap_ev.len -= mmap_ev.start;
-			mmap_ev.header.size = (sizeof(mmap_ev) -
-					       (sizeof(mmap_ev.filename) - size));
-			mmap_ev.pid = tgid;
-			mmap_ev.tid = pid;
-
-			write_output(&mmap_ev, mmap_ev.header.size);
-		}
-	}
-
-	fclose(fp);
-}
-
-static void synthesize_all(void)
-{
-	DIR *proc;
-	struct dirent dirent, *next;
-
-	proc = opendir("/proc");
-
-	while (!readdir_r(proc, &dirent, &next) && next) {
-		char *end;
-		pid_t pid, tgid;
-
-		pid = strtol(dirent.d_name, &end, 10);
-		if (*end) /* only interested in proper numerical dirents */
-			continue;
-
-		tgid = pid_synthesize_comm_event(pid, 1);
-		pid_synthesize_mmap_samples(pid, tgid);
-	}
-
-	closedir(proc);
-}
-
 static int group_fd;
 
 static struct perf_header_attr *get_header_attr(struct perf_event_attr *a, int nr)
@@ -608,11 +448,10 @@ static int __cmd_record(int argc, const char **argv)
 	if (file_new)
 		perf_header__write(header, output);
 
-	if (!system_wide) {
-		pid_t tgid = pid_synthesize_comm_event(pid, 0);
-		pid_synthesize_mmap_samples(pid, tgid);
-	} else
-		synthesize_all();
+	if (!system_wide)
+		event__synthesize_thread(pid, process_synthesized_event);
+	else
+		event__synthesize_threads(process_synthesized_event);
 
 	if (target_pid == -1 && argc) {
 		pid = fork();
diff --git a/tools/perf/util/event.c b/tools/perf/util/event.c
new file mode 100644
index 0000000..1dae7e3
--- /dev/null
+++ b/tools/perf/util/event.c
@@ -0,0 +1,177 @@
+#include <linux/types.h>
+#include "event.h"
+#include "debug.h"
+#include "string.h"
+
+static pid_t event__synthesize_comm(pid_t pid, int full,
+				    int (*process)(event_t *event))
+{
+	event_t ev;
+	char filename[PATH_MAX];
+	char bf[BUFSIZ];
+	FILE *fp;
+	size_t size = 0;
+	DIR *tasks;
+	struct dirent dirent, *next;
+	pid_t tgid = 0;
+
+	snprintf(filename, sizeof(filename), "/proc/%d/status", pid);
+
+	fp = fopen(filename, "r");
+	if (fp == NULL) {
+out_race:
+		/*
+		 * We raced with a task exiting - just return:
+		 */
+		pr_debug("couldn't open %s\n", filename);
+		return 0;
+	}
+
+	memset(&ev.comm, 0, sizeof(ev.comm));
+	while (!ev.comm.comm[0] || !ev.comm.pid) {
+		if (fgets(bf, sizeof(bf), fp) == NULL)
+			goto out_failure;
+
+		if (memcmp(bf, "Name:", 5) == 0) {
+			char *name = bf + 5;
+			while (*name && isspace(*name))
+				++name;
+			size = strlen(name) - 1;
+			memcpy(ev.comm.comm, name, size++);
+		} else if (memcmp(bf, "Tgid:", 5) == 0) {
+			char *tgids = bf + 5;
+			while (*tgids && isspace(*tgids))
+				++tgids;
+			tgid = ev.comm.pid = atoi(tgids);
+		}
+	}
+
+	ev.comm.header.type = PERF_RECORD_COMM;
+	size = ALIGN(size, sizeof(u64));
+	ev.comm.header.size = sizeof(ev.comm) - (sizeof(ev.comm.comm) - size);
+
+	if (!full) {
+		ev.comm.tid = pid;
+
+		process(&ev);
+		goto out_fclose;
+	}
+
+	snprintf(filename, sizeof(filename), "/proc/%d/task", pid);
+
+	tasks = opendir(filename);
+	if (tasks == NULL)
+		goto out_race;
+
+	while (!readdir_r(tasks, &dirent, &next) && next) {
+		char *end;
+		pid = strtol(dirent.d_name, &end, 10);
+		if (*end)
+			continue;
+
+		ev.comm.tid = pid;
+
+		process(&ev);
+	}
+	closedir(tasks);
+
+out_fclose:
+	fclose(fp);
+	return tgid;
+
+out_failure:
+	pr_warning("couldn't get COMM and pgid, malformed %s\n", filename);
+	return -1;
+}
+
+static int event__synthesize_mmap_events(pid_t pid, pid_t tgid,
+					 int (*process)(event_t *event))
+{
+	char filename[PATH_MAX];
+	FILE *fp;
+
+	snprintf(filename, sizeof(filename), "/proc/%d/maps", pid);
+
+	fp = fopen(filename, "r");
+	if (fp == NULL) {
+		/*
+		 * We raced with a task exiting - just return:
+		 */
+		pr_debug("couldn't open %s\n", filename);
+		return -1;
+	}
+
+	while (1) {
+		char bf[BUFSIZ], *pbf = bf;
+		event_t ev = {
+			.header = { .type = PERF_RECORD_MMAP },
+		};
+		int n;
+		size_t size;
+		if (fgets(bf, sizeof(bf), fp) == NULL)
+			break;
+
+		/* 00400000-0040c000 r-xp 00000000 fd:01 41038  /bin/cat */
+		n = hex2u64(pbf, &ev.mmap.start);
+		if (n < 0)
+			continue;
+		pbf += n + 1;
+		n = hex2u64(pbf, &ev.mmap.len);
+		if (n < 0)
+			continue;
+		pbf += n + 3;
+		if (*pbf == 'x') { /* vm_exec */
+			char *execname = strchr(bf, '/');
+
+			/* Catch VDSO */
+			if (execname == NULL)
+				execname = strstr(bf, "[vdso]");
+
+			if (execname == NULL)
+				continue;
+
+			size = strlen(execname);
+			execname[size - 1] = '\0'; /* Remove \n */
+			memcpy(ev.mmap.filename, execname, size);
+			size = ALIGN(size, sizeof(u64));
+			ev.mmap.len -= ev.mmap.start;
+			ev.mmap.header.size = (sizeof(ev.mmap) -
+					       (sizeof(ev.mmap.filename) - size));
+			ev.mmap.pid = tgid;
+			ev.mmap.tid = pid;
+
+			process(&ev);
+		}
+	}
+
+	fclose(fp);
+	return 0;
+}
+
+int event__synthesize_thread(pid_t pid, int (*process)(event_t *event))
+{
+	pid_t tgid = event__synthesize_comm(pid, 1, process);
+	if (tgid == -1)
+		return -1;
+	return event__synthesize_mmap_events(pid, tgid, process);
+}
+
+void event__synthesize_threads(int (*process)(event_t *event))
+{
+	DIR *proc;
+	struct dirent dirent, *next;
+
+	proc = opendir("/proc");
+
+	while (!readdir_r(proc, &dirent, &next) && next) {
+		char *end;
+		pid_t pid = strtol(dirent.d_name, &end, 10);
+
+		if (*end) /* only interested in proper numerical dirents */
+			continue;
+
+		event__synthesize_thread(pid, process);
+	}
+
+	closedir(proc);
+}
diff --git a/tools/perf/util/event.h b/tools/perf/util/event.h
index d972b4b..2ae1177 100644
--- a/tools/perf/util/event.h
+++ b/tools/perf/util/event.h
@@ -111,4 +111,7 @@ struct map *map__clone(struct map *self);
 int map__overlap(struct map *l, struct map *r);
 size_t map__fprintf(struct map *self, FILE *fp);
 
+int event__synthesize_thread(pid_t pid, int (*process)(event_t *event));
+void event__synthesize_threads(int (*process)(event_t *event));
+
 #endif /* __PERF_RECORD_H */
