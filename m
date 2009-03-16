Return-Path: <linux-kernel-owner+w=401wt.eu-S1762410AbZCPVVT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762410AbZCPVVT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Mar 2009 17:21:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755715AbZCPVU7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Mar 2009 17:20:59 -0400
Received: from wf-out-1314.google.com ([209.85.200.174]:52184 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762114AbZCPVU6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Mar 2009 17:20:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=XbFoBZsH3XLRTm3jfncuWpNGHRQLsANwS4NCMWHt6ZB3KGFUgi5pc4sOiVOzoysnhj
         VTW8y1P935ot4Xmt+FWYX4mdTCbPmXRkysY7ZX1TLmPyIic6QtAuUJFDv3u/yiW+O60M
         q9k/Wiocgu/vL5r9wtOQiKdzFOCEDBQlclMho=
MIME-Version: 1.0
In-Reply-To: <20090227.002436.106263719.anemo@mba.ocn.ne.jp>
References: <1234538938-23479-1-git-send-email-anemo@mba.ocn.ne.jp>
	 <e9c3a7c20902251745t314c1e0cs114d2199ccc8cf36@mail.gmail.com>
	 <20090227.002436.106263719.anemo@mba.ocn.ne.jp>
Date: Mon, 16 Mar 2009 14:20:56 -0700
X-Google-Sender-Auth: f4811340525b1313
Message-ID: <e9c3a7c20903161420u7568e7f9jfb10d518a3ca6fea@mail.gmail.com>
Subject: Re: [PATCH 1/2] dmaengine: TXx9 Soc DMA Controller driver
From: Dan Williams <dan.j.williams@intel.com>
To: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
Cc: linux-mips@linux-mips.org, ralf@linux-mips.org,
       linux-kernel@vger.kernel.org, haavard.skinnemoen@atmel.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 26, 2009 at 8:24 AM, Atsushi Nemoto <anemo@mba.ocn.ne.jp> wrote:
> On Wed, 25 Feb 2009 18:45:28 -0700, Dan Williams <dan.j.williams@intel.com> wrote:
>> Some comments and questions below.
>
> Thank you for review.
>
>> > +static struct txx9dmac_dev *to_txx9dmac_dev(struct dma_device *ddev)
>> > +{
>> > +       if (ddev->device_prep_dma_memcpy)
>> > +               return container_of(ddev, struct txx9dmac_dev, dma_memcpy);
>> > +       return container_of(ddev, struct txx9dmac_dev, dma);
>> > +}
>>
>> Can you explain why you need two dma_devices per txx9dmac_dev?  My
>> initial reaction is that it should be a bug if callers to
>> to_txx9dmac_dev() don't know what type of channel they are holding.
>
> I created two dma_devices: one for private slave dma channels and one
> for public memcpy channel.  I will explain later in this mail.
>
>> > +       dma_async_tx_descriptor_init(&desc->txd, &dc->chan);
>> > +       desc->txd.tx_submit = txx9dmac_tx_submit;
>> > +       desc->txd.flags = DMA_CTRL_ACK;
>> > +       INIT_LIST_HEAD(&desc->txd.tx_list);
>> > +       desc->txd.phys = dma_map_single(chan2parent(&dc->chan), &desc->hwdesc,
>> > +                                       ddev->descsize, DMA_TO_DEVICE);
>> > +       return desc;
>> > +}
>>
>> By setting DMA_CTRL_ACK by default this means that async_tx can never
>> attach attach a dependent operation to a txx9 descriptor.  This may
>> not be a problem in practice because async_tx will only do this to
>> satisfy inter-channel dependencies.  For example memcpy on chan-foo
>> followed by xor on chan-bar.  For future proofing the driver I would
>> rely on clients properly setting the ack bit when they call
>> ->device_prep_dma_memcpy
>
> The desc->txd.flags will be overwritten in txx9dmac_prep_xxx.  The
> reason setting DMA_CTRL_ACK here is to make the desc can be pulled
> from freelist in txx9dmac_desc_get().

Thanks for clarification...

> Maybe I should move this DMA_CTRL_ACK setting to txx9dmac_desc_put()?

