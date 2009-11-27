Return-Path: <linux-kernel-owner+w=401wt.eu-S1753389AbZK0S3r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753389AbZK0S3r (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Nov 2009 13:29:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753310AbZK0S3q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Nov 2009 13:29:46 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:42061 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752957AbZK0S3k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Nov 2009 13:29:40 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
       =?utf-8?q?Fr=C3=A9d=C3=A9ric=20Weisbecker?= <fweisbec@gmail.com>,
       John Kacur <jkacur@redhat.com>, Mike Galbraith <efault@gmx.de>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>
Subject: [PATCH 12/12] perf tools: Consolidate symbol resolving across all tools
Date: Fri, 27 Nov 2009 16:29:23 -0200
Message-Id: <1259346563-12568-12-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1259346563-12568-11-git-send-email-acme@infradead.org>
References: <1259346563-12568-1-git-send-email-acme@infradead.org>
 <1259346563-12568-2-git-send-email-acme@infradead.org>
 <1259346563-12568-3-git-send-email-acme@infradead.org>
 <1259346563-12568-4-git-send-email-acme@infradead.org>
 <1259346563-12568-5-git-send-email-acme@infradead.org>
 <1259346563-12568-6-git-send-email-acme@infradead.org>
 <1259346563-12568-7-git-send-email-acme@infradead.org>
 <1259346563-12568-8-git-send-email-acme@infradead.org>
 <1259346563-12568-9-git-send-email-acme@infradead.org>
 <1259346563-12568-10-git-send-email-acme@infradead.org>
 <1259346563-12568-11-git-send-email-acme@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

Now we have a very high level routine for simple tools to process
IP sample events:

	int event__preprocess_sample(const event_t *self,
				     struct addr_location *al,
				     symbol_filter_t filter)

It receives the event itself and will insert new threads in the global
threads list and resolve the map and symbol, filling all this info into
the new addr_location struct, so that tools like annotate and report can
further process the event by creating hist_entries in their specific
way (with or without callgraphs, etc).

It in turn uses the new next layer function:

	void thread__find_addr_location(struct thread *self, u8 cpumode,
					enum map_type type, u64 addr,
					struct addr_location *al,
					symbol_filter_t filter)

This one will, given a thread (userspace or the kernel kthread one),
will find the given type (MAP__FUNCTION now, MAP__VARIABLE too in
the near future) at the given cpumode, taking vdsos into account
(userspace hit, but kernel symbol) and will fill all these details in
the addr_location given.

Tools that need a more compact API for plain function resolution, like
'kmem', can use this other one:

	struct symbol *thread__find_function(struct thread *self, u64 addr,
					     symbol_filter_t filter)

So, to resolve a kernel symbol, that is all the 'kmem' tool needs, its
just a matter of calling:

	sym = thread__find_function(kthread, addr, NULL);

The 'filter' parameter is needed because we do lazy parsing/loading of
ELF symtabs or /proc/kallsyms.

With this we remove more code duplication all around, which is always
good, huh? :-)

Cc: Frédéric Weisbecker <fweisbec@gmail.com>
Cc: John Kacur <jkacur@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-annotate.c |   55 ++---------------
 tools/perf/builtin-kmem.c     |    2 +-
 tools/perf/builtin-report.c   |  135 ++++++++++++-----------------------------
 tools/perf/builtin-top.c      |   44 +++-----------
 tools/perf/util/event.c       |   62 +++++++++++++++++++
 tools/perf/util/event.h       |    4 +
 tools/perf/util/hist.c        |   15 ++---
 tools/perf/util/hist.h        |    6 +-
 tools/perf/util/symbol.c      |   26 +-------
 tools/perf/util/symbol.h      |   10 +++
 tools/perf/util/thread.c      |   12 ++++
 tools/perf/util/thread.h      |   23 +++++--
 12 files changed, 172 insertions(+), 222 deletions(-)

