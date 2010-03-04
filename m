Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754501Ab0CDODH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Mar 2010 09:03:07 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:54166 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753923Ab0CDOCE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Mar 2010 09:02:04 -0500
Message-Id: <20100304140100.694233760@chello.nl>
References: <20100304140046.596569763@chello.nl>
User-Agent: quilt/0.46-1
Date: Thu, 04 Mar 2010 15:00:56 +0100
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: mingo@elte.hu, linux-kernel@vger.kernel.org
Cc: paulus@samba.org, eranian@google.com, robert.richter@amd.com,
       fweisbec@gmail.com, Arnaldo Carvalho de Melo <acme@infradead.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 10/14] perf-top: Show the percentage of successfull PEBS-fixups
Content-Disposition: inline; filename=perf-tools-exact.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the PERF_RECORD_MISC_EXACT information to measure the success
rate of the PEBS fix-up.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <new-submission>
---
 tools/perf/builtin-top.c |   12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

Index: linux-2.6/tools/perf/builtin-top.c
===================================================================
--- linux-2.6.orig/tools/perf/builtin-top.c
+++ linux-2.6/tools/perf/builtin-top.c
@@ -410,6 +410,7 @@ static double sym_weight(const struct sy
 
 static long			samples;
 static long			userspace_samples;
+static long			exact_samples;
 static const char		CONSOLE_CLEAR[] = "[H[2J";
 
 static void __list_insert_active_sym(struct sym_entry *syme)
@@ -450,6 +451,7 @@ static void print_sym_table(void)
 	int counter, snap = !display_weighted ? sym_counter : 0;
 	float samples_per_sec = samples/delay_secs;
 	float ksamples_per_sec = (samples-userspace_samples)/delay_secs;
+	float esamples_percent = (100.0*exact_samples)/samples;
 	float sum_ksamples = 0.0;
 	struct sym_entry *syme, *n;
 	struct rb_root tmp = RB_ROOT;
@@ -457,7 +459,7 @@ static void print_sym_table(void)
 	int sym_width = 0, dso_width = 0, max_dso_width;
 	const int win_width = winsize.ws_col - 1;
 
-	samples = userspace_samples = 0;
+	samples = userspace_samples = exact_samples = 0;
 
 	/* Sort the active symbols */
 	pthread_mutex_lock(&active_symbols_lock);
@@ -488,9 +490,10 @@ static void print_sym_table(void)
 	puts(CONSOLE_CLEAR);
 
 	printf("%-*.*s\n", win_width, win_width, graph_dotted_line);
-	printf( "   PerfTop:%8.0f irqs/sec  kernel:%4.1f%% [",
+	printf( "   PerfTop:%8.0f irqs/sec  kernel:%4.1f%%  exact: %4.1f%% [",
 		samples_per_sec,
-		100.0 - (100.0*((samples_per_sec-ksamples_per_sec)/samples_per_sec)));
+		100.0 - (100.0*((samples_per_sec-ksamples_per_sec)/samples_per_sec)),
+		esamples_percent);
 
 	if (nr_counters == 1 || !display_weighted) {
 		printf("%Ld", (u64)attrs[0].sample_period);
@@ -954,6 +957,9 @@ static void event__process_sample(const 
 		return;
 	}
 
+	if (self->header.misc & PERF_RECORD_MISC_EXACT)
+		exact_samples++;
+
 	if (event__preprocess_sample(self, session, &al, symbol_filter) < 0 ||
 	    al.filtered)
 		return;

-- 

