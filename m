Return-Path: <linux-kernel-owner+w=401wt.eu-S1759411AbXHAQOU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759411AbXHAQOU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2007 12:14:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754086AbXHAQOK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Aug 2007 12:14:10 -0400
Received: from hc6521514.dhcp.vt.edu ([198.82.21.20]:49762 "EHLO
	hc6521514.dhcp.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752250AbXHAQOI (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2007 12:14:08 -0400
X-Greylist: delayed 2793 seconds by postgrey-1.27 at vger.kernel.org; Wed, 01 Aug 2007 12:14:08 EDT
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: 2.6.23-rc1-mm1 - loopback mount of files fails loop-use-unlocked_ioctl.patch
In-Reply-To: Your message of "Wed, 25 Jul 2007 04:03:04 PDT."
             <20070725040304.111550f4.akpm@linux-foundation.org>
From: Valdis.Kletnieks@vt.edu
References: <20070725040304.111550f4.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1185981898_4258P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Wed, 01 Aug 2007 11:24:58 -0400
Message-ID: <31610.1185981898@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1185981898_4258P
Content-Type: text/plain; charset=us-ascii

On Wed, 25 Jul 2007 04:03:04 PDT, Andrew Morton said:

> ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.23-rc1/2.6.23-rc1-mm1/

Looks like -rc1-mm2 came out while I was hunting this, haven't tried that yet)

File-backed loopback seems to be broken (note that I use a LVM volume with
a 'mount -o loop,encryption=aes /dev/mapper/...' every day - that *does* work).

loop-use-unlocked_ioctl.patch is the offender after bisecting.

I had created an ISO image with genisoimage, and to test it, I had done:

mount -o loop.ro /path/to/temp.iso /mnt

(Note that the image itself is good - I burned it to a CD, and then
'mount /dev/cdrom /mnt' worked just fine, so it's definitely the loopback,
and on file-backed mounts...).

and got treated to this wonderful oops:

[  170.420603] Unable to handle kernel NULL pointer dereference at 00000000000000b8 RIP: 
[  170.420877]  [<ffffffff803bf9b1>] lo_ioctl+0x21/0x94a
[  170.421243] PGD 41c5067 PUD 6111067 PMD 0 
[  170.421464] Oops: 0000 [1] PREEMPT SMP 
[  170.421671] CPU 0 
[  170.421775] Modules linked in: sha256 aes video output thermal processor fan container button bay battery ac nvram pcmcia firmware_class ohci1394 yenta_socket ieee1394 rsrc_nonstatic iTCO_wdt pcmcia_core iTCO_vendor_support intel_agp rtc
[  170.422989] Pid: 1616, comm: mount Not tainted 2.6.23-rc1 #3
[  170.423254] RIP: 0010:[<ffffffff803bf9b1>]  [<ffffffff803bf9b1>] lo_ioctl+0x21/0x94a
[  170.423627] RSP: 0018:ffff8100047076d8  EFLAGS: 00010296
[  170.423876] RAX: ffffffff80698720 RBX: 00000000fffffdfd RCX: ffffffff803bf990
[  170.424210] RDX: ffff810004707b18 RSI: 0000000000005310 RDI: 0000000000000000
[  170.424544] RBP: ffff8100047078d8 R08: ffff810004707b18 R09: ffff810004707968
[  170.424878] R10: ffff810004707b18 R11: ffff810004707b18 R12: 0000000000005310
[  170.425212] R13: ffff810004707b18 R14: ffff810004707b18 R15: 0000000000000000
[  170.425547] FS:  00002b82792a4740(0000) GS:ffffffff806e1000(0000) knlGS:0000000000000000
[  170.425928] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  170.426197] CR2: 00000000000000b8 CR3: 000000000610b000 CR4: 00000000000006e0
[  170.426531] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  170.439502] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[  170.452460] Process mount (pid: 1616, threadinfo ffff810004706000, task ffff810006898800)
[  170.465758] Stack:  0000003900000044 ffff810006898800 0000000000000000 ffff810006812588
[  170.479365]  0000000005071980 0000000000000007 0000000000000000 0000000000000044
[  170.493151]  0000000000100000 ffff8100047077b8 ffff8100047077a8 ffffffff8031facb
[  170.493517] Call Trace:
[  170.520574]  [<ffffffff8031facb>] avc_has_perm+0x4c/0x5e
[  170.534308]  [<ffffffff80320994>] inode_has_perm+0x6b/0x7a
[  170.547974]  [<ffffffff8029c126>] __d_lookup+0xe1/0x154
[  170.561721]  [<ffffffff80346bf7>] kobject_get+0x1a/0x21
[  170.575187]  [<ffffffff8033e29c>] get_disk+0x8d/0xad
[  170.588601]  [<ffffffff8033e2c8>] exact_lock+0xc/0x14
[  170.601969]  [<ffffffff803bc688>] kobj_lookup+0x14d/0x183
[  170.615253]  [<ffffffff8033d5e2>] blkdev_driver_ioctl+0x39/0x78
[  170.628545]  [<ffffffff8033dc7c>] blkdev_ioctl+0x65b/0x6b7
[  170.641836]  [<ffffffff802b082a>] __blkdev_get+0x7b/0x8d
[  170.655105]  [<ffffffff802b0a65>] ioctl_by_bdev+0x34/0x48
[  170.668432]  [<ffffffff802fbcff>] isofs_fill_super+0x337/0xa68
[  170.681666]  [<ffffffff80519ec2>] __down_write_nested+0x3d/0xab
[  170.694896]  [<ffffffff80519f3b>] __down_write+0xb/0xd
[  170.707835]  [<ffffffff8028c412>] sget+0x374/0x386
[  170.720528]  [<ffffffff8028bec8>] set_bdev_super+0x0/0x14
[  170.733267]  [<ffffffff8028cfbb>] get_sb_bdev+0x109/0x157
[  170.745881]  [<ffffffff802fb9c8>] isofs_fill_super+0x0/0xa68
[  170.758382]  [<ffffffff802fb445>] isofs_get_sb+0x13/0x15
[  170.770713]  [<ffffffff8028cac2>] vfs_kern_mount+0x90/0x11a
[  170.782999]  [<ffffffff8028cba5>] do_kern_mount+0x47/0xe2
[  170.795245]  [<ffffffff802a1d70>] do_mount+0x691/0x704
[  170.807349]  [<ffffffff802a06cb>] mntput_no_expire+0x1e/0x98
[  170.819351]  [<ffffffff80294b13>] link_path_walk+0xe8/0xfc
[  170.831216]  [<ffffffff802b0232>] bdput+0xd/0xf
[  170.843065]  [<ffffffff802a06cb>] mntput_no_expire+0x1e/0x98
[  170.854874]  [<ffffffff80294b43>] path_walk+0x1c/0x1e
[  170.866566]  [<ffffffff80294e38>] do_path_lookup+0x1b6/0x22f
[  170.878247]  [<ffffffff802937a1>] putname+0x37/0x39
[  170.889781]  [<ffffffff802957a1>] __user_walk_fd+0x4c/0x5c
[  170.901309]  [<ffffffff8026e055>] __alloc_pages+0x5c/0x2b5
[  170.912789]  [<ffffffff802a06cb>] mntput_no_expire+0x1e/0x98
[  170.924359]  [<ffffffff802a1e6c>] sys_mount+0x89/0xcb
[  170.935859]  [<ffffffff8023ea8b>] sys_rt_sigprocmask+0x58/0xd7
[  170.947361]  [<ffffffff8020bece>] system_call+0x7e/0x83
[  170.958877] 
[  170.970241] 
[  170.970241] Code: 48 8b 87 b8 00 00 00 48 8b 18 48 8b 83 e8 01 00 00 48 8b 80 
[  170.993080] RIP  [<ffffffff803bf9b1>] lo_ioctl+0x21/0x94a
[  171.004333]  RSP <ffff8100047076d8>
[  171.015387] CR2: 00000000000000b8
[  171.029069] mount used greatest stack depth: 3304 bytes left


--==_Exmh_1185981898_4258P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFGsKXKcC3lWbTT17ARAmCmAKCYZbOZf8NuJ2wD+3D6ATkOubV+JgCeMrWO
T16QpQ7JnAD3ovgR2KxYDbw=
=6oxw
-----END PGP SIGNATURE-----

--==_Exmh_1185981898_4258P--
