Return-Path: <linux-kernel-owner+w=401wt.eu-S933014AbZKXOFZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933014AbZKXOFZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Nov 2009 09:05:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932929AbZKXOFY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Nov 2009 09:05:24 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:52537 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932922AbZKXOFW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Nov 2009 09:05:22 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
       =?utf-8?q?Fr=C3=A9d=C3=A9ric=20Weisbecker?= <fweisbec@gmail.com>,
       Mike Galbraith <efault@gmx.de>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>
Subject: [PATCH 3/4] perf tools: Introduce zalloc for the common calloc(1, N) case
Date: Tue, 24 Nov 2009 12:05:16 -0200
Message-Id: <1259071517-3242-3-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1259071517-3242-2-git-send-email-acme@infradead.org>
References: <1259071517-3242-1-git-send-email-acme@infradead.org>
 <1259071517-3242-2-git-send-email-acme@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

This way we type less characters and it looks more like the kzalloc
kernel counterpart.

Cc: Frédéric Weisbecker <fweisbec@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/bench/mem-memcpy.c  |    4 ++--
 tools/perf/builtin-help.c      |    4 ++--
 tools/perf/builtin-probe.c     |    4 ++--
 tools/perf/builtin-sched.c     |   14 +++++---------
 tools/perf/builtin-top.c       |    2 +-
 tools/perf/util/header.c       |    2 +-
 tools/perf/util/parse-events.c |    2 +-
 tools/perf/util/symbol.c       |   11 +++++------
 tools/perf/util/thread.c       |    2 +-
 tools/perf/util/util.h         |    5 +++++
 10 files changed, 25 insertions(+), 25 deletions(-)

diff --git a/tools/perf/bench/mem-memcpy.c b/tools/perf/bench/mem-memcpy.c
index 5165fd1..8977317 100644
--- a/tools/perf/bench/mem-memcpy.c
+++ b/tools/perf/bench/mem-memcpy.c
@@ -127,11 +127,11 @@ int bench_mem_memcpy(int argc, const char **argv,
 		return 1;
 	}
 
-	dst = calloc(length, sizeof(char));
+	dst = zalloc(length);
 	if (!dst)
 		die("memory allocation failed - maybe length is too large?\n");
 
-	src = calloc(length, sizeof(char));
+	src = zalloc(length);
 	if (!src)
 		die("memory allocation failed - maybe length is too large?\n");
 
diff --git a/tools/perf/builtin-help.c b/tools/perf/builtin-help.c
index 768f9c8..9f810b1 100644
--- a/tools/perf/builtin-help.c
+++ b/tools/perf/builtin-help.c
@@ -179,7 +179,7 @@ static void add_man_viewer(const char *name)
 
 	while (*p)
 		p = &((*p)->next);
-	*p = calloc(1, (sizeof(**p) + len + 1));
+	*p = zalloc(sizeof(**p) + len + 1);
 	strncpy((*p)->name, name, len);
 }
 
