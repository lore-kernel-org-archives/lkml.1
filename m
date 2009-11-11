Return-Path: <linux-kernel-owner+w=401wt.eu-S1756381AbZKKHom@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756381AbZKKHom (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Nov 2009 02:44:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756238AbZKKHol
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Nov 2009 02:44:41 -0500
Received: from hera.kernel.org ([140.211.167.34]:40931 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756158AbZKKHoj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Nov 2009 02:44:39 -0500
Date: Wed, 11 Nov 2009 07:44:13 GMT
From: tip-bot for Frederic Weisbecker <fweisbec@gmail.com>
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, acme@redhat.com,
       hpa@zytor.com, mingo@redhat.com, efault@gmx.de, peterz@infradead.org,
       mitake@dcl.info.waseda.ac.jp, fweisbec@gmail.com, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
       linux-kernel@vger.kernel.org, fweisbec@gmail.com, peterz@infradead.org,
       efault@gmx.de, mitake@dcl.info.waseda.ac.jp, tglx@linutronix.de,
       mingo@elte.hu
In-Reply-To: <1257911467-28276-6-git-send-email-fweisbec@gmail.com>
References: <1257911467-28276-6-git-send-email-fweisbec@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools: Bring linear set of section headers for features
Message-ID: <tip-9e827dd00a94136b944a538bede67c944d0b740a@git.kernel.org>
Git-Commit-ID: 9e827dd00a94136b944a538bede67c944d0b740a
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  9e827dd00a94136b944a538bede67c944d0b740a
Gitweb:     http://git.kernel.org/tip/9e827dd00a94136b944a538bede67c944d0b740a
Author:     Frederic Weisbecker <fweisbec@gmail.com>
AuthorDate: Wed, 11 Nov 2009 04:51:07 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 11 Nov 2009 07:30:19 +0100

perf tools: Bring linear set of section headers for features

Build a set of section headers for features right after the
datas. Each implemented feature will have one of such section
header that provides the offset and the size of the data
manipulated by the feature.

The trace informations have moved after the data and are
recorded on exit time.

The new layout is as follows:

 -----------------------
                             ___
 [ magic               ]      |
 [ header size         ]      |
 [ attr size           ]      |
 [ attr content offset ]      |
 [ attr content size   ]      |
 [ data offset         ]  File Headers
 [ data size           ]      |
 [ event_types offset  ]      |
 [ event_types size    ]      |
 [ feature bitmap      ]      v

 [ attr section        ]
 [ events section      ]

                             ___
 [         X           ]      |
 [         X           ]      |
 [         X           ]    Datas
 [         X           ]      |
 [         X           ]      v

                             ___
 [ Feature 1 offset    ]      |
 [ Feature 1 size      ] Features headers
 [ Feature 2 offset    ]      |
 [ Feature 2 size      ]      v

 [ Feature 1 content   ]
 [ Feature 2 content   ]
 -----------------------

We have as many feature's section headers as we have features in
use for the current file.

Say Feat 1 and Feat 3 are used by the file, but not Feat 2. Then
the feature headers will be like follows:

[ Feature 1 offset    ]      |
[ Feature 1 size      ] Features headers
[ Feature 3 offset    ]      |
[ Feature 3 size      ]      v

There is no hole to cover Feature 2 that is not in use here. We
only need to cover the needed headers in order, from the lowest
feature bit to the highest.

Currently we have two features: HEADER_TRACE_INFO and
HEADER_BUILD_ID. Both have their contents that follow the
feature headers. Putting the contents right after the feature
headers is not mandatory though. While we keep the feature
headers right after the data and in order, their offsets can
point everywhere. We have just put the two above feature
contents in the end of the file for convenience.

The purpose of this layout change is to have a file format that
scales while keeping it simple: having such linear feature
headers is less error prone wrt forward/backward compatibility
as the content of a feature can be put anywhere, its location
can even change by the time, it's fine because its headers will
tell where it is. And we know how to find these headers,
following the above rules.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
LKML-Reference: <1257911467-28276-6-git-send-email-fweisbec@gmail.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 tools/perf/util/data_map.c             |   11 +--
 tools/perf/util/data_map.h             |    3 +-
 tools/perf/util/header.c               |  110 ++++++++++++++++++++++----------
 tools/perf/util/include/linux/bitmap.h |    1 +
 tools/perf/util/include/linux/ctype.h  |    2 +-
 tools/perf/util/util.h                 |    3 +
 6 files changed, 85 insertions(+), 45 deletions(-)

diff --git a/tools/perf/util/data_map.c b/tools/perf/util/data_map.c
index 66e58aa..aacb814 100644
--- a/tools/perf/util/data_map.c
+++ b/tools/perf/util/data_map.c
@@ -70,18 +70,15 @@ process_event(event_t *event, unsigned long offset, unsigned long head)
 	}
 }
 
