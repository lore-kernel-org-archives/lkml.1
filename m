Return-Path: <linux-kernel-owner+w=401wt.eu-S1756244AbYG2CVU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756244AbYG2CVU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2008 22:21:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752918AbYG2CVJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jul 2008 22:21:09 -0400
Received: from SpacedOut.fries.net ([67.64.210.234]:50107 "EHLO
	SpacedOut.fries.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752423AbYG2CVI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2008 22:21:08 -0400
Date: Mon, 28 Jul 2008 21:21:01 -0500
From: David Fries <david@fries.net>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Subject: [PATCH 11/30] W1: w1_slave_read_id read bug, use device_attribute
Message-ID: <20080729022101.GK24452@spacedout.fries.net>
References: <20080729020433.GA24424@spacedout.fries.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="k18oBAwMkTg3OUap"
Content-Disposition: inline
In-Reply-To: <20080729020433.GA24424@spacedout.fries.net>
User-Agent: Mutt/1.5.4i
X-Greylist: Sender is SPF-compliant, not delayed by milter-greylist-3.0 (SpacedOut.fries.net [127.0.0.1]); Mon, 28 Jul 2008 21:21:02 -0500 (CDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--k18oBAwMkTg3OUap
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Fix bug reading the id sysfs file.  If less than the full 8 bytes were
read, the next read would start at the first byte instead of
continuing.  It needed the offset added to memcpy, or the better
solution was to replace it with the device attribute instead of bin
attribute.

Signed-off-by: David Fries <david@fries.net>
Signed-off-by: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
---
 drivers/w1/w1.c |   35 ++++++++++-------------------------
 1 files changed, 10 insertions(+), 25 deletions(-)

diff --git a/drivers/w1/w1.c b/drivers/w1/w1.c
index 4bf2001..67b4b99 100644
--- a/drivers/w1/w1.c
+++ b/drivers/w1/w1.c
@@ -103,35 +103,20 @@ static ssize_t w1_slave_read_name(struct device *dev,=
 struct device_attribute *a
 	return sprintf(buf, "%s\n", sl->name);
 }
=20
-static ssize_t w1_slave_read_id(struct kobject *kobj,
-				struct bin_attribute *bin_attr,
-				char *buf, loff_t off, size_t count)
+static ssize_t w1_slave_read_id(struct device *dev,
+	struct device_attribute *attr, char *buf)
 {
-	struct w1_slave *sl =3D kobj_to_w1_slave(kobj);
-
-	if (off > 8) {
-		count =3D 0;
-	} else {
-		if (off + count > 8)
-			count =3D 8 - off;
-
-		memcpy(buf, (u8 *)&sl->reg_num, count);
-	}
+	struct w1_slave *sl =3D dev_to_w1_slave(dev);
+	ssize_t count =3D sizeof(sl->reg_num);
=20
+	memcpy(buf, (u8 *)&sl->reg_num, count);
 	return count;
 }
=20
 static struct device_attribute w1_slave_attr_name =3D
 	__ATTR(name, S_IRUGO, w1_slave_read_name, NULL);
-
-static struct bin_attribute w1_slave_attr_bin_id =3D {
-      .attr =3D {
-              .name =3D "id",
-              .mode =3D S_IRUGO,
-      },
-      .size =3D 8,
-      .read =3D w1_slave_read_id,
-};
+static struct device_attribute w1_slave_attr_id =3D
+	__ATTR(id, S_IRUGO, w1_slave_read_id, NULL);
=20
 /* Default family */
=20
@@ -641,7 +626,7 @@ static int __w1_attach_slave_device(struct w1_slave *sl)
 	}
=20
 	/* Create "id" entry */
-	err =3D sysfs_create_bin_file(&sl->dev.kobj, &w1_slave_attr_bin_id);
+	err =3D device_create_file(&sl->dev, &w1_slave_attr_id);
 	if (err < 0) {
 		dev_err(&sl->dev,
 			"sysfs file creation for [%s] failed. err=3D%d\n",
@@ -663,7 +648,7 @@ static int __w1_attach_slave_device(struct w1_slave *sl)
 	return 0;
=20
 out_rem2:
-	sysfs_remove_bin_file(&sl->dev.kobj, &w1_slave_attr_bin_id);
+	device_remove_file(&sl->dev, &w1_slave_attr_id);
 out_rem1:
 	device_remove_file(&sl->dev, &w1_slave_attr_name);
 out_unreg:
@@ -745,7 +730,7 @@ void w1_slave_detach(struct w1_slave *sl)
 	msg.type =3D W1_SLAVE_REMOVE;
 	w1_netlink_send(sl->master, &msg);
=20
-	sysfs_remove_bin_file(&sl->dev.kobj, &w1_slave_attr_bin_id);
+	device_remove_file(&sl->dev, &w1_slave_attr_id);
 	device_remove_file(&sl->dev, &w1_slave_attr_name);
 	device_unregister(&sl->dev);
=20
--=20
1.4.4.4

--k18oBAwMkTg3OUap
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQFIjn6NAI852cse6PARApL+AJ9ZA2MjEvMRABT4fgoKDaZew5iRHACgh0nZ
U3qjX+/BMH5W4u+e4wA96oU=
=GXyb
-----END PGP SIGNATURE-----

--k18oBAwMkTg3OUap--
