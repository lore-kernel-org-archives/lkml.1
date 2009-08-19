Return-Path: <linux-kernel-owner+w=401wt.eu-S1751560AbZHSJXT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751560AbZHSJXT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Aug 2009 05:23:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751517AbZHSJXS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Aug 2009 05:23:18 -0400
Received: from casper.infradead.org ([85.118.1.10]:60903 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751483AbZHSJXA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Aug 2009 05:23:00 -0400
Message-Id: <20090819092023.896648538@chello.nl>
References: <20090819091823.916851355@chello.nl>
User-Agent: quilt/0.46-1
Date: Wed, 19 Aug 2009 11:18:26 +0200
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Ingo Molnar <mingo@elte.hu>, Paul Mackerras <paulus@samba.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Mike Galbraith <efault@gmx.de>, linux-kernel@vger.kernel.org,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 3/4] perf tools: Check perf.data owner
Content-Disposition: inline; filename=perf-tool-check-uid.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add an owner check to opening perf.data files and a switch to silence
it.

Because perf-report/perf-annotate are binary parsers reading another
users' perf.data file could be a security risk if the file were
explicitly engineered to trigger bugs in the parser (we hope of course
there are non such bugs, but you never know).

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 tools/perf/builtin-annotate.c |    7 +++++++
 tools/perf/builtin-report.c   |    7 +++++++
 2 files changed, 14 insertions(+)

Index: linux-2.6/tools/perf/builtin-annotate.c
===================================================================
--- linux-2.6.orig/tools/perf/builtin-annotate.c
+++ linux-2.6/tools/perf/builtin-annotate.c
@@ -28,6 +28,7 @@ static char		const *input_name = "perf.d
 static char		default_sort_order[] = "comm,symbol";
 static char		*sort_order = default_sort_order;
 
+static int		force;
 static int		input;
 static int		show_mask = SHOW_KERNEL | SHOW_USER | SHOW_HV;
 
@@ -976,6 +977,11 @@ static int __cmd_annotate(void)
 		exit(-1);
 	}
 
+	if (!force && (input_stat.st_uid != geteuid())) {
+		fprintf(stderr, "file: %s not owned by current user\n", input_name);
+		exit(-1);
+	}
+
 	if (!input_stat.st_size) {
 		fprintf(stderr, "zero-sized file, nothing to do!\n");
 		exit(0);
@@ -1081,6 +1087,7 @@ static const struct option options[] = {
 		    "input file name"),
 	OPT_STRING('s', "symbol", &sym_hist_filter, "symbol",
 		    "symbol to annotate"),
+	OPT_BOOLEAN('f', "force", &force, "don't complain, do it"),
 	OPT_BOOLEAN('v', "verbose", &verbose,
 		    "be more verbose (show symbol address, etc)"),
 	OPT_BOOLEAN('D', "dump-raw-trace", &dump_trace,
Index: linux-2.6/tools/perf/builtin-report.c
===================================================================
--- linux-2.6.orig/tools/perf/builtin-report.c
+++ linux-2.6/tools/perf/builtin-report.c
@@ -37,6 +37,7 @@ static char		*dso_list_str, *comm_list_s
 static struct strlist	*dso_list, *comm_list, *sym_list;
 static char		*field_sep;
 
+static int		force;
 static int		input;
 static int		show_mask = SHOW_KERNEL | SHOW_USER | SHOW_HV;
 
@@ -1383,6 +1384,11 @@ static int __cmd_report(void)
 		exit(-1);
 	}
 
+	if (!force && (input_stat.st_uid != geteuid())) {
+		fprintf(stderr, "file: %s not owned by current user\n", input_name);
+		exit(-1);
+	}
+
 	if (!input_stat.st_size) {
 		fprintf(stderr, "zero-sized file, nothing to do!\n");
 		exit(0);
@@ -1594,6 +1600,7 @@ static const struct option options[] = {
 	OPT_BOOLEAN('D', "dump-raw-trace", &dump_trace,
 		    "dump raw trace in ASCII"),
 	OPT_STRING('k', "vmlinux", &vmlinux_name, "file", "vmlinux pathname"),
+	OPT_BOOLEAN('f', "force", &force, "don't complain, do it"),
 	OPT_BOOLEAN('m', "modules", &modules,
 		    "load module symbols - WARNING: use only with -k and LIVE kernel"),
 	OPT_BOOLEAN('n', "show-nr-samples", &show_nr_samples,

-- 

