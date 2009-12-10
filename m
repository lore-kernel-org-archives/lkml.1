Return-Path: <linux-kernel-owner+w=401wt.eu-S1753114AbZLJA4r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753114AbZLJA4r (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Dec 2009 19:56:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751412AbZLJA4m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Dec 2009 19:56:42 -0500
Received: from mail-ew0-f209.google.com ([209.85.219.209]:36748 "EHLO
	mail-ew0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751020AbZLJA4l convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Dec 2009 19:56:41 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=Jvv+tMHk0nv2WwrUHuWlS5LUTuSQ6fruTW7l3s4v0yMAAzj8D7lkptYF1feNb2iAcu
         cAoCaX9y6xqarhvF+QJVNBTZRj0R/wFz7N4N69DheP3HmuKC/6bT1fnLcoogrwPigjNK
         CTl81rtzJT+DMagFKynJlMtEwyMvd69f/1wEk=
MIME-Version: 1.0
In-Reply-To: <20091209220749.GD8742@kernel.dk>
References: <200912091049.12604.borntraeger@de.ibm.com>
	 <20091209212516.GA6206@fancy-poultry.org>
	 <20091209214501.GC8742@kernel.dk> <20091209220749.GD8742@kernel.dk>
Date: Wed, 9 Dec 2009 19:56:46 -0500
Message-ID: <170fa0d20912091656s31575d0cneaf899e1781bdc16@mail.gmail.com>
Subject: Re: todays git regression (2.6.32-04008.g3ff6a46): lot of device 
	mapper warnings
From: Mike Snitzer <snitzer@gmail.com>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Heinz Diehl <htd@fancy-poultry.org>, linux-kernel@vger.kernel.org,
       martin.petersen@oracle.com,
       Christian Borntraeger <borntraeger@de.ibm.com>, dm-devel@redhat.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 9, 2009 at 5:07 PM, Jens Axboe <jens.axboe@oracle.com> wrote:
> On Wed, Dec 09 2009, Jens Axboe wrote:
>> On Wed, Dec 09 2009, Heinz Diehl wrote:
>> > On 09.12.2009, Christian Borntraeger wrote:
>> >
>> > > with todays git I got a huge amount of warnings for device mapper:
>> > > device-mapper: uevent: version 1.0.3
>> > > device-mapper: ioctl: 4.15.0-ioctl (2009-04-01) initialised: dm-devel@redhat.com
>> > > device-mapper: table: 252:0: target device dasdf1 is misaligned: physical_block_size=4096, logical_block_size=4096, alignment_offset=0, start=196608
>> > [...]
>> >
>> > > The same devices produce no warning with a 2.6.32 vanilla kernel.
>> >
>> > I have exactly the same here...
>>
>> Can either one of you try and bisect it? I've cc'ed Martin, it's likely
>> one of the io stacking patches that causes this.
>
> Does this work?
>
> diff --git a/block/blk-settings.c b/block/blk-settings.c
> index dd1f1e0..0116d29 100644
> --- a/block/blk-settings.c
> +++ b/block/blk-settings.c
> @@ -554,11 +554,13 @@ int blk_stack_limits(struct queue_limits *t, struct queue_limits *b,
>                ret = -1;
>        }
>
> +#if 0
>        if (offset &&
>            (offset & (b->discard_granularity - 1)) != b->discard_alignment) {
>                t->discard_misaligned = 1;
>                ret = -1;
>        }
> +#endif
>
>        /* If top has no alignment offset, inherit from bottom */
>        if (!t->alignment_offset)

Jens,

It should be noted that Christian (original poster but cc's got
dropped) is using striped LVs.

Striped LVs use blk_limits_io_opt() via drivers/md/dm-stripe.c:stripe_io_hints()

Martin's change for discard alignment (commit: 86b37281) also splits
out the least common multiple code, that was exclusively used for
io_opt, to a new lcm() function in block/blk-settings.c

On the surface I thought this might be the reason for the warnings,
but Martin's lcm() looks perfectly fine; can't see why it would cause
these warnings to appear all of a sudden... but I figured I'd share.

It'll be interesting to see if the discard_granularity block you
#ifdef'd out helps either Christian or Heinz.

Mike
