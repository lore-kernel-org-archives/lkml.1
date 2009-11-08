Return-Path: <linux-kernel-owner+w=401wt.eu-S1755290AbZKHVYm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755290AbZKHVYm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Nov 2009 16:24:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755226AbZKHVYl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Nov 2009 16:24:41 -0500
Received: from smtp-out113.alice.it ([85.37.17.113]:3898 "EHLO
	smtp-out113.alice.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751600AbZKHVYk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Nov 2009 16:24:40 -0500
Date: Sun, 8 Nov 2009 22:24:34 +0100
From: Antonio Ospite <ospite@studenti.unina.it>
To: linux-arm-kernel@lists.infradead.org, openezx-devel@lists.openezx.org,
       linux-kernel@vger.kernel.org
Cc: Samuel Ortiz <sameo@linux.intel.com>, Daniel Ribeiro <drwyrm@gmail.com>,
       Mike Rapoport <mike@compulab.co.il>,
       Uwe =?ISO-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>,
       Ben Dooks <ben-linux@fluff.org>,
       Russell King - ARM Linux <linux@arm.linux.org.uk>
Subject: Re: Using statically allocated memory for platform_data.
Message-Id: <20091108222434.284cd78f.ospite@studenti.unina.it>
In-Reply-To: <20091102112316.16163f6a.ospite@studenti.unina.it>
References: <20091102112316.16163f6a.ospite@studenti.unina.it>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.3; i686-pc-linux-gnu)
X-Face: z*RaLf`X<@C75u6Ig9}{oW$H;1_\2t5)({*|jhM<pyWR#k60!#=#>/Vb;]yA5<GWI5`6u&+
 ;6b'@y|8w"wB;4/e!7wYYrcqdJFY,~%Gk_4]cq$Ei/7<j&N3ah(m`ku?pX.&+~:_/wC~dwn^)MizBG !pE^+iDQQ1yC6^,)YDKkxDd!T>\I~93>J<_`<4)A{':UrE
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Sun__8_Nov_2009_22_24_34_+0100_ASPt12wg.3NZATwO"
X-OriginalArrivalTime: 08 Nov 2009 21:24:42.0558 (UTC) FILETIME=[E2E86DE0:01CA60B9]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Sun__8_Nov_2009_22_24_34_+0100_ASPt12wg.3NZATwO
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, 2 Nov 2009 11:23:16 +0100
Antonio Ospite <ospite@studenti.unina.it> wrote:

> Hi,
>=20
> I noted that in some mfd drivers (drivers/mfd/ezx-pcap.c and
> drivers/mfd/da903x.c) there is code like this:
>=20
> static int __devinit pcap_add_subdev(struct pcap_chip *pcap,
>                                      struct pcap_subdev *subdev)
> {
>         struct platform_device *pdev;
>=20
>         pdev =3D platform_device_alloc(subdev->name, subdev->id);
>         pdev->dev.parent =3D &pcap->spi->dev;
>         pdev->dev.platform_data =3D subdev->platform_data;
>=20
>         return platform_device_add(pdev);
> }
>=20
> Note the _direct_assignment_ of platform data; then in board init code
> there are often global struct pointers passed as subdev platform data,
> see arch/arm/mach-pxa/em-x270.c::em_x270_da9030_subdevs for instance.
>=20
> In these cases, whenever the subdev platform device is unregistered,
> the call to platform_device_release() tries to kfree the platform data,
> and being it statically allocated memory this triggers a bug from SLAB:
> 	kernel BUG at mm/slab.c:521!
> In my case this prevented proper device poweroff.
>=20
> The question: should these mfd drivers use platform_device_add_data()
> which allocates dynamic memory for *a copy* of platform data? Is this
> simple solution acceptable even if there will be more memory used?
> Or should we setup platform_data in dynamic memory from the beginning
> in board init code? (which would be way less pretty IMHO).
>=20

Just for reference, in our local repository I am _temporarily_ working
around the bug with a change like the following, even if I am leaking
some memory. Any comments?

diff --git a/drivers/mfd/ezx-pcap.c b/drivers/mfd/ezx-pcap.c
index df405af..e4e999b 100644
--- a/drivers/mfd/ezx-pcap.c
+++ b/drivers/mfd/ezx-pcap.c
@@ -379,12 +379,17 @@ static int pcap_remove_subdev(struct device *dev, voi=
d *unused)
        return 0;
 }

+static void pcap_subdev_release(struct device *dev)
+{
+}
+
 static int __devinit pcap_add_subdev(struct pcap_chip *pcap,
                                                struct pcap_subdev *subdev)
 {
        struct platform_device *pdev;

        pdev =3D platform_device_alloc(subdev->name, subdev->id);
+       pdev->dev.release =3D pcap_subdev_release;
        pdev->dev.parent =3D &pcap->spi->dev;
        pdev->dev.platform_data =3D subdev->platform_data;

--=20
Antonio Ospite
http://ao2.it

PGP public key ID: 0x4553B001

A: Because it messes up the order in which people normally read text.
   See http://en.wikipedia.org/wiki/Posting_style
Q: Why is top-posting such a bad thing?
A: Top-posting.
Q: What is the most annoying thing in e-mail?

--Signature=_Sun__8_Nov_2009_22_24_34_+0100_ASPt12wg.3NZATwO
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkr3NxIACgkQ5xr2akVTsAGRhwCfTLtvN3g74xXMumvgUgSrxaZk
/A4AoJK/BxYNCLfQhOak4bs8qqk+5axR
=MUgY
-----END PGP SIGNATURE-----

--Signature=_Sun__8_Nov_2009_22_24_34_+0100_ASPt12wg.3NZATwO--
