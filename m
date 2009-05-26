Return-Path: <linux-kernel-owner+w=401wt.eu-S1755996AbZEZMOm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755996AbZEZMOm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 May 2009 08:14:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755516AbZEZMOP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 May 2009 08:14:15 -0400
Received: from hera.kernel.org ([140.211.167.34]:51281 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755725AbZEZMOL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 May 2009 08:14:11 -0400
Date: Tue, 26 May 2009 12:13:37 GMT
From: tip-bot for Arnaldo Carvalho de Melo <acme@redhat.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, acme@redhat.com,
       hpa@zytor.com, mingo@redhat.com, a.p.zijlstra@chello.nl,
       mtosatti@redhat.com, tglx@linutronix.de, cjashfor@linux.vnet.ibm.com,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
       linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
       mtosatti@redhat.com, tglx@linutronix.de, cjashfor@linux.vnet.ibm.com,
       mingo@elte.hu
In-Reply-To: <new-submission>
References: <new-submission>
Subject: [tip:perfcounters/core] perf_counter: Use rb_tree for symhists and threads in report
Message-ID: <tip-ce7e43653b08db094326f378958bc293a68e8e5b@git.kernel.org>
Git-Commit-ID: ce7e43653b08db094326f378958bc293a68e8e5b
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 26 May 2009 12:13:38 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  ce7e43653b08db094326f378958bc293a68e8e5b
Gitweb:     http://git.kernel.org/tip/ce7e43653b08db094326f378958bc293a68e8e5b
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Tue, 19 May 2009 09:30:23 -0300
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 26 May 2009 13:52:55 +0200

perf_counter: Use rb_tree for symhists and threads in report

Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Marcelo Tosatti <mtosatti@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
LKML-Reference: <new-submission>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 Documentation/perf_counter/builtin-report.c |  178 +++++++++++---------------
 1 files changed, 75 insertions(+), 103 deletions(-)

diff --git a/Documentation/perf_counter/builtin-report.c b/Documentation/perf_counter/builtin-report.c
index f63057f..e857201 100644
--- a/Documentation/perf_counter/builtin-report.c
+++ b/Documentation/perf_counter/builtin-report.c
@@ -479,23 +479,25 @@ static size_t map__fprintf(struct map *self, FILE *fp)
 }
 
 struct symhist {
-	struct list_head node;
+	struct rb_node	 rb_node;
 	struct dso	 *dso;
 	struct symbol	 *sym;
+	uint64_t	 ip;
 	uint32_t	 count;
 	char		 level;
 };
 
-static struct symhist *symhist__new(struct symbol *sym, struct dso *dso,
-				    char level)
+static struct symhist *symhist__new(struct symbol *sym, uint64_t ip,
+				    struct dso *dso, char level)
 {
 	struct symhist *self = malloc(sizeof(*self));
 
 	if (self != NULL) {
 		self->sym   = sym;
+		self->ip    = ip;
 		self->dso   = dso;
 		self->level = level;
-		self->count = 0;
+		self->count = 1;
 	}
 
 	return self;
@@ -506,12 +508,6 @@ static void symhist__delete(struct symhist *self)
 	free(self);
 }
 
-static bool symhist__equal(struct symhist *self, struct symbol *sym,
-			   struct dso *dso, char level)
-{
-	return self->level == level && self->sym == sym && self->dso == dso;
-}
-
 static void symhist__inc(struct symhist *self)
 {
 	++self->count;
@@ -519,7 +515,7 @@ static void symhist__inc(struct symhist *self)
 
 static size_t symhist__fprintf(struct symhist *self, FILE *fp)
 {
-	size_t ret = fprintf(fp, "[%c] ", self->level);
+	size_t ret = fprintf(fp, "%#llx [%c] ", (unsigned long long)self->ip, self->level);
 
 	if (self->level != '.')
 		ret += fprintf(fp, "%s", self->sym->name);
@@ -531,9 +527,9 @@ static size_t symhist__fprintf(struct symhist *self, FILE *fp)
 }
 
 struct thread {
-	struct list_head node;
+	struct rb_node	 rb_node;
 	struct list_head maps;
-	struct list_head symhists;
+	struct rb_root	 symhists;
 	pid_t		 pid;
 	char		 *comm;
 };
@@ -546,47 +542,43 @@ static struct thread *thread__new(pid_t pid)
 		self->pid = pid;
 		self->comm = NULL;
 		INIT_LIST_HEAD(&self->maps);
-		INIT_LIST_HEAD(&self->symhists);
+		self->symhists = RB_ROOT;
 	}
 
 	return self;
 }
 
