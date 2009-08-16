Return-Path: <linux-kernel-owner+w=401wt.eu-S1751691AbZHPNqr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751691AbZHPNqr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Aug 2009 09:46:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751204AbZHPNqq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Aug 2009 09:46:46 -0400
Received: from bu3sch.de ([62.75.166.246]:39510 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750907AbZHPNqq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Aug 2009 09:46:46 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Thomas Gleixner <tglx@linutronix.de>
Subject: Re: Threaded interrupt handlers broken?
Date: Sun, 16 Aug 2009 15:46:46 +0200
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org
References: <200908161153.14081.mb@bu3sch.de> <200908161445.53147.mb@bu3sch.de> <alpine.LFD.2.00.0908161519280.2782@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.0908161519280.2782@localhost.localdomain>
X-Move-Along: Nothing to see here. No, really... Nothing.
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200908161546.46328.mb@bu3sch.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 16 August 2009 15:22:29 Thomas Gleixner wrote:
> On Sun, 16 Aug 2009, Michael Buesch wrote:
> > On Sunday 16 August 2009 12:14:36 Michael Buesch wrote:
> > I need the following patch for threaded IRQs to work.
> > The first hunk obviously is incorrect. But without it the thread_fn is
> > never called.
> > 
> > Index: wireless-testing/kernel/irq/manage.c
> > ===================================================================
> > --- wireless-testing.orig/kernel/irq/manage.c	2009-08-15 22:22:07.000000000 +0200
> > +++ wireless-testing/kernel/irq/manage.c	2009-08-16 14:05:23.000000000 +0200
> > @@ -504,7 +504,7 @@ static int irq_thread(void *data)
> >  		atomic_inc(&desc->threads_active);
> >  
> >  		spin_lock_irq(&desc->lock);
> > -		if (unlikely(desc->status & IRQ_DISABLED)) {
> > +		if (0&&unlikely(desc->status & IRQ_DISABLED)) {
> 
> So the interrupt is marked disabled. How do you setup the handler ?
> And what does the primary handler do ? Can you post your driver code please?

This patch converts the b43 driver to threaded interrupts:
http://bu3sch.de/patches/wireless-testing/20090816-1535/patches/002-b43-threaded-irq-handler.patch

It kind of works with this hack applied to kernel/irq/manage.c

> >  			/*
> >  			 * CHECKME: We might need a dedicated
> >  			 * IRQ_THREAD_PENDING flag here, which
> > @@ -520,7 +520,7 @@ static int irq_thread(void *data)
> >  			action->thread_fn(action->irq, action->dev_id);
> >  		}
> >  
> > -		wake = atomic_dec_and_test(&desc->threads_active);
> > +		wake = !atomic_dec_and_test(&desc->threads_active);
> 
> So you wake when the thread counter is != 0 after the decrement.
> 
>  #define atomic_dec_and_test(v) (atomic_sub_return(1, (v)) == 0)

Yeah, isn't that what we want to do? I read the test as "wake other threads,
if there are other threads" or something like that.

-- 
Greetings, Michael.
