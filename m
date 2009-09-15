Return-Path: <linux-kernel-owner+w=401wt.eu-S1755416AbZIOQcj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755416AbZIOQcj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Sep 2009 12:32:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754233AbZIOQce
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Sep 2009 12:32:34 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:62010 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753842AbZIOQcd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Sep 2009 12:32:33 -0400
Subject: [PATCH] [GIT PULL] tracing: optimize global_trace_clock cachelines
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain
Organization: Kihon Technologies Inc.
Date: Tue, 15 Sep 2009 12:32:34 -0400
Message-Id: <1253032354.20020.119.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Ingo,

Please pull the latest tip/tracing/core3 tree, which can be found at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git
tip/tracing/core3


Steven Rostedt (1):
      tracing: optimize global_trace_clock cachelines

----
 kernel/trace/trace_clock.c |   24 ++++++++++++++----------
 1 files changed, 14 insertions(+), 10 deletions(-)
---------------------------
commit 6ca6cca31ddc7cc8b1dc38b12d7593d2667defe8
Author: Steven Rostedt <srostedt@redhat.com>
Date:   Tue Sep 15 12:24:22 2009 -0400

    tracing: optimize global_trace_clock cachelines
    
    The prev_trace_clock_time is only read or written to when the
    trace_clock_lock is taken. For better perfomance, they
    should share the same cache line.
    
    Reported-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
    Signed-off-by: Steven Rostedt <rostedt@goodmis.org>

diff --git a/kernel/trace/trace_clock.c b/kernel/trace/trace_clock.c
index b588fd8..20c5f92 100644
--- a/kernel/trace/trace_clock.c
+++ b/kernel/trace/trace_clock.c
@@ -66,10 +66,14 @@ u64 notrace trace_clock(void)
  * Used by plugins that need globally coherent timestamps.
  */
 
-static u64 prev_trace_clock_time;
-
-static raw_spinlock_t trace_clock_lock ____cacheline_aligned_in_smp =
-	(raw_spinlock_t)__RAW_SPIN_LOCK_UNLOCKED;
+/* keep prev_time and lock in the same cacheline. */
+static struct {
+	u64 prev_time;
+	raw_spinlock_t lock;
+} trace_clock_struct ____cacheline_aligned_in_smp =
+	{
+		.lock = (raw_spinlock_t)__RAW_SPIN_LOCK_UNLOCKED,
+	};
 
 u64 notrace trace_clock_global(void)
 {
@@ -88,19 +92,19 @@ u64 notrace trace_clock_global(void)
 	if (unlikely(in_nmi()))
 		goto out;
 
-	__raw_spin_lock(&trace_clock_lock);
+	__raw_spin_lock(&trace_clock_struct.lock);
 
 	/*
 	 * TODO: if this happens often then maybe we should reset
-	 * my_scd->clock to prev_trace_clock_time+1, to make sure
+	 * my_scd->clock to prev_time+1, to make sure
 	 * we start ticking with the local clock from now on?
 	 */
-	if ((s64)(now - prev_trace_clock_time) < 0)
-		now = prev_trace_clock_time + 1;
+	if ((s64)(now - trace_clock_struct.prev_time) < 0)
+		now = trace_clock_struct.prev_time + 1;
 
-	prev_trace_clock_time = now;
+	trace_clock_struct.prev_time = now;
 
-	__raw_spin_unlock(&trace_clock_lock);
+	__raw_spin_unlock(&trace_clock_struct.lock);
 
  out:
 	raw_local_irq_restore(flags);


