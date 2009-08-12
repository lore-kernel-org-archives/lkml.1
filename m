Return-Path: <linux-kernel-owner+w=401wt.eu-S932329AbZHLJ0U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932329AbZHLJ0U (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Aug 2009 05:26:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932309AbZHLJ0Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Aug 2009 05:26:16 -0400
Received: from mail-ew0-f214.google.com ([209.85.219.214]:41255 "EHLO
	mail-ew0-f214.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755197AbZHLJ0L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Aug 2009 05:26:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=HzTqjN7aMwpnRBs7mshmR+pkSHe0LZyLp75Z94xAovOe9KLJlbdvnAkjG+71FkpNbU
         x03CwXtsoGQYGM2cDFk3MkkiBAnvctSJLwZzsWX6Vj4/M6FEDUyUZhHXz7z3D/AC6smO
         0gUxh8i3QxfSg+UZ2Lg/tTRUfj+q23tjxsm5s=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Peter Zijlstra <peterz@infradead.org>, Mike Galbraith <efault@gmx.de>,
       Brice Goglin <Brice.Goglin@inria.fr>
Subject: [PATCH 3/3] perf tools: Factorize the map helpers
Date: Wed, 12 Aug 2009 11:26:02 +0200
Message-Id: <1250069162-13099-4-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
In-Reply-To: <1250069162-13099-1-git-send-email-fweisbec@gmail.com>
References: <1250069162-13099-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Factorize the dso mapping helpers into a single purpose common file
"util/map.c"

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Brice Goglin <Brice.Goglin@inria.fr>
---
 tools/perf/Makefile           |    1 +
 tools/perf/builtin-annotate.c |   79 +--------------------------
 tools/perf/builtin-record.c   |    1 +
 tools/perf/builtin-report.c   |  124 ++---------------------------------------
 tools/perf/util/callchain.h   |    1 +
 tools/perf/util/event.h       |   30 ++++++++++
 tools/perf/util/map.c         |   97 ++++++++++++++++++++++++++++++++
 tools/perf/util/symbol.h      |    1 +
 tools/perf/util/util.h        |    1 -
 9 files changed, 137 insertions(+), 198 deletions(-)
 create mode 100644 tools/perf/util/map.c

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index 2aee21b..f4d868c 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -340,6 +340,7 @@ LIB_OBJS += util/header.o
 LIB_OBJS += util/callchain.o
 LIB_OBJS += util/values.o
 LIB_OBJS += util/debug.o
+LIB_OBJS += util/event.o
 
 BUILTIN_OBJS += builtin-annotate.o
 BUILTIN_OBJS += builtin-help.o
diff --git a/tools/perf/builtin-annotate.c b/tools/perf/builtin-annotate.c
index fee663a..543c452 100644
--- a/tools/perf/builtin-annotate.c
+++ b/tools/perf/builtin-annotate.c
@@ -51,83 +51,6 @@ struct sym_ext {
 	char		*path;
 };
 
-struct map {
-	struct list_head node;
-	u64	 start;
-	u64	 end;
-	u64	 pgoff;
-	u64	 (*map_ip)(struct map *, u64);
-	struct dso	 *dso;
-};
-
-static u64 map__map_ip(struct map *map, u64 ip)
-{
-	return ip - map->start + map->pgoff;
-}
-
-static u64 vdso__map_ip(struct map *map __used, u64 ip)
-{
-	return ip;
-}
-
-static struct map *map__new(struct mmap_event *event)
-{
-	struct map *self = malloc(sizeof(*self));
-
-	if (self != NULL) {
-		const char *filename = event->filename;
-
-		self->start = event->start;
-		self->end   = event->start + event->len;
-		self->pgoff = event->pgoff;
-
-		self->dso = dsos__findnew(filename);
-		if (self->dso == NULL)
-			goto out_delete;
-
-		if (self->dso == vdso)
-			self->map_ip = vdso__map_ip;
-		else
-			self->map_ip = map__map_ip;
-	}
-	return self;
-out_delete:
-	free(self);
-	return NULL;
-}
-
-static struct map *map__clone(struct map *self)
-{
-	struct map *map = malloc(sizeof(*self));
-
-	if (!map)
-		return NULL;
-
-	memcpy(map, self, sizeof(*self));
-
-	return map;
-}
-
-static int map__overlap(struct map *l, struct map *r)
-{
-	if (l->start > r->start) {
-		struct map *t = l;
-		l = r;
-		r = t;
-	}
-
-	if (l->end > r->start)
-		return 1;
-
-	return 0;
-}
-
-static size_t map__fprintf(struct map *self, FILE *fp)
-{
-	return fprintf(fp, " %Lx-%Lx %Lx %s\n",
-		       self->start, self->end, self->pgoff, self->dso->name);
-}
-
 
 struct thread {
 	struct rb_node	 rb_node;
@@ -797,7 +720,7 @@ static int
 process_mmap_event(event_t *event, unsigned long offset, unsigned long head)
 {
 	struct thread *thread = threads__findnew(event->mmap.pid);
-	struct map *map = map__new(&event->mmap);
+	struct map *map = map__new(&event->mmap, NULL, 0);
 
 	dprintf("%p [%p]: PERF_EVENT_MMAP %d: [%p(%p) @ %p]: %s\n",
 		(void *)(offset + head),
diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index 718b8f7..106c6ab 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -15,6 +15,7 @@
 #include "util/string.h"
 
 #include "util/header.h"
+#include "util/event.h"
 
 #include <unistd.h>
 #include <sched.h>
diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index 1efefcc..93945ec 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -67,6 +67,10 @@ static char		callchain_default_opt[] = "fractal,0.5";
 
 static int		callchain;
 
+static char		__cwd[PATH_MAX];
+static char		*cwd = __cwd;
+static int		cwdlen;
+
 static
 struct callchain_param	callchain_param = {
 	.mode	= CHAIN_GRAPH_REL,
@@ -102,124 +106,6 @@ static int repsep_fprintf(FILE *fp, const char *fmt, ...)
 	return n;
 }
 
-
-
-static char __cwd[PATH_MAX];
-static char *cwd = __cwd;
-static int cwdlen;
-
-static int strcommon(const char *pathname)
-{
-	int n = 0;
-
-	while (n < cwdlen && pathname[n] == cwd[n])
-		++n;
-
-	return n;
-}
-
-struct map {
-	struct list_head node;
-	u64	 start;
-	u64	 end;
-	u64	 pgoff;
-	u64	 (*map_ip)(struct map *, u64);
-	struct dso	 *dso;
-};
-
-static u64 map__map_ip(struct map *map, u64 ip)
-{
-	return ip - map->start + map->pgoff;
-}
-
-static u64 vdso__map_ip(struct map *map __used, u64 ip)
-{
-	return ip;
-}
-
-static inline int is_anon_memory(const char *filename)
-{
-	return strcmp(filename, "//anon") == 0;
-}
-
-static struct map *map__new(struct mmap_event *event)
-{
-	struct map *self = malloc(sizeof(*self));
-
-	if (self != NULL) {
-		const char *filename = event->filename;
-		char newfilename[PATH_MAX];
-		int anon;
-
-		if (cwd) {
-			int n = strcommon(filename);
-
-			if (n == cwdlen) {
-				snprintf(newfilename, sizeof(newfilename),
-					 ".%s", filename + n);
-				filename = newfilename;
-			}
-		}
-
-		anon = is_anon_memory(filename);
-
-		if (anon) {
-			snprintf(newfilename, sizeof(newfilename), "/tmp/perf-%d.map", event->pid);
-			filename = newfilename;
-		}
-
-		self->start = event->start;
-		self->end   = event->start + event->len;
-		self->pgoff = event->pgoff;
-
-		self->dso = dsos__findnew(filename);
-		if (self->dso == NULL)
-			goto out_delete;
-
-		if (self->dso == vdso || anon)
-			self->map_ip = vdso__map_ip;
-		else
-			self->map_ip = map__map_ip;
-	}
-	return self;
-out_delete:
-	free(self);
-	return NULL;
-}
-
-static struct map *map__clone(struct map *self)
-{
-	struct map *map = malloc(sizeof(*self));
-
-	if (!map)
-		return NULL;
-
-	memcpy(map, self, sizeof(*self));
-
-	return map;
-}
-
-static int map__overlap(struct map *l, struct map *r)
-{
-	if (l->start > r->start) {
-		struct map *t = l;
-		l = r;
-		r = t;
-	}
-
-	if (l->end > r->start)
-		return 1;
-
-	return 0;
-}
-
-static size_t map__fprintf(struct map *self, FILE *fp)
-{
-	return fprintf(fp, " %Lx-%Lx %Lx %s\n",
-		       self->start, self->end, self->pgoff, self->dso->name);
-}
-
-
 struct thread {
 	struct rb_node	 rb_node;
 	struct list_head maps;
@@ -1474,7 +1360,7 @@ static int
 process_mmap_event(event_t *event, unsigned long offset, unsigned long head)
 {
 	struct thread *thread = threads__findnew(event->mmap.pid);
-	struct map *map = map__new(&event->mmap);
+	struct map *map = map__new(&event->mmap, cwd, cwdlen);
 
 	dprintf("%p [%p]: PERF_EVENT_MMAP %d: [%p(%p) @ %p]: %s\n",
 		(void *)(offset + head),
diff --git a/tools/perf/util/callchain.h b/tools/perf/util/callchain.h
index a926ae4..43cf3ea 100644
--- a/tools/perf/util/callchain.h
+++ b/tools/perf/util/callchain.h
@@ -4,6 +4,7 @@
 #include "../perf.h"
 #include <linux/list.h>
 #include <linux/rbtree.h>
+#include "util.h"
 #include "symbol.h"
 
 enum chain_mode {
diff --git a/tools/perf/util/event.h b/tools/perf/util/event.h
index 91e2fe5..d26dc88 100644
--- a/tools/perf/util/event.h
+++ b/tools/perf/util/event.h
@@ -1,4 +1,8 @@
+#ifndef __PERF_EVENT_H
+#define __PERF_EVENT_H
 #include "../perf.h"
+#include "util.h"
+#include <linux/list.h>
 
 struct ip_event {
 	struct perf_event_header header;
@@ -52,3 +56,29 @@ typedef union event_union {
 	struct lost_event		lost;
 	struct read_event		read;
 } event_t;
+
+struct map {
+	struct list_head	node;
+	u64			start;
+	u64			end;
+	u64			pgoff;
+	u64			(*map_ip)(struct map *, u64);
+	struct dso		*dso;
+};
+
+static inline u64 map__map_ip(struct map *map, u64 ip)
+{
+	return ip - map->start + map->pgoff;
+}
+
+static inline u64 vdso__map_ip(struct map *map __used, u64 ip)
+{
+	return ip;
+}
+
+struct map *map__new(struct mmap_event *event, char *cwd, int cwdlen);
+struct map *map__clone(struct map *self);
+int map__overlap(struct map *l, struct map *r);
+size_t map__fprintf(struct map *self, FILE *fp);
+
+#endif
diff --git a/tools/perf/util/map.c b/tools/perf/util/map.c
new file mode 100644
index 0000000..804e023
--- /dev/null
+++ b/tools/perf/util/map.c
@@ -0,0 +1,97 @@
+#include "event.h"
+#include "symbol.h"
+#include <stdlib.h>
+#include <string.h>
+#include <stdio.h>
+
+static inline int is_anon_memory(const char *filename)
+{
+	return strcmp(filename, "//anon") == 0;
+}
+
+static int strcommon(const char *pathname, char *cwd, int cwdlen)
+{
+	int n = 0;
+
+	while (n < cwdlen && pathname[n] == cwd[n])
+		++n;
+
+	return n;
+}
+
+ struct map *map__new(struct mmap_event *event, char *cwd, int cwdlen)
+{
+	struct map *self = malloc(sizeof(*self));
+
+	if (self != NULL) {
+		const char *filename = event->filename;
+		char newfilename[PATH_MAX];
+		int anon;
+
+		if (cwd) {
+			int n = strcommon(filename, cwd, cwdlen);
+
+			if (n == cwdlen) {
+				snprintf(newfilename, sizeof(newfilename),
+					 ".%s", filename + n);
+				filename = newfilename;
+			}
+		}
+
+		anon = is_anon_memory(filename);
+
+		if (anon) {
+			snprintf(newfilename, sizeof(newfilename), "/tmp/perf-%d.map", event->pid);
+			filename = newfilename;
+		}
+
+		self->start = event->start;
+		self->end   = event->start + event->len;
+		self->pgoff = event->pgoff;
+
+		self->dso = dsos__findnew(filename);
+		if (self->dso == NULL)
+			goto out_delete;
+
+		if (self->dso == vdso || anon)
+			self->map_ip = vdso__map_ip;
+		else
+			self->map_ip = map__map_ip;
+	}
+	return self;
+out_delete:
+	free(self);
+	return NULL;
+}
+
+struct map *map__clone(struct map *self)
+{
+	struct map *map = malloc(sizeof(*self));
+
+	if (!map)
+		return NULL;
+
+	memcpy(map, self, sizeof(*self));
+
+	return map;
+}
+
+int map__overlap(struct map *l, struct map *r)
+{
+	if (l->start > r->start) {
+		struct map *t = l;
+		l = r;
+		r = t;
+	}
+
+	if (l->end > r->start)
+		return 1;
+
+	return 0;
+}
+
+size_t map__fprintf(struct map *self, FILE *fp)
+{
+	return fprintf(fp, " %Lx-%Lx %Lx %s\n",
+		       self->start, self->end, self->pgoff, self->dso->name);
+}
diff --git a/tools/perf/util/symbol.h b/tools/perf/util/symbol.h
index f3490fc..50f7235 100644
--- a/tools/perf/util/symbol.h
+++ b/tools/perf/util/symbol.h
@@ -6,6 +6,7 @@
 #include <linux/list.h>
 #include <linux/rbtree.h>
 #include "module.h"
+#include "event.h"
 
 struct symbol {
 	struct rb_node	rb_node;
diff --git a/tools/perf/util/util.h b/tools/perf/util/util.h
index be4b52c..d61a6f0 100644
--- a/tools/perf/util/util.h
+++ b/tools/perf/util/util.h
@@ -83,7 +83,6 @@
 #include <inttypes.h>
 #include "../../../include/linux/magic.h"
 
-#include "event.h"
 
 #ifndef NO_ICONV
 #include <iconv.h>
-- 
1.6.2.3

