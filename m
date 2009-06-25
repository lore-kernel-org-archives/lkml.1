Return-Path: <linux-kernel-owner+w=401wt.eu-S1758896AbZFYTnY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758896AbZFYTnY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jun 2009 15:43:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753358AbZFYTnN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jun 2009 15:43:13 -0400
Received: from hera.kernel.org ([140.211.167.34]:45283 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752974AbZFYTnL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jun 2009 15:43:11 -0400
Date: Thu, 25 Jun 2009 19:42:32 GMT
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       a.p.zijlstra@chello.nl, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       a.p.zijlstra@chello.nl, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <new-submission>
References: <new-submission>
Subject: [tip:perfcounters/urgent] perf_counter tools: Rework the file format
Message-ID: <tip-7c6a1c65bbd3be688e581511f45818663efc1877@git.kernel.org>
Git-Commit-ID: 7c6a1c65bbd3be688e581511f45818663efc1877
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Thu, 25 Jun 2009 19:42:35 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  7c6a1c65bbd3be688e581511f45818663efc1877
Gitweb:     http://git.kernel.org/tip/7c6a1c65bbd3be688e581511f45818663efc1877
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Thu, 25 Jun 2009 17:05:54 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 25 Jun 2009 21:39:04 +0200

perf_counter tools: Rework the file format

Create a structured file format that includes the full
perf_counter_attr and all its relevant counter IDs so that
the reporting program has full information.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <new-submission>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 tools/perf/Makefile           |    3 +-
 tools/perf/builtin-record.c   |  100 +++++++++++------
 tools/perf/builtin-report.c   |   37 +++++--
 tools/perf/perf.h             |    8 +-
 tools/perf/util/header.c      |  242 +++++++++++++++++++++++++++++++++++++++++
 tools/perf/util/header.h      |   37 ++++++
 tools/perf/util/string.h      |    2 +-
 tools/perf/util/symbol.h      |    2 +-
 tools/perf/{ => util}/types.h |    0
 9 files changed, 377 insertions(+), 54 deletions(-)

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index 36d7eef..d3887ed 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -290,7 +290,7 @@ LIB_FILE=libperf.a
 
 LIB_H += ../../include/linux/perf_counter.h
 LIB_H += perf.h
-LIB_H += types.h
+LIB_H += util/types.h
 LIB_H += util/list.h
 LIB_H += util/rbtree.h
 LIB_H += util/levenshtein.h
@@ -328,6 +328,7 @@ LIB_OBJS += util/sigchain.o
 LIB_OBJS += util/symbol.o
 LIB_OBJS += util/color.o
 LIB_OBJS += util/pager.o
+LIB_OBJS += util/header.o
 
 BUILTIN_OBJS += builtin-annotate.o
 BUILTIN_OBJS += builtin-help.o
diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index 9b899ba..f4f0240 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -14,6 +14,8 @@
 #include "util/parse-events.h"
 #include "util/string.h"
 
+#include "util/header.h"
+
 #include <unistd.h>
 #include <sched.h>
 
@@ -52,7 +54,8 @@ static int			nr_poll;
 static int			nr_cpu;
 
 static int			file_new = 1;
-static struct perf_file_header	file_header;
+
+struct perf_header		*header;
 
 struct mmap_event {
 	struct perf_event_header	header;
@@ -328,7 +331,7 @@ static void pid_synthesize_mmap_samples(pid_t pid)
 	fclose(fp);
 }
 
-static void synthesize_samples(void)
+static void synthesize_all(void)
 {
 	DIR *proc;
 	struct dirent dirent, *next;
@@ -352,10 +355,35 @@ static void synthesize_samples(void)
 
 static int group_fd;
 
+static struct perf_header_attr *get_header_attr(struct perf_counter_attr *a, int nr)
+{
+	struct perf_header_attr *h_attr;
+
+	if (nr < header->attrs) {
+		h_attr = header->attr[nr];
+	} else {
+		h_attr = perf_header_attr__new(a);
+		perf_header__add_attr(header, h_attr);
+	}
+
+	return h_attr;
+}
+
 static void create_counter(int counter, int cpu, pid_t pid)
 {
 	struct perf_counter_attr *attr = attrs + counter;
-	int track = 1;
+	struct perf_header_attr *h_attr;
+	int track = !counter; /* only the first counter needs these */
+	struct {
+		u64 count;
+		u64 time_enabled;
+		u64 time_running;
+		u64 id;
+	} read_data;
+
+	attr->read_format	= PERF_FORMAT_TOTAL_TIME_ENABLED |
+				  PERF_FORMAT_TOTAL_TIME_RUNNING |
+				  PERF_FORMAT_ID;
 
 	attr->sample_type	= PERF_SAMPLE_IP | PERF_SAMPLE_TID;
 
@@ -368,22 +396,11 @@ static void create_counter(int counter, int cpu, pid_t pid)
 	if (call_graph)
 		attr->sample_type	|= PERF_SAMPLE_CALLCHAIN;
 
-	if (file_new) {
-		file_header.sample_type = attr->sample_type;
-	} else {
-		if (file_header.sample_type != attr->sample_type) {
-			fprintf(stderr, "incompatible append\n");
-			exit(-1);
-		}
-	}
-
 	attr->mmap		= track;
 	attr->comm		= track;
 	attr->inherit		= (cpu < 0) && inherit;
 	attr->disabled		= 1;
 
-	track = 0; /* only the first counter needs these */
-
 try_again:
 	fd[nr_cpu][counter] = sys_perf_counter_open(attr, pid, cpu, group_fd, 0);
 
@@ -414,6 +431,19 @@ try_again:
 		exit(-1);
 	}
 
+	h_attr = get_header_attr(attr, counter);
+
+	if (!file_new) {
+		if (memcmp(&h_attr->attr, attr, sizeof(*attr))) {
+			fprintf(stderr, "incompatible append\n");
+			exit(-1);
+		}
+	}
+
+	read(fd[nr_cpu][counter], &read_data, sizeof(read_data));
+
+	perf_header_attr__add_id(h_attr, read_data.id);
+
 	assert(fd[nr_cpu][counter] >= 0);
 	fcntl(fd[nr_cpu][counter], F_SETFL, O_NONBLOCK);
 
@@ -444,11 +474,6 @@ static void open_counters(int cpu, pid_t pid)
 {
 	int counter;
 
-	if (pid > 0) {
-		pid_synthesize_comm_event(pid, 0);
-		pid_synthesize_mmap_samples(pid);
-	}
-
 	group_fd = -1;
 	for (counter = 0; counter < nr_counters; counter++)
 		create_counter(counter, cpu, pid);
@@ -458,17 +483,16 @@ static void open_counters(int cpu, pid_t pid)
 
 static void atexit_header(void)
 {
-	file_header.data_size += bytes_written;
+	header->data_size += bytes_written;
 
-	if (pwrite(output, &file_header, sizeof(file_header), 0) == -1)
-		perror("failed to write on file headers");
+	perf_header__write(header, output);
 }
 
 static int __cmd_record(int argc, const char **argv)
 {
 	int i, counter;
 	struct stat st;
-	pid_t pid;
+	pid_t pid = 0;
 	int flags;
 	int ret;
 
@@ -499,22 +523,31 @@ static int __cmd_record(int argc, const char **argv)
 		exit(-1);
 	}
 
-	if (!file_new) {
-		if (read(output, &file_header, sizeof(file_header)) == -1) {
-			perror("failed to read file headers");
-			exit(-1);
-		}
-
-		lseek(output, file_header.data_size, SEEK_CUR);
-	}
+	if (!file_new)
+		header = perf_header__read(output);
+	else
+		header = perf_header__new();
 
 	atexit(atexit_header);
 
 	if (!system_wide) {
-		open_counters(-1, target_pid != -1 ? target_pid : getpid());
+		pid = target_pid;
+		if (pid == -1)
+			pid = getpid();
+
+		open_counters(-1, pid);
 	} else for (i = 0; i < nr_cpus; i++)
 		open_counters(i, target_pid);
 
+	if (file_new)
+		perf_header__write(header, output);
+
+	if (!system_wide) {
+		pid_synthesize_comm_event(pid, 0);
+		pid_synthesize_mmap_samples(pid);
+	} else
+		synthesize_all();
+
 	if (target_pid == -1 && argc) {
 		pid = fork();
 		if (pid < 0)
@@ -538,9 +571,6 @@ static int __cmd_record(int argc, const char **argv)
 		}
 	}
 
-	if (system_wide)
-		synthesize_samples();
-
 	while (!done) {
 		int hits = samples;
 
diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index b4e76f7..e575f30 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -17,6 +17,7 @@
 #include "util/string.h"
 
 #include "perf.h"
+#include "util/header.h"
 
 #include "util/parse-options.h"
 #include "util/parse-events.h"
@@ -1385,13 +1386,27 @@ process_event(event_t *event, unsigned long offset, unsigned long head)
 	return 0;
 }
 
-static struct perf_file_header		file_header;
+static struct perf_header	*header;
+
+static int perf_header__has_sample(u64 sample_mask)
+{
+	int i;
+
+	for (i = 0; i < header->attrs; i++) {
+		struct perf_header_attr *attr = header->attr[i];
+
+		if (!(attr->attr.sample_type & sample_mask))
+			return 0;
+	}
+
+	return 1;
+}
 
 static int __cmd_report(void)
 {
 	int ret, rc = EXIT_FAILURE;
 	unsigned long offset = 0;
-	unsigned long head = sizeof(file_header);
+	unsigned long head, shift;
 	struct stat stat;
 	event_t *event;
 	uint32_t size;
@@ -1419,13 +1434,11 @@ static int __cmd_report(void)
 		exit(0);
 	}
 
-	if (read(input, &file_header, sizeof(file_header)) == -1) {
-		perror("failed to read file headers");
-		exit(-1);
-	}
+	header = perf_header__read(input);
+	head = header->data_offset;
 
 	if (sort__has_parent &&
-	    !(file_header.sample_type & PERF_SAMPLE_CALLCHAIN)) {
+	    !perf_header__has_sample(PERF_SAMPLE_CALLCHAIN)) {
 		fprintf(stderr, "selected --sort parent, but no callchain data\n");
 		exit(-1);
 	}
@@ -1445,6 +1458,11 @@ static int __cmd_report(void)
 		cwd = NULL;
 		cwdlen = 0;
 	}
+
+	shift = page_size * (head / page_size);
+	offset += shift;
+	head -= shift;
+
 remap:
 	buf = (char *)mmap(NULL, page_size * mmap_window, PROT_READ,
 			   MAP_SHARED, input, offset);
@@ -1461,9 +1479,10 @@ more:
 		size = 8;
 
 	if (head + event->header.size >= page_size * mmap_window) {
-		unsigned long shift = page_size * (head / page_size);
 		int ret;
 
+		shift = page_size * (head / page_size);
+
 		ret = munmap(buf, page_size * mmap_window);
 		assert(ret == 0);
 
@@ -1501,7 +1520,7 @@ more:
 
 	head += size;
 
-	if (offset + head >= sizeof(file_header) + file_header.data_size)
+	if (offset + head >= header->data_offset + header->data_size)
 		goto done;
 
 	if (offset + head < stat.st_size)
diff --git a/tools/perf/perf.h b/tools/perf/perf.h
index bccb529..16c84fd 100644
--- a/tools/perf/perf.h
+++ b/tools/perf/perf.h
@@ -19,7 +19,7 @@
 #include <sys/syscall.h>
 
 #include "../../include/linux/perf_counter.h"
-#include "types.h"
+#include "util/types.h"
 
 /*
  * prctl(PR_TASK_PERF_COUNTERS_DISABLE) will (cheaply) disable all
@@ -66,10 +66,4 @@ sys_perf_counter_open(struct perf_counter_attr *attr,
 #define MAX_COUNTERS			256
 #define MAX_NR_CPUS			256
 
-struct perf_file_header {
-	u64	version;
-	u64	sample_type;
-	u64	data_size;
-};
-
 #endif
diff --git a/tools/perf/util/header.c b/tools/perf/util/header.c
new file mode 100644
index 0000000..450384b
--- /dev/null
+++ b/tools/perf/util/header.c
@@ -0,0 +1,242 @@
+#include <sys/types.h>
+#include <unistd.h>
+#include <stdio.h>
+#include <stdlib.h>
+
+#include "util.h"
+#include "header.h"
+
+/*
+ *
+ */
+
+struct perf_header_attr *perf_header_attr__new(struct perf_counter_attr *attr)
+{
+	struct perf_header_attr *self = malloc(sizeof(*self));
+
+	if (!self)
+		die("nomem");
+
+	self->attr = *attr;
+	self->ids = 0;
+	self->size = 1;
+	self->id = malloc(sizeof(u64));
+
+	if (!self->id)
+		die("nomem");
+
+	return self;
+}
+
+void perf_header_attr__add_id(struct perf_header_attr *self, u64 id)
+{
+	int pos = self->ids;
+
+	self->ids++;
+	if (self->ids > self->size) {
+		self->size *= 2;
+		self->id = realloc(self->id, self->size * sizeof(u64));
+		if (!self->id)
+			die("nomem");
+	}
+	self->id[pos] = id;
+}
+
+/*
+ *
+ */
+
+struct perf_header *perf_header__new(void)
+{
+	struct perf_header *self = malloc(sizeof(*self));
+
+	if (!self)
+		die("nomem");
+
+	self->frozen = 0;
+
+	self->attrs = 0;
+	self->size = 1;
+	self->attr = malloc(sizeof(void *));
+
+	if (!self->attr)
+		die("nomem");
+
+	self->data_offset = 0;
+	self->data_size = 0;
+
+	return self;
+}
+
+void perf_header__add_attr(struct perf_header *self,
+			   struct perf_header_attr *attr)
+{
+	int pos = self->attrs;
+
+	if (self->frozen)
+		die("frozen");
+
+	self->attrs++;
+	if (self->attrs > self->size) {
+		self->size *= 2;
+		self->attr = realloc(self->attr, self->size * sizeof(void *));
+		if (!self->attr)
+			die("nomem");
+	}
+	self->attr[pos] = attr;
+}
+
+static const char *__perf_magic = "PERFFILE";
+
+#define PERF_MAGIC	(*(u64 *)__perf_magic)
+
+struct perf_file_section {
+	u64 offset;
+	u64 size;
+};
+
+struct perf_file_attr {
+	struct perf_counter_attr	attr;
+	struct perf_file_section	ids;
+};
+
+struct perf_file_header {
+	u64				magic;
+	u64				size;
+	u64				attr_size;
+	struct perf_file_section	attrs;
+	struct perf_file_section	data;
+};
+
+static void do_write(int fd, void *buf, size_t size)
+{
+	while (size) {
+		int ret = write(fd, buf, size);
+
+		if (ret < 0)
+			die("failed to write");
+
+		size -= ret;
+		buf += ret;
+	}
+}
+
+void perf_header__write(struct perf_header *self, int fd)
+{
+	struct perf_file_header f_header;
+	struct perf_file_attr   f_attr;
+	struct perf_header_attr	*attr;
+	int i;
+
+	lseek(fd, sizeof(f_header), SEEK_SET);
+
+
+	for (i = 0; i < self->attrs; i++) {
+		attr = self->attr[i];
+
+		attr->id_offset = lseek(fd, 0, SEEK_CUR);
+		do_write(fd, attr->id, attr->ids * sizeof(u64));
+	}
+
+
+	self->attr_offset = lseek(fd, 0, SEEK_CUR);
+
+	for (i = 0; i < self->attrs; i++) {
+		attr = self->attr[i];
+
+		f_attr = (struct perf_file_attr){
+			.attr = attr->attr,
+			.ids  = {
+				.offset = attr->id_offset,
+				.size   = attr->ids * sizeof(u64),
+			}
+		};
+		do_write(fd, &f_attr, sizeof(f_attr));
+	}
+
+
+	self->data_offset = lseek(fd, 0, SEEK_CUR);
+
+	f_header = (struct perf_file_header){
+		.magic	   = PERF_MAGIC,
+		.size	   = sizeof(f_header),
+		.attr_size = sizeof(f_attr),
+		.attrs = {
+			.offset = self->attr_offset,
+			.size   = self->attrs * sizeof(f_attr),
+		},
+		.data = {
+			.offset = self->data_offset,
+			.size	= self->data_size,
+		},
+	};
+
+	lseek(fd, 0, SEEK_SET);
+	do_write(fd, &f_header, sizeof(f_header));
+	lseek(fd, self->data_offset + self->data_size, SEEK_SET);
+
+	self->frozen = 1;
+}
+
+static void do_read(int fd, void *buf, size_t size)
+{
+	while (size) {
+		int ret = read(fd, buf, size);
+
+		if (ret < 0)
+			die("failed to read");
+
+		size -= ret;
+		buf += ret;
+	}
+}
+
+struct perf_header *perf_header__read(int fd)
+{
+	struct perf_header	*self = perf_header__new();
+	struct perf_file_header f_header;
+	struct perf_file_attr	f_attr;
+	u64			f_id;
+
+	int nr_attrs, nr_ids, i, j;
+
+	lseek(fd, 0, SEEK_SET);
+	do_read(fd, &f_header, sizeof(f_header));
+
+	if (f_header.magic	!= PERF_MAGIC		||
+	    f_header.size	!= sizeof(f_header)	||
+	    f_header.attr_size	!= sizeof(f_attr))
+		die("incompatible file format");
+
+	nr_attrs = f_header.attrs.size / sizeof(f_attr);
+	lseek(fd, f_header.attrs.offset, SEEK_SET);
+
+	for (i = 0; i < nr_attrs; i++) {
+		struct perf_header_attr *attr;
+		off_t tmp = lseek(fd, 0, SEEK_CUR);
+
+		do_read(fd, &f_attr, sizeof(f_attr));
+
+		attr = perf_header_attr__new(&f_attr.attr);
+
+		nr_ids = f_attr.ids.size / sizeof(u64);
+		lseek(fd, f_attr.ids.offset, SEEK_SET);
+
+		for (j = 0; j < nr_ids; j++) {
+			do_read(fd, &f_id, sizeof(f_id));
+
+			perf_header_attr__add_id(attr, f_id);
+		}
+		perf_header__add_attr(self, attr);
+		lseek(fd, tmp, SEEK_SET);
+	}
+
+	self->data_offset = f_header.data.offset;
+	self->data_size   = f_header.data.size;
+
+	lseek(fd, self->data_offset + self->data_size, SEEK_SET);
+
+	self->frozen = 1;
+
+	return self;
+}
diff --git a/tools/perf/util/header.h b/tools/perf/util/header.h
new file mode 100644
index 0000000..b5ef53a
--- /dev/null
+++ b/tools/perf/util/header.h
@@ -0,0 +1,37 @@
+#ifndef _PERF_HEADER_H
+#define _PERF_HEADER_H
+
+#include "../../../include/linux/perf_counter.h"
+#include <sys/types.h>
+#include "types.h"
+
+struct perf_header_attr {
+	struct perf_counter_attr attr;
+	int ids, size;
+	u64 *id;
+	off_t id_offset;
+};
+
+struct perf_header {
+	int frozen;
+	int attrs, size;
+	struct perf_header_attr **attr;
+	off_t attr_offset;
+	u64 data_offset;
+	u64 data_size;
+};
+
+struct perf_header *perf_header__read(int fd);
+void perf_header__write(struct perf_header *self, int fd);
+
+void perf_header__add_attr(struct perf_header *self,
+			   struct perf_header_attr *attr);
+
+struct perf_header_attr *
+perf_header_attr__new(struct perf_counter_attr *attr);
+void perf_header_attr__add_id(struct perf_header_attr *self, u64 id);
+
+
+struct perf_header *perf_header__new(void);
+
+#endif /* _PERF_HEADER_H */
diff --git a/tools/perf/util/string.h b/tools/perf/util/string.h
index 37b0325..3dca2f6 100644
--- a/tools/perf/util/string.h
+++ b/tools/perf/util/string.h
@@ -1,7 +1,7 @@
 #ifndef _PERF_STRING_H_
 #define _PERF_STRING_H_
 
-#include "../types.h"
+#include "types.h"
 
 int hex2u64(const char *ptr, u64 *val);
 
diff --git a/tools/perf/util/symbol.h b/tools/perf/util/symbol.h
index ea332e5..940b432 100644
--- a/tools/perf/util/symbol.h
+++ b/tools/perf/util/symbol.h
@@ -2,7 +2,7 @@
 #define _PERF_SYMBOL_ 1
 
 #include <linux/types.h>
-#include "../types.h"
+#include "types.h"
 #include "list.h"
 #include "rbtree.h"
 
diff --git a/tools/perf/types.h b/tools/perf/util/types.h
similarity index 100%
rename from tools/perf/types.h
rename to tools/perf/util/types.h
