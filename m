Return-Path: <linux-kernel-owner+w=401wt.eu-S1756027AbYDMXOo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756027AbYDMXOo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Apr 2008 19:14:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752870AbYDMXOg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Apr 2008 19:14:36 -0400
Received: from SpacedOut.fries.net ([67.64.210.234]:49149 "EHLO
	SpacedOut.fries.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752750AbYDMXOf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Apr 2008 19:14:35 -0400
Date: Sun, 13 Apr 2008 18:14:33 -0500
From: David Fries <david@fries.net>
To: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 7/33 replaces 7/35] W1: feature, enable hardware strong pullup
Message-ID: <20080413231433.GA15213@spacedout.fries.net>
References: <20080413225632.GA14058@spacedout.fries.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="HlL+5n6rz5pIUxbD"
Content-Disposition: inline
In-Reply-To: <20080413225632.GA14058@spacedout.fries.net>
User-Agent: Mutt/1.5.4i
X-Greylist: Sender is SPF-compliant, not delayed by milter-greylist-3.0 (SpacedOut.fries.net [127.0.0.1]); Sun, 13 Apr 2008 18:14:34 -0500 (CDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--HlL+5n6rz5pIUxbD
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

Add a strong pullup option to the w1 system.  This supplies extra
power for parasite powered devices.

The one wire bus requires at a minimum one wire and ground.  The
common wire is used for sending and receiving data as well as
supplying power to devices that are parasite powered.  Temperature
sensors are one device that can be parasite powered and require no bus
transactions while the temperature conversion is progress.  A bus
transaction would pull the common wire down.  In addition to the
normal pullup resistor, which allows a device to pull the bus line
down to send data, some devices support a strong pullup mechanism to
deliver more power.  The documentation lists this as useful for larger
networks and when temperature sensors are exposed to higher
temperatures they can exceed the current supplied by a simple pullup
resistor.  This patch adds a mechanism to support a strong pullup, and
fall back to sleeping with the line high otherwise.  This patch
doesn't enable the strong pullup for any master or slave device, those
will follow as they require this patch.

The hardware USB 2490 one wire bus master has a bit on a few commands
which will enable the strong pullup as soon as the command finishes
executing.  That requires the ds2490 driver to be notified if it
should be set before the command is executed.  That's why I added the
w1_next_pullup.  That will call the master set_pullup just before the
next write, and reset the value to zero after it has completed.  If
the master driver doesn't support the set_pullup, it will delay the
appropriate amount of time after the write returns.

w1.h 1.2 1.3 1.4 1.10
Add set_pullup to w1_bus_master, and add pullup_duration to w1_master
to hold the strong pullup duration for the next write operation.  Add
enable_pullup to w1_master for a per master enable/disable option.

w1.c 1.20
Add w1_master_pullup sysfs entry.

w1_int.c 1.3 1.9
Add a check to disable set_pullup and print a warning message when the
operation isn't supported.  Add enable_pullup module parameter.

w1_io.c 1.2 1.3 1.4 1.6
Add w1_next_pullup, call w1_pre_write and w1_post_write to call
set_pullup before and after, or just sleep after if set_pullup isn't
supported.

Signed-off-by: David Fries <david@fries.net>
---
 drivers/w1/w1.c     |   30 ++++++++++++++++++++++
 drivers/w1/w1.h     |   12 +++++++++
 drivers/w1/w1_int.c |   16 ++++++++++++
 drivers/w1/w1_io.c  |   68 +++++++++++++++++++++++++++++++++++++++++++++++=
+---
 4 files changed, 122 insertions(+), 4 deletions(-)

diff --git a/drivers/w1/w1.c b/drivers/w1/w1.c
index 5d8c2c7..401c56a 100644
--- a/drivers/w1/w1.c
+++ b/drivers/w1/w1.c
@@ -270,6 +270,34 @@ static ssize_t w1_master_attribute_show_search(struct =
device *dev,
 	return count;
 }
=20
+static ssize_t w1_master_attribute_store_pullup(struct device * dev,
+						struct device_attribute *attr,
+						const char * buf, size_t count)
+{
+	struct w1_master *md =3D dev_to_w1_master(dev);
+
+	mutex_lock(&md->mutex);
+	md->enable_pullup =3D simple_strtol(buf, NULL, 0);
+	mutex_unlock(&md->mutex);
+	wake_up_process(md->thread);
+
+	return count;
+}
+
+static ssize_t w1_master_attribute_show_pullup(struct device *dev,
+					       struct device_attribute *attr,
+					       char *buf)
+{
+	struct w1_master *md =3D dev_to_w1_master(dev);
+	ssize_t count;
+
+	mutex_lock(&md->mutex);
+	count =3D sprintf(buf, "%d\n", md->enable_pullup);
+	mutex_unlock(&md->mutex);
+
+	return count;
+}
+
 static ssize_t w1_master_attribute_show_pointer(struct device *dev, struct=
 device_attribute *attr, char *buf)
 {
 	struct w1_master *md =3D dev_to_w1_master(dev);
@@ -365,6 +393,7 @@ static W1_MASTER_ATTR_RO(attempts, S_IRUGO);
 static W1_MASTER_ATTR_RO(timeout, S_IRUGO);
 static W1_MASTER_ATTR_RO(pointer, S_IRUGO);
 static W1_MASTER_ATTR_RW(search, S_IRUGO | S_IWUGO);
+static W1_MASTER_ATTR_RW(pullup, S_IRUGO | S_IWUGO);
=20
 static struct attribute *w1_master_default_attrs[] =3D {
 	&w1_master_attribute_name.attr,
@@ -375,6 +404,7 @@ static struct attribute *w1_master_default_attrs[] =3D {
 	&w1_master_attribute_timeout.attr,
 	&w1_master_attribute_pointer.attr,
 	&w1_master_attribute_search.attr,
+	&w1_master_attribute_pullup.attr,
 	NULL
 };
=20
diff --git a/drivers/w1/w1.h b/drivers/w1/w1.h
index c47ca1e..83d8208 100644
--- a/drivers/w1/w1.h
+++ b/drivers/w1/w1.h
@@ -142,6 +142,12 @@ struct w1_bus_master
 	 */
 	u8		(*reset_bus)(void *);
=20
+	/**
+	 * Put out a strong pull-up pulse of the specified duration.
+	 * @return -1=3DError, 0=3Dcompleted
+	 */
+	u8		(*set_pullup)(void *, int);
+
 	/** Really nice hardware can handles the different types of ROM search
 	 *  w1_master* is passed to the slave found callback.
 	 */
@@ -167,6 +173,11 @@ struct w1_master
 	void			*priv;
 	int			priv_size;
=20
+	/** 5V strong pullup enabled flag, 1 enabled, zero disabled. */
+	int			enable_pullup;
+	/** 5V strong pullup duration in milliseconds, zero disabled. */
+	int			pullup_duration;
+
 	struct task_struct	*thread;
 	struct mutex		mutex;
=20
@@ -201,6 +212,7 @@ u8 w1_calc_crc8(u8 *, int);
 void w1_write_block(struct w1_master *, const u8 *, int);
 u8 w1_read_block(struct w1_master *, u8 *, int);
 int w1_reset_select_slave(struct w1_slave *sl);
+void w1_next_pullup(struct w1_master *, int);
=20
 static inline struct w1_slave* dev_to_w1_slave(struct device *dev)
 {
diff --git a/drivers/w1/w1_int.c b/drivers/w1/w1_int.c
index 3388d8f..8deb76c 100644
--- a/drivers/w1/w1_int.c
+++ b/drivers/w1/w1_int.c
@@ -31,6 +31,9 @@
=20
 static u32 w1_ids =3D 1;
=20
+static int w1_enable_pullup =3D 1;
+module_param_named(enable_pullup, w1_enable_pullup, int, 0);
+
 static struct w1_master * w1_alloc_dev(u32 id, int slave_count, int slave_=
ttl,
 				       struct device_driver *driver,
 				       struct device *device)
@@ -59,6 +62,7 @@ static struct w1_master * w1_alloc_dev(u32 id, int slave_=
count, int slave_ttl,
 	dev->initialized	=3D 0;
 	dev->id			=3D id;
 	dev->slave_ttl		=3D slave_ttl;
+	dev->enable_pullup	=3D w1_enable_pullup;
         dev->search_count	=3D -1; /* continual scan */
=20
 	/* 1 for w1_process to decrement
@@ -107,6 +111,18 @@ int w1_add_master_device(struct w1_bus_master *master)
 		printk(KERN_ERR "w1_add_master_device: invalid function set\n");
 		return(-EINVAL);
         }
+	/* While it would be electrically possible to make a device that
+	 * generated a strong pullup in bit bang mode, only hardare that
+	 * controls 1-wire time frames are even expected to support a strong
+	 * pullup.  w1_io.c would need to support calling set_pullup before
+	 * the last write_bit operation of a w1_write_8 which it currently
+	 * doesn't.
+	 */
+	if(!master->write_byte && !master->touch_bit && master->set_pullup) {
+		printk(KERN_ERR "w1_add_master_device: set_pullup requires "
+			"write_byte or touch_bit, disabling\n");
+		master->set_pullup=3DNULL;
+	}
=20
 	dev =3D w1_alloc_dev(w1_ids++, w1_max_slave_count, w1_max_slave_ttl, &w1_=
master_driver, &w1_master_device);
 	if (!dev)
diff --git a/drivers/w1/w1_io.c b/drivers/w1/w1_io.c
index 0056ef6..3cdac8b 100644
--- a/drivers/w1/w1_io.c
+++ b/drivers/w1/w1_io.c
@@ -93,6 +93,40 @@ static void w1_write_bit(struct w1_master *dev, int bit)
 }
=20
 /**
+ * Pre-write operation, currently only supporting strong pullups.
+ * Program the hardware for a strong pullup, if one has been requested and
+ * the hardware supports it.
+ *
+ * @param dev     the master device
+ */
+static void w1_pre_write(struct w1_master *dev)
+{
+	if(dev->pullup_duration &&
+		dev->enable_pullup && dev->bus_master->set_pullup) {
+		dev->bus_master->set_pullup(dev->bus_master->data,
+			dev->pullup_duration);
+	}
+}
+
+/**
+ * Post-write operation, currently only supporting strong pullups.
+ * If a strong pullup was requested, clear it if the hardware supports
+ * them, or execute the delay otherwise, in either case clear the request.
+ *
+ * @param dev     the master device
+ */
+static void w1_post_write(struct w1_master *dev)
+{
+	if(dev->pullup_duration) {
+		if(dev->enable_pullup && dev->bus_master->set_pullup)
+			dev->bus_master->set_pullup(dev->bus_master->data, 0);
+		else
+			msleep(dev->pullup_duration);
+		dev->pullup_duration=3D0;
+	}
+}
+
+/**
  * Writes 8 bits.
  *
  * @param dev     the master device
@@ -102,11 +136,17 @@ void w1_write_8(struct w1_master *dev, u8 byte)
 {
 	int i;
=20
-	if (dev->bus_master->write_byte)
+	if (dev->bus_master->write_byte) {
+		w1_pre_write(dev);
 		dev->bus_master->write_byte(dev->bus_master->data, byte);
+	}
 	else
-		for (i =3D 0; i < 8; ++i)
+		for (i =3D 0; i < 8; ++i) {
+			if(i=3D=3D7)
+				w1_pre_write(dev);
 			w1_touch_bit(dev, (byte >> i) & 0x1);
+		}
+	w1_post_write(dev);
 }
 EXPORT_SYMBOL_GPL(w1_write_8);
=20
@@ -203,11 +243,14 @@ void w1_write_block(struct w1_master *dev, const u8 *=
buf, int len)
 {
 	int i;
=20
-	if (dev->bus_master->write_block)
+	if (dev->bus_master->write_block) {
+		w1_pre_write(dev);
 		dev->bus_master->write_block(dev->bus_master->data, buf, len);
+	}
 	else
 		for (i =3D 0; i < len; ++i)
-			w1_write_8(dev, buf[i]);
+			w1_write_8(dev, buf[i]); // calls w1_pre_write
+	w1_post_write(dev);
 }
 EXPORT_SYMBOL_GPL(w1_write_block);
=20
@@ -306,3 +349,20 @@ int w1_reset_select_slave(struct w1_slave *sl)
 	return 0;
 }
 EXPORT_SYMBOL_GPL(w1_reset_select_slave);
+
+/**
+ * Put out a strong pull-up of the specified duration after the next write
+ * operation.  Not all hardware supports strong pullups.  Hardware that
+ * doesn't support strong pullups will sleep for the given time after the
+ * write operation without a strong pullup.  This is a one shot request for
+ * the next write, specifying zero will clear a previous request.
+ * The w1 master lock must be held.
+ *
+ * @param delay	time in milliseconds
+ * @return	0=3Dsuccess, anything else=3Derror
+ */
+void w1_next_pullup(struct w1_master *dev, int delay)
+{
+	dev->pullup_duration=3Ddelay;
+}
+EXPORT_SYMBOL_GPL(w1_next_pullup);
--=20
1.4.4.4

--HlL+5n6rz5pIUxbD
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQFIApPZAI852cse6PARApYAAJ9ZobZa9ZS54spmH3hYVXsf21z5SACfQybo
LTkBl+s1APjbzEEKoBhheR4=
=P0nJ
-----END PGP SIGNATURE-----

--HlL+5n6rz5pIUxbD--
