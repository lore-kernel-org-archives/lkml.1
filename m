Return-Path: <linux-kernel-owner+w=401wt.eu-S933474AbZE0SWk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933474AbZE0SWk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 May 2009 14:22:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761793AbZE0SVo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 May 2009 14:21:44 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:58134 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932233AbZE0SVn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 May 2009 14:21:43 -0400
Message-Id: <20090527182101.229504802@chello.nl>
References: <20090527182021.231666503@chello.nl>
User-Agent: quilt/0.46-1
Date: Wed, 27 May 2009 20:20:28 +0200
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>,
       Corey Ashford <cjashfor@linux.vnet.ibm.com>,
       linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       John Kacur <jkacur@redhat.com>, Mike Galbraith <efault@gmx.de>
Subject: [PATCH 7/7] pref_counter: tools: report: add dso sorting
Content-Disposition: inline; filename=perf_counter-tools-report-sort6.patch
X-Bad-Reply: References but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


LKML-Reference: <new-submission>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 Documentation/perf_counter/builtin-report.c |   30 ++++++++++++++++++++++++++++
 1 file changed, 30 insertions(+)

Index: linux-2.6/Documentation/perf_counter/builtin-report.c
===================================================================
--- linux-2.6.orig/Documentation/perf_counter/builtin-report.c
+++ linux-2.6/Documentation/perf_counter/builtin-report.c
@@ -761,6 +761,35 @@ static struct sort_entry sort_comm = {
 };
 
 static int64_t
+sort__dso_cmp(struct hist_entry *left, struct hist_entry *right)
+{
+	struct dso *dso_l = left->dso;
+	struct dso *dso_r = right->dso;
+
+	if (!dso_l || !dso_r) {
+		if (!dso_l && !dso_r)
+			return 0;
+		else if (!dso_l)
+			return -1;
+		else
+			return 1;
+	}
+
+	return strcmp(dso_l->name, dso_r->name);
+}
+
+static size_t
+sort__dso_print(FILE *fp, struct hist_entry *self)
+{
+	return fprintf(fp, "%64s ", self->dso ? self->dso->name : "<unknown>");
+}
+
+static struct sort_entry sort_dso = {
+	.cmp	= sort__dso_cmp,
+	.print	= sort__dso_print,
+};
+
+static int64_t
 sort__sym_cmp(struct hist_entry *left, struct hist_entry *right)
 {
 	uint64_t ip_l, ip_r;
@@ -809,6 +838,7 @@ struct sort_dimension {
 static struct sort_dimension sort_dimensions[] = {
 	{ .name = "pid",	.entry = &sort_thread,	},
 	{ .name = "comm",	.entry = &sort_comm,	},
+	{ .name = "dso",	.entry = &sort_dso,	},
 	{ .name = "symbol",	.entry = &sort_sym,	},
 };
 

-- 

