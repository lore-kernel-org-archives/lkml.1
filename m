Return-Path: <linux-kernel-owner+w=401wt.eu-S932951AbXGYP1v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932951AbXGYP1v (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2007 11:27:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757044AbXGYP1n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jul 2007 11:27:43 -0400
Received: from mga03.intel.com ([143.182.124.21]:58318 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757263AbXGYP1m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2007 11:27:42 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.16,581,1175497200"; 
   d="scan'208";a="254625780"
Message-ID: <46A76BEC.1040309@intel.com>
Date: Wed, 25 Jul 2007 08:27:40 -0700
From: "Kok, Auke" <auke-jan.h.kok@intel.com>
User-Agent: Thunderbird 2.0.0.4 (X11/20070623)
MIME-Version: 1.0
To: =?ISO-8859-1?Q?Fernando_Luis_V=E1zquez_Cao?= 
	<fernando@oss.ntt.co.jp>
CC: e1000-devel@lists.sourceforge.net,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       john.ronciak@intel.com, jesse.brandeburg@intel.com,
       jeffrey.t.kirsher@intel.com
Subject: Re: [PATCH RFC] e1000: clear ICR before requesting an IRQ line
References: <1184666997.5271.5.camel@sebastian.kern.oss.ntt.co.jp>	 <20070718154659.c8b5ffea.akpm@linux-foundation.org>	 <1184896459.27369.36.camel@sebastian.kern.oss.ntt.co.jp>	 <1184896944.27369.50.camel@sebastian.kern.oss.ntt.co.jp>	 <1184898043.28418.3.camel@sebastian.kern.oss.ntt.co.jp> <1185355137.15252.82.camel@sebastian.kern.oss.ntt.co.jp>
In-Reply-To: <1185355137.15252.82.camel@sebastian.kern.oss.ntt.co.jp>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 25 Jul 2007 15:27:41.0921 (UTC) FILETIME=[5775DD10:01C7CED0]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Fernando Luis Vázquez Cao wrote:
> I made an interesting finding while testing the two patches below.
> 
> http://lkml.org/lkml/2007/7/19/685
> http://lkml.org/lkml/2007/7/19/687
> 
> These patches modify the traditional CONFIG_DEBUG_KERNEL in such a way
> that the request_irq prints a warning if after calling the handler it
> returned IRQ_HANDLED .
> 
> The code looks like this:
> 
> int request_irq(unsigned int irq, irq_handler_t handler,
>                 unsigned long irqflags, const char *devname, void *dev_id)
> .....
>         if (irqflags & IRQF_DISABLED) {
>                 unsigned long flags;
> 
>                 local_irq_save(flags);
>                 retval = handler(irq, dev_id);
>                 local_irq_restore(flags);
>         } else
>                 retval = handler(irq, dev_id);
>         if (retval == IRQ_HANDLED) {
>                 printk(KERN_WARNING
>                        "%s (IRQ %d) handled a spurious interrupt\n",
>                        devname, irq);
>         }
> .....
> 
> I discovered that the e1000 driver handles the "fake" interrupt, which,
> in principle, is not correct because it obviously isn't a real interrupt
> and it could have been an interrupt coming from another device that is
> sharing the IRQ line.
> 
> The problem is that the interrupt handler assumes that if ICR!=0 it was
> its device who generated the interrupt and, consequently, it should be
> handled. But, unfortunately, that is not always the case. If the network
> link is active when we open the device (e1000_open) the ICR will have
> the E1000_ICR_LSC bit set (by the way, is this the expected behavior?).

yes. is it really a problem though?

> This means that _any_ interrupt coming in after allocating our interrupt
> (e1000_request_irq) will be handled, no matter where it came from.

we actually generate this LSC interrupt ourselves in the driver, to make sure 
that we cascade into the watchdog which then enables or disables the link code 
based on the link status change. This allows us to _not_ do any link checking in 
_open and makes things a bit more simple.

> The solution I came up with is clearing the ICR before calling
> request_irq. I have to admit that I am not familiar enough with this
> driver, so it is quite likely that this is not the right fix. I would
> appreciate your comments on this.

Clearing the ICR before requesting an irq might not work - at the same time the 
device could generate another LSC irq...

Of course, we probably should just schedule some delayed work to run our 
watchdog in e1000_open, but I haven't checked if that actually works.


Auke

> Signed-off-by: Fernando Luis Vazquez Cao <fernando@oss.ntt.co.jp>
> ---
> 
> diff -urNp linux-2.6.22-orig/drivers/net/e1000/e1000_main.c linux-2.6.22-pendirq/drivers/net/e1000/e1000_main.c
> --- linux-2.6.22-orig/drivers/net/e1000/e1000_main.c	2007-07-19 18:18:53.000000000 +0900
> +++ linux-2.6.22-pendirq/drivers/net/e1000/e1000_main.c	2007-07-25 17:22:54.000000000 +0900
> @@ -1378,6 +1378,17 @@ e1000_alloc_queues(struct e1000_adapter 
>  }
>  
>  /**
> + * e1000_clear_interrupts
> + * @adapter: address of board private structure
> + *
> + * Mask interrupts
> + **/
> +static void
> +e1000_clear_interrupts(struct e1000_adapter *adapter) {
> +	E1000_READ_REG(&adapter->hw, ICR);
> +}
> +
> +/**
>   * e1000_open - Called when a network interface is made active
>   * @netdev: network interface device structure
>   *
> @@ -1431,6 +1442,9 @@ e1000_open(struct net_device *netdev)
>  	 * so we have to setup our clean_rx handler before we do so.  */
>  	e1000_configure(adapter);
>  
> +	/* Discard any possible pending interrupts. */
> +	e1000_clear_interrupts(adapter);
> +
>  	err = e1000_request_irq(adapter);
>  	if (err)
>  		goto err_req_irq;
