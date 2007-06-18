Return-Path: <linux-kernel-owner+w=401wt.eu-S1764270AbXFRR7a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764270AbXFRR7a (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2007 13:59:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760029AbXFRR7X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jun 2007 13:59:23 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:37769 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758762AbXFRR7W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2007 13:59:22 -0400
Date: Mon, 18 Jun 2007 10:59:21 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Dinakar Guniguntala <dino@in.ibm.com>,
       Dmitry Adamushko <dmitry.adamushko@gmail.com>,
       suresh.b.siddha@intel.com, pwil3058@bigpond.net.au,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: v2.6.21.4-rt11
In-Reply-To: <20070618173558.GA17865@linux.vnet.ibm.com>
Message-ID: <Pine.LNX.4.64.0706181054530.6596@schroedinger.engr.sgi.com>
References: <20070613185522.GA27335@elte.hu> <20070613233910.GJ8125@linux.vnet.ibm.com>
 <20070615144535.GA12078@elte.hu> <20070615151452.GC9301@linux.vnet.ibm.com>
 <20070615195545.GA28872@elte.hu> <20070616011605.GH9301@linux.vnet.ibm.com>
 <20070616084434.GG2559@linux.vnet.ibm.com> <20070616161213.GA2994@linux.vnet.ibm.com>
 <20070618151215.GA9750@linux.vnet.ibm.com> <Pine.LNX.4.64.0706180948250.4751@schroedinger.engr.sgi.com>
 <20070618173558.GA17865@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 18 Jun 2007, Srivatsa Vaddagiri wrote:

> On Mon, Jun 18, 2007 at 09:54:18AM -0700, Christoph Lameter wrote:
> > The nodes-level domain looks for internode balances between up to 16 
> > nodes. It is not restricted to a single node.
> 
> I was mostly speaking with the example system in mind (4-node 4-cpu
> box), but yes, node-level domain does look for imbalance across max 16
> nodes as you mention.
> 
> Both node and all-node domains don't have SD_BALANCE_NEWIDLE set, which
> means idle_balance() will stop looking for imbalance beyonds its own
> node. Based on the observed balance within its own node, IMO,
> idle_balance() should not cause ->next_balance to be reset.

I think the check in idle_balance needs to be modified.

If the domain *does not* have SD_BALANCE_NEWIDLE set then
next_balance must still be set right. Does this patch fix it?



Scheduler: Fix next_interval determination in idle_balance().

The intervals of domains that do not have SD_BALANCE_NEWIDLE must
be considered for the calculation of the time of the next balance. 
Otherwise we may defer rebalancing forever.

Signed-off-by: Christop Lameter <clameter@sgi.com>

Index: linux-2.6.22-rc4-mm2/kernel/sched.c
===================================================================
--- linux-2.6.22-rc4-mm2.orig/kernel/sched.c	2007-06-18 10:56:31.000000000 -0700
+++ linux-2.6.22-rc4-mm2/kernel/sched.c	2007-06-18 10:57:10.000000000 -0700
@@ -2493,17 +2493,16 @@ static void idle_balance(int this_cpu, s
 	unsigned long next_balance = jiffies + 60 *  HZ;
 
 	for_each_domain(this_cpu, sd) {
-		if (sd->flags & SD_BALANCE_NEWIDLE) {
+		if (sd->flags & SD_BALANCE_NEWIDLE)
 			/* If we've pulled tasks over stop searching: */
 			pulled_task = load_balance_newidle(this_cpu,
 							this_rq, sd);
-			if (time_after(next_balance,
-				  sd->last_balance + sd->balance_interval))
-				next_balance = sd->last_balance
-						+ sd->balance_interval;
-			if (pulled_task)
-				break;
-		}
+		if (time_after(next_balance,
+			  sd->last_balance + sd->balance_interval))
+			next_balance = sd->last_balance
+					+ sd->balance_interval;
+		if (pulled_task)
+			break;
 	}
 	if (!pulled_task)
 		/*
