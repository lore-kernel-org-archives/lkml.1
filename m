Return-Path: <linux-kernel-owner+w=401wt.eu-S1759617AbYBHXmH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759617AbYBHXmH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2008 18:42:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752862AbYBHXlw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Feb 2008 18:41:52 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:47566 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753519AbYBHXlu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2008 18:41:50 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Jeff Mahoney <jeffm@suse.com>
Subject: Re: kernel BUG at kernel/power/snapshot.c:464!
Date: Sat, 9 Feb 2008 00:40:00 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Pavel Machek <pavel@ucw.cz>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
References: <47ACA77E.2030001@suse.com> <200802082155.30582.rjw@sisk.pl> <47ACD9BA.5040608@suse.com>
In-Reply-To: <47ACD9BA.5040608@suse.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802090040.01479.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, 8 of February 2008, Jeff Mahoney wrote:
> Rafael J. Wysocki wrote:
> > On Friday, 8 of February 2008, Pavel Machek wrote:
> >> Hi!
> >>
> >>> Our old friend kernel BUG at kernel/power/snapshot.c:464! is back, this
> >>> time from mainline. I can't reproduce with 2.6.24-final, but I can with
> >>> a git snapshot from a few days ago. I'm doing a git bisect run now, but
> >>> it's rather time consuming, so I thought I'd pass this on in the interim.
> >>>
> >>> I can reproduce this just by doing "cat /dev/snapshot".
> >>>
> >>> Working output looks like:
> >>> swsusp: Marking nosave pages: 000000000009f000 - 0000000000100000
> >>> swsusp: Marking nosave pages: 00000000f7ff0000 - 0000000100000000
> >>> swsusp: Basic memory bitmaps created
> >>> swsusp: Basic memory bitmaps freed
> >> root@amd:~# cat /dev/snapshot
> >> cat: /dev/snapshot: No data available
> >> root@amd:~#
> >>
> >> ...on less than two days old 2.6.25-rc0-git. Rafael, do you have any
> >> ideas what may break?
> >
> > No idea and I can't reproduce it.
> >
> > Plus the trace looks bogus, as there are no "swsusp: ..." messages in the
> > mainline any more.
> 
> The git version from two days ago did. :)
> 
> I just git pulled and built and got the same BUG.
> 
> Here are the nosave registration messages:
> PM: Registered nosave memory: 000000000009f000 - 00000000000a0000
> PM: Registered nosave memory: 00000000000a0000 - 00000000000e0000
> PM: Registered nosave memory: 00000000000e0000 - 0000000000100000
> PM: Registered nosave memory: 00000000f7ff0000 - 00000000f7fff000
> PM: Registered nosave memory: 00000000f7fff000 - 00000000f8000000
> PM: Registered nosave memory: 00000000f8000000 - 00000000ff780000
> PM: Registered nosave memory: 00000000ff780000 - 0000000100000000
> 
> And the old swsusp messages match those ranges, just coalesced into two
> ranges.
> 
> Reassembling the zones from /proc/zoneinfo yields:
> Node 0, zone DMA	start_pfn: 0, spanned 4096
> 			(0x0-0x1000)
> Node 0, zone DMA32	start_pfn: 4096, spanned 1011696
> 			(0x1000-0xf7ff0)
> Node 1, zone Normal	start_pfn: 1048576, spanned 1048576
> 			(0x100000-200000)

Ah, NUMA.

> The pfn it's searching for is 0xf7ff0, which will end up hitting this in
> memory_bm_find_bit:
> while (pfn < zone_bm->start_pfn || pfn >= zone_bm->end_pfn) {
> 	zone_bm = zone_bm->next;
> 	BUG_ON(!zone_bm)
> }
> 
> Should that be pfn > zone_bm->end_pfn, or is end_pfn non-inclusive?

It used to be non-inclusive and I think it is, as 0xf7ff0 seems to be the start
of a reserved region.

Well, the assumption is that if the PFN doesn't belong to any zone, then
pfn_valid() in mark_nosave_pages() should filter it out.  Apparently, it has
stopped doing this at one point.

Andrew, have we had any changes to the way in which pfn_valid() works recently?

