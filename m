Return-Path: <linux-kernel-owner+w=401wt.eu-S1751442AbZHZTNj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751442AbZHZTNj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Aug 2009 15:13:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751099AbZHZTNi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Aug 2009 15:13:38 -0400
Received: from hera.kernel.org ([140.211.167.34]:37735 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751091AbZHZTNi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Aug 2009 15:13:38 -0400
Date: Wed, 26 Aug 2009 19:13:07 GMT
From: tip-bot for Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, acme@redhat.com,
       hpa@zytor.com, mingo@redhat.com, efault@gmx.de, peterz@infradead.org,
       fweisbec@gmail.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
       linux-kernel@vger.kernel.org, fweisbec@gmail.com, peterz@infradead.org,
       efault@gmx.de, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20090826145126.GA5255@ghostprotocols.net>
References: <20090826145126.GA5255@ghostprotocols.net>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perfcounters/core] perf top: Show RIP only in verbose mode
Message-ID: <tip-7ced156bb8bb6363b6ed541871bf19a90273f910@git.kernel.org>
Git-Commit-ID: 7ced156bb8bb6363b6ed541871bf19a90273f910
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 26 Aug 2009 19:13:07 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  7ced156bb8bb6363b6ed541871bf19a90273f910
Gitweb:     http://git.kernel.org/tip/7ced156bb8bb6363b6ed541871bf19a90273f910
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Wed, 26 Aug 2009 11:51:26 -0300
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 26 Aug 2009 20:21:45 +0200

perf top: Show RIP only in verbose mode

Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
LKML-Reference: <20090826145126.GA5255@ghostprotocols.net>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 tools/perf/builtin-top.c |   17 ++++++++++++-----
 1 files changed, 12 insertions(+), 5 deletions(-)

diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
index 62b55ec..4002ccb 100644
--- a/tools/perf/builtin-top.c
+++ b/tools/perf/builtin-top.c
@@ -483,11 +483,16 @@ static void print_sym_table(void)
 	if (nr_counters == 1)
 		printf("             samples    pcnt");
 	else
-		printf("  weight     samples    pcnt");
+		printf("   weight    samples    pcnt");
 
-	printf("         RIP          kernel function\n"
-	       	       "  ______     _______   _____   ________________   _______________\n\n"
-	);
+	if (verbose)
+		printf("         RIP       ");
+	printf("   kernel function\n");
+	printf("   %s    _______   _____",
+	       nr_counters == 1 ? "      " : "______");
+	if (verbose)
+		printf("   ________________");
+	printf("   _______________\n\n");
 
 	for (nd = rb_first(&tmp); nd; nd = rb_next(nd)) {
 		struct symbol *sym;
@@ -508,7 +513,9 @@ static void print_sym_table(void)
 			printf("%9.1f %10ld - ", syme->weight, syme->snap_count);
 
 		percent_color_fprintf(stdout, "%4.1f%%", pcnt);
-		printf(" - %016llx : %s", sym->start, sym->name);
+		if (verbose)
+			printf(" - %016llx", sym->start);
+		printf(" : %s", sym->name);
 		if (sym->module)
 			printf("\t[%s]", sym->module->name);
 		printf("\n");