diff --git a/tools/perf/builtin-annotate.c b/tools/perf/builtin-annotate.c
index 7d39bd2..7f85c6e 100644
--- a/tools/perf/builtin-annotate.c
+++ b/tools/perf/builtin-annotate.c
@@ -124,71 +124,30 @@ static void hist_hit(struct hist_entry *he, u64 ip)
 			h->ip[offset]);
 }
 
-static int hist_entry__add(struct thread *thread, struct map *map,
-			   struct symbol *sym, u64 ip, u64 count, char level)
+static int hist_entry__add(struct addr_location *al, u64 count)
 {
 	bool hit;
-	struct hist_entry *he = __hist_entry__add(thread, map, sym, NULL, ip,
-						  count, level, &hit);
+	struct hist_entry *he = __hist_entry__add(al, NULL, count, &hit);
 	if (he == NULL)
 		return -ENOMEM;
-	hist_hit(he, ip);
+	hist_hit(he, al->addr);
 	return 0;
 }
 
 static int process_sample_event(event_t *event)
 {
-	char level;
-	u64 ip = event->ip.ip;
-	struct map *map = NULL;
-	struct symbol *sym = NULL;
-	struct thread *thread = threads__findnew(event->ip.pid);
+	struct addr_location al;
 
 	dump_printf("(IP, %d): %d: %p\n", event->header.misc,
-		    event->ip.pid, (void *)(long)ip);
+		    event->ip.pid, (void *)(long)event->ip.ip);
 
