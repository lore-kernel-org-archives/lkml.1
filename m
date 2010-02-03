Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757499Ab0BCSwe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Feb 2010 13:52:34 -0500
Received: from casper.infradead.org ([85.118.1.10]:53445 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757148Ab0BCSwX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Feb 2010 13:52:23 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
       =?utf-8?q?Fr=C3=A9d=C3=A9ric=20Weisbecker?= <fweisbec@gmail.com>,
       Mike Galbraith <efault@gmx.de>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>
Subject: [PATCH 3/9] perf symbols: Ditch vdso global variable
Date: Wed,  3 Feb 2010 16:52:02 -0200
Message-Id: <1265223128-11786-3-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1265223128-11786-1-git-send-email-acme@infradead.org>
References: <1265223128-11786-1-git-send-email-acme@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

We can check using strcmp, most DSOs don't start with '[' so the test is
cheap enough and we had to test it there anyway since when reading
perf.data files we weren't calling the routine that created this global
variable and thus weren't setting it as "loaded", which was causing a
bogus:

Failed to open [vdso], continuing without symbols

Message as the first line of 'perf report'.

Cc: Frédéric Weisbecker <fweisbec@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/map.c    |    7 ++++++-
 tools/perf/util/symbol.c |   26 ++++----------------------
 tools/perf/util/symbol.h |    6 +++++-
 3 files changed, 15 insertions(+), 24 deletions(-)

diff --git a/tools/perf/util/map.c b/tools/perf/util/map.c
index 36ff0bf..f6626cc 100644
--- a/tools/perf/util/map.c
+++ b/tools/perf/util/map.c
@@ -68,8 +68,13 @@ struct map *map__new(struct mmap_event *event, enum map_type type,
 		map__init(self, type, event->start, event->start + event->len,
 			  event->pgoff, dso);
 
-		if (self->dso == vdso || anon)
+		if (anon) {
+set_identity:
 			self->map_ip = self->unmap_ip = identity__map_ip;
+		} else if (strcmp(filename, "[vdso]") == 0) {
+			dso__set_loaded(dso, self->type);
+			goto set_identity;
+		}
 	}
 	return self;
 out_delete:
diff --git a/tools/perf/util/symbol.c b/tools/perf/util/symbol.c
index 051d71b..e752837 100644
--- a/tools/perf/util/symbol.c
+++ b/tools/perf/util/symbol.c
@@ -53,11 +53,6 @@ bool dso__sorted_by_name(const struct dso *self, enum map_type type)
 	return self->sorted_by_name & (1 << type);
 }
 
-static void dso__set_loaded(struct dso *self, enum map_type type)
-{
-	self->loaded |= (1 << type);
-}
-
 static void dso__set_sorted_by_name(struct dso *self, enum map_type type)
 {
 	self->sorted_by_name |= (1 << type);
@@ -1697,7 +1692,6 @@ out_fixup:
 
 LIST_HEAD(dsos__user);
 LIST_HEAD(dsos__kernel);
-struct dso *vdso;
 
 static void dsos__add(struct list_head *head, struct dso *dso)
 {
@@ -1790,24 +1784,12 @@ static struct dso *dsos__create_kernel(const char *vmlinux)
 {
 	struct dso *kernel = dso__new_kernel(vmlinux);
 
-	if (kernel == NULL)
-		return NULL;
-
-	vdso = dso__new("[vdso]");
-	if (vdso == NULL)
-		goto out_delete_kernel_dso;
-	dso__set_loaded(vdso, MAP__FUNCTION);
-
-	dso__read_running_kernel_build_id(kernel);
-
-	dsos__add(&dsos__kernel, kernel);
-	dsos__add(&dsos__user, vdso);
+	if (kernel != NULL) {
+		dso__read_running_kernel_build_id(kernel);
+		dsos__add(&dsos__kernel, kernel);
+	}
 
 	return kernel;
-
-out_delete_kernel_dso:
-	dso__delete(kernel);
-	return NULL;
 }
 
 int __map_groups__create_kernel_maps(struct map_groups *self,
diff --git a/tools/perf/util/symbol.h b/tools/perf/util/symbol.h
index e6a59e5..e90568a 100644
--- a/tools/perf/util/symbol.h
+++ b/tools/perf/util/symbol.h
@@ -121,6 +121,11 @@ void dso__delete(struct dso *self);
 bool dso__loaded(const struct dso *self, enum map_type type);
 bool dso__sorted_by_name(const struct dso *self, enum map_type type);
 
+static inline void dso__set_loaded(struct dso *self, enum map_type type)
+{
+	self->loaded |= (1 << type);
+}
+
 void dso__sort_by_name(struct dso *self, enum map_type type);
 
 extern struct list_head dsos__user, dsos__kernel;
@@ -161,5 +166,4 @@ int kallsyms__parse(const char *filename, void *arg,
 int symbol__init(void);
 bool symbol_type__is_a(char symbol_type, enum map_type map_type);
 
-extern struct dso *vdso;
 #endif /* __PERF_SYMBOL */
-- 
1.6.2.5

