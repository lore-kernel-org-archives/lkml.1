Return-Path: <linux-kernel-owner+w=401wt.eu-S1753458AbYE1JX4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753458AbYE1JX4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2008 05:23:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751455AbYE1JXr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 May 2008 05:23:47 -0400
Received: from smtpeu1.atmel.com ([195.65.72.27]:40135 "EHLO bagnes.atmel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751390AbYE1JXq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2008 05:23:46 -0400
Date: Wed, 28 May 2008 11:21:09 +0200
From: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
To: David Brownell <david-b@pacbell.net>
Cc: Ben Nizette <bn@niasdigital.com>,
       linux-kernel <linux-kernel@vger.kernel.org>, kernel@avr32linux.org
Subject: Re: Latest gpio gumph
Message-ID: <20080528112109.47747cb5@hskinnemo-gx745.norway.atmel.com>
In-Reply-To: <200805280201.24256.david-b@pacbell.net>
References: <1211942475.27810.37.camel@moss.renham>
	<200805272144.33334.david-b@pacbell.net>
	<20080528101425.611e0145@hskinnemo-gx745.norway.atmel.com>
	<200805280201.24256.david-b@pacbell.net>
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 28 May 2008 09:21:00.0690 (UTC) FILETIME=[24EF6F20:01C8C0A4]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Brownell <david-b@pacbell.net> wrote:
> On Wednesday 28 May 2008, Haavard Skinnemoen wrote:
> > > 
> > >  * gpio_direction_output() should disable the pullups just like
> > >    at32_select_gpio(... AT32_GPIOF_OUTPUT) does, for consistency
> > >    between those alternative initialization paths.
> > 
> > But then we need to keep track of whether pullups used to be enabled so
> > that we can re-enable it in gpio_direction_input(), don't we?
> 
> "Need"?  I'd figure that changing direction like that would be
> uncommon without something determining signal level (like an
> external driver or pullup) ... and if nothing did so, then it'd
> be important to use the AVR32-private API with pullup control.

If you enable the internal pullup during port configuration, it should
stay that way, I think. But I think at32_select_gpio() should be fixed
so that when the user specifies AT32_GPIOF_OUTPUT | AT32_GPIOF_PULLUP,
the pullup will be turned on.

> > I can't see the harm of keeping the pullup enabled while the port is
> > configured as output. For consistency, I'd rather honor the pullup flag
> > in at32_select_gpio() regardless of AT32_GPIOF_OUTPUT.
> 
> I guess I don't like the idea of facilitating the constant current
> waste that implies if output is being driven low.  Even if it's not
> a huge current waste!  (These pullups being a lot weaker than I'd
> have expected, at typically 190 kOhm.)  No big deal here I guess.

I don't think we're talking about a lot of pins that need to switch
direction on the fly, and the pullup is very weak as you say. And a
floating input might waste a lot more power than the pullup ever will.

> For an open drain output it's probably less of an issue, unless
> there are too many pullups.

The board designer should know this and set the AT32_GPIOF_PULLUP flag
as appropriate.

> > >  * On the odd chance some code uses a pin as a GPIO IRQ without
> > >    calling gpio_request() or gpio_direction_input(), the debug
> > >    dump should still show its pin status.
> > 
> > Hmm. I guess that makes sense, though I would be lying if I said I care
> > all that much. I think gpiolib is going pretty far to accommodate buggy
> > drivers that don't call gpio_request() as it is.
> 
> For diagnostic/debug code, I'd say it's reasonably useful to cope
> with buglets like that. 
> 
> I actually observed that happening.  Setup code was passing the irq
> to the driver, and everything worked fine because the reset default
> was fine.  I happened to notice that /sys/kernel/debug/gpio output
> didn't match up to /proc/interrupts (bug) ... but it would have been
> much faster to see the bug if the listing for that pin had a "?" label
> showing that it hadn't been requested.

Yes, but it will only catch that particular case, not missing
gpio_request() calls in general.

I'm not really opposed to the second change; I would have applied it if
it came separately. But I think the first change is wrong.

Haavard
