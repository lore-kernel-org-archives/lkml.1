Return-Path: <linux-kernel-owner+w=401wt.eu-S1756223AbZKTVbi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756223AbZKTVbi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Nov 2009 16:31:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756049AbZKTVbg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Nov 2009 16:31:36 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:34638 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755671AbZKTV22 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Nov 2009 16:28:28 -0500
Message-Id: <20091120212508.378188589@chello.nl>
References: <20091120211942.676891948@chello.nl>
User-Agent: quilt/0.46-1
Date: Fri, 20 Nov 2009 22:19:45 +0100
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 03/15] perf: optimize perf_swevent_ctx_event()
Content-Disposition: inline; filename=perf-sw-counting-state.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove a rcu_read_{,un}lock() pair and a few conditionals.

We can remove the rcu_read_lock() by increasing the scope of one in
the calling function.

We can do away with the system_state check if the machine still boots
after this patch (seems to be the case).

We can do away with the list_empty() check because the bare
list_for_each_entry_rcu() reduces to that now that we've removed
everything else.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 kernel/perf_event.c |    7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

Index: linux-2.6/kernel/perf_event.c
===================================================================
--- linux-2.6.orig/kernel/perf_event.c
+++ linux-2.6/kernel/perf_event.c
@@ -3886,15 +3886,10 @@ static void perf_swevent_ctx_event(struc
 {
 	struct perf_event *event;
 
-	if (system_state != SYSTEM_RUNNING || list_empty(&ctx->event_list))
-		return;
-
-	rcu_read_lock();
 	list_for_each_entry_rcu(event, &ctx->event_list, event_entry) {
 		if (perf_swevent_match(event, type, event_id, data, regs))
 			perf_swevent_add(event, nr, nmi, data, regs);
 	}
-	rcu_read_unlock();
 }
 
 static int *perf_swevent_recursion_context(struct perf_cpu_context *cpuctx)
@@ -3926,9 +3921,9 @@ static void do_perf_sw_event(enum perf_t
 	(*recursion)++;
 	barrier();
 
+	rcu_read_lock();
 	perf_swevent_ctx_event(&cpuctx->ctx, type, event_id,
 				 nr, nmi, data, regs);
-	rcu_read_lock();
 	/*
 	 * doesn't really matter which of the child contexts the
 	 * events ends up in.

-- 

