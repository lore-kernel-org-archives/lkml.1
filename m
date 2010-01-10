Return-Path: <linux-kernel-owner+w=401wt.eu-S1753881Ab0AJSLV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753881Ab0AJSLV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jan 2010 13:11:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753585Ab0AJSLV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Jan 2010 13:11:21 -0500
Received: from outpost1.zedat.fu-berlin.de ([130.133.4.66]:40773 "EHLO
	outpost1.zedat.fu-berlin.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752093Ab0AJSLU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jan 2010 13:11:20 -0500
Date: Sun, 10 Jan 2010 19:11:12 +0100
From: Benjamin Valentin <benpicco@zedat.fu-berlin.de>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drivers/input/joystick/xpad.c: Add rumble support for
 original xbox controller
Message-ID: <20100110191112.5c66dc94@rechenknecht2k7>
In-Reply-To: <20100110075615.GC16057@core.coreip.homeip.net>
References: <20100108033215.447c814e@rechenknecht2k7>
	<20100108075054.GA3696@core.coreip.homeip.net>
	<20100108112610.0b78785b@piBook>
	<20100110075615.GC16057@core.coreip.homeip.net>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.18.3; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/ezAc50RMWWoe6Rqnu+bHGAe"; protocol="application/pgp-signature"
X-Originating-IP: 87.123.114.39
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/ezAc50RMWWoe6Rqnu+bHGAe
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Sat, 9 Jan 2010 23:56:16 -0800
Dmitry Torokhov <dmitry.torokhov@gmail.com> wrote:

> > --- /usr/src/linux-source-2.6.33/drivers/input/joystick/xpad.c
> > 2010-01-08 02:56:59.365851076 +0100 +++ xpad.c	2010-01-08
> > 03:13:38.477835651 +0100 @@ -505,7 +505,7 @@
> >  	struct usb_endpoint_descriptor *ep_irq_out;
> >  	int error =3D -ENOMEM;
> > =20
> > -	if (xpad->xtype !=3D XTYPE_XBOX360)
> > +	if (xpad->xtype !=3D XTYPE_XBOX360 && xpad->xtype !=3D
> > XTYPE_XBOX) return 0;
> > =20
> >  	xpad->odata =3D usb_buffer_alloc(xpad->udev, XPAD_PKT_LEN,
> > @@ -535,13 +535,13 @@
> > =20
> >  static void xpad_stop_output(struct usb_xpad *xpad)
> >  {
> > -	if (xpad->xtype =3D=3D XTYPE_XBOX360)
> > +	if (xpad->xtype =3D=3D XTYPE_XBOX360 || xpad->xtype !=3D
> > XTYPE_XBOX)
>=20
> This should cretainly be "... || xpad->xtype =3D=3D XTYPE_XBOX)", I'll fix
> it up locally.

Thank you, this made me discover another bug that eventually leads to a
kernel oops when the device is unplugged while an effect is playing
(or the effect is somehow else interrupted).
This should be fixed by taking the mutex when modifying xpad->odata as
well as checking whether it has been freed before writing to it.

Signed-off-by: Benjamin Valentin <benpicco@zedat.fu-berlin.de>

diff --git a/drivers/input/joystick/xpad.c b/drivers/input/joystick/xpad.c
--- a/drivers/input/joystick/xpad.c
+++ b/drivers/input/joystick/xpad.c
@@ -535,16 +535,24 @@
=20
 static void xpad_stop_output(struct usb_xpad *xpad)
 {
-	if (xpad->xtype =3D=3D XTYPE_XBOX360 || xpad->xtype !=3D XTYPE_XBOX)
-		usb_kill_urb(xpad->irq_out);
+	if (xpad->xtype !=3D XTYPE_XBOX360 || xpad->xtype !=3D XTYPE_XBOX)
+		return;
+	=09
+	mutex_lock(&xpad->odata_mutex);
+	usb_kill_urb(xpad->irq_out);
+	mutex_unlock(&xpad->odata_mutex);
 }
=20
 static void xpad_deinit_output(struct usb_xpad *xpad)
 {
-	if (xpad->xtype =3D=3D XTYPE_XBOX360 || xpad->xtype !=3D XTYPE_XBOX) {
+	if (xpad->xtype =3D=3D XTYPE_XBOX360 || xpad->xtype =3D=3D XTYPE_XBOX) {
+		mutex_lock(&xpad->odata_mutex);
+	=09
 		usb_free_urb(xpad->irq_out);
-		usb_buffer_free(xpad->udev, XPAD_PKT_LEN,
+		usb_buffer_free(xpad->udev, XPAD_PKT_LEN,=20
 				xpad->odata, xpad->odata_dma);
+			=09
+		mutex_unlock(&xpad->odata_mutex);	=09
 	}
 }
 #else
@@ -555,32 +563,46 @@
=20
 #ifdef CONFIG_JOYSTICK_XPAD_FF
 static int xpad_send_rumble(struct usb_xpad *xpad, unsigned char left, uns=
igned char right) {
-	switch(xpad->xtype) {
-		case XTYPE_XBOX:
-			xpad->odata[0] =3D 0x00;
-			xpad->odata[1] =3D 0x06;
-			xpad->odata[2] =3D 0x00;
-			xpad->odata[3] =3D left;  // left actuator
-			xpad->odata[4] =3D 0x00;
-			xpad->odata[5] =3D right; // right actuator
-			xpad->irq_out->transfer_buffer_length =3D 6;
-			return usb_submit_urb(xpad->irq_out, GFP_KERNEL);
-		case XTYPE_XBOX360:
-			xpad->odata[0] =3D 0x00;
-			xpad->odata[1] =3D 0x08;
-			xpad->odata[2] =3D 0x00;
-			xpad->odata[3] =3D left;  // left actuator?
-			xpad->odata[4] =3D right; // right actuator?
-			xpad->odata[5] =3D 0x00;
-			xpad->odata[6] =3D 0x00;
-			xpad->odata[7] =3D 0x00;
-			xpad->irq_out->transfer_buffer_length =3D 8;
-			return usb_submit_urb(xpad->irq_out, GFP_KERNEL);
-		default:
-			dbg("%s - rumble command sent to unsupported xpad type: %d",=20
-				__func__, xpad->xtype);
-			return 0;
+	int result =3D 0;
+=09
+	mutex_lock(&xpad->odata_mutex);=09
+	if(xpad->odata) {	=09
+		switch(xpad->xtype) {
+			case XTYPE_XBOX:
+				xpad->odata[0] =3D 0x00;
+				xpad->odata[1] =3D 0x06;
+				xpad->odata[2] =3D 0x00;
+				xpad->odata[3] =3D left;  // left actuator
+				xpad->odata[4] =3D 0x00;
+				xpad->odata[5] =3D right; // right actuator
+				xpad->irq_out->transfer_buffer_length =3D 6;
+				break;
+			case XTYPE_XBOX360:
+				xpad->odata[0] =3D 0x00;
+				xpad->odata[1] =3D 0x08;
+				xpad->odata[2] =3D 0x00;
+				xpad->odata[3] =3D left;  // left actuator?
+				xpad->odata[4] =3D right; // right actuator?
+				xpad->odata[5] =3D 0x00;
+				xpad->odata[6] =3D 0x00;
+				xpad->odata[7] =3D 0x00;
+				xpad->irq_out->transfer_buffer_length =3D 8;		=09
+				break;
+			default:
+				dbg("%s - rumble command sent to unsupported xpad type: %d",=20
+					__func__, xpad->xtype);
+				result =3D -1;
+			}
+		} else {
+			dbg("%s - xpad->odata already freed", __func__);
+			result =3D -1;
 		}
+	=09
+		if(result =3D=3D 0)
+			result =3D usb_submit_urb(xpad->irq_out, GFP_KERNEL);
+		=09
+		mutex_unlock(&xpad->odata_mutex);	=09
+		return result;
 }
=20
 static int xpad_play_effect(struct input_dev *dev, void *data, struct ff_e=
ffect *effect)


--Sig_/ezAc50RMWWoe6Rqnu+bHGAe
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAktKGEAACgkQg4D7JNscH9plkgCeMGrUedYwEfOX3KZ46tf5iJxD
wosAnjZBNyKaKfIqrZA7Ggx5GydZroY3
=bSjF
-----END PGP SIGNATURE-----

--Sig_/ezAc50RMWWoe6Rqnu+bHGAe--
