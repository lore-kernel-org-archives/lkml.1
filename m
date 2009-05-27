Return-Path: <linux-kernel-owner+w=401wt.eu-S933455AbZE0Txm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933455AbZE0Txm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 May 2009 15:53:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933317AbZE0TxF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 May 2009 15:53:05 -0400
Received: from hera.kernel.org ([140.211.167.34]:51450 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933195AbZE0TxD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 May 2009 15:53:03 -0400
Date: Wed, 27 May 2009 19:52:19 GMT
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
In-Reply-To: <20090527182101.129302022@chello.nl>
References: <20090527182101.129302022@chello.nl>
Subject: [tip:perfcounters/core] perf_counter: tools: report: Add comm sorting
Message-ID: <tip-992444b173f35997f96f5cbb214f0de81d1b97ff@git.kernel.org>
Git-Commit-ID: 992444b173f35997f96f5cbb214f0de81d1b97ff
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 27 May 2009 19:52:20 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  992444b173f35997f96f5cbb214f0de81d1b97ff
Gitweb:     http://git.kernel.org/tip/992444b173f35997f96f5cbb214f0de81d1b97ff
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Wed, 27 May 2009 20:20:27 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 27 May 2009 21:44:14 +0200

perf_counter: tools: report: Add comm sorting

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: John Kacur <jkacur@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
LKML-Reference: <20090527182101.129302022@chello.nl>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 Documentation/perf_counter/builtin-report.c |   30 +++++++++++++++++++++++++++
 1 files changed, 30 insertions(+), 0 deletions(-)

diff --git a/Documentation/perf_counter/builtin-report.c b/Documentation/perf_counter/builtin-report.c
index 982abce..a634022 100644
--- a/Documentation/perf_counter/builtin-report.c
+++ b/Documentation/perf_counter/builtin-report.c
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
 
