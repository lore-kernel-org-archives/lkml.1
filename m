Return-Path: <linux-kernel-owner+w=401wt.eu-S1765457AbYB1T7U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765457AbYB1T7U (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2008 14:59:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764428AbYB1Ty0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Feb 2008 14:54:26 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:52906 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763052AbYB1TyY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2008 14:54:24 -0500
Date: Thu, 28 Feb 2008 20:53:09 +0100
From: Ingo Molnar <mingo@elte.hu>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, hidave.darkstar@gmail.com,
       akpm@linux-foundation.org, fzu@wemgehoertderstaat.de, ego@in.ibm.com,
       dipankar@in.ibm.com, niv@us.ibm.com, dvhltc@us.ibm.com
Subject: Re: [PATCH] Remove never-migrates assumption from
	rcu_process_callbacks()
Message-ID: <20080228195309.GA29720@elte.hu>
References: <20080228002110.GA20091@linux.vnet.ibm.com> <20080228195107.GA31203@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080228195107.GA31203@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Paul E. McKenney <paulmck@linux.vnet.ibm.com> wrote:

> Hello again!
> 
> This patch fixes a potentially invalid access to a per-CPU variable in 
> rcu_process_callbacks().  This per-CPU access needs to be done in such 
> a way as to guarantee that the code using it cannot move to some other 
> CPU before all uses of the value accessed have completed.  Even though 
> this code is currently only invoked from softirq context, which 
> currrently cannot migrate to some other CPU, life would be better if 
> this code did not silently make such an assumption.

i've got the patch below queued up already - same thing, right?

	Ingo

----------->
Subject: rcupreempt: fix hibernate/resume in presence of PREEMPT_RCU and hotplug
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Date: Wed, 27 Feb 2008 16:21:10 -0800

This fixes a oops encountered when doing hibernate/resume in presence
of PREEMPT_RCU.  The problem was that the code failed to disable preemption
when accessing a per-CPU variable.  This is OK when called from code
that already has preemption disabled, but such is not the case from
the suspend/resume code path.

Reported-by: Dave Young <hidave.darkstar@gmail.com>
Tested-by: Dave Young <hidave.darkstar@gmail.com>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/rcupreempt.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

Index: linux/kernel/rcupreempt.c
===================================================================
--- linux.orig/kernel/rcupreempt.c
+++ linux/kernel/rcupreempt.c
@@ -918,8 +918,9 @@ void rcu_offline_cpu(int cpu)
 	 * fix.
 	 */
 
+	local_irq_save(flags);
 	rdp = RCU_DATA_ME();
-	spin_lock_irqsave(&rdp->lock, flags);
+	spin_lock(&rdp->lock);
 	*rdp->nexttail = list;
 	if (list)
 		rdp->nexttail = tail;
