Return-Path: <linux-kernel-owner+w=401wt.eu-S1757780AbXHQWeo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757780AbXHQWeo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2007 18:34:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752994AbXHQWeg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Aug 2007 18:34:36 -0400
Received: from smtp113.sbc.mail.re2.yahoo.com ([68.142.229.92]:20675 "HELO
	smtp113.sbc.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751036AbXHQWef (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2007 18:34:35 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=DHTS6SUp5l4YmrF9utu+6J7o2nOeb/GPzf6jtSBjM94L2py+40B54Mq96qfI5g79vqQamPZbZdscEAELuJDBuBBhnam5MELaKMYP4H3miKvFRwl+AnFHEOsTv2bWcEE/vy/BhenMBdFDfFqEZjuab/Ieic89feKLtV7LFAPsA08=  ;
X-YMail-OSG: QmfEq4cVM1my6kByzCwBKSyTocCh3CLdkTQEmYJM0.QSJ0fO7cuFdxEnCgfK_W9CMbwFi.knO6XZ.QQBF3DavM6Ob72M5DXlXd7aYmrU9V8HXEsZbBk19ibIaEw8HDucw9eMQ7zfZWOhmw--
From: David Brownell <david-b@pacbell.net>
To: Robin Getz <rgetz@blackfin.uclinux.org>
Subject: Re: [PATCH 02/12] Blackfin arch: Add label to call new GPIO API
Date: Fri, 17 Aug 2007 15:34:32 -0700
User-Agent: KMail/1.9.6
Cc: "Bryan Wu" <bryan.wu@analog.com>, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       "Michael Hennerich" <michael.hennerich@analog.com>
References: <11865441373719-git-send-email-bryan.wu@analog.com> <200708171124.54839.david-b@pacbell.net> <200708171753.50326.rgetz@blackfin.uclinux.org>
In-Reply-To: <200708171753.50326.rgetz@blackfin.uclinux.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200708171534.32638.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 17 August 2007, Robin Getz wrote:
> On Fri 17 Aug 2007 14:24, David Brownell pondered:
> > Just for the record, this is an unusual way to use these calls.
> 
> That is part of the natural evolution of the kernel isn't it - per James's 
> keynote at OLS - you release something, and see how people [ab]use it until 
> it either grows, evolves, or it dies.

Yep ... and it's worth knowing when you're doing
something different.  Different isn't always worse,
isn't always better.


> > Other platforms completely decouple these issues from the
> > IRQ infrastructure ... doing the pinmux and gpio claiming
> > separately from the request_irq()/free_irq() paths, mostly
> > as part of board setup.  Doing all of that "early":
> 
> is early:
>  - early in the kernel?
>  - early before the kernel? (in the bootloader).

Both of those are "earlier", yes.  Different product developers
may argue for either placement.

 
> >  - keeps those error returns from causing hard-to-track-down
> >    runtime bugs;
> 
> The current Blackfin implementation causes a run time message:
> "the pin xxxx driver requested, was already claimed by yyy driver".
> 
> I don't think that is too bad?

Given some product with a Blackfin chip, would you expect a
customer -- who may not even see the Linux bits!! -- to be
able to solve such problems?  If it's not possible for such
problems to crop up in the field, product support (and field
troubleshooting) gets easier...


> >  - works always, even on platforms where a given IRQ may
> >    appear on any of several pins/balls;
> 
> But requires custom bootloaders or board setup for every hardware platform?

One or both, yes.  That's typical in embedded setups.
They're not necessarily all that different, but that
code does need to handle the hardware differences.


> Most of our users would not like that, since they do as you say - use the 
> same kernel - with different drivers on multiple platforms.

I thought I referred to different revisions of one platform... :)

 
> >  - makes it easier to cross-check against board schematics,
> >    by keeping most board-specific setup in one source file;
> 
> Yes - but we are not talking about muxing a common peripheral (like a single 
> UART) out many different pins (A or B or C). The UART pins are fixed. If you 
> want the UART, you need to use pin A. If you want to use the I2C that also 
> sits on pin A, you will get the message:
> "pin A, requested by I2C, was already claimed by UART driver".

Not all platforms work that way though.  There can often be several
options for where a given signal gets routed.

And then there are the errors where someone accidentally copies
something like "GPIO 29" to two places ... invariants like "only
one GPIO requestor at a time" are needed to turn up such stuff.


> >  - shrinks the kernel's runtime footprint;
> 
> I agree - making things more flexible/easier to use - is normally more 
> complex/larger/slower. (I know - easier to use is a matter of opinion). Since 
> this is normally done once, in _init functions, I'm not sure that makes much 
> of a difference here.
>  
> >  - allows the label to be more descriptive ... describeing
> >    exactly *which* IRQ, so that using the labels for better
> >    diagnostics actually gives better diagnostics.
> 
> I'm not sure what you mean?

The $SUBJECT patch uses the string "IRQ" in all cases.
But "smc_irq" and "codec_irq" would be more informative
as entries in a list of even just a handful of GPIOs.
And with a few dozen, I'd find "IRQ" not at all helpful.


> > Again, not "wrong"; but probably sub-optimal.  You might
> > want to move towards earlier binding now, while Linux is
> > still young on Blackfin and you don't have legacy code to
> > worry about.
> 
> Our overall goal is to keep as much code - including bootloader - platform 
> agnostic, and not require people to write any of code/configuration data to 
> boot up something, and get things working in a semi-standard manner.

The issue is just where those limits lie.  IMO it's not at
all unreasonable to require board-specific code.  External
chips will need board-specfic glue data in most cases (how
they're addressed, what IRQs they use, and so on); and you
may have drivers available that correspond to devices that
are not wired up on that particular hardware.


> This still has it's limits - which is why we publish all our hardware designs. 
> If you implement things the similar way (because for the most part it is 
> fixed by the processor designer) - the bootloader/kernel/driver will just 
> work.

Sure ... you'd need to say "this board uses <these devices>"
and if integrated in the SOC that's often enough.  External
devices need more configuration.  Even for integrated ones,
that knowledge doesn't belong in the driver ... "which of the
many UARTS to use as console" isn't standard, and neither
is "what hardware handshaking pins are in use".

 
> I would rather force a little extra complexity on me (as a kernel developer) 
> than have to answer thousands of questions from end users, who are trying to 
> move the kernel onto their hardware.

Just remember that "Aunt Tilly" doesn't configure kernels.
And that even deeply technical people who do configure
them may not have the details fresh in mind a few months
later.  ;)

- Dave


