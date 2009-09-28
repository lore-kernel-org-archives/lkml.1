Return-Path: <linux-kernel-owner+w=401wt.eu-S1752303AbZI1RtI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752303AbZI1RtI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Sep 2009 13:49:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752083AbZI1RtI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Sep 2009 13:49:08 -0400
Received: from mx1.redhat.com ([209.132.183.28]:1670 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751925AbZI1RtG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Sep 2009 13:49:06 -0400
Date: Mon, 28 Sep 2009 14:48:46 -0300
From: Arnaldo Carvalho de Melo <acme@redhat.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Peter Zijlstra <peterz@infradead.org>,
       Mike Galbraith <efault@gmx.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/1 tip] perf tools: Use rb_tree for maps
Message-ID: <20090928174846.GA3361@ghostprotocols.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
X-Url: http://oops.ghostprotocols.net:81/blog
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Threads can have many and kernel modules will be represented as a tree
of maps as well.

Ah, and for a perf.data with 146607 samples:

Before:

[root@doppio ~]# perf stat -r 5 perf report > /dev/null

 Performance counter stats for 'perf report' (5 runs):

     699.823680  task-clock-msecs         #      0.991 CPUs    ( +-   0.454% )
             74  context-switches         #      0.000 M/sec   ( +-   1.709% )
              2  CPU-migrations           #      0.000 M/sec   ( +-  17.008% )
          23114  page-faults              #      0.033 M/sec   ( +-   0.000% )
     1381257019  cycles                   #   1973.721 M/sec   ( +-   0.290% )
     1456894438  instructions             #      1.055 IPC     ( +-   0.007% )
       18779818  cache-references         #     26.835 M/sec   ( +-   0.380% )
         641799  cache-misses             #      0.917 M/sec   ( +-   1.200% )

    0.705972729  seconds time elapsed   ( +-   0.501% )

[root@doppio ~]#

After

 Performance counter stats for 'perf report' (5 runs):

     691.261451  task-clock-msecs         #      0.993 CPUs    ( +-   0.307% )
             72  context-switches         #      0.000 M/sec   ( +-   0.829% )
              6  CPU-migrations           #      0.000 M/sec   ( +-  18.409% )
          23127  page-faults              #      0.033 M/sec   ( +-   0.000% )
     1366395876  cycles                   #   1976.670 M/sec   ( +-   0.153% )
     1443136016  instructions             #      1.056 IPC     ( +-   0.012% )
       17956402  cache-references         #     25.976 M/sec   ( +-   0.325% )
         661924  cache-misses             #      0.958 M/sec   ( +-   1.335% )

    0.696127275  seconds time elapsed   ( +-   0.377% )

I.e. we see some speedup too.

Cc: Frédéric Weisbecker <fweisbec@gmail.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Mike Galbraith <efault@gmx.de>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/Makefile      |    1 +
 tools/perf/util/event.h  |    4 +-
 tools/perf/util/thread.c |  129 +++++++++++++++++++++++++++++----------------
 tools/perf/util/thread.h |   12 +++-
 4 files changed, 95 insertions(+), 51 deletions(-)

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index 0a9e5ae..17b0757 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -340,6 +340,7 @@ LIB_H += util/module.h
 LIB_H += util/color.h
 LIB_H += util/values.h
 LIB_H += util/sort.h
+LIB_H += util/thread.h
 
 LIB_OBJS += util/abspath.o
 LIB_OBJS += util/alias.o
diff --git a/tools/perf/util/event.h b/tools/perf/util/event.h
index c31a5da..4c69eb5 100644
--- a/tools/perf/util/event.h
+++ b/tools/perf/util/event.h
@@ -3,7 +3,7 @@
 
 #include "../perf.h"
 #include "util.h"
-#include <linux/list.h>
+#include <linux/rbtree.h>
 
 enum {
 	SHOW_KERNEL	= 1,
@@ -79,7 +79,7 @@ typedef union event_union {
 } event_t;
 
 struct map {
-	struct list_head	node;
+	struct rb_node		rb_node;
 	u64			start;
 	u64			end;
 	u64			pgoff;
diff --git a/tools/perf/util/thread.c b/tools/perf/util/thread.c
index 45efb5d..9d0945c 100644
--- a/tools/perf/util/thread.c
+++ b/tools/perf/util/thread.c
@@ -15,7 +15,7 @@ static struct thread *thread__new(pid_t pid)
 		self->comm = malloc(32);
 		if (self->comm)
 			snprintf(self->comm, 32, ":%d", self->pid);
-		INIT_LIST_HEAD(&self->maps);
+		self->maps = RB_ROOT;
 	}
 
 	return self;
@@ -31,11 +31,13 @@ int thread__set_comm(struct thread *self, const char *comm)
 
 static size_t thread__fprintf(struct thread *self, FILE *fp)
 {
-	struct map *pos;
+	struct rb_node *nd;
 	size_t ret = fprintf(fp, "Thread %d %s\n", self->pid, self->comm);
 
-	list_for_each_entry(pos, &self->maps, node)
+	for (nd = rb_first(&self->maps); nd; nd = rb_next(nd)) {
+		struct map *pos = rb_entry(nd, struct map, rb_node);
 		ret += map__fprintf(pos, fp);
+	}
 
 	return ret;
 }
@@ -93,42 +95,90 @@ register_idle_thread(struct rb_root *threads, struct thread **last_match)
 	return thread;
 }
 
