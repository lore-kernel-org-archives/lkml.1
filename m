Return-Path: <linux-kernel-owner+w=401wt.eu-S1765042AbXFSTjz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765042AbXFSTjz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2007 15:39:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761412AbXFSTjs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jun 2007 15:39:48 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:34273 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758896AbXFSTjr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2007 15:39:47 -0400
Date: Tue, 19 Jun 2007 21:39:03 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Greg KH <gregkh@suse.de>,
       chrisw@sous-sol.org, stable@kernel.org,
       Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
       Christoph Lameter <clameter@sgi.com>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [patch] sched: fix next_interval determination in idle_balance()
Message-ID: <20070619193903.GA15024@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.0.3
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


2.6.22 must-have item - perhaps suitable for -stable too, because it was 
reproduced on 2.6.21.5 too.

---------------------->
From: Christoph Lameter <clameter@sgi.com>
Subject: [patch] sched: fix next_interval determination in idle_balance()

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
---
 kernel/sched.c |   22 +++++++++++++---------
 1 file changed, 13 insertions(+), 9 deletions(-)

Index: v/kernel/sched.c
===================================================================
--- v.orig/kernel/sched.c
+++ v/kernel/sched.c
@@ -2938,17 +2938,21 @@ static void idle_balance(int this_cpu, s
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
