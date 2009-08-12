Return-Path: <linux-kernel-owner+w=401wt.eu-S1755274AbZHLJ0N@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755274AbZHLJ0N (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Aug 2009 05:26:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755208AbZHLJ0M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Aug 2009 05:26:12 -0400
Received: from mail-ew0-f214.google.com ([209.85.219.214]:34601 "EHLO
	mail-ew0-f214.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754762AbZHLJ0I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Aug 2009 05:26:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=dLSG7pPPkbWTSCmpPQqGlH2KhpVsGErns9g373p8bj4+l71HyvCxGRadUXTLU85l83
         yAJx4L8PtHvZHb+Hxee5nvK6C1Mq2acq2m6luCgoDuNcjsJNkaNoRdu0i2w56ebnX/Gf
         3Lil5WhuRlTWAeRLJ1kT8F2NeBFLbeIDNShNg=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Peter Zijlstra <peterz@infradead.org>, Mike Galbraith <efault@gmx.de>,
       Brice Goglin <Brice.Goglin@inria.fr>
Subject: [PATCH 1/3] perf tools: Factorize high level dso helpers
Date: Wed, 12 Aug 2009 11:26:00 +0200
Message-Id: <1250069162-13099-2-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
In-Reply-To: <1250069162-13099-1-git-send-email-fweisbec@gmail.com>
References: <1250069162-13099-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Factorize multiple definitions of high level dso helpers into the
symbol source file.

The side effect is a general export of the verbose and eprintf
debugging helpers into a new file dedicated to debugging purposes.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Brice Goglin <Brice.Goglin@inria.fr>
---
 tools/perf/Makefile           |    1 +
 tools/perf/builtin-annotate.c |   96 ----------------------------------------
 tools/perf/builtin-record.c   |    1 -
 tools/perf/builtin-report.c   |   97 -----------------------------------------
 tools/perf/builtin-stat.c     |    1 -
 tools/perf/builtin-top.c      |    4 --
 tools/perf/builtin.h          |    1 +
 tools/perf/perf.h             |    1 +
 tools/perf/util/symbol.c      |   97 +++++++++++++++++++++++++++++++++++++++++
 tools/perf/util/symbol.h      |   11 +++++
 10 files changed, 111 insertions(+), 199 deletions(-)

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index de7beac..2aee21b 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -339,6 +339,7 @@ LIB_OBJS += util/pager.o
 LIB_OBJS += util/header.o
 LIB_OBJS += util/callchain.o
 LIB_OBJS += util/values.o
+LIB_OBJS += util/debug.o
 
 BUILTIN_OBJS += builtin-annotate.o
 BUILTIN_OBJS += builtin-help.o
diff --git a/tools/perf/builtin-annotate.c b/tools/perf/builtin-annotate.c
index 1dba568..1a79299 100644
--- a/tools/perf/builtin-annotate.c
+++ b/tools/perf/builtin-annotate.c
@@ -26,7 +26,6 @@
 #define SHOW_HV		4
 
 static char		const *input_name = "perf.data";
-static char		*vmlinux = "vmlinux";
 
 static char		default_sort_order[] = "comm,symbol";
 static char		*sort_order = default_sort_order;
@@ -37,9 +36,6 @@ static int		show_mask = SHOW_KERNEL | SHOW_USER | SHOW_HV;
 static int		dump_trace = 0;
 #define dprintf(x...)	do { if (dump_trace) printf(x); } while (0)
 
-static int		verbose;
-
-static int		modules;
 
 static int		full_paths;
 
@@ -89,98 +85,6 @@ struct sym_ext {
 	char		*path;
 };
 
-static LIST_HEAD(dsos);
-static struct dso *kernel_dso;
-static struct dso *vdso;
-
-
-static void dsos__add(struct dso *dso)
-{
-	list_add_tail(&dso->node, &dsos);
-}
-
-static struct dso *dsos__find(const char *name)
-{
-	struct dso *pos;
-
-	list_for_each_entry(pos, &dsos, node)
-		if (strcmp(pos->name, name) == 0)
-			return pos;
-	return NULL;
-}
-
-static struct dso *dsos__findnew(const char *name)
-{
-	struct dso *dso = dsos__find(name);
-	int nr;
-
-	if (dso)
-		return dso;
-
-	dso = dso__new(name, 0);
-	if (!dso)
-		goto out_delete_dso;
-
-	nr = dso__load(dso, NULL, verbose);
-	if (nr < 0) {
-		if (verbose)
-			fprintf(stderr, "Failed to open: %s\n", name);
-		goto out_delete_dso;
-	}
-	if (!nr && verbose) {
-		fprintf(stderr,
-		"No symbols found in: %s, maybe install a debug package?\n",
-				name);
-	}
-
-	dsos__add(dso);
-
-	return dso;
-
-out_delete_dso:
-	dso__delete(dso);
-	return NULL;
-}
-
-static void dsos__fprintf(FILE *fp)
-{
-	struct dso *pos;
-
-	list_for_each_entry(pos, &dsos, node)
-		dso__fprintf(pos, fp);
-}
-
-static struct symbol *vdso__find_symbol(struct dso *dso, u64 ip)
-{
-	return dso__find_symbol(dso, ip);
-}
-
-static int load_kernel(void)
-{
-	int err;
-
-	kernel_dso = dso__new("[kernel]", 0);
-	if (!kernel_dso)
-		return -1;
-
-	err = dso__load_kernel(kernel_dso, vmlinux, NULL, verbose, modules);
-	if (err <= 0) {
-		dso__delete(kernel_dso);
-		kernel_dso = NULL;
-	} else
-		dsos__add(kernel_dso);
-
-	vdso = dso__new("[vdso]", 0);
-	if (!vdso)
-		return -1;
-
-	vdso->find_symbol = vdso__find_symbol;
-
-	dsos__add(vdso);
-
-	return err;
-}
-
 struct map {
 	struct list_head node;
 	u64	 start;
diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index 0345aad..afae387 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -40,7 +40,6 @@ static int			inherit				= 1;
 static int			force				= 0;
 static int			append_file			= 0;
 static int			call_graph			= 0;
-static int			verbose				= 0;
 static int			inherit_stat			= 0;
 static int			no_samples			= 0;
 static int			sample_address			= 0;
diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index 2357c66..827eab2 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -30,7 +30,6 @@
 #define SHOW_HV		4
 
 static char		const *input_name = "perf.data";
-static char		*vmlinux = NULL;
 
 static char		default_sort_order[] = "comm,dso,symbol";
 static char		*sort_order = default_sort_order;
@@ -46,11 +45,6 @@ static int		dump_trace = 0;
 #define dprintf(x...)	do { if (dump_trace) printf(x); } while (0)
 #define cdprintf(x...)	do { if (dump_trace) color_fprintf(stdout, color, x); } while (0)
 
-static int		verbose;
-#define eprintf(x...)	do { if (verbose) fprintf(stderr, x); } while (0)
-
-static int		modules;
-
 static int		full_paths;
 static int		show_nr_samples;
 
@@ -161,98 +155,7 @@ static int repsep_fprintf(FILE *fp, const char *fmt, ...)
 	return n;
 }
 
-static LIST_HEAD(dsos);
-static struct dso *kernel_dso;
-static struct dso *vdso;
-static struct dso *hypervisor_dso;
-
-static void dsos__add(struct dso *dso)
-{
-	list_add_tail(&dso->node, &dsos);
-}
-
-static struct dso *dsos__find(const char *name)
-{
-	struct dso *pos;
-
-	list_for_each_entry(pos, &dsos, node)
-		if (strcmp(pos->name, name) == 0)
-			return pos;
-	return NULL;
-}
-
-static struct dso *dsos__findnew(const char *name)
-{
-	struct dso *dso = dsos__find(name);
-	int nr;
-
-	if (dso)
-		return dso;
-
-	dso = dso__new(name, 0);
-	if (!dso)
-		goto out_delete_dso;
-
-	nr = dso__load(dso, NULL, verbose);
-	if (nr < 0) {
-		eprintf("Failed to open: %s\n", name);
-		goto out_delete_dso;
-	}
-	if (!nr)
-		eprintf("No symbols found in: %s, maybe install a debug package?\n", name);
-
-	dsos__add(dso);
-
-	return dso;
-
-out_delete_dso:
-	dso__delete(dso);
-	return NULL;
-}
-
-static void dsos__fprintf(FILE *fp)
-{
-	struct dso *pos;
-
-	list_for_each_entry(pos, &dsos, node)
-		dso__fprintf(pos, fp);
-}
-
-static struct symbol *vdso__find_symbol(struct dso *dso, u64 ip)
-{
-	return dso__find_symbol(dso, ip);
-}
-
-static int load_kernel(void)
-{
-	int err;
-
-	kernel_dso = dso__new("[kernel]", 0);
-	if (!kernel_dso)
-		return -1;
-
-	err = dso__load_kernel(kernel_dso, vmlinux, NULL, verbose, modules);
-	if (err <= 0) {
-		dso__delete(kernel_dso);
-		kernel_dso = NULL;
-	} else
-		dsos__add(kernel_dso);
-
-	vdso = dso__new("[vdso]", 0);
-	if (!vdso)
-		return -1;
 
-	vdso->find_symbol = vdso__find_symbol;
-
-	dsos__add(vdso);
-
-	hypervisor_dso = dso__new("[hypervisor]", 0);
-	if (!hypervisor_dso)
-		return -1;
-	dsos__add(hypervisor_dso);
-
-	return err;
-}
 
 static char __cwd[PATH_MAX];
 static char *cwd = __cwd;
diff --git a/tools/perf/builtin-stat.c b/tools/perf/builtin-stat.c
index b4b06c7..4b9dd4a 100644
--- a/tools/perf/builtin-stat.c
+++ b/tools/perf/builtin-stat.c
@@ -63,7 +63,6 @@ static struct perf_counter_attr default_attrs[] = {
 #define MAX_RUN			100
 
 static int			system_wide			=  0;
-static int			verbose				=  0;
 static unsigned int		nr_cpus				=  0;
 static int			run_idx				=  0;
 
diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
index 7de28ce..0aa5673 100644
--- a/tools/perf/builtin-top.c
+++ b/tools/perf/builtin-top.c
@@ -68,8 +68,6 @@ static int			group				=  0;
 static unsigned int		page_size;
 static unsigned int		mmap_pages			= 16;
 static int			freq				=  0;
-static int			verbose				=  0;
-static char			*vmlinux			=  NULL;
 
 static int			delay_secs			=  2;
 static int			zero;
@@ -338,8 +336,6 @@ static void show_details(struct sym_entry *syme)
 		printf("%d lines not displayed, maybe increase display entries [e]\n", more);
 }
 
-struct dso			*kernel_dso;
-
 /*
  * Symbols will be added here in record_ip and will get out
  * after decayed.
diff --git a/tools/perf/builtin.h b/tools/perf/builtin.h
index 51d1682..3a63e41 100644
--- a/tools/perf/builtin.h
+++ b/tools/perf/builtin.h
@@ -22,5 +22,6 @@ extern int cmd_stat(int argc, const char **argv, const char *prefix);
 extern int cmd_top(int argc, const char **argv, const char *prefix);
 extern int cmd_version(int argc, const char **argv, const char *prefix);
 extern int cmd_list(int argc, const char **argv, const char *prefix);
+extern int cmd_trace(int argc, const char **argv, const char *prefix);
 
 #endif
diff --git a/tools/perf/perf.h b/tools/perf/perf.h
index e5148e2..f550921 100644
--- a/tools/perf/perf.h
+++ b/tools/perf/perf.h
@@ -48,6 +48,7 @@
 
 #include "../../include/linux/perf_counter.h"
 #include "util/types.h"
+#include "util/debug.h"
 
 /*
  * prctl(PR_TASK_PERF_COUNTERS_DISABLE) will (cheaply) disable all
diff --git a/tools/perf/util/symbol.c b/tools/perf/util/symbol.c
index f1dcede..e9b13b4 100644
--- a/tools/perf/util/symbol.c
+++ b/tools/perf/util/symbol.c
@@ -937,6 +937,103 @@ int dso__load_kernel(struct dso *self, const char *vmlinux,
 	return err;
 }
 
+LIST_HEAD(dsos);
+struct dso	*kernel_dso;
+struct dso	*vdso;
+struct dso	*hypervisor_dso;
+
+char		*vmlinux = "vmlinux";
+int		modules;
+
+static void dsos__add(struct dso *dso)
+{
+	list_add_tail(&dso->node, &dsos);
+}
+
+static struct dso *dsos__find(const char *name)
+{
+	struct dso *pos;
+
+	list_for_each_entry(pos, &dsos, node)
+		if (strcmp(pos->name, name) == 0)
+			return pos;
+	return NULL;
+}
+
+struct dso *dsos__findnew(const char *name)
+{
+	struct dso *dso = dsos__find(name);
+	int nr;
+
+	if (dso)
+		return dso;
+
+	dso = dso__new(name, 0);
+	if (!dso)
+		goto out_delete_dso;
+
+	nr = dso__load(dso, NULL, verbose);
+	if (nr < 0) {
+		eprintf("Failed to open: %s\n", name);
+		goto out_delete_dso;
+	}
+	if (!nr)
+		eprintf("No symbols found in: %s, maybe install a debug package?\n", name);
+
+	dsos__add(dso);
+
+	return dso;
+
+out_delete_dso:
+	dso__delete(dso);
+	return NULL;
+}
+
+void dsos__fprintf(FILE *fp)
+{
+	struct dso *pos;
+
+	list_for_each_entry(pos, &dsos, node)
+		dso__fprintf(pos, fp);
+}
+
+static struct symbol *vdso__find_symbol(struct dso *dso, u64 ip)
+{
+	return dso__find_symbol(dso, ip);
+}
+
+int load_kernel(void)
+{
+	int err;
+
+	kernel_dso = dso__new("[kernel]", 0);
+	if (!kernel_dso)
+		return -1;
+
+	err = dso__load_kernel(kernel_dso, vmlinux, NULL, verbose, modules);
+	if (err <= 0) {
+		dso__delete(kernel_dso);
+		kernel_dso = NULL;
+	} else
+		dsos__add(kernel_dso);
+
+	vdso = dso__new("[vdso]", 0);
+	if (!vdso)
+		return -1;
+
+	vdso->find_symbol = vdso__find_symbol;
+
+	dsos__add(vdso);
+
+	hypervisor_dso = dso__new("[hypervisor]", 0);
+	if (!hypervisor_dso)
+		return -1;
+	dsos__add(hypervisor_dso);
+
+	return err;
+}
+
+
 void symbol__init(void)
 {
 	elf_version(EV_CURRENT);
diff --git a/tools/perf/util/symbol.h b/tools/perf/util/symbol.h
index 1e003ec..f3490fc 100644
--- a/tools/perf/util/symbol.h
+++ b/tools/perf/util/symbol.h
@@ -48,9 +48,20 @@ int dso__load_kernel(struct dso *self, const char *vmlinux,
 		     symbol_filter_t filter, int verbose, int modules);
 int dso__load_modules(struct dso *self, symbol_filter_t filter, int verbose);
 int dso__load(struct dso *self, symbol_filter_t filter, int verbose);
+struct dso *dsos__findnew(const char *name);
+void dsos__fprintf(FILE *fp);
 
 size_t dso__fprintf(struct dso *self, FILE *fp);
 char dso__symtab_origin(const struct dso *self);
 
+int load_kernel(void);
+
 void symbol__init(void);
+
+extern struct list_head dsos;
+extern struct dso *kernel_dso;
+extern struct dso *vdso;
+extern struct dso *hypervisor_dso;
+extern char *vmlinux;
+extern int   modules;
 #endif /* _PERF_SYMBOL_ */
-- 
1.6.2.3

