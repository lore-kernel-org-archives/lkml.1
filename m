Return-Path: <linux-kernel-owner+w=401wt.eu-S1758434AbZLOP3S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758434AbZLOP3S (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Dec 2009 10:29:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754296AbZLOP3I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Dec 2009 10:29:08 -0500
Received: from mx1.redhat.com ([209.132.183.28]:15104 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755510AbZLOP3A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Dec 2009 10:29:00 -0500
From: Masami Hiramatsu <mhiramat@redhat.com>
Subject: [PATCH -tip 12/14] perf probe: Check build-id of vmlinux
To: Ingo Molnar <mingo@elte.hu>, Frederic Weisbecker <fweisbec@gmail.com>,
       lkml <linux-kernel@vger.kernel.org>
Cc: Paul Mackerras <paulus@samba.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Jim Keniston <jkenisto@us.ibm.com>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Christoph Hellwig <hch@infradead.org>,
       "Frank Ch. Eigler" <fche@redhat.com>, Jason Baron <jbaron@redhat.com>,
       "K.Prasad" <prasad@linux.vnet.ibm.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
       systemtap <systemtap@sources.redhat.com>,
       DLE <dle-develop@lists.sourceforge.net>
Date: Tue, 15 Dec 2009 10:32:33 -0500
Message-ID: <20091215153232.17436.45539.stgit@dhcp-100-2-132.bos.redhat.com>
In-Reply-To: <20091215153106.17436.66584.stgit@dhcp-100-2-132.bos.redhat.com>
References: <20091215153106.17436.66584.stgit@dhcp-100-2-132.bos.redhat.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Check build-id of vmlinux by using functions in symbol.c.
This also exposes map__load() for getting vmlinux path,
and removes vmlinux path list in builtin-probe.c,
because symbol.c already has that. Checking build-id
prevents users to open old or different debuginfo from
current running kernel.

Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Jim Keniston <jkenisto@us.ibm.com>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Frank Ch. Eigler <fche@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jason Baron <jbaron@redhat.com>
Cc: K.Prasad <prasad@linux.vnet.ibm.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
---

 tools/perf/builtin-probe.c |   72 ++++++++++++++++++--------------------------
 tools/perf/util/event.h    |    2 +
 tools/perf/util/map.c      |   14 ++++++---
 3 files changed, 41 insertions(+), 47 deletions(-)

diff --git a/tools/perf/builtin-probe.c b/tools/perf/builtin-probe.c
index 4d232cb..5008605 100644
--- a/tools/perf/builtin-probe.c
+++ b/tools/perf/builtin-probe.c
@@ -38,33 +38,27 @@
 #include "util/strlist.h"
 #include "util/event.h"
 #include "util/debug.h"
+#include "util/symbol.h"
+#include "util/thread.h"
+#include "util/session.h"
 #include "util/parse-options.h"
 #include "util/parse-events.h"	/* For debugfs_path */
 #include "util/probe-finder.h"
 #include "util/probe-event.h"
 
-/* Default vmlinux search paths */
-#define NR_SEARCH_PATH 4
-const char *default_search_path[NR_SEARCH_PATH] = {
-"/lib/modules/%s/build/vmlinux",		/* Custom build kernel */
-"/usr/lib/debug/lib/modules/%s/vmlinux",	/* Red Hat debuginfo */
-"/boot/vmlinux-debug-%s",			/* Ubuntu */
-"./vmlinux",					/* CWD */
-};
-
 #define MAX_PATH_LEN 256
 #define MAX_PROBES 128
 
 /* Session management structure */
 static struct {
-	char *vmlinux;
-	char *release;
 	bool need_dwarf;
 	bool list_events;
 	bool force_add;
 	int nr_probe;
 	struct probe_point probes[MAX_PROBES];
 	struct strlist *dellist;
+	struct symbol_conf conf;
+	struct perf_session *psession;
 } session;
 
 
@@ -122,33 +116,21 @@ static int opt_del_probe_event(const struct option *opt __used,
 }
 
 #ifndef NO_LIBDWARF
-static int open_default_vmlinux(void)
+static int open_vmlinux(void)
 {
-	struct utsname uts;
-	char fname[MAX_PATH_LEN];
-	int fd, ret, i;
-
-	ret = uname(&uts);
-	if (ret) {
-		pr_debug("uname() failed.\n");
-		return -errno;
+	struct map *kmap;
+	kmap = map_groups__find_by_name(&session.psession->kmaps,
+					MAP__FUNCTION, "[kernel.kallsyms]");
+	if (!kmap) {
+		pr_debug("Could not find kernel map.\n");
+		return -ENOENT;
 	}
-	session.release = uts.release;
-	for (i = 0; i < NR_SEARCH_PATH; i++) {
-		ret = snprintf(fname, MAX_PATH_LEN,
-			       default_search_path[i], session.release);
-		if (ret >= MAX_PATH_LEN || ret < 0) {
-			pr_debug("Filename(%d,%s) is too long.\n", i,
-				uts.release);
-			errno = E2BIG;
-			return -E2BIG;
-		}
-		pr_debug("try to open %s\n", fname);
-		fd = open(fname, O_RDONLY);
-		if (fd >= 0)
-			break;
+	if (map__load(kmap, session.psession, NULL) < 0) {
+		pr_debug("Failed to load kernel map.\n");
+		return -EINVAL;
 	}
-	return fd;
+	pr_debug("Try to open %s\n", kmap->dso->long_name);
+	return open(kmap->dso->long_name, O_RDONLY);
 }
 #endif
 
@@ -164,8 +146,8 @@ static const struct option options[] = {
 	OPT_BOOLEAN('v', "verbose", &verbose,
 		    "be more verbose (show parsed arguments, etc)"),
 #ifndef NO_LIBDWARF
-	OPT_STRING('k', "vmlinux", &session.vmlinux, "file",
-		"vmlinux/module pathname"),
+	OPT_STRING('k', "vmlinux", &session.conf.vmlinux_name,
+		   "file", "vmlinux pathname"),
 #endif
 	OPT_BOOLEAN('l', "list", &session.list_events,
 		    "list up current probe events"),
@@ -236,17 +218,23 @@ int cmd_probe(int argc, const char **argv, const char *prefix __used)
 			return 0;
 	}
 
+	/* Initialize symbol maps for vmlinux */
+	if (session.conf.vmlinux_name == NULL)
+		session.conf.try_vmlinux_path = true;
+	if (symbol__init(&session.conf) < 0)
+		die("Failed to init symbol map.");
+	session.psession = perf_session__new(NULL, O_WRONLY, false,
+					     &session.conf);
+	if (session.psession == NULL)
+		die("Failed to init perf_session.");
+
 	if (session.need_dwarf)
 #ifdef NO_LIBDWARF
 		die("Debuginfo-analysis is not supported");
 #else	/* !NO_LIBDWARF */
 		pr_debug("Some probes require debuginfo.\n");
 
-	if (session.vmlinux) {
-		pr_debug("Try to open %s.", session.vmlinux);
-		fd = open(session.vmlinux, O_RDONLY);
-	} else
-		fd = open_default_vmlinux();
+	fd = open_vmlinux();
 	if (fd < 0) {
 		if (session.need_dwarf)
 			die("Could not open debuginfo file.");
diff --git a/tools/perf/util/event.h b/tools/perf/util/event.h
index a92e0b0..8027309 100644
--- a/tools/perf/util/event.h
+++ b/tools/perf/util/event.h
@@ -152,6 +152,8 @@ size_t map__fprintf(struct map *self, FILE *fp);
 
 struct perf_session;
 
+int map__load(struct map *self, struct perf_session *session,
+	      symbol_filter_t filter);
 struct symbol *map__find_symbol(struct map *self, struct perf_session *session,
 				u64 addr, symbol_filter_t filter);
 struct symbol *map__find_symbol_by_name(struct map *self, const char *name,
diff --git a/tools/perf/util/map.c b/tools/perf/util/map.c
index 8b3dd46..c4d55a0 100644
--- a/tools/perf/util/map.c
+++ b/tools/perf/util/map.c
@@ -104,12 +104,16 @@ void map__fixup_end(struct map *self)
 
 #define DSO__DELETED "(deleted)"
 
-static int map__load(struct map *self, struct perf_session *session,
-		     symbol_filter_t filter)
+int map__load(struct map *self, struct perf_session *session,
+	      symbol_filter_t filter)
 {
 	const char *name = self->dso->long_name;
-	int nr = dso__load(self->dso, self, session, filter);
+	int nr;
 
+	if (dso__loaded(self->dso, self->type))
+		return 0;
+
+	nr = dso__load(self->dso, self, session, filter);
 	if (nr < 0) {
 		if (self->dso->has_build_id) {
 			char sbuild_id[BUILD_ID_SIZE * 2 + 1];
@@ -147,7 +151,7 @@ static int map__load(struct map *self, struct perf_session *session,
 struct symbol *map__find_symbol(struct map *self, struct perf_session *session,
 				u64 addr, symbol_filter_t filter)
 {
-	if (!dso__loaded(self->dso, self->type) && map__load(self, session, filter) < 0)
+	if (map__load(self, session, filter) < 0)
 		return NULL;
 
 	return dso__find_symbol(self->dso, self->type, addr);
@@ -157,7 +161,7 @@ struct symbol *map__find_symbol_by_name(struct map *self, const char *name,
 					struct perf_session *session,
 					symbol_filter_t filter)
 {
-	if (!dso__loaded(self->dso, self->type) && map__load(self, session, filter) < 0)
+	if (map__load(self, session, filter) < 0)
 		return NULL;
 
 	if (!dso__sorted_by_name(self->dso, self->type))


-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America), Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com
