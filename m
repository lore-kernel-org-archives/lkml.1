Return-Path: <linux-kernel-owner+w=401wt.eu-S1756700AbYC1Myp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756700AbYC1Myp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2008 08:54:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754996AbYC1Mwf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Mar 2008 08:52:35 -0400
Received: from SpacedOut.fries.net ([67.64.210.234]:56330 "EHLO
	SpacedOut.fries.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757280AbYC1Mwe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2008 08:52:34 -0400
Date: Fri, 28 Mar 2008 07:27:44 -0500
From: David Fries <david@fries.net>
To: linux-kernel@vger.kernel.org
Cc: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Subject: [PATCH 31/35] W1: ds2490.c reset ds2490 in init
Message-ID: <20080328122744.GF3613@spacedout.fries.net>
References: <200803272343.m2RNhDac017650@SpacedOut.fries.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="wtUqn8XWZYmnPFNh"
Content-Disposition: inline
In-Reply-To: <200803272343.m2RNhDac017650@SpacedOut.fries.net>
User-Agent: Mutt/1.5.4i
X-Greylist: Sender is SPF-compliant, not delayed by milter-greylist-3.0 (SpacedOut.fries.net [127.0.0.1]); Fri, 28 Mar 2008 07:27:45 -0500 (CDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--wtUqn8XWZYmnPFNh
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

ds2490.c 1.8
Reset the device in init as it can be in a bad state.  This is
necessary because a block write will wait for data to be placed in the
output buffer and block any later commands which will keep
accumulating and the device will not be idle.  Another case is
removing the ds2490 module while a bus search is in progress, somehow
a few commands get through, but the input transfers fail leaving data
in the input buffer.  This will cause the next read to fail see the
note in ds_recv_data.

Signed-off-by: David Fries <david@fries.net>
---
 drivers/w1/masters/ds2490.c |   21 +++++++++++++++++++++
 1 files changed, 21 insertions(+), 0 deletions(-)

diff --git a/drivers/w1/masters/ds2490.c b/drivers/w1/masters/ds2490.c
index 1a87979..2d1bdbc 100644
--- a/drivers/w1/masters/ds2490.c
+++ b/drivers/w1/masters/ds2490.c
@@ -315,6 +315,15 @@ static int ds_recv_data(struct ds_device *dev, unsigne=
d char *buf, int size)
 	int count, err;
 	struct ds_status st;
=20
+	/* Careful on size.  If size is less than what is available in
+	 * the input buffer, the device fails the bulk transfer and
+	 * clears the input buffer.  It could read the maximum size of
+	 * the data buffer, but then do you return the first, last, or
+	 * some set of the middle size bytes?  As long as the rest of
+	 * the code is correct there will be size bytes waiting.  A
+	 * call to ds_wait_status will wait until the device is idle
+	 * and any data to be received would have been available.
+	 */
 	count =3D 0;
 	err =3D usb_bulk_msg(dev->udev, usb_rcvbulkpipe(dev->udev, dev->ep[EP_DAT=
A_IN]),
 				buf, size, &count, 1000);
@@ -823,6 +832,18 @@ static int ds_w1_init(struct ds_device *dev)
 {
 	memset(&dev->master, 0, sizeof(struct w1_bus_master));
=20
+	/* Reset the device as it can be in a bad state.
+	 * This is necessary because a block write will wait for data
+	 * to be placed in the output buffer and block any later
+	 * commands which will keep accumulating and the device will
+	 * not be idle.  Another case is removing the ds2490 module
+	 * while a bus search is in progress, somehow a few commands
+	 * get through, but the input transfers fail leaving data in
+	 * the input buffer.  This will cause the next read to fail
+	 * see the note in ds_recv_data.
+	 */
+	ds_send_control_cmd(dev, CTL_RESET_DEVICE, 0);
+
 	dev->master.data	=3D dev;
 	dev->master.touch_bit	=3D &ds9490r_touch_bit;
 	/* read_bit and write_bit in w1_bus_master are expected to set and
--=20
1.4.4.4

--wtUqn8XWZYmnPFNh
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQFH7ORAAI852cse6PARAteGAKCLseFMgj5g5+4nD6fB5LZUKtM0UACghFnC
nluqHmgcXGTq5NnolPKTD+U=
=QITl
-----END PGP SIGNATURE-----

--wtUqn8XWZYmnPFNh--
