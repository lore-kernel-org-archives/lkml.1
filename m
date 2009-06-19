Return-Path: <linux-kernel-owner+w=401wt.eu-S1753974AbZFSLxE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753974AbZFSLxE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jun 2009 07:53:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752973AbZFSLwo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Jun 2009 07:52:44 -0400
Received: from hera.kernel.org ([140.211.167.34]:46766 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752836AbZFSLwm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jun 2009 07:52:42 -0400
Date: Fri, 19 Jun 2009 11:52:05 GMT
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       a.p.zijlstra@chello.nl, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       a.p.zijlstra@chello.nl, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <new-submission>
References: <new-submission>
Subject: [tip:perfcounters/core] perf_counter: Update userspace callchain sampling uses
Message-ID: <tip-2a0a50fe9def21835d65035cc8109c0b6dd6099d@git.kernel.org>
Git-Commit-ID: 2a0a50fe9def21835d65035cc8109c0b6dd6099d
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Fri, 19 Jun 2009 11:52:06 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  2a0a50fe9def21835d65035cc8109c0b6dd6099d
Gitweb:     http://git.kernel.org/tip/2a0a50fe9def21835d65035cc8109c0b6dd6099d
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Thu, 18 Jun 2009 22:20:45 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 19 Jun 2009 13:42:35 +0200

perf_counter: Update userspace callchain sampling uses

Update the tools to reflect the new callchain sampling format.

LKML-Reference: <new-submission>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 tools/perf/builtin-report.c |   86 +++++++++++++++++++-----------------------
 1 files changed, 39 insertions(+), 47 deletions(-)

diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index 86981bd..7a6577b 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -59,6 +59,11 @@ struct ip_event {
 	unsigned char __more_data[];
 };
 
+struct ip_callchain {
+	__u64 nr;
+	__u64 ips[0];
+};
+
 struct mmap_event {
 	struct perf_event_header header;
 	__u32 pid, tid;
@@ -833,15 +838,12 @@ got_dso:
 	return dso->find_symbol(dso, ip);
 }
 
-static struct symbol *call__match(struct symbol *sym)
+static int call__match(struct symbol *sym)
 {
-	if (!sym)
-		return NULL;
-
 	if (sym->name && !regexec(&parent_regex, sym->name, 0, NULL, 0))
-		return sym;
+		return 1;
 
-	return NULL;
+	return 0;
 }
 
 /*
@@ -850,7 +852,7 @@ static struct symbol *call__match(struct symbol *sym)
 
 static int
 hist_entry__add(struct thread *thread, struct map *map, struct dso *dso,
-		struct symbol *sym, __u64 ip, struct perf_callchain_entry *chain,
+		struct symbol *sym, __u64 ip, struct ip_callchain *chain,
 		char level, __u64 count)
 {
 	struct rb_node **p = &hist.rb_node;
@@ -869,31 +871,35 @@ hist_entry__add(struct thread *thread, struct map *map, struct dso *dso,
 	int cmp;
 
 	if (sort__has_parent && chain) {
-		int i, nr = chain->hv;
-		struct symbol *sym;
-		struct dso *dso;
-		__u64 ip;
-
-		for (i = 0; i < chain->kernel; i++) {
-			ip = chain->ip[nr + i];
-			dso = kernel_dso;
+		__u64 context = PERF_CONTEXT_MAX;
+		int i;
+
+		for (i = 0; i < chain->nr; i++) {
+			__u64 ip = chain->ips[i];
+			struct dso *dso = NULL;
+			struct symbol *sym;
+
+			if (ip >= PERF_CONTEXT_MAX) {
+				context = ip;
+				continue;
+			}
+
+			switch (context) {
+			case PERF_CONTEXT_KERNEL:
+				dso = kernel_dso;
+				break;
+			default:
+				break;
+			}
+
 			sym = resolve_symbol(thread, NULL, &dso, &ip);
-			entry.parent = call__match(sym);
-			if (entry.parent)
-				goto got_parent;
-		}
-		nr += i;
-
-		for (i = 0; i < chain->user; i++) {
-			ip = chain->ip[nr + i];
-			sym = resolve_symbol(thread, NULL, NULL, &ip);
-			entry.parent = call__match(sym);
-			if (entry.parent)
-				goto got_parent;
+
+			if (sym && call__match(sym)) {
+				entry.parent = sym;
+				break;
+			}
 		}
-		nr += i;
 	}
-got_parent:
 
 	while (*p != NULL) {
 		parent = *p;
@@ -1095,21 +1101,10 @@ static unsigned long total = 0,
 		     total_unknown = 0,
 		     total_lost = 0;
 
-static int validate_chain(struct perf_callchain_entry *chain, event_t *event)
+static int validate_chain(struct ip_callchain *chain, event_t *event)
 {
 	unsigned int chain_size;
 
-	if (chain->nr > MAX_STACK_DEPTH)
-		return -1;
-	if (chain->hv > MAX_STACK_DEPTH)
-		return -1;
-	if (chain->kernel > MAX_STACK_DEPTH)
-		return -1;
-	if (chain->user > MAX_STACK_DEPTH)
-		return -1;
-	if (chain->hv + chain->kernel + chain->user != chain->nr)
-		return -1;
-
 	chain_size = event->header.size;
 	chain_size -= (unsigned long)&event->ip.__more_data - (unsigned long)event;
 
@@ -1130,7 +1125,7 @@ process_overflow_event(event_t *event, unsigned long offset, unsigned long head)
 	__u64 period = 1;
 	struct map *map = NULL;
 	void *more_data = event->ip.__more_data;
-	struct perf_callchain_entry *chain = NULL;
+	struct ip_callchain *chain = NULL;
 
 	if (event->header.type & PERF_SAMPLE_PERIOD) {
 		period = *(__u64 *)more_data;
@@ -1150,10 +1145,7 @@ process_overflow_event(event_t *event, unsigned long offset, unsigned long head)
 
 		chain = (void *)more_data;
 
-		dprintf("... chain: u:%d, k:%d, nr:%d\n",
-			chain->user,
-			chain->kernel,
-			chain->nr);
+		dprintf("... chain: nr:%Lu\n", chain->nr);
 
 		if (validate_chain(chain, event) < 0) {
 			eprintf("call-chain problem with event, skipping it.\n");
@@ -1162,7 +1154,7 @@ process_overflow_event(event_t *event, unsigned long offset, unsigned long head)
 
 		if (dump_trace) {
 			for (i = 0; i < chain->nr; i++)
-				dprintf("..... %2d: %016Lx\n", i, chain->ip[i]);
+				dprintf("..... %2d: %016Lx\n", i, chain->ips[i]);
 		}
 	}
 
