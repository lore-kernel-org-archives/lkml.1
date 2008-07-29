Return-Path: <linux-kernel-owner+w=401wt.eu-S1755009AbYG2CR3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755009AbYG2CR3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2008 22:17:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752481AbYG2CRU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jul 2008 22:17:20 -0400
Received: from SpacedOut.fries.net ([67.64.210.234]:48733 "EHLO
	SpacedOut.fries.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752003AbYG2CRT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2008 22:17:19 -0400
Date: Mon, 28 Jul 2008 21:17:14 -0500
From: David Fries <david@fries.net>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Subject: [PATCH 7/30] W1: be able to manually add and remove slaves
Message-ID: <20080729021714.GG24452@spacedout.fries.net>
References: <20080729020433.GA24424@spacedout.fries.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="tvOENZuN7d6HfOWU"
Content-Disposition: inline
In-Reply-To: <20080729020433.GA24424@spacedout.fries.net>
User-Agent: Mutt/1.5.4i
X-Greylist: Sender is SPF-compliant, not delayed by milter-greylist-3.0 (SpacedOut.fries.net [127.0.0.1]); Mon, 28 Jul 2008 21:17:14 -0500 (CDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--tvOENZuN7d6HfOWU
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

sysfs entries were added to manually add and remove slave devices.
This is useful if the automatic bus searching is disabled, and the
device ids are already known.

Signed-off-by: David Fries <david@fries.net>
Signed-off-by: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
---
 drivers/w1/w1.c |  137 +++++++++++++++++++++++++++++++++++++++++++++++++++=
+++-
 1 files changed, 136 insertions(+), 1 deletions(-)

diff --git a/drivers/w1/w1.c b/drivers/w1/w1.c
index 76274ae..24312e0 100644
--- a/drivers/w1/w1.c
+++ b/drivers/w1/w1.c
@@ -56,6 +56,8 @@ module_param_named(slave_ttl, w1_max_slave_ttl, int, 0);
 DEFINE_MUTEX(w1_mlock);
 LIST_HEAD(w1_masters);
=20
+static int w1_attach_slave_device(struct w1_master *dev, struct w1_reg_num=
 *rn);
+
 static int w1_master_match(struct device *dev, struct device_driver *drv)
 {
 	return 1;
@@ -349,7 +351,8 @@ static ssize_t w1_master_attribute_show_slave_count(str=
uct device *dev, struct d
 	return count;
 }
=20
-static ssize_t w1_master_attribute_show_slaves(struct device *dev, struct =
device_attribute *attr, char *buf)
+static ssize_t w1_master_attribute_show_slaves(struct device *dev,
+	struct device_attribute *attr, char *buf)
 {
 	struct w1_master *md =3D dev_to_w1_master(dev);
 	int c =3D PAGE_SIZE;
@@ -374,6 +377,134 @@ static ssize_t w1_master_attribute_show_slaves(struct=
 device *dev, struct device
 	return PAGE_SIZE - c;
 }
=20
+static ssize_t w1_master_attribute_show_add(struct device *dev,
+	struct device_attribute *attr, char *buf)
+{
+	int c =3D PAGE_SIZE;
+	c -=3D snprintf(buf+PAGE_SIZE - c, c,
+		"write device id xx-xxxxxxxxxxxx to add slave\n");
+	return PAGE_SIZE - c;
+}
+
+static int w1_atoreg_num(struct device *dev, const char *buf, size_t count,
+	struct w1_reg_num *rn)
+{
+	unsigned int family;
+	u64 id;
+	int i;
+	u64 rn64_le;
+	/* The CRC value isn't read from the user because the sysfs directory
+	 * doesn't include it and most messages from the bus search don't
+	 * print it either.  It would be unreasonable for the user to then
+	 * provide it.
+	 */
+	const char *error_msg =3D "bad slave string format, expecting "
+		"ff-dddddddddddd\n";
+
+	if (buf[2] !=3D '-') {
+		dev_err(dev, "%s", error_msg);
+		return -EINVAL;
+	}
+	i =3D sscanf(buf, "%02x-%012llx", &family, &id);
+	if (i !=3D 2) {
+		dev_err(dev, "%s", error_msg);
+		return -EINVAL;
+	}
+	rn->family =3D family;
+	rn->id =3D id;
+
+	rn64_le =3D cpu_to_le64(*(u64 *)rn);
+	rn->crc =3D w1_calc_crc8((u8 *)&rn64_le, 7);
+
+	#if 0
+	dev_info(dev, "With CRC device is %02x.%012llx.%02x.\n",
+		  rn->family, (unsigned long long)rn->id, rn->crc);
+	#endif
+
+	return 0;
+}
+
+/* Searches the slaves in the w1_master and returns a pointer or NULL.
+ * Note: must hold the mutex
+ */
+static struct w1_slave *w1_slave_search_device(struct w1_master *dev,
+	struct w1_reg_num *rn)
+{
+	struct w1_slave *sl;
+	list_for_each_entry(sl, &dev->slist, w1_slave_entry) {
+		if (sl->reg_num.family =3D=3D rn->family &&
+				sl->reg_num.id =3D=3D rn->id &&
+				sl->reg_num.crc =3D=3D rn->crc) {
+			return sl;
+		}
+	}
+	return NULL;
+}
+
+static ssize_t w1_master_attribute_store_add(struct device *dev,
+						struct device_attribute *attr,
+						const char *buf, size_t count)
+{
+	struct w1_master *md =3D dev_to_w1_master(dev);
+	struct w1_reg_num rn;
+	struct w1_slave *sl;
+	ssize_t result =3D count;
+
+	if (w1_atoreg_num(dev, buf, count, &rn))
+		return -EINVAL;
+
+	mutex_lock(&md->mutex);
+	sl =3D w1_slave_search_device(md, &rn);
+	/* It would be nice to do a targeted search one the one-wire bus
+	 * for the new device to see if it is out there or not.  But the
+	 * current search doesn't support that.
+	 */
+	if (sl) {
+		dev_info(dev, "Device %s already exists\n", sl->name);
+		result =3D -EINVAL;
+	} else {
+		w1_attach_slave_device(md, &rn);
+	}
+	mutex_unlock(&md->mutex);
+
+	return result;
+}
+
+static ssize_t w1_master_attribute_show_remove(struct device *dev,
+	struct device_attribute *attr, char *buf)
+{
+	int c =3D PAGE_SIZE;
+	c -=3D snprintf(buf+PAGE_SIZE - c, c,
+		"write device id xx-xxxxxxxxxxxx to remove slave\n");
+	return PAGE_SIZE - c;
+}
+
+static ssize_t w1_master_attribute_store_remove(struct device *dev,
+						struct device_attribute *attr,
+						const char *buf, size_t count)
+{
+	struct w1_master *md =3D dev_to_w1_master(dev);
+	struct w1_reg_num rn;
+	struct w1_slave *sl;
+	ssize_t result =3D count;
+
+	if (w1_atoreg_num(dev, buf, count, &rn))
+		return -EINVAL;
+
+	mutex_lock(&md->mutex);
+	sl =3D w1_slave_search_device(md, &rn);
+	if (sl) {
+		w1_slave_detach(sl);
+	} else {
+		dev_info(dev, "Device %02x-%012llx doesn't exists\n", rn.family,
+			(unsigned long long)rn.id);
+		result =3D -EINVAL;
+	}
+	mutex_unlock(&md->mutex);
+
+	return result;
+}
+
 #define W1_MASTER_ATTR_RO(_name, _mode)				\
 	struct device_attribute w1_master_attribute_##_name =3D	\
 		__ATTR(w1_master_##_name, _mode,		\
@@ -394,6 +525,8 @@ static W1_MASTER_ATTR_RO(timeout, S_IRUGO);
 static W1_MASTER_ATTR_RO(pointer, S_IRUGO);
 static W1_MASTER_ATTR_RW(search, S_IRUGO | S_IWUGO);
 static W1_MASTER_ATTR_RW(pullup, S_IRUGO | S_IWUGO);
+static W1_MASTER_ATTR_RW(add, S_IRUGO | S_IWUGO);
+static W1_MASTER_ATTR_RW(remove, S_IRUGO | S_IWUGO);
=20
 static struct attribute *w1_master_default_attrs[] =3D {
 	&w1_master_attribute_name.attr,
@@ -405,6 +538,8 @@ static struct attribute *w1_master_default_attrs[] =3D {
 	&w1_master_attribute_pointer.attr,
 	&w1_master_attribute_search.attr,
 	&w1_master_attribute_pullup.attr,
+	&w1_master_attribute_add.attr,
+	&w1_master_attribute_remove.attr,
 	NULL
 };
=20
--=20
1.4.4.4

--tvOENZuN7d6HfOWU
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQFIjn2pAI852cse6PARAgBuAJ9oMmHujXBgdXv5cqkCRNvbTU+ftQCgkwzT
qjealbLWqhS7m7bIyQkCoI0=
=F9NT
-----END PGP SIGNATURE-----

--tvOENZuN7d6HfOWU--
