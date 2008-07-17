Return-Path: <linux-kernel-owner+w=401wt.eu-S1755530AbYGQEPr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755530AbYGQEPr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2008 00:15:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751377AbYGQEPg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jul 2008 00:15:36 -0400
Received: from wf-out-1314.google.com ([209.85.200.170]:29233 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751092AbYGQEPf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2008 00:15:35 -0400
Date: Wed, 16 Jul 2008 22:15:31 -0600
From: Grant Likely <grant.likely@secretlab.ca>
To: Trent Piepho <tpiepho@freescale.com>
Cc: Anton Vorontsov <avorontsov@ru.mvista.com>,
       Richard Purdie <rpurdie@rpsys.net>,
       Stephen Rothwell <sfr@canb.auug.org.au>,
       Kumar Gala <galak@kernel.crashing.org>, linux-kernel@vger.kernel.org,
       linuxppc-dev@ozlabs.org
Subject: Re: [PATCH v3] leds: implement OpenFirmare GPIO LED driver
Message-ID: <20080717041531.GA27243@secretlab.ca>
References: <1216133032.5345.73.camel@dax.rpnet.com> <20080715151917.GA30607@polina.dev.rtsoft.ru> <Pine.LNX.4.64.0807161546010.12709@t2.domain.actdsltmp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0807161546010.12709@t2.domain.actdsltmp>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 16, 2008 at 04:18:52PM -0700, Trent Piepho wrote:
> On Tue, 15 Jul 2008, Anton Vorontsov wrote:
> > Despite leds-gpio and leds-openfirmware-gpio similar purposes, there
> > is not much code can be shared between the two drivers (both are mostly
> > driver bindings anyway).
> 
> Why can't this driver use the existing gpio-led driver?  Basically, do
> something like this:
> 
> of_gpio_leds_probe(...)
> {
>  	gpio = of_get_gpio(np, 0);
>  	label = of_get_property(np, "label", NULL);
> 
>  	struct gpio_led led = {
>  		.name = label,
>  		.gpio = gpio,
>  	};
> 
>  	pdev = platform_device_register_simple("leds-gpio", 0, NULL, 0);
>  	platform_device_add_data(pdev, &led, sizeof(led));
> }

Ugh; that means registering *2* 'struct device' with the kernel instead of
one.  One as a platform device and one as an of_platform device.
It's bad enough that the LED scheme we're using for OF bindings has a
separate registration for every single LED.

Now that it comes to it, I worry that this driver takes the wrong
approach.  The number of resources dedicated per LED in this driver
seems pretty loony to me (one of_platform device per LED).  The fact
that the binding specifies one node per LED makes of_platform not a very
efficient solution.

I think it would be better to have a module that scans the device tree
for LED nodes and registers a single leds-gpio platform device for the
whole lot.

Thoughts?

g.
