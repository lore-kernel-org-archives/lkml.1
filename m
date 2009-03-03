Return-Path: <linux-kernel-owner+w=401wt.eu-S1758010AbZCCLyV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758010AbZCCLyV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Mar 2009 06:54:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751549AbZCCLyK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Mar 2009 06:54:10 -0500
Received: from www.tglx.de ([62.245.132.106]:51090 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751139AbZCCLyJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Mar 2009 06:54:09 -0500
Date: Tue, 3 Mar 2009 12:53:02 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: David Brownell <david-b@pacbell.net>
cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Andrew Morton <akpm@linux-foundation.org>, me@felipebalbi.com,
       linux-kernel@vger.kernel.org, linux-input@vger.kernel.org,
       felipe.balbi@nokia.com, dmitry.torokhov@gmail.com, sameo@openedhand.com
Subject: Re: lockdep and threaded IRQs (was: ...)
In-Reply-To: <200903021542.25153.david-b@pacbell.net>
Message-ID: <alpine.LFD.2.00.0903031207240.29264@localhost.localdomain>
References: <1235762883-20870-1-git-send-email-me@felipebalbi.com> <200903021520.30826.david-b@pacbell.net> <20090302232650.GA14515@elte.hu> <200903021542.25153.david-b@pacbell.net>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2 Mar 2009, David Brownell wrote:

> On Monday 02 March 2009, Ingo Molnar wrote:
> > If you want to work on genirq threaded IRQ handlers them please 
> > check out and test the threaded IRQ handlers patches that are 
> > being worked on at lkml. See:
> > 
> > [patch 0/4] genirq: add infrastructure for threaded interrupt handlers V2
> 
> I did check them out, as noted earlier in this thread.
> 
> The significant omission is lack of support for chaining
> such threads.  Example, an I2C device that exposes
> several dozen IRQs with mask/ack/... operations that
> require I2C access.

Well, the significant omission is on your side. Instead of talking to
us about the problems and possible shortcomings of the genirq code you
went there and created your private form of abuse and now you are
complaining about that. The lockdep issue is not caused by lockdep,
it's caused by your using code which is designed to run in hardirq
context from a thread context. It does not become more correct just
because it works fine w/o lockdep.

> I'm not sure what Thomas intends to do with that issue,

I can do something about that, when I know about it, but I have just
learned about the details in the last few days.

> if anything.  It does touch on messy bits of genirq.

Which mess are you referring to ? 

The problem you described is straight forward and as I said before
it's not rocket science to provide support for that in the genirq
code. Your use case does not need to use the chained handler setup at
all, it just needs to request the main IRQ as a simple type and handle
the ack/mask/unmask from the two handler parts.

irqreturn_t hardirq_handler()
{
	ack_mask(irq);
	return IRQ_WAKE_THREAD;
}    

irqreturn_t thread_handler()
{
	pending = read_i2c_pending_irqs();

	while (pending) {
	      ....
	      d->handle_irq(module_irq, d);
	}
	unmask(irq);
}

The only change in the generic code which is needed is a new handler
function for the chained irqs "handle_irq_simple_threaded()" which is
designed to handle the calls from thread context.

Thanks,

	tglx
