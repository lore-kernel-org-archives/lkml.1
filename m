Return-Path: <linux-kernel-owner+w=401wt.eu-S1761334AbZLOWGL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761334AbZLOWGL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Dec 2009 17:06:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933877AbZLOWE6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Dec 2009 17:04:58 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:46658 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933904AbZLOWE4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Dec 2009 17:04:56 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
       =?utf-8?q?Fr=C3=A9d=C3=A9ric=20Weisbecker?= <fweisbec@gmail.com>,
       Mike Galbraith <efault@gmx.de>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>
Subject: [PATCH 1/4] perf symbols: Make symbol_conf global
Date: Tue, 15 Dec 2009 20:04:39 -0200
Message-Id: <1260914682-29652-1-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

This simplifies a lot of functions, less stuff to be done by tool
writers.

Cc: Frédéric Weisbecker <fweisbec@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-annotate.c     |   14 +++++-------
 tools/perf/builtin-buildid-list.c |    5 ++-
 tools/perf/builtin-diff.c         |    8 ++----
 tools/perf/builtin-kmem.c         |    5 +--
 tools/perf/builtin-probe.c        |   14 +++++-------
 tools/perf/builtin-record.c       |    4 +-
 tools/perf/builtin-report.c       |    7 +----
 tools/perf/builtin-sched.c        |    5 +--
 tools/perf/builtin-timechart.c    |    5 +--
 tools/perf/builtin-top.c          |    6 +---
 tools/perf/builtin-trace.c        |    4 +-
 tools/perf/util/session.c         |    5 +--
 tools/perf/util/session.h         |    5 +---
 tools/perf/util/symbol.c          |   38 ++++++++++++++----------------------
 tools/perf/util/symbol.h          |    9 +++----
 15 files changed, 54 insertions(+), 80 deletions(-)

diff --git a/tools/perf/builtin-annotate.c b/tools/perf/builtin-annotate.c
index 2e2855a..e656e25 100644
--- a/tools/perf/builtin-annotate.c
+++ b/tools/perf/builtin-annotate.c
@@ -51,11 +51,6 @@ struct sym_priv {
 	struct sym_ext	*ext;
 };
 
-static struct symbol_conf symbol_conf = {
-	.priv_size	  = sizeof(struct sym_priv),
-	.try_vmlinux_path = true,
-};
-
 static const char *sym_hist_filter;
 
 static int symbol_filter(struct map *map __used, struct symbol *sym)
