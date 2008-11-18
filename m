Return-Path: <linux-kernel-owner+w=401wt.eu-S1752713AbYKRTAg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752713AbYKRTAg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2008 14:00:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751997AbYKRTA1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Nov 2008 14:00:27 -0500
Received: from wf-out-1314.google.com ([209.85.200.175]:63839 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751778AbYKRTA0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2008 14:00:26 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=lRFrbaOiBwEFzyF32yQMRS/9SLDiX7aiv7Ki8Q1WavSbCh63AwMVJZ5I8NdZz4kEYj
         HaPhqhbYKN4pf4g5LT3yVayu3n/fJ+WDuhVJjsARspoOark7YOLRqqYSPLVqd+qrKRkF
         F1R8o6jSggIGErRZHx/M5cTRc0Zh9wslbyzLQ=
Message-ID: <e9c3a7c20811181100q27af85ey49823ba326e70a09@mail.gmail.com>
Date: Tue, 18 Nov 2008 12:00:25 -0700
From: "Dan Williams" <dan.j.williams@intel.com>
To: "Nicolas Ferre" <nicolas.ferre@atmel.com>
Subject: Re: [PATCH] dmaengine: at_hdmac: new driver for the Atmel AHB DMA Controller
Cc: "Sosnowski, Maciej" <maciej.sosnowski@intel.com>,
       "Linux Kernel list" <linux-kernel@vger.kernel.org>,
       "ARM Linux Mailing List" <linux-arm-kernel@lists.arm.linux.org.uk>,
       "Haavard Skinnemoen" <hskinnemoen@atmel.com>,
       "Andrew Victor" <linux@maxim.org.za>
In-Reply-To: <491DA8AC.5010703@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <48F8B291.1060500@atmel.com>
	 <1224530326.27425.25.camel@dwillia2-linux.ch.intel.com>
	 <491DA8AC.5010703@atmel.com>
X-Google-Sender-Auth: 8b2c390a603b30a3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 14, 2008 at 9:34 AM, Nicolas Ferre <nicolas.ferre@atmel.com> wrote:
>>>  include/linux/at_hdmac.h                |   26 +
>>
>> ...this header should be moved somewhere under arch/arm/include.
>
> This is where dw_dmac.h resides. Moreover, if one day this IP is implemented
> on a different architecture, it will be good not to reach it through
> arch/arm path.

Ok, I won't gate acceptance on this since dw_dmac already set the
precedent, but shouldn't the header move after the IP has been
duplicated?  Just my 2cents.

>>> +               memset(desc, 0, sizeof(struct at_desc));
>>> +               dma_async_tx_descriptor_init(&desc->txd, chan);
>>> +               async_tx_ack(&desc->txd);
>>
>> the DMA_CTRL_ACK bit is under control of the client.  It should be
>> read-only to the driver (except for extra descriptors that the driver
>> creates on behalf of the client).
>
> This is precisely where the descriptors are been created so, I thought it
> should be ok to initialize this bit. Am I right ?
>

They will be acknowledged by client code.  Calls like async_memcpy
assume that the the ack bit is clear by default so they can specify
some actions to run at completion time.  By setting it early, at
descriptor allocation time, async_tx will get confused.

>>> +/**
>>> + * atc_alloc_chan_resources - allocate resources for DMA channel
>>> + * @chan: allocate descriptor resources for this channel
>>> + * @client: current client requesting the channel be ready for requests
>>> + *
>>> + * return - the number of allocated descriptors
>>> + */
>>> +static int atc_alloc_chan_resources(struct dma_chan *chan,
>>> +                                   struct dma_client *client)
>>> +{
>>> +       struct at_dma_chan      *atchan = to_at_dma_chan(chan);
>>> +       struct at_dma           *atdma = to_at_dma(chan->device);
>>> +       struct at_desc          *desc;
>>> +       int                     i;
>>> +       LIST_HEAD(tmp_list);
>>> +
>>> +       dev_vdbg(&chan->dev, "alloc_chan_resources\n");
>>> +
>
> [TAG]
>
>>> +       /* ASSERT:  channel is idle */
>>> +       if (atc_chan_is_enabled(atchan)) {
>>> +               dev_dbg(&chan->dev, "DMA channel not idle ?\n");
>>> +               return -EIO;
>>> +       }
>
> [/TAG]
>
>>> +
>>> +       /* have we already been set up? */
>>> +       if (!list_empty(&atchan->free_list))
>>> +               return atchan->descs_allocated;
>>> +
>>> +       /* Allocate initial pool of descriptors */
>>> +       for (i = 0; i < INIT_NR_DESCS_PER_CHANNEL; i++) {
>>> +               desc = atc_alloc_descriptor(chan, GFP_KERNEL);
>>> +               if (!desc) {
>>> +                       dev_err(atdma->dma_common.dev,
>>> +                               "Only %d initial descriptors\n", i);
>>> +                       break;
>>> +               }
>>> +               list_add_tail(&desc->desc_node, &tmp_list);
>>> +       }
>>> +
>>> +       spin_lock_bh(&atchan->lock);
>>> +       atchan->descs_allocated = i;
>>> +       list_splice(&tmp_list, &atchan->free_list);
>>> +       atchan->completed_cookie = chan->cookie = 1;
>>> +       spin_unlock_bh(&atchan->lock);
>>> +
>>> +       /* channel parameters */
>>> +       channel_writel(atchan, CFG, ATC_DEFAULT_CFG);
>>> +
>>> +       tasklet_init(&atchan->tasklet, atc_tasklet, (unsigned
>>> long)atchan);
>>
>> This routine may be called while the channel is already active,
>> potentially causing tasklet_init() to be called while a tasklet is
>> pending.  Can this move to at_dma_probe()?
>
> Oh, really ? In [TAG] above, I protect the call of this function when
> channel is enabled. Is the code at [TAG] ok ?

Yes, but it still feels like something that should be moved to the
probe routine.  In any event with the dmaengine rework I posted
recently [1] ->device_alloc_chan_resources() will no longer be called
multiple times without a ->free_chan_resources() inbetween.

> I will regenerate a new patch as soon as you acknowledge my comments.
>
> Thanks for your help, kind regards,

Thanks Nicolas.

Regards,
Dan

[1] http://marc.info/?l=linux-kernel&m=122669881026508&w=2