Perhaps a comment.  I think this scheme is ok, it just raised alarm
bells as I read it.

[..]
>> > +static irqreturn_t txx9dmac_interrupt(int irq, void *dev_id)
>> > +{
>> > +#ifdef TXX9_DMA_HAVE_IRQ_PER_CHAN
>> > +       struct txx9dmac_chan *dc = dev_id;
>> > +
>> > +       dev_vdbg(chan2dev(&dc->chan), "interrupt: status=%#x\n",
>> > +                       channel_readl(dc, CSR));
>> > +
>> > +       tasklet_schedule(&dc->tasklet);
>> > +#else
>> > +       struct txx9dmac_dev *ddev = dev_id;
>> > +
>> > +       dev_vdbg(ddev->dma.dev, "interrupt: status=%#x\n",
>> > +                       dma_readl(ddev, MCR));
>> > +
>> > +       tasklet_schedule(&ddev->tasklet);
>> > +#endif
>> > +       /*
>> > +        * Just disable the interrupts. We'll turn them back on in the
>> > +        * softirq handler.
>> > +        */
>> > +       disable_irq_nosync(irq);
>> > +
>> > +       return IRQ_HANDLED;
>> > +}
>>
>> Why do you need to disable interrupts here?
>
> Because interrupts are not cleared until txx9dmac_tasklet() calls
> txx9dmac_scan_descriptors() and it writes to CSR.  Touching CSR in
> txx9dmac_interrupt() seems bad while dc->lock spinlock does not
> protect from interrupts.  I chose calling disable_irq here instead of
> replace all spin_lock with spin_lock_irqsave.

I believe in this case you are protected by the fact this IRQ handler
will not race against itself, i.e. even though other interrupts are
enabled this handler will be masked until it returns.

>
>> > +       dev_vdbg(chan2dev(chan), "alloc_chan_resources\n");
>> > +
>> > +       if (chan == &ddev->reserved_chan) {
>> > +               /* reserved */
>> > +               return 0;
>> > +       }
>>
>> Can you explain how reserved channels work?  It looks like you are
>> working around the generic dma channel allocator, maybe it requires
>> updating to meet your needs.
>
> OK, let me try to explain.  This DMAC have four channels and one FIFO
> buffer.  Each channel can be configured for memory-memory or
> device-memory transfer, but only one channel can do alignment-free
> memory-memory transfer at a time while the channel should occupy the
> FIFO buffer for effective transfers.
>
> Instead of dynamically assign the FIFO buffer to channels, I chose
> make one dedicated channel for memory-memory transfer.  The dedicated
> channel is public.  Other channels are private and used for slave
> transfer.  Some devices in the SoC are wired to certain DMA channel.
> The platform code will give a channel number for memory-memory
> transfer via platform_data.
>
> The txx9dmac_probe() creates two dma_device: one for private slave
> channels and one for a public memory channel.  It also creates five
> dma_chan: four dma_chan are wrapped by txx9dmac_chan and other one
> dma_chan is used to reserve a memcpy channel number in slave
> dma_device.
>
> For example, if channel 2 was selected for memcpy, the dma_device for
> slave (txx9dmac_dev.dma) contains txx9dmac_chan[0,1], reserved_chan
> and txx9dmac_chan[3] in this order and the dma_device for memcpy
> (txx9dmac_dev.dma_memcpy) contains txx9dmac_chan[2].
>
> Now we have dma0chan0, dma0chan1, dma0chan2, dma0chan3 and dma1chan0.
>
> The txx9dmac_probe() calls dma_request_channel() to reserve dma0chan2.
>
> I need the reserved_chan to make channel 3 named "dma0chan3".  If I
> can chose chan_id for each channels in dma_device, the reserved_chan
> is not needed.

Can you post the code that communicates chan_id to the routine calling
dma_request_channel?  I am not understanding why you need to control
chan_id.  Why not have the filter_fn passed to dma_request_channel
ignore non-private devices?

> And if I could make only one channel in dma_device public, I need only
> one dma_device.  But I suppose it is not easy while DMA_PRIVATE is not
> per-channel attribute now.

Yes, that would be awkward given how the other capability bits are handled.

--
Dan
