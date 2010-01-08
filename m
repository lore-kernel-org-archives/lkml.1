Return-Path: <linux-kernel-owner+w=401wt.eu-S1752862Ab0AHKYu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752862Ab0AHKYu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jan 2010 05:24:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752144Ab0AHKYt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jan 2010 05:24:49 -0500
Received: from outpost1.zedat.fu-berlin.de ([130.133.4.66]:55000 "EHLO
	outpost1.zedat.fu-berlin.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750709Ab0AHKYs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jan 2010 05:24:48 -0500
Date: Fri, 8 Jan 2010 11:26:10 +0100
From: Benjamin Valentin <benpicco@zedat.fu-berlin.de>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drivers/input/joystick/xpad.c: Add rumble support for
 original xbox controller
Message-ID: <20100108112610.0b78785b@piBook>
In-Reply-To: <20100108075054.GA3696@core.coreip.homeip.net>
References: <20100108033215.447c814e@rechenknecht2k7>
	<20100108075054.GA3696@core.coreip.homeip.net>
X-Mailer: Claws Mail 3.7.3 (GTK+ 2.18.5; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/5Zz_cY2s+nU5QbnwpRtOXJ2"; protocol="application/pgp-signature"
X-Originating-IP: 87.77.84.60
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/5Zz_cY2s+nU5QbnwpRtOXJ2
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Thu, 7 Jan 2010 23:50:54 -0800
Dmitry Torokhov <dmitry.torokhov@gmail.com> wrote:

> Thank you for your patch. Could I please have your "Signed-off-by: "
> so I can apply it? Also, if you have any more patches ofr in put
> devices, could you please CC linux-input@vger.kernel.org?

This way?

Signed-off-by: Benjamin Valentin <benpicco@zedat.fu-berlin.de>

--- /usr/src/linux-source-2.6.33/drivers/input/joystick/xpad.c
2010-01-08 02:56:59.365851076 +0100 +++ xpad.c	2010-01-08
03:13:38.477835651 +0100 @@ -505,7 +505,7 @@
 	struct usb_endpoint_descriptor *ep_irq_out;
 	int error =3D -ENOMEM;
=20
-	if (xpad->xtype !=3D XTYPE_XBOX360)
+	if (xpad->xtype !=3D XTYPE_XBOX360 && xpad->xtype !=3D XTYPE_XBOX)
 		return 0;
=20
 	xpad->odata =3D usb_buffer_alloc(xpad->udev, XPAD_PKT_LEN,
@@ -535,13 +535,13 @@
=20
 static void xpad_stop_output(struct usb_xpad *xpad)
 {
-	if (xpad->xtype =3D=3D XTYPE_XBOX360)
+	if (xpad->xtype =3D=3D XTYPE_XBOX360 || xpad->xtype !=3D XTYPE_XBOX)
 		usb_kill_urb(xpad->irq_out);
 }
=20
 static void xpad_deinit_output(struct usb_xpad *xpad)
 {
-	if (xpad->xtype =3D=3D XTYPE_XBOX360) {
+	if (xpad->xtype =3D=3D XTYPE_XBOX360 || xpad->xtype !=3D XTYPE_XBOX)
{ usb_free_urb(xpad->irq_out);
 		usb_buffer_free(xpad->udev, XPAD_PKT_LEN,
 				xpad->odata, xpad->odata_dma);
@@ -554,24 +554,43 @@
 #endif
=20
 #ifdef CONFIG_JOYSTICK_XPAD_FF
-static int xpad_play_effect(struct input_dev *dev, void *data,
-			    struct ff_effect *effect)
+static int xpad_send_rumble(struct usb_xpad *xpad, unsigned char left,
unsigned char right) {
+	switch(xpad->xtype) {
+		case XTYPE_XBOX:
+			xpad->odata[0] =3D 0x00;
+			xpad->odata[1] =3D 0x06;
+			xpad->odata[2] =3D 0x00;
+			xpad->odata[3] =3D left;  // left actuator
+			xpad->odata[4] =3D 0x00;
+			xpad->odata[5] =3D right; // right actuator
+			xpad->irq_out->transfer_buffer_length =3D 6;
+			return usb_submit_urb(xpad->irq_out,
GFP_KERNEL);
+		case XTYPE_XBOX360:
+			xpad->odata[0] =3D 0x00;
+			xpad->odata[1] =3D 0x08;
+			xpad->odata[2] =3D 0x00;
+			xpad->odata[3] =3D left;  // left actuator?
+			xpad->odata[4] =3D right; // right actuator?
+			xpad->odata[5] =3D 0x00;
+			xpad->odata[6] =3D 0x00;
+			xpad->odata[7] =3D 0x00;
+			xpad->irq_out->transfer_buffer_length =3D 8;
+			return usb_submit_urb(xpad->irq_out,
GFP_KERNEL);
+		default:
+			dbg("%s - rumble command sent to unsupported
xpad type: %d",=20
+				__func__, xpad->xtype);
+			return 0;
+		}
+}
+
+static int xpad_play_effect(struct input_dev *dev, void *data, struct
ff_effect *effect) {
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
+		unsigned char strong =3D
effect->u.rumble.strong_magnitude / 256;
+		unsigned char weak   =3D
effect->u.rumble.weak_magnitude / 256;
+		xpad_send_rumble(xpad, strong, weak);
 	}
=20
 	return 0;
@@ -579,7 +598,7 @@
=20
 static int xpad_init_ff(struct usb_xpad *xpad)
 {
-	if (xpad->xtype !=3D XTYPE_XBOX360)
+	if (xpad->xtype !=3D XTYPE_XBOX360 && xpad->xtype !=3D XTYPE_XBOX)
 		return 0;
=20
 	input_set_capability(xpad->dev, EV_FF, FF_RUMBLE);

--Sig_/5Zz_cY2s+nU5QbnwpRtOXJ2
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAktHCEIACgkQg4D7JNscH9pSIwCgn0JhqF3kmQJfEVbabo6DFClD
GBkAn0gY6FUhVGqglcCM7fzG96zHutQz
=Wh+d
-----END PGP SIGNATURE-----

--Sig_/5Zz_cY2s+nU5QbnwpRtOXJ2--
