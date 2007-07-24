Return-Path: <linux-kernel-owner+w=401wt.eu-S1760824AbXGXWBI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760824AbXGXWBI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2007 18:01:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756196AbXGXWA4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jul 2007 18:00:56 -0400
Received: from deine-taler.de ([217.160.107.63]:52966 "EHLO deine-taler.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756227AbXGXWAz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2007 18:00:55 -0400
Date: Wed, 25 Jul 2007 00:00:53 +0200
From: Ulrich Kunitz <kune@deine-taler.de>
To: Chuck Ebbert <cebbert@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
       honza@jikos.cz, jkosina@suse.cz
Subject: Re: Is PIE randomization breaking klibc binaries?
Message-ID: <20070724220053.GA20531@deine-taler.de>
References: <20070720211300.GA21644@deine-taler.de> <46A131BF.4080404@zytor.com> <46A6624E.60003@redhat.com> <46A667BD.5080106@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46A667BD.5080106@redhat.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 07-07-24 16:57 Chuck Ebbert wrote:

> > $ strace ./cat
> > execve("./cat", ["./cat"], [/* 55 vars */]) = -1 ENOENT (No such file or directory)
> > ...

Chuck, my binaries run always into a segmentation violation. So
ENOENT is not the issue. (Notify it was on an x86-64.)

> > $ file cat
> > cat: ELF 32-bit LSB executable, Intel 80386, version 1 (SYSV), statically linked (uses shared libs), stripped
> > 
> > Funny nobody noticed that before...
> > 
> 
> After installing klibc.so and klibc-<ID>.so into /lib everything works:
> 
> Program Headers:
>   Type           Offset   VirtAddr   PhysAddr   FileSiz  MemSiz   Flg Align
>   PHDR           0x000034 0x08048034 0x08048034 0x0000a0 0x0000a0 R E 0x4
>   INTERP         0x0000d4 0x080480d4 0x080480d4 0x00002a 0x00002a R   0x1
>         [Requesting program interpreter: /lib/klibc-58kBUyV_qhVvkMnaxy8A7N8rLak.so]
> 

Yes, these files were present in the initrd.img file. I checked it
by unpacking the initrd.img file. Notify also that I used
git-bisect to identify the PIE patch. This requires successful
builds. Reverting the patch clearly resolved the issue at the end.

> Ulrich, did your initrd contain the correct .so?

Sure! I have only one klibc-*.so on my box in /lib. I diffed the
file in the unpacked initrd.img with the file in /lib and there
has been no difference.

I always recreate the initial ramdisk after the kernel rebuild
with make install and my own installkernel script, which uses
mkinitramfs. The mkinitramfs script ensures that the klibc so
object from /lib and the klibc binaries from /usr/lib/klibc/bin
are copied into the initrd image. Usually that works without any
issue on x86, x86-64. PPC can't use make install, but I use
mkinitramfs there too, which handles klibc the same way.

> Did you try rebuilding klibc after building the new kernel?

Rebuilding klibc doesn't make sense from my point of view. What
should be the point of it?

-- 
Uli Kunitz
