Return-Path: <linux-kernel-owner+w=401wt.eu-S1754572AbZCUMdh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754572AbZCUMdh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Mar 2009 08:33:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754192AbZCUMd2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Mar 2009 08:33:28 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:48271 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753103AbZCUMd1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Mar 2009 08:33:27 -0400
Subject: [PATCH] lockdep:  fix deadlock in lockdep_trace_alloc -v2
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: npiggin@suse.de, mingo@redhat.com, hpa@zytor.com,
       linux-kernel@vger.kernel.org, heiko.carstens@de.ibm.com,
       tglx@linutronix.de, mingo@elte.hu
Cc: linux-tip-commits@vger.kernel.org
In-Reply-To: <tip-b0992675bc7a5eca3c6a5eeea5ed680cec09c8e7@git.kernel.org>
References: <1237544000.24626.52.camel@twins>
	 <tip-b0992675bc7a5eca3c6a5eeea5ed680cec09c8e7@git.kernel.org>
Content-Type: text/plain
Date: Sat, 21 Mar 2009 13:33:08 +0100
Message-Id: <1237638788.4667.263.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.0 
Content-Transfer-Encoding: 7bit
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-03-20 at 10:26 +0000, Peter Zijlstra wrote:
> Commit-ID:  b0992675bc7a5eca3c6a5eeea5ed680cec09c8e7
> Gitweb:     http://git.kernel.org/tip/b0992675bc7a5eca3c6a5eeea5ed680cec09c8e7
> Author:     Peter Zijlstra <peterz@infradead.org>
> AuthorDate: Fri, 20 Mar 2009 11:13:20 +0100
> Committer:  Ingo Molnar <mingo@elte.hu>
> CommitDate: Fri, 20 Mar 2009 11:23:15 +0100
> 
> lockdep: fix deadlock in lockdep_trace_alloc
> 
> Heiko reported that we grab the graph lock with irqs enabled.
> 
> Fix this by providng the same wrapper as all other lockdep entry
> functions have.
> 
> Reported-by: Heiko Carstens <heiko.carstens@de.ibm.com>
> Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Cc: Nick Piggin <npiggin@suse.de>
> LKML-Reference: <1237544000.24626.52.camel@twins>
> Signed-off-by: Ingo Molnar <mingo@elte.hu>
> 

The below delta fixes it up proper -- saw that I forgot to update the
subject yesterday for the new iterations.

---
Since we now disabled IRQs, checking for IRQs disabled is a bit
pointless, check for it in the saved flags.

Also, add the missing check_flags() check for completeness.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
diff --git a/kernel/lockdep.c b/kernel/lockdep.c
index a39cb6d..b0f0118 100644
--- a/kernel/lockdep.c
+++ b/kernel/lockdep.c
@@ -2258,7 +2258,7 @@ void trace_softirqs_off(unsigned long ip)
 		debug_atomic_inc(&redundant_softirqs_off);
 }
 
-static void __lockdep_trace_alloc(gfp_t gfp_mask)
+static void __lockdep_trace_alloc(gfp_t gfp_mask, unsigned long flags)
 {
 	struct task_struct *curr = current;
 
@@ -2277,12 +2277,14 @@ static void __lockdep_trace_alloc(gfp_t gfp_mask)
 	if (!(gfp_mask & __GFP_FS))
 		return;
 
-	if (DEBUG_LOCKS_WARN_ON(irqs_disabled()))
+	if (DEBUG_LOCKS_WARN_ON(irqs_disabled_flags(flags)))
 		return;
 
 	mark_held_locks(curr, RECLAIM_FS);
 }
 
+static void check_flags(unsigned long flags);
+
 void lockdep_trace_alloc(gfp_t gfp_mask)
 {
 	unsigned long flags;
@@ -2291,8 +2293,9 @@ void lockdep_trace_alloc(gfp_t gfp_mask)
 		return;
 
 	raw_local_irq_save(flags);
+	check_flags(flags);
 	current->lockdep_recursion = 1;
-	__lockdep_trace_alloc(gfp_mask);
+	__lockdep_trace_alloc(gfp_mask, flags);
 	current->lockdep_recursion = 0;
 	raw_local_irq_restore(flags);
 }


