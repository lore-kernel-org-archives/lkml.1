Return-Path: <linux-kernel-owner+w=401wt.eu-S1754015AbXG1QHh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754015AbXG1QHh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jul 2007 12:07:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751309AbXG1QH2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Jul 2007 12:07:28 -0400
Received: from static-71-162-243-5.phlapa.fios.verizon.net ([71.162.243.5]:36975
	"EHLO grelber.thyrsus.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750992AbXG1QH1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jul 2007 12:07:27 -0400
From: Rob Landley <rob@landley.net>
Organization: Boundaries Unlimited
To: Bodo Eggert <7eggert@gmx.de>
Subject: Re: [PATCH 0/3][try 1] init: enable system-on-initramfs
Date: Sat, 28 Jul 2007 12:07:24 -0400
User-Agent: KMail/1.9.6
Cc: linux-kernel@vger.kernel.org
References: <Pine.LNX.4.58.0707132039080.3222@be1.lrz> <200707181754.05560.rob@landley.net> <Pine.LNX.4.58.0707191442440.2138@be1.lrz>
In-Reply-To: <Pine.LNX.4.58.0707191442440.2138@be1.lrz>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200707281207.24998.rob@landley.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I had this unsent on my desktop, buried by other windows.  Let me know if the 
conversation's moved on since, but if so I wasn't cc'd...

On Thursday 19 July 2007 9:56:11 am Bodo Eggert wrote:
> On Wed, 18 Jul 2007, Rob Landley wrote:
> > On Friday 13 July 2007 2:56:00 pm Bodo Eggert wrote:
> > > I toyed with setting up a diskless system in initramfs. In the process,
> > > I came across some things:
> > >
> > > 1)  There is no way to have the kernel not mount a filesystem,
> > >     unless you use /init or rdinit=.
> >
> > Er, yes.  By design.
> >
> > The kernel has to run an init program in order to hand off control to
> > userspace.  In initramfs, this is defined as /init.  It looks in exactly
> > one documented place.
> >
> > The older root= mechanism fell back to a half-dozen places (eventually
> > trying things like /bin/sh if it couldn't find anything else).  This is
> > because there wasn't a documented standard for what should be executed,
> > like there is with initramfs.
>
> Ever since I started using linux in 1997, the first program to run from an
> installed system was /sbin/init. (I might think about removing the other
> paths.)

So pass in rdinit=/sbin/init.  (Back in 1997 you didn't have to 
specify "root=", you used rdev.)

> The ramfs' /init was intended for system setup, which is a separate job.

The ramfs /init was "intended" to be the first process to run, which inherits 
PID 1 and thus all responsibility for further system setup.  You can't return 
back to the kernel from that, it panics if PID 1 exits.  Whether you choose 
to do "system setup" or keep running with rootfs as your root filesystem 
(very popular with embedded devices) is not the kernel's problem.

This has been documented and has worked fine for years.

Note that the initrd mechanism (which used to run /linuxrc) was _not_ PID 1, 
and expected you to return to the kernel.  That's one of the big improvements 
initramfs made over initrd.

> It is not intended to be the program running the system.

That's policy, and none of the kernel's business.

> Mixing those two 
> up just does not feel right.

You're mixing them in your head, and it sounds like you don't understand what 
it's doing.

> Setting root= in order to change the root 
> directory is much more natural.

Setting root= is not _used_ if initramfs triggers, because /init gets run 
before ever reaching that code.  In initramfs, the root filesystem is rootfs, 
and no attempt to mount anything else is made by the kernel unless userspace 
explicitly asks for it.  Userspace is welcome to mount anything it wants, and 
userspace can switch_root to it, but that's not the kernel's problem.

> > > 1a) In the process of writing these patches, I found prepare_namespace
> > > not to be called if /init is present. prepare_namespace will call
> > >     security_sb_post_mountroot after mounting the root fs. I did not
> > > yet see a way to call this from /init, and grepping kinit for
> > > "security" did not help, too.
> >
> > I don't use selinux.  I'm neither a Fortune 500 company nor the NSA.
>
> That's no reason for keeping bugs in that part.

*shrug*  I was saying I can't really comment much on a subsystem I neither use 
nor see much point in.

> > However, if you don't trust your own initramfs, where everything starts
> > out running as root, you have bigger problems.
>
> Using that argument, you can deduce that nobody would need selinux at all.

Yeah, pretty much.  Then again I feel the same way about the Itanium, and try 
to stay out of the way of people who feel they do need it.

