Return-Path: <linux-kernel-owner+w=401wt.eu-S1754203AbZKPVK7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754203AbZKPVK7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Nov 2009 16:10:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754000AbZKPVK6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Nov 2009 16:10:58 -0500
Received: from hera.kernel.org ([140.211.167.34]:57386 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753968AbZKPVK5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Nov 2009 16:10:57 -0500
Date: Mon, 16 Nov 2009 21:10:16 GMT
From: tip-bot for Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, acme@redhat.com,
       hpa@zytor.com, mingo@redhat.com, peterz@infradead.org, efault@gmx.de,
       fweisbec@gmail.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
       linux-kernel@vger.kernel.org, fweisbec@gmail.com, efault@gmx.de,
       peterz@infradead.org, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1258396365-29217-3-git-send-email-acme@infradead.org>
References: <1258396365-29217-3-git-send-email-acme@infradead.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools: Generalize perf_header__adds_read()
Message-ID: <tip-37562eac3767c7f07bb1a1329708ff6453e47570@git.kernel.org>
Git-Commit-ID: 37562eac3767c7f07bb1a1329708ff6453e47570
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  37562eac3767c7f07bb1a1329708ff6453e47570
Gitweb:     http://git.kernel.org/tip/37562eac3767c7f07bb1a1329708ff6453e47570
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Mon, 16 Nov 2009 16:32:43 -0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 16 Nov 2009 22:05:50 +0100

perf tools: Generalize perf_header__adds_read()

Renaming it to perf_header__process_sections() and passing a
callback to handle each feature.

The next changesets will introduce 'perf buildid-list' that will
handle just the HEADER_BUILD_ID table, ignoring all the other
features.

Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Acked-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
LKML-Reference: <1258396365-29217-3-git-send-email-acme@infradead.org>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 tools/perf/util/header.c |  123 ++++++++++++++++++++++++++--------------------
 tools/perf/util/header.h |   31 +++++++++++-
 2 files changed, 98 insertions(+), 56 deletions(-)

diff --git a/tools/perf/util/header.c b/tools/perf/util/header.c
index ca0d657..d8416f0 100644
--- a/tools/perf/util/header.c
+++ b/tools/perf/util/header.c
@@ -128,26 +128,11 @@ static const char *__perf_magic = "PERFFILE";
 
 #define PERF_MAGIC	(*(u64 *)__perf_magic)
 
-struct perf_file_section {
-	u64 offset;
-	u64 size;
-};
-
 struct perf_file_attr {
 	struct perf_event_attr	attr;
 	struct perf_file_section	ids;
 };
 
-struct perf_file_header {
-	u64				magic;
-	u64				size;
-	u64				attr_size;
-	struct perf_file_section	attrs;
-	struct perf_file_section	data;
-	struct perf_file_section	event_types;
-	DECLARE_BITMAP(adds_features, HEADER_FEAT_BITS);
-};
-
 void perf_header__set_feat(struct perf_header *self, int feat)
 {
 	set_bit(feat, self->adds_features);
@@ -324,21 +309,23 @@ static void do_read(int fd, void *buf, size_t size)
 	}
 }
 
