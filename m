Return-Path: <linux-kernel-owner+w=401wt.eu-S1757965AbZKRWV3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757965AbZKRWV3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Nov 2009 17:21:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757627AbZKRWVC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Nov 2009 17:21:02 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:42661 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757517AbZKRWU7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Nov 2009 17:20:59 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
       =?utf-8?q?Fr=C3=A9d=C3=A9ric=20Weisbecker?= <fweisbec@gmail.com>,
       Mike Galbraith <efault@gmx.de>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>
Subject: [PATCH 2/4] perf symbols: Kill struct build_id_list and die() another day
Date: Wed, 18 Nov 2009 20:20:51 -0200
Message-Id: <1258582853-8579-2-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1258582853-8579-1-git-send-email-acme@infradead.org>
References: <1258582853-8579-1-git-send-email-acme@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

No need for this struct and its allocations, we can just use the
->build_id member we already have in struct dso, then ask for it to be
read, and later traverse the dsos list, writing the buildid table to the
perf.data file.

As a bonus, one more die() function got killed.

Cc: Frédéric Weisbecker <fweisbec@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/event.h  |    7 -------
 tools/perf/util/header.c |   31 ++++++++++++++++++-------------
 tools/perf/util/symbol.c |   37 +++++++++----------------------------
 tools/perf/util/symbol.h |    2 +-
 4 files changed, 28 insertions(+), 49 deletions(-)

diff --git a/tools/perf/util/event.h b/tools/perf/util/event.h
index 1f771ce..34c6fcb 100644
--- a/tools/perf/util/event.h
+++ b/tools/perf/util/event.h
@@ -69,13 +69,6 @@ struct build_id_event {
 	char			 filename[];
 };
 
-struct build_id_list {
-	struct build_id_event	event;
-	struct list_head	list;
-	const char		*dso_name;
-	int			len;
-};
-
 typedef union event_union {
 	struct perf_event_header	header;
 	struct ip_event			ip;
diff --git a/tools/perf/util/header.c b/tools/perf/util/header.c
index b01a953..31731f1 100644
--- a/tools/perf/util/header.c
+++ b/tools/perf/util/header.c
@@ -176,18 +176,24 @@ static int do_write(int fd, const void *buf, size_t size)
 	return 0;
 }
 
-static int write_buildid_table(int fd, struct list_head *id_head)
+static int dsos__write_buildid_table(int fd)
 {
-	struct build_id_list *iter, *next;
-
-	list_for_each_entry_safe(iter, next, id_head, list) {
-		struct build_id_event *b = &iter->event;
-
-		if (do_write(fd, b, sizeof(*b)) < 0 ||
-		    do_write(fd, iter->dso_name, iter->len) < 0)
+	struct dso *pos;
+
+	list_for_each_entry(pos, &dsos, node) {
+		struct build_id_event b;
+		size_t len;
+
+		if (!pos->has_build_id)
+			continue;
+		len = pos->long_name_len + 1;
+		len = ALIGN(len, 64);
+		memset(&b, 0, sizeof(b));
+		memcpy(&b.build_id, pos->build_id, sizeof(pos->build_id));
+		b.header.size = sizeof(b) + len;
+		if (do_write(fd, &b, sizeof(b)) < 0 ||
+		    do_write(fd, pos->long_name, len) < 0)
 			return -1;
-		list_del(&iter->list);
-		free(iter);
 	}
 
 	return 0;
@@ -196,14 +202,13 @@ static int write_buildid_table(int fd, struct list_head *id_head)
 static void
 perf_header__adds_write(struct perf_header *self, int fd)
 {
-	LIST_HEAD(id_list);
 	int nr_sections;
 	struct perf_file_section *feat_sec;
 	int sec_size;
 	u64 sec_start;
 	int idx = 0;
 
-	if (fetch_build_id_table(&id_list))
+	if (dsos__read_build_ids())
 		perf_header__set_feat(self, HEADER_BUILD_ID);
 
 	nr_sections = bitmap_weight(self->adds_features, HEADER_FEAT_BITS);
@@ -238,7 +243,7 @@ perf_header__adds_write(struct perf_header *self, int fd)
 
 		/* Write build-ids */
 		buildid_sec->offset = lseek(fd, 0, SEEK_CUR);
-		if (write_buildid_table(fd, &id_list) < 0)
+		if (dsos__write_buildid_table(fd) < 0)
 			die("failed to write buildid table");
 		buildid_sec->size = lseek(fd, 0, SEEK_CUR) - buildid_sec->offset;
 	}
diff --git a/tools/perf/util/symbol.c b/tools/perf/util/symbol.c
index 594f36a..946ec31 100644
--- a/tools/perf/util/symbol.c
+++ b/tools/perf/util/symbol.c
@@ -883,38 +883,19 @@ out_close:
 	return err;
 }
 
-bool fetch_build_id_table(struct list_head *head)
+bool dsos__read_build_ids(void)
 {
-	bool have_buildid = false;
+	bool have_build_id = false;
 	struct dso *pos;
 
-	list_for_each_entry(pos, &dsos, node) {
-		struct build_id_list *new;
-		struct build_id_event b;
-		size_t len;
-
-		if (filename__read_build_id(pos->long_name,
-					    &b.build_id,
-					    sizeof(b.build_id)) < 0)
-			continue;
-		have_buildid = true;
-		memset(&b.header, 0, sizeof(b.header));
-		len = pos->long_name_len + 1;
-		len = ALIGN(len, 64);
-		b.header.size = sizeof(b) + len;
-
-		new = malloc(sizeof(*new));
-		if (!new)
-			die("No memory\n");
-
-		memcpy(&new->event, &b, sizeof(b));
-		new->dso_name = pos->long_name;
-		new->len = len;
-
-		list_add_tail(&new->list, head);
-	}
+	list_for_each_entry(pos, &dsos, node)
+		if (filename__read_build_id(pos->long_name, pos->build_id,
+					    sizeof(pos->build_id)) > 0) {
+			have_build_id	  = true;
+			pos->has_build_id = true;
+		}
 
-	return have_buildid;
+	return have_build_id;
 }
 
 int filename__read_build_id(const char *filename, void *bf, size_t size)
diff --git a/tools/perf/util/symbol.h b/tools/perf/util/symbol.h
index 5ad1019..546eb76 100644
--- a/tools/perf/util/symbol.h
+++ b/tools/perf/util/symbol.h
@@ -89,7 +89,7 @@ char dso__symtab_origin(const struct dso *self);
 void dso__set_build_id(struct dso *self, void *build_id);
 
 int filename__read_build_id(const char *filename, void *bf, size_t size);
-bool fetch_build_id_table(struct list_head *head);
+bool dsos__read_build_ids(void);
 int build_id__sprintf(u8 *self, int len, char *bf);
 
 int load_kernel(symbol_filter_t filter);
-- 
1.6.2.5

