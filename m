Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757292Ab0BDIs4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Feb 2010 03:48:56 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:55433 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1757135Ab0BDIsz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Feb 2010 03:48:55 -0500
Message-ID: <4B6A8972.3070605@cn.fujitsu.com>
Date: Thu, 04 Feb 2010 16:46:42 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: "H. Peter Anvin" <hpa@zytor.com>, Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>, Paul Mackerras <paulus@samba.org>,
       Peter Zijlstra <peterz@infradead.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH v2] perf tools: using O_LARGEFILE to open perf data file 
 - fix
References: <4B68F32A.9040203@cn.fujitsu.com> <4B6958B8.3000606@cn.fujitsu.com> <4B69B2BD.60909@zytor.com>
In-Reply-To: <4B69B2BD.60909@zytor.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Setting _FILE_OFFSET_BITS and using O_LARGEFILE, lseek64, etc, is
redundant. Thanks H. Peter Anvin for point out

So, this patch remove O_LARGEFILE, lseek64, etc

Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
---
 tools/perf/builtin-record.c        |    3 +--
 tools/perf/util/header.c           |   21 ++++++++++-----------
 tools/perf/util/session.c          |    3 +--
 tools/perf/util/trace-event-read.c |   20 ++++++++++----------
 4 files changed, 22 insertions(+), 25 deletions(-)

diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index 949167e..f54672f 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -5,7 +5,6 @@
  * (or a CPU, or a PID) into the perf.data output file - for
  * later analysis via perf report.
  */
-#define _LARGEFILE64_SOURCE
 #define _FILE_OFFSET_BITS 64
 
 #include "builtin.h"
@@ -454,7 +453,7 @@ static int __cmd_record(int argc, const char **argv)
 		append_file = 0;
 	}
 
-	flags = O_CREAT|O_RDWR|O_LARGEFILE;
+	flags = O_CREAT|O_RDWR;
 	if (append_file)
 		file_new = 0;
 	else
diff --git a/tools/perf/util/header.c b/tools/perf/util/header.c
index ed3efd7..48f325b 100644
--- a/tools/perf/util/header.c
+++ b/tools/perf/util/header.c
@@ -1,4 +1,3 @@
-#define _LARGEFILE64_SOURCE
 #define _FILE_OFFSET_BITS 64
 
 #include <sys/types.h>
@@ -385,7 +384,7 @@ static int perf_header__adds_write(struct perf_header *self, int fd)
 	sec_size = sizeof(*feat_sec) * nr_sections;
 
 	sec_start = self->data_offset + self->data_size;
-	lseek64(fd, sec_start + sec_size, SEEK_SET);
+	lseek(fd, sec_start + sec_size, SEEK_SET);
 
 	if (perf_header__has_feat(self, HEADER_TRACE_INFO)) {
 		struct perf_file_section *trace_sec;
@@ -393,9 +392,9 @@ static int perf_header__adds_write(struct perf_header *self, int fd)
 		trace_sec = &feat_sec[idx++];
 
 		/* Write trace info */
-		trace_sec->offset = lseek64(fd, 0, SEEK_CUR);
+		trace_sec->offset = lseek(fd, 0, SEEK_CUR);
 		read_tracing_data(fd, attrs, nr_counters);
-		trace_sec->size = lseek64(fd, 0, SEEK_CUR) - trace_sec->offset;
+		trace_sec->size = lseek(fd, 0, SEEK_CUR) - trace_sec->offset;
 	}
 
 
@@ -405,18 +404,18 @@ static int perf_header__adds_write(struct perf_header *self, int fd)
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
@@ -510,7 +509,7 @@ int perf_header__write(struct perf_header *self, int fd, bool at_exit)
 		pr_debug("failed to write perf header\n");
 		return err;
 	}
-	lseek64(fd, self->data_offset + self->data_size, SEEK_SET);
+	lseek(fd, self->data_offset + self->data_size, SEEK_SET);
 
 	self->frozen = 1;
 	return 0;
@@ -564,7 +563,7 @@ int perf_header__process_sections(struct perf_header *self, int fd,
 
 	sec_size = sizeof(*feat_sec) * nr_sections;
 
-	lseek64(fd, self->data_offset + self->data_size, SEEK_SET);
+	lseek(fd, self->data_offset + self->data_size, SEEK_SET);
 
 	if (perf_header__getbuffer64(self, fd, feat_sec, sec_size))
 		goto out_free;
@@ -638,7 +637,7 @@ static int perf_file_section__process(struct perf_file_section *self,
 				      struct perf_header *ph,
 				      int feat, int fd)
 {
-	if (lseek64(fd, self->offset, SEEK_SET) < 0) {
+	if (lseek(fd, self->offset, SEEK_SET) == (off_t)-1) {
 		pr_debug("Failed to lseek to %Ld offset for feature %d, "
 			 "continuing...\n", self->offset, feat);
 		return 0;
diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
index cf91d09..d5ebbc8 100644
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
-- 
1.6.1.2


