Return-Path: <linux-kernel-owner+w=401wt.eu-S1756036AbYIRHy0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756036AbYIRHy0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2008 03:54:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752860AbYIRHyP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Sep 2008 03:54:15 -0400
Received: from mtagate5.de.ibm.com ([195.212.29.154]:42754 "EHLO
	mtagate5.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751449AbYIRHyN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2008 03:54:13 -0400
In-Reply-To: <20080915100406.342e027a@bull.net>
References: <20080915100406.342e027a@bull.net>
Subject: Re: [PATCH HACK] powerpc: quick hack to get a functional eHEA with hardirq
 preemption
X-KeepSent: 39C3BF0F:17B60FAA-C12574C8:002AE138;
 type=4; name=$KeepSent
To: Sebastien Dugue <sebastien.dugue@bull.net>
Cc: gilles.carry@ext.bull.net, Jan-Bernd Themann <THEMANN@de.ibm.com>,
       jean-pierre.dion@bull.net, linux-kernel <linux-kernel@vger.kernel.org>,
       Linux-rt <linux-rt-users@vger.kernel.org>,
       linux-ppc <linuxppc-dev@ozlabs.org>, netdev@vger.kernel.org,
       Thomas Q Klein <TKLEIN@de.ibm.com>, tinytim@us.ibm.com,
       Benjamin Herrenschmidt <bherren@au1.ibm.com>
X-Mailer: Lotus Notes Release 8.0.1 HF105 April 10, 2008
Message-ID: <OF39C3BF0F.17B60FAA-ONC12574C8.002AE138-C12574C8.002B6422@de.ibm.com>
From: Christoph Raisch <RAISCH@de.ibm.com>
Date: Thu, 18 Sep 2008 09:53:54 +0200
X-MIMETrack: Serialize by Router on D12ML067/12/M/IBM(Release 8.0.1|February 07, 2008) at
 18/09/2008 09:53:55
MIME-Version: 1.0
Content-type: text/plain; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Sebastien Dugue <sebastien.dugue@bull.net> wrote on 15.09.2008 10:04:06:
> [PATCH HACK] powerpc: quick hack to get a functional eHEA with
> hardirq preemption
>
> Sebastien Dugue
>
> to:
>
> 15.09.2008 10:07
>
> Cc:
>
> linux-ppc, linux-kernel, Linux-rt, netdev, Jan-Bernd Themann, Thomas
> Q Klein, Christoph Raisch, jean-pierre.dion, gilles.carry, tinytim
>
>
> WARNING: HACK - HACK - HACK
> Not-Signed-off-by: Sebastien Dugue <sebastien.dugue@bull.net>
> ---
> --- a/arch/powerpc/kernel/ibmebus.c
> +++ b/arch/powerpc/kernel/ibmebus.c
> @@ -41,6 +41,7 @@
> -   return request_irq(irq, handler, irq_flags, devname, dev_id);
> +   ret = request_irq(irq, handler, irq_flags, devname, dev_id);
> +
> +   desc = irq_desc + irq;
> +   desc->status &= ~(IRQ_TYPE_SENSE_MASK | IRQ_LEVEL);
> +   desc->status |= IRQ_TYPE_EDGE_RISING;
> +
> +   return ret;
This looks a bit like a set_irq_type call.
Don't know if this is fully implemented for xics though...
>  }
>  EXPORT_SYMBOL(ibmebus_request_irq);
>
> diff --git a/kernel/irq/chip.c b/kernel/irq/chip.c
> index b7b397a..6d366ca 100644
> --- a/kernel/irq/chip.c
> +++ b/kernel/irq/chip.c
> @@ -430,7 +430,7 @@ handle_fasteoi_irq(unsigned int irq, struct
> irq_desc *desc)
>     action = desc->action;
>     if (unlikely(!action || (desc->status & (IRQ_INPROGRESS |
>                     IRQ_DISABLED)))) {
> -      desc->status |= IRQ_PENDING;
> +      desc->status |= IRQ_PENDING | IRQ_MASKED;
>        if (desc->chip->mask)
>           desc->chip->mask(irq);
>        goto out;
> @@ -439,9 +439,10 @@ handle_fasteoi_irq(unsigned int irq, struct
> irq_desc *desc)
>     desc->status |= IRQ_INPROGRESS;
>     /*
>      * In the threaded case we fall back to a mask+eoi sequence:
> +    * excepted for edge interrupts which are not masked.
>      */
>     if (redirect_hardirq(desc)) {
> -      if (desc->chip->mask)
> +      if (desc->chip->mask && !(desc->status & IRQ_TYPE_EDGE_BOTH))
>           desc->chip->mask(irq);
>        goto out;
>     }
> diff --git a/kernel/irq/manage.c b/kernel/irq/manage.c
> index 3bffa20..3e39c71 100644
> --- a/kernel/irq/manage.c
> +++ b/kernel/irq/manage.c
> @@ -788,9 +788,12 @@ static void do_hardirq(struct irq_desc *desc)
>        thread_simple_irq(desc);
>     else if (desc->handle_irq == handle_level_irq)
>        thread_level_irq(desc);
> -   else if (desc->handle_irq == handle_fasteoi_irq)
> -      thread_fasteoi_irq(desc);
> -   else if (desc->handle_irq == handle_edge_irq)
> +   else if (desc->handle_irq == handle_fasteoi_irq) {
> +      if (desc->status & IRQ_TYPE_EDGE_BOTH)
> +         thread_edge_irq(desc);
> +      else
> +         thread_fasteoi_irq(desc);
> +   } else if (desc->handle_irq == handle_edge_irq)
>        thread_edge_irq(desc);
>     else
>        thread_do_irq(desc);
> --
> 1.6.0.1.308.gede4c
>
According to the specs at some point in the system the HEA IRQs have a edge
characteristic.
But since PCI-E edge and level can both be forwarded through a message
interface
(HEA is not PCI-E, it's only connected to the same internal bus, where the
PHB resides)

Anybody from the xics experts want to comment on this?



Gruss / Regards
Christoph R.  & Jan-Bernd

