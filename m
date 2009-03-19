Return-Path: <linux-kernel-owner+w=401wt.eu-S1760619AbZCSTns@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760619AbZCSTns (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Mar 2009 15:43:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757940AbZCSTnV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Mar 2009 15:43:21 -0400
Received: from casper.infradead.org ([85.118.1.10]:46794 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751882AbZCSTnU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Mar 2009 15:43:20 -0400
Message-Id: <20090319194233.652078652@chello.nl>
References: <20090319192610.660857280@chello.nl>
User-Agent: quilt/0.46-1
Date: Thu, 19 Mar 2009 20:26:16 +0100
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: mingo@elte.hu, paulus@samba.org, rostedt@goodmis.org
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 06/10] perf_counter: fix up counter free paths
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

