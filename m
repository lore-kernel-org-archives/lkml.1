Return-Path: <linux-kernel-owner+w=401wt.eu-S1753144Ab0ATR27@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753144Ab0ATR27 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jan 2010 12:28:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752694Ab0ATR27
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jan 2010 12:28:59 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:39349 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752626Ab0ATR26 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jan 2010 12:28:58 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
       =?utf-8?q?Fr=C3=A9d=C3=A9ric=20Weisbecker?= <fweisbec@gmail.com>,
       Mike Galbraith <efault@gmx.de>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>
Subject: [PATCH 1/1] perf buildid-cache: Add new command to manage build-id cache
Date: Wed, 20 Jan 2010 15:28:45 -0200
Message-Id: <1264008525-29025-1-git-send-email-acme@infradead.org>
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

For now it just has operations to examine a given file, find its
build-id and add or remove it to/from the cache.

Useful, for instance, when adding binaries sent together with a
perf.data file, so that we can add them to the cache and have the tools
find it when resolving symbols.

It'll also manage the size of the cache like 'ccache' does.

Cc: Frédéric Weisbecker <fweisbec@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/Documentation/perf-buildid-cache.txt |   33 ++++++
 tools/perf/Makefile                             |    1 +
 tools/perf/builtin-buildid-cache.c              |  133 +++++++++++++++++++++++
 tools/perf/builtin.h                            |    1 +
 tools/perf/command-list.txt                     |    1 +
 tools/perf/perf.c                               |    1 +
 tools/perf/util/header.c                        |   72 +++++++++++--
 tools/perf/util/header.h                        |    5 +
 tools/perf/util/symbol.c                        |    4 +-
 tools/perf/util/symbol.h                        |    2 +-
 10 files changed, 241 insertions(+), 12 deletions(-)
 create mode 100644 tools/perf/Documentation/perf-buildid-cache.txt
 create mode 100644 tools/perf/builtin-buildid-cache.c

diff --git a/tools/perf/Documentation/perf-buildid-cache.txt b/tools/perf/Documentation/perf-buildid-cache.txt
new file mode 100644
index 0000000..88bc3b5
--- /dev/null
+++ b/tools/perf/Documentation/perf-buildid-cache.txt
@@ -0,0 +1,33 @@
+perf-buildid-cache(1)
+=====================
+
+NAME
+----
+perf-buildid-cache - Manage build-id cache.
+
+SYNOPSIS
+--------
+[verse]
+'perf buildid-list <options>'
+
+DESCRIPTION
+-----------
+This command manages the build-id cache. It can add and remove files to the
+cache. In the future it should as well purge older entries, set upper limits
+for the space used by the cache, etc.
+
+OPTIONS
+-------
+-a::
+--add=::
+        Add specified file to the cache.
+-r::
+--remove=::
+        Remove specified file to the cache.
+-v::
+--verbose::
+	Be more verbose.
+
+SEE ALSO
+--------
+linkperf:perf-record[1], linkperf:perf-report[1]
diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index ddbeeee..9b173e6 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -445,6 +445,7 @@ BUILTIN_OBJS += builtin-diff.o
 BUILTIN_OBJS += builtin-help.o
 BUILTIN_OBJS += builtin-sched.o
 BUILTIN_OBJS += builtin-buildid-list.o
+BUILTIN_OBJS += builtin-buildid-cache.o
 BUILTIN_OBJS += builtin-list.o
 BUILTIN_OBJS += builtin-record.o
 BUILTIN_OBJS += builtin-report.o
