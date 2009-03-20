Return-Path: <linux-kernel-owner+w=401wt.eu-S1762090AbZCTKOX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762090AbZCTKOX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Mar 2009 06:14:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762012AbZCTKNq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Mar 2009 06:13:46 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:32902 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757926AbZCTKNp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Mar 2009 06:13:45 -0400
Subject: lockdep: fix deadlock in lockdep_trace_alloc
From: Peter Zijlstra <peterz@infradead.org>
To: Heiko Carstens <heiko.carstens@de.ibm.com>, Ingo Molnar <mingo@elte.hu>
Cc: Nick Piggin <npiggin@suse.de>, "lkml," <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Fri, 20 Mar 2009 11:13:20 +0100
Message-Id: <1237544000.24626.52.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Heiko reported that we grab the graph lock with irqs enabled.

Fix this by providng the same wrapper as all other lockdep entry
functions have.

Reported-by: Heiko Carstens <heiko.carstens@de.ibm.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
diff --git a/kernel/lockdep.c b/kernel/lockdep.c
index 3e1cc47..a39cb6d 100644
--- a/kernel/lockdep.c
+++ b/kernel/lockdep.c
@@ -2258,7 +2258,7 @@ void trace_softirqs_off(unsigned long ip)
 		debug_atomic_inc(&redundant_softirqs_off);
 }
 
-void lockdep_trace_alloc(gfp_t gfp_mask)
+static void __lockdep_trace_alloc(gfp_t gfp_mask)
 {
 	struct task_struct *curr = current;
 
@@ -2283,6 +2283,20 @@ void lockdep_trace_alloc(gfp_t gfp_mask)
 	mark_held_locks(curr, RECLAIM_FS);
 }
 
+void lockdep_trace_alloc(gfp_t gfp_mask)
+{
+	unsigned long flags;
+
+	if (unlikely(current->lockdep_recursion))
+		return;
+
+	raw_local_irq_save(flags);
+	current->lockdep_recursion = 1;
+	__lockdep_trace_alloc(gfp_mask);
+	current->lockdep_recursion = 0;
+	raw_local_irq_restore(flags);
+}
+
 static int mark_irqflags(struct task_struct *curr, struct held_lock *hlock)
 {
 	/*

