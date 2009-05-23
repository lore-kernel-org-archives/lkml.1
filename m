Return-Path: <linux-kernel-owner+w=401wt.eu-S1757013AbZEWQcQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757013AbZEWQcQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 May 2009 12:32:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756103AbZEWQcA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 May 2009 12:32:00 -0400
Received: from casper.infradead.org ([85.118.1.10]:42756 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756470AbZEWQb6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 May 2009 12:31:58 -0400
Message-Id: <20090523163012.618790733@chello.nl>
References: <20090523162854.599719825@chello.nl>
User-Agent: quilt/0.46-1
Date: Sat, 23 May 2009 18:28:57 +0200
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>,
       Corey Ashford <cjashfor@linux.vnet.ibm.com>,
       linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       John Kacur <jkacur@redhat.com>
Subject: [PATCH 3/7] perf_counter: sanitize context locking
Content-Disposition: inline; filename=perf_counter-ctx-lock.patch
X-Bad-Reply: References but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ensure we're consistent with the context locks.

 context->mutex
   context->lock
     list_{add,del}_counter();

so that either lock is sufficient to stabilize the context.

LKML-Reference: <new-submission>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 kernel/perf_counter.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

Index: linux-2.6/kernel/perf_counter.c
===================================================================
--- linux-2.6.orig/kernel/perf_counter.c
+++ linux-2.6/kernel/perf_counter.c
@@ -597,6 +597,8 @@ static void add_counter_to_ctx(struct pe
 
 /*
  * Cross CPU call to install and enable a performance counter
+ *
+ * Must be called with ctx->mutex held
  */
 static void __perf_install_in_context(void *info)
 {
@@ -1496,13 +1498,13 @@ static void perf_counter_for_each_siblin
 	struct perf_counter_context *ctx = counter->ctx;
 	struct perf_counter *sibling;
 
-	spin_lock_irq(&ctx->lock);
+	mutex_lock(&ctx->mutex);
 	counter = counter->group_leader;
 
 	func(counter);
 	list_for_each_entry(sibling, &counter->sibling_list, list_entry)
 		func(sibling);
-	spin_unlock_irq(&ctx->lock);
+	mutex_unlock(&ctx->mutex);
 }
 
 static void perf_counter_for_each_child(struct perf_counter *counter,
@@ -3414,7 +3416,10 @@ __perf_counter_exit_task(struct task_str
 	struct perf_counter *parent_counter;
 
 	update_counter_times(child_counter);
+
+	spin_lock_irq(&child_ctx->lock);
 	list_del_counter(child_counter, child_ctx);
+	spin_unlock_irq(&child_ctx->lock);
 
 	parent_counter = child_counter->parent;
 	/*

-- 

