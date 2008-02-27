Return-Path: <linux-kernel-owner+w=401wt.eu-S1762943AbYB0XOW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762943AbYB0XOW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2008 18:14:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762199AbYB0XME
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Feb 2008 18:12:04 -0500
Received: from nf-out-0910.google.com ([64.233.182.189]:30340 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762038AbYB0XMA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2008 18:12:00 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id:sender;
        b=ooJuS4ifO8SiTIrjzV7Mc46FxWF+c4v4gFN3G9UfhW8JcEQSDJOLtklCzr4YsqLeX5gYEo7j+mib5ZPkeC9mF0q+OkwzgLQcq1sQY7+rJQreM48zYoq/hiVfW+jhPRhhZMl5JKNDTNNZR4tPkt+EKZ2suDsEZvYzo5TI5PDlhFs=
From: Karsten Wiese <fzu@wemgehoertderstaat.de>
To: "Dave Young" <hidave.darkstar@gmail.com>
Subject: Re: [BUG] using smp_processor_id() in preemptible as suspending
Date: Thu, 28 Feb 2008 00:11:48 +0100
User-Agent: KMail/1.9.6 (enterprise 0.20071204.744707)
Cc: paulmck@linux.vnet.ibm.com, "Andrew Morton" <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, "Ingo Molnar" <mingo@elte.hu>
References: <20080226082411.GA2853@darkstar.te-china.tietoenator.com> <20080226194504.GC8395@linux.vnet.ibm.com> <a8e1da0802261704t34eae4b9q758d22ee88fff3a9@mail.gmail.com>
In-Reply-To: <a8e1da0802261704t34eae4b9q758d22ee88fff3a9@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802280011.49386.fzu@wemgehoertderstaat.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Mittwoch, 27. Februar 2008 schrieb Dave Young:
> On Wed, Feb 27, 2008 at 3:45 AM, Paul E. McKenney
> <paulmck@linux.vnet.ibm.com> wrote:
> > On Tue, Feb 26, 2008 at 08:33:54AM -0800, Andrew Morton wrote:
> >  > On Tue, 26 Feb 2008 16:24:11 +0800 Dave Young <hidave.darkstar@gmail.com> wrote:
> >  >
> >  > > I don't know whom I should mail to, could you cc the proper guy? Thanks.
> >
> >  Hello, Dave,
> >
> >  Would you be willing to try out the following (untested, might not even
> >  compile) patch show at the very end of this message?  This assumes that
> >  you were running with CONFIG_PREEMPT_RCU, which seems most likely based
> >  on looking at your oops.
> 
> Built ok, but can't even resume now. (dark screen with cursor blinking
> on top-left of minitor)

Dave, can you give this untested patch a try?

thanks,
      Karsten

---
diff --git a/kernel/rcupreempt.c b/kernel/rcupreempt.c
index c7c5209..5a7f8fc 100644
--- a/kernel/rcupreempt.c
+++ b/kernel/rcupreempt.c
@@ -878,18 +878,20 @@ void rcu_offline_cpu(int cpu)
 	 * Otherwise rcu_barrier() will fail
 	 */
 
-	spin_lock_irqsave(&rdp->lock, flags);
+	local_irq_save(flags);
+
+	spin_lock(&rdp->lock);
 	rcu_offline_cpu_enqueue(rdp->donelist, rdp->donetail, list, tail);
 	for (i = GP_STAGES - 1; i >= 0; i--)
 		rcu_offline_cpu_enqueue(rdp->waitlist[i], rdp->waittail[i],
 						list, tail);
 	rcu_offline_cpu_enqueue(rdp->nextlist, rdp->nexttail, list, tail);
-	spin_unlock_irqrestore(&rdp->lock, flags);
+	spin_unlock(&rdp->lock);
 	rdp->waitlistcount = 0;
 
 	/* Disengage the newly dead CPU from the grace-period computation. */
 
-	spin_lock_irqsave(&rcu_ctrlblk.fliplock, flags);
+	spin_lock(&rcu_ctrlblk.fliplock);
 	rcu_check_mb(cpu);
 	if (per_cpu(rcu_flip_flag, cpu) == rcu_flipped) {
 		smp_mb();  /* Subsequent counter accesses must see new value */
@@ -906,7 +908,7 @@ void rcu_offline_cpu(int cpu)
 
 	cpu_clear(cpu, rcu_cpu_online_map);
 
-	spin_unlock_irqrestore(&rcu_ctrlblk.fliplock, flags);
+	spin_unlock(&rcu_ctrlblk.fliplock);
 
 	/*
 	 * Place the removed callbacks on the current CPU's queue.
@@ -919,11 +921,13 @@ void rcu_offline_cpu(int cpu)
 	 */
 
 	rdp = RCU_DATA_ME();
-	spin_lock_irqsave(&rdp->lock, flags);
+	spin_lock(&rdp->lock);
 	*rdp->nexttail = list;
 	if (list)
 		rdp->nexttail = tail;
-	spin_unlock_irqrestore(&rdp->lock, flags);
+	spin_unlock(&rdp->lock);
+
+	local_irq_restore(flags);
 }
 
 void __devinit rcu_online_cpu(int cpu)
