Return-Path: <linux-kernel-owner+w=401wt.eu-S932967AbXBLEsU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932967AbXBLEsU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Feb 2007 23:48:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932965AbXBLEsT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Feb 2007 23:48:19 -0500
Received: from pool-71-111-65-226.ptldor.dsl-w.verizon.net ([71.111.65.226]:12050
	"EHLO IBM-8EC8B5596CA.beaverton.ibm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932946AbXBLEsT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Feb 2007 23:48:19 -0500
Date: Sun, 11 Feb 2007 20:48:17 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: oleg@tv-sign.ru, a.p.zijlstra@chello.nl, mingo@elte.hu, hch@infradead.org,
       akpm@osdl.org, stern@rowland.harvard.edu
Subject: [RFC PATCH] QRCU fastpath optimization
Message-ID: <20070212044817.GA23254@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch optimizes the "quick" RCU update-side fastpath, so that in the
absence of readers, synchronize_qrcu() does four non-atomic comparisons
and three memory barriers, eliminating the need to acquire the global
lock in this case.  Lightly tested.  Algorithm has been validated for
the 3-reader-2-updater and 2-reader-3-updater cases -- 3-readers-3-updaters
case still to be done (I expect to get access to a large-memory machine
in the next few weeks -- need >>20GB).

Not for inclusion.  Patch is against Oleg's original patch, and likely
needs to be rediffed against Jen's patchstack.  I will do this rediffing
later, first want an easy-to-test and easy-to-inpect version.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---

 srcu.c |   42 +++++++++++++++++++++++++++++++++++++-----
 1 file changed, 37 insertions(+), 5 deletions(-)

diff -urpNa -X dontdiff linux-2.6.19-qrcu/kernel/srcu.c linux-2.6.19-qrcu-fp/kernel/srcu.c
--- linux-2.6.19-qrcu/kernel/srcu.c	2007-02-05 16:27:50.000000000 -0800
+++ linux-2.6.19-qrcu-fp/kernel/srcu.c	2007-02-11 18:10:35.000000000 -0800
@@ -287,23 +287,55 @@ void synchronize_qrcu(struct qrcu_struct
 {
 	int idx;
 
-	smp_mb();
+	smp_mb();  /* Force preceding change to happen before fastpath check. */
+
+	/*
+	 * Fastpath: If the two counters sum to "1" at a given point in
+	 * time, there are no readers.  However, it takes two separate
+	 * loads to sample both counters, which won't occur simultaneously.
+	 * So we might race with a counter switch, so that we might see
+	 * ctr[0]==0, then the counter might switch, then we might see
+	 * ctr[1]==1 (unbeknownst to us because there is a reader still
+	 * there).  So we do a read memory barrier and recheck.  If the
+	 * same race happens again, there must have been a second counter
+	 * switch.  This second counter switch could not have happened
+	 * until all preceding readers finished, so if the condition
+	 * is true both times, we may safely proceed.
+	 *
+	 * This relies critically on the atomic increment and atomic
+	 * decrement being seen as executing in order.
+	 */
+
+	if (atomic_read(&qp->ctr[0]) + atomic_read(&qp->ctr[1]) <= 1) {
+		smp_rmb();  /* Keep two checks independent. */
+		if (atomic_read(&qp->ctr[0]) + atomic_read(&qp->ctr[1]) <= 1)
+			goto out;
+	}
+
 	mutex_lock(&qp->mutex);
 
 	idx = qp->completed & 0x1;
 	if (atomic_read(qp->ctr + idx) == 1)
-		goto out;
+		goto out_unlock;
 
 	atomic_inc(qp->ctr + (idx ^ 0x1));
-	/* Reduce the likelihood that qrcu_read_lock() will loop */
+
+	/*
+	 * Prevent subsequent decrement from being seen before previous
+	 * increment -- such an inversion could cause the fastpath
+	 * above to falsely conclude that there were no readers.  Also,
+	 * reduce the likelihood that qrcu_read_lock() will loop.
+	 */
+
 	smp_mb__after_atomic_inc();
 	qp->completed++;
 
 	atomic_dec(qp->ctr + idx);
 	__wait_event(qp->wq, !atomic_read(qp->ctr + idx));
-out:
+out_unlock:
 	mutex_unlock(&qp->mutex);
-	smp_mb();
+out:
+	smp_mb(); /* force subsequent free after qrcu_read_unlock(). */
 }
 
 EXPORT_SYMBOL_GPL(init_qrcu_struct);
