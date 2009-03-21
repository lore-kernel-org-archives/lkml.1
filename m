Return-Path: <linux-kernel-owner+w=401wt.eu-S1757055AbZCUQTl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757055AbZCUQTl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Mar 2009 12:19:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755533AbZCUQTS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Mar 2009 12:19:18 -0400
Received: from hera.kernel.org ([140.211.167.34]:52910 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755364AbZCUQTR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Mar 2009 12:19:17 -0400
Date: Sat, 21 Mar 2009 16:18:38 GMT
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       a.p.zijlstra@chello.nl, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       a.p.zijlstra@chello.nl, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1237638788.4667.263.camel@laptop>
References: <1237638788.4667.263.camel@laptop>
Subject: [tip:core/locking] lockdep: fix deadlock in lockdep_trace_alloc, take 2
Message-ID: <tip-da40a037c5ed51693e739ff9b21e013414244644@git.kernel.org>
Git-Commit-ID: da40a037c5ed51693e739ff9b21e013414244644
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Sat, 21 Mar 2009 16:18:40 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  da40a037c5ed51693e739ff9b21e013414244644
Gitweb:     http://git.kernel.org/tip/da40a037c5ed51693e739ff9b21e013414244644
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Sat, 21 Mar 2009 13:33:08 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sat, 21 Mar 2009 17:15:42 +0100

lockdep: fix deadlock in lockdep_trace_alloc, take 2

Since we now disabled IRQs, checking for IRQs disabled is a bit
pointless, check for it in the saved flags.

Also, add the missing check_flags() check for completeness.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: npiggin@suse.de
Cc: heiko.carstens@de.ibm.com
LKML-Reference: <1237638788.4667.263.camel@laptop>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 kernel/lockdep.c |    9 ++++++---
 1 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/kernel/lockdep.c b/kernel/lockdep.c
index c750038..a288ae1 100644
--- a/kernel/lockdep.c
+++ b/kernel/lockdep.c
@@ -2257,7 +2257,7 @@ void trace_softirqs_off(unsigned long ip)
 		debug_atomic_inc(&redundant_softirqs_off);
 }
 
-static void __lockdep_trace_alloc(gfp_t gfp_mask)
+static void __lockdep_trace_alloc(gfp_t gfp_mask, unsigned long flags)
 {
 	struct task_struct *curr = current;
 
@@ -2276,12 +2276,14 @@ static void __lockdep_trace_alloc(gfp_t gfp_mask)
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
@@ -2290,8 +2292,9 @@ void lockdep_trace_alloc(gfp_t gfp_mask)
 		return;
 
 	raw_local_irq_save(flags);
+	check_flags(flags);
 	current->lockdep_recursion = 1;
-	__lockdep_trace_alloc(gfp_mask);
+	__lockdep_trace_alloc(gfp_mask, flags);
 	current->lockdep_recursion = 0;
 	raw_local_irq_restore(flags);
 }
