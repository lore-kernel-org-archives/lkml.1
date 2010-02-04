Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758200Ab0BDJ6h (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Feb 2010 04:58:37 -0500
Received: from hera.kernel.org ([140.211.167.34]:60212 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756426Ab0BDJ6b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Feb 2010 04:58:31 -0500
Date: Thu, 4 Feb 2010 09:57:59 GMT
From: tip-bot for Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, hpa@zytor.com,
       mingo@redhat.com, peterz@infradead.org, xiaoguangrong@cn.fujitsu.com,
       fweisbec@gmail.com, rostedt@goodmis.org, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org,
       linux-kernel@vger.kernel.org, peterz@infradead.org,
       xiaoguangrong@cn.fujitsu.com, fweisbec@gmail.com, rostedt@goodmis.org,
       tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <4B6A8972.3070605@cn.fujitsu.com>
References: <4B6A8972.3070605@cn.fujitsu.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools: Clean up O_LARGEFILE et al usage
Message-ID: <tip-f887f3019e56389a73617f4e70f512e82cc89adb@git.kernel.org>
Git-Commit-ID: f887f3019e56389a73617f4e70f512e82cc89adb
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 04 Feb 2010 09:58:00 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  f887f3019e56389a73617f4e70f512e82cc89adb
Gitweb:     http://git.kernel.org/tip/f887f3019e56389a73617f4e70f512e82cc89adb
Author:     Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
AuthorDate: Thu, 4 Feb 2010 16:46:42 +0800
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 4 Feb 2010 10:03:03 +0100

perf tools: Clean up O_LARGEFILE et al usage

Setting _FILE_OFFSET_BITS and using O_LARGEFILE, lseek64, etc,
is redundant. Thanks H. Peter Anvin for pointing it out.

So, this patch removes O_LARGEFILE, lseek64, etc.

Suggested-by: "H. Peter Anvin" <hpa@zytor.com>
Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
LKML-Reference: <4B6A8972.3070605@cn.fujitsu.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 tools/perf/builtin-record.c        |    3 +--
 tools/perf/util/header.c           |   21 ++++++++++-----------
 tools/perf/util/session.c          |    3 +--
 tools/perf/util/trace-event-read.c |   20 ++++++++++----------
 4 files changed, 22 insertions(+), 25 deletions(-)

diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index 706f001..3ad599b 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -5,7 +5,6 @@
  * (or a CPU, or a PID) into the perf.data output file - for
  * later analysis via perf report.
  */
-#define _LARGEFILE64_SOURCE
 #define _FILE_OFFSET_BITS 64
 
 #include "builtin.h"
@@ -451,7 +450,7 @@ static int __cmd_record(int argc, const char **argv)
 		append_file = 0;
 	}
 
-	flags = O_CREAT|O_RDWR|O_LARGEFILE;
+	flags = O_CREAT|O_RDWR;
 	if (append_file)
 		file_new = 0;
 	else
diff --git a/tools/perf/util/header.c b/tools/perf/util/header.c
index d5facd5..6c9aa16 100644
--- a/tools/perf/util/header.c
+++ b/tools/perf/util/header.c
@@ -1,4 +1,3 @@
-#define _LARGEFILE64_SOURCE
 #define _FILE_OFFSET_BITS 64
 
 #include <sys/types.h>
@@ -388,7 +387,7 @@ static int perf_header__adds_write(struct perf_header *self, int fd)
 	sec_size = sizeof(*feat_sec) * nr_sections;
 
 	sec_start = self->data_offset + self->data_size;
-	lseek64(fd, sec_start + sec_size, SEEK_SET);
+	lseek(fd, sec_start + sec_size, SEEK_SET);
 
 	if (perf_header__has_feat(self, HEADER_TRACE_INFO)) {
 		struct perf_file_section *trace_sec;
@@ -396,9 +395,9 @@ static int perf_header__adds_write(struct perf_header *self, int fd)
 		trace_sec = &feat_sec[idx++];
 
 		/* Write trace info */
-		trace_sec->offset = lseek64(fd, 0, SEEK_CUR);
+		trace_sec->offset = lseek(fd, 0, SEEK_CUR);
 		read_tracing_data(fd, attrs, nr_counters);
-		trace_sec->size = lseek64(fd, 0, SEEK_CUR) - trace_sec->offset;
+		trace_sec->size = lseek(fd, 0, SEEK_CUR) - trace_sec->offset;
 	}
 
 
@@ -408,18 +407,18 @@ static int perf_header__adds_write(struct perf_header *self, int fd)
 		buildid_sec = &feat_sec[idx++];
 
 		/* Write build-ids */
-		buildid_sec->offset = lseek64(fd, 0, SEEK_CUR);
+		buildid_sec->offset = lseek(fd, 0, SEEK_CUR);
 		err = dsos__write_buildid_table(fd);
 		if (err < 0) {
 			pr_debug("failed to write buildid table\n");
 			goto out_free;
 		}
-		buildid_sec->size = lseek64(fd, 0, SEEK_CUR) -
-					    buildid_sec->offset;
+		buildid_sec->size = lseek(fd, 0, SEEK_CUR) -
+					  buildid_sec->offset;
 		dsos__cache_build_ids();
 	}
 
