Return-Path: <linux-kernel-owner+w=401wt.eu-S1754493AbZJVIm4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754493AbZJVIm4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Oct 2009 04:42:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754415AbZJVImy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Oct 2009 04:42:54 -0400
Received: from mail.nomovok.com ([83.150.122.238]:51760 "EHLO mail.nomovok.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754361AbZJVImx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Oct 2009 04:42:53 -0400
X-Greylist: delayed 389 seconds by postgrey-1.27 at vger.kernel.org; Thu, 22 Oct 2009 04:42:53 EDT
Subject: [PATCH] fix hso soft-lockup
From: Antti =?ISO-8859-1?Q?Kaijanm=E4ki?= <antti.kaijanmaki@nomovok.com>
To: linux-kernel@vger.kernel.org
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-1zPuuzAk3yPhDeW+W+po"
Date: Thu, 22 Oct 2009 11:36:18 +0300
Message-Id: <1256200578.3057.113.camel@nomovok.homedomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.0 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-1zPuuzAk3yPhDeW+W+po
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Fix soft-lockup in hso.c which is triggered on SMP machine when
modem is removed while file descriptor(s) under /dev are still open:

  old version called kref_put() too early which resulted in destroying
  hso_serial and hso_device objects which were still used later on.

Also fix driver debug routines (not compiled in by default).
---
 drivers/net/usb/hso.c |    9 ++++++---
 1 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/net/usb/hso.c b/drivers/net/usb/hso.c
index fa4e581..539642a 100644
--- a/drivers/net/usb/hso.c
+++ b/drivers/net/usb/hso.c
@@ -2,6 +2,7 @@
  *
  * Driver for Option High Speed Mobile Devices.
  *
+ *  Copyright (C) 2009 Antti Kaijanm=C3=A4ki <antti.kaijanmaki@nomovok.com=
>
  *  Copyright (C) 2008 Option International
  *                     Filip Aben <f.aben@option.com>
  *                     Denis Joseph Barrow <d.barow@option.com>
@@ -378,7 +379,7 @@ static void dbg_dump(int line_count, const char *func_n=
ame, unsigned char *buf,
 }
=20
 #define DUMP(buf_, len_)	\
-	dbg_dump(__LINE__, __func__, buf_, len_)
+	dbg_dump(__LINE__, __func__, (unsigned char*)buf_, len_)
=20
 #define DUMP1(buf_, len_)			\
 	do {					\
@@ -1363,7 +1364,7 @@ static void hso_serial_close(struct tty_struct *tty, =
struct file *filp)
 	/* reset the rts and dtr */
 	/* do the actual close */
 	serial->open_count--;
-	kref_put(&serial->parent->ref, hso_serial_ref_free);
+
 	if (serial->open_count <=3D 0) {
 		serial->open_count =3D 0;
 		spin_lock_irq(&serial->serial_lock);
@@ -1383,6 +1384,8 @@ static void hso_serial_close(struct tty_struct *tty, =
struct file *filp)
 		usb_autopm_put_interface(serial->parent->interface);
=20
 	mutex_unlock(&serial->parent->mutex);
+
+	kref_put(&serial->parent->ref, hso_serial_ref_free);
 }
=20
 /* close the requested serial port */
@@ -1527,7 +1530,7 @@ static void tiocmget_intr_callback(struct urb *urb)
 		dev_warn(&usb->dev,
 			 "hso received invalid serial state notification\n");
 		DUMP(serial_state_notification,
-		     sizeof(hso_serial_state_notifation))
+		     sizeof(struct hso_serial_state_notification));
 	} else {
=20
 		UART_state_bitmap =3D le16_to_cpu(serial_state_notification->
--=20
1.6.3.3


--=-1zPuuzAk3yPhDeW+W+po
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkrgGYAACgkQJ/yWUtJ8RGo0sgCeOvQuiNK9svcw30JVkVE11PVM
NQsAoLqrf8i7f1qYJ5vUy9S4fiPaJvGS
=dAqG
-----END PGP SIGNATURE-----

--=-1zPuuzAk3yPhDeW+W+po--