-static void thread__insert_symhist(struct thread *self,
-				   struct symhist *symhist)
-{
-	list_add_tail(&symhist->node, &self->symhists);
-}
-
-static struct symhist *thread__symhists_find(struct thread *self,
-					     struct symbol *sym,
-					     struct dso *dso, char level)
+static int thread__symbol_incnew(struct thread *self, struct symbol *sym,
+				 uint64_t ip, struct dso *dso, char level)
 {
-	struct symhist *pos;
+	struct rb_node **p = &self->symhists.rb_node;
+	struct rb_node *parent = NULL;
+	struct symhist *sh;
 
-	list_for_each_entry(pos, &self->symhists, node)
-		if (symhist__equal(pos, sym, dso, level))
-			return pos;
+	while (*p != NULL) {
+		parent = *p;
+		sh = rb_entry(parent, struct symhist, rb_node);
 
-	return NULL;
-}
+		if (sh->sym == sym || ip == sh->ip) {
+			symhist__inc(sh);
+			return 0;
+		}
 
-static int thread__symbol_incnew(struct thread *self, struct symbol *sym,
-				 struct dso *dso, char level)
-{
-	struct symhist *symhist = thread__symhists_find(self, sym, dso, level);
+		/* Handle unresolved symbols too */
+		const uint64_t start = !sh->sym ? sh->ip : sh->sym->start;
 
-	if (symhist == NULL) {
-		symhist = symhist__new(sym, dso, level);
-		if (symhist == NULL)
-			goto out_error;
-		thread__insert_symhist(self, symhist);
+		if (ip < start)
+			p = &(*p)->rb_left;
+		else
+			p = &(*p)->rb_right;
 	}
 
-	symhist__inc(symhist);
+	sh = symhist__new(sym, ip, dso, level);
+	if (sh == NULL)
+		return -ENOMEM;
+	rb_link_node(&sh->rb_node, parent, p);
+	rb_insert_color(&sh->rb_node, &self->symhists);
 	return 0;
-out_error:
-	return -ENOMEM;
 }
 
 static int thread__set_comm(struct thread *self, const char *comm)
@@ -608,43 +600,44 @@ static size_t thread__maps_fprintf(struct thread *self, FILE *fp)
 
 static size_t thread__fprintf(struct thread *self, FILE *fp)
 {
-	struct symhist *pos;
 	int ret = fprintf(fp, "thread: %d %s\n", self->pid, self->comm);
+	struct rb_node *nd;
 
-	list_for_each_entry(pos, &self->symhists, node)
+	for (nd = rb_first(&self->symhists); nd; nd = rb_next(nd)) {
+		struct symhist *pos = rb_entry(nd, struct symhist, rb_node);
 		ret += symhist__fprintf(pos, fp);
+	}
 
 	return ret;
 }
 
-static LIST_HEAD(threads);
+static struct rb_root threads = RB_ROOT;
 
-static void threads__add(struct thread *thread)
-{
-	list_add_tail(&thread->node, &threads);
-}
-
-static struct thread *threads__find(pid_t pid)
+static struct thread *threads__findnew(pid_t pid)
 {
-	struct thread *pos;
+	struct rb_node **p = &threads.rb_node;
+	struct rb_node *parent = NULL;
+	struct thread *th;
 
-	list_for_each_entry(pos, &threads, node)
-		if (pos->pid == pid)
-			return pos;
-	return NULL;
-}
+	while (*p != NULL) {
+		parent = *p;
+		th = rb_entry(parent, struct thread, rb_node);
 
-static struct thread *threads__findnew(pid_t pid)
-{
-	struct thread *thread = threads__find(pid);
+		if (th->pid == pid)
+			return th;
 
-	if (thread == NULL) {
-		thread = thread__new(pid);
-		if (thread != NULL)
-			threads__add(thread);
+		if (pid < th->pid)
+			p = &(*p)->rb_left;
+		else
+			p = &(*p)->rb_right;
 	}
 
-	return thread;
+	th = thread__new(pid);
+	if (th != NULL) {
+		rb_link_node(&th->rb_node, parent, p);
+		rb_insert_color(&th->rb_node, &threads);
+	}
+	return th;
 }
 
 static void thread__insert_map(struct thread *self, struct map *map)
@@ -668,44 +661,13 @@ static struct map *thread__find_map(struct thread *self, uint64_t ip)
 
 static void threads__fprintf(FILE *fp)
 {
-	struct thread *pos;
-
-	list_for_each_entry(pos, &threads, node)
+	struct rb_node *nd;
+	for (nd = rb_first(&threads); nd; nd = rb_next(nd)) {
+		struct thread *pos = rb_entry(nd, struct thread, rb_node);
 		thread__fprintf(pos, fp);
+	}
 }
 
-#if 0
-static std::string resolve_user_symbol(int pid, uint64_t ip)
-{
-	std::string sym = "<unknown>";
-
-	maps_t &m = maps[pid];
-	maps_t::const_iterator mi = m.upper_bound(map(ip));
-	if (mi == m.end())
-		return sym;
-
-	ip -= mi->start + mi->pgoff;
-
-	symbols_t &s = dsos[mi->dso].syms;
-	symbols_t::const_iterator si = s.upper_bound(symbol(ip));
-
-	sym = mi->dso + ": <unknown>";
-
-	if (si == s.begin())
-		return sym;
-	si--;
-
-	if (si->start <= ip && ip < si->end)
-		sym = mi->dso + ": " + si->name;
-#if 0
-	else if (si->start <= ip)
-		sym = mi->dso + ": ?" + si->name;
-#endif
-
-	return sym;
-}
-#endif
-
 static void display_help(void)
 {
 	printf(
@@ -824,8 +786,11 @@ more:
 		struct dso *dso = NULL;
 		struct thread *thread = threads__findnew(event->ip.pid);
 
-		if (thread == NULL)
+		if (thread == NULL) {
+			fprintf(stderr, "problem processing %d event, bailing out\n",
+				event->header.type);
 			goto done;
+		}
 
 		if (event->header.misc & PERF_EVENT_MISC_KERNEL) {
 			show = SHOW_KERNEL;
@@ -845,8 +810,11 @@ more:
 		if (show & show_mask) {
 			struct symbol *sym = dso__find_symbol(dso, event->ip.ip);
 
-			if (thread__symbol_incnew(thread, sym, dso, level))
+			if (thread__symbol_incnew(thread, sym, event->ip.ip,
+						  dso, level)) {
+				fprintf(stderr, "problem incrementing symbol count, bailing out\n");
 				goto done;
+			}
 		}
 		total++;
 	} else switch (event->header.type) {
@@ -854,8 +822,10 @@ more:
 		struct thread *thread = threads__findnew(event->mmap.pid);
 		struct map *map = map__new(&event->mmap);
 
-		if (thread == NULL || map == NULL )
+		if (thread == NULL || map == NULL) {
+			fprintf(stderr, "problem processing PERF_EVENT_MMAP, bailing out\n");
 			goto done;
+		}
 		thread__insert_map(thread, map);
 		break;
 	}
@@ -863,8 +833,10 @@ more:
 		struct thread *thread = threads__findnew(event->comm.pid);
 
 		if (thread == NULL ||
-		    thread__set_comm(thread, event->comm.comm))
+		    thread__set_comm(thread, event->comm.comm)) {
+			fprintf(stderr, "problem processing PERF_EVENT_COMM, bailing out\n");
 			goto done;
+		}
 		break;
 	}
 	}
