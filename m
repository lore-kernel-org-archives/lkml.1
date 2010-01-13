Return-Path: <linux-kernel-owner+w=401wt.eu-S1756446Ab0AMVbe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756446Ab0AMVbe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jan 2010 16:31:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756134Ab0AMVbd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jan 2010 16:31:33 -0500
Received: from outpost1.zedat.fu-berlin.de ([130.133.4.66]:50365 "EHLO
	outpost1.zedat.fu-berlin.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751809Ab0AMVbd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jan 2010 16:31:33 -0500
Date: Wed, 13 Jan 2010 22:31:19 +0100
From: Benjamin Valentin <benpicco@zedat.fu-berlin.de>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drivers/input/joystick/xpad.c: Add rumble support for
 original xbox controller
Message-ID: <20100113223119.56532356@rechenknecht2k7>
In-Reply-To: <20100110195641.GA27553@core.coreip.homeip.net>
References: <20100108033215.447c814e@rechenknecht2k7>
	<20100108075054.GA3696@core.coreip.homeip.net>
	<20100108112610.0b78785b@piBook>
	<20100110075615.GC16057@core.coreip.homeip.net>
	<20100110191112.5c66dc94@rechenknecht2k7>
	<20100110195641.GA27553@core.coreip.homeip.net>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.18.3; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/m8EEHk3j_5FnDqtM8Gl4gmi"; protocol="application/pgp-signature"
X-Originating-IP: 87.123.121.33
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/m8EEHk3j_5FnDqtM8Gl4gmi
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

To avoid confusion, I am resubmitting a cleaned up version of the patch
against 2.6.33-r4.
I have changed GFP_KERNEL to GFP_ATOMIC as you did in your tree [1],
this seems to clear the oops in Virtualbox when unplugging the device
while sending an effect.

[1]
http://git.kernel.org/gitweb.cgi?p=3Dlinux/kernel/git/dtor/input.git;a=3Dco=
mmit;h=3Ddd38d6889dc5dae2014d9eac72fae32f477f294e)

Signed-off-by: Benjamin Valentin <benpicco@zedat.fu-berlin.de>
--- a/drivers/input/joystick/xpad.c	2010-01-13 21:35:35.081651802 +0100
+++ b/drivers/input/joystick/xpad.c	2010-01-13 22:02:29.313757056 +0100
@@ -446,7 +446,7 @@ static void xpad_irq_in(struct urb *urb)
 	}
=20
 exit:
-	retval =3D usb_submit_urb (urb, GFP_ATOMIC);
+	retval =3D usb_submit_urb(urb, GFP_ATOMIC);
 	if (retval)
 		err ("%s - usb_submit_urb failed with result %d",
 		     __func__, retval);
