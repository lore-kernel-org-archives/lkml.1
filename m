Return-Path: <linux-kernel-owner+w=401wt.eu-S1423152AbXBUVhD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423152AbXBUVhD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Feb 2007 16:37:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423173AbXBUVhC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Feb 2007 16:37:02 -0500
Received: from proxima.lp0.eu ([85.158.45.36]:39208 "EHLO proxima.lp0.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423152AbXBUVhA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Feb 2007 16:37:00 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=exim; d=thunder.lp0.eu;
	h=Received:Message-ID:Date:From:User-Agent:MIME-Version:To:CC:Subject:X-Enigmail-Version:OpenPGP:Content-Type:Sender:Reply-To;
	b=xglYGHBPq4FUPJURzUURZIAGmmKR9cTyFFQMYLXiY2fWcbxNrd44ulxEh1G0OplHQ/LEBUou6gqrr4RgqJBMqa1m8NdlGS1p2BAGsuns6enYqn26VBxJeXjNUodQbSmx;
Message-ID: <45DCBB4E.8000502@simon.arlott.org.uk>
Date: Wed, 21 Feb 2007 21:36:14 +0000
From: Simon Arlott <simon@arlott.org>
User-Agent: Thunderbird 1.5.0.5 (X11/20060819)
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
CC: Duncan Sands <duncan.sands@math.u-psud.fr>
Subject: [PATCH 1/2] usbatm: Increment module refcount when atm device is
 opened.
X-Enigmail-Version: 0.94.1.2
OpenPGP: id=89C93563
Content-Type: multipart/signed; micalg=pgp-sha512;
 protocol="application/pgp-signature";
 boundary="------------enig239850BD7759ACE811668F9A"
Reply-To: Simon Arlott <404ba30d933f248a9b1hjz8z0007fglh@thunder.lp0.eu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig239850BD7759ACE811668F9A
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Increment usbatm driver module refcount when atm device is opened, this p=
revents the driver for the device being removed if it's in use. (I contin=
ue to allow removing the driver without unplugging the device if it's not=
 being used). No problems occur if the atm device is open while the devic=
e is unplugged.

Signed-off-by: Simon Arlott <simon@fire.lp0.eu>
---
 drivers/usb/atm/cxacru.c     |    1 +
 drivers/usb/atm/speedtch.c   |    1 +
 drivers/usb/atm/ueagle-atm.c |    1 +
 drivers/usb/atm/usbatm.c     |   14 ++++++++++++--
 drivers/usb/atm/usbatm.h     |    1 +
 drivers/usb/atm/xusbatm.c    |    1 +
 6 files changed, 17 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/atm/cxacru.c b/drivers/usb/atm/cxacru.c
index 1049e34..424b0f4 100644
--- a/drivers/usb/atm/cxacru.c
+++ b/drivers/usb/atm/cxacru.c
@@ -980,6 +980,7 @@ static const struct usb_device_id cxacru
 MODULE_DEVICE_TABLE(usb, cxacru_usb_ids);
