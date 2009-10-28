Return-Path: <linux-kernel-owner+w=401wt.eu-S932724AbZJ1Ib2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932724AbZJ1Ib2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Oct 2009 04:31:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932687AbZJ1Ib1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Oct 2009 04:31:27 -0400
Received: from mail-bw0-f227.google.com ([209.85.218.227]:40032 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932674AbZJ1IbZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Oct 2009 04:31:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=lrvi2Ltg3WaHgb4ORIKsJw3SPDvRoSDyPzCttL2KiS0Cmh1Q+1UxAXvjn/Plhsn61/
         ZKXGbdRKGfD+WSKSVVSCuKmHkb0s158zJ+SXj8q4IGogJWTcBH/N+nXd1ijO6MyX/VnN
         fg6bPabZcHWxev3oSyuEzx+BOGr+2GU+u6wOc=
MIME-Version: 1.0
In-Reply-To: <e9c3a7c20910121524l5a2207b9h840142c6793dad6e@mail.gmail.com>
References: <1255078843-24958-1-git-send-email-linus.walleij@stericsson.com>
	 <e9c3a7c20910121524l5a2207b9h840142c6793dad6e@mail.gmail.com>
Date: Wed, 28 Oct 2009 09:31:29 +0100
Message-ID: <63386a3d0910280131k5043648fu600a223936cd081a@mail.gmail.com>
Subject: Re: [PATCH] Add COH 901 318 DMA block driver v2
From: Linus Walleij <linus.ml.walleij@gmail.com>
To: Dan Williams <dan.j.williams@intel.com>
Cc: Linus Walleij <linus.walleij@stericsson.com>,
       Maciej Sosnowski <maciej.sosnowski@intel.com>,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dan, thanks *a lot* for the review, a v3 version will follow
shortly, hopefully
this will be mainline material. Most remarks have been fixed, some notices
below...

2009/10/13 Dan Williams <dan.j.williams@intel.com>:

>> +       if (cohc_chan_conf(cohc)->priority_high)
>> +               tasklet_hi_schedule(&cohc->tasklet);
>> +       else
>> +               tasklet_schedule(&cohc->tasklet);
>> +}
>> +
>
> Just curious, can you say a bit about why this driver needs two
> tasklet priority levels?

It is a safety precaution but perhaps we're overdoing it.
The high prio channels are used to transfer audio data during a
voice call from the application subsystem to the modem in the
U300 platforms (one of the most user-annoying things in an interactive
system is when audio skips so this must never happen). We haven't
really made any measurements to see if this is a real-world issue
and whether the tasklet prio levels helps in some corner case.
(Having the entire audio path under DMA helps a lot though.)

Also see next answer...

>> +int coh901318_channel_link(struct dma_chan *chan, struct dma_chan *chan_dest,
>> +                          int size)
>> +{
>> +       struct coh901318_chan *cohc = to_coh901318_chan(chan);
>> +       struct coh901318_chan *cohc_dst = to_coh901318_chan(chan_dest);
>> +       int err = 0;
>> +       u32 ctrl = cohc_chan_param(cohc)->ctrl_lli_chained;
>> +       u32 config = cohc_chan_param(cohc)->config;
>> +       struct coh901318_lli lli;
>> +       unsigned long flags;
>> +       spin_lock_irqsave(&cohc->lock, flags);
>> +
>> +       dev_vdbg(COHC_2_DEV(cohc),
>> +                "[%s] chan_src %d chan_dst %d, size %d\n",
>> +                __func__, cohc->id, cohc_dst->id, size);
>> +
>> +       /* TODO: Add support for size != -1 */
>> +       if (size != -1) {
>> +               err = -EINVAL;
>> +               goto out;
>> +       }
>> +
>> +       ctrl &= ~COH901318_CX_CTRL_MASTER_MODE_MASK;
>> +       ctrl |= cohc_chan_param(cohc_dst)->ctrl_lli_chained &
>> +               COH901318_CX_CTRL_MASTER_MODE_MASK;
>> +
>> +       /* transfer between two peripheral, src and dest is constant */
>> +       ctrl &= ~COH901318_CX_CTRL_SRC_ADDR_INC_ENABLE;
>> +       ctrl &= ~COH901318_CX_CTRL_DST_ADDR_INC_ENABLE;
>> +
>> +       /* set COH901318_CX_CTRL_PRDD_SOURCE */
>> +       ctrl &= ~COH901318_CX_CTRL_PRDD_DEST;
>> +
>> +       /* Handshake both two primary and secondary peripheral */
>> +       ctrl |= COH901318_CX_CTRL_HSP_ENABLE;
>> +       ctrl |= COH901318_CX_CTRL_HSS_ENABLE;
>> +
>> +       config |= COH901318_CX_CFG_RM_PRIMARY_TO_SECONDARY;
>> +       config |= cohc_dst->id << COH901318_CX_CFG_LCRF_SHIFT;
>> +
>> +       if (size == -1)
>> +               ctrl &= ~COH901318_CX_CTRL_TC_ENABLE;
>> +
>> +       coh901318_set_conf(cohc, config);
>> +       lli.control = ctrl;
>> +       lli.src_addr = cohc_dev_addr(cohc);
>> +       lli.dst_addr = cohc_dev_addr(cohc_dst);
>> +       lli.link_addr = 0;
>> +
>> +       coh901318_list_print(cohc, &lli);
>> +
>> +       coh901318_prep_linked_list(cohc, &lli);
>> +
>> +       coh901318_start(cohc);
>> +
>> + out:
>> +       spin_unlock_irqrestore(&cohc->lock, flags);
>> +       return err;
>> +}
>> +EXPORT_SYMBOL(coh901318_channel_link);
>
> ??
>
> What scenario would you use this functionality?  Let's defer this
> piece and the other exported symbols to the (upcoming?) patches that
> add users for these exports.

This is used to let the DMA transfer data between two devices without
involving the CPU. For example we use this to transfer audio data
directly from a modem interface to an I2S channel. No memory is
involved, it's just the AMBA bus transmitting bursts from one device to
the other. This offloads the CPU of the entire data shuffle task.

This is a typical feature of embedded DMA and something the we
believe will find its way into the DMAengine sooner or later so we'll
be happy to refactor the code at that point.

We've removed this function and also coh901318_prep_single while
keeping some of the internals like coh901318_get_bytes_left,
coh901318_stop and coh901318_continue.

>> diff --git a/include/linux/coh901318.h b/include/linux/coh901318.h
>> new file mode 100644
>> index 0000000..ca9ab68
>> --- /dev/null
>> +++ b/include/linux/coh901318.h
>
> I do not think this file belongs in include/linux/.  How about
> arch/arm/mach-u300/include/mach/?

This was based on the fact that the other embedded architectures
using the DMA engine has its include file in

include/linux/dw_dmac.h
include/linux/at_hdmac.h

We've moved the header to the mach-u300 include, though this
block can theoretically be used in other hardware.

Do you want a patch moving

include/linux/dw_dmac.h -> arch/avr32/mach-at32ap/include/mach
include/linux/at_hdmac.h ->  arch/arm/mach-at91/include/mach

as well? I can probably fix that, I just love patching up archs I know
nothing about just as entertainment :-)

Linus Walleij
