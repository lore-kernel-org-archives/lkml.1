Return-Path: <linux-kernel-owner+w=401wt.eu-S1762910AbXLRCIQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762910AbXLRCIQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2007 21:08:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751110AbXLRCIC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Dec 2007 21:08:02 -0500
Received: from turing-police.cc.vt.edu ([128.173.14.107]:38548 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752166AbXLRCIA (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2007 21:08:00 -0500
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Andrew Morton <akpm@linux-foundation.org>, viro@zeniv.linux.org.uk
Cc: linux-kernel@vger.kernel.org
Subject: Re: 2.6.24-rc5-mm1 - wonky disk cache and CDROM behavior...
In-Reply-To: Your message of "Mon, 17 Dec 2007 14:56:44 PST."
             <20071217145644.2d6374e4.akpm@linux-foundation.org>
From: Valdis.Kletnieks@vt.edu
References: <20071213024050.7d6e5f3e.akpm@linux-foundation.org> <30457.1197931451@turing-police.cc.vt.edu>
            <20071217145644.2d6374e4.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1197943676_2751P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Mon, 17 Dec 2007 21:07:56 -0500
Message-ID: <11403.1197943676@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1197943676_2751P
Content-Type: text/plain; charset=us-ascii

On Mon, 17 Dec 2007 14:56:44 PST, Andrew Morton said:

(Adding Al Viro to the list, he's listed as "file systems" and MAINTAINERS
doesn't list 'isofs' anyplace.  Will Al or Andrew please vector to whoever
actually does that code?)

> > I try it again, and it reports it died at the same exact place, but in about
> > 2 seconds flat, and reports 91M/sec transfer.  OK, that's *weird*, I didn't
> > think that blocks read from /dev/cdrom would get cached, but OK.
> 
> It'll remain cached if something is holding the device open.

Does it need to be "device open", or are there other things as well? If the
drop_cache was hosed, that would result in the same symptoms, no?

> Something's holding s_umount for writing I guess.  Possibly busted error
> handling somewhere totally different.

Aha - found what was holding it - an attempt to loopback mount the truncated
file (before I realized it was truncated) had failed - I had gotten a 'Killed'
back from the mount, but I didn't realize it had pulled an actual oops:

Dec 17 15:54:33 turing-police kernel: [14503.402385] attempt to access beyond end of device
Dec 17 15:54:33 turing-police kernel: [14503.402391] loop1: rw=0, want=1284500, limit=314240
Dec 17 15:54:33 turing-police kernel: [14503.402395] ISOFS: unable to read i-node block
Dec 17 15:54:33 turing-police kernel: [14503.402428] Unable to handle kernel NULL pointer dereference at 000000000000010b RIP:
Dec 17 15:54:33 turing-police kernel: [14503.402440]  [<ffffffff802a096b>] iput+0x11/0x80
...
Dec 17 15:54:33 turing-police kernel: [14503.403008] Call Trace:
Dec 17 15:54:33 turing-police kernel: [14503.403026]  [<ffffffff802ff73e>] isofs_fill_super+0x7e9/0xa6b
Dec 17 15:54:33 turing-police kernel: [14503.403045]  [<ffffffff80523d28>] __down_write_nested+0x3d/0xa1
Dec 17 15:54:33 turing-police kernel: [14503.403061]  [<ffffffff80523d97>] __down_write+0xb/0xd
Dec 17 15:54:33 turing-police kernel: [14503.403076]  [<ffffffff8028fb63>] sget+0x397/0x3a9
Dec 17 15:54:33 turing-police kernel: [14503.403090]  [<ffffffff8028f204>] set_bdev_super+0x0/0x14
Dec 17 15:54:33 turing-police kernel: [14503.403106]  [<ffffffff80290301>] get_sb_bdev+0x109/0x157
Dec 17 15:54:33 turing-police kernel: [14503.403120]  [<ffffffff802fef55>] isofs_fill_super+0x0/0xa6b
Dec 17 15:54:33 turing-police kernel: [14503.403138]  [<ffffffff802fe2e9>] isofs_get_sb+0x13/0x15
Dec 17 15:54:33 turing-police kernel: [14503.403151]  [<ffffffff80290075>] vfs_kern_mount+0x90/0x11a
Dec 17 15:54:33 turing-police kernel: [14503.403167]  [<ffffffff8029015c>] do_kern_mount+0x47/0xe3
Dec 17 15:54:33 turing-police kernel: [14503.403183]  [<ffffffff802a5012>] do_mount+0x717/0x78a
Dec 17 15:54:33 turing-police kernel: [14503.403199]  [<ffffffff805242fc>] _read_lock_irq+0x9/0xb
Dec 17 15:54:33 turing-police kernel: [14503.403212]  [<ffffffff8026cce0>] find_lock_page+0x8c/0x97
Dec 17 15:54:33 turing-police kernel: [14503.403227]  [<ffffffff8026ecb6>] filemap_fault+0x1fa/0x3c6
Dec 17 15:54:33 turing-police kernel: [14503.403241]  [<ffffffff8026cb6b>] unlock_page+0x2d/0x31
Dec 17 15:54:33 turing-police kernel: [14503.403254]  [<ffffffff8027925c>] __do_fault+0x38d/0x3c3
Dec 17 15:54:33 turing-police kernel: [14503.403274]  [<ffffffff8027ab68>] handle_mm_fault+0x36d/0x6e9
Dec 17 15:54:33 turing-police kernel: [14503.403293]  [<ffffffff80271903>] __alloc_pages+0x68/0x2f6
Dec 17 15:54:33 turing-police kernel: [14503.403314]  [<ffffffff802a510e>] sys_mount+0x89/0xcb
Dec 17 15:54:33 turing-police kernel: [14503.403328]  [<ffffffff80214f34>] syscall_trace_enter+0x97/0x9b
Dec 17 15:54:33 turing-police kernel: [14503.403344]  [<ffffffff8020c34c>] tracesys+0xdc/0xe1
Dec 17 15:54:33 turing-police kernel: [14503.403359]
Dec 17 15:54:33 turing-police kernel: [14503.403366]
Dec 17 15:54:33 turing-police kernel: [14503.403367] Code: 48 8b 87 10 01 00 00 48 83 bf 38 02 00 00 40 48 8b 40 38 75

I don't mind it failing the mount, but the oops seems excessive.  I suspect
that *somewhere* in that stack trace, we're wanting something like a

	if (!foo_ptr)
		return -EIO;

but I admit not being competent enough to decide where that should be.


--==_Exmh_1197943676_2751P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFHZyt8cC3lWbTT17ARAr9/AKDaJZjkchJdurD3Hm3pjRyHrI1F9wCeKXxD
7XF1k9aEUnERhEFee5P0nPI=
=hbZ9
-----END PGP SIGNATURE-----

--==_Exmh_1197943676_2751P--
