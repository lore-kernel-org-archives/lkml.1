Return-Path: <linux-kernel-owner+w=401wt.eu-S1754541AbZF1T3r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754541AbZF1T3r (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Jun 2009 15:29:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752696AbZF1T3i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Jun 2009 15:29:38 -0400
Received: from fe01x03-cgp.akado.ru ([77.232.31.164]:53162 "EHLO akado.ru"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751519AbZF1T3h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Jun 2009 15:29:37 -0400
X-Greylist: delayed 3602 seconds by postgrey-1.27 at vger.kernel.org; Sun, 28 Jun 2009 15:29:37 EDT
From: Arseniy Lartsev <ars3n@yandex.ru>
To: linux-kernel@vger.kernel.org
Subject: PROBLEM: USB ACM device does not work
Date: Sun, 28 Jun 2009 22:29:26 +0400
User-Agent: KMail/1.10.3 (Linux/2.6.27.23-0.1-default; KDE/4.1.3; i686; ; )
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart2182420.STCGG8UVhR";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200906282229.35713.ars3n@yandex.ru>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart2182420.STCGG8UVhR
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

I've got a piece of hardware (this one:
http://masterkit.ru/main/set.php?num=3D1153) which acts like an USB ACM
device and is handeled by the cdc_acm module. /dev/ttyACM0 does appear
but any attempt to write something to the device with a simple
"echo something >/dev/ttyACM0" fails with "Invalid argument" error.

The reason is that the driver calls usb_submit_urb in acm_start_wb()
but doesn't set interval in the urb structure, so it remains zero and
causes usb_submit_urb to return -EINVAL. Reading from device also does
not work due to the same problem in acm_rx_tasklet().

After setting urb interval to 128, this particular device works fine
for me (though I'm not sure that it's a right solution in general).

Corresponding patch (against 2.6.30) is:

=2D-- linux-2.6.30.orig/drivers/usb/class/cdc-acm.c
+++ linux-2.6.30/drivers/usb/class/cdc-acm.c
@@ -182,6 +182,7 @@ static int acm_start_wb(struct acm *acm,
 	wb->urb->transfer_dma =3D wb->dmah;
 	wb->urb->transfer_buffer_length =3D wb->len;
 	wb->urb->dev =3D acm->dev;
+	wb->urb->interval =3D 128;
=20
 	if ((rc =3D usb_submit_urb(wb->urb, GFP_ATOMIC)) < 0) {
 		dbg("usb_submit_urb(write bulk) failed: %d", rc);
@@ -453,6 +454,7 @@ urbs:
 				  acm_read_bulk, rcv);
 		rcv->urb->transfer_dma =3D buf->dma;
 		rcv->urb->transfer_flags |=3D URB_NO_TRANSFER_DMA_MAP;
+		rcv->urb->interval =3D 128;
=20
 		/* This shouldn't kill the driver as unsuccessful URBs are returned to t=
he
 		   free-urbs-pool and resubmited ASAP */


--nextPart2182420.STCGG8UVhR
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)

iJwEAAECAAYFAkpHto8ACgkQIHDkq2F9exbb4gQAsDbQ1e04MeUIYnH1LjJGDQSl
My7Hb9xQEoeqwt6VLc2YPuSat15oxhTwriXpQkqku95o9VxgqVS0+zOffR4izJqn
R5lODAjeT2EUQPVRpXprMys1ewVaF/HHoMYnCgMkovPvaD2vHNGZfT+6AdzGJrnL
BqsagRUidKEoZ2HBzfc=
=hGno
-----END PGP SIGNATURE-----

--nextPart2182420.STCGG8UVhR--