-void thread__insert_map(struct thread *self, struct map *map)
+static void thread__remove_overlappings(struct thread *self, struct map *map)
 {
-	struct map *pos, *tmp;
-
-	list_for_each_entry_safe(pos, tmp, &self->maps, node) {
-		if (map__overlap(pos, map)) {
-			if (verbose >= 2) {
-				printf("overlapping maps:\n");
-				map__fprintf(map, stdout);
-				map__fprintf(pos, stdout);
-			}
-
-			if (map->start <= pos->start && map->end > pos->start)
-				pos->start = map->end;
-
-			if (map->end >= pos->end && map->start < pos->end)
-				pos->end = map->start;
-
-			if (verbose >= 2) {
-				printf("after collision:\n");
-				map__fprintf(pos, stdout);
-			}
-
-			if (pos->start >= pos->end) {
-				list_del_init(&pos->node);
-				free(pos);
-			}
+	struct rb_node *next = rb_first(&self->maps);
+
+	while (next) {
+		struct map *pos = rb_entry(next, struct map, rb_node);
+		next = rb_next(&pos->rb_node);
+
+		if (!map__overlap(pos, map))
+			continue;
+
+		if (verbose >= 2) {
+			printf("overlapping maps:\n");
+			map__fprintf(map, stdout);
+			map__fprintf(pos, stdout);
+		}
+
+		if (map->start <= pos->start && map->end > pos->start)
+			pos->start = map->end;
+
+		if (map->end >= pos->end && map->start < pos->end)
+			pos->end = map->start;
+
+		if (verbose >= 2) {
+			printf("after collision:\n");
+			map__fprintf(pos, stdout);
+		}
+
+		if (pos->start >= pos->end) {
+			rb_erase(&pos->rb_node, &self->maps);
+			free(pos);
 		}
 	}
+}
+
+void maps__insert(struct rb_root *maps, struct map *map)
+{
+	struct rb_node **p = &maps->rb_node;
+	struct rb_node *parent = NULL;
+	const u64 ip = map->start;
+	struct map *m;
+
+	while (*p != NULL) {
+		parent = *p;
+		m = rb_entry(parent, struct map, rb_node);
+		if (ip < m->start)
+			p = &(*p)->rb_left;
+		else
+			p = &(*p)->rb_right;
+	}
+
+	rb_link_node(&map->rb_node, parent, p);
+	rb_insert_color(&map->rb_node, maps);
+}
+
+struct map *maps__find(struct rb_root *maps, u64 ip)
+{
+	struct rb_node **p = &maps->rb_node;
+	struct rb_node *parent = NULL;
+	struct map *m;
+
+	while (*p != NULL) {
+		parent = *p;
+		m = rb_entry(parent, struct map, rb_node);
+		if (ip < m->start)
+			p = &(*p)->rb_left;
+		else if (ip > m->end)
+			p = &(*p)->rb_right;
+		else
+			return m;
+	}
+
+	return NULL;
+}
 
-	list_add_tail(&map->node, &self->maps);
+void thread__insert_map(struct thread *self, struct map *map)
+{
+	thread__remove_overlappings(self, map);
+	maps__insert(&self->maps, map);
 }
 
 int thread__fork(struct thread *self, struct thread *parent)
 {
-	struct map *map;
+	struct rb_node *nd;
 
 	if (self->comm)
 		free(self->comm);
@@ -136,7 +186,8 @@ int thread__fork(struct thread *self, struct thread *parent)
 	if (!self->comm)
 		return -ENOMEM;
 
-	list_for_each_entry(map, &parent->maps, node) {
+	for (nd = rb_first(&parent->maps); nd; nd = rb_next(nd)) {
+		struct map *map = rb_entry(nd, struct map, rb_node);
 		struct map *new = map__clone(map);
 		if (!new)
 			return -ENOMEM;
@@ -146,20 +197,6 @@ int thread__fork(struct thread *self, struct thread *parent)
 	return 0;
 }
 
-struct map *thread__find_map(struct thread *self, u64 ip)
-{
-	struct map *pos;
-
-	if (self == NULL)
-		return NULL;
-
-	list_for_each_entry(pos, &self->maps, node)
-		if (ip >= pos->start && ip <= pos->end)
-			return pos;
-
-	return NULL;
-}
-
 size_t threads__fprintf(FILE *fp, struct rb_root *threads)
 {
 	size_t ret = 0;
diff --git a/tools/perf/util/thread.h b/tools/perf/util/thread.h
index 693ed1e..bbb37c1 100644
--- a/tools/perf/util/thread.h
+++ b/tools/perf/util/thread.h
@@ -2,13 +2,12 @@
 #define __PERF_THREAD_H
 
 #include <linux/rbtree.h>
-#include <linux/list.h>
 #include <unistd.h>
 #include "symbol.h"
 
 struct thread {
 	struct rb_node		rb_node;
-	struct list_head	maps;
+	struct rb_root		maps;
 	pid_t			pid;
 	char			shortname[3];
 	char			*comm;
@@ -21,7 +20,14 @@ struct thread *
 register_idle_thread(struct rb_root *threads, struct thread **last_match);
 void thread__insert_map(struct thread *self, struct map *map);
 int thread__fork(struct thread *self, struct thread *parent);
-struct map *thread__find_map(struct thread *self, u64 ip);
 size_t threads__fprintf(FILE *fp, struct rb_root *threads);
 
+void maps__insert(struct rb_root *maps, struct map *map);
+struct map *maps__find(struct rb_root *maps, u64 ip);
+
+static inline struct map *thread__find_map(struct thread *self, u64 ip)
+{
+	return self ? maps__find(&self->maps, ip) : NULL;
+}
+
 #endif	/* __PERF_THREAD_H */
-- 
1.6.2.5

