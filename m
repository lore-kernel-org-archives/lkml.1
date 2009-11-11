Return-Path: <linux-kernel-owner+w=401wt.eu-S1755764AbZKKHn4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755764AbZKKHn4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Nov 2009 02:43:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755700AbZKKHnz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Nov 2009 02:43:55 -0500
Received: from hera.kernel.org ([140.211.167.34]:40876 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755716AbZKKHnx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Nov 2009 02:43:53 -0500
Date: Wed, 11 Nov 2009 07:43:05 GMT
From: tip-bot for Frederic Weisbecker <fweisbec@gmail.com>
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, acme@redhat.com,
       hpa@zytor.com, mingo@redhat.com, efault@gmx.de, peterz@infradead.org,
       mitake@dcl.info.waseda.ac.jp, fweisbec@gmail.com, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
       linux-kernel@vger.kernel.org, fweisbec@gmail.com, peterz@infradead.org,
       efault@gmx.de, mitake@dcl.info.waseda.ac.jp, tglx@linutronix.de,
       mingo@elte.hu
In-Reply-To: <1257911467-28276-2-git-send-email-fweisbec@gmail.com>
References: <1257911467-28276-2-git-send-email-fweisbec@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools: Move the build-id storage operations to headers
Message-ID: <tip-8671dab9d5b2f0b444b8d09792384dccbfd43d14@git.kernel.org>
Git-Commit-ID: 8671dab9d5b2f0b444b8d09792384dccbfd43d14
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  8671dab9d5b2f0b444b8d09792384dccbfd43d14
Gitweb:     http://git.kernel.org/tip/8671dab9d5b2f0b444b8d09792384dccbfd43d14
Author:     Frederic Weisbecker <fweisbec@gmail.com>
AuthorDate: Wed, 11 Nov 2009 04:51:03 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 11 Nov 2009 07:30:17 +0100

perf tools: Move the build-id storage operations to headers

So that it makes easier to control it. Especially because we
plan to give it a feature section.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
LKML-Reference: <1257911467-28276-2-git-send-email-fweisbec@gmail.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 tools/perf/builtin-record.c |   32 ++------------------------------
 tools/perf/util/header.c    |   41 ++++++++++++++++++++++++++++++++++++++---
 tools/perf/util/header.h    |    2 +-
 3 files changed, 41 insertions(+), 34 deletions(-)

diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index 9f98b86..c35e61b 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -378,39 +378,11 @@ static void open_counters(int cpu, pid_t pid)
 	nr_cpu++;
 }
 
-static bool write_buildid_table(void)
-{
-	struct dso *pos;
-	bool have_buildid = false;
-
-	list_for_each_entry(pos, &dsos, node) {
-		struct build_id_event b;
-		size_t len;
-
-		if (filename__read_build_id(pos->long_name,
-					    &b.build_id,
-					    sizeof(b.build_id)) < 0)
-			continue;
-		have_buildid = true;
-		memset(&b.header, 0, sizeof(b.header));
-		len = strlen(pos->long_name) + 1;
-		len = ALIGN(len, 64);
-		b.header.size = sizeof(b) + len;
-		write_output(&b, sizeof(b));
-		write_output(pos->long_name, len);
-	}
-
-	return have_buildid;
-}
-
 static void atexit_header(void)
 {
 	header->data_size += bytes_written;
 
-	if (write_buildid_table())
-		perf_header__set_feat(header, HEADER_BUILD_ID);
-
-	perf_header__write(header, output);
+	perf_header__write(header, output, true);
 }
 
 static int __cmd_record(int argc, const char **argv)
@@ -487,7 +459,7 @@ static int __cmd_record(int argc, const char **argv)
 	}
 
 	if (file_new)
-		perf_header__write(header, output);
+		perf_header__write(header, output, false);
 
 	if (!system_wide)
 		event__synthesize_thread(pid, process_synthesized_event);
diff --git a/tools/perf/util/header.c b/tools/perf/util/header.c
index 050f543..a4d0bbe 100644
--- a/tools/perf/util/header.c
+++ b/tools/perf/util/header.c
@@ -2,11 +2,13 @@
 #include <unistd.h>
 #include <stdio.h>
 #include <stdlib.h>
+#include <linux/list.h>
 
 #include "util.h"
 #include "header.h"
 #include "../perf.h"
 #include "trace-event.h"
+#include "symbol.h"
 
 /*
  * Create new perf.data header attribute:
@@ -172,7 +174,33 @@ static void do_write(int fd, void *buf, size_t size)
 	}
 }
 
-static void perf_header__adds_write(struct perf_header *self, int fd)
+static bool write_buildid_table(int fd)
+{
+	struct dso *pos;
+	bool have_buildid = false;
+
+	list_for_each_entry(pos, &dsos, node) {
+		struct build_id_event b;
+		size_t len;
+
+		if (filename__read_build_id(pos->long_name,
+					    &b.build_id,
+					    sizeof(b.build_id)) < 0)
+			continue;
+		have_buildid = true;
+		memset(&b.header, 0, sizeof(b.header));
+		len = strlen(pos->long_name) + 1;
+		len = ALIGN(len, 64);
+		b.header.size = sizeof(b) + len;
+		do_write(fd, &b, sizeof(b));
+		do_write(fd, pos->long_name, len);
+	}
+
+	return have_buildid;
+}
+
+static void
+perf_header__adds_write(struct perf_header *self, int fd, bool at_exit)
 {
 	struct perf_file_section trace_sec;
 	u64 cur_offset = lseek(fd, 0, SEEK_CUR);
@@ -196,9 +224,16 @@ static void perf_header__adds_write(struct perf_header *self, int fd)
 		 */
 		cur_offset = lseek(fd, trace_sec.offset + trace_sec.size, SEEK_SET);
 	}
+
+	if (at_exit) {
+		lseek(fd, self->data_offset + self->data_size, SEEK_SET);
+		if (write_buildid_table(fd))
+			perf_header__set_feat(self, HEADER_BUILD_ID);
+		lseek(fd, cur_offset, SEEK_SET);
+	}
 };
 
-void perf_header__write(struct perf_header *self, int fd)
+void perf_header__write(struct perf_header *self, int fd, bool at_exit)
 {
 	struct perf_file_header f_header;
 	struct perf_file_attr   f_attr;
@@ -236,7 +271,7 @@ void perf_header__write(struct perf_header *self, int fd)
 	if (events)
 		do_write(fd, events, self->event_size);
 
-	perf_header__adds_write(self, fd);
+	perf_header__adds_write(self, fd, at_exit);
 
 	self->data_offset = lseek(fd, 0, SEEK_CUR);
 
diff --git a/tools/perf/util/header.h b/tools/perf/util/header.h
index 2f233c5..77186c9 100644
--- a/tools/perf/util/header.h
+++ b/tools/perf/util/header.h
@@ -33,7 +33,7 @@ struct perf_header {
 };
 
 struct perf_header *perf_header__read(int fd);
-void perf_header__write(struct perf_header *self, int fd);
+void perf_header__write(struct perf_header *self, int fd, bool at_exit);
 
 void perf_header__add_attr(struct perf_header *self,
 			   struct perf_header_attr *attr);
