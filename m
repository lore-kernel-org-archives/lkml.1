Return-Path: <linux-kernel-owner+w=401wt.eu-S1754566AbYKNQfi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754566AbYKNQfi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2008 11:35:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752169AbYKNQfS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Nov 2008 11:35:18 -0500
Received: from mail.atmel.fr ([81.80.104.162]:56800 "EHLO atmel-es2.atmel.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751957AbYKNQfP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2008 11:35:15 -0500
Message-ID: <491DA8AC.5010703@atmel.com>
Date: Fri, 14 Nov 2008 17:34:52 +0100
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Thunderbird 2.0.0.17 (Windows/20080914)
MIME-Version: 1.0
To: Dan Williams <dan.j.williams@intel.com>,
       "Sosnowski, Maciej" <maciej.sosnowski@intel.com>
CC: Linux Kernel list <linux-kernel@vger.kernel.org>,
       ARM Linux Mailing List 
	<linux-arm-kernel@lists.arm.linux.org.uk>,
       Haavard Skinnemoen <hskinnemoen@atmel.com>,
       Andrew Victor <linux@maxim.org.za>
Subject: Re: [PATCH] dmaengine: at_hdmac: new driver for the Atmel AHB DMA
 Controller
References: <48F8B291.1060500@atmel.com> <1224530326.27425.25.camel@dwillia2-linux.ch.intel.com>
In-Reply-To: <1224530326.27425.25.camel@dwillia2-linux.ch.intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dan,

Thanks a lot for your feedback.

Dan Williams :
> On Fri, 2008-10-17 at 08:43 -0700, Nicolas Ferre wrote:
>> This AHB DMA Controller (aka HDMA or DMAC on AT91 systems) is availlable on
>> at91sam9rl chip. It will be used on other products in the future.
>>
>> This first release covers only the memory-to-memory tranfer type. This is the
>> only tranfer type supported by this chip.
>> On other products, it will be used also for peripheral DMA transfer (slave API
>> support to come).
>>
>> I used dmatest client without problem in different configurations to test
>> it.
>>
>> Full documentation for this controller can be found in the SAM9RL datasheet :
>> http://www.atmel.com/dyn/products/product_card.asp?part_id=4243
>>
>> Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
>> ---
> 
> Hi Nicolas,
> 
> A few comments below.
> 
> Also, checkpatch reported:
> 
> total: 4 errors, 45 warnings, 1475 lines checked
> 
> ...mostly 80 column warnings (some you may want to take a look at).

I reviewed this and manage to reduce most of 80 column warnings. An 
error remains but it is a space in "if" statement and it is for 
alignment purpose.


> Regards,
> Dan
> 
>>  arch/arm/mach-at91/at91sam9rl_devices.c |   47 ++
>>  drivers/dma/Kconfig                     |    8 +
>>  drivers/dma/Makefile                    |    1 +
>>  drivers/dma/at_hdmac.c                  |  989 +++++++++++++++++++++++++++++++
>>  drivers/dma/at_hdmac_regs.h             |  377 ++++++++++++
>>  include/linux/at_hdmac.h                |   26 +
> 
> ...this header should be moved somewhere under arch/arm/include.

This is where dw_dmac.h resides. Moreover, if one day this IP is 
implemented on a different architecture, it will be good not to reach it 
through arch/arm path.

[..]

>> +/**
>> + * atc_alloc_descriptor - allocate and return an initilized descriptor
>> + * @chan: the channel to allocate descriptors for
>> + * @gfp_flags: GFP allocation flags
>> + */
>> +static struct at_desc *atc_alloc_descriptor(struct dma_chan *chan,
>> +                                           gfp_t gfp_flags)
>> +{
>> +       struct at_desc  *desc = NULL;
>> +       struct at_dma   *atdma = to_at_dma(chan->device);
>> +       dma_addr_t phys;
>> +
>> +       desc = dma_pool_alloc(atdma->dma_desc_pool, gfp_flags, &phys);
>> +       if (desc) {
>> +               BUG_ON(phys & 0x3UL); /* descriptors have to be word aligned */
> 
> hmm, yes this is a bug but can't we trust that dma_pool_alloc does its
> job correctly?

Indeed, it was mainly for debugging purpose, I remove it.


>> +               memset(desc, 0, sizeof(struct at_desc));
>> +               dma_async_tx_descriptor_init(&desc->txd, chan);
>> +               async_tx_ack(&desc->txd);
> 
> the DMA_CTRL_ACK bit is under control of the client.  It should be
> read-only to the driver (except for extra descriptors that the driver
> creates on behalf of the client).

This is precisely where the descriptors are been created so, I thought 
it should be ok to initialize this bit. Am I right ?

[..]

>> +static irqreturn_t at_dma_interrupt(int irq, void *dev_id)
>> +{
>> +       struct at_dma           *atdma = (struct at_dma *)dev_id;
>> +       struct at_dma_chan      *atchan;
>> +       int                     i;
>> +       u32                     status, pending, imr;
>> +       int                     ret = IRQ_NONE;
>> +
>> +       do {
>> +               imr = dma_readl(atdma, EBCIMR);
>> +               status = dma_readl(atdma, EBCISR);
>> +               pending = status & imr;
>> +
>> +               if (!pending)
>> +                       break;
>> +
>> +               dev_vdbg(atdma->dma_common.dev,
>> +                       "interrupt: status = 0x%08x, 0x%08x, 0x%08x\n",
>> +                        status, imr, pending);
>> +
>> +               for (i = 0; i < atdma->dma_common.chancnt; i++) {
>> +                       atchan = &atdma->chan[i];
>> +                       if (pending & (AT_DMA_CBTC(i) | AT_DMA_ERR(i))) {
>> +                               if (pending & AT_DMA_ERR(i)) {
>> +                                       /*
>> +                                       spin_lock(atchan->lock);
>> +                                       atchan->error_status = 1;
>> +                                       spin_unlock(atchan->lock);
> 
> writing to an unsigned long should already be atomic, no?

On ARM yes, on other architectures, I do not know...
Anyway, I removed those commented lines.

[..]

>> +/**
>> + * atc_alloc_chan_resources - allocate resources for DMA channel
>> + * @chan: allocate descriptor resources for this channel
>> + * @client: current client requesting the channel be ready for requests
>> + *
>> + * return - the number of allocated descriptors
>> + */
>> +static int atc_alloc_chan_resources(struct dma_chan *chan,
>> +                                   struct dma_client *client)
>> +{
>> +       struct at_dma_chan      *atchan = to_at_dma_chan(chan);
>> +       struct at_dma           *atdma = to_at_dma(chan->device);
>> +       struct at_desc          *desc;
>> +       int                     i;
>> +       LIST_HEAD(tmp_list);
>> +
>> +       dev_vdbg(&chan->dev, "alloc_chan_resources\n");
>> +

[TAG]

>> +       /* ASSERT:  channel is idle */
>> +       if (atc_chan_is_enabled(atchan)) {
>> +               dev_dbg(&chan->dev, "DMA channel not idle ?\n");
>> +               return -EIO;
>> +       }

[/TAG]

>> +
>> +       /* have we already been set up? */
>> +       if (!list_empty(&atchan->free_list))
>> +               return atchan->descs_allocated;
>> +
>> +       /* Allocate initial pool of descriptors */
>> +       for (i = 0; i < INIT_NR_DESCS_PER_CHANNEL; i++) {
>> +               desc = atc_alloc_descriptor(chan, GFP_KERNEL);
>> +               if (!desc) {
>> +                       dev_err(atdma->dma_common.dev,
>> +                               "Only %d initial descriptors\n", i);
>> +                       break;
>> +               }
>> +               list_add_tail(&desc->desc_node, &tmp_list);
>> +       }
>> +
>> +       spin_lock_bh(&atchan->lock);
>> +       atchan->descs_allocated = i;
>> +       list_splice(&tmp_list, &atchan->free_list);
>> +       atchan->completed_cookie = chan->cookie = 1;
>> +       spin_unlock_bh(&atchan->lock);
>> +
>> +       /* channel parameters */
>> +       channel_writel(atchan, CFG, ATC_DEFAULT_CFG);
>> +
>> +       tasklet_init(&atchan->tasklet, atc_tasklet, (unsigned long)atchan);
> 
> This routine may be called while the channel is already active,
> potentially causing tasklet_init() to be called while a tasklet is
> pending.  Can this move to at_dma_probe()?

Oh, really ? In [TAG] above, I protect the call of this function when 
channel is enabled. Is the code at [TAG] ok ?

Ok, so I move all this.

>> +       /* clear any pending interrupt */
>> +       while (dma_readl(atdma, EBCISR))
>> +               cpu_relax();
>> +       atc_enable_irq(atchan);
> 
> ditto.

Ok.


I will regenerate a new patch as soon as you acknowledge my comments.

Thanks for your help, kind regards,
-- 
Nicolas Ferre

