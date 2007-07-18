Return-Path: <linux-kernel-owner+w=401wt.eu-S935591AbXGRWlq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935591AbXGRWlq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2007 18:41:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932488AbXGRWkU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jul 2007 18:40:20 -0400
Received: from static-71-162-243-5.phlapa.fios.verizon.net ([71.162.243.5]:51876
	"EHLO grelber.thyrsus.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934216AbXGRWkR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2007 18:40:17 -0400
From: Rob Landley <rob@landley.net>
Organization: Boundaries Unlimited
To: Bodo Eggert <7eggert@gmx.de>
Subject: Re: [PATCH 0/3][try 1] init: enable system-on-initramfs
Date: Wed, 18 Jul 2007 17:54:05 -0400
User-Agent: KMail/1.9.6
Cc: linux-kernel@vger.kernel.org
References: <Pine.LNX.4.58.0707132039080.3222@be1.lrz>
In-Reply-To: <Pine.LNX.4.58.0707132039080.3222@be1.lrz>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707181754.05560.rob@landley.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 13 July 2007 2:56:00 pm Bodo Eggert wrote:
> I toyed with setting up a diskless system in initramfs. In the process, I
> came across some things:
>
> 1)  There is no way to have the kernel not mount a filesystem,
>     unless you use /init or rdinit=.

Er, yes.  By design.

The kernel has to run an init program in order to hand off control to 
userspace.  In initramfs, this is defined as /init.  It looks in exactly one 
documented place.

The older root= mechanism fell back to a half-dozen places (eventually trying 
things like /bin/sh if it couldn't find anything else).  This is because 
there wasn't a documented standard for what should be executed, like there is 
with initramfs.

> 1a) In the process of writing these patches, I found prepare_namespace not
> to be called if /init is present. prepare_namespace will call
>     security_sb_post_mountroot after mounting the root fs. I did not yet
> see a way to call this from /init, and grepping kinit for "security" did
> not help, too.

I don't use selinux.  I'm neither a Fortune 500 company nor the NSA.

However, if you don't trust your own initramfs, where everything starts out 
running as root, you have bigger problems.

>    This is probably a bug, but using the features of this patchset, you'll
>    avoid hitting it. Therefore this patchset does nothing about that.
>
> 2)  If you want to use tmpfs, you need a script which essentially
> duplicates the work the kernel just did: Mount the root fs, unpack or move
> the files.

mkdir sub
mount -t tmpfs sub sub
cp -ax / sub
switch_root sub /init-stage-2

I haven't tried it but it really doesn't sound like brain surgery.  If your 
switch_root is statically linked, you can use mv instead of cp.

> Using tmpfs instead for the first root mount is as cheap as 
> using ramfs, as long as tmpfs is used anyway (and most likely it is).

*shrug*  I don't object to doing so, but I've heard nebulous technical 
objections from people who know more about the implementation details fo 
tmpfs than I do.

> 2a) I figured if you prepared the root fs to contain a running system, you
>     woud probably also set up a runnable system on it.

*scratches head*

That's a tautology, right?

>     Therefore I changed 
>     the default to boot from tmpfs if there was no /init nor a root=
> option. (If there is a /init, it will be executed as usural.)

I have no idea what you just said.  If there's an /init, we boot from it.  If 
there's no /init, they just violated the spec and we don't know what to boot 
from.

They made an initramfs.  They constructed it, explicitly, for the Linux 
kernel, and /init is what the kernel will try to boot.  I documented this 
years ago.  If they chose not to put an /init, then they didn't want us to 
boot from initramfs.  (Maybe they're supplying firmware and an /sbin/hotplug 
for a statically linked device.  I dunno.)

>     Unfortunately the way I do it, this will override the rdev setting, but
>     that should be OK, since rdev is dead. Isn't it?
>
> 3)  While I was at it, I figured I would not need most of the init/mount*
>     code anymore. Therefore I made patch 3, which ifdefs it out as far as
>     possible while still aiming for a small change.
>
> Patch 1 adds the capability to use root=rootfs.

I've been using initramfs since back around 2.6.12.  It works fine.  Why are 
you patching the kernel for something that already works?

> Patch 2 adds the capability to use tmpfs for root, default root=rootfs.
>         ramfs becomes optional if rootfs=tmpfs.
> Patch 3 allows to remove the capability of automounting filesystems.
>
> All patches appyl to 2.6.22.1

Rob
-- 
"One of my most productive days was throwing away 1000 lines of code."
  - Ken Thompson.