Rafael


> Here's the updated oops, which doesn't look any different:
> 
> ------------[ cut here ]------------
> kernel BUG at kernel/power/snapshot.c:464!
> invalid opcode: 0000 [1] SMP
> CPU 1
> Modules linked in: ocfs2_dlmfs ocfs2_dlm ocfs2_nodemanager configfs
> autofs4 sunrpc iptable_filter ip_tables ip6table_filter ip6_tables
> x_tables ipv6 af_packet loop dm_mod sbp2 ohci1394 ieee1394 k8temp
> amd_rng tg3 i2c_amd8111 hwmon i2c_amd756 floppy shpchp rtc_cmos rtc_core
> rtc_lib sr_mod i2c_core cdrom parport_pc parport pci_hotplug serio_raw
> button sg ohci_hcd sd_mod usbcore edd ext3 mbcache jbd fan sata_sil
> pata_amd libata scsi_mod thermal processor
> Pid: 3165, comm: cat Not tainted 2.6.24-vanilla #20
> RIP: 0010:[<ffffffff80254c4c>]  [<ffffffff80254c4c>]
> memory_bm_find_bit+0x20/0x78
> RSP: 0018:ffff8100379bfd78  EFLAGS: 00010246
> RAX: 0000000000000000 RBX: ffff810000003480 RCX: ffff8100379bfd8c
> RDX: ffff8100379bfd80 RSI: 00000000000f7ff0 RDI: ffff81003793e5c0
> RBP: 00000000000f7ff0 R08: ffff8100379bfd80 R09: 0000000000000000
> R10: 0000000000000028 R11: 0000000000000001 R12: ffff81003793e5c0
> R13: ffff81003783f118 R14: ffff81003783f118 R15: ffff8100f603e380
> FS:  00007f753cff06f0(0000) GS:ffff8100f767ec40(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
> CR2: 00007f753cb47c30 CR3: 00000000f61fc000 CR4: 00000000000006e0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> Process cat (pid: 3165, threadinfo ffff8100379be000, task ffff8100378f0640)
> Stack:  ffffffff80254cb5 ffff810037837018 0000003ff603e380 ffffffff8025641f
>  ffff8100f603e380 0000000000000000 ffff81003783f118 ffffffff80257016
>  ffff8100f777fe40 ffffffff8040dbca ffffffff80451aa0 0000000000000000
> Call Trace:
>  [<ffffffff80254cb5>] ? memory_bm_set_bit+0x11/0x20
>  [<ffffffff8025641f>] ? create_basic_memory_bitmaps+0x134/0x139
>  [<ffffffff80257016>] ? snapshot_open+0x58/0x13f
>  [<ffffffff8040dbca>] ? mutex_lock+0xd/0x1e
>  [<ffffffff8035fb76>] ? misc_open+0x13e/0x1b2
>  [<ffffffff80294459>] ? chrdev_open+0x150/0x174
>  [<ffffffff8029c495>] ? open_namei+0x2d0/0x653
>  [<ffffffff80294309>] ? chrdev_open+0x0/0x174
>  [<ffffffff802906dc>] ? __dentry_open+0xeb/0x1be
>  [<ffffffff80290866>] ? do_filp_open+0x2d/0x3d
>  [<ffffffff8029055b>] ? get_unused_fd_flags+0x7f/0x10e
>  [<ffffffff802908bc>] ? do_sys_open+0x46/0xc3
>  [<ffffffff8020befb>] ? system_call_after_swapgs+0x7b/0x80
> 
> 
> Code: 00 3d 4f 80 e9 74 8f 1b 00 90 90 48 8b 47 10 49 89 d0 48 3b 70 08
> 72 06 48 3b 70 10 72 21 48 8b 07 eb 0c 48 8b 00 48 85 c0 75 04 <0f> 0b
> eb fe 48 3b 70 08 72 ee 48 3b 70 10 73 e8 48 89 47 10 48
> RIP  [<ffffffff80254c4c>] memory_bm_find_bit+0x20/0x78
>  RSP <ffff8100379bfd78>
> ---[ end trace 5aadb6f82638eb8d ]---
> 
> 
