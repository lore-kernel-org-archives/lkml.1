Return-Path: <linux-kernel-owner+w=401wt.eu-S1751569AbXAXORP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751569AbXAXORP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jan 2007 09:17:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751574AbXAXORP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jan 2007 09:17:15 -0500
Received: from rtsoft3.corbina.net ([85.21.88.6]:19637 "EHLO
	buildserver.ru.mvista.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751566AbXAXORO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jan 2007 09:17:14 -0500
Date: Wed, 24 Jan 2007 17:14:41 +0300
From: Vitaly Bordug <vbordug@ru.mvista.com>
To: Greg KH <gregkh@suse.de>
Cc: lkml <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@osdl.org>
Subject: drivers/base: device_bind_driver() fix
Message-ID: <20070124171441.6a07d06b@localhost.localdomain>
X-Mailer: Sylpheed-Claws 2.5.6cvs10 (GTK+ 2.10.7; i686-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/MYi3kddlux/KQTzjkJkQuS";
 protocol="application/pgp-signature"; micalg=PGP-SHA1
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/MYi3kddlux/KQTzjkJkQuS
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable


Keeps sysfs from creating link if device is already bound to driver.
Similar behavior was before the rework; now without this patch fixed
PHY will complain about not been able to create file in sysfs.

Signed-off-by: Vitaly Bordug <vbordug@ru.mvista.com>
---

 drivers/base/dd.c |    8 +++++---
 1 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/base/dd.c b/drivers/base/dd.c
index 510e788..6da3d01 100644
--- a/drivers/base/dd.c
+++ b/drivers/base/dd.c
@@ -26,12 +26,12 @@
 #define to_drv(node) container_of(node, struct device_driver, kobj.entry)
=20
=20
-static void driver_bound(struct device *dev)
+static int driver_bound(struct device *dev)
 {
 	if (klist_node_attached(&dev->knode_driver)) {
 		printk(KERN_WARNING "%s: device %s already bound\n",
 			__FUNCTION__, kobject_name(&dev->kobj));
-		return;
+		return 0;
 	}
=20
 	pr_debug("bound device '%s' to driver '%s'\n",
@@ -42,6 +42,7 @@ static void driver_bound(struct device *dev)
 					     BUS_NOTIFY_BOUND_DRIVER, dev);
=20
 	klist_add_tail(&dev->knode_driver, &dev->driver->klist_devices);
+	return 1;
 }
=20
 static int driver_sysfs_add(struct device *dev)
@@ -86,7 +87,8 @@ static void driver_sysfs_remove(struct device *dev)
  */
 int device_bind_driver(struct device *dev)
 {
-	driver_bound(dev);
+	if (!driver_bound(dev))
+		return 0;
 	return driver_sysfs_add(dev);
 }
=20

--Sig_/MYi3kddlux/KQTzjkJkQuS
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFFt2nSuOg9JvQhSEsRAi7IAJ0c0anU1wgCtIHqBdGg0ce9c8uWwQCfUFbY
Hu0IWbw+xMbd1HkeXGGdW2Y=
=RdRP
-----END PGP SIGNATURE-----

--Sig_/MYi3kddlux/KQTzjkJkQuS--
