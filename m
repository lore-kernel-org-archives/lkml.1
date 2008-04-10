Return-Path: <linux-kernel-owner+w=401wt.eu-S1756169AbYDJKeX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756169AbYDJKeX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2008 06:34:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754109AbYDJKeQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Apr 2008 06:34:16 -0400
Received: from mail1.bur.st ([203.82.212.241]:38594 "EHLO creep.bur.st"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752948AbYDJKeP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2008 06:34:15 -0400
Date: Thu, 10 Apr 2008 12:19:23 +0200
From: Rodney Lorrimar <rodney@rodney.id.au>
To: Pavel Machek <pavel@suse.cz>
Cc: jikos@suse.cz, linux-kernel@vger.kernel.org,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Andrew McNabb <amcnabb@mcnabbs.org>
Subject: [PATCH] Input: adbhid - capslock and power button fix
Message-ID: <20080410101923.GB2945@solaria.local>
References: <20080328001556.GA30148@solaria.local> <20080328105855.GA1686@elf.ucw.cz> <20080410095930.GA2945@solaria.local>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ZfOjI3PrQbgiZnxM"
Content-Disposition: inline
In-Reply-To: <20080410095930.GA2945@solaria.local>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--ZfOjI3PrQbgiZnxM
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

This patch applies on top of the previous patch in the thread.

---
 drivers/macintosh/adbhid.c |   15 ++++++++++++---
 1 files changed, 12 insertions(+), 3 deletions(-)

diff --git a/drivers/macintosh/adbhid.c b/drivers/macintosh/adbhid.c
index 19d0984..72b9011 100644
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
+				                 "(scancode 0xff).\n");
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
1.5.4.5


--ZfOjI3PrQbgiZnxM
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFH/emrbBchLr+YxKcRAgA8AJ4g9ikLc8+Kv86V4B9/OvD+PvtrrgCgvWMV
VSscjITOI8GWMf18/CHsdJQ=
=Ha79
-----END PGP SIGNATURE-----

--ZfOjI3PrQbgiZnxM--
