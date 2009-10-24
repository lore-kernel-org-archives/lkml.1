Return-Path: <linux-kernel-owner+w=401wt.eu-S1753270AbZJXBEu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753270AbZJXBEu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Oct 2009 21:04:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753220AbZJXBEs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Oct 2009 21:04:48 -0400
Received: from hera.kernel.org ([140.211.167.34]:51704 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752659AbZJXBEk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Oct 2009 21:04:40 -0400
Date: Sat, 24 Oct 2009 01:04:03 GMT
From: tip-bot for Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, acme@redhat.com,
       hpa@zytor.com, mingo@redhat.com, efault@gmx.de, peterz@infradead.org,
       fweisbec@gmail.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
       linux-kernel@vger.kernel.org, fweisbec@gmail.com, peterz@infradead.org,
       efault@gmx.de, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1256153646-10097-1-git-send-email-acme@redhat.com>
References: <1256153646-10097-1-git-send-email-acme@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:branch?] perf tools: Unify debug messages mechanisms
Message-ID: <tip-6beba7adbe092e63dfe8d09fbd1e3ec140474a13@git.kernel.org>
Git-Commit-ID: 6beba7adbe092e63dfe8d09fbd1e3ec140474a13
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  6beba7adbe092e63dfe8d09fbd1e3ec140474a13
Gitweb:     http://git.kernel.org/tip/6beba7adbe092e63dfe8d09fbd1e3ec140474a13
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Wed, 21 Oct 2009 17:34:06 -0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 23 Oct 2009 08:22:47 +0200

perf tools: Unify debug messages mechanisms

We were using eprintf in some places, that looks at a global
'verbose' level, and at other places passing a 'v' parameter to
specify the verbosity level, unify it by introducing
pr_{err,warning,debug,etc}, just like in the kernel.

Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Mike Galbraith <efault@gmx.de>
LKML-Reference: <1256153646-10097-1-git-send-email-acme@redhat.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 tools/perf/builtin-annotate.c          |    3 +-
 tools/perf/builtin-record.c            |    2 +-
 tools/perf/builtin-report.c            |    9 +-
 tools/perf/builtin-sched.c             |    4 +-
 tools/perf/builtin-timechart.c         |   13 ++--
 tools/perf/builtin-top.c               |    2 +-
 tools/perf/builtin-trace.c             |    4 +-
 tools/perf/util/callchain.c            |    2 +-
 tools/perf/util/debug.c                |    4 +-
 tools/perf/util/debug.h                |    3 +-
 tools/perf/util/event.h                |    3 +-
 tools/perf/util/header.c               |    2 +-
 tools/perf/util/include/linux/kernel.h |   17 ++++
 tools/perf/util/map.c                  |   17 ++--
 tools/perf/util/symbol.c               |  134 ++++++++++++++------------------
 tools/perf/util/symbol.h               |    5 +-
 tools/perf/util/thread.c               |    6 +-
 17 files changed, 114 insertions(+), 116 deletions(-)

diff --git a/tools/perf/builtin-annotate.c b/tools/perf/builtin-annotate.c
index 99bac6a..6d63c2e 100644
--- a/tools/perf/builtin-annotate.c
+++ b/tools/perf/builtin-annotate.c
@@ -203,8 +203,7 @@ static int
 process_mmap_event(event_t *event, unsigned long offset, unsigned long head)
 {
 	struct map *map = map__new(&event->mmap, NULL, 0,
-				   sizeof(struct sym_priv), symbol_filter,
-				   verbose);
+				   sizeof(struct sym_priv), symbol_filter);
 	struct thread *thread = threads__findnew(event->mmap.pid);
 
 	dump_printf("%p [%p]: PERF_RECORD_MMAP %d: [%p(%p) @ %p]: %s\n",
diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index f0467ff..ac5ddff 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -630,7 +630,7 @@ static int __cmd_record(int argc, const char **argv)
 
 		param.sched_priority = realtime_prio;
 		if (sched_setscheduler(0, SCHED_FIFO, &param)) {
-			printf("Could not set realtime priority.\n");
+			pr_err("Could not set realtime priority.\n");
 			exit(-1);
 		}
 	}
diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index 72d5842..b3d814b 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -689,7 +689,8 @@ process_sample_event(event_t *event, unsigned long offset, unsigned long head)
 		dump_printf("... chain: nr:%Lu\n", chain->nr);
 
 		if (validate_chain(chain, event) < 0) {
-			eprintf("call-chain problem with event, skipping it.\n");
+			pr_debug("call-chain problem with event, "
+				 "skipping it.\n");
 			return 0;
 		}
 
@@ -700,7 +701,7 @@ process_sample_event(event_t *event, unsigned long offset, unsigned long head)
 	}
 
 	if (thread == NULL) {
-		eprintf("problem processing %d event, skipping it.\n",
+		pr_debug("problem processing %d event, skipping it.\n",
 			event->header.type);
 		return -1;
 	}
@@ -738,7 +739,7 @@ process_sample_event(event_t *event, unsigned long offset, unsigned long head)
 
 	if (hist_entry__add(thread, map, sym, ip,
 			    chain, level, period)) {
-		eprintf("problem incrementing symbol count, skipping event\n");
+		pr_debug("problem incrementing symbol count, skipping event\n");
 		return -1;
 	}
 
@@ -750,7 +751,7 @@ process_sample_event(event_t *event, unsigned long offset, unsigned long head)
 static int
 process_mmap_event(event_t *event, unsigned long offset, unsigned long head)
 {
-	struct map *map = map__new(&event->mmap, cwd, cwdlen, 0, NULL, verbose);
+	struct map *map = map__new(&event->mmap, cwd, cwdlen, 0, NULL);
 	struct thread *thread = threads__findnew(event->mmap.pid);
 
 	dump_printf("%p [%p]: PERF_RECORD_MMAP %d/%d: [%p(%p) @ %p]: %s\n",
diff --git a/tools/perf/builtin-sched.c b/tools/perf/builtin-sched.c
index 807ca66..9a48d96 100644
--- a/tools/perf/builtin-sched.c
+++ b/tools/perf/builtin-sched.c
@@ -1666,8 +1666,8 @@ process_sample_event(event_t *event, unsigned long offset, unsigned long head)
 		(long long)period);
 
 	if (thread == NULL) {
-		eprintf("problem processing %d event, skipping it.\n",
-			event->header.type);
+		pr_debug("problem processing %d event, skipping it.\n",
+			 event->header.type);
 		return -1;
 	}
 
diff --git a/tools/perf/builtin-timechart.c b/tools/perf/builtin-timechart.c
index 34fad57..0a2f222 100644
--- a/tools/perf/builtin-timechart.c
+++ b/tools/perf/builtin-timechart.c
@@ -1162,12 +1162,10 @@ more:
 	size = event->header.size;
 
 	if (!size || process_event(event) < 0) {
-
-		printf("%p [%p]: skipping unknown header type: %d\n",
-			(void *)(offset + head),
-			(void *)(long)(event->header.size),
-			event->header.type);
-
+		pr_warning("%p [%p]: skipping unknown header type: %d\n",
+			   (void *)(offset + head),
+			   (void *)(long)(event->header.size),
+			   event->header.type);
 		/*
 		 * assume we lost track of the stream, check alignment, and
 		 * increment a single u64 in the hope to catch on again 'soon'.
@@ -1200,7 +1198,8 @@ done:
 
 	write_svg_file(output_name);
 
-	printf("Written %2.1f seconds of trace to %s.\n", (last_time - first_time) / 1000000000.0, output_name);
+	pr_info("Written %2.1f seconds of trace to %s.\n",
+		(last_time - first_time) / 1000000000.0, output_name);
 
 	return rc;
 }
diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
index fa20345..4a9fe22 100644
--- a/tools/perf/builtin-top.c
+++ b/tools/perf/builtin-top.c
@@ -809,7 +809,7 @@ static int symbol_filter(struct map *map, struct symbol *sym)
 static int parse_symbols(void)
 {
 	if (dsos__load_kernel(vmlinux_name, sizeof(struct sym_entry),
-			      symbol_filter, verbose, 1) <= 0)
+			      symbol_filter, 1) <= 0)
 		return -1;
 
 	if (dump_symtab)
diff --git a/tools/perf/builtin-trace.c b/tools/perf/builtin-trace.c
index 4c129ff..e566bbe 100644
--- a/tools/perf/builtin-trace.c
+++ b/tools/perf/builtin-trace.c
@@ -81,8 +81,8 @@ process_sample_event(event_t *event, unsigned long offset, unsigned long head)
 		(long long)period);
 
 	if (thread == NULL) {
-		eprintf("problem processing %d event, skipping it.\n",
-			event->header.type);
+		pr_debug("problem processing %d event, skipping it.\n",
+			 event->header.type);
 		return -1;
 	}
 
diff --git a/tools/perf/util/callchain.c b/tools/perf/util/callchain.c
index 3b8380f..b3b7125 100644
--- a/tools/perf/util/callchain.c
+++ b/tools/perf/util/callchain.c
@@ -206,7 +206,7 @@ fill_node(struct callchain_node *node, struct ip_callchain *chain,
 	}
 	node->val_nr = chain->nr - start;
 	if (!node->val_nr)
-		printf("Warning: empty node in callchain tree\n");
+		pr_warning("Warning: empty node in callchain tree\n");
 }
 
 static void
diff --git a/tools/perf/util/debug.c b/tools/perf/util/debug.c
index e8ca98f..28d520d 100644
--- a/tools/perf/util/debug.c
+++ b/tools/perf/util/debug.c
@@ -13,12 +13,12 @@
 int verbose = 0;
 int dump_trace = 0;
 
-int eprintf(const char *fmt, ...)
+int eprintf(int level, const char *fmt, ...)
 {
 	va_list args;
 	int ret = 0;
 
-	if (verbose) {
+	if (verbose >= level) {
 		va_start(args, fmt);
 		ret = vfprintf(stderr, fmt, args);
 		va_end(args);
diff --git a/tools/perf/util/debug.h b/tools/perf/util/debug.h
index 02d1fa1..e8b18a1 100644
--- a/tools/perf/util/debug.h
+++ b/tools/perf/util/debug.h
@@ -5,7 +5,8 @@
 extern int verbose;
 extern int dump_trace;
 
-int eprintf(const char *fmt, ...) __attribute__((format(printf, 1, 2)));
+int eprintf(int level,
+	    const char *fmt, ...) __attribute__((format(printf, 2, 3)));
 int dump_printf(const char *fmt, ...) __attribute__((format(printf, 1, 2)));
 void trace_event(event_t *event);
 
diff --git a/tools/perf/util/event.h b/tools/perf/util/event.h
index db59c8b..d972b4b 100644
--- a/tools/perf/util/event.h
+++ b/tools/perf/util/event.h
@@ -106,8 +106,7 @@ struct symbol;
 typedef int (*symbol_filter_t)(struct map *map, struct symbol *sym);
 
 struct map *map__new(struct mmap_event *event, char *cwd, int cwdlen,
-		     unsigned int sym_priv_size, symbol_filter_t filter,
-		     int v);
+		     unsigned int sym_priv_size, symbol_filter_t filter);
 struct map *map__clone(struct map *self);
 int map__overlap(struct map *l, struct map *r);
 size_t map__fprintf(struct map *self, FILE *fp);
diff --git a/tools/perf/util/header.c b/tools/perf/util/header.c
index 622c60e..7d26659 100644
--- a/tools/perf/util/header.c
+++ b/tools/perf/util/header.c
@@ -93,7 +93,7 @@ static struct perf_trace_event_type *events;
 void perf_header__push_event(u64 id, const char *name)
 {
 	if (strlen(name) > MAX_EVENT_NAME)
-		printf("Event %s will be truncated\n", name);
+		pr_warning("Event %s will be truncated\n", name);
 
 	if (!events) {
 		events = malloc(sizeof(struct perf_trace_event_type));
diff --git a/tools/perf/util/include/linux/kernel.h b/tools/perf/util/include/linux/kernel.h
index 4b9204d..21c0274 100644
--- a/tools/perf/util/include/linux/kernel.h
+++ b/tools/perf/util/include/linux/kernel.h
@@ -85,4 +85,21 @@ simple_strtoul(const char *nptr, char **endptr, int base)
 	return strtoul(nptr, endptr, base);
 }
 
+#ifndef pr_fmt
+#define pr_fmt(fmt) fmt
+#endif
+
+#define pr_err(fmt, ...) \
+	do { fprintf(stderr, pr_fmt(fmt), ##__VA_ARGS__); } while (0)
+#define pr_warning(fmt, ...) \
+	do { fprintf(stderr, pr_fmt(fmt), ##__VA_ARGS__); } while (0)
+#define pr_info(fmt, ...) \
+	do { fprintf(stderr, pr_fmt(fmt), ##__VA_ARGS__); } while (0)
+#define pr_debug(fmt, ...) \
+	eprintf(1, pr_fmt(fmt), ##__VA_ARGS__)
+#define pr_debugN(n, fmt, ...) \
+	eprintf(n, pr_fmt(fmt), ##__VA_ARGS__)
+#define pr_debug2(fmt, ...) pr_debugN(2, pr_fmt(fmt), ##__VA_ARGS__)
+#define pr_debug3(fmt, ...) pr_debugN(3, pr_fmt(fmt), ##__VA_ARGS__)
+
 #endif
diff --git a/tools/perf/util/map.c b/tools/perf/util/map.c
index 55079c0..c1c5568 100644
--- a/tools/perf/util/map.c
+++ b/tools/perf/util/map.c
@@ -21,8 +21,7 @@ static int strcommon(const char *pathname, char *cwd, int cwdlen)
 }
 
 struct map *map__new(struct mmap_event *event, char *cwd, int cwdlen,
-		     unsigned int sym_priv_size, symbol_filter_t filter,
-		     int v)
+		     unsigned int sym_priv_size, symbol_filter_t filter)
 {
 	struct map *self = malloc(sizeof(*self));
 
@@ -58,16 +57,16 @@ struct map *map__new(struct mmap_event *event, char *cwd, int cwdlen,
 			goto out_delete;
 
 		if (new_dso) {
-			int nr = dso__load(self->dso, self, filter, v);
+			int nr = dso__load(self->dso, self, filter);
 
 			if (nr < 0)
-				eprintf("Failed to open %s, continuing "
-					"without symbols\n",
-					self->dso->long_name);
+				pr_warning("Failed to open %s, continuing "
+					   "without symbols\n",
+					   self->dso->long_name);
 			else if (nr == 0)
-				eprintf("No symbols found in %s, maybe "
-					"install a debug package?\n",
-					self->dso->long_name);
+				pr_warning("No symbols found in %s, maybe "
+					   "install a debug package?\n",
+					   self->dso->long_name);
 		}
 
 		if (self->dso == vdso || anon)
diff --git a/tools/perf/util/symbol.c b/tools/perf/util/symbol.c
index 0a48984..8f0208c 100644
--- a/tools/perf/util/symbol.c
+++ b/tools/perf/util/symbol.c
@@ -76,7 +76,7 @@ static void kernel_maps__fixup_end(void)
 }
 
 static struct symbol *symbol__new(u64 start, u64 len, const char *name,
-				  unsigned int priv_size, int v)
+				  unsigned int priv_size)
 {
 	size_t namelen = strlen(name) + 1;
 	struct symbol *self = calloc(1, priv_size + sizeof(*self) + namelen);
@@ -91,8 +91,7 @@ static struct symbol *symbol__new(u64 start, u64 len, const char *name,
 	self->start = start;
 	self->end   = len ? start + len - 1 : start;
 
-	if (v > 2)
-		printf("%s: %s %#Lx-%#Lx\n", __func__, name, start, self->end);
+	pr_debug3("%s: %s %#Lx-%#Lx\n", __func__, name, start, self->end);
 
 	memcpy(self->name, name, namelen);
 
@@ -209,7 +208,7 @@ size_t dso__fprintf(struct dso *self, FILE *fp)
  * so that we can in the next step set the symbol ->end address and then
  * call kernel_maps__split_kallsyms.
  */
-static int kernel_maps__load_all_kallsyms(int v)
+static int kernel_maps__load_all_kallsyms(void)
 {
 	char *line = NULL;
 	size_t n;
@@ -252,7 +251,7 @@ static int kernel_maps__load_all_kallsyms(int v)
 		 * Will fix up the end later, when we have all symbols sorted.
 		 */
 		sym = symbol__new(start, 0, symbol_name,
-				  kernel_map->dso->sym_priv_size, v);
+				  kernel_map->dso->sym_priv_size);
 
 		if (sym == NULL)
 			goto out_delete_line;
@@ -300,8 +299,8 @@ static int kernel_maps__split_kallsyms(symbol_filter_t filter, int use_modules)
 			if (strcmp(map->dso->name, module)) {
 				map = kernel_maps__find_by_dso_name(module);
 				if (!map) {
-					fputs("/proc/{kallsyms,modules} "
-					      "inconsistency!\n", stderr);
+					pr_err("/proc/{kallsyms,modules} "
+					       "inconsistency!\n");
 					return -1;
 				}
 			}
@@ -351,10 +350,9 @@ delete_symbol:
 }
 
 
-static int kernel_maps__load_kallsyms(symbol_filter_t filter,
-				      int use_modules, int v)
+static int kernel_maps__load_kallsyms(symbol_filter_t filter, int use_modules)
 {
-	if (kernel_maps__load_all_kallsyms(v))
+	if (kernel_maps__load_all_kallsyms())
 		return -1;
 
 	dso__fixup_sym_end(kernel_map->dso);
@@ -362,9 +360,9 @@ static int kernel_maps__load_kallsyms(symbol_filter_t filter,
 	return kernel_maps__split_kallsyms(filter, use_modules);
 }
 
-static size_t kernel_maps__fprintf(FILE *fp, int v)
+static size_t kernel_maps__fprintf(FILE *fp)
 {
-	size_t printed = fprintf(stderr, "Kernel maps:\n");
+	size_t printed = fprintf(fp, "Kernel maps:\n");
 	struct rb_node *nd;
 
 	for (nd = rb_first(&kernel_maps); nd; nd = rb_next(nd)) {
@@ -372,17 +370,17 @@ static size_t kernel_maps__fprintf(FILE *fp, int v)
 
 		printed += fprintf(fp, "Map:");
 		printed += map__fprintf(pos, fp);
-		if (v > 1) {
+		if (verbose > 1) {
 			printed += dso__fprintf(pos->dso, fp);
 			printed += fprintf(fp, "--\n");
 		}
 	}
 
-	return printed + fprintf(stderr, "END kernel maps\n");
+	return printed + fprintf(fp, "END kernel maps\n");
 }
 
 static int dso__load_perf_map(struct dso *self, struct map *map,
-			      symbol_filter_t filter, int v)
+			      symbol_filter_t filter)
 {
 	char *line = NULL;
 	size_t n;
@@ -420,7 +418,7 @@ static int dso__load_perf_map(struct dso *self, struct map *map,
 			continue;
 
 		sym = symbol__new(start, size, line + len,
-				  self->sym_priv_size, v);
+				  self->sym_priv_size);
 
 		if (sym == NULL)
 			goto out_delete_line;
@@ -534,7 +532,7 @@ static Elf_Scn *elf_section_by_name(Elf *elf, GElf_Ehdr *ep,
  * And always look at the original dso, not at debuginfo packages, that
  * have the PLT data stripped out (shdr_rel_plt.sh_type == SHT_NOBITS).
  */
-static int dso__synthesize_plt_symbols(struct  dso *self, int v)
+static int dso__synthesize_plt_symbols(struct  dso *self)
 {
 	uint32_t nr_rel_entries, idx;
 	GElf_Sym sym;
@@ -618,7 +616,7 @@ static int dso__synthesize_plt_symbols(struct  dso *self, int v)
 				 "%s@plt", elf_sym__name(&sym, symstrs));
 
 			f = symbol__new(plt_offset, shdr_plt.sh_entsize,
-					sympltname, self->sym_priv_size, v);
+					sympltname, self->sym_priv_size);
 			if (!f)
 				goto out_elf_end;
 
@@ -636,7 +634,7 @@ static int dso__synthesize_plt_symbols(struct  dso *self, int v)
 				 "%s@plt", elf_sym__name(&sym, symstrs));
 
 			f = symbol__new(plt_offset, shdr_plt.sh_entsize,
-					sympltname, self->sym_priv_size, v);
+					sympltname, self->sym_priv_size);
 			if (!f)
 				goto out_elf_end;
 
@@ -654,14 +652,14 @@ out_close:
 	if (err == 0)
 		return nr;
 out:
-	fprintf(stderr, "%s: problems reading %s PLT info.\n",
-		__func__, self->long_name);
+	pr_warning("%s: problems reading %s PLT info.\n",
+		   __func__, self->long_name);
 	return 0;
 }
 
 static int dso__load_sym(struct dso *self, struct map *map, const char *name,
 			 int fd, symbol_filter_t filter, int kernel,
-			 int kmodule, int v)
+			 int kmodule)
 {
 	struct map *curr_map = map;
 	struct dso *curr_dso = self;
@@ -680,15 +678,12 @@ static int dso__load_sym(struct dso *self, struct map *map, const char *name,
 
 	elf = elf_begin(fd, ELF_C_READ_MMAP, NULL);
 	if (elf == NULL) {
-		if (v)
-			fprintf(stderr, "%s: cannot read %s ELF file.\n",
-				__func__, name);
+		pr_err("%s: cannot read %s ELF file.\n", __func__, name);
 		goto out_close;
 	}
 
 	if (gelf_getehdr(elf, &ehdr) == NULL) {
-		if (v)
-			fprintf(stderr, "%s: cannot get elf header.\n", __func__);
+		pr_err("%s: cannot get elf header.\n", __func__);
 		goto out_elf_end;
 	}
 
@@ -794,10 +789,9 @@ static int dso__load_sym(struct dso *self, struct map *map, const char *name,
 		}
 
 		if (curr_dso->adjust_symbols) {
-			if (v > 2)
-				printf("adjusting symbol: st_value: %Lx sh_addr: %Lx sh_offset: %Lx\n",
-					(u64)sym.st_value, (u64)shdr.sh_addr, (u64)shdr.sh_offset);
-
+			pr_debug2("adjusting symbol: st_value: %Lx sh_addr: "
+				  "%Lx sh_offset: %Lx\n", (u64)sym.st_value,
+				  (u64)shdr.sh_addr, (u64)shdr.sh_offset);
 			sym.st_value -= shdr.sh_addr - shdr.sh_offset;
 		}
 		/*
@@ -810,7 +804,7 @@ static int dso__load_sym(struct dso *self, struct map *map, const char *name,
 			elf_name = demangled;
 new_symbol:
 		f = symbol__new(sym.st_value, sym.st_size, elf_name,
-				curr_dso->sym_priv_size, v);
+				curr_dso->sym_priv_size);
 		free(demangled);
 		if (!f)
 			goto out_elf_end;
@@ -837,7 +831,7 @@ out_close:
 
 #define BUILD_ID_SIZE 128
 
-static char *dso__read_build_id(struct dso *self, int v)
+static char *dso__read_build_id(struct dso *self)
 {
 	int i;
 	GElf_Ehdr ehdr;
@@ -854,15 +848,13 @@ static char *dso__read_build_id(struct dso *self, int v)
 
 	elf = elf_begin(fd, ELF_C_READ_MMAP, NULL);
 	if (elf == NULL) {
-		if (v)
-			fprintf(stderr, "%s: cannot read %s ELF file.\n",
-				__func__, self->long_name);
+		pr_err("%s: cannot read %s ELF file.\n", __func__,
+		       self->long_name);
 		goto out_close;
 	}
 
 	if (gelf_getehdr(elf, &ehdr) == NULL) {
-		if (v)
-			fprintf(stderr, "%s: cannot get elf header.\n", __func__);
+		pr_err("%s: cannot get elf header.\n", __func__);
 		goto out_elf_end;
 	}
 
@@ -884,8 +876,7 @@ static char *dso__read_build_id(struct dso *self, int v)
 		++raw;
 		bid += 2;
 	}
-	if (v >= 2)
-		printf("%s(%s): %s\n", __func__, self->long_name, build_id);
+	pr_debug2("%s(%s): %s\n", __func__, self->long_name, build_id);
 out_elf_end:
 	elf_end(elf);
 out_close:
@@ -911,8 +902,7 @@ char dso__symtab_origin(const struct dso *self)
 	return origin[self->origin];
 }
 
-int dso__load(struct dso *self, struct map *map,
-	      symbol_filter_t filter, int v)
+int dso__load(struct dso *self, struct map *map, symbol_filter_t filter)
 {
 	int size = PATH_MAX;
 	char *name = malloc(size), *build_id = NULL;
@@ -925,7 +915,7 @@ int dso__load(struct dso *self, struct map *map,
 	self->adjust_symbols = 0;
 
 	if (strncmp(self->name, "/tmp/perf-", 10) == 0) {
-		ret = dso__load_perf_map(self, map, filter, v);
+		ret = dso__load_perf_map(self, map, filter);
 		self->origin = ret > 0 ? DSO__ORIG_JAVA_JIT :
 					 DSO__ORIG_NOT_FOUND;
 		return ret;
@@ -946,7 +936,7 @@ more:
 				 self->long_name);
 			break;
 		case DSO__ORIG_BUILDID:
-			build_id = dso__read_build_id(self, v);
+			build_id = dso__read_build_id(self);
 			if (build_id != NULL) {
 				snprintf(name, size,
 					 "/usr/lib/debug/.build-id/%.2s/%s.debug",
@@ -967,7 +957,7 @@ more:
 		fd = open(name, O_RDONLY);
 	} while (fd < 0);
 
-	ret = dso__load_sym(self, map, name, fd, filter, 0, 0, v);
+	ret = dso__load_sym(self, map, name, fd, filter, 0, 0);
 	close(fd);
 
 	/*
@@ -977,7 +967,7 @@ more:
 		goto more;
 
 	if (ret > 0) {
-		int nr_plt = dso__synthesize_plt_symbols(self, v);
+		int nr_plt = dso__synthesize_plt_symbols(self);
 		if (nr_plt > 0)
 			ret += nr_plt;
 	}
@@ -1025,34 +1015,29 @@ struct map *kernel_maps__find_by_dso_name(const char *name)
 }
 
 static int dso__load_module_sym(struct dso *self, struct map *map,
-				symbol_filter_t filter, int v)
+				symbol_filter_t filter)
 {
 	int err = 0, fd = open(self->long_name, O_RDONLY);
 
 	if (fd < 0) {
-		if (v)
-			fprintf(stderr, "%s: cannot open %s\n",
-				__func__, self->long_name);
+		pr_err("%s: cannot open %s\n", __func__, self->long_name);
 		return err;
 	}
 
-	err = dso__load_sym(self, map, self->long_name, fd, filter, 0, 1, v);
+	err = dso__load_sym(self, map, self->long_name, fd, filter, 0, 1);
 	close(fd);
 
 	return err;
 }
 
-static int dsos__load_modules_sym_dir(char *dirname,
-				      symbol_filter_t filter, int v)
+static int dsos__load_modules_sym_dir(char *dirname, symbol_filter_t filter)
 {
 	struct dirent *dent;
 	int nr_symbols = 0, err;
 	DIR *dir = opendir(dirname);
 
 	if (!dir) {
-		if (v)
-			fprintf(stderr, "%s: cannot open %s dir\n", __func__,
-				dirname);
+		pr_err("%s: cannot open %s dir\n", __func__, dirname);
 		return -1;
 	}
 
@@ -1066,7 +1051,7 @@ static int dsos__load_modules_sym_dir(char *dirname,
 
 			snprintf(path, sizeof(path), "%s/%s",
 				 dirname, dent->d_name);
-			err = dsos__load_modules_sym_dir(path, filter, v);
+			err = dsos__load_modules_sym_dir(path, filter);
 			if (err < 0)
 				goto failure;
 		} else {
@@ -1092,7 +1077,7 @@ static int dsos__load_modules_sym_dir(char *dirname,
 			if (map->dso->long_name == NULL)
 				goto failure;
 
-			err = dso__load_module_sym(map->dso, map, filter, v);
+			err = dso__load_module_sym(map->dso, map, filter);
 			if (err < 0)
 				goto failure;
 			last = rb_last(&map->dso->syms);
@@ -1119,7 +1104,7 @@ failure:
 	return -1;
 }
 
-static int dsos__load_modules_sym(symbol_filter_t filter, int v)
+static int dsos__load_modules_sym(symbol_filter_t filter)
 {
 	struct utsname uts;
 	char modules_path[PATH_MAX];
@@ -1130,7 +1115,7 @@ static int dsos__load_modules_sym(symbol_filter_t filter, int v)
 	snprintf(modules_path, sizeof(modules_path), "/lib/modules/%s/kernel",
 		 uts.release);
 
-	return dsos__load_modules_sym_dir(modules_path, filter, v);
+	return dsos__load_modules_sym_dir(modules_path, filter);
 }
 
 /*
@@ -1225,15 +1210,14 @@ out_failure:
 }
 
 static int dso__load_vmlinux(struct dso *self, struct map *map,
-			     const char *vmlinux,
-			     symbol_filter_t filter, int v)
+			     const char *vmlinux, symbol_filter_t filter)
 {
 	int err, fd = open(vmlinux, O_RDONLY);
 
 	if (fd < 0)
 		return -1;
 
-	err = dso__load_sym(self, map, self->long_name, fd, filter, 1, 0, v);
+	err = dso__load_sym(self, map, self->long_name, fd, filter, 1, 0);
 
 	close(fd);
 
@@ -1241,7 +1225,7 @@ static int dso__load_vmlinux(struct dso *self, struct map *map,
 }
 
 int dsos__load_kernel(const char *vmlinux, unsigned int sym_priv_size,
-		      symbol_filter_t filter, int v, int use_modules)
+		      symbol_filter_t filter, int use_modules)
 {
 	int err = -1;
 	struct dso *dso = dso__new(vmlinux, sym_priv_size);
@@ -1257,26 +1241,26 @@ int dsos__load_kernel(const char *vmlinux, unsigned int sym_priv_size,
 	kernel_map->map_ip = kernel_map->unmap_ip = identity__map_ip;
 
 	if (use_modules && dsos__load_modules(sym_priv_size) < 0) {
-		fprintf(stderr, "Failed to load list of modules in use! "
-				"Continuing...\n");
+		pr_warning("Failed to load list of modules in use! "
+			   "Continuing...\n");
 		use_modules = 0;
 	}
 
 	if (vmlinux) {
-		err = dso__load_vmlinux(dso, kernel_map, vmlinux, filter, v);
+		err = dso__load_vmlinux(dso, kernel_map, vmlinux, filter);
 		if (err > 0 && use_modules) {
-			int syms = dsos__load_modules_sym(filter, v);
+			int syms = dsos__load_modules_sym(filter);
 
 			if (syms < 0)
-				fprintf(stderr, "Failed to read module symbols!"
-					" Continuing...\n");
+				pr_warning("Failed to read module symbols!"
+					   " Continuing...\n");
 			else
 				err += syms;
 		}
 	}
 
 	if (err <= 0)
-		err = kernel_maps__load_kallsyms(filter, use_modules, v);
+		err = kernel_maps__load_kallsyms(filter, use_modules);
 
 	if (err > 0) {
 		struct rb_node *node = rb_first(&dso->syms);
@@ -1296,8 +1280,8 @@ int dsos__load_kernel(const char *vmlinux, unsigned int sym_priv_size,
 		kernel_maps__fixup_end();
 		dsos__add(dso);
 
-		if (v > 0)
-			kernel_maps__fprintf(stderr, v);
+		if (verbose)
+			kernel_maps__fprintf(stderr);
 	}
 
 	return err;
@@ -1355,8 +1339,8 @@ void dsos__fprintf(FILE *fp)
 
 int load_kernel(unsigned int sym_priv_size, symbol_filter_t filter)
 {
-	if (dsos__load_kernel(vmlinux_name, sym_priv_size,
-			      filter, verbose, modules) <= 0)
+	if (dsos__load_kernel(vmlinux_name, sym_priv_size, filter,
+			      modules) <= 0)
 		return -1;
 
 	vdso = dso__new("[vdso]", 0);
diff --git a/tools/perf/util/symbol.h b/tools/perf/util/symbol.h
index c2a777d..77b7b3e 100644
--- a/tools/perf/util/symbol.h
+++ b/tools/perf/util/symbol.h
@@ -63,11 +63,10 @@ static inline void *dso__sym_priv(struct dso *self, struct symbol *sym)
 struct symbol *dso__find_symbol(struct dso *self, u64 ip);
 
 int dsos__load_kernel(const char *vmlinux, unsigned int sym_priv_size,
-		      symbol_filter_t filter, int verbose, int modules);
+		      symbol_filter_t filter, int modules);
 struct dso *dsos__findnew(const char *name, unsigned int sym_priv_size,
 			  bool *is_new);
-int dso__load(struct dso *self, struct map *map,
-	      symbol_filter_t filter, int v);
+int dso__load(struct dso *self, struct map *map, symbol_filter_t filter);
 void dsos__fprintf(FILE *fp);
 
 size_t dso__fprintf(struct dso *self, FILE *fp);
diff --git a/tools/perf/util/thread.c b/tools/perf/util/thread.c
index 8cb47f1..0f6d78c 100644
--- a/tools/perf/util/thread.c
+++ b/tools/perf/util/thread.c
@@ -127,9 +127,9 @@ static void thread__remove_overlappings(struct thread *self, struct map *map)
 			continue;
 
 		if (verbose >= 2) {
-			printf("overlapping maps:\n");
-			map__fprintf(map, stdout);
-			map__fprintf(pos, stdout);
+			fputs("overlapping maps:\n", stderr);
+			map__fprintf(map, stderr);
+			map__fprintf(pos, stderr);
 		}
 
 		rb_erase(&pos->rb_node, &self->maps);
