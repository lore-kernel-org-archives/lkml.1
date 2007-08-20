Return-Path: <linux-kernel-owner+w=401wt.eu-S1757409AbXHTB4N@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757409AbXHTB4N (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Aug 2007 21:56:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752600AbXHTBz5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 19 Aug 2007 21:55:57 -0400
Received: from nwd2mail11.analog.com ([137.71.25.57]:47414 "EHLO
	nwd2mail11.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753241AbXHTBz4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Aug 2007 21:55:56 -0400
X-IronPort-AV: i="4.19,282,1183348800"; 
   d="scan'208"; a="37546670:sNHT29526784"
From: Robin Getz <rgetz@blackfin.uclinux.org>
Organization: Blackfin uClinux org
To: "David Brownell" <david-b@pacbell.net>
Subject: Re: [PATCH 02/12] Blackfin arch: Add label to call new GPIO API
Date: Sun, 19 Aug 2007 21:55:58 -0400
User-Agent: KMail/1.9.5
Cc: "Bryan Wu" <bryan.wu@analog.com>, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       "Michael Hennerich" <michael.hennerich@analog.com>
References: <11865441373719-git-send-email-bryan.wu@analog.com> <200708181507.26273.rgetz@blackfin.uclinux.org> <200708191454.16527.david-b@pacbell.net>
In-Reply-To: <200708191454.16527.david-b@pacbell.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200708192155.58152.rgetz@blackfin.uclinux.org>
X-OriginalArrivalTime: 20 Aug 2007 01:55:54.0852 (UTC) FILETIME=[3E867240:01C7E2CD]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun 19 Aug 2007 17:54, David Brownell pondered:
> On Saturday 18 August 2007, Robin Getz wrote:
> 
> > I don't see how early/late makes the problem easier/worse to debug. No
> > matter when you do it - the driver refuses to install (or at least
> > should). 
> 
> If you arrange to *reliably* detect the pinmux/setup problems by
> the time the system starts ""init" (early), that means one large
> class of hard-to-sort problems never needs runtime troubleshooting.

Sure it does - it just needs to do it in the bootloader, not the kernel. You 
haven't eliminated the problem - or made it any easier to debug - it is just 
moved somewhere else. Again - this is not bad. We decided/are attempting to 
do it in the kernel. Normally what we find is there are more kernel people on 
a project than bootloader (whether this makes this easier - or not - is still 
TDB :)

> Think of it this way:  folk have observed that pin setup issues can
> be painful to sort out. 

Absolutely - the problem that everyone is trying to solve - is how to do plug 
and play, with no enumeration?

Doing it early in the bootloader is akin to historical PC solution where early 
ISA PNP (shudder) filled out a table in memory, and passed it to the OS.

> So they adopt a strategy ("failfast"/"early") 
> which helps surface them early and basically removes them as issues
> in later debugging.

When the kernel engineer runs into a problem because a driver won't load, is 
it better that he can fix it himself (hopefully), or that they have to call 
the person maintaining the bootloader? There are pro/cons of either. I can 
see the value in both. 

We choose to do it in the driver, not the bootloader.

> > Right - for us - the code handing the hardware differences is easier
> > in the drivers, rather than the bootloaders.
> 
> Remember that I didn't argue in favor of putting that code into
> boot loaders ... I just pointed out that some product lines work
> that way, so Linux needs to cope with that strategy.  (One of the
> many examples involves OpenFirmware device tables.)
> 
> But regardless:  I can't buy any argument that it's better to put
> lots of board-specific code into drivers. 

I don't think we are putting board specific code in drivers (or if there is - 
it should get removed).

I did a quick look, and the only place this has happened is in some of our 
drivers that have not made it to main line yet - where we accidently put some 
mtd_partitions in the drivers, rather than the boards file. I know we are 
working on fixing this.

> That adds up quickly, 
> making maintaining the drivers painful.  "Real" updates (bugfixes,
> new features, API updates, cleanup, and so on) regularly end up
> in conflict with patches to support a few more boards, and board
> support patches must then always involve those driver maintainers.
> So merging new boards involves many more people than necessary...

I agree - which is why don't do this either. Board specific info does not go 
into drivers. I think this is something that Michael, Bryan and others 
working on the Blackfin arch & drivers will agree to 100%.

What we do is try to make the driver agnostic to the hardware as much as 
possible, where hardware specifics (chip selects, IRQ, GPIO, etc) are managed 
in Kconfig.

I can see the value of doing the initialisation in the bootloader - since this 
would allow you have a common driver - and hardware customisation is done in 
the bootloader.

>
> > 
> > linux-2.6.x/drivers/serial/Kconfig:
> 
> That can work, at least for *single-board* kernel builds.  Of course,
> that gets into territory some people will say is Kconfig abuse ...
> and the need for many ugly #ifdefs is very obvious.  :)

We have been trying to minimise that - and I think we have been doing a pretty 
good job. There doesn't seem to be any platform specific ifdefs in our 
drivers that are not abstracted out.

> Doing that in Kconfig is atypical ... it may well be a bit easier to
> pick up at the beginning of a developer's learning curve, but I think
> it doesn't scale very well as multi-board product lines evolve.

We have lots of end users (obviously not as many as ARM or PPC yet), and they 
have not been complaining, in fact some say that this is easier to deploy.

But - I think we both agree - that what we are doing is just an alternative 
implemention of hardware abstraction - that is different than the way that 
some others are doing it. Not better/worse (from what I can tell) - it just 
has different tradeoffs.

-Robin
