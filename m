Return-Path: <linux-kernel-owner+w=401wt.eu-S1756504AbZCAJpf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756504AbZCAJpf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Mar 2009 04:45:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755488AbZCAJpU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Mar 2009 04:45:20 -0500
Received: from www.tglx.de ([62.245.132.106]:48797 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754178AbZCAJpS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Mar 2009 04:45:18 -0500
Date: Sun, 1 Mar 2009 10:44:18 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Christoph Hellwig <hch@infradead.org>
cc: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>,
       Arjan van de Veen <arjan@infradead.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       Jon Masters <jonathan@jonmasters.org>
Subject: Re: [patch 3/4] genirq: add a quick check handler
In-Reply-To: <20090228222408.GB7797@infradead.org>
Message-ID: <alpine.LFD.2.00.0903011043520.29264@localhost.localdomain>
References: <20090226131336.423054348@linutronix.de> <20090226131719.640887792@linutronix.de> <20090228222408.GB7797@infradead.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 28 Feb 2009, Christoph Hellwig wrote:
> I really disagree with the notation of the pre-handler.  Instead of
> adding an additional pre handler method you should add a new threadfn
> method.  The handler could just as now handle/not handle the interrupt,
> or as a third option defer it to the thread.  That makes the different
> semantics a lot clearer, and means ->handler and ->threadfn both have
> very well defined contexts, instead of sometimes calling ->handler
> sometimes from irq and sometimes from thread context.  This also
> makes it much easier for complex hardware that might have simple and
> fast interrupts that it may want to handle directly from hardirq context
> in just a couple of cycles or complex interrupts that might be deferred
> to process context.
> 
> In that model that main loop in handle_IRQ_event would look something
> like this:
> 
> 
> 	do {
> 		ret = action->handler(irq, action->dev_id);
> 		switch (ret) {
> 		case IRQ_HANDLED:
> 			status |= action->flags;
> 			break;
> 		case IRQ_WAKE_THREAD:
> 			if (likely(!test_bit(IRQTF_DIED,
> 					     &action->thread_flags))) {
> 				set_bit(IRQTF_RUNTHREAD, &action->thread_flags);
> 				wake_up_process(action->thread);
> 			}
> 			/*
> 			 * Set it to handled so the spurious check
> 			 * does not trigger.
> 			 */
> 			ret = IRQ_HANDLED;
> 			break;
> 		}
> 		retval |= ret;
> 		action = action->next;
> 	 } while (action);

Makes a lot of sense.

Thanks,

	tglx
 