diff --git a/tools/perf/builtin-buildid-cache.c b/tools/perf/builtin-buildid-cache.c
new file mode 100644
index 0000000..30a05f5
--- /dev/null
+++ b/tools/perf/builtin-buildid-cache.c
@@ -0,0 +1,133 @@
+/*
+ * builtin-buildid-cache.c
+ *
+ * Builtin buildid-cache command: Manages build-id cache
+ *
+ * Copyright (C) 2010, Red Hat Inc.
+ * Copyright (C) 2010, Arnaldo Carvalho de Melo <acme@redhat.com>
+ */
+#include "builtin.h"
+#include "perf.h"
+#include "util/cache.h"
+#include "util/debug.h"
+#include "util/header.h"
+#include "util/parse-options.h"
+#include "util/strlist.h"
+#include "util/symbol.h"
+
+static char const *add_name_list_str, *remove_name_list_str;
+
+static const char * const buildid_cache_usage[] = {
+	"perf buildid-cache [<options>]",
+	NULL
+};
+
+static const struct option buildid_cache_options[] = {
+	OPT_STRING('a', "add", &add_name_list_str,
+		   "file list", "file(s) to add"),
+	OPT_STRING('r', "remove", &remove_name_list_str, "file list",
+		    "file(s) to remove"),
+	OPT_BOOLEAN('v', "verbose", &verbose, "be more verbose"),
+	OPT_END()
+};
+
+static int build_id_cache__add_file(const char *filename, const char *debugdir)
+{
+	char sbuild_id[BUILD_ID_SIZE * 2 + 1];
+	u8 build_id[BUILD_ID_SIZE];
+	int err;
+
+	if (filename__read_build_id(filename, &build_id, sizeof(build_id)) < 0) {
+		pr_debug("Couldn't read a build-id in %s\n", filename);
+		return -1;
+	}
+
+	build_id__sprintf(build_id, sizeof(build_id), sbuild_id);
+	err = build_id_cache__add_s(sbuild_id, debugdir, filename, false);
+	if (verbose)
+		pr_info("Adding %s %s: %s\n", sbuild_id, filename,
+			err ? "FAIL" : "Ok");
+	return err;
+}
+
+static int build_id_cache__remove_file(const char *filename __used,
+				       const char *debugdir __used)
+{
+	u8 build_id[BUILD_ID_SIZE];
+	char sbuild_id[BUILD_ID_SIZE * 2 + 1];
+
+	int err;
+
+	if (filename__read_build_id(filename, &build_id, sizeof(build_id)) < 0) {
+		pr_debug("Couldn't read a build-id in %s\n", filename);
+		return -1;
+	}
+
+	build_id__sprintf(build_id, sizeof(build_id), sbuild_id);
+	err = build_id_cache__remove_s(sbuild_id, debugdir);
+	if (verbose)
+		pr_info("Removing %s %s: %s\n", sbuild_id, filename,
+			err ? "FAIL" : "Ok");
+
+	return err;
+}
+
+static int __cmd_buildid_cache(void)
+{
+	struct strlist *list;
+	struct str_node *pos;
+	char debugdir[PATH_MAX];
+
+	snprintf(debugdir, sizeof(debugdir), "%s/%s", getenv("HOME"),
+		 DEBUG_CACHE_DIR);
+
+	if (add_name_list_str) {
+		list = strlist__new(true, add_name_list_str);
+		if (list) {
+			strlist__for_each(pos, list)
+				if (build_id_cache__add_file(pos->s, debugdir)) {
+					if (errno == EEXIST) {
+						pr_debug("%s already in the cache\n",
+							 pos->s);
+						continue;
+					}
+					pr_warning("Couldn't add %s: %s\n",
+						   pos->s, strerror(errno));
+				}
+
+			strlist__delete(list);
+		}
+	}
+
+	if (remove_name_list_str) {
+		list = strlist__new(true, remove_name_list_str);
+		if (list) {
+			strlist__for_each(pos, list)
+				if (build_id_cache__remove_file(pos->s, debugdir)) {
+					if (errno == ENOENT) {
+						pr_debug("%s wasn't in the cache\n",
+							 pos->s);
+						continue;
+					}
+					pr_warning("Couldn't remove %s: %s\n",
+						   pos->s, strerror(errno));
+				}
+
+			strlist__delete(list);
+		}
+	}
+
+	return 0;
+}
+
+int cmd_buildid_cache(int argc, const char **argv, const char *prefix __used)
+{
+	argc = parse_options(argc, argv, buildid_cache_options,
+			     buildid_cache_usage, 0);
+
+	if (symbol__init() < 0)
+		return -1;
+
+	setup_pager();
+	return __cmd_buildid_cache();
+}
diff --git a/tools/perf/builtin.h b/tools/perf/builtin.h
index 18035b1..dee97cf 100644
--- a/tools/perf/builtin.h
+++ b/tools/perf/builtin.h
@@ -16,6 +16,7 @@ extern int check_pager_config(const char *cmd);
 
 extern int cmd_annotate(int argc, const char **argv, const char *prefix);
 extern int cmd_bench(int argc, const char **argv, const char *prefix);
