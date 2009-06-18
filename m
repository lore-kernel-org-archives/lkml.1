Return-Path: <linux-kernel-owner+w=401wt.eu-S1764107AbZFRMw5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764107AbZFRMw5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jun 2009 08:52:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758687AbZFRMvR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Jun 2009 08:51:17 -0400
Received: from hera.kernel.org ([140.211.167.34]:38274 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763566AbZFRMvO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jun 2009 08:51:14 -0400
Date: Thu, 18 Jun 2009 12:50:38 GMT
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
Subject: [tip:perfcounters/core] perf_counter tools: Handle lost events
Message-ID: <tip-9d91a6f7a489eb914c16b82d927f9d81d629c259@git.kernel.org>
Git-Commit-ID: 9d91a6f7a489eb914c16b82d927f9d81d629c259
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Thu, 18 Jun 2009 12:50:39 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  9d91a6f7a489eb914c16b82d927f9d81d629c259
Gitweb:     http://git.kernel.org/tip/9d91a6f7a489eb914c16b82d927f9d81d629c259
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Thu, 18 Jun 2009 11:40:28 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 18 Jun 2009 14:46:11 +0200

perf_counter tools: Handle lost events

Make use of the new ->data_tail mechanism to tell kernel-space
about user-space draining the data stream. Emit lost events
(and display them) if they happen.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
LKML-Reference: <new-submission>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 tools/perf/builtin-record.c |   20 ++++++++++++++++----
 tools/perf/builtin-report.c |   29 ++++++++++++++++++++++++++++-
 2 files changed, 44 insertions(+), 5 deletions(-)

diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index e1dfef2..06fdfb8 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -78,10 +78,10 @@ struct mmap_data {
 
 static struct mmap_data		mmap_array[MAX_NR_CPUS][MAX_COUNTERS];
 
-static unsigned int mmap_read_head(struct mmap_data *md)
+static unsigned long mmap_read_head(struct mmap_data *md)
 {
 	struct perf_counter_mmap_page *pc = md->base;
-	int head;
+	long head;
 
 	head = pc->data_head;
 	rmb();
@@ -89,6 +89,17 @@ static unsigned int mmap_read_head(struct mmap_data *md)
 	return head;
 }
 
+static void mmap_write_tail(struct mmap_data *md, unsigned long tail)
+{
+	struct perf_counter_mmap_page *pc = md->base;
+
+	/*
+	 * ensure all reads are done before we write the tail out.
+	 */
+	/* mb(); */
+	pc->data_tail = tail;
+}
+
 static void mmap_read(struct mmap_data *md)
 {
 	unsigned int head = mmap_read_head(md);
@@ -109,7 +120,7 @@ static void mmap_read(struct mmap_data *md)
 	 * In either case, truncate and restart at head.
 	 */
 	diff = head - old;
-	if (diff > md->mask / 2 || diff < 0) {
+	if (diff < 0) {
 		struct timeval iv;
 		unsigned long msecs;
 
@@ -167,6 +178,7 @@ static void mmap_read(struct mmap_data *md)
 	}
 
 	md->prev = old;
+	mmap_write_tail(md, old);
 }
 
 static volatile int done = 0;
@@ -424,7 +436,7 @@ try_again:
 	mmap_array[nr_cpu][counter].prev = 0;
 	mmap_array[nr_cpu][counter].mask = mmap_pages*page_size - 1;
 	mmap_array[nr_cpu][counter].base = mmap(NULL, (mmap_pages+1)*page_size,
-			PROT_READ, MAP_SHARED, fd[nr_cpu][counter], 0);
+			PROT_READ|PROT_WRITE, MAP_SHARED, fd[nr_cpu][counter], 0);
 	if (mmap_array[nr_cpu][counter].base == MAP_FAILED) {
 		error("failed to mmap with %d (%s)\n", errno, strerror(errno));
 		exit(-1);
diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index 9a3805f..fe66895 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -83,6 +83,12 @@ struct period_event {
 	__u64 sample_period;
 };
 
+struct lost_event {
+	struct perf_event_header header;
+	__u64 id;
+	__u64 lost;
+};
+
 typedef union event_union {
 	struct perf_event_header	header;
 	struct ip_event			ip;
@@ -90,6 +96,7 @@ typedef union event_union {
 	struct comm_event		comm;
 	struct fork_event		fork;
 	struct period_event		period;
+	struct lost_event		lost;
 } event_t;
 
 static LIST_HEAD(dsos);
@@ -1068,7 +1075,8 @@ static unsigned long total = 0,
 		     total_mmap = 0,
 		     total_comm = 0,
 		     total_fork = 0,
-		     total_unknown = 0;
+		     total_unknown = 0,
+		     total_lost = 0;
 
 static int validate_chain(struct perf_callchain_entry *chain, event_t *event)
 {
@@ -1260,6 +1268,20 @@ process_period_event(event_t *event, unsigned long offset, unsigned long head)
 	return 0;
 }
 
+static int
+process_lost_event(event_t *event, unsigned long offset, unsigned long head)
+{
+	dprintf("%p [%p]: PERF_EVENT_LOST: id:%Ld: lost:%Ld\n",
+		(void *)(offset + head),
+		(void *)(long)(event->header.size),
+		event->lost.id,
+		event->lost.lost);
+
+	total_lost += event->lost.lost;
+
+	return 0;
+}
+
 static void trace_event(event_t *event)
 {
 	unsigned char *raw_event = (void *)event;
@@ -1316,6 +1338,10 @@ process_event(event_t *event, unsigned long offset, unsigned long head)
 
 	case PERF_EVENT_PERIOD:
 		return process_period_event(event, offset, head);
+
+	case PERF_EVENT_LOST:
+		return process_lost_event(event, offset, head);
+
 	/*
 	 * We dont process them right now but they are fine:
 	 */
@@ -1444,6 +1470,7 @@ more:
 	dprintf("    mmap events: %10ld\n", total_mmap);
 	dprintf("    comm events: %10ld\n", total_comm);
 	dprintf("    fork events: %10ld\n", total_fork);
+	dprintf("    lost events: %10ld\n", total_lost);
 	dprintf(" unknown events: %10ld\n", total_unknown);
 
 	if (dump_trace)
