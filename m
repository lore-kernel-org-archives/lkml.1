Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756171Ab0CJDVq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Mar 2010 22:21:46 -0500
Received: from mail.windriver.com ([147.11.1.11]:53156 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756153Ab0CJDVm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Mar 2010 22:21:42 -0500
Date: Wed, 10 Mar 2010 11:21:02 +0800
From: Yong Zhang <yong.zhang@windriver.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Lars-Peter Clausen <lars@metafoo.de>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH] IRQ: Fix oneshot irq race between
 irq_finalize_oneshot and handle_level_irq
Message-ID: <20100310032102.GA2090@windriver.com>
Reply-To: Yong Zhang <yong.zhang@windriver.com>
References: <1268092679-18070-1-git-send-email-lars@metafoo.de>
 <alpine.LFD.2.00.1003091959080.22855@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1003091959080.22855@localhost.localdomain>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginalArrivalTime: 10 Mar 2010 03:21:04.0377 (UTC) FILETIME=[B772D690:01CAC000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 10, 2010 at 12:22:12AM +0100, Thomas Gleixner wrote:
> B1;2005;0cOn Tue, 9 Mar 2010, Lars-Peter Clausen wrote:
> >  
> > -	desc->status |= IRQ_INPROGRESS;
> > +	desc->status |= IRQ_INPROGRESS | IRQ_ONESHOT_INPROGRESS;
> >  	raw_spin_unlock(&desc->lock);
> 
> That keeps the IRQ_ONESHOT_INPROGRESS dangling for non ONESHOT
> interrupts. Not a big deal, but not pretty either.
>   
> The race between the thread and the irq handler exists indeed on SMP,
> but I think there are more fundamental issues about the state which
> need to be addressed.
> 
> The first thing is that we do not mark the status MASKED when we
> actually mask the interrupt in mask_ack_irq(). 
> 
> That conditional MASKED after running the primary handler is really
> horrible - I already ranted in private at the moron who committed that
> crime :)
> 
> So the following patch fixes that and the SMP race scenario:

Hi Thomas,

How about the following patch(maybe a little ugly). I think it will
resolve your concerns.

diff --git a/kernel/irq/chip.c b/kernel/irq/chip.c
index d70394f..23b79c6 100644
--- a/kernel/irq/chip.c
+++ b/kernel/irq/chip.c
@@ -461,9 +461,24 @@ handle_level_irq(unsigned int irq, struct irq_desc *desc)
 	raw_spin_lock(&desc->lock);
 	mask_ack_irq(desc, irq);
 
-	if (unlikely(desc->status & IRQ_INPROGRESS))
-		goto out_unlock;
+	/*
+	 * if we are in oneshot mode and the irq thread is running on
+	 * another cpu, just return because the irq thread will unmask
+	 * the irq
+	 */
+	if (unlikely(desc->status & IRQ_ONESHOT)) {
+		if (unlikely(desc->status & (IRQ_INPROGRESS | IRQ_MASKED)
+					  == IRQ_INPROGRESS | IRQ_MASKED))
+			goto out_unlock;
+	}
+	else {
+		if (unlikely(desc->status & IRQ_INPROGRESS))
+			goto out_unlock;
+	}
+
 	desc->status &= ~(IRQ_REPLAY | IRQ_WAITING);
+	if (unlikely(desc->status & IRQ_ONESHOT))
+		desc->status |= IRQ_MASKED;
 	kstat_incr_irqs_this_cpu(irq, desc);
 
 	/*
@@ -484,9 +499,7 @@ handle_level_irq(unsigned int irq, struct irq_desc *desc)
 	raw_spin_lock(&desc->lock);
 	desc->status &= ~IRQ_INPROGRESS;
 
-	if (unlikely(desc->status & IRQ_ONESHOT))
-		desc->status |= IRQ_MASKED;
-	else if (!(desc->status & IRQ_DISABLED) && desc->chip->unmask)
+	if (!(desc->status & (IRQ_DISABLED | IRQ_MASKED) && desc->chip->unmask)
 		desc->chip->unmask(irq);
 out_unlock:
 	raw_spin_unlock(&desc->lock);
