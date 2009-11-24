Return-Path: <linux-kernel-owner+w=401wt.eu-S933003AbZKXOFX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933003AbZKXOFX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Nov 2009 09:05:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932929AbZKXOFW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Nov 2009 09:05:22 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:52536 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932926AbZKXOFW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Nov 2009 09:05:22 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
       =?utf-8?q?Fr=C3=A9d=C3=A9ric=20Weisbecker?= <fweisbec@gmail.com>,
       Mike Galbraith <efault@gmx.de>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>
Subject: [PATCH 1/4] perf top: Always show the DSO column, even if its all the same
Date: Tue, 24 Nov 2009 12:05:14 -0200
Message-Id: <1259071517-3242-1-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

Ingo found it confusing, and I agree with that, for 'perf report' its OK
because it is static, but for a tool refreshing it the eventual switch
from column to summary at the top may seem confusing.

Suggested-by: Ingo Molnar <mingo@elte.hu>
Cc: Frédéric Weisbecker <fweisbec@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-top.c |   38 +++++++++++---------------------------
 1 files changed, 11 insertions(+), 27 deletions(-)

diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
index 6a5de90..b9a321f 100644
--- a/tools/perf/builtin-top.c
+++ b/tools/perf/builtin-top.c
@@ -451,9 +451,8 @@ static void print_sym_table(void)
 	struct sym_entry *syme, *n;
 	struct rb_root tmp = RB_ROOT;
 	struct rb_node *nd;
-	int sym_width = 0, dso_width = 0;
+	int sym_width = 0, dso_width = 0, max_dso_width;
 	const int win_width = winsize.ws_col - 1;
-	struct dso *unique_dso = NULL, *first_dso = NULL;
 
 	samples = userspace_samples = 0;
 
@@ -539,11 +538,6 @@ static void print_sym_table(void)
 		    (int)syme->snap_count < count_filter)
 			continue;
 
-		if (first_dso == NULL)
-			unique_dso = first_dso = syme->map->dso;
-		else if (syme->map->dso != first_dso)
-			unique_dso = NULL;
-
 		if (syme->map->dso->long_name_len > dso_width)
 			dso_width = syme->map->dso->long_name_len;
 
@@ -553,14 +547,10 @@ static void print_sym_table(void)
 
 	printed = 0;
 
-	if (unique_dso)
-		printf("DSO: %s\n", unique_dso->long_name);
-	else {
-		int max_dso_width = winsize.ws_col - sym_width - 29;
-		if (dso_width > max_dso_width)
-			dso_width = max_dso_width;
-		putchar('\n');
-	}
+	max_dso_width = winsize.ws_col - sym_width - 29;
+	if (dso_width > max_dso_width)
+		dso_width = max_dso_width;
+	putchar('\n');
 	if (nr_counters == 1)
 		printf("             samples  pcnt");
 	else
@@ -568,17 +558,13 @@ static void print_sym_table(void)
 
 	if (verbose)
 		printf("         RIP       ");
-	printf(" %-*.*s", sym_width, sym_width, "function");
-	if (!unique_dso)
-		printf(" DSO");
-	putchar('\n');
+	printf(" %-*.*s DSO\n", sym_width, sym_width, "function");
 	printf("   %s    _______ _____",
 	       nr_counters == 1 ? "      " : "______");
 	if (verbose)
 		printf(" ________________");
 	printf(" %-*.*s", sym_width, sym_width, graph_line);
-	if (!unique_dso)
-		printf(" %-*.*s", dso_width, dso_width, graph_line);
+	printf(" %-*.*s", dso_width, dso_width, graph_line);
 	puts("\n");
 
 	for (nd = rb_first(&tmp); nd; nd = rb_next(nd)) {
@@ -603,12 +589,10 @@ static void print_sym_table(void)
 		if (verbose)
 			printf(" %016llx", sym->start);
 		printf(" %-*.*s", sym_width, sym_width, sym->name);
-		if (!unique_dso)
-			printf(" %-*.*s", dso_width, dso_width,
-			       dso_width >= syme->map->dso->long_name_len ?
-						syme->map->dso->long_name :
-						syme->map->dso->short_name);
-		printf("\n");
+		printf(" %-*.*s\n", dso_width, dso_width,
+		       dso_width >= syme->map->dso->long_name_len ?
+					syme->map->dso->long_name :
+					syme->map->dso->short_name);
 	}
 }
 
-- 
1.6.2.5