@@ -464,10 +459,10 @@ static struct perf_event_ops event_ops = {
 
 static int __cmd_annotate(void)
 {
-	struct perf_session *session = perf_session__new(input_name, O_RDONLY,
-							 force, &symbol_conf);
 	int ret;
+	struct perf_session *session;
 
+	session = perf_session__new(input_name, O_RDONLY, force);
 	if (session == NULL)
 		return -ENOMEM;
 
@@ -523,7 +518,10 @@ static const struct option options[] = {
 
 int cmd_annotate(int argc, const char **argv, const char *prefix __used)
 {
-	if (symbol__init(&symbol_conf) < 0)
+	symbol_conf.priv_size = sizeof(struct sym_priv);
+	symbol_conf.try_vmlinux_path = true;
+
+	if (symbol__init() < 0)
 		return -1;
 
 	argc = parse_options(argc, argv, options, annotate_usage, 0);
diff --git a/tools/perf/builtin-buildid-list.c b/tools/perf/builtin-buildid-list.c
index 7c36e4b..e693e67 100644
--- a/tools/perf/builtin-buildid-list.c
+++ b/tools/perf/builtin-buildid-list.c
@@ -54,8 +54,9 @@ static int perf_file_section__process_buildids(struct perf_file_section *self,
 static int __cmd_buildid_list(void)
 {
 	int err = -1;
-	struct perf_session *session = perf_session__new(input_name, O_RDONLY,
-							 force, NULL);
+	struct perf_session *session;
+
+	session = perf_session__new(input_name, O_RDONLY, force);
 	if (session == NULL)
 		return -1;
 
diff --git a/tools/perf/builtin-diff.c b/tools/perf/builtin-diff.c
index 0d52801..67328d1 100644
--- a/tools/perf/builtin-diff.c
+++ b/tools/perf/builtin-diff.c
@@ -21,8 +21,6 @@ static char	   const *input_old = "perf.data.old",
 static int	   force;
 static bool 	   show_percent;
 
-struct symbol_conf symbol_conf;
-
 static int perf_session__add_hist_entry(struct perf_session *self,
 					struct addr_location *al, u64 count)
 {
@@ -226,8 +224,8 @@ static int __cmd_diff(void)
 	int ret, i;
 	struct perf_session *session[2];
 
-	session[0] = perf_session__new(input_old, O_RDONLY, force, &symbol_conf);
-	session[1] = perf_session__new(input_new, O_RDONLY, force, &symbol_conf);
+	session[0] = perf_session__new(input_old, O_RDONLY, force);
+	session[1] = perf_session__new(input_new, O_RDONLY, force);
 	if (session[0] == NULL || session[1] == NULL)
 		return -ENOMEM;
 
@@ -267,7 +265,7 @@ static const struct option options[] = {
 
 int cmd_diff(int argc, const char **argv, const char *prefix __used)
 {
-	if (symbol__init(&symbol_conf) < 0)
+	if (symbol__init() < 0)
 		return -1;
 
 	setup_sorting(diff_usage, options);
diff --git a/tools/perf/builtin-kmem.c b/tools/perf/builtin-kmem.c
index dda6086..e078797 100644
--- a/tools/perf/builtin-kmem.c
+++ b/tools/perf/builtin-kmem.c
@@ -505,8 +505,7 @@ static void sort_result(void)
 static int __cmd_kmem(void)
 {
 	int err;
-	struct perf_session *session = perf_session__new(input_name, O_RDONLY,
-							 0, NULL);
+	struct perf_session *session = perf_session__new(input_name, O_RDONLY, 0);
 	if (session == NULL)
 		return -ENOMEM;
 
@@ -767,7 +766,7 @@ static int __cmd_record(int argc, const char **argv)
 
 int cmd_kmem(int argc, const char **argv, const char *prefix __used)
 {
-	symbol__init(0);
+	symbol__init();
 
 	argc = parse_options(argc, argv, kmem_options, kmem_usage, 0);
 
diff --git a/tools/perf/builtin-probe.c b/tools/perf/builtin-probe.c
index 520b064..7e741f5 100644
--- a/tools/perf/builtin-probe.c
+++ b/tools/perf/builtin-probe.c
@@ -57,7 +57,6 @@ static struct {
 	int nr_probe;
 	struct probe_point probes[MAX_PROBES];
 	struct strlist *dellist;
-	struct symbol_conf conf;
 	struct perf_session *psession;
 	struct map *kmap;
 } session;
@@ -151,7 +150,7 @@ static const struct option options[] = {
 	OPT_BOOLEAN('v', "verbose", &verbose,
 		    "be more verbose (show parsed arguments, etc)"),
 #ifndef NO_LIBDWARF
-	OPT_STRING('k', "vmlinux", &session.conf.vmlinux_name,
+	OPT_STRING('k', "vmlinux", &symbol_conf.vmlinux_name,
 		   "file", "vmlinux pathname"),
 #endif
 	OPT_BOOLEAN('l', "list", &session.list_events,
@@ -224,13 +223,12 @@ int cmd_probe(int argc, const char **argv, const char *prefix __used)
 	}
 
 	/* Initialize symbol maps for vmlinux */
-	session.conf.sort_by_name = true;
-	if (session.conf.vmlinux_name == NULL)
-		session.conf.try_vmlinux_path = true;
-	if (symbol__init(&session.conf) < 0)
+	symbol_conf.sort_by_name = true;
+	if (symbol_conf.vmlinux_name == NULL)
+		symbol_conf.try_vmlinux_path = true;
+	if (symbol__init() < 0)
 		die("Failed to init symbol map.");
-	session.psession = perf_session__new(NULL, O_WRONLY, false,
-					     &session.conf);
+	session.psession = perf_session__new(NULL, O_WRONLY, false);
 	if (session.psession == NULL)
 		die("Failed to init perf_session.");
 	session.kmap = map_groups__find_by_name(&session.psession->kmaps,
diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index 66979a5..1da48a8 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -451,7 +451,7 @@ static int __cmd_record(int argc, const char **argv)
 		exit(-1);
 	}
 
-	session = perf_session__new(output_name, O_WRONLY, force, NULL);
+	session = perf_session__new(output_name, O_WRONLY, force);
 	if (session == NULL) {
 		pr_err("Not enough memory for reading perf file header\n");
 		return -1;
@@ -632,7 +632,7 @@ int cmd_record(int argc, const char **argv, const char *prefix __used)
 {
 	int counter;
 
-	symbol__init(0);
+	symbol__init();
 
 	argc = parse_options(argc, argv, options, record_usage,
 		PARSE_OPT_STOP_AT_NON_OPTION);
diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index 40389c0..c349bdb 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -52,9 +52,6 @@ static int		exclude_other = 1;
 
 static char		callchain_default_opt[] = "fractal,0.5";
 
-static struct symbol_conf	symbol_conf;
-
-
 static size_t
 callchain__fprintf_left_margin(FILE *fp, int left_margin)
 {
@@ -705,7 +702,7 @@ static int __cmd_report(void)
 	int ret;
 	struct perf_session *session;
 
-	session = perf_session__new(input_name, O_RDONLY, force, &symbol_conf);
+	session = perf_session__new(input_name, O_RDONLY, force);
 	if (session == NULL)
 		return -ENOMEM;
 
@@ -864,7 +861,7 @@ static void setup_list(struct strlist **list, const char *list_str,
 
 int cmd_report(int argc, const char **argv, const char *prefix __used)
 {
-	if (symbol__init(&symbol_conf) < 0)
+	if (symbol__init() < 0)
 		return -1;
 
 	argc = parse_options(argc, argv, options, report_usage, 0);
diff --git a/tools/perf/builtin-sched.c b/tools/perf/builtin-sched.c
index d67f274..80209df 100644
--- a/tools/perf/builtin-sched.c
+++ b/tools/perf/builtin-sched.c
@@ -1675,8 +1675,7 @@ static struct perf_event_ops event_ops = {
 static int read_events(void)
 {
 	int err;
-	struct perf_session *session = perf_session__new(input_name, O_RDONLY,
-							 0, NULL);
+	struct perf_session *session = perf_session__new(input_name, O_RDONLY, 0);
 	if (session == NULL)
 		return -ENOMEM;
 
@@ -1912,7 +1911,7 @@ int cmd_sched(int argc, const char **argv, const char *prefix __used)
 	if (!strcmp(argv[0], "trace"))
 		return cmd_trace(argc, argv, prefix);
 
-	symbol__init(0);
+	symbol__init();
 	if (!strncmp(argv[0], "rec", 3)) {
 		return __cmd_record(argc, argv);
 	} else if (!strncmp(argv[0], "lat", 3)) {
diff --git a/tools/perf/builtin-timechart.c b/tools/perf/builtin-timechart.c
index ffd81e8..9c98b7a 100644
--- a/tools/perf/builtin-timechart.c
+++ b/tools/perf/builtin-timechart.c
@@ -1050,8 +1050,7 @@ static struct perf_event_ops event_ops = {
 
 static int __cmd_timechart(void)
 {
-	struct perf_session *session = perf_session__new(input_name, O_RDONLY,
-							 0, NULL);
+	struct perf_session *session = perf_session__new(input_name, O_RDONLY, 0);
 	int ret;
 
 	if (session == NULL)
@@ -1138,7 +1137,7 @@ static const struct option options[] = {
 
 int cmd_timechart(int argc, const char **argv, const char *prefix __used)
 {
-	symbol__init(0);
+	symbol__init();
 
 	argc = parse_options(argc, argv, options, timechart_usage,
 			PARSE_OPT_STOP_AT_NON_OPTION);
diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
index 296e809..cd89b6d 100644
--- a/tools/perf/builtin-top.c
+++ b/tools/perf/builtin-top.c
@@ -80,7 +80,6 @@ static int			dump_symtab                     =      0;
 static bool			hide_kernel_symbols		=  false;
 static bool			hide_user_symbols		=  false;
 static struct winsize		winsize;
-static struct symbol_conf	symbol_conf;
 
 /*
  * Source
@@ -1162,8 +1161,7 @@ static int __cmd_top(void)
 	 * FIXME: perf_session__new should allow passing a O_MMAP, so that all this
 	 * mmap reading, etc is encapsulated in it. Use O_WRONLY for now.
 	 */
-	struct perf_session *session = perf_session__new(NULL, O_WRONLY, false,
-							 &symbol_conf);
+	struct perf_session *session = perf_session__new(NULL, O_WRONLY, false);
 	if (session == NULL)
 		return -ENOMEM;
 
@@ -1284,7 +1282,7 @@ int cmd_top(int argc, const char **argv, const char *prefix __used)
 				 (nr_counters + 1) * sizeof(unsigned long));
 	if (symbol_conf.vmlinux_name == NULL)
 		symbol_conf.try_vmlinux_path = true;
-	if (symbol__init(&symbol_conf) < 0)
+	if (symbol__init() < 0)
 		return -1;
 
 	if (delay_secs < 1)
diff --git a/tools/perf/builtin-trace.c b/tools/perf/builtin-trace.c
index 7e744f7..07ad25c 100644
--- a/tools/perf/builtin-trace.c
+++ b/tools/perf/builtin-trace.c
@@ -579,7 +579,7 @@ int cmd_trace(int argc, const char **argv, const char *prefix __used)
 		exit(-1);
 	}
 
-	symbol__init(0);
+	symbol__init();
 
 	setup_scripting();
 
@@ -588,7 +588,7 @@ int cmd_trace(int argc, const char **argv, const char *prefix __used)
 
 	setup_pager();
 
-	session = perf_session__new(input_name, O_RDONLY, 0, NULL);
+	session = perf_session__new(input_name, O_RDONLY, 0);
 	if (session == NULL)
 		return -ENOMEM;
 
diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
index ecd54be..bceaa09 100644
--- a/tools/perf/util/session.c
+++ b/tools/perf/util/session.c
@@ -49,8 +49,7 @@ out_close:
 	return -1;
 }
 
-struct perf_session *perf_session__new(const char *filename, int mode,
-				       bool force, struct symbol_conf *conf)
+struct perf_session *perf_session__new(const char *filename, int mode, bool force)
 {
 	size_t len = filename ? strlen(filename) + 1 : 0;
 	struct perf_session *self = zalloc(sizeof(*self) + len);
@@ -69,7 +68,7 @@ struct perf_session *perf_session__new(const char *filename, int mode,
 	self->cwdlen = 0;
 	map_groups__init(&self->kmaps);
 
-	if (perf_session__create_kernel_maps(self, conf) < 0)
+	if (perf_session__create_kernel_maps(self) < 0)
 		goto out_delete;
 
 	if (mode == O_RDONLY && perf_session__open(self, force) < 0)
diff --git a/tools/perf/util/session.h b/tools/perf/util/session.h
index bdfc4b8..faf18a8 100644
--- a/tools/perf/util/session.h
+++ b/tools/perf/util/session.h
@@ -10,7 +10,6 @@
 struct ip_callchain;
 struct thread;
 struct symbol;
-struct symbol_conf;
 
 struct perf_session {
 	struct perf_header	header;
@@ -26,7 +25,6 @@ struct perf_session {
 	int			fd;
 	int			cwdlen;
 	char			*cwd;
-	bool			use_modules;
 	bool			use_callchain;
 	char filename[0];
 };
@@ -48,8 +46,7 @@ struct perf_event_ops {
 	bool		full_paths;
 };
 
-struct perf_session *perf_session__new(const char *filename, int mode,
-				       bool force, struct symbol_conf *conf);
+struct perf_session *perf_session__new(const char *filename, int mode, bool force);
 void perf_session__delete(struct perf_session *self);
 
 int perf_session__process_events(struct perf_session *self,
diff --git a/tools/perf/util/symbol.c b/tools/perf/util/symbol.c
index 185b9ee..17ce012 100644
--- a/tools/perf/util/symbol.c
+++ b/tools/perf/util/symbol.c
@@ -33,11 +33,10 @@ static void dsos__add(struct list_head *head, struct dso *dso);
 static struct map *map__new2(u64 start, struct dso *dso, enum map_type type);
 static int dso__load_kernel_sym(struct dso *self, struct map *map,
 				struct perf_session *session, symbol_filter_t filter);
-unsigned int symbol__priv_size;
 static int vmlinux_path__nr_entries;
 static char **vmlinux_path;
 
-static struct symbol_conf symbol_conf__defaults = {
+struct symbol_conf symbol_conf = {
 	.use_modules	  = true,
 	.try_vmlinux_path = true,
 };
@@ -130,13 +129,13 @@ static void map_groups__fixup_end(struct map_groups *self)
 static struct symbol *symbol__new(u64 start, u64 len, const char *name)
 {
 	size_t namelen = strlen(name) + 1;
-	struct symbol *self = zalloc(symbol__priv_size +
+	struct symbol *self = zalloc(symbol_conf.priv_size +
 				     sizeof(*self) + namelen);
 	if (self == NULL)
 		return NULL;
 
-	if (symbol__priv_size)
-		self = ((void *)self) + symbol__priv_size;
+	if (symbol_conf.priv_size)
+		self = ((void *)self) + symbol_conf.priv_size;
 
 	self->start = start;
 	self->end   = len ? start + len - 1 : start;
@@ -150,7 +149,7 @@ static struct symbol *symbol__new(u64 start, u64 len, const char *name)
 
 static void symbol__delete(struct symbol *self)
 {
-	free(((void *)self) - symbol__priv_size);
+	free(((void *)self) - symbol_conf.priv_size);
 }
 
 static size_t symbol__fprintf(struct symbol *self, FILE *fp)
@@ -471,7 +470,7 @@ static int dso__split_kallsyms(struct dso *self, struct map *map,
 
 		module = strchr(pos->name, '\t');
 		if (module) {
-			if (!session->use_modules)
+			if (!symbol_conf.use_modules)
 				goto discard_symbol;
 
 			*module++ = '\0';
@@ -1740,34 +1739,27 @@ out_fail:
 	return -1;
 }
 
-int symbol__init(struct symbol_conf *conf)
+int symbol__init(void)
 {
-	const struct symbol_conf *pconf = conf ?: &symbol_conf__defaults;
-
 	elf_version(EV_CURRENT);
-	symbol__priv_size = pconf->priv_size;
-	if (pconf->sort_by_name)
-		symbol__priv_size += (sizeof(struct symbol_name_rb_node) -
-				      sizeof(struct symbol));
+	if (symbol_conf.sort_by_name)
+		symbol_conf.priv_size += (sizeof(struct symbol_name_rb_node) -
+					  sizeof(struct symbol));
 
-	if (pconf->try_vmlinux_path && vmlinux_path__init() < 0)
+	if (symbol_conf.try_vmlinux_path && vmlinux_path__init() < 0)
 		return -1;
 
 	return 0;
 }
 
-int perf_session__create_kernel_maps(struct perf_session *self,
-				     struct symbol_conf *conf)
+int perf_session__create_kernel_maps(struct perf_session *self)
 {
-	const struct symbol_conf *pconf = conf ?: &symbol_conf__defaults;
-
 	if (map_groups__create_kernel_maps(&self->kmaps,
-					   pconf->vmlinux_name) < 0)
+					   symbol_conf.vmlinux_name) < 0)
 		return -1;
 
-	self->use_modules = pconf->use_modules;
-
-	if (pconf->use_modules && perf_session__create_module_maps(self) < 0)
+	if (symbol_conf.use_modules &&
+	    perf_session__create_module_maps(self) < 0)
 		pr_debug("Failed to load list of modules for session %s, "
 			 "continuing...\n", self->filename);
 	/*
diff --git a/tools/perf/util/symbol.h b/tools/perf/util/symbol.h
index 941ef33..7662947 100644
--- a/tools/perf/util/symbol.h
+++ b/tools/perf/util/symbol.h
@@ -57,11 +57,11 @@ struct symbol_conf {
 	const char	*vmlinux_name;
 };
 
-extern unsigned int symbol__priv_size;
+extern struct symbol_conf symbol_conf;
 
 static inline void *symbol__priv(struct symbol *self)
 {
-	return ((void *)self) - symbol__priv_size;
+	return ((void *)self) - symbol_conf.priv_size;
 }
 
 struct addr_location {
@@ -119,9 +119,8 @@ int sysfs__read_build_id(const char *filename, void *bf, size_t size);
 bool dsos__read_build_ids(void);
 int build_id__sprintf(u8 *self, int len, char *bf);
 
-int symbol__init(struct symbol_conf *conf);
-int perf_session__create_kernel_maps(struct perf_session *self,
-				     struct symbol_conf *conf);
+int symbol__init(void);
+int perf_session__create_kernel_maps(struct perf_session *self);
 
 extern struct list_head dsos__user, dsos__kernel;
 extern struct dso *vdso;
-- 
1.6.2.5

