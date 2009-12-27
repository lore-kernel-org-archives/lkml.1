Return-Path: <linux-kernel-owner+w=401wt.eu-S1751474AbZL0Xiv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751474AbZL0Xiv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Dec 2009 18:38:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751466AbZL0Xis
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Dec 2009 18:38:48 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:56323 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751092AbZL0XhU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Dec 2009 18:37:20 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
       =?utf-8?q?Fr=C3=A9d=C3=A9ric=20Weisbecker?= <fweisbec@gmail.com>,
       Mike Galbraith <efault@gmx.de>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>
Subject: [PATCH 10/10] perf record: Introduce a symtab cache
Date: Sun, 27 Dec 2009 21:37:06 -0200
Message-Id: <1261957026-15580-10-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1261957026-15580-1-git-send-email-acme@infradead.org>
References: <1261957026-15580-1-git-send-email-acme@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

Now a cache will be created in a ~/.debug debuginfo like hierarchy, so
that at the end of a 'perf record' session all the binaries (with
build-ids) involved get collected and indexed by their build-ids, so
that perf record can find them.

This is interesting when developing software where you want to do a
'perf diff' with the previous build and opens avenues for lots more
interesting tools, like a 'perf diff --graph' that takes more than two
binaries into account.

Tunables for collecting just the symtabs can be added if one doesn't
want to have the full binary, but having the full binary allows things
like 'perf rerecord' or other tools that can re-run the tests by having
access to the exact binary in some perf.data file, so it may well be
interesting to keep the full binary there.

Space consumption is minimised by trying to use hard links, a 'perf
cache' tool to manage the space used, a la ccache is required to purge
older entries.

With this in place it will be possible also to introduce new commands,
'perf archive' and 'perf restore' (or some more suitable and future
proof names) to create a cpio/tar file with the perf data and the files
in the cache that _had_ perf hits of interest.

There are more aspects to polish, like finding the right vmlinux file
to cache, etc, but this is enough for a first step.

Cc: Frédéric Weisbecker <fweisbec@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/Makefile      |    1 +
 tools/perf/util/header.c |   82 +++++++++++++++++++++++++++++++++++++++++++---
 tools/perf/util/symbol.c |   17 +++++++--
 tools/perf/util/symbol.h |    2 +
 tools/perf/util/util.c   |   69 ++++++++++++++++++++++++++++++++++++++
 tools/perf/util/util.h   |    3 ++
 6 files changed, 165 insertions(+), 9 deletions(-)
 create mode 100644 tools/perf/util/util.c

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index fafea0b..7c84642 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -425,6 +425,7 @@ LIB_OBJS += util/svghelper.o
 LIB_OBJS += util/sort.o
 LIB_OBJS += util/hist.o
 LIB_OBJS += util/probe-event.o
+LIB_OBJS += util/util.o
 
 BUILTIN_OBJS += builtin-annotate.o
 
diff --git a/tools/perf/util/header.c b/tools/perf/util/header.c
index 8a0bca5..df237c3 100644
--- a/tools/perf/util/header.c
+++ b/tools/perf/util/header.c
@@ -169,20 +169,23 @@ static int do_write(int fd, const void *buf, size_t size)
 	return 0;
 }
 
