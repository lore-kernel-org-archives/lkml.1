Return-Path: <linux-kernel-owner+w=401wt.eu-S1765542AbXFSDqT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765542AbXFSDqT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2007 23:46:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760653AbXFSDqJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jun 2007 23:46:09 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:57697 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1760017AbXFSDqI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2007 23:46:08 -0400
Date: Mon, 18 Jun 2007 20:46:03 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: "Siddha, Suresh B" <suresh.b.siddha@intel.com>
cc: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Dinakar Guniguntala <dino@in.ibm.com>,
       Dmitry Adamushko <dmitry.adamushko@gmail.com>, pwil3058@bigpond.net.au,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: v2.6.21.4-rt11
In-Reply-To: <20070619021558.GD7160@linux-os.sc.intel.com>
Message-ID: <Pine.LNX.4.64.0706182040500.30213@schroedinger.engr.sgi.com>
References: <20070615144535.GA12078@elte.hu> <20070615151452.GC9301@linux.vnet.ibm.com>
 <20070615195545.GA28872@elte.hu> <20070616011605.GH9301@linux.vnet.ibm.com>
 <20070616084434.GG2559@linux.vnet.ibm.com> <20070616161213.GA2994@linux.vnet.ibm.com>
 <20070618151215.GA9750@linux.vnet.ibm.com> <Pine.LNX.4.64.0706180948250.4751@schroedinger.engr.sgi.com>
 <20070618173558.GA17865@linux.vnet.ibm.com> <Pine.LNX.4.64.0706181054530.6596@schroedinger.engr.sgi.com>
 <20070619021558.GD7160@linux-os.sc.intel.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 18 Jun 2007, Siddha, Suresh B wrote:

> > +		if (time_after(next_balance,
> > +			  sd->last_balance + sd->balance_interval))
> > +			next_balance = sd->last_balance
> > +					+ sd->balance_interval;
> 
> don't we have to do, msecs_to_jiffies(sd->balance_interval)?

Well that is certainly a bug here. Is this better?

Scheduler: Fix next_interval determination in idle_balance().

The intervals of domains that do not have SD_BALANCE_NEWIDLE must
be considered for the calculation of the time of the next balance.
Otherwise we may defer rebalancing forever.

Siddha also spotted that the conversion of the balance interval
to jiffies is missing. Fix that to.

Signed-off-by: Christop Lameter <clameter@sgi.com>

Index: linux-2.6.22-rc4-mm2/kernel/sched.c
===================================================================
--- linux-2.6.22-rc4-mm2.orig/kernel/sched.c	2007-06-18 20:41:46.000000000 -0700
+++ linux-2.6.22-rc4-mm2/kernel/sched.c	2007-06-18 20:44:00.000000000 -0700
@@ -2493,17 +2493,18 @@ static void idle_balance(int this_cpu, s
 	unsigned long next_balance = jiffies + 60 *  HZ;
 
 	for_each_domain(this_cpu, sd) {
-		if (sd->flags & SD_BALANCE_NEWIDLE) {
+		unsigned long interval;
+
+		if (sd->flags & SD_BALANCE_NEWIDLE)
 			/* If we've pulled tasks over stop searching: */
-			pulled_task = load_balance_newidle(this_cpu,
-							this_rq, sd);
-			if (time_after(next_balance,
-				  sd->last_balance + sd->balance_interval))
-				next_balance = sd->last_balance
-						+ sd->balance_interval;
-			if (pulled_task)
-				break;
-		}
+			pulled_task = load_balance_newidle(this_cpu,this_rq, sd);
+
+		interval = msecs_to_jiffies(sd->balance_interval);
+		if (time_after(next_balance,
+			  sd->last_balance + interval))
+			next_balance = sd->last_balance + interval;
+		if (pulled_task)
+			break;
 	}
 	if (!pulled_task)
 		/*

