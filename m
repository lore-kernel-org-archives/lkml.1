Return-Path: <linux-kernel-owner+w=401wt.eu-S1754410AbZKQRlZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754410AbZKQRlZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Nov 2009 12:41:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753907AbZKQRlI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Nov 2009 12:41:08 -0500
Received: from casper.infradead.org ([85.118.1.10]:42362 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753319AbZKQRlF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Nov 2009 12:41:05 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
       =?utf-8?q?Fr=C3=A9d=C3=A9ric=20Weisbecker?= <fweisbec@gmail.com>,
       Mike Galbraith <efault@gmx.de>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>
Subject: [PATCH 1/3] perf symbols: Add a long_name_len member to struct dso
Date: Tue, 17 Nov 2009 15:40:53 -0200
Message-Id: <1258479655-28662-1-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

Using a two bytes hole we already had and since we also need to
calculate this strlen for fetching the buildids. We'll use it in 'perf
top' to auto-adjust the output based on the terminal width.

Cc: Frédéric Weisbecker <fweisbec@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/symbol.c |   26 +++++++++++++++++++++-----
 tools/perf/util/symbol.h |    1 +
 2 files changed, 22 insertions(+), 5 deletions(-)

diff --git a/tools/perf/util/symbol.c b/tools/perf/util/symbol.c
index 1b77e81..5cc96c8 100644
--- a/tools/perf/util/symbol.c
+++ b/tools/perf/util/symbol.c
@@ -109,13 +109,24 @@ static size_t symbol__fprintf(struct symbol *self, FILE *fp)
 		       self->start, self->end, self->name);
 }
 
+static void dso__set_long_name(struct dso *self, char *name)
+{
+	self->long_name = name;
+	self->long_name_len = strlen(name);
+}
+
+static void dso__set_basename(struct dso *self)
+{
+	self->short_name = basename(self->long_name);
+}
+
 struct dso *dso__new(const char *name)
 {
 	struct dso *self = malloc(sizeof(*self) + strlen(name) + 1);
 
 	if (self != NULL) {
 		strcpy(self->name, name);
-		self->long_name = self->name;
+		dso__set_long_name(self, self->name);
 		self->short_name = self->name;
 		self->syms = RB_ROOT;
 		self->find_symbol = dso__find_symbol;
@@ -888,7 +899,7 @@ bool fetch_build_id_table(struct list_head *head)
 			continue;
 		have_buildid = true;
 		memset(&b.header, 0, sizeof(b.header));
-		len = strlen(pos->long_name) + 1;
+		len = pos->long_name_len + 1;
 		len = ALIGN(len, 64);
 		b.header.size = sizeof(b) + len;
 
@@ -1165,6 +1176,7 @@ static int dsos__load_modules_sym_dir(char *dirname, symbol_filter_t filter)
 			     dso_name[PATH_MAX];
 			struct map *map;
 			struct rb_node *last;
+			char *long_name;
 
 			if (dot == NULL || strcmp(dot, ".ko"))
 				continue;
@@ -1179,9 +1191,11 @@ static int dsos__load_modules_sym_dir(char *dirname, symbol_filter_t filter)
 			snprintf(path, sizeof(path), "%s/%s",
 				 dirname, dent->d_name);
 
-			map->dso->long_name = strdup(path);
-			if (map->dso->long_name == NULL)
+			long_name = strdup(path);
+			if (long_name == NULL)
 				goto failure;
+			dso__set_long_name(map->dso, long_name);
+			dso__set_basename(map->dso);
 
 			err = dso__load_module_sym(map->dso, map, filter);
 			if (err < 0)
@@ -1420,8 +1434,10 @@ struct dso *dsos__findnew(const char *name)
 
 	if (!dso) {
 		dso = dso__new(name);
-		if (dso != NULL)
+		if (dso != NULL) {
 			dsos__add(dso);
+			dso__set_basename(dso);
+		}
 	}
 
 	return dso;
diff --git a/tools/perf/util/symbol.h b/tools/perf/util/symbol.h
index 51c5a4a..5ad1019 100644
--- a/tools/perf/util/symbol.h
+++ b/tools/perf/util/symbol.h
@@ -66,6 +66,7 @@ struct dso {
 	u8		 has_build_id:1;
 	unsigned char	 origin;
 	u8		 build_id[BUILD_ID_SIZE];
+	u16		 long_name_len;
 	const char	 *short_name;
 	char	 	 *long_name;
 	char		 name[0];
-- 
1.6.2.5

