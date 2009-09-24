Return-Path: <linux-kernel-owner+w=401wt.eu-S1753159AbZIXQCH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753159AbZIXQCH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Sep 2009 12:02:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752722AbZIXQCG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Sep 2009 12:02:06 -0400
Received: from mx1.redhat.com ([209.132.183.28]:59565 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752639AbZIXQCE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Sep 2009 12:02:04 -0400
Date: Thu, 24 Sep 2009 18:01:51 +0200 (CEST)
From: John Kacur <jkacur@redhat.com>
X-X-Sender: jkacur@localhost.localdomain
To: mingo@elte.hu, Peter Zijlstra <a.p.zijlstra@chello.nl>
cc: linux-kernel@vger.kernel.org, linux-perf-users@vger.kernel.org
Subject: [PATCH 1/3]Add-the-cmp_null-function-to-builtin-annotate.c
Message-ID: <alpine.LFD.2.00.0909241754031.11383@localhost.localdomain>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 93d856e28036610f54efc41efba89cd887f2af90 Mon Sep 17 00:00:00 2001
From: John Kacur <jkacur@redhat.com>
Date: Mon, 21 Sep 2009 13:10:45 +0200
Subject: [PATCH] Add the cmp_null function to builtin-annotate.c and make use of it.

Add the cmp_null function to builtin-annotate.c and make use of it.
This function exists in builtin-report.c but not in builtin-annotate.c
Functions that use cmp_null are shorter and clearer. Synchronizing functions
between these two files will also make it easier to potential share code in
the future.

Signed-off-by: John Kacur <jkacur@redhat.com>
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
-- 
1.6.0.6

