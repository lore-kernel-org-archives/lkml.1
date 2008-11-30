Return-Path: <linux-kernel-owner+w=401wt.eu-S1755536AbYK3Rzq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755536AbYK3Rzq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Nov 2008 12:55:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751890AbYK3Rze
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Nov 2008 12:55:34 -0500
Received: from smtp119.sbc.mail.sp1.yahoo.com ([69.147.64.92]:35606 "HELO
	smtp119.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751471AbYK3Rzd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Nov 2008 12:55:33 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=jw7kMoK6HldAqw81ME91C+W/W/47qfVzWk27XvzntdeXxlMvZY3aquCqBnOu2u4E3/FC1djbMBujJOJJHGz/3QeKjKJjoDj+f32XChKhICsI7V+HxZ/c2LXxSsJfhZgCKLm8sJrbqCSrT0ESmQ6/IRo27u9tidGYLv+8k23Z5l8=  ;
X-YMail-OSG: 6czibXcVM1lTFK8u2JT_CFqERyzFcPuCxkt_2H2K5CHbPu.Dmg2S7wpHvEnY.dhD2ZwR5bTkdNznFM7DWOcnhkfsaXyK5jLZlu8VUkoR2Nj1SMkRn8fAhpEqFdycElygdiCLG65HcKCLWuTp91vcnDvOiPeBZ4GfpA55e3Lh4wPzR0fjhJKX7GIs7.KR
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: "Jaya Kumar" <jayakumar.lkml@gmail.com>
Subject: Re: [RFC 2.6.27 1/1] gpiolib: add support for batch set of pins
Date: Sun, 30 Nov 2008 09:55:28 -0800
User-Agent: KMail/1.9.10
Cc: "Eric Miao" <eric.y.miao@gmail.com>, "Sam Ravnborg" <sam@ravnborg.org>,
       "Eric Miao" <eric.miao@marvell.com>,
       "Haavard Skinnemoen" <hskinnemoen@atmel.com>,
       "Philipp Zabel" <philipp.zabel@gmail.com>,
       "Russell King" <rmk@arm.linux.org.uk>,
       "Ben Gardner" <bgardner@wabtec.com>, "Greg KH" <greg@kroah.com>,
       linux-arm-kernel@lists.arm.linux.org.uk,
       linux-fbdev-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       linux-embedded@vger.kernel.org
References: <12276535632759-git-send-email-jayakumar.lkml@gmail.com> <200811291454.17110.david-b@pacbell.net> <45a44e480811291552i77878bcdn5fe33f48fc4236eb@mail.gmail.com>
In-Reply-To: <45a44e480811291552i77878bcdn5fe33f48fc4236eb@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200811300955.30180.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 29 November 2008, Jaya Kumar wrote:
> On Sun, Nov 30, 2008 at 6:54 AM, David Brownell <david-b@pacbell.net> wrote:
> > If you want to pursue this, I'd like to get the gpio_chip
> > proposal in place first:  bitmask read and write, without
> > forcing an "all bits are contiguous" policy.  Lightweight.
> 
> Yup, yup, I definitely want to pursue it. I want Linux e-paper
> displays to be zippy. :-) Agreed, I will do bitmask read and write.
> Hey, wait a sec, bitmask write definitely. but bitmask read is
> peculiar to me. I can understand the caller would want to do something
> like foo = gpio_get_values(gpio, bitwidth). But would they really want
> to do foo = gpio_get_values(gpio, bitwidth, bitmask) rather than deal
> with it appropriately themselves?

They wouldn't want names so easily confused with the current set
of GPIO calls, no.

But if they're using GPIOs as a low-bandwidth parallel bus they'd
most *certainly* need to be able to read, not just write.  That's
what the "I" part of "GPIO" represents:  "I"nput (vs "O"utput).


> > Maybe it should suffice to have a gpio_chip support the
> > bitmask ops, instead of just bit-at-a-time ones... so it'd
> > be practical to incorporate this by itself, given patches
> > to convert a couple gpio_chip implementations.
> 
> Ok, you've scared me there. I only have a Gumstix board so I can do it
> for the pxa255 but will need help if more platforms are needed.
> Exploiting this opportunity for hardware whoring, if anyone wants to
> send me free hardware, I'll be ecstatic and will eagerly do support
> duty on said platforms. :-)

Doesn't necessarily need to be *you* doing that, but if it only
works on older gumstix boards it'd not be general enough.  Which
is part of why I say to get the lowest level proposal out there
first.  If done right, it'll be easy to support on other chips.


> >
> > Then separately two more things:
> >
> >  - A gpio_* interface proposal for higher-level bitmask calls.
> >   This is worth some discussion; the calls should clearly
> >   be optional (not everything will implement them), and I
> >   can't help but suspect <linux/bitmap.h> interfaces should
> >   interoperate smoothly.

... including probably ganged request/free, and direction updates.
When bitbanging a multiplexed parallel databus, you'll often need
to change directions.


> >
> >  - A gpiolib based implementation, using those new gpio_chip
> >   methods as accelerators if they're present.  This should
> >   probably also be optional, even at the Kconfig level; many
> >   systems won't need to spend memory on these calls.
> 
> Understood. I will make it optional. Does
> CONFIG_GPIOLIB_MULTIBIT_ACCESS sound okay?

Kind of verbose for my taste, and it's already "multibit" (one
at a time, but still multiple) ... let's see some more mergeable
proposals and code first.  Different C file too, I suspect.


> > Don't assume gpiolib when defining the interface.
> 
> Ok, I didn't understand this part. I think you mentioned a higher
> level interface before but I didn't fully understand, if not gpiolib,
> then at what level do you recommend?

The gpio_*() interfaces are how system glue code and drivers
access GPIOs, unless they roll their own chip-specific calls.

Whereas gpiolib (and gpio_chip) are an *optional* framework
for implementing those calls.  Platforms can (and do!) use
other frameworks ... maybe they don't want to pay its costs,
and don't need the various GPIO expander drivers.

So to repeat:  don't assume the interface is implemented in
one particular way (using gpiolib).  It has to make sense
with other implementation strategies too.  Standard split
between interface and implementation, that's all.  (Some folk
have been heard to talk about "gpiolib" as the interface to
drivers ... it's not, it's a provider-only interface library.)

- Dave