-int perf_header__read_build_ids(const struct perf_header *self,
-				int input, off_t file_size)
+int perf_header__read_build_ids(int input, off_t size)
 {
-	off_t offset = self->data_offset + self->data_size;
 	struct build_id_event bev;
 	char filename[PATH_MAX];
+	off_t offset = lseek(input, 0, SEEK_CUR);
+	off_t limit = offset + size;
 	int err = -1;
 
-	if (lseek(input, offset, SEEK_SET) < 0)
-		return -1;
-
-	while (offset < file_size) {
+	while (offset < limit) {
 		struct dso *dso;
 		ssize_t len;
 
diff --git a/tools/perf/util/data_map.h b/tools/perf/util/data_map.h
index c412281..20b4037 100644
--- a/tools/perf/util/data_map.h
+++ b/tools/perf/util/data_map.h
@@ -27,7 +27,6 @@ int mmap_dispatch_perf_file(struct perf_header **pheader,
 			    int full_paths,
 			    int *cwdlen,
 			    char **cwd);
-int perf_header__read_build_ids(const struct perf_header *self,
-				int input, off_t file_size);
+int perf_header__read_build_ids(int input, off_t file_size);
 
 #endif
diff --git a/tools/perf/util/header.c b/tools/perf/util/header.c
index 9709d38..ebed4f4 100644
--- a/tools/perf/util/header.c
+++ b/tools/perf/util/header.c
@@ -186,41 +186,58 @@ static void write_buildid_table(int fd, struct list_head *id_head)
 }
 
 static void
-perf_header__adds_write(struct perf_header *self, int fd, bool at_exit)
+perf_header__adds_write(struct perf_header *self, int fd)
 {
-	struct perf_file_section trace_sec;
-	u64 cur_offset = lseek(fd, 0, SEEK_CUR);
+	LIST_HEAD(id_list);
+	int nr_sections;
+	struct perf_file_section *feat_sec;
+	int sec_size;
+	u64 sec_start;
+	int idx = 0;
+
+	if (fetch_build_id_table(&id_list))
+		perf_header__set_feat(self, HEADER_BUILD_ID);
+
+	nr_sections = bitmap_weight(self->adds_features, HEADER_FEAT_BITS);
+	if (!nr_sections)
+		return;
+
+	feat_sec = calloc(sizeof(*feat_sec), nr_sections);
+	if (!feat_sec)
+		die("No memory");
+
+	sec_size = sizeof(*feat_sec) * nr_sections;
+
+	sec_start = self->data_offset + self->data_size;
+	lseek(fd, sec_start + sec_size, SEEK_SET);
 
 	if (perf_header__has_feat(self, HEADER_TRACE_INFO)) {
+		struct perf_file_section *trace_sec;
+
+		trace_sec = &feat_sec[idx++];
+
 		/* Write trace info */
-		trace_sec.offset = lseek(fd, sizeof(trace_sec), SEEK_CUR);
+		trace_sec->offset = lseek(fd, 0, SEEK_CUR);
 		read_tracing_data(fd, attrs, nr_counters);
-		trace_sec.size = lseek(fd, 0, SEEK_CUR) - trace_sec.offset;
-
-		/* Write trace info headers */
-		lseek(fd, cur_offset, SEEK_SET);
-		do_write(fd, &trace_sec, sizeof(trace_sec));
-
-		/*
-		 * Update cur_offset. So that other (future)
-		 * features can set their own infos in this place. But if we are
-		 * the only feature, at least that seeks to the place the data
-		 * should begin.
-		 */
-		cur_offset = lseek(fd, trace_sec.offset + trace_sec.size, SEEK_SET);
+		trace_sec->size = lseek(fd, 0, SEEK_CUR) - trace_sec->offset;
 	}
 
-	if (at_exit) {
-		LIST_HEAD(id_list);
 
-		if (fetch_build_id_table(&id_list)) {
-			lseek(fd, self->data_offset + self->data_size, SEEK_SET);
-			perf_header__set_feat(self, HEADER_BUILD_ID);
-			write_buildid_table(fd, &id_list);
-			lseek(fd, cur_offset, SEEK_SET);
-		}
+	if (perf_header__has_feat(self, HEADER_BUILD_ID)) {
+		struct perf_file_section *buildid_sec;
+
+		buildid_sec = &feat_sec[idx++];
+
+		/* Write build-ids */
+		buildid_sec->offset = lseek(fd, 0, SEEK_CUR);
+		write_buildid_table(fd, &id_list);
+		buildid_sec->size = lseek(fd, 0, SEEK_CUR) - buildid_sec->offset;
 	}
-};
+
+	lseek(fd, sec_start, SEEK_SET);
+	do_write(fd, feat_sec, sec_size);
+	free(feat_sec);
+}
 
 void perf_header__write(struct perf_header *self, int fd, bool at_exit)
 {
@@ -260,10 +277,11 @@ void perf_header__write(struct perf_header *self, int fd, bool at_exit)
 	if (events)
 		do_write(fd, events, self->event_size);
 
-	perf_header__adds_write(self, fd, at_exit);
-
 	self->data_offset = lseek(fd, 0, SEEK_CUR);
 
+	if (at_exit)
+		perf_header__adds_write(self, fd);
+
 	f_header = (struct perf_file_header){
 		.magic	   = PERF_MAGIC,
 		.size	   = sizeof(f_header),
@@ -308,22 +326,44 @@ static void do_read(int fd, void *buf, size_t size)
 
 static void perf_header__adds_read(struct perf_header *self, int fd)
 {
+	struct perf_file_section *feat_sec;
+	int nr_sections;
+	int sec_size;
+	int idx = 0;
+
+
+	nr_sections = bitmap_weight(self->adds_features, HEADER_FEAT_BITS);
+	if (!nr_sections)
+		return;
+
+	feat_sec = calloc(sizeof(*feat_sec), nr_sections);
+	if (!feat_sec)
+		die("No memory");
+
+	sec_size = sizeof(*feat_sec) * nr_sections;
+
+	lseek(fd, self->data_offset + self->data_size, SEEK_SET);
+
+	do_read(fd, feat_sec, sec_size);
+
 	if (perf_header__has_feat(self, HEADER_TRACE_INFO)) {
-		struct perf_file_section trace_sec;
+		struct perf_file_section *trace_sec;
 
-		do_read(fd, &trace_sec, sizeof(trace_sec));
-		lseek(fd, trace_sec.offset, SEEK_SET);
+		trace_sec = &feat_sec[idx++];
+		lseek(fd, trace_sec->offset, SEEK_SET);
 		trace_report(fd);
-		lseek(fd, trace_sec.offset + trace_sec.size, SEEK_SET);
 	}
 
 	if (perf_header__has_feat(self, HEADER_BUILD_ID)) {
-		struct stat input_stat;
+		struct perf_file_section *buildid_sec;
 
-		fstat(fd, &input_stat);
-		if (perf_header__read_build_ids(self, fd, input_stat.st_size))
+		buildid_sec = &feat_sec[idx++];
+		lseek(fd, buildid_sec->offset, SEEK_SET);
+		if (perf_header__read_build_ids(fd, buildid_sec->size))
 			pr_debug("failed to read buildids, continuing...\n");
 	}
+
+	free(feat_sec);
 };
 
 struct perf_header *perf_header__read(int fd)
diff --git a/tools/perf/util/include/linux/bitmap.h b/tools/perf/util/include/linux/bitmap.h
index 821c103..9450763 100644
--- a/tools/perf/util/include/linux/bitmap.h
+++ b/tools/perf/util/include/linux/bitmap.h
@@ -1,2 +1,3 @@
 #include "../../../../include/linux/bitmap.h"
 #include "../../../../include/asm-generic/bitops/find.h"
+#include <linux/errno.h>
diff --git a/tools/perf/util/include/linux/ctype.h b/tools/perf/util/include/linux/ctype.h
index bae5783..a53d4ee 100644
--- a/tools/perf/util/include/linux/ctype.h
+++ b/tools/perf/util/include/linux/ctype.h
@@ -1 +1 @@
-#include "../../../../include/linux/ctype.h"
+#include "../util.h"
diff --git a/tools/perf/util/util.h b/tools/perf/util/util.h
index 9de2329..7bd5bda 100644
--- a/tools/perf/util/util.h
+++ b/tools/perf/util/util.h
@@ -306,6 +306,7 @@ static inline int has_extension(const char *filename, const char *ext)
 #undef isascii
 #undef isspace
 #undef isdigit
+#undef isxdigit
 #undef isalpha
 #undef isprint
 #undef isalnum
@@ -323,6 +324,8 @@ extern unsigned char sane_ctype[256];
 #define isascii(x) (((x) & ~0x7f) == 0)
 #define isspace(x) sane_istest(x,GIT_SPACE)
 #define isdigit(x) sane_istest(x,GIT_DIGIT)
+#define isxdigit(x)	\
+	(sane_istest(toupper(x), GIT_ALPHA | GIT_DIGIT) && toupper(x) < 'G')
 #define isalpha(x) sane_istest(x,GIT_ALPHA)
 #define isalnum(x) sane_istest(x,GIT_ALPHA | GIT_DIGIT)
 #define isprint(x) sane_istest(x,GIT_PRINT)
