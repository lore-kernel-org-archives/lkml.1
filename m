Return-Path: <linux-kernel-owner+w=401wt.eu-S1759061AbXJaKax@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759061AbXJaKax (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2007 06:30:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753853AbXJaKao
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Oct 2007 06:30:44 -0400
Received: from viefep18-int.chello.at ([213.46.255.22]:23998 "EHLO
	viefep33-int.chello.at" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753712AbXJaKam (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2007 06:30:42 -0400
Subject: Re: aim7 -30% regression in 2.6.24-rc1
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1193824668.3019.236.camel@ymzhang>
References: <1193391787.3019.174.camel@ymzhang>
	 <20071026112307.GA30406@elte.hu> <1193624538.3019.189.camel@ymzhang>
	 <1193650626.3019.198.camel@ymzhang> <1193710325.3019.203.camel@ymzhang>
	 <20071030072658.GB20372@elte.hu>  <1193733390.3019.210.camel@ymzhang>
	 <1193824668.3019.236.camel@ymzhang>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-CYikUQT5ExiBW+NaquNS"
Date: Wed, 31 Oct 2007 11:30:39 +0100
Message-Id: <1193826639.27652.113.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--=-CYikUQT5ExiBW+NaquNS
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2007-10-31 at 17:57 +0800, Zhang, Yanmin wrote:
> On Tue, 2007-10-30 at 16:36 +0800, Zhang, Yanmin wrote:
> > On Tue, 2007-10-30 at 08:26 +0100, Ingo Molnar wrote:
> > > * Zhang, Yanmin <yanmin_zhang@linux.intel.com> wrote:
> > >=20
> > > > sub-bisecting captured patch=20
> > > > 38ad464d410dadceda1563f36bdb0be7fe4c8938(sched: uniform tunings)=20
> > > > caused 20% regression of aim7.
> > > >=20
> > > > The last 10% should be also related to sched parameters, such like=20
> > > > sysctl_sched_min_granularity.
> > >=20
> > > ah, interesting. Since you have CONFIG_SCHED_DEBUG enabled, could you=
=20
> > > please try to figure out what the best value for=20
> > > /proc/sys/kernel_sched_latency, /proc/sys/kernel_sched_nr_latency and=
=20
> > > /proc/sys/kernel_sched_min_granularity is?
> > >=20
> > > there's a tuning constraint for kernel_sched_nr_latency:=20
> > >=20
> > > - kernel_sched_nr_latency should always be set to=20
> > >   kernel_sched_latency/kernel_sched_min_granularity. (it's not a free=
=20
> > >   tunable)
> > >=20
> > > i suspect a good approach would be to double the value of=20
> > > kernel_sched_latency and kernel_sched_nr_latency in each tuning=20
> > > iteration, while keeping kernel_sched_min_granularity unchanged. That=
=20
> > > will excercise the tuning values of the 2.6.23 kernel as well.
> > I followed your idea to test 2.6.24-rc1. The improvement is slow.
> > When sched_nr_latency=3D2560 and sched_latency_ns=3D640000000, the perf=
ormance
> > is still about 15% less than 2.6.23.
>=20
> I got the aim7 30% regression on my new upgraded stoakley machine. I foun=
d
> this mahcine is slower than the old one. Maybe BIOS has issues, or memeor=
y(Might not
> be dual-channel?) is slow. So I retested it on the old machine and found =
on the old
> stoakley machine, the regression is about 6%, quite similiar to the regre=
ssion on tigerton
> machine.
>=20
> By sched_nr_latency=3D640 and sched_latency_ns=3D640000000 on the old sto=
akley machine,
> the regression becomes about 2%. Other latency has more regression.
>=20
> On my tulsa machine, by sched_nr_latency=3D640 and sched_latency_ns=3D640=
000000,
> the regression becomes less than 1% (The original regression is about 20%=
).
>=20
> When I ran a bad script to change the values of sched_nr_latency and sche=
d_latency_ns,
> I hit OOPS on my tulsa machine. Below is the log. It looks like sched_nr_=
latency becomes
> 0.

Oops, yeah I think I overlooked that case :-/
I think limiting the sysctl parameters make most sense, as a 0 value
really doesn't.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index 3b4efbe..0f34c91 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -94,6 +94,7 @@ static int two =3D 2;
=20
 static int zero;
 static int one_hundred =3D 100;
+static int int_max =3D INT_MAX;
=20
 /* this is needed for the proc_dointvec_minmax for [fs_]overflow UID and G=
ID */
 static int maxolduid =3D 65535;
@@ -239,7 +240,10 @@ static struct ctl_table kern_table[] =3D {
 		.data		=3D &sysctl_sched_nr_latency,
 		.maxlen		=3D sizeof(unsigned int),
 		.mode		=3D 0644,
-		.proc_handler	=3D &proc_dointvec,
+		.proc_handler	=3D &proc_dointvec_minmax,
+		.strategy	=3D &sysctl_intvec,
+		.extra1		=3D &one,
+		.extra2		=3D &int_max,
 	},
 	{
 		.ctl_name	=3D CTL_UNNUMBERED,


--=-CYikUQT5ExiBW+NaquNS
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBHKFlPXA2jU0ANEf4RApuSAJ9FOf5Zm1UmksKNuL0smiJhjrzOSACfeDZH
D85WogvyebhlMcDpsMHD4R0=
=Y4X5
-----END PGP SIGNATURE-----

--=-CYikUQT5ExiBW+NaquNS--

