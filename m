Return-Path: <linux-kernel-owner+w=401wt.eu-S1759065AbYC1M5g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759065AbYC1M5g (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2008 08:57:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758459AbYC1Mza
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Mar 2008 08:55:30 -0400
Received: from SpacedOut.fries.net ([67.64.210.234]:34541 "EHLO
	SpacedOut.fries.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756925AbYC1Mz2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2008 08:55:28 -0400
Date: Fri, 28 Mar 2008 07:25:04 -0500
From: David Fries <david@fries.net>
To: linux-kernel@vger.kernel.org
Cc: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Subject: [PATCH 7/35] W1: feature, enable hardware strong pullup
Message-ID: <20080328122504.GH3613@spacedout.fries.net>
References: <200803272343.m2RNhDac017650@SpacedOut.fries.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="NzX0AQGjRQPusK/O"
Content-Disposition: inline
In-Reply-To: <200803272343.m2RNhDac017650@SpacedOut.fries.net>
User-Agent: Mutt/1.5.4i
X-Greylist: Sender is SPF-compliant, not delayed by milter-greylist-3.0 (SpacedOut.fries.net [127.0.0.1]); Fri, 28 Mar 2008 07:25:04 -0500 (CDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--NzX0AQGjRQPusK/O
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

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

w1.h 1.2 1.3 1.4
Add set_pullup to w1_bus_master, and add pullup_duration to w1_master
to hold the strong pullup duration for the next write operation.

w1_int.c 1.3
Add a check to disable set_pullup and print a warning message when the
operation isn't supported.

w1_io.c 1.2 1.3 1.4 1.6
Add w1_next_pullup, call w1_pre_write and w1_post_write to call
set_pullup before and after, or just sleep after if set_pullup isn't
supported.

Signed-off-by: David Fries <david@fries.net>
---
 drivers/w1/w1.h     |   10 +++++++
 drivers/w1/w1_int.c |   12 +++++++++
 drivers/w1/w1_io.c  |   66 +++++++++++++++++++++++++++++++++++++++++++++++=
---
 3 files changed, 84 insertions(+), 4 deletions(-)

diff --git a/drivers/w1/w1.h b/drivers/w1/w1.h
index c47ca1e..bad7c7c 100644
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
@@ -167,6 +173,9 @@ struct w1_master
 	void			*priv;
 	int			priv_size;
=20
+	/** Strong pullup duration in milliseconds, zero disabled. */
+	int			pullup_duration;
+
 	struct task_struct	*thread;
 	struct mutex		mutex;
=20
@@ -201,6 +210,7 @@ u8 w1_calc_crc8(u8 *, int);
 void w1_write_block(struct w1_master *, const u8 *, int);
 u8 w1_read_block(struct w1_master *, u8 *, int);
 int w1_reset_select_slave(struct w1_slave *sl);
+void w1_next_pullup(struct w1_master *, int);
=20
 static inline struct w1_slave* dev_to_w1_slave(struct device *dev)
 {
diff --git a/drivers/w1/w1_int.c b/drivers/w1/w1_int.c
index 3388d8f..932a242 100644
--- a/drivers/w1/w1_int.c
+++ b/drivers/w1/w1_int.c
@@ -107,6 +107,18 @@ int w1_add_master_device(struct w1_bus_master *master)
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
index 0056ef6..46c6994 100644
--- a/drivers/w1/w1_io.c
+++ b/drivers/w1/w1_io.c
@@ -93,6 +93,38 @@ static void w1_write_bit(struct w1_master *dev, int bit)
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
+	if(dev->pullup_duration && dev->bus_master->set_pullup)
+		dev->bus_master->set_pullup(dev->bus_master->data,
+			dev->pullup_duration);
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
+		if(dev->bus_master->set_pullup)
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
@@ -102,11 +134,17 @@ void w1_write_8(struct w1_master *dev, u8 byte)
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
@@ -203,11 +241,14 @@ void w1_write_block(struct w1_master *dev, const u8 *=
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
@@ -306,3 +347,20 @@ int w1_reset_select_slave(struct w1_slave *sl)
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

--NzX0AQGjRQPusK/O
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQFH7OOgAI852cse6PARAgKAAJ9jTzVgjnnnlbJ38WdludaEZiGbFQCeOxSi
q6h7qaoU5XAcx3J8cvKwHd8=
=aqF1
-----END PGP SIGNATURE-----

--NzX0AQGjRQPusK/O--
