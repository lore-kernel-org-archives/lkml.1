Return-Path: <linux-kernel-owner+w=401wt.eu-S1755687Ab0AVBST@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755687Ab0AVBST (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jan 2010 20:18:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755664Ab0AVBSP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jan 2010 20:18:15 -0500
Received: from fg-out-1718.google.com ([72.14.220.156]:17015 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755395Ab0AVBQi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jan 2010 20:16:38 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=CSkjl4NQGtlDWaHyVTuRMmfPiXWpE7S3e7B9clbPswBrn6BFvNEKI7eAtZDBwIFeJY
         tSWuCyEbhdg53aY0QuL/E89GMm7GwZ23XNx/b+6GxhxVxQd2dzK+hrxiqvhxZ09ZmxA9
         PQG2sLTiEPo5+DYqyhz/jyWUjij/XtvVQif4A=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>, Li Zefan <lizf@cn.fujitsu.com>,
       Lai Jiangshan <laijs@cn.fujitsu.com>
Subject: [RFC PATCH 10/10] ftrace: Factorize search and insertion in the function hashlist
Date: Fri, 22 Jan 2010 02:16:22 +0100
Message-Id: <1264122982-1553-11-git-send-regression-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
In-Reply-To: <1264122982-1553-1-git-send-regression-fweisbec@gmail.com>
References: <1264122982-1553-1-git-send-regression-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Factorize search and insertion operations in the function hashlist
to remove some redundant code.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Li Zefan <lizf@cn.fujitsu.com>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>
---
 kernel/trace/ftrace.c                |   18 ++++++------------
 kernel/trace/functions_hlist.h       |   12 ++++++++++++
 kernel/trace/trace_functions_graph.c |   17 +++++++----------
 3 files changed, 25 insertions(+), 22 deletions(-)

diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index d719078..785d077 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -385,12 +385,9 @@ function_profile_call(unsigned long ip, unsigned long parent_ip)
 
 	hlist = &__get_cpu_var(func_hlist_cpu);
 
-	rec = function_find_hlist_node(hlist, ip);
-	if (!rec) {
-		rec = function_hlist_record_alloc(hlist, ip);
-		if (!rec)
-			goto out;
-	}
+	rec = function_get_hlist_node(hlist, ip);
+	if (!rec)
+		goto out;
 
 	rec->counter++;
  out:
@@ -2198,12 +2195,9 @@ change_graph_function_hlist(unsigned long ip, int val, struct func_hlist *hlist)
 {
 	struct func_node *rec;
 
-	rec = function_find_hlist_node(hlist, ip);
-	if (!rec) {
-		rec = function_hlist_record_alloc(hlist, ip);
-		if (!rec)
-			return 1;
-	}
+	rec = function_get_hlist_node(hlist, ip);
+	if (!rec)
+		return 1;
 
 	rec->graph_start = val;
 
diff --git a/kernel/trace/functions_hlist.h b/kernel/trace/functions_hlist.h
index 39d89b4..3baf4bb 100644
--- a/kernel/trace/functions_hlist.h
+++ b/kernel/trace/functions_hlist.h
@@ -40,3 +40,15 @@ int get_function_hlist(void);
 void put_function_hlist(void);
 void function_hlist_reset_profile(void);
 void function_hlist_reset_graph(void);
+
+static inline struct func_node *
+function_get_hlist_node(struct func_hlist *hlist, unsigned long ip)
+{
+	struct func_node *rec;
+
+	rec = function_find_hlist_node(hlist, ip);
+	if (!rec)
+		rec = function_hlist_record_alloc(hlist, ip);
+
+	return rec;
+}
diff --git a/kernel/trace/trace_functions_graph.c b/kernel/trace/trace_functions_graph.c
index da24add..0fa0691 100644
--- a/kernel/trace/trace_functions_graph.c
+++ b/kernel/trace/trace_functions_graph.c
@@ -213,16 +213,13 @@ static inline int ftrace_graph_addr(unsigned long addr)
 
 	hlist = &__get_cpu_var(func_hlist_cpu);
 
-	rec = function_find_hlist_node(hlist, addr);
-	if (!rec) {
-		/*
-		 * TODO: send a retrieval error event
-		 * to keep track of this.
-		 */
-		rec = function_hlist_record_alloc(hlist, addr);
-		if (!rec)
-			return 0;
-	}
+	/*
+	 * TODO: send a retrieval error event
+	 * to keep track of failures
+	 */
+	rec = function_get_hlist_node(hlist, addr);
+	if (!rec)
+		return 0;
 
 	if (rec->graph_start)
 		return 1;
-- 
1.6.2.3

