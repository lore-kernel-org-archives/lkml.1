Return-Path: <linux-kernel-owner+w=401wt.eu-S1756513Ab0A0XHm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756513Ab0A0XHm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jan 2010 18:07:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756493Ab0A0XHh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jan 2010 18:07:37 -0500
Received: from casper.infradead.org ([85.118.1.10]:45489 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755284Ab0A0XGJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jan 2010 18:06:09 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
       =?utf-8?q?Fr=C3=A9d=C3=A9ric=20Weisbecker?= <fweisbec@gmail.com>,
       Mike Galbraith <efault@gmx.de>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>
Subject: [PATCH 3/9] perf symbols: Split helpers used when creating kernel dso object
Date: Wed, 27 Jan 2010 21:05:51 -0200
Message-Id: <1264633557-17597-3-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1264633557-17597-1-git-send-email-acme@infradead.org>
References: <1264633557-17597-1-git-send-email-acme@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

To make it clear and allow for direct usage by, for instance, regression
test suites.

Cc: Frédéric Weisbecker <fweisbec@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/symbol.c |   28 +++++++++++++++++++++-------
 tools/perf/util/symbol.h |    2 ++
 2 files changed, 23 insertions(+), 7 deletions(-)

diff --git a/tools/perf/util/symbol.c b/tools/perf/util/symbol.c
index 26ec603..f9049d1 100644
--- a/tools/perf/util/symbol.c
+++ b/tools/perf/util/symbol.c
@@ -1762,24 +1762,38 @@ size_t dsos__fprintf_buildid(FILE *fp, bool with_hits)
 		__dsos__fprintf_buildid(&dsos__user, fp, with_hits));
 }
 
+struct dso *dso__new_kernel(const char *name)
+{
+	struct dso *self = dso__new(name ?: "[kernel.kallsyms]");
+
+	if (self != NULL) {
+		self->short_name = "[kernel]";
+		self->kernel	 = 1;
+	}
+
+	return self;
+}
+
+void dso__read_running_kernel_build_id(struct dso *self)
+{
+	if (sysfs__read_build_id("/sys/kernel/notes", self->build_id,
+				 sizeof(self->build_id)) == 0)
+		self->has_build_id = true;
+}
+
 static struct dso *dsos__create_kernel(const char *vmlinux)
 {
-	struct dso *kernel = dso__new(vmlinux ?: "[kernel.kallsyms]");
+	struct dso *kernel = dso__new_kernel(vmlinux);
 
 	if (kernel == NULL)
 		return NULL;
 
-	kernel->short_name = "[kernel]";
-	kernel->kernel	   = 1;
-
 	vdso = dso__new("[vdso]");
 	if (vdso == NULL)
 		goto out_delete_kernel_dso;
 	dso__set_loaded(vdso, MAP__FUNCTION);
 
-	if (sysfs__read_build_id("/sys/kernel/notes", kernel->build_id,
-				 sizeof(kernel->build_id)) == 0)
-		kernel->has_build_id = true;
+	dso__read_running_kernel_build_id(kernel);
 
 	dsos__add(&dsos__kernel, kernel);
 	dsos__add(&dsos__user, vdso);
diff --git a/tools/perf/util/symbol.h b/tools/perf/util/symbol.h
index a94997a..1243027 100644
--- a/tools/perf/util/symbol.h
+++ b/tools/perf/util/symbol.h
@@ -109,6 +109,7 @@ struct dso {
 };
 
 struct dso *dso__new(const char *name);
+struct dso *dso__new_kernel(const char *name);
 void dso__delete(struct dso *self);
 
 bool dso__loaded(const struct dso *self, enum map_type type);
@@ -139,6 +140,7 @@ size_t dso__fprintf(struct dso *self, enum map_type type, FILE *fp);
 char dso__symtab_origin(const struct dso *self);
 void dso__set_long_name(struct dso *self, char *name);
 void dso__set_build_id(struct dso *self, void *build_id);
+void dso__read_running_kernel_build_id(struct dso *self);
 struct symbol *dso__find_symbol(struct dso *self, enum map_type type, u64 addr);
 struct symbol *dso__find_symbol_by_name(struct dso *self, enum map_type type,
 					const char *name);
-- 
1.6.2.5

