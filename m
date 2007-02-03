Return-Path: <linux-kernel-owner+w=401wt.eu-S1946274AbXBCCqt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946274AbXBCCqt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Feb 2007 21:46:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946276AbXBCCnh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Feb 2007 21:43:37 -0500
Received: from 216-99-217-87.dsl.aracnet.com ([216.99.217.87]:53549 "EHLO
	sous-sol.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946274AbXBCCnb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Feb 2007 21:43:31 -0500
Message-Id: <20070203024741.262460000@sous-sol.org>
References: <20070203023504.435051000@sous-sol.org>
User-Agent: quilt/0.45-1
Date: Fri, 02 Feb 2007 18:36:03 -0800
From: Chris Wright <chrisw@sous-sol.org>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@osdl.org>,
       Linus Torvalds <torvalds@osdl.org>
Subject: [patch 59/59] sched: fix cond_resched_softirq() offset
Content-Disposition: inline; filename=sched-fix-cond_resched_softirq-offset.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.
------------------

From: Ingo Molnar <mingo@elte.hu>

Remove the __resched_legal() check: it is conceptually broken.  The biggest
problem it had is that it can mask buggy cond_resched() calls.  A
cond_resched() call is only legal if we are not in an atomic context, with
two narrow exceptions:

 - if the system is booting
 - a reacquire_kernel_lock() down() done while PREEMPT_ACTIVE is set

But __resched_legal() hid this and just silently returned whenever
these primitives were called from invalid contexts. (Same goes for
cond_resched_locked() and cond_resched_softirq()).

Furthermore, the __legal_resched(0) call was buggy in that it caused
unnecessarily long softirq latencies via cond_resched_softirq().  (which is
only called from softirq-off sections, hence the code did nothing.)

The fix is to resurrect the efficiency of the might_sleep checks and to
only allow the narrow exceptions.

Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@osdl.org>
Signed-off-by: Linus Torvalds <torvalds@osdl.org>
[chrisw: backport to 2.6.19.2]
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
---
 kernel/sched.c |   16 ++++------------
 1 file changed, 4 insertions(+), 12 deletions(-)

--- linux-2.6.19.2.orig/kernel/sched.c
+++ linux-2.6.19.2/kernel/sched.c
@@ -4524,15 +4524,6 @@ asmlinkage long sys_sched_yield(void)
 	return 0;
 }
 
-static inline int __resched_legal(int expected_preempt_count)
-{
-	if (unlikely(preempt_count() != expected_preempt_count))
-		return 0;
-	if (unlikely(system_state != SYSTEM_RUNNING))
-		return 0;
-	return 1;
-}
-
 static void __cond_resched(void)
 {
 #ifdef CONFIG_DEBUG_SPINLOCK_SLEEP
@@ -4552,7 +4543,8 @@ static void __cond_resched(void)
 
 int __sched cond_resched(void)
 {
-	if (need_resched() && __resched_legal(0)) {
+	if (need_resched() && !(preempt_count() & PREEMPT_ACTIVE) &&
+					system_state == SYSTEM_RUNNING) {
 		__cond_resched();
 		return 1;
 	}
@@ -4578,7 +4570,7 @@ int cond_resched_lock(spinlock_t *lock)
 		ret = 1;
 		spin_lock(lock);
 	}
-	if (need_resched() && __resched_legal(1)) {
+	if (need_resched() && system_state == SYSTEM_RUNNING) {
 		spin_release(&lock->dep_map, 1, _THIS_IP_);
 		_raw_spin_unlock(lock);
 		preempt_enable_no_resched();
@@ -4594,7 +4586,7 @@ int __sched cond_resched_softirq(void)
 {
 	BUG_ON(!in_softirq());
 
-	if (need_resched() && __resched_legal(0)) {
+	if (need_resched() && system_state == SYSTEM_RUNNING) {
 		raw_local_irq_disable();
 		_local_bh_enable();
 		raw_local_irq_enable();

--
