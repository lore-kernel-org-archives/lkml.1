Return-Path: <linux-kernel-owner+w=401wt.eu-S1753318AbZKSQ4N@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753318AbZKSQ4N (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Nov 2009 11:56:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753074AbZKSQ4L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Nov 2009 11:56:11 -0500
Received: from casper.infradead.org ([85.118.1.10]:33034 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753072AbZKSQ4F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Nov 2009 11:56:05 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
       =?utf-8?q?Fr=C3=A9d=C3=A9ric=20Weisbecker?= <fweisbec@gmail.com>,
       Mike Galbraith <efault@gmx.de>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>
Subject: [PATCH 2/3] perf tools: Eliminate some more die() uses in library functions
Date: Thu, 19 Nov 2009 14:55:56 -0200
Message-Id: <1258649757-17554-2-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1258649757-17554-1-git-send-email-acme@infradead.org>
References: <1258649757-17554-1-git-send-email-acme@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

This time in perf_header__adds_write, propagating the do_write error
returns.

Cc: Frédéric Weisbecker <fweisbec@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-record.c |    7 +++-
 tools/perf/util/header.c    |   80 ++++++++++++++++++++++++++++--------------
 tools/perf/util/header.h    |    2 +-
 3 files changed, 59 insertions(+), 30 deletions(-)

diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index c97cb2c..87f98fd 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -474,8 +474,11 @@ static int __cmd_record(int argc, const char **argv)
 		}
 	}
 
-	if (file_new)
-		perf_header__write(header, output, false);
+	if (file_new) {
+		err = perf_header__write(header, output, false);
+		if (err < 0)
+			return err;
+	}
 
 	if (!system_wide)
 		event__synthesize_thread(pid, process_synthesized_event);
diff --git a/tools/perf/util/header.c b/tools/perf/util/header.c
index e66c7bd..d5c81eb 100644
--- a/tools/perf/util/header.c
+++ b/tools/perf/util/header.c
@@ -176,7 +176,7 @@ static int do_write(int fd, const void *buf, size_t size)
 		int ret = write(fd, buf, size);
 
 		if (ret < 0)
-			return -1;
+			return -errno;
 
 		size -= ret;
 		buf += ret;
@@ -190,6 +190,7 @@ static int dsos__write_buildid_table(int fd)
 	struct dso *pos;
 
 	list_for_each_entry(pos, &dsos, node) {
+		int err;
 		struct build_id_event b;
 		size_t len;
 
@@ -200,33 +201,35 @@ static int dsos__write_buildid_table(int fd)
 		memset(&b, 0, sizeof(b));
 		memcpy(&b.build_id, pos->build_id, sizeof(pos->build_id));
 		b.header.size = sizeof(b) + len;
-		if (do_write(fd, &b, sizeof(b)) < 0 ||
-		    do_write(fd, pos->long_name, len) < 0)
-			return -1;
+		err = do_write(fd, &b, sizeof(b));
+		if (err < 0)
+			return err;
+		err = do_write(fd, pos->long_name, len);
+		if (err < 0)
+			return err;
 	}
 
 	return 0;
 }
 
-static void
-perf_header__adds_write(struct perf_header *self, int fd)
+static int perf_header__adds_write(struct perf_header *self, int fd)
 {
 	int nr_sections;
 	struct perf_file_section *feat_sec;
 	int sec_size;
 	u64 sec_start;
-	int idx = 0;
+	int idx = 0, err;
 
 	if (dsos__read_build_ids())
 		perf_header__set_feat(self, HEADER_BUILD_ID);
 
 	nr_sections = bitmap_weight(self->adds_features, HEADER_FEAT_BITS);
 	if (!nr_sections)
-		return;
+		return 0;
 
 	feat_sec = calloc(sizeof(*feat_sec), nr_sections);
-	if (!feat_sec)
-		die("No memory");
+	if (feat_sec == NULL)
+		return -ENOMEM;
 
 	sec_size = sizeof(*feat_sec) * nr_sections;
 
@@ -258,23 +261,29 @@ perf_header__adds_write(struct perf_header *self, int fd)
 
 		/* Write build-ids */
 		buildid_sec->offset = lseek(fd, 0, SEEK_CUR);
-		if (dsos__write_buildid_table(fd) < 0)
-			die("failed to write buildid table");
+		err = dsos__write_buildid_table(fd);
+		if (err < 0) {
+			pr_debug("failed to write buildid table\n");
+			goto out_free;
+		}
 		buildid_sec->size = lseek(fd, 0, SEEK_CUR) - buildid_sec->offset;
 	}
 
 	lseek(fd, sec_start, SEEK_SET);
