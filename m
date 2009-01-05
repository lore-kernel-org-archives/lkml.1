Return-Path: <linux-kernel-owner+w=401wt.eu-S1753115AbZAEEaZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753115AbZAEEaZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Jan 2009 23:30:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752131AbZAEEaN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Jan 2009 23:30:13 -0500
Received: from e6.ny.us.ibm.com ([32.97.182.146]:34520 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752114AbZAEEaL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Jan 2009 23:30:11 -0500
Date: Sun, 4 Jan 2009 20:30:06 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, andi@firstfloor.org, snakebyte@gmx.de,
       akpm@linux-foundation.org, dvhltc@us.ibm.com, niv@us.ibm.com,
       manfred@colorfullife.com, laijs@cn.fujitsu.com
Subject: [PATCH] Fix rcutree grace-period-latency bug on small systems
Message-ID: <20090105043006.GA22049@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kudos to Andi Kleen for finding a grace-period-latency problem!  The
problem was that the special-case code for small machines never updated
the ->signaled field to indicate that grace-period initialization had
completed, which prevented force_quiescent_state() from ever expediting
grace periods.  This problem resulted in grace periods extending for more
than 20 seconds.  Not subtle.  I introduced this bug during my inspection
process when I fixed a race between grace-period initialization and
force_quiescent_state() execution.

The following patch properly updates the ->signaled field for the
"small"-system case (no more than 32 CPUs for 32-bit kernels and no more
than 64 CPUs for 64-bit kernels).

I believe that this patch should be included for 2.6.29.

Located-by: Andi Kleen <andi@firstfloor.org>
Tested-by: Andi Kleen <andi@firstfloor.org>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---

 rcutree.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/kernel/rcutree.c b/kernel/rcutree.c
index a342b03..88d921c 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -572,6 +572,7 @@ rcu_start_gp(struct rcu_state *rsp, unsigned long flags)
 	/* Special-case the common single-level case. */
 	if (NUM_RCU_NODES == 1) {
 		rnp->qsmask = rnp->qsmaskinit;
+		rsp->signaled = RCU_SIGNAL_INIT; /* force_quiescent_state OK. */
 		spin_unlock_irqrestore(&rnp->lock, flags);
 		return;
 	}

