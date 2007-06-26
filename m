Return-Path: <linux-kernel-owner+w=401wt.eu-S1759282AbXFZSWq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759282AbXFZSWq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2007 14:22:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757614AbXFZSWi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jun 2007 14:22:38 -0400
Received: from static-ip-62-75-166-246.inaddr.intergenia.de ([62.75.166.246]:60177
	"EHLO vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756075AbXFZSWg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2007 14:22:36 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH RFC #2] hwrng: Add type categories
Date: Tue, 26 Jun 2007 20:21:51 +0200
User-Agent: KMail/1.9.6
Cc: Matt Mackall <mpm@selenic.com>,
       Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
       "linux-kernel" <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200706262021.51410.mb@bu3sch.de>
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Don't use the word "quality", as people seem to think of
the entropy quality when hearing that word.
This uses the word "type", which is probably better for
understanding what the value really means.

This is just for building up a default policy on which device
to use by default after boot/insmod. It has only implicitely to do
with the entropy quality of the device.

No functional change since the last patch. Just renaming.

Signed-off-by: Michael Buesch <mb@bu3sch.de>

Index: bu3sch-wireless-dev/drivers/char/hw_random/core.c
===================================================================
--- bu3sch-wireless-dev.orig/drivers/char/hw_random/core.c	2007-03-05 18:42:03.000000000 +0100
+++ bu3sch-wireless-dev/drivers/char/hw_random/core.c	2007-06-26 20:10:49.000000000 +0200
@@ -78,6 +78,20 @@ static inline int hwrng_data_read(struct
 	return rng->data_read(rng, data);
 }
 
+static const char * hwrng_type_string(enum hwrng_type type)
+{
+	switch (type) {
+	case HWRNG_TYPE_DEDIC:
+		return "dedicated";
+	case HWRNG_TYPE_ONBOARD:
+		return "onboard";
+	case HWRNG_TYPE_BAD:
+		return "bad";
+	case HWRNG_TYPE_PSEUDO:
+		return "pseudo";
+	}
+	return "unknown";
+}
 
 static int rng_dev_open(struct inode *inode, struct file *filp)
 {
@@ -210,7 +224,7 @@ static ssize_t hwrng_attr_current_show(s
 	ret = snprintf(buf, PAGE_SIZE, "%s\n", name);
 	mutex_unlock(&rng_mutex);
 
-	return ret;
+	return min(ret, (ssize_t)PAGE_SIZE);
 }
 
 static ssize_t hwrng_attr_available_show(struct device *dev,
@@ -235,7 +249,36 @@ static ssize_t hwrng_attr_available_show
 	ret++;
 	mutex_unlock(&rng_mutex);
 
-	return ret;
+	return min(ret, (ssize_t)PAGE_SIZE);
+}
+
+static ssize_t hwrng_attr_types_show(struct device *dev,
+				     struct device_attribute *attr,
+				     char *buf)
+{
+	int err;
+	ssize_t ret = 0;
+	struct hwrng *rng;
+	const char *type;
+
+	err = mutex_lock_interruptible(&rng_mutex);
+	if (err)
+		return -ERESTARTSYS;
+	buf[0] = '\0';
+	list_for_each_entry(rng, &rng_list, list) {
+		strncat(buf, rng->name, PAGE_SIZE - ret - 1);
+		ret += strlen(rng->name);
+		strncat(buf, " type: \"", PAGE_SIZE - ret - 1);
+		ret += 8;
+		type = hwrng_type_string(rng->type);
+		strncat(buf, type, PAGE_SIZE - ret - 1);
+		ret += strlen(type);
+		strncat(buf, "\"\n", PAGE_SIZE - ret - 1);
+		ret += 2;
+	}
+	mutex_unlock(&rng_mutex);
+
+	return min(ret, (ssize_t)PAGE_SIZE);
 }
 
 static DEVICE_ATTR(rng_current, S_IRUGO | S_IWUSR,
@@ -244,10 +287,58 @@ static DEVICE_ATTR(rng_current, S_IRUGO 
 static DEVICE_ATTR(rng_available, S_IRUGO,
 		   hwrng_attr_available_show,
 		   NULL);
+static DEVICE_ATTR(rng_types, S_IRUGO,
+		   hwrng_attr_types_show,
+		   NULL);
+
+
+/* Returns the RNG with the highest type value
+ * Expects rng_mutex locked. */
+static struct hwrng * select_best_hwrng(void)
+{
+	struct hwrng *rng, *ret = NULL;
+
+	list_for_each_entry(rng, &rng_list, list) {
+		if (!ret || (rng->type > ret->type))
+			ret = rng;
+	}
+
+	return ret;
+}
+
+/* Initializes the RNG with the highest type value.
+ * Expects rng_mutex locked. */
+static int init_best_hwrng(void)
+{
+	struct hwrng *rng, *prev_rng = NULL;
+	int err;
 
+	rng = select_best_hwrng();
+	if (!rng)
+		return -ENODEV;
+	if (rng == current_rng)
+		return 0;
+	if (current_rng) {
+		/* Shutdown current RNG */
+		prev_rng = current_rng;
+		hwrng_cleanup(current_rng);
+		current_rng = NULL;
+	}
+	err = hwrng_init(rng);
+	if (err) {
+		/* Try to enable the old one again. */
+		if (prev_rng && (hwrng_init(prev_rng) == 0))
+			current_rng = prev_rng;
+		return err;
+	}
+	current_rng = rng;
+
+	return 0;
+}
 
 static void unregister_miscdev(void)
 {
+	device_remove_file(rng_miscdev.this_device, &dev_attr_rng_types);
 	device_remove_file(rng_miscdev.this_device, &dev_attr_rng_available);
 	device_remove_file(rng_miscdev.this_device, &dev_attr_rng_current);
 	misc_deregister(&rng_miscdev);
@@ -268,9 +359,16 @@ static int register_miscdev(void)
 				 &dev_attr_rng_available);
 	if (err)
 		goto err_remove_current;
+	err = device_create_file(rng_miscdev.this_device,
+				 &dev_attr_rng_types);
+	if (err)
+		goto err_remove_available;
+
 out:
 	return err;
 
+err_remove_available:
+	device_remove_file(rng_miscdev.this_device, &dev_attr_rng_available);
 err_remove_current:
 	device_remove_file(rng_miscdev.this_device, &dev_attr_rng_current);
 err_misc_dereg:
@@ -282,7 +380,7 @@ int hwrng_register(struct hwrng *rng)
 {
 	int must_register_misc;
 	int err = -EINVAL;
-	struct hwrng *old_rng, *tmp;
+	struct hwrng *tmp;
 
 	if (rng->name == NULL ||
 	    rng->data_read == NULL)
@@ -297,27 +395,26 @@ int hwrng_register(struct hwrng *rng)
 			goto out_unlock;
 	}
 
-	must_register_misc = (current_rng == NULL);
-	old_rng = current_rng;
-	if (!old_rng) {
-		err = hwrng_init(rng);
-		if (err)
-			goto out_unlock;
-		current_rng = rng;
-	}
+	must_register_misc = list_empty(&rng_list);
+	INIT_LIST_HEAD(&rng->list);
+	list_add(&rng->list, &rng_list);
+
+	init_best_hwrng();
+	/* We ignore the error code of init_best_hwrng(), as
+	 * it doesn't matter for hwrng_register(). */
 	err = 0;
 	if (must_register_misc) {
 		err = register_miscdev();
 		if (err) {
-			if (!old_rng) {
-				hwrng_cleanup(rng);
+			if (current_rng) {
+				hwrng_cleanup(current_rng);
 				current_rng = NULL;
 			}
+			list_del(&rng->list);
 			goto out_unlock;
 		}
 	}
-	INIT_LIST_HEAD(&rng->list);
-	list_add_tail(&rng->list, &rng_list);
+
 out_unlock:
 	mutex_unlock(&rng_mutex);
 out:
@@ -327,21 +424,15 @@ EXPORT_SYMBOL_GPL(hwrng_register);
 
 void hwrng_unregister(struct hwrng *rng)
 {
-	int err;
-
 	mutex_lock(&rng_mutex);
 
 	list_del(&rng->list);
 	if (current_rng == rng) {
 		hwrng_cleanup(rng);
-		if (list_empty(&rng_list)) {
-			current_rng = NULL;
-		} else {
-			current_rng = list_entry(rng_list.prev, struct hwrng, list);
-			err = hwrng_init(current_rng);
-			if (err)
-				current_rng = NULL;
-		}
+		current_rng = NULL;
+		/* Now try to init another hwrng, if any.
+		 * We're not interested if this fails or not. */
+		init_best_hwrng();
 	}
 	if (list_empty(&rng_list))
 		unregister_miscdev();
Index: bu3sch-wireless-dev/include/linux/hw_random.h
===================================================================
--- bu3sch-wireless-dev.orig/include/linux/hw_random.h	2007-03-05 18:42:17.000000000 +0100
+++ bu3sch-wireless-dev/include/linux/hw_random.h	2007-06-26 20:06:10.000000000 +0200
@@ -16,6 +16,29 @@
 #include <linux/types.h>
 #include <linux/list.h>
 
+
+/**
+ * enum hwrng_type - Type identifier for RNG hardware
+ * @HWRNG_TYPE_DEDIC:	Dedicated RNG extension board/device.
+ * 			Use for special (non-onboard) RNG boards
+ * 			that gather entropy from good sources.
+ * @HWRNG_TYPE_ONBOARD:	Onboard-RNG or In-CPU-RNG devices.
+ * @HWRNG_TYPE_BAD:	RNG devices with an unknown quality of the
+ * 			entropy or entropy sources that could
+ * 			be influenced from outside (like normal radio
+ * 			receivers)
+ * @HWRNG_TYPE_PSEUDO:	Pseudo RNG device. Use this for devices
+ * 			which are not RNG devices by definition, but
+ * 			could be used as such. For example various
+ * 			hardware sensors, like a motion sensor.
+ */
+enum hwrng_type {
+	HWRNG_TYPE_DEDIC	= 3,
+	HWRNG_TYPE_ONBOARD	= 2,
+	HWRNG_TYPE_BAD		= 1,
+	HWRNG_TYPE_PSEUDO	= 0,
+};
+
 /**
  * struct hwrng - Hardware Random Number Generator driver
  * @name:		Unique RNG name.
@@ -28,6 +51,7 @@
  *			Returns the number of lower random bytes in "data".
  *			Must not be NULL.
  * @priv:		Private data, for use by the RNG driver.
+ * @type:		The type identifier of the RNG device.
  */
 struct hwrng {
 	const char *name;
@@ -36,6 +60,7 @@ struct hwrng {
 	int (*data_present)(struct hwrng *rng);
 	int (*data_read)(struct hwrng *rng, u32 *data);
 	unsigned long priv;
+	enum hwrng_type type;
 
 	/* internal. */
 	struct list_head list;
Index: bu3sch-wireless-dev/drivers/char/hw_random/amd-rng.c
===================================================================
--- bu3sch-wireless-dev.orig/drivers/char/hw_random/amd-rng.c	2007-03-05 18:42:03.000000000 +0100
+++ bu3sch-wireless-dev/drivers/char/hw_random/amd-rng.c	2007-06-26 20:12:39.000000000 +0200
@@ -99,6 +99,7 @@ static struct hwrng amd_rng = {
 	.cleanup	= amd_rng_cleanup,
 	.data_present	= amd_rng_data_present,
 	.data_read	= amd_rng_data_read,
+	.type		= HWRNG_TYPE_ONBOARD,
 };
 
 
Index: bu3sch-wireless-dev/drivers/char/hw_random/geode-rng.c
===================================================================
--- bu3sch-wireless-dev.orig/drivers/char/hw_random/geode-rng.c	2007-03-05 18:42:03.000000000 +0100
+++ bu3sch-wireless-dev/drivers/char/hw_random/geode-rng.c	2007-06-26 20:12:58.000000000 +0200
@@ -73,6 +73,7 @@ static struct hwrng geode_rng = {
 	.name		= "geode",
 	.data_present	= geode_rng_data_present,
 	.data_read	= geode_rng_data_read,
+	.type		= HWRNG_TYPE_ONBOARD,
 };
 
 
Index: bu3sch-wireless-dev/drivers/char/hw_random/intel-rng.c
===================================================================
--- bu3sch-wireless-dev.orig/drivers/char/hw_random/intel-rng.c	2007-05-18 18:09:48.000000000 +0200
+++ bu3sch-wireless-dev/drivers/char/hw_random/intel-rng.c	2007-06-26 20:13:16.000000000 +0200
@@ -216,6 +216,7 @@ static struct hwrng intel_rng = {
 	.cleanup	= intel_rng_cleanup,
 	.data_present	= intel_rng_data_present,
 	.data_read	= intel_rng_data_read,
+	.type		= HWRNG_TYPE_ONBOARD,
 };
 
 struct intel_rng_hw {
Index: bu3sch-wireless-dev/drivers/char/hw_random/ixp4xx-rng.c
===================================================================
--- bu3sch-wireless-dev.orig/drivers/char/hw_random/ixp4xx-rng.c	2007-03-05 18:42:03.000000000 +0100
+++ bu3sch-wireless-dev/drivers/char/hw_random/ixp4xx-rng.c	2007-06-26 20:13:35.000000000 +0200
@@ -38,6 +38,7 @@ static int ixp4xx_rng_data_read(struct h
 static struct hwrng ixp4xx_rng_ops = {
 	.name		= "ixp4xx",
 	.data_read	= ixp4xx_rng_data_read,
+	.type		= HWRNG_TYPE_ONBOARD,
 };
 
 static int __init ixp4xx_rng_init(void)
Index: bu3sch-wireless-dev/drivers/char/hw_random/pasemi-rng.c
===================================================================
--- bu3sch-wireless-dev.orig/drivers/char/hw_random/pasemi-rng.c	2007-05-18 18:09:48.000000000 +0200
+++ bu3sch-wireless-dev/drivers/char/hw_random/pasemi-rng.c	2007-06-26 20:14:29.000000000 +0200
@@ -137,6 +137,7 @@ static struct of_platform_driver rng_dri
 	.match_table	= rng_match,
 	.probe		= rng_probe,
 	.remove		= rng_remove,
+	.type		= HWRNG_TYPE_ONBOARD,
 };
 
 static int __init rng_init(void)
Index: bu3sch-wireless-dev/drivers/char/hw_random/via-rng.c
===================================================================
--- bu3sch-wireless-dev.orig/drivers/char/hw_random/via-rng.c	2007-05-18 18:09:48.000000000 +0200
+++ bu3sch-wireless-dev/drivers/char/hw_random/via-rng.c	2007-06-26 20:14:47.000000000 +0200
@@ -150,6 +150,7 @@ static struct hwrng via_rng = {
 	.init		= via_rng_init,
 	.data_present	= via_rng_data_present,
 	.data_read	= via_rng_data_read,
+	.type		= HWRNG_TYPE_ONBOARD,
 };
 
 
Index: bu3sch-wireless-dev/drivers/net/wireless/bcm43xx/bcm43xx_main.c
===================================================================
--- bu3sch-wireless-dev.orig/drivers/net/wireless/bcm43xx/bcm43xx_main.c	2007-05-18 18:09:51.000000000 +0200
+++ bu3sch-wireless-dev/drivers/net/wireless/bcm43xx/bcm43xx_main.c	2007-06-26 20:12:16.000000000 +0200
@@ -3278,6 +3278,7 @@ static int bcm43xx_rng_init(struct bcm43
 	bcm->rng.name = bcm->rng_name;
 	bcm->rng.data_read = bcm43xx_rng_read;
 	bcm->rng.priv = (unsigned long)bcm;
+	bcm->rng.type = HWRNG_TYPE_BAD;
 	err = hwrng_register(&bcm->rng);
 	if (err)
 		printk(KERN_ERR PFX "RNG init failed (%d)\n", err);
Index: bu3sch-wireless-dev/drivers/net/wireless/mac80211/bcm43xx/bcm43xx_main.c
===================================================================
--- bu3sch-wireless-dev.orig/drivers/net/wireless/mac80211/bcm43xx/bcm43xx_main.c	2007-06-26 19:59:19.000000000 +0200
+++ bu3sch-wireless-dev/drivers/net/wireless/mac80211/bcm43xx/bcm43xx_main.c	2007-06-26 20:11:52.000000000 +0200
@@ -2399,6 +2399,7 @@ static int bcm43xx_rng_init(struct bcm43
 	wl->rng.name = wl->rng_name;
 	wl->rng.data_read = bcm43xx_rng_read;
 	wl->rng.priv = (unsigned long)wl;
+	wl->rng.type = HWRNG_TYPE_BAD;
 	wl->rng_initialized = 1;
 	err = hwrng_register(&wl->rng);
 	if (err) {
Index: bu3sch-wireless-dev/drivers/char/hw_random/omap-rng.c
===================================================================
--- bu3sch-wireless-dev.orig/drivers/char/hw_random/omap-rng.c	2007-03-05 18:42:03.000000000 +0100
+++ bu3sch-wireless-dev/drivers/char/hw_random/omap-rng.c	2007-06-26 20:14:05.000000000 +0200
@@ -81,6 +81,7 @@ static struct hwrng omap_rng_ops = {
 	.name		= "omap",
 	.data_present	= omap_rng_data_present,
 	.data_read	= omap_rng_data_read,
+	.type		= HWRNG_TYPE_ONBOARD,
 };
 
 static int __init omap_rng_probe(struct platform_device *pdev)

-- 
Greetings Michael.
