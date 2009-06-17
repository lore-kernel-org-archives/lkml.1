Return-Path: <linux-kernel-owner+w=401wt.eu-S1765553AbZFQLU0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765553AbZFQLU0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jun 2009 07:20:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759886AbZFQLUO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Jun 2009 07:20:14 -0400
Received: from bilbo.ozlabs.org ([203.10.76.25]:47821 "EHLO bilbo.ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758300AbZFQLUN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jun 2009 07:20:13 -0400
Subject: Re: [BUG] lib/kernel_lock.c:126 with cgroups regression ltp tests
From: Michael Ellerman <michael@ellerman.id.au>
Reply-To: michael@ellerman.id.au
To: Sachin Sant <sachinp@in.ibm.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, linuxppc-dev@ozlabs.org,
       menage@google.com, Balbir Singh <balbir@linux.vnet.ibm.com>,
       abogani@texware.it, Al Viro <viro@zeniv.linux.org.uk>
In-Reply-To: <4A38CAAC.4090606@in.ibm.com>
References: <4A38CAAC.4090606@in.ibm.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-PiJEtoJfsvvYXMfO7IYR"
Date: Wed, 17 Jun 2009 21:20:13 +1000
Message-Id: <1245237613.4269.13.camel@concordia>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-PiJEtoJfsvvYXMfO7IYR
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2009-06-17 at 16:21 +0530, Sachin Sant wrote:
> While executing cgroups regression tests from LTP May 2009
> release on a Power6 box came across the following bug.

> This is with 2.6.30-git10 (300df7dc89cc276377fc020704e34875d5c473b6)

Looks like 337eb00a2 missed some return paths in do_remount_sb()?

$ git log -p -U13 337eb00a2c3a421999c39c94ce7e33545ee8baa7 fs/super.c
commit 337eb00a2c3a421999c39c94ce7e33545ee8baa7
Author: Alessio Igor Bogani <abogani@texware.it>
Date:   Tue May 12 15:10:54 2009 +0200

    Push BKL down into ->remount_fs()
   =20
    [xfs, btrfs, capifs, shmem don't need BKL, exempt]
   =20
    Signed-off-by: Alessio Igor Bogani <abogani@texware.it>
    Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>

diff --git a/fs/super.c b/fs/super.c
index 1905f4a..83b4741 100644
--- a/fs/super.c
+++ b/fs/super.c
@@ -530,53 +530,51 @@ int do_remount_sb(struct super_block *sb, int flags, =
void=20
 {
        int retval;
        int remount_rw;
       =20
 #ifdef CONFIG_BLOCK
        if (!(flags & MS_RDONLY) && bdev_read_only(sb->s_bdev))
                return -EACCES;
 #endif
        if (flags & MS_RDONLY)
                acct_auto_close(sb);
        shrink_dcache_sb(sb);
        sync_filesystem(sb);
=20
-       lock_kernel();
        /* If we are remounting RDONLY and current sb is read/write,
           make sure there are no rw files opened */
        if ((flags & MS_RDONLY) && !(sb->s_flags & MS_RDONLY)) {
                if (force)
                        mark_files_ro(sb);
                else if (!fs_may_remount_ro(sb)) {
                        unlock_kernel();
                        return -EBUSY;
                }
                retval =3D vfs_dq_off(sb, 1);
                if (retval < 0 && retval !=3D -ENOSYS) {
                        unlock_kernel();
                        return -EBUSY;
                }
        }
        remount_rw =3D !(flags & MS_RDONLY) && (sb->s_flags & MS_RDONLY);
=20
        if (sb->s_op->remount_fs) {
                retval =3D sb->s_op->remount_fs(sb, &flags, data);
                if (retval) {
                        unlock_kernel();
                        return retval;
                }
        }
        sb->s_flags =3D (sb->s_flags & ~MS_RMT_MASK) | (flags & MS_RMT_MASK=
);
-       unlock_kernel();


cheers


> ------------[ cut here ]------------
> kernel BUG at lib/kernel_lock.c:126!
> Oops: Exception in kernel mode, sig: 5 [#1]
> SMP NR_CPUS=3D1024 NUMA pSeries
> Modules linked in: ipv6 fuse loop dm_mod sr_mod ehea cdrom sg ibmveth sd_=
mod crc_t10dif ibmvscsic scsi_transport_srp scsi_tgt scsi_mod
> NIP: c0000000005c6dac LR: c0000000001965ac CTR: 0000000000000006
> REGS: c00000002a5d3910 TRAP: 0700   Not tainted  (2.6.30-git10)
> MSR: 8000000000029032 <EE,ME,CE,IR,DR>  CR: 82042442  XER: 00000000
> TASK =3D c0000000407cbc20[9581] 'mount' THREAD: c00000002a5d0000 CPU: 3
> <6>GPR00: 0000000000000001 c00000002a5d3b90 c000000000ef31f0 ffffffffffff=
fff0=20
> <6>GPR04: c0000000000f0098 c000000000799813 0000000000000000 000000000000=
0001=20
> <6>GPR08: c000000000e36aa0 c0000000407cbc20 0000000000000002 c0000000407c=
bc20=20
> <6>GPR12: 0000000024042424 c000000000ff2a00 00000fffed50f6fd 00000fffed50=
6e08=20
> <6>GPR16: 00000fffed506db8 000000001002b638 0000000000000000 000000000000=
0000=20
> <6>GPR20: 00000000100329a0 00000fffed506e0c c00000003e14b870 000000000000=
0000=20
> <6>GPR24: 0000000000000000 c00000002a030000 0000000000000000 000000000000=
0000=20
> <6>GPR28: c00000003e14b800 fffffffffffffff0 c000000000e7aa40 c00000002a5d=
3b90=20
> NIP [c0000000005c6dac] .unlock_kernel+0x20/0x78
> LR [c0000000001965ac] .do_remount_sb+0x190/0x204
> Call Trace:
> [c00000002a5d3bd0] [c00000000019659c] .do_remount_sb+0x180/0x204
> [c00000002a5d3c70] [c0000000001b8210] .do_mount+0x38c/0x9fc
> [c00000002a5d3d60] [c0000000001b8940] .SyS_mount+0xc0/0x12c
> [c00000002a5d3e30] [c000000000008534] syscall_exit+0x0/0x40
> Instruction dump:
> 383f0040 ebc1fff0 ebe1fff8 4e800020 fbc1fff0 fbe1fff8 f821ffc1 7c3f0b78=20
> ebc2c0b8 e92d01b0 e809001e 78000fe0 <0b000000> e96d01b0 812b001c 3929ffff=
=20
> ---[ end trace 3bf0012ad33d52b2 ]---
>=20
> Corresponding c code is :
>=20
> void __lockfunc unlock_kernel(void)
> {
>         BUG_ON(current->lock_depth < 0);  <<=3D=3D=3D=3D=3D=3D
>         if (likely(--current->lock_depth < 0))
>                 __unlock_kernel();
>=20
> Have attached the cgroups regression test run log.
>=20
> Thanks
> -Sachin
>=20
> _______________________________________________
> Linuxppc-dev mailing list
> Linuxppc-dev@lists.ozlabs.org
> https://lists.ozlabs.org/listinfo/linuxppc-dev


--=-PiJEtoJfsvvYXMfO7IYR
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAko40WkACgkQdSjSd0sB4dIiMQCgmtxXOuX34N36w/3RTXZnizzP
so4AoMuwaqRDX/hgVnddXzigklL+3C+C
=a43q
-----END PGP SIGNATURE-----

--=-PiJEtoJfsvvYXMfO7IYR--

