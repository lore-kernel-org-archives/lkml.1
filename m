Return-Path: <linux-kernel-owner+w=401wt.eu-S1754260Ab0AGWAI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754260Ab0AGWAI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jan 2010 17:00:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754247Ab0AGWAC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jan 2010 17:00:02 -0500
Received: from casper.infradead.org ([85.118.1.10]:50260 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754240Ab0AGV77 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jan 2010 16:59:59 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
       =?utf-8?q?Fr=C3=A9d=C3=A9ric=20Weisbecker?= <fweisbec@gmail.com>,
       Mike Galbraith <efault@gmx.de>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>
Subject: [PATCH 6/6] perf tools: Encode kernel module mappings in perf.data
Date: Thu,  7 Jan 2010 19:59:43 -0200
Message-Id: <1262901583-8074-6-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1262901583-8074-1-git-send-email-acme@infradead.org>
References: <1262901583-8074-1-git-send-email-acme@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

We were always looking at the running machine /proc/modules, even when
processing a perf.data file, which only makes sense when we're doing
'perf record' and 'perf report' on the same machine, and in close
sucession, or if we don't use modules at all, right Peter? ;-)

Now, at 'perf record' time we read /proc/modules, find the long path for
modules, and put them as PERF_MMAP events, just like we did to encode
the reloc reference symbol for vmlinux. Talking about that now it is
encoded in .pgoff, so that we can use .{start,len} to store the address
boundaries for the kernel so that when we reconstruct the kmaps tree we
can do lookups right away, without having to fixup the end of the kernel
maps like we did in the past (and now only in perf record).

One more step in the 'perf archive' direction when we'll finally be able
to collect data in one machine and analyse in another.

Cc: Frédéric Weisbecker <fweisbec@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-kmem.c   |    5 ++
 tools/perf/builtin-record.c |   11 ++++
 tools/perf/builtin-top.c    |    5 ++
 tools/perf/util/event.c     |  104 ++++++++++++++++++++++++++++++++++-----
 tools/perf/util/event.h     |    2 +
 tools/perf/util/session.c   |    8 ++--
 tools/perf/util/session.h   |    4 ++
 tools/perf/util/symbol.c    |  116 +++++++++++++++++++++++++++++++------------
 tools/perf/util/symbol.h    |    3 +
 tools/perf/util/thread.h    |    4 ++
 10 files changed, 214 insertions(+), 48 deletions(-)

diff --git a/tools/perf/builtin-kmem.c b/tools/perf/builtin-kmem.c
index 2d2990d..3e3acc4 100644
--- a/tools/perf/builtin-kmem.c
+++ b/tools/perf/builtin-kmem.c
@@ -492,6 +492,11 @@ static int __cmd_kmem(void)
 	if (!perf_session__has_traces(session, "kmem record"))
 		goto out_delete;
 
+	if (perf_session__create_kernel_maps(session) < 0) {
+		pr_err("Problems creating kernel maps\n");
+		return -1;
+	}
+
 	setup_pager();
 	err = perf_session__process_events(session, &event_ops);
 	if (err != 0)
diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index 8f88420..c130df2 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -465,6 +465,11 @@ static int __cmd_record(int argc, const char **argv)
 		return -1;
 	}
 
+	if (perf_session__create_kernel_maps(session) < 0) {
+		pr_err("Problems creating kernel maps\n");
+		return -1;
+	}
+
 	if (!file_new) {
 		err = perf_header__read(&session->header, output);
 		if (err < 0)
@@ -558,6 +563,12 @@ static int __cmd_record(int argc, const char **argv)
 		return err;
 	}
 
+	err = event__synthesize_modules(process_synthesized_event, session);
+	if (err < 0) {
+		pr_err("Couldn't record kernel reference relocation symbol.\n");
+		return err;
+	}
+
 	if (!system_wide && profile_cpu == -1)
 		event__synthesize_thread(pid, process_synthesized_event,
 					 session);
diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
index 8f0c837..4786857 100644
--- a/tools/perf/builtin-top.c
+++ b/tools/perf/builtin-top.c
@@ -1161,6 +1161,11 @@ static int __cmd_top(void)
 	if (session == NULL)
 		return -ENOMEM;
 
+	if (perf_session__create_kernel_maps(session) < 0) {
+		pr_err("Problems creating kernel maps\n");
+		return -1;
+	}
+
 	if (target_pid != -1)
 		event__synthesize_thread(target_pid, event__process, session);
 	else
