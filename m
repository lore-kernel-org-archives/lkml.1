Return-Path: <linux-kernel-owner+w=401wt.eu-S1758260AbYCCWoh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758260AbYCCWoh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2008 17:44:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753096AbYCCWoZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Mar 2008 17:44:25 -0500
Received: from qb-out-0506.google.com ([72.14.204.226]:38099 "EHLO
	qb-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753557AbYCCWoX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2008 17:44:23 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=NoeGsj2IK5ckGnrueBJ0BJVYUEHVTErNoZNnk3aHO6erdH70cqIAZQ96Fgz3dP3AGDNe1ps2+8Ydyz3Ufjax+HB9cd2RoiVXHc54zlwU2xP/WRzsAbX43/EahHEffSSEdNkT+tGillceDMWVFEgpe1d8j+J9MVzWtEKqHMT060I=
Message-ID: <47CC7F3D.4010605@gmail.com>
Date: Tue, 04 Mar 2008 07:44:13 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20070801)
MIME-Version: 1.0
To: FUJITA Tomonori <tomof@acm.org>
CC: jens.axboe@oracle.com, fujita.tomonori@lab.ntt.co.jp,
       James.Bottomley@HansenPartnership.com, efault@gmx.de,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org,
       jgarzik@pobox.com
Subject: Re: [PATCH] block: fix residual byte count handling
References: <47CC036C.2060902@gmail.com>	<20080303230121M.tomof@acm.org>	<47CC09B6.6090709@gmail.com> <20080303235207S.tomof@acm.org>
In-Reply-To: <20080303235207S.tomof@acm.org>
X-Enigmail-Version: 0.95.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

FUJITA Tomonori wrote:
> On Mon, 03 Mar 2008 23:22:46 +0900
> Tejun Heo <htejun@gmail.com> wrote:
> 
>> FUJITA Tomonori wrote:
>>>> At the end of blk_rq_map_user() together with data_len / extra_len
>>>> mangling or were you talking about James' original patch?
>>> With my patch, at the end of blk_rq_map_user, we have:
>>>
>>> 	if (len & queue_dma_alignment(q)) {
>>> 		unsigned int pad_len = (queue_dma_alignment(q) & ~len) + 1;
>>>
>>> 		rq->extra_len += pad_len;
>>> 	}
>>>
>>>
>>> So no change as compared with 2.6.24?
>> Oh.. you killed sg list manipulation.  Many controllers do allow odd
>> bytes as the last sg entry but not all.  Also, if you append drain
> 
> Until 2.6.24, these drivers have taken care about the issue by
> themselves. There is no change as compared with 2.6.24.

Yeah, libata did its own padding and needed to add draining.  Private
implementation was complex as hell and James suggested moving them to
block layer.  Are you suggesting moving them back to drivers?

>> buffer after it, it ends up with unaligned sg entry in the middle and
>> rq->data_len + rq->extra_len will overrun the sg entry after the drain
>> page which is really dangerous.
> 
> The drivers know that they use drain buffer. They can take care about
> themselves on this too. If we want to do explicitly, we could have
> rq->pad_len and rq->drain_len instead of rq->extra_len, though I think
> that we are fine without these values because these drivers already
> tell the block layer what they want and know that the block layer
> gives it.

So, if a driver has requested aligning and draining, the driver should
extend the sg entry before the last one by the alignment if draining was
used for the request and extent the last sg if the draining wasn't used.
 I'd rather just implement them in the drivers.

-- 
tejun
