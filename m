Return-Path: <linux-kernel-owner+w=401wt.eu-S1753357AbZKSQ4W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753357AbZKSQ4W (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Nov 2009 11:56:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753278AbZKSQ4N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Nov 2009 11:56:13 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:45881 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753063AbZKSQ4E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Nov 2009 11:56:04 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
       =?utf-8?q?Fr=C3=A9d=C3=A9ric=20Weisbecker?= <fweisbec@gmail.com>,
       Mike Galbraith <efault@gmx.de>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>
Subject: [PATCH 1/3] perf tools: perf_header__read shouldn't die()
Date: Thu, 19 Nov 2009 14:55:55 -0200
Message-Id: <1258649757-17554-1-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

And also don't call the constructor in it, this way it adheres to the
model the other methods follow.

Cc: Frédéric Weisbecker <fweisbec@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-record.c    |   16 +++++++-----
 tools/perf/builtin-timechart.c |   17 ++++++++++---
 tools/perf/util/data_map.c     |   18 ++++++++++----
 tools/perf/util/header.c       |   52 +++++++++++++++++++++++----------------
 tools/perf/util/header.h       |    7 +++--
 5 files changed, 70 insertions(+), 40 deletions(-)

diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index 82260c5..c97cb2c 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -400,7 +400,7 @@ static int __cmd_record(int argc, const char **argv)
 	struct stat st;
 	pid_t pid = 0;
 	int flags;
-	int ret;
+	int err;
 	unsigned long waking = 0;
 
 	page_size = sysconf(_SC_PAGE_SIZE);
@@ -434,16 +434,18 @@ static int __cmd_record(int argc, const char **argv)
 		exit(-1);
 	}
 
-	if (!file_new)
-		header = perf_header__read(output);
-	else
-		header = perf_header__new();
-
+	header = perf_header__new();
 	if (header == NULL) {
 		pr_err("Not enough memory for reading perf file header\n");
 		return -1;
 	}
 
