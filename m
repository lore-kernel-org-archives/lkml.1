Return-Path: <linux-kernel-owner+w=401wt.eu-S1760055AbYGKNtX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760055AbYGKNtX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2008 09:49:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759423AbYGKNrz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jul 2008 09:47:55 -0400
Received: from zbr.yandex.ru ([213.180.219.33]:34974 "EHLO gavana.yandex.ru"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758178AbYGKNru (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2008 09:47:50 -0400
From: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>, David Fries <david@fries.net>,
       Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Subject: [PATCH 5/30] W1: feature, enable hardware strong pullup
Date: Fri, 11 Jul 2008 17:51:20 +0400
Message-Id: <12157843051033-git-send-email-johnpol@2ka.mipt.ru>
X-Mailer: git-send-email 1.5.2.5
In-Reply-To: <12157843054074-git-send-email-johnpol@2ka.mipt.ru>
References: <12157843054074-git-send-email-johnpol@2ka.mipt.ru>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a strong pullup option to the w1 system.  This supplies extra
power for parasite powered devices.  There is a w1_master_pullup sysfs
entry and enable_pullup module parameter to enable or disable the
strong pullup.

The one wire bus requires at a minimum one wire and ground.  The
common wire is used for sending and receiving data as well as
supplying power to devices that are parasite powered of which
temperature sensors can be one example.  The bus must be idle and left
high while a temperature conversion is in progress, in addition the
normal pullup resister on larger networks or even higher temperatures
might not supply enough power.  The pullup resister can't provide too
much pullup current, because devices need to pull the bus down to
write a value.  This enables the strong pullup for supported hardware,
which can supply more current when requested.  Unsupported hardware
will just delay with the bus high.

The hardware USB 2490 one wire bus master has a bit on some commands
which will enable the strong pullup as soon as the command finishes
executing.  To use strong pullup, call the new w1_next_pullup function
to register the duration.  The next write command will call set_pullup
before sending the data, and reset the duration to zero once it
returns.

Signed-off-by: David Fries <david@fries.net>
Signed-off-by: Evgeniy Polyakov <johnpol@2ka.mipt.ru>

---
 drivers/w1/w1.c     |   30 ++++++++++++++++++++++
 drivers/w1/w1.h     |   12 +++++++++
 drivers/w1/w1_int.c |   16 ++++++++++++
 drivers/w1/w1_io.c  |   68 ++++++++++++++++++++++++++++++++++++++++++++++++---
 4 files changed, 122 insertions(+), 4 deletions(-)

diff --git a/drivers/w1/w1.c b/drivers/w1/w1.c
index 9b5c117..76274ae 100644
--- a/drivers/w1/w1.c
+++ b/drivers/w1/w1.c
@@ -270,6 +270,34 @@ static ssize_t w1_master_attribute_show_search(struct device *dev,
 	return count;
 }
 
+static ssize_t w1_master_attribute_store_pullup(struct device *dev,
+						struct device_attribute *attr,
+						const char *buf, size_t count)
+{
+	struct w1_master *md = dev_to_w1_master(dev);
+
+	mutex_lock(&md->mutex);
+	md->enable_pullup = simple_strtol(buf, NULL, 0);
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
+	struct w1_master *md = dev_to_w1_master(dev);
+	ssize_t count;
+
+	mutex_lock(&md->mutex);
+	count = sprintf(buf, "%d\n", md->enable_pullup);
+	mutex_unlock(&md->mutex);
+
+	return count;
+}
+
 static ssize_t w1_master_attribute_show_pointer(struct device *dev, struct device_attribute *attr, char *buf)
 {
 	struct w1_master *md = dev_to_w1_master(dev);
@@ -365,6 +393,7 @@ static W1_MASTER_ATTR_RO(attempts, S_IRUGO);
 static W1_MASTER_ATTR_RO(timeout, S_IRUGO);
 static W1_MASTER_ATTR_RO(pointer, S_IRUGO);
 static W1_MASTER_ATTR_RW(search, S_IRUGO | S_IWUGO);
+static W1_MASTER_ATTR_RW(pullup, S_IRUGO | S_IWUGO);
 
 static struct attribute *w1_master_default_attrs[] = {
 	&w1_master_attribute_name.attr,
@@ -375,6 +404,7 @@ static struct attribute *w1_master_default_attrs[] = {
 	&w1_master_attribute_timeout.attr,
 	&w1_master_attribute_pointer.attr,
 	&w1_master_attribute_search.attr,
+	&w1_master_attribute_pullup.attr,
 	NULL
 };
 
diff --git a/drivers/w1/w1.h b/drivers/w1/w1.h
index 34ee01e..00b84ab 100644
--- a/drivers/w1/w1.h
+++ b/drivers/w1/w1.h
@@ -142,6 +142,12 @@ struct w1_bus_master
 	 */
 	u8		(*reset_bus)(void *);
 
+	/**
+	 * Put out a strong pull-up pulse of the specified duration.
+	 * @return -1=Error, 0=completed
+	 */
+	u8		(*set_pullup)(void *, int);
+
 	/** Really nice hardware can handles the different types of ROM search
 	 *  w1_master* is passed to the slave found callback.
 	 */
@@ -167,6 +173,11 @@ struct w1_master
 	void			*priv;
 	int			priv_size;
 
+	/** 5V strong pullup enabled flag, 1 enabled, zero disabled. */
+	int			enable_pullup;
+	/** 5V strong pullup duration in milliseconds, zero disabled. */
+	int			pullup_duration;
+
 	struct task_struct	*thread;
 	struct mutex		mutex;
 
@@ -201,6 +212,7 @@ u8 w1_calc_crc8(u8 *, int);
 void w1_write_block(struct w1_master *, const u8 *, int);
 u8 w1_read_block(struct w1_master *, u8 *, int);
 int w1_reset_select_slave(struct w1_slave *sl);
+void w1_next_pullup(struct w1_master *, int);
 
 static inline struct w1_slave* dev_to_w1_slave(struct device *dev)
 {
diff --git a/drivers/w1/w1_int.c b/drivers/w1/w1_int.c
index bd877b2..9d723ef 100644
--- a/drivers/w1/w1_int.c
+++ b/drivers/w1/w1_int.c
@@ -31,6 +31,9 @@
 
 static u32 w1_ids = 1;
 
+static int w1_enable_pullup = 1;
+module_param_named(enable_pullup, w1_enable_pullup, int, 0);
+
 static struct w1_master * w1_alloc_dev(u32 id, int slave_count, int slave_ttl,
 				       struct device_driver *driver,
 				       struct device *device)
@@ -59,6 +62,7 @@ static struct w1_master * w1_alloc_dev(u32 id, int slave_count, int slave_ttl,
 	dev->initialized	= 0;
 	dev->id			= id;
 	dev->slave_ttl		= slave_ttl;
+	dev->enable_pullup	= w1_enable_pullup;
         dev->search_count	= -1; /* continual scan */
 
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
+	if (!master->write_byte && !master->touch_bit && master->set_pullup) {
+		printk(KERN_ERR "w1_add_master_device: set_pullup requires "
+			"write_byte or touch_bit, disabling\n");
+		master->set_pullup = NULL;
+	}
 
 	dev = w1_alloc_dev(w1_ids++, w1_max_slave_count, w1_max_slave_ttl, &w1_master_driver, &w1_master_device);
 	if (!dev)
diff --git a/drivers/w1/w1_io.c b/drivers/w1/w1_io.c
index 0056ef6..a2f0d5f 100644
--- a/drivers/w1/w1_io.c
+++ b/drivers/w1/w1_io.c
@@ -93,6 +93,40 @@ static void w1_write_bit(struct w1_master *dev, int bit)
 }
 
 /**
+ * Pre-write operation, currently only supporting strong pullups.
+ * Program the hardware for a strong pullup, if one has been requested and
+ * the hardware supports it.
+ *
+ * @param dev     the master device
+ */
+static void w1_pre_write(struct w1_master *dev)
+{
+	if (dev->pullup_duration &&
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
+	if (dev->pullup_duration) {
+		if (dev->enable_pullup && dev->bus_master->set_pullup)
+			dev->bus_master->set_pullup(dev->bus_master->data, 0);
+		else
+			msleep(dev->pullup_duration);
+		dev->pullup_duration = 0;
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
 
-	if (dev->bus_master->write_byte)
+	if (dev->bus_master->write_byte) {
+		w1_pre_write(dev);
 		dev->bus_master->write_byte(dev->bus_master->data, byte);
+	}
 	else
-		for (i = 0; i < 8; ++i)
+		for (i = 0; i < 8; ++i) {
+			if (i==7)
+				w1_pre_write(dev);
 			w1_touch_bit(dev, (byte >> i) & 0x1);
+		}
+	w1_post_write(dev);
 }
 EXPORT_SYMBOL_GPL(w1_write_8);
 
@@ -203,11 +243,14 @@ void w1_write_block(struct w1_master *dev, const u8 *buf, int len)
 {
 	int i;
 
-	if (dev->bus_master->write_block)
+	if (dev->bus_master->write_block) {
+		w1_pre_write(dev);
 		dev->bus_master->write_block(dev->bus_master->data, buf, len);
+	}
 	else
 		for (i = 0; i < len; ++i)
-			w1_write_8(dev, buf[i]);
+			w1_write_8(dev, buf[i]); // calls w1_pre_write
+	w1_post_write(dev);
 }
 EXPORT_SYMBOL_GPL(w1_write_block);
 
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
+ * @return	0=success, anything else=error
+ */
+void w1_next_pullup(struct w1_master *dev, int delay)
+{
+	dev->pullup_duration = delay;
+}
+EXPORT_SYMBOL_GPL(w1_next_pullup);
-- 
1.4.4.4

