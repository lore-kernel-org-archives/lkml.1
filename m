Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755680Ab0BCIqh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Feb 2010 03:46:37 -0500
Received: from hera.kernel.org ([140.211.167.34]:44957 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755393Ab0BCIqe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Feb 2010 03:46:34 -0500
Date: Wed, 3 Feb 2010 08:45:35 GMT
From: tip-bot for Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, hpa@zytor.com,
       mingo@redhat.com, peterz@infradead.org, xiaoguangrong@cn.fujitsu.com,
       fweisbec@gmail.com, rostedt@goodmis.org, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org,
       linux-kernel@vger.kernel.org, peterz@infradead.org,
       xiaoguangrong@cn.fujitsu.com, fweisbec@gmail.com, rostedt@goodmis.org,
       tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <4B68F32A.9040203@cn.fujitsu.com>
References: <4B68F32A.9040203@cn.fujitsu.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools: Use O_LARGEFILE to open perf data file
Message-ID: <tip-b8f46c5a34fa64fd456295388d18f50ae69d9f37@git.kernel.org>
Git-Commit-ID: b8f46c5a34fa64fd456295388d18f50ae69d9f37
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 03 Feb 2010 08:45:36 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  b8f46c5a34fa64fd456295388d18f50ae69d9f37
Gitweb:     http://git.kernel.org/tip/b8f46c5a34fa64fd456295388d18f50ae69d9f37
Author:     Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
AuthorDate: Wed, 3 Feb 2010 11:53:14 +0800
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 3 Feb 2010 09:03:59 +0100

perf tools: Use O_LARGEFILE to open perf data file

Open perf data file with O_LARGEFILE flag since its size is
easily larger that 2G.

For example:

 # rm -rf perf.data
 # ./perf kmem record sleep 300

 [ perf record: Woken up 0 times to write data ]
 [ perf record: Captured and wrote 3142.147 MB perf.data
 (~137282513 samples) ]

 # ll -h perf.data
 -rw------- 1 root root 3.1G .....

Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
LKML-Reference: <4B68F32A.9040203@cn.fujitsu.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 tools/perf/builtin-record.c        |    5 ++++-
 tools/perf/util/header.c           |   22 +++++++++++++---------
 tools/perf/util/session.c          |    5 ++++-
 tools/perf/util/trace-event-read.c |    4 ++--
 4 files changed, 23 insertions(+), 13 deletions(-)

diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index eea5691..949167e 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -5,6 +5,9 @@
  * (or a CPU, or a PID) into the perf.data output file - for
  * later analysis via perf report.
  */
+#define _LARGEFILE64_SOURCE
+#define _FILE_OFFSET_BITS 64
+
 #include "builtin.h"
 
 #include "perf.h"
@@ -451,7 +454,7 @@ static int __cmd_record(int argc, const char **argv)
 		append_file = 0;
 	}
 
-	flags = O_CREAT|O_RDWR;
+	flags = O_CREAT|O_RDWR|O_LARGEFILE;
 	if (append_file)
 		file_new = 0;
 	else
diff --git a/tools/perf/util/header.c b/tools/perf/util/header.c
index 2bb2bdb..ed3efd7 100644
--- a/tools/perf/util/header.c
+++ b/tools/perf/util/header.c
@@ -1,3 +1,6 @@
+#define _LARGEFILE64_SOURCE
+#define _FILE_OFFSET_BITS 64
+
 #include <sys/types.h>
 #include <byteswap.h>
 #include <unistd.h>
@@ -382,7 +385,7 @@ static int perf_header__adds_write(struct perf_header *self, int fd)
 	sec_size = sizeof(*feat_sec) * nr_sections;
 
 	sec_start = self->data_offset + self->data_size;
-	lseek(fd, sec_start + sec_size, SEEK_SET);
+	lseek64(fd, sec_start + sec_size, SEEK_SET);
 
 	if (perf_header__has_feat(self, HEADER_TRACE_INFO)) {
 		struct perf_file_section *trace_sec;
@@ -390,9 +393,9 @@ static int perf_header__adds_write(struct perf_header *self, int fd)
 		trace_sec = &feat_sec[idx++];
 
 		/* Write trace info */
-		trace_sec->offset = lseek(fd, 0, SEEK_CUR);
+		trace_sec->offset = lseek64(fd, 0, SEEK_CUR);
 		read_tracing_data(fd, attrs, nr_counters);
-		trace_sec->size = lseek(fd, 0, SEEK_CUR) - trace_sec->offset;
+		trace_sec->size = lseek64(fd, 0, SEEK_CUR) - trace_sec->offset;
 	}
 
 
