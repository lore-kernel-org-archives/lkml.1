Return-Path: <linux-kernel-owner+w=401wt.eu-S1753504AbXDSSbz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753504AbXDSSbz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2007 14:31:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753510AbXDSSbz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Apr 2007 14:31:55 -0400
Received: from smtp110.sbc.mail.mud.yahoo.com ([68.142.198.209]:42337 "HELO
	smtp110.sbc.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753504AbXDSSby (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2007 14:31:54 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=B+x3dOYMc9TJeB8ImtwORAve1fbZ7V4lEmnBybuX0qIRFRXAyFrrZmMcHr7AnVbZ2aUgFlpYsFw94j2ZkEkiSU0tG6gSuSZJfW5z4nEUT+tt3YLLMqSHYgKOg6QaYRuoVfc/Q4ER+CR6sfIxDhFQ7MjzNUqknm82obSsLjLNE5Q=  ;
X-YMail-OSG: 6ZttBm4VM1k7Cie9WsPLoANJIDDeVQdfsPIy.IZULCEA1d7gDcruKErQHuKzSNFGBuz4RSRKPQ--
From: David Brownell <david-b@pacbell.net>
To: "Francis Moreau" <francis.moro@gmail.com>
Subject: Re: question on generic gpio interface
Date: Thu, 19 Apr 2007 11:06:57 -0700
User-Agent: KMail/1.7.1
Cc: linux-kernel@vger.kernel.org
References: <38b2ab8a0704131351la5085vf0ab58e85cf49879@mail.gmail.com> <200704170942.49626.david-b@pacbell.net> <38b2ab8a0704190105x68414f34w51f109f1f289ca7d@mail.gmail.com>
In-Reply-To: <38b2ab8a0704190105x68414f34w51f109f1f289ca7d@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200704191106.57943.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 19 April 2007 1:05 am, Francis Moreau wrote:
> On 4/17/07, David Brownell <david-b@pacbell.net> wrote:

With regards to a userspace interface to GPIOs (rather than to
devices such as leds or switches they control):


> > In this case I'm not entirely sure how it'd work.  I've seen a few
> > drivers which let userspace peek and poke at GPIO signals -- like
> > one for Gumstix boards -- but generalizing the model isn't simple.
> > Sub-problems include:
> >
> >  - Configuring the relevant pins.  Especially for SOC cases, GPIO
> >    roles are multiplexed with several others.  So there are two
> >    issues:  (a) the platform-specific setup of that multiplexing,
> >    plus (b) the board-specific knowledge of what pins are truly
> >    available for use as GPIOs, and not otherwise in use.
> >
> 
> what about create a module "user-gpio" for example that could request
> some gpios that the board could have declared using resource
> subsystem, like this:

That addresses only (b).  But (a) would still need a solution.

It's common that any given pin be usable for multiple different
purposes ... it's rarely hardwired only to a GPIO controller.
More usually it will be multiplexed to several other controllers
under software control.  (Some chips allow up to eight choices,
Others only have two or three.)

> 
> static struct resource foo_gpio_resource[] = {
>         [0] = {
>                 .start = 10,
>                 .end  = 11,
>                 .flags = IORESOURCE_GPIO,

As you probably know, there is no such thing as IORESOURCE_GPIO;
that could be changed if necessary.

>         },
>        [1] = {
>                 .start = 26,
>                 .end  = 31,
>                 .flags = IORESOURCE_GPIO,
>         },
> };
> 
> struct platform_device foo_device_usergpio = {
>         .name           = "user-gpio",
>         .id             = -1,
>         .num_resources  = ARRAY_SIZE(foo_gpio_resource),
>         .resource       = foo_gpio_resource,
> };
> 
> This way "user-gpio" module knows which pins are avalaible to userspace.

If there's going to be a "user-gpio" driver it could just as easily
take an array of GPIOs in its platform data; and that would usuallly
take a lot less space, even if it's not compressed to a bitmask!


> >  - Enumerating those GPIOs to userspace.  One SOC might have just
> >    a few dozen, another might have a few hundred; and then there
> >    are all the board-specific ones, on FPGA or I2C chips etc.
> >
> 
> This point is actully the one where I'm really not sure...
> 
> Enumerating user GPIOs would always start from 0 to GPIO_USER_NR - 1
> and an application that need to be portable should use a config file
> to specify which GPIO num to use...

Actually GPIOs don't need to start at zero, and the numbering doesn't
need to be continuous.  On one system I use, GPIOs start at 32; on
another, they go 0..63 and then 192..207; and that's just for the
once on the same chip as the CPU!

As far as configuration goes, what would be useful would be to have
someone do a survey of the existing userspace tools that work with
GPIOs, and see what they're trying to do.  I'd start with that one
for Gumstix, since it's got a fairly broad problem domain.


> >  - Exposing those pins to userspace.  It'd be unsafe to let pins
> >    claimed by drivers be managed by userspace; the default should
> >    be that only unclaimed GPIOs can be accessed.
> >
> 
> Well an extreme solution would be to test in gpio_request(), if the
> passed gpio nr is a user one then gpio_request() would return an
> error. We could use is_user_gpio() function implemented by user-gpio
> module

Yes, using gpio_request() is the natural solution.  I hope to see more
platforms actually implementing it before too long.

- Dave

