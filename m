Return-Path: <linux-kernel-owner+w=401wt.eu-S1756435AbZFDQBx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756435AbZFDQBx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jun 2009 12:01:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757756AbZFDQBe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Jun 2009 12:01:34 -0400
Received: from hera.kernel.org ([140.211.167.34]:37243 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757707AbZFDQBb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jun 2009 12:01:31 -0400
Date: Thu, 4 Jun 2009 16:01:01 GMT
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, paulus@samba.org,
       hpa@zytor.com, mingo@redhat.com, a.p.zijlstra@chello.nl, efault@gmx.de,
       tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org, acme@redhat.com,
       linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl, efault@gmx.de,
       tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <new-submission>
References: <new-submission>
Subject: [tip:perfcounters/core] perf_counter tools: Use fork and remove munmap events
Message-ID: <tip-62fc44536c14b5787531bac7417580fca54c88b4@git.kernel.org>
Git-Commit-ID: 62fc44536c14b5787531bac7417580fca54c88b4
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Thu, 04 Jun 2009 16:01:02 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  62fc44536c14b5787531bac7417580fca54c88b4
Gitweb:     http://git.kernel.org/tip/62fc44536c14b5787531bac7417580fca54c88b4
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Thu, 4 Jun 2009 16:53:49 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 4 Jun 2009 17:51:39 +0200

perf_counter tools: Use fork and remove munmap events

Use fork events to clone comm and map data and remove everything
munmap related

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
LKML-Reference: <new-submission>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 Documentation/perf_counter/builtin-report.c |  103 ++++++++++++++++++++++++---
 Documentation/perf_counter/builtin-top.c    |   21 ------
 2 files changed, 93 insertions(+), 31 deletions(-)

diff --git a/Documentation/perf_counter/builtin-report.c b/Documentation/perf_counter/builtin-report.c
index 389ae25..5d19121 100644
--- a/Documentation/perf_counter/builtin-report.c
+++ b/Documentation/perf_counter/builtin-report.c
@@ -43,12 +43,6 @@ static int		full_paths;
 static unsigned long	page_size;
 static unsigned long	mmap_window = 32;
 
-const char *perf_event_names[] = {
-	[PERF_EVENT_MMAP]   = " PERF_EVENT_MMAP",
-	[PERF_EVENT_MUNMAP] = " PERF_EVENT_MUNMAP",
-	[PERF_EVENT_COMM]   = " PERF_EVENT_COMM",
-};
-
 struct ip_event {
 	struct perf_event_header header;
 	__u64 ip;
@@ -70,11 +64,17 @@ struct comm_event {
 	char comm[16];
 };
 
+struct fork_event {
+	struct perf_event_header header;
+	__u32 pid, ppid;
+};
+
 typedef union event_union {
 	struct perf_event_header header;
 	struct ip_event ip;
 	struct mmap_event mmap;
 	struct comm_event comm;
+	struct fork_event fork;
 } event_t;
 
 static LIST_HEAD(dsos);
@@ -208,7 +208,31 @@ out_delete:
 	return NULL;
 }
 
-struct thread;
+static struct map *map__clone(struct map *self)
+{
+	struct map *map = malloc(sizeof(*self));
+
+	if (!map)
+		return NULL;
+
+	memcpy(map, self, sizeof(*self));
+
+	return map;
+}
+
+static int map__overlap(struct map *l, struct map *r)
+{
+	if (l->start > r->start) {
+		struct map *t = l;
+		l = r;
+		r = t;
+	}
+
+	if (l->end > r->start)
+		return 1;
+
+	return 0;
+}
 
 struct thread {
 	struct rb_node	 rb_node;
@@ -284,9 +308,39 @@ static struct thread *threads__findnew(pid_t pid)
 
 static void thread__insert_map(struct thread *self, struct map *map)
 {
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
 	list_add_tail(&map->node, &self->maps);
 }
 
+static int thread__fork(struct thread *self, struct thread *parent)
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
 static struct map *thread__find_map(struct thread *self, uint64_t ip)
 {
 	struct map *pos;
@@ -784,7 +838,11 @@ static void register_idle_thread(void)
 	}
 }
 
-static unsigned long total = 0, total_mmap = 0, total_comm = 0, total_unknown = 0;
+static unsigned long total = 0,
+		     total_mmap = 0,
+		     total_comm = 0,
+		     total_fork = 0,
+		     total_unknown = 0;
 
 static int
 process_overflow_event(event_t *event, unsigned long offset, unsigned long head)
@@ -866,9 +924,10 @@ process_mmap_event(event_t *event, unsigned long offset, unsigned long head)
 	struct thread *thread = threads__findnew(event->mmap.pid);
 	struct map *map = map__new(&event->mmap);
 
-	dprintf("%p [%p]: PERF_EVENT_MMAP: [%p(%p) @ %p]: %s\n",
+	dprintf("%p [%p]: PERF_EVENT_MMAP %d: [%p(%p) @ %p]: %s\n",
 		(void *)(offset + head),
 		(void *)(long)(event->header.size),
+		event->mmap.pid,
 		(void *)(long)event->mmap.start,
 		(void *)(long)event->mmap.len,
 		(void *)(long)event->mmap.pgoff,
@@ -906,6 +965,26 @@ process_comm_event(event_t *event, unsigned long offset, unsigned long head)
 }
 
 static int
+process_fork_event(event_t *event, unsigned long offset, unsigned long head)
+{
+	struct thread *thread = threads__findnew(event->fork.pid);
+	struct thread *parent = threads__findnew(event->fork.ppid);
+
+	dprintf("%p [%p]: PERF_EVENT_FORK: %d:%d\n",
+		(void *)(offset + head),
+		(void *)(long)(event->header.size),
+		event->fork.pid, event->fork.ppid);
+
+	if (!thread || !parent || thread__fork(thread, parent)) {
+		dprintf("problem processing PERF_EVENT_FORK, skipping event.\n");
+		return -1;
+	}
+	total_fork++;
+
+	return 0;
+}
+
+static int
 process_event(event_t *event, unsigned long offset, unsigned long head)
 {
 	if (event->header.misc & PERF_EVENT_MISC_OVERFLOW)
@@ -918,10 +997,13 @@ process_event(event_t *event, unsigned long offset, unsigned long head)
 	case PERF_EVENT_COMM:
 		return process_comm_event(event, offset, head);
 
+	case PERF_EVENT_FORK:
+		return process_fork_event(event, offset, head);
+
 	/*
 	 * We dont process them right now but they are fine:
 	 */
-	case PERF_EVENT_MUNMAP:
+
 	case PERF_EVENT_PERIOD:
 	case PERF_EVENT_THROTTLE:
 	case PERF_EVENT_UNTHROTTLE:
@@ -1038,6 +1120,7 @@ more:
 	dprintf("      IP events: %10ld\n", total);
 	dprintf("    mmap events: %10ld\n", total_mmap);
 	dprintf("    comm events: %10ld\n", total_comm);
+	dprintf("    fork events: %10ld\n", total_fork);
 	dprintf(" unknown events: %10ld\n", total_unknown);
 
 	if (dump_trace)
diff --git a/Documentation/perf_counter/builtin-top.c b/Documentation/perf_counter/builtin-top.c
index 20e5b12..31c00ba 100644
--- a/Documentation/perf_counter/builtin-top.c
+++ b/Documentation/perf_counter/builtin-top.c
@@ -75,8 +75,6 @@ static unsigned int		realtime_prio			=  0;
 static int			group				=  0;
 static unsigned int		page_size;
 static unsigned int		mmap_pages			=  16;
-static int			use_mmap			= 0;
-static int			use_munmap			= 0;
 static int			freq				= 0;
 
 static char			*sym_filter;
@@ -527,19 +525,6 @@ static void mmap_read(struct mmap_data *md)
 		if (event->header.misc & PERF_EVENT_MISC_OVERFLOW) {
 			if (event->header.type & PERF_SAMPLE_IP)
 				process_event(event->ip.ip, md->counter);
-		} else {
-			switch (event->header.type) {
-				case PERF_EVENT_MMAP:
-				case PERF_EVENT_MUNMAP:
-					printf("%s: %Lu %Lu %Lu %s\n",
-							event->header.type == PERF_EVENT_MMAP
-							? "mmap" : "munmap",
-							event->mmap.start,
-							event->mmap.len,
-							event->mmap.pgoff,
-							event->mmap.filename);
-					break;
-			}
 		}
 	}
 
@@ -569,8 +554,6 @@ static int __cmd_top(void)
 			attr.config		= event_id[counter];
 			attr.sample_period	= event_count[counter];
 			attr.sample_type	= PERF_SAMPLE_IP | PERF_SAMPLE_TID;
-			attr.mmap		= use_mmap;
-			attr.munmap		= use_munmap;
 			attr.freq		= freq;
 
 			fd[i][counter] = sys_perf_counter_open(&attr, target_pid, cpu, group_fd, 0);
@@ -670,10 +653,6 @@ static const struct option options[] = {
 		    "only display symbols matchig this pattern"),
 	OPT_BOOLEAN('z', "zero", &group,
 		    "zero history across updates"),
-	OPT_BOOLEAN('M', "use-mmap", &use_mmap,
-		    "track mmap events"),
-	OPT_BOOLEAN('U', "use-munmap", &use_munmap,
-		    "track munmap events"),
 	OPT_INTEGER('F', "freq", &freq,
 		    "profile at this frequency"),
 	OPT_INTEGER('E', "entries", &print_entries,