> Obviously some people disagree, and maybe some of them are no fools,
> therefore we should try to DTRT for them and do the callback when it's
> supposed to happen.
>
> BTW: The problems start as soon as you have to do "reflections on trusting
> trust".

Which led to David Wheeler's "diverse double-compiling": 
http://www.dwheeler.com/trusting-trust/

Which led to rather a lot of patches being integrated into the tcc fork I 
maintain in my nonexistent free time, such as: 
http://www.landley.net/hg/tinycc?cs=e6ddaffce6a8

> > > Using tmpfs instead for the first root mount is as cheap as
> > > using ramfs, as long as tmpfs is used anyway (and most likely it is).
> >
> > *shrug*  I don't object to doing so, but I've heard nebulous technical
> > objections from people who know more about the implementation details fo
> > tmpfs than I do.
>
> Obviously these problems were solved.

I'm all for a patch to make initramfs use tmpfs.  I'm kind of dubious about 
one coming from somebody who thinks that the initramfs interface in use by 
thousands of developers for years now needs to be totally rewritten as a 
prerequisite of doing so.

> > > 2a) I figured if you prepared the root fs to contain a running system,
> > > you woud probably also set up a runnable system on it.
> >
> > *scratches head*
> >
> > That's a tautology, right?
>
> You may also use the same kernel with the same initramfs in order to start
> a classic system, just by changing root=.

Do you mean if you program initramfs to parse the environment variable "root", 
or if you set rdinit=/nonexistent and fall back to the old root= code?

> > I have no idea what you just said.  If there's an /init, we boot from it.
> >  If there's no /init, they just violated the spec and we don't know what
> > to boot from.
>
> These patches changes the spec in order to support system-on-rootfs:

When I said the existing initramfs interface has been "in use by thousands of 
developers for years now", I wasn't speaking metaphorically.  I was speaking 
from personal experience.

Hi.  I used to maintain busybox, which is probably _the_ most widely used 
embedded Linux package.  I wrote the kernel's current 
Documentation/filesystems/ramfs-rootfs-initramfs.txt and some other random
documentation on initramfs (http://linuxdevices.com/articles/AT4017834659.html 
and http://www.timesys.com/timesource/initramfs.htm).  I have personally 
taken apart a dozen or more different systems using "system-on-rootfs", and 
know _of_ over a hundred.  I can tell you the plusses and minuses of doing 
that vs jffs2 vs squashfs vs ext2.  Entire system generators like buildroot 
and uClinux create initramfs images by default.

This is why I'm fairly certain the current initramfs interface is usable by a 
large variety of people.

> If there is an init, it will run. No change from the current situation
> ever, at least if not using rdev.
>
> If you use root=rootfs, a system-on-rootfs will run.
>
> If you use rootfs=tmpfs, root= will default to rootfs, and I did it in a
> way disabeling that obsolete rdev.

The way to specify a filesystem type to go with the mount "root=" does is 
actually "rootfstype=".  I use this when mounting a hostfs root for User Mode 
Linux, ala this woefully out of date document:
http://landley.net/writing/docs/UML.html

You don't specify a filesystem type for "root=", you specify a path there.

> > They made an initramfs.  They constructed it, explicitly, for the Linux
> > kernel, and /init is what the kernel will try to boot.  I documented this
> > years ago.  If they chose not to put an /init, then they didn't want us
> > to boot from initramfs.  (Maybe they're supplying firmware and an
> > /sbin/hotplug for a statically linked device.  I dunno.)
>
> Not booting /using/ an intramfs differs from not booting /from/ an
> intramfs. Mixing them works by accident.

I have no idea what you just said.

> > >     Unfortunately the way I do it, this will override the rdev setting,
> > > but that should be OK, since rdev is dead. Isn't it?
> > >
> > > 3)  While I was at it, I figured I would not need most of the
> > > init/mount* code anymore. Therefore I made patch 3, which ifdefs it out
> > > as far as possible while still aiming for a small change.
> > >
> > > Patch 1 adds the capability to use root=rootfs.
> >
> > I've been using initramfs since back around 2.6.12.  It works fine.  Why
> > are you patching the kernel for something that already works?
>
> Why do you build a way if walking through the fields already works?
> Besides that, using all these features safes about 3KB.

An option to removing the "root=" infrastructure that never gets reached if 
you use initramfs should save space, yes.  The other stuff you added just 
shows you don't seem to understand the existing, documented way to use 
initramfs.

Rob
-- 
"One of my most productive days was throwing away 1000 lines of code."
  - Ken Thompson.
