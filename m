Return-Path: <linux-kernel-owner+w=401wt.eu-S1764996AbXHKTDZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764996AbXHKTDZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Aug 2007 15:03:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762522AbXHKS60
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Aug 2007 14:58:26 -0400
Received: from 1wt.eu ([62.212.114.60]:1561 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758005AbXHKS6W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Aug 2007 14:58:22 -0400
From: Willy Tarreau <w@1wt.eu>
Message-Id: <20070811184846.%N@1wt.eu>
References: <20070811184752.%N@1wt.eu>
User-Agent: quilt/0.46-1
Date: Sat, 11 Aug 2007 21:48:11 +0200
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Christoph Lameter <clameter@sgi.com>, Ingo Molnar <mingo@elte.hu>,
       Chris Wright <chrisw@sous-sol.org>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [2.6.20.16 review 19/28] sched: fix next_interval determination in idle_balance()
Content-Disposition: inline; filename=0019-sched-fix-next_interval-determination-in-idle_balan.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Fix massive SMP imbalance on NUMA nodes observed on 2.6.21.5 with CFS.
(and later on reproduced without CFS as well).

The intervals of domains that do not have SD_BALANCE_NEWIDLE must be
considered for the calculation of the time of the next balance.
Otherwise we may defer rebalancing forever and nodes might stay idle for
very long times.

Siddha also spotted that the conversion of the balance interval to
jiffies is missing. Fix that to.

From: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>

also continue the loop if !(sd->flags & SD_LOAD_BALANCE).

Tested-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

It did in fact trigger under all three of mainline, CFS, and -rt
including CFS -- see below for a couple of emails from last Friday
giving results for these three on the AMD box (where it happened) and on
a single-quad NUMA-Q system (where it did not, at least not with such
severity).

Signed-off-by: Christoph Lameter <clameter@sgi.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 kernel/sched.c |   22 +++++++++++++---------
 1 files changed, 13 insertions(+), 9 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index 62db30c..907ab05 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -2814,17 +2814,21 @@ static void idle_balance(int this_cpu, struct rq *this_rq)
 	unsigned long next_balance = jiffies + 60 *  HZ;
 
 	for_each_domain(this_cpu, sd) {
-		if (sd->flags & SD_BALANCE_NEWIDLE) {
+		unsigned long interval;
+
+		if (!(sd->flags & SD_LOAD_BALANCE))
+			continue;
+
+		if (sd->flags & SD_BALANCE_NEWIDLE)
 			/* If we've pulled tasks over stop searching: */
 			pulled_task = load_balance_newidle(this_cpu,
-							this_rq, sd);
-			if (time_after(next_balance,
-				  sd->last_balance + sd->balance_interval))
-				next_balance = sd->last_balance
-						+ sd->balance_interval;
-			if (pulled_task)
-				break;
-		}
+								this_rq, sd);
+
+		interval = msecs_to_jiffies(sd->balance_interval);
+		if (time_after(next_balance, sd->last_balance + interval))
+			next_balance = sd->last_balance + interval;
+		if (pulled_task)
+			break;
 	}
 	if (!pulled_task)
 		/*
-- 
1.5.2.4

-- 