@@ -505,7 +505,7 @@ static int xpad_init_output(struct usb_i
 	struct usb_endpoint_descriptor *ep_irq_out;
 	int error =3D -ENOMEM;
=20
-	if (xpad->xtype !=3D XTYPE_XBOX360)
+	if (xpad->xtype !=3D XTYPE_XBOX360 && xpad->xtype !=3D XTYPE_XBOX)
 		return 0;
=20
 	xpad->odata =3D usb_buffer_alloc(xpad->udev, XPAD_PKT_LEN,
@@ -535,13 +535,13 @@ static int xpad_init_output(struct usb_i
=20
 static void xpad_stop_output(struct usb_xpad *xpad)
 {
-	if (xpad->xtype =3D=3D XTYPE_XBOX360)
+	if (xpad->xtype =3D=3D XTYPE_XBOX360 || xpad->xtype =3D=3D XTYPE_XBOX)
 		usb_kill_urb(xpad->irq_out);
 }
=20
 static void xpad_deinit_output(struct usb_xpad *xpad)
 {
-	if (xpad->xtype =3D=3D XTYPE_XBOX360) {
+	if (xpad->xtype =3D=3D XTYPE_XBOX360 || xpad->xtype =3D=3D XTYPE_XBOX) {
 		usb_free_urb(xpad->irq_out);
 		usb_buffer_free(xpad->udev, XPAD_PKT_LEN,
 				xpad->odata, xpad->odata_dma);
@@ -554,24 +554,45 @@ static void xpad_stop_output(struct usb_
 #endif
=20
 #ifdef CONFIG_JOYSTICK_XPAD_FF
-static int xpad_play_effect(struct input_dev *dev, void *data,
-			    struct ff_effect *effect)
+static int xpad_send_rumble(struct usb_xpad *xpad, __u8 left, __u8 right) {
+	switch(xpad->xtype) {
+		case XTYPE_XBOX:
+			xpad->odata[0] =3D 0x00;
+			xpad->odata[1] =3D 0x06;
+			xpad->odata[2] =3D 0x00;
+			xpad->odata[3] =3D left;  // left actuator (strong)
+			xpad->odata[4] =3D 0x00;
+			xpad->odata[5] =3D right; // right actuator (weak)
+			xpad->irq_out->transfer_buffer_length =3D 6;
+			break;
+		case XTYPE_XBOX360:
+			xpad->odata[0] =3D 0x00;
+			xpad->odata[1] =3D 0x08;
+			xpad->odata[2] =3D 0x00;
+			xpad->odata[3] =3D left;  // left actuator (strong)
+			xpad->odata[4] =3D right; // right actuator (weak)
+			xpad->odata[5] =3D 0x00;
+			xpad->odata[6] =3D 0x00;
+			xpad->odata[7] =3D 0x00;
+			xpad->irq_out->transfer_buffer_length =3D 8;
+			break;
+		default:
+			dbg("%s - rumble command sent to unsupported xpad type: %d",=20
+				__func__, xpad->xtype);
+			return 0;
+		}
+	=09
+		return usb_submit_urb(xpad->irq_out, GFP_ATOMIC);
+}
+
+static int xpad_play_effect(struct input_dev *dev, void *data, struct ff_e=
ffect *effect)
 {
 	struct usb_xpad *xpad =3D input_get_drvdata(dev);
=20
 	if (effect->type =3D=3D FF_RUMBLE) {
-		__u16 strong =3D effect->u.rumble.strong_magnitude;
-		__u16 weak =3D effect->u.rumble.weak_magnitude;
-		xpad->odata[0] =3D 0x00;
-		xpad->odata[1] =3D 0x08;
-		xpad->odata[2] =3D 0x00;
-		xpad->odata[3] =3D strong / 256;
-		xpad->odata[4] =3D weak / 256;
-		xpad->odata[5] =3D 0x00;
-		xpad->odata[6] =3D 0x00;
-		xpad->odata[7] =3D 0x00;
-		xpad->irq_out->transfer_buffer_length =3D 8;
-		usb_submit_urb(xpad->irq_out, GFP_KERNEL);
+		__u8 strong =3D effect->u.rumble.strong_magnitude / 256;
+		__u8 weak   =3D effect->u.rumble.weak_magnitude / 256;
+		xpad_send_rumble(xpad, strong, weak);
 	}
=20
 	return 0;
@@ -579,7 +600,7 @@ static int xpad_play_effect(struct input
=20
 static int xpad_init_ff(struct usb_xpad *xpad)
 {
-	if (xpad->xtype !=3D XTYPE_XBOX360)
+	if (xpad->xtype !=3D XTYPE_XBOX360 && xpad->xtype !=3D XTYPE_XBOX)
 		return 0;
=20
 	input_set_capability(xpad->dev, EV_FF, FF_RUMBLE);

--Sig_/m8EEHk3j_5FnDqtM8Gl4gmi
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAktOO6cACgkQg4D7JNscH9pyfgCeICgfnRbZcpGaI/aD1rj6jquQ
fqIAnjA4BXdecr44BFWSzSAtCnxa7dRy
=CvxJ
-----END PGP SIGNATURE-----

--Sig_/m8EEHk3j_5FnDqtM8Gl4gmi--
