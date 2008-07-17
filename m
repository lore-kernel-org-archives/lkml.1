Return-Path: <linux-kernel-owner+w=401wt.eu-S1757248AbYGQJVN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757248AbYGQJVN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2008 05:21:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753119AbYGQJU6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jul 2008 05:20:58 -0400
Received: from rv-out-0506.google.com ([209.85.198.232]:4087 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754911AbYGQJU5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2008 05:20:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=jer7U230g/Uo5vjL3rOqS6HyxYybg7JTyC8K6XzE41YrnuX0hltF1s+O3BaNewaORI
         FBjGxNDHPhw/U0ACtoMZAMyN1/0x0Tq5nbN4kvX3q02YGAmMatZ9OYpMfgylApJHcJlV
         U5X0SmNiVw7z8hyQmo3BoSccBrxt9idJcdEFo=
Message-ID: <aecf5e530807170220v5c35c0cen9d105208ff41bcdb@mail.gmail.com>
Date: Thu, 17 Jul 2008 14:50:56 +0530
From: "sasa sasa" <sasak.1983@gmail.com>
To: linux-arm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [BUG]Set_up irq problem while using gpio
In-Reply-To: <aecf5e530807152108j22ab557fw267469a0820973fe@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <aecf5e530807142304m60ef0cb2pe1c3592ae1abc7eb@mail.gmail.com>
	 <20080715123228.GG24620@fluff.org.uk>
	 <aecf5e530807152108j22ab557fw267469a0820973fe@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi ,

I think there is a bug in kernel/irq/manage.c file.
  --- kernel_old/irq/manage.c 2008-02-07 22:11:14.000000000 +0530
 +++ kernel_new/irq/manage.c 2008-02-07 22:19:14.000000000 +0530
 @@ -349,8 +349,14 @@
         /* Setup the type (level, edge polarity) if configured: */
         if (new->flags & IRQF_TRIGGER_MASK) {
             if (desc->chip && desc->chip->set_type)
 -               desc->chip->set_type(irq,
 -                       new->flags & IRQF_TRIGGER_MASK);
 +           {
 +               if((desc->chip->set_type(irq,
 +                       new->flags & IRQF_TRIGGER_MASK)))
 +               {   *p = NULL;
 +                   spin_unlock_irqrestore(&desc->lock, flags);
 +                   return -ESPIPE;
 +               }
 +           }


 The reason is that in case of gpio pins requested as irq pin may be
already ocuupied in other mode (like alternate function mode or in
software mode) by other device. In that case, some error mechanism
must be there, if we are requesting that gpio pin as
 interrupt through request_irq function.

I think, it should return error like set_irq_type do. Internally both
set_irq_type and set_type do the same work, calls chip's set_type
function.

Regards
Sasa
---------- Forwarded message ----------
From: sasa sasa <sasak.1983@gmail.com>
Date: Wed, Jul 16, 2008 at 9:38 AM
Subject: Re: Set_up irq problem while using gpio
To: Ben Dooks <ben-linux@fluff.org>
Cc: linux-kernel@vger.kernel.org


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
