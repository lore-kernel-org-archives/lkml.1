Return-Path: <linux-kernel-owner+w=401wt.eu-S1757383AbYG2CXj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757383AbYG2CXj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2008 22:23:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754819AbYG2CX3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jul 2008 22:23:29 -0400
Received: from SpacedOut.fries.net ([67.64.210.234]:50119 "EHLO
	SpacedOut.fries.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752481AbYG2CX2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2008 22:23:28 -0400
Date: Mon, 28 Jul 2008 21:23:23 -0500
From: David Fries <david@fries.net>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Subject: [PATCH 15/30] W1: w1_int.c use first available master number
Message-ID: <20080729022323.GO24452@spacedout.fries.net>
References: <20080729020433.GA24424@spacedout.fries.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="f0PSjARDFl/vfYT5"
Content-Disposition: inline
In-Reply-To: <20080729020433.GA24424@spacedout.fries.net>
User-Agent: Mutt/1.5.4i
X-Greylist: Sender is SPF-compliant, not delayed by milter-greylist-3.0 (SpacedOut.fries.net [127.0.0.1]); Mon, 28 Jul 2008 21:23:23 -0500 (CDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--f0PSjARDFl/vfYT5
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Follow the example of other devices (like the joystick device).  Pick
the first available id for each detected device.  Currently for USB
devices, suspending and resuming would cause the number to increment.

Signed-off-by: David Fries <david@fries.net>
Signed-off-by: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
---
 drivers/w1/w1_int.c |   32 ++++++++++++++++++++++++++------
 1 files changed, 26 insertions(+), 6 deletions(-)

diff --git a/drivers/w1/w1_int.c b/drivers/w1/w1_int.c
index 3fd6e66..a3a5456 100644
--- a/drivers/w1/w1_int.c
+++ b/drivers/w1/w1_int.c
@@ -29,7 +29,6 @@
 #include "w1_netlink.h"
 #include "w1_int.h"
=20
-static u32 w1_ids =3D 1;
 static int w1_search_count =3D -1; /* Default is continual scan */
 module_param_named(search_count, w1_search_count, int, 0);
=20
@@ -102,9 +101,10 @@ static void w1_free_dev(struct w1_master *dev)
=20
 int w1_add_master_device(struct w1_bus_master *master)
 {
-	struct w1_master *dev;
+	struct w1_master *dev, *entry;
 	int retval =3D 0;
 	struct w1_netlink_msg msg;
+	int id, found;
=20
         /* validate minimum functionality */
         if (!(master->touch_bit && master->reset_bus) &&
@@ -126,13 +126,33 @@ int w1_add_master_device(struct w1_bus_master *master)
 		master->set_pullup =3D NULL;
 	}
=20
-	dev =3D w1_alloc_dev(w1_ids++, w1_max_slave_count, w1_max_slave_ttl, &w1_=
master_driver, &w1_master_device);
-	if (!dev)
+	/* Lock until the device is added (or not) to w1_masters. */
+	mutex_lock(&w1_mlock);
+	/* Search for the first available id (starting at 1). */
+	id =3D 0;
+	do {
+		++id;
+		found =3D 0;
+		list_for_each_entry(entry, &w1_masters, w1_master_entry) {
+			if (entry->id =3D=3D id) {
+				found =3D 1;
+				break;
+			}
+		}
+	} while (found);
+
+	dev =3D w1_alloc_dev(id, w1_max_slave_count, w1_max_slave_ttl,
+		&w1_master_driver, &w1_master_device);
+	if (!dev) {
+		mutex_unlock(&w1_mlock);
 		return -ENOMEM;
+	}
=20
 	retval =3D  w1_create_master_attributes(dev);
-	if (retval)
+	if (retval) {
+		mutex_unlock(&w1_mlock);
 		goto err_out_free_dev;
+	}
=20
 	memcpy(dev->bus_master, master, sizeof(struct w1_bus_master));
=20
@@ -144,10 +164,10 @@ int w1_add_master_device(struct w1_bus_master *master)
 		dev_err(&dev->dev,
 			 "Failed to create new kernel thread. err=3D%d\n",
 			 retval);
+		mutex_unlock(&w1_mlock);
 		goto err_out_rm_attr;
 	}
=20
-	mutex_lock(&w1_mlock);
 	list_add(&dev->w1_master_entry, &w1_masters);
 	mutex_unlock(&w1_mlock);
=20
--=20
1.4.4.4

--f0PSjARDFl/vfYT5
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQFIjn8bAI852cse6PARAonIAJ4ytpIalAiJ5MdDoEF2w5sSeBuhtQCgzBx/
c3HnFZLLokKEZcnAxNH44rw=
=IenW
-----END PGP SIGNATURE-----

--f0PSjARDFl/vfYT5--
