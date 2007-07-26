Return-Path: <linux-kernel-owner+w=401wt.eu-S1765470AbXGZMpl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765470AbXGZMpl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2007 08:45:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759039AbXGZMpc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jul 2007 08:45:32 -0400
Received: from mtagate1.uk.ibm.com ([195.212.29.134]:50489 "EHLO
	mtagate1.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758446AbXGZMpa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2007 08:45:30 -0400
Date: Thu, 26 Jul 2007 14:44:33 +0200
From: Christian Krafft <krafft@de.ibm.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Trond Myklebust <trond.myklebust@fys.uio.no>, linux-kernel@vger.kernel.org
Subject: Re: [patch] nfs: fix locking in nfs/inode.c in
 nfs_free_open_context
Message-ID: <20070726144433.080126f7@localhost>
In-Reply-To: <200707261323.38310.arnd@arndb.de>
References: <20070725170837.5fba5fd1@localhost>
	<1185384502.6585.97.camel@localhost>
	<200707261323.38310.arnd@arndb.de>
Organization: IBM Deutschland Entwicklung GmbH
X-Mailer: Claws Mail 2.8.1 (GTK+ 2.10.9; i686-pc-linux-gnu)
X-Face: `W@`hRxh5l!3-i=A%w>*|0PiG}G;2Y!DoiUjUcBX:Xf)vV'7+Is>5$*66xg5jwQA8P65#e
 <*gu)O37;+RS9iC[c7wnR]O0%dkLr^g_f1`&sfIQe&BG$E)b=GyjfCE$Ao'.6#^8@+z^`v
 qs#^Z%sWk_290zu+7nql/d?=lf<5^JI(C?MeXv;Tz)`xYOe<*"3'M?r2NHOdm_&jy-0Gp,
 3VVLR;cE=X-;J?p6b~_?K+jTAJrnGuuO%<!$3".gR,z_~jYJ"be)qH1(1A?koh`}d6Le|k
 CE<Y)JAsm
Mime-Version: 1.0
Content-Type: multipart/signed; boundary=Sig_mD1J9ojh9mzkEJjaFTncfMv;
 protocol="application/pgp-signature"; micalg=PGP-SHA1
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_mD1J9ojh9mzkEJjaFTncfMv
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Thu, 26 Jul 2007 13:23:37 +0200
Arnd Bergmann <arnd@arndb.de> wrote:

> On Wednesday 25 July 2007, Trond Myklebust wrote:
> >=20
> > On Wed, 2007-07-25 at 17:08 +0200, Christian Krafft wrote:
> >=20
> > > Obviously the locking code in nfs_free_open_context is wrong.
> > > Checking the list for entries and removing the entry should be an ato=
mic operation.
> >=20
> > Wrong. It is quite safe to test the structure member ctx->list for
> > emptiness outside the spinlock because we have an explicit guarantee
> > that nobody else has a reference to this structure, plus the
> > atomic_dec_and_test() in kref_put() has acted as a memory barrier for
> > us.
>=20
> Well, the real question then is how the ctx can still be present in the
> nfsi->open_files list. Since we are in nfs_free_open_context(), there
> must not be any pointer to the ctx anywhere, but still we have this other
> thread calling get_nfs_open_context() on it.
>=20
> 	Arnd <><

Thanks for the pointer Arnd,

Trond, does the patch below look better to you ?

Note:
For now the list_del_init is needed, so that the BUG_ON(!list_empty) works =
correctly.
(I have no clue why list_empty should not be working, when the list has bee=
n poisoned by a list_del.)
I am running the stress tests now. It seems to work so far.
---


Subject: nfs: fix locking in nfs/inode.c in nfs_free_open_context

From: Christian Krafft <krafft@de.ibm.com>

While running some tests on a server using NFS root I found some
locking problems.

The scripts I am using can be found under at

http://localhorst.gotdns.org/parabelboi/nfs/

Please note, I am using rpm to generate read load. I found no better way
to generate that much stress on the read path ;-)

It's a two way machine btw, with mount options tcp,nolock the problem
doesn't occur (probably due to a different timing).
When running write_back.sh six times concurrent with one read.sh,
the processes will be locked within a few minutes.

The problem occurs at least on 2.6.22 and 2.6.23-rc1.
It shows up like this:

Badness at lib/kref.c:33
NIP: c00000000018b734 LR: c00000000014c37c CTR: c0000000001566f0
REGS: c00000007aebf160 TRAP: 0700   Not tainted  (2.6.23-rc1)
MSR: 9000000000029032 <EE,ME,IR,DR>  CR: 84000422  XER: 00000000
TASK =3D c00000007df7d530[30769] 'sync' THREAD: c00000007aebc000 CPU: 3
NIP [c00000000018b734] .kref_get+0xc/0x28
LR [c00000000014c37c] .get_nfs_open_context+0x1c/0x38
Call Trace:
[c00000007aebf3e0] [c00000000033d9f4] ._spin_lock+0x10/0x24 (unreliable)
[c00000007aebf460] [c00000000014cf40] .nfs_find_open_context+0x68/0xcc
[c00000007aebf500] [c000000000156654] .nfs_writepage_locked+0x164/0x200
[c00000007aebf600] [c00000000015670c] .nfs_writepage+0x1c/0x48
[c00000007aebf690] [c00000000008e53c] .__writepage+0x3c/0x84
[c00000007aebf710] [c00000000008ed84] .write_cache_pages+0x238/0x3f4
[c00000007aebf880] [c000000000155840] .nfs_writepages+0x7c/0xc0
[c00000007aebf970] [c00000000008efe0] .do_writepages+0x68/0xa4
[c00000007aebf9f0] [c0000000000e0290] .__writeback_single_inode+0x1bc/0x3b8
[c00000007aebfae0] [c0000000000e0984] .sync_sb_inodes+0x20c/0x308
[c00000007aebfb90] [c0000000000e0b50] .sync_inodes_sb+0xd0/0x100
[c00000007aebfc80] [c0000000000e0c14] .__sync_inodes+0x94/0x120
nstruction dump:
4e800421 e8410028 38000001 38210080 7c030378 e8010010 ebc1fff0 7c0803a6=20
4e800020 80030000 7c000034 5400d97e <0b000000> 7c001828 30000001 7c00192d=20
Unable to handle kernel paging request for data at address 0x00200200
Faulting instruction address: 0xc000000000193474
cpu 0x0: Vector: 300 (Data Access) at [c00000000ff4b5b0]
    pc: c000000000193474: .list_del+0x20/0xa4
    lr: c00000000014c2e8: .nfs_free_open_context+0x4c/0xc4
    sp: c00000000ff4b830
   msr: 9000000000009032
   dar: 200200
 dsisr: 40000000
  current =3D 0xc00000000ff0a230
  paca    =3D 0xc00000000047e900
    pid   =3D 506, comm =3D rpciod/0
enter ? for help
[c00000000ff4b8b0] c00000000014c2e8 .nfs_free_open_context+0x4c/0xc4
[c00000000ff4b940] c00000000018b708 .kref_put+0x74/0x94
[c00000000ff4b9c0] c00000000014c1dc .put_nfs_open_context+0x1c/0x34
[c00000000ff4ba40] c000000000150ec0 .nfs_free_request+0x2c/0x5c
[c00000000ff4bad0] c00000000018b708 .kref_put+0x74/0x94
[c00000000ff4bb50] c000000000150e2c .nfs_release_request+0x20/0x38
[c00000000ff4bbd0] c00000000015750c .nfs_writeback_done_partial+0x270/0x2c8
[c00000000ff4bc80] c0000000003274fc .rpc_exit_task+0x5c/0xa0

Obviously the locking code in nfs_free_open_context is wrong.
Checking the list for entries and removing the entry should be an atomic op=
eration.
Also list_del_init should be used, because list_del will leave the empty li=
st in
an undefined condition.

After applying the patch the scripts run a bit longer, but another error oc=
curs :-/

Signed-off-by: Christian Krafft <krafft@de.ibm.com>

Index: linux-2.6.23-rc1/fs/nfs/inode.c
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- linux-2.6.23-rc1.orig/fs/nfs/inode.c
+++ linux-2.6.23-rc1/fs/nfs/inode.c
@@ -485,12 +485,8 @@ static void nfs_free_open_context(struct
 	struct nfs_open_context *ctx =3D container_of(kref,
 			struct nfs_open_context, kref);
=20
-	if (!list_empty(&ctx->list)) {
-		struct inode *inode =3D ctx->path.dentry->d_inode;
-		spin_lock(&inode->i_lock);
-		list_del(&ctx->list);
-		spin_unlock(&inode->i_lock);
-	}
+	BUG_ON(!list_empty(&ctx->list));
+
 	if (ctx->state !=3D NULL)
 		nfs4_close_state(&ctx->path, ctx->state, ctx->mode);
 	if (ctx->cred !=3D NULL)
@@ -549,7 +545,7 @@ static void nfs_file_clear_open_context(
 	if (ctx) {
 		filp->private_data =3D NULL;
 		spin_lock(&inode->i_lock);
-		list_move_tail(&ctx->list, &NFS_I(inode)->open_files);
+		list_del_init(&ctx->list);
 		spin_unlock(&inode->i_lock);
 		put_nfs_open_context(ctx);
 	}

--=20
Mit freundlichen Gruessen,
kind regards,

Christian Krafft
IBM Systems & Technology Group,
Linux Kernel Development
IT Specialist


Vorsitzender des Aufsichtsrats:	Martin Jetter
Geschaeftsfuehrung:		Herbert Kircher
Sitz der Gesellschaft:		Boeblingen
Registriergericht:		Amtsgericht Stuttgart, HRB 243294


--Sig_mD1J9ojh9mzkEJjaFTncfMv
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFGqJc/6rqK4qDx+dcRAsR/AKC2oXnA7wnHwS+ufZb0X7+zIUgeEACggE60
oEDYOkbIooYn0ohH51ox0Sc=
=LbWz
-----END PGP SIGNATURE-----

--Sig_mD1J9ojh9mzkEJjaFTncfMv--
