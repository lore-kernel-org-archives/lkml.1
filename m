Return-Path: <linux-kernel-owner+w=401wt.eu-S1759940AbYC1NAl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759940AbYC1NAl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2008 09:00:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758555AbYC1Mzo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Mar 2008 08:55:44 -0400
Received: from SpacedOut.fries.net ([67.64.210.234]:34541 "EHLO
	SpacedOut.fries.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758542AbYC1Mzm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2008 08:55:42 -0400
Date: Fri, 28 Mar 2008 07:26:55 -0500
From: David Fries <david@fries.net>
To: linux-kernel@vger.kernel.org
Cc: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Subject: [PATCH 21/35] W1: w1_io.c reset comments and msleep
Message-ID: <20080328122655.GV3613@spacedout.fries.net>
References: <200803272343.m2RNhDac017650@SpacedOut.fries.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="SidV/bKy1CyabPX8"
Content-Disposition: inline
In-Reply-To: <200803272343.m2RNhDac017650@SpacedOut.fries.net>
User-Agent: Mutt/1.5.4i
X-Greylist: Sender is SPF-compliant, not delayed by milter-greylist-3.0 (SpacedOut.fries.net [127.0.0.1]); Fri, 28 Mar 2008 07:26:55 -0500 (CDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--SidV/bKy1CyabPX8
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

w1_io.c 1.7
w1_reset_bus, added some comments about the timing and switched to
msleep for the later delay.  I don't have the hardware to test the
sleep after reset change.  The one wire doesn't have a timing              =
     requirement between commands so it is fine.  I do have the USB        =
          hardware and it would be in big trouble with 10ms interrupt trans=
fers
to find that the reset completed.

Signed-off-by: David Fries <david@fries.net>
---
 drivers/w1/w1_io.c |   14 +++++++++++++-
 1 files changed, 13 insertions(+), 1 deletions(-)

diff --git a/drivers/w1/w1_io.c b/drivers/w1/w1_io.c
index 46c6994..9238758 100644
--- a/drivers/w1/w1_io.c
+++ b/drivers/w1/w1_io.c
@@ -291,12 +291,24 @@ int w1_reset_bus(struct w1_master *dev)
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

--SidV/bKy1CyabPX8
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQFH7OQPAI852cse6PARAtCPAKCP5epzW8m6J6oRLPQkYpdr3IVRWQCgvGul
xpj2Qs1/PejcVj4xkaAEICI=
=srWe
-----END PGP SIGNATURE-----

--SidV/bKy1CyabPX8--
