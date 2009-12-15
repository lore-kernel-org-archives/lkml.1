Return-Path: <linux-kernel-owner+w=401wt.eu-S1756440AbZLOEpw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756440AbZLOEpw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Dec 2009 23:45:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756299AbZLOEpv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Dec 2009 23:45:51 -0500
Received: from mail-gx0-f211.google.com ([209.85.217.211]:59925 "EHLO
	mail-gx0-f211.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755252AbZLOEpu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Dec 2009 23:45:50 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer;
        b=mYjdjlweYSoUPNK6TCiL6smfJtdhPSAFzyqH5Ye2pXAdb3xB+UR+y45xZb5/fazVy2
         7+8mw93GgIVSlei00VlrOe4wCx3/IHNdgBBOwwobAltHWwGIELaHAonPjALPCWDg/iJZ
         z7F0r4y9JMBwPoTeLBzUk/09kiMp/gJpFcf40=
Subject: Re: [GIT PATCH] USB patches for 2.6.33-git
From: Russ Dill <russ.dill@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Greg KH <greg@kroah.com>, Alan Stern <stern@rowland.harvard.edu>,
       Greg KH <gregkh@suse.de>, Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-usb@vger.kernel.org
In-Reply-To: <alpine.LFD.2.00.0912142031170.14385@localhost.localdomain>
References: <g383sjib9r8nlmw354UYAxe124vaj_firegpg@mail.gmail.com>
	 <1260849652.28808.1.camel@russ-laptop>
	 <alpine.LFD.2.00.0912142031170.14385@localhost.localdomain>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-vtpnKbHsLFrNLKj7DtFL"
Date: Mon, 14 Dec 2009 21:45:35 -0700
Message-ID: <1260852335.1886.0.camel@russ-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-vtpnKbHsLFrNLKj7DtFL
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2009-12-14 at 20:36 -0800, Linus Torvalds wrote:
>=20
> On Mon, 14 Dec 2009, Russ Dill wrote:
> > @@ -144,10 +144,9 @@ static int __find_interface(struct device *dev, vo=
id *data)
> >  		return 0;
> > =20
> >  	intf =3D to_usb_interface(dev);
> > -	if (intf->minor !=3D -1 && intf->minor =3D=3D arg->minor) {
> > -		arg->interface =3D intf;
> > +	if (intf->minor !=3D -1 && intf->minor =3D=3D arg->minor &&
> > +		dev->driver =3D=3D arg->drv)
> >  		return 1;
> > -	}
> >  	return 0;
> >  }
>=20
> Btw, can we please write this somewhat more readably, and just do
>=20
> 	if (dev->driver !=3D arg->drv)
> 		return 0;
> 	intf =3D to_usb_interface(dev);
> 	return intf->minor =3D=3D arg->minor;
>=20
> because the whole "intf->minor !=3D -1" thing is pointless (we're going t=
o=20
> test it against 'arg->minor', and if that is -1, then the caller damn wel=
l=20
> gets what he deserves anyway).
>=20
> This way there are no complex multi-line crud expressions, and it all=20
> looks simpler. No?

Yup.

=46rom 41e394bc38b9d5224cc5e8013f45e769910a114e Mon Sep 17 00:00:00 2001
From: Russ Dill <Russ.Dill@gmail.com>
Date: Wed, 18 Nov 2009 10:31:27 -0700
Subject: [PATCH] Close usb_find_interface race v3

USB drivers that create character devices call usb_register_dev in their
probe function. This associates the usb_interface device with that minor
number and creates the character device and announces it to the world.
However, the driver's probe function is called before the new
usb_interface is added to the driver's klist_devices.

This is a problem because userspace will respond to the character device
creation announcement by opening the character device. The driver's open
function will the call usb_find_interface to find the usb_interface
associated with that minor number. usb_find_interface will walk the
driver's list of devices and find the usb_interface with the matching
minor number.

Because the announcement happens before the usb_interface is added to the
driver's klist_devices, a race condition exists. A straightforward fix
is to walk the list of devices on usb_bus_type instead since the device
is added to that list before the announcement occurs.

bus_find_device calls get_device to bump the reference count on the found
device. It is arguable that the reference count should be dropped by the
caller of usb_find_interface instead of usb_find_interface, however,
the current users of usb_find_interface do not expect this.

The original version of this patch only matched against minor number
instead of driver and minor number. This version matches against both.

Signed-off-by: Russ Dill <Russ.Dill@gmail.com>
---
 drivers/usb/core/usb.c |   31 ++++++++++++++++---------------
 1 files changed, 16 insertions(+), 15 deletions(-)

diff --git a/drivers/usb/core/usb.c b/drivers/usb/core/usb.c
index b1b85ab..52e5e31 100644
--- a/drivers/usb/core/usb.c
+++ b/drivers/usb/core/usb.c
@@ -132,7 +132,7 @@ EXPORT_SYMBOL_GPL(usb_altnum_to_altsetting);
=20
 struct find_interface_arg {
 	int minor;
-	struct usb_interface *interface;
+	struct device_driver *drv;
 };
=20
 static int __find_interface(struct device *dev, void *data)
@@ -143,12 +143,10 @@ static int __find_interface(struct device *dev, void =
*data)
 	if (!is_usb_interface(dev))
 		return 0;
=20
+	if (dev->driver !=3D arg->drv)
+		return 0;
 	intf =3D to_usb_interface(dev);
-	if (intf->minor !=3D -1 && intf->minor =3D=3D arg->minor) {
-		arg->interface =3D intf;
-		return 1;
-	}
-	return 0;
+	return intf->minor =3D=3D arg->minor;
 }
=20
 /**
@@ -156,21 +154,24 @@ static int __find_interface(struct device *dev, void =
*data)
  * @drv: the driver whose current configuration is considered
  * @minor: the minor number of the desired device
  *
- * This walks the driver device list and returns a pointer to the interfac=
e
- * with the matching minor.  Note, this only works for devices that share =
the
- * USB major number.
+ * This walks the bus device list and returns a pointer to the interface
+ * with the matching minor and driver.  Note, this only works for devices
+ * that share the USB major number.
  */
 struct usb_interface *usb_find_interface(struct usb_driver *drv, int minor=
)
 {
 	struct find_interface_arg argb;
-	int retval;
+	struct device *dev;
=20
 	argb.minor =3D minor;
-	argb.interface =3D NULL;
-	/* eat the error, it will be in argb.interface */
-	retval =3D driver_for_each_device(&drv->drvwrap.driver, NULL, &argb,
-					__find_interface);
-	return argb.interface;
+	argb.drv =3D &drv->drvwrap.driver;
+
+	dev =3D bus_find_device(&usb_bus_type, NULL, &argb, __find_interface);
+
+	/* Drop reference count from bus_find_device */
+	put_device(dev);
+
+	return dev ? to_usb_interface(dev) : NULL;
 }
 EXPORT_SYMBOL_GPL(usb_find_interface);
=20
--=20
1.6.5





--=-vtpnKbHsLFrNLKj7DtFL
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAksnFGkACgkQfNRrxBinbdv9vQCgmLGSWoROcE5sAUNuxjb41S9f
LzYAn26/tc97Lcjj6S+Amjga72IxgBq0
=+s8d
-----END PGP SIGNATURE-----

--=-vtpnKbHsLFrNLKj7DtFL--

