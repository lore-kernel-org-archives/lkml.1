Return-Path: <linux-kernel-owner+w=401wt.eu-S1757471AbZCWS4c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757471AbZCWS4c (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Mar 2009 14:56:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754943AbZCWS4X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Mar 2009 14:56:23 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:47492 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754271AbZCWS4X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Mar 2009 14:56:23 -0400
Date: Mon, 23 Mar 2009 14:56:18 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>,
       Christoph Hellwig <hch@infradead.org>,
       Arjan van de Veen <arjan@infradead.org>,
       Jon Masters <jonathan@jonmasters.org>,
       Sven Dietrich <sdietrich@suse.de>, David Brownell <david-b@pacbell.net>
Subject: Re: [patch 1/2] genirq: add threaded interrupt handler support
Message-ID: <20090323185618.GA11432@infradead.org>
References: <20090323172814.548471871@linutronix.de> <20090323172835.250505802@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090323172835.250505802@linutronix.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I like the API and concept of the patch a lot.

some minor comments:

> +		switch (ret) {
> +		case IRQ_WAKE_THREAD:
> +			/*
> +			 * Wake up the handler thread for this
> +			 * action. In case the thread crashed and was
> +			 * killed we just pretend that we handled the
> +			 * interrupt. The hardirq handler above has
> +			 * disabled the device interrupt, so no irq
> +			 * storm is lurking.
> +			 */

We probably wants some sort of error check to catch drivers returning
IRQ_WAKE_THREAD without actually defining a threaded handler here.

> +static inline int irq_thread_should_run(struct irqaction *action)
> +{
> +	return test_and_clear_bit(IRQTF_RUNTHREAD, &action->thread_flags);
> +}
> +
> +static int irq_wait_for_interrupt(struct irqaction *action)
> +{
> +	while (!kthread_should_stop()) {
> +		set_current_state(TASK_INTERRUPTIBLE);
> +		if (irq_thread_should_run(action)) {

Does adding the helper for one use really help readability?

> +			__set_current_state(TASK_RUNNING);
> +			return 0;
> +		} else
> +			schedule();

No need for the else here :)

> +	if (new->thread_fn) {
> +		struct task_struct *t;
> +
> +		t = kthread_create(irq_thread, new, "irq/%d-%s", irq,
> +				   new->name);
> +		if (IS_ERR(t))
> +			return PTR_ERR(t);
> +		/*
> +		 * We keep the reference to the task struct even if
> +		 * the thread dies to avoid that the interrupt code
> +		 * references an already freed task_struct.
> +		 */
> +		get_task_struct(t);
> +		new->thread = t;
> +		wake_up_process(t);
> +	}

We should really introduce a refcounted variant of the kthread helpers.
Not an argument against the patch, just a public mental note.

>  /**
> - *	request_irq - allocate an interrupt line
> + *	request_threaded_irq - allocate an interrupt line
>   *	@irq: Interrupt line to allocate
> - *	@handler: Function to be called when the IRQ occurs
> + *	@handler: Function to be called when the IRQ occurs.
> + *		  Primary handler for threaded interrupts
> + *      @thread_fn: Function called from the irq handler thread
> + *                  If NULL, no irq thread is created

The indentation is messed up here.

