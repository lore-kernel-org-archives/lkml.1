Return-Path: <linux-kernel-owner+w=401wt.eu-S1757648AbZEZTTz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757648AbZEZTTz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 May 2009 15:19:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756761AbZEZTTr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 May 2009 15:19:47 -0400
Received: from mx2.redhat.com ([66.187.237.31]:53861 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755399AbZEZTTq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 May 2009 15:19:46 -0400
Date: Tue, 26 May 2009 16:19:04 -0300
From: Arnaldo Carvalho de Melo <acme@redhat.com>
To: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>, Mike Galbraith <efault@gmx.de>,
       Thomas Gleixner <tglx@linutronix.de>,
       Steven Rostedt <rostedt@goodmis.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/1 tip] perf: Sort report output by symbol usage
Message-ID: <20090526191904.GH4424@ghostprotocols.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Url: http://oops.ghostprotocols.net:81/blog
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

commit c1d5ff9c805eae0c97860f27ccc4270ff27b136f
Author: Arnaldo Carvalho de Melo <acme@redhat.com>
Date:   Tue May 26 16:03:02 2009 -0300

    perf: Sort report output by symbol usage
    
    [acme@emilia ~]$ perf record find / > /dev/null 2>&1
    [acme@emilia ~]$ perf stat perf report | head -20
     4.95          find [k] 0xffffffff81393d65 _spin_lock
     3.89          find [.] 0x000000000000af89 /usr/bin/find: <unknown>
     2.19          find [k] 0xffffffffa00518e0 ext3fs_dirhash
     1.87          find [k] 0xffffffff810a6cea __rcu_read_lock
     1.86          find [k] 0xffffffff811c7312 _atomic_dec_and_lock
     1.86          find [.] 0x00000000000782ab /lib64/libc-2.5.so: __GI_strlen
     1.85          find [k] 0xffffffff810fedfb __kmalloc
     1.62          find [.] 0x00000000000430ff /lib64/libc-2.5.so: vfprintf
     1.59          find [k] 0xffffffff810a6d6d __rcu_read_unlock
     1.55          find [k] 0xffffffff81119395 __d_lookup
     1.39          find [.] 0x0000000000071b40 /lib64/libc-2.5.so: _int_malloc
     1.30          find [k] 0xffffffffa031c4fc nfs_do_filldir
     1.21          find [k] 0xffffffff811876a5 avc_has_perm_noaudit
     1.15          find [k] 0xffffffff810fef62 kmem_cache_alloc
     1.07          find [k] 0xffffffff811d03fb copy_user_generic_string
     1.03          find [k] 0xffffffffa0043882 ext3_htree_store_dirent
     0.99          find [k] 0xffffffff81393ebb _spin_lock_bh
     0.98          find [k] 0xffffffffa03319a2 nfs3_decode_dirent
     0.97          find [k] 0xffffffff8100bf20 system_call
     0.92          find [k] 0xffffffff8139437e _spin_unlock
    
     Performance counter stats for 'perf':
    
         244.278972  task clock ticks     (msecs)
                  8  context switches     (events)
                  9  CPU migrations       (events)
               2104  pagefaults           (events)
           35329669  CPU cycles           (events)  (scaled from 75.40%)
           13740366  instructions         (events)  (scaled from 75.49%)
              59073  cache references     (events)  (scaled from 24.60%)
                196  cache misses         (events)  (scaled from 24.51%)
    
     Wall-clock time elapsed:   246.060717 msecs
    
    [acme@emilia ~]$
    [acme@emilia ~]$ grep "model name" /proc/cpuinfo | head -1
    model name	: Intel(R) Xeon(R) CPU           E5405  @ 2.00GHz
    [acme@emilia ~]$ grep "model name" /proc/cpuinfo | wc -l
    8
    [acme@emilia ~]$
    
    Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>

diff --git a/Documentation/perf_counter/builtin-report.c b/Documentation/perf_counter/builtin-report.c
index 2d4e4cc..3c0daeb 100644
--- a/Documentation/perf_counter/builtin-report.c
+++ b/Documentation/perf_counter/builtin-report.c
@@ -447,26 +447,33 @@ static size_t map__fprintf(struct map *self, FILE *fp)
 		       self->start, self->end, self->pgoff, self->dso->name);
 }
 
+struct thread;
+
+static const char *thread__name(struct thread *self, char *bf, size_t size);
+
 struct symhist {
 	struct rb_node	 rb_node;
 	struct dso	 *dso;
 	struct symbol	 *sym;
+	struct thread	 *thread;
 	uint64_t	 ip;
 	uint32_t	 count;
 	char		 level;
 };
 
 static struct symhist *symhist__new(struct symbol *sym, uint64_t ip,
-				    struct dso *dso, char level)
+				    struct thread *thread, struct dso *dso,
+				    char level)
 {
 	struct symhist *self = malloc(sizeof(*self));
 
 	if (self != NULL) {
-		self->sym   = sym;
-		self->ip    = ip;
-		self->dso   = dso;
-		self->level = level;
-		self->count = 1;
+		self->sym    = sym;
+		self->thread = thread;
+		self->ip     = ip;
+		self->dso    = dso;
+		self->level  = level;
+		self->count  = 1;
 	}
 
 	return self;
@@ -482,17 +489,29 @@ static void symhist__inc(struct symhist *self)
 	++self->count;
 }
 
