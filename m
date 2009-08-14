Return-Path: <linux-kernel-owner+w=401wt.eu-S1754756AbZHNKV6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754756AbZHNKV6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Aug 2009 06:21:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754717AbZHNKV5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Aug 2009 06:21:57 -0400
Received: from mail-ew0-f214.google.com ([209.85.219.214]:65246 "EHLO
	mail-ew0-f214.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754721AbZHNKV4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Aug 2009 06:21:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=F0lYYZbutKBIyoZFPUpP1sJfPGSI3cELWx5VjfNkTsKK3X94vconzZi8+XBUBV7OSZ
         UxJTZL03l3Y++3mnQH8n2PCqg0vab6VJw2yM0ThAl1CF7mPUC8TIwCBMca1j4L3yzdxx
         koVM8Uw1qoxZKAp6+2hKHLFsveK3bG6JbxBjQ=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Mike Galbraith <efault@gmx.de>
Subject: [PATCH v2] perf tools: Factorize the thread code in a dedicated file
Date: Fri, 14 Aug 2009 12:21:53 +0200
Message-Id: <1250245313-6995-1-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
In-Reply-To: <1250244300-6343-2-git-send-email-fweisbec@gmail.com>
References: <1250244300-6343-2-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Factorize the thread management code used by perf-annotate and
perf-report in dedicated source and header files.

v2: pass last_match by address so that it can actually be modified.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
---
 tools/perf/Makefile           |    1 +
 tools/perf/builtin-annotate.c |  173 ++++-------------------------------
 tools/perf/builtin-report.c   |  205 ++++------------------------------------
 tools/perf/util/thread.c      |  143 ++++++++++++++++++++++++++++
 tools/perf/util/thread.h      |   19 ++++
 5 files changed, 202 insertions(+), 339 deletions(-)
 create mode 100644 tools/perf/util/thread.c
 create mode 100644 tools/perf/util/thread.h

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index 68218cf..0056405 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -341,6 +341,7 @@ LIB_OBJS += util/callchain.o
 LIB_OBJS += util/values.o
 LIB_OBJS += util/debug.o
 LIB_OBJS += util/map.o
+LIB_OBJS += util/thread.o
 
 BUILTIN_OBJS += builtin-annotate.o
 BUILTIN_OBJS += builtin-help.o
diff --git a/tools/perf/builtin-annotate.c b/tools/perf/builtin-annotate.c
index 543c452..3bedaa5 100644
--- a/tools/perf/builtin-annotate.c
+++ b/tools/perf/builtin-annotate.c
@@ -20,6 +20,7 @@
 
 #include "util/parse-options.h"
 #include "util/parse-events.h"
+#include "util/thread.h"
 
 #define SHOW_KERNEL	1
 #define SHOW_USER	2
@@ -44,6 +45,9 @@ static int		print_line;
 static unsigned long	page_size;
 static unsigned long	mmap_window = 32;
 
+static struct rb_root	threads;
+static struct thread	*last_match;
+
 
 struct sym_ext {
 	struct rb_node	node;
@@ -51,154 +55,6 @@ struct sym_ext {
 	char		*path;
 };
 
-
-struct thread {
-	struct rb_node	 rb_node;
-	struct list_head maps;
-	pid_t		 pid;
-	char		 *comm;
-};
-
-static struct thread *thread__new(pid_t pid)
-{
-	struct thread *self = malloc(sizeof(*self));
-
-	if (self != NULL) {
-		self->pid = pid;
-		self->comm = malloc(32);
-		if (self->comm)
-			snprintf(self->comm, 32, ":%d", self->pid);
-		INIT_LIST_HEAD(&self->maps);
-	}
-
-	return self;
-}
-
-static int thread__set_comm(struct thread *self, const char *comm)
-{
-	if (self->comm)
-		free(self->comm);
-	self->comm = strdup(comm);
-	return self->comm ? 0 : -ENOMEM;
-}
-
-static size_t thread__fprintf(struct thread *self, FILE *fp)
-{
-	struct map *pos;
-	size_t ret = fprintf(fp, "Thread %d %s\n", self->pid, self->comm);
-
-	list_for_each_entry(pos, &self->maps, node)
-		ret += map__fprintf(pos, fp);
-
-	return ret;
-}
-
-
-static struct rb_root threads;
-static struct thread *last_match;
-
-static struct thread *threads__findnew(pid_t pid)
-{
-	struct rb_node **p = &threads.rb_node;
-	struct rb_node *parent = NULL;
-	struct thread *th;
-
-	/*
-	 * Font-end cache - PID lookups come in blocks,
-	 * so most of the time we dont have to look up
-	 * the full rbtree:
-	 */
-	if (last_match && last_match->pid == pid)
-		return last_match;
-
-	while (*p != NULL) {
-		parent = *p;
-		th = rb_entry(parent, struct thread, rb_node);
-
-		if (th->pid == pid) {
-			last_match = th;
-			return th;
-		}
-
-		if (pid < th->pid)
-			p = &(*p)->rb_left;
-		else
-			p = &(*p)->rb_right;
-	}
-
-	th = thread__new(pid);
-	if (th != NULL) {
-		rb_link_node(&th->rb_node, parent, p);
-		rb_insert_color(&th->rb_node, &threads);
-		last_match = th;
-	}
-
-	return th;
-}
-
-static void thread__insert_map(struct thread *self, struct map *map)
-{
-	struct map *pos, *tmp;
-
-	list_for_each_entry_safe(pos, tmp, &self->maps, node) {
-		if (map__overlap(pos, map)) {
-			list_del_init(&pos->node);
-			/* XXX leaks dsos */
-			free(pos);
-		}
-	}
-
-	list_add_tail(&map->node, &self->maps);
-}
-
-static int thread__fork(struct thread *self, struct thread *parent)
-{
-	struct map *map;
-
-	if (self->comm)
-		free(self->comm);
-	self->comm = strdup(parent->comm);
-	if (!self->comm)
-		return -ENOMEM;
-
-	list_for_each_entry(map, &parent->maps, node) {
-		struct map *new = map__clone(map);
-		if (!new)
-			return -ENOMEM;
-		thread__insert_map(self, new);
-	}
-
-	return 0;
-}
-
-static struct map *thread__find_map(struct thread *self, u64 ip)
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
-static size_t threads__fprintf(FILE *fp)
-{
-	size_t ret = 0;
-	struct rb_node *nd;
-
-	for (nd = rb_first(&threads); nd; nd = rb_next(nd)) {
-		struct thread *pos = rb_entry(nd, struct thread, rb_node);
-
-		ret += thread__fprintf(pos, fp);
-	}
-
-	return ret;
-}
-
 /*
  * histogram, sorted on item, collects counts
  */
@@ -624,7 +480,7 @@ static void output__resort(void)
 
 static void register_idle_thread(void)
 {
-	struct thread *thread = threads__findnew(0);
+	struct thread *thread = threads__findnew(0, &threads, &last_match);
 
 	if (thread == NULL ||
 			thread__set_comm(thread, "[idle]")) {
@@ -645,10 +501,12 @@ process_sample_event(event_t *event, unsigned long offset, unsigned long head)
 	char level;
 	int show = 0;
 	struct dso *dso = NULL;
-	struct thread *thread = threads__findnew(event->ip.pid);
+	struct thread *thread;
 	u64 ip = event->ip.ip;
 	struct map *map = NULL;
 
+	thread = threads__findnew(event->ip.pid, &threads, &last_match);
+
 	dprintf("%p [%p]: PERF_EVENT (IP, %d): %d: %p\n",
 		(void *)(offset + head),
 		(void *)(long)(event->header.size),
@@ -719,9 +577,11 @@ process_sample_event(event_t *event, unsigned long offset, unsigned long head)
 static int
 process_mmap_event(event_t *event, unsigned long offset, unsigned long head)
 {
-	struct thread *thread = threads__findnew(event->mmap.pid);
+	struct thread *thread;
 	struct map *map = map__new(&event->mmap, NULL, 0);
 
+	thread = threads__findnew(event->mmap.pid, &threads, &last_match);
+
 	dprintf("%p [%p]: PERF_EVENT_MMAP %d: [%p(%p) @ %p]: %s\n",
 		(void *)(offset + head),
 		(void *)(long)(event->header.size),
@@ -745,8 +605,9 @@ process_mmap_event(event_t *event, unsigned long offset, unsigned long head)
 static int
 process_comm_event(event_t *event, unsigned long offset, unsigned long head)
 {
-	struct thread *thread = threads__findnew(event->comm.pid);
+	struct thread *thread;
 
+	thread = threads__findnew(event->comm.pid, &threads, &last_match);
 	dprintf("%p [%p]: PERF_EVENT_COMM: %s:%d\n",
 		(void *)(offset + head),
 		(void *)(long)(event->header.size),
@@ -765,9 +626,11 @@ process_comm_event(event_t *event, unsigned long offset, unsigned long head)
 static int
 process_fork_event(event_t *event, unsigned long offset, unsigned long head)
 {
-	struct thread *thread = threads__findnew(event->fork.pid);
-	struct thread *parent = threads__findnew(event->fork.ppid);
+	struct thread *thread;
+	struct thread *parent;
 
+	thread = threads__findnew(event->fork.pid, &threads, &last_match);
+	parent = threads__findnew(event->fork.ppid, &threads, &last_match);
 	dprintf("%p [%p]: PERF_EVENT_FORK: %d:%d\n",
 		(void *)(offset + head),
 		(void *)(long)(event->header.size),
@@ -1202,7 +1065,7 @@ more:
 		return 0;
 
 	if (verbose >= 3)
-		threads__fprintf(stdout);
+		threads__fprintf(stdout, &threads);
 
 	if (verbose >= 2)
 		dsos__fprintf(stdout);
diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index 6321951..298f26b 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -25,6 +25,8 @@
 #include "util/parse-options.h"
 #include "util/parse-events.h"
 
+#include "util/thread.h"
+
 #define SHOW_KERNEL	1
 #define SHOW_USER	2
 #define SHOW_HV		4
@@ -71,6 +73,9 @@ static char		__cwd[PATH_MAX];
 static char		*cwd = __cwd;
 static int		cwdlen;
 
+static struct rb_root	threads;
+static struct thread	*last_match;
+
 static
 struct callchain_param	callchain_param = {
 	.mode	= CHAIN_GRAPH_REL,
@@ -106,187 +111,10 @@ static int repsep_fprintf(FILE *fp, const char *fmt, ...)
 	return n;
 }
 
-struct thread {
-	struct rb_node	 rb_node;
-	struct list_head maps;
-	pid_t		 pid;
-	char		 *comm;
-};
-
-static struct thread *thread__new(pid_t pid)
-{
-	struct thread *self = malloc(sizeof(*self));
-
-	if (self != NULL) {
-		self->pid = pid;
-		self->comm = malloc(32);
-		if (self->comm)
-			snprintf(self->comm, 32, ":%d", self->pid);
-		INIT_LIST_HEAD(&self->maps);
-	}
-
-	return self;
-}
-
 static unsigned int dsos__col_width,
 		    comms__col_width,
 		    threads__col_width;
 
-static int thread__set_comm(struct thread *self, const char *comm)
-{
-	if (self->comm)
-		free(self->comm);
-	self->comm = strdup(comm);
-	if (!self->comm)
-		return -ENOMEM;
-
-	if (!col_width_list_str && !field_sep &&
-	    (!comm_list || strlist__has_entry(comm_list, comm))) {
-		unsigned int slen = strlen(comm);
-		if (slen > comms__col_width) {
-			comms__col_width = slen;
-			threads__col_width = slen + 6;
-		}
-	}
-
-	return 0;
-}
-
-static size_t thread__fprintf(struct thread *self, FILE *fp)
-{
-	struct map *pos;
-	size_t ret = fprintf(fp, "Thread %d %s\n", self->pid, self->comm);
-
-	list_for_each_entry(pos, &self->maps, node)
-		ret += map__fprintf(pos, fp);
-
-	return ret;
-}
-
-
-static struct rb_root threads;
-static struct thread *last_match;
-
-static struct thread *threads__findnew(pid_t pid)
-{
-	struct rb_node **p = &threads.rb_node;
-	struct rb_node *parent = NULL;
-	struct thread *th;
-
-	/*
-	 * Font-end cache - PID lookups come in blocks,
-	 * so most of the time we dont have to look up
-	 * the full rbtree:
-	 */
-	if (last_match && last_match->pid == pid)
-		return last_match;
-
-	while (*p != NULL) {
-		parent = *p;
-		th = rb_entry(parent, struct thread, rb_node);
-
-		if (th->pid == pid) {
-			last_match = th;
-			return th;
-		}
-
-		if (pid < th->pid)
-			p = &(*p)->rb_left;
-		else
-			p = &(*p)->rb_right;
-	}
-
-	th = thread__new(pid);
-	if (th != NULL) {
-		rb_link_node(&th->rb_node, parent, p);
-		rb_insert_color(&th->rb_node, &threads);
-		last_match = th;
-	}
-
-	return th;
-}
-
-static void thread__insert_map(struct thread *self, struct map *map)
-{
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
-		}
-	}
-
-	list_add_tail(&map->node, &self->maps);
-}
-
-static int thread__fork(struct thread *self, struct thread *parent)
-{
-	struct map *map;
-
-	if (self->comm)
-		free(self->comm);
-	self->comm = strdup(parent->comm);
-	if (!self->comm)
-		return -ENOMEM;
-
-	list_for_each_entry(map, &parent->maps, node) {
-		struct map *new = map__clone(map);
-		if (!new)
-			return -ENOMEM;
-		thread__insert_map(self, new);
-	}
-
-	return 0;
-}
-
-static struct map *thread__find_map(struct thread *self, u64 ip)
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
-static size_t threads__fprintf(FILE *fp)
-{
-	size_t ret = 0;
-	struct rb_node *nd;
-
-	for (nd = rb_first(&threads); nd; nd = rb_next(nd)) {
-		struct thread *pos = rb_entry(nd, struct thread, rb_node);
-
-		ret += thread__fprintf(pos, fp);
-	}
-
-	return ret;
-}
-
 /*
  * histogram, sorted on item, collects counts
  */
@@ -1228,7 +1056,7 @@ print_entries:
 
 static void register_idle_thread(void)
 {
-	struct thread *thread = threads__findnew(0);
+	struct thread *thread = threads__findnew(0, &threads, &last_match);
 
 	if (thread == NULL ||
 			thread__set_comm(thread, "[idle]")) {
@@ -1263,7 +1091,7 @@ process_sample_event(event_t *event, unsigned long offset, unsigned long head)
 	char level;
 	int show = 0;
 	struct dso *dso = NULL;
-	struct thread *thread = threads__findnew(event->ip.pid);
+	struct thread *thread;
 	u64 ip = event->ip.ip;
 	u64 period = 1;
 	struct map *map = NULL;
@@ -1271,6 +1099,8 @@ process_sample_event(event_t *event, unsigned long offset, unsigned long head)
 	struct ip_callchain *chain = NULL;
 	int cpumode;
 
+	thread = threads__findnew(event->ip.pid, &threads, &last_match);
+
 	if (sample_type & PERF_SAMPLE_PERIOD) {
 		period = *(u64 *)more_data;
 		more_data += sizeof(u64);
@@ -1360,9 +1190,11 @@ process_sample_event(event_t *event, unsigned long offset, unsigned long head)
 static int
 process_mmap_event(event_t *event, unsigned long offset, unsigned long head)
 {
-	struct thread *thread = threads__findnew(event->mmap.pid);
+	struct thread *thread;
 	struct map *map = map__new(&event->mmap, cwd, cwdlen);
 
+	thread = threads__findnew(event->mmap.pid, &threads, &last_match);
+
 	dprintf("%p [%p]: PERF_EVENT_MMAP %d/%d: [%p(%p) @ %p]: %s\n",
 		(void *)(offset + head),
 		(void *)(long)(event->header.size),
@@ -1387,7 +1219,9 @@ process_mmap_event(event_t *event, unsigned long offset, unsigned long head)
 static int
 process_comm_event(event_t *event, unsigned long offset, unsigned long head)
 {
-	struct thread *thread = threads__findnew(event->comm.pid);
+	struct thread *thread;
+
+	thread = threads__findnew(event->comm.pid, &threads, &last_match);
 
 	dprintf("%p [%p]: PERF_EVENT_COMM: %s:%d\n",
 		(void *)(offset + head),
@@ -1407,8 +1241,11 @@ process_comm_event(event_t *event, unsigned long offset, unsigned long head)
 static int
 process_task_event(event_t *event, unsigned long offset, unsigned long head)
 {
-	struct thread *thread = threads__findnew(event->fork.pid);
-	struct thread *parent = threads__findnew(event->fork.ppid);
+	struct thread *thread;
+	struct thread *parent;
+
+	thread = threads__findnew(event->fork.pid, &threads, &last_match);
+	parent = threads__findnew(event->fork.ppid, &threads, &last_match);
 
 	dprintf("%p [%p]: PERF_EVENT_%s: (%d:%d):(%d:%d)\n",
 		(void *)(offset + head),
@@ -1749,7 +1586,7 @@ done:
 		return 0;
 
 	if (verbose >= 3)
-		threads__fprintf(stdout);
+		threads__fprintf(stdout, &threads);
 
 	if (verbose >= 2)
 		dsos__fprintf(stdout);
diff --git a/tools/perf/util/thread.c b/tools/perf/util/thread.c
new file mode 100644
index 0000000..00c14b9
--- /dev/null
+++ b/tools/perf/util/thread.c
@@ -0,0 +1,143 @@
+#include "../perf.h"
+#include <stdlib.h>
+#include <stdio.h>
+#include <string.h>
+#include "thread.h"
+#include "util.h"
+
+static struct thread *thread__new(pid_t pid)
+{
+	struct thread *self = malloc(sizeof(*self));
+
+	if (self != NULL) {
+		self->pid = pid;
+		self->comm = malloc(32);
+		if (self->comm)
+			snprintf(self->comm, 32, ":%d", self->pid);
+		INIT_LIST_HEAD(&self->maps);
+	}
+
+	return self;
+}
+
+int thread__set_comm(struct thread *self, const char *comm)
+{
+	if (self->comm)
+		free(self->comm);
+	self->comm = strdup(comm);
+	return self->comm ? 0 : -ENOMEM;
+}
+
+static size_t thread__fprintf(struct thread *self, FILE *fp)
+{
+	struct map *pos;
+	size_t ret = fprintf(fp, "Thread %d %s\n", self->pid, self->comm);
+
+	list_for_each_entry(pos, &self->maps, node)
+		ret += map__fprintf(pos, fp);
+
+	return ret;
+}
+
+struct thread *
+threads__findnew(pid_t pid, struct rb_root *threads, struct thread **last_match)
+{
+	struct rb_node **p = &threads->rb_node;
+	struct rb_node *parent = NULL;
+	struct thread *th;
+
+	/*
+	 * Font-end cache - PID lookups come in blocks,
+	 * so most of the time we dont have to look up
+	 * the full rbtree:
+	 */
+	if (*last_match && (*last_match)->pid == pid)
+		return *last_match;
+
+	while (*p != NULL) {
+		parent = *p;
+		th = rb_entry(parent, struct thread, rb_node);
+
+		if (th->pid == pid) {
+			*last_match = th;
+			return th;
+		}
+
+		if (pid < th->pid)
+			p = &(*p)->rb_left;
+		else
+			p = &(*p)->rb_right;
+	}
+
+	th = thread__new(pid);
+	if (th != NULL) {
+		rb_link_node(&th->rb_node, parent, p);
+		rb_insert_color(&th->rb_node, threads);
+		*last_match = th;
+	}
+
+	return th;
+}
+
+void thread__insert_map(struct thread *self, struct map *map)
+{
+	struct map *pos, *tmp;
+
+	list_for_each_entry_safe(pos, tmp, &self->maps, node) {
+		if (map__overlap(pos, map)) {
+			list_del_init(&pos->node);
+			/* XXX leaks dsos */
+			free(pos);
+		}
+	}
+
+	list_add_tail(&map->node, &self->maps);
+}
+
+int thread__fork(struct thread *self, struct thread *parent)
+{
+	struct map *map;
+
+	if (self->comm)
+		free(self->comm);
+	self->comm = strdup(parent->comm);
+	if (!self->comm)
+		return -ENOMEM;
+
+	list_for_each_entry(map, &parent->maps, node) {
+		struct map *new = map__clone(map);
+		if (!new)
+			return -ENOMEM;
+		thread__insert_map(self, new);
+	}
+
+	return 0;
+}
+
+struct map *thread__find_map(struct thread *self, u64 ip)
+{
+	struct map *pos;
+
+	if (self == NULL)
+		return NULL;
+
+	list_for_each_entry(pos, &self->maps, node)
+		if (ip >= pos->start && ip <= pos->end)
+			return pos;
+
+	return NULL;
+}
+
+size_t threads__fprintf(FILE *fp, struct rb_root *threads)
+{
+	size_t ret = 0;
+	struct rb_node *nd;
+
+	for (nd = rb_first(threads); nd; nd = rb_next(nd)) {
+		struct thread *pos = rb_entry(nd, struct thread, rb_node);
+
+		ret += thread__fprintf(pos, fp);
+	}
+
+	return ret;
+}
diff --git a/tools/perf/util/thread.h b/tools/perf/util/thread.h
new file mode 100644
index 0000000..b1c6671
--- /dev/null
+++ b/tools/perf/util/thread.h
@@ -0,0 +1,19 @@
+#include <linux/rbtree.h>
+#include <linux/list.h>
+#include <unistd.h>
+#include "symbol.h"
+
+struct thread {
+	struct rb_node	 rb_node;
+	struct list_head maps;
+	pid_t		 pid;
+	char		 *comm;
+};
+
+int thread__set_comm(struct thread *self, const char *comm);
+struct thread *
+threads__findnew(pid_t pid, struct rb_root *threads, struct thread **last_match);
+void thread__insert_map(struct thread *self, struct map *map);
+int thread__fork(struct thread *self, struct thread *parent);
+struct map *thread__find_map(struct thread *self, u64 ip);
+size_t threads__fprintf(FILE *fp, struct rb_root *threads);
-- 
1.6.2.3

