Return-Path: <linux-kernel-owner+w=401wt.eu-S1757773AbZGGX6Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757773AbZGGX6Y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jul 2009 19:58:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755571AbZGGX6Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Jul 2009 19:58:16 -0400
Received: from ru.mvista.com ([213.79.90.228]:44635 "EHLO
	buildserver.ru.mvista.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755195AbZGGX6Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jul 2009 19:58:16 -0400
Date: Wed, 8 Jul 2009 03:58:12 +0400
From: Anton Vorontsov <avorontsov@ru.mvista.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Oleg Nesterov <oleg@redhat.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org
Subject: [PATCH/RFC] sched: Remove SYSTEM_RUNNING checks from
 cond_resched*()
Message-ID: <20090707235812.GA12824@oksana.dev.rtsoft.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Using early netconsole and gianfar driver this error pops up:

  netconsole: timeout waiting for carrier

It appears that net/core/netpoll.c:netpoll_setup() is using
cond_resched() in a loop waiting for a carrier.

The thing is that cond_resched() is a no-op when system_state !=
SYSTEM_RUNNING, and so drivers/net/phy/phy.c's state_queue is never
scheduled, therefore link detection doesn't work.

This patch fixes the issue by removing SYSTEM_RUNNING checks, which
might be dangerous to do, but looking at 'git blame' I can see that
the first SYSTEM_RUNNING check was introduced in this commit:

  commit 8ba7b0a14b2ec19583bedbcdbea7f1c5008fc922
  Author: Linus Torvalds <torvalds@g5.osdl.org>
  Date:   Mon Mar 6 17:38:49 2006 -0800

   Add early-boot-safety check to cond_resched()

   Just to be safe, we should not trigger a conditional reschedule during
   the early boot sequence.  We've historically done some questionable
   early on, and the safety warnings in __might_sleep() are generally
   turned off during that period, so there might be problems lurking.

   This affects CONFIG_PREEMPT_VOLUNTARY, which takes over might_sleep() to
   cause a voluntary conditional reschedule.

The commit doesn't mention that it fixes some particular problem,
though it surely breaks netconsole for drivers that are using phylib.

I tested the patch with CONFIG_PREEMPT_VOLUNTARY (on PowerPC), and it
didn't cause any issues.

Surely, the other way to fix the netconsole is to call schedule() or
msleep() directly, but I'm curious if removing the checks makes sense
nowadays.

Signed-off-by: Anton Vorontsov <avorontsov@ru.mvista.com>
---
 kernel/sched.c |    7 +++----
 1 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index 7c9098d..3899baa 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -6560,8 +6560,7 @@ static void __cond_resched(void)
 
 int __sched _cond_resched(void)
 {
-	if (need_resched() && !(preempt_count() & PREEMPT_ACTIVE) &&
-					system_state == SYSTEM_RUNNING) {
+	if (need_resched() && !(preempt_count() & PREEMPT_ACTIVE)) {
 		__cond_resched();
 		return 1;
 	}
@@ -6579,7 +6578,7 @@ EXPORT_SYMBOL(_cond_resched);
  */
 int cond_resched_lock(spinlock_t *lock)
 {
-	int resched = need_resched() && system_state == SYSTEM_RUNNING;
+	int resched = need_resched();
 	int ret = 0;
 
 	if (spin_needbreak(lock) || resched) {
@@ -6599,7 +6598,7 @@ int __sched cond_resched_softirq(void)
 {
 	BUG_ON(!in_softirq());
 
-	if (need_resched() && system_state == SYSTEM_RUNNING) {
+	if (need_resched()) {
 		local_bh_enable();
 		__cond_resched();
 		local_bh_disable();
-- 
1.6.3.3
