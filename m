Return-Path: <linux-kernel-owner+w=401wt.eu-S1756168AbYC1Awj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756168AbYC1Awj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2008 20:52:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755495AbYC1AwW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Mar 2008 20:52:22 -0400
Received: from mail1.bur.st ([203.82.212.241]:60784 "EHLO creep.bur.st"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753540AbYC1AwV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2008 20:52:21 -0400
X-Greylist: delayed 2164 seconds by postgrey-1.27 at vger.kernel.org; Thu, 27 Mar 2008 20:52:20 EDT
Date: Fri, 28 Mar 2008 01:15:56 +0100
From: Rodney Lorrimar <rodney@rodney.id.au>
To: linux-kernel@vger.kernel.org
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Andrew McNabb <amcnabb@mcnabbs.org>
Subject: [PATCH] Input: adbhid - fix capslock key state after suspend
Message-ID: <20080328001556.GA30148@solaria.local>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="G4iJoqBmSsgzjUCe"
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--G4iJoqBmSsgzjUCe
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

If the adbhid module parameter restore_capslock_events is used,
sometimes capslock will get stuck down after resuming.

My fix is to remember the capslock state before suspend and then
ignore the first 'caps lock key down' message after resume if the
capslock LED was on before suspending.

Signed-off-by: Rodney Lorrimar <rodney@rodney.id.au>
---
 drivers/macintosh/adbhid.c |   43 +++++++++++++++++++++++++++++++++++++---=
---
 1 files changed, 37 insertions(+), 6 deletions(-)

diff --git a/drivers/macintosh/adbhid.c b/drivers/macintosh/adbhid.c
index ef4c117..19d0984 100644
--- a/drivers/macintosh/adbhid.c
+++ b/drivers/macintosh/adbhid.c
@@ -219,11 +219,12 @@ struct adbhid {
 	int flags;
 };
=20
-#define FLAG_FN_KEY_PRESSED	0x00000001
-#define FLAG_POWER_FROM_FN	0x00000002
-#define FLAG_EMU_FWDEL_DOWN	0x00000004
-#define FLAG_CAPSLOCK_TRANSLATE	0x00000008
-#define FLAG_CAPSLOCK_DOWN	0x00000010
+#define FLAG_FN_KEY_PRESSED		0x00000001
+#define FLAG_POWER_FROM_FN		0x00000002
+#define FLAG_EMU_FWDEL_DOWN		0x00000004
+#define FLAG_CAPSLOCK_TRANSLATE		0x00000008
+#define FLAG_CAPSLOCK_DOWN		0x00000010
+#define FLAG_CAPSLOCK_IGNORE_NEXT	0x00000020
=20
 static struct adbhid *adbhid[16];
=20
@@ -291,8 +292,15 @@ adbhid_input_keycode(int id, int scancode, int repeat)
 		if (keycode =3D=3D ADB_KEY_CAPSLOCK && !up_flag) {
 			/* Key pressed, turning on the CapsLock LED.
 			 * The next 0xff will be interpreted as a release. */
-			ahid->flags |=3D FLAG_CAPSLOCK_TRANSLATE
+			if (ahid->flags & FLAG_CAPSLOCK_IGNORE_NEXT) {
+				/* Throw away this key event if it happens
+				 * just after resume. */
+				ahid->flags &=3D ~FLAG_CAPSLOCK_IGNORE_NEXT;
+				return;
+			} else {
+				ahid->flags |=3D FLAG_CAPSLOCK_TRANSLATE
 					| FLAG_CAPSLOCK_DOWN;
+			}
 		} else if (scancode =3D=3D 0xff) {
 			/* Scancode 0xff usually signifies that the capslock
 			 * key was either pressed or released. */
@@ -681,6 +689,20 @@ static int adbhid_kbd_event(struct input_dev *dev, uns=
igned int type, unsigned i
 	return -1;
 }
=20
+static void
+adbhid_kbd_capslock_remember(void)
+{
+	struct adbhid *ahid;
+	int i;
+	for (i =3D 1; i < 16; i++) {
+		ahid =3D adbhid[i];
+
+		if (ahid && ahid->id =3D=3D ADB_KEYBOARD)
+			if (ahid->flags & FLAG_CAPSLOCK_TRANSLATE)
+				ahid->flags |=3D FLAG_CAPSLOCK_IGNORE_NEXT;
+	}
+}
+
 static int
 adb_message_handler(struct notifier_block *this, unsigned long code, void =
*x)
 {
@@ -699,6 +721,15 @@ adb_message_handler(struct notifier_block *this, unsig=
ned long code, void *x)
 		/* Stop pending led requests */
 		while(leds_req_pending)
 			adb_poll();
+
+		/* After resume, and if the capslock LED is on, the PMU will
+		 * send a "capslock down" key event. This confuses the
+		 * restore_capslock_events logic. Remember if the capslock
+		 * LED was on before suspend so the unwanted key event can
+		 * be ignored after resume. */
+		if (restore_capslock_events)
+			adbhid_kbd_capslock_remember();
+
 		break;
=20
 	case ADB_MSG_POST_RESET:
--=20
1.5.4.4


--G4iJoqBmSsgzjUCe
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFH7Di7bBchLr+YxKcRAuJHAJ4ua5toMhPX/3PDTxfPhFEfHwhljACgg83V
Rq1zXQC7WOLdPk4cibNSefk=
=CLfS
-----END PGP SIGNATURE-----

--G4iJoqBmSsgzjUCe--
