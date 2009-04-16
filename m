Return-Path: <linux-kernel-owner+w=401wt.eu-S1758443AbZDPQS7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758443AbZDPQS7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Apr 2009 12:18:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758333AbZDPQSP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Apr 2009 12:18:15 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:44913 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758312AbZDPQSN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Apr 2009 12:18:13 -0400
Message-Id: <20090416161746.831882528@goodmis.org>
References: <20090416161543.199331330@goodmis.org>
User-Agent: quilt/0.46-1
Date: Thu, 16 Apr 2009 12:15:45 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 2/2] tracing/events/lockdep: move tracepoints within recursive protection
Content-Disposition: inline; filename=0002-tracing-events-lockdep-move-tracepoints-within-recu.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

With the current location of the tracepoints in lockdep, the system
can hard lockup in minutes when the tracepoints are enabled.

Moving the tracepoints outside inside the lockdep protection solves
the issue.

Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/lockdep.c |   14 +++++++-------
 1 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/kernel/lockdep.c b/kernel/lockdep.c
index 47b201e..53b887a 100644
--- a/kernel/lockdep.c
+++ b/kernel/lockdep.c
@@ -2941,11 +2941,11 @@ void lock_acquire(struct lockdep_map *lock, unsigned int subclass,
 {
 	unsigned long flags;
 
-	trace_lock_acquire(lock, subclass, trylock, read, check, nest_lock, ip);
-
 	if (unlikely(current->lockdep_recursion))
 		return;
 
+	trace_lock_acquire(lock, subclass, trylock, read, check, nest_lock, ip);
+
 	raw_local_irq_save(flags);
 	check_flags(flags);
 
@@ -2962,11 +2962,11 @@ void lock_release(struct lockdep_map *lock, int nested,
 {
 	unsigned long flags;
 
-	trace_lock_release(lock, nested, ip);
-
 	if (unlikely(current->lockdep_recursion))
 		return;
 
+	trace_lock_release(lock, nested, ip);
+
 	raw_local_irq_save(flags);
 	check_flags(flags);
 	current->lockdep_recursion = 1;
@@ -3118,14 +3118,14 @@ void lock_contended(struct lockdep_map *lock, unsigned long ip)
 {
 	unsigned long flags;
 
+	if (unlikely(current->lockdep_recursion))
+		return;
+
 	trace_lock_contended(lock, ip);
 
 	if (unlikely(!lock_stat))
 		return;
 
-	if (unlikely(current->lockdep_recursion))
-		return;
-
 	raw_local_irq_save(flags);
 	check_flags(flags);
 	current->lockdep_recursion = 1;
-- 
1.6.2.1

-- 
