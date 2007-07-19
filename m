Return-Path: <linux-kernel-owner+w=401wt.eu-S939179AbXGSOLB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S939179AbXGSOLB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 10:11:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S938326AbXGSN4v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 09:56:51 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:59057 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S938314AbXGSN4u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 09:56:50 -0400
Date: Thu, 19 Jul 2007 15:56:11 +0200 (CEST)
From: Bodo Eggert <7eggert@gmx.de>
To: Rob Landley <rob@landley.net>
cc: Bodo Eggert <7eggert@gmx.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/3][try 1] init: enable system-on-initramfs
In-Reply-To: <200707181754.05560.rob@landley.net>
Message-ID: <Pine.LNX.4.58.0707191442440.2138@be1.lrz>
References: <Pine.LNX.4.58.0707132039080.3222@be1.lrz> <200707181754.05560.rob@landley.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-be10.7eggert.dyndns.org-MailScanner-Information: See www.mailscanner.info for information
X-be10.7eggert.dyndns.org-MailScanner: Found to be clean
X-be10.7eggert.dyndns.org-MailScanner-From: 7eggert@gmx.de
X-Provags-ID: V01U2FsdGVkX1+zBPcvgwiQVHjMA2gwNWV0s6CthYT3LoG1wQE
 Mdbx6wd09ydS4OC4zQLoMFle8ZrVU8QEpYhBesoEbf5EePbu9R
 8iW/gCLCW1vPHWXwJsz1w==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 18 Jul 2007, Rob Landley wrote:
> On Friday 13 July 2007 2:56:00 pm Bodo Eggert wrote:

> > I toyed with setting up a diskless system in initramfs. In the process, I
> > came across some things:
> >
> > 1)  There is no way to have the kernel not mount a filesystem,
> >     unless you use /init or rdinit=.
> 
> Er, yes.  By design.
> 
> The kernel has to run an init program in order to hand off control to 
> userspace.  In initramfs, this is defined as /init.  It looks in exactly one 
> documented place.
> 
> The older root= mechanism fell back to a half-dozen places (eventually trying 
> things like /bin/sh if it couldn't find anything else).  This is because 
> there wasn't a documented standard for what should be executed, like there is 
> with initramfs.

Ever since I started using linux in 1997, the first program to run from an
installed system was /sbin/init. (I might think about removing the other 
paths.)

The ramfs' /init was intended for system setup, which is a separate job.
It is not intended to be the program running the system. Mixing those two
up just does not feel right. Setting root= in order to change the root
directory is much more natural.

> > 1a) In the process of writing these patches, I found prepare_namespace not
> > to be called if /init is present. prepare_namespace will call
> >     security_sb_post_mountroot after mounting the root fs. I did not yet
> > see a way to call this from /init, and grepping kinit for "security" did
> > not help, too.
> 
> I don't use selinux.  I'm neither a Fortune 500 company nor the NSA.

That's no reason for keeping bugs in that part.

> However, if you don't trust your own initramfs, where everything starts out 
> running as root, you have bigger problems.

Using that argument, you can deduce that nobody would need selinux at all.
Obviously some people disagree, and maybe some of them are no fools,
therefore we should try to DTRT for them and do the callback when it's
supposed to happen.

BTW: The problems start as soon as you have to do "reflections on trusting 
trust".

> >    This is probably a bug, but using the features of this patchset, you'll
> >    avoid hitting it. Therefore this patchset does nothing about that.
> >
> > 2)  If you want to use tmpfs, you need a script which essentially
> > duplicates the work the kernel just did: Mount the root fs, unpack or move
> > the files.
> 
> mkdir sub
> mount -t tmpfs sub sub
> cp -ax / sub
> switch_root sub /init-stage-2
> 
> I haven't tried it but it really doesn't sound like brain surgery.  If your 
> switch_root is statically linked, you can use mv instead of cp.

Why should I have to do that if I can do the right thing in the first 
place with in each respect negative costs?

> > Using tmpfs instead for the first root mount is as cheap as 
> > using ramfs, as long as tmpfs is used anyway (and most likely it is).
> 
> *shrug*  I don't object to doing so, but I've heard nebulous technical 
> objections from people who know more about the implementation details fo 
> tmpfs than I do.

Obviously these problems were solved.

> > 2a) I figured if you prepared the root fs to contain a running system, you
> >     woud probably also set up a runnable system on it.
> 
> *scratches head*
> 
> That's a tautology, right?

You may also use the same kernel with the same initramfs in order to start
a classic system, just by changing root=. This may be nice for rescue
systems. Off cause after applying the third patch, you may also unselect
that feature.

> >     Therefore I changed 
> >     the default to boot from tmpfs if there was no /init nor a root=
> > option. (If there is a /init, it will be executed as usural.)
> 
> I have no idea what you just said.  If there's an /init, we boot from it.  If 
> there's no /init, they just violated the spec and we don't know what to boot 
> from.

These patches changes the spec in order to support system-on-rootfs:

If there is an init, it will run. No change from the current situation 
ever, at least if not using rdev.

If you use root=rootfs, a system-on-rootfs will run.

If you use rootfs=tmpfs, root= will default to rootfs, and I did it in a 
way disabeling that obsolete rdev.

> They made an initramfs.  They constructed it, explicitly, for the Linux 
> kernel, and /init is what the kernel will try to boot.  I documented this 
> years ago.  If they chose not to put an /init, then they didn't want us to 
> boot from initramfs.  (Maybe they're supplying firmware and an /sbin/hotplug 
> for a statically linked device.  I dunno.)

Not booting /using/ an intramfs differs from not booting /from/ an 
intramfs. Mixing them works by accident.

> >     Unfortunately the way I do it, this will override the rdev setting, but
> >     that should be OK, since rdev is dead. Isn't it?
> >
> > 3)  While I was at it, I figured I would not need most of the init/mount*
> >     code anymore. Therefore I made patch 3, which ifdefs it out as far as
> >     possible while still aiming for a small change.
> >
> > Patch 1 adds the capability to use root=rootfs.
> 
> I've been using initramfs since back around 2.6.12.  It works fine.  Why are 
> you patching the kernel for something that already works?

Why do you build a way if walking through the fields already works?
Besides that, using all these features safes about 3KB.
-- 
bus error. passengers dumped.
