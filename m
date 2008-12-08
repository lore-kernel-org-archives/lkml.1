Return-Path: <linux-kernel-owner+w=401wt.eu-S1753589AbYLHNmq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753589AbYLHNmq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2008 08:42:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752459AbYLHNmh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Dec 2008 08:42:37 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:53285 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751763AbYLHNmh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2008 08:42:37 -0500
Date: Mon, 8 Dec 2008 14:42:19 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/5] irq: move irq_desc according to smp_affinity v5
Message-ID: <20081208134219.GC29965@elte.hu>
References: <1228532430-28958-1-git-send-email-yinghai@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1228532430-28958-1-git-send-email-yinghai@kernel.org>
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


* Yinghai Lu <yinghai@kernel.org> wrote:

> +#ifdef CONFIG_MOVE_IRQ_DESC
> +	/* get new one */
> +	desc = irq_to_desc(irq);
> +#endif
>  
>  	spin_unlock(&desc->lock);
>  }
> @@ -467,12 +475,20 @@ handle_edge_irq(unsigned int irq, struct
>  		    !desc->action)) {
>  		desc->status |= (IRQ_PENDING | IRQ_MASKED);
>  		mask_ack_irq(desc, irq);
> +#ifdef CONFIG_MOVE_IRQ_DESC
> +		/* get new one */
> +		desc = irq_to_desc(irq);
> +#endif
>  		goto out_unlock;
>  	}
>  	kstat_incr_irqs_this_cpu(irq, desc);
>  
>  	/* Start handling the irq */
>  	desc->chip->ack(irq);
> +#ifdef CONFIG_MOVE_IRQ_DESC
> +	/* get new one */
> +	desc = irq_to_desc(irq);
> +#endif
>  
>  	/* Mark the IRQ currently in progress.*/
>  	desc->status |= IRQ_INPROGRESS;
> @@ -533,8 +549,13 @@ handle_percpu_irq(unsigned int irq, stru
>  	if (!noirqdebug)
>  		note_interrupt(irq, desc, action_ret);
>  
> -	if (desc->chip->eoi)
> +	if (desc->chip->eoi) {
>  		desc->chip->eoi(irq);
> +#ifdef CONFIG_MOVE_IRQ_DESC
> +		/* get new one */
> +		desc = irq_to_desc(irq);
> +#endif
> +	}
>  }
>  
>  void
> @@ -569,8 +590,13 @@ __set_irq_handler(unsigned int irq, irq_
>  
>  	/* Uninstall? */
>  	if (handle == handle_bad_irq) {
> -		if (desc->chip != &no_irq_chip)
> +		if (desc->chip != &no_irq_chip) {
>  			mask_ack_irq(desc, irq);
> +#ifdef CONFIG_MOVE_IRQ_DESC
> +			/* get new one */
> +			desc = irq_to_desc(irq);
> +#endif

this patch adds a ton of #ifdefs to important .c files, which could all 
have been avoided by introducing a new method:

	desc = irq_remap_to_desc(irq, desc);

which would do something like:

 static struct irq_desc *
 irq_remap_to_desc(unsigned int irq, struct irq_desc *desc)
 {
 #ifdef CONFIG_MOVE_IRQ_DESC
	return irq_to_desc(irq);
 #else
	return desc;
 #endif
 }

right?

	Ingo