-	if (thread == NULL) {
+	if (event__preprocess_sample(event, &al, symbol_filter) < 0) {
 		fprintf(stderr, "problem processing %d event, skipping it.\n",
 			event->header.type);
 		return -1;
 	}
 
-	dump_printf(" ... thread: %s:%d\n", thread->comm, thread->pid);
-
-	if (event->header.misc & PERF_RECORD_MISC_KERNEL) {
-		level = 'k';
-		sym = kernel_maps__find_function(ip, &map, symbol_filter);
-		dump_printf(" ...... dso: %s\n",
-			    map ? map->dso->long_name : "<not found>");
-	} else if (event->header.misc & PERF_RECORD_MISC_USER) {
-		level = '.';
-		map = thread__find_map(thread, MAP__FUNCTION, ip);
-		if (map != NULL) {
-			ip = map->map_ip(map, ip);
-			sym = map__find_symbol(map, ip, symbol_filter);
-		} else {
-			/*
-			 * If this is outside of all known maps,
-			 * and is a negative address, try to look it
-			 * up in the kernel dso, as it might be a
-			 * vsyscall or vdso (which executes in user-mode).
-			 *
-			 * XXX This is nasty, we should have a symbol list in
-			 * the "[vdso]" dso, but for now lets use the old
-			 * trick of looking in the whole kernel symbol list.
-			 */
-			if ((long long)ip < 0)
-				sym = kernel_maps__find_function(ip, &map,
-								 symbol_filter);
-		}
-		dump_printf(" ...... dso: %s\n",
-			    map ? map->dso->long_name : "<not found>");
-	} else {
-		level = 'H';
-		dump_printf(" ...... dso: [hypervisor]\n");
-	}
-
-	if (hist_entry__add(thread, map, sym, ip, 1, level)) {
+	if (hist_entry__add(&al, 1)) {
 		fprintf(stderr, "problem incrementing symbol count, "
 				"skipping event\n");
 		return -1;
diff --git a/tools/perf/builtin-kmem.c b/tools/perf/builtin-kmem.c
index e7294c8..047fef7 100644
--- a/tools/perf/builtin-kmem.c
+++ b/tools/perf/builtin-kmem.c
@@ -420,7 +420,7 @@ static void __print_result(struct rb_root *root, int n_lines, int is_caller)
 		if (is_caller) {
 			addr = data->call_site;
 			if (!raw_ip)
-				sym = kernel_maps__find_function(addr, NULL, NULL);
+				sym = thread__find_function(kthread, addr, NULL);
 		} else
 			addr = data->ptr;
 
diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index 01ef35c..383c4ab 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -408,55 +408,6 @@ static int thread__set_comm_adjust(struct thread *self, const char *comm)
 	return 0;
 }
 
-
-static struct symbol *
-resolve_symbol(struct thread *thread, struct map **mapp, u64 *ipp)
-{
-	struct map *map = mapp ? *mapp : NULL;
-	u64 ip = *ipp;
-
-	if (map)
-		goto got_map;
-
-	if (!thread)
-		return NULL;
-
-	map = thread__find_map(thread, MAP__FUNCTION, ip);
-	if (map != NULL) {
-		/*
-		 * We have to do this here as we may have a dso
-		 * with no symbol hit that has a name longer than
-		 * the ones with symbols sampled.
-		 */
-		if (!sort_dso.elide && !map->dso->slen_calculated)
-			dso__calc_col_width(map->dso);
-
-		if (mapp)
-			*mapp = map;
-got_map:
-		ip = map->map_ip(map, ip);
-	} else {
-		/*
-		 * If this is outside of all known maps,
-		 * and is a negative address, try to look it
-		 * up in the kernel dso, as it might be a
-		 * vsyscall or vdso (which executes in user-mode).
-		 *
-		 * XXX This is nasty, we should have a symbol list in
-		 * the "[vdso]" dso, but for now lets use the old
-		 * trick of looking in the whole kernel symbol list.
-		 */
-		if ((long long)ip < 0)
-			return kernel_maps__find_function(ip, mapp, NULL);
-	}
-	dump_printf(" ...... dso: %s\n",
-		    map ? map->dso->long_name : "<not found>");
-	dump_printf(" ...... map: %Lx -> %Lx\n", *ipp, ip);
-	*ipp  = ip;
-
-	return map ? map__find_symbol(map, ip, NULL) : NULL;
-}
-
 static int call__match(struct symbol *sym)
 {
 	if (sym->name && !regexec(&parent_regex, sym->name, 0, NULL, 0))
@@ -469,7 +420,7 @@ static struct symbol **resolve_callchain(struct thread *thread,
 					 struct ip_callchain *chain,
 					 struct symbol **parent)
 {
-	u64 context = PERF_CONTEXT_MAX;
+	u8 cpumode = PERF_RECORD_MISC_USER;
 	struct symbol **syms = NULL;
 	unsigned int i;
 
@@ -483,30 +434,31 @@ static struct symbol **resolve_callchain(struct thread *thread,
 
 	for (i = 0; i < chain->nr; i++) {
 		u64 ip = chain->ips[i];
-		struct symbol *sym = NULL;
+		struct addr_location al;
 
 		if (ip >= PERF_CONTEXT_MAX) {
-			context = ip;
+			switch (ip) {
+			case PERF_CONTEXT_HV:
+				cpumode = PERF_RECORD_MISC_HYPERVISOR;	break;
+			case PERF_CONTEXT_KERNEL:
+				cpumode = PERF_RECORD_MISC_KERNEL;	break;
+			case PERF_CONTEXT_USER:
+				cpumode = PERF_RECORD_MISC_USER;	break;
+			default:
+				break;
+			}
 			continue;
 		}
 
-		switch (context) {
-		case PERF_CONTEXT_HV:
-			break;
-		case PERF_CONTEXT_KERNEL:
-			sym = kernel_maps__find_function(ip, NULL, NULL);
-			break;
-		default:
-			sym = resolve_symbol(thread, NULL, &ip);
-			break;
-		}
-
-		if (sym) {
-			if (sort__has_parent && !*parent && call__match(sym))
-				*parent = sym;
+		thread__find_addr_location(thread, cpumode, MAP__FUNCTION,
+					   ip, &al, NULL);
+		if (al.sym != NULL) {
+			if (sort__has_parent && !*parent &&
+			    call__match(al.sym))
+				*parent = al.sym;
 			if (!callchain)
 				break;
-			syms[i] = sym;
+			syms[i] = al.sym;
 		}
 	}
 
@@ -517,20 +469,17 @@ static struct symbol **resolve_callchain(struct thread *thread,
  * collect histogram counts
  */
 
-static int
-hist_entry__add(struct thread *thread, struct map *map,
-		struct symbol *sym, u64 ip, struct ip_callchain *chain,
-		char level, u64 count)
+static int hist_entry__add(struct addr_location *al,
+			   struct ip_callchain *chain, u64 count)
 {
 	struct symbol **syms = NULL, *parent = NULL;
 	bool hit;
 	struct hist_entry *he;
 
 	if ((sort__has_parent || callchain) && chain)
-		syms = resolve_callchain(thread, chain, &parent);
+		syms = resolve_callchain(al->thread, chain, &parent);
 
-	he = __hist_entry__add(thread, map, sym, parent,
-			       ip, count, level, &hit);
+	he = __hist_entry__add(al, parent, count, &hit);
 	if (he == NULL)
 		return -ENOMEM;
 
@@ -656,14 +605,12 @@ static int validate_chain(struct ip_callchain *chain, event_t *event)
 
 static int process_sample_event(event_t *event)
 {
-	char level;
-	struct symbol *sym = NULL;
 	u64 ip = event->ip.ip;
 	u64 period = 1;
-	struct map *map = NULL;
 	void *more_data = event->ip.__more_data;
 	struct ip_callchain *chain = NULL;
 	int cpumode;
+	struct addr_location al;
 	struct thread *thread = threads__findnew(event->ip.pid);
 
 	if (sample_type & PERF_SAMPLE_PERIOD) {
@@ -709,32 +656,26 @@ static int process_sample_event(event_t *event)
 
 	cpumode = event->header.misc & PERF_RECORD_MISC_CPUMODE_MASK;
 
-	if (cpumode == PERF_RECORD_MISC_KERNEL) {
-		level = 'k';
-		sym = kernel_maps__find_function(ip, &map, NULL);
-		dump_printf(" ...... dso: %s\n",
-			    map ? map->dso->long_name : "<not found>");
-	} else if (cpumode == PERF_RECORD_MISC_USER) {
-		level = '.';
-		sym = resolve_symbol(thread, &map, &ip);
-
-	} else {
-		level = 'H';
-		dump_printf(" ...... dso: [hypervisor]\n");
-	}
+	thread__find_addr_location(thread, cpumode,
+				   MAP__FUNCTION, ip, &al, NULL);
+	/*
+	 * We have to do this here as we may have a dso with no symbol hit that
+	 * has a name longer than the ones with symbols sampled.
+	 */
+	if (al.map && !sort_dso.elide && !al.map->dso->slen_calculated)
+		dso__calc_col_width(al.map->dso);
 
 	if (dso_list &&
-	    (!map || !map->dso ||
-	     !(strlist__has_entry(dso_list, map->dso->short_name) ||
-	       (map->dso->short_name != map->dso->long_name &&
-		strlist__has_entry(dso_list, map->dso->long_name)))))
+	    (!al.map || !al.map->dso ||
+	     !(strlist__has_entry(dso_list, al.map->dso->short_name) ||
+	       (al.map->dso->short_name != al.map->dso->long_name &&
+		strlist__has_entry(dso_list, al.map->dso->long_name)))))
 		return 0;
 
-	if (sym_list && sym && !strlist__has_entry(sym_list, sym->name))
+	if (sym_list && al.sym && !strlist__has_entry(sym_list, al.sym->name))
 		return 0;
 
-	if (hist_entry__add(thread, map, sym, ip,
-			    chain, level, period)) {
+	if (hist_entry__add(&al, chain, period)) {
 		pr_debug("problem incrementing symbol count, skipping event\n");
 		return -1;
 	}
diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
index 7a3c0c7..e0a374d 100644
--- a/tools/perf/builtin-top.c
+++ b/tools/perf/builtin-top.c
@@ -929,55 +929,28 @@ static int symbol_filter(struct map *map, struct symbol *sym)
 static void event__process_sample(const event_t *self, int counter)
 {
 	u64 ip = self->ip.ip;
-	struct map *map;
 	struct sym_entry *syme;
-	struct symbol *sym;
+	struct addr_location al;
 	u8 origin = self->header.misc & PERF_RECORD_MISC_CPUMODE_MASK;
 
 	switch (origin) {
-	case PERF_RECORD_MISC_USER: {
-		struct thread *thread;
-
+	case PERF_RECORD_MISC_USER:
 		if (hide_user_symbols)
 			return;
-
-		thread = threads__findnew(self->ip.pid);
-		if (thread == NULL)
-			return;
-
-		map = thread__find_map(thread, MAP__FUNCTION, ip);
-		if (map != NULL) {
-			ip = map->map_ip(map, ip);
-			sym = map__find_symbol(map, ip, symbol_filter);
-			if (sym == NULL)
-				return;
-			userspace_samples++;
-			break;
-		}
-	}
-		/*
-		 * If this is outside of all known maps,
-		 * and is a negative address, try to look it
-		 * up in the kernel dso, as it might be a
-		 * vsyscall or vdso (which executes in user-mode).
-		 */
-		if ((long long)ip >= 0)
-			return;
-		/* Fall thru */
+		break;
 	case PERF_RECORD_MISC_KERNEL:
 		if (hide_kernel_symbols)
 			return;
-
-		sym = kernel_maps__find_function(ip, &map, symbol_filter);
-		if (sym == NULL)
-			return;
 		break;
 	default:
 		return;
 	}
 
-	syme = symbol__priv(sym);
+	if (event__preprocess_sample(self, &al, symbol_filter) < 0 ||
+	    al.sym == NULL)
+		return;
 
+	syme = symbol__priv(al.sym);
 	if (!syme->skip) {
 		syme->count[counter]++;
 		syme->origin = origin;
@@ -986,8 +959,9 @@ static void event__process_sample(const event_t *self, int counter)
 		if (list_empty(&syme->node) || !syme->node.next)
 			__list_insert_active_sym(syme);
 		pthread_mutex_unlock(&active_symbols_lock);
+		if (origin == PERF_RECORD_MISC_USER)
+			++userspace_samples;
 		++samples;
-		return;
 	}
 }
 
diff --git a/tools/perf/util/event.c b/tools/perf/util/event.c
index 70b4aa0..233d7ad 100644
--- a/tools/perf/util/event.c
+++ b/tools/perf/util/event.c
@@ -249,3 +249,65 @@ int event__process_task(event_t *self)
 
 	return 0;
 }
+
+void thread__find_addr_location(struct thread *self, u8 cpumode,
+				enum map_type type, u64 addr,
+				struct addr_location *al,
+				symbol_filter_t filter)
+{
+	struct thread *thread = al->thread = self;
+
+	al->addr = addr;
+
+	if (cpumode & PERF_RECORD_MISC_KERNEL) {
+		al->level = 'k';
+		thread = kthread;
+	} else if (cpumode & PERF_RECORD_MISC_USER)
+		al->level = '.';
+	else {
+		al->level = 'H';
+		al->map = NULL;
+		al->sym = NULL;
+		return;
+	}
+try_again:
+	al->map = thread__find_map(thread, type, al->addr);
+	if (al->map == NULL) {
+		/*
+		 * If this is outside of all known maps, and is a negative
+		 * address, try to look it up in the kernel dso, as it might be
+		 * a vsyscall or vdso (which executes in user-mode).
+		 *
+		 * XXX This is nasty, we should have a symbol list in the
+		 * "[vdso]" dso, but for now lets use the old trick of looking
+		 * in the whole kernel symbol list.
+		 */
+		if ((long long)al->addr < 0 && thread != kthread) {
+			thread = kthread;
+			goto try_again;
+		}
+		al->sym = NULL;
+	} else {
+		al->addr = al->map->map_ip(al->map, al->addr);
+		al->sym = map__find_symbol(al->map, al->addr, filter);
+	}
+}
+
+int event__preprocess_sample(const event_t *self, struct addr_location *al,
+			     symbol_filter_t filter)
+{
+	u8 cpumode = self->header.misc & PERF_RECORD_MISC_CPUMODE_MASK;
+	struct thread *thread = threads__findnew(self->ip.pid);
+
+	if (thread == NULL)
+		return -1;
+
+	dump_printf(" ... thread: %s:%d\n", thread->comm, thread->pid);
+
+	thread__find_addr_location(thread, cpumode, MAP__FUNCTION,
+				   self->ip.ip, al, filter);
+	dump_printf(" ...... dso: %s\n",
+		    al->map ? al->map->dso->long_name :
+			al->level == 'H' ? "[hypervisor]" : "<not found>");
+	return 0;
+}
diff --git a/tools/perf/util/event.h b/tools/perf/util/event.h
index 13c12c7..a4cc810 100644
--- a/tools/perf/util/event.h
+++ b/tools/perf/util/event.h
@@ -152,4 +152,8 @@ int event__process_lost(event_t *self);
 int event__process_mmap(event_t *self);
 int event__process_task(event_t *self);
 
+struct addr_location;
+int event__preprocess_sample(const event_t *self, struct addr_location *al,
+			     symbol_filter_t filter);
+
 #endif /* __PERF_RECORD_H */
diff --git a/tools/perf/util/hist.c b/tools/perf/util/hist.c
index f26cd9b..0ebf6ee 100644
--- a/tools/perf/util/hist.c
+++ b/tools/perf/util/hist.c
@@ -14,20 +14,19 @@ struct callchain_param	callchain_param = {
  * histogram, sorted on item, collects counts
  */
 
-struct hist_entry *__hist_entry__add(struct thread *thread, struct map *map,
-				     struct symbol *sym,
+struct hist_entry *__hist_entry__add(struct addr_location *al,
 				     struct symbol *sym_parent,
-				     u64 ip, u64 count, char level, bool *hit)
+				     u64 count, bool *hit)
 {
 	struct rb_node **p = &hist.rb_node;
 	struct rb_node *parent = NULL;
 	struct hist_entry *he;
 	struct hist_entry entry = {
-		.thread	= thread,
-		.map	= map,
-		.sym	= sym,
-		.ip	= ip,
-		.level	= level,
+		.thread	= al->thread,
+		.map	= al->map,
+		.sym	= al->sym,
+		.ip	= al->addr,
+		.level	= al->level,
 		.count	= count,
 		.parent = sym_parent,
 	};
diff --git a/tools/perf/util/hist.h b/tools/perf/util/hist.h
index ac2149c..3020db0 100644
--- a/tools/perf/util/hist.h
+++ b/tools/perf/util/hist.h
@@ -36,9 +36,9 @@ extern unsigned long total_fork;
 extern unsigned long total_unknown;
 extern unsigned long total_lost;
 
-struct hist_entry *__hist_entry__add(struct thread *thread, struct map *map,
-				     struct symbol *sym, struct symbol *parent,
-				     u64 ip, u64 count, char level, bool *hit);
+struct hist_entry *__hist_entry__add(struct addr_location *al,
+				     struct symbol *parent,
+				     u64 count, bool *hit);
 extern int64_t hist_entry__cmp(struct hist_entry *, struct hist_entry *);
 extern int64_t hist_entry__collapse(struct hist_entry *, struct hist_entry *);
 extern void hist_entry__free(struct hist_entry *);
diff --git a/tools/perf/util/symbol.c b/tools/perf/util/symbol.c
index b788c2f..fffcb93 100644
--- a/tools/perf/util/symbol.c
+++ b/tools/perf/util/symbol.c
@@ -43,7 +43,8 @@ static struct symbol_conf symbol_conf__defaults = {
 	.try_vmlinux_path = true,
 };
 
-static struct thread kthread_mem, *kthread = &kthread_mem;
+static struct thread kthread_mem;
+struct thread *kthread = &kthread_mem;
 
 bool dso__loaded(const struct dso *self, enum map_type type)
 {
@@ -1178,29 +1179,6 @@ out:
 	return ret;
 }
 
-static struct symbol *thread__find_symbol(struct thread *self, u64 ip,
-					  enum map_type type, struct map **mapp,
-					  symbol_filter_t filter)
-{
-	struct map *map = thread__find_map(self, type, ip);
-
-	if (mapp)
-		*mapp = map;
-
-	if (map) {
-		ip = map->map_ip(map, ip);
-		return map__find_symbol(map, ip, filter);
-	}
-
-	return NULL;
-}
-
-struct symbol *kernel_maps__find_function(u64 ip, struct map **mapp,
-					  symbol_filter_t filter)
-{
-	return thread__find_symbol(kthread, ip, MAP__FUNCTION, mapp, filter);
-}
-
 static struct map *thread__find_map_by_name(struct thread *self, char *name)
 {
 	struct rb_node *nd;
diff --git a/tools/perf/util/symbol.h b/tools/perf/util/symbol.h
index 3f9e4a4..17003ef 100644
--- a/tools/perf/util/symbol.h
+++ b/tools/perf/util/symbol.h
@@ -63,6 +63,14 @@ static inline void *symbol__priv(struct symbol *self)
 	return ((void *)self) - symbol__priv_size;
 }
 
+struct addr_location {
+	struct thread *thread;
+	struct map    *map;
+	struct symbol *sym;
+	u64	      addr;
+	char	      level;
+};
+
 struct dso {
 	struct list_head node;
 	struct rb_root	 symbols[MAP__NR_TYPES];
@@ -105,6 +113,8 @@ size_t kernel_maps__fprintf(FILE *fp);
 
 int symbol__init(struct symbol_conf *conf);
 
+struct thread;
+struct thread *kthread;
 extern struct list_head dsos__user, dsos__kernel;
 extern struct dso *vdso;
 #endif /* __PERF_SYMBOL */
diff --git a/tools/perf/util/thread.c b/tools/perf/util/thread.c
index 2229f82..603f561 100644
--- a/tools/perf/util/thread.c
+++ b/tools/perf/util/thread.c
@@ -285,3 +285,15 @@ size_t threads__fprintf(FILE *fp)
 
 	return ret;
 }
+
+struct symbol *thread__find_symbol(struct thread *self,
+				   enum map_type type, u64 addr,
+				   symbol_filter_t filter)
+{
+	struct map *map = thread__find_map(self, type, addr);
+
+	if (map != NULL)
+		return map__find_symbol(map, map->map_ip(map, addr), filter);
+
+	return NULL;
+}
diff --git a/tools/perf/util/thread.h b/tools/perf/util/thread.h
index 59b0d9b..686d6e9 100644
--- a/tools/perf/util/thread.h
+++ b/tools/perf/util/thread.h
@@ -27,19 +27,30 @@ size_t thread__fprintf_maps(struct thread *self, FILE *fp);
 size_t threads__fprintf(FILE *fp);
 
 void maps__insert(struct rb_root *maps, struct map *map);
-struct map *maps__find(struct rb_root *maps, u64 ip);
-
-struct symbol *kernel_maps__find_function(const u64 ip, struct map **mapp,
-					  symbol_filter_t filter);
+struct map *maps__find(struct rb_root *maps, u64 addr);
 
 static inline struct map *thread__find_map(struct thread *self,
-					   enum map_type type, u64 ip)
+					   enum map_type type, u64 addr)
 {
-	return self ? maps__find(&self->maps[type], ip) : NULL;
+	return self ? maps__find(&self->maps[type], addr) : NULL;
 }
 
 static inline void __thread__insert_map(struct thread *self, struct map *map)
 {
 	 maps__insert(&self->maps[map->type], map);
 }
+
+void thread__find_addr_location(struct thread *self, u8 cpumode,
+				enum map_type type, u64 addr,
+				struct addr_location *al,
+				symbol_filter_t filter);
+struct symbol *thread__find_symbol(struct thread *self,
+				   enum map_type type, u64 addr,
+				   symbol_filter_t filter);
+
+static inline struct symbol *
+thread__find_function(struct thread *self, u64 addr, symbol_filter_t filter)
+{
+	return thread__find_symbol(self, MAP__FUNCTION, addr, filter);
+}
 #endif	/* __PERF_THREAD_H */
-- 
1.6.2.5

