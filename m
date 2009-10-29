Return-Path: <linux-kernel-owner+w=401wt.eu-S1752546AbZJ2IHi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752546AbZJ2IHi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Oct 2009 04:07:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752330AbZJ2IHh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Oct 2009 04:07:37 -0400
Received: from hera.kernel.org ([140.211.167.34]:52931 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752327AbZJ2IHd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Oct 2009 04:07:33 -0400
Date: Thu, 29 Oct 2009 08:06:40 GMT
From: tip-bot for Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, acme@redhat.com,
       hpa@zytor.com, mingo@redhat.com, efault@gmx.de, peterz@infradead.org,
       fweisbec@gmail.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
       linux-kernel@vger.kernel.org, fweisbec@gmail.com, peterz@infradead.org,
       efault@gmx.de, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1256773881-4191-1-git-send-email-acme@infradead.org>
References: <1256773881-4191-1-git-send-email-acme@infradead.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools: Delay loading symtabs till we hit a map with it
Message-ID: <tip-66bd8424cc05e800db384053bf7ab967e4658468@git.kernel.org>
Git-Commit-ID: 66bd8424cc05e800db384053bf7ab967e4658468
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  66bd8424cc05e800db384053bf7ab967e4658468
Gitweb:     http://git.kernel.org/tip/66bd8424cc05e800db384053bf7ab967e4658468
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Wed, 28 Oct 2009 21:51:21 -0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 29 Oct 2009 08:23:40 +0100

perf tools: Delay loading symtabs till we hit a map with it

So that we can have a quicker start on perf top and even
speedups in the other tools, as we can have maps with no hits,
so no need to load its symtabs.

Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Mike Galbraith <efault@gmx.de>
LKML-Reference: <1256773881-4191-1-git-send-email-acme@infradead.org>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 tools/perf/builtin-annotate.c |    4 ++--
 tools/perf/builtin-report.c   |    4 ++--
 tools/perf/builtin-top.c      |    5 ++---
 tools/perf/util/event.h       |    3 ++-
 tools/perf/util/map.c         |   38 ++++++++++++++++++++++----------------
 tools/perf/util/symbol.c      |   16 +++++++++-------
 tools/perf/util/symbol.h      |    4 ++--
 7 files changed, 41 insertions(+), 33 deletions(-)

diff --git a/tools/perf/builtin-annotate.c b/tools/perf/builtin-annotate.c
index 6d63c2e..8688bfe 100644
--- a/tools/perf/builtin-annotate.c
+++ b/tools/perf/builtin-annotate.c
@@ -165,7 +165,7 @@ process_sample_event(event_t *event, unsigned long offset, unsigned long head)
 		if (map != NULL) {
 got_map:
 			ip = map->map_ip(map, ip);
-			sym = map->dso->find_symbol(map->dso, ip);
+			sym = map__find_symbol(map, ip, symbol_filter);
 		} else {
 			/*
 			 * If this is outside of all known maps,
@@ -203,7 +203,7 @@ static int
 process_mmap_event(event_t *event, unsigned long offset, unsigned long head)
 {
 	struct map *map = map__new(&event->mmap, NULL, 0,
-				   sizeof(struct sym_priv), symbol_filter);
+				   sizeof(struct sym_priv));
 	struct thread *thread = threads__findnew(event->mmap.pid);
 
 	dump_printf("%p [%p]: PERF_RECORD_MMAP %d: [%p(%p) @ %p]: %s\n",
diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index b3d814b..f1bcd35 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -455,7 +455,7 @@ got_map:
 	dump_printf(" ...... map: %Lx -> %Lx\n", *ipp, ip);
 	*ipp  = ip;
 
-	return map ? map->dso->find_symbol(map->dso, ip) : NULL;
+	return map ? map__find_symbol(map, ip, NULL) : NULL;
 }
 
 static int call__match(struct symbol *sym)
@@ -751,7 +751,7 @@ process_sample_event(event_t *event, unsigned long offset, unsigned long head)
 static int
 process_mmap_event(event_t *event, unsigned long offset, unsigned long head)
 {
-	struct map *map = map__new(&event->mmap, cwd, cwdlen, 0, NULL);
+	struct map *map = map__new(&event->mmap, cwd, cwdlen, 0);
 	struct thread *thread = threads__findnew(event->mmap.pid);
 
 	dump_printf("%p [%p]: PERF_RECORD_MMAP %d/%d: [%p(%p) @ %p]: %s\n",
diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
index a02fc41..ee87640 100644
--- a/tools/perf/builtin-top.c
+++ b/tools/perf/builtin-top.c
@@ -834,7 +834,7 @@ static void event__process_sample(const event_t *self, int counter)
 		map = thread__find_map(thread, ip);
 		if (map != NULL) {
 			ip = map->map_ip(map, ip);
-			sym = map->dso->find_symbol(map->dso, ip);
+			sym = map__find_symbol(map, ip, symbol_filter);
 			if (sym == NULL)
 				return;
 			userspace_samples++;
@@ -879,8 +879,7 @@ static void event__process_mmap(event_t *self)
 
 	if (thread != NULL) {
 		struct map *map = map__new(&self->mmap, NULL, 0,
-					   sizeof(struct sym_entry),
-					   symbol_filter);
+					   sizeof(struct sym_entry));
 		if (map != NULL)
 			thread__insert_map(thread, map);
 	}
diff --git a/tools/perf/util/event.h b/tools/perf/util/event.h
index 2ae1177..3064a05 100644
--- a/tools/perf/util/event.h
+++ b/tools/perf/util/event.h
@@ -106,10 +106,11 @@ struct symbol;
 typedef int (*symbol_filter_t)(struct map *map, struct symbol *sym);
 
 struct map *map__new(struct mmap_event *event, char *cwd, int cwdlen,
-		     unsigned int sym_priv_size, symbol_filter_t filter);
+		     unsigned int sym_priv_size);
 struct map *map__clone(struct map *self);
 int map__overlap(struct map *l, struct map *r);
 size_t map__fprintf(struct map *self, FILE *fp);
+struct symbol *map__find_symbol(struct map *self, u64 ip, symbol_filter_t filter);
 
 int event__synthesize_thread(pid_t pid, int (*process)(event_t *event));
 void event__synthesize_threads(int (*process)(event_t *event));
diff --git a/tools/perf/util/map.c b/tools/perf/util/map.c
index c1c5568..d302e51 100644
--- a/tools/perf/util/map.c
+++ b/tools/perf/util/map.c
@@ -21,7 +21,7 @@ static int strcommon(const char *pathname, char *cwd, int cwdlen)
 }
 
 struct map *map__new(struct mmap_event *event, char *cwd, int cwdlen,
-		     unsigned int sym_priv_size, symbol_filter_t filter)
+		     unsigned int sym_priv_size)
 {
 	struct map *self = malloc(sizeof(*self));
 
@@ -29,7 +29,6 @@ struct map *map__new(struct mmap_event *event, char *cwd, int cwdlen,
 		const char *filename = event->filename;
 		char newfilename[PATH_MAX];
 		int anon;
-		bool new_dso;
 
 		if (cwd) {
 			int n = strcommon(filename, cwd, cwdlen);
@@ -52,23 +51,10 @@ struct map *map__new(struct mmap_event *event, char *cwd, int cwdlen,
 		self->end   = event->start + event->len;
 		self->pgoff = event->pgoff;
 
-		self->dso = dsos__findnew(filename, sym_priv_size, &new_dso);
+		self->dso = dsos__findnew(filename, sym_priv_size);
 		if (self->dso == NULL)
 			goto out_delete;
 
-		if (new_dso) {
-			int nr = dso__load(self->dso, self, filter);
-
-			if (nr < 0)
-				pr_warning("Failed to open %s, continuing "
-					   "without symbols\n",
-					   self->dso->long_name);
-			else if (nr == 0)
-				pr_warning("No symbols found in %s, maybe "
-					   "install a debug package?\n",
-					   self->dso->long_name);
-		}
-
 		if (self->dso == vdso || anon)
 			self->map_ip = self->unmap_ip = identity__map_ip;
 		else {
@@ -82,6 +68,26 @@ out_delete:
 	return NULL;
 }
 
+struct symbol *
+map__find_symbol(struct map *self, u64 ip, symbol_filter_t filter)
+{
+	if (!self->dso->loaded) {
+		int nr = dso__load(self->dso, self, filter);
+
+		if (nr < 0) {
+			pr_warning("Failed to open %s, continuing without symbols\n",
+				   self->dso->long_name);
+			return NULL;
+		} else if (nr == 0) {
+			pr_warning("No symbols found in %s, maybe install a debug package?\n",
+				   self->dso->long_name);
+			return NULL;
+		}
+	}
+
+	return self->dso->find_symbol(self->dso, ip);
+}
+
 struct map *map__clone(struct map *self)
 {
 	struct map *map = malloc(sizeof(*self));
diff --git a/tools/perf/util/symbol.c b/tools/perf/util/symbol.c
index 8f0208c..0273d83 100644
--- a/tools/perf/util/symbol.c
+++ b/tools/perf/util/symbol.c
@@ -909,6 +909,8 @@ int dso__load(struct dso *self, struct map *map, symbol_filter_t filter)
 	int ret = -1;
 	int fd;
 
+	self->loaded = true;
+
 	if (!name)
 		return -1;
 
@@ -1019,6 +1021,8 @@ static int dso__load_module_sym(struct dso *self, struct map *map,
 {
 	int err = 0, fd = open(self->long_name, O_RDONLY);
 
+	self->loaded = true;
+
 	if (fd < 0) {
 		pr_err("%s: cannot open %s\n", __func__, self->long_name);
 		return err;
@@ -1214,6 +1218,8 @@ static int dso__load_vmlinux(struct dso *self, struct map *map,
 {
 	int err, fd = open(vmlinux, O_RDONLY);
 
+	self->loaded = true;
+
 	if (fd < 0)
 		return -1;
 
@@ -1312,19 +1318,15 @@ static struct dso *dsos__find(const char *name)
 	return NULL;
 }
 
-struct dso *dsos__findnew(const char *name, unsigned int sym_priv_size,
-			  bool *is_new)
+struct dso *dsos__findnew(const char *name, unsigned int sym_priv_size)
 {
 	struct dso *dso = dsos__find(name);
 
 	if (!dso) {
 		dso = dso__new(name, sym_priv_size);
-		if (dso) {
+		if (dso != NULL)
 			dsos__add(dso);
-			*is_new = true;
-		}
-	} else
-		*is_new = false;
+	}
 
 	return dso;
 }
diff --git a/tools/perf/util/symbol.h b/tools/perf/util/symbol.h
index 77b7b3e..432edbc 100644
--- a/tools/perf/util/symbol.h
+++ b/tools/perf/util/symbol.h
@@ -46,6 +46,7 @@ struct dso {
 	unsigned int	 sym_priv_size;
 	unsigned char	 adjust_symbols;
 	unsigned char	 slen_calculated;
+	bool		 loaded;
 	unsigned char	 origin;
 	const char	 *short_name;
 	char	 	 *long_name;
@@ -64,8 +65,7 @@ struct symbol *dso__find_symbol(struct dso *self, u64 ip);
 
 int dsos__load_kernel(const char *vmlinux, unsigned int sym_priv_size,
 		      symbol_filter_t filter, int modules);
-struct dso *dsos__findnew(const char *name, unsigned int sym_priv_size,
-			  bool *is_new);
+struct dso *dsos__findnew(const char *name, unsigned int sym_priv_size);
 int dso__load(struct dso *self, struct map *map, symbol_filter_t filter);
 void dsos__fprintf(FILE *fp);
 
