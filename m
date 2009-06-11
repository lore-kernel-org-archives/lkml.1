Return-Path: <linux-kernel-owner+w=401wt.eu-S1755161AbZFKVgF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755161AbZFKVgF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jun 2009 17:36:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751748AbZFKVfz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Jun 2009 17:35:55 -0400
Received: from mail-ew0-f210.google.com ([209.85.219.210]:42786 "EHLO
	mail-ew0-f210.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751567AbZFKVfy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jun 2009 17:35:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:sender:reply-to:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=e2ZFZQEtUp3+RSna8Msf745CrzBg5yitZvatpqDQBQ+KgQYZ9mVcSnz8gHdg/fHL2H
         VQEl+AgQ9SRkGehkoAJ9AxEuguppi4a38qpiBiRzQ9ABSYXkl1+XwCgk9OOFALZI6OxW
         Gb1lEHAUHhGekTqJkoIoCdKhP2fCm8WnrbgN0=
MIME-Version: 1.0
Reply-To: Tobias_Mueller@twam.info
In-Reply-To: <20090611172850.6c418b1d@mycelium.queued.net>
References: <20090610001033.27b7f69f@mycelium.queued.net>
	 <17be05570906111152j3ecb0102qfd6f53221c7ae9f9@mail.gmail.com>
	 <20090611160059.6d70f54a@mycelium.queued.net>
	 <17be05570906111311s717f126cyd4edf0847b839eef@mail.gmail.com>
	 <20090611172850.6c418b1d@mycelium.queued.net>
Date: Thu, 11 Jun 2009 23:35:55 +0200
X-Google-Sender-Auth: 57bad158ba451854
Message-ID: <17be05570906111435p3d4dfb52p67669e8a82a1ab56@mail.gmail.com>
Subject: Re: [PATCH 1/2] cs5535-gpio: add AMD CS5535/CS5536 GPIO driver 
	support
From: =?UTF-8?Q?Tobias_M=C3=BCller?= <Tobias_Mueller@twam.info>
To: Andres Salomon <dilinger@collabora.co.uk>
Cc: akpm@linux-foundation.org, Randy Dunlap <randy.dunlap@oracle.com>,
       deepak@laptop.org, Takashi Iwai <tiwai@suse.de>,
       linux-kernel@vger.kernel.org, linux-geode@lists.infradead.org,
       jordan@cosmicpenguin.net, cjb@laptop.org,
       David Brownell <david-b@pacbell.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> /**
>> * Some GPIO pins
>> *  31-29,23 : reserved (always mask out)
>> *  28       : Power Button
>> *  26       : PME#
>> *  22-16    : LPC
>> *  14,15    : SMBus
>> *  9,8      : UART1
>> *  7        : PCI INTB
>> *  3,4      : UART2/DDC
>> *  2        : IDE_IRQ0
>> *  1        : AC_BEEP
>> *  0        : PCI INTA
>> *
>> * If a mask was not specified, be conservative and only allow:
>> *  1,2,5,6,10-13,24,25,27
>> */
>>
>> I'll add this in my patch to clear it out.
>>
>
> But why are you being conservative in the first place?  If something's
> using GPIOs, unless they're unmapped, you should allow it to use them
> without requiring a boot arg.
>
> For example, OLPC uses GPIO 7 for its DCON IRQ.  With the masking
> scheme, OLPC will need to set that mask from the default.  I don't see
> the point of having the mask at all if other drivers in the kernel are
> going to be requesting GPIOs (presumably they know what they're doing).
Hmm... OK, this makes sense. So default mask allow everything exept
reserved pins and pin 28 (power button).

I think the mask is quite useful if you've critical things on GPIO pins
and they should be changeable (especially from userspace and when
non-root users are allowed to use userspace gpio).

>> >> +     /* disable output aux 1 & 2 on this pin */
>> >> +     __cs5535_gpio_clear(chip, offset, GPIO_OUTPUT_AUX1);
>> >> +     __cs5535_gpio_clear(chip, offset, GPIO_OUTPUT_AUX2);
>> >> +
>> >> +     /* disable input aux 1 on this pin */
>> >> +     __cs5535_gpio_clear(chip, offset, GPIO_INPUT_AUX1);
>> >> +
>> >> +     /* disable output */
>> >> +     __cs5535_gpio_clear(chip, offset, GPIO_OUTPUT_ENABLE);
>> >> +
>> >> +     /* enable input */
>> >> +     __cs5535_gpio_set(chip, offset, GPIO_INPUT_ENABLE);
>> >
>> > I don't think this is the right place for all of this.  Your earlier
>> > email mentioned disabling OUT_AUX{1,2} for outputs, and IN_AUX for
>> > inputs.  I'm fine with doing that here, but I don't see why you're
>> > also disabling output and enabling input by default.
>>
>> I mentioned this in an ealier mail too. When I request the GPIO from
>> userspace the direction file always contains "in", so I thought
>> this is the standard direction after resetting as I should be in a
>> defined state after requesting. But I didn't found anything
>> about this in GPIO lib documentation, so I would be fine to change
>> this if there is any common default behavoir.
>
> To be honest, I'd have to play around with it a bit before I
> knew whether it actually breaks anything or not. I'm not sure if
> it would break anything on OLPC, and I don't have any other geode
> machines that do anything interesting w/ GPIOs.
>
> Maybe David can clear up whether this behavior is correct from the
> userspace GPIO usage standpoint..
This would be nice. But I wouldn't have a problem when those
two statements are removed. I just thought it's better to put them
in a defined state.