-	if (do_write(fd, feat_sec, sec_size) < 0)
-		die("failed to write feature section");
+	err = do_write(fd, feat_sec, sec_size);
+	if (err < 0)
+		pr_debug("failed to write feature section\n");
+out_free:
 	free(feat_sec);
+	return err;
 }
 
-void perf_header__write(struct perf_header *self, int fd, bool at_exit)
+int perf_header__write(struct perf_header *self, int fd, bool at_exit)
 {
 	struct perf_file_header f_header;
 	struct perf_file_attr   f_attr;
 	struct perf_header_attr	*attr;
-	int i;
+	int i, err;
 
 	lseek(fd, sizeof(f_header), SEEK_SET);
 
@@ -283,8 +292,11 @@ void perf_header__write(struct perf_header *self, int fd, bool at_exit)
 		attr = self->attr[i];
 
 		attr->id_offset = lseek(fd, 0, SEEK_CUR);
-		if (do_write(fd, attr->id, attr->ids * sizeof(u64)) < 0)
-			die("failed to write perf header");
+		err = do_write(fd, attr->id, attr->ids * sizeof(u64));
+		if (err < 0) {
+			pr_debug("failed to write perf header\n");
+			return err;
+		}
 	}
 
 
@@ -300,20 +312,30 @@ void perf_header__write(struct perf_header *self, int fd, bool at_exit)
 				.size   = attr->ids * sizeof(u64),
 			}
 		};
-		if (do_write(fd, &f_attr, sizeof(f_attr)) < 0)
-			die("failed to write perf header attribute");
+		err = do_write(fd, &f_attr, sizeof(f_attr));
+		if (err < 0) {
+			pr_debug("failed to write perf header attribute\n");
+			return err;
+		}
 	}
 
 	self->event_offset = lseek(fd, 0, SEEK_CUR);
 	self->event_size = event_count * sizeof(struct perf_trace_event_type);
-	if (events)
-		if (do_write(fd, events, self->event_size) < 0)
-			die("failed to write perf header events");
+	if (events) {
+		err = do_write(fd, events, self->event_size);
+		if (err < 0) {
+			pr_debug("failed to write perf header events\n");
+			return err;
+		}
+	}
 
 	self->data_offset = lseek(fd, 0, SEEK_CUR);
 
-	if (at_exit)
-		perf_header__adds_write(self, fd);
+	if (at_exit) {
+		err = perf_header__adds_write(self, fd);
+		if (err < 0)
+			return err;
+	}
 
 	f_header = (struct perf_file_header){
 		.magic	   = PERF_MAGIC,
@@ -336,11 +358,15 @@ void perf_header__write(struct perf_header *self, int fd, bool at_exit)
 	memcpy(&f_header.adds_features, &self->adds_features, sizeof(self->adds_features));
 
 	lseek(fd, 0, SEEK_SET);
-	if (do_write(fd, &f_header, sizeof(f_header)) < 0)
-		die("failed to write perf header");
+	err = do_write(fd, &f_header, sizeof(f_header));
+	if (err < 0) {
+		pr_debug("failed to write perf header\n");
+		return err;
+	}
 	lseek(fd, self->data_offset + self->data_size, SEEK_SET);
 
 	self->frozen = 1;
+	return 0;
 }
 
 static void do_read(int fd, void *buf, size_t size)
diff --git a/tools/perf/util/header.h b/tools/perf/util/header.h
index dc8fedb..d1dbe2b 100644
--- a/tools/perf/util/header.h
+++ b/tools/perf/util/header.h
@@ -59,7 +59,7 @@ struct perf_header *perf_header__new(void);
 void perf_header__delete(struct perf_header *self);
 
 int perf_header__read(struct perf_header *self, int fd);
-void perf_header__write(struct perf_header *self, int fd, bool at_exit);
+int perf_header__write(struct perf_header *self, int fd, bool at_exit);
 
 int perf_header__add_attr(struct perf_header *self,
 			  struct perf_header_attr *attr);
-- 
1.6.2.5

