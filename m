Return-Path: <linux-kernel-owner+w=401wt.eu-S1753553AbZJZVXY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753553AbZJZVXY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Oct 2009 17:23:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752803AbZJZVXX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Oct 2009 17:23:23 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:43418 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752837AbZJZVXW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Oct 2009 17:23:22 -0400
From: Arnaldo Carvalho de Melo <acme@redhat.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Paul Mackerras <paulus@samba.org>, Mike Galbraith <efault@gmx.de>
Subject: [PATCH 3/3] perf top: Support userspace symbols too
Date: Mon, 26 Oct 2009 19:23:19 -0200
Message-Id: <1256592199-9608-3-git-send-email-acme@redhat.com>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1256592199-9608-2-git-send-email-acme@redhat.com>
References: <y>
 <1256592199-9608-1-git-send-email-acme@redhat.com>
 <1256592199-9608-2-git-send-email-acme@redhat.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Example:

Compiling the kernel with 'make -k 22 allyesconfig'

[root@emilia linux-2.6-tip]# perf top -r 90
------------------------------------------------------------------------------
   PerfTop:    3669 irqs/sec  kernel:59.9% [1000Hz cycles],  (all, 8 CPUs)
------------------------------------------------------------------------------

             samples  pcnt function                                 DSO
             _______ _____ ________________________________ ________________

             3062.00  6.5% clear_page_c                     [kernel]
             2233.00  4.8% _int_malloc                      /lib64/libc-2.5.so
             2100.00  4.5% yylex                            /home/acme/git/build/allyesconfig/scripts/genksyms/genksyms
             2029.00  4.3% memset                           /lib64/libc-2.5.so
             1224.00  2.6% page_fault                       [kernel]
             1075.00  2.3% __GI_strlen                      /lib64/libc-2.5.so
              863.00  1.8% sub_preempt_count                [kernel]
              822.00  1.8% __GI_memcpy                      /lib64/libc-2.5.so
              810.00  1.7% __GI_vfprintf                    /lib64/libc-2.5.so
              786.00  1.7% _int_free                        /lib64/libc-2.5.so
              775.00  1.7% __GI_strcmp                      /lib64/libc-2.5.so
              748.00  1.6% _spin_lock                       [kernel]
              699.00  1.5% main                             /home/acme/git/build/allyesconfig/scripts/basic/fixdep
              659.00  1.4% add_preempt_count                [kernel]
              649.00  1.4% yyparse                          /home/acme/git/build/allyesconfig/scripts/genksyms/genksyms
              645.00  1.4% preempt_trace                    [kernel]
              635.00  1.4% __GI___libc_free                 /lib64/libc-2.5.so
              597.00  1.3% trace_preempt_on                 [kernel]
              551.00  1.2% __GI___libc_malloc               /lib64/libc-2.5.so
              516.00  1.1% _spin_lock_irqsave               [kernel]
              481.00  1.0% copy_user_generic_string         [kernel]
              479.00  1.0% unmap_vmas                       [kernel]
              429.00  0.9% _IO_file_xsputn_internal         /lib64/libc-2.5.so
              425.00  0.9% __GI_strncpy                     /lib64/libc-2.5.so
              416.00  0.9% get_page_from_freelist           [kernel]
              414.00  0.9% malloc_consolidate               /lib64/libc-2.5.so
              406.00  0.9% get_parent_ip                    [kernel]
              362.00  0.8% __rmqueue                        [kernel]
              347.00  0.7% in_lock_functions                [kernel]
              316.00  0.7% __d_lookup                       [kernel]

[root@emilia linux-2.6-tip]#

More polishing is needed to print just DSO basename when not --verbose, etc.

Supporting a 'comm' column requires some more reworking of 'perf top' internals
as we will need to use something like the hist entries 'perf report' uses and
will be done in another patch.

Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Mike Galbraith <efault@gmx.de>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-top.c |  143 ++++++++++++++++++++++++++++++++-------------
 1 files changed, 101 insertions(+), 42 deletions(-)

diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
index 4a9fe22..a02fc41 100644
--- a/tools/perf/builtin-top.c
+++ b/tools/perf/builtin-top.c
@@ -318,7 +318,7 @@ static void show_details(struct sym_entry *syme)
 }
 
 /*
- * Symbols will be added here in record_ip and will get out
+ * Symbols will be added here in event__process_sample and will get out
  * after decayed.
  */
 static LIST_HEAD(active_symbols);
@@ -459,18 +459,18 @@ static void print_sym_table(void)
 	}
 
 	if (nr_counters == 1)
-		printf("             samples    pcnt");
+		printf("             samples  pcnt");
 	else
-		printf("   weight    samples    pcnt");
+		printf("   weight    samples  pcnt");
 
 	if (verbose)
 		printf("         RIP       ");
-	printf("   kernel function\n");
-	printf("   %s    _______   _____",
+	printf(" function                                 DSO\n");
+	printf("   %s    _______ _____",
 	       nr_counters == 1 ? "      " : "______");
 	if (verbose)
-		printf("   ________________");
-	printf("   _______________\n\n");
+		printf(" ________________");
+	printf(" ________________________________ ________________\n\n");
 
 	for (nd = rb_first(&tmp); nd; nd = rb_next(nd)) {
 		struct symbol *sym;
@@ -486,16 +486,15 @@ static void print_sym_table(void)
 					 sum_ksamples));
 
 		if (nr_counters == 1 || !display_weighted)
-			printf("%20.2f - ", syme->weight);
+			printf("%20.2f ", syme->weight);
 		else