@@ -194,7 +194,7 @@ static void do_add_man_viewer_info(const char *name,
 				   size_t len,
 				   const char *value)
 {
-	struct man_viewer_info_list *new = calloc(1, sizeof(*new) + len + 1);
+	struct man_viewer_info_list *new = zalloc(sizeof(*new) + len + 1);
 
 	strncpy(new->name, name, len);
 	new->info = strdup(value);
diff --git a/tools/perf/builtin-probe.c b/tools/perf/builtin-probe.c
index d78a3d9..a2f6daf 100644
--- a/tools/perf/builtin-probe.c
+++ b/tools/perf/builtin-probe.c
@@ -309,9 +309,9 @@ static int synthesize_probe_event(struct probe_point *pp)
 {
 	char *buf;
 	int i, len, ret;
-	pp->probes[0] = buf = (char *)calloc(MAX_CMDLEN, sizeof(char));
+	pp->probes[0] = buf = zalloc(MAX_CMDLEN);
 	if (!buf)
-		die("Failed to allocate memory by calloc.");
+		die("Failed to allocate memory by zalloc.");
 	ret = snprintf(buf, MAX_CMDLEN, "%s+%d", pp->function, pp->offset);
 	if (ret <= 0 || ret >= MAX_CMDLEN)
 		goto error;
diff --git a/tools/perf/builtin-sched.c b/tools/perf/builtin-sched.c
index dbf089b..19eb708 100644
--- a/tools/perf/builtin-sched.c
+++ b/tools/perf/builtin-sched.c
@@ -225,7 +225,7 @@ static void calibrate_sleep_measurement_overhead(void)
 static struct sched_atom *
 get_new_event(struct task_desc *task, u64 timestamp)
 {
-	struct sched_atom *event = calloc(1, sizeof(*event));
+	struct sched_atom *event = zalloc(sizeof(*event));
 	unsigned long idx = task->nr_events;
 	size_t size;
 
@@ -293,7 +293,7 @@ add_sched_event_wakeup(struct task_desc *task, u64 timestamp,
 		return;
 	}
 
-	wakee_event->wait_sem = calloc(1, sizeof(*wakee_event->wait_sem));
+	wakee_event->wait_sem = zalloc(sizeof(*wakee_event->wait_sem));
 	sem_init(wakee_event->wait_sem, 0, 0);
 	wakee_event->specific_wait = 1;
 	event->wait_sem = wakee_event->wait_sem;
@@ -323,7 +323,7 @@ static struct task_desc *register_pid(unsigned long pid, const char *comm)
 	if (task)
 		return task;
 
-	task = calloc(1, sizeof(*task));
+	task = zalloc(sizeof(*task));
 	task->pid = pid;
 	task->nr = nr_tasks;
 	strcpy(task->comm, comm);
@@ -962,9 +962,7 @@ __thread_latency_insert(struct rb_root *root, struct work_atoms *data,
 
 static void thread_atoms_insert(struct thread *thread)
 {
-	struct work_atoms *atoms;
-
-	atoms = calloc(sizeof(*atoms), 1);
+	struct work_atoms *atoms = zalloc(sizeof(*atoms));
 	if (!atoms)
 		die("No memory");
 
@@ -996,9 +994,7 @@ add_sched_out_event(struct work_atoms *atoms,
 		    char run_state,
 		    u64 timestamp)
 {
-	struct work_atom *atom;
-
-	atom = calloc(sizeof(*atom), 1);
+	struct work_atom *atom = zalloc(sizeof(*atom));
 	if (!atom)
 		die("Non memory");
 
diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
index a212475..4c8653a 100644
--- a/tools/perf/builtin-top.c
+++ b/tools/perf/builtin-top.c
@@ -181,7 +181,7 @@ static void parse_source(struct sym_entry *syme)
 		return;
 
 	if (syme->src == NULL) {
-		syme->src = calloc(1, sizeof(*source));
+		syme->src = zalloc(sizeof(*source));
 		if (syme->src == NULL)
 			return;
 		pthread_mutex_init(&syme->src->lock, NULL);
diff --git a/tools/perf/util/header.c b/tools/perf/util/header.c
index 271a160..4b58656 100644
--- a/tools/perf/util/header.c
+++ b/tools/perf/util/header.c
@@ -63,7 +63,7 @@ int perf_header_attr__add_id(struct perf_header_attr *self, u64 id)
  */
 struct perf_header *perf_header__new(void)
 {
-	struct perf_header *self = calloc(sizeof(*self), 1);
+	struct perf_header *self = zalloc(sizeof(*self));
 
 	if (self != NULL) {
 		self->size = 1;
diff --git a/tools/perf/util/parse-events.c b/tools/perf/util/parse-events.c
index 0700274..9e5dbd6 100644
--- a/tools/perf/util/parse-events.c
+++ b/tools/perf/util/parse-events.c
@@ -197,7 +197,7 @@ struct tracepoint_path *tracepoint_id_to_path(u64 config)
 			if (id == config) {
 				closedir(evt_dir);
 				closedir(sys_dir);
-				path = calloc(1, sizeof(path));
+				path = zalloc(sizeof(path));
 				path->system = malloc(MAX_EVENT_LENGTH);
 				if (!path->system) {
 					free(path);
diff --git a/tools/perf/util/symbol.c b/tools/perf/util/symbol.c
index c4ca974..8db85b4 100644
--- a/tools/perf/util/symbol.c
+++ b/tools/perf/util/symbol.c
@@ -94,15 +94,14 @@ static void kernel_maps__fixup_end(void)
 static struct symbol *symbol__new(u64 start, u64 len, const char *name)
 {
 	size_t namelen = strlen(name) + 1;
-	struct symbol *self = calloc(1, (symbol__priv_size +
-					 sizeof(*self) + namelen));
-	if (!self)
+	struct symbol *self = zalloc(symbol__priv_size +
+				     sizeof(*self) + namelen);
+	if (self == NULL)
 		return NULL;
 
-	if (symbol__priv_size) {
-		memset(self, 0, symbol__priv_size);
+	if (symbol__priv_size)
 		self = ((void *)self) + symbol__priv_size;
-	}
+
 	self->start = start;
 	self->end   = len ? start + len - 1 : start;
 
diff --git a/tools/perf/util/thread.c b/tools/perf/util/thread.c
index 0f6d78c..1796625 100644
--- a/tools/perf/util/thread.c
+++ b/tools/perf/util/thread.c
@@ -11,7 +11,7 @@ static struct thread *last_match;
 
 static struct thread *thread__new(pid_t pid)
 {
-	struct thread *self = calloc(1, sizeof(*self));
+	struct thread *self = zalloc(sizeof(*self));
 
 	if (self != NULL) {
 		self->pid = pid;
diff --git a/tools/perf/util/util.h b/tools/perf/util/util.h
index e1c623e..30c5517 100644
--- a/tools/perf/util/util.h
+++ b/tools/perf/util/util.h
@@ -302,6 +302,11 @@ extern int xdup(int fd);
 extern FILE *xfdopen(int fd, const char *mode);
 extern int xmkstemp(char *template);
 
+static inline void *zalloc(size_t size)
+{
+	return calloc(1, size);
+}
+
 static inline size_t xsize_t(off_t len)
 {
 	return (size_t)len;
-- 
1.6.2.5

