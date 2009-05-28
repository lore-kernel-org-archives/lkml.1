Return-Path: <linux-kernel-owner+w=401wt.eu-S1763848AbZE1R4f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763848AbZE1R4f (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 May 2009 13:56:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763705AbZE1R4N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 May 2009 13:56:13 -0400
Received: from mx2.redhat.com ([66.187.237.31]:35360 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763682AbZE1R4K convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 May 2009 13:56:10 -0400
Date: Thu, 28 May 2009 14:55:41 -0300
From: Arnaldo Carvalho de Melo <acme@redhat.com>
To: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>, Mike Galbraith <efault@gmx.de>,
       Thomas Gleixner <tglx@linutronix.de>,
       Steven Rostedt <rostedt@goodmis.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH tip 5/5] perf: Convert builtin-top to use libperf symbol
	routines
Message-ID: <20090528175541.GG4747@ghostprotocols.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now both perf top and report use the same routines.

Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 Documentation/perf_counter/builtin-top.c |  303 ++++++++++++------------------
 1 files changed, 117 insertions(+), 186 deletions(-)

diff --git a/Documentation/perf_counter/builtin-top.c b/Documentation/perf_counter/builtin-top.c
index a890872..52ba9f4 100644
--- a/Documentation/perf_counter/builtin-top.c
+++ b/Documentation/perf_counter/builtin-top.c
@@ -44,8 +44,9 @@
 
 #include "perf.h"
 #include "builtin.h"
+#include "util/symbol.h"
 #include "util/util.h"
-#include "util/util.h"
+#include "util/rbtree.h"
 #include "util/parse-options.h"
 #include "util/parse-events.h"
 
@@ -125,19 +126,21 @@ static uint64_t			min_ip;
 static uint64_t			max_ip = -1ll;
 
 struct sym_entry {
-	unsigned long long	addr;
-	char			*sym;
+	struct rb_node		rb_node;
+	struct list_head	node;
 	unsigned long		count[MAX_COUNTERS];
 	int			skip;
 };
 
-#define MAX_SYMS		100000
-
-static int sym_table_count;
-
 struct sym_entry		*sym_filter_entry;
 
-static struct sym_entry		sym_table[MAX_SYMS];
+struct dso *kernel_dso;
+
+/*
+ * Symbols will be added here in record_ip and will get out
+ * after decayed.
+ */
+static LIST_HEAD(active_symbols);
 
 /*
  * Ordering weight: count-1 * count-2 * ... / count-n
@@ -157,42 +160,60 @@ static double sym_weight(const struct sym_entry *sym)
 	return weight;
 }
 
-static int compare(const void *__sym1, const void *__sym2)
-{
-	const struct sym_entry *sym1 = __sym1, *sym2 = __sym2;
-
-	return sym_weight(sym1) < sym_weight(sym2);
-}
-
 static long			events;
 static long			userspace_events;
 static const char		CONSOLE_CLEAR[] = "[H[2J";
 
-static struct sym_entry		tmp[MAX_SYMS];
+static void list_insert_active_sym(struct sym_entry *syme)
+{
+	list_add(&syme->node, &active_symbols);
+}
+
+static void rb_insert_active_sym(struct rb_root *tree, struct sym_entry *se)
+{
+	struct rb_node **p = &tree->rb_node;
+	struct rb_node *parent = NULL;
+	struct sym_entry *iter;
+
+	while (*p != NULL) {
+		parent = *p;
+		iter = rb_entry(parent, struct sym_entry, rb_node);
+
+		if (sym_weight(se) > sym_weight(iter))
+			p = &(*p)->rb_left;
+		else
+			p = &(*p)->rb_right;
+	}
+
+	rb_link_node(&se->rb_node, parent, p);
+	rb_insert_color(&se->rb_node, tree);
+}
 
 static void print_sym_table(void)
 {
-	int i, j, active_count, printed;
+	int printed, j;
 	int counter;
 	float events_per_sec = events/delay_secs;
 	float kevents_per_sec = (events-userspace_events)/delay_secs;
 	float sum_kevents = 0.0;
+	struct sym_entry *syme, *n;
+	struct rb_root tmp = RB_ROOT;
+	struct rb_node *nd;
 
 	events = userspace_events = 0;
 
-	/* Iterate over symbol table and copy/tally/decay active symbols. */
-	for (i = 0, active_count = 0; i < sym_table_count; i++) {
-		if (sym_table[i].count[0]) {
-			tmp[active_count++] = sym_table[i];
-			sum_kevents += sym_table[i].count[0];
+	/* Sort the active symbols */
+	list_for_each_entry_safe(syme, n, &active_symbols, node) {
+		if (syme->count[0] != 0) {
+			rb_insert_active_sym(&tmp, syme);
+			sum_kevents += syme->count[0];
 
 			for (j = 0; j < nr_counters; j++)
-				sym_table[i].count[j] = zero ? 0 : sym_table[i].count[j] * 7 / 8;
-		}
+				syme->count[j] = zero ? 0 : syme->count[j] * 7 / 8;
+		} else
+			list_del_init(&syme->node);
 	}
 
-	qsort(tmp, active_count + 1, sizeof(tmp[0]), compare);
-
 	write(1, CONSOLE_CLEAR, strlen(CONSOLE_CLEAR));
 
 	printf(
@@ -238,23 +259,25 @@ static void print_sym_table(void)
 	       	       "  ______     ______   _____   ________________   _______________\n\n"
 	);
 
-	for (i = 0, printed = 0; i < active_count; i++) {
+	for (nd = rb_first(&tmp); nd; nd = rb_next(nd)) {
+		struct sym_entry *syme = rb_entry(nd, struct sym_entry, rb_node);
+		struct symbol *sym = (struct symbol *)(syme + 1);
 		float pcnt;
 
-		if (++printed > 18 || tmp[i].count[0] < count_filter)
+		if (++printed > 18 || syme->count[0] < count_filter)
 			break;
 
-		pcnt = 100.0 - (100.0*((sum_kevents-tmp[i].count[0])/sum_kevents));
+		pcnt = 100.0 - (100.0 * ((sum_kevents - syme->count[0]) /
+					 sum_kevents));
 
 		if (nr_counters == 1)
 			printf("%19.2f - %4.1f%% - %016llx : %s\n",
-				sym_weight(tmp + i),
-				pcnt, tmp[i].addr, tmp[i].sym);
+				sym_weight(syme),
+				pcnt, sym->start, sym->name);
 		else
 			printf("%8.1f %10ld - %4.1f%% - %016llx : %s\n",
-				sym_weight(tmp + i),
-				tmp[i].count[0],
-				pcnt, tmp[i].addr, tmp[i].sym);
+				sym_weight(syme), syme->count[0],
+				pcnt, sym->start, sym->name);
 	}
 
 	{
@@ -277,146 +300,85 @@ static void *display_thread(void *arg)
 	return NULL;
 }
 
-static int read_symbol(FILE *in, struct sym_entry *s)
+static int symbol_filter(struct dso *self, struct symbol *sym)
 {
-	static int filter_match = 0;
-	char *sym, stype;
-	char str[500];
-	int rc, pos;
-
-	rc = fscanf(in, "%llx %c %499s", &s->addr, &stype, str);
-	if (rc == EOF)
-		return -1;
-
-	assert(rc == 3);
-
-	/* skip until end of line: */
-	pos = strlen(str);
-	do {
-		rc = fgetc(in);
-		if (rc == '\n' || rc == EOF || pos >= 499)
-			break;
-		str[pos] = rc;
-		pos++;
-	} while (1);
-	str[pos] = 0;
-
-	sym = str;
-
-	/* Filter out known duplicates and non-text symbols. */
-	if (!strcmp(sym, "_text"))
-		return 1;
-	if (!min_ip && !strcmp(sym, "_stext"))
-		return 1;
-	if (!strcmp(sym, "_etext") || !strcmp(sym, "_sinittext"))
-		return 1;
-	if (stype != 'T' && stype != 't')
-		return 1;
-	if (!strncmp("init_module", sym, 11) || !strncmp("cleanup_module", sym, 14))
-		return 1;
-	if (strstr(sym, "_text_start") || strstr(sym, "_text_end"))
+	static int filter_match;
+	struct sym_entry *syme;
+	const char *name = sym->name;
+
+	if (!strcmp(name, "_text") ||
+	    !strcmp(name, "_etext") ||
+	    !strcmp(name, "_sinittext") ||
+	    !strncmp("init_module", name, 11) ||
+	    !strncmp("cleanup_module", name, 14) ||
+	    strstr(name, "_text_start") ||
+	    strstr(name, "_text_end"))
 		return 1;
 
-	s->sym = malloc(strlen(str)+1);
-	assert(s->sym);
-
-	strcpy((char *)s->sym, str);
-	s->skip = 0;
-
+	syme = dso__sym_priv(self, sym);
 	/* Tag events to be skipped. */
-	if (!strcmp("default_idle", s->sym) || !strcmp("cpu_idle", s->sym))
-		s->skip = 1;
-	else if (!strcmp("enter_idle", s->sym) || !strcmp("exit_idle", s->sym))
-		s->skip = 1;
-	else if (!strcmp("mwait_idle", s->sym))
-		s->skip = 1;
+	if (!strcmp("default_idle", name) ||
+	    !strcmp("cpu_idle", name) ||
+	    !strcmp("enter_idle", name) ||
+	    !strcmp("exit_idle", name) ||
+	    !strcmp("mwait_idle", name))
+		syme->skip = 1;
 
 	if (filter_match == 1) {
-		filter_end = s->addr;
+		filter_end = sym->start;
 		filter_match = -1;
 		if (filter_end - filter_start > 10000) {
-			printf("hm, too large filter symbol <%s> - skipping.\n",
+			fprintf(stderr,
+				"hm, too large filter symbol <%s> - skipping.\n",
 				sym_filter);
-			printf("symbol filter start: %016lx\n", filter_start);
-			printf("                end: %016lx\n", filter_end);
+			fprintf(stderr, "symbol filter start: %016lx\n",
+				filter_start);
+			fprintf(stderr, "                end: %016lx\n",
+				filter_end);
 			filter_end = filter_start = 0;
 			sym_filter = NULL;
 			sleep(1);
 		}
 	}
-	if (filter_match == 0 && sym_filter && !strcmp(s->sym, sym_filter)) {
+
+	if (filter_match == 0 && sym_filter && !strcmp(name, sym_filter)) {
 		filter_match = 1;
-		filter_start = s->addr;
+		filter_start = sym->start;
 	}
 
+
 	return 0;
 }
 
-static int compare_addr(const void *__sym1, const void *__sym2)
+static int parse_symbols(void)
 {
-	const struct sym_entry *sym1 = __sym1, *sym2 = __sym2;
+	struct rb_node *node;
+	struct symbol  *sym;
 
-	return sym1->addr > sym2->addr;
-}
-
-static void sort_symbol_table(void)
-{
-	int i, dups;
-
-	do {
-		qsort(sym_table, sym_table_count, sizeof(sym_table[0]), compare_addr);
-		for (i = 0, dups = 0; i < sym_table_count; i++) {
-			if (sym_table[i].addr == sym_table[i+1].addr) {
-				sym_table[i+1].addr = -1ll;
-				dups++;
-			}
-		}
-		sym_table_count -= dups;
-	} while(dups);
-}
-
-static void parse_symbols(void)
-{
-	struct sym_entry *last;
+	kernel_dso = dso__new("[kernel]", sizeof(struct sym_entry));
+	if (kernel_dso == NULL)
+		return -1;
 
-	FILE *kallsyms = fopen("/proc/kallsyms", "r");
+	if (dso__load_kernel(kernel_dso, NULL, symbol_filter) != 0)
+		goto out_delete_dso;
 
-	if (!kallsyms) {
-		printf("Could not open /proc/kallsyms - no CONFIG_KALLSYMS_ALL=y?\n");
-		exit(-1);
-	}
+	node = rb_first(&kernel_dso->syms);
+	sym = rb_entry(node, struct symbol, rb_node);
+	min_ip = sym->start;
 
-	while (!feof(kallsyms)) {
-		if (read_symbol(kallsyms, &sym_table[sym_table_count]) == 0) {
-			sym_table_count++;
-			assert(sym_table_count <= MAX_SYMS);
-		}
-	}
+	node = rb_last(&kernel_dso->syms);
+	sym = rb_entry(node, struct symbol, rb_node);
+	max_ip = sym->start;
 
-	sort_symbol_table();
-	min_ip = sym_table[0].addr;
-	max_ip = sym_table[sym_table_count-1].addr;
-	last = sym_table + sym_table_count++;
+	if (dump_symtab)
+		dso__fprintf(kernel_dso, stdout);
 
-	last->addr = -1ll;
-	last->sym = "<end>";
-
-	if (filter_end) {
-		int count;
-		for (count=0; count < sym_table_count; count ++) {
-			if (!strcmp(sym_table[count].sym, sym_filter)) {
-				sym_filter_entry = &sym_table[count];
-				break;
-			}
-		}
-	}
-	if (dump_symtab) {
-		int i;
+	return 0;
 
-		for (i = 0; i < sym_table_count; i++)
-			fprintf(stderr, "%llx %s\n",
-				sym_table[i].addr, sym_table[i].sym);
-	}
+out_delete_dso:
+	dso__delete(kernel_dso);
+	kernel_dso = NULL;
+	return -1;
 }
 
 #define TRACE_COUNT     3
@@ -426,51 +388,20 @@ static void parse_symbols(void)
  */
 static void record_ip(uint64_t ip, int counter)
 {
-	int left_idx, middle_idx, right_idx, idx;
-	unsigned long left, middle, right;
-
-	left_idx = 0;
-	right_idx = sym_table_count-1;
-	assert(ip <= max_ip && ip >= min_ip);
-
-	while (left_idx + 1 < right_idx) {
-		middle_idx = (left_idx + right_idx) / 2;
+	struct symbol *sym = dso__find_symbol(kernel_dso, ip);
 
-		left   = sym_table[  left_idx].addr;
-		middle = sym_table[middle_idx].addr;
-		right  = sym_table[ right_idx].addr;
+	if (sym != NULL) {
+		struct sym_entry *syme = dso__sym_priv(kernel_dso, sym);
 
-		if (!(left <= middle && middle <= right)) {
-			printf("%016lx...\n%016lx...\n%016lx\n", left, middle, right);
-			printf("%d %d %d\n", left_idx, middle_idx, right_idx);
+		if (!syme->skip) {
+			syme->count[counter]++;
+			if (list_empty(&syme->node) || !syme->node.next)
+				list_insert_active_sym(syme);
+			return;
 		}
-		assert(left <= middle && middle <= right);
-		if (!(left <= ip && ip <= right)) {
-			printf(" left: %016lx\n", left);
-			printf("   ip: %016lx\n", (unsigned long)ip);
-			printf("right: %016lx\n", right);
-		}
-		assert(left <= ip && ip <= right);
-		/*
-		 * [ left .... target .... middle .... right ]
-		 *   => right := middle
-		 */
-		if (ip < middle) {
-			right_idx = middle_idx;
-			continue;
-		}
-		/*
-		 * [ left .... middle ... target ... right ]
-		 *   => left := middle
-		 */
-		left_idx = middle_idx;
 	}
 
-	idx = left_idx;
-
-	if (!sym_table[idx].skip)
-		sym_table[idx].count[counter]++;
-	else events--;
+	events--;
 }
 
 static void process_event(uint64_t ip, int counter)
-- 
1.6.0.6