+extern int cmd_buildid_cache(int argc, const char **argv, const char *prefix);
 extern int cmd_buildid_list(int argc, const char **argv, const char *prefix);
 extern int cmd_diff(int argc, const char **argv, const char *prefix);
 extern int cmd_help(int argc, const char **argv, const char *prefix);
diff --git a/tools/perf/command-list.txt b/tools/perf/command-list.txt
index cf6444d..9afcff2 100644
--- a/tools/perf/command-list.txt
+++ b/tools/perf/command-list.txt
@@ -5,6 +5,7 @@
 perf-annotate			mainporcelain common
 perf-archive			mainporcelain common
 perf-bench			mainporcelain common
+perf-buildid-cache		mainporcelain common
 perf-buildid-list		mainporcelain common
 perf-diff			mainporcelain common
 perf-list			mainporcelain common
diff --git a/tools/perf/perf.c b/tools/perf/perf.c
index fc89005..05c861c 100644
--- a/tools/perf/perf.c
+++ b/tools/perf/perf.c
@@ -285,6 +285,7 @@ static void handle_internal_command(int argc, const char **argv)
 {
 	const char *cmd = argv[0];
 	static struct cmd_struct commands[] = {
+		{ "buildid-cache", cmd_buildid_cache, 0 },
 		{ "buildid-list", cmd_buildid_list, 0 },
 		{ "diff",	cmd_diff,	0 },
 		{ "help",	cmd_help,	0 },
diff --git a/tools/perf/util/header.c b/tools/perf/util/header.c
index 1b65fed..2bb2bdb 100644
--- a/tools/perf/util/header.c
+++ b/tools/perf/util/header.c
@@ -231,32 +231,29 @@ static int dsos__write_buildid_table(int fd)
 	return err;
 }
 
-static int dso__cache_build_id(struct dso *self, const char *debugdir)
+int build_id_cache__add_s(const char *sbuild_id, const char *debugdir,
+			  const char *name, bool is_kallsyms)
 {
 	const size_t size = PATH_MAX;
 	char *filename = malloc(size),
-	     *linkname = malloc(size), *targetname, *sbuild_id;
+	     *linkname = malloc(size), *targetname;
 	int len, err = -1;
-	bool is_kallsyms = self->kernel && self->long_name[0] != '/';
 
 	if (filename == NULL || linkname == NULL)
 		goto out_free;
 
 	len = snprintf(filename, size, "%s%s%s",
-		       debugdir, is_kallsyms ? "/" : "", self->long_name);
+		       debugdir, is_kallsyms ? "/" : "", name);
 	if (mkdir_p(filename, 0755))
 		goto out_free;
 
-	len += snprintf(filename + len, sizeof(filename) - len, "/");
-	sbuild_id = filename + len;
-	build_id__sprintf(self->build_id, sizeof(self->build_id), sbuild_id);
+	snprintf(filename + len, sizeof(filename) - len, "/%s", sbuild_id);
 
 	if (access(filename, F_OK)) {
 		if (is_kallsyms) {
 			 if (copyfile("/proc/kallsyms", filename))
 				goto out_free;
-		} else if (link(self->long_name, filename) &&
-			   copyfile(self->long_name, filename))
+		} else if (link(name, filename) && copyfile(name, filename))
 			goto out_free;
 	}
 
@@ -278,6 +275,63 @@ out_free:
 	return err;
 }
 
