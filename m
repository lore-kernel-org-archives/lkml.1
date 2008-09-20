Return-Path: <linux-kernel-owner+w=401wt.eu-S1753740AbYITVkv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753740AbYITVkv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Sep 2008 17:40:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751470AbYITVkn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 20 Sep 2008 17:40:43 -0400
Received: from mail-gx0-f16.google.com ([209.85.217.16]:51001 "EHLO
	mail-gx0-f16.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751392AbYITVkm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Sep 2008 17:40:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=pwpFE9Yuhm6uzYWPU5z5dxpOvaJXv6EYCkAKxH1XfyvW0pWS3S81xEW7nW+av3bRgS
         UbfdiH4cl5clMPhJ4IIkn8TbFd7+oE1CvRsF5yhjRIpvYwJfFf1HlOsFW93T0c4rLkgs
         8MH+r/GerHSews8PXY2bQrHvaw1tScvanBpvQ=
Message-ID: <e9c3a7c20809201440t739ea58enede8d0d6a70f5118@mail.gmail.com>
Date: Sat, 20 Sep 2008 14:40:40 -0700
From: "Dan Williams" <dan.j.williams@intel.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: [PATCH] dmatest: properly handle duplicate DMA channels
Cc: "Timur Tabi" <timur@freescale.com>, haavard.skinnemoen@atmel.com,
       linux-kernel@vger.kernel.org
In-Reply-To: <20080919163145.de9866ac.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1221751279-24936-1-git-send-email-timur@freescale.com>
	 <20080919163145.de9866ac.akpm@linux-foundation.org>
X-Google-Sender-Auth: 7415b61a911cf7cd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 19, 2008 at 4:31 PM, Andrew Morton
<akpm@linux-foundation.org> wrote:
> On Thu, 18 Sep 2008 10:21:19 -0500
> Timur Tabi <timur@freescale.com> wrote:
>
>> --- a/drivers/dma/dmatest.c
>> +++ b/drivers/dma/dmatest.c
>> @@ -321,10 +321,15 @@ static void dmatest_cleanup_channel(struct dmatest_chan *dtc)
>>
>>  static enum dma_state_client dmatest_add_channel(struct dma_chan *chan)
>>  {
>> -     struct dmatest_chan     *dtc;
>> +     struct dmatest_chan     *dtc, *_dtc;
>>       struct dmatest_thread   *thread;
>>       unsigned int            i;
>>
>> +     /* Have we already been told about this channel? */
>> +     list_for_each_entry_safe(dtc, _dtc, &dmatest_channels, node)
>> +             if (dtc->chan == chan)
>> +                     return DMA_DUP;
>> +
>>       dtc = kmalloc(sizeof(struct dmatest_chan), GFP_ATOMIC);
>>       if (!dtc) {
>>               pr_warning("dmatest: No memory for %s\n", chan->dev.bus_id);
>
> hm.  A few lines after that GFP_ATOMIC the driver does a GFP_KERNEL
> allocation.
>
> One of them is incorrect.  The interface is undocumented (natch), but I
> assume that GFP_KERNEL is the one to use here.
>

The interface is documented, although not the locking (natch), at
include/linux/dmaengine.h:229.  When I fix this up is there a
canonical location to document a callback interface rather than at the
callback's typedef?

Thanks,
Dan
