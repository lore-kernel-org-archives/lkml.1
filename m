Return-Path: <linux-kernel-owner+w=401wt.eu-S1755983AbZKMJeB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755983AbZKMJeB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Nov 2009 04:34:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755953AbZKMJd6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Nov 2009 04:33:58 -0500
Received: from hera.kernel.org ([140.211.167.34]:53403 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755974AbZKMJdy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Nov 2009 04:33:54 -0500
Message-ID: <4AFD2801.7020900@kernel.org>
Date: Fri, 13 Nov 2009 18:33:53 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; ko-KR; rv:1.9.1.4pre) Gecko/20090915 SUSE/3.0b4-3.6 Thunderbird/3.0b4
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: lkml <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@redhat.com>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 2.6.32-rc6] sched, kvm: fix race condition involving sched_in_preempt_notifers
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In finish_task_switch(), fire_sched_in_preempt_notifiers() is called
after finish_lock_switch().  However, depending on architecture,
preemption can be enabled after finish_lock_switch() which breaks the
semantics of preempt notifiers.  Move it before finish_arch_switch().
This also makes in notifiers symmetric to out notifiers in terms of
locking - now both are called under rq lock.

NOT_SIGNED_OFF_YET
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Avi Kivity <avi@redhat.com>
---
Avi, I think kvm should be fine with this but I haven't tested it.
Does this look okay to you?  If so, can you please route this through
kvm tree with my signoff?

Thanks.

 kernel/sched.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: work/kernel/sched.c
===================================================================
--- work.orig/kernel/sched.c
+++ work/kernel/sched.c
@@ -2751,9 +2751,9 @@ static void finish_task_switch(struct rq
 	prev_state = prev->state;
 	finish_arch_switch(prev);
 	perf_event_task_sched_in(current, cpu_of(rq));
+	fire_sched_in_preempt_notifiers(current);
 	finish_lock_switch(rq, prev);
 
-	fire_sched_in_preempt_notifiers(current);
 	if (mm)
 		mmdrop(mm);
 	if (unlikely(prev_state == TASK_DEAD)) {
