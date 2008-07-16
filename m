Return-Path: <linux-kernel-owner+w=401wt.eu-S1755313AbYGPEIe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755313AbYGPEIe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2008 00:08:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751061AbYGPEIZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jul 2008 00:08:25 -0400
Received: from py-out-1112.google.com ([64.233.166.183]:61423 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750750AbYGPEIZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2008 00:08:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=NQQ3v90mnHzMg/07K1uyEZU2hKGlQt/mXDnNEtTRmHUArrB/fdKrU0D/sOeKT9zScG
         BR1HkAiA64gegYR3n97UvRQ9+4jdJ8Vc0BmOHYwF6oY4MwElnZJHie4ndjhTiY+AqyYP
         VVZMb2rHQyBpVpAePrWSvJzoRL2mkaeHz5Pos=
Message-ID: <aecf5e530807152108j22ab557fw267469a0820973fe@mail.gmail.com>
Date: Wed, 16 Jul 2008 09:38:23 +0530
From: "sasa sasa" <sasak.1983@gmail.com>
To: "Ben Dooks" <ben-linux@fluff.org>
Subject: Re: Set_up irq problem while using gpio
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20080715123228.GG24620@fluff.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <aecf5e530807142304m60ef0cb2pe1c3592ae1abc7eb@mail.gmail.com>
	 <20080715123228.GG24620@fluff.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ben,

> Hmm, I thought (when implementing the s3c24xx irq support) that
> requesting the IRQ should change the pin mode appropriately.

Does it mean that whenever we request gpio as interruot pin, it should
allow that request, no matter whether that gpio pin is already
occupied in other modes.
I think, it should return error like set_irq_type do. Internally both
set_irq_type and set_type do the same work, calls chip's set_type
function.

Regards
sasa

On Tue, Jul 15, 2008 at 6:02 PM, Ben Dooks <ben-linux@fluff.org> wrote:
> On Tue, Jul 15, 2008 at 11:34:23AM +0530, sasa sasa wrote:
>> Hi,
>>
>> I have query that the below patch has to applied on irq/manage.c file or not.
>> --- kernel_old/irq/manage.c 2008-02-07 22:11:14.000000000 +0530
>> +++ kernel_new/irq/manage.c 2008-02-07 22:19:14.000000000 +0530
>> @@ -349,8 +349,14 @@
>>         /* Setup the type (level, edge polarity) if configured: */
>>         if (new->flags & IRQF_TRIGGER_MASK) {
>>             if (desc->chip && desc->chip->set_type)
>> -               desc->chip->set_type(irq,
>> -                       new->flags & IRQF_TRIGGER_MASK);
>> +           {
>> +               if((desc->chip->set_type(irq,
>> +                       new->flags & IRQF_TRIGGER_MASK)))
>> +               {
>> +                   spin_unlock_irqrestore(&desc->lock, flags);
>> +                   return -ESPIPE;
>> +               }
>> +           }
>
> this is difficult to read, a better way would be to
>
>        ret = desc->chip->set_type(irq, new->flags & IRQF_TRIGGER_MASK)
>        if (ret) {
>                spin_unlock_irqrestore(&desc->lock, flags);
>                return ret;
>        }
>
>
> If set_type() is meant to return an error, this should have been done
> from the start, instead of being ignored.
>
> tbh, the code could be further cleaned up by holding
> the (new->flags & IRQF_TRIGGER_MASK in a variable such as new_trigger
> which would stop the problem of wrapping lines...
>
>> The reason is that in case of gpio pins used as interrupt pin but that
>> pin has already been ocuupied in other mode (like alternate function
>> mode or in software mode) by other device. In that case, some error
>> mechanism must be there, if we are requesting that gpio pin as
>> interrupt through request_irq function.
>
> Hmm, I thought (when implementing the s3c24xx irq support) that
> requesting the IRQ should change the pin mode appropriately.
>
> --
> Ben (ben@fluff.org, http://www.fluff.org/)
>
>  'a smiley only costs 4 bytes'
>
