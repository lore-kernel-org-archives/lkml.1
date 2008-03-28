Return-Path: <linux-kernel-owner+w=401wt.eu-S1757446AbYC1NBo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757446AbYC1NBo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2008 09:01:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758581AbYC1Mzs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Mar 2008 08:55:48 -0400
Received: from SpacedOut.fries.net ([67.64.210.234]:34541 "EHLO
	SpacedOut.fries.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758542AbYC1Mzp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2008 08:55:45 -0400
Date: Fri, 28 Mar 2008 07:26:43 -0500
From: David Fries <david@fries.net>
To: linux-kernel@vger.kernel.org
Cc: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Subject: [PATCH 19/35] W1: w1_int.c use first available master number
Message-ID: <20080328122643.GT3613@spacedout.fries.net>
References: <200803272343.m2RNhDac017650@SpacedOut.fries.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="2wYUONsACSj9OMJp"
Content-Disposition: inline
In-Reply-To: <200803272343.m2RNhDac017650@SpacedOut.fries.net>
User-Agent: Mutt/1.5.4i
X-Greylist: Sender is SPF-compliant, not delayed by milter-greylist-3.0 (SpacedOut.fries.net [127.0.0.1]); Fri, 28 Mar 2008 07:26:43 -0500 (CDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--2wYUONsACSj9OMJp
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

w1_int.c 1.8
Follow the example of other devices (like the joystick device).  Pick      =
     the first available id for each detected device.  For a one device
system suspending and resuming would at least keep the 1 id.  It would
at least make it easier on the user program.  That and it would reduce
holes, plugin master, plugin master, remove 2nd master, plug in
master, then you have 1, 2 intead of 1, 3.

Signed-off-by: David Fries <david@fries.net>
---
 drivers/w1/w1_int.c |   31 +++++++++++++++++++++++++------
 1 files changed, 25 insertions(+), 6 deletions(-)

diff --git a/drivers/w1/w1_int.c b/drivers/w1/w1_int.c
index f1806e2..9ec468a 100644
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
@@ -98,9 +97,10 @@ static void w1_free_dev(struct w1_master *dev)
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
@@ -122,13 +122,32 @@ int w1_add_master_device(struct w1_bus_master *master)
 		master->set_pullup=3DNULL;
 	}
=20
-	dev =3D w1_alloc_dev(w1_ids++, w1_max_slave_count, w1_max_slave_ttl, &w1_=
master_driver, &w1_master_device);
-	if (!dev)
+	/* Lock until the device is added (or not) to w1_masters. */
+	mutex_lock(&w1_mlock);
+	/* Search for the first available id (starting at 1). */
+	id=3D0;
+	do {
+		++id;
+		found=3D0;
+		list_for_each_entry(entry, &w1_masters, w1_master_entry) {
+			if(entry->id=3D=3Did) {
+				found=3D1;
+				break;
+			}
+		}
+	}while(found);
+
+	dev =3D w1_alloc_dev(id, w1_max_slave_count, w1_max_slave_ttl, &w1_master=
_driver, &w1_master_device);
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
@@ -140,10 +159,10 @@ int w1_add_master_device(struct w1_bus_master *master)
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

--2wYUONsACSj9OMJp
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQFH7OQDAI852cse6PARAvTUAJ9/0BmxXzzRMUGYHF5KGn4M0SP4+wCgnW4N
2kqJr+VrHb79qS8irt50a/Q=
=gxJ2
-----END PGP SIGNATURE-----

--2wYUONsACSj9OMJp--
