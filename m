Return-Path: <linux-kernel-owner+w=401wt.eu-S2993109AbXDSCWw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2993109AbXDSCWw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2007 22:22:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2993113AbXDSCWv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Apr 2007 22:22:51 -0400
Received: from smtp105.sbc.mail.mud.yahoo.com ([68.142.198.204]:36815 "HELO
	smtp105.sbc.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S2993109AbXDSCWu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2007 22:22:50 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=NdSf55sYMl9/7CltztlaSMDWfc1wetZAvuHow0MF9exjbeXhIx56exMFHNYpPKk2twJO2ajM7Jpto14+dBoIwsLj9mnozrSdsbU9og7/NuP4+igux4o5OPecF51FrZGgWapzbqKRKRyJRjn2219sgPpQlQGALeNu1h8YjZix+xM=  ;
X-YMail-OSG: XAm1lzYVM1kCRfbzUjiuDEQWpQfjesWB4w1c_4bGso_C6iacF7dG8yBMUnpEYsqNQlKMm9AmXKz5xJIhONZ3kgIRWvQBcWKTKmZxLK5TaoseQxCu.74-
From: David Brownell <david-b@pacbell.net>
To: Paul Sokolovsky <pmiscml@gmail.com>
Subject: Re: is there any generic GPIO chip framework like IRQ chips?
Date: Wed, 18 Apr 2007 19:22:44 -0700
User-Agent: KMail/1.7.1
Cc: linux-arm-kernel@lists.arm.linux.org.uk, linux-kernel@vger.kernel.org
References: <f17812d70704090309l8dd764cxc06fbd7b765c55d8@mail.gmail.com> <200704151247.57724.david-b@pacbell.net> <424488534.20070417190535@gmail.com>
In-Reply-To: <424488534.20070417190535@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200704181922.44635.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> >> > So, talking about what an (optional) implementation framework might
> >> > look like (and which could handle the SOC, FPGA, I2C, and MFD cases
> >> > I've looked at):
> 
> > See patches in following messages ... a preliminary "gpio_chip" core
> > for such a framework, plus example support for one SOC family's GPIOs,
> > and then updating one board's handling of GPIOs, including over I2C.
> 
>         Just to compare, diffstats for GPIODEV:

Now, if they were functionally equivalent, such a comparison
would be less of an apples/oranges thing!

The most useful comparison would focus on technical aspects of
the gpio_chip abstraction itself (i.e. $SUBJECT).


> 	it needs work - it doesn't adhere to your own 
> optimization scheme by using lookup table instead of list.

I thought it was more important to address the $SUBJECT first:
get a working gpio_chip abstraction which covers all the needed
functionality.  The patch had a hook for implementing such tweaks,
but it wasn't used.

The next version you'll see lets the platform code use its own
existing lookup code, as part of slimming things down a bit.
I also decided to take out the debugfs support.


>         	 you speak about constructor
> parts which "anyone" can use to construct whatever GPIO API they like,
> whereas I'm speaking about exact API implementation which can be used
> right away.

I most certainly did not speak about "whatever GPIO API they like"!!

Quite the contrary, in fact.  Please don't put words in my mouth.
(You've been doing it quite extensively in this thread; it's rude.)

And that "core" patch I posted was clearly usable "right away";
otherwise the two examples _using_ it couldn't have worked.


>         Well, besides gpio_keys we here have asic3_keys, samcop_keys,
> etc. - all that duplication just because the current GPIO API doesn't
> allow extensibility to more chips.

When I get tired of repeating myself, just remember:  the current
programming interface *DOES* allow such extensibility.  That's what it
means to be an "interface", rather than an implementation:  it defines
inputs and outputs, allowing any process that conforms to both.

In fact, the patches I sent demonstrated exactly that extensibility.
Same interface, additional chips; different implementation inside.


> > So you're agreeing that, at a technical level, what I described
> > could be augmented by a "caching" facility ... giving a programming
> > interface with all the characteristics of your "GPIODEV" thingie.
> 
> > All you're really disagreeing with is bootstrapping issues; and
> > whether there is in fact a need for such a layer.  The only argument
> > I could possibly buy is that it avoids the lookup of (b) ... but
> > that doesn't seem to matter in most cases I've looked at.


> So, now the most important question is what we all would get
> with your approach in the end.
> 
> So, if you could make sure gpiolib.c doesn't contain inefficient
> implementation,

I can make it comparable to existing implementations that work
the same way ... e.g. AT91 and OMAP code.  Of course, it's not
possible to get away from the cost of function indirection, with
a generic gpio_chip abstraction.  Or those lookup costs; but as
you agreed, those costs don't seem to matter much.  And if they
ever do matter, caching support would be easy to add.


> and make such extensible implementation available by default
> for ARM PXA/S3Cxxx/OMAP, then it's for sure cover Handhelds.org's,
> and many other peoples' usecases, and that would be highly
> appreciated.
> 
> If you could do it for 2.6.22 merge window, that would
> straight ideal.

I think having an optional gpio_chip, not unlike what was in
that one patch, should be reasonable; also, making it work on
some platforms that I use.  But I don't think there's much
overlap between those platforms and what hh.org uses.

- Dave
