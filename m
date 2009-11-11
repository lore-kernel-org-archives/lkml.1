Return-Path: <linux-kernel-owner+w=401wt.eu-S1756579AbZKKDv6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756579AbZKKDv6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Nov 2009 22:51:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754394AbZKKDvP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Nov 2009 22:51:15 -0500
Received: from mail-ew0-f207.google.com ([209.85.219.207]:63411 "EHLO
	mail-ew0-f207.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753571AbZKKDvD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Nov 2009 22:51:03 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=q9/c+C/wr2bBG/3Ufeo6TIziuV/V1ce1bFDG/vq38qJAjvVeR8oHfR4JusgAyvoW6E
         S2VzlxVaWOeYAs3hGOVyDCdOh7ydTVE6e0w8ReXt6R96aVVZ70/YpvZ+rBhvpiSeBQF7
         rhgT4MEmwJPPrkVvG9dG6AEbNOYzN9pwCEON0=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
       Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
Subject: [PATCH 3/6] perf tools: Split up build id saving into fetch and write
Date: Wed, 11 Nov 2009 04:51:04 +0100
Message-Id: <1257911467-28276-3-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
In-Reply-To: <1257911467-28276-1-git-send-email-fweisbec@gmail.com>
References: <1257911467-28276-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We are saving the build id once we stop the profiling. And only after
doing that we know if we need to set that feature in the header through
the feature bitmap.

But if we want a proper feature support in the headers, using a rule of
offset/size pairs in sections, we need to know in advance how many
features we need to set in the headers, so that we can reserve rooms
for their section headers.

The current state doesn't allow that, as it forces us to first save
the build-ids to the file right after the datas instead of planning
any structured layout.

That's why this splits up the build-ids processing in two parts: one
that fetches the build-ids from the Dso objects, and one that saves
them into the file.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
---
 tools/perf/util/event.h  |    7 +++++++
 tools/perf/util/header.c |   41 +++++++++++++++++------------------------
 tools/perf/util/symbol.c |   34 ++++++++++++++++++++++++++++++++++
 tools/perf/util/symbol.h |    1 +
 4 files changed, 59 insertions(+), 24 deletions(-)

diff --git a/tools/perf/util/event.h b/tools/perf/util/event.h
index 34c6fcb..1f771ce 100644
--- a/tools/perf/util/event.h
+++ b/tools/perf/util/event.h
@@ -69,6 +69,13 @@ struct build_id_event {
 	char			 filename[];
 };
 
+struct build_id_list {
+	struct build_id_event	event;
+	struct list_head	list;
+	const char		*dso_name;
+	int			len;
+};
+
 typedef union event_union {
 	struct perf_event_header	header;
 	struct ip_event			ip;
diff --git a/tools/perf/util/header.c b/tools/perf/util/header.c
index a4d0bbe..2f702c2 100644
--- a/tools/perf/util/header.c
+++ b/tools/perf/util/header.c
@@ -174,29 +174,18 @@ static void do_write(int fd, void *buf, size_t size)
 	}
 }
 
-static bool write_buildid_table(int fd)
+static void write_buildid_table(int fd, struct list_head *id_head)
 {
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
-		do_write(fd, &b, sizeof(b));
-		do_write(fd, pos->long_name, len);
-	}
+	struct build_id_list *iter, *next;
+
+	list_for_each_entry_safe(iter, next, id_head, list) {
+		struct build_id_event *b = &iter->event;
 
-	return have_buildid;
+		do_write(fd, b, sizeof(*b));
+		do_write(fd, (void *)iter->dso_name, iter->len);
+		list_del(&iter->list);
+		free(iter);
+	}
 }
 
 static void
@@ -226,10 +215,14 @@ perf_header__adds_write(struct perf_header *self, int fd, bool at_exit)
 	}
 
 	if (at_exit) {
-		lseek(fd, self->data_offset + self->data_size, SEEK_SET);
-		if (write_buildid_table(fd))
+		LIST_HEAD(id_list);
+
+		if (fetch_build_id_table(&id_list)) {
+			lseek(fd, self->data_offset + self->data_size, SEEK_SET);
 			perf_header__set_feat(self, HEADER_BUILD_ID);
-		lseek(fd, cur_offset, SEEK_SET);
+			write_buildid_table(fd, &id_list);
+			lseek(fd, cur_offset, SEEK_SET);
+		}
 	}
 };
 
diff --git a/tools/perf/util/symbol.c b/tools/perf/util/symbol.c
index a2e95ce..9c286db 100644
--- a/tools/perf/util/symbol.c
+++ b/tools/perf/util/symbol.c
@@ -851,6 +851,40 @@ out_close:
 	return err;
 }
 
+bool fetch_build_id_table(struct list_head *head)
+{
+	bool have_buildid = false;
+	struct dso *pos;
+
+	list_for_each_entry(pos, &dsos, node) {
+		struct build_id_list *new;
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
+
+		new = malloc(sizeof(*new));
+		if (!new)
+			die("No memory\n");
+
+		memcpy(&new->event, &b, sizeof(b));
+		new->dso_name = pos->long_name;
+		new->len = len;
+
+		list_add_tail(&new->list, head);
+	}
+
+	return have_buildid;
+}
+
 int filename__read_build_id(const char *filename, void *bf, size_t size)
 {
 	int fd, err = -1;
diff --git a/tools/perf/util/symbol.h b/tools/perf/util/symbol.h
index f8c1899..0a34a54 100644
--- a/tools/perf/util/symbol.h
+++ b/tools/perf/util/symbol.h
@@ -86,6 +86,7 @@ char dso__symtab_origin(const struct dso *self);
 void dso__set_build_id(struct dso *self, void *build_id);
 
 int filename__read_build_id(const char *filename, void *bf, size_t size);
+bool fetch_build_id_table(struct list_head *head);
 int build_id__sprintf(u8 *self, int len, char *bf);
 
 int load_kernel(symbol_filter_t filter);
-- 
1.6.2.3

