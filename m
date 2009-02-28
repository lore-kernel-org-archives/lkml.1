Return-Path: <linux-kernel-owner+w=401wt.eu-S1756203AbZB1WYV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756203AbZB1WYV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Feb 2009 17:24:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754170AbZB1WYN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Feb 2009 17:24:13 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:35112 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754480AbZB1WYM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Feb 2009 17:24:12 -0500
Date: Sat, 28 Feb 2009 17:24:09 -0500
From: Christoph Hellwig <hch@infradead.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>,
       Arjan van de Veen <arjan@infradead.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       Jon Masters <jonathan@jonmasters.org>
Subject: Re: [patch 3/4] genirq: add a quick check handler
Message-ID: <20090228222408.GB7797@infradead.org>
References: <20090226131336.423054348@linutronix.de> <20090226131719.640887792@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090226131719.640887792@linutronix.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I really disagree with the notation of the pre-handler.  Instead of
adding an additional pre handler method you should add a new threadfn
method.  The handler could just as now handle/not handle the interrupt,
or as a third option defer it to the thread.  That makes the different
semantics a lot clearer, and means ->handler and ->threadfn both have
very well defined contexts, instead of sometimes calling ->handler
sometimes from irq and sometimes from thread context.  This also
makes it much easier for complex hardware that might have simple and
fast interrupts that it may want to handle directly from hardirq context
in just a couple of cycles or complex interrupts that might be deferred
to process context.

In that model that main loop in handle_IRQ_event would look something
like this:


	do {
		ret = action->handler(irq, action->dev_id);
		switch (ret) {
		case IRQ_HANDLED:
			status |= action->flags;
			break;
		case IRQ_WAKE_THREAD:
			if (likely(!test_bit(IRQTF_DIED,
					     &action->thread_flags))) {
				set_bit(IRQTF_RUNTHREAD, &action->thread_flags);
				wake_up_process(action->thread);
			}
			/*
			 * Set it to handled so the spurious check
			 * does not trigger.
			 */
			ret = IRQ_HANDLED;
			break;
		}
		retval |= ret;
		action = action->next;
	 } while (action);
