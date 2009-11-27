Return-Path: <linux-kernel-owner+w=401wt.eu-S1753268AbZK0Sbp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753268AbZK0Sbp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Nov 2009 13:31:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753113AbZK0Sbn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Nov 2009 13:31:43 -0500
Received: from casper.infradead.org ([85.118.1.10]:43539 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753057AbZK0S3h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Nov 2009 13:29:37 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
       =?utf-8?q?Fr=C3=A9d=C3=A9ric=20Weisbecker?= <fweisbec@gmail.com>,
       Mike Galbraith <efault@gmx.de>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>
Subject: [PATCH 05/12] perf symbols: Add a 'type' field to struct map
Date: Fri, 27 Nov 2009 16:29:16 -0200
Message-Id: <1259346563-12568-5-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1259346563-12568-4-git-send-email-acme@infradead.org>
References: <1259346563-12568-1-git-send-email-acme@infradead.org>
 <1259346563-12568-2-git-send-email-acme@infradead.org>
 <1259346563-12568-3-git-send-email-acme@infradead.org>
 <1259346563-12568-4-git-send-email-acme@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

That way we will be able to check if the right symtab is loaded in the
underlying DSO.

Cc: Frédéric Weisbecker <fweisbec@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-top.c         |    2 +-
 tools/perf/util/event.h          |   12 +++++++++---
 tools/perf/util/map.c            |   12 +++++++-----
 tools/perf/util/process_events.c |    2 +-
 tools/perf/util/symbol.c         |   31 +++++++++++++++++++++----------
 tools/perf/util/symbol.h         |    4 +++-
 6 files changed, 42 insertions(+), 21 deletions(-)

diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
index ded6cf6..a0168f2 100644
--- a/tools/perf/builtin-top.c
+++ b/tools/perf/builtin-top.c
@@ -996,7 +996,7 @@ static void event__process_mmap(event_t *self)
 	struct thread *thread = threads__findnew(self->mmap.pid);
 
 	if (thread != NULL) {
-		struct map *map = map__new(&self->mmap, NULL, 0);
+		struct map *map = map__new(&self->mmap, MAP__FUNCTION, NULL, 0);
 		if (map != NULL)
 			thread__insert_map(thread, map);
 	}
diff --git a/tools/perf/util/event.h b/tools/perf/util/event.h
index 882a953..29543bd 100644
--- a/tools/perf/util/event.h
+++ b/tools/perf/util/event.h
@@ -80,6 +80,10 @@ typedef union event_union {
 	struct sample_event		sample;
 } event_t;
 
+enum map_type {
+	MAP__FUNCTION,
+};
+
 struct map {
 	union {
 		struct rb_node	rb_node;
@@ -87,6 +91,7 @@ struct map {
 	};
 	u64			start;
 	u64			end;
+	enum map_type		type;
 	u64			pgoff;
 	u64			(*map_ip)(struct map *, u64);
 	u64			(*unmap_ip)(struct map *, u64);
@@ -112,9 +117,10 @@ struct symbol;
 
 typedef int (*symbol_filter_t)(struct map *map, struct symbol *sym);
 
-void map__init(struct map *self, u64 start, u64 end, u64 pgoff,
-	       struct dso *dso);
-struct map *map__new(struct mmap_event *event, char *cwd, int cwdlen);
+void map__init(struct map *self, enum map_type type,
+	       u64 start, u64 end, u64 pgoff, struct dso *dso);
+struct map *map__new(struct mmap_event *event, enum map_type,
+		     char *cwd, int cwdlen);
 void map__delete(struct map *self);
 struct map *map__clone(struct map *self);
 int map__overlap(struct map *l, struct map *r);
diff --git a/tools/perf/util/map.c b/tools/perf/util/map.c
index 41c5c4a..52bb4c6 100644
--- a/tools/perf/util/map.c
+++ b/tools/perf/util/map.c
@@ -20,9 +20,10 @@ static int strcommon(const char *pathname, char *cwd, int cwdlen)
 	return n;
 }
 
-void map__init(struct map *self, u64 start, u64 end, u64 pgoff,
-	       struct dso *dso)
+void map__init(struct map *self, enum map_type type,
+	       u64 start, u64 end, u64 pgoff, struct dso *dso)
 {
+	self->type     = type;
 	self->start    = start;
 	self->end      = end;
 	self->pgoff    = pgoff;
@@ -32,7 +33,8 @@ void map__init(struct map *self, u64 start, u64 end, u64 pgoff,
 	RB_CLEAR_NODE(&self->rb_node);
 }
 
-struct map *map__new(struct mmap_event *event, char *cwd, int cwdlen)
+struct map *map__new(struct mmap_event *event, enum map_type type,
+		     char *cwd, int cwdlen)
 {
 	struct map *self = malloc(sizeof(*self));
 
@@ -63,7 +65,7 @@ struct map *map__new(struct mmap_event *event, char *cwd, int cwdlen)
 		if (dso == NULL)
 			goto out_delete;
 
-		map__init(self, event->start, event->start + event->len,
+		map__init(self, type, event->start, event->start + event->len,
 			  event->pgoff, dso);
 
 		if (self->dso == vdso || anon)
@@ -103,7 +105,7 @@ void map__fixup_end(struct map *self, struct rb_root *symbols)
 struct symbol *map__find_function(struct map *self, u64 ip,
 				  symbol_filter_t filter)
 {
-	if (!self->dso->loaded) {
+	if (!dso__loaded(self->dso, self->type)) {
 		int nr = dso__load(self->dso, self, filter);
 
 		if (nr < 0) {
diff --git a/tools/perf/util/process_events.c b/tools/perf/util/process_events.c
index a920436..5377868 100644
--- a/tools/perf/util/process_events.c
+++ b/tools/perf/util/process_events.c
@@ -6,7 +6,7 @@ int	cwdlen;
 int
 process_mmap_event(event_t *event, unsigned long offset, unsigned long head)
 {
-	struct map *map = map__new(&event->mmap, cwd, cwdlen);
+	struct map *map = map__new(&event->mmap, MAP__FUNCTION, cwd, cwdlen);
 	struct thread *thread = threads__findnew(event->mmap.pid);
 
 	dump_printf("%p [%p]: PERF_RECORD_MMAP %d/%d: [%p(%p) @ %p]: %s\n",
diff --git a/tools/perf/util/symbol.c b/tools/perf/util/symbol.c
index 0b8a298..45a4a9a 100644
--- a/tools/perf/util/symbol.c
+++ b/tools/perf/util/symbol.c
@@ -29,7 +29,7 @@ enum dso_origin {
 };
 
 static void dsos__add(struct list_head *head, struct dso *dso);
-static struct map *map__new2(u64 start, struct dso *dso);
+static struct map *map__new2(u64 start, struct dso *dso, enum map_type type);
 static void kernel_maps__insert(struct map *map);
 static int dso__load_kernel_sym(struct dso *self, struct map *map,
 				symbol_filter_t filter);
@@ -45,6 +45,16 @@ static struct symbol_conf symbol_conf__defaults = {
 
 static struct rb_root kernel_maps__functions;
 
+bool dso__loaded(const struct dso *self, enum map_type type)
+{
+	return self->loaded & (1 << type);
+}
+
+static void dso__set_loaded(struct dso *self, enum map_type type)
+{
+	self->loaded |= (1 << type);
+}
+
 static void symbols__fixup_end(struct rb_root *self)
 {
 	struct rb_node *nd, *prevnd = rb_first(self);
@@ -387,7 +397,7 @@ static int kernel_maps__split_kallsyms(symbol_filter_t filter)
 			if (dso == NULL)
 				return -1;
 
-			map = map__new2(pos->start, dso);
+			map = map__new2(pos->start, dso, MAP__FUNCTION);
 			if (map == NULL) {
 				dso__delete(dso);
 				return -1;
@@ -846,7 +856,8 @@ static int dso__load_sym(struct dso *self, struct map *map, const char *name,
 				curr_dso = dso__new(dso_name);
 				if (curr_dso == NULL)
 					goto out_elf_end;
-				curr_map = map__new2(start, curr_dso);
+				curr_map = map__new2(start, curr_dso,
+						     MAP__FUNCTION);
 				if (curr_map == NULL) {
 					dso__delete(curr_dso);
 					goto out_elf_end;
@@ -1076,7 +1087,7 @@ int dso__load(struct dso *self, struct map *map, symbol_filter_t filter)
 	int ret = -1;
 	int fd;
 
-	self->loaded = 1;
+	dso__set_loaded(self, map->type);
 
 	if (self->kernel)
 		return dso__load_kernel_sym(self, map, filter);
@@ -1275,7 +1286,7 @@ static int dsos__set_modules_path(void)
  * they are loaded) and for vmlinux, where only after we load all the
  * symbols we'll know where it starts and ends.
  */
-static struct map *map__new2(u64 start, struct dso *dso)
+static struct map *map__new2(u64 start, struct dso *dso, enum map_type type)
 {
 	struct map *self = malloc(sizeof(*self));
 
@@ -1283,7 +1294,7 @@ static struct map *map__new2(u64 start, struct dso *dso)
 		/*
 		 * ->end will be filled after we load all the symbols
 		 */
-		map__init(self, start, 0, 0, dso);
+		map__init(self, type, start, 0, 0, dso);
 	}
 
 	return self;
@@ -1333,7 +1344,7 @@ static int kernel_maps__create_module_maps(void)
 		if (dso == NULL)
 			goto out_delete_line;
 
-		map = map__new2(start, dso);
+		map = map__new2(start, dso, MAP__FUNCTION);
 		if (map == NULL) {
 			dso__delete(dso);
 			goto out_delete_line;
@@ -1394,7 +1405,7 @@ static int dso__load_vmlinux(struct dso *self, struct map *map,
 	if (fd < 0)
 		return -1;
 
-	self->loaded = 1;
+	dso__set_loaded(self, map->type);
 	err = dso__load_sym(self, map, self->long_name, fd, filter, 1, 0);
 
 	close(fd);
@@ -1522,7 +1533,7 @@ static int kernel_maps__create_kernel_map(const struct symbol_conf *conf)
 	if (kernel == NULL)
 		return -1;
 
-	kernel_map__functions = map__new2(0, kernel);
+	kernel_map__functions = map__new2(0, kernel, MAP__FUNCTION);
 	if (kernel_map__functions == NULL)
 		goto out_delete_kernel_dso;
 
@@ -1533,7 +1544,7 @@ static int kernel_maps__create_kernel_map(const struct symbol_conf *conf)
 	vdso = dso__new("[vdso]");
 	if (vdso == NULL)
 		goto out_delete_kernel_map;
-	vdso->loaded = 1;
+	dso__set_loaded(vdso, MAP__FUNCTION);
 
 	if (sysfs__read_build_id("/sys/kernel/notes", kernel->build_id,
 				 sizeof(kernel->build_id)) == 0)
diff --git a/tools/perf/util/symbol.h b/tools/perf/util/symbol.h
index fb0be9e..11d4195 100644
--- a/tools/perf/util/symbol.h
+++ b/tools/perf/util/symbol.h
@@ -69,10 +69,10 @@ struct dso {
 	struct symbol    *(*find_function)(struct dso *, u64 ip);
 	u8		 adjust_symbols:1;
 	u8		 slen_calculated:1;
-	u8		 loaded:1;
 	u8		 has_build_id:1;
 	u8		 kernel:1;
 	unsigned char	 origin;
+	u8		 loaded;
 	u8		 build_id[BUILD_ID_SIZE];
 	u16		 long_name_len;
 	const char	 *short_name;
@@ -85,6 +85,8 @@ void dso__delete(struct dso *self);
 
 struct symbol *dso__find_function(struct dso *self, u64 ip);
 
+bool dso__loaded(const struct dso *self, enum map_type type);
+
 struct dso *dsos__findnew(const char *name);
 int dso__load(struct dso *self, struct map *map, symbol_filter_t filter);
 void dsos__fprintf(FILE *fp);
-- 
1.6.2.5