+	if (!file_new) {
+		err = perf_header__read(header, output);
+		if (err < 0)
+			return err;
+	}
+
 	if (raw_samples) {
 		perf_header__set_feat(header, HEADER_TRACE_INFO);
 	} else {
@@ -527,7 +529,7 @@ static int __cmd_record(int argc, const char **argv)
 		if (hits == samples) {
 			if (done)
 				break;
-			ret = poll(event_array, nr_poll, -1);
+			err = poll(event_array, nr_poll, -1);
 			waking++;
 		}
 
diff --git a/tools/perf/builtin-timechart.c b/tools/perf/builtin-timechart.c
index 665877e..dd4d82a 100644
--- a/tools/perf/builtin-timechart.c
+++ b/tools/perf/builtin-timechart.c
@@ -1093,7 +1093,7 @@ static void process_samples(void)
 
 static int __cmd_timechart(void)
 {
-	int ret, rc = EXIT_FAILURE;
+	int err, rc = EXIT_FAILURE;
 	unsigned long offset = 0;
 	unsigned long head, shift;
 	struct stat statbuf;
@@ -1111,8 +1111,8 @@ static int __cmd_timechart(void)
 		exit(-1);
 	}
 
-	ret = fstat(input, &statbuf);
-	if (ret < 0) {
+	err = fstat(input, &statbuf);
+	if (err < 0) {
 		perror("failed to stat file");
 		exit(-1);
 	}
@@ -1122,7 +1122,16 @@ static int __cmd_timechart(void)
 		exit(0);
 	}
 
-	header = perf_header__read(input);
+	header = perf_header__new();
+	if (header == NULL)
+		return -ENOMEM;
+
+	err = perf_header__read(header, input);
+	if (err < 0) {
+		perf_header__delete(header);
+		return err;
+	}
+
 	head = header->data_offset;
 
 	sample_type = perf_header__sample_type(header);
diff --git a/tools/perf/util/data_map.c b/tools/perf/util/data_map.c
index 14cb846..b8fc0fa 100644
--- a/tools/perf/util/data_map.c
+++ b/tools/perf/util/data_map.c
@@ -106,7 +106,7 @@ int mmap_dispatch_perf_file(struct perf_header **pheader,
 			    int *cwdlen,
 			    char **cwd)
 {
-	int ret, rc = EXIT_FAILURE;
+	int err, rc = EXIT_FAILURE;
 	struct perf_header *header;
 	unsigned long head, shift;
 	unsigned long offset = 0;
@@ -132,8 +132,8 @@ int mmap_dispatch_perf_file(struct perf_header **pheader,
 		exit(-1);
 	}
 
-	ret = fstat(input, &input_stat);
-	if (ret < 0) {
+	err = fstat(input, &input_stat);
+	if (err < 0) {
 		perror("failed to stat file");
 		exit(-1);
 	}
@@ -149,8 +149,16 @@ int mmap_dispatch_perf_file(struct perf_header **pheader,
 		exit(0);
 	}
 
-	*pheader = perf_header__read(input);
-	header = *pheader;
+	header = perf_header__new();
+	if (header == NULL)
+		return -ENOMEM;
+
+	err = perf_header__read(header, input);
+	if (err < 0) {
+		perf_header__delete(header);
+		return err;
+	}
+	*pheader = header;
 	head = header->data_offset;
 
 	sample_type = perf_header__sample_type(header);
diff --git a/tools/perf/util/header.c b/tools/perf/util/header.c
index 425a29b..e66c7bd 100644
--- a/tools/perf/util/header.c
+++ b/tools/perf/util/header.c
@@ -78,16 +78,24 @@ struct perf_header *perf_header__new(void)
 	return self;
 }
 
+void perf_header__delete(struct perf_header *self)
+{
+	int i;
+
+	for (i = 0; i < self->attrs; ++i)
+		perf_header_attr__delete(self->attr[i]);
+
+	free(self->attr);
+	free(self);
+}
+
 int perf_header__add_attr(struct perf_header *self,
 			  struct perf_header_attr *attr)
 {
-	int pos = self->attrs;
-
 	if (self->frozen)
 		return -1;
 
-	self->attrs++;
-	if (self->attrs > self->size) {
+	if (self->attrs == self->size) {
 		int nsize = self->size * 2;
 		struct perf_header_attr **nattr;
 
@@ -98,7 +106,8 @@ int perf_header__add_attr(struct perf_header *self,
 		self->size = nsize;
 		self->attr = nattr;
 	}
-	self->attr[pos] = attr;
+
+	self->attr[self->attrs++] = attr;
 	return 0;
 }
 
@@ -441,19 +450,17 @@ static int perf_file_section__process(struct perf_file_section *self,
 	return 0;
 }
 
-struct perf_header *perf_header__read(int fd)
+int perf_header__read(struct perf_header *self, int fd)
 {
-	struct perf_header	*self = perf_header__new();
 	struct perf_file_header f_header;
 	struct perf_file_attr	f_attr;
 	u64			f_id;
 	int nr_attrs, nr_ids, i, j;
 
-	if (self == NULL)
-		die("nomem");
-
-	if (perf_file_header__read(&f_header, self, fd) < 0)
-		die("incompatible file format");
+	if (perf_file_header__read(&f_header, self, fd) < 0) {
+		pr_debug("incompatible file format\n");
+		return -EINVAL;
+	}
 
 	nr_attrs = f_header.attrs.size / sizeof(f_attr);
 	lseek(fd, f_header.attrs.offset, SEEK_SET);
@@ -467,7 +474,7 @@ struct perf_header *perf_header__read(int fd)
 
 		attr = perf_header_attr__new(&f_attr.attr);
 		if (attr == NULL)
-			 die("nomem");
+			 return -ENOMEM;
 
 		nr_ids = f_attr.ids.size / sizeof(u64);
 		lseek(fd, f_attr.ids.offset, SEEK_SET);
@@ -475,11 +482,15 @@ struct perf_header *perf_header__read(int fd)
 		for (j = 0; j < nr_ids; j++) {
 			do_read(fd, &f_id, sizeof(f_id));
 
-			if (perf_header_attr__add_id(attr, f_id) < 0)
-				die("nomem");
+			if (perf_header_attr__add_id(attr, f_id) < 0) {
+				perf_header_attr__delete(attr);
+				return -ENOMEM;
+			}
+		}
+		if (perf_header__add_attr(self, attr) < 0) {
+			perf_header_attr__delete(attr);
+			return -ENOMEM;
 		}
-		if (perf_header__add_attr(self, attr) < 0)
-			 die("nomem");
 
 		lseek(fd, tmp, SEEK_SET);
 	}
@@ -487,8 +498,8 @@ struct perf_header *perf_header__read(int fd)
 	if (f_header.event_types.size) {
 		lseek(fd, f_header.event_types.offset, SEEK_SET);
 		events = malloc(f_header.event_types.size);
-		if (!events)
-			die("nomem");
+		if (events == NULL)
+			return -ENOMEM;
 		do_read(fd, events, f_header.event_types.size);
 		event_count =  f_header.event_types.size / sizeof(struct perf_trace_event_type);
 	}
@@ -498,8 +509,7 @@ struct perf_header *perf_header__read(int fd)
 	lseek(fd, self->data_offset, SEEK_SET);
 
 	self->frozen = 1;
-
-	return self;
+	return 0;
 }
 
 u64 perf_header__sample_type(struct perf_header *header)
diff --git a/tools/perf/util/header.h b/tools/perf/util/header.h
index f46a94e..dc8fedb 100644
--- a/tools/perf/util/header.h
+++ b/tools/perf/util/header.h
@@ -55,7 +55,10 @@ struct perf_header {
 	DECLARE_BITMAP(adds_features, HEADER_FEAT_BITS);
 };
 
-struct perf_header *perf_header__read(int fd);
+struct perf_header *perf_header__new(void);
+void perf_header__delete(struct perf_header *self);
+
+int perf_header__read(struct perf_header *self, int fd);
 void perf_header__write(struct perf_header *self, int fd, bool at_exit);
 
 int perf_header__add_attr(struct perf_header *self,
@@ -75,8 +78,6 @@ perf_header__find_attr(u64 id, struct perf_header *header);
 void perf_header__set_feat(struct perf_header *self, int feat);
 bool perf_header__has_feat(const struct perf_header *self, int feat);
 
-struct perf_header *perf_header__new(void);
-
 int perf_header__process_sections(struct perf_header *self, int fd,
 				  int (*process)(struct perf_file_section *self,
 						 int feat, int fd));
-- 
1.6.2.5

