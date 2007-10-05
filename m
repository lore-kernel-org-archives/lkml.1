Return-Path: <linux-kernel-owner+w=401wt.eu-S1759373AbXJEHdS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759373AbXJEHdS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2007 03:33:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752792AbXJEHdE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Oct 2007 03:33:04 -0400
Received: from viefep18-int.chello.at ([213.46.255.22]:64053 "EHLO
	viefep15-int.chello.at" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755553AbXJEHdB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2007 03:33:01 -0400
Subject: Re: [PATCH] remove throttle_vm_writeout()
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Miklos Szeredi <miklos@szeredi.hu>, wfg@mail.ustc.edu.cn,
       linux-mm@kvack.org, linux-kernel@vger.kernel.org
In-Reply-To: <20071004160941.e0c0c7e5.akpm@linux-foundation.org>
References: <E1IdPla-0002Bd-00@dorka.pomaz.szeredi.hu>
	 <20071004145640.18ced770.akpm@linux-foundation.org>
	 <E1IdZLg-0002Wr-00@dorka.pomaz.szeredi.hu>
	 <20071004160941.e0c0c7e5.akpm@linux-foundation.org>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-Cu2uxn8Sr4XKkNK4aPLz"
Date: Fri, 05 Oct 2007 09:32:57 +0200
Message-Id: <1191569577.22357.22.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--=-Cu2uxn8Sr4XKkNK4aPLz
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2007-10-04 at 16:09 -0700, Andrew Morton wrote:
> On Fri, 05 Oct 2007 00:39:16 +0200
> Miklos Szeredi <miklos@szeredi.hu> wrote:
>=20
> > > throttle_vm_writeout() should be a per-zone thing, I guess.  Perhaps =
fixing
> > > that would fix your deadlock.  That's doubtful, but I don't know anyt=
hing
> > > about your deadlock so I cannot say.
> >=20
> > No, doing the throttling per-zone won't in itself fix the deadlock.
> >=20
> > Here's a deadlock example:
> >=20
> > Total memory =3D 32M
> > /proc/sys/vm/dirty_ratio =3D 10
> > dirty_threshold =3D 3M
> > ratelimit_pages =3D 1M
> >=20
> > Some program dirties 4M (dirty_threshold + ratelimit_pages) of mmap on
> > a fuse fs.  Page balancing is called which turns all these into
> > writeback pages.
> >=20
> > Then userspace filesystem gets a write request, and tries to allocate
> > memory needed to complete the writeout.
> >=20
> > That will possibly trigger direct reclaim, and throttle_vm_writeout()
> > will be called.  That will block until nr_writeback goes below 3.3M
> > (dirty_threshold + 10%).  But since all 4M of writeback is from the
> > fuse fs, that will never happen.
> >=20
> > Does that explain it better?
> >=20
>=20
> yup, thanks.
>=20
> This is a somewhat general problem: a userspace process is in the IO path=
.=20
> Userspace block drivers, for example - pretty much anything which involve=
s
> kernel->userspace upcalls for storage applications.
>=20
> I solved it once in the past by marking the userspace process as
> PF_MEMALLOC and I beleive that others have implemented the same hack.
>=20
> I suspect that what we need is a general solution, and that the solution
> will involve explicitly telling the kernel that this process is one which
> actually cleans memory and needs special treatment.
>=20
> Because I bet there will be other corner-cases where such a process needs
> kernel help, and there might be optimisation opportunities as well.
>=20
> Problem is, any such mark-me-as-special syscall would need to be
> privileged, and FUSE servers presently don't require special perms (do
> they?)

I think just adding nr_cpus * ratelimit_pages to the dirth_thresh in
throttle_vm_writeout() will also solve the problem

--=-Cu2uxn8Sr4XKkNK4aPLz
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBHBeipXA2jU0ANEf4RApgvAJ92EWsfzvf/eQErQHbIn/qWFEvCqQCbB1Q7
fLPQqJlxYwETFscV2+9DFwg=
=7VY/
-----END PGP SIGNATURE-----

--=-Cu2uxn8Sr4XKkNK4aPLz--

