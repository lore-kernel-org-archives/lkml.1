Return-Path: <linux-kernel-owner+w=401wt.eu-S1762995AbZCTKbl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762995AbZCTKbl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Mar 2009 06:31:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762700AbZCTK2i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Mar 2009 06:28:38 -0400
Received: from hera.kernel.org ([140.211.167.34]:35369 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762694AbZCTK2h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Mar 2009 06:28:37 -0400
Date: Fri, 20 Mar 2009 10:26:53 GMT
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
Subject: [tip:core/locking] lockdep: fix deadlock in lockdep_trace_alloc
Message-ID: <tip-b0992675bc7a5eca3c6a5eeea5ed680cec09c8e7@git.kernel.org>
Git-Commit-ID: b0992675bc7a5eca3c6a5eeea5ed680cec09c8e7
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Fri, 20 Mar 2009 10:26:55 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  b0992675bc7a5eca3c6a5eeea5ed680cec09c8e7
Gitweb:     http://git.kernel.org/tip/b0992675bc7a5eca3c6a5eeea5ed680cec09c8e7
Author:     Peter Zijlstra <peterz@infradead.org>
AuthorDate: Fri, 20 Mar 2009 11:13:20 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 20 Mar 2009 11:23:15 +0100

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
 kernel/lockdep.c |   16 +++++++++++++++-
 1 files changed, 15 insertions(+), 1 deletions(-)

diff --git a/kernel/lockdep.c b/kernel/lockdep.c
index 77ac37f..c750038 100644
--- a/kernel/lockdep.c
+++ b/kernel/lockdep.c
@@ -2257,7 +2257,7 @@ void trace_softirqs_off(unsigned long ip)
 		debug_atomic_inc(&redundant_softirqs_off);
 }
 
-void lockdep_trace_alloc(gfp_t gfp_mask)
+static void __lockdep_trace_alloc(gfp_t gfp_mask)
 {
 	struct task_struct *curr = current;
 
@@ -2282,6 +2282,20 @@ void lockdep_trace_alloc(gfp_t gfp_mask)
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
