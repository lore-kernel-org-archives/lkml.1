Return-Path: <linux-kernel-owner+w=401wt.eu-S1754859AbZGHUp4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754859AbZGHUp4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jul 2009 16:45:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754109AbZGHUpr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Jul 2009 16:45:47 -0400
Received: from ru.mvista.com ([213.79.90.228]:47867 "EHLO
	buildserver.ru.mvista.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753884AbZGHUpr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jul 2009 16:45:47 -0400
Date: Thu, 9 Jul 2009 00:45:45 +0400
From: Anton Vorontsov <avorontsov@ru.mvista.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Oleg Nesterov <oleg@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: [PATCH] sched: Make cond_resched*() available earlier
Message-ID: <20090708204545.GA3216@oksana.dev.rtsoft.ru>
Reply-To: avorontsov@ru.mvista.com
References: <20090707235812.GA12824@oksana.dev.rtsoft.ru>
 <20090708005000.GA12380@redhat.com>
 <1247034263.9777.24.camel@twins>
 <20090708120302.GA6341@oksana.dev.rtsoft.ru>
 <1247055145.9777.52.camel@twins>
 <20090708125527.GA11963@oksana.dev.rtsoft.ru>
 <1247057926.9777.54.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1247057926.9777.54.camel@twins>
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

The system_state check exists to avoid very early calls to the
scheduler. Though, using cond_resched() should be safe after scheduler
is initialized, so instead of checking the system_state, we can test
that the scheduler is running, therefore making cond_resched() and
friends available much earlier (but not too much).

Signed-off-by: Anton Vorontsov <avorontsov@ru.mvista.com>
---

On Wed, Jul 08, 2009 at 02:58:46PM +0200, Peter Zijlstra wrote:
[...]
> > > > Hm. Speaking of cond_resched*() only, then it should be pretty
> > > > safe to convert the SYSTEM_RUNNING checks to scheduler_running,
> > > > no? scheduler_running is set after sched_init().
> > > 
> > > Hmm, that might work, I'd have to audit sched_init_smp() as it seems to
> > > do way too much...
> > 
> > sched_init_smp() is called from the kernel_thread(), so
> > if the scheduler is not functional prior to kernel_thread(),
> > you're in trouble anyway, no? The point is that a lot of
> > code is calling schedule() prior to sched_init_smp()
> > (e.g. msleep(), mutexes), and there are no issues. So
> > should be no issues with cond_resched()?
> 
> Yeah, it should be good, I just got paranoid looking at
> sched_init_smp().

OK, thanks everyone for the reviews.

Here is an updated patch. As usual, tested on UP PowerPC, with and
without SMP, PREEMPT and PREEMPT_VOLUNTARY.

 kernel/sched.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index 7c9098d..555360b 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -6561,7 +6561,7 @@ static void __cond_resched(void)
 int __sched _cond_resched(void)
 {
 	if (need_resched() && !(preempt_count() & PREEMPT_ACTIVE) &&
-					system_state == SYSTEM_RUNNING) {
+					scheduler_running) {
 		__cond_resched();
 		return 1;
 	}
@@ -6579,7 +6579,7 @@ EXPORT_SYMBOL(_cond_resched);
  */
 int cond_resched_lock(spinlock_t *lock)
 {
-	int resched = need_resched() && system_state == SYSTEM_RUNNING;
+	int resched = need_resched() && scheduler_running;
 	int ret = 0;
 
 	if (spin_needbreak(lock) || resched) {
@@ -6599,7 +6599,7 @@ int __sched cond_resched_softirq(void)
 {
 	BUG_ON(!in_softirq());
 
-	if (need_resched() && system_state == SYSTEM_RUNNING) {
+	if (need_resched() && scheduler_running) {
 		local_bh_enable();
 		__cond_resched();
 		local_bh_disable();
-- 
1.6.3.3

