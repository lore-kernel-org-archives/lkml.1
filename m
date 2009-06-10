Return-Path: <linux-kernel-owner+w=401wt.eu-S1757207AbZFJIBT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757207AbZFJIBT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jun 2009 04:01:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754148AbZFJIBI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Jun 2009 04:01:08 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:52636 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752743AbZFJIBG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jun 2009 04:01:06 -0400
Date: Wed, 10 Jun 2009 18:00:58 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: LKML <linux-kernel@vger.kernel.org>
Cc: linux-next@vger.kernel.org, "Theodore Ts'o" <tytso@mit.edu>,
       Al Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org
Subject: linux-next: next-20090609 hangs in early user mode
Message-Id: <20090610180058.99bd3dda.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.16.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Wed__10_Jun_2009_18_00_58_+1000_axvoNP_=foil10cV"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__10_Jun_2009_18_00_58_+1000_axvoNP_=foil10cV
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

My boot tests last night produced this during boot:

Loading, please wait...
exe used greatest stack depth: 11120 bytes left
async/0 used greatest stack depth: 10928 bytes left
-- 0:conmux-control -- time-stamp -- Jun/09/09 21:02:12 --
INFO: task init:1 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
init          D 0000000010078228  8192     1      0 0x00008010
Call Trace:
[c0000000be67f380] [c0000000be67f430] 0xc0000000be67f430 (unreliable)
[c0000000be67f550] [c00000000001153c] .__switch_to+0xfc/0x1b0
[c0000000be67f5e0] [c00000000055dc70] .schedule+0x2b0/0x980
[c0000000be67f700] [c000000000138850] .inode_wait+0x10/0x30
[c0000000be67f780] [c00000000055ebd8] .__wait_on_bit+0xd8/0x160
[c0000000be67f830] [c00000000055ece8] .out_of_line_wait_on_bit+0x88/0xb0
[c0000000be67f910] [c000000000139060] .clear_inode+0x120/0x150
[c0000000be67f990] [c0000000001395c8] .generic_drop_inode+0x198/0x330
[c0000000be67fa20] [c0000000001388f8] .iput+0x88/0xc0
[c0000000be67faa0] [c000000000134308] .dentry_iput+0x108/0x220
[c0000000be67fb30] [c0000000001345c8] .d_kill+0x68/0xb0
[c0000000be67fbc0] [c000000000135104] .dput+0x154/0x2c0
[c0000000be67fc60] [c00000000011f9a4] .__fput+0x1b4/0x290
[c0000000be67fd00] [c00000000011b760] .filp_close+0xa0/0x100
[c0000000be67fd90] [c00000000011b870] .SyS_close+0xb0/0x180
[c0000000be67fe30] [c0000000000084ac] syscall_exit+0x0/0x40

And it never recovers.  Sometimes during the bisection run, it was a
different process - but it was the same backtrace.

Bisection lead me to this:

d4fdcb2068eef29c03d6027aa219fa60171c6b87 is first bad commit
commit d4fdcb2068eef29c03d6027aa219fa60171c6b87
Author: Theodore Ts'o <tytso@mit.edu>
Date:   Thu May 21 16:00:59 2009 -0400

    fs: i_flags and i_state in struct inode only need to be unsigned short
   =20
    Currently i_flags and i_state do not need to be an unsigned int and an
    unsigned long, respectively.  (We currently use 9 i_flags bits, and 8
    i_state bits.)  Changing them to be an unsigned short saves 4 bytes
    per inode on an x86 platform, and 8 bytes on an x86_64 platform.
   =20
    Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
    Cc: linux-fsdevel@vger.kernel.org
    Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>

Reverting that commit from next-20090609 gets me a bootable kernel.

The machines are PowerPC64 (so big endian).  It looks to me like we use
bitops on i_state - don't our bitops only apply to unsigned longs?
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Wed__10_Jun_2009_18_00_58_+1000_axvoNP_=foil10cV
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkovaDoACgkQjjKRsyhoI8wgPACgoKwhTOkjD/sL6R9jUDasyp9a
ZkIAn3mqGoD+4As9BROIT5apOH3KNhuR
=5fzA
-----END PGP SIGNATURE-----

--Signature=_Wed__10_Jun_2009_18_00_58_+1000_axvoNP_=foil10cV--