-			printf("%9.1f %10ld - ", syme->weight, syme->snap_count);
+			printf("%9.1f %10ld ", syme->weight, syme->snap_count);
 
 		percent_color_fprintf(stdout, "%4.1f%%", pcnt);
 		if (verbose)
-			printf(" - %016llx", sym->start);
-		printf(" : %s", sym->name);
-		if (syme->map->dso->name[0] == '[')
-			printf(" \t%s", syme->map->dso->name);
+			printf(" %016llx", sym->start);
+		printf(" %-32s", sym->name);
+		printf(" %s", syme->map->dso->short_name);
 		printf("\n");
 	}
 }
@@ -818,41 +817,97 @@ static int parse_symbols(void)
 	return 0;
 }
 
-/*
- * Binary search in the histogram table and record the hit:
- */
-static void record_ip(u64 ip, int counter)
+static void event__process_sample(const event_t *self, int counter)
 {
+	u64 ip = self->ip.ip;
 	struct map *map;
-	struct symbol *sym = kernel_maps__find_symbol(ip, &map);
-
-	if (sym != NULL) {
-		struct sym_entry *syme = dso__sym_priv(map->dso, sym);
-
-		if (!syme->skip) {
-			syme->count[counter]++;
-			record_precise_ip(syme, counter, ip);
-			pthread_mutex_lock(&active_symbols_lock);
-			if (list_empty(&syme->node) || !syme->node.next)
-				__list_insert_active_sym(syme);
-			pthread_mutex_unlock(&active_symbols_lock);
+	struct sym_entry *syme;
+	struct symbol *sym;
+
+	switch (self->header.misc & PERF_RECORD_MISC_CPUMODE_MASK) {
+	case PERF_RECORD_MISC_USER: {
+		struct thread *thread = threads__findnew(self->ip.pid);
+
+		if (thread == NULL)
 			return;
+
+		map = thread__find_map(thread, ip);
+		if (map != NULL) {
+			ip = map->map_ip(map, ip);
+			sym = map->dso->find_symbol(map->dso, ip);
+			if (sym == NULL)
+				return;
+			userspace_samples++;
+			break;
 		}
 	}
+		/*
+		 * If this is outside of all known maps,
+		 * and is a negative address, try to look it
+		 * up in the kernel dso, as it might be a
+		 * vsyscall or vdso (which executes in user-mode).
+		 */
+		if ((long long)ip >= 0)
+			return;
+		/* Fall thru */
+	case PERF_RECORD_MISC_KERNEL:
+		sym = kernel_maps__find_symbol(ip, &map);
+		if (sym == NULL)
+			return;
+		break;
+	default:
+		return;
+	}
+
+	syme = dso__sym_priv(map->dso, sym);
 
-	samples--;
+	if (!syme->skip) {
+		syme->count[counter]++;
+		record_precise_ip(syme, counter, ip);
+		pthread_mutex_lock(&active_symbols_lock);
+		if (list_empty(&syme->node) || !syme->node.next)
+			__list_insert_active_sym(syme);
+		pthread_mutex_unlock(&active_symbols_lock);
+		++samples;
+		return;
+	}
 }
 
-static void process_event(u64 ip, int counter, int user)
+static void event__process_mmap(event_t *self)
 {
-	samples++;
+	struct thread *thread = threads__findnew(self->mmap.pid);
+
+	if (thread != NULL) {
+		struct map *map = map__new(&self->mmap, NULL, 0,
+					   sizeof(struct sym_entry),
+					   symbol_filter);
+		if (map != NULL)
+			thread__insert_map(thread, map);
+	}
+}
 
-	if (user) {
-		userspace_samples++;
-		return;
+static void event__process_comm(event_t *self)
+{
+	struct thread *thread = threads__findnew(self->comm.pid);
+
+	if (thread != NULL)
+		thread__set_comm(thread, self->comm.comm);
+}
+
+static int event__process(event_t *event)
+{
+	switch (event->header.type) {
+	case PERF_RECORD_COMM:
+		event__process_comm(event);
+		break;
+	case PERF_RECORD_MMAP:
+		event__process_mmap(event);
+		break;
+	default:
+		break;
 	}
 
-	record_ip(ip, counter);
+	return 0;
 }
 
 struct mmap_data {
@@ -925,13 +980,11 @@ static void mmap_read_counter(struct mmap_data *md)
 			event = &event_copy;
 		}
 
+		if (event->header.type == PERF_RECORD_SAMPLE)
+			event__process_sample(event, md->counter);
+		else
+			event__process(event);
 		old += size;
-
-		if (event->header.type == PERF_RECORD_SAMPLE) {
-			int user =
-	(event->header.misc & PERF_RECORD_MISC_CPUMODE_MASK) == PERF_RECORD_MISC_USER;
-			process_event(event->ip.ip, md->counter, user);
-		}
 	}
 
 	md->prev = old;
@@ -973,6 +1026,7 @@ static void start_counter(int i, int counter)
 	}
 
 	attr->inherit		= (cpu < 0) && inherit;
+	attr->mmap		= 1;
 
 try_again:
 	fd[i][counter] = sys_perf_event_open(attr, target_pid, cpu, group_fd, 0);
@@ -1031,6 +1085,11 @@ static int __cmd_top(void)
 	int i, counter;
 	int ret;
 
+	if (target_pid != -1)
+		event__synthesize_thread(target_pid, event__process);
+	else
+		event__synthesize_threads(event__process);
+
 	for (i = 0; i < nr_cpus; i++) {
 		group_fd = -1;
 		for (counter = 0; counter < nr_counters; counter++)
-- 
1.5.5.1

