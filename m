Return-Path: <linux-kernel-owner+w=401wt.eu-S1754476AbZLMVuy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754476AbZLMVuy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Dec 2009 16:50:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754408AbZLMVuu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Dec 2009 16:50:50 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:47501 "HELO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754412AbZLMVuq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Dec 2009 16:50:46 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
       =?utf-8?q?Fr=C3=A9d=C3=A9ric=20Weisbecker?= <fweisbec@gmail.com>,
       Mike Galbraith <efault@gmx.de>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>
Subject: [PATCH 6/6] perf session: Move kmaps to perf_session
Date: Sun, 13 Dec 2009 19:50:29 -0200
Message-Id: <1260741029-4430-6-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1260741029-4430-1-git-send-email-acme@infradead.org>
References: <1260741029-4430-1-git-send-email-acme@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

There is still some more work to do to disentangle map creation from DSO
loading, but this happens only for the kernel, and for the early
adopters of perf diff, where this disentanglement matters most, we'll be
testing different kernels, so no problem here.

Further clarification: right now we create the kernel maps for the
various modules and discontiguous kernel text maps when loading the DSO,
we should do it as a two step process, first creating the maps, for
multiple mappings with the same DSO store, then doing the dso load just
once, for the first hit on one of the maps sharing this DSO backing
store.

Cc: Frédéric Weisbecker <fweisbec@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-annotate.c     |    2 +-
 tools/perf/builtin-buildid-list.c |    4 +-
 tools/perf/builtin-kmem.c         |   41 ++++++++---------
 tools/perf/builtin-record.c       |    2 +-
 tools/perf/builtin-report.c       |   14 +++---
 tools/perf/builtin-sched.c        |    4 +-
 tools/perf/builtin-timechart.c    |    3 +-
 tools/perf/builtin-top.c          |    4 +-
 tools/perf/builtin-trace.c        |    2 +-
 tools/perf/util/event.c           |   13 +++---
 tools/perf/util/event.h           |   10 +++--
 tools/perf/util/map.c             |   14 +++---
 tools/perf/util/session.c         |   19 +++++---
 tools/perf/util/session.h         |    6 ++-
 tools/perf/util/symbol.c          |   89 ++++++++++++++++++-------------------
 tools/perf/util/symbol.h          |   11 +++--
 tools/perf/util/thread.c          |    3 +-
 tools/perf/util/thread.h          |   11 +++--
 18 files changed, 134 insertions(+), 118 deletions(-)

