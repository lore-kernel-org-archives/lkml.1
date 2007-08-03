Return-Path: <linux-kernel-owner+w=401wt.eu-S1762151AbXHCSpA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762151AbXHCSpA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Aug 2007 14:45:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754320AbXHCSow
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Aug 2007 14:44:52 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:49124 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753737AbXHCSov (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Aug 2007 14:44:51 -0400
Date: Fri, 3 Aug 2007 11:44:49 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-rt-users@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, dipankar@in.ibm.com,
       ego@in.ibm.com, vatsa@in.ibm.com, josht@linux.vnet.ibm.com
Subject: [PATCH RFC -rt] Allow rcutorture to handle synchronize_sched()
Message-ID: <20070803184449.GA2196@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The rcutorture module uses a random-number generator that periodically
calls get_random_bytes() to add entropy.  This random-number generator
is invoked from within the RCU read-side critical section, which, in the
case of the synchronize_sched() variant of RCU, has preeemption disabled.
Unfortunately, get_random_bytes() ends up acquiring normal spinlocks,
which can block in -rt, resulting in very large numbers of "scheduling
while atomic" messages.

This patch takes a very crude approach, simply substituting the time
of day for get_random_bytes().

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---

 rcutorture.c |    7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff -urpNa -X dontdiff linux-2.6.22.1-rt4/kernel/rcutorture.c linux-2.6.22.1-rt4-rcutorturesched/kernel/rcutorture.c
--- linux-2.6.22.1-rt4/kernel/rcutorture.c	2007-07-21 16:58:22.000000000 -0700
+++ linux-2.6.22.1-rt4-rcutorturesched/kernel/rcutorture.c	2007-08-02 16:38:09.000000000 -0700
@@ -165,16 +165,13 @@ struct rcu_random_state {
 
 /*
  * Crude but fast random-number generator.  Uses a linear congruential
- * generator, with occasional help from get_random_bytes().
+ * generator, with occasional help from the time-of-day clock.
  */
 static unsigned long
 rcu_random(struct rcu_random_state *rrsp)
 {
-	long refresh;
-
 	if (--rrsp->rrs_count < 0) {
-		get_random_bytes(&refresh, sizeof(refresh));
-		rrsp->rrs_state += refresh;
+		rrsp->rrs_state += xtime.tv_nsec;
 		rrsp->rrs_count = RCU_RANDOM_REFRESH;
 	}
 	rrsp->rrs_state = rrsp->rrs_state * RCU_RANDOM_MULT + RCU_RANDOM_ADD;
