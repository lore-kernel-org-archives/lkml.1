Return-Path: <linux-kernel-owner+w=401wt.eu-S1756575AbZE3Jtm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756575AbZE3Jtm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 May 2009 05:49:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755464AbZE3Jte
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 May 2009 05:49:34 -0400
Received: from hera.kernel.org ([140.211.167.34]:44612 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755005AbZE3Jtd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 May 2009 05:49:33 -0400
Date: Sat, 30 May 2009 09:48:50 GMT
From: tip-bot for Arnaldo Carvalho de Melo <acme@redhat.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, acme@redhat.com,
       hpa@zytor.com, mingo@redhat.com, a.p.zijlstra@chello.nl, efault@gmx.de,
       rostedt@goodmis.org, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
       linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl, efault@gmx.de,
       rostedt@goodmis.org, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20090529200307.GR4747@ghostprotocols.net>
References: <20090529200307.GR4747@ghostprotocols.net>
Subject: [tip:perfcounters/core] perf_counter tools: Add locking to perf top
Message-ID: <tip-c44613a4c1092e85841b78b7ab52a06654fcd321@git.kernel.org>
Git-Commit-ID: c44613a4c1092e85841b78b7ab52a06654fcd321
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Sat, 30 May 2009 09:48:51 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  c44613a4c1092e85841b78b7ab52a06654fcd321
Gitweb:     http://git.kernel.org/tip/c44613a4c1092e85841b78b7ab52a06654fcd321
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Fri, 29 May 2009 17:03:07 -0300
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sat, 30 May 2009 11:34:00 +0200

perf_counter tools: Add locking to perf top

perf_counter tools: Add locking to perf top

We need to protect the active_symbols list as two threads change it:
the main thread adding entries to the head and the display thread
decaying entries from any place in the list.

Also related: take a snapshot of syme->count[0] before using it to
calculate the weight and to show the same number used in this calc when
displaying the symbol usage.

Reported-by: Mike Galbraith <efault@gmx.de>
Tested-by: Mike Galbraith <efault@gmx.de>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
LKML-Reference: <20090529200307.GR4747@ghostprotocols.net>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 Documentation/perf_counter/builtin-top.c |   47 +++++++++++++++++++----------
 1 files changed, 31 insertions(+), 16 deletions(-)

diff --git a/Documentation/perf_counter/builtin-top.c b/Documentation/perf_counter/builtin-top.c
index ebe8bec..24a8879 100644
--- a/Documentation/perf_counter/builtin-top.c
+++ b/Documentation/perf_counter/builtin-top.c
@@ -129,6 +129,8 @@ struct sym_entry {
 	struct rb_node		rb_node;
 	struct list_head	node;
 	unsigned long		count[MAX_COUNTERS];
+	unsigned long		snap_count;
+	double			weight;
 	int			skip;
 };
 
@@ -141,17 +143,16 @@ struct dso *kernel_dso;
  * after decayed.
  */
 static LIST_HEAD(active_symbols);
+static pthread_mutex_t active_symbols_lock = PTHREAD_MUTEX_INITIALIZER;
 
 /*
  * Ordering weight: count-1 * count-2 * ... / count-n
  */
 static double sym_weight(const struct sym_entry *sym)
 {
-	double weight;
+	double weight = sym->snap_count;
 	int counter;
 
-	weight = sym->count[0];
-
 	for (counter = 1; counter < nr_counters-1; counter++)
 		weight *= sym->count[counter];
 
@@ -164,11 +165,18 @@ static long			events;
 static long			userspace_events;
 static const char		CONSOLE_CLEAR[] = "[H[2J";
 
-static void list_insert_active_sym(struct sym_entry *syme)
+static void __list_insert_active_sym(struct sym_entry *syme)
 {
 	list_add(&syme->node, &active_symbols);
 }
 
+static void list_remove_active_sym(struct sym_entry *syme)
+{
+	pthread_mutex_lock(&active_symbols_lock);
+	list_del_init(&syme->node);
+	pthread_mutex_unlock(&active_symbols_lock);
+}
+
 static void rb_insert_active_sym(struct rb_root *tree, struct sym_entry *se)
 {
 	struct rb_node **p = &tree->rb_node;
@@ -179,7 +187,7 @@ static void rb_insert_active_sym(struct rb_root *tree, struct sym_entry *se)
 		parent = *p;
 		iter = rb_entry(parent, struct sym_entry, rb_node);
 
-		if (sym_weight(se) > sym_weight(iter))
+		if (se->weight > iter->weight)
 			p = &(*p)->rb_left;
 		else
 			p = &(*p)->rb_right;
@@ -203,15 +211,21 @@ static void print_sym_table(void)
 	events = userspace_events = 0;
 
 	/* Sort the active symbols */
-	list_for_each_entry_safe(syme, n, &active_symbols, node) {
-		if (syme->count[0] != 0) {
+	pthread_mutex_lock(&active_symbols_lock);
+	syme = list_entry(active_symbols.next, struct sym_entry, node);
+	pthread_mutex_unlock(&active_symbols_lock);
+
+	list_for_each_entry_safe_from(syme, n, &active_symbols, node) {
+		syme->snap_count = syme->count[0];
+		if (syme->snap_count != 0) {
+			syme->weight = sym_weight(syme);
 			rb_insert_active_sym(&tmp, syme);
-			sum_kevents += syme->count[0];
+			sum_kevents += syme->snap_count;
 
 			for (j = 0; j < nr_counters; j++)
 				syme->count[j] = zero ? 0 : syme->count[j] * 7 / 8;
 		} else
-			list_del_init(&syme->node);
+			list_remove_active_sym(syme);
 	}
 
 	write(1, CONSOLE_CLEAR, strlen(CONSOLE_CLEAR));
@@ -264,19 +278,18 @@ static void print_sym_table(void)
 		struct symbol *sym = (struct symbol *)(syme + 1);
 		float pcnt;
 
-		if (++printed > 18 || syme->count[0] < count_filter)
-			break;
+		if (++printed > 18 || syme->snap_count < count_filter)
+			continue;
 
-		pcnt = 100.0 - (100.0 * ((sum_kevents - syme->count[0]) /
+		pcnt = 100.0 - (100.0 * ((sum_kevents - syme->snap_count) /
 					 sum_kevents));
 
 		if (nr_counters == 1)
 			printf("%19.2f - %4.1f%% - %016llx : %s\n",
-				sym_weight(syme),
-				pcnt, sym->start, sym->name);
+				syme->weight, pcnt, sym->start, sym->name);
 		else
 			printf("%8.1f %10ld - %4.1f%% - %016llx : %s\n",
-				sym_weight(syme), syme->count[0],
+				syme->weight, syme->snap_count,
 				pcnt, sym->start, sym->name);
 	}
 
@@ -395,8 +408,10 @@ static void record_ip(uint64_t ip, int counter)
 
 		if (!syme->skip) {
 			syme->count[counter]++;
+			pthread_mutex_lock(&active_symbols_lock);
 			if (list_empty(&syme->node) || !syme->node.next)
-				list_insert_active_sym(syme);
+				__list_insert_active_sym(syme);
+			pthread_mutex_unlock(&active_symbols_lock);
 			return;
 		}
 	}
