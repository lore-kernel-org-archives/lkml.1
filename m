Return-Path: <linux-kernel-owner+w=401wt.eu-S1757082AbZCQWIk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757082AbZCQWIk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Mar 2009 18:08:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756264AbZCQWGT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Mar 2009 18:06:19 -0400
Received: from casper.infradead.org ([85.118.1.10]:35080 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755750AbZCQWGR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Mar 2009 18:06:17 -0400
Message-Id: <20090317220419.037509892@chello.nl>
References: <20090317215606.037073805@chello.nl>
User-Agent: quilt/0.46-1
Date: Tue, 17 Mar 2009 22:56:07 +0100
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: mingo@elte.hu, paulus@samba.org, rostedt@goodmis.org
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [RFC][PATCH 01/11] perf_counter: fix uninitialized usage of event_list
Content-Disposition: inline; filename=perf_swcounter_fix-init.patch
X-Bad-Reply: References but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When doing the generic context switch event I ran into some early boot
hangs, which were caused by inf func recursion (event, fault, event, fault).

I eventually tracked it down to event_list not being initialized at the
time of the first event. Fix this.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 kernel/perf_counter.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

Index: linux-2.6/kernel/perf_counter.c
===================================================================
--- linux-2.6.orig/kernel/perf_counter.c
+++ linux-2.6/kernel/perf_counter.c
@@ -1506,7 +1506,7 @@ static void perf_swcounter_ctx_event(str
 {
 	struct perf_counter *counter;
 
-	if (list_empty(&ctx->event_list))
+	if (!ctx->is_active || list_empty(&ctx->event_list))
 		return;
 
 	rcu_read_lock();
diff --git a/include/linux/init_task.h b/include/linux/init_task.h
index 219748d..ca226a9 100644
--- a/include/linux/init_task.h
+++ b/include/linux/init_task.h
@@ -124,6 +124,8 @@ extern struct cred init_cred;
 # define INIT_PERF_COUNTERS(tsk)					\
 	.perf_counter_ctx.counter_list =				\
 		LIST_HEAD_INIT(tsk.perf_counter_ctx.counter_list),	\
+	.perf_counter_ctx.event_list =					\
+		LIST_HEAD_INIT(tsk.perf_counter_ctx.event_list),	\
 	.perf_counter_ctx.lock =					\
 		__SPIN_LOCK_UNLOCKED(tsk.perf_counter_ctx.lock),
 #else

-- 

