Return-Path: <linux-kernel-owner+w=401wt.eu-S1759015AbXHTDmQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759015AbXHTDmQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Aug 2007 23:42:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753813AbXHTDmD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 19 Aug 2007 23:42:03 -0400
Received: from smtp122.sbc.mail.re3.yahoo.com ([66.196.96.95]:29852 "HELO
	smtp122.sbc.mail.re3.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752661AbXHTDmB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Aug 2007 23:42:01 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=mPKMNkIYRferTc2sK551izEPfbcY4vcac6r3MYXQK2gtxus4yiMURWaU031X1sUSfaxo77zLf+9D4zVOgz10UDNkxEu/yfw8XS/4E1E5XVVfjLMhkyR1VdBHUcesz2L0LHaONw9ciZ9vChkQmsL5RmSS4i+c3N3EXFdxM1kQCxg=  ;
X-YMail-OSG: quxPy.4VM1lGSnpYZSSfJQsIqhfX1BxVKrYQAaGiv4goG9QU129fC1ud6wtgeeqdcJFHf0_0bA--
From: David Brownell <david-b@pacbell.net>
To: Robin Getz <rgetz@blackfin.uclinux.org>
Subject: Re: [PATCH 02/12] Blackfin arch: Add label to call new GPIO API
Date: Sun, 19 Aug 2007 20:41:57 -0700
User-Agent: KMail/1.9.6
Cc: "Bryan Wu" <bryan.wu@analog.com>, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       "Michael Hennerich" <michael.hennerich@analog.com>
References: <11865441373719-git-send-email-bryan.wu@analog.com> <200708191454.16527.david-b@pacbell.net> <200708192155.58152.rgetz@blackfin.uclinux.org>
In-Reply-To: <200708192155.58152.rgetz@blackfin.uclinux.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200708192041.57613.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 19 August 2007, Robin Getz wrote:
> On Sun 19 Aug 2007 17:54, David Brownell pondered:
> > On Saturday 18 August 2007, Robin Getz wrote:
> > 
> > > I don't see how early/late makes the problem easier/worse to debug. No
> > > matter when you do it - the driver refuses to install (or at least
> > > should). 
> > 
> > If you arrange to *reliably* detect the pinmux/setup problems by
> > the time the system starts ""init" (early), that means one large
> > class of hard-to-sort problems never needs runtime troubleshooting.
> 
> Sure it does - it just needs to do it in the bootloader, not the kernel.

Kernel arch/.../board-X.c code is the place to "reliably" handle
that.  Bootloader is out-of-scope here; it's a separate codebase.


> You  
> haven't eliminated the problem - or made it any easier to debug - it is just 
> moved somewhere else.

Moved it out of runtime, to a small window before "init" sections
get discarded and "init" is invoked.  So if it ever *could* show
up, it'll show up then ... every time the system boots, a message
will appear.  Easy to notice while the bug is fresh, just from a
developer's routine scan of bootup messages.

The alternative lets the problem appear later, almost randomly,
based on whether the conflicting drivers happen to be loaded
at the same time.  Which *IS* harder to debug.


I still remember the time a board had to be respun because the
hardware guys goofed on use of one signal.  Two different drivers
both needed it ... but until later in system integration, they
were never tested together, so that conflict never showed up.
(It was a non-obvious thing, for on-chip signal routing not the
on-board type verified by module tests in hardware QA and design
review.)

Doing that setup "early" would have prevented that problem, and
avoided one annoying schedule slip and hardware respin.


> Again - this is not bad. We decided/are attempting to  
> do it in the kernel. Normally what we find is there are more kernel people on 
> a project than bootloader (whether this makes this easier - or not - is still 
> TDB :)

I don't know why you're reading what I write as any kind of
preference for doing that in the bootloader.  It's nothing
more than an *acknowledgement* that some vendors work that
way, so Linux is better off with an approach which won't be
broken when they do.  (That is, always having finished pin
mux setup before drivers get probed.)

When Linux does that setup in arch/..../board-X.c files, mostly
before drivers come into play, it's normal for driver code to
ignore it ... which means the bootloader might also have done
it, for those kinds of product.

Usually I'd expect one person on the bootloader, plus ideally
understudies.  Not a full time job; that person might mostly
do kernel development, hardware test/bringup, or something
else depending on how the product team was structured.


> > Remember that I didn't argue in favor of putting that code into
> > boot loaders ... I just pointed out that some product lines work
> > that way, so Linux needs to cope with that strategy.  (One of the
> > many examples involves OpenFirmware device tables.)
> > 
> > But regardless:  I can't buy any argument that it's better to put
> > lots of board-specific code into drivers. 
> 
> I don't think we are putting board specific code in drivers (or if there is - 
> it should get removed).
> 
> I did a quick look, and the only place this has happened is in some of our 
> drivers that have not made it to main line yet

Good!!  If it's not in drivers, I suspect you'll agree that it
will probably all land in that arch/..../board-X.c setup code.


> I agree - which is why don't do this either. Board specific info does not go 
> into drivers. I think this is something that Michael, Bryan and others 
> working on the Blackfin arch & drivers will agree to 100%.
> 
> What we do is try to make the driver agnostic to the hardware as much as 
> possible,

Good ...

> where hardware specifics (chip selects, IRQ, GPIO, etc) are managed  
> in Kconfig.

... IMO less good, but that's all your worry.  I suspect that
by the time you handle a few dozen boards, you'll find Kconfig
is not well suited to this.  (Because of the way it prevents one
kernel from handling multiple boards, unless they really aren't
very different.)


> > Doing that in Kconfig is atypical ... it may well be a bit easier to
> > pick up at the beginning of a developer's learning curve, but I think
> > it doesn't scale very well as multi-board product lines evolve.
> 
> We have lots of end users (obviously not as many as ARM or PPC yet), and they 
> have not been complaining, in fact some say that this is easier to deploy.

These are people already familiar with ARM or PPC embedded Linux?
I guess one question is "easier than what".

Kconfig doesn't try to help with the "give me a minimal .config
for <THIS> hardware" problem; say, by reading "lspci -n" output
or some other system description.  It expects people to know their
way around.  Maybe a bit of a "20 questions" style interface
comes across as providing useful hand-holding; some of that can
be done in Kconfig, but it's still a kind of menu maze.

I'd hope people don't still get degrees for writing automagic
system configuration tools.  Even though it's still not easy.  :)


> But - I think we both agree - that what we are doing is just an alternative 
> implemention of hardware abstraction - that is different than the way that 
> some others are doing it. Not better/worse (from what I can tell) - it just 
> has different tradeoffs.

We could have that discussion in a few years.  I suspect you'll
find less going into Kconfig and more into C code, if for no
other reason than to make sure things scale sanely.  Or if lots
of stuff is in Kconfig ... it'll be in the arch part of the tree
associated with boards, not the driver parts.

- Dave


