Return-Path: <linux-kernel-owner+w=401wt.eu-S1757317AbXJKUPI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757317AbXJKUPI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2007 16:15:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754425AbXJKUO5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Oct 2007 16:14:57 -0400
Received: from static-71-162-243-5.phlapa.fios.verizon.net ([71.162.243.5]:56428
	"EHLO grelber.thyrsus.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751632AbXJKUO4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2007 16:14:56 -0400
From: Rob Landley <rob@landley.net>
Organization: Boundaries Unlimited
To: Finn Thain <fthain@telegraphics.com.au>
Subject: Re: [PATCH] Make m68k cross compile like every other architecture.
Date: Thu, 11 Oct 2007 16:14:39 -0500
User-Agent: KMail/1.9.6
Cc: Geert Uytterhoeven <geert@linux-m68k.org>, Sam Ravnborg <sam@ravnborg.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Linux/m68k <linux-m68k@vger.kernel.org>
References: <200710101722.21126.rob@landley.net> <Pine.LNX.4.64.0710111707270.3729@anakin> <Pine.LNX.4.64.0710120211130.4083@loopy.telegraphics.com.au>
In-Reply-To: <Pine.LNX.4.64.0710120211130.4083@loopy.telegraphics.com.au>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710111614.39879.rob@landley.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 11 October 2007 11:26:07 am Finn Thain wrote:
> On Thu, 11 Oct 2007, Geert Uytterhoeven wrote:
> > > Reading the patch in that link, recent cross compilers from _where_?
> > > Buildroot?  Cross-tools?  Gentoo embedded?  Cross Linux From Scratch?
> > > My Firmware Linux project?
> > >
> > > You assume they all use the same name, yet your patch changes them
> > > from one default name to another default name, presumably due to a gcc
> > > version change becoming increasingly political about the
> > > GNU/Linux/Dammit thing...
> >
> > Compilers build from the only remaining distribution that supports (sort
> > of) m68k: Debian.
>
> Maybe. I use an old Cross LFS build, as well as Debian (does Debian
> officially support m68k?), and there also exists an unofficial Gentoo
> port.

I noticed the cruft in this target because I'm attempting to support it in 
Firmware Linux (http://landley.net/code/firmware), on the theory that a patch 
was posted to the qemu mailing list to add m68k support to qemu, so it's 
probably only a matter of time until it gets merged and an m68k system board 
added to the emulator: 
http://lists.gnu.org/archive/html/qemu-devel/2007-07/msg00015.html

If the _goal_ is that Debian be the only distribution to support m68k, then 
obviously the name it uses can be hardwired into the code because that's all 
that can ever matter, by definition.

> > If you cross compile for m68k and don't specify a toolchain, you get a
> > default one: the one the m68k developers use.
> >
> > On some other architectures, you always have to specify the toolchain.
> > What's wrong with providing a default?
>
> Nothing, except that uniformity across platforms follows the principal of
> least suprise. That generally makes life easier downstream.
>
> I personally have created and used m68k cross toolchains as "m68k-linux",
> "m68k-linux-gnu" and "m68k-unknown-linux-gnu". AFAIK it's quite arbitrary.

My toolchains override the default prefix to just the target, resulting 
in "m68k-gcc".  (It's shorter, and when you're creating a dozen toolchains 
having them all say -linux- in the middle of every command name gets a bit 
silly...)

When it started complaining about "m68k-linux-gnu-gcc" (which is _not_ what my 
cross compiler is called) I spent half an hour tracking down where it was 
getting that name from and what exactly was going on.  (Was my build script 
supplying the wrong name?  Did something set an environment variable it 
shouldn't have?  Did the gcc build suddenly reveal another strange buried 
corner case that made it revert to a default against explicit instructions 
_again_?)

When I found the surprising behavior that cost me time and effort to diagnose, 
I submitted a patch so it wouldn't confuse future developers the first time 
_they_ try to build m68k.  (Yes, I think there might be such.  Call me 
crazy.)  I've seen "didn't specify any cross compiler" failures before, on 
arm and x86-64 and mips and sparc and so on.  I've seen it in the linux 
kernel, in busybox, in uClibc, and in various gnu packages 
with ./configureitis.  This is the first time I've seen a package confidently 
decide for itself to use a compiler name that isn't in the $PATH, and 
especially the first time I've seen Linux do it.  It cost me time to 
disagnose because it looks like it's getting a CROSS_COMPILE setting from its 
environment somehow, and the logical thing to do is look at that environment 
(and the build scripts driving it, and the temp files) to see where such a 
thing might be leaking in from.  The fact it might be hallucinating its own 
value was not my first guess, because nothing else I've encountered does that 
in this context.

> This wasn't an issue before we came to depend on cross compilers. Since we
> tend to need them more as compilation becomes more expensive, IMHO we
> should follow the practice of the embedded architectures.

That topic's a can of worms, but I point out that you always needed a cross 
compiler to bootstrap a new platform. :)

If you're going to support cross compiling at all, you might as well do it 
more or less consistently for all targets.

Rob
-- 
"One of my most productive days was throwing away 1000 lines of code."
  - Ken Thompson.
