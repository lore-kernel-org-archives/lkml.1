Return-Path: <linux-kernel-owner+w=401wt.eu-S1757469AbYG2CYd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757469AbYG2CYd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2008 22:24:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756476AbYG2CYR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jul 2008 22:24:17 -0400
Received: from SpacedOut.fries.net ([67.64.210.234]:50125 "EHLO
	SpacedOut.fries.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756275AbYG2CYQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2008 22:24:16 -0400
Date: Mon, 28 Jul 2008 21:24:11 -0500
From: David Fries <david@fries.net>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Subject: [PATCH 17/30] W1: w1_io.c reset comments and msleep
Message-ID: <20080729022411.GQ24452@spacedout.fries.net>
References: <20080729020433.GA24424@spacedout.fries.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="5KxTQ9fdN6Op3ksq"
Content-Disposition: inline
In-Reply-To: <20080729020433.GA24424@spacedout.fries.net>
User-Agent: Mutt/1.5.4i
X-Greylist: Sender is SPF-compliant, not delayed by milter-greylist-3.0 (SpacedOut.fries.net [127.0.0.1]); Mon, 28 Jul 2008 21:24:12 -0500 (CDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--5KxTQ9fdN6Op3ksq
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

w1_reset_bus, added some comments about the timing and switched to
msleep for the later delay.  I don't have the hardware to test the
sleep after reset change.  The one wire doesn't have a timing              =
     requirement between commands so it is fine.  I do have the USB        =
          hardware and it would be in big trouble with 10ms interrupt trans=
fers
to find that the reset completed.

Signed-off-by: David Fries <david@fries.net>
Signed-off-by: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
---
 drivers/w1/w1_io.c |   14 +++++++++++++-
 1 files changed, 13 insertions(+), 1 deletions(-)

diff --git a/drivers/w1/w1_io.c b/drivers/w1/w1_io.c
index a2f0d5f..dd2ecef 100644
--- a/drivers/w1/w1_io.c
+++ b/drivers/w1/w1_io.c
@@ -293,12 +293,24 @@ int w1_reset_bus(struct w1_master *dev)
 		result =3D dev->bus_master->reset_bus(dev->bus_master->data) & 0x1;
 	else {
 		dev->bus_master->write_bit(dev->bus_master->data, 0);
+		/* minimum 480, max ? us
+		 * be nice and sleep, except 18b20 spec lists 960us maximum,
+		 * so until we can sleep with microsecond accuracy, spin.
+		 * Feel free to come up with some other way to give up the
+		 * cpu for such a short amount of time AND get it back in
+		 * the maximum amount of time.
+		 */
 		w1_delay(480);
 		dev->bus_master->write_bit(dev->bus_master->data, 1);
 		w1_delay(70);
=20
 		result =3D dev->bus_master->read_bit(dev->bus_master->data) & 0x1;
-		w1_delay(410);
+		/* minmum 70 (above) + 410 =3D 480 us
+		 * There aren't any timing requirements between a reset and
+		 * the following transactions.  Sleeping is safe here.
+		 */
+		/* w1_delay(410); min required time */
+		msleep(1);
 	}
=20
 	return result;
--=20
1.4.4.4

--5KxTQ9fdN6Op3ksq
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQFIjn9LAI852cse6PARAlugAKCoFqhPNx99Xc0i3badehtbIyLQIACeMDfI
nrg8UhwjU4qLFG481Gb7Cc0=
=q9j1
-----END PGP SIGNATURE-----

--5KxTQ9fdN6Op3ksq--
