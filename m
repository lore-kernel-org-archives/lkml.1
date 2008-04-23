Return-Path: <linux-kernel-owner+w=401wt.eu-S1756753AbYDWKPS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756753AbYDWKPS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2008 06:15:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755881AbYDWKO6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Apr 2008 06:14:58 -0400
Received: from fg-out-1718.google.com ([72.14.220.156]:30919 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756379AbYDWKO5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2008 06:14:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type:content-disposition:user-agent:sender;
        b=CT7h4kzsTK5QfcndX1DF5qgNFu6Kw+KI+t3jSPr6StRnRTzsZrbWkIZ3LP5uqGWZCbDdixYN/SteMXVeb3GZaULh4lyQNgQ5tTyuO0L7kRyYrKlPV/HtzP4DKKr4fwCWtuXafFPYJeUXzLo9Ix0yugxRZzVH/r1a4pIe537IyB0=
Date: Wed, 23 Apr 2008 12:14:51 +0200
From: Rodney Lorrimar <rodney@rodney.id.au>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Pavel Machek <pavel@suse.cz>, jikos@suse.cz,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Andrew McNabb <amcnabb@mcnabbs.org>, linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] Input: adbhid - capslock and power button fix
Message-ID: <20080423101451.GC4735@solaria.local>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="KDt/GgjP6HVcx58l"
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--KDt/GgjP6HVcx58l
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

If the adbhid module parameter restore_capslock_events is used,
pressing the power button may confuse the capslock state. This is
because the power button release scancode (0xff) is sometimes the same
as the capslock press/release scancode.

This fix adds yet another flag to track the state of the power button
so that it works independently of capslock.

Signed-off-by: Rodney Lorrimar <rodney@rodney.id.au>
---
 drivers/macintosh/adbhid.c |   15 ++++++++++++---
 1 files changed, 12 insertions(+), 3 deletions(-)

diff --git a/drivers/macintosh/adbhid.c b/drivers/macintosh/adbhid.c
index 19d0984..2f28444 100644
--- a/drivers/macintosh/adbhid.c
+++ b/drivers/macintosh/adbhid.c
@@ -225,6 +225,7 @@ struct adbhid {
 #define FLAG_CAPSLOCK_TRANSLATE		0x00000008
 #define FLAG_CAPSLOCK_DOWN		0x00000010
 #define FLAG_CAPSLOCK_IGNORE_NEXT	0x00000020
+#define FLAG_POWER_KEY_PRESSED		0x00000040
=20
 static struct adbhid *adbhid[16];
=20
@@ -301,9 +302,11 @@ adbhid_input_keycode(int id, int scancode, int repeat)
 				ahid->flags |=3D FLAG_CAPSLOCK_TRANSLATE
 					| FLAG_CAPSLOCK_DOWN;
 			}
-		} else if (scancode =3D=3D 0xff) {
+		} else if (scancode =3D=3D 0xff &&
+			   !(ahid->flags & FLAG_POWER_KEY_PRESSED)) {
 			/* Scancode 0xff usually signifies that the capslock
-			 * key was either pressed or released. */
+			 * key was either pressed or released, or that the
+			 * power button was released. */
 			if (ahid->flags & FLAG_CAPSLOCK_TRANSLATE) {
 				keycode =3D ADB_KEY_CAPSLOCK;
 				if (ahid->flags & FLAG_CAPSLOCK_DOWN) {
@@ -317,7 +320,7 @@ adbhid_input_keycode(int id, int scancode, int repeat)
 				}
 			} else {
 				printk(KERN_INFO "Spurious caps lock event "
-						"(scancode 0xff).");
+						 "(scancode 0xff).\n");
 			}
 		}
 	}
@@ -344,6 +347,12 @@ adbhid_input_keycode(int id, int scancode, int repeat)
 		}
 		break;
 	case ADB_KEY_POWER:
+		/* Keep track of the power key state */
+		if (up_flag)
+			ahid->flags &=3D ~FLAG_POWER_KEY_PRESSED;
+		else
+			ahid->flags |=3D FLAG_POWER_KEY_PRESSED;
+
 		/* Fn + Command will produce a bogus "power" keycode */
 		if (ahid->flags & FLAG_FN_KEY_PRESSED) {
 			keycode =3D ADB_KEY_CMD;
--=20
1.5.5.1


--KDt/GgjP6HVcx58l
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFIDwwbbBchLr+YxKcRAibdAKCF/GKGG5e1Ypt+hd942iQ6oTnBpgCfST/y
Lj23Zz3foVYyI2YRp2x8s0k=
=ONkJ
-----END PGP SIGNATURE-----

--KDt/GgjP6HVcx58l--
