Return-Path: <linux-kernel-owner+w=401wt.eu-S1758521AbYDMXQb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758521AbYDMXQb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Apr 2008 19:16:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758092AbYDMXPl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Apr 2008 19:15:41 -0400
Received: from SpacedOut.fries.net ([67.64.210.234]:60300 "EHLO
	SpacedOut.fries.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757980AbYDMXPj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Apr 2008 19:15:39 -0400
Date: Sun, 13 Apr 2008 18:15:37 -0500
From: David Fries <david@fries.net>
To: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 13/33 replaces 14/35 and 15/35] W1: w1_slave_read_id multiple short read bug
Message-ID: <20080413231537.GF15213@spacedout.fries.net>
References: <20080413225632.GA14058@spacedout.fries.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="mrJd9p1Ce66CJMxE"
Content-Disposition: inline
In-Reply-To: <20080413225632.GA14058@spacedout.fries.net>
User-Agent: Mutt/1.5.4i
X-Greylist: Sender is SPF-compliant, not delayed by milter-greylist-3.0 (SpacedOut.fries.net [127.0.0.1]); Sun, 13 Apr 2008 18:15:38 -0500 (CDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--mrJd9p1Ce66CJMxE
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
This is an update to the previous set of patches, don't merge them
yet.  Some of the context was messed up and I don't expect patch to
apply the updates with the previous set cleanly.  I'll resubmit the
entire set if these updates look good.
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D

This is more to point out the bug in w1_slave_read_id, the next patch
rewrites the routine.

w1.c 1.15
Reading at an offset other than zero, ie reading less than 8 bytes at
a time would result in reading the first bytes over and over until 8
bytes were returned.  Added the offset to the buffer.
- memcpy(buf, (u8 *)&sl->reg_num, count);
+ memcpy(buf, (u8 *)&sl->reg_num+off, count);
But there is a better way...

w1.c 1.16
Switching w1_slave_read_id from being a bin_attribute to a
device_attribute.  It only has to return 8 bytes per read and lets
kobject handle the buffering.  That simplifies the logic in
w1_slave_read_id.

Signed-off-by: David Fries <david@fries.net>
---
 drivers/w1/w1.c |   35 ++++++++++-------------------------
 1 files changed, 10 insertions(+), 25 deletions(-)

diff --git a/drivers/w1/w1.c b/drivers/w1/w1.c
index 5053bc8..c008493 100644
--- a/drivers/w1/w1.c
+++ b/drivers/w1/w1.c
@@ -104,35 +104,20 @@ static ssize_t w1_slave_read_name(struct device *dev,=
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
+	ssize_t count=3Dsizeof(sl->reg_num);
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
@@ -642,7 +627,7 @@ static int __w1_attach_slave_device(struct w1_slave *sl)
 	}
=20
 	/* Create "id" entry */
-	err =3D sysfs_create_bin_file(&sl->dev.kobj, &w1_slave_attr_bin_id);
+	err =3D device_create_file(&sl->dev, &w1_slave_attr_id);
 	if (err < 0) {
 		dev_err(&sl->dev,
 			"sysfs file creation for [%s] failed. err=3D%d\n",
@@ -664,7 +649,7 @@ static int __w1_attach_slave_device(struct w1_slave *sl)
 	return 0;
=20
 out_rem2:
-	sysfs_remove_bin_file(&sl->dev.kobj, &w1_slave_attr_bin_id);
+	device_remove_file(&sl->dev, &w1_slave_attr_id);
 out_rem1:
 	device_remove_file(&sl->dev, &w1_slave_attr_name);
 out_unreg:
@@ -746,7 +731,7 @@ void w1_slave_detach(struct w1_slave *sl)
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

--mrJd9p1Ce66CJMxE
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQFIApQZAI852cse6PARAhizAJ4zM5rBUBd3eARCeohGhDgzE+epQACgkhpm
TUvXowqNChfMxquz3vNZMBc=
=eWb/
-----END PGP SIGNATURE-----

--mrJd9p1Ce66CJMxE--
