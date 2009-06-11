Return-Path: <linux-kernel-owner+w=401wt.eu-S1761476AbZFKAoh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761476AbZFKAoh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jun 2009 20:44:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761400AbZFKAoa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Jun 2009 20:44:30 -0400
Received: from hera.kernel.org ([140.211.167.34]:59616 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753519AbZFKAo3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jun 2009 20:44:29 -0400
Date: Thu, 11 Jun 2009 00:43:01 GMT
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
Subject: [tip:perfcounters/core] perf_counter tools: Normalize data using per sample period data
Message-ID: <tip-ea1900e571d40a3ce60c835c2f21e1fd8c5cb663@git.kernel.org>
Git-Commit-ID: ea1900e571d40a3ce60c835c2f21e1fd8c5cb663
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Thu, 11 Jun 2009 00:43:02 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  ea1900e571d40a3ce60c835c2f21e1fd8c5cb663
Gitweb:     http://git.kernel.org/tip/ea1900e571d40a3ce60c835c2f21e1fd8c5cb663
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Wed, 10 Jun 2009 21:45:22 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 11 Jun 2009 02:39:01 +0200

perf_counter tools: Normalize data using per sample period data

When we use variable period sampling, add the period to the sample
data and use that to normalize the samples.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
LKML-Reference: <new-submission>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 tools/perf/builtin-record.c |    3 ++-
 tools/perf/builtin-report.c |   18 +++++++++++-------
 2 files changed, 13 insertions(+), 8 deletions(-)

diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index c10553c..919f23c 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -350,8 +350,9 @@ static void create_counter(int counter, int cpu, pid_t pid)
 	struct perf_counter_attr *attr = attrs + counter;
 	int track = 1;
 
-	attr->sample_type	= PERF_SAMPLE_IP | PERF_SAMPLE_TID | PERF_SAMPLE_PERIOD;
+	attr->sample_type	= PERF_SAMPLE_IP | PERF_SAMPLE_TID;
 	if (freq) {
+		attr->sample_type	|= PERF_SAMPLE_PERIOD;
 		attr->freq		= 1;
 		attr->sample_freq	= freq;
 	}
diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index 9a0e31e..f57fd5c 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -456,7 +456,7 @@ struct hist_entry {
 	uint64_t	 ip;
 	char		 level;
 
-	uint32_t	 count;
+	uint64_t	 count;
 };
 
 /*
@@ -726,7 +726,7 @@ hist_entry__fprintf(FILE *fp, struct hist_entry *self, uint64_t total_samples)
 
 static int
 hist_entry__add(struct thread *thread, struct map *map, struct dso *dso,
-		struct symbol *sym, uint64_t ip, char level)
+		struct symbol *sym, uint64_t ip, char level, uint64_t count)
 {
 	struct rb_node **p = &hist.rb_node;
 	struct rb_node *parent = NULL;
@@ -738,7 +738,7 @@ hist_entry__add(struct thread *thread, struct map *map, struct dso *dso,
 		.sym	= sym,
 		.ip	= ip,
 		.level	= level,
-		.count	= 1,
+		.count	= count,
 	};
 	int cmp;
 
@@ -749,7 +749,7 @@ hist_entry__add(struct thread *thread, struct map *map, struct dso *dso,
 		cmp = hist_entry__cmp(&entry, he);
 
 		if (!cmp) {
-			he->count++;
+			he->count += count;
 			return 0;
 		}
 
@@ -942,15 +942,19 @@ process_overflow_event(event_t *event, unsigned long offset, unsigned long head)
 	struct dso *dso = NULL;
 	struct thread *thread = threads__findnew(event->ip.pid);
 	uint64_t ip = event->ip.ip;
+	uint64_t period = 1;
 	struct map *map = NULL;
 
+	if (event->header.type & PERF_SAMPLE_PERIOD)
+		period = event->ip.period;
+
 	dprintf("%p [%p]: PERF_EVENT (IP, %d): %d: %p period: %Ld\n",
 		(void *)(offset + head),
 		(void *)(long)(event->header.size),
 		event->header.misc,
 		event->ip.pid,
 		(void *)(long)ip,
-		(long long)event->ip.period);
+		(long long)period);
 
 	dprintf(" ... thread: %s:%d\n", thread->comm, thread->pid);
 
@@ -1001,13 +1005,13 @@ process_overflow_event(event_t *event, unsigned long offset, unsigned long head)
 		if (dso)
 			sym = dso->find_symbol(dso, ip);
 
-		if (hist_entry__add(thread, map, dso, sym, ip, level)) {
+		if (hist_entry__add(thread, map, dso, sym, ip, level, period)) {
 			fprintf(stderr,
 		"problem incrementing symbol count, skipping event\n");
 			return -1;
 		}
 	}
-	total++;
+	total += period;
 
 	return 0;
 }
