Return-Path: <linux-kernel-owner+w=401wt.eu-S933554AbZE0SXa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933554AbZE0SXa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 May 2009 14:23:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932208AbZE0SVq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 May 2009 14:21:46 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:58137 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933140AbZE0SVq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 May 2009 14:21:46 -0400
Message-Id: <20090527182101.129302022@chello.nl>
References: <20090527182021.231666503@chello.nl>
User-Agent: quilt/0.46-1
Date: Wed, 27 May 2009 20:20:27 +0200
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>,
       Corey Ashford <cjashfor@linux.vnet.ibm.com>,
       linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       John Kacur <jkacur@redhat.com>, Mike Galbraith <efault@gmx.de>
Subject: [PATCH 6/7] perf_counter: tools: report: add comm sorting
Content-Disposition: inline; filename=perf_counter-tools-report-sort5.patch
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
@@ -732,6 +732,35 @@ static struct sort_entry sort_thread = {
 };
 
 static int64_t
+sort__comm_cmp(struct hist_entry *left, struct hist_entry *right)
+{
+	char *comm_l = left->thread->comm;
+	char *comm_r = right->thread->comm;
+
+	if (!comm_l || !comm_r) {
+		if (!comm_l && !comm_r)
+			return 0;
+		else if (!comm_l)
+			return -1;
+		else
+			return 1;
+	}
+
+	return strcmp(comm_l, comm_r);
+}
+
+static size_t
+sort__comm_print(FILE *fp, struct hist_entry *self)
+{
+	return fprintf(fp, "%20s ", self->thread->comm ?: "<unknown>");
+}
+
+static struct sort_entry sort_comm = {
+	.cmp	= sort__comm_cmp,
+	.print	= sort__comm_print,
+};
+
+static int64_t
 sort__sym_cmp(struct hist_entry *left, struct hist_entry *right)
 {
 	uint64_t ip_l, ip_r;
@@ -779,6 +808,7 @@ struct sort_dimension {
 
 static struct sort_dimension sort_dimensions[] = {
 	{ .name = "pid",	.entry = &sort_thread,	},
+	{ .name = "comm",	.entry = &sort_comm,	},
 	{ .name = "symbol",	.entry = &sort_sym,	},
 };
 

-- 

