Return-Path: <linux-kernel-owner+w=401wt.eu-S1754234Ab0AGV74@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754234Ab0AGV74 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jan 2010 16:59:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752273Ab0AGV7z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jan 2010 16:59:55 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:57446 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750870Ab0AGV7y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jan 2010 16:59:54 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
       =?utf-8?q?Fr=C3=A9d=C3=A9ric=20Weisbecker?= <fweisbec@gmail.com>,
       Mike Galbraith <efault@gmx.de>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>
Subject: [PATCH 2/6] perf symbols: Record the domain of DSOs in HEADER_BUILD_ID header table
Date: Thu,  7 Jan 2010 19:59:39 -0200
Message-Id: <1262901583-8074-2-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1262901583-8074-1-git-send-email-acme@infradead.org>
References: <1262901583-8074-1-git-send-email-acme@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

So that we can restore them to the right DSO list (either dsos__kernel
or dsos__user).

We do that just like the kernel does for the other events, encoding
PERF_RECORD_MISC_{KERNEL,USER} in perf_event_header.

Cc: Frédéric Weisbecker <fweisbec@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/header.c  |    9 ++++++---
 tools/perf/util/session.c |    6 +++++-
 tools/perf/util/symbol.c  |    6 +++---
 tools/perf/util/symbol.h  |   11 +++++++++--
 4 files changed, 23 insertions(+), 9 deletions(-)

diff --git a/tools/perf/util/header.c b/tools/perf/util/header.c
index 942f7da..ec96321 100644
--- a/tools/perf/util/header.c
+++ b/tools/perf/util/header.c
@@ -193,7 +193,7 @@ static int write_padded(int fd, const void *bf, size_t count,
 			continue;		\
 		else
 
-static int __dsos__write_buildid_table(struct list_head *head, int fd)
+static int __dsos__write_buildid_table(struct list_head *head, u16 misc, int fd)
 {
 	struct dso *pos;
 
@@ -205,6 +205,7 @@ static int __dsos__write_buildid_table(struct list_head *head, int fd)
 		len = ALIGN(len, NAME_ALIGN);
 		memset(&b, 0, sizeof(b));
 		memcpy(&b.build_id, pos->build_id, sizeof(pos->build_id));
+		b.header.misc = misc;
 		b.header.size = sizeof(b) + len;
 		err = do_write(fd, &b, sizeof(b));
 		if (err < 0)
@@ -220,9 +221,11 @@ static int __dsos__write_buildid_table(struct list_head *head, int fd)
 
 static int dsos__write_buildid_table(int fd)
 {
-	int err = __dsos__write_buildid_table(&dsos__kernel, fd);
+	int err = __dsos__write_buildid_table(&dsos__kernel,
+					      PERF_RECORD_MISC_KERNEL, fd);
 	if (err == 0)
-		err = __dsos__write_buildid_table(&dsos__user, fd);
+		err = __dsos__write_buildid_table(&dsos__user,
+						  PERF_RECORD_MISC_USER, fd);
 	return err;
 }
 
diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
index e0e6a07..378ac54 100644
--- a/tools/perf/util/session.c
+++ b/tools/perf/util/session.c
@@ -255,6 +255,7 @@ int perf_header__read_build_ids(int input, u64 offset, u64 size)
 	while (offset < limit) {
 		struct dso *dso;
 		ssize_t len;
+		struct list_head *head = &dsos__user;
 
 		if (read(input, &bev, sizeof(bev)) != sizeof(bev))
 			goto out;
@@ -263,7 +264,10 @@ int perf_header__read_build_ids(int input, u64 offset, u64 size)
 		if (read(input, filename, len) != len)
 			goto out;
 
-		dso = dsos__findnew(filename);
+		if (bev.header.misc & PERF_RECORD_MISC_KERNEL)
+			head = &dsos__kernel;
+
+		dso = __dsos__findnew(head, filename);
 		if (dso != NULL)
 			dso__set_build_id(dso, &bev.build_id);
 
diff --git a/tools/perf/util/symbol.c b/tools/perf/util/symbol.c
index da2f07f..8e6627e 100644
--- a/tools/perf/util/symbol.c
+++ b/tools/perf/util/symbol.c
@@ -1615,14 +1615,14 @@ static struct dso *dsos__find(struct list_head *head, const char *name)
 	return NULL;
 }
 
-struct dso *dsos__findnew(const char *name)
+struct dso *__dsos__findnew(struct list_head *head, const char *name)
 {
-	struct dso *dso = dsos__find(&dsos__user, name);
+	struct dso *dso = dsos__find(head, name);
 
 	if (!dso) {
 		dso = dso__new(name);
 		if (dso != NULL) {
-			dsos__add(&dsos__user, dso);
+			dsos__add(head, dso);
 			dso__set_basename(dso);
 		}
 	}
diff --git a/tools/perf/util/symbol.h b/tools/perf/util/symbol.h
index b2b5330..ee0b459 100644
--- a/tools/perf/util/symbol.h
+++ b/tools/perf/util/symbol.h
@@ -115,9 +115,17 @@ bool dso__sorted_by_name(const struct dso *self, enum map_type type);
 
 void dso__sort_by_name(struct dso *self, enum map_type type);
 
+extern struct list_head dsos__user, dsos__kernel;
+
+struct dso *__dsos__findnew(struct list_head *head, const char *name);
+
+static inline struct dso *dsos__findnew(const char *name)
+{
+	return __dsos__findnew(&dsos__user, name);
+}
+
 struct perf_session;
 
-struct dso *dsos__findnew(const char *name);
 int dso__load(struct dso *self, struct map *map, struct perf_session *session,
 	      symbol_filter_t filter);
 void dsos__fprintf(FILE *fp);
@@ -143,6 +151,5 @@ bool symbol_type__is_a(char symbol_type, enum map_type map_type);
 
 int perf_session__create_kernel_maps(struct perf_session *self);
 
-extern struct list_head dsos__user, dsos__kernel;
 extern struct dso *vdso;
 #endif /* __PERF_SYMBOL */
-- 
1.6.2.5