+#define dsos__for_each_with_build_id(pos, head)	\
+	list_for_each_entry(pos, head, node)	\
+		if (!pos->has_build_id)		\
+			continue;		\
+		else
+
 static int __dsos__write_buildid_table(struct list_head *head, int fd)
 {
 #define NAME_ALIGN	64
 	struct dso *pos;
 	static const char zero_buf[NAME_ALIGN];
 
-	list_for_each_entry(pos, head, node) {
+	dsos__for_each_with_build_id(pos, head) {
 		int err;
 		struct build_id_event b;
-		size_t len;
+		size_t len = pos->long_name_len + 1;
 
-		if (!pos->has_build_id)
-			continue;
-		len = pos->long_name_len + 1;
 		len = ALIGN(len, NAME_ALIGN);
 		memset(&b, 0, sizeof(b));
 		memcpy(&b.build_id, pos->build_id, sizeof(pos->build_id));
@@ -209,6 +212,74 @@ static int dsos__write_buildid_table(int fd)
 	return err;
 }
 
+static int dso__cache_build_id(struct dso *self, const char *debugdir)
+{
+	const size_t size = PATH_MAX;
+	char *filename = malloc(size),
+	     *linkname = malloc(size), *targetname, *sbuild_id;
+	int len, err = -1;
+
+	if (filename == NULL || linkname == NULL)
+		goto out_free;
+
+	len = snprintf(filename, size, "%s%s", debugdir, self->long_name);
+	if (mkdir_p(filename, 0755))
+		goto out_free;
+
+	len += snprintf(filename + len, sizeof(filename) - len, "/");
+	sbuild_id = filename + len;
+	build_id__sprintf(self->build_id, sizeof(self->build_id), sbuild_id);
+
+	if (access(filename, F_OK) && link(self->long_name, filename) &&
+	    copyfile(self->long_name, filename))
+		goto out_free;
+
+	len = snprintf(linkname, size, "%s/.build-id/%.2s",
+		       debugdir, sbuild_id);
+
+	if (access(linkname, X_OK) && mkdir_p(linkname, 0755))
+		goto out_free;
+
+	snprintf(linkname + len, size - len, "/%s", sbuild_id + 2);
+	targetname = filename + strlen(debugdir) - 5;
+	memcpy(targetname, "../..", 5);
+
+	if (symlink(targetname, linkname) == 0)
+		err = 0;
+out_free:
+	free(filename);
+	free(linkname);
+	return err;
+}
+
+static int __dsos__cache_build_ids(struct list_head *head, const char *debugdir)
+{
+	struct dso *pos;
+	int err = 0;
+
+	dsos__for_each_with_build_id(pos, head)
+		if (dso__cache_build_id(pos, debugdir))
+			err = -1;
+
+	return err;
+}
+
+static int dsos__cache_build_ids(void)
+{
+	int err_kernel, err_user;
+	char debugdir[PATH_MAX];
+
+	snprintf(debugdir, sizeof(debugdir), "%s/%s", getenv("HOME"),
+		 DEBUG_CACHE_DIR);
+
+	if (mkdir(debugdir, 0755) != 0 && errno != EEXIST)
+		return -1;
+
+	err_kernel = __dsos__cache_build_ids(&dsos__kernel, debugdir);
+	err_user   = __dsos__cache_build_ids(&dsos__user, debugdir);
+	return err_kernel || err_user ? -1 : 0;
+}
+
 static int perf_header__adds_write(struct perf_header *self, int fd)
 {
 	int nr_sections;
@@ -258,6 +329,7 @@ static int perf_header__adds_write(struct perf_header *self, int fd)
 			goto out_free;
 		}
 		buildid_sec->size = lseek(fd, 0, SEEK_CUR) - buildid_sec->offset;
+		dsos__cache_build_ids();
 	}
 
 	lseek(fd, sec_start, SEEK_SET);
diff --git a/tools/perf/util/symbol.c b/tools/perf/util/symbol.c
index ab92763..79ca6a0 100644
--- a/tools/perf/util/symbol.c
+++ b/tools/perf/util/symbol.c
@@ -22,6 +22,7 @@
 enum dso_origin {
 	DSO__ORIG_KERNEL = 0,
 	DSO__ORIG_JAVA_JIT,
+	DSO__ORIG_BUILD_ID_CACHE,
 	DSO__ORIG_FEDORA,
 	DSO__ORIG_UBUNTU,
 	DSO__ORIG_BUILDID,
@@ -1191,6 +1192,7 @@ char dso__symtab_origin(const struct dso *self)
 	static const char origin[] = {
 		[DSO__ORIG_KERNEL] =   'k',
 		[DSO__ORIG_JAVA_JIT] = 'j',
+		[DSO__ORIG_BUILD_ID_CACHE] = 'B',
 		[DSO__ORIG_FEDORA] =   'f',
 		[DSO__ORIG_UBUNTU] =   'u',
 		[DSO__ORIG_BUILDID] =  'b',
@@ -1209,6 +1211,7 @@ int dso__load(struct dso *self, struct map *map, struct perf_session *session,
 	int size = PATH_MAX;
 	char *name;
 	u8 build_id[BUILD_ID_SIZE];
+	char build_id_hex[BUILD_ID_SIZE * 2 + 1];
 	int ret = -1;
 	int fd;
 
@@ -1230,8 +1233,16 @@ int dso__load(struct dso *self, struct map *map, struct perf_session *session,
 		return ret;
 	}
 
-	self->origin = DSO__ORIG_FEDORA - 1;
+	self->origin = DSO__ORIG_BUILD_ID_CACHE;
 
+	if (self->has_build_id) {
+		build_id__sprintf(self->build_id, sizeof(self->build_id),
+				  build_id_hex);
+		snprintf(name, size, "%s/%s/.build-id/%.2s/%s",
+			 getenv("HOME"), DEBUG_CACHE_DIR,
+			 build_id_hex, build_id_hex + 2);
+		goto open_file;
+	}
 more:
 	do {
 		self->origin++;
@@ -1247,8 +1258,6 @@ more:
 		case DSO__ORIG_BUILDID:
 			if (filename__read_build_id(self->long_name, build_id,
 						    sizeof(build_id))) {
-				char build_id_hex[BUILD_ID_SIZE * 2 + 1];
-
 				build_id__sprintf(build_id, sizeof(build_id),
 						  build_id_hex);
 				snprintf(name, size,
@@ -1276,7 +1285,7 @@ compare_build_id:
 			if (!dso__build_id_equal(self, build_id))
 				goto more;
 		}
-
+open_file:
 		fd = open(name, O_RDONLY);
 	} while (fd < 0);
 
diff --git a/tools/perf/util/symbol.h b/tools/perf/util/symbol.h
index 9eabd60..f27e158 100644
--- a/tools/perf/util/symbol.h
+++ b/tools/perf/util/symbol.h
@@ -8,6 +8,8 @@
 #include <linux/rbtree.h>
 #include "event.h"
 
+#define DEBUG_CACHE_DIR ".debug"
+
 #ifdef HAVE_CPLUS_DEMANGLE
 extern char *cplus_demangle(const char *, int);
 
diff --git a/tools/perf/util/util.c b/tools/perf/util/util.c
new file mode 100644
index 0000000..f3c0798
--- /dev/null
+++ b/tools/perf/util/util.c
@@ -0,0 +1,69 @@
+#include <sys/mman.h>
+#include <sys/stat.h>
+#include <sys/types.h>
+#include <fcntl.h>
+#include <string.h>
+#include <unistd.h>
+#include "util.h"
+
+int mkdir_p(char *path, mode_t mode)
+{
+	struct stat st;
+	int err;
+	char *d = path;
+
+	if (*d != '/')
+		return -1;
+
+	if (stat(path, &st) == 0)
+		return 0;
+
+	while (*++d == '/');
+
+	while ((d = strchr(d, '/'))) {
+		*d = '\0';
+		err = stat(path, &st) && mkdir(path, mode);
+		*d++ = '/';
+		if (err)
+			return -1;
+		while (*d == '/')
+			++d;
+	}
+	return (stat(path, &st) && mkdir(path, mode)) ? -1 : 0;
+}
+
+int copyfile(const char *from, const char *to)
+{
+	int fromfd, tofd;
+	struct stat st;
+	void *addr;
+	int err = -1;
+
+	if (stat(from, &st))
+		goto out;
+
+	fromfd = open(from, O_RDONLY);
+	if (fromfd < 0)
+		goto out;
+
+	tofd = creat(to, 0755);
+	if (tofd < 0)
+		goto out_close_from;
+
+	addr = mmap(NULL, st.st_size, PROT_READ, MAP_PRIVATE, fromfd, 0);
+	if (addr == MAP_FAILED)
+		goto out_close_to;
+
+	if (write(tofd, addr, st.st_size) == st.st_size)
+		err = 0;
+
+	munmap(addr, st.st_size);
+out_close_to:
+	close(tofd);
+	if (err)
+		unlink(to);
+out_close_from:
+	close(fromfd);
+out:
+	return err;
+}
diff --git a/tools/perf/util/util.h b/tools/perf/util/util.h
index c673d88..0f5b2a6 100644
--- a/tools/perf/util/util.h
+++ b/tools/perf/util/util.h
@@ -403,4 +403,7 @@ void git_qsort(void *base, size_t nmemb, size_t size,
 #endif
 #endif
 
+int mkdir_p(char *path, mode_t mode);
+int copyfile(const char *from, const char *to);
+
 #endif
-- 
1.6.2.5

