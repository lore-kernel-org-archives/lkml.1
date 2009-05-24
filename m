Return-Path: <linux-kernel-owner+w=401wt.eu-S1754838AbZEXHCo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754838AbZEXHCo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 May 2009 03:02:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753368AbZEXHCW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 May 2009 03:02:22 -0400
Received: from hera.kernel.org ([140.211.167.34]:35703 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753306AbZEXHCU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 May 2009 03:02:20 -0400
Date: Sun, 24 May 2009 07:01:31 GMT
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, paulus@samba.org,
       hpa@zytor.com, mingo@redhat.com, jkacur@redhat.com,
       a.p.zijlstra@chello.nl, tglx@linutronix.de, cjashfor@linux.vnet.ibm.com,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org, acme@redhat.com,
       linux-kernel@vger.kernel.org, jkacur@redhat.com, a.p.zijlstra@chello.nl,
       tglx@linutronix.de, cjashfor@linux.vnet.ibm.com, mingo@elte.hu
In-Reply-To: <20090523163012.618790733@chello.nl>
References: <20090523163012.618790733@chello.nl>
Subject: [tip:perfcounters/core] perf_counter: Sanitize context locking
Message-ID: <tip-682076ae1de0aba9c2da509f7b19dc03e30a6e1f@git.kernel.org>
Git-Commit-ID: 682076ae1de0aba9c2da509f7b19dc03e30a6e1f
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Sun, 24 May 2009 07:01:31 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  682076ae1de0aba9c2da509f7b19dc03e30a6e1f
Gitweb:     http://git.kernel.org/tip/682076ae1de0aba9c2da509f7b19dc03e30a6e1f
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Sat, 23 May 2009 18:28:57 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sat, 23 May 2009 19:37:46 +0200

perf_counter: Sanitize context locking

Ensure we're consistent with the context locks.

 context->mutex
   context->lock
     list_{add,del}_counter();

so that either lock is sufficient to stabilize the context.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: John Kacur <jkacur@redhat.com>
LKML-Reference: <20090523163012.618790733@chello.nl>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 kernel/perf_counter.c |    9 +++++++--
 1 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/kernel/perf_counter.c b/kernel/perf_counter.c
index 679c3b5..d162d2f 100644
--- a/kernel/perf_counter.c
+++ b/kernel/perf_counter.c
@@ -597,6 +597,8 @@ static void add_counter_to_ctx(struct perf_counter *counter,
 
 /*
  * Cross CPU call to install and enable a performance counter
+ *
+ * Must be called with ctx->mutex held
  */
 static void __perf_install_in_context(void *info)
 {
@@ -1496,13 +1498,13 @@ static void perf_counter_for_each_sibling(struct perf_counter *counter,
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
@@ -3414,7 +3416,10 @@ __perf_counter_exit_task(struct task_struct *child,
 	struct perf_counter *parent_counter;
 
 	update_counter_times(child_counter);
+
+	spin_lock_irq(&child_ctx->lock);
 	list_del_counter(child_counter, child_ctx);
+	spin_unlock_irq(&child_ctx->lock);
 
 	parent_counter = child_counter->parent;
 	/*