@@ -402,17 +405,18 @@ static int perf_header__adds_write(struct perf_header *self, int fd)
 		buildid_sec = &feat_sec[idx++];
 
 		/* Write build-ids */
-		buildid_sec->offset = lseek(fd, 0, SEEK_CUR);
+		buildid_sec->offset = lseek64(fd, 0, SEEK_CUR);
 		err = dsos__write_buildid_table(fd);
 		if (err < 0) {
 			pr_debug("failed to write buildid table\n");
 			goto out_free;
 		}
-		buildid_sec->size = lseek(fd, 0, SEEK_CUR) - buildid_sec->offset;
+		buildid_sec->size = lseek64(fd, 0, SEEK_CUR) -
+					    buildid_sec->offset;
 		dsos__cache_build_ids();
 	}
 
-	lseek(fd, sec_start, SEEK_SET);
+	lseek64(fd, sec_start, SEEK_SET);
 	err = do_write(fd, feat_sec, sec_size);
 	if (err < 0)
 		pr_debug("failed to write feature section\n");
@@ -506,7 +510,7 @@ int perf_header__write(struct perf_header *self, int fd, bool at_exit)
 		pr_debug("failed to write perf header\n");
 		return err;
 	}
-	lseek(fd, self->data_offset + self->data_size, SEEK_SET);
+	lseek64(fd, self->data_offset + self->data_size, SEEK_SET);
 
 	self->frozen = 1;
 	return 0;
@@ -560,7 +564,7 @@ int perf_header__process_sections(struct perf_header *self, int fd,
 
 	sec_size = sizeof(*feat_sec) * nr_sections;
 
-	lseek(fd, self->data_offset + self->data_size, SEEK_SET);
+	lseek64(fd, self->data_offset + self->data_size, SEEK_SET);
 
 	if (perf_header__getbuffer64(self, fd, feat_sec, sec_size))
 		goto out_free;
@@ -634,7 +638,7 @@ static int perf_file_section__process(struct perf_file_section *self,
 				      struct perf_header *ph,
 				      int feat, int fd)
 {
-	if (lseek(fd, self->offset, SEEK_SET) < 0) {
+	if (lseek64(fd, self->offset, SEEK_SET) < 0) {
 		pr_debug("Failed to lseek to %Ld offset for feature %d, "
 			 "continuing...\n", self->offset, feat);
 		return 0;
diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
index 8e7c189..cf91d09 100644
--- a/tools/perf/util/session.c
+++ b/tools/perf/util/session.c
@@ -1,3 +1,6 @@
+#define _LARGEFILE64_SOURCE
+#define _FILE_OFFSET_BITS 64
+
 #include <linux/kernel.h>
 
 #include <byteswap.h>
@@ -12,7 +15,7 @@ static int perf_session__open(struct perf_session *self, bool force)
 {
 	struct stat input_stat;
 
-	self->fd = open(self->filename, O_RDONLY);
+	self->fd = open(self->filename, O_RDONLY|O_LARGEFILE);
 	if (self->fd < 0) {
 		pr_err("failed to open file: %s", self->filename);
 		if (!strcmp(self->filename, "perf.data"))
diff --git a/tools/perf/util/trace-event-read.c b/tools/perf/util/trace-event-read.c
index 1744422..ca3c26d 100644
--- a/tools/perf/util/trace-event-read.c
+++ b/tools/perf/util/trace-event-read.c
@@ -83,7 +83,7 @@ static char *read_string(void)
 	char *str = NULL;
 	int size = 0;
 	int i;
-	int r;
+	s64 r;
 
 	for (;;) {
 		r = read(input_fd, buf, BUFSIZ);
@@ -117,7 +117,7 @@ static char *read_string(void)
 	i++;
 
 	/* move the file descriptor to the end of the string */
-	r = lseek(input_fd, -(r - i), SEEK_CUR);
+	r = lseek64(input_fd, -(r - i), SEEK_CUR);
 	if (r < 0)
 		die("lseek");
 
