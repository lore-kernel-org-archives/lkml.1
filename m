Return-Path: <linux-kernel-owner+w=401wt.eu-S1755924AbZFCWgk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755924AbZFCWgk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jun 2009 18:36:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754730AbZFCWgX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Jun 2009 18:36:23 -0400
Received: from hera.kernel.org ([140.211.167.34]:43612 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754802AbZFCWgT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jun 2009 18:36:19 -0400
Date: Wed, 3 Jun 2009 22:35:47 GMT
From: tip-bot for Ingo Molnar <mingo@elte.hu>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, paulus@samba.org,
       hpa@zytor.com, mingo@redhat.com, a.p.zijlstra@chello.nl, efault@gmx.de,
       mtosatti@redhat.com, tglx@linutronix.de, cjashfor@linux.vnet.ibm.com,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org, acme@redhat.com,
       linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl, efault@gmx.de,
       mtosatti@redhat.com, tglx@linutronix.de, cjashfor@linux.vnet.ibm.com,
       mingo@elte.hu
In-Reply-To: <new-submission>
References: <new-submission>
Subject: [tip:perfcounters/core] perf report: Split out event processing helpers
Message-ID: <tip-75051724f78677532618dd164a515baf106990e5@git.kernel.org>
Git-Commit-ID: 75051724f78677532618dd164a515baf106990e5
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 03 Jun 2009 22:35:47 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  75051724f78677532618dd164a515baf106990e5
Gitweb:     http://git.kernel.org/tip/75051724f78677532618dd164a515baf106990e5
Author:     Ingo Molnar <mingo@elte.hu>
AuthorDate: Wed, 3 Jun 2009 23:14:49 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 3 Jun 2009 23:26:49 +0200

perf report: Split out event processing helpers

- Introduce per event helper functions

Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Marcelo Tosatti <mtosatti@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
LKML-Reference: <new-submission>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 Documentation/perf_counter/builtin-report.c |  213 +++++++++++++++------------
 1 files changed, 119 insertions(+), 94 deletions(-)

diff --git a/Documentation/perf_counter/builtin-report.c b/Documentation/perf_counter/builtin-report.c
index 333d312..82b6252 100644
--- a/Documentation/perf_counter/builtin-report.c
+++ b/Documentation/perf_counter/builtin-report.c
@@ -50,6 +50,7 @@ struct ip_event {
 	__u64 ip;
 	__u32 pid, tid;
 };
+
 struct mmap_event {
 	struct perf_event_header header;
 	__u32 pid, tid;
@@ -58,9 +59,10 @@ struct mmap_event {
 	__u64 pgoff;
 	char filename[PATH_MAX];
 };
+
 struct comm_event {
 	struct perf_event_header header;
-	__u32 pid,tid;
+	__u32 pid, tid;
 	char comm[16];
 };
 
@@ -760,114 +762,137 @@ static void register_idle_thread(void)
 static unsigned long total = 0, total_mmap = 0, total_comm = 0, total_unknown = 0;
 
 static int
-process_event(event_t *event, unsigned long offset, unsigned long head)
+process_overflow_event(event_t *event, unsigned long offset, unsigned long head)
 {
-	if (event->header.misc & PERF_EVENT_MISC_OVERFLOW) {
-		char level;
-		int show = 0;
-		struct dso *dso = NULL;
-		struct thread *thread = threads__findnew(event->ip.pid);
-		uint64_t ip = event->ip.ip;
-		struct map *map = NULL;
-
-		dprintf("%p [%p]: PERF_EVENT (IP, %d): %d: %p\n",
-			(void *)(offset + head),
-			(void *)(long)(event->header.size),
-			event->header.misc,
-			event->ip.pid,
-			(void *)(long)ip);
-
-		dprintf(" ... thread: %s:%d\n", thread->comm, thread->pid);
-
-		if (thread == NULL) {
-			fprintf(stderr, "problem processing %d event, skipping it.\n",
-				event->header.type);
-			return -1;
-		}
-
-		if (event->header.misc & PERF_EVENT_MISC_KERNEL) {
-			show = SHOW_KERNEL;
-			level = 'k';
+	char level;
+	int show = 0;
+	struct dso *dso = NULL;
+	struct thread *thread = threads__findnew(event->ip.pid);
+	uint64_t ip = event->ip.ip;
+	struct map *map = NULL;
+
+	dprintf("%p [%p]: PERF_EVENT (IP, %d): %d: %p\n",
+		(void *)(offset + head),
+		(void *)(long)(event->header.size),
+		event->header.misc,
+		event->ip.pid,
+		(void *)(long)ip);
+
+	dprintf(" ... thread: %s:%d\n", thread->comm, thread->pid);
+
+	if (thread == NULL) {
+		fprintf(stderr, "problem processing %d event, skipping it.\n",
+			event->header.type);
+		return -1;
+	}
 
-			dso = kernel_dso;
+	if (event->header.misc & PERF_EVENT_MISC_KERNEL) {
+		show = SHOW_KERNEL;
+		level = 'k';
 
-			dprintf(" ...... dso: %s\n", dso->name);
+		dso = kernel_dso;
 
-		} else if (event->header.misc & PERF_EVENT_MISC_USER) {
+		dprintf(" ...... dso: %s\n", dso->name);
 
-			show = SHOW_USER;
-			level = '.';
+	} else if (event->header.misc & PERF_EVENT_MISC_USER) {
 
-			map = thread__find_map(thread, ip);
-			if (map != NULL) {
-				dso = map->dso;
-				ip -= map->start + map->pgoff;
-			} else {
-				/*
-				 * If this is outside of all known maps,
-				 * and is a negative address, try to look it
-				 * up in the kernel dso, as it might be a
-				 * vsyscall (which executes in user-mode):
-				 */
-				if ((long long)ip < 0)
-					dso = kernel_dso;
-			}
-			dprintf(" ...... dso: %s\n", dso ? dso->name : "<not found>");
+		show = SHOW_USER;
+		level = '.';
 
+		map = thread__find_map(thread, ip);
+		if (map != NULL) {
+			dso = map->dso;
+			ip -= map->start + map->pgoff;
 		} else {
-			show = SHOW_HV;
-			level = 'H';
-			dprintf(" ...... dso: [hypervisor]\n");
+			/*
+			 * If this is outside of all known maps,
+			 * and is a negative address, try to look it
+			 * up in the kernel dso, as it might be a
+			 * vsyscall (which executes in user-mode):
+			 */
+			if ((long long)ip < 0)
+				dso = kernel_dso;
 		}
+		dprintf(" ...... dso: %s\n", dso ? dso->name : "<not found>");
 
-		if (show & show_mask) {
-			struct symbol *sym = dso__find_symbol(dso, ip);
+	} else {
+		show = SHOW_HV;
+		level = 'H';
+		dprintf(" ...... dso: [hypervisor]\n");
+	}
 
-			if (hist_entry__add(thread, map, dso, sym, ip, level)) {
-				fprintf(stderr,
-		"problem incrementing symbol count, skipping event\n");
-				return -1;
-			}
-		}
-		total++;
-	} else switch (event->header.type) {
-	case PERF_EVENT_MMAP: {
-		struct thread *thread = threads__findnew(event->mmap.pid);
-		struct map *map = map__new(&event->mmap);
+	if (show & show_mask) {
+		struct symbol *sym = dso__find_symbol(dso, ip);
 
-		dprintf("%p [%p]: PERF_EVENT_MMAP: [%p(%p) @ %p]: %s\n",
-			(void *)(offset + head),
-			(void *)(long)(event->header.size),
-			(void *)(long)event->mmap.start,
-			(void *)(long)event->mmap.len,
-			(void *)(long)event->mmap.pgoff,
-			event->mmap.filename);
-
-		if (thread == NULL || map == NULL) {
-			if (verbose)
-				fprintf(stderr, "problem processing PERF_EVENT_MMAP, skipping event.\n");
+		if (hist_entry__add(thread, map, dso, sym, ip, level)) {
+			fprintf(stderr,
+		"problem incrementing symbol count, skipping event\n");
 			return -1;
 		}
-		thread__insert_map(thread, map);
-		total_mmap++;
-		break;
 	}
-	case PERF_EVENT_COMM: {
-		struct thread *thread = threads__findnew(event->comm.pid);
+	total++;
 
-		dprintf("%p [%p]: PERF_EVENT_COMM: %s:%d\n",
-			(void *)(offset + head),
-			(void *)(long)(event->header.size),
-			event->comm.comm, event->comm.pid);
+	return 0;
+}
 
-		if (thread == NULL ||
-		    thread__set_comm(thread, event->comm.comm)) {
-			fprintf(stderr, "problem processing PERF_EVENT_COMM, skipping event.\n");
-			return -1;
-		}
-		total_comm++;
-		break;
+static int
+process_mmap_event(event_t *event, unsigned long offset, unsigned long head)
+{
+	struct thread *thread = threads__findnew(event->mmap.pid);
+	struct map *map = map__new(&event->mmap);
+
+	dprintf("%p [%p]: PERF_EVENT_MMAP: [%p(%p) @ %p]: %s\n",
+		(void *)(offset + head),
+		(void *)(long)(event->header.size),
+		(void *)(long)event->mmap.start,
+		(void *)(long)event->mmap.len,
+		(void *)(long)event->mmap.pgoff,
+		event->mmap.filename);
+
+	if (thread == NULL || map == NULL) {
+		dprintf("problem processing PERF_EVENT_MMAP, skipping event.\n");
+		return -1;
+	}
+
+	thread__insert_map(thread, map);
+	total_mmap++;
+
+	return 0;
+}
+
+static int
+process_comm_event(event_t *event, unsigned long offset, unsigned long head)
+{
+	struct thread *thread = threads__findnew(event->comm.pid);
+
+	dprintf("%p [%p]: PERF_EVENT_COMM: %s:%d\n",
+		(void *)(offset + head),
+		(void *)(long)(event->header.size),
+		event->comm.comm, event->comm.pid);
+
+	if (thread == NULL ||
+	    thread__set_comm(thread, event->comm.comm)) {
+		dprintf("problem processing PERF_EVENT_COMM, skipping event.\n");
+		return -1;
 	}
+	total_comm++;
+
+	return 0;
+}
+
+static int
+process_event(event_t *event, unsigned long offset, unsigned long head)
+{
+	if (event->header.misc & PERF_EVENT_MISC_OVERFLOW)
+		return process_overflow_event(event, offset, head);
+
+	switch (event->header.type) {
+	case PERF_EVENT_MMAP:
+		return process_mmap_event(event, offset, head);
+
+	case PERF_EVENT_COMM:
+		return process_comm_event(event, offset, head);
+
 	default:
 		return -1;
 	}
@@ -877,13 +902,13 @@ process_event(event_t *event, unsigned long offset, unsigned long head)
 
 static int __cmd_report(void)
 {
+	int ret, rc = EXIT_FAILURE;
 	unsigned long offset = 0;
 	unsigned long head = 0;
 	struct stat stat;
-	char *buf;
 	event_t *event;
-	int ret, rc = EXIT_FAILURE;
 	uint32_t size;
+	char *buf;
 
 	register_idle_thread();
 
