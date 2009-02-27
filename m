Return-Path: <linux-kernel-owner+w=401wt.eu-S1755341AbZB0F1q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755341AbZB0F1q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Feb 2009 00:27:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751936AbZB0F1g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Feb 2009 00:27:36 -0500
Received: from casper.infradead.org ([85.118.1.10]:46417 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751534AbZB0F1g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Feb 2009 00:27:36 -0500
Date: Thu, 26 Feb 2009 21:27:52 -0800
From: Arjan van de Ven <arjan@infradead.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
       mingo@elte.hu, peterz@infradead.org, rostedt@goodmis.org,
       jonathan@jonmasters.org
Subject: Re: [patch 4/4] genirq: add support for threaded interrupt handlers
Message-ID: <20090226212752.332ba546@infradead.org>
In-Reply-To: <20090226153216.5db66bc3.akpm@linux-foundation.org>
References: <20090226131336.423054348@linutronix.de>
	<20090226131719.760899560@linutronix.de>
	<20090226153216.5db66bc3.akpm@linux-foundation.org>
Organization: Intel
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 26 Feb 2009 15:32:16 -0800
Andrew Morton <akpm@linux-foundation.org> wrote:

> On Thu, 26 Feb 2009 13:28:23 -0000
> Thomas Gleixner <tglx@linutronix.de> wrote:
> 
> > Add suppport for threaded interrupt handlers. This is a more strict
> > separation of the primary interrupt handler, which runs in hard
> > interrupt context, and the real interrupt handler, which handles the
> > real device functionality, than the existing hardirq/softirq
> > separation.
> > 
> > The primary hard interrupt context handler solely checks whether the
> > interrupt originates from the device or not. In case the interrupt
> > is asserted by the device the handler disables the interrupt on the
> > device level. This must be the only functionality of the primary
> > handler and this restriction has to be carefully monitored to avoid
> > unresolvable locking scenarios with a fully preemptible kernel.
> > 
> > The threaded handler allows to integrate hardware related
> > functionality and softirq/tasklet functions in the handler
> > thread.
> > 
> 
> A typical device driver will do:
> 
> some_function(...)
> {
> 	spin_lock_irqsave(&dev->lock);
> }
> 
> irq_handler(...)
> {
> 	spin_lock(&dev->lock);
> }
> 
> and this does not deadlock, because the driver "knows" that the IRQ is
> disabled during the execution of the IRQ handler.
> 
> But how is this optimisation supported with IRQ threads?  Do we leave
> the IRQ disabled during the thread execution?  Or does the driver need
> to be changed?
> 
> Bearing in mind that the driver might choose to split the IRQ handling
> between hard-irq context fastpath and process-context slowpath (I
> hope), and that each path might want to take the same lock.
> 


Realistically, for the "we go threaded interrupts" case (which is
opt-in), I think the only sane option is
* the quickhandler runs with irqs off
* the "slow" threaded handler runs with irqs on
And we guarantee both of these conditions from the core, to the point
that I think we should not allow any other combination.

This also should be fine for basically all cases; the quick handler
really needs to be quick so irq off makes sense, and the slow handler
can, worst case, turn off interrupts by itself, but normally is
preemptable etc etc.


-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
