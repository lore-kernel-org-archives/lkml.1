Return-Path: <linux-kernel-owner+w=401wt.eu-S1761321AbYEOUB0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761321AbYEOUB0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2008 16:01:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752116AbYEOUBP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 May 2008 16:01:15 -0400
Received: from yw-out-2324.google.com ([74.125.46.29]:55897 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752122AbYEOUBN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2008 16:01:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=LIhFll4XOpCfohbIBxHiqEOhYyT+pkweD77slbe/pKdfrKtIospbcjvqU3Y+3oqfDnI1XJ5Wuo9L+z/ld0qTBzcTckev6n4bURiV9TqL/IrCjPiaSvGmx/Zwb+Z3/KTZqhg8mQJ8UEgbx9X6HQk/KvEwFlHx17n/hbm2SEc+JWY=
Message-ID: <9a8748490805151301m6dc969f5t73c5285fc4c95466@mail.gmail.com>
Date: Thu, 15 May 2008 22:01:07 +0200
From: "Jesper Juhl" <jesper.juhl@gmail.com>
To: "James Bottomley" <James.Bottomley@hansenpartnership.com>
Subject: Re: scsi_scan: WARNING: at include/linux/blkdev.h:431 blk_queue_init_tags+0x107/0x120()
Cc: "FUJITA Tomonori" <fujita.tomonori@lab.ntt.co.jp>, jens.axboe@oracle.com,
       linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
In-Reply-To: <1210607968.3078.15.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <alpine.LNX.1.00.0805020043130.1489@dragon.funnycrock.com>
	 <20080502111652T.tomof@acm.org>
	 <1210200026.3067.25.camel@localhost.localdomain>
	 <20080508125532W.fujita.tomonori@lab.ntt.co.jp>
	 <1210607968.3078.15.camel@localhost.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

2008/5/12 James Bottomley <James.Bottomley@hansenpartnership.com>:
> On Thu, 2008-05-08 at 12:55 +0900, FUJITA Tomonori wrote:
>> On Wed, 07 May 2008 17:40:26 -0500
>> James Bottomley <James.Bottomley@HansenPartnership.com> wrote:
>> > > The problem is that the commit 75ad23b expects that we hold the queue
>> > > lock for __blk_queue_free_tags, blk_queue_free_tags and
>> > > blk_queue_init_tags but we haven't.
>> > >
>> > > The simple fix is using queue_flag_set/clear_unlocked for them, then
>> > > it should work as before. However, it would be better to hold the
>> > > queue lock for blk_queue_free_tags and blk_queue_init_tags (we can
>> > > hold the queue lock in scsi_activate_tcq and scsi_deactivate_tcq).
>> >
>> > So is this the fix that everyone agrees on?  And if so, whose tree is it
>> > going through (I tend to think block, since the original breakage came
>> > from the block tree).
>>
>> The patch is fine from the perspective of the SCSI mid-layer. But it
>> would be not from the perspective of the block layer. For example,
>> blk_queue_init_tags is expected to be called with holding the queue
>> lock (since it could call blk_queue_resize_tags internally) though
>> only the SCSI mid-layer uses those APIs for now.
>
> There are two cases for blk_queue_init_tags; one is for a shared tag map
> and the other is for individual tag maps.  If you look at the code and
> its use, blk_queue_resize_tags is *only* called for the individual tag
> map case (or for the first caller in a shared tag map case).
>
> The blk_queue_resize_tags() also returns -EBUSY on shared tag maps,
> except the first one; which really exposes a bug in SCSI: we want to set
> the shared tag map to some host specific depth and then carve off pieces
> of it in the devices, so we don't want to adjust the queue down to
> whatever the first seen device wants, and we don't want all other
> devices to fail to adjust the scsi_queue depth the mid-layer uses.
>
> This should fix up scsi.
>
> James
>
> ---
> diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
> index 110e776..cc0af0f 100644
> --- a/drivers/scsi/scsi.c
> +++ b/drivers/scsi/scsi.c
> @@ -893,9 +893,11 @@ void scsi_adjust_queue_depth(struct scsi_device *sdev, int tagged, int tags)
>
>        spin_lock_irqsave(sdev->request_queue->queue_lock, flags);
>
> -       /* Check to see if the queue is managed by the block layer.
> -        * If it is, and we fail to adjust the depth, exit. */
> +       /* Check to see if the queue is managed by the block layer,
> +        * and that we don't have a shared tag map.  If so, and we
> +        * fail to adjust the depth, exit. */
>        if (blk_queue_tagged(sdev->request_queue) &&
> +           !sdev->host->bqt &&
>            blk_queue_resize_tags(sdev->request_queue, tags) != 0)
>                goto out;
>

I just tested this patch by applying it to the tip of Linus' git tree,
recompiled, rebooted and everything seems to be fine.
>From where I'm sitting this looks good.  Thanks James.

Tested-by: Jesper Juhl <jesper.juhl@gmail.com>

-- 
Jesper Juhl <jesper.juhl@gmail.com>
Don't top-post http://www.catb.org/~esr/jargon/html/T/top-post.html
Plain text mails only, please http://www.expita.com/nomime.html
