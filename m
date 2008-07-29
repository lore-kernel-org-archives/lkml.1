Return-Path: <linux-kernel-owner+w=401wt.eu-S1754480AbYG2CVh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754480AbYG2CVh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2008 22:21:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753461AbYG2CVZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jul 2008 22:21:25 -0400
Received: from SpacedOut.fries.net ([67.64.210.234]:50110 "EHLO
	SpacedOut.fries.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752918AbYG2CVY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2008 22:21:24 -0400
Date: Mon, 28 Jul 2008 21:21:19 -0500
From: David Fries <david@fries.net>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Subject: [PATCH 12/30] W1: w1_therm fix user buffer overflow and cat
Message-ID: <20080729022119.GL24452@spacedout.fries.net>
References: <20080729020433.GA24424@spacedout.fries.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="w2xx78T4DcG3O+DJ"
Content-Disposition: inline
In-Reply-To: <20080729020433.GA24424@spacedout.fries.net>
User-Agent: Mutt/1.5.4i
X-Greylist: Sender is SPF-compliant, not delayed by milter-greylist-3.0 (SpacedOut.fries.net [127.0.0.1]); Mon, 28 Jul 2008 21:21:19 -0500 (CDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--w2xx78T4DcG3O+DJ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Fixed data reading bug by replacing binary attribute with device one.

Switching the sysfs read from bin_attribute to device_attribute.  The
data is far under PAGE_SIZE so the binary interface isn't required.
As the device_attribute interface will make one call to w1_therm_read per
file open and buffer, the result is, the following problems go away.

buffer overflow:
	Execute a short read on w1_slave and w1_therm_read_bin would still
	return the full string size worth of data clobbering the user space
	buffer when it returned.  Switching to device_attribute avoids the
	buffer overflow problems.  With the snprintf formatted output dealing
	with short reads without doing a conversion per read would have
	been difficult.
bad behavior:
	`cat w1_slave` would cause two temperature conversions to take place.
	Previously the code assumed W1_SLAVE_DATA_SIZE would be returned with
	each read.  It would not return 0 unless the offset was less
	than W1_SLAVE_DATA_SIZE.  The result was the first read did a
	temperature conversion, filled the buffer and returned, the
	offset in the second read would be less than
	W1_SLAVE_DATA_SIZE and also fill the buffer and return, the
	third read would finnally have a big enough offset to return 0
	and cause cat to stop.  Now w1_therm_read will be called at
	most once per open.

Signed-off-by: David Fries <david@fries.net>
Signed-off-by: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
---
 drivers/w1/slaves/w1_therm.c |   55 +++++++++++++++-----------------------=
---
 drivers/w1/w1.h              |    1 -
 2 files changed, 20 insertions(+), 36 deletions(-)

diff --git a/drivers/w1/slaves/w1_therm.c b/drivers/w1/slaves/w1_therm.c
index e87f464..7de99df 100644
--- a/drivers/w1/slaves/w1_therm.c
+++ b/drivers/w1/slaves/w1_therm.c
@@ -50,26 +50,20 @@ static u8 bad_roms[][9] =3D {
 				{}
 			};
=20
-static ssize_t w1_therm_read_bin(struct kobject *, struct bin_attribute *,
-				 char *, loff_t, size_t);
+static ssize_t w1_therm_read(struct device *device,
+	struct device_attribute *attr, char *buf);
=20
-static struct bin_attribute w1_therm_bin_attr =3D {
-	.attr =3D {
-		.name =3D "w1_slave",
-		.mode =3D S_IRUGO,
-	},
-	.size =3D W1_SLAVE_DATA_SIZE,
-	.read =3D w1_therm_read_bin,
-};
+static struct device_attribute w1_therm_attr =3D
+	__ATTR(w1_slave, S_IRUGO, w1_therm_read, NULL);
=20
 static int w1_therm_add_slave(struct w1_slave *sl)
 {
-	return sysfs_create_bin_file(&sl->dev.kobj, &w1_therm_bin_attr);
+	return device_create_file(&sl->dev, &w1_therm_attr);
 }
=20
 static void w1_therm_remove_slave(struct w1_slave *sl)
 {
-	sysfs_remove_bin_file(&sl->dev.kobj, &w1_therm_bin_attr);
+	device_remove_file(&sl->dev, &w1_therm_attr);
 }
=20
 static struct w1_family_ops w1_therm_fops =3D {
@@ -168,30 +162,19 @@ static int w1_therm_check_rom(u8 rom[9])
 	return 0;
 }
=20
-static ssize_t w1_therm_read_bin(struct kobject *kobj,
-				 struct bin_attribute *bin_attr,
-				 char *buf, loff_t off, size_t count)
+static ssize_t w1_therm_read(struct device *device,
+	struct device_attribute *attr, char *buf)
 {
-	struct w1_slave *sl =3D kobj_to_w1_slave(kobj);
+	struct w1_slave *sl =3D dev_to_w1_slave(device);
 	struct w1_master *dev =3D sl->master;
 	u8 rom[9], crc, verdict;
 	int i, max_trying =3D 10;
+	ssize_t c =3D PAGE_SIZE;
=20
 	mutex_lock(&sl->master->mutex);
=20
-	if (off > W1_SLAVE_DATA_SIZE) {
-		count =3D 0;
-		goto out;
-	}
-	if (off + count > W1_SLAVE_DATA_SIZE) {
-		count =3D 0;
-		goto out;
-	}
-
-	memset(buf, 0, count);
 	memset(rom, 0, sizeof(rom));
=20
-	count =3D 0;
 	verdict =3D 0;
 	crc =3D 0;
=20
@@ -211,7 +194,9 @@ static ssize_t w1_therm_read_bin(struct kobject *kobj,
=20
 				w1_write_8(dev, W1_READ_SCRATCHPAD);
 				if ((count =3D w1_read_block(dev, rom, 9)) !=3D 9) {
-					dev_warn(&dev->dev, "w1_read_block() returned %d instead of 9.\n", co=
unt);
+					dev_warn(device, "w1_read_block() "
+						"returned %u instead of 9.\n",
+						count);
 				}
=20
 				crc =3D w1_calc_crc8(rom, 8);
@@ -226,22 +211,22 @@ static ssize_t w1_therm_read_bin(struct kobject *kobj,
 	}
=20
 	for (i =3D 0; i < 9; ++i)
-		count +=3D sprintf(buf + count, "%02x ", rom[i]);
-	count +=3D sprintf(buf + count, ": crc=3D%02x %s\n",
+		c -=3D snprintf(buf + PAGE_SIZE - c, c, "%02x ", rom[i]);
+	c -=3D snprintf(buf + PAGE_SIZE - c, c, ": crc=3D%02x %s\n",
 			   crc, (verdict) ? "YES" : "NO");
 	if (verdict)
 		memcpy(sl->rom, rom, sizeof(sl->rom));
 	else
-		dev_warn(&dev->dev, "18S20 doesn't respond to CONVERT_TEMP.\n");
+		dev_warn(device, "18S20 doesn't respond to CONVERT_TEMP.\n");
=20
 	for (i =3D 0; i < 9; ++i)
-		count +=3D sprintf(buf + count, "%02x ", sl->rom[i]);
+		c -=3D snprintf(buf + PAGE_SIZE - c, c, "%02x ", sl->rom[i]);
=20
-	count +=3D sprintf(buf + count, "t=3D%d\n", w1_convert_temp(rom, sl->fami=
ly->fid));
-out:
+	c -=3D snprintf(buf + PAGE_SIZE - c, c, "t=3D%d\n",
+		w1_convert_temp(rom, sl->family->fid));
 	mutex_unlock(&dev->mutex);
=20
-	return count;
+	return PAGE_SIZE - c;
 }
=20
 static int __init w1_therm_init(void)
diff --git a/drivers/w1/w1.h b/drivers/w1/w1.h
index 00b84ab..cdaa6ff 100644
--- a/drivers/w1/w1.h
+++ b/drivers/w1/w1.h
@@ -46,7 +46,6 @@ struct w1_reg_num
 #include "w1_family.h"
=20
 #define W1_MAXNAMELEN		32
-#define W1_SLAVE_DATA_SIZE	128
=20
 #define W1_SEARCH		0xF0
 #define W1_ALARM_SEARCH		0xEC
--=20
1.4.4.4

--w2xx78T4DcG3O+DJ
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQFIjn6fAI852cse6PARAn6fAKCNd7+gx3EA84j6YRsdRK5f0i6jVgCaA7kU
jF0cX3f3mG0YuV7wbaTa4vA=
=7Y4E
-----END PGP SIGNATURE-----

--w2xx78T4DcG3O+DJ--
