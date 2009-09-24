Return-Path: <linux-kernel-owner+w=401wt.eu-S1754510AbZIXThE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754510AbZIXThE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Sep 2009 15:37:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754448AbZIXThD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Sep 2009 15:37:03 -0400
Received: from hera.kernel.org ([140.211.167.34]:40185 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754221AbZIXThB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Sep 2009 15:37:01 -0400
Date: Thu, 24 Sep 2009 19:36:37 GMT
From: tip-bot for John Kacur <jkacur@redhat.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       jkacur@redhat.com, a.p.zijlstra@chello.nl, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       jkacur@redhat.com, a.p.zijlstra@chello.nl, tglx@linutronix.de,
       mingo@elte.hu
In-Reply-To: <alpine.LFD.2.00.0909241754031.11383@localhost.localdomain>
References: <alpine.LFD.2.00.0909241754031.11383@localhost.localdomain>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf annotate: Add the cmp_null function and make use of it
Message-ID: <tip-cbfeb267cb0ff632dbc8ff02685012bee2e87434@git.kernel.org>
Git-Commit-ID: cbfeb267cb0ff632dbc8ff02685012bee2e87434
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Thu, 24 Sep 2009 19:36:37 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  cbfeb267cb0ff632dbc8ff02685012bee2e87434
Gitweb:     http://git.kernel.org/tip/cbfeb267cb0ff632dbc8ff02685012bee2e87434
Author:     John Kacur <jkacur@redhat.com>
AuthorDate: Thu, 24 Sep 2009 18:01:51 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 24 Sep 2009 21:27:50 +0200

perf annotate: Add the cmp_null function and make use of it

This function exists in builtin-report.c but not in
builtin-annotate.c Functions that use cmp_null are shorter and
clearer.

Synchronizing functions between these two files will also make it
easier to potential share code in the future.

Signed-off-by: John Kacur <jkacur@redhat.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <alpine.LFD.2.00.0909241754031.11383@localhost.localdomain>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 tools/perf/builtin-annotate.c |   30 ++++++++++++++----------------
 1 files changed, 14 insertions(+), 16 deletions(-)

diff --git a/tools/perf/builtin-annotate.c b/tools/perf/builtin-annotate.c
index 1ec7416..a330873 100644
--- a/tools/perf/builtin-annotate.c
+++ b/tools/perf/builtin-annotate.c
@@ -82,6 +82,16 @@ struct sort_entry {
 	size_t	(*print)(FILE *fp, struct hist_entry *);
 };
 
+static int64_t cmp_null(void *l, void *r)
+{
+	if (!l && !r)
+		return 0;
+	else if (!l)
+		return -1;
+	else
+		return 1;
+}
+
 /* --sort pid */
 
 static int64_t
@@ -116,14 +126,8 @@ sort__comm_collapse(struct hist_entry *left, struct hist_entry *right)
 	char *comm_l = left->thread->comm;
 	char *comm_r = right->thread->comm;
 
-	if (!comm_l || !comm_r) {
-		if (!comm_l && !comm_r)
-			return 0;
-		else if (!comm_l)
-			return -1;
-		else
-			return 1;
-	}
+	if (!comm_l || !comm_r)
+		return cmp_null(comm_l, comm_r);
 
 	return strcmp(comm_l, comm_r);
 }
@@ -149,14 +153,8 @@ sort__dso_cmp(struct hist_entry *left, struct hist_entry *right)
 	struct dso *dso_l = left->dso;
 	struct dso *dso_r = right->dso;
 
-	if (!dso_l || !dso_r) {
-		if (!dso_l && !dso_r)
-			return 0;
-		else if (!dso_l)
-			return -1;
-		else
-			return 1;
-	}
+	if (!dso_l || !dso_r)
+		return cmp_null(dso_l, dso_r);
 
 	return strcmp(dso_l->name, dso_r->name);
 }
