Return-Path: <linux-kernel-owner+w=401wt.eu-S1756226AbZKWQak@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756226AbZKWQak (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Nov 2009 11:30:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756441AbZKWQaB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Nov 2009 11:30:01 -0500
Received: from hera.kernel.org ([140.211.167.34]:52723 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756122AbZKWQ2W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Nov 2009 11:28:22 -0500
From: Tejun Heo <tj@kernel.org>
To: peterz@infradead.org, torvalds@linux-foundation.org, awalls@radix.net,
       linux-kernel@vger.kernel.org, jeff@garzik.org, mingo@elte.hu,
       akpm@linux-foundation.org, jens.axboe@oracle.com, rusty@rustcorp.com.au,
       cl@linux-foundation.org, dhowells@redhat.com, arjan@linux.intel.com,
       avi@redhat.com, johannes@sipsolutions.net
Cc: Tejun Heo <tj@kernel.org>
Subject: [PATCH 01/14] sched, kvm: fix race condition involving sched_in_preempt_notifers
Date: Tue, 24 Nov 2009 01:26:51 +0900
Message-Id: <1258993624-28735-2-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.6.5.3
In-Reply-To: <1258993624-28735-1-git-send-email-tj@kernel.org>
References: <1258993624-28735-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In finish_task_switch(), fire_sched_in_preempt_notifiers() is called
after finish_lock_switch().  However, depending on architecture,
preemption can be enabled after finish_lock_switch() which breaks the
semantics of preempt notifiers.  Move it before finish_arch_switch().
This also makes in notifiers symmetric to out notifiers in terms of
locking - now both are called under rq lock.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Avi Kivity <avi@redhat.com>
---
 kernel/sched.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index 3c11ae0..de8a765 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -2751,9 +2751,9 @@ static void finish_task_switch(struct rq *rq, struct task_struct *prev)
 	prev_state = prev->state;
 	finish_arch_switch(prev);
 	perf_event_task_sched_in(current, cpu_of(rq));
+	fire_sched_in_preempt_notifiers(current);
 	finish_lock_switch(rq, prev);
 
-	fire_sched_in_preempt_notifiers(current);
 	if (mm)
 		mmdrop(mm);
 	if (unlikely(prev_state == TASK_DEAD)) {
-- 
1.6.5.3

