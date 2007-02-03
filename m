Return-Path: <linux-kernel-owner+w=401wt.eu-S1946298AbXBCCqt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946298AbXBCCqt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Feb 2007 21:46:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946274AbXBCCnk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Feb 2007 21:43:40 -0500
Received: from 216-99-217-87.dsl.aracnet.com ([216.99.217.87]:53551 "EHLO
	sous-sol.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946287AbXBCCnb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Feb 2007 21:43:31 -0500
Message-Id: <20070203024730.601627000@sous-sol.org>
References: <20070203023504.435051000@sous-sol.org>
User-Agent: quilt/0.45-1
Date: Fri, 02 Feb 2007 18:36:02 -0800
From: Chris Wright <chrisw@sous-sol.org>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Kirill Korotaev <dev@openvz.org>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@osdl.org>, Linus Torvalds <torvalds@osdl.org>
Subject: [patch 58/59] move_task_off_dead_cpu() should be called with disabled ints
Content-Disposition: inline; filename=move_task_off_dead_cpu-should-be-called-with-disabled-ints.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.
------------------

From: Kirill Korotaev <dev@openvz.org>

move_task_off_dead_cpu() requires interrupts to be disabled, while
migrate_dead() calls it with enabled interrupts.  Added appropriate
comments to functions and added BUG_ON(!irqs_disabled()) into
double_rq_lock() and double_lock_balance() which are the origin sources of
such bugs.

Signed-off-by: Kirill Korotaev <dev@openvz.org>
Acked-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@osdl.org>
Signed-off-by: Linus Torvalds <torvalds@osdl.org>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
---
 kernel/sched.c |   17 ++++++++++++++---
 1 file changed, 14 insertions(+), 3 deletions(-)

--- linux-2.6.19.2.orig/kernel/sched.c
+++ linux-2.6.19.2/kernel/sched.c
@@ -1941,6 +1941,7 @@ static void double_rq_lock(struct rq *rq
 	__acquires(rq1->lock)
 	__acquires(rq2->lock)
 {
+	BUG_ON(!irqs_disabled());
 	if (rq1 == rq2) {
 		spin_lock(&rq1->lock);
 		__acquire(rq2->lock);	/* Fake it out ;) */
@@ -1980,6 +1981,11 @@ static void double_lock_balance(struct r
 	__acquires(busiest->lock)
 	__acquires(this_rq->lock)
 {
+	if (unlikely(!irqs_disabled())) {
+		/* printk() doesn't work good under rq->lock */
+		spin_unlock(&this_rq->lock);
+		BUG_ON(1);
+	}
 	if (unlikely(!spin_trylock(&busiest->lock))) {
 		if (busiest < this_rq) {
 			spin_unlock(&this_rq->lock);
@@ -5050,7 +5056,10 @@ wait_to_die:
 }
 
 #ifdef CONFIG_HOTPLUG_CPU
-/* Figure out where task on dead CPU should go, use force if neccessary. */
+/*
+ * Figure out where task on dead CPU should go, use force if neccessary.
+ * NOTE: interrupts should be disabled by the caller
+ */
 static void move_task_off_dead_cpu(int dead_cpu, struct task_struct *p)
 {
 	unsigned long flags;
@@ -5170,6 +5179,7 @@ void idle_task_exit(void)
 	mmdrop(mm);
 }
 
+/* called under rq->lock with disabled interrupts */
 static void migrate_dead(unsigned int dead_cpu, struct task_struct *p)
 {
 	struct rq *rq = cpu_rq(dead_cpu);
@@ -5186,10 +5196,11 @@ static void migrate_dead(unsigned int de
 	 * Drop lock around migration; if someone else moves it,
 	 * that's OK.  No task can be added to this CPU, so iteration is
 	 * fine.
+	 * NOTE: interrupts should be left disabled  --dev@
 	 */
-	spin_unlock_irq(&rq->lock);
+	spin_unlock(&rq->lock);
 	move_task_off_dead_cpu(dead_cpu, p);
-	spin_lock_irq(&rq->lock);
+	spin_lock(&rq->lock);
 
 	put_task_struct(p);
 }

--