-static size_t symhist__fprintf(struct symhist *self, FILE *fp)
+static size_t symhist__fprintf(struct symhist *self, uint64_t total_samples,
+			       FILE *fp)
 {
-	size_t ret = fprintf(fp, "%#llx [%c] ", (unsigned long long)self->ip, self->level);
+	char bf[32];
+	size_t ret;
+
+	if (total_samples)
+		ret = fprintf(fp, "%5.2f", (self->count * 100.0) / total_samples);
+	else
+		ret = fprintf(fp, "%12d", self->count);
+
+	ret += fprintf(fp, "%14s [%c] %#018llx ",
+		       thread__name(self->thread, bf, sizeof(bf)),
+		       self->level, (unsigned long long)self->ip);
 
 	if (self->level != '.')
-		ret += fprintf(fp, "%s", self->sym ? self->sym->name: "<unknown>");
+		ret += fprintf(fp, "%s\n",
+			       self->sym ? self->sym->name: "<unknown>");
 	else
-		ret += fprintf(fp, "%s: %s",
+		ret += fprintf(fp, "%s: %s\n",
 			       self->dso ? self->dso->name : "<unknown>",
 			       self->sym ? self->sym->name : "<unknown>");
-	return ret + fprintf(fp, ": %u\n", self->count);
+	return ret;
 }
 
 struct thread {
@@ -503,6 +522,15 @@ struct thread {
 	char		 *comm;
 };
 
+static const char *thread__name(struct thread *self, char *bf, size_t size)
+{
+	if (self->comm)
+		return self->comm;
+
+	snprintf(bf, sizeof(bf), ":%u", self->pid);
+	return bf;
+}
+
 static struct thread *thread__new(pid_t pid)
 {
 	struct thread *self = malloc(sizeof(*self));
@@ -542,7 +570,7 @@ static int thread__symbol_incnew(struct thread *self, struct symbol *sym,
 			p = &(*p)->rb_right;
 	}
 
-	sh = symhist__new(sym, ip, dso, level);
+	sh = symhist__new(sym, ip, self, dso, level);
 	if (sh == NULL)
 		return -ENOMEM;
 	rb_link_node(&sh->rb_node, parent, p);
@@ -574,7 +602,7 @@ static size_t thread__fprintf(struct thread *self, FILE *fp)
 
 	for (nd = rb_first(&self->symhists); nd; nd = rb_next(nd)) {
 		struct symhist *pos = rb_entry(nd, struct symhist, rb_node);
-		ret += symhist__fprintf(pos, fp);
+		ret += symhist__fprintf(pos, 0, fp);
 	}
 
 	return ret;
@@ -628,7 +656,7 @@ static struct map *thread__find_map(struct thread *self, uint64_t ip)
 	return NULL;
 }
 
-static void threads__fprintf(FILE *fp)
+void threads__fprintf(FILE *fp)
 {
 	struct rb_node *nd;
 	for (nd = rb_first(&threads); nd; nd = rb_next(nd)) {
@@ -637,6 +665,61 @@ static void threads__fprintf(FILE *fp)
 	}
 }
 
+static struct rb_root global_symhists = RB_ROOT;
+
+static void threads__insert_symhist(struct symhist *sh)
+{
+	struct rb_node **p = &global_symhists.rb_node;
+	struct rb_node *parent = NULL;
+	struct symhist *iter;
+
+	while (*p != NULL) {
+		parent = *p;
+		iter = rb_entry(parent, struct symhist, rb_node);
+
+		/* Reverse order */
+		if (sh->count > iter->count)
+			p = &(*p)->rb_left;
+		else
+			p = &(*p)->rb_right;
+	}
+
+	rb_link_node(&sh->rb_node, parent, p);
+	rb_insert_color(&sh->rb_node, &global_symhists);
+}
+
+static void threads__sort_symhists(void)
+{
+	struct rb_node *nd;
+
+	for (nd = rb_first(&threads); nd; nd = rb_next(nd)) {
+		struct thread *thread = rb_entry(nd, struct thread, rb_node);
+		struct rb_node *next = rb_first(&thread->symhists);
+
+		while (next) {
+			struct symhist *n = rb_entry(next, struct symhist,
+						     rb_node);
+			next = rb_next(&n->rb_node);
+			rb_erase(&n->rb_node, &thread->symhists);
+			threads__insert_symhist(n);
+		}
+
+	}
+}
+
+static size_t threads__symhists_fprintf(uint64_t total_samples, FILE *fp)
+{
+	struct rb_node *nd;
+	size_t ret = 0;
+
+	for (nd = rb_first(&global_symhists); nd; nd = rb_next(nd)) {
+		struct symhist *pos = rb_entry(nd, struct symhist, rb_node);
+		ret += symhist__fprintf(pos, total_samples, fp);
+	}
+
+	return ret;
+}
+
 static int __cmd_report(void)
 {
 	unsigned long offset = 0;
@@ -813,23 +896,9 @@ done:
 		return 0;
 	}
 
-	//dsos__fprintf(stdout);
-	threads__fprintf(stdout);
-#if 0
-	std::map<std::string, int>::iterator hi = hist.begin();
-
-	while (hi != hist.end()) {
-		rev_hist.insert(std::pair<int, std::string>(hi->second, hi->first));
-		hist.erase(hi++);
-	}
-
-	std::multimap<int, std::string>::const_iterator ri = rev_hist.begin();
+	threads__sort_symhists();
+	threads__symhists_fprintf(total, stdout);
 
-	while (ri != rev_hist.end()) {
-		printf(" %5.2f %s\n", (100.0 * ri->first)/total, ri->second.c_str());
-		ri++;
-	}
-#endif
 	return rc;
 }
 
