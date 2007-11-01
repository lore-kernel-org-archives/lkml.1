Return-Path: <linux-kernel-owner+w=401wt.eu-S1759906AbXKALwL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759906AbXKALwL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2007 07:52:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756717AbXKALv5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Nov 2007 07:51:57 -0400
Received: from viefep18-int.chello.at ([213.46.255.22]:13626 "EHLO
	viefep34-int.chello.at" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754159AbXKALv5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2007 07:51:57 -0400
Subject: Re: [PATCH 2/6] sched: make sched_slice() group scheduling savvy
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: vatsa@linux.vnet.ibm.com
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Mike Galbraith <efault@gmx.de>,
       Dmitry Adamushko <dmitry.adamushko@gmail.com>
In-Reply-To: <20071101113138.GA20788@linux.vnet.ibm.com>
References: <20071031211030.310581000@chello.nl>
	 <20071031211248.796653000@chello.nl>
	 <20071101113138.GA20788@linux.vnet.ibm.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-yCxK12Ev8B/oHyZNNtr5"
Date: Thu, 01 Nov 2007 12:51:52 +0100
Message-Id: <1193917912.27652.258.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--=-yCxK12Ev8B/oHyZNNtr5
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2007-11-01 at 17:01 +0530, Srivatsa Vaddagiri wrote:
> On Wed, Oct 31, 2007 at 10:10:32PM +0100, Peter Zijlstra wrote:
> > Currently the ideal slice length does not take group scheduling into ac=
count.
> > Change it so that it properly takes all the runnable tasks on this cpu =
into
> > account and caluclate the weight according to the grouping hierarchy.
> >=20
> > Also fixes a bug in vslice which missed a factor NICE_0_LOAD.
> >=20
> > Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> > CC: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
> > ---
> >  kernel/sched_fair.c |   42 +++++++++++++++++++++++++++++++-----------
> >  1 file changed, 31 insertions(+), 11 deletions(-)
> >=20
> > Index: linux-2.6/kernel/sched_fair.c
> > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> > --- linux-2.6.orig/kernel/sched_fair.c
> > +++ linux-2.6/kernel/sched_fair.c
> > @@ -331,10 +331,15 @@ static u64 __sched_period(unsigned long=20
> >   */
> >  static u64 sched_slice(struct cfs_rq *cfs_rq, struct sched_entity *se)
> >  {
> > -	u64 slice =3D __sched_period(cfs_rq->nr_running);
> > +	unsigned long nr_running =3D rq_of(cfs_rq)->nr_running;
> > +	u64 slice =3D __sched_period(nr_running);
> >=20
> > -	slice *=3D se->load.weight;
> > -	do_div(slice, cfs_rq->load.weight);
> > +	for_each_sched_entity(se) {
> > +		cfs_rq =3D cfs_rq_of(se);
> > +
> > +		slice *=3D se->load.weight;
> > +		do_div(slice, cfs_rq->load.weight);
> > +	}
> >=20
> >  	return slice;
>=20
>=20
> Lets say we have two groups A and B on CPU0, of equal weight (1024).
>=20
> Further,
>=20
> A has 1 task (A0)
> B has 1000 tasks (B0 .. B999)=20
>=20
> Agreed its a extreme case, but illustrates the problem I have in mind
> for this patch.
>=20
> All tasks of same weight=3D1024.
>=20
> Before this patch
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>=20
> 	sched_slice(grp A) =3D 20ms * 1/2 =3D 10ms
> 	sched_slice(A0) =3D 20ms
>=20
> 	sched_slice(grp B) =3D 20ms * 1/2 =3D 10ms
> 	sched_slice(B0) =3D (20ms * 1000/20) * 1 / 1000 =3D 1ms
> 	sched_slice(B1) =3D ... =3D sched_slice(B99) =3D 1 ms
>=20
> Fairness between groups and tasks would be obtained as below:
>=20
>     A0       B0-B9     A0    B10-B19     A0     B20-B29
>  |--------|--------|--------|--------|--------|--------|-----//--|=20
>  0       10ms	   20ms	   30ms     40ms     50ms     60ms
>=20
> After this patch
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>=20
> 	sched_slice(grp A) =3D (20ms * 1001/20) * 1/2 ~=3D 500ms
> 	sched_slice(A0) =3D 500ms

Hmm, right that is indeed not intended

> 	sched_slice(grp B) =3D 500ms
> 	sched_slice(B0) =3D 0.5ms=20

This 0.5 is indeed correct, whereas the previous 1ms was not

> Fairness between groups and tasks would be obtained as below:
>=20
> 	    A0		          B0 - B99  	            A0
>  |-----------------------|-----------------------|-----------------------=
|
>  0		        500ms			1000ms 			1500ms
>=20
> Did I get it right? If so, I don't like the fact that group A is allowed =
to run=20
> for a long time (500ms) before giving chance to group B.

Hmm, quite bad indeed.

> Can I know what real problem is being addressed by this change to
> sched_slice()?

sched_slice() is about lantecy, its intended purpose is to ensure each
task is ran exactly once during sched_period() - which is
sysctl_sched_latency when nr_running <=3D sysctl_sched_nr_latency, and
otherwise linearly scales latency.



--=-yCxK12Ev8B/oHyZNNtr5
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBHKb3YXA2jU0ANEf4RAh7OAJ0WjP8zI1mFb5o4lc/d//xemPGr+wCdHQRC
27QGkii3x1TxuyDRckebc0E=
=ikT8
-----END PGP SIGNATURE-----

--=-yCxK12Ev8B/oHyZNNtr5--

