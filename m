Return-Path: <linux-kernel-owner+w=401wt.eu-S1759594AbXIMKNU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759594AbXIMKNU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2007 06:13:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751958AbXIMKNN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Sep 2007 06:13:13 -0400
Received: from az33egw01.freescale.net ([192.88.158.102]:38510 "EHLO
	az33egw01.freescale.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751868AbXIMKNM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2007 06:13:12 -0400
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH 5/5] Add DMA engine driver for Freescale MPC85xxprocessors.
Date: Thu, 13 Sep 2007 18:13:06 +0800
Message-ID: <46B96294322F7D458F9648B60E15112C85D8A5@zch01exm26.fsl.freescale.net>
In-Reply-To: <20070907223553.GA18599@freescale.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH 5/5] Add DMA engine driver for Freescale MPC85xxprocessors.
Thread-Index: Acfxn5HdQjXYBbVHROGi7DPEpw1FvwERGvgg
References: <11891624582950-git-send-email-wei.zhang@freescale.com> <20070907223553.GA18599@freescale.com>
From: "Zhang Wei-r63237" <Wei.Zhang@freescale.com>
To: "Wood Scott-B07421" <scottwood@freescale.com>, <dan.j.williams@intel.com>
Cc: <paulus@samba.org>, <shannon.nelson@intel.com>, <linuxppc-dev@ozlabs.org>,
       <linux-kernel@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, 

> > +static void fsl_dma_set_src(dma_addr_t addr,
> > +				struct dma_async_tx_descriptor 
> *tx, int index)
> > +{
> 
> What is index supposed to mean?  It's not used, or documented 
> anywhere than
> I can see.

I've also got more document here. Hi, Dan, could you give me some
explanation about this API? :)

> 
> > +		else {
> > +			/* Run the link descriptor callback function */
> > +			if (desc->async_tx.callback) {
> > +				
> spin_unlock_irqrestore(&fsl_chan->desc_lock,
> > +								flags);
> > +				dev_dbg(fsl_chan->device->dev,
> > +					"link descriptor %p 
> callback\n", desc);
> > +				desc->async_tx.callback(
> > +						
> desc->async_tx.callback_param);
> > +				
> spin_lock_irqsave(&fsl_chan->desc_lock, flags);
> 
> After dropping the lock, you can no longer assume that your 
> iterator is
> still valid; you need to work off of the list head.
> 

list_for_each_entry_safe() is used here. I think the safe should be ok.
:P

> > +	/* Find the first un-transfer desciptor */
> > +	for (ld_node = fsl_chan->ld_queue.next;
> > +		(ld_node != &fsl_chan->ld_queue)
> > +			&& (DMA_SUCCESS == dma_async_is_complete(
> > +					
> to_fsl_desc(ld_node)->async_tx.cookie,
> > +					fsl_chan->completed_cookie,
> > +					fsl_chan->common.cookie));
> > +		ld_node = ld_node->next);
> 
> Call fsl_dma_is_complete directly, don't waste time going through the
> virtual call.
> 
> And you have a recursive lock usage here; fsl_dma_is_complete calls
> fsl_chan_ld_cleanup, which acquires desc_lock, but you 
> already have it.
> 
> Couldn't you just call fsl_chan_ld_cleanup, and then check 
> what's at the
> head of the list?
> 

I'll split interrupt and poll here.

> > +static irqreturn_t fsl_dma_do_interrupt(int irq, void *data)
> > +{
> > +	struct fsl_dma_device *fdev = (struct fsl_dma_device *)data;
> > +	struct fsl_dma_chan *fsl_chan = NULL;
> > +	u32 gsr;
> > +	int ch_nr;
> > +	struct dma_chan *int_chan;
> > +
> > +	gsr = (fdev->feature & FSL_DMA_BIG_ENDIAN) ? 
> in_be32(fdev->reg_base)
> > +			: in_le32(fdev->reg_base);
> > +	ch_nr = (32 - ffs(gsr)) / 8;
> > +
> > +	list_for_each_entry(int_chan, &fdev->common.channels, 
> device_node)
> > +		if (to_fsl_chan(int_chan)->id == ch_nr)
> > +			fsl_chan = to_fsl_chan(int_chan);
> 
> Why not use an array of channels?

The list is used in dma engine core file. And it's possible that there
are not all channel listed in dts and array.

> > +
> > +	return fsl_chan ? fsl_dma_chan_do_interrupt(irq, 
> fsl_chan) : IRQ_NONE;
> > +
> > +}
> > +
> > +static void dma_do_tasklet(unsigned long unused)
> > +{
> > +	struct fsl_desc_sw *desc, *_desc;
> > +	unsigned long flags;
> > +
> > +	spin_lock_irqsave(&recy_ln_lock, flags);
> > +	list_for_each_entry_safe(desc, _desc, &recy_ln_chain, node) {
> > +		struct fsl_dma_chan *fsl_chan =
> > +					
> to_fsl_chan(desc->async_tx.chan);
> > +		/* Run the link descriptor callback function */
> > +		if (desc->async_tx.callback) {
> > +			spin_unlock_irqrestore(&recy_ln_lock, flags);
> > +			dev_dbg(fsl_chan->device->dev,
> > +				"dma_tasklet: link descriptor 
> %p callback\n",
> > +				desc);
> > +			desc->async_tx.callback(
> > +					desc->async_tx.callback_param);
> > +			spin_lock_irqsave(&recy_ln_lock, flags);
> > +		}
> > +		/* Recycle it! */
> > +		list_del(&desc->node);
> 
> You should remove it from the list before dropping the lock, 
> as otherwise
> something else could come along and remove it again.

All right!

> 
> > +	if (strcmp(match->compatible, "fsl,mpc8540-dma-channel") == 0)
> > +		new_fsl_chan->feature = FSL_DMA_IP_86XX | 
> FSL_DMA_BIG_ENDIAN;
> 
> Shouldn't it be 85XX, to be consistent?
> 
> > +	else if (strcmp(match->compatible, 
> "fsl,mpc8349-dma-channel") == 0)
> > +		new_fsl_chan->feature = FSL_DMA_IP_83XX | 
> FSL_DMA_LITTLE_ENDIAN;
> 
> You could have the features be part of the match struct, so 
> you don't have
> to do extra strcmps.
> 

Can I use the data field of struct of_device_id?

> 
> > +static struct of_device_id of_fsl_dma_ids[] = {
> > +	{ .compatible = "fsl,dma", },
> > +};
> 
> Why do we need to bind to the parent node at all?

Yes, the MPC83xx should get interrupt source from DMA device register.

> 
> > +/* There is no asm instructions for 64 bits reverse loads 
> and stores */
> > +static u64 in_le64(const u64 __iomem *addr)
> > +{
> > +	return le64_to_cpu(in_be64(addr));
> > +}
> > +
> > +static void out_le64(u64 __iomem *addr, u64 val)
> > +{
> > +	out_be64(addr, cpu_to_le64(val));
> > +}
> > +#endif
> 
> You can use asm instructions for this, as such:

Aha, they are just copied from io.h.

> 
> static u64 in_le64(const u64 __iomem *addr)
> {
> 	return ((u64)in_le32((u32 *)addr + 1) << 32) | 
> (in_le32((u32 *)addr));
> }
> 
> 
> static void out_le64(u64 __iomem *addr, u64 val)
> {
> 	out_le32((u32 *)addr, (u32)val);
> 	out_le32((u32 *)addr + 1, val >> 32);
> }
> 

And I agree with your other comments.

Thanks a lot!
- zw
