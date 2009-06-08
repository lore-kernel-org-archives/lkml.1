Return-Path: <linux-kernel-owner+w=401wt.eu-S1757217AbZFHVen@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757217AbZFHVen (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jun 2009 17:34:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757142AbZFHVe1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Jun 2009 17:34:27 -0400
Received: from hera.kernel.org ([140.211.167.34]:40250 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756846AbZFHVeZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jun 2009 17:34:25 -0400
Date: Mon, 8 Jun 2009 21:33:56 GMT
From: tip-bot for Ingo Molnar <mingo@elte.hu>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, paulus@samba.org,
       hpa@zytor.com, mingo@redhat.com, a.p.zijlstra@chello.nl, efault@gmx.de,
       tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org, acme@redhat.com,
       linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl, efault@gmx.de,
       tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <new-submission>
References: <new-submission>
Subject: [tip:perfcounters/core] perf_counter tools: Standardize color printing
Message-ID: <tip-aefcf37b82886260d8540c9fb815e613c8977e06@git.kernel.org>
Git-Commit-ID: aefcf37b82886260d8540c9fb815e613c8977e06
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Mon, 08 Jun 2009 21:33:56 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  aefcf37b82886260d8540c9fb815e613c8977e06
Gitweb:     http://git.kernel.org/tip/aefcf37b82886260d8540c9fb815e613c8977e06
Author:     Ingo Molnar <mingo@elte.hu>
AuthorDate: Mon, 8 Jun 2009 23:15:28 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 8 Jun 2009 23:15:28 +0200

perf_counter tools: Standardize color printing

The rule is:

 - high overhead: red
 -  mid overhead: green
 -  low overhead: normal (white/black)

Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
LKML-Reference: <new-submission>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 tools/perf/builtin-annotate.c |    5 +++--
 tools/perf/builtin-report.c   |   13 ++++++++-----
 tools/perf/builtin-top.c      |   13 ++++++++-----
 3 files changed, 19 insertions(+), 12 deletions(-)

diff --git a/tools/perf/builtin-annotate.c b/tools/perf/builtin-annotate.c
index 0e23fe9..3334a8b 100644
--- a/tools/perf/builtin-annotate.c
+++ b/tools/perf/builtin-annotate.c
@@ -1085,8 +1085,9 @@ parse_line(FILE *file, struct symbol *sym, uint64_t start, uint64_t len)
 			percent = 100.0 * hits / sym->hist_sum;
 
 		/*
-		 * We color high-overhead entries in red, low-overhead
-		 * entries in green - and keep the middle ground normal:
+		 * We color high-overhead entries in red, mid-overhead
+		 * entries in green - and keep the low overhead places
+		 * normal:
 		 */
 		if (percent >= 5.0)
 			color = PERF_COLOR_RED;
diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index 61d8718..0b18cb9 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -693,13 +693,16 @@ hist_entry__fprintf(FILE *fp, struct hist_entry *self, uint64_t total_samples)
 		char *color = PERF_COLOR_NORMAL;
 
 		/*
-		 * We color high-overhead entries in red, low-overhead
-		 * entries in green - and keep the middle ground normal:
+		 * We color high-overhead entries in red, mid-overhead
+		 * entries in green - and keep the low overhead places
+		 * normal:
 		 */
-		if (percent >= 5.0)
+		if (percent >= 5.0) {
 			color = PERF_COLOR_RED;
-		if (percent < 0.5)
-			color = PERF_COLOR_GREEN;
+		} else {
+			if (percent >= 0.5)
+				color = PERF_COLOR_GREEN;
+		}
 
 		ret = color_fprintf(fp, color, "   %6.2f%%",
 				(self->count * 100.0) / total_samples);
diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
index be1698f..8ba2480 100644
--- a/tools/perf/builtin-top.c
+++ b/tools/perf/builtin-top.c
@@ -248,13 +248,16 @@ static void print_sym_table(void)
 					 sum_ksamples));
 
 		/*
-		 * We color high-overhead entries in red, low-overhead
-		 * entries in green - and keep the middle ground normal:
+		 * We color high-overhead entries in red, mid-overhead
+		 * entries in green - and keep the low overhead places
+		 * normal:
 		 */
-		if (pcnt >= 5.0)
+		if (pcnt >= 5.0) {
 			color = PERF_COLOR_RED;
-		if (pcnt < 0.5)
-			color = PERF_COLOR_GREEN;
+		} else {
+			if (pcnt >= 0.5)
+				color = PERF_COLOR_GREEN;
+		}
 
 		if (nr_counters == 1)
 			printf("%20.2f - ", syme->weight);
