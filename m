Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756524Ab0CJNUZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Mar 2010 08:20:25 -0500
Received: from hera.kernel.org ([140.211.167.34]:57457 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756476Ab0CJNUV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Mar 2010 08:20:21 -0500
Date: Wed, 10 Mar 2010 13:19:46 GMT
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       acme@infradead.org, a.p.zijlstra@chello.nl, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       a.p.zijlstra@chello.nl, acme@infradead.org, tglx@linutronix.de,
       mingo@elte.hu
In-Reply-To: <20100304140100.694233760@chello.nl>
References: <20100304140100.694233760@chello.nl>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/pebs] perf-top: Show the percentage of successfull PEBS-fixups
Message-ID: <tip-1676b8a077c352085d52578fb4f29350b58b6e74@git.kernel.org>
Git-Commit-ID: 1676b8a077c352085d52578fb4f29350b58b6e74
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 10 Mar 2010 13:19:48 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  1676b8a077c352085d52578fb4f29350b58b6e74
Gitweb:     http://git.kernel.org/tip/1676b8a077c352085d52578fb4f29350b58b6e74
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Thu, 4 Mar 2010 14:19:36 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 10 Mar 2010 13:23:33 +0100

perf-top: Show the percentage of successfull PEBS-fixups

Use the PERF_RECORD_MISC_EXACT information to measure the success rate of
the PEBS fix-up.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Arnaldo Carvalho de Melo <acme@infradead.org>
Cc: paulus@samba.org
Cc: eranian@google.com
Cc: robert.richter@amd.com
Cc: fweisbec@gmail.com
LKML-Reference: <20100304140100.694233760@chello.nl>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 tools/perf/builtin-top.c |   12 +++++++++---
 1 files changed, 9 insertions(+), 3 deletions(-)

diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
index 31f2e59..c051833 100644
--- a/tools/perf/builtin-top.c
+++ b/tools/perf/builtin-top.c
@@ -410,6 +410,7 @@ static double sym_weight(const struct sym_entry *sym)
 
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
@@ -954,6 +957,9 @@ static void event__process_sample(const event_t *self,
 		return;
 	}
 
+	if (self->header.misc & PERF_RECORD_MISC_EXACT)
+		exact_samples++;
+
 	if (event__preprocess_sample(self, session, &al, symbol_filter) < 0 ||
 	    al.filtered)
 		return;
