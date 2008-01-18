Return-Path: <linux-kernel-owner+w=401wt.eu-S1764701AbYARUoR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764701AbYARUoR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2008 15:44:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759664AbYARUoF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jan 2008 15:44:05 -0500
Received: from srv5.dvmed.net ([207.36.208.214]:57581 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755240AbYARUoC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2008 15:44:02 -0500
Message-ID: <47910F8F.3040107@pobox.com>
Date: Fri, 18 Jan 2008 15:43:59 -0500
From: Jeff Garzik <jgarzik@pobox.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Rusty Russell <rusty@rustcorp.com.au>
CC: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Ash Willis <ashwillis@programmer.net>, linux-pcmcia@lists.infradead.org,
       virtualization@lists.linux-foundation.org, Tejun Heo <htejun@gmail.com>
Subject: Re: [PATCH 2/3] Make IRQ handlers typesafe.
References: <200801190722.26154.rusty@rustcorp.com.au> <200801190725.24271.rusty@rustcorp.com.au>
In-Reply-To: <200801190725.24271.rusty@rustcorp.com.au>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.3 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rusty Russell wrote:
> This patch lets interrupt handler functions have their natural type
> (ie. exactly match the data pointer type); for transition it allows
> the old irq_handler_t type as well.
> 
> To do this it uses a gcc extension, cast-to-union, which allows a type
> to be cast to any type within the union.  When used in a wrapper
> macro, it's a simple way of allowing one of several types.
> 
> (Some drivers now need to be cleaned up to compile, previous patch).
> 
> Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
> ---
>  include/linux/interrupt.h |   17 +++++++++++++++--
>  include/linux/kernel.h    |    7 +++++++
>  kernel/irq/devres.c       |   10 +++++-----
>  kernel/irq/manage.c       |    6 +++---
>  4 files changed, 30 insertions(+), 10 deletions(-)
> 
> diff -r 0fe1a980708b include/linux/interrupt.h
> --- a/include/linux/interrupt.h	Thu Jan 17 14:48:56 2008 +1100
> +++ b/include/linux/interrupt.h	Thu Jan 17 15:42:01 2008 +1100
> @@ -69,13 +69,26 @@ struct irqaction {
>  };
>  
>  extern irqreturn_t no_action(int cpl, void *dev_id);
> -extern int __must_check request_irq(unsigned int, irq_handler_t handler,
> +
> +/* Typesafe version of request_irq.  Also takes old-style void * handlers. */
> +#define request_irq(irq, handler, flags, name, dev_id)			\
> +	__request_irq((irq),						\
> +		      check_either_type((handler), irq_handler_t,	\
> +					int (*)(int, typeof(dev_id))),	\
> +		      (flags), (name), (dev_id))
> +
> +extern int __must_check __request_irq(unsigned int, irq_handler_t handler,
>  		       unsigned long, const char *, void *);
>  extern void free_irq(unsigned int, void *);
>  
>  struct device;
>  
> -extern int __must_check devm_request_irq(struct device *dev, unsigned int irq,
> +#define devm_request_irq(dev, irq, handler, flags, name, dev_id)	\
> +	__devm_request_irq((dev), (irq),				\
> +		      check_either_type((handler), irq_handler_t,	\
> +					int (*)(int, typeof(dev_id))),	\
> +		      (flags), (name), (dev_id))
> +extern int __must_check __devm_request_irq(struct device *dev, unsigned int irq,
>  			    irq_handler_t handler, unsigned long irqflags,
>  			    const char *devname, void *dev_id);

This is ugly and unnecessary.

Anything that does not use irq_handler_t is broken and should be fixed 
(as noted in last email, I think I've covered all this driver work already)

And if by definition everything uses irq_handler_t, there is no need for 
any of this "check_either_type" silliness.

	Jeff