diff --git a/tools/perf/util/event.c b/tools/perf/util/event.c
index bfb3d87..73e8dd9 100644
--- a/tools/perf/util/event.c
+++ b/tools/perf/util/event.c
@@ -154,6 +154,34 @@ static int event__synthesize_mmap_events(pid_t pid, pid_t tgid,
 	return 0;
 }
 
+int event__synthesize_modules(event__handler_t process,
+			      struct perf_session *session)
+{
+	struct rb_node *nd;
+	struct map *pos;
+
+	perf_session__for_each_module_map(session, pos, nd) {
+		size_t size = ALIGN(pos->dso->long_name_len + 1, sizeof(u64));
+		event_t ev = {
+			.mmap = {
+				.header = {
+					.type = PERF_RECORD_MMAP,
+					.size = (sizeof(ev.mmap) -
+						 (sizeof(ev.mmap.filename) - size)),
+				},
+				.start = pos->start,
+				.len   = pos->end - pos->start,
+			},
+		};
+
+		memcpy(ev.mmap.filename, pos->dso->long_name,
+		       pos->dso->long_name_len + 1);
+		process(&ev, session);
+	}
+
+	return 0;
+}
+
 int event__synthesize_thread(pid_t pid, event__handler_t process,
 			     struct perf_session *session)
 {
@@ -222,7 +250,9 @@ int event__synthesize_kernel_mmap(event__handler_t process,
 			"[kernel.kallsyms.%s]", symbol_name) + 1;
 	size = ALIGN(size, sizeof(u64));
 	ev.mmap.header.size = (sizeof(ev.mmap) - (sizeof(ev.mmap.filename) - size));
-	ev.mmap.start = args.start;
+	ev.mmap.pgoff = args.start;
+	ev.mmap.start = session->vmlinux_maps[MAP__FUNCTION]->start;
+	ev.mmap.len   = session->vmlinux_maps[MAP__FUNCTION]->end - ev.mmap.start ;
 
 	return process(&ev, session);
 }
@@ -280,7 +310,6 @@ int event__process_mmap(event_t *self, struct perf_session *session)
 {
 	struct thread *thread;
 	struct map *map;
-	static const char kmmap_prefix[] = "[kernel.kallsyms.";
 
 	dump_printf(" %d/%d: [%p(%p) @ %p]: %s\n",
 		    self->mmap.pid, self->mmap.tid,
@@ -289,13 +318,61 @@ int event__process_mmap(event_t *self, struct perf_session *session)
 		    (void *)(long)self->mmap.pgoff,
 		    self->mmap.filename);
 
-	if (self->mmap.pid == 0 &&
-	    memcmp(self->mmap.filename, kmmap_prefix,
-		   sizeof(kmmap_prefix) - 1) == 0) {
-		const char *symbol_name = (self->mmap.filename +
-					   sizeof(kmmap_prefix) - 1);
-		perf_session__set_kallsyms_ref_reloc_sym(session, symbol_name,
-							 self->mmap.start);
+	if (self->mmap.pid == 0) {
+		static const char kmmap_prefix[] = "[kernel.kallsyms.";
+
+		if (self->mmap.filename[0] == '/') {
+			char short_module_name[1024];
+			char *name = strrchr(self->mmap.filename, '/'), *dot;
+
+			if (name == NULL)
+				goto out_problem;
+
+			++name; /* skip / */
+			dot = strrchr(name, '.');
+			if (dot == NULL)
+				goto out_problem;
+
+			snprintf(short_module_name, sizeof(short_module_name),
+				 "[%.*s]", (int)(dot - name), name);
+			strxfrchar(short_module_name, '-', '_');
+
+			map = perf_session__new_module_map(session,
+							   self->mmap.start,
+							   short_module_name);
+			if (map == NULL)
+				goto out_problem;
+
+			name = strdup(self->mmap.filename);
+			if (name == NULL)
+				goto out_problem;
+
+			dso__set_long_name(map->dso, name);
+			map->end = map->start + self->mmap.len;
+		} else if (memcmp(self->mmap.filename, kmmap_prefix,
+				sizeof(kmmap_prefix) - 1) == 0) {
+			const char *symbol_name = (self->mmap.filename +
+						   sizeof(kmmap_prefix) - 1);
+			/*
+			 * Should be there already, from the build-id table in
+			 * the header.
+			 */
+			struct dso *kernel = __dsos__findnew(&dsos__kernel,
+							     "[kernel.kallsyms]");
+			if (kernel == NULL)
+				goto out_problem;
+
+			if (__map_groups__create_kernel_maps(&session->kmaps,
+							     session->vmlinux_maps,
+							     kernel) < 0)
+				goto out_problem;
+
+			session->vmlinux_maps[MAP__FUNCTION]->start = self->mmap.start;
+			session->vmlinux_maps[MAP__FUNCTION]->end   = self->mmap.start + self->mmap.len;
+
+			perf_session__set_kallsyms_ref_reloc_sym(session, symbol_name,
+								 self->mmap.pgoff);
+		}
 		return 0;
 	}
 
@@ -304,10 +381,13 @@ int event__process_mmap(event_t *self, struct perf_session *session)
 		       session->cwd, session->cwdlen);
 
 	if (thread == NULL || map == NULL)
-		dump_printf("problem processing PERF_RECORD_MMAP, skipping event.\n");
-	else
-		thread__insert_map(thread, map);
+		goto out_problem;
+
+	thread__insert_map(thread, map);
+	return 0;
 
+out_problem:
+	dump_printf("problem processing PERF_RECORD_MMAP, skipping event.\n");
 	return 0;
 }
 
