Return-Path: <linux-kernel-owner+w=401wt.eu-S1752835AbZHSNcr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752835AbZHSNcr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Aug 2009 09:32:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752639AbZHSNcq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Aug 2009 09:32:46 -0400
Received: from hera.kernel.org ([140.211.167.34]:34673 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752095AbZHSNco (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Aug 2009 09:32:44 -0400
Date: Wed, 19 Aug 2009 13:32:14 GMT
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, acme@redhat.com,
       hpa@zytor.com, mingo@redhat.com, a.p.zijlstra@chello.nl, efault@gmx.de,
       fweisbec@gmail.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
       linux-kernel@vger.kernel.org, fweisbec@gmail.com,
       a.p.zijlstra@chello.nl, efault@gmx.de, tglx@linutronix.de,
       mingo@elte.hu
In-Reply-To: <20090819092023.896648538@chello.nl>
References: <20090819092023.896648538@chello.nl>
Subject: [tip:perfcounters/core] perf tools: Check perf.data owner
Message-ID: <tip-fa6963b2481beff8b11f76006fbb63fdbbf2d2d7@git.kernel.org>
Git-Commit-ID: fa6963b2481beff8b11f76006fbb63fdbbf2d2d7
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 19 Aug 2009 13:32:14 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  fa6963b2481beff8b11f76006fbb63fdbbf2d2d7
Gitweb:     http://git.kernel.org/tip/fa6963b2481beff8b11f76006fbb63fdbbf2d2d7
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Wed, 19 Aug 2009 11:18:26 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 19 Aug 2009 15:25:51 +0200

perf tools: Check perf.data owner

Add an owner check to opening perf.data files and a switch to
silence it.

Because perf-report/perf-annotate are binary parsers reading
another users' perf.data file could be a security risk if the
file were explicitly engineered to trigger bugs in the parser
(we hope of course there are non such bugs, but you never
know).

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
LKML-Reference: <20090819092023.896648538@chello.nl>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 tools/perf/builtin-annotate.c |    7 +++++++
 tools/perf/builtin-report.c   |    7 +++++++
 2 files changed, 14 insertions(+), 0 deletions(-)

diff --git a/tools/perf/builtin-annotate.c b/tools/perf/builtin-annotate.c
index 343e7b1..5e17de9 100644
--- a/tools/perf/builtin-annotate.c
+++ b/tools/perf/builtin-annotate.c
@@ -31,6 +31,7 @@ static char		*vmlinux = "vmlinux";
 static char		default_sort_order[] = "comm,symbol";
 static char		*sort_order = default_sort_order;
 
+static int		force;
 static int		input;
 static int		show_mask = SHOW_KERNEL | SHOW_USER | SHOW_HV;
 
@@ -1334,6 +1335,11 @@ static int __cmd_annotate(void)
 		exit(-1);
 	}
 
+	if (!force && (stat.st_uid != geteuid())) {
+		fprintf(stderr, "file: %s not owned by current user\n", input_name);
+		exit(-1);
+	}
+
 	if (!stat.st_size) {
 		fprintf(stderr, "zero-sized file, nothing to do!\n");
 		exit(0);
@@ -1439,6 +1445,7 @@ static const struct option options[] = {
 		    "input file name"),
 	OPT_STRING('s', "symbol", &sym_hist_filter, "symbol",
 		    "symbol to annotate"),
+	OPT_BOOLEAN('f', "force", &force, "don't complain, do it"),
 	OPT_BOOLEAN('v', "verbose", &verbose,
 		    "be more verbose (show symbol address, etc)"),
 	OPT_BOOLEAN('D', "dump-raw-trace", &dump_trace,
diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index b53a60f..8b2ec88 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -38,6 +38,7 @@ static char		*dso_list_str, *comm_list_str, *sym_list_str,
 static struct strlist	*dso_list, *comm_list, *sym_list;
 static char		*field_sep;
 
+static int		force;
 static int		input;
 static int		show_mask = SHOW_KERNEL | SHOW_USER | SHOW_HV;
 
@@ -1856,6 +1857,11 @@ static int __cmd_report(void)
 		exit(-1);
 	}
 
+	if (!force && (stat.st_uid != geteuid())) {
+		fprintf(stderr, "file: %s not owned by current user\n", input_name);
+		exit(-1);
+	}
+
 	if (!stat.st_size) {
 		fprintf(stderr, "zero-sized file, nothing to do!\n");
 		exit(0);
@@ -2064,6 +2070,7 @@ static const struct option options[] = {
 	OPT_BOOLEAN('D', "dump-raw-trace", &dump_trace,
 		    "dump raw trace in ASCII"),
 	OPT_STRING('k', "vmlinux", &vmlinux, "file", "vmlinux pathname"),
+	OPT_BOOLEAN('f', "force", &force, "don't complain, do it"),
 	OPT_BOOLEAN('m', "modules", &modules,
 		    "load module symbols - WARNING: use only with -k and LIVE kernel"),
 	OPT_BOOLEAN('n', "show-nr-samples", &show_nr_samples,
