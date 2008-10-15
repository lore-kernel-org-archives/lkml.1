Return-Path: <linux-kernel-owner+w=401wt.eu-S1755472AbYJOShj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755472AbYJOShj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2008 14:37:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753113AbYJOShc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Oct 2008 14:37:32 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:34341 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752033AbYJOShb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2008 14:37:31 -0400
Subject: sched: only update rq->clock while holding rq->lock
From: Peter Zijlstra <peterz@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: vatsa <vatsa@linux.vnet.ibm.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>
Content-Type: text/plain
Date: Wed, 15 Oct 2008 20:37:23 +0200
Message-Id: <1224095843.28131.13.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Vatsa,

you said someone would send a patch to this effect, I don't want to
steal credit, but I think this patch is better posted sooner rather than
later.

---

Subject: sched: only update rq->clock while holding rq->lock
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
Date: Wed Oct 15 20:30:26 CEST 2008

Vatsa noticed rq->clock going funny and tracked it down to an update_rq_clock()
outside a rq->lock section.

This is a problem because things like double_rq_lock() update the rq->clock
value for both rqs. Therefore disabling interrupts isn't strong enough.

Reported-by: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 kernel/sched.c |    6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

Index: linux-2.6/kernel/sched.c
===================================================================
--- linux-2.6.orig/kernel/sched.c
+++ linux-2.6/kernel/sched.c
@@ -4448,12 +4448,8 @@ need_resched_nonpreemptible:
 	if (sched_feat(HRTICK))
 		hrtick_clear(rq);
 
-	/*
-	 * Do the rq-clock update outside the rq lock:
-	 */
-	local_irq_disable();
+	spin_lock_irq(&rq->lock);
 	update_rq_clock(rq);
-	spin_lock(&rq->lock);
 	clear_tsk_need_resched(prev);
 
 	if (prev->state && !(preempt_count() & PREEMPT_ACTIVE)) {


