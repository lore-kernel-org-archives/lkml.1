Return-Path: <linux-kernel-owner+w=401wt.eu-S1758994AbZCQWGm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758994AbZCQWGm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Mar 2009 18:06:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754726AbZCQWGP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Mar 2009 18:06:15 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:50347 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752366AbZCQWGN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Mar 2009 18:06:13 -0400
Message-Id: <20090317220420.778794411@chello.nl>
References: <20090317215606.037073805@chello.nl>
User-Agent: quilt/0.46-1
Date: Tue, 17 Mar 2009 22:56:13 +0100
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: mingo@elte.hu, paulus@samba.org, rostedt@goodmis.org
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [RFC][PATCH 07/11] perf_counter: fix up counter free paths
Content-Disposition: inline; filename=perf_counter-free_counter.patch
X-Bad-Reply: References but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I found another counter free path, create a free_counter() call to accomodate
generic tear-down.

Fixes an RCU bug.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 kernel/perf_counter.c |   11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

Index: linux-2.6/kernel/perf_counter.c
===================================================================
--- linux-2.6.orig/kernel/perf_counter.c
+++ linux-2.6/kernel/perf_counter.c
@@ -1150,6 +1150,11 @@ static void free_counter_rcu(struct rcu_
 	kfree(counter);
 }
 
+static void free_counter(struct perf_counter *counter)
+{
+	call_rcu(&counter->rcu_head, free_counter_rcu);
+}
+
 /*
  * Called when the last reference to the file is gone.
  */
@@ -1168,7 +1173,7 @@ static int perf_release(struct inode *in
 	mutex_unlock(&counter->mutex);
 	mutex_unlock(&ctx->mutex);
 
-	call_rcu(&counter->rcu_head, free_counter_rcu);
+	free_counter(counter);
 	put_context(ctx);
 
 	return 0;
@@ -2128,10 +2133,10 @@ __perf_counter_exit_task(struct task_str
 					 list_entry) {
 			if (sub->parent) {
 				sync_child_counter(sub, sub->parent);
-				kfree(sub);
+				free_counter(sub);
 			}
 		}
-		kfree(child_counter);
+		free_counter(child_counter);
 	}
 }
 

-- 

