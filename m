Return-Path: <linux-kernel-owner+w=401wt.eu-S1761681AbYGAXly@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761681AbYGAXly (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2008 19:41:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754095AbYGAXlp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jul 2008 19:41:45 -0400
Received: from yw-out-2324.google.com ([74.125.46.30]:29722 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755397AbYGAXlo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2008 19:41:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=DznULZdBcvXVxOASuikYkPrhfrtrtpUIb/rHZwTVqRIKEEWroetlOtvKG4xzWl1TKP
         56NZZTG6hk4/2WQi14ndWt86HkjiodyZ+EmH3n67ceBmpiFstHqSthjBpoWG8t1GoZwL
         7IiCHxlmdLiNZCzMQ/PERvswTW9r8Dig5ZWBg=
Message-ID: <e9c3a7c20807011641u2de28aa8k23fc2c74797adb2a@mail.gmail.com>
Date: Tue, 1 Jul 2008 16:41:34 -0700
From: "Dan Williams" <dan.j.williams@intel.com>
To: saeed <saeed@marvell.com>
Subject: Re: [PATCH/RFC] DMA engine driver for Marvell XOR engine
Cc: "Sosnowski, Maciej" <maciej.sosnowski@intel.com>,
       "Nicolas Pitre" <nico@cam.org>,
       "Lennert Buytenhek" <buytenh@wantstofly.org>,
       "Russell King" <linux@arm.linux.org.uk>,
       lkml <linux-kernel@vger.kernel.org>
In-Reply-To: <alpine.DEB.0.99.0807010430480.9671@ubuntu-saeed.il.marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <7F38996F7185A24AB9071ED4950AD8C101BEE6CD@swsmsx413.ger.corp.intel.com>
	 <alpine.DEB.0.99.0807010430480.9671@ubuntu-saeed.il.marvell.com>
X-Google-Sender-Auth: 998c68ed892f6e59
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 1, 2008 at 9:07 AM, saeed <saeed@marvell.com> wrote:
>> > +   int num_descs_in_pool = plat_data->pool_size/MV_XOR_SLOT_SIZE;
>> > +
>> > +   /* Allocate descriptor slots */
>> > +   do {
>> > +           idx = mv_chan->slots_allocated;
>> > +           if (idx == num_descs_in_pool)
>> > +                   break;
>>
>> This break condition is actually redundant to the do-while loop
>> condition.
>> What about replacing do-while with simpler while loop?
> I did that, but know I found some problem with this code which was
> copied from the iop-adma. what bothers me that if we exit the loop from
> the break, then we end with idx=mv_chan->slots_allocated=num_descs_in_pool,
>  but, if we exit from the while condition, then we end with
> idx=mv_chan->slots_allocated - 1 = num_descs_in_pool - 1
> Dan, can you comment?

The admittedly ugly do { } while () loop in iop-adma.c assumed that
num_descs_in_pool is always > 1, and guarantees that idx is equal to
the count of allocated descriptors.  Since you changed it to a simple
while() loop then you should also replace idx with ->slots_allocated
in the rest of the routine i.e.:

     return mv_chan->slots_allocated ? : -ENOMEM;

>> MV_XOR_SLOT_SIZE];
>> > +
>> > +   tx = mv_xor_prep_dma_memcpy(dma_chan, dest_dma, src_dma,
>> > +                               MV_XOR_TEST_SIZE, 0);
>> > +   cookie = mv_xor_tx_submit(tx);
>>
>> It would be more generic solution in both _self_test() functions
>> to use dma_device API and async_tx API rather than
>> direct calls like mv_xor_alloc_chan_resources(),
>> mv_xor_prep_dma_memcpy(),
>> mv_xor_tx_submit(), mv_xor_issue_pending()
>> (i.e. replace mv_xor_alloc_chan_resources
>> with device->common.device_alloc_chan_resources, etc.)
> again, this is copy&paste from iop-adma, I suggest to keep it this way,
> and to do what you suggest in seperate patch set. and I think that the
> test code better be removed from the low level drivers to the DMA Engine
> layer.
> agree?
>

I agree, keep it this way for now and then we can look to unify all
the drivers' self test routines into a common dmaengine routine for
2.6.28.

>>
>> > +   if (dma_has_cap(DMA_MEMCPY, dma_dev->cap_mask)) {
>> > +           ret = mv_xor_memcpy_self_test(adev);
>> > +           dev_dbg(&pdev->dev, "memcpy self test returned %d\n",
>> ret);
>> > +           if (ret)
>> > +                   goto err_free_dma;
>> > +   }
>> > +
>> > +   if (dma_has_cap(DMA_XOR, dma_dev->cap_mask) ||
>> > +           dma_has_cap(DMA_MEMSET, dma_dev->cap_mask)) {
>> > +           ret = mv_xor_xor_self_test(adev);
>> > +           dev_dbg(&pdev->dev, "xor self test returned %d\n", ret);
>> > +           if (ret)
>> > +                   goto err_free_dma;
>> > +   }
>> > +   if (dma_has_cap(DMA_MEMCPY, dma_dev->cap_mask)) {
>> > +           ret = mv_xor_memcpy_self_test(adev);
>> > +           dev_dbg(&pdev->dev, "memcpy self test returned %d\n",
>> ret);
>> > +           if (ret)
>> > +                   goto err_free_dma;
>> > +   }
>> > +
>> > +   if (dma_has_cap(DMA_XOR, dma_dev->cap_mask) ||
>> > +           dma_has_cap(DMA_MEMSET, dma_dev->cap_mask)) {
>> > +           ret = mv_xor_xor_self_test(adev);
>> > +           dev_dbg(&pdev->dev, "xor self test returned %d\n", ret);
>> > +           if (ret)
>> > +                   goto err_free_dma;
>> > +   }
>>
>> What is the reason for running exact the same memcpy/xor self_test
>> procedure two times?
>> It would be helpful if there was a comment on that in this place.
> no reason, I did that for debug and forgot to remove, I also removed the
> || dma_has_cap (MEMSET) from the xor self test; another stupid copy&paste

Yes, this is an architecture specific aspect of the iop-adma driver.
On an iop the channel may be a memcpy only channel, or an xor / memset
channel.  Hence the need for two separate tests.

--
Dan