diff --git a/tools/perf/util/event.h b/tools/perf/util/event.h
index 80356da..50a7132 100644
--- a/tools/perf/util/event.h
+++ b/tools/perf/util/event.h
@@ -112,6 +112,8 @@ void event__synthesize_threads(event__handler_t process,
 int event__synthesize_kernel_mmap(event__handler_t process,
 				  struct perf_session *session,
 				  const char *symbol_name);
+int event__synthesize_modules(event__handler_t process,
+			      struct perf_session *session);
 
 int event__process_comm(event_t *self, struct perf_session *session);
 int event__process_lost(event_t *self, struct perf_session *session);
diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
index 378ac54..fd1c5a3 100644
--- a/tools/perf/util/session.c
+++ b/tools/perf/util/session.c
@@ -69,9 +69,6 @@ struct perf_session *perf_session__new(const char *filename, int mode, bool forc
 	self->unknown_events = 0;
 	map_groups__init(&self->kmaps);
 
-	if (perf_session__create_kernel_maps(self) < 0)
-		goto out_delete;
-
 	if (mode == O_RDONLY && perf_session__open(self, force) < 0)
 		goto out_delete;
 
@@ -268,8 +265,11 @@ int perf_header__read_build_ids(int input, u64 offset, u64 size)
 			head = &dsos__kernel;
 
 		dso = __dsos__findnew(head, filename);
-		if (dso != NULL)
+		if (dso != NULL) {
 			dso__set_build_id(dso, &bev.build_id);
+			if (head == &dsos__kernel && filename[0] == '[')
+				dso->kernel = 1;
+		}
 
 		offset += bev.header.size;
 	}
diff --git a/tools/perf/util/session.h b/tools/perf/util/session.h
index d4a9d20..4446d60 100644
--- a/tools/perf/util/session.h
+++ b/tools/perf/util/session.h
@@ -69,4 +69,8 @@ int perf_session__set_kallsyms_ref_reloc_sym(struct perf_session *self,
 void perf_session__reloc_vmlinux_maps(struct perf_session *self,
 				      u64 unrelocated_addr);
 
+#define perf_session__for_each_module_map(self, pos, nd)		      \
+	rb_for_each_entry(pos, nd, &self->kmaps.maps[MAP__FUNCTION], rb_node) \
+		if (pos->dso->kernel) continue; else
+
 #endif /* __PERF_SESSION_H */
diff --git a/tools/perf/util/symbol.c b/tools/perf/util/symbol.c
index 85b96ea..9df9833 100644
--- a/tools/perf/util/symbol.c
+++ b/tools/perf/util/symbol.c
@@ -161,7 +161,7 @@ static size_t symbol__fprintf(struct symbol *self, FILE *fp)
 		       self->start, self->end, self->name);
 }
 
