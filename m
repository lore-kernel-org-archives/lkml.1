Return-Path: <linux-kernel-owner+w=401wt.eu-S1753502AbZGAM17@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753502AbZGAM17 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jul 2009 08:27:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753533AbZGAM1l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Jul 2009 08:27:41 -0400
Received: from fe01x03-cgp.akado.ru ([77.232.31.164]:56189 "EHLO akado.ru"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753604AbZGAM1k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jul 2009 08:27:40 -0400
From: Arseniy Lartsev <ars3n@yandex.ru>
To: Oliver Neukum <oliver@neukum.org>
Subject: [PATCH] cdc-acm: work around some broken devices
Date: Wed, 1 Jul 2009 16:27:26 +0400
User-Agent: KMail/1.10.3 (Linux/2.6.31-rc1-git3-0.1-default; KDE/4.1.3; i686; ; )
Cc: Alan Stern <stern@rowland.harvard.edu>,
       USB list <linux-usb@vger.kernel.org>, linux-kernel@vger.kernel.org,
       greg@kroah.com
References: <Pine.LNX.4.44L0.0906301656440.5222-100000@iolanthe.rowland.org> <200907011525.00689.ars3n@yandex.ru> <200907011337.48901.oliver@neukum.org>
In-Reply-To: <200907011337.48901.oliver@neukum.org>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart2148006.fXOMxAsspz";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200907011627.31170.ars3n@yandex.ru>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart2148006.fXOMxAsspz
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Wednesday 01 July 2009 15:37:48 Oliver Neukum wrote:
> Yes, exactly. Please add greg@kroah.com into CC, add a Signed-off-by line
> and resend.
ok

Signed-off-by: Arseniy Lartsev <ars3n at yandex dot ru>
=2D-- a/drivers/usb/class/cdc-acm.c
+++ b/drivers/usb/class/cdc-acm.c
@@ -387,6 +387,7 @@ static void acm_rx_tasklet(unsigned long
 	struct acm_ru *rcv;
 	unsigned long flags;
 	unsigned char throttled;
+	struct usb_host_endpoint *ep;
=20
 	dbg("Entering acm_rx_tasklet");
=20
@@ -462,11 +463,20 @@ urbs:
=20
 		rcv->buffer =3D buf;
=20
=2D		usb_fill_bulk_urb(rcv->urb, acm->dev,
=2D				  acm->rx_endpoint,
=2D				  buf->base,
=2D				  acm->readsize,
=2D				  acm_read_bulk, rcv);
+		ep =3D (usb_pipein(acm->rx_endpoint) ? acm->dev->ep_in : acm->dev->ep_ou=
t)
+				[usb_pipeendpoint(acm->rx_endpoint)];
+		if (usb_endpoint_xfer_int(&ep->desc))
+			usb_fill_int_urb(rcv->urb, acm->dev,
+					 acm->rx_endpoint,
+					 buf->base,
+					 acm->readsize,
+					 acm_read_bulk, rcv, ep->desc.bInterval);
+		else
+			usb_fill_bulk_urb(rcv->urb, acm->dev,
+					  acm->rx_endpoint,
+					  buf->base,
+					  acm->readsize,
+					  acm_read_bulk, rcv);
 		rcv->urb->transfer_dma =3D buf->dma;
 		rcv->urb->transfer_flags |=3D URB_NO_TRANSFER_DMA_MAP;
=20
@@ -1227,9 +1237,14 @@ made_compressed_probe:
 			goto alloc_fail7;
 		}
=20
=2D		usb_fill_bulk_urb(snd->urb, usb_dev,
=2D			usb_sndbulkpipe(usb_dev, epwrite->bEndpointAddress),
=2D			NULL, acm->writesize, acm_write_bulk, snd);
+		if (usb_endpoint_xfer_int(epwrite))
+			usb_fill_int_urb(snd->urb, usb_dev,
+				usb_sndbulkpipe(usb_dev, epwrite->bEndpointAddress),
+				NULL, acm->writesize, acm_write_bulk, snd, epwrite->bInterval);
+		else
+			usb_fill_bulk_urb(snd->urb, usb_dev,
+				usb_sndbulkpipe(usb_dev, epwrite->bEndpointAddress),
+				NULL, acm->writesize, acm_write_bulk, snd);
 		snd->urb->transfer_flags |=3D URB_NO_TRANSFER_DMA_MAP;
 		snd->instance =3D acm;
 	}


--nextPart2148006.fXOMxAsspz
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)

iJwEAAECAAYFAkpLVjMACgkQIHDkq2F9exZZcgP+IuafzyCOf/pEwKMzd0T8zkPD
Yh8ntrzCaYxQQ1l4tUZ4hdS8PT9UbZ0vAH8RMtjdy2YMKcz3/1XudhGqvYWsT4VD
GZOiye6bWrpjp4vKevS/QqhYqihtKnI6Khm+KX8RlcckoUvH46tknpxfUCAoeL/y
cu51mivMVP2bTeynqt0=
=jURX
-----END PGP SIGNATURE-----

--nextPart2148006.fXOMxAsspz--
