Return-Path: <linux-kernel-owner+w=401wt.eu-S1759732AbZCXTQW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759732AbZCXTQW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 15:16:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751180AbZCXTPq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 15:15:46 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:53702 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754868AbZCXTPp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 15:15:45 -0400
Date: Tue, 24 Mar 2009 20:14:49 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       ltt-dev@lists.casi.polymtl.ca, Frederic Weisbecker <fweisbec@gmail.com>,
       Jason Baron <jbaron@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Russell King <rmk+lkml@arm.linux.org.uk>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       "Frank Ch. Eigler" <fche@redhat.com>, Hideo AOKI <haoki@redhat.com>,
       Takashi Nishiie <t-nishiie@np.css.fujitsu.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>
Subject: Re: [patch 2/9] LTTng instrumentation - irq
Message-ID: <20090324191449.GB11665@elte.hu>
References: <20090324155625.420966314@polymtl.ca> <20090324160148.080628193@polymtl.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090324160148.080628193@polymtl.ca>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca> wrote:

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

Hm, this is rather unclean. Why open-code the first handler 
execution?

This is a sign (and side effect) of the logical model being slightly 
incorrect - see my previous mail to Jason.

	Ingo
