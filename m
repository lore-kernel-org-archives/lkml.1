Return-Path: <linux-kernel-owner+w=401wt.eu-S1755151AbXHBCXB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755151AbXHBCXB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2007 22:23:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750929AbXHBCWy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Aug 2007 22:22:54 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:43583 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751231AbXHBCWx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2007 22:22:53 -0400
Date: Thu, 2 Aug 2007 08:05:16 +0530 (IST)
From: Satyam Sharma <satyam@infradead.org>
X-X-Sender: satyam@enigma.security.iitk.ac.in
To: Rokas Masiulis <roma1390@uosis.mif.vu.lt>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jan Engelhardt <jengelh@computergmbh.de>
Subject: Re: Examine user space locks
In-Reply-To: <20070801205205.GA34272@uosis.mif.vu.lt>
Message-ID: <alpine.LFD.0.999.0708020729460.8258@enigma.security.iitk.ac.in>
References: <20070801190754.GA31656@uosis.mif.vu.lt>
 <Pine.LNX.4.64.0708012150420.23692@fbirervta.pbzchgretzou.qr>
 <20070801205205.GA34272@uosis.mif.vu.lt>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Rokas,

[ Your mailer does not maintain the Cc: list. That's not good
  when posting to LKML. Adding back Jan Engelhardt to Cc: ]


On Wed, 1 Aug 2007, Rokas Masiulis wrote:

> On Wed, Aug 01, 2007 at 09:51:06PM +0200, Jan Engelhardt wrote:
> > [...]
> > echo t >/proc/sysrq-trigger
> 
>  # cat /proc/kmsg > log &
>  [1] 28058
>  # echo t >/proc/sysrq-trigger
>  # sleep 3
>  # fg
>  cat /proc/kmsg > log
>  ^C

First, ensure:
# echo 1 > /proc/sys/kernel/sysrq

and that you've built with various debug stuff like CONFIG_LOCKDEP,
CONFIG_FRAME_POINTER, etc enabled.

If you're only interested in those processes that are hung in "D"
i.e. TASK_UNINTERRUPTIBLE wait, you could try:

# dmesg -c
# echo w > /proc/sysrq-trigger
# dmesg > uninterruptible-sleeping-tasks.txt

to limit output to only interesting stuff. Also, not all tasks waiting
in TASK_UNINTERRUPTIBLE may be blocked on locks / mutexes (most would
simply be waiting for IO to complete), so:

# dmesg -c
# echo d > /proc/sysrq-trigger
# dmesg > held-locks.txt

would tell us specifically what locks are held currently.


> it seems that i can't get full log. Not all proceses are listed on it.
> 
> But some of "bad proceses i have".
> (full log: http://89.190.108.145/~rokas/tasks.txt)

Eek, not very readable, that.


> it seems that some are stoped on cdrom_transfer_packet_command, some on __mutex_lock_slowpath.
> I'm confused..
> 
>  hald-addon-st D 000004E2     0  5826      1         17981 12866 (NOTLB)
>         f55ebc34 c02c9717 c02c94b8 000004e2 c0529780 00000000 00200202 c0529a64 
>         00000000 c0529780 c02c9656 00000080 c2a17b20 00000000 b25fc600 003d0c2e 
>         c042e340 f54d1a70 f54d1b78 f55ea000 f55ebca8 f55ebc54 f55ebc8c c03bdb8a 
>  Call Trace:
>   <c02c9717> cdrom_transfer_packet_command+0x80/0xf9  <c02c94b8> cdrom_timer_expiry+0x0/0x5d
>   <c02c9656> cdrom_start_packet_command+0x141/0x182  <c03bdb8a> wait_for_completion+0x85/0xca
> ...
>   <c016051e> do_sys_open+0x4a/0xca  <c01605ba> sys_open+0x1c/0x20
>   <c0102b67> sysenter_past_esp+0x54/0x75 

Could be waiting on i/o ... (?)


>  eject         D 00000101     0 12662      1         12793 17981 (NOTLB)
>         e5c17e9c c0156dfd 00000000 00000101 00000001 00000000 f308eac4 00000000 
>         00000003 00000802 f56d5e40 00000003 c2a17b20 00000000 0616c400 003d2850 
>         c042e340 eb65e030 eb65e138 f5ad970c f5ad9710 eb65e030 f5ad9718 c03be586 
>  Call Trace:
>   <c0156dfd> free_pages_and_swap_cache+0x51/0x75  <c03be586> __mutex_lock_slowpath+0x46/0x7f
>   <c03be6e0> .text.lock.mutex+0x5/0x14  <c0169041> do_open+0x55/0x382
> ...
>   <c016051e> do_sys_open+0x4a/0xca  <c01605ba> sys_open+0x1c/0x20
>   <c0102b67> sysenter_past_esp+0x54/0x75 

Not the BKL. Sounds like bdev->bd_mutex ...


>  hald-probe-st D 00000101     0 17981      1         12662  5826 (NOTLB)
>         dfa3be9c f5761144 00000000 00000101 00000001 00000000 e5ab03f4 00000000 
>         00000004 00008800 00000000 dd243550 c2a1fb20 00000000 22986700 003d64c8 
>         dd243550 e4379550 e4379658 f5ad970c f5ad9710 e4379550 f5ad9718 c03be586 
>  Call Trace:
>   <c03be586> __mutex_lock_slowpath+0x46/0x7f  <c03be6e0> .text.lock.mutex+0x5/0x14
>   <c0169041> do_open+0x55/0x382  <c0169405> blkdev_open+0x0/0x5a
> ...
>   <c012926e> do_sigaction+0xf1/0x192  <c016051e> do_sys_open+0x4a/0xca
>   <c01605ba> sys_open+0x1c/0x20  <c0102b67> sysenter_past_esp+0x54/0x75

Hmm, a lot of stuff seems hung on the bdev->bd_mutex of your cdrom device.
Your cdrom drive becomes unusable after this, right?

Can you reproduce this, or let us know what exactly you did to lead to
this situation? You could put up your .config somewhere as well, also
probably give some description of your setup / cdrom hardware.


Satyam
