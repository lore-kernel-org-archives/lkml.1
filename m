Return-Path: <linux-kernel-owner+w=401wt.eu-S1756778AbYCDCdX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756778AbYCDCdX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2008 21:33:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752501AbYCDCdK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Mar 2008 21:33:10 -0500
Received: from qb-out-0506.google.com ([72.14.204.234]:45120 "EHLO
	qb-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751032AbYCDCdI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2008 21:33:08 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=QzcfJxgPzArZk68UpiMVfOE6AqFiwTq3N12aF9AcQAXVBTZZn+JmMNo9s+NM5dXZcX6zdFCS+BvOdcpjCsX1L8hzVsiqEsQYbUSk+Njwz9/RPsTRyOLm92eqGgtV9ceeRNttIAsa7ck92KnqedUAGye8CFk440QkKPt5eEXVE1c=
Message-ID: <47CCB4D8.8090600@gmail.com>
Date: Tue, 04 Mar 2008 11:32:56 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20070801)
MIME-Version: 1.0
To: FUJITA Tomonori <tomof@acm.org>
CC: jens.axboe@oracle.com, fujita.tomonori@lab.ntt.co.jp,
       James.Bottomley@HansenPartnership.com, efault@gmx.de,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org,
       jgarzik@pobox.com, Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: Re: [PATCH] block: fix residual byte count handling
References: <47CC09B6.6090709@gmail.com>	<20080303235207S.tomof@acm.org>	<47CC7F3D.4010605@gmail.com> <20080304111056X.tomof@acm.org>
In-Reply-To: <20080304111056X.tomof@acm.org>
X-Enigmail-Version: 0.95.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

FUJITA Tomonori wrote:
>> Yeah, libata did its own padding and needed to add draining.  Private
>> implementation was complex as hell and James suggested moving them to
>> block layer.  Are you suggesting moving them back to drivers?
> 
> No, I'm not. I've been working on the IOMMUs to remove such
> workarounds in LLDs.
> 
> What drivers need to do on this is just adding a padding length, that
> is, drivers don't need to change the structure of the sg list (like
> splitting a sg entry), right? And it doesn't break the SAS drivers
> that support SATAPI, does it?
> 
> But I agree that drivers want to get a complete sglist so I'm fine
> with adjusting sglist entries in the block layer with your secode
> patch (separate out padding from alignment). As we discussed, I'm fine
> with breaking sum(sg) == rq->data_len as long as rq->data_len means
> the true data length.

As long as the second patch is in, what value rq->data_len indicates
doesn't matter to drivers which don't use explicit padding or draining,
so the situation is much more controlled.  I don't care which value
rq->data_len would indicate.  I'd prefer it equal sum(sg) as that value
is what IDE and libata which will be the major users of padding and/or
draining expect in rq->data_len but fixing up that shouldn't be too
difficult.  I guess this can be determined by Jens.  If Jens likes
rq->data_len to contain requested transfer size, I'll post updated patches.

>>>> buffer after it, it ends up with unaligned sg entry in the middle and
>>>> rq->data_len + rq->extra_len will overrun the sg entry after the drain
>>>> page which is really dangerous.
>>> The drivers know that they use drain buffer. They can take care about
>>> themselves on this too. If we want to do explicitly, we could have
>>> rq->pad_len and rq->drain_len instead of rq->extra_len, though I think
>>> that we are fine without these values because these drivers already
>>> tell the block layer what they want and know that the block layer
>>> gives it.
>> So, if a driver has requested aligning and draining, the driver should
>> extend the sg entry before the last one by the alignment if draining was
>> used for the request and extent the last sg if the draining wasn't used.
>>  I'd rather just implement them in the drivers.
> 
> The block layer extends the sg entry? The drivers just adjust
> sg->length?

Still, do you really wanna force such things into low level drivers?
That will be one extremely fragile API and will be really difficult to
tell when things go wrong.

-- 
tejun
