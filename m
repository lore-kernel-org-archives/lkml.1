Return-Path: <linux-kernel-owner+w=401wt.eu-S1758443AbZC3VZy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758443AbZC3VZy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Mar 2009 17:25:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755691AbZC3VZm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Mar 2009 17:25:42 -0400
Received: from hera.kernel.org ([140.211.167.34]:59928 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750873AbZC3VZl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Mar 2009 17:25:41 -0400
Date: Mon, 30 Mar 2009 21:24:51 GMT
From: Peter Zijlstra <peterz@infradead.org>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       a.p.zijlstra@chello.nl, peterz@infradead.org, npiggin@suse.de,
       heiko.carstens@de.ibm.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: npiggin@suse.de, mingo@redhat.com, hpa@zytor.com,
       linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
       peterz@infradead.org, heiko.carstens@de.ibm.com, tglx@linutronix.de,
       mingo@elte.hu
In-Reply-To: <1237544000.24626.52.camel@twins>
References: <1237544000.24626.52.camel@twins>
Subject: [tip:core/locking-v2] lockdep: fix deadlock in lockdep_trace_alloc
Message-ID: <tip-2f8501815256af8498904e68bd0984b1afffd6f8@git.kernel.org>
Git-Commit-ID: 2f8501815256af8498904e68bd0984b1afffd6f8
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Mon, 30 Mar 2009 21:24:53 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  2f8501815256af8498904e68bd0984b1afffd6f8
Gitweb:     http://git.kernel.org/tip/2f8501815256af8498904e68bd0984b1afffd6f8
Author:     Peter Zijlstra <peterz@infradead.org>
AuthorDate: Fri, 20 Mar 2009 11:13:20 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 30 Mar 2009 23:19:24 +0200

lockdep: fix deadlock in lockdep_trace_alloc

Heiko reported that we grab the graph lock with irqs enabled.

Fix this by providng the same wrapper as all other lockdep entry
functions have.

Reported-by: Heiko Carstens <heiko.carstens@de.ibm.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Nick Piggin <npiggin@suse.de>
LKML-Reference: <1237544000.24626.52.camel@twins>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 kernel/lockdep.c |   21 +++++++++++++++++++--
 1 files changed, 19 insertions(+), 2 deletions(-)

diff --git a/kernel/lockdep.c b/kernel/lockdep.c
index 022d2ed..3673a3f 100644
--- a/kernel/lockdep.c
+++ b/kernel/lockdep.c
@@ -2260,7 +2260,7 @@ void trace_softirqs_off(unsigned long ip)
 		debug_atomic_inc(&redundant_softirqs_off);
 }
 
-void lockdep_trace_alloc(gfp_t gfp_mask)
+static void __lockdep_trace_alloc(gfp_t gfp_mask, unsigned long flags)
 {
 	struct task_struct *curr = current;
 
@@ -2279,12 +2279,29 @@ void lockdep_trace_alloc(gfp_t gfp_mask)
 	if (!(gfp_mask & __GFP_FS))
 		return;
 
-	if (DEBUG_LOCKS_WARN_ON(irqs_disabled()))
+	if (DEBUG_LOCKS_WARN_ON(irqs_disabled_flags(flags)))
 		return;
 
 	mark_held_locks(curr, RECLAIM_FS);
 }
 
+static void check_flags(unsigned long flags);
+
+void lockdep_trace_alloc(gfp_t gfp_mask)
+{
+	unsigned long flags;
+
+	if (unlikely(current->lockdep_recursion))
+		return;
+
+	raw_local_irq_save(flags);
+	check_flags(flags);
+	current->lockdep_recursion = 1;
+	__lockdep_trace_alloc(gfp_mask, flags);
+	current->lockdep_recursion = 0;
+	raw_local_irq_restore(flags);
+}
+
 static int mark_irqflags(struct task_struct *curr, struct held_lock *hlock)
 {
 	/*
