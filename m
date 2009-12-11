Return-Path: <linux-kernel-owner+w=401wt.eu-S1758552AbZLKU4o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758552AbZLKU4o (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Dec 2009 15:56:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756746AbZLKU4k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Dec 2009 15:56:40 -0500
Received: from casper.infradead.org ([85.118.1.10]:52940 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756138AbZLKU4j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Dec 2009 15:56:39 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
       =?utf-8?q?Fr=C3=A9d=C3=A9ric=20Weisbecker?= <fweisbec@gmail.com>,
       Mike Galbraith <efault@gmx.de>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>
Subject: [PATCH 1/1] perf symbols: Ditch dso->find_symbol
Date: Fri, 11 Dec 2009 18:56:39 -0200
Message-Id: <1260564999-13371-1-git-send-email-acme@infradead.org>
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

It is always wired to dso__find_symbol.

Cc: Frédéric Weisbecker <fweisbec@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/map.c    |    2 +-
 tools/perf/util/symbol.c |    2 --
 tools/perf/util/symbol.h |    3 +--
 3 files changed, 2 insertions(+), 5 deletions(-)

diff --git a/tools/perf/util/map.c b/tools/perf/util/map.c
index 175f1f6..76bdca6 100644
--- a/tools/perf/util/map.c
+++ b/tools/perf/util/map.c
@@ -149,7 +149,7 @@ struct symbol *map__find_symbol(struct map *self, u64 addr,
 	if (!dso__loaded(self->dso, self->type) && map__load(self, filter) < 0)
 		return NULL;
 
-	return self->dso->find_symbol(self->dso, self->type, addr);
+	return dso__find_symbol(self->dso, self->type, addr);
 }
 
 struct symbol *map__find_symbol_by_name(struct map *self, const char *name,
diff --git a/tools/perf/util/symbol.c b/tools/perf/util/symbol.c
index 8134c49..d3d9fed 100644
--- a/tools/perf/util/symbol.c
+++ b/tools/perf/util/symbol.c
@@ -30,7 +30,6 @@ enum dso_origin {
 
 static void dsos__add(struct list_head *head, struct dso *dso);
 static struct map *map__new2(u64 start, struct dso *dso, enum map_type type);
-struct symbol *dso__find_symbol(struct dso *self, enum map_type type, u64 addr);
 static int dso__load_kernel_sym(struct dso *self, struct map *map,
 				struct map_groups *mg, symbol_filter_t filter);
 unsigned int symbol__priv_size;
@@ -186,7 +185,6 @@ struct dso *dso__new(const char *name)
 		self->short_name = self->name;
 		for (i = 0; i < MAP__NR_TYPES; ++i)
 			self->symbols[i] = self->symbol_names[i] = RB_ROOT;
-		self->find_symbol = dso__find_symbol;
 		self->slen_calculated = 0;
 		self->origin = DSO__ORIG_NOT_FOUND;
 		self->loaded = 0;
diff --git a/tools/perf/util/symbol.h b/tools/perf/util/symbol.h
index 51c4013..cf99f88 100644
--- a/tools/perf/util/symbol.h
+++ b/tools/perf/util/symbol.h
@@ -76,8 +76,6 @@ struct dso {
 	struct list_head node;
 	struct rb_root	 symbols[MAP__NR_TYPES];
 	struct rb_root	 symbol_names[MAP__NR_TYPES];
-	struct symbol    *(*find_symbol)(struct dso *self,
-					 enum map_type type, u64 addr);
 	u8		 adjust_symbols:1;
 	u8		 slen_calculated:1;
 	u8		 has_build_id:1;
@@ -109,6 +107,7 @@ size_t dso__fprintf_buildid(struct dso *self, FILE *fp);
 size_t dso__fprintf(struct dso *self, enum map_type type, FILE *fp);
 char dso__symtab_origin(const struct dso *self);
 void dso__set_build_id(struct dso *self, void *build_id);
+struct symbol *dso__find_symbol(struct dso *self, enum map_type type, u64 addr);
 struct symbol *dso__find_symbol_by_name(struct dso *self, enum map_type type,
 					const char *name);
 
-- 
1.6.2.5

