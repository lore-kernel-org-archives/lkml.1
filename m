Return-Path: <linux-kernel-owner+w=401wt.eu-S1758901AbZFKUMO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758901AbZFKUMO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jun 2009 16:12:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752165AbZFKUMA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Jun 2009 16:12:00 -0400
Received: from mail-ew0-f210.google.com ([209.85.219.210]:32852 "EHLO
	mail-ew0-f210.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751704AbZFKUL7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jun 2009 16:11:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:sender:reply-to:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=G3Qy5RA9oWC7/OOUNGrHST5fjhqV6kd3t/njugzBNdmXKWSJQ6po5AL0/w3kToGUAi
         EIYG36seC8rhlTXntbejTbTN82YIlPAHm7MVu8fIQ+4k/OJ4Gvo98na+wJSZYuapGk5m
         THVglc9oxVom631gD+0ku9fMS3pg+A0MegSj8=
MIME-Version: 1.0
Reply-To: Tobias_Mueller@twam.info
In-Reply-To: <20090611160059.6d70f54a@mycelium.queued.net>
References: <20090610001033.27b7f69f@mycelium.queued.net>
	 <17be05570906111152j3ecb0102qfd6f53221c7ae9f9@mail.gmail.com>
	 <20090611160059.6d70f54a@mycelium.queued.net>
Date: Thu, 11 Jun 2009 22:11:58 +0200
X-Google-Sender-Auth: 60aa7a05ee275c6f
Message-ID: <17be05570906111311s717f126cyd4edf0847b839eef@mail.gmail.com>
Subject: Re: [PATCH 1/2] cs5535-gpio: add AMD CS5535/CS5536 GPIO driver 
	support
From: =?UTF-8?Q?Tobias_M=C3=BCller?= <Tobias_Mueller@twam.info>
To: Andres Salomon <dilinger@collabora.co.uk>
Cc: akpm@linux-foundation.org, Randy Dunlap <randy.dunlap@oracle.com>,
       deepak@laptop.org, Takashi Iwai <tiwai@suse.de>,
       linux-kernel@vger.kernel.org, linux-geode@lists.infradead.org,
       jordan@cosmicpenguin.net, cjb@laptop.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>  #define DRV_NAME "cs5535-gpio"
>>  #define GPIO_BAR 1
>> +#define GPIO_DEFAULT_MASK 0x0B003C66
>
> Where does this mask of available GPIOs originate from?

I had a comment in my original patch:

/**
* Some GPIO pins
*  31-29,23 : reserved (always mask out)
*  28       : Power Button
*  26       : PME#
*  22-16    : LPC
*  14,15    : SMBus
*  9,8      : UART1
*  7        : PCI INTB
*  3,4      : UART2/DDC
*  2        : IDE_IRQ0
*  1        : AC_BEEP
*  0        : PCI INTA
*
* If a mask was not specified, be conservative and only allow:
*  1,2,5,6,10-13,24,25,27
*/

I'll add this in my patch to clear it out.

>> +     spin_lock_irqsave(&chip->lock, flags);
>> +
>> +     /* check if this pin is available */
>> +     if ((mask & (1 << offset)) == 0) {
>> +             printk(KERN_INFO DRV_NAME
>> +                    ": pin %u is not available (check mask)\n",
>> offset);
>> +             return -EINVAL;
>
> There's a locking error here; you really want to spin_unlock_irqrestore
> before returning.

Thanks.

>> +     /* disable output aux 1 & 2 on this pin */
>> +     __cs5535_gpio_clear(chip, offset, GPIO_OUTPUT_AUX1);
>> +     __cs5535_gpio_clear(chip, offset, GPIO_OUTPUT_AUX2);
>> +
>> +     /* disable input aux 1 on this pin */
>> +     __cs5535_gpio_clear(chip, offset, GPIO_INPUT_AUX1);
>> +
>> +     /* disable output */
>> +     __cs5535_gpio_clear(chip, offset, GPIO_OUTPUT_ENABLE);
>> +
>> +     /* enable input */
>> +     __cs5535_gpio_set(chip, offset, GPIO_INPUT_ENABLE);
>
> I don't think this is the right place for all of this.  Your earlier
> email mentioned disabling OUT_AUX{1,2} for outputs, and IN_AUX for
> inputs.  I'm fine with doing that here, but I don't see why you're also
> disabling output and enabling input by default.

I mentioned this in an ealier mail too. When I request the GPIO from
userspace the direction file always contains "in", so I thought
this is the standard direction after resetting as I should be in a
defined state after requesting. But I didn't found anything
about this in GPIO lib documentation, so I would be fine to change
this if there is any common default behavoir.

>> -             .ngpio = 28,
>> +             .ngpio = 32,
>
> Since GPIOs 29-31 aren't externally available, and 28 is
> unavailable anyways, shouldn't we just set ngpio to 28?
I thought that 32 is in consistency with the datasheet as it always
talks about 32 GPIO pins.
