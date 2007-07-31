Return-Path: <linux-kernel-owner+w=401wt.eu-S968445AbXGaEgS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S968445AbXGaEgS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2007 00:36:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S968079AbXGaEbs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Jul 2007 00:31:48 -0400
Received: from canuck.infradead.org ([209.217.80.40]:34575 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S968038AbXGaEbr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2007 00:31:47 -0400
Date: Mon, 30 Jul 2007 21:32:54 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org,
       torvalds@linux-foundation.org, akpm@linux-foundation.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, alan@lxorguk.ukuu.org.uk,
       gregkh@suse.de, vatsa@linux.vnet.ibm.com, chrisw@sous-sol.org,
       paulmck@linux.vnet.ibm.com, clameter@sgi.com,
       Ingo Molnar <mingo@elte.hu>
Subject: [patch 14/26] sched: fix next_interval determination in
	idle_balance()
Message-ID: <20070731043254.GO3975@kroah.com>
References: <20070731042108.546594256@blue.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="sched-fix-next_interval-determination-in-idle_balance.patch"
In-Reply-To: <20070731043047.GA3975@kroah.com>
User-Agent: Mutt/1.5.15 (2007-04-06)
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Christoph Lameter <clameter@sgi.com>

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
 1 file changed, 13 insertions(+), 9 deletions(-)

--- linux-2.6.21.6.orig/kernel/sched.c
+++ linux-2.6.21.6/kernel/sched.c
@@ -2831,17 +2831,21 @@ static void idle_balance(int this_cpu, s
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
