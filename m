Return-Path: <linux-kernel-owner+w=401wt.eu-S1754112AbYGWQNG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754112AbYGWQNG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2008 12:13:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752875AbYGWQMx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jul 2008 12:12:53 -0400
Received: from smtp115.sbc.mail.sp1.yahoo.com ([69.147.64.88]:44112 "HELO
	smtp115.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751012AbYGWQMx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2008 12:12:53 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=YOexUJkgUlqM7/JHSQtCRIz0p8gs6lfPuVGx6O9L7mc+umBEJCTlF2Kxcb1pLUi5SWZ/zsCWGYQgbkiLsgGY/lq1EunSDU7WFaNsj1BfxkCwR1FLWMeG9+k91cLE0GJHY9tgQuD/i7pdMdJgWBbd6Bzw2BaRKpTbcLrBVzEZJbc=  ;
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Uwe =?iso-8859-1?q?Kleine-K=F6nig?= <Uwe.Kleine-Koenig@digi.com>
Subject: Re: [PATCH] set_irq_wake: fix return code and wake status tracking
Date: Wed, 23 Jul 2008 09:00:27 -0700
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org,
       David Brownell <dbrownell@users.sourceforge.net>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Russell King <rmk@arm.linux.org.uk>, Andrew Morton <akpm@osdl.org>,
       Linus Torvalds <torvalds@osdl.org>
References: <1216816945-20223-1-git-send-email-Uwe.Kleine-Koenig@digi.com>
In-Reply-To: <1216816945-20223-1-git-send-email-Uwe.Kleine-Koenig@digi.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200807230900.27563.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 23 July 2008, Uwe Kleine-König wrote:
> Since 15a647eba94c3da27ccc666bea72e7cca06b2d19 set_irq_wake returned -ENXIO
> if another device had it already enabled.  Zero is the right value to
> return in this case.  Moreover the change to desc->status was not reverted
> if desc->chip->set_wake returned an error.
> 
> Signed-off-by: Uwe Kleine-König <Uwe.Kleine-Koenig@digi.com>
> Cc: David Brownell <dbrownell@users.sourceforge.net>

Acked-by: David Brownell <dbrownell@users.sourceforge.net>


> Cc: Ingo Molnar <mingo@elte.hu>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Russell King <rmk@arm.linux.org.uk>
> Cc: Andrew Morton <akpm@osdl.org>
> Cc: Linus Torvalds <torvalds@osdl.org>
> ---
>  kernel/irq/manage.c |   39 +++++++++++++++++++++++++++------------
>  1 files changed, 27 insertions(+), 12 deletions(-)
> 
> diff --git a/kernel/irq/manage.c b/kernel/irq/manage.c
> index e01ad8e..227cd49 100644
> --- a/kernel/irq/manage.c
> +++ b/kernel/irq/manage.c
> @@ -194,6 +194,17 @@ void enable_irq(unsigned int irq)
>  }
>  EXPORT_SYMBOL(enable_irq);
>  
> +int set_irq_wake_real(unsigned int irq, unsigned int on)
> +{
> +	struct irq_desc *desc = irq_desc + irq;
> +	int ret = -ENXIO;
> +
> +	if (desc->chip->set_wake)
> +		ret = desc->chip->set_wake(irq, on);
> +
> +	return ret;
> +}
> +
>  /**
>   *	set_irq_wake - control irq power management wakeup
>   *	@irq:	interrupt to control
> @@ -210,30 +221,34 @@ int set_irq_wake(unsigned int irq, unsigned int on)
>  {
>  	struct irq_desc *desc = irq_desc + irq;
>  	unsigned long flags;
> -	int ret = -ENXIO;
> -	int (*set_wake)(unsigned, unsigned) = desc->chip->set_wake;
> +	int ret = 0;
>  
>  	/* wakeup-capable irqs can be shared between drivers that
>  	 * don't need to have the same sleep mode behaviors.
>  	 */
>  	spin_lock_irqsave(&desc->lock, flags);
>  	if (on) {
> -		if (desc->wake_depth++ == 0)
> -			desc->status |= IRQ_WAKEUP;
> -		else
> -			set_wake = NULL;
> +		if (desc->wake_depth++ == 0) {
> +			ret = set_irq_wake_real(irq, on);
> +			if (ret)
> +				desc->wake_depth = 0;
> +			else
> +				desc->status |= IRQ_WAKEUP;
> +		}
>  	} else {
>  		if (desc->wake_depth == 0) {
>  			printk(KERN_WARNING "Unbalanced IRQ %d "
>  					"wake disable\n", irq);
>  			WARN_ON(1);
> -		} else if (--desc->wake_depth == 0)
> -			desc->status &= ~IRQ_WAKEUP;
> -		else
> -			set_wake = NULL;
> +		} else if (--desc->wake_depth == 0) {
> +			ret = set_irq_wake_real(irq, on);
> +			if (ret)
> +				desc->wake_depth = 1;
> +			else
> +				desc->status &= ~IRQ_WAKEUP;
> +		}
>  	}
> -	if (set_wake)
> -		ret = desc->chip->set_wake(irq, on);
> +
>  	spin_unlock_irqrestore(&desc->lock, flags);
>  	return ret;
>  }
> -- 
> 1.5.6.3
> 


