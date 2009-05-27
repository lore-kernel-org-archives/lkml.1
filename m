Return-Path: <linux-kernel-owner+w=401wt.eu-S933513AbZE0Tx6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933513AbZE0Tx6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 May 2009 15:53:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933135AbZE0TxV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 May 2009 15:53:21 -0400
Received: from hera.kernel.org ([140.211.167.34]:51458 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762261AbZE0TxU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 May 2009 15:53:20 -0400
Date: Wed, 27 May 2009 19:52:31 GMT
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
In-Reply-To: <20090527182101.229504802@chello.nl>
References: <20090527182101.229504802@chello.nl>
Subject: [tip:perfcounters/core] pref_counter: tools: report: Add dso sorting
Message-ID: <tip-55e5ec41a9de46b6ca06031f4fbdfdfc76dc24dc@git.kernel.org>
Git-Commit-ID: 55e5ec41a9de46b6ca06031f4fbdfdfc76dc24dc
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 27 May 2009 19:52:32 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  55e5ec41a9de46b6ca06031f4fbdfdfc76dc24dc
Gitweb:     http://git.kernel.org/tip/55e5ec41a9de46b6ca06031f4fbdfdfc76dc24dc
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Wed, 27 May 2009 20:20:28 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 27 May 2009 21:44:15 +0200

pref_counter: tools: report: Add dso sorting

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: John Kacur <jkacur@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
LKML-Reference: <20090527182101.229504802@chello.nl>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 Documentation/perf_counter/builtin-report.c |   30 +++++++++++++++++++++++++++
 1 files changed, 30 insertions(+), 0 deletions(-)

diff --git a/Documentation/perf_counter/builtin-report.c b/Documentation/perf_counter/builtin-report.c
index a634022..30e12c7 100644
--- a/Documentation/perf_counter/builtin-report.c
+++ b/Documentation/perf_counter/builtin-report.c
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
 
