Return-Path: <linux-kernel-owner+w=401wt.eu-S1762099AbXEJK1I@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762099AbXEJK1I (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2007 06:27:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762297AbXEJK0B
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 May 2007 06:26:01 -0400
Received: from mailhub.sw.ru ([195.214.233.200]:40835 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762288AbXEJKZ7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2007 06:25:59 -0400
Date: Thu, 10 May 2007 14:33:51 +0400
From: Alexey Dobriyan <adobriyan@sw.ru>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Ken Chen <kenchen@google.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org,
       Kay Sievers <kay.sievers@vrfy.org>
Subject: Re: 2.6.21-git11: BUG in loop.ko
Message-ID: <20070510103351.GA6105@localhost.sw.ru>
References: <46425EC9.5070209@goop.org> <20070509170521.ec2c9ae7.akpm@linux-foundation.org> <4642656B.9020501@goop.org> <20070510073949.GA6068@localhost.sw.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070510073949.GA6068@localhost.sw.ru>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 10, 2007 at 11:39:49AM +0400, Alexey Dobriyan wrote:
> On Wed, May 09, 2007 at 05:20:59PM -0700, Jeremy Fitzhardinge wrote:
> > 100% reliable, but a bit obscure.  I'm booting an FC6 livecd with a
> > paravirt_ops kernel under Xen.  The relevant part of the iso's initrd
> > script is:
> >
> > + mknod /dev/loop118 b 7 118
> > + mknod /dev/loop119 b 7 119
> > + mknod /dev/loop120 b 7 120
> > + mknod /dev/loop121 b 7 121
> > + mkdir -p /dev/mapper
> > + mknod /dev/mapper/control c 10 63
> > + modprobe loop max_loop=128
> > loop: the max_loop option is obsolete and will be removed in March 2008
> > loop: module loaded
> > + modprobe dm_snapshot
> > device-mapper: ioctl: 4.11.0-ioctl (2006-10-12) initialised: dm-devel@redhat.com
> > + '[' 0 == 1 ']'
> > + losetup /dev/loop120 /sysroot/squashfs.img
> > ------------[ cut here ]------------
> > kernel BUG at /home/jeremy/hg/xen/paravirt/linux/include/linux/module.h:396!
> > invalid opcode: 0000 [#1]
> > PREEMPT SMP
> > Modules linked in: dm_snapshot dm_mod loop
> > CPU:    0
> > EIP:    0061:[<d085a911>]    Not tainted VLI
> > EFLAGS: 00010246   (2.6.21-paravirt #1339)
> > [...]
>
> This must be caused by dynamic loop devices creation patch
>
> Steps to reproduce:
>
> 	mknod foo b 7 1
> 	losetup foo 1.img
>
> where "7 1" is major/minor pair which doesn't created by udev et al
> after module loading.

I don't understand what "+ 1" is doing in lo_open(). Off by one?
It's removal would certainly fix creation of random number of loop
devices after just "losetup -a".

Also refcount of loop module can be made negative via

	mknod foo b 7 42
	losetup -d foo		# sic

