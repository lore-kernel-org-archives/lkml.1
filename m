Return-Path: <linux-kernel-owner+w=401wt.eu-S932318Ab0ANUan@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932318Ab0ANUan (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jan 2010 15:30:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756094Ab0ANUaS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jan 2010 15:30:18 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:39103 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755739Ab0ANUaR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jan 2010 15:30:17 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
       =?utf-8?q?Fr=C3=A9d=C3=A9ric=20Weisbecker?= <fweisbec@gmail.com>,
       Mike Galbraith <efault@gmx.de>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>
Subject: [PATCH 3/3] perf symbols: Cache /proc/kallsyms files by build-id
Date: Thu, 14 Jan 2010 18:30:06 -0200
Message-Id: <1263501006-14185-3-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1263501006-14185-1-git-send-email-acme@infradead.org>
References: <1263501006-14185-1-git-send-email-acme@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

So that when we don't have a vmlinux handy we can store the kallsyms for
later use by 'perf report'.

Cc: Frédéric Weisbecker <fweisbec@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/event.c  |    2 +-
 tools/perf/util/header.c |   15 ++++++++++---
 tools/perf/util/symbol.c |   48 +++++++++++++++++++++++++++++++++------------
 tools/perf/util/symbol.h |    5 ++-
 tools/perf/util/util.c   |   30 ++++++++++++++++++++++++++++
 5 files changed, 80 insertions(+), 20 deletions(-)

diff --git a/tools/perf/util/event.c b/tools/perf/util/event.c
index 24ec5be..0e9820a 100644
--- a/tools/perf/util/event.c
+++ b/tools/perf/util/event.c
@@ -245,7 +245,7 @@ int event__synthesize_kernel_mmap(event__handler_t process,
 	 */
 	struct process_symbol_args args = { .name = symbol_name, };
 
-	if (kallsyms__parse(&args, find_symbol_cb) <= 0)
+	if (kallsyms__parse("/proc/kallsyms", &args, find_symbol_cb) <= 0)
 		return -ENOENT;
 
 	size = snprintf(ev.mmap.filename, sizeof(ev.mmap.filename),
diff --git a/tools/perf/util/header.c b/tools/perf/util/header.c
index b31e0ae..1b65fed 100644
--- a/tools/perf/util/header.c
+++ b/tools/perf/util/header.c
@@ -237,11 +237,13 @@ static int dso__cache_build_id(struct dso *self, const char *debugdir)
 	char *filename = malloc(size),
 	     *linkname = malloc(size), *targetname, *sbuild_id;
 	int len, err = -1;
+	bool is_kallsyms = self->kernel && self->long_name[0] != '/';
 
 	if (filename == NULL || linkname == NULL)
 		goto out_free;
 
-	len = snprintf(filename, size, "%s%s", debugdir, self->long_name);
+	len = snprintf(filename, size, "%s%s%s",
+		       debugdir, is_kallsyms ? "/" : "", self->long_name);
 	if (mkdir_p(filename, 0755))
 		goto out_free;
 
@@ -249,9 +251,14 @@ static int dso__cache_build_id(struct dso *self, const char *debugdir)
 	sbuild_id = filename + len;
 	build_id__sprintf(self->build_id, sizeof(self->build_id), sbuild_id);
 
-	if (access(filename, F_OK) && link(self->long_name, filename) &&
-	    copyfile(self->long_name, filename))
-		goto out_free;
+	if (access(filename, F_OK)) {
+		if (is_kallsyms) {
+			 if (copyfile("/proc/kallsyms", filename))
+				goto out_free;
+		} else if (link(self->long_name, filename) &&
+			   copyfile(self->long_name, filename))
+			goto out_free;
+	}
 
 	len = snprintf(linkname, size, "%s/.build-id/%.2s",
 		       debugdir, sbuild_id);
diff --git a/tools/perf/util/symbol.c b/tools/perf/util/symbol.c
index 71d23e1..ae61e9f 100644
--- a/tools/perf/util/symbol.c
+++ b/tools/perf/util/symbol.c
@@ -383,13 +383,14 @@ size_t dso__fprintf(struct dso *self, enum map_type type, FILE *fp)
 	return ret;
 }
 
-int kallsyms__parse(void *arg, int (*process_symbol)(void *arg, const char *name,
+int kallsyms__parse(const char *filename, void *arg,
+		    int (*process_symbol)(void *arg, const char *name,
 						     char type, u64 start))
 {
 	char *line = NULL;
 	size_t n;
 	int err = 0;
-	FILE *file = fopen("/proc/kallsyms", "r");
+	FILE *file = fopen(filename, "r");
 
 	if (file == NULL)
 		goto out_failure;
@@ -466,10 +467,11 @@ static int map__process_kallsym_symbol(void *arg, const char *name,
  * so that we can in the next step set the symbol ->end address and then
  * call kernel_maps__split_kallsyms.
  */
-static int dso__load_all_kallsyms(struct dso *self, struct map *map)
+static int dso__load_all_kallsyms(struct dso *self, const char *filename,
+				  struct map *map)
 {
 	struct process_kallsyms_args args = { .map = map, .dso = self, };
-	return kallsyms__parse(&args, map__process_kallsym_symbol);
+	return kallsyms__parse(filename, &args, map__process_kallsym_symbol);
 }
 
 /*
@@ -556,10 +558,10 @@ discard_symbol:		rb_erase(&pos->rb_node, root);
 }
 
 
-static int dso__load_kallsyms(struct dso *self, struct map *map,
+static int dso__load_kallsyms(struct dso *self, const char *filename, struct map *map,
 			      struct perf_session *session, symbol_filter_t filter)
 {
-	if (dso__load_all_kallsyms(self, map) < 0)
+	if (dso__load_all_kallsyms(self, filename, map) < 0)
 		return -1;
 
 	symbols__fixup_end(&self->symbols[map->type]);
@@ -1580,7 +1582,8 @@ static int dso__load_kernel_sym(struct dso *self, struct map *map,
 				struct perf_session *session, symbol_filter_t filter)
 {
 	int err;
-	bool is_kallsyms;
+	const char *kallsyms_filename = NULL;
+	char *kallsyms_allocated_filename = NULL;
 
 	if (vmlinux_path != NULL) {
 		int i;
@@ -1606,19 +1609,37 @@ static int dso__load_kernel_sym(struct dso *self, struct map *map,
 	 */
 	if (self->has_build_id) {
 		u8 kallsyms_build_id[BUILD_ID_SIZE];
+		char sbuild_id[BUILD_ID_SIZE * 2 + 1];
 
 		if (sysfs__read_build_id("/sys/kernel/notes", kallsyms_build_id,
 					 sizeof(kallsyms_build_id)) == 0) {
-			is_kallsyms = dso__build_id_equal(self, kallsyms_build_id);
-			if (is_kallsyms)
+			if (dso__build_id_equal(self, kallsyms_build_id)) {
+				kallsyms_filename = "/proc/kallsyms";
 				goto do_kallsyms;
+			}
 		}
+
+		build_id__sprintf(self->build_id, sizeof(self->build_id),
+				  sbuild_id);
+
+		if (asprintf(&kallsyms_allocated_filename,
+			     "%s/.debug/[kernel.kallsyms]/%s",
+			     getenv("HOME"), sbuild_id) != -1) {
+			if (access(kallsyms_filename, F_OK)) {
+				kallsyms_filename = kallsyms_allocated_filename;
+				goto do_kallsyms;
+			}
+			free(kallsyms_allocated_filename);
+			kallsyms_allocated_filename = NULL;
+		}
+
 		goto do_vmlinux;
 	}
 
-	is_kallsyms = self->long_name[0] == '[';
-	if (is_kallsyms)
+	if (self->long_name[0] == '[') {
+		kallsyms_filename = "/proc/kallsyms";
 		goto do_kallsyms;
+	}
 
 do_vmlinux:
 	err = dso__load_vmlinux(self, map, session, self->long_name, filter);
@@ -1629,9 +1650,10 @@ do_vmlinux:
 		pr_info("The file %s cannot be used, "
 			"trying to use /proc/kallsyms...", self->long_name);
 do_kallsyms:
-		err = dso__load_kallsyms(self, map, session, filter);
-		if (err > 0 && !is_kallsyms)
+		err = dso__load_kallsyms(self, kallsyms_filename, map, session, filter);
+		if (err > 0 && kallsyms_filename == NULL)
                         dso__set_long_name(self, strdup("[kernel.kallsyms]"));
+		free(kallsyms_allocated_filename);
 	}
 
 	if (err > 0) {
diff --git a/tools/perf/util/symbol.h b/tools/perf/util/symbol.h
index 594156e..36b7c71 100644
--- a/tools/perf/util/symbol.h
+++ b/tools/perf/util/symbol.h
@@ -144,8 +144,9 @@ int filename__read_build_id(const char *filename, void *bf, size_t size);
 int sysfs__read_build_id(const char *filename, void *bf, size_t size);
 bool dsos__read_build_ids(void);
 int build_id__sprintf(u8 *self, int len, char *bf);
-int kallsyms__parse(void *arg, int (*process_symbol)(void *arg, const char *name,
-						     char type, u64 start));
+int kallsyms__parse(const char *filename, void *arg,
+		    int (*process_symbol)(void *arg, const char *name,
+					  char type, u64 start));
 
 int symbol__init(void);
 bool symbol_type__is_a(char symbol_type, enum map_type map_type);
diff --git a/tools/perf/util/util.c b/tools/perf/util/util.c
index f3c0798..f068584 100644
--- a/tools/perf/util/util.c
+++ b/tools/perf/util/util.c
@@ -32,6 +32,33 @@ int mkdir_p(char *path, mode_t mode)
 	return (stat(path, &st) && mkdir(path, mode)) ? -1 : 0;
 }
 
+static int slow_copyfile(const char *from, const char *to)
+{
+	int err = 0;
+	char *line = NULL;
+	size_t n;
+	FILE *from_fp = fopen(from, "r"), *to_fp;
+
+	if (from_fp == NULL)
+		goto out;
+
+	to_fp = fopen(to, "w");
+	if (to_fp == NULL)
+		goto out_fclose_from;
+
+	while (getline(&line, &n, from_fp) > 0)
+		if (fputs(line, to_fp) == EOF)
+			goto out_fclose_to;
+	err = 0;
+out_fclose_to:
+	fclose(to_fp);
+	free(line);
+out_fclose_from:
+	fclose(from_fp);
+out:
+	return err;
+}
+
 int copyfile(const char *from, const char *to)
 {
 	int fromfd, tofd;
@@ -42,6 +69,9 @@ int copyfile(const char *from, const char *to)
 	if (stat(from, &st))
 		goto out;
 
+	if (st.st_size == 0) /* /proc? do it slowly... */
+		return slow_copyfile(from, to);
+
 	fromfd = open(from, O_RDONLY);
 	if (fromfd < 0)
 		goto out;
-- 
1.6.2.5

