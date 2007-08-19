Return-Path: <linux-kernel-owner+w=401wt.eu-S1755685AbXHSVyb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755685AbXHSVyb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Aug 2007 17:54:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751671AbXHSVyV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 19 Aug 2007 17:54:21 -0400
Received: from smtp123.sbc.mail.re3.yahoo.com ([66.196.96.96]:41760 "HELO
	smtp123.sbc.mail.re3.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751906AbXHSVyU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Aug 2007 17:54:20 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=rnvTebZEHjY/XGBcOCedOIRdwCw4mlWAghpiNin12vsfydHJBb2tle2zpOzEHC2p4yI9Scx3PkUMehI37TjcZSbADtp0MCq/2cLQq1i93zzwEv2pVgPuQCnxq993EqmfsfMApDjtVj5BV5UhzYpcZIMt0mWMCQ+PiHJ6H24xGNo=  ;
X-YMail-OSG: 4Hg7ey4VM1kFxxpGB39e5G31GCf5fYv2HdRh0up2QSXG8b7hKPRQl4zQ4DRvPHcSw9QhESRIdQ--
From: David Brownell <david-b@pacbell.net>
To: Robin Getz <rgetz@blackfin.uclinux.org>
Subject: Re: [PATCH 02/12] Blackfin arch: Add label to call new GPIO API
Date: Sun, 19 Aug 2007 14:54:15 -0700
User-Agent: KMail/1.9.6
Cc: "Bryan Wu" <bryan.wu@analog.com>, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       "Michael Hennerich" <michael.hennerich@analog.com>
References: <11865441373719-git-send-email-bryan.wu@analog.com> <200708171534.32638.david-b@pacbell.net> <200708181507.26273.rgetz@blackfin.uclinux.org>
In-Reply-To: <200708181507.26273.rgetz@blackfin.uclinux.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200708191454.16527.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 18 August 2007, Robin Getz wrote:

> I don't see how early/late makes the problem easier/worse to debug. No matter 
> when you do it - the driver refuses to install (or at least should).

If you arrange to *reliably* detect the pinmux/setup problems by
the time the system starts ""init" (early), that means one large
class of hard-to-sort problems never needs runtime troubleshooting.

Think of it this way:  folk have observed that pin setup issues can
be painful to sort out.  So they adopt a strategy ("failfast"/"early")
which helps surface them early and basically removes them as issues
in later debugging.  I think you're hoping that by adding extra
resource tracking code, you can make that later debugging easier
even though, by "late" binding, you've introduced extra error paths.


> Right - for us - the code handing the hardware differences is easier in the 
> drivers, rather than the bootloaders.

Remember that I didn't argue in favor of putting that code into
boot loaders ... I just pointed out that some product lines work
that way, so Linux needs to cope with that strategy.  (One of the
many examples involves OpenFirmware device tables.)

But regardless:  I can't buy any argument that it's better to put
lots of board-specific code into drivers.  That adds up quickly,
making maintaining the drivers painful.  "Real" updates (bugfixes,
new features, API updates, cleanup, and so on) regularly end up
in conflict with patches to support a few more boards, and board
support patches must then always involve those driver maintainers.
So merging new boards involves many more people than necessary...


> For other systems - where you can have a UART on any pin - I completely 
> understand your point.

UART on any pin?  Few kernels dynamically reprogram FPGAs!  :)


> > Sure ... you'd need to say "this board uses <these devices>"
> > and if integrated in the SOC that's often enough. 
> 
> with the kernel .config - that is what happens. If you have 2 serial drivers 
> connected - you enable 2 serial drivers in Kconfig.

Your language is incorrect here.  What your Kconfig does is
not configure two different *drivers* ... but some number of
different serial *devices* handled by the same driver.

One obvious downside of that is that making it needlessly hard
to support several boards with one kernel.  As a rule, those
boards can have different serial devices, and the devices can
be configured differently.  Yet you said you wanted to make it
easy to support many boards with one kernel...


> > External 
> > devices need more configuration.  Even for integrated ones,
> > that knowledge doesn't belong in the driver ... "which of the
> > many UARTs to use as console" isn't standard, and neither
> > is "what hardware handshaking pins are in use".
> 
> When hardware handshaking pins are fixed - it sure is.

Not unless the UART for some odd reason *requires* those pins to work.

There's almost always support for pure software handshaking (XON/XOFF),
with one board option being "don't handshake".  Board A might use two
pins for UART2 RTS/CTS; board B might use UART as well, but use those
two pins for another I2C bus.  The differences belong in board-specific
configuration, not in drivers.


> When they are not (when  
> the hardware doesn't support hardware handshaking, and you need to do it in 
> software) - we still allow you do to it via Kconfig.
> 
> linux-2.6.x/drivers/serial/Kconfig:

That can work, at least for *single-board* kernel builds.  Of course,
that gets into territory some people will say is Kconfig abuse ...
and the need for many ugly #ifdefs is very obvious.  :)

In fact one could argue that those bits of Kconfig syntax are really
just support for one Blackfin board (ezkit), and so they don't belong
in that Kconfig file or with those names...

Plus, that approach only works with fairly simple types of device glue.
It's routine to find chip hookups that can't fit smoothly into some
pre-planned Kconfig, since they require board-specific function hooks.
(Sometimes even with UARTs, but clearly not in this case.)


> Board configs are in one place - under source control - the kernel .config

And in arch/blackfin/mach-*/boards/*.c ... all that stuff you set up
in Kconfig could as easily have been coded in those files, without any
need for #ifdefs or confusing Kconfig.  Still under source control,
plus it's a lot harder to break.  :)


> I guess we thought it was easier for people to select a few things in config, 
> rather than have to write C code/include files for board specific 
> implementations options - It is like you said - everything is all in one 
> place...

Doing that in Kconfig is atypical ... it may well be a bit easier to
pick up at the beginning of a developer's learning curve, but I think
it doesn't scale very well as multi-board product lines evolve.

- Dave
