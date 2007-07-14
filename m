Return-Path: <linux-kernel-owner+w=401wt.eu-S1764264AbXGNCEY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764264AbXGNCEY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2007 22:04:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761484AbXGNCEQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jul 2007 22:04:16 -0400
Received: from draco.mcnabbs.org ([208.78.103.77]:34549 "EHLO mcnabbs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760025AbXGNCEP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2007 22:04:15 -0400
X-Greylist: delayed 1592 seconds by postgrey-1.27 at vger.kernel.org; Fri, 13 Jul 2007 22:04:15 EDT
Date: Fri, 13 Jul 2007 18:57:12 -0600
From: Andrew McNabb <amcnabb@mcnabbs.org>
To: linux-kernel@vger.kernel.org
Subject: [PATCH] adbhid: produce all capslock key events
Message-ID: <20070714005712.GA10266@mcnabbs.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="WIyZ46R2i8wDzkSu"
Content-Disposition: inline
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--WIyZ46R2i8wDzkSu
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

The ADB keyboard, which is used for Apple PowerBooks, has strange
behavior with regard to the capslock key.  It keeps track of capslock
state internally, and it sends a keycode when capslock is engaged and a
keycode when capslock is disengaged.

When the current adbhid driver sees that the capslock key is pressed or
released, it creates both a keypress event and a keyrelease event
simultaneously.  This results in normal capslock behavior.

While this works, it makes it impossible to remap the capslock key to be
a control key.  However, by translating the 0xff keycode into capslock
keycodes, we can restore the missing capslock events and make it
possible to remap the capslock key.

With this patch, the adbhid driver will translate these 0xff keycodes
into capslock keypresses and keyreleases if
/sys/module/adbhid/parameters/restore_capslock_events is set to 1.
Otherwise it will retain the current behavior.  This option is off by
default because occasionally the 0xff keycode is not a capslock event,
and a mistake may require the user to tap the capslock key.

I would appreciate any feedback on the patch.  If it looks good, I would
like to submit it to be merged.

Signed-off-by: Andrew McNabb <amcnabb@mcnabbs.org>
---
 drivers/macintosh/adbhid.c |   48 ++++++++++++++++++++++++++++++++++++++--=
---
 1 files changed, 42 insertions(+), 6 deletions(-)

diff --git a/drivers/macintosh/adbhid.c b/drivers/macintosh/adbhid.c
index b46817f..3fd9b5e 100644
--- a/drivers/macintosh/adbhid.c
+++ b/drivers/macintosh/adbhid.c
@@ -52,6 +52,11 @@
=20
 MODULE_AUTHOR("Franz Sirl <Franz.Sirl-kernel@lauterbach.com>");
=20
+static int restore_capslock_events =3D 0;
+module_param(restore_capslock_events, int, 0644);
+MODULE_PARM_DESC(restore_capslock_events,
+	"Produce keypress events for capslock on both keyup and keydown.");
+
 #define KEYB_KEYREG	0	/* register # for key up/down data */
 #define KEYB_LEDREG	2	/* register # for leds on ADB keyboard */
 #define MOUSE_DATAREG	0	/* reg# for movement/button codes from mouse */
@@ -217,6 +222,8 @@ struct adbhid {
 #define FLAG_FN_KEY_PRESSED	0x00000001
 #define FLAG_POWER_FROM_FN	0x00000002
 #define FLAG_EMU_FWDEL_DOWN	0x00000004
+#define FLAG_CAPSLOCK_TRANSLATE	0x00000008
+#define FLAG_CAPSLOCK_DOWN	0x00000010
=20
 static struct adbhid *adbhid[16];
=20
@@ -272,16 +279,45 @@ adbhid_keyboard_input(unsigned char *data, int nb, in=
t apoll)
 }
=20
 static void
-adbhid_input_keycode(int id, int keycode, int repeat)
+adbhid_input_keycode(int id, int scancode, int repeat)
 {
 	struct adbhid *ahid =3D adbhid[id];
-	int up_flag;
-
-	up_flag =3D (keycode & 0x80);
-	keycode &=3D 0x7f;
+	int keycode, up_flag;
+
+	keycode =3D (scancode & 0x7f);
+	up_flag =3D (scancode & 0x80);
+
+	if (restore_capslock_events) {
+		if ((keycode =3D=3D ADB_KEY_CAPSLOCK) && !up_flag) {
+			/* Key pressed, turning on the CapsLock LED.
+			 * The next 0xff will be interpreted as a release. */
+			ahid->flags |=3D FLAG_CAPSLOCK_TRANSLATE
+					| FLAG_CAPSLOCK_DOWN;
+		} else if (scancode =3D=3D 0xff) {
+			/* Scancode 0xff usually signifies that the capslock
+			 * key was either pressed or released. */
+			if (ahid->flags & FLAG_CAPSLOCK_TRANSLATE) {
+				keycode =3D ADB_KEY_CAPSLOCK;
+				if (ahid->flags & FLAG_CAPSLOCK_DOWN) {
+					/* Key released */
+					up_flag =3D 1;
+					ahid->flags &=3D ~FLAG_CAPSLOCK_DOWN;
+				} else {
+					/* Key pressed */
+					up_flag =3D 0;
+					ahid->flags &=3D ~FLAG_CAPSLOCK_TRANSLATE;
+				}
+			} else {
+				printk(KERN_INFO "Spurious caps lock event "
+						"(scancode 0xff).");
+			}
+		}
+	}
=20
 	switch (keycode) {
-	case ADB_KEY_CAPSLOCK: /* Generate down/up events for CapsLock everytime.=
 */
+	case ADB_KEY_CAPSLOCK:
+		if (restore_capslock_events) break;
+		/* Generate down/up events for CapsLock everytime. */
 		input_report_key(ahid->input, KEY_CAPSLOCK, 1);
 		input_report_key(ahid->input, KEY_CAPSLOCK, 0);
 		input_sync(ahid->input);
--=20
1.5.2.2


--=20
Andrew McNabb
http://www.mcnabbs.org/andrew/
PGP Fingerprint: 8A17 B57C 6879 1863 DE55  8012 AB4D 6098 8826 6868

--WIyZ46R2i8wDzkSu
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)

iD8DBQFGmB9oq01gmIgmaGgRAsHAAJ0b2NTOfhQuXwC5w9eaCITj/iBvKACfaEt0
NuKHKAnOineMqD17vmTN+Zs=
=Dhlv
-----END PGP SIGNATURE-----

--WIyZ46R2i8wDzkSu--
