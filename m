Return-Path: <linux-kernel-owner+w=401wt.eu-S1756341AbZC0WPE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756341AbZC0WPE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Mar 2009 18:15:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751434AbZC0WOw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Mar 2009 18:14:52 -0400
Received: from www.tglx.de ([62.245.132.106]:53327 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751992AbZC0WOu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Mar 2009 18:14:50 -0400
Date: Fri, 27 Mar 2009 23:12:41 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
cc: akpm@linux-foundation.org, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, ltt-dev@lists.casi.polymtl.ca,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Jason Baron <jbaron@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
       Russell King <rmk+lkml@arm.linux.org.uk>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       "Frank Ch. Eigler" <fche@redhat.com>, Hideo AOKI <haoki@redhat.com>,
       Takashi Nishiie <t-nishiie@np.css.fujitsu.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>
Subject: Re: [patch 2/9] LTTng instrumentation - irq
In-Reply-To: <20090324160148.080628193@polymtl.ca>
Message-ID: <alpine.LFD.2.00.0903272307490.3397@localhost.localdomain>
References: <20090324155625.420966314@polymtl.ca> <20090324160148.080628193@polymtl.ca>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 24 Mar 2009, Mathieu Desnoyers wrote:
>   * lockdep: we want to handle all irq_desc locks as a single lock-class:
>   */
>  struct lock_class_key irq_desc_lock_class;
> @@ -316,6 +324,19 @@ irqreturn_t no_action(int cpl, void *dev
>  	return IRQ_NONE;
>  }
>  
> +static irqreturn_t __handle_irq_next_handler(unsigned int irq,
> +	struct irqaction **action, irqreturn_t *retval, unsigned int *status)
> +{
> +	irqreturn_t ret;
> +
> +	ret = (*action)->handler(irq, (*action)->dev_id);
> +	if (ret == IRQ_HANDLED)
> +		*status |= (*action)->flags;
> +	*retval |= ret;
> +	*action = (*action)->next;
> +	return ret;
> +}
> +
>  static irqreturn_t _handle_IRQ_event(unsigned int irq, struct irqaction *action)
>  {
>  	irqreturn_t ret, retval = IRQ_NONE;
> @@ -324,13 +345,12 @@ static irqreturn_t _handle_IRQ_event(uns
>  	if (!(action->flags & IRQF_DISABLED))
>  		local_irq_enable_in_hardirq();
>  
> -	do {
> -		ret = action->handler(irq, action->dev_id);
> -		if (ret == IRQ_HANDLED)
> -			status |= action->flags;
> -		retval |= ret;
> -		action = action->next;
> -	} while (action);
> +	ret = __handle_irq_next_handler(irq, &action, &retval, &status);
> +
> +	while (action) {
> +		trace_irq_next_handler(irq, action, ret);
> +		ret = __handle_irq_next_handler(irq, &action, &retval, &status);
> +	}

This one is the next candidate for the "ugly patch of the week contest".

It does not trace the return value of the first handler and just moves
code around for no good reason. Darn why can' t you simply do:

	do {
		ret = action->handler(irq, action->dev_id);
+		trace_action_handler(....);
	}

and keep the rest of the code unchanged ?    

>  
>  #ifndef CONFIG_GENERIC_HARDIRQS_NO__DO_IRQ

This code is going away. No tracepoint needed here.

Thanks,

	tglx
