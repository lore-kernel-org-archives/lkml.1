Return-Path: <linux-kernel-owner+w=401wt.eu-S1754563AbZFSImc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754563AbZFSImc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jun 2009 04:42:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752967AbZFSImX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Jun 2009 04:42:23 -0400
Received: from mail-bw0-f213.google.com ([209.85.218.213]:65146 "EHLO
	mail-bw0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752886AbZFSImV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jun 2009 04:42:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=Q6T3Qn2ylxEeX4onj6HEGsoF4xdA/Pmi7KB+ttxplMlybDjpdmwlELTcsxNtj8rKqK
         NFWbWXyxRJORPiCUKhgx3d1tlEBIFyzojIUZv98yIBUlc5exfpP5Q+AasXidvfnjdT1r
         HXoMVO5jCoAyVUeYNBmTyvo6+drHeIiaW+Rnw=
MIME-Version: 1.0
In-Reply-To: <20090519230601.GF23114@fluff.org.uk>
References: <63386a3d0905190736q574d0379hb529aaa105aa36f3@mail.gmail.com>
	 <20090519230601.GF23114@fluff.org.uk>
Date: Fri, 19 Jun 2009 10:42:22 +0200
Message-ID: <63386a3d0906190142k1cfa608agfe1a81f05058cc6e@mail.gmail.com>
Subject: Re: [PATCH 1/1] MFD: Add U300 AB3100 core support v3
From: Linus Walleij <linus.ml.walleij@gmail.com>
To: Ben Dooks <ben-linux@fluff.org>
Cc: linux-kernel@vger.kernel.org, sameo@linux.intel.com,
       linux-i2c@vger.kernel.org, Linus Walleij <linus.walleij@stericsson.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I was revisiting this in my mind:

2009/5/20 Ben Dooks <ben-linux@fluff.org>:
> On Tue, May 19, 2009 at 04:36:50PM +0200, Linus Walleij wrote:
(...)
>> +/*
>> + * Here we define all the platform devices that appear
>> + * as children of the AB3100. These are regular platform
>> + * devices with the IORESOURCE_IO .start and .end set
>> + * to correspond to the internal AB3100 register range
>> + * mapping to the corresponding subdevice.
>> + */
>> +
>> +#define AB3100_DEVICE(devname, devid, regstart, regend)              \
>> +static struct resource ab3100_##devname##_resource[] = {     \
>> +     {                                                       \
>> +             .start  = regstart,                             \
>> +             .end    = regend,                               \
>> +             .flags  = IORESOURCE_IO,                        \
>> +     }                                                       \
>
> is IORESOURCE_IO a good idea here, we may need to add some form of
> flag to say 'generic data' and for the driver core to not try and
> register it with any of the ioport or iomem structures.

I face the issue of adding sub-drivers to the AB3100 which will likely
be the same for other chips in the same series, so that say
drivers/rtc-ab3100.c will be used for all AB3xxx chips.
Register X thru X+size-1 (maps to .start and .end) will be
used for a certain subdevice.

So naturally I want these drivers to be relative to some base I2C
register adress and this needs to be passed down as a resource.
(Each I2C device has max 256 registers only for natural resons,
but may still contain several functions.)

Type, as defined in ioport.h is only four unique bits and all four
are taken:

#define IORESOURCE_TYPE_BITS    0x00000f00      /* Resource type */
#define IORESOURCE_IO           0x00000100
#define IORESOURCE_MEM          0x00000200
#define IORESOURCE_IRQ          0x00000400
#define IORESOURCE_DMA          0x00000800

(Pretty generic.)

There is no space for any IORESOURCE_GENERIC or so.

So putting in a resource of type IORESOURCE_IO is still the
best thing I can think of here, any other suggestions?
(I can think of kludgy things like using the bus-specific bits 7-0.)

Yours,
Linus Walleij
