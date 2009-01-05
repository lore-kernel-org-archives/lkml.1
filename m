Return-Path: <linux-kernel-owner+w=401wt.eu-S1754837AbZAEVIY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754837AbZAEVIY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2009 16:08:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752262AbZAEVIO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Jan 2009 16:08:14 -0500
Received: from static-71-162-243-5.phlapa.fios.verizon.net ([71.162.243.5]:45668
	"EHLO grelber.thyrsus.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752139AbZAEVIM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2009 16:08:12 -0500
From: Rob Landley <rob@landley.net>
Organization: Boundaries Unlimited
To: Bernd Petrovitsch <bernd@firmix.at>
Subject: Re: [PATCH 1/3]: Replace kernel/timeconst.pl with kernel/timeconst.sh
Date: Mon, 5 Jan 2009 15:07:25 -0600
User-Agent: KMail/1.10.1 (Linux/2.6.27-7-generic; KDE/4.1.2; x86_64; ; )
Cc: Jamie Lokier <jamie@shareable.org>, Valdis.Kletnieks@vt.edu,
       Ingo Oeser <ioe-lkml@rameria.de>,
       Embedded Linux mailing list <linux-embedded@vger.kernel.org>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       "H. Peter Anvin" <hpa@zytor.com>, Sam Ravnborg <sam@ravnborg.org>
References: <200901020207.30359.rob@landley.net> <20090105022349.GB1345@shareable.org> <1231152378.3326.14.camel@gimli.at.home>
In-Reply-To: <1231152378.3326.14.camel@gimli.at.home>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200901051507.26453.rob@landley.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 05 January 2009 04:46:18 Bernd Petrovitsch wrote:
> > My 850 Linux boxes are 166MHz ARMs and occasionally NFS-mounted.
> > Their /bin/sh does not do $((...)), and Bash is not there at all.
>
> I assume that the NFS-mounted root filesystem is a real distribution.
> And on the local flash is a usual busybox based firmware.

Building on an nfs mount is evil.  Make cares greatly about timestamp 
accuracy, and NFS's dentry cacheing doesn't really, especially when it 
discards cached copies and re-fetches them, and the server and client's clocks 
are a half-second off from each other.

Sometimes you haven't got a choice, but I hate having to debug the build 
problems this intermittently causes.  If you never do anything except "make 
all" it should suck less.

> > If I were installing GCC natively on them, I'd install GNU Make and a
> > proper shell while I were at it.  But I don't know if Bash works
>
> ACK.
>
> > properly without fork()* - or even if GCC does :-)
> >
> > Perl might be hard, as shared libraries aren't supported by the
> > toolchain which targets my ARMs* and Perl likes its loadable modules.
>
> The simplest way to go is probably to use CentOS or Debian or another
> ready binary distribution on ARM (or MIPS or PPC or whatever core the
> embedded system has) possibly on a custom build kernel (if necessary).

Building natively on target hardware or under QEMU is growing in popularity.  
That's how the non-x86 versions of major distros build, and they even have 
policy documents about it.

Here's Fedora's:
http://fedoraproject.org/wiki/Architectures/ARM#Native_Compilation

And here are the guys who opened the door for Ubuntu's official Arm port:
http://mojo.handhelds.org/files/HandheldsMojo_ELC2008.pdf

Of course hobbyists like myself haven't got the budget to buy a cluster of 
high-end arm systems and they're not always even _available_ for things like 
cris, and for new architectures (Xylinx microblaze anyone?) you'll always have 
to cross compile to bootstrap the first development environment on 'em anyway, 
and it's nice for your environment to be _reproducible_...

So a more flexible approach is to cross compile just enough to get a working 
native development environment on the target, and then continue the build 
natively (whether it's under qemu or on a sufficiently powerful piece of 
target hardware).  That's what my "art piece" Firmware Linux project does, and 
there's a scratchbox rewrite (sbox2, 
http://www.freedesktop.org/wiki/Software/sbox2 ) that does the same sort of 
thing, and there are others out there in various states of development.  With 
x86 hardware so cheap and powerful, building under emulation for less powerful 
targets starts to make sense.

Building natively under emulation (QEMU) is available to hobbyists like me and 
avoids most of the fun cross compiling issues you don't find out about until 
after you've shipped the system and somebody tries to do something with it you 
didn't test.  So far the record for diagnosing one of these is the two full-
time weeks my friend Garrett spent back at TimeSys tracking down why perl 
signal handling wasn't working on mips; turned out it was using x86 signal 
numbers rather which don't match the mips ones.  The BSP had been shipping for 
over a year at that point, but nobody had ever tried to do signal handling in 
perl on mips before, and since the perl ./configure step is written in perl 
finding the broken part took some doing.  This was back in the mists of early 
2007 so it's ancient history by now, of course...

If you have set up a cross compiler, you can configure QEMU to use distcc to 
call out through its virtual network to the cross compiler running on the 
host, which gives you a speed boost without reintroducing most of the horrible 
cross compiling issues: there's still only a native toolchain so your build 
doesn't have to keep two contexts (hostcc/targetcc) straight, ./configure 
still runs natively so any binaries it builds can run and any questions it 
asks about the host it's building on should give the right answers for the 
target it's building for (including uname -m and friends), headers are 
#included natively and libraries are linked natively (that's just how distcc 
works, preprocessing and linking happen on the local machine) and there's only 
one set so they can't accidentally mix and the cross compiler isn't even 
_involved_ in that, make runs natively so it won't get confused by strange 
environment variables (yeah, seen that one)...)  Only the heavy lifting of 
compiling preprocessed .c files to .o files gets exported, which is the one 
thing the cross compiler can't really screw up.

But bootstraping a native build environment to run under the emulator is 
something you want to keep down to as few packages as possible, because if 
you're trying to get the same behavior across half a dozen boards, cross 
compiling breaks every time you upgrade _anything_.

> [...]
>
> > (* - No MMU on some ARMs, but I'm working on ARM FDPIC-ELF to add
> >      proper shared libs.  Feel free to fund this :-)
>
> The above mentioned ARMs have a MMU. Without MMU, it would be truly
> insane IMHO.

Without an mmu you have a restricted set of packages that run anyway.  No 
variable length stacks, you have to use vfork() instead of fork() (no copy on 
write), memory fragmentation is a big problem so malloc() fails way more 
often...

So toolchain problems aren't a "hump" to get past on nommu systems: the area 
past that it isn't necessarily any easier.

> 	Bernd

Rob
