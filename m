Return-Path: <linux-kernel-owner+w=401wt.eu-S1750825AbXBRMcI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750825AbXBRMcI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Feb 2007 07:32:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750862AbXBRMcI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Feb 2007 07:32:08 -0500
Received: from www.osadl.org ([213.239.205.134]:50270 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750825AbXBRMcH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Feb 2007 07:32:07 -0500
Subject: Re: 2.6.20-git13 kernel BUG at
	/mnt/md0/devel/linux-git/kernel/time/tick-sched.c:168
From: Thomas Gleixner <tglx@linutronix.de>
Reply-To: tglx@linutronix.de
To: Alex Riesen <fork0@users.sourceforge.net>
Cc: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>
In-Reply-To: <20070218095037.GA3408@steel.home>
References: <45D61632.1020105@googlemail.com>
	 <1171660939.30834.102.camel@localhost.localdomain>
	 <20070217144752.GA2503@steel.home>
	 <1171725257.30834.120.camel@localhost.localdomain>
	 <20070217164652.GA2579@steel.home>
	 <6bffcb0e0702171441i6ac69ac0yb1c46dbf8f43dc2e@mail.gmail.com>
	 <1171788100.30834.169.camel@localhost.localdomain>
	 <20070218095037.GA3408@steel.home>
Content-Type: text/plain
Date: Sun, 18 Feb 2007 13:36:56 +0100
Message-Id: <1171802216.30834.172.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2007-02-18 at 10:50 +0100, Alex Riesen wrote:
> > The arch/i386/kernel/process.c part of the patch should apply to 2.6.20
> > as well. Can you check if the problem is there too ?
> 
> It does not apply and does not look trivially hackable.
> The code for cpu_idle was introduced in 2ff2d3d7 "i386: add idle notifier".

Here you go.

	tglx

Index: linux-2.6.20/arch/i386/kernel/process.c
===================================================================
--- linux-2.6.20.orig/arch/i386/kernel/process.c
+++ linux-2.6.20/arch/i386/kernel/process.c
@@ -189,6 +189,13 @@ void cpu_idle(void)
 				play_dead();
 
 			__get_cpu_var(irq_stat).idle_timestamp = jiffies;
+
+			local_irq_disable();
+			if (local_softirq_pending() && !need_resched())
+				printk(KERN_ERR
+				       "Idle: local softirq pending: %04x\n",
+				       local_softirq_pending());
+			local_irq_enable();
 			idle();
 		}
 		preempt_enable_no_resched();




