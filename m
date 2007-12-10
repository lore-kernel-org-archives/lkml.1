Return-Path: <linux-kernel-owner+w=401wt.eu-S1755879AbXLJQw2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755879AbXLJQw2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2007 11:52:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751840AbXLJQwT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Dec 2007 11:52:19 -0500
Received: from smtp116.sbc.mail.sp1.yahoo.com ([69.147.64.89]:43515 "HELO
	smtp116.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751818AbXLJQwT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2007 11:52:19 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:Received:Date:From:To:Subject:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-Id;
  b=Di/jOTgNxvWYqbOFSrzmnEtZb4cDk6d+aERQAe3M2LKQr8T3S6syvlzwxHXSi1fX6JqbRF1cU+JJTwbA4Jcgr1SWrCU1kiX2QYq1q3Q4khr129KPz7iz3v8hvzZHjXwd2KfuC/6vbP4sXof6MGkHY4eQgqKs4wgXgHQpdQjfAnE=  ;
X-YMail-OSG: XVeatwEVM1lUOHlN1M5fWHqv4DyGOxteC4LbsC.R_9ls5AT49tT2hoTRrt.Zzk.ZtXB8NyiaiW1DG.bDVqPmBjUK6qL3MORhN5xccGQ3RcUOR4Upnw--
Date: Mon, 10 Dec 2007 08:52:17 -0800
From: David Brownell <david-b@pacbell.net>
To: khali@linux-fr.org
Subject: Re: [patch 2.6.24-rc4-mm 4/6] gpiolib:  create empty drivers/gpio
Cc: linux-kernel@vger.kernel.org, eric.y.miao@marvell.com,
       akpm@linux-foundation.org
References: <200712092022.14062.david-b@pacbell.net>
 <200712092039.57722.david-b@pacbell.net>
 <20071210171609.0d4738b8@hyperion.delvare>
In-Reply-To: <20071210171609.0d4738b8@hyperion.delvare>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20071210165217.5CB6616AF7A@adsl-69-226-248-13.dsl.pltn13.pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > Add an empty drivers/gpio directory for gpiolib based GPIO expanders.
> > We already have three of them (two I2C, one SPI), and there are dozens
> > of similar chips that only exist for GPIO expansion.
> > 
> > This won't be the only place to hold such gpio_chip code.  Many external
> > chips add a few GPIOs as secondary functionality, and platform code
> > frequently needs to closely integrate GPIO and IRQ support.
> > 
> > This is placed *early* in the build/link sequence since it's common for
> > other drivers to depend on GPIOs to do their work, so they need to be
> > initialized early in the device_initcall() sequence.
>
> Note that I foresee potential problems with this. These GPIO drivers
> need I2C or SPI to be initialized before they can load. However on some
> systems, I2C or SPI buses are hanging off GPIOs, meaning that these
> GPIOS need to be initialized before I2C or SPI, respectively.

In those cases the I2C (or SPI) bus will normally be hanging off
some arch/XX/mach-YY/gpio.c platform code, which will usually be
set up so it's "always there".  (As noted by the docs in patch 3/6
of this series.)  Such code often initializes very early, sometimes
even before IRQs are enabled or kmalloc works.

Bitbanging through an I2C or SPI expander would be possible, but
doesn't seem especially practical.  :)


>	I can
> imagine weird setups where for example an SPI bus would be driven by an
> I2C-based GPIO chip, or vice-versa. I sure hope that nobody does this,
> but you never know... And I'm not sure how we would possibly support
> this.

It's just a routine case of init this before that.  Again, the
dependency issue is noted in the docs in patch 3/6 of this series.
Linking these expanders early reduces such problems, it can never
get rid of them.

It's really no different than needing to hold off initialization
of any other device until the I2C based GPIOs are ready, like the
leds-gpio example [1] I posted some time ago.

- Dave

[1] http://marc.info/?l=linux-kernel&m=119370944606415&w=2
    See evm_led_setup(), setting up the leds-gpio device as a
    child of the GPIO expander; and evm_u18_setup(), setting
    up a switch attribute as a child of a different expander.