-static void dso__set_long_name(struct dso *self, char *name)
+void dso__set_long_name(struct dso *self, char *name)
 {
 	if (name == NULL)
 		return;
@@ -176,7 +176,7 @@ static void dso__set_basename(struct dso *self)
 
 struct dso *dso__new(const char *name)
 {
-	struct dso *self = malloc(sizeof(*self) + strlen(name) + 1);
+	struct dso *self = zalloc(sizeof(*self) + strlen(name) + 1);
 
 	if (self != NULL) {
 		int i;
@@ -498,13 +498,17 @@ static int dso__split_kallsyms(struct dso *self, struct map *map,
 
 			*module++ = '\0';
 
-			if (strcmp(self->name, module)) {
+			if (strcmp(curr_map->dso->short_name, module)) {
 				curr_map = map_groups__find_by_name(&session->kmaps, map->type, module);
 				if (curr_map == NULL) {
 					pr_debug("/proc/{kallsyms,modules} "
-					         "inconsistency!\n");
+					         "inconsistency while looking "
+						 "for \"%s\" module!\n", module);
 					return -1;
 				}
+
+				if (curr_map->dso->loaded)
+					goto discard_symbol;
 			}
 			/*
 			 * So that we look just like we get from .ko files,
@@ -1340,12 +1344,32 @@ struct map *map_groups__find_by_name(struct map_groups *self,
 	struct map *map;
 
 	rb_for_each_entry(map, nd, &self->maps[type], rb_node)
-		if (map->dso && strcmp(map->dso->name, name) == 0)
+		if (map->dso && strcmp(map->dso->short_name, name) == 0)
 			return map;
 
 	return NULL;
 }
 
+static int dso__kernel_module_get_build_id(struct dso *self)
+{
+	char filename[PATH_MAX];
+	/*
+	 * kernel module short names are of the form "[module]" and
+	 * we need just "module" here.
+	 */
+	const char *name = self->short_name + 1;
+
+	snprintf(filename, sizeof(filename),
+		 "/sys/module/%.*s/notes/.note.gnu.build-id",
+		 (int)strlen(name - 1), name);
+
+	if (sysfs__read_build_id(filename, self->build_id,
+				 sizeof(self->build_id)) == 0)
+		self->has_build_id = true;
+
+	return 0;
+}
+
 static int perf_session__set_modules_path_dir(struct perf_session *self, char *dirname)
 {
 	struct dirent *dent;
@@ -1391,6 +1415,7 @@ static int perf_session__set_modules_path_dir(struct perf_session *self, char *d
 			if (long_name == NULL)
 				goto failure;
 			dso__set_long_name(map->dso, long_name);
+			dso__kernel_module_get_build_id(map->dso);
 		}
 	}
 
@@ -1433,6 +1458,24 @@ static struct map *map__new2(u64 start, struct dso *dso, enum map_type type)
 	return self;
 }
 
+struct map *perf_session__new_module_map(struct perf_session *self, u64 start,
+					 const char *filename)
+{
+	struct map *map;
+	struct dso *dso = __dsos__findnew(&dsos__kernel, filename);
+
+	if (dso == NULL)
+		return NULL;
+
+	map = map__new2(start, dso, MAP__FUNCTION);
+	if (map == NULL)
+		return NULL;
+
+	dso->origin = DSO__ORIG_KMODULE;
+	map_groups__insert(&self->kmaps, map);
+	return map;
+}
+
 static int perf_session__create_module_maps(struct perf_session *self)
 {
 	char *line = NULL;
@@ -1446,7 +1489,6 @@ static int perf_session__create_module_maps(struct perf_session *self)
 	while (!feof(file)) {
 		char name[PATH_MAX];
 		u64 start;
-		struct dso *dso;
 		char *sep;
 		int line_len;
 
@@ -1472,26 +1514,10 @@ static int perf_session__create_module_maps(struct perf_session *self)
 		*sep = '\0';
 
 		snprintf(name, sizeof(name), "[%s]", line);
-		dso = dso__new(name);
-
-		if (dso == NULL)
-			goto out_delete_line;
-
-		map = map__new2(start, dso, MAP__FUNCTION);
-		if (map == NULL) {
-			dso__delete(dso);
+		map = perf_session__new_module_map(self, start, name);
+		if (map == NULL)
 			goto out_delete_line;
-		}
-
-		snprintf(name, sizeof(name),
-			 "/sys/module/%s/notes/.note.gnu.build-id", line);
-		if (sysfs__read_build_id(name, dso->build_id,
-					 sizeof(dso->build_id)) == 0)
-			dso->has_build_id = true;
-
-		dso->origin = DSO__ORIG_KMODULE;
-		map_groups__insert(&self->kmaps, map);
-		dsos__add(&dsos__kernel, dso);
+		dso__kernel_module_get_build_id(map->dso);
 	}
 
 	free(line);
@@ -1569,10 +1595,28 @@ static int dso__load_kernel_sym(struct dso *self, struct map *map,
 		}
 	}
 
+	/*
+	 * Say the kernel DSO was created when processing the build-id header table,
+	 * we have a build-id, so check if it is the same as the running kernel,
+	 * using it if it is.
+	 */
+	if (self->has_build_id) {
+		u8 kallsyms_build_id[BUILD_ID_SIZE];
+
+		if (sysfs__read_build_id("/sys/kernel/notes", kallsyms_build_id,
+					 sizeof(kallsyms_build_id)) == 0)
+
+		is_kallsyms = dso__build_id_equal(self, kallsyms_build_id);
+		if (is_kallsyms)
+			goto do_kallsyms;
+		goto do_vmlinux;
+	}
+
 	is_kallsyms = self->long_name[0] == '[';
 	if (is_kallsyms)
 		goto do_kallsyms;
 
+do_vmlinux:
 	err = dso__load_vmlinux(self, map, session, self->long_name, filter);
 	if (err <= 0) {
 		pr_info("The file %s cannot be used, "
@@ -1690,16 +1734,12 @@ out_delete_kernel_dso:
 	return NULL;
 }
 
-static int map_groups__create_kernel_maps(struct map_groups *self,
-					  struct map *vmlinux_maps[MAP__NR_TYPES],
-					  const char *vmlinux)
+int __map_groups__create_kernel_maps(struct map_groups *self,
+				     struct map *vmlinux_maps[MAP__NR_TYPES],
+				     struct dso *kernel)
 {
-	struct dso *kernel = dsos__create_kernel(vmlinux);
 	enum map_type type;
 
-	if (kernel == NULL)
-		return -1;
-
 	for (type = 0; type < MAP__NR_TYPES; ++type) {
 		vmlinux_maps[type] = map__new2(0, kernel, type);
 		if (vmlinux_maps[type] == NULL)
@@ -1713,6 +1753,18 @@ static int map_groups__create_kernel_maps(struct map_groups *self,
 	return 0;
 }
 
+static int map_groups__create_kernel_maps(struct map_groups *self,
+					  struct map *vmlinux_maps[MAP__NR_TYPES],
+					  const char *vmlinux)
+{
+	struct dso *kernel = dsos__create_kernel(vmlinux);
+
+	if (kernel == NULL)
+		return -1;
+
+	return __map_groups__create_kernel_maps(self, vmlinux_maps, kernel);
+}
+
 static void vmlinux_path__exit(void)
 {
 	while (--vmlinux_path__nr_entries >= 0) {
diff --git a/tools/perf/util/symbol.h b/tools/perf/util/symbol.h
index ee0b459..594156e 100644
--- a/tools/perf/util/symbol.h
+++ b/tools/perf/util/symbol.h
@@ -134,6 +134,7 @@ size_t dsos__fprintf_buildid(FILE *fp);
 size_t dso__fprintf_buildid(struct dso *self, FILE *fp);
 size_t dso__fprintf(struct dso *self, enum map_type type, FILE *fp);
 char dso__symtab_origin(const struct dso *self);
+void dso__set_long_name(struct dso *self, char *name);
 void dso__set_build_id(struct dso *self, void *build_id);
 struct symbol *dso__find_symbol(struct dso *self, enum map_type type, u64 addr);
 struct symbol *dso__find_symbol_by_name(struct dso *self, enum map_type type,
@@ -151,5 +152,7 @@ bool symbol_type__is_a(char symbol_type, enum map_type map_type);
 
 int perf_session__create_kernel_maps(struct perf_session *self);
 
+struct map *perf_session__new_module_map(struct perf_session *self, u64 start,
+					 const char *filename);
 extern struct dso *vdso;
 #endif /* __PERF_SYMBOL */
diff --git a/tools/perf/util/thread.h b/tools/perf/util/thread.h
index c206f72..c06c135 100644
--- a/tools/perf/util/thread.h
+++ b/tools/perf/util/thread.h
@@ -67,4 +67,8 @@ map_groups__find_function(struct map_groups *self, struct perf_session *session,
 
 struct map *map_groups__find_by_name(struct map_groups *self,
 				     enum map_type type, const char *name);
+
+int __map_groups__create_kernel_maps(struct map_groups *self,
+				     struct map *vmlinux_maps[MAP__NR_TYPES],
+				     struct dso *kernel);
 #endif	/* __PERF_THREAD_H */
-- 
1.6.2.5

