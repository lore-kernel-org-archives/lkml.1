Return-Path: <linux-kernel-owner+w=401wt.eu-S1753432AbZAFAHs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753432AbZAFAHs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2009 19:07:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751545AbZAFAHj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Jan 2009 19:07:39 -0500
Received: from static-71-162-243-5.phlapa.fios.verizon.net ([71.162.243.5]:53724
	"EHLO grelber.thyrsus.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751481AbZAFAHi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2009 19:07:38 -0500
From: Rob Landley <rob@landley.net>
Organization: Boundaries Unlimited
To: Jamie Lokier <jamie@shareable.org>
Subject: Re: [PATCH 1/3]: Replace kernel/timeconst.pl with kernel/timeconst.sh
Date: Mon, 5 Jan 2009 18:06:53 -0600
User-Agent: KMail/1.10.1 (Linux/2.6.27-7-generic; KDE/4.1.2; x86_64; ; )
Cc: Bernd Petrovitsch <bernd@firmix.at>, Valdis.Kletnieks@vt.edu,
       Ingo Oeser <ioe-lkml@rameria.de>,
       Embedded Linux mailing list <linux-embedded@vger.kernel.org>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       "H. Peter Anvin" <hpa@zytor.com>, Sam Ravnborg <sam@ravnborg.org>
References: <200901020207.30359.rob@landley.net> <1231152378.3326.14.camel@gimli.at.home> <20090105150156.GD14503@shareable.org>
In-Reply-To: <20090105150156.GD14503@shareable.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200901051806.54403.rob@landley.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 05 January 2009 09:01:56 Jamie Lokier wrote:
> Bernd Petrovitsch wrote:
> > I assume that the NFS-mounted root filesystem is a real distribution.
>
> Not unless you call uClinux (MMU-less) a real distribution, no.

I want things to be orthogonal.  The following should be completely separate 
steps:

1) Creating a cross compiler
2) building a native development environment
3) booting a native development environment (on real hardware or under and 
emulator)
4) natively building your target system.

You should be able to mix and match.  Crosstool for #1, go download "fedora 
for arm" instead of #2, qemu or real hardware is your choice for #3, and then 
you should be able to natively build gentoo under an ubuntu host or vice 
versa.  (How is not currently properly documented, but I'm working on that.)

My objection to build systems like buildroot or uClinux is that they bundle 
all this together into a big hairball.  They create their own cross compiler, 
build their own root file system, use their own packaging system, and you have 
to take it all or nothing.

My build system is ruthlessly orthogonal.  I try not to make it depend on 
other bits of _itself_ more than necessary.

> > > (* - No MMU on some ARMs, but I'm working on ARM FDPIC-ELF to add
> > >      proper shared libs.  Feel free to fund this :-)
> >
> > The above mentioned ARMs have a MMU. Without MMU, it would be truly
> > insane IMHO.
>
> We have similar cross-build issues without MMUs... I.e. that a lot of
> useful packages don't cross-build properly (including many which use
> Autoconf), and it might be easier to make a native build environment
> than to debug and patch all the broken-for-cross-build packages.
> Especially as sometimes they build, but fail at run-time in some
> conditions.

If you can get a version of the same architecture with an mmu you can actually 
build natively on that.  It's not ideal (it's a bit like trying to build i486 
code on an i686; the fact it runs on the host is no guarantee it'll run on the 
target), but it's better than cross compiling.  And most things have a broad 
enough compatible "base architecture" that you can mostly get away with it.

> But you're right it's probably insane to try.  I haven't dared as I
> suspect GCC and/or Binutils would break too :-)

Oh it does, but you can fix it. :)

> I'm sticking instead with "oh well cross-build a few packages by hand
> and just don't even _try_ to use most of the handy software out there".

Cross compiling doesn't scale, and it bit-rots insanely quickly.

> You mentioned ARM Debian.  According to
> http://wiki.debian.org/ArmEabiPort one recommended method of
> bootstrapping it is building natively on an emulated ARM, because
> cross-building is fragile.

That's what my firmware linux project does too.  (I believe I was one of the 
first doing this back in 2006, but there are three or four others out there 
doing it now.)

Native compiling under emulation is an idea whose time has come.  Emulators on 
cheap x86-64 laptops today are about as powerful as high end tricked out build 
servers circa 2001, and Moore's Law continues to advance.  More memory, more 
CPU (maybe via SMP but distcc can take advantage of that today and qemu will 
develop threading someday).  You can throw engineering time at the problem 
(making cross compiling work) or you can throw hardware at the problem (build 
natively and buy fast native or emulator-hosting hardware).  The balance used 
to be in favor of the former; not so much anymore.

That said, my drive for reproducibility and orthogonality says that your 
native development environment must be something you can reproduce entirely 
from source on an arbitrary host.  You can't make cross compiling go away 
entirely, the best you can do is limit it to bootstrapping the native 
environment.  But I want to keep the parts I have to cross compile as small 
and simple as possible, and then run a native build script to get a richer 
environment.  For the past 5+ years my definition has been "an environment 
that can rebuild itself under itself is powerful enough, that's all I need to 
cross compile", and from the first time I tried this (late 2002) up until 
2.6.25 that was 7 packages.  That's why I responded to the addition of perl as 
a regression, because for my use case it was.

> -- Jamie

Rob
