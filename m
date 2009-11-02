Return-Path: <linux-kernel-owner+w=401wt.eu-S1756480AbZKBRwB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756480AbZKBRwB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Nov 2009 12:52:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756382AbZKBRwA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Nov 2009 12:52:00 -0500
Received: from icculus.org ([67.106.77.212]:41850 "EHLO icculus.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756137AbZKBRv7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Nov 2009 12:51:59 -0500
Date: Mon, 2 Nov 2009 12:52:00 -0500 (EST)
From: "Ryan C. Gordon" <icculus@icculus.org>
X-X-Sender: icculus@caridad.icculuslan
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
cc: =?ISO-8859-15?Q?M=E5ns_Rullg=E5rd?= <mans@mansr.com>,
       linux-kernel@vger.kernel.org, davem@davemloft.net
Subject: Re: FatELF patches...
In-Reply-To: <20091102000147.424f104b@lxorguk.ukuu.org.uk>
Message-ID: <alpine.OSX.1.10.0911021057450.464@caridad.icculuslan>
References: <alpine.DEB.2.00.0910271410510.16178@andre.icculuslan> <1257103201.2865.6.camel@chumley> <yw1xy6mq0z2s.fsf@unicorn.mansr.com> <alpine.OSX.1.10.0911011540400.53392@caridad.local> <20091102000147.424f104b@lxorguk.ukuu.org.uk>
User-Agent: Alpine 1.10 (OSX 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


(As requested by davem.)

On Mon, 2 Nov 2009, Alan Cox wrote:
> Lets go down the list of "benefits"
> 
> - Separate downloads
> 	- Doesn't work. The network usage would increase dramatically
> 	  pulling all sorts of unneeded crap.

Sure, this doesn't work for everyone, but this list isn't meant to be a 
massive pile of silver bullets. Some of the items are "that's a cool 
trick" and some are "that would help solve an annoyance." I can see a 
use-case for the one-iso-multiple-arch example, but it's not going to be 
Ubuntu.

> 	- Already solved by having a packaging system (in fact FatELF is
> 	  basically obsoleted by packaging tools)

I think I've probably talked this to death, and will again when I reply to 
Julien, but: packaging tools are a different thing entirely. They solve 
some of the same issues, they cause other issues. The fact that Debian is 
now talking about "multiarch" shows that they've experienced some of these 
problems, too, despite having a world-class package manager.

> - Separate lib, lib32, lib64
> 	- So you have one file with 3 files in it rather than three files
> 	  with one file in them. Directories were invented for a reason

We covered this when talking about shell scripts.

> 	- Makes updates bigger

I'm sure, but I'm not sure the increase is a staggering amount. We're not 
talking about making all packages into FatELF binaries.

> 	- Stops users only having 32bit libs for some packages

Is that a serious concern?

> - Third party packagers no longer have to publish multiple rpm/deb etc
> 	- By vastly increasing download size
> 	- By making updates vastly bigger

It's true that /bin/ls would double in size (although I'm sure at least 
the download saves some of this in compression). But how much of, say, 
Gnome or OpenOffice or Doom 3 is executable code? These things would be 
nowhere near "vastly" bigger.

> 	- Assumes data files are not dependant on binary (often not true)

Turns out that /usr/sbin/hald's cache file was. That would need to be 
fixed, which is trivial, but in my virtual machine test I had it delete 
and regenerate the file on each boot as a fast workaround.

The rest of the Ubuntu install boots and runs. This is millions of lines 
of code that does not depend on the byte order, alignment, and word size 
for its data files.

I don't claim to be an expert on the inner workings of every package you 
would find on a Linux system, but like you, I expected there would be a 
lot of things to fix. It turns out that "often not true" just turned out 
to actually _not_ be true at all.

> 	- And is irrelevant really because 90% or more of the cost is
> 	  testing

Testing doesn't really change with what I'm describing. If you want to 
ship a program for PowerPC and x86, you still need to test it on PowerPC 
and x86, no matter how you distribute or launch it.

> - You no longer need to use shell scripts and flakey logic to pick the
>   right binary ...
> 	- Since the 1990s we've used package managers to do that instead.
> 	  I just type "yum install bzflag", the rest is done for me.

Yes, that is true for software shipped via yum, which does not encompass 
all the software you may want to run on your system. I'm not arguing 
against package management.

> - The ELF OSABI for your system changes someday?
> 	- We already handle that

Do we? I grepped for OSABI in the 2.6.31 sources, and can't find anywhere, 
outside of my FatELF patches, where we check an ELF file's OSABI or OSABI 
version at all.

The kernel blindly loads ELF binaries without checking the ABI, and glibc 
checks the ABI for shared libraries--and flatly rejects files that don't 
match what it expects.

Where do we handle an ABI change gracefully? Am I misunderstanding the 
code?

> - Ship a single shared library that provides bindings for a scripting
>   language and not have to worry about whether the scripting language
>   itself is built for the same architecture as your bindings. 
> 	- Except if they don't overlap it won't run

True. If I try to run a PowerPC binary on a Sparc, it fails in any 
circumstance. I recognize the goal of this post was to shoot down every 
single point, but you can't see a scenario where this adds a benefit? Even 
in a world that's still running 32-bit web browsers on _every major 
operating system_ because some crucial plugins aren't 64-bit yet?

> - Ship web browser plugins that work out of the box with multiple
>   platforms.
> 	- yum install just works, and there is a search path in firefox
> 	  etc

So it's better to have a thousand little unique solutions to the same 
problem? Everything has a search path (except things that don't), and all 
of those search paths are set up in the same way (except things that 
aren't). Do we really need to have every single program screwing around 
with their own personal spiritual successor to the CLASSPATH environment 
variable?

> - Ship kernel drivers for multiple processors in one file.
> 	- Not useful see separate downloads

Pain in the butt see "which installer is right for me?"   :)

I don't want to get into a holy war about out-of-tree kernel drivers, 
because I'm totally on board with getting drivers into the mainline. But 
it doesn't change the fact that I downloaded the wrong nvidia drivers the 
other day because I accidentally grabbed the ia32 package instead of the 
amd64 one. So much for saving bandwidth.

I wasn't paying attention. But lots of people wouldn't know which to pick 
even if they were. Nvidia, etc, could certainly put everything in one 
shell script and choose for you, but now we're back at square one again.

This discussion applies to applications, not just kernel modules. 
The applications are more important here, in my opinion.

> - Transition to a new architecture in incremental steps. 
> 	- IFF the CPU supports both old and new

A lateral move would be painful (although Apple just did this very thing 
with a FatELF-style solution, albeit with the help of an emulator), but if 
we're talking about the most common case at the moment, x86 to amd64, it's 
not a serious concern.

> 	- and we can already do that

Not really. compat_binfmt_elf will run legacy binaries on new systems, but 
not vice versa. The goal is having something that will let it work on both 
without having to go through a package manager infrastructure.

> - Support 64-bit and 32-bit compatibility binaries in one file. 
> 	- Not useful as we've already seen

Where did we see that? There are certainly tradeoffs, pros and cons, but 
this is very dismissive despite several counter-examples.

> - No more ia32 compatibility libraries! Even if your distro
>   doesn't make a complete set of FatELF binaries available, they can
>   still provide it for the handful of packages you need for 99% of 32-bit
>   apps you want to run on a 64-bit system. 
> 
> 	- Argument against FatELF - why waste the disk space if its rare ?

This is _not_ an argument against FatELF.

Why install Gimp by default if I'm not an artist? Because disk space is 
cheap in the configurations I'm talking about and it's better to have it 
just in case, for the 1% of users that will want it. A desktop, laptop or 
server can swallow a few megabytes to clean up some awkward design 
decisions, like the /lib64 thing.

A few more megabytes installed may cut down on the support load for 
distributions when some old 32 bit program refuses to start at all.

In a world where terrabyte hard drives are cheap consumer-level 
commodities, the tradeoff seems like a complete no-brainer to me.

> - Have a CPU that can handle different byte orders? Ship one binary that
>   satisfies all configurations!
> 
> 	- Variant of the distribution "advantage" - same problem - its
> 	  better to have two files, its all about testing anyway
> 
> - Ship one file that works across Linux and FreeBSD (without a platform
>   compatibility layer on either of them). 
> 
> 	- Ditto

And ditto from me, too: testing is still testing, no matter how you 
package and ship it. It's just simply not related to FatELF. This problem 
exists in shipping binaries via apt and yum, too.

> - One hard drive partition can be booted on different machines with
>   different CPU architectures, for development and experimentation. Same
>   root file system, different kernel and CPU architecture. 
> 
> 	- Now we are getting desperate.

It's not like this is unheard of. Apple is selling this very thing for 129 
bucks a copy.

> - Prepare your app on a USB stick for sneakernet, know it'll work on
>   whatever Linux box you are likely to plug it into.
> 
> 	- No I don't because of the dependancies, architecture ordering
> 	  of data files, lack of testing on each platform and the fact
> 	  architecture isn't sufficient to define a platform

Yes, it's not a silver bullet. Fedora will not be promising binaries that 
run on every Unix box on the planet.

But the guy with the USB stick? He probably knows the details of every 
machine he wants to plug it into...
 
> - Prepare your app on a network share, know it will work with all
>   the workstations on your LAN. 

...and so does the LAN's administrator.

It's possible to ship binaries that don't depend on a specific 
distribution, or preinstalled dependencies, beyond the existance of a 
glibc that was built in the last five years or so. I do it every day. It's 
not unreasonable, if you aren't part of the package management network, to 
make something that will run, generically on "Linux."

> 	- We have search paths, multiple mount points etc.

I'm proposing a unified, clean, elegant way to solve the problem.

> So why exactly do we want FatELF. It was obsoleted in the early 1990s
> when architecture handling was introduced into package managers.

I can't speak for anyone but myself, but I can see lots of places where it 
would personally help me as a developer that isn't always inside the 
packaging system.

There are programs I support that I just simply won't bother moving to 
amd64 because it just complicates things for the end user, for example.

Goofy one-off example: a game that I ported named Lugaru ( 
http://www.wolfire.com/lugaru ) is being updated for Intel Mac OS X. The 
build on my hard drive will run natively as a PowerPC, x86, and amd64 
process, and Mac OS X just does the right thing on whatever hardware tries 
to launch it. On Linux...well, I'm not updating it. You can enjoy the x86 
version. It's easier on me, I have other projects to work on, and too bad 
for you. Granted, the x86_64 version _works_ on Linux, but shipping it is 
a serious pain, so it just won't ship.

That is anecdotal, and I apologize for that. But I'm not the only 
developer that's not in an apt repository, and all of these rebuttals are 
anecdotal: "I just use yum [...because I don't personally care about 
Debian users]."

The "third-party" is important. If your answer is "you should have 
petitioned Fedora, Ubuntu, Gentoo, CentOS, Slackware and every other 
distro to package it, or packaged it for all of those yourself, or open 
sourced someone else's software on their behalf and let the community 
figure it out" then I just don't think we're talking about the same 
reality at all, and I can't resolve that issue for you.

And, since I'm about to get a flood of "closed source is evil" emails: 
this applies to Free Software too. Take something bleeding edge but open 
source, like, say, Songbird, and you are going to find yourself working 
outside of apt-get to get a modern build, or perhaps a build at all.

In short: I'm glad yum works great for your users, but they aren't all the 
users, and it sure doesn't work well for all developers.

--ryan.

