Return-Path: <linux-kernel-owner+w=401wt.eu-S1758558AbZLOEBM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758558AbZLOEBM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Dec 2009 23:01:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755567AbZLOEBL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Dec 2009 23:01:11 -0500
Received: from mail-yw0-f182.google.com ([209.85.211.182]:62854 "EHLO
	mail-yw0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754776AbZLOEBJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Dec 2009 23:01:09 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer;
        b=cPb+Eq/U/UBE46faU5s+nd4QWLNwTDuDt1Igrt/1RaKOsT6G+hPRvA0sB/mMUy8sYN
         bIuDY+WCtJx3wss93dZq6GRVCGlRlTUCcYylAw6PCcmear7VrK+QruFYAgRB2gik9yQy
         QY3zVB3wUn7cs7D+F0cHGyfVEsioIv98QuTjo=
Subject: Re: [GIT PATCH] USB patches for 2.6.33-git
From: Russ Dill <russ.dill@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Greg KH <greg@kroah.com>, Alan Stern <stern@rowland.harvard.edu>,
       Greg KH <gregkh@suse.de>, Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-usb@vger.kernel.org
In-Reply-To: <g383sjib9r8nlmw354UYAxe124vaj_firegpg@mail.gmail.com>
References: <g383sjib9r8nlmw354UYAxe124vaj_firegpg@mail.gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-GqLwbDrRby9TzssoqDU+"
Date: Mon, 14 Dec 2009 21:00:52 -0700
Message-ID: <1260849652.28808.1.camel@russ-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-GqLwbDrRby9TzssoqDU+
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2009-12-14 at 20:17 -0700, russ.dill@gmail.com wrote:
>=20
> On Mon, Dec 14, 2009 at 8:09 PM, Linus Torvalds <torvalds@linux-foundatio=
n.org> wrote:
> >
> >
> > On Mon, 14 Dec 2009, Linus Torvalds wrote:
> >>
> >> I'll double-check by reverting it from current -tip, but if you don't =
hear
> >> anything different from me, you can assume that that double-check
> >> succeeded and confirms that that commit really is the cause of my prin=
ter
> >> no longer working.
> >
> > Confirmed.
> >
> > With that commit reverted, everything works fine again. So it's definit=
ely
> > a2582bd478c13c574d4c16ef1209d333f2a25935, although I have no idea _why_=
 it
> > causes problems.
> >
> > One thing I note is that it literally changed semantics, as per the
> > comment in there. It used to be:
> >
> >        This walks the driver device list and returns a pointer to the i=
nterface
> >        with the matching minor.
> >
> > and after that it is
> >
> >        This walks the bus device list and returns a pointer to the inte=
rface
> >        with the matching minor.
> >
> > Notice the "driver device list" -> "bus device list" change.
> >
> > Also notice that the minor number of my 'lp0' device is zero, so I coul=
d
> > easily imagine that some device without a driver at all or whatever wil=
l
> > have a zero there, and then it would return the wrong device entirely.
> >
> > So I really think that commit is very suspect. Not matching against the
> > driver that we passed in looks like some total screwup.
> >
> > But I don't know the code or the use. I do know that reverting it fixes
> > it.
>=20
> Yes, you are right. Sorry for breaking your printer. There is both USB_MA=
JOR and USB_DEVICE_MAJOR. I haven't investigated it in great detail yet, bu=
t that seems likely to be the issue. I'll clean up the patch. And yes, it s=
hould definitely not be going into stable yet. Revert for now and I'll resu=
bmit.


Here is a cleaned up patch that matches against minor and driver, not
just minor. I'll haven't test it yet, but will get a chance to tomorrow.

=46rom 4441c99c80d8298a99b6f2fbd4ece9d3cfe7fd4d Mon Sep 17 00:00:00 2001
From: Russ Dill <Russ.Dill@gmail.com>
Date: Wed, 18 Nov 2009 10:31:27 -0700
Subject: [PATCH] Close usb_find_interface race v2

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
 drivers/usb/core/usb.c |   28 +++++++++++++++-------------
 1 files changed, 15 insertions(+), 13 deletions(-)

diff --git a/drivers/usb/core/usb.c b/drivers/usb/core/usb.c
index b1b85ab..2091fac 100644
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
@@ -144,10 +144,9 @@ static int __find_interface(struct device *dev, void *=
data)
 		return 0;
=20
 	intf =3D to_usb_interface(dev);
-	if (intf->minor !=3D -1 && intf->minor =3D=3D arg->minor) {
-		arg->interface =3D intf;
+	if (intf->minor !=3D -1 && intf->minor =3D=3D arg->minor &&
+		dev->driver =3D=3D arg->drv)
 		return 1;
-	}
 	return 0;
 }
=20
@@ -156,21 +155,24 @@ static int __find_interface(struct device *dev, void =
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



--=-GqLwbDrRby9TzssoqDU+
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAksnCfQACgkQfNRrxBinbdtdNwCaAwjS+3hR9CrBTQS7pf3BTTKs
mfMAniwq/RfYoKoxrwPYeuIHHYKyamzL
=1ogb
-----END PGP SIGNATURE-----

--=-GqLwbDrRby9TzssoqDU+--

