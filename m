Return-Path: <linux-kernel-owner+w=401wt.eu-S1751141AbZL0Xj0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751141AbZL0Xj0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Dec 2009 18:39:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751323AbZL0Xir
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Dec 2009 18:38:47 -0500
Received: from casper.infradead.org ([85.118.1.10]:40958 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751151AbZL0XhU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Dec 2009 18:37:20 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
       =?utf-8?q?Fr=C3=A9d=C3=A9ric=20Weisbecker?= <fweisbec@gmail.com>,
       Mike Galbraith <efault@gmx.de>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>
Subject: [PATCH 04/10] perf tools: Move the map class definition to a separate header
Date: Sun, 27 Dec 2009 21:37:00 -0200
Message-Id: <1261957026-15580-4-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1261957026-15580-1-git-send-email-acme@infradead.org>
References: <1261957026-15580-1-git-send-email-acme@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

And this resulted in the need for adding some missing includes in some
places that were getting the definitions needed out of sheer luck.

Cc: Frédéric Weisbecker <fweisbec@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/Makefile            |    1 +
 tools/perf/util/debug.c        |    1 +
 tools/perf/util/event.h        |   65 ++----------------------------------
 tools/perf/util/map.h          |   73 ++++++++++++++++++++++++++++++++++++++++
 tools/perf/util/probe-finder.h |    2 +
 5 files changed, 80 insertions(+), 62 deletions(-)
 create mode 100644 tools/perf/util/map.h

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index 4172c3b..fafea0b 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -357,6 +357,7 @@ LIB_H += util/event.h
 LIB_H += util/exec_cmd.h
 LIB_H += util/types.h
 LIB_H += util/levenshtein.h
+LIB_H += util/map.h
 LIB_H += util/parse-options.h
 LIB_H += util/parse-events.h
 LIB_H += util/quote.h
diff --git a/tools/perf/util/debug.c b/tools/perf/util/debug.c
index 28d520d..0905600 100644
--- a/tools/perf/util/debug.c
+++ b/tools/perf/util/debug.c
@@ -9,6 +9,7 @@
 #include "color.h"
 #include "event.h"
 #include "debug.h"
+#include "util.h"
 
 int verbose = 0;
 int dump_trace = 0;
diff --git a/tools/perf/util/event.h b/tools/perf/util/event.h
index 690a96d..80fb365 100644
--- a/tools/perf/util/event.h
+++ b/tools/perf/util/event.h
@@ -1,10 +1,10 @@
 #ifndef __PERF_RECORD_H
 #define __PERF_RECORD_H
 
+#include <limits.h>
+
 #include "../perf.h"
-#include "util.h"
-#include <linux/list.h>
-#include <linux/rbtree.h>
+#include "map.h"
 
 /*
  * PERF_SAMPLE_IP | PERF_SAMPLE_TID | *
@@ -101,67 +101,8 @@ struct events_stats {
 
 void event__print_totals(void);
 
-enum map_type {
-	MAP__FUNCTION = 0,
-	MAP__VARIABLE,
-};
-
-#define MAP__NR_TYPES (MAP__VARIABLE + 1)
-
-struct map {
-	union {
-		struct rb_node	rb_node;
-		struct list_head node;
-	};
-	u64			start;
-	u64			end;
-	enum map_type		type;
-	u64			pgoff;
-	u64			(*map_ip)(struct map *, u64);
-	u64			(*unmap_ip)(struct map *, u64);
-	struct dso		*dso;
-};
-
-static inline u64 map__map_ip(struct map *map, u64 ip)
-{
-	return ip - map->start + map->pgoff;
-}
-
-static inline u64 map__unmap_ip(struct map *map, u64 ip)
-{
-	return ip + map->start - map->pgoff;
-}
-
-static inline u64 identity__map_ip(struct map *map __used, u64 ip)
-{
-	return ip;
-}
-
-struct symbol;
-
-typedef int (*symbol_filter_t)(struct map *map, struct symbol *sym);
-
-void map__init(struct map *self, enum map_type type,
-	       u64 start, u64 end, u64 pgoff, struct dso *dso);
-struct map *map__new(struct mmap_event *event, enum map_type,
-		     char *cwd, int cwdlen);
-void map__delete(struct map *self);
-struct map *map__clone(struct map *self);
-int map__overlap(struct map *l, struct map *r);
-size_t map__fprintf(struct map *self, FILE *fp);
-
 struct perf_session;
 
-int map__load(struct map *self, struct perf_session *session,
-	      symbol_filter_t filter);
-struct symbol *map__find_symbol(struct map *self, struct perf_session *session,
-				u64 addr, symbol_filter_t filter);
-struct symbol *map__find_symbol_by_name(struct map *self, const char *name,
-					struct perf_session *session,
-					symbol_filter_t filter);
-void map__fixup_start(struct map *self);
-void map__fixup_end(struct map *self);
-
 int event__synthesize_thread(pid_t pid,
 			     int (*process)(event_t *event,
 					    struct perf_session *session),
diff --git a/tools/perf/util/map.h b/tools/perf/util/map.h
new file mode 100644
index 0000000..72f0b6a
--- /dev/null
+++ b/tools/perf/util/map.h
@@ -0,0 +1,73 @@
+#ifndef __PERF_MAP_H
+#define __PERF_MAP_H
+
+#include <linux/compiler.h>
+#include <linux/list.h>
+#include <linux/rbtree.h>
+#include <linux/types.h>
+
+enum map_type {
+	MAP__FUNCTION = 0,
+	MAP__VARIABLE,
+};
+
+#define MAP__NR_TYPES (MAP__VARIABLE + 1)
+
+struct dso;
+
+struct map {
+	union {
+		struct rb_node	rb_node;
+		struct list_head node;
+	};
+	u64			start;
+	u64			end;
+	enum map_type		type;
+	u64			pgoff;
+	u64			(*map_ip)(struct map *, u64);
+	u64			(*unmap_ip)(struct map *, u64);
+	struct dso		*dso;
+};
+
+static inline u64 map__map_ip(struct map *map, u64 ip)
+{
+	return ip - map->start + map->pgoff;
+}
+
+static inline u64 map__unmap_ip(struct map *map, u64 ip)
+{
+	return ip + map->start - map->pgoff;
+}
+
+static inline u64 identity__map_ip(struct map *map __used, u64 ip)
+{
+	return ip;
+}
+
+struct symbol;
+struct mmap_event;
+
+typedef int (*symbol_filter_t)(struct map *map, struct symbol *sym);
+
+void map__init(struct map *self, enum map_type type,
+	       u64 start, u64 end, u64 pgoff, struct dso *dso);
+struct map *map__new(struct mmap_event *event, enum map_type,
+		     char *cwd, int cwdlen);
+void map__delete(struct map *self);
+struct map *map__clone(struct map *self);
+int map__overlap(struct map *l, struct map *r);
+size_t map__fprintf(struct map *self, FILE *fp);
+
+struct perf_session;
+
+int map__load(struct map *self, struct perf_session *session,
+	      symbol_filter_t filter);
+struct symbol *map__find_symbol(struct map *self, struct perf_session *session,
+				u64 addr, symbol_filter_t filter);
+struct symbol *map__find_symbol_by_name(struct map *self, const char *name,
+					struct perf_session *session,
+					symbol_filter_t filter);
+void map__fixup_start(struct map *self);
+void map__fixup_end(struct map *self);
+
+#endif /* __PERF_MAP_H */
diff --git a/tools/perf/util/probe-finder.h b/tools/perf/util/probe-finder.h
index a4086aa..e3f3968 100644
--- a/tools/perf/util/probe-finder.h
+++ b/tools/perf/util/probe-finder.h
@@ -1,6 +1,8 @@
 #ifndef _PROBE_FINDER_H
 #define _PROBE_FINDER_H
 
+#include "util.h"
+
 #define MAX_PATH_LEN		 256
 #define MAX_PROBE_BUFFER	1024
 #define MAX_PROBES		 128
-- 
1.6.2.5