-	lseek64(fd, sec_start, SEEK_SET);
+	lseek(fd, sec_start, SEEK_SET);
 	err = do_write(fd, feat_sec, sec_size);
 	if (err < 0)
 		pr_debug("failed to write feature section\n");
@@ -513,7 +512,7 @@ int perf_header__write(struct perf_header *self, int fd, bool at_exit)
 		pr_debug("failed to write perf header\n");
 		return err;
 	}
-	lseek64(fd, self->data_offset + self->data_size, SEEK_SET);
+	lseek(fd, self->data_offset + self->data_size, SEEK_SET);
 
 	self->frozen = 1;
 	return 0;
@@ -567,7 +566,7 @@ int perf_header__process_sections(struct perf_header *self, int fd,
 
 	sec_size = sizeof(*feat_sec) * nr_sections;
 
-	lseek64(fd, self->data_offset + self->data_size, SEEK_SET);
+	lseek(fd, self->data_offset + self->data_size, SEEK_SET);
 
 	if (perf_header__getbuffer64(self, fd, feat_sec, sec_size))
 		goto out_free;
@@ -641,7 +640,7 @@ static int perf_file_section__process(struct perf_file_section *self,
 				      struct perf_header *ph,
 				      int feat, int fd)
 {
-	if (lseek64(fd, self->offset, SEEK_SET) < 0) {
+	if (lseek(fd, self->offset, SEEK_SET) == (off_t)-1) {
 		pr_debug("Failed to lseek to %Ld offset for feature %d, "
 			 "continuing...\n", self->offset, feat);
 		return 0;
diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
index 74cbc64..0de7258 100644
--- a/tools/perf/util/session.c
+++ b/tools/perf/util/session.c
@@ -1,4 +1,3 @@
-#define _LARGEFILE64_SOURCE
 #define _FILE_OFFSET_BITS 64
 
 #include <linux/kernel.h>
@@ -15,7 +14,7 @@ static int perf_session__open(struct perf_session *self, bool force)
 {
 	struct stat input_stat;
 
-	self->fd = open(self->filename, O_RDONLY|O_LARGEFILE);
+	self->fd = open(self->filename, O_RDONLY);
 	if (self->fd < 0) {
 		pr_err("failed to open file: %s", self->filename);
 		if (!strcmp(self->filename, "perf.data"))
diff --git a/tools/perf/util/trace-event-read.c b/tools/perf/util/trace-event-read.c
index ca3c26d..7cd1193 100644
--- a/tools/perf/util/trace-event-read.c
+++ b/tools/perf/util/trace-event-read.c
@@ -18,7 +18,7 @@
  *
  * ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  */
-#define _LARGEFILE64_SOURCE
+#define _FILE_OFFSET_BITS 64
 
 #include <dirent.h>
 #include <stdio.h>
@@ -83,7 +83,7 @@ static char *read_string(void)
 	char *str = NULL;
 	int size = 0;
 	int i;
-	s64 r;
+	off_t r;
 
 	for (;;) {
 		r = read(input_fd, buf, BUFSIZ);
@@ -117,8 +117,8 @@ static char *read_string(void)
 	i++;
 
 	/* move the file descriptor to the end of the string */
-	r = lseek64(input_fd, -(r - i), SEEK_CUR);
-	if (r < 0)
+	r = lseek(input_fd, -(r - i), SEEK_CUR);
+	if (r == (off_t)-1)
 		die("lseek");
 
 	if (str) {
@@ -282,8 +282,8 @@ static void update_cpu_data_index(int cpu)
 
 static void get_next_page(int cpu)
 {
-	off64_t save_seek;
-	off64_t ret;
+	off_t save_seek;
+	off_t ret;
 
 	if (!cpu_data[cpu].page)
 		return;
@@ -298,17 +298,17 @@ static void get_next_page(int cpu)
 		update_cpu_data_index(cpu);
 
 		/* other parts of the code may expect the pointer to not move */
-		save_seek = lseek64(input_fd, 0, SEEK_CUR);
+		save_seek = lseek(input_fd, 0, SEEK_CUR);
 
-		ret = lseek64(input_fd, cpu_data[cpu].offset, SEEK_SET);
-		if (ret < 0)
+		ret = lseek(input_fd, cpu_data[cpu].offset, SEEK_SET);
+		if (ret == (off_t)-1)
 			die("failed to lseek");
 		ret = read(input_fd, cpu_data[cpu].page, page_size);
 		if (ret < 0)
 			die("failed to read page");
 
 		/* reset the file pointer back */
-		lseek64(input_fd, save_seek, SEEK_SET);
+		lseek(input_fd, save_seek, SEEK_SET);
 
 		return;
 	}
