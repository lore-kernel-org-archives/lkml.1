Return-Path: <linux-kernel-owner+w=401wt.eu-S933026AbXBLGWI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933026AbXBLGWI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Feb 2007 01:22:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933029AbXBLGWI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Feb 2007 01:22:08 -0500
Received: from brick.kernel.dk ([62.242.22.158]:28182 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933026AbXBLGWF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Feb 2007 01:22:05 -0500
Date: Mon, 12 Feb 2007 07:22:09 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, oleg@tv-sign.ru, a.p.zijlstra@chello.nl,
       mingo@elte.hu, hch@infradead.org, akpm@osdl.org,
       stern@rowland.harvard.edu
Subject: Re: [RFC PATCH] QRCU fastpath optimization
Message-ID: <20070212062209.GE3999@kernel.dk>
References: <20070212044817.GA23254@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070212044817.GA23254@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 11 2007, Paul E. McKenney wrote:
> This patch optimizes the "quick" RCU update-side fastpath, so that in the
> absence of readers, synchronize_qrcu() does four non-atomic comparisons
> and three memory barriers, eliminating the need to acquire the global
> lock in this case.  Lightly tested.  Algorithm has been validated for
> the 3-reader-2-updater and 2-reader-3-updater cases -- 3-readers-3-updaters
> case still to be done (I expect to get access to a large-memory machine
> in the next few weeks -- need >>20GB).
> 
> Not for inclusion.  Patch is against Oleg's original patch, and likely
> needs to be rediffed against Jen's patchstack.  I will do this rediffing
> later, first want an easy-to-test and easy-to-inpect version.

I'd suggest just merging this optimization into the original QRCU patch.
Once you are happy with the validation, I'll add it to the plug branch
as well.

Version against the plug branch below.

diff --git a/kernel/srcu.c b/kernel/srcu.c
index 53c6989..bfe347a 100644
--- a/kernel/srcu.c
+++ b/kernel/srcu.c
@@ -324,28 +324,53 @@ void synchronize_qrcu(struct qrcu_struct *qp)
 {
 	int idx;
 
+	smp_mb();  /* Force preceding change to happen before fastpath check. */
+
 	/*
-	 * The following memory barrier is needed to ensure that
-	 * any prior data-structure manipulation is seen by other
-	 * CPUs to happen before picking up the value of
-	 * qp->completed.
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
 	 */
-	smp_mb();
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
 	smp_mb__after_atomic_inc();
 	qp->completed++;
 
 	atomic_dec(qp->ctr + idx);
 	__wait_event(qp->wq, !atomic_read(qp->ctr + idx));
-out:
+out_unlock:
 	mutex_unlock(&qp->mutex);
+out:
 	smp_mb();
 	/*
 	 * The above smp_mb() is needed in the case that we

-- 
Jens Axboe

