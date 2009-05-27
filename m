Return-Path: <linux-kernel-owner+w=401wt.eu-S1761562AbZE0TxY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761562AbZE0TxY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 May 2009 15:53:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933199AbZE0Twn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 May 2009 15:52:43 -0400
Received: from hera.kernel.org ([140.211.167.34]:51432 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933122AbZE0Twl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 May 2009 15:52:41 -0400
Date: Wed, 27 May 2009 19:52:08 GMT
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, paulus@samba.org,
       hpa@zytor.com, mingo@redhat.com, jkacur@redhat.com,
       a.p.zijlstra@chello.nl, efault@gmx.de, tglx@linutronix.de,
       cjashfor@linux.vnet.ibm.com, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org, acme@redhat.com,
       linux-kernel@vger.kernel.org, jkacur@redhat.com, a.p.zijlstra@chello.nl,
       efault@gmx.de, tglx@linutronix.de, cjashfor@linux.vnet.ibm.com,
       mingo@elte.hu
In-Reply-To: <20090527182101.041817692@chello.nl>
References: <20090527182101.041817692@chello.nl>
Subject: [tip:perfcounters/core] pref_counter: tools: report: Add --sort option
Message-ID: <tip-37f440cba299bb479cf45d12eef923f0979dbcaf@git.kernel.org>
Git-Commit-ID: 37f440cba299bb479cf45d12eef923f0979dbcaf
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 27 May 2009 19:52:08 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  37f440cba299bb479cf45d12eef923f0979dbcaf
Gitweb:     http://git.kernel.org/tip/37f440cba299bb479cf45d12eef923f0979dbcaf
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Wed, 27 May 2009 20:20:26 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 27 May 2009 21:44:14 +0200

pref_counter: tools: report: Add --sort option

option parsing for dynamic sorting.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: John Kacur <jkacur@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
LKML-Reference: <20090527182101.041817692@chello.nl>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 Documentation/perf_counter/builtin-report.c |   43 +++++++++++++++++++++++++-
 1 files changed, 41 insertions(+), 2 deletions(-)

diff --git a/Documentation/perf_counter/builtin-report.c b/Documentation/perf_counter/builtin-report.c
index 856186f..982abce 100644
--- a/Documentation/perf_counter/builtin-report.c
+++ b/Documentation/perf_counter/builtin-report.c
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
 
