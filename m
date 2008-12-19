Return-Path: <linux-kernel-owner+w=401wt.eu-S1753918AbYLSXM1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753918AbYLSXM1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Dec 2008 18:12:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751918AbYLSXMQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Dec 2008 18:12:16 -0500
Received: from 69-30-77-85.dq1sn.easystreet.com ([69.30.77.85]:56801 "EHLO
	camus.anholt.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751932AbYLSXMP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Dec 2008 18:12:15 -0500
Subject: Re: [PATCH 1/3] drivers/gpu/drm: Move a dereference below a NULL
	test
From: Eric Anholt <eric@anholt.net>
To: Dave Airlie <airlied@gmail.com>
Cc: Julia Lawall <julia@diku.dk>, airlied@linux.ie,
       dri-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
In-Reply-To: <21d7e9970812191435g645c03ebqdcd53930d52f4830@mail.gmail.com>
References: <Pine.LNX.4.64.0812191809490.11217@ask.diku.dk>
	 <21d7e9970812191435g645c03ebqdcd53930d52f4830@mail.gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-69O7gJtWz/dXoLDBejlx"
Date: Fri, 19 Dec 2008 15:12:08 -0800
Message-Id: <1229728328.6544.10.camel@gaiman.anholt.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-69O7gJtWz/dXoLDBejlx
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sat, 2008-12-20 at 08:35 +1000, Dave Airlie wrote:
> On Sat, Dec 20, 2008 at 3:10 AM, Julia Lawall <julia@diku.dk> wrote:
> > From: Julia Lawall <julia@diku.dk>
> >
> > If the NULL test is necessary, then the dereference should be moved bel=
ow
> > the NULL test.
> >
> > The semantic patch that makes this change is as follows:
> > (http://www.emn.fr/x-info/coccinelle/).  The result has been modified t=
o
> > move the initialization of driver down closer to where it is used.
> >
> > // <smpl>
> > @@
> > type T;
> > expression E;
> > identifier i,fld;
> > statement S;
> > @@
> >
> > - T i =3D E->fld;
> > + T i;
> >  ... when !=3D E
> >      when !=3D i
> >  if (E =3D=3D NULL) S
> > + i =3D E->fld;
> > // </smpl>
> >
> > Signed-off-by: Julia Lawall <julia@diku.dk>
> >
> > ---
> >  drivers/gpu/drm/drm_drv.c |    7 ++++---
> >  1 file changed, 4 insertions(+), 3 deletions(-)
> >
> > diff --git a/drivers/gpu/drm/drm_drv.c b/drivers/gpu/drm/drm_drv.c
> > index 0b9f316..4bdfc98 100644
> > --- a/drivers/gpu/drm/drm_drv.c
> > +++ b/drivers/gpu/drm/drm_drv.c
> > @@ -297,7 +297,7 @@ EXPORT_SYMBOL(drm_init);
> >  */
> >  static void drm_cleanup(struct drm_device * dev)
> >  {
> > -       struct drm_driver *driver =3D dev->driver;
> > +       struct drm_driver *driver;
> >
> >        DRM_DEBUG("\n");
> >
> > @@ -324,8 +324,9 @@ static void drm_cleanup(struct drm_device * dev)
> >                dev->agp =3D NULL;
> >        }
> >
> > -       if (dev->driver->unload)
> > -               dev->driver->unload(dev);
> > +       driver =3D dev->driver;
> > +       if (driver->unload)
> > +               driver->unload(dev);
>=20
> Huh?
>=20
> The original test is to check it dev->driver->unload exists, not it
> dev->driver exists.
>=20
> I think your test  parameters are wrong.

No, it was valid, but I think the better patch is:

=46rom 1e0a24cfe75a328db5a50dbcdaaf0eb461638b6b Mon Sep 17 00:00:00 2001
From: Eric Anholt <eric@anholt.net>
Date: Fri, 19 Dec 2008 15:07:11 -0800
Subject: [PATCH] drm: Avoid use-before-null-test on dev in drm_cleanup().

Signed-off-by: Eric Anholt <eric@anholt.net>

---
 drivers/gpu/drm/drm_drv.c |    4 +---
 1 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/drm_drv.c b/drivers/gpu/drm/drm_drv.c
index 373e3de..febb517 100644
--- a/drivers/gpu/drm/drm_drv.c
+++ b/drivers/gpu/drm/drm_drv.c
@@ -294,8 +294,6 @@ EXPORT_SYMBOL(drm_init);
  */
 static void drm_cleanup(struct drm_device * dev)
 {
-	struct drm_driver *driver =3D dev->driver;
-
 	DRM_DEBUG("\n");
=20
 	if (!dev) {
@@ -330,7 +328,7 @@ static void drm_cleanup(struct drm_device * dev)
 	if (drm_core_check_feature(dev, DRIVER_MODESET))
 		drm_put_minor(&dev->control);
=20
-	if (driver->driver_features & DRIVER_GEM)
+	if (dev->driver->driver_features & DRIVER_GEM)
 		drm_gem_destroy(dev);
=20
 	drm_put_minor(&dev->primary);
--=20
1.5.6.5


--=20
Eric Anholt
eric@anholt.net                         eric.anholt@intel.com



--=-69O7gJtWz/dXoLDBejlx
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAklMKkgACgkQHUdvYGzw6vfw+wCeOVJwgxzuIBjBSl0/bOukYJqU
JtsAn3EASD0ktRjVZtrJ0LdyYuPqiJTO
=AiNu
-----END PGP SIGNATURE-----

--=-69O7gJtWz/dXoLDBejlx--

