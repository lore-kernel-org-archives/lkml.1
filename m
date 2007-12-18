Return-Path: <linux-kernel-owner+w=401wt.eu-S1758540AbXLRPO7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758540AbXLRPO7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2007 10:14:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756602AbXLRPOu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Dec 2007 10:14:50 -0500
Received: from hc652a898.dhcp.vt.edu ([198.82.168.152]:47291 "EHLO
	hc652a898.dhcp.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756544AbXLRPOt (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2007 10:14:49 -0500
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Dave Young <hidave.darkstar@gmail.com>,
       David Howells <dhowells@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, viro@zeniv.linux.org.uk,
       linux-kernel@vger.kernel.org
Subject: Re: 2.6.24-rc5-mm1 - wonky disk cache and CDROM behavior...
In-Reply-To: Your message of "Tue, 18 Dec 2007 10:37:32 +0800."
             <20071218023732.GA3215@darkstar.te-china.tietoenator.com>
From: Valdis.Kletnieks@vt.edu
References: <20071213024050.7d6e5f3e.akpm@linux-foundation.org> <30457.1197931451@turing-police.cc.vt.edu> <20071217145644.2d6374e4.akpm@linux-foundation.org> <11403.1197943676@turing-police.cc.vt.edu>
            <20071218023732.GA3215@darkstar.te-china.tietoenator.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1197957143_2928P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Tue, 18 Dec 2007 00:52:23 -0500
Message-ID: <3836.1197957143@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1197957143_2928P
Content-Type: text/plain; charset="us-ascii"
Content-Id: <3819.1197957125.1@turing-police.cc.vt.edu>

(Adding Dave Howells, his name is on iget-stop-isofs-from-using-read_inode.patch)

On Tue, 18 Dec 2007 10:37:32 +0800, Dave Young said:

> > I don't mind it failing the mount, but the oops seems excessive.  I suspect
> > that *somewhere* in that stack trace, we're wanting something like a
> > 
> > 	if (!foo_ptr)
> > 		return -EIO;
> > 
> > but I admit not being competent enough to decide where that should be.
> > 
> 
> Hi,
> Could you please try the below patch:
> 
> Signed-off-by: Dave Young <hidave.darkstar@gmail.com> 
> 
> ---
> fs/isofs/inode.c |    2 +-
> 1 file changed, 1 insertion(+), 1 deletion(-)

With that patch applied, I took the ISO image (which I ended up reading on
another machine and copying over the net to get a complete usable image),
and dd'ed just the first 150M into another file, and tried to loopback mount
it.  And I got:

# mount -o ro,loop /path/to/cd.partial.image /mnt/loop
mount: wrong fs type, bad option, bad superblock on /dev/loop0,
       missing codepage or helper program, or other error
       In some cases useful info is found in syslog - try
       dmesg | tail  or so

And my dmesg says:

[   33.622073] ISO 9660 Extensions: Microsoft Joliet Level 3
[   33.622125] attempt to access beyond end of device
[   33.622129] loop0: rw=0, want=1284500, limit=300000
[   33.622133] ISOFS: unable to read i-node block
    Here is where we would oops before - now it errors out more reasonably:
[   33.622140] ISOFS: changing to secondary root
[   33.622148] attempt to access beyond end of device
[   33.622151] loop0: rw=0, want=1284508, limit=300000
[   33.622155] ISOFS: unable to read i-node block
[   33.622159] isofs_fill_super: get root inode failed

So that fixes *this* bug. I looked in the -rc5-mm1 broken-out/, saw
the vast multitudes of 'iget-stop-<foofs>-from-using' patches, and decided
that somebody else will probably have to audit them for sanity.

In the iget-* series, there's some 184 'return ERR_PTR(-E<FOO>);' for some FOO,
and 3 other uses:

% grep ERR_PTR iget* | grep -v return
iget-stop-isofs-from-using-read_inode.patch:+                   inode = ERR_PTR(ret);
iget-stop-jfs-from-using-iget-and-read_inode-try.patch:+                parent = ERR_PTR(-ENOMEM);
iget-stop-jfs-from-using-iget-and-read_inode-try.patch:-                parent = ERR_PTR(-EACCES);
iget-stop-jfs-from-using-iget-and-read_inode-try.patch:-                parent = ERR_PTR(-ENOMEM);

isofs is the only place we don't return a constant 'ERR_PTR(-EFOO)', but
cast somebody else's return value.  I wish I understood what that tells us. ;)



--==_Exmh_1197957143_2928P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFHZ2AXcC3lWbTT17ARAkCWAJ0cyNW/cxL6OQznkuF+cykc652srgCgybnP
L9yT/xsmYWl8z1H9A6Qrep4=
=iU87
-----END PGP SIGNATURE-----

--==_Exmh_1197957143_2928P--
