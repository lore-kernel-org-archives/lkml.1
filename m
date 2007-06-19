Return-Path: <linux-kernel-owner+w=401wt.eu-S1754148AbXFSIJF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754148AbXFSIJF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2007 04:09:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755393AbXFSIIl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jun 2007 04:08:41 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:41729 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754489AbXFSIIh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2007 04:08:37 -0400
Date: Tue, 19 Jun 2007 10:07:37 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
Cc: Christoph Lameter <clameter@sgi.com>,
       "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Dinakar Guniguntala <dino@in.ibm.com>,
       Dmitry Adamushko <dmitry.adamushko@gmail.com>, pwil3058@bigpond.net.au,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: v2.6.21.4-rt11
Message-ID: <20070619080737.GB22371@elte.hu>
References: <20070616011605.GH9301@linux.vnet.ibm.com> <20070616084434.GG2559@linux.vnet.ibm.com> <20070616161213.GA2994@linux.vnet.ibm.com> <20070618151215.GA9750@linux.vnet.ibm.com> <Pine.LNX.4.64.0706180948250.4751@schroedinger.engr.sgi.com> <20070618173558.GA17865@linux.vnet.ibm.com> <Pine.LNX.4.64.0706181054530.6596@schroedinger.engr.sgi.com> <20070619021558.GD7160@linux-os.sc.intel.com> <Pine.LNX.4.64.0706182040500.30213@schroedinger.engr.sgi.com> <20070619054901.GA10981@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070619054901.GA10981@linux.vnet.ibm.com>
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


* Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com> wrote:

> On Mon, Jun 18, 2007 at 08:46:03PM -0700, Christoph Lameter wrote:
> > @@ -2493,17 +2493,18 @@ static void idle_balance(int this_cpu, s
> >  	unsigned long next_balance = jiffies + 60 *  HZ;
> > 
> >  	for_each_domain(this_cpu, sd) {
> > -		if (sd->flags & SD_BALANCE_NEWIDLE) {
> > +		unsigned long interval;
> > +
> 
> Do we need a :
> 
> 		if (!(sd->flags & SD_LOAD_BALANCE))
> 			continue;
> 
> here?
> 
> Otherwise patch look good and fixes the problem Paul observed earlier.

great! I've applied the patch below (added your fix and cleaned it up a 
bit) and have released 2.6.21.5-rt17 with it.

	Ingo

------------------------------>
From: Christoph Lameter <clameter@sgi.com>
Subject: [patch] sched: fix next_interval determination in idle_balance().

The intervals of domains that do not have SD_BALANCE_NEWIDLE must
be considered for the calculation of the time of the next balance.
Otherwise we may defer rebalancing forever.

Siddha also spotted that the conversion of the balance interval
to jiffies is missing. Fix that to.

From: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>

also continue the loop if !(sd->flags & SD_LOAD_BALANCE).

Signed-off-by: Christoph Lameter <clameter@sgi.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/sched.c |   22 +++++++++++++---------
 1 file changed, 13 insertions(+), 9 deletions(-)

Index: linux/kernel/sched.c
===================================================================
--- linux.orig/kernel/sched.c
+++ linux/kernel/sched.c
@@ -2591,17 +2591,21 @@ static void idle_balance(int this_cpu, s
 	unsigned long next_balance = jiffies + HZ;
 
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
 	if (pulled_task || time_after(jiffies, this_rq->next_balance)) {
 		/*
