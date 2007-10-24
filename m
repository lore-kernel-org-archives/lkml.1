Return-Path: <linux-kernel-owner+w=401wt.eu-S1756605AbXJXLz1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756605AbXJXLz1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2007 07:55:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752869AbXJXLzU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Oct 2007 07:55:20 -0400
Received: from hellhawk.shadowen.org ([80.68.90.175]:1957 "EHLO
	hellhawk.shadowen.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752640AbXJXLzR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2007 07:55:17 -0400
Date: Wed, 24 Oct 2007 12:54:36 +0100
From: Andy Whitcroft <apw@shadowen.org>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [BUG] 2.6.23-git18 Kernel oops in sg helpers
Message-ID: <20071024115436.GT32058@shadowen.org>
References: <471E110C.20404@linux.vnet.ibm.com> <20071023184419.GD14671@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071023184419.GD14671@kernel.dk>
User-Agent: Mutt/1.5.13 (2006-08-11)
X-SPF-Guess: neutral
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 23, 2007 at 08:44:20PM +0200, Jens Axboe wrote:
> On Tue, Oct 23 2007, Kamalesh Babulal wrote:
> > Hi,
> > 
> > Kernel oops is triggered while running fsx-linux test, followed by cpu softlock
> > over the AMD box
> > 
> > Unable to handle kernel NULL pointer dereference at 0000000000000018 RIP: 
> >  [<ffffffff8021f2f6>] gart_map_sg+0x26c/0x406
> > PGD 10185b067 PUD 10075b067 PMD 0 
> > Oops: 0002 [1] SMP 
> > CPU 3 
> > Modules linked in:
> > Pid: 18676, comm: fsx-linux Not tainted 2.6.23-git18-autokern1 #1
> > RIP: 0010:[<ffffffff8021f2f6>]  [<ffffffff8021f2f6>] gart_map_sg+0x26c/0x406
> > RSP: 0000:ffff810181edf948  EFLAGS: 00010002
> 
> Can you check where gart_map_sg+0x26c is at? Make sure you have
> CONFIG_DEBUG_INFO defined, then do:
> 
> $ gdb vmlinux
> $ l *gart_map_sg+0x26c

Ok, this problem still seems to be about in 2.6.24-rc1.  Here is the gdb
output from that version, the panic (also below) seems the same:

(gdb) l *gart_map_sg+0x26c
0xffffffff8022011e is in gart_map_sg (arch/x86/kernel/pci-gart_64.c:433).
428                     goto error;
429             out++;
430             flush_gart();
431             if (out < nents) {
432                     sgmap = sg_next(sgmap);
433                     sgmap->dma_length = 0;
434             }
435             return out;
436
437     error:

So it seems sg_next has returned 0.

-apw

elm3b6 login: -- 0:conmux-control -- time-stamp -- Oct/24/07  3:31:05 --
-- 0:conmux-control -- time-stamp -- Oct/24/07  3:46:40 --
Unable to handle kernel NULL pointer dereference at 0000000000000018 RIP: 
 [<ffffffff8022011e>] gart_map_sg+0x26c/0x406
PGD 101a8f067 PUD 10193c067 PMD 0 
Oops: 0002 [1] SMP 
CPU 3 
Modules linked in:
Pid: 18339, comm: fsx-linux Not tainted 2.6.24-rc1-autokern1 #1
RIP: 0010:[<ffffffff8022011e>]  [<ffffffff8022011e>] gart_map_sg+0x26c/0x406
RSP: 0000:ffff810181e03948  EFLAGS: 00010002
RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000000000
RDX: 0000000000000004 RSI: 0000000000000002 RDI: ffffffff8057918c
RBP: ffff810181d0d820 R08: 0000000000000004 R09: ffff810181e038d4
R10: 00000000000000db R11: ffffffff804198f0 R12: ffff810181d0d840
R13: 0000000000000003 R14: 0000000000000001 R15: 0000000000000003
FS:  0000000000000000(0000) GS:ffff81018071e380(0063) knlGS:00000000f7fb9900
CS:  0010 DS: 002b ES: 002b CR0: 000000008005003b
CR2: 0000000000000018 CR3: 0000000101a39000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process fsx-linux (pid: 18339, threadinfo ffff810181e02000, task ffff810181f2f560)
Stack:  0000000300000001 ffff810100000000 ffff810181d0d840 0000000000000001
 0000000200000002 ffff810181d0d800 ffff810100773870 ffff810002905da0
 ffff8100022d6000 ffff8101807082f0 ffff810002905dd0 0000000002000000
Call Trace:
 [<ffffffff803ed20b>] scsi_dma_map+0x3f/0x4e
 [<ffffffff803fda81>] mptscsih_qcmd+0x1bc/0x4af
 [<ffffffff803e71ad>] scsi_dispatch_cmd+0x1e7/0x277
 [<ffffffff803ec758>] scsi_request_fn+0x2df/0x369
 [<ffffffff803514a8>] cfq_insert_request+0x2a6/0x2ae
 [<ffffffff803471f5>] elv_insert+0xcf/0x18a
 [<ffffffff8034aa31>] __make_request+0x550/0x58b
 [<ffffffff8034ac89>] generic_make_request+0x1bb/0x1f0
 [<ffffffff8034ad92>] submit_bio+0xd4/0xdf
 [<ffffffff802a15fb>] dio_bio_submit+0x52/0x66
 [<ffffffff802a230b>] __blockdev_direct_IO+0x813/0xa1c
 [<ffffffff80261108>] pagevec_lookup_tag+0x1a/0x21
 [<ffffffff802df9b9>] ext3_direct_IO+0x107/0x19e
 [<ffffffff802e03f0>] ext3_get_block+0x0/0xe2
 [<ffffffff8025a9ab>] generic_file_direct_IO+0xcb/0x111
 [<ffffffff8025b0af>] generic_file_aio_read+0x86/0x160
 [<ffffffff8027e9a2>] do_sync_read+0xc8/0x10b
 [<ffffffff80298345>] __mark_inode_dirty+0x29/0x17d
 [<ffffffff80246141>] autoremove_wake_function+0x0/0x2e
 [<ffffffff80290ee7>] notify_change+0x255/0x26a
 [<ffffffff802815d9>] vfs_getattr+0x2b/0x2f
 [<ffffffff802816c1>] vfs_fstat+0x33/0x3a
 [<ffffffff8027ea90>] vfs_read+0xab/0x12e
 [<ffffffff8027ed94>] sys_read+0x45/0x6e
 [<ffffffff802229d2>] ia32_sysret+0x0/0xa


Code: c7 41 18 00 00 00 00 8b 44 24 20 e9 7b 01 00 00 e8 27 f8 ff 
RIP  [<ffffffff8022011e>] gart_map_sg+0x26c/0x406
 RSP <ffff810181e03948>
CR2: 0000000000000018
