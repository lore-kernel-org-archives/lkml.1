Return-Path: <linux-kernel-owner+w=401wt.eu-S1755707AbZARXqc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755707AbZARXqc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Jan 2009 18:46:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753516AbZARXqS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Jan 2009 18:46:18 -0500
Received: from wf-out-1314.google.com ([209.85.200.168]:44998 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753293AbZARXqQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Jan 2009 18:46:16 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=hLMSlZi6jMrYytHof/BFsK9QtyTWNdmpmxQE/MWqKJdvJSJO5K/hz+ktOTXl0iMSpQ
         1bUf9Y8a0u9tWK94OnDkBjUmNS4yhAFfo8Nc9Mf2tEZQJ+MgRhXpaCekDo96yAiUVkO6
         m2S5MFfgkqg335iFE3XSjkb6E3CUUHAeawSmI=
MIME-Version: 1.0
In-Reply-To: <49738B8C.7020404@bluewatersys.com>
References: <12321862383405-git-send-email-jayakumar.lkml@gmail.com>
	 <49738B8C.7020404@bluewatersys.com>
Date: Mon, 19 Jan 2009 07:46:14 +0800
Message-ID: <45a44e480901181546t140f7127hb2f2b5fbfdec8464@mail.gmail.com>
Subject: Re: [RFC 2.6.28 1/2] gpiolib: add set/get batch v4
From: Jaya Kumar <jayakumar.lkml@gmail.com>
To: Ryan Mallon <ryan@bluewatersys.com>
Cc: David Brownell <david-b@pacbell.net>, Eric Miao <eric.miao@marvell.com>,
       Paulius Zaleckas <paulius.zaleckas@teltonika.lt>,
       Geert Uytterhoeven <geert@linux-m68k.org>,
       Sam Ravnborg <sam@ravnborg.org>,
       linux-arm-kernel@lists.arm.linux.org.uk,
       linux-fbdev-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       linux-embedded@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 19, 2009 at 4:05 AM, Ryan Mallon <ryan@bluewatersys.com> wrote:
> Jaya Kumar wrote:
>> Hi friends,
>>
>
>> +
>> +     /* BATCH GPIO OUTPUT */
>> +int gpio_set_batch(unsigned gpio, u32 values, u32 bitmask, int maskwidth);
>> +
>> +The following examples help explain how this function is to be used.
>> + Q: How to set gpio pins 0 through 7 to all 0? (8 bits)
>> + A: gpio_set_batch(gpio=0, values=0x0, bitmask=0xFF, width=8);
>> + Q: How to set gpio pins 58 through 73 to all 1? (16 bits)
>> + A: gpio_set_batch(gpio=58, values=0xFFFF, bitmask=0xFFFF, width=16);
>> + Q: How to set gpio pins 16 through 47 to 0xCAFEC001? (32 bits)
>> + A: gpio_set_batch(gpio=16, values=0xCAFEC001, bitmask=0xFFFFFFFF, width=32);
>> +
>
> Can the gpio_set_batch function be used to set non-consecutive gpios?
> For example:
>
>  gpio_set_batch(0, 0x0, 0x88, 8);
>
> To clear gpios 3 and 7? It looks like the pxa implementation will

Hi Ryan,

For the first part, yes, it can do non-consecutive gpios by using the
mask. Pins 3 and 7 are handled using a 5-bit mask. You'd  do
gpio_set_batch(3 <- starting pin is gpio 3, 0x0 <- clear, 0x1F <-
mask, 5 <- bit width of mask);

> support this, but can it be guaranteed for other architectures? If so,

That's a tough question. My basic answer would be yes because I've
provided the generic set_batch handler that just uses single bit sets
to achieve it. See __generic_gpio_set_batch() in patch). But if your
question is deeper, ie: can it be optimized for other architectures? ;
then I think I have to handwave a bit. I believe it can, as most of
the CPUs I've seen expose gpio via a set register and clear register
with variation between a context register to select which bank/module
of gpios is being accessed versus just having a pool of set and clear
registers (like pxa). If a CPU didn't have this and just had a blanket
gpio register then the implementation would have to first read the
previous register value (or cache it) in order to support doing the
mask.

> can we put an example in the documentation. If not, can we make it clear

Good point. I'll put it in the docs.

> that you shouldn't do this in the documentation. Also , in the latter
> case is it necessary to pass the bitmask, since it will just be ((1 <<
> bitwidth) - 1)?

Yes, it is as you have non-consecutive bits. In the above case the
mask width is 5 bits, but 3 bits are masked off, so we need the mask
so that the caller can tell us which bits are masked off.

Thanks,
jaya
