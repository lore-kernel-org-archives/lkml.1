Return-Path: <linux-kernel-owner+w=401wt.eu-S1754172AbZKQRlK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754172AbZKQRlK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Nov 2009 12:41:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753965AbZKQRlJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Nov 2009 12:41:09 -0500
Received: from casper.infradead.org ([85.118.1.10]:42361 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753028AbZKQRlF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Nov 2009 12:41:05 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
       =?utf-8?q?Fr=C3=A9d=C3=A9ric=20Weisbecker?= <fweisbec@gmail.com>,
       Mike Galbraith <efault@gmx.de>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>
Subject: [PATCH 3/3] perf top: Suppress DSO column if only one is present
Date: Tue, 17 Nov 2009 15:40:55 -0200
Message-Id: <1258479655-28662-3-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1258479655-28662-2-git-send-email-acme@infradead.org>
References: <1258479655-28662-1-git-send-email-acme@infradead.org>
 <1258479655-28662-2-git-send-email-acme@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

E.g.

[root@doppio ~]# perf top -U
---------------------------------------------------------------------------
   PerfTop:     482 irqs/sec  kernel:100.0% [1000Hz cycles],  (all, 2 CPUs)
---------------------------------------------------------------------------
DSO: vmlinux
             samples  pcnt function
             _______ _____ _________________________

              471.00 47.9% read_hpet
               57.00  5.8% acpi_os_read_port
               30.00  3.1% hpet_next_event
               30.00  3.1% find_busiest_group
               22.00  2.2% schedule
               18.00  1.8% sched_clock_local
               14.00  1.4% _spin_lock_irqsave
               14.00  1.4% native_read_tsc
               13.00  1.3% trace_hardirqs_off
                9.00  0.9% fget_light
                9.00  0.9% ioread8
                8.00  0.8% do_sys_poll

Cc: Frédéric Weisbecker <fweisbec@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-top.c |   43 ++++++++++++++++++++++++++++++++-----------
 1 files changed, 32 insertions(+), 11 deletions(-)

diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
index a368978..6db0e37 100644
--- a/tools/perf/builtin-top.c
+++ b/tools/perf/builtin-top.c
@@ -438,8 +438,9 @@ static void print_sym_table(void)
 	struct sym_entry *syme, *n;
 	struct rb_root tmp = RB_ROOT;
 	struct rb_node *nd;
-	int sym_width = 0, dso_width;
+	int sym_width = 0, dso_width = 0;
 	const int win_width = winsize.ws_col - 1;
+	struct dso *unique_dso = NULL, *first_dso = NULL;
 
 	samples = userspace_samples = 0;
 
@@ -509,7 +510,7 @@ static void print_sym_table(void)
 			printf(", %d CPUs)\n", nr_cpus);
 	}
 
-	printf("%-*.*s\n\n", win_width, win_width, graph_dotted_line);
+	printf("%-*.*s\n", win_width, win_width, graph_dotted_line);
 
 	if (sym_filter_entry) {
 		show_details(sym_filter_entry);
@@ -525,28 +526,47 @@ static void print_sym_table(void)
 		    (int)syme->snap_count < count_filter)
 			continue;
 
+		if (first_dso == NULL)
+			unique_dso = first_dso = syme->map->dso;
+		else if (syme->map->dso != first_dso)
+			unique_dso = NULL;
+
+		if (syme->map->dso->long_name_len > dso_width)
+			dso_width = syme->map->dso->long_name_len;
+
 		if (syme->name_len > sym_width)
 			sym_width = syme->name_len;
 	}
 
 	printed = 0;
 
+	if (unique_dso)
+		printf("DSO: %s\n", unique_dso->long_name);
+	else {
+		int max_dso_width = winsize.ws_col - sym_width - 29;
+		if (dso_width > max_dso_width)
+			dso_width = max_dso_width;
+		putchar('\n');
+	}
 	if (nr_counters == 1)
 		printf("             samples  pcnt");
 	else
 		printf("   weight    samples  pcnt");
 
-	dso_width = winsize.ws_col - sym_width - 29;
-
 	if (verbose)
 		printf("         RIP       ");
-	printf(" %-*.*s DSO\n", sym_width, sym_width, "function");
+	printf(" %-*.*s", sym_width, sym_width, "function");
+	if (!unique_dso)
+		printf(" DSO");
+	putchar('\n');
 	printf("   %s    _______ _____",
 	       nr_counters == 1 ? "      " : "______");
 	if (verbose)
 		printf(" ________________");
-	printf(" %-*.*s %-*.*s\n\n", sym_width, sym_width, graph_line,
-	       dso_width, dso_width, graph_line);
+	printf(" %-*.*s", sym_width, sym_width, graph_line);
+	if (!unique_dso)
+		printf(" %-*.*s", dso_width, dso_width, graph_line);
+	puts("\n");
 
 	for (nd = rb_first(&tmp); nd; nd = rb_next(nd)) {
 		struct symbol *sym;
@@ -570,10 +590,11 @@ static void print_sym_table(void)
 		if (verbose)
 			printf(" %016llx", sym->start);
 		printf(" %-*.*s", sym_width, sym_width, sym->name);
-		printf(" %-*.*s", dso_width, dso_width,
-		       dso_width >= syme->map->dso->long_name_len ?
-					syme->map->dso->long_name :
-					syme->map->dso->short_name);
+		if (!unique_dso)
+			printf(" %-*.*s", dso_width, dso_width,
+			       dso_width >= syme->map->dso->long_name_len ?
+						syme->map->dso->long_name :
+						syme->map->dso->short_name);
 		printf("\n");
 	}
 }
-- 
1.6.2.5

