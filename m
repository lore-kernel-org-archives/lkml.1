Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750944Ab0CAKsP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Mar 2010 05:48:15 -0500
Received: from gate.lvk.cs.msu.su ([158.250.17.1]:37556 "EHLO
	mail.lvk.cs.msu.su" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750764Ab0CAKsN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Mar 2010 05:48:13 -0500
X-Spam-ASN: 
Date: Mon, 1 Mar 2010 13:48:01 +0300
From: Alexander Gordeev <lasaine@lvk.cs.msu.su>
To: Rodolfo Giometti <giometti@enneenne.com>
Cc: linux-kernel@vger.kernel.org, linuxpps@ml.enneenne.com,
       "Nikita V. Youshchenko" <yoush@cs.msu.su>, stas@lvk.cs.msu.su,
       john stultz <johnstul@us.ibm.com>, Randy Dunlap <rdunlap@xenotime.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       Mauro Carvalho Chehab <mchehab@redhat.com>,
       Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>,
       Avi Kivity <avi@redhat.com>, Reg Clemens <clemens@dwf.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Dave Jones <davej@redhat.com>,
       linux-doc@vger.kernel.org
Subject: Re: [PATCHv2 4/6] pps: add kernel consumer support
Message-ID: <20100301134801.319a6c3b@desktopvm.lvknet>
In-Reply-To: <20100301082916.GJ3671@enneenne.com>
References: <cover.1267008049.git.lasaine@lvk.cs.msu.su>
	<84b05b9e8dc74f46c99de1728dc5baf24d85d9cc.1267008049.git.lasaine@lvk.cs.msu.su>
	<20100301082916.GJ3671@enneenne.com>
Organization: LVK
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.12; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/qJTYF0lfGk=2lceJpB9SX+u";
 protocol="application/pgp-signature"; micalg=PGP-SHA256
X-AV-Checked: ClamAV using ClamSMTP
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/qJTYF0lfGk=2lceJpB9SX+u
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon, 1 Mar 2010 09:29:16 +0100
Rodolfo Giometti <giometti@enneenne.com> wrote:

> On Wed, Feb 24, 2010 at 03:28:15PM +0300, Alexander Gordeev wrote:
> > Add an optional feature of PPSAPI, kernel consumer support, which uses
> > the added hardpps() function.
> >=20
> > Signed-off-by: Alexander Gordeev <lasaine@lvk.cs.msu.su>
>=20
> Acked-by: Rodolfo Giometti <giometti@linux.it>
>=20
> However see the note below.
>=20
> > ---
> >  Documentation/ioctl/ioctl-number.txt |    2 +-
> >  drivers/pps/kapi.c                   |   26 +++++++++++++
> >  drivers/pps/pps.c                    |   67 ++++++++++++++++++++++++++=
+++++++-
> >  include/linux/pps.h                  |    7 ++++
> >  include/linux/pps_kernel.h           |    6 +++
> >  5 files changed, 106 insertions(+), 2 deletions(-)
> >=20
> > diff --git a/Documentation/ioctl/ioctl-number.txt b/Documentation/ioctl=
/ioctl-number.txt
> > index 9473749..d68718b 100644
> > --- a/Documentation/ioctl/ioctl-number.txt
> > +++ b/Documentation/ioctl/ioctl-number.txt
> > @@ -152,7 +152,7 @@ Code	Seq#	Include File		Comments
> >  'p'	40-7F	linux/nvram.h
> >  'p'	80-9F				user-space parport
> >  					<mailto:tim@cyberelk.net>
> > -'p'	a1-a4	linux/pps.h		LinuxPPS
> > +'p'	a1-a5	linux/pps.h		LinuxPPS
> >  					<mailto:giometti@linux.it>
> >  'q'	00-1F	linux/serio.h
> >  'q'	80-FF				Internet PhoneJACK, Internet LineJACK
> > diff --git a/drivers/pps/kapi.c b/drivers/pps/kapi.c
> > index b87f699..5871744 100644
> > --- a/drivers/pps/kapi.c
> > +++ b/drivers/pps/kapi.c
> > @@ -25,6 +25,7 @@
> >  #include <linux/init.h>
> >  #include <linux/sched.h>
> >  #include <linux/time.h>
> > +#include <linux/timex.h>
> >  #include <linux/spinlock.h>
> >  #include <linux/idr.h>
> >  #include <linux/fs.h>
> > @@ -37,6 +38,12 @@
> >  DEFINE_SPINLOCK(pps_idr_lock);
> >  DEFINE_IDR(pps_idr);
> > =20
> > +/* state variables to bind kernel consumer */
> > +/* PPS API (RFC 2783): current source and mode for ``kernel consumer''=
 */
> > +DEFINE_SPINLOCK(pps_kc_hardpps_lock);
> > +void	*pps_kc_hardpps_dev;	/* some unique pointer to device */
> > +int	pps_kc_hardpps_mode;	/* mode bits for kernel consumer */
> > +
> >  /*
> >   * Local functions
> >   */
> > @@ -248,6 +255,15 @@ void pps_unregister_source(int source)
> >  	}
> >  	spin_unlock_irq(&pps_idr_lock);
> > =20
> > +	spin_lock_irq(&pps_kc_hardpps_lock);
> > +	if (pps =3D=3D pps_kc_hardpps_dev) {
> > +		pps_kc_hardpps_mode =3D 0;
> > +		pps_kc_hardpps_dev =3D NULL;
> > +		spin_unlock_irq(&pps_kc_hardpps_lock);
> > +		pr_info("unbound kernel consumer on device removal\n");
> > +	} else
> > +		spin_unlock_irq(&pps_kc_hardpps_lock);
> > +
>=20
> I suppose you are using such if-else schema due the fact pr_info is
> too slow to be executed with helded spinlock, arent't you? :)

Yes, indeed. Is it ok? :)

--=20
  Alexander

--Sig_/qJTYF0lfGk=2lceJpB9SX+u
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iQEcBAEBCAAGBQJLi5thAAoJEElrwznyooJbtbUH/0LWe+M/1TyLJ/vuv1DHFEb5
p0n9VTYe6uXTjdDcFxd1pp8zitKybQ2n9366u2xPIQBP8Z47jPrpzghyt+ut/yZ5
EXgv2NlFwJTSI1nRpsN805I4ojX5RBlHwBF0na/tyEaOg//ta4+2bWSnwzPp2OQp
KjeiS+sK3pjqHQT3VlH6w06VYUTAN1g8WRjOkzJ/m6DPfEKwkseqfanFuMl3fMbQ
pRvv9cXthmfBzGPG7YvpClXBi75WT2IO3BKtaVFtO3k5W6QX1d3jRaCwIteXzo6z
I7l4cd5Luf1LZwlcBFd5+utt357IMTKQbHd+0qKGVRMUkq0SAQPIRvCZotYXcbc=
=qGaI
-----END PGP SIGNATURE-----

--Sig_/qJTYF0lfGk=2lceJpB9SX+u--
