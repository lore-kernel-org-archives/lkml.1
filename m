Return-Path: <linux-kernel-owner+w=401wt.eu-S1752232AbZIYUY1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752232AbZIYUY1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Sep 2009 16:24:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751591AbZIYUY1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Sep 2009 16:24:27 -0400
Received: from mail-yw0-f174.google.com ([209.85.211.174]:38705 "EHLO
	mail-yw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751497AbZIYUY0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Sep 2009 16:24:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=UTVkIwPoBaMkSa6vyIdTd2qVqPbtEScLQWvyy+g7lvBz/cOCCrkCqekA/FM3OkEfUO
         D0uE651MzJ8Nu/ArDBIwRYFs56l/z2NvdkxMTCj3+P5QIsiTSptNY+t+474JSuGeipIu
         IsGGv8q5UBqgwuqQbcUnDSLne+eYJaY6v8Yd0=
MIME-Version: 1.0
In-Reply-To: <20090924163240.d03127e3.akpm@linux-foundation.org>
References: <1252950549-9838-1-git-send-email-vapier@gentoo.org> 
	<1253223426-5938-1-git-send-email-vapier@gentoo.org> <20090924163240.d03127e3.akpm@linux-foundation.org>
From: Mike Frysinger <vapier.adi@gmail.com>
Date: Fri, 25 Sep 2009 16:24:10 -0400
Message-ID: <8bd0f97a0909251324h115c5c47wb2d50cc982ba17dd@mail.gmail.com>
Subject: Re: [PATCH v2] fbdev: bfin-lq035q1-fb: new Blackfin Landscape LCD 
	EZ-Extender driver
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-fbdev-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       michael.hennerich@analog.com, cooloney@kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 24, 2009 at 19:32, Andrew Morton wrote:
> On Thu, 17 Sep 2009 17:37:06 -0400 Mike Frysinger wrote:
>> +config FB_BFIN_LQ035Q1
>> +     tristate "SHARP LQ035Q1DH02 TFT LCD"
>> +     depends on FB && BLACKFIN
>> +     select FB_CFB_FILLRECT
>> +     select FB_CFB_COPYAREA
>> +     select FB_CFB_IMAGEBLIT
>> +     select BFIN_GPTIMERS
>> +     select SPI
>
> Are we sure about the `select SPI'?  There's only one other place in
> the kernel which does this, and `select' often makes things explode.  I
> fear that you're either selecting the wrong thing or you're selecting
> something which won't work well.

is it there on purpose and is it not just a mistaken typo ?  yes.  do
we really need it and will we cry if it changes to a "depends" ?  no.

it's just confusing to have a device driver disappear if SPI is
disabled, but considering SPI is enabled by default now, it's not a
big deal.

>> +#define DRIVER_NAME "bfin-lq035q1"
>> +static char driver_name[] = DRIVER_NAME;
>
> Will the compielr magically put this string into read-only storage for
> us, or should we do that manually with `const'?

is this question a rhetorical one ?  oh no, infinite loop ...

i'll fix it up in v3

>> +static int lq035q1_control(unsigned char reg, unsigned short value)
>> +{
>> +     int ret;
>> +     u8 regs[3] = {LQ035_INDEX, 0, 0};
>> +     u8 dat[3] = {LQ035_DATA, 0, 0};
>> +
>> +     if (spi_control.spidev) {
>> +             regs[2] = reg;
>> +             dat[1] = value >> 8;
>> +             dat[2] = value & 0xFF;
>> +
>> +             ret = spi_write(spi_control.spidev, regs, ARRAY_SIZE(regs));
>> +             ret |= spi_write(spi_control.spidev, dat, ARRAY_SIZE(dat));
>> +     } else
>> +             return -ENODEV;
>> +
>> +     return ret;
>> +}
>
> I am suspecting that this function (and the similar ones below) rely
> upon state within the hardware and will hence misbehave if two
> instances are run concurrently.
>
> Is that correct>  If so, is there locking to prevent this from occurring?

if by "instances" you mean "users" as in "multiple programs
reading/writing the framebuffer concurrently", then probably.  rather
than handle the locking ourselves, it can be pushed to the SPI bus by
having the regs/dat be transfers in a single message.
-mike
