Return-Path: <linux-kernel-owner+w=401wt.eu-S1758017AbXEJHcg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758017AbXEJHcg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2007 03:32:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756542AbXEJHca
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 May 2007 03:32:30 -0400
Received: from mailhub.sw.ru ([195.214.233.200]:34035 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756508AbXEJHc3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2007 03:32:29 -0400
Date: Thu, 10 May 2007 11:39:49 +0400
From: Alexey Dobriyan <adobriyan@sw.ru>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Ken Chen <kenchen@google.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kay Sievers <kay.sievers@vrfy.org>
Subject: Re: 2.6.21-git11: BUG in loop.ko
Message-ID: <20070510073949.GA6068@localhost.sw.ru>
References: <46425EC9.5070209@goop.org> <20070509170521.ec2c9ae7.akpm@linux-foundation.org> <4642656B.9020501@goop.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4642656B.9020501@goop.org>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 09, 2007 at 05:20:59PM -0700, Jeremy Fitzhardinge wrote:
> Andrew Morton wrote:
> > On Wed, 09 May 2007 16:52:41 -0700
> > Jeremy Fitzhardinge <jeremy@goop.org> wrote:
> >
> >   
> >> Seems to be getting a 0 refcount.  I don't see anything in the recent
> >> changes which might cause this, but this is relatively new behaviour. 
> >> It was working for me in the 2.6.21-pre time period, but I haven't tried
> >> this since 2.6.21 was released.
> >>
> >> The BUG is actually triggered by the __module_get(THIS_MODULE) in
> >> loop_set_fd.
> >>
> >>     J
> >>
> >> loop: module loaded
> >> device-mapper: ioctl: 4.11.0-ioctl (2006-10-12) initialised: dm-devel@redhat.com
> >> ------------[ cut here ]------------
> >> kernel BUG at /home/jeremy/hg/xen/paravirt/linux/include/linux/module.h:396!
> >> invalid opcode: 0000 [#1]
> >> PREEMPT SMP 
> >> Modules linked in: dm_snapshot dm_mod loop
> >> CPU:    1
> >> EIP:    0061:[<d085a911>]    Not tainted VLI
> >> EFLAGS: 00010246   (2.6.21-paravirt #1339)
> >> EIP is at lo_ioctl+0x65/0xa52 [loop]
> >> eax: 00000000   ebx: cfb92c98   ecx: d085e480   edx: 00000200
> >> esi: 00004c00   edi: cf8ad428   ebp: cf37fdc0   esp: cf37fbf8
> >> ds: 007b   es: 007b   fs: 00d8  gs: 0033  ss: 0069
> >> Process losetup (pid: 440, ti=cf37e000 task=cf30b4d0 task.ti=cf37e000)
> >> Stack: c1390080 c1390080 cf37fc10 00000008 cf8ad428 cfbb2258 00000000 cf37fc34 
> >>        c01458c5 cfb92c98 c1392a40 cf30ba70 cf30b4d0 cf30ba54 00000002 cf30ba70 
> >>        cf30b4d0 cf30ba54 00000002 00000003 c134c088 c134c088 cf37fc90 c01215b8 
> >> Call Trace:
> >>  [<c0109173>] show_trace_log_lvl+0x1a/0x30
> >>  [<c0109226>] show_stack_log_lvl+0x9d/0xa5
> >>  [<c0109425>] show_registers+0x1f7/0x336
> >>  [<c010967d>] die+0x119/0x21b
> >>  [<c0382c78>] do_trap+0x8a/0xa4
> >>  [<c0109ad1>] do_invalid_op+0x88/0x92
> >>  [<c0382a42>] error_code+0x72/0x78
> >>  [<c0211c79>] blkdev_driver_ioctl+0x4c/0x5d
> >>  [<c02123de>] blkdev_ioctl+0x754/0x7a2
> >>  [<c0198840>] block_ioctl+0x1b/0x1f
> >>  [<c0182e2e>] do_ioctl+0x22/0x68
> >>  [<c01830a6>] vfs_ioctl+0x232/0x245
> >>  [<c0183102>] sys_ioctl+0x49/0x63
> >>  [<c0108080>] syscall_call+0x7/0xb
> >>  =======================
> >> Code: ff 83 f8 06 0f 87 5a 09 00 00 ff 24 85 5c bc 85 d0 8b 9b cc 01 00 00 b8 80 e4 85 d0 89 9d 5c fe ff ff e8 37 0a 8f ef 85 c0 75 04 <0f> 0b eb fe b8 01 00 00 00 e8 79 9f 8c ef e8 ec 4b 9c ef c1 e0 
> >> EIP: [<d085a911>] lo_ioctl+0x65/0xa52 [loop] SS:ESP 0069:cf37fbf8
> >>
> >>     
> >
> > A few people have been playing with module refcounting lately.  Did you
> > work out a reproduce-it recipe?
> >   
> 
> 
> 100% reliable, but a bit obscure.  I'm booting an FC6 livecd with a
> paravirt_ops kernel under Xen.  The relevant part of the iso's initrd
> script is:
> 
> + mknod /dev/loop118 b 7 118
> + mknod /dev/loop119 b 7 119
> + mknod /dev/loop120 b 7 120
> + mknod /dev/loop121 b 7 121
> + mkdir -p /dev/mapper
> + mknod /dev/mapper/control c 10 63
> + modprobe loop max_loop=128
> loop: the max_loop option is obsolete and will be removed in March 2008
> loop: module loaded
> + modprobe dm_snapshot
> device-mapper: ioctl: 4.11.0-ioctl (2006-10-12) initialised: dm-devel@redhat.com
> + '[' 0 == 1 ']'
> + losetup /dev/loop120 /sysroot/squashfs.img
> ------------[ cut here ]------------
> kernel BUG at /home/jeremy/hg/xen/paravirt/linux/include/linux/module.h:396!
> invalid opcode: 0000 [#1]
> PREEMPT SMP 
> Modules linked in: dm_snapshot dm_mod loop
> CPU:    0
> EIP:    0061:[<d085a911>]    Not tainted VLI
> EFLAGS: 00010246   (2.6.21-paravirt #1339)
> [...]

This must be caused by dynamic loop devices creation patch

Steps to reproduce:

	mknod foo b 7 1
	losetup foo 1.img

where "7 1" is major/minor pair which doesn't created by udev et al
after module loading.

