Return-Path: <linux-kernel-owner+w=401wt.eu-S1752866AbZKPScs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752866AbZKPScs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Nov 2009 13:32:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752494AbZKPScr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Nov 2009 13:32:47 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:55024 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751634AbZKPScr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Nov 2009 13:32:47 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
       Peter Zijlstra <peterz@infradead.org>
Subject: [PATCH 4/5] perf tools: Introduce dsos__fprintf_buildid
Date: Mon, 16 Nov 2009 16:32:44 -0200
Message-Id: <1258396365-29217-4-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1258396365-29217-3-git-send-email-acme@infradead.org>
References: <1258396365-29217-1-git-send-email-acme@infradead.org>
 <1258396365-29217-2-git-send-email-acme@infradead.org>
 <1258396365-29217-3-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

To print the buildids in the list of dsos. Will be used by 'perf
buildid-list'

Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/symbol.c |   30 ++++++++++++++++++++++++++----
 tools/perf/util/symbol.h |    2 ++
 2 files changed, 28 insertions(+), 4 deletions(-)

diff --git a/tools/perf/util/symbol.c b/tools/perf/util/symbol.c
index 93e4b52..53de9c4 100644
--- a/tools/perf/util/symbol.c
+++ b/tools/perf/util/symbol.c
@@ -212,14 +212,21 @@ int build_id__sprintf(u8 *self, int len, char *bf)
 	return raw - self;
 }
 
-size_t dso__fprintf(struct dso *self, FILE *fp)
+size_t dso__fprintf_buildid(struct dso *self, FILE *fp)
 {
 	char sbuild_id[BUILD_ID_SIZE * 2 + 1];
-	struct rb_node *nd;
-	size_t ret;
 
 	build_id__sprintf(self->build_id, sizeof(self->build_id), sbuild_id);
-	ret = fprintf(fp, "dso: %s (%s)\n", self->short_name, sbuild_id);
+	return fprintf(fp, "%s", sbuild_id);
+}
+
+size_t dso__fprintf(struct dso *self, FILE *fp)
+{
+	struct rb_node *nd;
+	size_t ret = fprintf(fp, "dso: %s (", self->short_name);
+
+	ret += dso__fprintf_buildid(self, fp);
+	ret += fprintf(fp, ")\n");
 
 	for (nd = rb_first(&self->syms); nd; nd = rb_next(nd)) {
 		struct symbol *pos = rb_entry(nd, struct symbol, rb_node);
@@ -1428,6 +1435,21 @@ void dsos__fprintf(FILE *fp)
 		dso__fprintf(pos, fp);
 }
 
+size_t dsos__fprintf_buildid(FILE *fp)
+{
+	struct dso *pos;
+	size_t ret = 0;
+
+	list_for_each_entry(pos, &dsos, node) {
+		ret += dso__fprintf_buildid(pos, fp);
+		if (verbose)
+			ret += fprintf(fp, " %s\n", pos->long_name);
+		else
+			ret += fprintf(fp, "\n");
+	}
+	return ret;
+}
+
 int load_kernel(symbol_filter_t filter)
 {
 	if (dsos__load_kernel(vmlinux_name, filter, modules) <= 0)
diff --git a/tools/perf/util/symbol.h b/tools/perf/util/symbol.h
index 0a34a54..51c5a4a 100644
--- a/tools/perf/util/symbol.h
+++ b/tools/perf/util/symbol.h
@@ -80,7 +80,9 @@ int dsos__load_kernel(const char *vmlinux, symbol_filter_t filter, int modules);
 struct dso *dsos__findnew(const char *name);
 int dso__load(struct dso *self, struct map *map, symbol_filter_t filter);
 void dsos__fprintf(FILE *fp);
+size_t dsos__fprintf_buildid(FILE *fp);
 
+size_t dso__fprintf_buildid(struct dso *self, FILE *fp);
 size_t dso__fprintf(struct dso *self, FILE *fp);
 char dso__symtab_origin(const struct dso *self);
 void dso__set_build_id(struct dso *self, void *build_id);
-- 
1.6.2.5