=20
 static struct usbatm_driver cxacru_driver =3D {
+	.owner		=3D THIS_MODULE,
 	.driver_name	=3D cxacru_driver_name,
 	.bind		=3D cxacru_bind,
 	.heavy_init	=3D cxacru_heavy_init,
diff --git a/drivers/usb/atm/speedtch.c b/drivers/usb/atm/speedtch.c
index 638b800..5d6a0eb 100644
--- a/drivers/usb/atm/speedtch.c
+++ b/drivers/usb/atm/speedtch.c
@@ -924,6 +924,7 @@ static void speedtch_unbind(struct usbat
 ***********/
=20
 static struct usbatm_driver speedtch_usbatm_driver =3D {
+	.owner		=3D THIS_MODULE,
 	.driver_name	=3D speedtch_driver_name,
 	.bind		=3D speedtch_bind,
 	.heavy_init	=3D speedtch_heavy_init,
diff --git a/drivers/usb/atm/ueagle-atm.c b/drivers/usb/atm/ueagle-atm.c
index dae4ef1..e32c93f 100644
--- a/drivers/usb/atm/ueagle-atm.c
+++ b/drivers/usb/atm/ueagle-atm.c
@@ -1735,6 +1735,7 @@ static void uea_unbind(struct usbatm_dat
 }
=20
 static struct usbatm_driver uea_usbatm_driver =3D {
+	.owner =3D THIS_MODULE,
 	.driver_name =3D "ueagle-atm",
 	.bind =3D uea_bind,
 	.atm_start =3D uea_atm_open,
diff --git a/drivers/usb/atm/usbatm.c b/drivers/usb/atm/usbatm.c
index d91ed11..83cea01 100644
--- a/drivers/usb/atm/usbatm.c
+++ b/drivers/usb/atm/usbatm.c
@@ -828,6 +828,12 @@ static int usbatm_atm_open(struct atm_vc
=20
 	mutex_lock(&instance->serialize);	/* vs self, usbatm_atm_close, usbatm_=
usb_disconnect */
=20
+ 	if (!try_module_get(instance->driver->owner)) {
+ 		atm_dbg(instance, "%s: try_module_get failed\n", __func__);
+ 		ret =3D -ENODEV;
+ 		goto fail;
+ 	}
+
 	if (instance->disconnected) {
 		atm_dbg(instance, "%s: disconnected!\n", __func__);
 		ret =3D -ENODEV;
@@ -854,7 +860,7 @@ static int usbatm_atm_open(struct atm_vc
 	if (!new->sarb) {
 		atm_err(instance, "%s: no memory for SAR buffer!\n", __func__);
 		ret =3D -ENOMEM;
-		goto fail;
+		goto fail_free;
 	}
=20
 	vcc->dev_data =3D new;
@@ -876,8 +882,10 @@ static int usbatm_atm_open(struct atm_vc
=20
 	return 0;
=20
-fail:
+fail_free:
 	kfree(new);
+fail:
+	module_put(instance->driver->owner);
 	mutex_unlock(&instance->serialize);
 	return ret;
 }
@@ -922,6 +930,8 @@ static void usbatm_atm_close(struct atm_
 	clear_bit(ATM_VF_PARTIAL, &vcc->flags);
 	clear_bit(ATM_VF_ADDR, &vcc->flags);
=20
+	module_put(instance->driver->owner);
+
 	mutex_unlock(&instance->serialize);
=20
 	atm_dbg(instance, "%s successful\n", __func__);
diff --git a/drivers/usb/atm/usbatm.h b/drivers/usb/atm/usbatm.h
index d3c0ee4..4a172a9 100644
--- a/drivers/usb/atm/usbatm.h
+++ b/drivers/usb/atm/usbatm.h
@@ -103,6 +103,7 @@ struct usbatm_data;
 */
=20
 struct usbatm_driver {
+	struct module *owner;
 	const char *driver_name;
=20
 	/* init device ... can sleep, or cause probe() failure */
diff --git a/drivers/usb/atm/xusbatm.c b/drivers/usb/atm/xusbatm.c
index 70125c6..8c425d7 100644
--- a/drivers/usb/atm/xusbatm.c
+++ b/drivers/usb/atm/xusbatm.c
@@ -205,6 +205,7 @@ static int __init xusbatm_init(void)
 		xusbatm_usb_ids[i].idVendor	=3D vendor[i];
 		xusbatm_usb_ids[i].idProduct	=3D product[i];
=20
+		xusbatm_drivers[i].owner	=3D THIS_MODULE;
 		xusbatm_drivers[i].driver_name	=3D xusbatm_driver_name;
 		xusbatm_drivers[i].bind		=3D xusbatm_bind;
 		xusbatm_drivers[i].unbind	=3D xusbatm_unbind;
--=20
1.4.3.1


--=20
Simon Arlott


--------------enig239850BD7759ACE811668F9A
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.2.2 (GNU/Linux)

iQIVAwUBRdy7TqRtx1WjQ8ihAQpgdA//WPzBOt/h8vh2WdhXY30SpXoMTNkTg5vS
IidE3axmvH9tbBY6E6pyLH+6sQqUKJwbnIEy+Mo6ixaO7QZf/WGRCGVX+JeGJq4M
gsvVsouhXaMSlslctzBiHaulpzXlqYH1v8S88hD83aQFU/QPweP3KNXvLWu3+beW
+GYQm76ka3acIgkABjl4IHa0SNQOjEouzozIdkexXJXJb9JDWntcTCe+A5uRckix
6efW0Rd1LJ/5udrxgA5+kxR7DVPoiapnoh8+GT+dgFaVUFGbXkIB5TOFjievRvN8
ju/OWRdFipfLYlgS7+lpqoCNlvOvGUq95fpeR9fBdwtMvx9a0r5rHULyVlMfYPVg
8LdCssAD5iE0iTFIVxgl8p0010hjJv3KCDj2hwGAf9Xi1uQDkIIhCD9N+ILaDK2V
DJaJjttBcqT60IkmryTsIXApJ/xfTnE+voyTRo3010r9exI+DjhMUncibgCSN4L1
+Fc6vMeiXuOguu2oJ8Gwpo37GPWWeLF51JQ3Dtgn/0xDZw+mNwQiZGA1Mc1/Fw32
nnfyKgLaL6NJd7N9VCtE7bW72w8ik4UbbSM9rm7PiUw5N/bWhsuhX2gDCytLDGke
NaJ4Hi8opKB3g+fTXb3D77NwpAikq7iG6tDX1wFtGNWkQaDIcOcDjBjD87VWn6X3
RCAcTHUxd88=
=XbCI
-----END PGP SIGNATURE-----

--------------enig239850BD7759ACE811668F9A--
