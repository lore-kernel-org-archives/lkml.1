Return-Path: <linux-kernel-owner+w=401wt.eu-S1758447AbZJLWZh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758447AbZJLWZh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Oct 2009 18:25:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757242AbZJLWZg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Oct 2009 18:25:36 -0400
Received: from mail-vw0-f203.google.com ([209.85.212.203]:35122 "EHLO
	mail-vw0-f203.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757182AbZJLWZf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Oct 2009 18:25:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=XarcA55rIYiBDPy4+BTX8IQBqn9Jxveg+29mKcZU9BKnQna9BK1rGq50NfODKYddve
         2KI+ueNdOoxhfyTTxysJCvid8GLmqKRxweRPsHuuaMLmlCKjA6BD6Z8gfU6iPreeEFDD
         4KEaUQx19Ny7E1PWHkxGeKlpp4KqkDsGP31ps=
MIME-Version: 1.0
In-Reply-To: <1255078843-24958-1-git-send-email-linus.walleij@stericsson.com>
References: <1255078843-24958-1-git-send-email-linus.walleij@stericsson.com>
Date: Mon, 12 Oct 2009 15:24:57 -0700
X-Google-Sender-Auth: 82090d5a65691c54
Message-ID: <e9c3a7c20910121524l5a2207b9h840142c6793dad6e@mail.gmail.com>
Subject: Re: [PATCH] Add COH 901 318 DMA block driver v2
From: Dan Williams <dan.j.williams@intel.com>
To: Linus Walleij <linus.walleij@stericsson.com>
Cc: Maciej Sosnowski <maciej.sosnowski@intel.com>,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Sorry for the delay, comments below.

Regards,
Dan

On Fri, Oct 9, 2009 at 2:00 AM, Linus Walleij
<linus.walleij@stericsson.com> wrote:
> This patch adds support for the ST-Ericsson COH 901 318 DMA block,
> found in the U300 series platforms. It registers a DMA slave for
> device I/O and also a memcpy slave for memcpy.
>
> Signed-off-by: Linus Walleij <linus.walleij@stericsson.com>
> ---
[..]
> diff --git a/drivers/dma/Kconfig b/drivers/dma/Kconfig
> index 5903a88..25d3c54 100644
> --- a/drivers/dma/Kconfig
> +++ b/drivers/dma/Kconfig
> @@ -109,6 +109,14 @@ config SH_DMAE
>        help
>          Enable support for the Renesas SuperH DMA controllers.
>
> +config COH901318
> +       bool "ST-Ericsson COH901318 DMA support"
> +       select DMA_ENGINE
> +       depends on ARCH_U300
> +       default y if ARCH_U300

I am not a fan of default 'y' for dma drivers because they can
interact with different subsystems in different ways.  It should be a
conscious selection.

> diff --git a/drivers/dma/coh901318.c b/drivers/dma/coh901318.c
> new file mode 100644
> index 0000000..3fa3d95
> --- /dev/null
> +++ b/drivers/dma/coh901318.c
[..]
> +#ifdef VERBOSE_DEBUG
> +static void coh901318_list_print(struct coh901318_chan *cohc,
> +                                struct coh901318_lli *lli)
> +{
> +       struct coh901318_lli *l;
> +       dma_addr_t addr =  virt_to_phys(list);
> +       int i = 0;
> +
> +       while (addr) {
> +               l = phys_to_virt(addr);
> +               dev_info(COHC_2_DEV(cohc), "i %d, lli %p, ctrl 0x%x, src 0x%x"
> +                        ", dst 0x%x, link 0x%x link_virt 0x%p\n",
> +                        i, l, l->control, l->src_addr, l->dst_addr,
> +                        l->link_addr, phys_to_virt(l->link_addr));
> +               i++;
> +               addr = l->link_addr;
> +       }
> +}
> +#else
> +#define coh901318_list_print(cohc, lli)
> +#endif

I did an experiment to see if this would compile away if the dev_info
was changed to dev_vdbg... no such luck it still does the loop
infrastructure because addr is unknown at compile time.  But I did
find:

     drivers/dma/coh901318.c:77: error: 'list' undeclared (first use
in this function)

So, maybe something like the following to get compile coverage on the
debug bits:
-#ifdef VERBOSE_DEBUG
 static void coh901318_list_print(struct coh901318_chan *cohc,
                                 struct coh901318_lli *lli)
 {
        struct coh901318_lli *l;
-       dma_addr_t addr =  virt_to_phys(list);
+       dma_addr_t addr = virt_to_phys(lli);
        int i = 0;

+       #ifndef VERBOSE_DEBUG
+       addr = 0;
+       #endif
+
        while (addr) {
                l = phys_to_virt(addr);
-               dev_info(COHC_2_DEV(cohc), "i %d, lli %p, ctrl 0x%x, src 0x%x"
+               dev_vdbg(COHC_2_DEV(cohc), "i %d, lli %p, ctrl 0x%x, src 0x%x"
                         ", dst 0x%x, link 0x%x link_virt 0x%p\n",
                         i, l, l->control, l->src_addr, l->dst_addr,
                         l->link_addr, phys_to_virt(l->link_addr));
@@ -88,9 +91,6 @@ static void coh901318_list_print(struct coh901318_chan *cohc,
                addr = l->link_addr;
        }
 }
-#else
-#define coh901318_list_print(cohc, lli)
-#endif

[..]

> +/* called from interrupt context */
> +static void dma_tc_handle(struct coh901318_chan *cohc)
> +{
> +       BUG_ON(!cohc->allocated && (list_empty(&cohc->active) ||
> +                                   list_empty(&cohc->queue)));
> +
> +       if (!cohc->allocated)
> +               return;
> +
> +       BUG_ON(cohc->pending_irqs == 0);
> +
> +       cohc->pending_irqs--;
> +       cohc->nbr_active_done++;
> +
> +       if (cohc->pending_irqs == 0 && coh901318_queue_start(cohc) == NULL)
> +               cohc->busy = 0;
> +
> +       BUG_ON(list_empty(&cohc->active));
> +
> +       if (cohc_chan_conf(cohc)->priority_high)
> +               tasklet_hi_schedule(&cohc->tasklet);
> +       else
> +               tasklet_schedule(&cohc->tasklet);
> +}
> +

Just curious, can you say a bit about why this driver needs two
tasklet priority levels?

> +
> +static irqreturn_t dma_irq_handler(int irq, void *dev_id)
> +{
> +       u32 status1;
> +       u32 status2;
> +       int i;
> +       int ch;
> +       struct coh901318_base *base  = dev_id;
> +       struct coh901318_chan *cohc;
> +       void *virtbase = base->virtbase;
> +
> +       status1 = readl(virtbase + COH901318_INT_STATUS1);
> +       status2 = readl(virtbase + COH901318_INT_STATUS2);
> +
> +       rmb();

I notice that wmb() is used liberally throughout the driver, so I came
here looking for the corresponding rmb().  I question whether they are
necessary as these reads will flush any pending writes.  wmb()
devolves to barrier()  on !SMP and since the compiler will not reorder
readl() and writel() calls (due to volatile) I do not see the point of
the barriers?

> +
> +       if (unlikely(status1 == 0 && status2 == 0)) {
> +               dev_warn(base->dev, "spurious DMA IRQ from no channel!\n");
> +               return IRQ_HANDLED;
> +       }
> +
[..]
> +int coh901318_channel_link(struct dma_chan *chan, struct dma_chan *chan_dest,
> +                          int size)
> +{
> +       struct coh901318_chan *cohc = to_coh901318_chan(chan);
> +       struct coh901318_chan *cohc_dst = to_coh901318_chan(chan_dest);
> +       int err = 0;
> +       u32 ctrl = cohc_chan_param(cohc)->ctrl_lli_chained;
> +       u32 config = cohc_chan_param(cohc)->config;
> +       struct coh901318_lli lli;
> +       unsigned long flags;
> +       spin_lock_irqsave(&cohc->lock, flags);
> +
> +       dev_vdbg(COHC_2_DEV(cohc),
> +                "[%s] chan_src %d chan_dst %d, size %d\n",
> +                __func__, cohc->id, cohc_dst->id, size);
> +
> +       /* TODO: Add support for size != -1 */
> +       if (size != -1) {
> +               err = -EINVAL;
> +               goto out;
> +       }
> +
> +       ctrl &= ~COH901318_CX_CTRL_MASTER_MODE_MASK;
> +       ctrl |= cohc_chan_param(cohc_dst)->ctrl_lli_chained &
> +               COH901318_CX_CTRL_MASTER_MODE_MASK;
> +
> +       /* transfer between two peripheral, src and dest is constant */
> +       ctrl &= ~COH901318_CX_CTRL_SRC_ADDR_INC_ENABLE;
> +       ctrl &= ~COH901318_CX_CTRL_DST_ADDR_INC_ENABLE;
> +
> +       /* set COH901318_CX_CTRL_PRDD_SOURCE */
> +       ctrl &= ~COH901318_CX_CTRL_PRDD_DEST;
> +
> +       /* Handshake both two primary and secondary peripheral */
> +       ctrl |= COH901318_CX_CTRL_HSP_ENABLE;
> +       ctrl |= COH901318_CX_CTRL_HSS_ENABLE;
> +
> +       config |= COH901318_CX_CFG_RM_PRIMARY_TO_SECONDARY;
> +       config |= cohc_dst->id << COH901318_CX_CFG_LCRF_SHIFT;
> +
> +       if (size == -1)
> +               ctrl &= ~COH901318_CX_CTRL_TC_ENABLE;
> +
> +       coh901318_set_conf(cohc, config);
> +       lli.control = ctrl;
> +       lli.src_addr = cohc_dev_addr(cohc);
> +       lli.dst_addr = cohc_dev_addr(cohc_dst);
> +       lli.link_addr = 0;
> +
> +       coh901318_list_print(cohc, &lli);
> +
> +       coh901318_prep_linked_list(cohc, &lli);
> +
> +       coh901318_start(cohc);
> +
> + out:
> +       spin_unlock_irqrestore(&cohc->lock, flags);
> +       return err;
> +}
> +EXPORT_SYMBOL(coh901318_channel_link);

??

What scenario would you use this functionality?  Let's defer this
piece and the other exported symbols to the (upcoming?) patches that
add users for these exports.

> diff --git a/drivers/dma/coh901318_lli.c b/drivers/dma/coh901318_lli.c
> new file mode 100644
> index 0000000..43fdfcc
> --- /dev/null
> +++ b/drivers/dma/coh901318_lli.c
[..]
> +struct coh901318_lli *
> +coh901318_lli_alloc(struct coh901318_pool *pool, unsigned int len)
> +{
> +       int i;
> +       struct coh901318_lli *head;
> +       struct coh901318_lli *lli;
> +       struct coh901318_lli *lli_prev;
> +       dma_addr_t phy;
> +
> +       if (len == 0)
> +               goto err;
> +
> +       spin_lock(&pool->lock);
> +
> +       head = dma_pool_alloc(pool->dmapool, GFP_ATOMIC, &phy);

I have the nagging suspicion that many GFP_ATOMIC calls across the
kernel can be downgraded to GFP_NOWAIT, especially for dmaengines.  In
the memcpy offload case the code simply falls back to a cpu memcpy
when a descriptor cannot be allocated.  Allocating from emergency
memory pools to save a few cpu cycles is overkill.

> diff --git a/include/linux/coh901318.h b/include/linux/coh901318.h
> new file mode 100644
> index 0000000..ca9ab68
> --- /dev/null
> +++ b/include/linux/coh901318.h

I do not think this file belongs in include/linux/.  How about
arch/arm/mach-u300/include/mach/?

> +/**
> + * struct dma_channel - dma channel base
> + * @name: ascii name of dma channel
> + * @number: channel id number
> + * @desc_nbr_max: number of preallocated descriptortors
> + * @priority_high: prio of channel, 0 low otherwise high.
> + * @param: configuration parameters
> + * @dev_addr: physical address of periphal connected to channel
> + */
> +struct dma_channel {
> +       const char name[32];
> +       const int number;
> +       const int desc_nbr_max;
> +       const int priority_high;
> +       const struct coh901318_params param;
> +       const dma_addr_t dev_addr;
> +};

This is a fairly generic name for a architecture specific object.  How
about coh_dma_channel instead?

> +
> +/**
> + * dma_access_memory_state_t - register dma for memory access
> + *
> + * @active:  1 means dma intends to access memory
> + *           0 means dma wont access memory
> + */
> +typedef void (*dma_access_memory_state_t)(bool active);
> +

??

Odd, the callee does not need to know which device is signaling its
desire for memory access?
