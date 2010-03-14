Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753386Ab0CNF52 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Mar 2010 00:57:28 -0500
Received: from hera.kernel.org ([140.211.167.34]:59218 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751169Ab0CNF50 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Mar 2010 00:57:26 -0500
Message-ID: <4B9C7A77.80901@kernel.org>
Date: Sat, 13 Mar 2010 21:56:07 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.8) Gecko/20100228 SUSE/3.0.3-1.1.1 Thunderbird/3.0.3
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, mingo@redhat.com, hpa@zytor.com,
       tglx@linutronix.de, lars@metafoo.de
CC: linux-tip-commits@vger.kernel.org
Subject: Re: [tip:irq/urgent] genirq: Prevent oneshot irq thread race
References: <tip-0b1adaa031a55e44f5dd942f234bf09d28e8a0d6@git.kernel.org>
In-Reply-To: <tip-0b1adaa031a55e44f5dd942f234bf09d28e8a0d6@git.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/10/2010 08:57 AM, tip-bot for Thomas Gleixner wrote:
> Commit-ID:  0b1adaa031a55e44f5dd942f234bf09d28e8a0d6
> Gitweb:     http://git.kernel.org/tip/0b1adaa031a55e44f5dd942f234bf09d28e8a0d6
> Author:     Thomas Gleixner <tglx@linutronix.de>
> AuthorDate: Tue, 9 Mar 2010 19:45:54 +0100
> Committer:  Thomas Gleixner <tglx@linutronix.de>
> CommitDate: Wed, 10 Mar 2010 17:45:14 +0100
> 
> genirq: Prevent oneshot irq thread race
> 
> Lars-Peter pointed out that the oneshot threaded interrupt handler
> code has the following race:
> 
>  CPU0                            CPU1
>  hande_level_irq(irq X)
>    mask_ack_irq(irq X)
>    handle_IRQ_event(irq X)
>      wake_up(thread_handler)
>                                  thread handler(irq X) runs
>                                  finalize_oneshot(irq X)
> 				  does not unmask due to 
> 				  !(desc->status & IRQ_MASKED)
> 
>  return from irq
>  does not unmask due to
>  (desc->status & IRQ_ONESHOT)
>   				  
> This leaves the interrupt line masked forever. 
> 
> The reason for this is the inconsistent handling of the IRQ_MASKED
> flag. Instead of setting it in the mask function the oneshot support
> sets the flag after waking up the irq thread.
> 
> The solution for this is to set/clear the IRQ_MASKED status whenever
> we mask/unmask an interrupt line. That's the easy part, but that
> cleanup opens another race:
> 
>  CPU0                            CPU1
>  hande_level_irq(irq)
>    mask_ack_irq(irq)
>    handle_IRQ_event(irq)
>      wake_up(thread_handler)
>                                  thread handler(irq) runs
>                                  finalize_oneshot_irq(irq)
> 				  unmask(irq)
>      irq triggers again
>      handle_level_irq(irq)
>        mask_ack_irq(irq)
>      return from irq due to IRQ_INPROGRESS				  
> 
>  return from irq
>  does not unmask due to
>  (desc->status & IRQ_ONESHOT)
> 
> This requires that we synchronize finalize_oneshot_irq() with the
> primary handler. If IRQ_INPROGESS is set we wait until the primary
> handler on the other CPU has returned before unmasking the interrupt
> line again.
> 
> We probably have never seen that problem because it does not happen on
> UP and on SMP the irqbalancer protects us by pinning the primary
> handler and the thread to the same CPU.
> 
> Reported-by: Lars-Peter Clausen <lars@metafoo.de>
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> Cc: stable@kernel.org
> ---
>  kernel/irq/chip.c   |   31 ++++++++++++++++++++++---------
>  kernel/irq/manage.c |   18 ++++++++++++++++++
>  2 files changed, 40 insertions(+), 9 deletions(-)
> 
> diff --git a/kernel/irq/chip.c b/kernel/irq/chip.c
> index d70394f..71eba24 100644
> --- a/kernel/irq/chip.c
> +++ b/kernel/irq/chip.c
> @@ -359,6 +359,23 @@ static inline void mask_ack_irq(struct irq_desc *desc, int irq)
>  		if (desc->chip->ack)
>  			desc->chip->ack(irq);
>  	}
> +	desc->status |= IRQ_MASKED;
> +}
> +
> +static inline void mask_irq(struct irq_desc *desc, int irq)
> +{
> +	if (desc->chip->mask) {
> +		desc->chip->mask(irq);
> +		desc->status |= IRQ_MASKED;
> +	}
> +}
> +
> +static inline void unmask_irq(struct irq_desc *desc, int irq)
> +{
> +	if (desc->chip->unmask) {
> +		desc->chip->unmask(irq);
> +		desc->status &= ~IRQ_MASKED;
> +	}
>  }

this one will cause cris compiling error...

arch/cris/arch-v10/kernel/irq.c:#define mask_irq(irq_nr) (*R_VECT_MASK_CLR = 1 << (irq_nr));
arch/cris/include/arch-v32/arch/irq.h:void mask_irq(int irq);
arch/mips/nxp/pnx8550/common/int.c:static inline void mask_irq(unsigned int irq_nr)
kernel/irq/chip.c:static inline void mask_irq(struct irq_desc *desc)

because arch/irq.h will be included via linux/irq.h

YH
