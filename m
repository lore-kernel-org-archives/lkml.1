Return-Path: <linux-kernel-owner+w=401wt.eu-S965295AbXBQPJd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965295AbXBQPJd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Feb 2007 10:09:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965297AbXBQPJd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Feb 2007 10:09:33 -0500
Received: from www.osadl.org ([213.239.205.134]:54390 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S965295AbXBQPJc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Feb 2007 10:09:32 -0500
Subject: Re: 2.6.20-git13 kernel BUG at
	/mnt/md0/devel/linux-git/kernel/time/tick-sched.c:168
From: Thomas Gleixner <tglx@linutronix.de>
Reply-To: tglx@linutronix.de
To: Alex Riesen <fork0@users.sourceforge.net>
Cc: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>
In-Reply-To: <20070217144752.GA2503@steel.home>
References: <45D61632.1020105@googlemail.com>
	 <1171660939.30834.102.camel@localhost.localdomain>
	 <20070217144752.GA2503@steel.home>
Content-Type: text/plain
Date: Sat, 17 Feb 2007 16:14:17 +0100
Message-Id: <1171725257.30834.120.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2007-02-17 at 15:47 +0100, Alex Riesen wrote:
> > > 164             if (need_resched())
> > > 165                     goto end;
> > > 166
> > > 167             cpu = smp_processor_id();
> > > 168             BUG_ON(local_softirq_pending());
> > 
> > Hmm, the BUG_ON is inside of an interrupt disabled region, so we should
> > have bailed out early in the need_resched() check above (because we are
> > in the idle task context according to the stack trace).
> > 
> > Is this reproducible ?
>
> Seen this too (Ubuntu, P4/ht-SMT, SATA, typed from screen):

Can you please apply the patch below, so we can at least see, which
softirq is pending. This should trigger independently of hrtimers and
dynticks. You can keep it compiled in and disable it at the kernel
commandline with "nohz=off" and / or "highres=off"

	tglx

diff --git a/arch/i386/kernel/process.c b/arch/i386/kernel/process.c
index bea304d..deeb90e 100644
--- a/arch/i386/kernel/process.c
+++ b/arch/i386/kernel/process.c
@@ -236,6 +236,11 @@ void cpu_idle(void)
 			 * Otherwise, idle callbacks can misfire.
 			 */
 			local_irq_disable();
+			if (local_softirq_pending() && !need_resched())
+				printk(KERN_ERR
+				       "Idle: local softirq pending: %04x",
+				       local_softirq_pending());
+
 			enter_idle();
 			idle();
 			__exit_idle();
diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
index 95e41f7..91d459f 100644
--- a/kernel/time/tick-sched.c
+++ b/kernel/time/tick-sched.c
@@ -165,7 +165,6 @@ void tick_nohz_stop_sched_tick(void)
 		goto end;
 
 	cpu = smp_processor_id();
-	BUG_ON(local_softirq_pending());
 
 	now = ktime_get();
 	/*


