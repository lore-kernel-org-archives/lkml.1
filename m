Return-Path: <linux-kernel-owner+w=401wt.eu-S1754871AbZKPXpg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754871AbZKPXpg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Nov 2009 18:45:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754813AbZKPXpf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Nov 2009 18:45:35 -0500
Received: from casper.infradead.org ([85.118.1.10]:40896 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754806AbZKPXpd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Nov 2009 18:45:33 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
       Peter Zijlstra <peterz@infradead.org>
Subject: [PATCH 1/2] perf top: Introduce --hide_{user,kernel}_symbols
Date: Mon, 16 Nov 2009 21:45:24 -0200
Message-Id: <1258415125-15019-1-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

Default continues to be showing all symbols. 'K' and 'U' can be used
to toggle showing kernel and user symbols.

Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-top.c |   42 ++++++++++++++++++++++++++++++++++++++++--
 1 files changed, 40 insertions(+), 2 deletions(-)

diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
index 3af9520..89b7f68 100644
--- a/tools/perf/builtin-top.c
+++ b/tools/perf/builtin-top.c
@@ -76,6 +76,9 @@ static int			delay_secs			=      2;
 static int			zero                            =      0;
 static int			dump_symtab                     =      0;
 
+static bool			hide_kernel_symbols		=  false;
+static bool			hide_user_symbols		=  false;
+
 /*
  * Source
  */
@@ -104,6 +107,7 @@ struct sym_entry {
 	unsigned long		snap_count;
 	double			weight;
 	int			skip;
+	u8			origin;
 	struct map		*map;
 	struct source_line	*source;
 	struct source_line	*lines;
@@ -430,6 +434,13 @@ static void print_sym_table(void)
 	list_for_each_entry_safe_from(syme, n, &active_symbols, node) {
 		syme->snap_count = syme->count[snap];
 		if (syme->snap_count != 0) {
+			if ((hide_user_symbols &&
+			     syme->origin == PERF_RECORD_MISC_USER) ||
+			    (hide_kernel_symbols &&
+			     syme->origin == PERF_RECORD_MISC_KERNEL)) {
+				list_remove_active_sym(syme);
+				continue;
+			}
 			syme->weight = sym_weight(syme);
 			rb_insert_active_sym(&tmp, syme);
 			sum_ksamples += syme->snap_count;
@@ -637,6 +648,12 @@ static void print_mapped_keys(void)
 	if (nr_counters > 1)
 		fprintf(stdout, "\t[w]     toggle display weighted/count[E]r. \t(%d)\n", display_weighted ? 1 : 0);
 
+	fprintf(stdout,
+		"\t[K]     hide kernel_symbols symbols.             \t(%s)\n",
+		hide_kernel_symbols ? "yes" : "no");
+	fprintf(stdout,
+		"\t[U]     hide user symbols.               \t(%s)\n",
+		hide_user_symbols ? "yes" : "no");
 	fprintf(stdout, "\t[z]     toggle sample zeroing.             \t(%d)\n", zero ? 1 : 0);
 	fprintf(stdout, "\t[qQ]    quit.\n");
 }
@@ -650,6 +667,8 @@ static int key_mapped(int c)
 		case 'z':
 		case 'q':
 		case 'Q':
+		case 'K':
+		case 'U':
 			return 1;
 		case 'E':
 		case 'w':
@@ -727,6 +746,9 @@ static void handle_keypress(int c)
 		case 'F':
 			prompt_percent(&sym_pcnt_filter, "Enter details display event filter (percent)");
 			break;
+		case 'K':
+			hide_kernel_symbols = !hide_kernel_symbols;
+			break;
 		case 'q':
 		case 'Q':
 			printf("exiting.\n");
@@ -746,6 +768,9 @@ static void handle_keypress(int c)
 				pthread_mutex_unlock(&syme->source_lock);
 			}
 			break;
+		case 'U':
+			hide_user_symbols = !hide_user_symbols;
+			break;
 		case 'w':
 			display_weighted = ~display_weighted;
 			break;
@@ -857,11 +882,16 @@ static void event__process_sample(const event_t *self, int counter)
 	struct map *map;
 	struct sym_entry *syme;
 	struct symbol *sym;
+	u8 origin = self->header.misc & PERF_RECORD_MISC_CPUMODE_MASK;
 
-	switch (self->header.misc & PERF_RECORD_MISC_CPUMODE_MASK) {
+	switch (origin) {
 	case PERF_RECORD_MISC_USER: {
-		struct thread *thread = threads__findnew(self->ip.pid);
+		struct thread *thread;
 
+		if (hide_user_symbols)
+			return;
+
+		thread = threads__findnew(self->ip.pid);
 		if (thread == NULL)
 			return;
 
@@ -885,6 +915,9 @@ static void event__process_sample(const event_t *self, int counter)
 			return;
 		/* Fall thru */
 	case PERF_RECORD_MISC_KERNEL:
+		if (hide_kernel_symbols)
+			return;
+
 		sym = kernel_maps__find_symbol(ip, &map);
 		if (sym == NULL)
 			return;
@@ -897,6 +930,7 @@ static void event__process_sample(const event_t *self, int counter)
 
 	if (!syme->skip) {
 		syme->count[counter]++;
+		syme->origin = origin;
 		record_precise_ip(syme, counter, ip);
 		pthread_mutex_lock(&active_symbols_lock);
 		if (list_empty(&syme->node) || !syme->node.next)
@@ -1178,6 +1212,8 @@ static const struct option options[] = {
 	OPT_INTEGER('C', "CPU", &profile_cpu,
 		    "CPU to profile on"),
 	OPT_STRING('k', "vmlinux", &vmlinux_name, "file", "vmlinux pathname"),
+	OPT_BOOLEAN('K', "hide_kernel_symbols", &hide_kernel_symbols,
+		    "hide kernel symbols"),
 	OPT_INTEGER('m', "mmap-pages", &mmap_pages,
 		    "number of mmap data pages"),
 	OPT_INTEGER('r', "realtime", &realtime_prio,
@@ -1200,6 +1236,8 @@ static const struct option options[] = {
 		    "profile at this frequency"),
 	OPT_INTEGER('E', "entries", &print_entries,
 		    "display this many functions"),
+	OPT_BOOLEAN('U', "hide_user_symbols", &hide_user_symbols,
+		    "hide user symbols"),
 	OPT_BOOLEAN('v', "verbose", &verbose,
 		    "be more verbose (show counter open errors, etc)"),
 	OPT_END()
-- 
1.6.2.5

