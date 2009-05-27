Return-Path: <linux-kernel-owner+w=401wt.eu-S932801AbZE0SVr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932801AbZE0SVr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 May 2009 14:21:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759997AbZE0SVg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 May 2009 14:21:36 -0400
Received: from casper.infradead.org ([85.118.1.10]:52030 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755747AbZE0SVf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 May 2009 14:21:35 -0400
Message-Id: <20090527182101.041817692@chello.nl>
References: <20090527182021.231666503@chello.nl>
User-Agent: quilt/0.46-1
Date: Wed, 27 May 2009 20:20:26 +0200
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>,
       Corey Ashford <cjashfor@linux.vnet.ibm.com>,
       linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       John Kacur <jkacur@redhat.com>, Mike Galbraith <efault@gmx.de>
Subject: [PATCH 5/7] pref_counter: tools: report: --sort option
Content-Disposition: inline; filename=perf_counter-tools-report-sort4.patch
X-Bad-Reply: References but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

option parsing for dynamic sorting

LKML-Reference: <new-submission>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 Documentation/perf_counter/builtin-report.c |   43 ++++++++++++++++++++++++++--
 1 file changed, 41 insertions(+), 2 deletions(-)

Index: linux-2.6/Documentation/perf_counter/builtin-report.c
===================================================================
--- linux-2.6.orig/Documentation/perf_counter/builtin-report.c
+++ linux-2.6/Documentation/perf_counter/builtin-report.c
@@ -20,6 +20,7 @@
 
 static char		const *input_name = "perf.data";
 static char		*vmlinux = NULL;
+static char		*sort_order = "pid,symbol";
 static int		input;
 static int		show_mask = SHOW_KERNEL | SHOW_USER | SHOW_HV;
 
@@ -770,12 +771,49 @@ static struct sort_entry sort_sym = {
 	.print	= sort__sym_print,
 };
 
+struct sort_dimension {
+	char *name;
+	struct sort_entry *entry;
+	int taken;
+};
+
+static struct sort_dimension sort_dimensions[] = {
+	{ .name = "pid",	.entry = &sort_thread,	},
+	{ .name = "symbol",	.entry = &sort_sym,	},
+};
+
 static LIST_HEAD(hist_entry__sort_list);
 
+static int sort_dimension__add(char *tok)
+{
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(sort_dimensions); i++) {
+		struct sort_dimension *sd = &sort_dimensions[i];
+
+		if (sd->taken)
+			continue;
+
+		if (strcmp(tok, sd->name))
+			continue;
+
+		list_add_tail(&sd->entry->list, &hist_entry__sort_list);
+		sd->taken = 1;
+		return 0;
+	}
+
+	return -ESRCH;
+}
+
 static void setup_sorting(void)
 {
-	list_add_tail(&sort_thread.list, &hist_entry__sort_list);
-	list_add_tail(&sort_sym.list, &hist_entry__sort_list);
+	char *tmp, *tok, *str = strdup(sort_order);
+
+	for (tok = strtok_r(str, ", ", &tmp);
+			tok; tok = strtok_r(NULL, ", ", &tmp))
+		sort_dimension__add(tok);
+
+	free(str);
 }
 
 static int64_t
@@ -1137,6 +1175,7 @@ static const struct option options[] = {
 	OPT_BOOLEAN('D', "dump-raw-trace", &dump_trace,
 		    "dump raw trace in ASCII"),
 	OPT_STRING('k', "vmlinux", &vmlinux, "file", "vmlinux pathname"),
+	OPT_STRING('s', "sort", &sort_order, "foo", "bar"),
 	OPT_END()
 };
 

-- 

