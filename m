Return-Path: <linux-kernel-owner+w=401wt.eu-S1423001AbXCBKOC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423001AbXCBKOC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2007 05:14:02 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423002AbXCBKOB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Mar 2007 05:14:01 -0500
Received: from ozlabs.org ([203.10.76.45]:55582 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423001AbXCBKOA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2007 05:14:00 -0500
Subject: Re: [Cbe-oss-dev] [PATCH 14/22] spufs: use SPU master control to
	prevent wild	SPU execution
From: Michael Ellerman <michael@ellerman.id.au>
Reply-To: michael@ellerman.id.au
To: Arnd Bergmann <arnd@arndb.de>
Cc: cbe-oss-dev@ozlabs.org, linux-kernel@vger.kernel.org,
       linuxppc-dev@ozlabs.org
In-Reply-To: <200703011450.50935.arnd@arndb.de>
References: <20061120174454.067872000@arndb.de>
	 <20061120180525.281408000@arndb.de>
	 <1172729890.5852.40.camel@concordia.ozlabs.ibm.com>
	 <200703011450.50935.arnd@arndb.de>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-55G8gmVN1fLU+I4MzSsa"
Date: Fri, 02 Mar 2007 19:13:57 +0900
Message-Id: <1172830438.16533.6.camel@concordia.ozlabs.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.1 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--=-55G8gmVN1fLU+I4MzSsa
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2007-03-01 at 14:50 +0100, Arnd Bergmann wrote:=20
> On Thursday 01 March 2007, Michael Ellerman wrote:
> > On Mon, 2006-11-20 at 18:45 +0100, Arnd Bergmann wrote:
> > > plain text document attachment (spufs-master-control.diff)
> > > When the user changes the runcontrol register, an SPU might be
> > > running without a process being attached to it and waiting for
> > > events. In order to prevent this, make sure we always disable
> > > the priv1 master control when we're not inside of spu_run.
> >=20
> > Hi Arnd,
> >=20
> > Sorry I didn't comment on this when you sent it, I wasn't paying enough
> > attention. This patch confuses me, you say we should make sure we alway=
s
> > disable the master control when we're not inside spu_run, but I see
> > several exit paths where we leave the master run bit enabled - or maybe
> > I'm reading it wrong.
>=20
> I think you're right, there is at least one path that I now saw
> getting out of spufs_run_spu incorrectly. In particular, when
> spu_reacquire_runnable() fails, we never call the master stop,
> which is a bug, but should happen very infrequently in practice.
> Do you see another case where we end up with the same problem?

That was the first one that caught my eye, but I wasn't sure about the
semantics of the error case.

There's also the error case for spu_run_init() which skips the master
stop. I guess that's ok because we've only set the master control in the
backing store, and the only way that will ever get propagated to an
actual spu is by coming back thorough spufs_run_spu().

What originally caught my eye on this was the output from xmon. When we
drop into xmon with no spu programs running and stop the spus, it
reports that they _all_ have the master run enabled, and some of them
have the runcntl enabled (those that have had spu programs run on them
since boot it seems).

It looks like the save/restore code sets the master bit in several
places, but never sets/clears the runcntl, which seems bogus to me.

So when we leave spufs_spu_run we do the master stop call:

spu_mfc_sr1_set: spu: c00000007ffdfc80 (15) sr1: 0x1b runcntl: 0x1
Call Trace:
[C00000000196BAA0] [C00000000000F920] .show_stack+0x68/0x1b0 (unreliable)
[C00000000196BB40] [D0000000001475C0] .spu_hw_master_stop+0xa8/0x170 [spufs=
]
[C00000000196BBE0] [D000000000148598] .spufs_run_spu+0x5ec/0x770 [spufs]
[C00000000196BCC0] [D000000000144BA0] .do_spu_run+0xb4/0x180 [spufs]
[C00000000196BD80] [C00000000003905C] .sys_spu_run+0xb0/0x108
[C00000000196BE30] [C000000000008634] syscall_exit+0x0/0x40


But then the save/restore code sets it back on?

spu_mfc_sr1_set: spu: c00000007ffdfc80 (15) sr1: 0x32 runcntl: 0x1
Call Trace:
[C00000000FF9B790] [C00000000000F920] .show_stack+0x68/0x1b0 (unreliable)
[C00000000FF9B830] [C00000000003B310] .spu_save+0x9b0/0x156c
[C00000000FF9B950] [D0000000001457FC] .spu_unbind_context+0x124/0x1a4 [spuf=
s]
[C00000000FF9B9F0] [D0000000001458B0] .spu_deactivate+0x34/0x138 [spufs]
[C00000000FF9BA80] [D00000000014448C] .spu_acquire_saved+0x34/0x4c [spufs]
[C00000000FF9BB10] [D00000000014493C] .spu_forget+0x18/0x4c [spufs]
[C00000000FF9BBA0] [D00000000014030C] .spufs_dir_close+0x78/0xb4 [spufs]
[C00000000FF9BC50] [C0000000000B8594] .__fput+0x110/0x200
[C00000000FF9BD00] [C0000000000B4F38] .filp_close+0xac/0xd4
[C00000000FF9BD90] [C0000000000B68BC] .sys_close+0xc4/0x130
[C00000000FF9BE30] [C000000000008634] syscall_exit+0x0/0x40


cheers

--=20
Michael Ellerman
OzLabs, IBM Australia Development Lab

wwweb: http://michael.ellerman.id.au
phone: +61 2 6212 1183 (tie line 70 21183)

We do not inherit the earth from our ancestors,
we borrow it from our children. - S.M.A.R.T Person

--=-55G8gmVN1fLU+I4MzSsa
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.3 (GNU/Linux)

iD8DBQBF5/jldSjSd0sB4dIRAslrAJ9jIKuU9H0IqTybcPgszgpiPDqKQQCgmrtN
2b+aAW95kQnvq2FYk842f8E=
=E1sj
-----END PGP SIGNATURE-----

--=-55G8gmVN1fLU+I4MzSsa--