+static int build_id_cache__add_b(const u8 *build_id, size_t build_id_size,
+				 const char *name, const char *debugdir,
+				 bool is_kallsyms)
+{
+	char sbuild_id[BUILD_ID_SIZE * 2 + 1];
+
+	build_id__sprintf(build_id, build_id_size, sbuild_id);
+
+	return build_id_cache__add_s(sbuild_id, debugdir, name, is_kallsyms);
+}
+
+int build_id_cache__remove_s(const char *sbuild_id, const char *debugdir)
+{
+	const size_t size = PATH_MAX;
+	char *filename = malloc(size),
+	     *linkname = malloc(size);
+	int err = -1;
+
+	if (filename == NULL || linkname == NULL)
+		goto out_free;
+
+	snprintf(linkname, size, "%s/.build-id/%.2s/%s",
+		 debugdir, sbuild_id, sbuild_id + 2);
+
+	if (access(linkname, F_OK))
+		goto out_free;
+
+	if (readlink(linkname, filename, size) < 0)
+		goto out_free;
+
+	if (unlink(linkname))
+		goto out_free;
+
+	/*
+	 * Since the link is relative, we must make it absolute:
+	 */
+	snprintf(linkname, size, "%s/.build-id/%.2s/%s",
+		 debugdir, sbuild_id, filename);
+
+	if (unlink(linkname))
+		goto out_free;
+
+	err = 0;
+out_free:
+	free(filename);
+	free(linkname);
+	return err;
+}
+
+static int dso__cache_build_id(struct dso *self, const char *debugdir)
+{
+	bool is_kallsyms = self->kernel && self->long_name[0] != '/';
+
+	return build_id_cache__add_b(self->build_id, sizeof(self->build_id),
+				     self->long_name, debugdir, is_kallsyms);
+}
+
 static int __dsos__cache_build_ids(struct list_head *head, const char *debugdir)
 {
 	struct dso *pos;
diff --git a/tools/perf/util/header.h b/tools/perf/util/header.h
index ccc8540..82a6af7 100644
--- a/tools/perf/util/header.h
+++ b/tools/perf/util/header.h
@@ -5,6 +5,7 @@
 #include <sys/types.h>
 #include <stdbool.h>
 #include "types.h"
+#include "event.h"
 
 #include <linux/bitmap.h>
 
@@ -84,4 +85,8 @@ int perf_header__process_sections(struct perf_header *self, int fd,
 						 struct perf_header *ph,
 						 int feat, int fd));
 
+int build_id_cache__add_s(const char *sbuild_id, const char *debugdir,
+			  const char *name, bool is_kallsyms);
+int build_id_cache__remove_s(const char *sbuild_id, const char *debugdir);
+
 #endif /* __PERF_HEADER_H */
diff --git a/tools/perf/util/symbol.c b/tools/perf/util/symbol.c
index b6ab23d..6f30fe1 100644
--- a/tools/perf/util/symbol.c
+++ b/tools/perf/util/symbol.c
@@ -345,10 +345,10 @@ void dso__sort_by_name(struct dso *self, enum map_type type)
 				     &self->symbols[type]);
 }
 
-int build_id__sprintf(u8 *self, int len, char *bf)
+int build_id__sprintf(const u8 *self, int len, char *bf)
 {
 	char *bid = bf;
-	u8 *raw = self;
+	const u8 *raw = self;
 	int i;
 
 	for (i = 0; i < len; ++i) {
diff --git a/tools/perf/util/symbol.h b/tools/perf/util/symbol.h
index 525085f..ffe0b0f 100644
--- a/tools/perf/util/symbol.h
+++ b/tools/perf/util/symbol.h
@@ -144,7 +144,7 @@ struct symbol *dso__find_symbol_by_name(struct dso *self, enum map_type type,
 int filename__read_build_id(const char *filename, void *bf, size_t size);
 int sysfs__read_build_id(const char *filename, void *bf, size_t size);
 bool dsos__read_build_ids(void);
-int build_id__sprintf(u8 *self, int len, char *bf);
+int build_id__sprintf(const u8 *self, int len, char *bf);
 int kallsyms__parse(const char *filename, void *arg,
 		    int (*process_symbol)(void *arg, const char *name,
 					  char type, u64 start));
-- 
1.6.2.5

