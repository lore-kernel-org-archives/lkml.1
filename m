Return-Path: <linux-kernel-owner+w=401wt.eu-S933353AbYBHTET@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933353AbYBHTET (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2008 14:04:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964942AbYBHTDd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Feb 2008 14:03:33 -0500
Received: from ns.suse.de ([195.135.220.2]:35664 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935206AbYBHTDa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2008 14:03:30 -0500
Message-ID: <47ACA77E.2030001@suse.com>
Date: Fri, 08 Feb 2008 14:03:26 -0500
From: Jeff Mahoney <jeffm@suse.com>
Organization: SUSE Labs, Novell, Inc
User-Agent: Thunderbird 2.0.0.9 (X11/20070801)
MIME-Version: 1.0
To: Pavel Machek <pavel@suse.cz>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: kernel BUG at kernel/power/snapshot.c:464!
X-Enigmail-Version: 0.95.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1


Hi Pavel -

Our old friend kernel BUG at kernel/power/snapshot.c:464! is back, this
time from mainline. I can't reproduce with 2.6.24-final, but I can with
a git snapshot from a few days ago. I'm doing a git bisect run now, but
it's rather time consuming, so I thought I'd pass this on in the interim.

I can reproduce this just by doing "cat /dev/snapshot".

Working output looks like:
swsusp: Marking nosave pages: 000000000009f000 - 0000000000100000
swsusp: Marking nosave pages: 00000000f7ff0000 - 0000000100000000
swsusp: Basic memory bitmaps created
swsusp: Basic memory bitmaps freed

Here's the trace:

swsusp: Marking nosave pages: 000000000009f000 - 0000000000100000
swsusp: Marking nosave pages: 00000000f7ff0000 - 0000000100000000
- ------------[ cut here ]------------
kernel BUG at kernel/power/snapshot.c:464!
invalid opcode: 0000 [1] SMP
CPU 1
Modules linked in: ocfs2_dlmfs ocfs2_dlm ocfs2_nodemanager configfs
autofs4 sunrpc iptable_filter ip_tables ip6table_filter ip6_tables
x_tables ipv6 af_packet loop dm_mod sbp2 ohci1394 ieee1394 parport_pc
parport tg3 sr_mod i2c_amd8111 shpchp button pci_hotplug amd_rng
rtc_cmos rtc_core rtc_lib i2c_amd756 i2c_core k8temp serio_raw cdrom
hwmon sg floppy ohci_hcd sd_mod usbcore edd ext3 mbcache jbd fan
sata_sil pata_amd libata scsi_mod thermal processor
Pid: 3131, comm: cat Not tainted 2.6.24-vanilla #14
RIP: 0010:[<ffffffff8025a254>]  [<ffffffff8025a254>]
memory_bm_find_bit+0x20/0x78
RSP: 0018:ffff8100f602bd78  EFLAGS: 00010246
RAX: 0000000000000000 RBX: ffff810000003480 RCX: ffff8100f602bd8c
RDX: ffff8100f602bd80 RSI: 00000000000f7ff0 RDI: ffff8100f65eadc0
RBP: 00000000000f7ff0 R08: ffff8100f602bd80 R09: 0000000100000000
R10: ffff8100f602bae8 R11: ffffffff80322454 R12: ffff8100f65eadc0
R13: ffff8100f67f6d58 R14: ffff8100f67f6d58 R15: ffff8100f6138ec0
FS:  00002b24042806f0(0000) GS:ffff8100f7688ac0(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 00002b2403fe1c30 CR3: 00000000f69bd000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
        Process cat (pid: 3131, threadinfo ffff8100f602a000, task
ffff8100379ff040)
Stack:  ffffffff8025a2bd ffff8100379ce018 0000003ff6138ec0 ffffffff8025ba68
 ffff8100f6138ec0 0000000000000000 ffff8100f67f6d58 ffffffff8025c65f
 ffff8100f77341c0 ffffffff80412b6a ffffffff80445610 0000000000000000
Call Trace:
 [<ffffffff8025a2bd>] memory_bm_set_bit+0x11/0x20
 [<ffffffff8025ba68>] create_basic_memory_bitmaps+0x162/0x166
 [<ffffffff8025c65f>] snapshot_open+0x58/0x102
 [<ffffffff80412b6a>] mutex_lock+0xd/0x1e
 [<ffffffff80361d8a>] misc_open+0x13e/0x1b2
 [<ffffffff802990bf>] chrdev_open+0x158/0x17c
 [<ffffffff802a12b1>] open_namei+0x2d0/0x653

 [<ffffffff80298f67>] chrdev_open+0x0/0x17c
 [<ffffffff8029527a>] __dentry_open+0xeb/0x1be
 [<ffffffff80295404>] do_filp_open+0x2d/0x3d
 [<ffffffff802950f0>] get_unused_fd_flags+0x80/0x118
 [<ffffffff8029545a>] do_sys_open+0x46/0xc3
 [<ffffffff8020bfde>] system_call+0x7e/0x83


Code: 0f 0b eb fe 48 3b 70 08 72 ee 48 3b 70 10 73 e8 48 89 47 10
RIP  [<ffffffff8025a254>] memory_bm_find_bit+0x20/0x78
 RSP <ffff8100f602bd78>
- ---[ end trace c6de0b8a8d80da39 ]---


- --
Jeff Mahoney
SUSE Labs
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.4-svn0 (GNU/Linux)
Comment: Using GnuPG with SUSE - http://enigmail.mozdev.org

iD8DBQFHrKd+LPWxlyuTD7IRArWBAJ9+wGj8l2g/NU3B09YTwtM3+8dYIACdGeAt
3F2Cs30J2dCqRXFYe95StO8=
=j1bj
-----END PGP SIGNATURE-----
