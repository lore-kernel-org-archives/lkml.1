Return-Path: <linux-kernel-owner+w=401wt.eu-S1760956AbZCSTqP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760956AbZCSTqP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Mar 2009 15:46:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758342AbZCSTn0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Mar 2009 15:43:26 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:53499 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757624AbZCSTnV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Mar 2009 15:43:21 -0400
Message-Id: <20090319194233.195392657@chello.nl>
References: <20090319192610.660857280@chello.nl>
User-Agent: quilt/0.46-1
Date: Thu, 19 Mar 2009 20:26:11 +0100
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: mingo@elte.hu, paulus@samba.org, rostedt@goodmis.org
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 01/10] perf_counter: fix uninitialized usage of event_list
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
 include/linux/init_task.h |    2 ++
 kernel/perf_counter.c     |    2 +-
 2 files changed, 3 insertions(+), 1 deletion(-)

Index: linux-2.6/kernel/perf_counter.c
===================================================================
--- linux-2.6.orig/kernel/perf_counter.c
+++ linux-2.6/kernel/perf_counter.c
@@ -1506,7 +1506,7 @@ static void perf_swcounter_ctx_event(str
 {
 	struct perf_counter *counter;
 
-	if (list_empty(&ctx->event_list))
+	if (system_state != SYSTEM_RUNNING || list_empty(&ctx->event_list))
 		return;
 
 	rcu_read_lock();
Index: linux-2.6/include/linux/init_task.h
===================================================================
--- linux-2.6.orig/include/linux/init_task.h
+++ linux-2.6/include/linux/init_task.h
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