diff --git a/tools/perf/builtin-annotate.c b/tools/perf/builtin-annotate.c
index 795f865..e44c54c 100644
--- a/tools/perf/builtin-annotate.c
+++ b/tools/perf/builtin-annotate.c
@@ -463,7 +463,7 @@ static struct perf_event_ops event_ops = {
 static int __cmd_annotate(void)
 {
 	struct perf_session *session = perf_session__new(input_name, O_RDONLY,
-							 force);
+							 force, &symbol_conf);
 	int ret;
 
 	if (session == NULL)
diff --git a/tools/perf/builtin-buildid-list.c b/tools/perf/builtin-buildid-list.c
index 2629f76..7c36e4b 100644
--- a/tools/perf/builtin-buildid-list.c
+++ b/tools/perf/builtin-buildid-list.c
@@ -54,8 +54,8 @@ static int perf_file_section__process_buildids(struct perf_file_section *self,
 static int __cmd_buildid_list(void)
 {
 	int err = -1;
-	struct perf_session *session = perf_session__new(input_name, O_RDONLY, force);
-
+	struct perf_session *session = perf_session__new(input_name, O_RDONLY,
+							 force, NULL);
 	if (session == NULL)
 		return -1;
 
diff --git a/tools/perf/builtin-kmem.c b/tools/perf/builtin-kmem.c
index de19495..e79ecbc 100644
--- a/tools/perf/builtin-kmem.c
+++ b/tools/perf/builtin-kmem.c
@@ -364,19 +364,6 @@ static struct perf_event_ops event_ops = {
 	.sample_type_check	= sample_type_check,
 };
 
-static int read_events(void)
-{
-	int err;
-	struct perf_session *session = perf_session__new(input_name, O_RDONLY, 0);
-
-	if (session == NULL)
-		return -ENOMEM;
-
-	err = perf_session__process_events(session, &event_ops);
-	perf_session__delete(session);
-	return err;
-}
-
 static double fragmentation(unsigned long n_req, unsigned long n_alloc)
 {
 	if (n_alloc == 0)
@@ -385,7 +372,8 @@ static double fragmentation(unsigned long n_req, unsigned long n_alloc)
 		return 100.0 - (100.0 * n_req / n_alloc);
 }
 
-static void __print_result(struct rb_root *root, int n_lines, int is_caller)
+static void __print_result(struct rb_root *root, struct perf_session *session,
+			   int n_lines, int is_caller)
 {
 	struct rb_node *next;
 
@@ -406,7 +394,7 @@ static void __print_result(struct rb_root *root, int n_lines, int is_caller)
 		if (is_caller) {
 			addr = data->call_site;
 			if (!raw_ip)
-				sym = map_groups__find_function(kmaps, addr, NULL);
+				sym = map_groups__find_function(&session->kmaps, session, addr, NULL);
 		} else
 			addr = data->ptr;
 
@@ -447,12 +435,12 @@ static void print_summary(void)
 	printf("Cross CPU allocations: %lu/%lu\n", nr_cross_allocs, nr_allocs);
 }
 
-static void print_result(void)
+static void print_result(struct perf_session *session)
 {
 	if (caller_flag)
-		__print_result(&root_caller_sorted, caller_lines, 1);
+		__print_result(&root_caller_sorted, session, caller_lines, 1);
 	if (alloc_flag)
-		__print_result(&root_alloc_sorted, alloc_lines, 0);
+		__print_result(&root_alloc_sorted, session, alloc_lines, 0);
 	print_summary();
 }
 
@@ -520,12 +508,21 @@ static void sort_result(void)
 
 static int __cmd_kmem(void)
 {
+	int err;
+	struct perf_session *session = perf_session__new(input_name, O_RDONLY,
+							 0, NULL);
+	if (session == NULL)
+		return -ENOMEM;
+
 	setup_pager();
-	read_events();
+	err = perf_session__process_events(session, &event_ops);
+	if (err != 0)
+		goto out_delete;
 	sort_result();
-	print_result();
-
-	return 0;
+	print_result(session);
+out_delete:
+	perf_session__delete(session);
+	return err;
 }
 
 static const char * const kmem_usage[] = {
diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index b7e15a1..a66a58d 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -442,7 +442,7 @@ static int __cmd_record(int argc, const char **argv)
 		exit(-1);
 	}
 
-	session = perf_session__new(output_name, O_WRONLY, force);
+	session = perf_session__new(output_name, O_WRONLY, force, NULL);
 	if (session == NULL) {
 		pr_err("Not enough memory for reading perf file header\n");
 		return -1;
diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index efa8147..3487224 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -414,6 +414,7 @@ static int call__match(struct symbol *sym)
 }
 
 static struct symbol **resolve_callchain(struct thread *thread,
+					 struct perf_session *session,
 					 struct ip_callchain *chain,
 					 struct symbol **parent)
 {
@@ -447,8 +448,8 @@ static struct symbol **resolve_callchain(struct thread *thread,
 			continue;
 		}
 
-		thread__find_addr_location(thread, cpumode, MAP__FUNCTION,
-					   ip, &al, NULL);
+		thread__find_addr_location(thread, session, cpumode,
+					   MAP__FUNCTION, ip, &al, NULL);
 		if (al.sym != NULL) {
 			if (sort__has_parent && !*parent &&
 			    call__match(al.sym))
@@ -467,6 +468,7 @@ static struct symbol **resolve_callchain(struct thread *thread,
  */
 
 static int hist_entry__add(struct addr_location *al,
+			   struct perf_session *session,
 			   struct ip_callchain *chain, u64 count)
 {
 	struct symbol **syms = NULL, *parent = NULL;
@@ -474,7 +476,7 @@ static int hist_entry__add(struct addr_location *al,
 	struct hist_entry *he;
 
 	if ((sort__has_parent || callchain) && chain)
-		syms = resolve_callchain(al->thread, chain, &parent);
+		syms = resolve_callchain(al->thread, session, chain, &parent);
 
 	he = __hist_entry__add(al, parent, count, &hit);
 	if (he == NULL)
@@ -650,7 +652,7 @@ static int process_sample_event(event_t *event, struct perf_session *session)
 
 	cpumode = event->header.misc & PERF_RECORD_MISC_CPUMODE_MASK;
 
-	thread__find_addr_location(thread, cpumode,
+	thread__find_addr_location(thread, session, cpumode,
 				   MAP__FUNCTION, data.ip, &al, NULL);
 	/*
 	 * We have to do this here as we may have a dso with no symbol hit that
@@ -669,7 +671,7 @@ static int process_sample_event(event_t *event, struct perf_session *session)
 	if (sym_list && al.sym && !strlist__has_entry(sym_list, al.sym->name))
 		return 0;
 
-	if (hist_entry__add(&al, data.callchain, data.period)) {
+	if (hist_entry__add(&al, session, data.callchain, data.period)) {
 		pr_debug("problem incrementing symbol count, skipping event\n");
 		return -1;
 	}
@@ -763,7 +765,7 @@ static int __cmd_report(void)
 	int ret;
 	struct perf_session *session;
 
-	session = perf_session__new(input_name, O_RDONLY, force);
+	session = perf_session__new(input_name, O_RDONLY, force, &symbol_conf);
 	if (session == NULL)
 		return -ENOMEM;
 
diff --git a/tools/perf/builtin-sched.c b/tools/perf/builtin-sched.c
index 8d58d9e..bce05df 100644
--- a/tools/perf/builtin-sched.c
+++ b/tools/perf/builtin-sched.c
@@ -1679,8 +1679,8 @@ static struct perf_event_ops event_ops = {
 static int read_events(void)
 {
 	int err;
-	struct perf_session *session = perf_session__new(input_name, O_RDONLY, 0);
-
+	struct perf_session *session = perf_session__new(input_name, O_RDONLY,
+							 0, NULL);
 	if (session == NULL)
 		return -ENOMEM;
 
diff --git a/tools/perf/builtin-timechart.c b/tools/perf/builtin-timechart.c
index b5211fa..2701853 100644
--- a/tools/perf/builtin-timechart.c
+++ b/tools/perf/builtin-timechart.c
@@ -1056,7 +1056,8 @@ static struct perf_event_ops event_ops = {
 
 static int __cmd_timechart(void)
 {
-	struct perf_session *session = perf_session__new(input_name, O_RDONLY, 0);
+	struct perf_session *session = perf_session__new(input_name, O_RDONLY,
+							 0, NULL);
 	int ret;
 
 	if (session == NULL)
diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
index 0f7a4da..3b212bb 100644
--- a/tools/perf/builtin-top.c
+++ b/tools/perf/builtin-top.c
@@ -1162,8 +1162,8 @@ static int __cmd_top(void)
 	 * FIXME: perf_session__new should allow passing a O_MMAP, so that all this
 	 * mmap reading, etc is encapsulated in it. Use O_WRONLY for now.
 	 */
-	struct perf_session *session = perf_session__new(NULL, O_WRONLY, false);
-
+	struct perf_session *session = perf_session__new(NULL, O_WRONLY, false,
+							 &symbol_conf);
 	if (session == NULL)
 		return -ENOMEM;
 
diff --git a/tools/perf/builtin-trace.c b/tools/perf/builtin-trace.c
index d765323..9d89ae4 100644
--- a/tools/perf/builtin-trace.c
+++ b/tools/perf/builtin-trace.c
@@ -318,7 +318,7 @@ int cmd_trace(int argc, const char **argv, const char *prefix __used)
 
 	setup_pager();
 
-	session = perf_session__new(input_name, O_RDONLY, 0);
+	session = perf_session__new(input_name, O_RDONLY, 0, NULL);
 	if (session == NULL)
 		return -ENOMEM;
 
diff --git a/tools/perf/util/event.c b/tools/perf/util/event.c
index 2d09c29..222efb1 100644
--- a/tools/perf/util/event.c
+++ b/tools/perf/util/event.c
@@ -256,7 +256,8 @@ int event__process_task(event_t *self, struct perf_session *session)
 	return 0;
 }
 
-void thread__find_addr_location(struct thread *self, u8 cpumode,
+void thread__find_addr_location(struct thread *self,
+				struct perf_session *session, u8 cpumode,
 				enum map_type type, u64 addr,
 				struct addr_location *al,
 				symbol_filter_t filter)
@@ -268,7 +269,7 @@ void thread__find_addr_location(struct thread *self, u8 cpumode,
 
 	if (cpumode & PERF_RECORD_MISC_KERNEL) {
 		al->level = 'k';
-		mg = kmaps;
+		mg = &session->kmaps;
 	} else if (cpumode & PERF_RECORD_MISC_USER)
 		al->level = '.';
 	else {
@@ -289,14 +290,14 @@ try_again:
 		 * "[vdso]" dso, but for now lets use the old trick of looking
 		 * in the whole kernel symbol list.
 		 */
-		if ((long long)al->addr < 0 && mg != kmaps) {
-			mg = kmaps;
+		if ((long long)al->addr < 0 && mg != &session->kmaps) {
+			mg = &session->kmaps;
 			goto try_again;
 		}
 		al->sym = NULL;
 	} else {
 		al->addr = al->map->map_ip(al->map, al->addr);
-		al->sym = map__find_symbol(al->map, al->addr, filter);
+		al->sym = map__find_symbol(al->map, session, al->addr, filter);
 	}
 }
 
@@ -311,7 +312,7 @@ int event__preprocess_sample(const event_t *self, struct perf_session *session,
 
 	dump_printf(" ... thread: %s:%d\n", thread->comm, thread->pid);
 
-	thread__find_addr_location(thread, cpumode, MAP__FUNCTION,
+	thread__find_addr_location(thread, session, cpumode, MAP__FUNCTION,
 				   self->ip.ip, al, filter);
 	dump_printf(" ...... dso: %s\n",
 		    al->map ? al->map->dso->long_name :
diff --git a/tools/perf/util/event.h b/tools/perf/util/event.h
index bb09025..035ecf3 100644
--- a/tools/perf/util/event.h
+++ b/tools/perf/util/event.h
@@ -149,15 +149,17 @@ void map__delete(struct map *self);
 struct map *map__clone(struct map *self);
 int map__overlap(struct map *l, struct map *r);
 size_t map__fprintf(struct map *self, FILE *fp);
-struct symbol *map__find_symbol(struct map *self, u64 addr,
-				symbol_filter_t filter);
+
+struct perf_session;
+
+struct symbol *map__find_symbol(struct map *self, struct perf_session *session,
+				u64 addr, symbol_filter_t filter);
 struct symbol *map__find_symbol_by_name(struct map *self, const char *name,
+					struct perf_session *session,
 					symbol_filter_t filter);
 void map__fixup_start(struct map *self);
 void map__fixup_end(struct map *self);
 
-struct perf_session;
-
 int event__synthesize_thread(pid_t pid,
 			     int (*process)(event_t *event,
 					    struct perf_session *session),
diff --git a/tools/perf/util/map.c b/tools/perf/util/map.c
index 76bdca6..8b3dd46 100644
--- a/tools/perf/util/map.c
+++ b/tools/perf/util/map.c
@@ -104,10 +104,11 @@ void map__fixup_end(struct map *self)
 
 #define DSO__DELETED "(deleted)"
 
-static int map__load(struct map *self, symbol_filter_t filter)
+static int map__load(struct map *self, struct perf_session *session,
+		     symbol_filter_t filter)
 {
 	const char *name = self->dso->long_name;
-	int nr = dso__load(self->dso, self, filter);
+	int nr = dso__load(self->dso, self, session, filter);
 
 	if (nr < 0) {
 		if (self->dso->has_build_id) {
@@ -143,19 +144,20 @@ static int map__load(struct map *self, symbol_filter_t filter)
 	return 0;
 }
 
-struct symbol *map__find_symbol(struct map *self, u64 addr,
-				symbol_filter_t filter)
+struct symbol *map__find_symbol(struct map *self, struct perf_session *session,
+				u64 addr, symbol_filter_t filter)
 {
-	if (!dso__loaded(self->dso, self->type) && map__load(self, filter) < 0)
+	if (!dso__loaded(self->dso, self->type) && map__load(self, session, filter) < 0)
 		return NULL;
 
 	return dso__find_symbol(self->dso, self->type, addr);
 }
 
 struct symbol *map__find_symbol_by_name(struct map *self, const char *name,
+					struct perf_session *session,
 					symbol_filter_t filter)
 {
-	if (!dso__loaded(self->dso, self->type) && map__load(self, filter) < 0)
+	if (!dso__loaded(self->dso, self->type) && map__load(self, session, filter) < 0)
 		return NULL;
 
 	if (!dso__sorted_by_name(self->dso, self->type))
diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
index 09836a5..fe87a2f 100644
--- a/tools/perf/util/session.c
+++ b/tools/perf/util/session.c
@@ -49,7 +49,7 @@ out_close:
 }
 
 struct perf_session *perf_session__new(const char *filename, int mode,
-				       bool force)
+				       bool force, struct symbol_conf *conf)
 {
 	size_t len = filename ? strlen(filename) + 1 : 0;
 	struct perf_session *self = zalloc(sizeof(*self) + len);
@@ -58,7 +58,7 @@ struct perf_session *perf_session__new(const char *filename, int mode,
 		goto out;
 
 	if (perf_header__init(&self->header) < 0)
-		goto out_delete;
+		goto out_free;
 
 	memcpy(self->filename, filename, len);
 	self->threads = RB_ROOT;
@@ -66,16 +66,21 @@ struct perf_session *perf_session__new(const char *filename, int mode,
 	self->mmap_window = 32;
 	self->cwd = NULL;
 	self->cwdlen = 0;
+	map_groups__init(&self->kmaps);
 
-	if (mode == O_RDONLY && perf_session__open(self, force) < 0) {
-		perf_session__delete(self);
-		self = NULL;
-	}
+	if (perf_session__create_kernel_maps(self, conf) < 0)
+		goto out_delete;
+
+	if (mode == O_RDONLY && perf_session__open(self, force) < 0)
+		goto out_delete;
 out:
 	return self;
-out_delete:
+out_free:
 	free(self);
 	return NULL;
+out_delete:
+	perf_session__delete(self);
+	return NULL;
 }
 
 void perf_session__delete(struct perf_session *self)
diff --git a/tools/perf/util/session.h b/tools/perf/util/session.h
index 1dbef7c..20b2c9c 100644
--- a/tools/perf/util/session.h
+++ b/tools/perf/util/session.h
@@ -3,19 +3,23 @@
 
 #include "event.h"
 #include "header.h"
+#include "thread.h"
 #include <linux/rbtree.h>
 
 struct thread;
+struct symbol_conf;
 
 struct perf_session {
 	struct perf_header	header;
 	unsigned long		size;
 	unsigned long		mmap_window;
+	struct map_groups	kmaps;
 	struct rb_root		threads;
 	struct thread		*last_match;
 	int			fd;
 	int			cwdlen;
 	char			*cwd;
+	bool			use_modules;
 	char filename[0];
 };
 
@@ -37,7 +41,7 @@ struct perf_event_ops {
 };
 
 struct perf_session *perf_session__new(const char *filename, int mode,
-				       bool force);
+				       bool force, struct symbol_conf *conf);
 void perf_session__delete(struct perf_session *self);
 
 int perf_session__process_events(struct perf_session *self,
diff --git a/tools/perf/util/symbol.c b/tools/perf/util/symbol.c
index d3d9fed..185b9ee 100644
--- a/tools/perf/util/symbol.c
+++ b/tools/perf/util/symbol.c
@@ -1,5 +1,6 @@
 #include "util.h"
 #include "../perf.h"
+#include "session.h"
 #include "string.h"
 #include "symbol.h"
 #include "thread.h"
@@ -31,7 +32,7 @@ enum dso_origin {
 static void dsos__add(struct list_head *head, struct dso *dso);
 static struct map *map__new2(u64 start, struct dso *dso, enum map_type type);
 static int dso__load_kernel_sym(struct dso *self, struct map *map,
-				struct map_groups *mg, symbol_filter_t filter);
+				struct perf_session *session, symbol_filter_t filter);
 unsigned int symbol__priv_size;
 static int vmlinux_path__nr_entries;
 static char **vmlinux_path;
@@ -41,9 +42,6 @@ static struct symbol_conf symbol_conf__defaults = {
 	.try_vmlinux_path = true,
 };
 
-static struct map_groups kmaps_mem;
-struct map_groups *kmaps = &kmaps_mem;
-
 bool dso__loaded(const struct dso *self, enum map_type type)
 {
 	return self->loaded & (1 << type);
@@ -456,7 +454,7 @@ out_failure:
  * the original ELF section names vmlinux have.
  */
 static int dso__split_kallsyms(struct dso *self, struct map *map,
-			       struct map_groups *mg, symbol_filter_t filter)
+			       struct perf_session *session, symbol_filter_t filter)
 {
 	struct map *curr_map = map;
 	struct symbol *pos;
@@ -473,13 +471,13 @@ static int dso__split_kallsyms(struct dso *self, struct map *map,
 
 		module = strchr(pos->name, '\t');
 		if (module) {
-			if (!mg->use_modules)
+			if (!session->use_modules)
 				goto discard_symbol;
 
 			*module++ = '\0';
 
 			if (strcmp(self->name, module)) {
-				curr_map = map_groups__find_by_name(mg, map->type, module);
+				curr_map = map_groups__find_by_name(&session->kmaps, map->type, module);
 				if (curr_map == NULL) {
 					pr_debug("/proc/{kallsyms,modules} "
 					         "inconsistency!\n");
@@ -510,7 +508,7 @@ static int dso__split_kallsyms(struct dso *self, struct map *map,
 			}
 
 			curr_map->map_ip = curr_map->unmap_ip = identity__map_ip;
-			map_groups__insert(mg, curr_map);
+			map_groups__insert(&session->kmaps, curr_map);
 			++kernel_range;
 		}
 
@@ -531,7 +529,7 @@ discard_symbol:		rb_erase(&pos->rb_node, root);
 
 
 static int dso__load_kallsyms(struct dso *self, struct map *map,
-			      struct map_groups *mg, symbol_filter_t filter)
+			      struct perf_session *session, symbol_filter_t filter)
 {
 	if (dso__load_all_kallsyms(self, map) < 0)
 		return -1;
@@ -539,14 +537,7 @@ static int dso__load_kallsyms(struct dso *self, struct map *map,
 	symbols__fixup_end(&self->symbols[map->type]);
 	self->origin = DSO__ORIG_KERNEL;
 
-	return dso__split_kallsyms(self, map, mg, filter);
-}
-
-size_t kernel_maps__fprintf(FILE *fp)
-{
-	size_t printed = fprintf(fp, "Kernel maps:\n");
-	printed += map_groups__fprintf_maps(kmaps, fp);
-	return printed + fprintf(fp, "END kernel maps\n");
+	return dso__split_kallsyms(self, map, session, filter);
 }
 
 static int dso__load_perf_map(struct dso *self, struct map *map,
@@ -873,7 +864,7 @@ static bool elf_sec__is_a(GElf_Shdr *self, Elf_Data *secstrs, enum map_type type
 }
 
 static int dso__load_sym(struct dso *self, struct map *map,
-			 struct map_groups *mg, const char *name, int fd,
+			 struct perf_session *session, const char *name, int fd,
 			 symbol_filter_t filter, int kernel, int kmodule)
 {
 	struct map *curr_map = map;
@@ -977,7 +968,7 @@ static int dso__load_sym(struct dso *self, struct map *map,
 			snprintf(dso_name, sizeof(dso_name),
 				 "%s%s", self->short_name, section_name);
 
-			curr_map = map_groups__find_by_name(mg, map->type, dso_name);
+			curr_map = map_groups__find_by_name(&session->kmaps, map->type, dso_name);
 			if (curr_map == NULL) {
 				u64 start = sym.st_value;
 
@@ -996,7 +987,7 @@ static int dso__load_sym(struct dso *self, struct map *map,
 				curr_map->map_ip = identity__map_ip;
 				curr_map->unmap_ip = identity__map_ip;
 				curr_dso->origin = DSO__ORIG_KERNEL;
-				map_groups__insert(kmaps, curr_map);
+				map_groups__insert(&session->kmaps, curr_map);
 				dsos__add(&dsos__kernel, curr_dso);
 			} else
 				curr_dso = curr_map->dso;
@@ -1211,7 +1202,8 @@ char dso__symtab_origin(const struct dso *self)
 	return origin[self->origin];
 }
 
-int dso__load(struct dso *self, struct map *map, symbol_filter_t filter)
+int dso__load(struct dso *self, struct map *map, struct perf_session *session,
+	      symbol_filter_t filter)
 {
 	int size = PATH_MAX;
 	char *name;
@@ -1222,7 +1214,7 @@ int dso__load(struct dso *self, struct map *map, symbol_filter_t filter)
 	dso__set_loaded(self, map->type);
 
 	if (self->kernel)
-		return dso__load_kernel_sym(self, map, kmaps, filter);
+		return dso__load_kernel_sym(self, map, session, filter);
 
 	name = malloc(size);
 	if (!name)
@@ -1323,7 +1315,7 @@ struct map *map_groups__find_by_name(struct map_groups *self,
 	return NULL;
 }
 
-static int dsos__set_modules_path_dir(char *dirname)
+static int perf_session__set_modules_path_dir(struct perf_session *self, char *dirname)
 {
 	struct dirent *dent;
 	DIR *dir = opendir(dirname);
@@ -1343,7 +1335,7 @@ static int dsos__set_modules_path_dir(char *dirname)
 
 			snprintf(path, sizeof(path), "%s/%s",
 				 dirname, dent->d_name);
-			if (dsos__set_modules_path_dir(path) < 0)
+			if (perf_session__set_modules_path_dir(self, path) < 0)
 				goto failure;
 		} else {
 			char *dot = strrchr(dent->d_name, '.'),
@@ -1357,7 +1349,7 @@ static int dsos__set_modules_path_dir(char *dirname)
 				 (int)(dot - dent->d_name), dent->d_name);
 
 			strxfrchar(dso_name, '-', '_');
-			map = map_groups__find_by_name(kmaps, MAP__FUNCTION, dso_name);
+			map = map_groups__find_by_name(&self->kmaps, MAP__FUNCTION, dso_name);
 			if (map == NULL)
 				continue;
 
@@ -1377,7 +1369,7 @@ failure:
 	return -1;
 }
 
-static int dsos__set_modules_path(void)
+static int perf_session__set_modules_path(struct perf_session *self)
 {
 	struct utsname uts;
 	char modules_path[PATH_MAX];
@@ -1388,7 +1380,7 @@ static int dsos__set_modules_path(void)
 	snprintf(modules_path, sizeof(modules_path), "/lib/modules/%s/kernel",
 		 uts.release);
 
-	return dsos__set_modules_path_dir(modules_path);
+	return perf_session__set_modules_path_dir(self, modules_path);
 }
 
 /*
@@ -1410,7 +1402,7 @@ static struct map *map__new2(u64 start, struct dso *dso, enum map_type type)
 	return self;
 }
 
-static int map_groups__create_module_maps(struct map_groups *self)
+static int perf_session__create_module_maps(struct perf_session *self)
 {
 	char *line = NULL;
 	size_t n;
@@ -1467,14 +1459,14 @@ static int map_groups__create_module_maps(struct map_groups *self)
 			dso->has_build_id = true;
 
 		dso->origin = DSO__ORIG_KMODULE;
-		map_groups__insert(self, map);
+		map_groups__insert(&self->kmaps, map);
 		dsos__add(&dsos__kernel, dso);
 	}
 
 	free(line);
 	fclose(file);
 
-	return dsos__set_modules_path();
+	return perf_session__set_modules_path(self);
 
 out_delete_line:
 	free(line);
@@ -1483,7 +1475,7 @@ out_failure:
 }
 
 static int dso__load_vmlinux(struct dso *self, struct map *map,
-			     struct map_groups *mg,
+			     struct perf_session *session,
 			     const char *vmlinux, symbol_filter_t filter)
 {
 	int err = -1, fd;
@@ -1517,14 +1509,14 @@ static int dso__load_vmlinux(struct dso *self, struct map *map,
 		return -1;
 
 	dso__set_loaded(self, map->type);
-	err = dso__load_sym(self, map, mg, self->long_name, fd, filter, 1, 0);
+	err = dso__load_sym(self, map, session, self->long_name, fd, filter, 1, 0);
 	close(fd);
 
 	return err;
 }
 
 static int dso__load_kernel_sym(struct dso *self, struct map *map,
-				struct map_groups *mg, symbol_filter_t filter)
+				struct perf_session *session, symbol_filter_t filter)
 {
 	int err;
 	bool is_kallsyms;
@@ -1534,7 +1526,7 @@ static int dso__load_kernel_sym(struct dso *self, struct map *map,
 		pr_debug("Looking at the vmlinux_path (%d entries long)\n",
 			 vmlinux_path__nr_entries);
 		for (i = 0; i < vmlinux_path__nr_entries; ++i) {
-			err = dso__load_vmlinux(self, map, mg,
+			err = dso__load_vmlinux(self, map, session,
 						vmlinux_path[i], filter);
 			if (err > 0) {
 				pr_debug("Using %s for symbols\n",
@@ -1550,12 +1542,12 @@ static int dso__load_kernel_sym(struct dso *self, struct map *map,
 	if (is_kallsyms)
 		goto do_kallsyms;
 
-	err = dso__load_vmlinux(self, map, mg, self->long_name, filter);
+	err = dso__load_vmlinux(self, map, session, self->long_name, filter);
 	if (err <= 0) {
 		pr_info("The file %s cannot be used, "
 			"trying to use /proc/kallsyms...", self->long_name);
 do_kallsyms:
-		err = dso__load_kallsyms(self, map, mg, filter);
+		err = dso__load_kallsyms(self, map, session, filter);
 		if (err > 0 && !is_kallsyms)
                         dso__set_long_name(self, strdup("[kernel.kallsyms]"));
 	}
@@ -1757,23 +1749,30 @@ int symbol__init(struct symbol_conf *conf)
 	if (pconf->sort_by_name)
 		symbol__priv_size += (sizeof(struct symbol_name_rb_node) -
 				      sizeof(struct symbol));
-	map_groups__init(kmaps);
 
 	if (pconf->try_vmlinux_path && vmlinux_path__init() < 0)
 		return -1;
 
-	if (map_groups__create_kernel_maps(kmaps, pconf->vmlinux_name) < 0) {
-		vmlinux_path__exit();
+	return 0;
+}
+
+int perf_session__create_kernel_maps(struct perf_session *self,
+				     struct symbol_conf *conf)
+{
+	const struct symbol_conf *pconf = conf ?: &symbol_conf__defaults;
+
+	if (map_groups__create_kernel_maps(&self->kmaps,
+					   pconf->vmlinux_name) < 0)
 		return -1;
-	}
 
-	kmaps->use_modules = pconf->use_modules;
-	if (pconf->use_modules && map_groups__create_module_maps(kmaps) < 0)
-		pr_debug("Failed to load list of modules in use, "
-			 "continuing...\n");
+	self->use_modules = pconf->use_modules;
+
+	if (pconf->use_modules && perf_session__create_module_maps(self) < 0)
+		pr_debug("Failed to load list of modules for session %s, "
+			 "continuing...\n", self->filename);
 	/*
 	 * Now that we have all the maps created, just set the ->end of them:
 	 */
-	map_groups__fixup_end(kmaps);
+	map_groups__fixup_end(&self->kmaps);
 	return 0;
 }
diff --git a/tools/perf/util/symbol.h b/tools/perf/util/symbol.h
index cf99f88..941ef33 100644
--- a/tools/perf/util/symbol.h
+++ b/tools/perf/util/symbol.h
@@ -98,8 +98,11 @@ bool dso__sorted_by_name(const struct dso *self, enum map_type type);
 
 void dso__sort_by_name(struct dso *self, enum map_type type);
 
+struct perf_session;
+
 struct dso *dsos__findnew(const char *name);
-int dso__load(struct dso *self, struct map *map, symbol_filter_t filter);
+int dso__load(struct dso *self, struct map *map, struct perf_session *session,
+	      symbol_filter_t filter);
 void dsos__fprintf(FILE *fp);
 size_t dsos__fprintf_buildid(FILE *fp);
 
@@ -116,12 +119,10 @@ int sysfs__read_build_id(const char *filename, void *bf, size_t size);
 bool dsos__read_build_ids(void);
 int build_id__sprintf(u8 *self, int len, char *bf);
 
-size_t kernel_maps__fprintf(FILE *fp);
-
 int symbol__init(struct symbol_conf *conf);
+int perf_session__create_kernel_maps(struct perf_session *self,
+				     struct symbol_conf *conf);
 
-struct map_groups;
-struct map_groups *kmaps;
 extern struct list_head dsos__user, dsos__kernel;
 extern struct dso *vdso;
 #endif /* __PERF_SYMBOL */
diff --git a/tools/perf/util/thread.c b/tools/perf/util/thread.c
index 634b7f7..4a08dcf 100644
--- a/tools/perf/util/thread.c
+++ b/tools/perf/util/thread.c
@@ -282,13 +282,14 @@ size_t perf_session__fprintf(struct perf_session *self, FILE *fp)
 }
 
 struct symbol *map_groups__find_symbol(struct map_groups *self,
+				       struct perf_session *session,
 				       enum map_type type, u64 addr,
 				       symbol_filter_t filter)
 {
 	struct map *map = map_groups__find(self, type, addr);
 
 	if (map != NULL)
-		return map__find_symbol(map, map->map_ip(map, addr), filter);
+		return map__find_symbol(map, session, map->map_ip(map, addr), filter);
 
 	return NULL;
 }
diff --git a/tools/perf/util/thread.h b/tools/perf/util/thread.h
index e93abf2..c206f72 100644
--- a/tools/perf/util/thread.h
+++ b/tools/perf/util/thread.h
@@ -8,7 +8,6 @@
 struct map_groups {
 	struct rb_root		maps[MAP__NR_TYPES];
 	struct list_head	removed_maps[MAP__NR_TYPES];
-	bool			use_modules;
 };
 
 struct thread {
@@ -49,19 +48,21 @@ static inline struct map *thread__find_map(struct thread *self,
 	return self ? map_groups__find(&self->mg, type, addr) : NULL;
 }
 
-void thread__find_addr_location(struct thread *self, u8 cpumode,
+void thread__find_addr_location(struct thread *self,
+				struct perf_session *session, u8 cpumode,
 				enum map_type type, u64 addr,
 				struct addr_location *al,
 				symbol_filter_t filter);
 struct symbol *map_groups__find_symbol(struct map_groups *self,
+				       struct perf_session *session,
 				       enum map_type type, u64 addr,
 				       symbol_filter_t filter);
 
 static inline struct symbol *
-map_groups__find_function(struct map_groups *self, u64 addr,
-			  symbol_filter_t filter)
+map_groups__find_function(struct map_groups *self, struct perf_session *session,
+			  u64 addr, symbol_filter_t filter)
 {
-	return map_groups__find_symbol(self, MAP__FUNCTION, addr, filter);
+	return map_groups__find_symbol(self, session, MAP__FUNCTION, addr, filter);
 }
 
 struct map *map_groups__find_by_name(struct map_groups *self,
-- 
1.6.2.5