-static void perf_header__adds_read(struct perf_header *self, int fd)
+int perf_header__process_sections(struct perf_header *self, int fd,
+				  int (*process)(struct perf_file_section *self,
+						 int feat, int fd))
 {
 	struct perf_file_section *feat_sec;
 	int nr_sections;
 	int sec_size;
 	int idx = 0;
-
+	int err = 0, feat = 1;
 
 	nr_sections = bitmap_weight(self->adds_features, HEADER_FEAT_BITS);
 	if (!nr_sections)
-		return;
+		return 0;
 
 	feat_sec = calloc(sizeof(*feat_sec), nr_sections);
 	if (!feat_sec)
-		die("No memory");
+		return -1;
 
 	sec_size = sizeof(*feat_sec) * nr_sections;
 
@@ -346,25 +333,73 @@ static void perf_header__adds_read(struct perf_header *self, int fd)
 
 	do_read(fd, feat_sec, sec_size);
 
-	if (perf_header__has_feat(self, HEADER_TRACE_INFO)) {
-		struct perf_file_section *trace_sec;
+	while (idx < nr_sections && feat < HEADER_LAST_FEATURE) {
+		if (perf_header__has_feat(self, feat)) {
+			struct perf_file_section *sec = &feat_sec[idx++];
 
-		trace_sec = &feat_sec[idx++];
-		lseek(fd, trace_sec->offset, SEEK_SET);
-		trace_report(fd);
+			err = process(sec, feat, fd);
+			if (err < 0)
+				break;
+		}
+		++feat;
 	}
 
-	if (perf_header__has_feat(self, HEADER_BUILD_ID)) {
-		struct perf_file_section *buildid_sec;
+	free(feat_sec);
+	return err;
+};
 
-		buildid_sec = &feat_sec[idx++];
-		lseek(fd, buildid_sec->offset, SEEK_SET);
-		if (perf_header__read_build_ids(fd, buildid_sec->offset, buildid_sec->size))
-			pr_debug("failed to read buildids, continuing...\n");
+int perf_file_header__read(struct perf_file_header *self,
+			   struct perf_header *ph, int fd)
+{
+	lseek(fd, 0, SEEK_SET);
+	do_read(fd, self, sizeof(*self));
+
+	if (self->magic     != PERF_MAGIC ||
+	    self->attr_size != sizeof(struct perf_file_attr))
+		return -1;
+
+	if (self->size != sizeof(*self)) {
+		/* Support the previous format */
+		if (self->size == offsetof(typeof(*self), adds_features))
+			bitmap_zero(self->adds_features, HEADER_FEAT_BITS);
+		else
+			return -1;
 	}
 
-	free(feat_sec);
-};
+	memcpy(&ph->adds_features, &self->adds_features,
+	       sizeof(self->adds_features));
+
+	ph->event_offset = self->event_types.offset;
+	ph->event_size	 = self->event_types.size;
+	ph->data_offset	 = self->data.offset;
+	ph->data_size	 = self->data.size;
+	return 0;
+}
+
+static int perf_file_section__process(struct perf_file_section *self,
+				      int feat, int fd)
+{
+	if (lseek(fd, self->offset, SEEK_SET) < 0) {
+		pr_debug("Failed to lseek to %Ld offset for feature %d, "
+			 "continuing...\n", self->offset, feat);
+		return 0;
+	}
+
+	switch (feat) {
+	case HEADER_TRACE_INFO:
+		trace_report(fd);
+		break;
+
+	case HEADER_BUILD_ID:
+		if (perf_header__read_build_ids(fd, self->offset, self->size))
+			pr_debug("Failed to read buildids, continuing...\n");
+		break;
+	default:
+		pr_debug("unknown feature %d, continuing...\n", feat);
+	}
+
+	return 0;
+}
 
 struct perf_header *perf_header__read(int fd)
 {
@@ -372,23 +407,11 @@ struct perf_header *perf_header__read(int fd)
 	struct perf_file_header f_header;
 	struct perf_file_attr	f_attr;
 	u64			f_id;
-
 	int nr_attrs, nr_ids, i, j;
 
-	lseek(fd, 0, SEEK_SET);
-	do_read(fd, &f_header, sizeof(f_header));
-
-	if (f_header.magic	!= PERF_MAGIC		||
-	    f_header.attr_size	!= sizeof(f_attr))
+	if (perf_file_header__read(&f_header, self, fd) < 0)
 		die("incompatible file format");
 
-	if (f_header.size != sizeof(f_header)) {
-		/* Support the previous format */
-		if (f_header.size == offsetof(typeof(f_header), adds_features))
-			bitmap_zero(f_header.adds_features, HEADER_FEAT_BITS);
-		else
-			die("incompatible file format");
-	}
 	nr_attrs = f_header.attrs.size / sizeof(f_attr);
 	lseek(fd, f_header.attrs.offset, SEEK_SET);
 
@@ -422,15 +445,7 @@ struct perf_header *perf_header__read(int fd)
 		event_count =  f_header.event_types.size / sizeof(struct perf_trace_event_type);
 	}
 
-	memcpy(&self->adds_features, &f_header.adds_features, sizeof(f_header.adds_features));
-
-	self->event_offset = f_header.event_types.offset;
-	self->event_size   = f_header.event_types.size;
-
-	self->data_offset = f_header.data.offset;
-	self->data_size   = f_header.data.size;
-
-	perf_header__adds_read(self, fd);
+	perf_header__process_sections(self, fd, perf_file_section__process);
 
 	lseek(fd, self->data_offset, SEEK_SET);
 
diff --git a/tools/perf/util/header.h b/tools/perf/util/header.h
index a22d70b..f1b3bf7 100644
--- a/tools/perf/util/header.h
+++ b/tools/perf/util/header.h
@@ -15,11 +15,34 @@ struct perf_header_attr {
 	off_t id_offset;
 };
 
-#define HEADER_TRACE_INFO			1
-#define HEADER_BUILD_ID				2
+enum {
+	HEADER_TRACE_INFO = 1,
+	HEADER_BUILD_ID,
+	HEADER_LAST_FEATURE,
+};
 
 #define HEADER_FEAT_BITS			256
 
+struct perf_file_section {
+	u64 offset;
+	u64 size;
+};
+
+struct perf_file_header {
+	u64				magic;
+	u64				size;
+	u64				attr_size;
+	struct perf_file_section	attrs;
+	struct perf_file_section	data;
+	struct perf_file_section	event_types;
+	DECLARE_BITMAP(adds_features, HEADER_FEAT_BITS);
+};
+
+struct perf_header;
+
+int perf_file_header__read(struct perf_file_header *self,
+			   struct perf_header *ph, int fd);
+
 struct perf_header {
 	int			frozen;
 	int			attrs, size;
@@ -54,4 +77,8 @@ bool perf_header__has_feat(const struct perf_header *self, int feat);
 
 struct perf_header *perf_header__new(void);
 
+int perf_header__process_sections(struct perf_header *self, int fd,
+				  int (*process)(struct perf_file_section *self,
+						 int feat, int fd));
+
 #endif /* __PERF_HEADER_H */
