Return-Path: <linux-kernel-owner+w=401wt.eu-S1758291AbYG2C17@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758291AbYG2C17 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2008 22:27:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757961AbYG2C1O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jul 2008 22:27:14 -0400
Received: from SpacedOut.fries.net ([67.64.210.234]:58128 "EHLO
	SpacedOut.fries.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755429AbYG2C1M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2008 22:27:12 -0400
Date: Mon, 28 Jul 2008 21:27:07 -0500
From: David Fries <david@fries.net>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Subject: [PATCH 26/30] W1: ds2490.c reset ds2490 in init
Message-ID: <20080729022707.GZ24452@spacedout.fries.net>
References: <20080729020433.GA24424@spacedout.fries.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="tyjMFqNw14br+l4O"
Content-Disposition: inline
In-Reply-To: <20080729020433.GA24424@spacedout.fries.net>
User-Agent: Mutt/1.5.4i
X-Greylist: Sender is SPF-compliant, not delayed by milter-greylist-3.0 (SpacedOut.fries.net [127.0.0.1]); Mon, 28 Jul 2008 21:27:08 -0500 (CDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--tyjMFqNw14br+l4O
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Reset the device in init as it can be in a bad state.  This is
necessary because a block write will wait for data to be placed in the
output buffer and block any later commands which will keep
accumulating and the device will not be idle.  Another case is
removing the ds2490 module while a bus search is in progress, somehow
a few commands get through, but the input transfers fail leaving data
in the input buffer.  This will cause the next read to fail see the
note in ds_recv_data.

Signed-off-by: David Fries <david@fries.net>
Signed-off-by: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
---
 drivers/w1/masters/ds2490.c |   21 +++++++++++++++++++++
 1 files changed, 21 insertions(+), 0 deletions(-)

diff --git a/drivers/w1/masters/ds2490.c b/drivers/w1/masters/ds2490.c
index eb902ab..754a4bb 100644
--- a/drivers/w1/masters/ds2490.c
+++ b/drivers/w1/masters/ds2490.c
@@ -316,6 +316,15 @@ static int ds_recv_data(struct ds_device *dev, unsigne=
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
@@ -824,6 +833,18 @@ static int ds_w1_init(struct ds_device *dev)
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

--tyjMFqNw14br+l4O
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQFIjn/7AI852cse6PARAufHAJ9AnrwP+FwFOUedpTRIVQEWRBVGJACfWxGD
G7YCoHhTk38wx4zkvk9z4L8=
=20IE
-----END PGP SIGNATURE-----

--tyjMFqNw14br+l4O--
