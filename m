Return-Path: <linux-kernel-owner+w=401wt.eu-S1754572AbYDHKou@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754572AbYDHKou (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2008 06:44:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752040AbYDHKol
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Apr 2008 06:44:41 -0400
Received: from mail.gmx.net ([213.165.64.20]:35653 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751836AbYDHKok convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2008 06:44:40 -0400
X-Authenticated: #20450766
X-Provags-ID: V01U2FsdGVkX1+vKDl5OLmv/FG+/yx0Wl3PDxeQVKoMiDqcuxeq9x
	rjs6C64EH9hQle
Date: Tue, 8 Apr 2008 12:44:46 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@pengutronix.de>
X-X-Sender: lyakh@axis700.grange
To: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= <Uwe.Kleine-Koenig@digi.com>
cc: David Brownell <david-b@pacbell.net>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: gpio patches in mmotm
In-Reply-To: <20080408093305.GA8141@digi.com>
Message-ID: <Pine.LNX.4.64.0804081227360.4987@axis700.grange>
References: <20080317173134.GA27282@digi.com> <Pine.LNX.4.64.0803171915020.8640@axis700.grange>
 <20080318160316.GA31588@digi.com> <Pine.LNX.4.64.0803181717240.5022@axis700.grange>
 <20080408060230.GA22071@digi.com> <Pine.LNX.4.64.0804080812420.3556@axis700.grange>
 <20080408093305.GA8141@digi.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 8 Apr 2008, Uwe Kleine-König wrote:

> arch/arm/mach-ns9xxx.  It's not (yet) fully supported in vanilla, but it
> includes support for different SOCs that have a different handling of
> their GPIOs.  E.g. the ns9360 has one gpio configuration register per 8
> gpios, the ns9215 has one per 4 gpios.  Or another thing: ns9215 has
> 108 gpios, ns9210 has only 54 where the first 50 gpios are identical to
> the first 50 of ns9215, and the last 4 gpios are identical to gpios
> 105-108 on ns9215.  So gpio_is_valid for ns9xxx has to look like:
> 
> 	int gpio_is_valid(int gpio)
> 	{
> 		...
> 		if (processor_is_ns9210())
> 			return gpio >= 0 && gpio < 108 && !(gpio >= 50 && gpio < 105);
> 		...
> 	}
> 
> (In my eyes that hole is ugly, but with it can calculate the address of
> the configuration register without case splitting and can handle ns9215
> and ns9210 identically---apart from the is-valid check.)

Ok, I thought it would be something like that. I think, these are two 
different things: GPIO valid and GPIO currently physically existing. 
gpio_is_valid() is a test whether the number being tested at all stands a 
chance to be a GPIO number on this architecture. As you see in 
include/asm-generic/gpio.h it only compares against ARCH_NR_GPIOS, which 
is just the theoretically highest GPIO number. It says nothing about 
whether or not all valid GPIOs are actually present on the system. Think 
about GPIO expanders, there might or might not be one currently available 
on the system. Still gpio_is_valid() will return the same result for any 
given number. PXA CPUs have the same "feature" as ns9xxx - different 
models have differeng GPIOs, and platform add their own GPIO controllers, 
which are often placed at a fixed start number, which means, on some CPUs 
there will be holes too. And gpio_is_valid is not (and should not be) 
checking for those - this is already the task for request_gpio().

> So you reason that the alternative approach allows only a slight
> simplification and so is not worth considering?  But obviously
> yes, I have a different opinion. :-)

No, my reason is that I didn't want to put "intimate knowledge" of GPIO 
interna, like "-1 is not a valid GPIO" in the driver but use an 
abstraction instead. My original proposal was to introduce just one 
NO_GPIO macro to test against, however, David nicely managed to persuade 
me, that the gpio_is_valid approach is better. Unfortunately, I cannot 
argument as nicely as he did, maybe looking through his emails in LKML 
archives will help you:-)

Thanks
Guennadi
---
Guennadi Liakhovetski
