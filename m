Return-Path: <linux-kernel-owner+w=401wt.eu-S1755603AbZHYSGF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755603AbZHYSGF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Aug 2009 14:06:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755577AbZHYSGE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Aug 2009 14:06:04 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:33363 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755558AbZHYSGD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Aug 2009 14:06:03 -0400
Date: Tue, 25 Aug 2009 20:05:58 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>
Subject: [GIT PULL] perfcounters fixes
Message-ID: <20090825180558.GA32402@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest perfcounters-fixes-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git perfcounters-fixes-for-linus

 Thanks,

	Ingo

------------------>
Peter Zijlstra (2):
      perf tools: Check perf.data owner
      perf_counter: Fix typo in read() output generation


 kernel/perf_counter.c         |    2 +-
 tools/perf/builtin-annotate.c |    7 +++++++
 tools/perf/builtin-report.c   |    7 +++++++
 3 files changed, 15 insertions(+), 1 deletions(-)

diff --git a/kernel/perf_counter.c b/kernel/perf_counter.c
index 36f65e2..f274e19 100644
--- a/kernel/perf_counter.c
+++ b/kernel/perf_counter.c
@@ -1791,7 +1791,7 @@ static int perf_counter_read_group(struct perf_counter *counter,
 	size += err;
 
 	list_for_each_entry(sub, &leader->sibling_list, list_entry) {
-		err = perf_counter_read_entry(counter, read_format,
+		err = perf_counter_read_entry(sub, read_format,
 				buf + size);
 		if (err < 0)
 			return err;
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
