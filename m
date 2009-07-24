Return-Path: <linux-kernel-owner+w=401wt.eu-S1750976AbZGXIJ4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750976AbZGXIJ4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jul 2009 04:09:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750720AbZGXIJz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Jul 2009 04:09:55 -0400
Received: from mail.gmx.net ([213.165.64.20]:42314 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1750736AbZGXIJx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jul 2009 04:09:53 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1+q/dAfur+qEXPXFBRICzn6uFPE6jgnwaIalU4yn7
	5Z2BDAkaHhuxIK
Subject: [patch] perf tools: allow top users to switch between weighted and
 individual counter display
From: Mike Galbraith <efault@gmx.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>
Content-Type: text/plain
Date: Fri, 24 Jul 2009 10:09:50 +0200
Message-Id: <1248422990.28486.3.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.68
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(depends on last resurrect annotation patch)

perf_counter tools: allow top users to switch between weighted and individual counter display.

Add [w]eighted hotkey.  Pressing [w] toggles between displaying weighted total of all counters,
and the counter selected via [E]vent select key.


------------------------------------------------------------------------------
   PerfTop:   90395 irqs/sec  kernel:16.1% [cache-misses/cache-references/instructions],  (all, 4 CPUs)
------------------------------------------------------------------------------

  weight     samples    pcnt         RIP          kernel function
  ______     _______   _____   ________________   _______________

1275408.6      10881 -  5.3% - ffffffff81146f70 : copy_page_c
 553683.4      43569 - 21.3% - ffffffff81146f20 : clear_page_c
  74075.0       6768 -  3.3% - ffffffff81147190 : copy_user_generic_string
  40602.9       7538 -  3.7% - ffffffff81284ba2 : _spin_lock
  26882.1        965 -  0.5% - ffffffff8109d280 : file_ra_state_init

[w]

------------------------------------------------------------------------------
   PerfTop:   91221 irqs/sec  kernel:14.5% [10000Hz cache-misses],  (all, 4 CPUs)
------------------------------------------------------------------------------

  weight     samples    pcnt         RIP          kernel function
  ______     _______   _____   ________________   _______________

            47320.00 - 22.3% - ffffffff81146f20 : clear_page_c
            14261.00 -  6.7% - ffffffff810992f5 : __rmqueue
            11046.00 -  5.2% - ffffffff81146f70 : copy_page_c
             7842.00 -  3.7% - ffffffff81284ba2 : _spin_lock
             7234.00 -  3.4% - ffffffff810aa1d6 : unmap_vmas


Signed-off-by: Mike Galbraith <efault@gmx.de>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <new-submission>

---
 tools/perf/builtin-top.c |   24 +++++++++++++++++-------
 1 file changed, 17 insertions(+), 7 deletions(-)

Index: linux-2.6/tools/perf/builtin-top.c
===================================================================
--- linux-2.6.orig/tools/perf/builtin-top.c
+++ linux-2.6/tools/perf/builtin-top.c
@@ -90,6 +90,7 @@ static char			*sym_filter			=  NULL;
 struct sym_entry		*sym_filter_entry		=  NULL;
 static int			sym_pcnt_filter			=  5;
 static int			sym_counter			=  0;
+static int			display_weighted		= -1;
 
 /*
  * Symbols
@@ -354,6 +355,9 @@ static double sym_weight(const struct sy
 	double weight = sym->snap_count;
 	int counter;
 
+	if (!display_weighted)
+		return weight;
+
 	for (counter = 1; counter < nr_counters-1; counter++)
 		weight *= sym->count[counter];
 
@@ -401,7 +405,7 @@ static void rb_insert_active_sym(struct
 static void print_sym_table(void)
 {
 	int printed = 0, j;
-	int counter;
+	int counter, snap = !display_weighted ? sym_counter : 0;
 	float samples_per_sec = samples/delay_secs;
 	float ksamples_per_sec = (samples-userspace_samples)/delay_secs;
 	float sum_ksamples = 0.0;
@@ -417,7 +421,7 @@ static void print_sym_table(void)
 	pthread_mutex_unlock(&active_symbols_lock);
 
 	list_for_each_entry_safe_from(syme, n, &active_symbols, node) {
-		syme->snap_count = syme->count[0];
+		syme->snap_count = syme->count[snap];
 		if (syme->snap_count != 0) {
 			syme->weight = sym_weight(syme);
 			rb_insert_active_sym(&tmp, syme);
@@ -437,7 +441,7 @@ static void print_sym_table(void)
 		samples_per_sec,
 		100.0 - (100.0*((samples_per_sec-ksamples_per_sec)/samples_per_sec)));
 
-	if (nr_counters == 1) {
+	if (nr_counters == 1 || !display_weighted) {
 		printf("%Ld", (u64)attrs[0].sample_period);
 		if (freq)
 			printf("Hz ");
@@ -445,7 +449,9 @@ static void print_sym_table(void)
 			printf(" ");
 	}
 
-	for (counter = 0; counter < nr_counters; counter++) {
+	if (!display_weighted)
+		printf("%s", event_name(sym_counter));
+	else for (counter = 0; counter < nr_counters; counter++) {
 		if (counter)
 			printf("/");
 
@@ -495,7 +501,7 @@ static void print_sym_table(void)
 		pcnt = 100.0 - (100.0 * ((sum_ksamples - syme->snap_count) /
 					 sum_ksamples));
 
-		if (nr_counters == 1)
+		if (nr_counters == 1 || !display_weighted)
 			printf("%20.2f - ", syme->weight);
 		else
 			printf("%9.1f %10ld - ", syme->weight, syme->snap_count);
@@ -601,13 +607,14 @@ static void print_known_keys(void)
 	fprintf(stdout, "\nknown keys:\n");
 	fprintf(stdout, "\t[d]     display refresh delay.             \t(%d)\n", delay_secs);
 	fprintf(stdout, "\t[e]     display entries (lines).           \t(%d)\n", print_entries);
-	fprintf(stdout, "\t[E]     annotate event counter.            \t(%s)\n", event_name(sym_counter));
+	fprintf(stdout, "\t[E]     active event counter.              \t(%s)\n", event_name(sym_counter));
 	fprintf(stdout, "\t[f]     profile display filter (count).    \t(%d)\n", count_filter);
 	fprintf(stdout, "\t[F]     annotate display filter (percent). \t(%d%%)\n", sym_pcnt_filter);
 	fprintf(stdout, "\t[qQ]    quit.\n");
 	fprintf(stdout, "\t[s]     annotate symbol.                   \t(%s)\n", name?: "NULL");
 	fprintf(stdout, "\t[S]     stop annotation.\n");
-	fprintf(stdout, "\t[z]     toggle count zeroing.              \t(%d)\n", zero ? 1 : 0);
+	fprintf(stdout, "\t[w]     toggle display weighted/count[E]r. \t(%d)\n", display_weighted ? 1 : 0);
+	fprintf(stdout, "\t[z]     toggle sample zeroing.             \t(%d)\n", zero ? 1 : 0);
 }
 
 static void handle_keypress(int c)
@@ -663,6 +670,9 @@ repeat:
 				pthread_mutex_unlock(&syme->source_lock);
 			}
 			break;
+		case 'w':
+			display_weighted = ~display_weighted;
+			break;
 		case 'z':
 			zero = ~zero;
 			break;


